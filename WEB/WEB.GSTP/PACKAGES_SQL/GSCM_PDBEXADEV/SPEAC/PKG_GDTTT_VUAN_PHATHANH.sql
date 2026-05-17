--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_PHATHANH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_PHATHANH" AS 
PROCEDURE  TONGDAT_GDKT_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_VUAN_ID in NUMBER, 
    v_GIAIDOAN in NUMBER,
    v_ID_HS_TLDON in VARCHAR2, 
    v_LOAIVB in VARCHAR2, 
    v_LOAIANID in NUMBER,
    v_TENVANBAN in VARCHAR2, 
    v_SOVB in VARCHAR2,
    v_NGAYVB in DATE,
    v_NGUOIKY in VARCHAR2,
    v_DONVIPHATHANH_ID in NUMBER, 
    v_DONVIPHATHANH in VARCHAR2, 
    v_TOAANID in NUMBER,
    v_NGAYTHUHOI in DATE,
    v_LYDOTHUHOI in VARCHAR2, 
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2,
    v_FILE_URL in VARCHAR2,
    vID out number
);
PROCEDURE  TONGDAT_GDKT_GETBYID
( 
    v_id  in number DEFAULT 0,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  TONGDAT_GDKT_DEL
( 
    v_id  in number DEFAULT 0
);

PROCEDURE  TONGDAT_GDKT_NOINHAN_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_TONGDAT_GDKT_ID in NUMBER, 
    v_DOITUONG in NUMBER,
    v_NOINHAN_ID in NUMBER, 
    v_NOINHAN in VARCHAR2, 
    v_TUCACHTOTUNG in VARCHAR2, 
    v_DIACHI in VARCHAR2, 
    v_TRANGTHAI in NUMBER,
    v_LYDO in VARCHAR2,
    v_NGAYGUI in DATE,
    v_NGAYPHATHANH in DATE, 
    v_NGAYNHAN in DATE, 
    v_HINHTHUCGUI in NUMBER,
    v_PHATHANHLAI_ID in NUMBER,
    v_IS_SUA in NUMBER,
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    vID out number
);

PROCEDURE  TONGDAT_GDKT_NOINHAN_GETBYID
( 
    v_id  in number DEFAULT 0,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  TONGDAT_GDKT_NOINHAN_DEL
( 
    v_id  in number DEFAULT 0
);

PROCEDURE  GET_VAN_BAN_PHAT_HANH
( 
    v_VuAn_ID  in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE    GET_VAN_BAN_PHAT_HANH_CHUAGUI
( 
   v_VuAn_ID in number,
   v_LoaiVBPH in varchar2,
   curReturn    OUT       sys_refcursor
);

PROCEDURE    GET_VAN_BAN_PHAT_HANH_DAGUI
( 
   v_VUANID in number,
   v_LoaiVBPH in varchar2,
   v_TrangThai in varchar2,
   curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_VAN_BAN_PHAT_HANH_NOINHAN
( 
    v_VuAn_ID  in number,
    v_HoSo_ID  in number,
    v_GiaiDoan  in varchar2,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_VBPH_NOINHAN_DOITUONG
( 
    v_VuAn_ID  in number,
    v_GiaiDoan  in varchar2,
    v_LoaiAn  in number,
    v_ThuLy  in number,
    v_IsKhangNghi in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_TONGDAT_GDKT
( 
    v_VuAn_ID  in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  GET_VBPH_NOINHAN_EDIT
( 
    v_TONGDAT_GDKT_ID  in number,
    v_Loai  in number,
    v_NOINHAN_ID in number,
    curReturn    OUT       sys_refcursor
);

PROCEDURE  THUHOI_TONGDAT_GDKT
( 
    v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2
);

PROCEDURE  TONGDAT_GDKT_DONG_MO_KHOA
( 
    v_NOI_NHAN_ID  in number,
    v_IS_SUA  in number
);

PROCEDURE TONGDAT_GDKT_NOINHAN_PHATHANH_UPD
( 
    v_ID  in number,
    v_NGAYPHATHANH  in date
);

PROCEDURE TONGDAT_GDKT_FILE_UPD
( 
    v_ID  in number,
    v_TENFILE  in varchar2,
    v_FILE_URL in varchar2
);

PROCEDURE TONGDAT_GDKT_NOINHAN_TRAKETQUA
( 
    v_ID  in number,
    v_TRANGTHAI in number DEFAULT 0,
    v_NGAYNHAN  in date,
    v_LYDO in varchar2
);

END PKG_GDTTT_VUAN_PHATHANH;

/
