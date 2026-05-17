--------------------------------------------------------
--  DDL for Package Body PKG_HCTP_PHATHANH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_HCTP_PHATHANH" AS

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
) AS
  BEGIN
        if (v_ID >0) then
            update TONGDAT_HCTP
                    set
                        DON_ID = v_DON_ID,
                        LOAIVB = v_LOAIVANBAN,
                        TENVANBAN = v_TENVANBAN,
                        SOVB = v_SOVB,
                        NGAYVB = v_NGAYVB,
                        NGUOIKY = v_NGUOIKY,
                        DONVIPHATHANH_ID = v_DONVIPHATHANH_ID,
                        DONVIPHATHANH = v_DONVIPHATHANH,
                        TOAANID = v_TOAANID,
                        NGAYTHUHOI = v_NGAYTHUHOI,
                        LYDOTHUHOI = v_LYDOTHUHOI,
                        NGAYTAO = v_NGAYTAO,
                        NGUOITAO = v_NGUOITAO,
                        NGAYSUA = v_NGAYSUA,
                        NGUOISUA = v_NGUOISUA
                    where ID = v_ID
                    RETURNING ID INTO vID;
        else
            insert into TONGDAT_HCTP 
            (ID,DON_ID,LOAIVB,TENVANBAN,SOVB,NGAYVB,NGUOIKY,DONVIPHATHANH_ID,DONVIPHATHANH,TOAANID,NGAYTHUHOI,LYDOTHUHOI,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA)
            values (TONGDAT_HCTP_SEQ.nextval,v_DON_ID,v_LOAIVANBAN,v_TENVANBAN,v_SOVB,v_NGAYVB,v_NGUOIKY,v_DONVIPHATHANH_ID,v_DONVIPHATHANH,v_TOAANID,v_NGAYTHUHOI,v_LYDOTHUHOI,v_NGAYTAO,v_NGUOITAO,v_NGAYSUA,v_NGUOISUA)
            RETURNING ID INTO vID;
        end if;
  END TONGDAT_HCTP_INS_UPD;

  PROCEDURE  TONGDAT_HCTP_GETBYID
( 
    v_ID in number DEFAULT 0,
    curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR  
    SELECT * FROM TONGDAT_HCTP WHERE ID = v_ID;
  END TONGDAT_HCTP_GETBYID;

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
) AS
  BEGIN
    if (v_ID >0) then
            update TONGDAT_HCTP_NOINHAN
                    set
                        TONGDAT_HCTP_ID = v_TONGDAT_HCTP_ID,
                        NOINHAN_ID = v_NOINHAN_ID,
                        NOINHAN = v_NOINHAN,
                        DOITUONG = v_DOITUONG,
                        TUCACHTOTUNG = v_TUCACHTOTUNG,
                        DIACHI = v_DIACHI,
                        TRANGTHAI = v_TRANGTHAI,
                        LYDO = v_LYDO,
                        NGAYGUI = v_NGAYGUI,
                        NGAYPHATHANH = v_NGAYPHATHANH,
                        NGAYNHAN = v_NGAYNHAN,
                        HINHTHUCGUI = v_HINHTHUCGUI,
                        PHATHANHLAI_ID = v_PHATHANHLAI_ID,
                        NGAYTAO = v_NGAYTAO,
                        NGUOITAO = v_NGUOITAO
                    where ID = v_ID
                    RETURNING ID INTO vID;
        else
            insert into TONGDAT_HCTP_NOINHAN
            (ID,TONGDAT_HCTP_ID,NOINHAN_ID,NOINHAN,DOITUONG,TUCACHTOTUNG,DIACHI,TRANGTHAI,LYDO,NGAYGUI,NGAYPHATHANH,NGAYNHAN,HINHTHUCGUI,PHATHANHLAI_ID,NGAYTAO,NGUOITAO)
            values (TONGDAT_HCTP_NOINHAN_SEQ.nextval,v_TONGDAT_HCTP_ID,v_NOINHAN_ID,v_NOINHAN,v_DOITUONG,v_TUCACHTOTUNG,v_DIACHI,v_TRANGTHAI,v_LYDO,v_NGAYGUI,v_NGAYPHATHANH,v_NGAYNHAN,v_HINHTHUCGUI,v_PHATHANHLAI_ID,v_NGAYTAO,v_NGUOITAO)
            RETURNING ID INTO vID;
        end if;
  END TONGDAT_HCTP_NOINHAN_INS_UPD;

  PROCEDURE  TONGDAT_HCTP_NOINHAN_GETBYID
( 
    v_ID in number DEFAULT 0,
    curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR  
    SELECT * FROM TONGDAT_HCTP_NOINHAN WHERE ID = v_ID;
  END TONGDAT_HCTP_NOINHAN_GETBYID;

  PROCEDURE TONGDAT_HCTP_DEL
( 
    v_ID in number DEFAULT 0
) AS
  BEGIN
    if (v_ID >0) then
            DELETE TONGDAT_HCTP where ID = v_ID; 
            DELETE TONGDAT_HCTP_NOINHAN where TONGDAT_HCTP_ID = v_ID;
        end if;
  END TONGDAT_HCTP_DEL;

PROCEDURE TONGDAT_HCTP_FILE_UPD
( 
    v_ID  in number,
    v_TENFILE  in varchar2,
    v_FILE_URL in varchar2
)IS 
BEGIN
    UPDATE TONGDAT_HCTP SET 
        TENFILE = v_TENFILE,
        FILE_URL = v_FILE_URL
    WHERE ID = v_ID;
END TONGDAT_HCTP_FILE_UPD;

PROCEDURE TONGDAT_HCTP_NOINHAN_PHATHANH_UPD
( 
    v_ID  in number,
    v_NGAYPHATHANH  in date
)IS 
BEGIN
    UPDATE TONGDAT_HCTP_NOINHAN SET 
        NGAYPHATHANH = v_NGAYPHATHANH,
        TRANGTHAI = 3
    WHERE ID = v_ID AND TRANGTHAI = 1;
END TONGDAT_HCTP_NOINHAN_PHATHANH_UPD;

PROCEDURE TONGDAT_HCTP_NOINHAN_TRAKETQUA
( 
    v_ID  in number,
    v_NGAYNHAN  in date,
    v_LYDO in varchar2
)IS 
BEGIN
    UPDATE TONGDAT_HCTP_NOINHAN SET 
        NGAYNHAN = v_NGAYNHAN,
        LYDO = v_LYDO
    WHERE ID = v_ID;
END TONGDAT_HCTP_NOINHAN_TRAKETQUA;

END PKG_HCTP_PHATHANH;

/
