--------------------------------------------------------
--  DDL for Package PKG_HCTP_PHATHANH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_HCTP_PHATHANH" AS 

PROCEDURE TONGDAT_HCTP_INS_UPD
(
    v_ID in number DEFAULT 0,
    v_DON_ID in number,
    v_LOAIVANBAN in varchar2,
    v_TENVANBAN in varchar2,
    v_SOVB in varchar2,
    v_NGAYVB in date,
    v_NGUOIKY in varchar2,
    v_DONVIPHATHANH_ID in number,
    v_DONVIPHATHANH in varchar2,
    v_TOAANID in number,
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    v_NGAYSUA in date,
    v_NGUOISUA in varchar2,
    vID out number
);

PROCEDURE TONGDAT_HCTP_NOINHAN_INS_UPD
(
    v_ID in number DEFAULT 0,
    v_TONGDAT_HCTP_ID in number,
    v_NOINHAN_ID in number,
    v_NOINHAN in varchar2,
    v_DOITUONG in number,
    v_TUCACHTOTUNG in varchar2,
    v_DIACHI in varchar2,
    v_TRANGTHAI in number,
    v_LYDO in varchar2,
    v_NGAYGUI in date,
    v_NGAYPHATHANH in date,
    v_NGAYNHAN in date,
    v_HINHTHUCGUI in number,
    v_PHATHANHLAI_ID in number,
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    vID out number
);

PROCEDURE TONGDAT_HCTP_GETBYID
( 
    v_ID in number DEFAULT 0,
    curReturn OUT sys_refcursor
);

PROCEDURE TONGDAT_HCTP_NOINHAN_GETBYID
( 
    v_ID in number DEFAULT 0,
    curReturn OUT sys_refcursor
);

PROCEDURE TONGDAT_HCTP_DEL
( 
    v_ID in number DEFAULT 0
);

PROCEDURE TONGDAT_HCTP_FILE_UPD
( 
    v_ID  in number,
    v_TENFILE  in varchar2,
    v_FILE_URL in varchar2
);

PROCEDURE TONGDAT_HCTP_NOINHAN_PHATHANH_UPD
( 
    v_ID  in number,
    v_NGAYPHATHANH  in date
);

PROCEDURE TONGDAT_HCTP_NOINHAN_TRAKETQUA
( 
    v_ID  in number,
    v_NGAYNHAN  in date,
    v_LYDO in varchar2
);

END PKG_HCTP_PHATHANH;
