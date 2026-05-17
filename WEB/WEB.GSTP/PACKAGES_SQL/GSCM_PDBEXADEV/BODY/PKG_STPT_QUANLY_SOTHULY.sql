--------------------------------------------------------
--  DDL for Package Body PKG_STPT_QUANLY_SOTHULY
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_QUANLY_SOTHULY" AS

PROCEDURE GET_LATEST_DATE_IN_SOTHULY
(
  in_MAGIAIDOAN IN NUMBER,
  in_LOAIAN IN NUMBER,
  in_TOAAN_ID IN NUMBER,
  in_NGAYTHULY IN VARCHAR2,
  CURRETURN               OUT   SYS_REFCURSOR
)
AS
    NGAYLONNHATCODULIEU DATE;
    in_YEAR NUMBER;
BEGIN

    SELECT EXTRACT(YEAR FROM TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY')) INTO in_YEAR
    FROM DUAL;

    IF (in_MAGIAIDOAN = 2) THEN
            IF(in_LOAIAN = 1) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHS_SOTHAM_THULY
                            INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 2) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ADS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 3) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHN_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 4) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AKT_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 5) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ALD_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 6) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHC_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 7) THEN
                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM APS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

            END IF;

    ELSIF(in_MAGIAIDOAN = 3) THEN


            IF(in_LOAIAN = 1) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHS_SOTHAM_THULY
                            INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 2) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ADS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                ELSIF(in_LOAIAN = 3) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHN_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 4) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AKT_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                ELSIF(in_LOAIAN = 5) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ALD_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                    ELSIF(in_LOAIAN = 6) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHC_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                    ELSIF(in_LOAIAN = 7) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM APS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                END IF;

    END IF;

    OPEN CURRETURN FOR SELECT NGAYLONNHATCODULIEU AS RESULT_QUERY FROM DUAL;

END GET_LATEST_DATE_IN_SOTHULY;


PROCEDURE GET_STPT_QUANLY_SOTHULY_THEONGAY_SOTHAM
(
  in_MAGIAIDOAN IN NUMBER,
  in_LOAIAN IN NUMBER,
  in_TOAAN_ID IN NUMBER,
  in_NGAYTHULY IN VARCHAR2,
  CURRETURN               OUT   SYS_REFCURSOR

)
AS
    NGAYLONNHATCODULIEU DATE;
    in_YEAR NUMBER;

    CHECK_COUNT NUMBER DEFAULT 0;
    NGAYGANNHATCODULIEU DATE;
