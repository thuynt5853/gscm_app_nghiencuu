--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO_TUANVNA
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO_TUANVNA" AS

PROCEDURE GDT14_Export
(  
    V_TOAANID	    IN	VARCHAR2,
    V_Donvi_KNID	IN	VARCHAR2,
    V_LOAIAN_ID     IN  VARCHAR2,
    V_LOAIXULY      IN	VARCHAR2,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,
    curReturn       OUT sys_refcursor
)
IS 
    V_ARRAY     T_TYPE_OF_15_COLUMN_VARCHAR;

    V_TENLOAIAN VARCHAR(100);

    VVTUNGAY    DATE;
    VVDENNGAY   DATE;

    COLUMN_3    NUMBER DEFAULT 0;
    COLUMN_4    NUMBER DEFAULT 0;
    COLUMN_5    NUMBER DEFAULT 0;
    COLUMN_6    NUMBER DEFAULT 0;
    COLUMN_7    NUMBER DEFAULT 0;
    COLUMN_8    NUMBER DEFAULT 0;
    COLUMN_9    NUMBER DEFAULT 0;
    COLUMN_10   NUMBER DEFAULT 0;
    COLUMN_11   NUMBER DEFAULT 0;
    COLUMN_12   NUMBER DEFAULT 0;
    COLUMN_13   NUMBER DEFAULT 0;
    COLUMN_14   NUMBER DEFAULT 0;
    COLUMN_15   NUMBER DEFAULT 0;
    
    KIEMTRACODE VARCHAR(1000);

