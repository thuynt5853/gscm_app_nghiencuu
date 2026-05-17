--------------------------------------------------------
--  DDL for Package PKG_AHN_STPT_DS_TKQUAHAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_AHN_STPT_DS_TKQUAHAN" AS 
PROCEDURE AHN_DON_QUAHAN
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2,
    V_DS_DONID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
);
PROCEDURE AHN_DON_QUAHAN_CHITIET
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2,
    V_TK_QUAHAN_ID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
);

END PKG_AHN_STPT_DS_TKQUAHAN;

/
