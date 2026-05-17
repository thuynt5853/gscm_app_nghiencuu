--------------------------------------------------------
--  DDL for Package PKG_STPT_BAQD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_BAQD" AS 
PROCEDURE ADS_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHC_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHN_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHS_ST_BAQD_VUAN_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE AKT_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE ALD_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE APS_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHC_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHN_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE  AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE AKT_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE ALD_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE ADS_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHN_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHC_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AKT_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE ALD_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE APS_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);

PROCEDURE AHS_PT_BAQD_VUAN_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE AHS_PT_QD_VUAN_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE ADS_PHUCTHAM_QUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE AHN_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE AHC_PHUCTHAM_QUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE AKT_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE ALD_PHUCTHAM_QUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE APS_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
);
END PKG_STPT_BAQD;
