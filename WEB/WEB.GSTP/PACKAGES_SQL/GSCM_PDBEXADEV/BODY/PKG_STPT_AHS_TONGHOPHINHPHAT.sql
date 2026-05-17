--------------------------------------------------------
--  DDL for Package Body PKG_STPT_AHS_TONGHOPHINHPHAT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_AHS_TONGHOPHINHPHAT" AS

-- check trường hợp y án sơ thẩm
PROCEDURE AHS_Y_AN_SO_THAM
(
    VBICANID NUMBER,
    curReturn OUT sys_refcursor
)
AS
    COUNT_AHS NUMBER DEFAULT 0; -- KIỂM TRA XEM CÓ Y ÁN SƠ THẨM KO
    COUNT_AHS2 NUMBER DEFAULT 0; -- KIỂM TRA XEM CÓ HÌNH PHẠT KO
    COUNT_AHS_EXP NUMBER DEFAULT 0; -- KẾT QUẢ CỦA SO SÁNH
BEGIN

SELECT SUM(A) INTO COUNT_AHS
FROM (SELECT count(1) A
        FROM (SELECT  HINHPHATID,BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY,K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT 
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO
MINUS
              SELECT HINHPHATID, BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                      ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO)
      UNION ALL
      SELECT count(1)
        FROM (SELECT  HINHPHATID,BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO
MINUS
              SELECT HINHPHATID, BICANID, LOAIHINHPHAT, TF_VALUE, SH_VALUE, SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                      ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT 
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO));

    IF (COUNT_AHS = 0) THEN
        SELECT count(1) INTO COUNT_AHS2
        FROM AHS_PHUCTHAM_BANAN_DIEU_CT ct
        WHERE HINHPHATID IS NOT NULL AND HINHPHATID <> 0 AND LOAIHINHPHAT IS NOT NULL AND LOAIHINHPHAT <> 0 AND ISMAIN <> 1
              AND  exists (SELECT TENTOIDANH
                                 FROM DM_BOLUAT_TOIDANH BL 
                                 WHERE DIEM IS NULL 
                                 AND KHOAN IS NULL and ct.TENTOIDANH = BL.TENTOIDANH) 
              AND BICANID = VBICANID;
    END IF;

    IF(COUNT_AHS = 0 and COUNT_AHS2 = 0) then COUNT_AHS_EXP := 0; -- Y án ST
        elsif(COUNT_AHS > 0 and COUNT_AHS2 = 0) then COUNT_AHS_EXP := -2;
        else COUNT_AHS_EXP := -1; -- Chưa nhập HP ST
        end if;


    OPEN curReturn FOR 
        SELECT COUNT_AHS_EXP FROM DUAL;  
END AHS_Y_AN_SO_THAM;

PROCEDURE AHS_KQXXPT
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS 
    V_CURSOR sys_refcursor;
    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ

    -------------------------------------- SƠ THẨM ---------------------------------------------------   
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN  
    CHECK_TT_ST NUMBER DEFAULT 0;
    NAM   NUMBER DEFAULT 0;  THANG    NUMBER DEFAULT 0;   NGAY   NUMBER DEFAULT 0;   -- TÙ GIAM
    NAMT  NUMBER DEFAULT 0;  THANGT   NUMBER DEFAULT 0;   NGAYT  NUMBER DEFAULT 0;  -- TÙ TREO
    NAMTT NUMBER DEFAULT 0;  THANGTT  NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0; -- THỬ THÁCH
    TUGIAM_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    --------------------------------------------------------------------------------------------------

    -------------------------------------- PHÚC THẨM ---------------------------------------------------   
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN  
    CHECK_TT_PT NUMBER DEFAULT 0;
    NAM_PT   NUMBER DEFAULT 0;  THANG_PT    NUMBER DEFAULT 0;   NGAY_PT   NUMBER DEFAULT 0;   -- TÙ GIAM
    NAMT_PT  NUMBER DEFAULT 0;  THANGT_PT   NUMBER DEFAULT 0;   NGAYT_PT  NUMBER DEFAULT 0;  -- TÙ TREO
    NAMTT_PT NUMBER DEFAULT 0;  THANGTT_PT  NUMBER DEFAULT 0;   NGAYTT_PT NUMBER DEFAULT 0; -- THỬ THÁCH
    TUGIAM_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    --------------------------------------------------------------------------------------------------
    THOIHANST NUMBER DEFAULT 0;
    THOIHANPT NUMBER DEFAULT 0;
    CHECK_INTO NUMBER DEFAULT 0;

