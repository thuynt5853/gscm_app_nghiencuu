--------------------------------------------------------
--  DDL for Package PKG_STPT_QLCS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_QLCS" AS
PROCEDURE QLA_ST_PT_CheckSoQD
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoQD in varchar2,
  vLoaiQD in  varchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE QLA_ST_PT_GetSoQDnew
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vLoaiQD in  varchar2,
	curReturn    OUT       sys_refcursor
);
PROCEDURE QLA_ST_PT_CheckSoBA
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoBA in nvarchar2,
	curReturn    OUT       sys_refcursor
); 
PROCEDURE QLA_ST_PT_GETSoBA_NEW
(   vLoaiAn in varchar2,
    vdonviID in number,
    vFromDate in DATE,
    vToDate in DATE,
    curReturn    OUT       sys_refcursor
);
PROCEDURE QLA_ST_PT_CheckSoThuLy
( vLoaiAn in varchar2,
  v_thanhnien in number,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoThuLy in nvarchar2,
	curReturn    OUT       sys_refcursor
); 
PROCEDURE   QLA_ST_PT_STL_GETMAXTT
( vLoaiAn in varchar2,
  v_thanhnien in number,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
	curReturn    OUT       sys_refcursor
);

PROCEDURE QLA_ST_PT_CheckSoThongBaoThuLy
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSothongbao in nvarchar2,
	curReturn    OUT       sys_refcursor
); 
PROCEDURE   QLA_ST_PT_STBTL_GETMAXTT
(   vLoaiAn in varchar2,
    vdonviID in number,
    vFromDate in DATE,
    vToDate in DATE,
    curReturn    OUT       sys_refcursor
);
PROCEDURE   QLA_ST_PT_STB_XLDON_GETMAXTT
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  curReturn    OUT   sys_refcursor
);
PROCEDURE   QLA_ST_PT_STB_ANPHI_GETMAXTT
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  curReturn    OUT   sys_refcursor
);
PROCEDURE   QLA_ST_PT_STB_XLDON_GETMAXTT_V2
    ( vLoaiAn in varchar2,
      vdonviID in number,
      vFromDate in DATE,
      vToDate in DATE,
      curReturn    OUT   sys_refcursor
    );    
 PROCEDURE QLA_ST_PT_CheckSoThongBaoThuLy_V2
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSothongbao in nvarchar2,
	curReturn    OUT       sys_refcursor
);   
PROCEDURE   QLA_ST_PT_STBTL_GETMAXTT_V2
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  curReturn    OUT   sys_refcursor
);
END PKG_STPT_QLCS;

/
