--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP_PHATHANH_BACKUP261123
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP_PHATHANH_BACKUP261123" AS 
PROCEDURE GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,   
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
);
PROCEDURE GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,   
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
);
PROCEDURE GDTTT_HCTP_PHATHANH_DON_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,  
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
);
PROCEDURE  GET_VAN_BAN_PHAT_HANH
( 
    vID  in number,
    vLoaiVB in number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  GET_VBPH_NOINHAN_DOITUONG
( 
    vID  in number,
    vLoaiVB in number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  GET_VBPH_NOINHAN_DOITUONG_EDIT
( 
    v_TONGDAT_HCTP_ID  in number,
    v_NOINHAN_ID in number,
    curReturn    OUT       sys_refcursor
);
PROCEDURE  THUHOI_TONGDAT_HCTP
( 
    v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2
);
END PKG_GDTTT_HCTP_PHATHANH_BACKUP261123;
