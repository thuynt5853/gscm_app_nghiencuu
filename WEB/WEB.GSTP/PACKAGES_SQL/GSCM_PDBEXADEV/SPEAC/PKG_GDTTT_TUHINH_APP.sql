--------------------------------------------------------
--  DDL for Package PKG_GDTTT_TUHINH_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_TUHINH_APP" AS
PROCEDURE DELETE_GDTTT_TUHINH_DON
  (
    V_ID IN VARCHAR2 DEFAULT NULL,
    V_Dele out DECIMAL
  );
PROCEDURE GDTTT_TUHINH_DON_GET_BY_ID
(
  v_ID        IN NUMBER,
  curReturn OUT sys_refcursor
);
PROCEDURE  GDTTT_TUHINH_DON_SEARCH
( 
  v_Loaidon in number,
  v_nguoinhan in number,
  v_loaingay    in number,
  v_tungay  in date,
  v_denngay in date,
  v_nguoigui in varchar2,
  v_diachi in varchar2,
  v_soba    in varchar2,
  v_ngayba  in date,
  v_toaxx   in number,
  PageIndex	in	number,
  PageSize	in	number,
  curReturn OUT sys_refcursor
);

PROCEDURE  GDTTT_VUAN_GETALLDUONGSU
( 
  vVuanid      in number,
  vDuongsuid    in number,
  curReturn OUT sys_refcursor
);


PROCEDURE GDTTT_TUHINH_DON_INS_UP
(
  v_ID        IN NUMBER,
  V_VUANID    IN NUMBER,
  V_DUONGSUID IN NUMBER,
  v_hoso_id   IN NUMBER,
  V_NGUOIGUI    IN VARCHAR2,
  V_NGUOIGUI_DIACHI IN VARCHAR2,
  V_NGUOINHAN_ID IN NUMBER,
  V_NGAYTRENDON IN DATE ,
  V_NGAYNHAN IN DATE,
  V_LOAI IN NUMBER,
  V_NOIDUNG IN VARCHAR2,
  V_NGUOITAO_ID in number,
  V_NGUOITAO IN VARCHAR2,
  
   --thong tin ban an moi
    V_LOAIBA  IN NUMBER,
  V_SOANPHUCTHAM IN VARCHAR2,
  V_NGAYXUPHUCTHAM IN DATE ,
  V_TOAPHUCTHAMID IN NUMBER,
  V_SOANSOTHAM IN VARCHAR2,
  V_NGAYXUSOTHAM IN DATE ,
  V_TOAANSOTHAM IN NUMBER,
  --thong tin duong su moi
  V_HOTENBC   IN VARCHAR2,
  V_NAMSINH     IN NUMBER,
  V_DIACHI    IN VARCHAR2,
  V_TOIDANH_ID IN NUMBER,
  V_TENTOIDANH  IN VARCHAR2,
   --thong tin ttv và ldv
  V_NGAYPHANCONGTTV  IN DATE,
  V_THAMTRAVIENID  IN NUMBER,
  V_TENTHAMTRAVIEN  IN VARCHAR2,
  V_NgayNhanTieuHS  IN DATE,
  V_NgayNhanHS   IN DATE,
  V_LANHDAOVU  IN NUMBER,
  V_THAMPHAN  IN NUMBER
);
PROCEDURE  GDTTT_TUHINH_INSERT
( 
    V_USER_ID  in number,
    V_VUAN_ID in number,
    V_DUONGSU_ID in number
);
end PKG_GDTTT_TUHINH_APP;

/
