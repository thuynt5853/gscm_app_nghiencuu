--------------------------------------------------------
--  DDL for Package PKG_STPT_DS_BC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_DS_BC" AS

PROCEDURE DS_CHUYENAN
(
  vToaAnID number,
   vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  vDonan in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_DS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
);
PROCEDURE DS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  vDonan in number,--toancau-anhnt thêm trường check là đơn hay án
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_DS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);

PROCEDURE HN_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_HN_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS
);
PROCEDURE HN_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_HN_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);

PROCEDURE KT_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_KT_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU  LẤY THÊM TRƯỜNG
);
PROCEDURE KT_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_KT_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);

PROCEDURE HC_CHUYENAN
(
    vToaAnID number,
    vToaAnNhan_ten in varchar2,
    vMavuviec in nvarchar2,
    vTenvuviec in nvarchar2,
    vSoQD in nvarchar2,
    vSoBA in nvarchar2,  
    vTungay in date,
    vDenngay in date,
    vDuongsu in nvarchar2,  
    vTrangthai in number,
    curReturn OUT sys_refcursor
);
PROCEDURE FILL_HC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS
);
PROCEDURE HC_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_HC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);

PROCEDURE LD_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_LD_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU  LẤY THÊM TRƯỜNG
);
PROCEDURE LD_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_LD_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);
PROCEDURE PS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_PS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS
);
PROCEDURE PS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
);
PROCEDURE FILL_PS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
);


PROCEDURE HS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
);
PROCEDURE HS_CHUYEN_AN_CHITIET
(
  V_VUANID IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
);
PROCEDURE FILL_HS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT
);
PROCEDURE HS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  V_SO_QD IN VARCHAR2,
  V_NGAY_QD IN VARCHAR2,
  VTOAANID NUMBER,
  VMAVUVIEC IN NVARCHAR2,
  VTENVUVIEC IN NVARCHAR2,
  VTOACHUYEN IN NVARCHAR2,
  VTRUONGHOPGIAONHAN IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE,
  VTRANGTHAI IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
);
PROCEDURE HS_NHANAN_CHITIET
(
  V_VUANID IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
);
END PKG_STPT_DS_BC;
