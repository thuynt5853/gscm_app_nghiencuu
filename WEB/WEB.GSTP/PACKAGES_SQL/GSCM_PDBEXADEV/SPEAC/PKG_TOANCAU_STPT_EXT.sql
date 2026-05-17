--------------------------------------------------------
--  DDL for Package PKG_TOANCAU_STPT_EXT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_TOANCAU_STPT_EXT" AS 
PROCEDURE   AHS_NTGTT_GETBYVUANID
(
   vu_an_id in number,
   GiaiDoan in varchar2,
   PageIndex	in	int,
   PageSize	in	int,
   curReturn  OUT sys_refcursor
   
);

PROCEDURE AHS_ST_BICAO_GETALL
(
  vu_an_id IN NUMBER,CurReturn OUT sys_refcursor
);
PROCEDURE NGUOI_DD_INS
(
V_NGUOI_TGTT_ID	in	NUMBER,
P_BICAO_ID	in	VARCHAR2,
V_CHECK OUT VARCHAR2
);
PROCEDURE GET_BCBC_NGUOITGTT
(
  V_NGUOITGTT_ID IN NUMBER,
  CurReturn OUT sys_refcursor 
); 
PROCEDURE SO_DK
(
 V_DK OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_TUCACHID IN VARCHAR2

);
PROCEDURE SO_DK_HC
(
 V_DK_HC OUT NUMBER,
  VTOAANID IN VARCHAR2,
   V_CXX IN VARCHAR2
);
PROCEDURE SO_DK_ALD
(
  V_DK_ALD OUT NUMBER,
  VTOAANID IN VARCHAR2,
   V_CXX IN VARCHAR2
);


PROCEDURE SO_DK_PS
(
  V_DK_PS OUT NUMBER,
  VTOAANID IN VARCHAR2,
   V_CXX IN VARCHAR2
);


PROCEDURE SO_DK_DS
(
  V_DK_DS OUT NUMBER,
  VTOAANID IN VARCHAR2,
   v_CXX IN VARCHAR2
);


PROCEDURE SO_DK_HN
(
V_DK_HN OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_CXX IN VARCHAR2
);


PROCEDURE SO_DK_AKT
(
  V_DK_AKT OUT NUMBER,
  VTOAANID IN VARCHAR2,
 V_CXX IN VARCHAR2
);

FUNCTION  GXN_BICAO
(
 vArrSelectID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;
FUNCTION  GXN_BIHAI
(
 vArrSelectID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_DS_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_HC_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2, 
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_HN_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2, 
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_KT_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2, 
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_LD_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2, 
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

--duongph
FUNCTION  GXN_PS_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2, 
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR;

END PKG_TOANCAU_STPT_EXT;

/
