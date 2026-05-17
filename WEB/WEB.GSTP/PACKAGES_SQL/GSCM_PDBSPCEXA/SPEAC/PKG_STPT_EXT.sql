--------------------------------------------------------
--  DDL for Package PKG_STPT_EXT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_EXT" AS
PROCEDURE   AHS_NTGTT_GETBYVUANID
(
   vu_an_id in number,
   GiaiDoan in varchar2,
   PageIndex	in	int,
   PageSize	in	int,
   curReturn  OUT sys_refcursor
);
PROCEDURE     AHS_PT_BICAO_GETALL
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
  VTOAANID IN VARCHAR2,
  V_TUCACHID IN VARCHAR2,
  V_DK OUT NUMBER
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
END PKG_STPT_EXT;
