--------------------------------------------------------
--  DDL for Package Body PKG_STPT_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_GS" AS

    PROCEDURE QLA_ST_PT_STL_GETMAXTT (
        VLOAIAN     IN VARCHAR2,
        V_THANHNIEN IN NUMBER,
        VDONVIID    IN NUMBER,
        VFROMDATE   IN DATE,
        VTODATE     IN DATE,
        CURRETURN   OUT SYS_REFCURSOR
    ) IS
        VRETURNID NUMBER;
    BEGIN  
--NVL(MAX(d.STT),0)
        IF VLOAIAN = 'ADS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   ADS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 2
        THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 1
        THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE
                                   AND ( EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_BICANBICAO BC
                                       WHERE
                                               BC.ISTREVITHANHNIEN = 1
                                           AND BC.VUANID = T.VUANID
                                   )
                                         OR EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_NGUOITHAMGIATOTUNG NTT
                                       WHERE
                                               NTT.ISTREVITHANHNIEN = 1
                                           AND NTT.VUANID = T.VUANID
                                   ) );

        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 0
        THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE
                                   AND ( NOT EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_BICANBICAO BC
                                       WHERE
                                               BC.ISTREVITHANHNIEN = 1
                                           AND BC.VUANID = T.VUANID
                                   )
                                             AND NOT EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_NGUOITHAMGIATOTUNG NTT
                                       WHERE
                                               NTT.ISTREVITHANHNIEN = 1
                                           AND NTT.VUANID = T.VUANID
                                   ) );

        ELSIF VLOAIAN = 'AHN_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHN_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHC_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'ALD_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   ALD_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AKT_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AKT_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'APS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   APS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'XLHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHULY, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   --XLHC_PHUCTHAM_THULY T 
                                   XLHC_KCKNQDK_PHUCTHAM_THULY T -- VNPT- Đinh Hoàng Sơn - chỉnh lấy số thụ lý cho PTQDK - 18-9-2025 08:00
                               WHERE
                                       T.TOAANID = VDONVIID  AND T.TOAANID=T.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        END IF;
    END QLA_ST_PT_STL_GETMAXTT;

    PROCEDURE QLA_ST_PT_CHECKSOTHONGBAOTHULY (
        VLOAIAN     IN VARCHAR2,
        VDONVIID    IN NUMBER,
        VFROMDATE   IN DATE,
        VTODATE     IN DATE,
        VSOTHONGBAO IN NVARCHAR2,
        CURRETURN   OUT SYS_REFCURSOR
    ) IS
        VRETURNID NUMBER;
    BEGIN
        IF VLOAIAN = 'ADS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   ADS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AHN_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHN_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHC_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'ALD_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   ALD_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AKT_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AKT_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'APS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   APS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID 
                                   AND T.SOTHONGBAO = VSOTHONGBAO
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        END IF;
    END QLA_ST_PT_CHECKSOTHONGBAOTHULY;

    PROCEDURE QLA_ST_PT_STBTL_GETMAXTT (
        VLOAIAN   IN VARCHAR2,
        VDONVIID  IN NUMBER,
        VFROMDATE IN DATE,
        VTODATE   IN DATE,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
        VRETURNID NUMBER;
    BEGIN  
--NVL(MAX(d.STT),0)
        IF VLOAIAN = 'ADS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   ADS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'AHN_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHN_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;

        ELSIF VLOAIAN = 'AHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AHC_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'ALD_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   ALD_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'AKT_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   AKT_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID AND t.TOAANID=t.TOA_GIAIQUYET_ID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'APS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   NVL(MAX(TO_NUMBER(REGEXP_REPLACE(T.SOTHONGBAO, '[^0-9]'))), 0)
                               INTO VRETURNID
                               FROM
                                   APS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.NGAYTHONGBAO BETWEEN VFROMDATE AND VTODATE;

        END IF;
    END QLA_ST_PT_STBTL_GETMAXTT;

    PROCEDURE QLA_ST_PT_CHECKSOTHULY (
        VLOAIAN     IN VARCHAR2,
        V_THANHNIEN IN NUMBER,
        VDONVIID    IN NUMBER,
        VFROMDATE   IN DATE,
        VTODATE     IN DATE,
        VSOTHULY    IN NVARCHAR2,
        CURRETURN   OUT SYS_REFCURSOR
    ) IS
        VRETURNID NUMBER;
    BEGIN
        IF VLOAIAN = 'ADS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   ADS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 2
        THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 1
        THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE
                                   AND ( EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_BICANBICAO BC
                                       WHERE
                                               BC.ISTREVITHANHNIEN = 1
                                           AND BC.VUANID = T.VUANID
                                   )
                                         OR EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_NGUOITHAMGIATOTUNG NTT
                                       WHERE
                                               NTT.ISTREVITHANHNIEN = 1
                                           AND NTT.VUANID = T.VUANID
                                   ) );

        ELSIF
            VLOAIAN = 'AHS_PTQDK'
            AND V_THANHNIEN = 0
        THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE
                                   AND ( NOT EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_BICANBICAO BC
                                       WHERE
                                               BC.ISTREVITHANHNIEN = 1
                                           AND BC.VUANID = T.VUANID
                                   )
                                             AND NOT EXISTS (
                                       SELECT
                                           'X'
                                       FROM
                                           AHS_NGUOITHAMGIATOTUNG NTT
                                       WHERE
                                               NTT.ISTREVITHANHNIEN = 1
                                           AND NTT.VUANID = T.VUANID
                                   ) );
        ELSIF VLOAIAN = 'AHN_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHN_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'AHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AHC_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'ALD_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   ALD_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'AKT_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   AKT_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'APS_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   APS_KCKNQDK_PHUCTHAM_THULY T
                               WHERE
                                       T.TOAANID = VDONVIID
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
        ELSIF VLOAIAN = 'XLHC_PTQDK' THEN
            OPEN CURRETURN FOR SELECT
                                   T.ID
                               INTO VRETURNID
                               FROM
                                   -- XLHC_PHUCTHAM_THULY T
                                   XLHC_KCKNQDK_PHUCTHAM_THULY T -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 17-9-2025 08:00
                               WHERE
                                       T.TOAANID = VDONVIID AND T.TOAANID = T.TOA_GIAIQUYET_ID -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID - 19-9-2025 08:00
                                   AND T.SOTHULY = VSOTHULY
                                   AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

        END IF;
    END QLA_ST_PT_CHECKSOTHULY;

END PKG_STPT_GS;

/
