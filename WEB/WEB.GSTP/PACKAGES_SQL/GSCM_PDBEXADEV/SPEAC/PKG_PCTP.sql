--------------------------------------------------------
--  DDL for Package PKG_PCTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_PCTP" AS 
PROCEDURE TPGQD_LICHSUPHANCONG
(   vToaAnID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE TPGQD_DAPHANCONG
( vKetQuaID in number,
  vToaAnID in number,
	curReturn    OUT       sys_refcursor
);
PROCEDURE TPGQD_CHUAPHANCONG
( vToaAnID in number,
  vNgayPhanCong in date,
  vChanhAnID in number,
  vFromDate in date,
  vToDate in date,
	curReturn    OUT       sys_refcursor
);
FUNCTION TPGQD_PHANCONGNGAUNHIEN
( vToaAnID in number,
  vNgayPhanCong in date,
  vChanhAnID in number,
  vNguoithuchien number,
  vFromDate in date,
  vToDate in date,
  vChucDanh in varchar2
)RETURN number;
FUNCTION GETTENTP 
(
  vDonID IN NUMBER,
  vLoaiAn in nvarchar2,
  vMavaitro in nvarchar2,
  vLoaiTP in nvarchar2,
  vGiaidoan nvarchar2
) RETURN nvarchar2;
FUNCTION CheckIsNotGQD 
(
  vDonID IN NUMBER,
  vLoaiAn in nvarchar2,
  vMavaitro in nvarchar2
) RETURN number;
PROCEDURE CANBO_GETBYDONVI
( donviID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
);
END PKG_PCTP;

/
