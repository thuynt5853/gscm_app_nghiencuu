--------------------------------------------------------
--  DDL for Package PKG_GDTTT_BAOCAO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_BAOCAO" AS 
FUNCTION BAOCAO_TH_THULY_GDKT
(
  vToaAnID in VARCHAR2,
  vPhongBanID  in  VARCHAR2,
  vThamphanID  in  VARCHAR2,
  vTuNgay in date,
  vDenNgay in date
)
 RETURN SYS_REFCURSOR;
FUNCTION BAOCAO_TH_THULY_TP
(
  vToaAnID in VARCHAR2,
  vThamphanID VARCHAR2,
  vThamphanID_Login  in  VARCHAR2,
  vTuNgay in date,
  vDenNgay in date
)
 RETURN SYS_REFCURSOR;
FUNCTION BAOCAO_TK_TP_GET
(
  VTHAMPHANID_PCA  IN NUMBER,
  vToaAnID in number,
  vThamphanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vYears in varchar2
)
 RETURN SYS_REFCURSOR;
FUNCTION BAOCAO_TK_VU
(
  vToaAnID in number,
  vPhongBanID  in number,
  vLanhdaoVu number,
  vThamTraVien number
)
 RETURN SYS_REFCURSOR;
FUNCTION BAOCAO_THONGKE_CHITIEU_01
(
    v_TenPhongban VARCHAR2 DEFAULT NULL,
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vTuNgay_ky in date,
    vDenNgay_ky in date,
    vLanhDaoID number,
    vThamtravienID number
)
RETURN SYS_REFCURSOR;
END PKG_GDTTT_BAOCAO;
