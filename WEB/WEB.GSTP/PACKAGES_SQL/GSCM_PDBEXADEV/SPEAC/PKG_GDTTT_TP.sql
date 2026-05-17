--------------------------------------------------------
--  DDL for Package PKG_GDTTT_TP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_TP" AS 
PROCEDURE DON_GETDONTRUNG 
(
  V_LOAIDON  in number,
  v_toaanid in number,
  vCurrDonID in number,
  vNguoiGui IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNgayBAQD IN VARCHAR2,
  vToaXetXu IN VARCHAR2,
  vCapXetXu IN VARCHAR2,
  vIsBanAn IN VARCHAR2,
  curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTHEOID
( 
  varrID in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDON_TLL
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE DANHSACHDON_KEMTHE0
( 
  vID in number,
	curReturn OUT sys_refcursor
);
PROCEDURE SET_THAMPHAN_THULYLAI
(
     V_DONTRUNGID IN VARCHAR2,
     V_DON_ID  IN VARCHAR2,
     V_CD_TA_TRANGTHAI IN VARCHAR2, --1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện,2 chuyển từ chưa đủ đk sang đủ đk
     V_ISTHULY IN VARCHAR2--1 Thụ lý mới,2 Đã thụ lý
);
PROCEDURE GET_KETQUA_GQ
(
     V_DONTRUNGID IN VARCHAR2,  
     V_GQD_LOAIKETQUA OUT VARCHAR2
);
PROCEDURE ARR_DONTRUNGID_UP
(
     V_CD_LOAI IN VARCHAR2,
     V_DONTRUNGID IN VARCHAR2,
     V_DON_ID  IN VARCHAR2,
     V_CD_TA_TRANGTHAI IN VARCHAR2, --1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện,2 chuyển từ chưa đủ đk sang đủ đk
     V_ISTHULY IN VARCHAR2--1 Thụ lý mới,2 Đã thụ lý
);
END PKG_GDTTT_TP;

/
