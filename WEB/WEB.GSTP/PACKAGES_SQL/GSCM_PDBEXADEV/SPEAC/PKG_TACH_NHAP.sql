--------------------------------------------------------
--  DDL for Package PKG_TACH_NHAP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_TACH_NHAP" AS

PROCEDURE DM_TOAAN_MAPPING_GET_BY_ID (
    P_ID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
);    

PROCEDURE DM_TOAAN_MAPPING_GETS_BY_TOTOAANID (
    P_TOTOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
);    
PROCEDURE DM_TOAAN_MAPPING_GETS_BY_TOAANID (
    P_TOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
);    
PROCEDURE DM_TOAAN_MAPPING_GETS_SAME_LEVEL (
    P_TOAANID IN NUMBER,
    P_CURSOR OUT SYS_REFCURSOR
);    
PROCEDURE DM_TOAAN_MAPPING_ADD (
    v_toaanid           IN NUMBER,
    v_loai              IN VARCHAR2,
    v_totoaanid         IN NUMBER,
    v_ngayhieuluc       IN DATE,
    v_ghichu            IN VARCHAR2,
    v_ngaytao           IN DATE,
    v_nguoitao          IN VARCHAR2
);    
PROCEDURE DM_TOAAN_MAPPING_EDIT (
        p_ID             IN NUMBER,
        p_TOAANID        IN NUMBER,
        p_TOTOAANID      IN NUMBER,
        p_NGAYHIEULUC    IN DATE,
        p_GHICHU         IN VARCHAR2
    );    
PROCEDURE DM_TOAAN_MAPPING_DELETE(v_id IN NUMBER);    


PROCEDURE DM_TOAAN_HISTORY_ADD (
    v_toaanid           IN NUMBER,
    v_totoaanid         IN NUMBER,
    v_hieuluc           IN NUMBER,
    v_ngayhieuluc       IN DATE,
    v_ngayhethieuluc    IN DATE,
    v_loai              IN VARCHAR2,
    v_ngaytao           IN DATE,
    v_nguoitao          IN VARCHAR2,
    v_hanhdong          IN VARCHAR2
);    

END PKG_TACH_NHAP;    

/
