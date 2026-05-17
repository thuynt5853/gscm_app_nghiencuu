--------------------------------------------------------
--  DDL for Package Body PKG_STPT_CHUYENAN_XLHC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_CHUYENAN_XLHC" 
AS
-- Package body
	PROCEDURE COUNT_KCKN_TDC (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    ) AS
        LCOUNTKC   NUMBER;
        LCOUNTKN   NUMBER;
    BEGIN
        SELECT
            COUNT(KC.ID)
        INTO LCOUNTKC
        FROM
            XLHC_SOTHAM_KHANGCAO KC
--            LEFT JOIN XLHC_SOTHAM_QUYETDINH  QD ON QD.ID = KC.SOQDBA
            LEFT JOIN DM_QD_QUYETDINH        DM ON DM.ID = KC.SOQDBA
        WHERE
            DM.MA IN (
                '06-BPXLHC-TĐC'
            ) 
            AND (KC.ISQUAHAN = 0 OR (KC.ISQUAHAN = 1 AND KC.GQ_ISCHAPNHAN = 1))
            -- 31072025 check bo qua kc tdc da duyet
            AND KC.GQ_TINHTRANG != 3
            AND KC.DONID = VDONID;

        VOUT := NVL(LCOUNTKC, 0);
    END;

    PROCEDURE COUNT_KN_QUAHAN (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    ) AS
        LCOUNTKN   NUMBER;
    BEGIN
        SELECT
            COUNT(QD.ID)
        INTO LCOUNTKN
        FROM
            KHANGCAOQUAHAN_QUYETDINH QD
        WHERE
        	QD.KETQUA = 1
            AND QD.DONID = VDONID;

        VOUT := NVL(LCOUNTKN, 0);
    END;

END PKG_STPT_CHUYENAN_XLHC;

/
