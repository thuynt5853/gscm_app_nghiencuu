--------------------------------------------------------
--  DDL for Package PKG_GSTP_REPORT_HS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GSTP_REPORT_HS" AS 

/* 01-HS */
PROCEDURE AHS_01
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	); 
PROCEDURE AHS_FILL_01_ST
	(
		v_ARRAY IN OUT AHS_T_01_ADD
	);
PROCEDURE AHS_FILL_01_PT
	(
		v_ARRAY IN OUT AHS_T_01_ADD
	);

/* 02-HS */
PROCEDURE AHS_02
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	); 
PROCEDURE AHS_FILL_02_ST
	(
		v_ARRAY IN OUT AHS_T_02
	);
PROCEDURE AHS_FILL_02_PT
	(
		v_ARRAY IN OUT AHS_T_02
	);

/* 03-HS */
PROCEDURE AHS_03
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	); 
PROCEDURE AHS_FILL_03_ST
	(
		v_ARRAY IN OUT AHS_T_03
	);
PROCEDURE AHS_FILL_03_PT
	(
		v_ARRAY IN OUT AHS_T_03
	);

/* 16-HS */
PROCEDURE AHS_16
	(
		 in_VUANID IN NUMBER,
     in_MAGIAIDOAN IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	);
PROCEDURE AHS_FILL_16
	(
		v_ARRAY IN OUT AHS_T_16
	);

/* 20-HS */
PROCEDURE AHS_20
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	);
PROCEDURE AHS_FILL_20
	(
		v_ARRAY IN OUT AHS_T_20
	);

/* 21-HS */
PROCEDURE AHS_21
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	);
PROCEDURE AHS_FILL_21
	(
		v_ARRAY IN OUT AHS_T_21
	);

/* 36-HS */
PROCEDURE AHS_36
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	);
PROCEDURE AHS_FILL_36
	(
		v_ARRAY IN OUT AHS_T_36
	);

/* 37-HS */
PROCEDURE AHS_37
	(
		 in_VUANID IN NUMBER,
		 curReturn OUT SYS_REFCURSOR
	);
PROCEDURE AHS_FILL_37
	(
		v_ARRAY IN OUT AHS_T_37
	);

PROCEDURE AHS_REPORT_BM01
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM04
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM05
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM06
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM07
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM08
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_BM30
(
  vDonID number,
  curReturn OUT sys_refcursor
);

FUNCTION FUN_AHS_TOIDANH 
(
  vDONID NUMBER,
  vBICANID NUMBER
) RETURN NVARCHAR2;

PROCEDURE AHS_REPORT_ThamPhan
(
  vDonID number,
  curReturn OUT sys_refcursor
);

PROCEDURE AHS_REPORT_HoiThamND
(
  vDonID number,
  curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETHINHPHAT_BICAO_ST 
(
  BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETHINHPHAT_BICAO_PT 
(
  BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETTOIDANH_BICAO_VKS 
(
  BOLUATID IN NUMBER
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETTOIDANH_BICAO_ST 
(
  BOLUATID IN NUMBER
, BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETTOIDANH_BICAO_PT 
(
  BOLUATID IN NUMBER
, BANANID IN NUMBER 
, BICAOID IN NUMBER
, curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETDIEUKHOAN_BICAO_ST 
(
  vBoLuatID in number,
  vBanAnID in number,
  vBiCaoID in number,
  curReturn OUT sys_refcursor
);
PROCEDURE AHS_GETDIEUKHOAN_BICAO_PT 
(
  vBoLuatID in number,
  vBanAnID in number,
  vBiCaoID in number,
  curReturn OUT sys_refcursor
);

END PKG_GSTP_REPORT_HS;

/
