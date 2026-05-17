--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_KETQUA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_KETQUA" AS

  PROCEDURE  GDTTT_VUAN_KETQUA_GETBYID
(
     V_ID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua V WHERE (V.ID = V_ID or V.VUANID = V_ID) and V.TRANGTHAI = 1 order by  V.NGAYTAO DESC;
END GDTTT_VUAN_KETQUA_GETBYID;

PROCEDURE  GDTTT_VUAN_KETQUA_GETBYVUANID
(
     V_VUANID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua V WHERE V.VUANID = V_VUANID and V.TRANGTHAI = 1 order by  V.NGAYTAO DESC;
END GDTTT_VUAN_KETQUA_GETBYVUANID; 

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
) IS
  BEGIN
    if (V_ID >0) then
            update gdttt_vuan_ketqua
                    set
                        VUANID = V_VUANID,
                        TRANGTHAI = V_TRANGTHAI,
                        NOIDUNGKHANGNGHI = V_NOIDUNGKHANGNGHI,
                        TOAAN_ID = V_TOAAN_ID,
                        CAPNHATVUAN = V_CAPNHATVUAN,
                        NGUOIKHANGNGHI = V_NGUOIKHANGNGHI,
                        GQD_LOAIKETQUA = V_GQD_LOAIKETQUA,
                        GQD_KETQUA = V_GQD_KETQUA,
                        GDQ_SO = V_GDQ_SO,
                        GDQ_NGAY = V_GDQ_NGAY,
                        GDQ_NGUOIKY = V_GDQ_NGUOIKY,
                        THAMQUYENXXGDT = V_THAMQUYENXXGDT,
                        QUATRINH_GHICHU = V_QUATRINH_GHICHU,
                        GQD_GHICHU = V_GQD_GHICHU,
                        GQD_ISHOANTHA = V_GQD_ISHOANTHA,
                        GQD_HOANTHA_NGUOIKYID = V_GQD_HOANTHA_NGUOIKYID,
                        GQD_HOANTHA_NGAY = V_GQD_HOANTHA_NGAY,
                        GQD_HOANTHA_SO = V_GQD_HOANTHA_SO,
                        GQD_NGAYPHATHANHCV = V_GQD_NGAYPHATHANHCV
                    where ID = V_ID and VUANID = V_VUANID;   
        else
            insert into gdttt_vuan_ketqua 
            (
                ID,
                VUANID,
                TRANGTHAI,
                NOIDUNGKHANGNGHI,
                TOAAN_ID,
                CAPNHATVUAN,
                NGUOIKHANGNGHI,
                GQD_LOAIKETQUA,
                GQD_KETQUA,
                GDQ_SO,
                GDQ_NGAY,
                GDQ_NGUOIKY,
                THAMQUYENXXGDT,
                QUATRINH_GHICHU,
                GQD_GHICHU,
                GQD_ISHOANTHA,
                GQD_HOANTHA_NGUOIKYID,
                GQD_HOANTHA_NGAY,
                GQD_HOANTHA_SO,
                GQD_NGAYPHATHANHCV,
                NGAYTAO
            )
            values 
            (   
                V_ID,
                V_VUANID,
                V_TRANGTHAI,
                V_NOIDUNGKHANGNGHI,
                V_TOAAN_ID,
                V_CAPNHATVUAN,
                V_NGUOIKHANGNGHI,
                V_GQD_LOAIKETQUA,
                V_GQD_KETQUA,
                V_GDQ_SO,
                V_GDQ_NGAY,
                V_GDQ_NGUOIKY,
                V_THAMQUYENXXGDT,
                V_QUATRINH_GHICHU,
                V_GQD_GHICHU,
                V_GQD_ISHOANTHA,
                V_GQD_HOANTHA_NGUOIKYID,
                V_GQD_HOANTHA_NGAY,
                V_GQD_HOANTHA_SO,
                V_GQD_NGAYPHATHANHCV,
                V_NGAYTAO
            );

        end if;
  END GDTTT_VUAN_KETQUA_UP_IN; 

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
) IS
  BEGIN
    if (V_ID >0) then
            insert into gdttt_vuan_ketqua 
            (
                ID,
                VUANID,
                TRANGTHAI,
                NOIDUNGKHANGNGHI,
                TOAAN_ID,
                CAPNHATVUAN,
                NGUOIKHANGNGHI,
                GQD_LOAIKETQUA,
                GQD_KETQUA,
                GDQ_SO,
                GDQ_NGAY,
                GDQ_NGUOIKY,
                THAMQUYENXXGDT,
                QUATRINH_GHICHU,
                GQD_GHICHU,
                GQD_ISHOANTHA,
                GQD_HOANTHA_NGUOIKYID,
                GQD_HOANTHA_NGAY,
                GQD_HOANTHA_SO,
                GQD_NGAYPHATHANHCV,
                NGAYTAO
            )
            values 
            (   
                V_ID,
                V_VUANID,
                V_TRANGTHAI,
                V_NOIDUNGKHANGNGHI,
                V_TOAAN_ID,
                V_CAPNHATVUAN,
                V_NGUOIKHANGNGHI,
                V_GQD_LOAIKETQUA,
                V_GQD_KETQUA,
                V_GDQ_SO,
                V_GDQ_NGAY,
                V_GDQ_NGUOIKY,
                V_THAMQUYENXXGDT,
                V_QUATRINH_GHICHU,
                V_GQD_GHICHU,
                V_GQD_ISHOANTHA,
                V_GQD_HOANTHA_NGUOIKYID,
                V_GQD_HOANTHA_NGAY,
                V_GQD_HOANTHA_SO,
                V_GQD_NGAYPHATHANHCV,
                V_NGAYTAO
            );

        end if;
  END GDTTT_VUAN_KETQUA_INSERT;  

  PROCEDURE  GDTTT_VUAN_KETQUA_DEL
( 
    v_id  in number 
) IS
  BEGIN
    if (v_id >0) then
            DELETE gdttt_vuan_ketqua where ID = v_id ;   
        end if;
  END GDTTT_VUAN_KETQUA_DEL;

  PROCEDURE  GDTTT_VUAN_KETQUA_CAPNHATVUAN
( 
    v_ID  in number ,
    v_CAPNHATVUAN  in number 
) IS
  BEGIN
  update gdttt_vuan_ketqua
                    set
                        CAPNHATVUAN = v_CAPNHATVUAN
                    where ID = v_ID;   
  END GDTTT_VUAN_KETQUA_CAPNHATVUAN;

  PROCEDURE  GDTTT_VUAN_KETQUA_UP_TT
( 
    v_ID  in number ,
    v_TRANGTHAI  in number 
) IS
  BEGIN
  update gdttt_vuan_ketqua
                    set
                        TRANGTHAI = v_TRANGTHAI
                    where ID = v_ID;   
  END GDTTT_VUAN_KETQUA_UP_TT;

END PKG_GDTTT_VUAN_KETQUA;

/