BEGIN   
        SELECT count(1)INTO CHECK_INTO
        FROM (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT);

        IF (CHECK_INTO > 0 ) THEN
        -------------------------------------- SƠ THẨM ---------------------------------------------------
        PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_SOTHAM_HINHPHAT_TH_CT_TG(VBICANID,V_CURSOR);
        LOOP 
        FETCH V_CURSOR 
            INTO   MAHINHPHAT_ST, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, 
                   NAMTT, THANGTT, NGAYTT, TUGIAM_ST, ANTREO_ST, THUTHACH_ST;
            EXIT WHEN V_CURSOR%NOTFOUND;
        END LOOP;    
        CLOSE V_CURSOR;
        --------------------------------------------------------------------------------------------------
        END IF;

        CHECK_INTO := 0;

        SELECT count(1)INTO CHECK_INTO
        FROM (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                            BICANID, LOAIHINHPHAT,
                            TF_VALUE, SH_VALUE,
                            SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                            K_VALUE1, K_VALUE2,
                            ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                    FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                            INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                        UNION ALL
                                        SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                        )DM_HP ON DM_HP.ID = CT.HINHPHATID
                    WHERE    LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                    GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                              LOAIHINHPHAT,
                              TF_VALUE, SH_VALUE,
                              K_VALUE1, K_VALUE2,
                              ISANTREO, DM_HP.TENHINHPHAT);
        IF (CHECK_INTO > 0 ) THEN
        -------------------------------------- PHÚC THẨM -------------------------------------------------  
        PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_PHUCTHAM_HINHPHAT_TH_CT_TG(VBICANID,V_CURSOR);
        LOOP 
        FETCH V_CURSOR 
            INTO   MAHINHPHAT_PT, NAM_PT, THANG_PT, NGAY_PT, NAMT_PT, THANGT_PT, NGAYT_PT, 
                   NAMTT_PT, THANGTT_PT, NGAYTT_PT, TUGIAM_PT, ANTREO_PT, THUTHACH_PT;
            EXIT WHEN V_CURSOR%NOTFOUND;
        END LOOP;    
        CLOSE V_CURSOR;
        --------------------------------------------------------------------------------------------------
        END IF;
        ---------------- SO SÁNH HÌNH PHẠT TÙ VÀ TỬ HÌNH, XÁC ĐỊNH ĐỘ ƯU TIÊN ----------------------------
            IF(MAHINHPHAT_PT = 'TUHINH') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  V_RESULT_EXPORT := 'Tử hình; ';                                  END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ tù chung thân lên tử hình; ';   END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ';
                        IF(TUGIAM_ST != 'DEFAULT VALUE')            THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_ST;  END IF;
                        IF(ANTREO_ST != 'DEFAULT VALUE')            THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_ST;  END IF;
                        IF(THUTHACH_ST != 'DEFAULT VALUE')          THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_ST;END IF;
                        V_RESULT_EXPORT := V_RESULT_EXPORT ||' lên tử hình; '; 
                        END IF;
                    IF(MAHINHPHAT_ST = 'DEFAULT VALUE')             THEN  V_RESULT_EXPORT := 'Tử hình; ' || V_RESULT_EXPORT;END IF;
                ELSIF(MAHINHPHAT_PT = 'TUCHUNGTHAN') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  V_RESULT_EXPORT := 'Giảm hình phạt từ tử hình xuống tù chung thân; '; END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  V_RESULT_EXPORT := 'Tù chung thân; ';                                  END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ ';
                        IF(TUGIAM_ST != 'DEFAULT VALUE')     THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_ST;     END IF;
                        IF(ANTREO_ST != 'DEFAULT VALUE')     THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_ST;     END IF;
                        IF(THUTHACH_ST != 'DEFAULT VALUE')   THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_ST;   END IF;
                        V_RESULT_EXPORT := V_RESULT_EXPORT ||' lên tù chung thân; ';
                        END IF;
                    IF(MAHINHPHAT_ST = 'DEFAULT VALUE')             THEN  V_RESULT_EXPORT := 'Tù chung thân; ' || V_RESULT_EXPORT;END IF;
                ELSIF(MAHINHPHAT_PT = 'TUCOTHOIHAN') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  
                        V_RESULT_EXPORT := 'Giảm hình phạt từ tử hình xuống ';
                        IF(TUGIAM_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_PT;               END IF;
                        IF(ANTREO_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_PT;               END IF;
                        IF(THUTHACH_PT != 'DEFAULT VALUE')          THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_PT;             END IF;                  
                        END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  
                        V_RESULT_EXPORT := 'Giảm hình phạt từ tù chung thân xuống ';
                        IF(TUGIAM_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_PT;               END IF;
                        IF(ANTREO_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_PT;               END IF;
                        IF(THUTHACH_PT != 'DEFAULT VALUE')          THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_PT;             END IF;                  
                        END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  
                            IF(TUGIAM_PT != 'DEFAULT VALUE' AND TUGIAM_ST != 'DEFAULT VALUE') THEN 
                                    THOIHANPT := NAM_PT * 365 + THANG_PT *30 + NGAY_PT;
                                    THOIHANST := NAM * 365 + THANG *30 + NGAY;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || TUGIAM_ST || ' lên ' || TUGIAM_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || TUGIAM_ST || ' xuống ' || TUGIAM_PT || '; ';
                                        END IF;
                                ELSIF(TUGIAM_PT != 'DEFAULT VALUE' AND TUGIAM_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || TUGIAM_PT || '; ';
                            END IF;          
                            IF(ANTREO_PT != 'DEFAULT VALUE' AND ANTREO_ST != 'DEFAULT VALUE') THEN
                                    THOIHANPT := NAMT_PT * 365 + THANGT_PT *30 + NGAYT_PT;
                                    THOIHANST := NAMT * 365 + THANGT *30 + NGAYT;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || ANTREO_ST || ' lên ' || ANTREO_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || ANTREO_ST || ' xuống ' || ANTREO_PT || '; ';
                                        END IF;
                                ELSIF(ANTREO_PT != 'DEFAULT VALUE' AND ANTREO_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || ANTREO_PT || '; ';
                            END IF;                         
                            IF(THUTHACH_PT != 'DEFAULT VALUE' AND THUTHACH_ST != 'DEFAULT VALUE') THEN
                                    THOIHANPT := NAMTT_PT * 365 + THANGTT_PT *30 + NGAYTT_PT;
                                    THOIHANST := NAMTT * 365 + THANGTT *30 + NGAYTT;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || THUTHACH_ST || ' lên ' || THUTHACH_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || THUTHACH_ST || ' xuống ' || THUTHACH_PT || '; ';
                                        END IF;
                                ELSIF(THUTHACH_PT != 'DEFAULT VALUE' AND THUTHACH_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || THUTHACH_PT || '; ';
                            END IF;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                        ELSE 
                            IF(TUGIAM_PT != 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || TUGIAM_PT || '; '; END IF;
                            IF(ANTREO_PT NOT LIKE 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || ANTREO_PT || '; '; END IF;
                            IF(THUTHACH_PT NOT LIKE 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || THUTHACH_PT || '; '; END IF;
                        END IF;
            END IF;
        V_RESULT_EXPORT := REPLACE(V_RESULT_EXPORT, 'DEFAULT VALUE', '');
    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT FROM DUAL;  
END AHS_KQXXPT;

PROCEDURE AHS_TONGHOPHINHPHAT_SOSANH
(
    VUANID IN NUMBER, 
    VBICAOID IN NUMBER,
    curReturn OUT SYS_REFCURSOR
)
AS  
    CHECK_TH_CT_TG INT DEFAULT 0; -- CHECK STATUS ĐỂ KHÔNG VÀO LẦN 2 AHS_PHUCTHAM_HINHPHAT_TH_CT_TG
    HP_TU VARCHAR(500) DEFAULT '';        

    HP_SOHOC VARCHAR(500) DEFAULT '';    -- HÌNH PHẠT SỐ HỌC (TIỀN, ...)
    HP_THOIGIAN VARCHAR(500) DEFAULT ''; -- HÌNH PHẠT CÓ THỜI GIAN
    HP_KHAC VARCHAR(1000) DEFAULT '';    -- CÁC HÌNH PHẠT CHÍNH KHÁC      
    HP_BOSUNG VARCHAR(200) DEFAULT '';  -- HÌNH PHẠT BỔ SUNG

    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';    -- MÃ HÌNH PHẠT DÙNG ĐỂ LOẠI BỎ HÌNH PHẠT TÙ THEO NĂM KHI ĐÃ CÓ TỬ HÌNH HOẶC CHUNG THÂN
    THOIGIANTU VARCHAR(200) DEFAULT ''; -- LƯU THỜI GIAN ĐỂ ĐIỀN SAU KHI LOAI BỎ
    CHECK_TT INT DEFAULT 0;

    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
    CHECK_Y_AN_SO_THAM NUMBER DEFAULT 0; -- NẾU Y ÁN SƠ THẨM THÌ KHÔNG CẦN LÀM CÁC BƯỚC TIẾP THEO
    CHECK_KETQUAPHUCTHAM NUMBER DEFAULT 0; -- TRUỜNG HỢP GIỮ HOẶC SỬA BẢN ÁN MỚI CHO NHẬP ĐIỀU LUẬT VÀ LẤY THÔNG TIN
    V_CURSOR SYS_REFCURSOR;

    --KHANGNGHI NUMBER DEFAULT 0; 
    RUTKHANGNGHI NUMBER DEFAULT 0;
    --TGTTKHANGCAO NUMBER DEFAULT 0; 
    TGTTRUTKHANGCAO NUMBER DEFAULT 0; TENRUTKHANGCAO VARCHAR(200) DEFAULT '';
    --BCKHANGCAO NUMBER DEFAULT 0; 
    BCRUTKHANGCAO NUMBER DEFAULT 0;

    RUTKHANGCAOKHANGNGHI VARCHAR(200) DEFAULT '';
    VVUANID NUMBER DEFAULT 0;
    V_QD_DINHCHI_VUAN NUMBER DEFAULT 0;
    V_QD_DINHCHI_BICAO NUMBER DEFAULT 0;
    V_QD_TAMDINHCHI_BICAO NUMBER DEFAULT 0;

BEGIN

    --LẤY VỤ ÁN ID
    --SELECT DISTINCT VUANID INTO VVUANID FROM AHS_BICANBICAO WHERE ID = VBICAOID;
    VVUANID := VUANID;
    SELECT CASE WHEN EXISTS ( SELECT 1
                               FROM AHS_PHUCTHAM_QUYETDINH_VUAN
                                   INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                               WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                               WHERE VUANID = VVUANID
                           ) THEN 1 
                           ELSE 0 
                       END INTO V_QD_DINHCHI_VUAN
    FROM DUAL;

    SELECT CASE WHEN EXISTS ( SELECT 1
                               FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                   INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                               WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                               WHERE BICANID = VBICAOID
                           ) THEN 1 
                           ELSE 0 
                       END INTO V_QD_DINHCHI_BICAO
    FROM DUAL;

    SELECT CASE WHEN EXISTS ( SELECT 1
                               FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                   INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                               WHERE TEN LIKE '%Quyết định tạm đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                               WHERE BICANID = VBICAOID
                           ) THEN 1 
                           ELSE 0 
                       END INTO V_QD_TAMDINHCHI_BICAO
    FROM DUAL;
--------------------------------------



    IF(V_QD_DINHCHI_VUAN > 0 OR V_QD_DINHCHI_BICAO >0 OR V_QD_TAMDINHCHI_BICAO >0) THEN 
            IF(V_QD_TAMDINHCHI_BICAO >0) THEN V_RESULT_EXPORT := 'QĐ tạm đình chỉ bị cáo; '; END IF;
            IF(V_QD_DINHCHI_BICAO >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ bị cáo; '; END IF;
            IF(V_QD_DINHCHI_VUAN >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ vụ án; '; END IF;
        ELSE
--                select count(1) into BCKHANGCAO from ahs_bicanbicao bc 
--                    inner join (select nguoikcid from ahs_sotham_khangcao) bckc on bckc.nguoikcid = bc.id
--                    where vuanid = VVUANID and bckc.nguoikcid = VBICAOID;

                select count(1) into BCRUTKHANGCAO from ahs_bicanbicao bc 
                    inner join (select id,nguoikcid from ahs_sotham_khangcao) bckc on bckc.nguoikcid = bc.id
                    inner join (select khangcaoid from ahs_sotham_rutkhangcao where tinhtrang = 2 and caprutkn = 3) bhrkc on bhrkc.khangcaoid = bckc.id
                    where vuanid = VVUANID and bckc.nguoikcid = VBICAOID;

--                select count(1) into TGTTKHANGCAO from ahs_nguoithamgiatotung tgtt 
--                    inner join (select nguoikcid from ahs_sotham_khangcao) bhkc on bhkc.nguoikcid = tgtt.id
--                    where vuanid = VVUANID;

                select count(1) into TGTTRUTKHANGCAO 
                from ahs_nguoithamgiatotung tgtt 
                    inner join ahs_sotham_khangcao bhkc on bhkc.nguoikcid = tgtt.id
                    inner join ahs_sotham_rutkhangcao bhrkc on bhrkc.khangcaoid = bhkc.id and bhrkc.tinhtrang = 2 and bhrkc.caprutkn = 3
                where tgtt.vuanid = VVUANID;

                if(TGTTRUTKHANGCAO > 0 ) then
                    select listagg(tgtt.hoten, ', ') within group (order by '') into TENRUTKHANGCAO 
                    from ahs_nguoithamgiatotung tgtt
                            inner join ahs_sotham_khangcao bhkc on bhkc.nguoikcid = tgtt.id 
                            inner join ahs_sotham_rutkhangcao bhrkc on bhrkc.khangcaoid = bhkc.id and bhrkc.tinhtrang = 2 and bhrkc.caprutkn = 3
                    where tgtt.vuanid = VVUANID;
                end if;
                
--                select count(1) into KHANGNGHI 
--                from ahs_sotham_khangnghi 
--                where vuanid = vvuanid;
                
                select count(1) into RUTKHANGNGHI 
                from ahs_sotham_khangnghi kn
                    inner join ahs_sotham_rutkhangnghi rkn on rkn.khangnghiid = kn.id and rkn.caprutkn = 3 and rkn.tinhtrang = 2
                where kn.vuanid = vvuanid;

                --Check trường hợp giữ nguyên hình phạt
                PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_Y_AN_SO_THAM(VBICAOID,V_CURSOR); LOOP FETCH V_CURSOR INTO CHECK_Y_AN_SO_THAM; EXIT WHEN V_CURSOR%NOTFOUND; END LOOP; CLOSE V_CURSOR;

                SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM
                FROM AHS_PHUCTHAM_BANAN BA
                    INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE '%Giữ nguyên %') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                WHERE BA.VUANID = VVUANID;

                IF(CHECK_KETQUAPHUCTHAM > 0 ) THEN 
                     IF(BCRUTKHANGCAO > 0 ) THEN
                            V_RESULT_EXPORT := 'Rút k/c;';
                        ELSE
                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Y án sơ thẩm; ';
                        END IF;
                    ELSE   
                        SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM
                        FROM AHS_PHUCTHAM_BANAN BA
                        INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Hủy%') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                        WHERE BA.VUANID = VVUANID;

                        IF(CHECK_KETQUAPHUCTHAM = 1 ) THEN 
                                SELECT TEN INTO V_RESULT_EXPORT
                                FROM AHS_PHUCTHAM_BANAN BA
                                INNER JOIN (SELECT TEN,ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Hủy%') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                                WHERE BA.VUANID = VVUANID;
                            ELSE
                                IF(BCRUTKHANGCAO > 0) THEN V_RESULT_EXPORT := 'Rút k/c;';
                                    ELSE
                                        IF(CHECK_Y_AN_SO_THAM = 0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'Y án sơ thẩm; ';
                                        ELSIF(CHECK_Y_AN_SO_THAM = -1) THEN V_RESULT_EXPORT := 'Chưa nhập hình phạt'; -- nếu chưa nhập hình phạt
                                        ELSE
                                            FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                                            BICANID, LOAIHINHPHAT,
                                                            TF_VALUE, SH_VALUE,
                                                            SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                                                            K_VALUE1, K_VALUE2,
                                                            ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                                                    FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                                                            INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                                                        UNION ALL
                                                                        SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                                                        )DM_HP ON DM_HP.ID = CT.HINHPHATID
                                                    WHERE    LOAIHINHPHAT > 0 AND CT.BICANID = VBICAOID
                                                    GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                                              LOAIHINHPHAT,
                                                              TF_VALUE, SH_VALUE,
                                                              K_VALUE1, K_VALUE2,
                                                              ISANTREO, DM_HP.TENHINHPHAT)
                                            LOOP
                                                --HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC
                                                IF(ITEM.NHOMHINHPHAT = 144 OR ITEM.NHOMHINHPHAT = 146) THEN
                                                        IF(ITEM.HINHPHATID = 8 OR ITEM.HINHPHATID = 6 OR ITEM.HINHPHATID = 5 OR ITEM.HINHPHATID = 2 OR ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN
                                                            ---------------------- PHÚC THẨM (TỬ HÌNH, TÙ GIAM, ÁN TRAO, THỬ THÁCH) ---------------------------
                                                            IF(CHECK_TH_CT_TG = 0) THEN
                                                               IF (ITEM.HINHPHATID = 6 OR ITEM.HINHPHATID = 8 OR ITEM.HINHPHATID = 5) THEN          
                                                                    PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_KQXXPT(VBICAOID,V_CURSOR);
                                                                    LOOP 
                                                                    FETCH V_CURSOR 
                                                                        INTO  HP_TU;
                                                                        EXIT WHEN V_CURSOR%NOTFOUND;
                                                                    END LOOP;    
                                                                    CLOSE V_CURSOR;
                                                                    CHECK_TH_CT_TG := 1; -- ĐỔI STATUS ĐỂ KHÔNG VÀO LẦN 2
                                                                END IF;
                                                            END IF;
                                                            ---------------CẢI TẠO KHÔNG GIAM GIỮ VÀ ĐÌNH CHỈ HOẠT ĐỘNG CÓ THỜI HẠN-------------------------
                                                            IF (ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN                        
                                                                PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_SOSANH_HINHPHAT_THOIGIAN(ITEM.HINHPHATID,VBICAOID,V_CURSOR);
                                                                LOOP 
                                                                FETCH V_CURSOR 
                                                                    INTO  HP_THOIGIAN;
                                                                    EXIT WHEN V_CURSOR%NOTFOUND;
                                                                END LOOP;    
                                                                CLOSE V_CURSOR;
                                                            END IF;
                                                            ----------------PHẠT TIỀN-----------------------------------------------------------------------
                                                            IF (ITEM.HINHPHATID = 2) THEN
                                                                PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_SOSANH_HINHPHAT_SOHOC(ITEM.HINHPHATID,VBICAOID,V_CURSOR);
                                                                LOOP 
                                                                FETCH V_CURSOR 
                                                                    INTO  HP_SOHOC;
                                                                    EXIT WHEN V_CURSOR%NOTFOUND;
                                                                END LOOP;    
                                                                CLOSE V_CURSOR;
                                                            END IF;
                                                        -------HÌNH PHẠT KHÁC--------------------------------
                                                            ELSE 
                                                                HP_KHAC := HP_KHAC || ITEM.TENHINHPHAT || '; ';
                                                        END IF;
                                                    ----------------HÌNH PHẠT BỔ SUNG KHÁC----------------------------
                                                    IF(ITEM.NHOMHINHPHAT = 145) THEN
                                                        IF (ITEM.K_VALUE1 != 0) THEN
                                                                HP_BOSUNG := HP_BOSUNG || TO_CHAR(ITEM.K_VALUE1 || '; ');
                                                            END IF;
                                                        IF (ITEM.K_VALUE2 IS NOT NULL ) THEN
                                                                HP_BOSUNG := HP_BOSUNG || ITEM.K_VALUE2 || '; ';
                                                            END IF;
                                                        END IF;
                                                END IF;
                                            END LOOP;

                                            IF (HP_TU IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_TU;    END IF;
                                            IF (HP_THOIGIAN IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_THOIGIAN;    END IF;
                                            IF (HP_SOHOC IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_SOHOC;    END IF;
                                            IF (HP_KHAC IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_KHAC;    END IF;
                                            IF (HP_BOSUNG IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_BOSUNG;    END IF;
                                        END IF;
                                    END IF;
                            END IF;
                    END IF;
        END IF;
        OPEN curReturn FOR 
            SELECT V_RESULT_EXPORT FROM DUAL;
END AHS_TONGHOPHINHPHAT_SOSANH;

PROCEDURE AHS_TONGHOPHINHPHAT_ST
(
    VVUANID in number,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS
    HP_CHINH VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC 
    HP_BOSUNG VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT BỔ SUNG
    MAHINHPHAT VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- MÃ HÌNH PHẠT DÙNG ĐỂ LOẠI BỎ HÌNH PHẠT TÙ THEO NĂM KHI ĐÃ CÓ TỬ HÌNH HOẶC CHUNG THÂN
    THOIGIANTU VARCHAR(200) DEFAULT ''; -- LƯU THỜI GIAN ĐỂ ĐIỀN SAU KHI LOAI BỎ
    V_RESULT_EXPORT VARCHAR(500) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
    CHECK_TT INT DEFAULT 0; 
    V_QD_DINHCHI_VUAN number DEFAULT 0;
    V_QD_DINHCHI_BC number DEFAULT 0;
    V_QD_TAMDINHCHI_BICAO NUMBER DEFAULT 0;
BEGIN

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_SOTHAM_QUYETDINH_VUAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE VUANID = VVUANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_DINHCHI_VUAN
        FROM DUAL;

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_SOTHAM_QUYETDINH_BICAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE BICANID = VBICANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_DINHCHI_BC
        FROM DUAL;

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_SOTHAM_QUYETDINH_BICAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định tạm đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE BICANID = VBICANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_TAMDINHCHI_BICAO
        FROM DUAL;


        IF(V_QD_DINHCHI_VUAN > 0 OR V_QD_DINHCHI_BC >0 OR V_QD_TAMDINHCHI_BICAO >0) THEN 
                IF(V_QD_TAMDINHCHI_BICAO >0) THEN V_RESULT_EXPORT := 'QĐ tạm đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_BC >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_VUAN >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ vụ án; '; END IF;
            ELSE 
                    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                        BICANID, LOAIHINHPHAT,
                                        TF_VALUE, SH_VALUE,
                                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                                        K_VALUE1, K_VALUE2,
                                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                                    UNION ALL
                                                    SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                                WHERE  LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                          LOAIHINHPHAT,
                                          TF_VALUE, SH_VALUE,
                                          K_VALUE1, K_VALUE2,
                                          ISANTREO, DM_HP.TENHINHPHAT)
                    LOOP
                        IF(ITEM.NAM > 30) THEN ITEM.NAM := 30; ITEM.THANG := 0; ITEM.NGAY := 0; END IF;
                        IF(ITEM.NAMT > 30) THEN ITEM.NAMT := 30; ITEM.THANGT := 0; ITEM.NGAYT := 0; END IF;

                        --HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC
                        IF(ITEM.NHOMHINHPHAT = 144 OR ITEM.NHOMHINHPHAT = 146) THEN
                                -- TỬ HÌNH
                                IF(ITEM.HINHPHATID = 8) THEN
                                        MAHINHPHAT := 'TUHINH';
                                    -- CHUNG THÂN
                                    ELSIF (ITEM.HINHPHATID = 6 AND MAHINHPHAT != 'TUHINH') THEN    
                                        MAHINHPHAT := 'TUCHUNGTHAN';
                                    -- TÙ CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 5) THEN
                                        IF (MAHINHPHAT != 'TUHINH' AND MAHINHPHAT != 'TUCHUNGTHAN') THEN
                                            IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NAM || ' năm ';
                                                END IF;
                                            IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.THANG || ' tháng ';
                                                END IF;
                                            IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NGAY || ' ngày ';
                                                END IF;
                                            IF (ITEM.ISANTREO = 0) THEN
                                                    THOIGIANTU := THOIGIANTU || ' tù giam; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                ELSIF (ITEM.ISANTREO = 1) THEN
                                                    THOIGIANTU := THOIGIANTU || ' án treo; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                END IF;
                                             -- THỬ THÁCH
                                            IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NAMT || ' năm ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.THANGT || ' tháng ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.NGAYT != 0 AND ITEM.NGAYT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NGAYT || ' ngày';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF(CHECK_TT = 1) THEN
                                                HP_CHINH := 'Thử thách: '|| HP_CHINH || '; ';
                                                END IF;
                                            END IF;

                                    -- PHẠT TIỀN
                                    ELSIF (ITEM.HINHPHATID = 2) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ' || ITEM.SH_VALUE ||' VND; ';

                                    -- CẢI TẠO KHÔNG GIAM GIỮ VÀ ĐÌNH CHỈ HOẠT ĐỘNG CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ';
                                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NAM || ' năm ';
                                            END IF;
                                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.THANG || ' tháng ';
                                            END IF;
                                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NGAY || ' ngày ';
                                            END IF;
                                        HP_CHINH := HP_CHINH || '; ';

                                    -- CÁC HÌNH PHẠT KHÁC
                                    ELSE 
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || '; ';
                                    END IF;
                            END IF;
                        -- HÌNH PHẠT BỔ SUNG (CÁC HÌNH PHẠT BỔ SUNG KHÁC)
                        IF(ITEM.NHOMHINHPHAT = 145) THEN
                            IF (ITEM.K_VALUE1 != 0) THEN
                                    HP_BOSUNG := HP_BOSUNG || TO_CHAR(ITEM.K_VALUE1 || '; ');
                                END IF;
                            IF (ITEM.K_VALUE2 IS NOT NULL ) THEN
                                    HP_BOSUNG := HP_BOSUNG || ITEM.K_VALUE2 || '; ';
                                END IF;
                            END IF;
                    END LOOP;

                    -- SO SÁNH HÌNH PHẠT TÙ VÀ TỬ HÌNH, XÁC ĐỊNH ĐỘ ƯU TIÊN
                    IF (MAHINHPHAT = 'TUHINH') THEN
                            V_RESULT_EXPORT := 'Từ hình; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCHUNGTHAN') THEN
                            V_RESULT_EXPORT := 'Tù chung thân; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCOTHOIHAN') THEN
                            V_RESULT_EXPORT := THOIGIANTU || V_RESULT_EXPORT;
                        END IF;

                    IF (HP_CHINH IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_CHINH;
                        END IF;
                    IF (HP_BOSUNG IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_BOSUNG;
                        END IF;
        END IF;
    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT FROM DUAL;  
END AHS_TONGHOPHINHPHAT_ST;


PROCEDURE AHS_TONGHOPHINHPHAT_PT
(
    VVUANID in number,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS
    HP_CHINH VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC 
    HP_BOSUNG VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT BỔ SUNG
    MAHINHPHAT VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- MÃ HÌNH PHẠT DÙNG ĐỂ LOẠI BỎ HÌNH PHẠT TÙ THEO NĂM KHI ĐÃ CÓ TỬ HÌNH HOẶC CHUNG THÂN
    THOIGIANTU VARCHAR(200) DEFAULT ''; -- LƯU THỜI GIAN ĐỂ ĐIỀN SAU KHI LOAI BỎ
    V_RESULT_EXPORT VARCHAR(500) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
    CHECK_TT INT DEFAULT 0; 
    V_QD_DINHCHI_VUAN number DEFAULT 0;
    V_QD_DINHCHI_BC number DEFAULT 0;
    V_QD_TAMDINHCHI_BICAO NUMBER DEFAULT 0;
BEGIN

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_PHUCTHAM_QUYETDINH_VUAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE VUANID = VVUANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_DINHCHI_VUAN
        FROM DUAL;

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE BICANID = VBICANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_DINHCHI_BC
        FROM DUAL;

        SELECT CASE WHEN EXISTS ( SELECT 1
                                   FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                       INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                                                   WHERE TEN LIKE '%Quyết định tạm đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
                                   WHERE BICANID = VBICANID
                               ) THEN 1 
                               ELSE 0 
                           END INTO V_QD_TAMDINHCHI_BICAO
        FROM DUAL;


        IF(V_QD_DINHCHI_VUAN > 0 OR V_QD_DINHCHI_BC >0 OR V_QD_TAMDINHCHI_BICAO >0) THEN 
                IF(V_QD_TAMDINHCHI_BICAO >0) THEN V_RESULT_EXPORT := 'QĐ tạm đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_BC >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_VUAN >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ vụ án; '; END IF;
            ELSE 
                    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                        BICANID, LOAIHINHPHAT,
                                        TF_VALUE, SH_VALUE,
                                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                                        K_VALUE1, K_VALUE2,
                                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                                FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
                                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                                    UNION ALL
                                                    SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                                WHERE  LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                          LOAIHINHPHAT,
                                          TF_VALUE, SH_VALUE,
                                          K_VALUE1, K_VALUE2,
                                          ISANTREO, DM_HP.TENHINHPHAT)
                    LOOP
                        IF(ITEM.NAM > 30) THEN ITEM.NAM := 30; ITEM.THANG := 0; ITEM.NGAY := 0; END IF;
                        IF(ITEM.NAMT > 30) THEN ITEM.NAMT := 30; ITEM.THANGT := 0; ITEM.NGAYT := 0; END IF;

                        --HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC
                        IF(ITEM.NHOMHINHPHAT = 144 OR ITEM.NHOMHINHPHAT = 146) THEN
                                -- TỬ HÌNH
                                IF(ITEM.HINHPHATID = 8) THEN
                                        MAHINHPHAT := 'TUHINH';
                                    -- CHUNG THÂN
                                    ELSIF (ITEM.HINHPHATID = 6 AND MAHINHPHAT != 'TUHINH') THEN    
                                        MAHINHPHAT := 'TUCHUNGTHAN';
                                    -- TÙ CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 5) THEN
                                        IF (MAHINHPHAT != 'TUHINH' AND MAHINHPHAT != 'TUCHUNGTHAN') THEN
                                            IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NAM || ' năm ';
                                                END IF;
                                            IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.THANG || ' tháng ';
                                                END IF;
                                            IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NGAY || ' ngày ';
                                                END IF;
                                            IF (ITEM.ISANTREO = 0) THEN
                                                    THOIGIANTU := THOIGIANTU || ' tù giam; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                ELSIF (ITEM.ISANTREO = 1) THEN
                                                    THOIGIANTU := THOIGIANTU || ' án treo; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                END IF;
                                             -- THỬ THÁCH
                                            IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NAMT || ' năm ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.THANGT || ' tháng ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.NGAYT != 0 AND ITEM.NGAYT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NGAYT || ' ngày';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF(CHECK_TT = 1) THEN
                                                HP_CHINH := 'Thử thách: '|| HP_CHINH || '; ';
                                                END IF;
                                            END IF;

                                    -- PHẠT TIỀN
                                    ELSIF (ITEM.HINHPHATID = 2) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ' || ITEM.SH_VALUE ||' VND; ';

                                    -- CẢI TẠO KHÔNG GIAM GIỮ VÀ ĐÌNH CHỈ HOẠT ĐỘNG CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ';
                                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NAM || ' năm ';
                                            END IF;
                                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.THANG || ' tháng ';
                                            END IF;
                                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NGAY || ' ngày ';
                                            END IF;
                                        HP_CHINH := HP_CHINH || '; ';

                                    -- CÁC HÌNH PHẠT KHÁC
                                    ELSE 
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || '; ';
                                    END IF;
                            END IF;
                        -- HÌNH PHẠT BỔ SUNG (CÁC HÌNH PHẠT BỔ SUNG KHÁC)
                        IF(ITEM.NHOMHINHPHAT = 145) THEN
                            IF (ITEM.K_VALUE1 != 0) THEN
                                    HP_BOSUNG := HP_BOSUNG || TO_CHAR(ITEM.K_VALUE1 || '; ');
                                END IF;
                            IF (ITEM.K_VALUE2 IS NOT NULL ) THEN
                                    HP_BOSUNG := HP_BOSUNG || ITEM.K_VALUE2 || '; ';
                                END IF;
                            END IF;
                    END LOOP;

                    -- SO SÁNH HÌNH PHẠT TÙ VÀ TỬ HÌNH, XÁC ĐỊNH ĐỘ ƯU TIÊN
                    IF (MAHINHPHAT = 'TUHINH') THEN
                            V_RESULT_EXPORT := 'Từ hình; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCHUNGTHAN') THEN
                            V_RESULT_EXPORT := 'Tù chung thân; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCOTHOIHAN') THEN
                            V_RESULT_EXPORT := THOIGIANTU || V_RESULT_EXPORT;
                        END IF;

                    IF (HP_CHINH IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_CHINH;
                        END IF;
                    IF (HP_BOSUNG IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_BOSUNG;
                        END IF;
        END IF;
    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT FROM DUAL;  
END AHS_TONGHOPHINHPHAT_PT;



PROCEDURE AHS_PHUCTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS        
    MAHINHPHAT_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';      -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN
    NAM NUMBER DEFAULT 0;    THANG NUMBER DEFAULT 0;     NGAY NUMBER DEFAULT 0; 
    NAMT NUMBER DEFAULT 0;   THANGT NUMBER DEFAULT 0;    NGAYT NUMBER DEFAULT 0; 
    NAMTT NUMBER DEFAULT 0;  THANGTT NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0;

    TUGIAM_PT VARCHAR(500) DEFAULT '';
    ANTREO_PT VARCHAR(500) DEFAULT '';
    THUTHACH_PT VARCHAR(500) DEFAULT '';

    CHECK_TUS_TG NUMBER DEFAULT 0;
    CHECK_TUS_AT NUMBER DEFAULT 0;
    CHECK_TUS_TT NUMBER DEFAULT 0;
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(ITEM.HINHPHATID = 8) THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 6 AND MAHINHPHAT_PT NOT LIKE 'TUHINH') THEN
                    MAHINHPHAT_PT := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 5) THEN 
                IF(MAHINHPHAT_PT NOT LIKE 'TUHINH' AND MAHINHPHAT_PT NOT LIKE 'TUCHUNGTHAN') THEN
                    MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                    IF(ITEM.ISANTREO = 1) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAMT := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANGT := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAYT := ITEM.NGAY;
                        END IF;

                        IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                NAMTT := ITEM.NAMT;
                        END IF;
                        IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                THANGTT := ITEM.THANGT;
                        END IF;
                        IF (ITEM.NGAYT != 0) THEN
                            IF(ITEM.NGAYT IS NOT NULL) THEN 
                                NGAYTT := ITEM.NGAYT;
                            END IF;
                        END IF;
                    END IF;                   
                    IF(ITEM.ISANTREO = 0) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAM := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANG := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAY := ITEM.NGAY;
                        END IF;
                    END IF;                    
                END IF;
        END IF;
    END LOOP;

    IF(NAM > 30) THEN NAM := 30; THANG := 0; NGAY := 0; END IF;
    IF(NAMT > 30) THEN NAMT := 30; THANGT := 0; NGAYT := 0; END IF;
    IF(NAMTT > 30) THEN NAMTT := 30; THANGTT := 0; NGAYTT := 0; END IF;

    IF(MAHINHPHAT_PT = 'TUCOTHOIHAN') THEN
    ------------------------------------- GÁN GIÁ TRỊ --------------------------------------------------------
        IF (NAM > 0)       THEN TUGIAM_PT := TUGIAM_PT || NAM || ' năm ';    CHECK_TUS_TG := 1;        END IF;
        IF (THANG > 0)     THEN TUGIAM_PT := TUGIAM_PT || THANG || ' tháng ';CHECK_TUS_TG := 1;        END IF;
        IF (NGAY > 0)      THEN TUGIAM_PT := TUGIAM_PT || NGAY || ' ngày';CHECK_TUS_TG := 1;           END IF;

        IF (NAMT > 0)      THEN ANTREO_PT := ANTREO_PT || NAMT || ' năm ';CHECK_TUS_AT := 1;           END IF;
        IF (THANGT > 0)    THEN ANTREO_PT := ANTREO_PT || THANGT || ' tháng ';CHECK_TUS_AT := 1;       END IF;
        IF (NGAYT > 0)     THEN ANTREO_PT := ANTREO_PT || NGAYT || ' ngày';CHECK_TUS_AT := 1;          END IF;

        IF (NAMTT > 0)     THEN THUTHACH_PT := THUTHACH_PT || NAMTT || ' năm ';CHECK_TUS_TT := 1;      END IF;
        IF (THANGTT > 0)   THEN THUTHACH_PT := THUTHACH_PT || THANGTT || ' tháng ';CHECK_TUS_TT := 1;  END IF;
        IF (NGAYTT > 0)    THEN THUTHACH_PT := THUTHACH_PT || NGAYTT || ' ngày';CHECK_TUS_TT := 1;     END IF;

        IF (CHECK_TUS_TG = 1)   THEN TUGIAM_PT := TUGIAM_PT || ' tù giam';           END IF;        
        IF (CHECK_TUS_AT = 1)   THEN ANTREO_PT := ANTREO_PT || ' án treo';           END IF;    
        IF (CHECK_TUS_TT = 1)   THEN THUTHACH_PT := THUTHACH_PT || 'thử thách';    END IF;
    -----------------------------------------------------------------------------------------------------------
    END IF;
    OPEN curReturn FOR 
        SELECT MAHINHPHAT_PT, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, NAMTT, THANGTT, NGAYTT, TUGIAM_PT, ANTREO_PT, THUTHACH_PT
        FROM DUAL;   
END AHS_PHUCTHAM_HINHPHAT_TH_CT_TG;
PROCEDURE AHS_SOTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS    
    MAHINHPHAT_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';      -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN
    NAM NUMBER DEFAULT 0;    THANG NUMBER DEFAULT 0;     NGAY NUMBER DEFAULT 0; 
    NAMT NUMBER DEFAULT 0;   THANGT NUMBER DEFAULT 0;    NGAYT NUMBER DEFAULT 0; 
    NAMTT NUMBER DEFAULT 0;  THANGTT NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0;

    TUGIAM_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';

    CHECK_TUS_TG NUMBER DEFAULT 0;
    CHECK_TUS_AT NUMBER DEFAULT 0;
    CHECK_TUS_TT NUMBER DEFAULT 0;
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(ITEM.HINHPHATID = 8) THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 6 AND MAHINHPHAT_ST NOT LIKE 'TUHINH') THEN
                    MAHINHPHAT_ST := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 5) THEN 
                IF(MAHINHPHAT_ST NOT LIKE 'TUHINH' AND MAHINHPHAT_ST NOT LIKE 'TUCHUNGTHAN') THEN
                    MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                    IF(ITEM.ISANTREO = 1) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAMT := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANGT := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAYT := ITEM.NGAY;
                        END IF;

                        IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                NAMTT := ITEM.NAMT;
                        END IF;
                        IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                THANGTT := ITEM.THANGT;
                        END IF;
                        IF (ITEM.NGAYT != 0) THEN
                            IF(ITEM.NGAYT IS NOT NULL) THEN 
                                NGAYTT := ITEM.NGAYT;
                            END IF;
                        END IF;
                    END IF;                   
                    IF(ITEM.ISANTREO = 0) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAM := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANG := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAY := ITEM.NGAY;
                        END IF;
                    END IF;                    
                END IF;
        END IF;
    END LOOP;

    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN') THEN
    ------------------------------------- GÁN GIÁ TRỊ --------------------------------------------------------
        IF (NAM > 0)       THEN TUGIAM_ST := TUGIAM_ST || NAM || ' năm ';    CHECK_TUS_TG := 1;        END IF;
        IF (THANG > 0)     THEN TUGIAM_ST := TUGIAM_ST || THANG || ' tháng ';CHECK_TUS_TG := 1;        END IF;
        IF (NGAY > 0)      THEN TUGIAM_ST := TUGIAM_ST || NGAY || ' ngày';CHECK_TUS_TG := 1;           END IF;

        IF (NAMT > 0)      THEN ANTREO_ST := ANTREO_ST || NAMT || ' năm ';CHECK_TUS_AT := 1;           END IF;
        IF (THANGT > 0)    THEN ANTREO_ST := ANTREO_ST || THANGT || ' tháng ';CHECK_TUS_AT := 1;       END IF;
        IF (NGAYT > 0)     THEN ANTREO_ST := ANTREO_ST || NGAYT || ' ngày';CHECK_TUS_AT := 1;          END IF;

        IF (NAMTT > 0)     THEN THUTHACH_ST := THUTHACH_ST || NAMTT || ' năm ';CHECK_TUS_TT := 1;      END IF;
        IF (THANGTT > 0)   THEN THUTHACH_ST := THUTHACH_ST || THANGTT || ' tháng ';CHECK_TUS_TT := 1;  END IF;
        IF (NGAYTT > 0)    THEN THUTHACH_ST := THUTHACH_ST || NGAYTT || ' ngày';CHECK_TUS_TT := 1;     END IF;

        IF (CHECK_TUS_TG = 1)   THEN TUGIAM_ST := TUGIAM_ST || ' tù giam';           END IF;        
        IF (CHECK_TUS_AT = 1)   THEN ANTREO_ST := ANTREO_ST || ' án treo';           END IF;    
        IF (CHECK_TUS_TT = 1) THEN THUTHACH_ST := THUTHACH_ST || ' thử thách';      END IF;
    -----------------------------------------------------------------------------------------------------------
    END IF;

    OPEN curReturn FOR 
        SELECT MAHINHPHAT_ST, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, NAMTT, THANGTT, NGAYTT, TUGIAM_ST, ANTREO_ST, THUTHACH_ST
        FROM DUAL;   
END AHS_SOTHAM_HINHPHAT_TH_CT_TG;

PROCEDURE AHS_SOSANH_HINHPHAT_SOHOC
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS  
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    SOHOC_ST NUMBER DEFAULT 0;
    SOHOC_PT NUMBER DEFAULT 0;
    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE   NHOMHINHPHAT = 144
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 2)THEN
            IF(ITEM.MAHINHPHAT = 'PHATTIEN') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                SOHOC_ST := ITEM.SH_VALUE;
            END IF; 
        END IF;
    END LOOP;    
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144
                                    )DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 2)THEN
            IF(ITEM.MAHINHPHAT = 'PHATTIEN') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                SOHOC_PT := ITEM.SH_VALUE;
            END IF; 
        END IF;
    END LOOP;

    IF(VHINHPHATID = 2)THEN
        IF(MAHINHPHAT_ST = 'PHATTIEN' AND MAHINHPHAT_PT = 'PHATTIEN') THEN
            IF(SOHOC_ST > SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt từ ' || SOHOC_ST || ' vnđ xuống ' || SOHOC_PT || ' VND; ';
                ELSIF(SOHOC_ST < SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt từ ' || SOHOC_ST || ' vnđ lên ' || SOHOC_PT || ' VND; ';
                ELSIF(SOHOC_ST = 0 AND SOHOC_PT > 0) THEN
                    V_RESULT_EXPORT := 'Phạt tiền: ' || SOHOC_PT || ' vnđ; ';
                ELSIF(SOHOC_ST > 0 AND SOHOC_PT = 0) THEN
                    V_RESULT_EXPORT := '';
                ELSIF(SOHOC_ST = SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Phạt tiền: ' || SOHOC_PT || ' vnđ; ';
            END IF;
        END IF;
    END IF;

    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT
        FROM DUAL;   
END AHS_SOSANH_HINHPHAT_SOHOC;
PROCEDURE AHS_SOSANH_HINHPHAT_THOIGIAN
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS    
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';

    NAM_ST NUMBER DEFAULT 0;    THANG_ST NUMBER DEFAULT 0;     NGAY_ST NUMBER DEFAULT 0; 
    NAM_PT NUMBER DEFAULT 0;    THANG_PT NUMBER DEFAULT 0;     NGAY_PT NUMBER DEFAULT 0;

    THOIGIAN_ST VARCHAR(500) DEFAULT '';
    THOIGIAN_PT VARCHAR(500) DEFAULT '';

    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE   NHOMHINHPHAT = 144
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 3)THEN
            IF(ITEM.MAHINHPHAT = 'CAITAOKGG') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                NAM_ST := ITEM.NAM;
                THANG_ST := ITEM.THANG;
                NGAY_ST := ITEM.NGAY;
            END IF; 
        END IF;
        IF(VHINHPHATID = 65)THEN
            IF(ITEM.MAHINHPHAT = 'DCHDCTH') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                NAM_ST := ITEM.NAM;
                THANG_ST := ITEM.THANG;
                NGAY_ST := ITEM.NGAY;
            END IF; 
        END IF;
    END LOOP;    
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144
                                    )DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 3)THEN
            IF(ITEM.MAHINHPHAT = 'CAITAOKGG') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                NAM_PT := ITEM.NAM;
                THANG_PT := ITEM.THANG;
                NGAY_PT := ITEM.NGAY;
            END IF; 
        END IF;
        IF(VHINHPHATID = 65)THEN
            IF(ITEM.MAHINHPHAT = 'DCHDCTH') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                NAM_PT := ITEM.NAM;
                THANG_PT := ITEM.THANG;
                NGAY_PT := ITEM.NGAY;
            END IF; 
        END IF;
    END LOOP;

    IF (NAM_ST > 0)       THEN THOIGIAN_ST := THOIGIAN_ST || NAM_ST || ' năm ';            END IF;
    IF (THANG_ST > 0)     THEN THOIGIAN_ST := THOIGIAN_ST || THANG_ST || ' tháng ';        END IF;
    IF (NGAY_ST > 0)      THEN THOIGIAN_ST := THOIGIAN_ST || NGAY_ST || ' ngày';          END IF;

    IF (NAM_PT > 0)       THEN THOIGIAN_PT := THOIGIAN_PT || NAM_PT || ' năm ';            END IF;
    IF (THANG_PT > 0)     THEN THOIGIAN_PT := THOIGIAN_PT || THANG_PT || ' tháng ';        END IF;
    IF (NGAY_PT > 0)      THEN THOIGIAN_PT := THOIGIAN_PT || NGAY_PT || ' ngày';          END IF;    

    IF(VHINHPHATID = 3)THEN
        IF(MAHINHPHAT_ST = 'CAITAOKGG' AND MAHINHPHAT_PT = 'CAITAOKGG') THEN
            IF(NAM_PT > NAM_ST) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT < NAM_ST) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT = NAM_ST) THEN
                    IF(THANG_PT > THANG_PT) THEN
                            V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT < THANG_PT) THEN
                            V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT = THANG_ST) THEN
                            IF(NGAY_PT > NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT < NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT = NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Cải tạo không giam giữ ' || THOIGIAN_PT || '';
                            END IF;
                    END IF;
            END IF;
            ELSIF(MAHINHPHAT_ST = 'DEFAULT VALUE' AND MAHINHPHAT_PT = 'CAITAOKGG') THEN
                V_RESULT_EXPORT := 'Cải tạo không giam giữ ' || THOIGIAN_PT || '; ';
        END IF;
    END IF;

    IF(VHINHPHATID = 65)THEN
        IF(MAHINHPHAT_ST = 'DCHDCTH' AND MAHINHPHAT_PT = 'DCHDCTH') THEN
            IF(NAM_PT > NAM_ST) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT < NAM_ST) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT = NAM_ST) THEN
                    IF(THANG_PT > THANG_PT) THEN
                            V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT < THANG_PT) THEN
                            V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT = THANG_ST) THEN
                            IF(NGAY_PT > NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT < NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT = NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Đình chỉ hoạt động ' || THOIGIAN_PT || '; ';
                            END IF;
                    END IF;
            END IF;
            ELSIF(MAHINHPHAT_ST = 'DEFAULT VALUE' AND MAHINHPHAT_PT = 'DCHDCTH') THEN
                V_RESULT_EXPORT := 'Đình chỉ hoạt động ' || THOIGIAN_PT || '';
        END IF;
    END IF;

    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT
        FROM DUAL;   
END AHS_SOSANH_HINHPHAT_THOIGIAN;

PROCEDURE AHS_RETURN_ALL_HINHPHAT_BICAN
(
    VVUANID in number,
    curReturn OUT sys_refcursor
)
AS 
    V_CURSOR sys_refcursor;

    TEXT_EXPORT_ST VARCHAR(1000) DEFAULT '';
    TEXT_EXPORT_PT VARCHAR(1000) DEFAULT '';
    V_RESULT_EXPORT_ST CLOB;
    V_RESULT_EXPORT_PT CLOB;

    V_QD_DINHCHI NUMBER DEFAULT 0;

    CHECK_KETQUAPHUCTHAM NUMBER DEFAULT 0;

    KHANGNGHIVA NUMBER DEFAULT 0;    KHANGNGHIBC CLOB;-- NUMBER DEFAULT 0;     
    TGTTKHANGCAOVA NUMBER DEFAULT 0; TGTTKHANGCAOBC CLOB;-- NUMBER DEFAULT 0;
    BCKHANGCAO CLOB; --NUMBER DEFAULT 0; 
    DANHSACH_BC CLOB DEFAULT '';
    DANHSACH_BC_CHAR VARCHAR(2000);

    check_value NUMBER DEFAULT 0;

    V_RESULT_EXPORT_TENTOIDANH CLOB DEFAULT ''; 
    V_RESULT_EXPORT_HOTEN CLOB DEFAULT '';
    V_RESULT_EXPORT_SOBC NUMBER DEFAULT 0;
    check_value_ID CLOB; check_value_HOTEN CLOB;check_value_TENTOIDANH CLOB;

    CHECK_INTO NUMBER DEFAULT 0;

BEGIN       

    select count(1) into V_RESULT_EXPORT_SOBC from ahs_bicanbicao bc where vuanid = VVUANID; 

    --Bị cáo kháng cáo
    select listagg(bc.id, ';') within group (order by '') --count(1)
    into BCKHANGCAO 
    from ahs_bicanbicao bc 
    inner join (select kc.ID,kc.nguoikcid 
                from ahs_sotham_khangcao kc 
                    left join ahs_sotham_rutkhangcao rkc on rkc.khangcaoid = kc.id 
                where NGUOIKCLOAI = 0 and rkc.khangcaoid is null) bckc on bckc.nguoikcid = bc.id 
    where vuanid = VVUANID;

    --Người tham gia tố tụng kháng cáo 
    select count(1) into TGTTKHANGCAOVA 
    from ahs_nguoithamgiatotung tgtt 
        inner join (select kc.ID, kc.nguoikcid 
                    from ahs_sotham_khangcao kc 
                        left join ahs_sotham_rutkhangcao rkc on rkc.khangcaoid = kc.id 
                    where NGUOIKCLOAI = 1 and DSNGUOIBIKC is null and rkc.khangcaoid is null) bhkc on bhkc.nguoikcid = tgtt.id 
    where tgtt.vuanid = VVUANID;
    
    select listagg(bhkc.DSNGUOIBIKC, ';') within group (order by '') --count(1) 
    into TGTTKHANGCAOBC 
    from ahs_nguoithamgiatotung tgtt 
        inner join (select kc.ID,kc.nguoikcid,DSNGUOIBIKC 
                    from ahs_sotham_khangcao kc 
                        left join ahs_sotham_rutkhangcao rkc on rkc.khangcaoid = kc.id 
                    where NGUOIKCLOAI = 1 and DSNGUOIBIKC is NOT null and rkc.khangcaoid is null) bhkc on bhkc.nguoikcid = tgtt.id 
    where vuanid = VVUANID;

    -- Kháng nghị
    select count(1) into KHANGNGHIVA 
    from ahs_sotham_khangnghi kn 
        left join ahs_sotham_rutkhangnghi rkn on rkn.khangnghiid = kn.id and rkn.caprutkn = 3 and rkn.tinhtrang = 2
    where vuanid = vvuanid and DSNGUOIBIKN is null and rkn.khangnghiid is null;
    
    select listagg(DSNGUOIBIKN, ';') within group (order by '')--count(1) 
    into KHANGNGHIBC 
    from ahs_sotham_khangnghi kn 
        left join ahs_sotham_rutkhangnghi rkn on rkn.khangnghiid = kn.id  and rkn.caprutkn = 3 and rkn.tinhtrang = 2
    where vuanid = vvuanid and DSNGUOIBIKN is NOT null and rkn.khangnghiid is null;    

    if(KHANGNGHIVA > 0 OR TGTTKHANGCAOVA > 0) then --Lấy hết tất cả bị cáo cùng tội danh

            for item in (select  bc.id, hoten, TD.TENTOIDANH into check_value_ID, check_value_HOTEN, check_value_TENTOIDANH from ahs_bicanbicao bc
                             INNER JOIN (SELECT BICANID, DL.TENTOIDANH 
                                         FROM AHS_SOTHAM_CAOTRANG_DIEULUAT DL 
                                            INNER JOIN (SELECT ID FROM DM_BOLUAT_TOIDANH BL WHERE DIEM IS NULL AND KHOAN IS NULL) DMBL ON DMBL.ID = DL.TOIDANHID
                                         WHERE ISMAIN = 1 )TD ON TD.BICANID = BC.ID      
                         where BC.VUANID = VVUANID)
            loop
                DANHSACH_BC := CONCAT(DANHSACH_BC,ITEM.ID || ';');
                V_RESULT_EXPORT_HOTEN := CONCAT(V_RESULT_EXPORT_HOTEN,ITEM.HOTEN || ';<br style="mso-data-placement:same-cell;" />');
                V_RESULT_EXPORT_TENTOIDANH := CONCAT(V_RESULT_EXPORT_TENTOIDANH,ITEM.TENTOIDANH || ';<br style="mso-data-placement:same-cell;" />');

            end loop;

        elsif (BCKHANGCAO IS NOT NULL OR TGTTKHANGCAOBC IS NOT NULL  OR KHANGNGHIBC IS NOT NULL ) then --Lấy các bị cáo được kc/kn cùng tội danh  

            BCKHANGCAO := replace(BCKHANGCAO,',',';');
            TGTTKHANGCAOBC := replace(TGTTKHANGCAOBC,',',';');
            KHANGNGHIBC := replace(KHANGNGHIBC,',',';');

            for item in (select regexp_substr(BCKHANGCAO, '[^;]+', 1, level) bcid FROM dual CONNECT BY LEVEL <= regexp_count( BCKHANGCAO,  ';' ) + 1)
            loop
                SELECT REGEXP_INSTR(DANHSACH_BC, item.bcid) into check_value FROM DUAL;
                if(DANHSACH_BC LIKE '') then DANHSACH_BC := concat(DANHSACH_BC, item.bcid ||';'); end if; check_value := 0; 
                if(check_value = 0) then DANHSACH_BC := concat(DANHSACH_BC,';' || item.bcid); end if; check_value := 0;   
            end loop;

            for item in (select regexp_substr(TGTTKHANGCAOBC, '[^;]+', 1, level) bcid FROM dual CONNECT BY LEVEL <= regexp_count( TGTTKHANGCAOBC,  ';' ) + 1)
            loop
                SELECT REGEXP_INSTR(DANHSACH_BC, item.bcid) into check_value FROM DUAL;
                if(DANHSACH_BC LIKE '') then DANHSACH_BC := concat(DANHSACH_BC, item.bcid ||';'); end if; check_value := 0; 
                if(check_value = 0) then DANHSACH_BC := concat(DANHSACH_BC,';' || item.bcid); end if; check_value := 0;

            end loop;

            for item in (select regexp_substr(KHANGNGHIBC, '[^;]+', 1, level) bcid FROM dual CONNECT BY LEVEL <= regexp_count( KHANGNGHIBC,  ';' ) + 1)
            loop
                SELECT REGEXP_INSTR(DANHSACH_BC, item.bcid) into check_value FROM DUAL;
                if(DANHSACH_BC LIKE '') then DANHSACH_BC := concat(DANHSACH_BC, item.bcid ||';'); end if; check_value := 0; 
                if(check_value = 0) then DANHSACH_BC := concat(DANHSACH_BC,';' || item.bcid); end if; check_value := 0;                
            end loop;

            --Quy về 1 chuẩn dữ liệu DANHSACH_BC
            WHILE (INSTR(DANHSACH_BC, ';;') > 0)
            LOOP
               DANHSACH_BC := REPLACE( DANHSACH_BC, ';;', ';');
            END LOOP;

            IF(INSTR(DANHSACH_BC, ';') = 1) THEN
                DANHSACH_BC := SUBSTR(DANHSACH_BC, 2, LENGTH(DANHSACH_BC));
            END IF;   

            IF(SUBSTR(DANHSACH_BC,-1) NOT LIKE ';') THEN
                DANHSACH_BC := CONCAT(DANHSACH_BC, ';');
            END IF; 
            -------------------------------------------------------------------------------
            --V_RESULT_EXPORT_HOTEN := DANHSACH_BC;
            for item in (select regexp_substr(DANHSACH_BC, '[^;]+', 1, level) bcid FROM dual CONNECT BY LEVEL <= regexp_count( DANHSACH_BC,  ';' ))
            loop

                check_value := to_number(item.bcid);

                select hoten into check_value_HOTEN
                from ahs_bicanbicao BC
                where bc.id = check_value;

                 BEGIN
                    SELECT DL.TENTOIDANH into check_value_TENTOIDANH
                    FROM AHS_SOTHAM_CAOTRANG_DIEULUAT DL 
                    WHERE EXISTS (SELECT 'X' FROM DM_BOLUAT_TOIDANH BL  WHERE BL.DIEM IS NULL AND BL.KHOAN IS NULL AND BL.TENTOIDANH LIKE '%'||DL.TENTOIDANH||'%') /*AND ISMAIN = 1*/
                    AND ROWNUM = 1 and DL.BICANID = check_value
                    ORDER BY DL.ID;
                  EXCEPTION 
                        WHEN OTHERS 
                        THEN check_value_TENTOIDANH := null;
                   END;   

                V_RESULT_EXPORT_HOTEN := CONCAT(V_RESULT_EXPORT_HOTEN,check_value_HOTEN || ';<br style="mso-data-placement:same-cell;" />');
                V_RESULT_EXPORT_TENTOIDANH := CONCAT(V_RESULT_EXPORT_TENTOIDANH,check_value_TENTOIDANH || ';<br style="mso-data-placement:same-cell;" />');

            end loop;
        end if;

        SELECT count(1) INTO V_QD_DINHCHI
        FROM AHS_PHUCTHAM_QUYETDINH_VUAN
        INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                    WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
        WHERE VUANID = VVUANID;

        IF(V_QD_DINHCHI > 0) THEN V_RESULT_EXPORT_PT := ' QĐ đình chỉ; ';
            ELSE 
                SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM 
                FROM AHS_PHUCTHAM_BANAN BA
                INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Giữ nguyên bản án, quyết định sơ thẩm') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                WHERE BA.VUANID = VVUANID;

                IF(CHECK_KETQUAPHUCTHAM > 0 ) THEN V_RESULT_EXPORT_PT := V_RESULT_EXPORT_PT || 'Giữ nguyên bản án, quyết định sơ thẩm;';            
                    ELSE   
                            SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM
                            FROM AHS_PHUCTHAM_BANAN BA
                            INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Hủy%') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                            WHERE BA.VUANID = VVUANID;

                        IF(CHECK_KETQUAPHUCTHAM = 1 ) THEN 
                            SELECT TEN INTO V_RESULT_EXPORT_PT
                                FROM AHS_PHUCTHAM_BANAN BA
                                INNER JOIN (SELECT TEN,ID FROM DM_KETQUA_PHUCTHAM) KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                                WHERE BA.VUANID = VVUANID;
                            ELSE
                                IF(DANHSACH_BC IS NOT NULL) then 
                                        DANHSACH_BC_CHAR := TO_CHAR(DANHSACH_BC);
                                        FOR ITEM IN (select regexp_substr(DANHSACH_BC_CHAR, '[^;]+', 1, level) BCID FROM dual CONNECT BY LEVEL <= regexp_count(DANHSACH_BC_CHAR,  ';' ) + 1)
                                            LOOP
                                                IF(ITEM.BCID IS NOT NULL) THEN
                                                        check_value := to_number(ITEM.BCID);

                                                        PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_PT(0,check_value,V_CURSOR);
                                                        LOOP FETCH V_CURSOR INTO TEXT_EXPORT_PT;
                                                        EXIT WHEN V_CURSOR%NOTFOUND;
                                                        END LOOP;
                                                        CLOSE V_CURSOR;

                                                        V_RESULT_EXPORT_PT := CONCAT(V_RESULT_EXPORT_PT,TEXT_EXPORT_PT || ';<br style="mso-data-placement:same-cell;" />');

                                                    END IF;
                                            END LOOP;
                                    END IF;
                        END IF;
                    END IF;
            END IF;

            IF(DANHSACH_BC IS NOT NULL) then 
                DANHSACH_BC_CHAR := TO_CHAR(DANHSACH_BC);
                FOR ITEM IN (select regexp_substr(DANHSACH_BC_CHAR, '[^;]+', 1, level) BCID FROM dual CONNECT BY LEVEL <= regexp_count(DANHSACH_BC_CHAR,  ';' ) + 1)
                    LOOP
                        IF(ITEM.BCID IS NOT NULL) THEN
                                check_value := to_number(ITEM.BCID);

                                PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_ST(0,check_value,V_CURSOR);
                                LOOP FETCH V_CURSOR INTO TEXT_EXPORT_ST;
                                EXIT WHEN V_CURSOR%NOTFOUND;
                                END LOOP;
                                CLOSE V_CURSOR;

                                V_RESULT_EXPORT_ST := CONCAT(V_RESULT_EXPORT_ST,TEXT_EXPORT_ST || ';<br style="mso-data-placement:same-cell;" />');

                            END IF;
                    END LOOP;
            END IF;


    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT_ST ,V_RESULT_EXPORT_PT,V_RESULT_EXPORT_HOTEN,V_RESULT_EXPORT_TENTOIDANH,V_RESULT_EXPORT_SOBC
                FROM DUAL;
END AHS_RETURN_ALL_HINHPHAT_BICAN;

END PKG_STPT_AHS_TONGHOPHINHPHAT;

/
