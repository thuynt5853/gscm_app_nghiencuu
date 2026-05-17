--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_KETQUA_DON
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_KETQUA_DON" AS

  PROCEDURE  GDTTT_VUAN_KETQUA_DON_GETBYID
(
     V_ID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua_don V WHERE (V.ID = V_ID) and V.TRANGTHAI = 1;
END GDTTT_VUAN_KETQUA_DON_GETBYID;

PROCEDURE  GDTTT_VUAN_KETQUA_DON_GETBYDONID
(
     V_DONID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua_don V WHERE (V.DONID = V_DONID) and V.TRANGTHAI = 1;
END GDTTT_VUAN_KETQUA_DON_GETBYDONID;

PROCEDURE  GDTTT_VUAN_KETQUA_DON_GETBYVUANKETQUAID
(
     V_VUAN_KETQUA_ID IN number,  
     V_DONID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua_don V WHERE V.VUAN_KETQUA_ID = V_VUAN_KETQUA_ID and V.DONID = V_DONID and V.TRANGTHAI = 1;
END GDTTT_VUAN_KETQUA_DON_GETBYVUANKETQUAID;

PROCEDURE  GDTTT_VUAN_KETQUA_DON_GETBYVUANID
(
     V_VUANID IN number,  
     curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM gdttt_vuan_ketqua_don V 
        inner join gdttt_vuan_ketqua k on k.ID = V.vuan_ketqua_id
        WHERE (k.VUANID = V_VUANID) and V.TRANGTHAI = 1;
END GDTTT_VUAN_KETQUA_DON_GETBYVUANID;

  PROCEDURE GDTTT_VUAN_KETQUA_DON_DSGiaiQuyetDon
( 
    V_VUANID in number,
    V_TYPETB in number,
	curReturn OUT sys_refcursor
) IS
  BEGIN   
    OPEN curReturn FOR
    select a.*, b.TL_So 
     , case when (Length(NVL(b.TL_Ngay,''))=0 or (to_char(b.TL_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(b.TL_Ngay,'')) >0 then to_char(b.TL_Ngay,'dd/MM/yyyy')
                        end  TL_Ngay  
    from gdttt_vuan_ketqua_don a 
      left join (select ID, TL_NGAY, TL_So from GDTTT_don where CD_TRANGTHAI=2) b on a.donid = b.ID
    where (a.VUAN_KETQUA_ID = V_VUANID or a.DONID = V_VUANID or a.ID = V_VUANID ) and a.TypeTB = V_TYPETB and a.TRANGTHAI = 1;

  END GDTTT_VUAN_KETQUA_DON_DSGiaiQuyetDon;

  PROCEDURE GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ
( 
    V_VUANID in number,
    V_TYPETB in number,
    V_TRANGTHAI in number,
	curReturn OUT sys_refcursor
) IS
  BEGIN  
    OPEN curReturn FOR
    select a.*, b.TL_So 
     , case when (Length(NVL(b.TL_Ngay,''))=0 or (to_char(b.TL_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(b.TL_Ngay,'')) >0 then to_char(b.TL_Ngay,'dd/MM/yyyy')
                        end  TL_Ngay  
    from gdttt_vuan_ketqua_don a 
      left join (select ID, TL_NGAY, TL_So from GDTTT_don where CD_TRANGTHAI=2) b on a.donid = b.ID
      inner join GDTTT_VUAN_KETQUA c on c.ID = a.VUAN_KETQUA_ID
    where C.VUANID =V_VUANID
    and a.TYPETB = V_TYPETB 
    and a.TRANGTHAI = V_TRANGTHAI;

  END GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ;

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
) IS
  BEGIN
    if (V_ID >0) then
            update gdttt_vuan_ketqua_don
                    set
                        SO = V_SO,
                        NGAY = V_NGAY,
                        NGUOIKY = V_NGUOIKY,
                        NGUOINHAN = V_NGUOINHAN,
                        DIACHINHAN = V_DIACHINHAN,
                        LOAI = V_LOAI,
                        DUONGSU_ID = V_DUONGSU_ID,
                        TYPETB = V_TYPETB,
                        GHICHU = V_GHICHU,
                        NOIDUNGKHANGNGHI = V_NOIDUNGKHANGNGHI,
                        NGAYPHATHANH = V_NGAYPHATHANH,
                        TRANGTHAI = V_TRANGTHAI,
                        THAMQUYENXXGDT = V_THAMQUYENXXGDT
                    where ID = V_ID;   
        else
            insert into gdttt_vuan_ketqua_don 
            (
                --ID,
                VUAN_KETQUA_ID,
                DONID,
                SO,
                NGAY,
                NGUOIKY,
                NGUOINHAN,
                DIACHINHAN,
                LOAI,
                DUONGSU_ID,
                TYPETB,
                GHICHU,
                NOIDUNGKHANGNGHI,
                NGAYPHATHANH,
                TRANGTHAI,
                NGAYTAO,
                THAMQUYENXXGDT
            )
            values 
            (   
                --V_ID,
                V_VUAN_KETQUA_ID,
                V_DONID,
                V_SO,
                V_NGAY,
                V_NGUOIKY,
                V_NGUOINHAN,
                V_DIACHINHAN,
                V_LOAI,
                V_DUONGSU_ID,
                V_TYPETB,
                V_GHICHU,
                V_NOIDUNGKHANGNGHI,
                V_NGAYPHATHANH,
                V_TRANGTHAI,
                V_NGAYTAO,
                V_THAMQUYENXXGDT
            );

        end if;
  END GDTTT_VUAN_KETQUA_DON_UP_IN; 

  PROCEDURE  GDTTT_VUAN_KETQUA_DON_DEL
( 
    v_id  in number 
) IS
  BEGIN
    if (v_id >0) then
            DELETE gdttt_vuan_ketqua_don where ID = v_id ;   
        end if;
  END GDTTT_VUAN_KETQUA_DON_DEL;

  PROCEDURE  GDTTT_VUAN_KETQUA_DON_UP_TT
( 
    v_ID  in number ,
    v_TRANGTHAI  in number 
) IS
  BEGIN
  update gdttt_vuan_ketqua_don
                    set
                        TRANGTHAI = v_TRANGTHAI
                    where ID = v_ID;   
  END GDTTT_VUAN_KETQUA_DON_UP_TT;

END PKG_GDTTT_VUAN_KETQUA_DON;

/
