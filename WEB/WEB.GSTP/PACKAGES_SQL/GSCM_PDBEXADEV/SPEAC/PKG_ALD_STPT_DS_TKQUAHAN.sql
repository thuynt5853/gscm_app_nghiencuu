--------------------------------------------------------
--  DDL for Package PKG_ALD_STPT_DS_TKQUAHAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_ALD_STPT_DS_TKQUAHAN" AS 
PROCEDURE ALD_DON_QUAHAN
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2,
    V_DS_DONID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
);
PROCEDURE ALD_DON_QUAHAN_CHITIET
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2,
    V_TK_QUAHAN_ID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
);

END PKG_ALD_STPT_DS_TKQUAHAN;

/
