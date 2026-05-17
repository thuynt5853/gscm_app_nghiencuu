--------------------------------------------------------
--  DDL for Package PKG_DONCHOXL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DONCHOXL" AS 
PROCEDURE GET_DON_CHOXULY
(
    v_toa_an_id IN VARCHAR2,
    vNguonDen IN number,
    vNguoiGuiDon IN VARCHAR2,
    vLoaian in number,
    vSoLuongDon in number,
    vLoaiDon IN number,
    vNoiDungDon IN VARCHAR2,
    vSoDenTu in number,
    vDen in number,
    vLoaiNgay IN number,
    vTuNgay IN VARCHAR2,
    vDenNgay in VARCHAR2,
    vTrangThai in number,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_LICHSU
(
    vDonID in number,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_ADS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_AHN
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_AHC
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_AKT
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_ALD
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_APS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
PROCEDURE GET_DON_CHOXULY_GHEPDON_AHS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id in varchar2, 
    v_ten_vu_an in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,    
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
);
END PKG_DONCHOXL;
