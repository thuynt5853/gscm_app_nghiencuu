--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_KETQUA_DON
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_KETQUA_DON" AS

 PROCEDURE GDTTT_VUAN_KETQUA_DON_GETBYID
( 
    V_ID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_DON_GETBYDONID
( 
    V_DONID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_DON_GETBYVUANKETQUAID
( 
    V_VUAN_KETQUA_ID in number,
    V_DONID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_DON_GETBYVUANID
( 
    V_VUANID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_DON_DSGiaiQuyetDon
( 
    V_VUANID in number,
    V_TYPETB in number,
    curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ
( 
    V_VUANID in number,
    V_TYPETB in number,
    V_TRANGTHAI in number,
    curReturn OUT sys_refcursor
);

PROCEDURE  GDTTT_VUAN_KETQUA_DON_UP_IN
( 
            V_ID in number,
            V_VUAN_KETQUA_ID in number,
            V_DONID in number,
            V_SO in varchar2,
            V_NGAY in date,
            V_NGUOIKY in varchar2,
            V_NGUOINHAN in varchar2,
            V_DIACHINHAN in varchar2,
            V_LOAI in number,
            V_DUONGSU_ID in number,
            V_TYPETB in number,
            V_GHICHU in varchar2,
            V_NOIDUNGKHANGNGHI in varchar2,
            V_NGAYPHATHANH in date,
            V_TRANGTHAI in number,
            V_NGAYTAO in date,
            V_THAMQUYENXXGDT in varchar2
);
PROCEDURE  GDTTT_VUAN_KETQUA_DON_DEL
( 
    v_id  in number 
);

PROCEDURE  GDTTT_VUAN_KETQUA_DON_UP_TT
( 
    v_ID  in number,
    v_TRANGTHAI in number
);

END PKG_GDTTT_VUAN_KETQUA_DON;

/