BEGIN
     --Lấy ngày gần nhất có thụ lý
    IF (in_MAGIAIDOAN = 2) THEN
            IF(in_LOAIAN = 1) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHS_SOTHAM_THULY
                            INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 2) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ADS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 3) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHN_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 4) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AKT_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 5) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ALD_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 6) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHC_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 7) THEN
                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM APS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

            END IF;

    ELSIF(in_MAGIAIDOAN = 3) THEN


            IF(in_LOAIAN = 1) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHS_SOTHAM_THULY
                            INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 2) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ADS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                ELSIF(in_LOAIAN = 3) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHN_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                ELSIF(in_LOAIAN = 4) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AKT_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                ELSIF(in_LOAIAN = 5) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM ALD_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                    ELSIF(in_LOAIAN = 6) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM AHC_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);


                    ELSIF(in_LOAIAN = 7) THEN

                            SELECT MAX(NGAYTHULY) INTO NGAYLONNHATCODULIEU
                            FROM APS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND in_YEAR = EXTRACT(YEAR FROM NGAYTHULY);

                END IF;

    END IF;


    --Kiểm tra có số thụ lý trống hay không
    SELECT COUNT(*) INTO CHECK_COUNT
    FROM GSCM.STPT_QUANLY_SOTHULY STL
    WHERE STL.MAGIAIDOAN = in_MAGIAIDOAN AND STL.LOAIAN = in_LOAIAN 
                                         AND STL.TOAAN_ID = in_TOAAN_ID 
                                         AND STL.NGAYTHULY LIKE TO_DATE(in_NGAYTHULY,'DD/MM/YYYY')
                                         AND STL.ACTIVE = 1;

    IF (CHECK_COUNT > 0 OR (TO_DATE(in_NGAYTHULY,'DD/MM/YYYY') > NGAYLONNHATCODULIEU AND CHECK_COUNT = 0)) THEN
            OPEN CURRETURN FOR 
                --Lấy số thụ lý trống nếu có
                SELECT DISTINCT(SOTHULY) SOTHULY
                FROM (SELECT regexp_replace(SOTHULY, '[^0-9]', '') SOTHULY
                        FROM STPT_QUANLY_SOTHULY STL
                        WHERE STL.MAGIAIDOAN = in_MAGIAIDOAN AND STL.LOAIAN = in_LOAIAN 
                                             AND STL.TOAAN_ID = in_TOAAN_ID 
                                             AND STL.NGAYTHULY LIKE TO_DATE(in_NGAYTHULY,'DD/MM/YYYY')
                                             AND STL.ACTIVE = 1)
                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
        ELSE
            --Nếu không có số thụ lý trống thì ...
            IF(in_LOAIAN = 1) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHS_SOTHAM_THULY STL
                            INNER JOIN AHS_VUAN VA ON VA.ID = STL.VUANID
                        WHERE VA.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                        --Lấy các số thụ lý trong ngày nếu ngày đó có thụ lý
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHS_SOTHAM_THULY STL
                                            INNER JOIN AHS_VUAN VA ON VA.ID = STL.VUANID
                                        WHERE VA.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                        --Lấy ngày gần nhất có thụ lý nếu ngày đó không thụ lý
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHS_SOTHAM_THULY
                                INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHS_SOTHAM_THULY STL
                                            INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                                        WHERE VA.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 2) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  ADS_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ADS_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM ADS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ADS_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 3) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHN_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHN_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHN_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHN_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 4) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AKT_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AKT_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AKT_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AKT_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 5) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  ALD_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN         
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ALD_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM ALD_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ALD_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 6) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHC_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHC_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHC_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHC_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 7) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  APS_SOTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  APS_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM APS_SOTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  APS_SOTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;


            END IF;

    END IF;



END GET_STPT_QUANLY_SOTHULY_THEONGAY_SOTHAM;

PROCEDURE GET_STPT_QUANLY_SOTHULY_THEONGAY_PHUCTHAM
(
  in_MAGIAIDOAN IN NUMBER,
  in_LOAIAN IN NUMBER,
  in_TOAAN_ID IN NUMBER,
  in_NGAYTHULY IN VARCHAR2,
  CURRETURN               OUT   SYS_REFCURSOR
)
AS
    CHECK_COUNT NUMBER DEFAULT 0;
    NGAYGANNHATCODULIEU DATE;
