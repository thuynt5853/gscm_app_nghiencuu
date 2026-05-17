--------------------------------------------------------
--  DDL for Package PKG_GDTTT_TPB3
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_TPB3" AS

FUNCTION PHANCONGCHIDINH
    ( vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vNguoithuchien varchar2,
      vNguoithuchienID in number,
      vDs varchar,
      vLoaithamphan varchar2,
      vThamphan number
    )RETURN number;
    
FUNCTION PHANCONGNGAUNHIEN_TPB3
    ( vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vNguoithuchien number
    )RETURN number;
    
PROCEDURE DON_GETCHUAPCTP
    ( 
      vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNoiChuyen in number,
      vTrangthai in number,  
      vIsThuLy in number,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vHinhThuc in number,
      vNgayTL in date,      
      vSoThuLy in varchar2,
      vSoBAQD in varchar2,
        curReturn OUT sys_refcursor
    );
PROCEDURE get_ds_thamphan (
        vloaitp   IN VARCHAR2,
        vtoaanid  IN NUMBER,
        vphongbanid in number,
        curReturn OUT SYS_REFCURSOR
    );

PROCEDURE DON_GETTHEOKETQUAID_CHIDINH
( 
    vToaAnID in number,  
    vKetQuaID in number,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vNgayThuly in varchar2,
    vSoThuly in varchar2,
    vThamphanID in number,
    vLoaiTP varchar,
    curReturn OUT sys_refcursor
);

END PKG_GDTTT_TPB3;

/
