--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_QUANLYSO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_QUANLYSO" AS

  PROCEDURE GDTTT_HCTP_QLSO_UP_IN
( 
    v_ID in number,
    v_SO in varchar2,
    v_NGAY in date,
    v_NGUOIKY in varchar2,
    v_DONID in varchar2,
    v_SO_TT in varchar2,
    v_NGAY_TT in date,
    v_LOAI in number,
    v_NGUOITAO in varchar2,
    v_NGAYTAO in date,
    v_NGUOISUA in varchar2,
    v_NGAYSUA in date,
    v_THAMPHANID in number,
    v_TRANGTHAI in number
) AS
  BEGIN
        if (v_id >0) then
            update GDTTT_HCTP_QLSO
                    set
                        SO = v_SO,
                        NGAY = v_NGAY,
                        NGUOIKY = v_NGUOIKY,
                        DONID = v_DONID,
                        SO_TT = v_SO_TT,
                        NGAY_TT = v_NGAY_TT,
                        LOAI = v_LOAI,
                        NGUOITAO = v_NGUOITAO,
                        NGAYTAO = v_NGAYTAO,
                        NGUOISUA = v_NGUOISUA,
                        NGAYSUA = v_NGAYSUA,
                        THAMPHANID = v_THAMPHANID,
                        TRANGTHAI = v_TRANGTHAI
                    where id = v_ID ;
        else
            insert into GDTTT_HCTP_QLSO(SO,NGAY,NGUOIKY,DONID,SO_TT,NGAY_TT,LOAI,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA,THAMPHANID,TRANGTHAI)
            values(v_SO,v_NGAY,v_NGUOIKY,v_DONID,v_SO_TT,v_NGAY_TT,v_LOAI,v_NGUOITAO,v_NGAYTAO,v_NGUOISUA,v_NGAYSUA,v_THAMPHANID,v_TRANGTHAI);

        end if;
  END GDTTT_HCTP_QLSO_UP_IN;

  PROCEDURE GDTTT_HCTP_QLSO_GETALL
(
    curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR
    SELECT * FROM GDTTT_HCTP_QLSO;
  END GDTTT_HCTP_QLSO_GETALL;

END PKG_GDTTT_HCTP_QUANLYSO;
