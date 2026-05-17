create or replace NONEDITIONABLE PROCEDURE        "AHS_SOTHAM_KCAOKNGHI_GETLIST" 
( VVUANID IN NUMBER,
	CURRETURN OUT SYS_REFCURSOR
)
IS 
--TOANCAU
IDCUOIDAGIAIQUYET NUMBER;
IDCUOIDAGIAIQUYETKN NUMBER;
ISCHUYENAN NUMBER;
V_DANHSACHNGUOIBIKC CLOB;
V_HOTEN VARCHAR2(100);
VTOAANID NUMBER;--TOANCAU
V_ARRAY         T_AHS_SOTHAM_KCAOKNGHI_GETLIST;

BEGIN

    V_ARRAY := T_AHS_SOTHAM_KCAOKNGHI_GETLIST();


--TOANCAU
    BEGIN
        SELECT
            MAX(ID)
        INTO IDCUOIDAGIAIQUYET
        FROM
            AHS_SOTHAM_KHANGCAO
        WHERE
            TINHTRANG_GIAIQUYET = 1
            AND VUANID = VVUANID;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IDCUOIDAGIAIQUYET := 0;
    END;

    BEGIN
        SELECT
            MAX(ID)
        INTO IDCUOIDAGIAIQUYETKN
        FROM
            AHS_SOTHAM_KHANGNGHI
        WHERE
            TINHTRANG_GIAIQUYET = 1
            AND VUANID = VVUANID;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IDCUOIDAGIAIQUYETKN := 0;
    END;

    BEGIN    
        SELECT
            TOAANID
        INTO VTOAANID
        FROM
            AHS_VUAN
        WHERE
            ID = VVUANID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN VTOAANID := 0;
    END;

    BEGIN
        SELECT
            (
                CASE
                    WHEN GNST.VUANID IS NULL THEN
                        0
                    ELSE
                        1
                END
            ) ISCHUYENAN INTO ISCHUYENAN
        FROM
            AHS_VUAN D
            LEFT JOIN (
                SELECT
                    CNA.ID,
                    CNA.VUANID,
                    CNA.TOACHUYENID
                FROM
                    (
                        SELECT
                            CA.ID,
                            CA.VUANID,
                            CA.TOACHUYENID,
                            ROW_NUMBER() OVER(
                                PARTITION BY CA.VUANID, CA.TOACHUYENID
                                ORDER BY
                                    CA.ID DESC
                            ) RN
                        FROM
                            AHS_CHUYEN_NHAN_AN CA
                        WHERE
                            CA.TOACHUYENID = VTOAANID
                    ) CNA
                WHERE
                    CNA.RN = 1
                    AND NOT EXISTS (
                        SELECT
                            'X'
                        FROM
                            AHS_CHUYEN_NHAN_AN   CN1
                            JOIN AHS_CHUYEN_NHAN_AN   CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                        WHERE
                            CN1.VUANID = CNA.VUANID
                            AND CN2.TOANHANID = VTOAANID
                            AND CN2.ID > CNA.ID
                    )
            ) GNST ON GNST.VUANID = D.ID
                      AND D.MAGIAIDOAN = 2
        WHERE
            D.ID = VVUANID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN ISCHUYENAN := 0;
    END;