BEGIN


    SELECT COUNT(*) INTO CHECK_COUNT
    FROM GSCM.STPT_QUANLY_SOTHULY STL
    WHERE STL.MAGIAIDOAN = in_MAGIAIDOAN AND STL.LOAIAN = in_LOAIAN 
                                         AND STL.TOAAN_ID = in_TOAAN_ID 
                                         AND STL.NGAYTHULY LIKE TO_DATE(in_NGAYTHULY,'DD/MM/YYYY')
                                         AND STL.ACTIVE = 1;

    IF (CHECK_COUNT > 0) THEN
            OPEN CURRETURN FOR 
                SELECT DISTINCT(SOTHULY) SOTHULY
                FROM (SELECT regexp_replace(SOTHULY, '[^0-9]', '') SOTHULY
                        FROM STPT_QUANLY_SOTHULY STL
                        WHERE STL.MAGIAIDOAN = in_MAGIAIDOAN AND STL.LOAIAN = in_LOAIAN 
                                             AND STL.TOAAN_ID = in_TOAAN_ID 
                                             AND STL.NGAYTHULY LIKE TO_DATE(in_NGAYTHULY,'DD/MM/YYYY')
                                             AND STL.ACTIVE = 1);
        ELSE
            IF(in_LOAIAN = 1) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHS_PHUCTHAM_THULY STL
                            INNER JOIN AHS_VUAN VA ON VA.ID = STL.VUANID
                        WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHS_PHUCTHAM_THULY STL
                                            INNER JOIN AHS_VUAN VA ON VA.ID = STL.VUANID
                                        WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHS_PHUCTHAM_THULY
                                INNER JOIN AHS_VUAN VA ON VA.ID = VUANID
                            WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHS_PHUCTHAM_THULY STL
                                            INNER JOIN AHS_VUAN VA ON VA.ID = STL.VUANID
                                        WHERE VA.TOAPHUCTHAMID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 2) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  ADS_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ADS_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM ADS_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ADS_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 3) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHN_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHN_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHN_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHN_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 4) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AKT_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AKT_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AKT_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AKT_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 5) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  ALD_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ALD_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM ALD_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  ALD_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 6) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  AHC_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHC_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM AHC_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  AHC_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;

                ELSIF(in_LOAIAN = 7) THEN

                        SELECT COUNT(*) INTO CHECK_COUNT
                        FROM  APS_PHUCTHAM_THULY STL
                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY');

                        IF(CHECK_COUNT > 0) THEN
                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  APS_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = TO_DATE(in_NGAYTHULY,'DD/MM/YYYY'))
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;
                        ELSE
                            SELECT MAX(NGAYTHULY) INTO NGAYGANNHATCODULIEU
                            FROM APS_PHUCTHAM_THULY
                            WHERE TOAANID = in_TOAAN_ID AND NGAYTHULY < TO_DATE(in_NGAYTHULY, 'DD/MM/YYYY');

                            OPEN CURRETURN FOR 
                                SELECT DISTINCT(SOTHULY) SOTHULY
                                FROM (SELECT regexp_replace(STL.SOTHULY, '[^0-9]', '') SOTHULY
                                        FROM  APS_PHUCTHAM_THULY STL
                                        WHERE STL.TOAANID = in_TOAAN_ID AND STL.NGAYTHULY = NGAYGANNHATCODULIEU)
                                ORDER BY LENGTH(SOTHULY) ASC, SOTHULY ASC;

                        END IF;


            END IF;

    END IF;

END GET_STPT_QUANLY_SOTHULY_THEONGAY_PHUCTHAM;

PROCEDURE UPDATE_STPT_QUANLY_SOTHULY_THEOSOTHULYVANAM
(
  in_MAGIAIDOAN IN NUMBER,
  in_LOAIAN IN NUMBER,
  in_TOAAN_ID IN NUMBER,
  in_NGAYTHULY IN VARCHAR2,
  in_SOTHULY IN VARCHAR2,
  CURRETURN               OUT   SYS_REFCURSOR
)
AS

BEGIN

    UPDATE STPT_QUANLY_SOTHULY SET ACTIVE = 0 WHERE MAGIAIDOAN = in_MAGIAIDOAN 
                                                AND LOAIAN = in_LOAIAN 
                                                AND TOAAN_ID = in_TOAAN_ID 
                                                AND SOTHULY = in_SOTHULY 
                                                AND ACTIVE = 1
                                                AND EXTRACT(YEAR FROM  NGAYTHULY) = EXTRACT(YEAR FROM to_date(in_NGAYTHULY,'dd/mm/yyyy') );

    COMMIT;

    OPEN CURRETURN FOR SELECT 1 AS RESULT_QUERY FROM DUAL;

END UPDATE_STPT_QUANLY_SOTHULY_THEOSOTHULYVANAM;



END PKG_STPT_QUANLY_SOTHULY;

/
