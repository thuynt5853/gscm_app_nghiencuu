--------------------------------------------------------
--  DDL for Package PKG_LOAD_DM_QDVUAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_LOAD_DM_QDVUAN" AS

--------------SƠ THẨM-------------
PROCEDURE ADS_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHC_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHN_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHS_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AKT_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE ALD_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE APS_DM_QUYETDINH_VUAN
(
    curReturn OUT SYS_REFCURSOR
);
----------------------------------

-------------PHÚC THẨM------------
PROCEDURE ADS_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHC_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHN_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AHS_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE AKT_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE ALD_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
PROCEDURE APS_DM_QUYETDINH_VUAN_PT
(
    curReturn OUT SYS_REFCURSOR
);
----------------------------------


-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định vụ án/vụ việc)------------
PROCEDURE DGLIST_QUYETDINH_PT
(
    VLOAIAN VARCHAR2,
    VDONID NUMBER,
    curReturn OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------

-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định bị can/bị cáo)------------
PROCEDURE DGLIST_QUYETDINH_BICAN_PT
(
    VLOAIAN VARCHAR2,
    VDONID NUMBER,
    curReturn OUT SYS_REFCURSOR
);
------------------------------------------------------------------------------------


END PKG_LOAD_DM_QDVUAN;