BEGIN
    V_ARRAY := T_TYPE_OF_15_COLUMN_VARCHAR();

    IF(VTUNGAY IS NOT NULL)  then  VVTUNGAY:=  TO_DATE(TRIM(VTUNGAY)  ||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
    IF(VDENNGAY IS NOT NULL) then  VVDENNGAY:= TO_DATE(TRIM(VDENNGAY) ||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;

    FOR ITEM IN (SELECT DM.ID, DM.LOAI_AN_TEN FROM DM_LOAIAN DM ORDER BY DM.ID)
    LOOP
            IF (ITEM.ID = 3) THEN V_TENLOAIAN := 'HNGD';
            ELSIF (ITEM.ID = 4) THEN V_TENLOAIAN := 'Kinh tế';
            ELSE V_TENLOAIAN := ITEM.LOAI_AN_TEN; END IF;

            V_ARRAY.EXTEND;
            V_ARRAY(V_ARRAY.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(ITEM.ID,V_TENLOAIAN,'','','','','','','','','','','','','' );
    END LOOP;

    FOR ITEM IN (SELECT T1.COLUMN_1 FROM TABLE(V_ARRAY) T1 ORDER BY T1.COLUMN_1) 
    LOOP
        --Tổng số đơn xử lý
        SELECT COUNT('x') INTO COLUMN_3
        FROM GDTTT_DON T2 
        WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                AND (T2.CD_LOAI = 0) -- Nơi chuyển Nội bộ
                AND (T2.LOAIDON IN (1,3,5,6,7,8,9,10)) -- Lấy tất cả các loại hình thức đơn (trừ Hồ sơ kháng nghị GĐT)
                AND (T2.NGAYXULYDON BETWEEN VVTUNGAY AND VVDENNGAY AND T2.NGAYXULYDON IS NOT NULL);

        --Mới thụ lý xét xử GĐT  
        -- Lấy từ HCTP và 4. GDKT theo ngày thụ lý
        SELECT SUM(COUNT_TL) INTO COLUMN_4
        FROM (SELECT COUNT('x') AS COUNT_TL
             FROM GDTTT_VUAN T2 
             WHERE (T2.LOAIAN = ITEM.COLUMN_1 OR T2.LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                     AND (T2.NGAYTHULYXXGDT BETWEEN VVTUNGAY AND VVDENNGAY AND T2.NGAYTHULYXXGDT IS NOT NULL)
             UNION
             SELECT COUNT('x') AS COUNT_TL
             FROM GDTTT_DON T2
             WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                    AND T2.LOAIDON IN (4) -- Chỉ lấy Hồ sơ kháng nghị GĐT
                    AND T2.CD_TRANGTHAI IN (0,1)
                    AND (T2.TL_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND T2.TL_NGAY IS NOT NULL)
             );

        --Giải quyết, còn lại xét xử GĐT
        --Đã giải quyết
        SELECT COUNT('x') INTO COLUMN_5
        FROM GDTTT_VUAN T2 
        WHERE (T2.LOAIAN = ITEM.COLUMN_1 OR T2.LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                AND (T2.XXGDTTT_NGAYQD BETWEEN VVTUNGAY AND VVDENNGAY AND T2.XXGDTTT_NGAYQD IS NOT NULL);

        -- Còn lại
        
        /* Lấy những vụ tính đến thời điểm cuối của kỳ thống kê: đã thụ lý chưa có kết quả
           
        
        */
        SELECT SUM(COUNT_X) INTO COLUMN_6 
        FROM (
                -- hctp
                SELECT COUNT('X') AS COUNT_X
                        FROM GDTTT_DON T2 
                        WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID) AND T2.CD_LOAI = 0
                              AND T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001') -- Thụ lý đến "đến ngày"
                              AND T2.LOAIDON = 4 AND T2.CD_TRANGTHAI IN (0,1) -- Hồ sơ kháng nghị chưa chuyển hoặc đã chuyển nhưng chưa nhận

                UNION
                -- các p gđ
                SELECT COUNT('X') AS COUNT_X
                FROM GDTTT_VUAN VA
                WHERE (VA.LOAIAN = ITEM.COLUMN_1 OR VA.LOAIAN = V_LOAIAN_ID) AND (VA.TOAANID = V_TOAANID)
                    AND EXISTS(SELECT 'X' 
                               FROM GDTTT_DON T2 
                               WHERE T2.VUVIECID = VA.ID AND T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                               AND T2.CD_TRANGTHAI IN (2) AND T2.CD_LOAI = 0) -- Xuất phát từ đơn
                    AND (
                         --(VA.GQD_LOAIKETQUA = 1 AND VA.XXGDTTT_KETQUAID IS NULL AND VA.NGAYTHULYXXGDT IS NULL AND VA.TRANGTHAIID = 14 AND VA.THAMQUYENXXGDT = 4) -- Đã xác định là HSKN, chưa thụ lý và chưa có kết quả
                         --OR 
                         (VA.GQD_LOAIKETQUA = 1 AND (NVL(VA.XXGDTTT_KETQUAID,0) = 0) AND VA.NGAYTHULYXXGDT IS NOT NULL) -- Đã xác định là HSKN, đã thụ lý và chưa có kết quả
                         OR (VA.GQD_LOAIKETQUA = 1 AND (NVL(VA.XXGDTTT_KETQUAID,0) > 0) AND VA.NGAYTHULYXXGDT IS NOT NULL AND VA.XXGDTTT_NGAYQD > VVDENNGAY)
                         )
                )
        ; 

        --Mới thụ lý đơn
        SELECT COUNT('x') INTO COLUMN_7
        FROM GDTTT_DON T2
        WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                AND (T2.LOAIDON IN (1,3,6,7,9))
                AND (T2.TL_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND T2.TL_NGAY IS NOT NULL);

        --Giải quyết, còn lại đơn GDT,TT
        SELECT COUNT('x') INTO COLUMN_8
        FROM GDTTT_VUAN T2
            INNER JOIN (SELECT T2.VUVIECID 
                        FROM GDTTT_DON T2 
                        WHERE T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                        AND T2.CD_TRANGTHAI IN (2)
                        AND T2.LOAIDON IN (1,3,6,7,9)) DON ON DON.VUVIECID = T2.ID
        WHERE (T2.LOAIAN = ITEM.COLUMN_1 OR T2.LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
              AND T2.GQD_LOAIKETQUA = 0 --Trả lời đơn = 0 
              AND (T2.GDQ_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND T2.GDQ_NGAY IS NOT NULL); 

        SELECT COUNT('x') INTO COLUMN_9
        FROM GDTTT_VUAN T2
                    INNER JOIN (SELECT T2.VUVIECID 
                        FROM GDTTT_DON T2 
                        WHERE T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                        AND T2.CD_TRANGTHAI IN (2)
                        AND T2.LOAIDON IN (1,3,6,7,9)) DON ON DON.VUVIECID = T2.ID
        WHERE (T2.LOAIAN = ITEM.COLUMN_1 OR T2.LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
              AND (T2.GQD_LOAIKETQUA = 1) --Nếu chỉ cần Chánh án --Kháng nghị  = 1 
              --AND (T2.GQD_LOAIKETQUA = 1 AND T2.nguoikhangnghi IN (9, 1143) or ISvientruongkn IS NULL) --Nếu cần cả Chánh án + VKS --Kháng nghị  = 1 
              AND (T2.GDQ_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND T2.GDQ_NGAY IS NOT NULL);

        SELECT COUNT('x') INTO COLUMN_10
        FROM GDTTT_VUAN T2
                    INNER JOIN (SELECT T2.VUVIECID 
                        FROM GDTTT_DON T2 
                        WHERE T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                        AND T2.CD_TRANGTHAI IN (2)
                        AND T2.LOAIDON IN (1,3,6,7,9)) DON ON DON.VUVIECID = T2.ID
        WHERE (T2.LOAIAN = ITEM.COLUMN_1 OR T2.LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
              AND T2.GQD_LOAIKETQUA IN (2,3,4) --Xếp đơn = 2, Xử lý khác = 3 và VKS đang GQ = 4
              AND (T2.GQD_NGAYPHATHANHCV BETWEEN VVTUNGAY AND VVDENNGAY AND T2.GQD_NGAYPHATHANHCV IS NOT NULL);

        -- Còn lại
        SELECT SUM(COUNT_X) INTO COLUMN_12
        FROM (  SELECT COUNT('X') AS COUNT_X
                FROM GDTTT_DON T2 
                    LEFT JOIN (SELECT VA.* FROM GDTTT_VUAN VA) VA ON VA.ID = T2.VUVIECID
                WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                      AND T2.ISTHULY = 1
                      AND T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001') -- Thụ lý đến "đến ngày"
                      AND (T2.LOAIDON IN (1,3,6,7,9)) AND T2.CD_TRANGTHAI IN (0,1) -- Đơn đề nghị, Đơn đề nghị + CV, CV kiến nghị, CV kiến nghị + CV
                      AND T2.CD_LOAI = 0
                UNION

                SELECT COUNT('X') AS COUNT_X
                FROM GDTTT_VUAN VA
                    INNER JOIN (SELECT T2.VUVIECID 
                               FROM GDTTT_DON T2 
                               WHERE T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                               AND T2.CD_TRANGTHAI IN (2)
                               AND T2.LOAIDON IN (1,3,6,7,9)
                               AND T2.CD_LOAI = 0) T2 ON T2.VUVIECID = VA.ID
                WHERE (VA.LOAIAN = ITEM.COLUMN_1 OR VA.LOAIAN = V_LOAIAN_ID) AND (VA.TOAANID = V_TOAANID)
                    AND (
                         (VA.GQD_LOAIKETQUA IS NULL) -- Đã xác định là HSKN, chưa thụ lý và chưa có kết quả
                         OR (VA.GQD_LOAIKETQUA != 1 AND VA.GDQ_NGAY > VVDENNGAY)
                         )
                )
        ; 

        --Giải quyết khiếu nại tư pháp
        --Mới thụ lý
        SELECT COUNT('x') INTO COLUMN_13
        FROM GDTTT_DON T2        
        WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
              AND  T2.LOAIDON IN (8,10) -- 8 - Khiếu nại tư pháp, 10 - Đơn Khiếu nại Tư pháp kèm CV chuyển đơn
              AND (T2.TL_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND T2.TL_NGAY IS NOT NULL);

        --Giải quyết khiếu nại    
        SELECT COUNT('x') INTO COLUMN_14
        FROM GDTTT_DON T2        
        WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID) 
              AND T2.LOAIDON IN (8,10) -- 8 - Khiếu nại tư pháp, 10 - Đơn Khiếu nại Tư pháp kèm CV chuyển đơn
              AND EXISTS(SELECT 'X' FROM GDTTT_VUAN VA -- (Đã chuyển + Đã chuyển và đã nhận) + Đã thụ lý + đã có kết quả giải quyết
                         WHERE T2.VUVIECID = VA.ID 
                             AND VA.GQD_LOAIKETQUA IN (0,1,2,3) -- 0 - Chấp nhận KN, 1 - Không chấp nhận KN, 2 - Xếp đơn, 3 - Giải quyết khác 
                             AND VA.LOAI_GDTTTT IN (8,10)
                             AND (VA.GDQ_NGAY BETWEEN VVTUNGAY AND VVDENNGAY AND VA.GDQ_NGAY IS NOT NULL) ); 

        --Còn lại     
        -- Còn lại    
        SELECT SUM(COUNT_X) INTO COLUMN_15
        FROM (  SELECT COUNT('X') AS COUNT_X
                FROM GDTTT_DON T2 
                WHERE (T2.BAQD_LOAIAN = ITEM.COLUMN_1 OR T2.BAQD_LOAIAN = V_LOAIAN_ID) AND (T2.TOAANID = V_TOAANID)
                      AND T2.ISTHULY = 1
                      AND T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001') -- Thụ lý đến "đến ngày"
                      AND T2.LOAIDON IN (8,10) AND T2.CD_TRANGTHAI IN (0,1) -- 8 - Khiếu nại tư pháp, 10 - Đơn Khiếu nại Tư pháp kèm CV chuyển đơn
                      AND T2.CD_LOAI = 0
                UNION

                SELECT COUNT('X') AS COUNT_X
                FROM GDTTT_VUAN VA
                    INNER JOIN (SELECT T2.VUVIECID 
                               FROM GDTTT_DON T2 
                               WHERE T2.TL_NGAY <= VVDENNGAY AND T2.TL_NGAY IS NOT NULL AND (TO_CHAR(T2.TL_NGAY,'dd/MM/yyyy') != '01/01/0001')
                               AND T2.CD_TRANGTHAI IN (2)
                               AND T2.LOAIDON IN (8,10)
                               AND T2.CD_LOAI = 0) T2 ON T2.VUVIECID = VA.ID

                WHERE (VA.LOAIAN = ITEM.COLUMN_1 OR VA.LOAIAN = V_LOAIAN_ID) AND (VA.TOAANID = V_TOAANID)
                    AND (
                         (VA.GQD_LOAIKETQUA IS NULL) -- Chưa có kết quả
                         OR (VA.GQD_LOAIKETQUA IS NOT NULL AND VA.GDQ_NGAY > VVDENNGAY) -- Đã có kết quả sau ngày đến
                         )
                )
        ; 

        --Đổ vào bảng tạm      
        V_ARRAY(ITEM.COLUMN_1).COLUMN_3:= TO_CHAR(COLUMN_3);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_4:= TO_CHAR(COLUMN_4);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_5:= TO_CHAR(COLUMN_5);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_6:= TO_CHAR(COLUMN_6);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_7:= TO_CHAR(COLUMN_7);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_8:= TO_CHAR(COLUMN_8);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_9:= TO_CHAR(COLUMN_9);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_10:= TO_CHAR(COLUMN_10);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_11:= TO_CHAR(COLUMN_8 + COLUMN_9 + COLUMN_10);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_12:= TO_CHAR(COLUMN_12);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_13:= TO_CHAR(COLUMN_13);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_14:= TO_CHAR(COLUMN_14);
        V_ARRAY(ITEM.COLUMN_1).COLUMN_15:= TO_CHAR(COLUMN_15);

        --Reset lại các biến tạm
        COLUMN_3 := 0;  COLUMN_3 := 0;  COLUMN_4 := 0;  COLUMN_5 := 0;
        COLUMN_6 := 0;  COLUMN_7 := 0;  COLUMN_8 := 0;  COLUMN_9 := 0;
        COLUMN_10 := 0; COLUMN_11 := 0; COLUMN_12 := 0; COLUMN_13 := 0;
        COLUMN_14 := 0; COLUMN_15 := 0;
    END LOOP;

    OPEN curReturn FOR
        SELECT T1.* 
        FROM TABLE(V_ARRAY) T1
        ORDER BY  T1.COLUMN_1;
END GDT14_Export;

END PKG_VGDKT_BAOCAO_TUANVNA;

/
