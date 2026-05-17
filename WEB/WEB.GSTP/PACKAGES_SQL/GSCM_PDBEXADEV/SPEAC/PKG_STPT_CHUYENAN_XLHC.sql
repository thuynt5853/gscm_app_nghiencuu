--------------------------------------------------------
--  DDL for Package PKG_STPT_CHUYENAN_XLHC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_CHUYENAN_XLHC" 
AS
-- Package header
PROCEDURE COUNT_KCKN_TDC (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    );
	PROCEDURE COUNT_KN_QUAHAN (
	    VDONID   IN  NUMBER,
	    VOUT     OUT NUMBER
	);
END PKG_STPT_CHUYENAN_XLHC;

/
