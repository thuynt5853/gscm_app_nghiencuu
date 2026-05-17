--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_KETQUA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_KETQUA" AS 

 PROCEDURE GDTTT_VUAN_KETQUA_GETBYID
( 
    V_ID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GDTTT_VUAN_KETQUA_GETBYVUANID
( 
    V_VUANID in number,
	curReturn OUT sys_refcursor
);

PROCEDURE  GDTTT_VUAN_KETQUA_UP_IN
( 
            V_ID in number,
            V_VUANID  in number,
            V_TRANGTHAI in number,
            V_NOIDUNGKHANGNGHI in varchar2,
            V_TOAAN_ID in number,
            V_CAPNHATVUAN in number,
            V_NGUOIKHANGNGHI in number,
            V_GQD_LOAIKETQUA in number,
            V_GQD_KETQUA in varchar2,
            V_GDQ_SO in varchar2,
            V_GDQ_NGAY in date,
            V_GDQ_NGUOIKY in varchar2,
            V_THAMQUYENXXGDT in number,
            V_QUATRINH_GHICHU in varchar2,
            V_GQD_GHICHU in varchar2,
            V_GQD_ISHOANTHA in number,
            V_GQD_HOANTHA_NGUOIKYID in number,
            V_GQD_HOANTHA_NGAY in date,
            V_GQD_HOANTHA_SO in varchar2,
            V_GQD_NGAYPHATHANHCV in date,
            V_NGAYTAO in date
);

PROCEDURE  GDTTT_VUAN_KETQUA_INSERT
( 
            V_ID in number,
            V_VUANID  in number,
            V_TRANGTHAI in number,
            V_NOIDUNGKHANGNGHI in varchar2,
            V_TOAAN_ID in number,
            V_CAPNHATVUAN in number,
            V_NGUOIKHANGNGHI in number,
            V_GQD_LOAIKETQUA in number,
            V_GQD_KETQUA in varchar2,
            V_GDQ_SO in varchar2,
            V_GDQ_NGAY in date,
            V_GDQ_NGUOIKY in varchar2,
            V_THAMQUYENXXGDT in number,
            V_QUATRINH_GHICHU in varchar2,
            V_GQD_GHICHU in varchar2,
            V_GQD_ISHOANTHA in number,
            V_GQD_HOANTHA_NGUOIKYID in number,
            V_GQD_HOANTHA_NGAY in date,
            V_GQD_HOANTHA_SO in varchar2,
            V_GQD_NGAYPHATHANHCV in date,
            V_NGAYTAO in date
);

PROCEDURE  GDTTT_VUAN_KETQUA_DEL
( 
    v_id  in number 
);

PROCEDURE  GDTTT_VUAN_KETQUA_CAPNHATVUAN
( 
    v_ID  in number,
    v_CAPNHATVUAN in number
);

PROCEDURE  GDTTT_VUAN_KETQUA_UP_TT
( 
    v_ID  in number,
    v_TRANGTHAI in number
);

END PKG_GDTTT_VUAN_KETQUA;

/
