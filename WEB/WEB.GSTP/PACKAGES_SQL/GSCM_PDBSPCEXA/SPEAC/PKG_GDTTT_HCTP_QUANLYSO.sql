--------------------------------------------------------
--  DDL for Package PKG_GDTTT_HCTP_QUANLYSO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_HCTP_QUANLYSO" AS 

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
);

PROCEDURE GDTTT_HCTP_QLSO_GETALL
(
    curReturn OUT sys_refcursor
);

END PKG_GDTTT_HCTP_QUANLYSO;