--TOANCAU

    FOR ITEM IN (      
                SELECT  D.ID AS ID
                       ,'1' AS ISKHANGCAO
                       ,'Kháng cáo' AS KCKNNAME
                       ,DECODE (S.HOTEN,NULL,L.HOTEN,S.HOTEN) || 
                              ' ' || DECODE(S.BICANDAUVU, 0, '(Bị cáo)', 1, '(Bị cáo đầu vụ)' , '(' || L.TEN || ')') || 
                              ' - ' || DECODE (S.NAMSINH,NULL,   DECODE(L.NAMSINH, 0, '' ,L.NAMSINH),S.NAMSINH) AS NGUOIKCCAPKN
                       ,d.DSNGUOIBIKC AS NGUOIBIKC     
                       ,(CASE D.LOAIKHANGCAO WHEN 0 THEN 'Bản án'  WHEN 1 THEN 'Quyết định' ELSE 'QĐ tạm đình chỉ/khác' END) AS LOAIKCKN  
                       ,D.NGAYKHANGCAO AS NGAYKCKN
                       ,(CASE D.LOAIKHANGCAO WHEN 0 THEN B.SOBANAN ELSE Q.SOQUYETDINH END) AS SO_QDBA
                       ,D.NGAYQDBA AS NGAYQDBA
                       ,D.NGUOITAO
                       ,D.NGAYTAO
                       ,CASE WHEN D.ISQUAHAN=1 THEN 'Có' ELSE 'Không' END AS QUAHAN
                       ,D.NGUOITAO || ' ' || TO_CHAR(D.NGAYTAO,'dd/mm/rrrr') AS NGUOITAONGAYTAO
                       ,(CASE D.LOAIKHANGCAO WHEN 0 THEN B.SOBANAN ELSE Q.SOQUYETDINH END) || '<br>' || TO_CHAR(D.NGAYQDBA,'dd/mm/rrrr') AS SONGAY_BAQD
                       ,YCKCKN.TENYEUCAU
                       ,D.TENFILE
                       , DECODE(S.ID, NULL, 'Người kháng cáo ' || L.HOTEN || ' kháng cáo ' || D.NOIDUNGKHANGCAO,'Bị cáo ' || S.HOTEN || ' kháng cáo ' || D.NOIDUNGKHANGCAO) AS NOIDUNG
                       ,(CASE WHEN D.TINHTRANG_GIAIQUYET = 1 THEN 'Đã giải quyết' WHEN D.TINHTRANG_GIAIQUYET = 3 THEN 'Rút kháng nghị' ELSE '' END) AS TINHTRANG_GIAIQUYET
                       ,(CASE WHEN (IDCUOIDAGIAIQUYETKN>0 AND D.ID <= IDCUOIDAGIAIQUYETKN ) OR D.TINHTRANG_GIAIQUYET = 3 OR ISCHUYENAN = 1 THEN 1 ELSE 0 END) AS READONLY
                        ,D.TOA_GIAIQUYET_ID
                FROM AHS_SOTHAM_KHANGCAO D 

                    LEFT JOIN (SELECT A.ID,A.HOTEN,A.NAMSINH,A.BICANDAUVU FROM AHS_BICANBICAO A WHERE A.VUANID=VVUANID) S ON S.ID=D.NGUOIKCID
                    LEFT JOIN (SELECT A.ID,A.HOTEN,A.NAMSINH, DM_DTITEM.TEN FROM AHS_NGUOITHAMGIATOTUNG A 
                                    LEFT JOIN (SELECT A.NGUOIID, A.TUCACHID FROM AHS_NGUOITHAMGIATOTUNG_TUCACH A) TC ON TC.NGUOIID = A.ID
                                    LEFT JOIN (SELECT A.ID, A.TEN FROM DM_DATAITEM A) DM_DTITEM ON DM_DTITEM.ID = TC.TUCACHID

                               WHERE A.VUANID=VVUANID) L ON L.ID=D.NGUOIKCID

                    LEFT JOIN (SELECT E.VUANID,E.SOBANAN,E.ID FROM AHS_SOTHAM_BANAN E WHERE E.VUANID=VVUANID) B ON B.ID=D.SOQDBA AND D.LOAIKHANGCAO = 0
                    LEFT JOIN (SELECT F.VUANID,F.SOQUYETDINH,F.ID,0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN F WHERE F.VUANID=VVUANID
                               UNION 
                               SELECT F.VUANID,F.SOQUYETDINH,F.ID,1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN F WHERE F.VUANID = VVUANID) Q ON Q.ID=D.SOQDBA AND ((D.LOAIKHANGCAO = 3 AND Q.ISBICAN = 1) OR D.LOAIKHANGCAO IN (1,2) AND Q.ISBICAN = 0)

                    LEFT JOIN (SELECT KHANGCAOID, LISTAGG(DM.TEN, '; ') WITHIN GROUP (ORDER BY '') TENYEUCAU
                               FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
                                   LEFT JOIN (SELECT ID,TEN FROM DM_DATAITEM) DM ON DM.ID = YC.YEUCAUID
                               GROUP BY KHANGCAOID) YCKCKN ON YCKCKN.KHANGCAOID = D.ID

                WHERE D.VUANID=VVUANID)
    LOOP
            V_DANHSACHNGUOIBIKC := '';

            IF(ITEM.NGUOIBIKC IS NOT NULL) THEN
                FOR ITEM_BC IN (SELECT REGEXP_SUBSTR(ITEM.NGUOIBIKC, '[^,]+', 1, LEVEL) BCID 
                             FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT( ITEM.NGUOIBIKC,  ',' ))
                LOOP
                    SELECT C.HOTEN INTO V_HOTEN
                    FROM   AHS_BICANBICAO C
                    WHERE  C.ID = TO_NUMBER(ITEM_BC.BCID);

                    V_DANHSACHNGUOIBIKC := V_DANHSACHNGUOIBIKC || ';' || V_HOTEN;

                END LOOP;
            END IF;

            V_ARRAY.EXTEND;
            V_ARRAY(V_ARRAY.COUNT) := R_AHS_SOTHAM_KCAOKNGHI_GETLIST(ITEM.ID, ITEM.ISKHANGCAO, ITEM.KCKNNAME,
                                                                     ITEM.NGUOIKCCAPKN, V_DANHSACHNGUOIBIKC, ITEM.LOAIKCKN, ITEM.NGAYKCKN,
                                                                     ITEM.SO_QDBA,ITEM.NGAYQDBA, ITEM.NGUOITAO, ITEM.NGAYTAO, ITEM.QUAHAN, ITEM.NGUOITAONGAYTAO,
                                                                     ITEM.SONGAY_BAQD, ITEM.TENYEUCAU, ITEM.TENFILE,
                                                                     ITEM.NOIDUNG, ITEM.TINHTRANG_GIAIQUYET, ITEM.READONLY);



    END LOOP;




    FOR ITEM IN (      
                    SELECT D.ID
                            , '2' AS ISKHANGCAO
                            ,'Kháng nghị' AS KCKNNAME
                            ,(CASE D.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) AS NGUOIKCCAPKN
                            ,d.DSNGUOIBIKN AS NGUOIBIKN
                            ,(CASE D.LOAIKN WHEN 0 THEN 'Bản án'  WHEN 1 THEN 'Quyết định' ELSE 'QĐ tạm đình chỉ/khác' END) AS LOAIKCKN
                            ,D.NGAYKN AS NGAYKCKN
                            ,(CASE D.LOAIKN WHEN 0 THEN B.SOBANAN ELSE Q.SOQUYETDINH END) AS SO_QDBA
                            ,D.NGAYBANAN AS NGAYQDBA
                            ,D.NGUOITAO
                            ,D.NGAYTAO
                            ,'' AS QUAHAN
                            ,D.NGUOITAO || ' ' || TO_CHAR(D.NGAYTAO,'dd/mm/rrrr') AS NGUOITAONGAYTAO
                            ,(CASE D.LOAIKN WHEN 0 THEN B.SOBANAN ELSE Q.SOQUYETDINH END) || '<br>' || TO_CHAR(D.NGAYBANAN,'dd/mm/rrrr') AS SONGAY_BAQD
                            ,YCKCKN.TENYEUCAU,D.TENFILE, ((CASE D.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) || ' kháng nghị ' || D.NOIDUNGKN) NOIDUNG
                            ,(CASE WHEN D.TINHTRANG_GIAIQUYET = 1 THEN 'Đã giải quyết' WHEN D.TINHTRANG_GIAIQUYET = 3 THEN 'Rút kháng nghị' ELSE '' END) AS TINHTRANG_GIAIQUYET
                            ,(CASE WHEN (IDCUOIDAGIAIQUYETKN>0 AND D.ID <= IDCUOIDAGIAIQUYETKN ) OR D.TINHTRANG_GIAIQUYET = 3 OR ISCHUYENAN = 1 THEN 1 ELSE 0 END) AS READONLY
                            ,D.TOA_GIAIQUYET_ID
                    FROM AHS_SOTHAM_KHANGNGHI D 

                        LEFT JOIN (SELECT A.VUANID,A.SOBANAN,A.ID FROM AHS_SOTHAM_BANAN A WHERE A.VUANID=VVUANID) B ON B.ID=D.BANANID AND D.LOAIKN = 0
                        LEFT JOIN (SELECT C.VUANID,C.SOQUYETDINH,C.ID, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN C WHERE C.VUANID=VVUANID
                                   UNION
                                   SELECT F.VUANID,F.SOQUYETDINH,F.ID,1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN F WHERE F.VUANID = VVUANID) Q ON Q.ID=D.BANANID AND ((D.LOAIKN = 3 AND Q.ISBICAN = 1)
                        OR D.LOAIKN IN (1,2) AND Q.ISBICAN = 0) 
                        LEFT JOIN (SELECT KHANGNGHIID, LISTAGG(DM.TEN, '; ') WITHIN GROUP (ORDER BY '') TENYEUCAU
                                    FROM AHS_SOTHAM_KHANGNGHI_YEUCAU YC
                                        LEFT JOIN (SELECT ID,TEN FROM DM_DATAITEM) DM ON DM.ID = YC.YEUCAUID
                                    GROUP BY KHANGNGHIID) YCKCKN ON YCKCKN.KHANGNGHIID = D.ID

                    WHERE D.VUANID=VVUANID)
    LOOP
            V_DANHSACHNGUOIBIKC := '';

            IF(ITEM.NGUOIBIKN IS NOT NULL) THEN
                FOR ITEM_BC IN (SELECT REGEXP_SUBSTR(ITEM.NGUOIBIKN, '[^,]+', 1, LEVEL) BCID 
                             FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT( ITEM.NGUOIBIKN,  ',' ))
                LOOP
                    SELECT C.HOTEN INTO V_HOTEN
                    FROM   AHS_BICANBICAO C
                    WHERE  C.ID = TO_NUMBER(ITEM_BC.BCID);

                    V_DANHSACHNGUOIBIKC := V_DANHSACHNGUOIBIKC || ';' || V_HOTEN;

                END LOOP;
            END IF;

            V_ARRAY.EXTEND;
            V_ARRAY(V_ARRAY.COUNT) := R_AHS_SOTHAM_KCAOKNGHI_GETLIST(ITEM.ID, ITEM.ISKHANGCAO, ITEM.KCKNNAME,
                                                                     ITEM.NGUOIKCCAPKN, V_DANHSACHNGUOIBIKC, ITEM.LOAIKCKN, ITEM.NGAYKCKN,
                                                                     ITEM.SO_QDBA, ITEM.NGAYQDBA, ITEM.NGUOITAO, ITEM.NGAYTAO , ITEM.QUAHAN, ITEM.NGUOITAONGAYTAO,
                                                                     ITEM.SONGAY_BAQD, ITEM.TENYEUCAU, ITEM.TENFILE,
                                                                     ITEM.NOIDUNG, ITEM.TINHTRANG_GIAIQUYET, ITEM.READONLY);



    END LOOP;


     OPEN curReturn FOR SELECT * FROM TABLE(V_ARRAY) T1;

END AHS_SOTHAM_KCAOKNGHI_GETLIST;