--------------------------------------------------------
--  DDL for Package PKG_NHAP_TACH_DONVI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_NHAP_TACH_DONVI" AS 

PROCEDURE GDTTT_DANHSACH_VUAN_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,  
  vLoaiAn in number,    
  vKetquathuly in number,  
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_DANHSACH_VUAN_NHAN
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,  
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);
FUNCTION CREATE_MA_NHAPTACH_RANDOM
(
  V_MALANCHUYEN OUT VARCHAR2
) 
RETURN  VARCHAR2;

PROCEDURE NHAP_TACH_DONVI_IN
(
    V_KetQuaQG IN NUMBER,
    V_TOAANID IN NUMBER,
    V_DONVIMOI IN NUMBER,
    V_DONVICU IN NUMBER,
    V_LYDO IN VARCHAR2,
    V_GHICHU IN VARCHAR2,
    V_DANHSACH IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_TAIKHOANTAO IN VARCHAR2
);
PROCEDURE DM_TOAAN_GET_GDTTT
( vAdmin in number,
  vdonviID in number,
  vloaitoa in varchar2,
	curReturn    OUT       sys_refcursor
);
END PKG_NHAP_TACH_DONVI;

/
