--------------------------------------------------------
--  DDL for Package PKG_STPT_YCBS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_YCBS" AS 

PROCEDURE ADS_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE AHC_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE AHN_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE AKT_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE ALD_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE APS_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize in int,
  curReturn OUT sys_refcursor
);
PROCEDURE INSERT_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0,
  vDONID in number,
  vLOAIAN in number,
  vDON_XULYID in number,
  vLOAIGIAIQUYET in number,
  vNGAYGQ_YC in date,
  vLYDO in varchar2,
  vCDTN_TOAANID in number,
  vCDTN_NGAYNHAN in date,
  vCDNN_TENCQ in varchar2,
  vTRADON_CANCUID in number,
  vNGAYTAO in date,
  vNGUOITAO in varchar2,
  vNGAYSUA in date,
  vNGUOISUA in varchar2,
  vCDNN_NGAYCHUYEN in date,
  vTRADON_LYDOID in number,
  vTRADON_NGAYTRA in date,
  vYCBS_NGAYYEUCAU in date,
  vYCBS_NOIDUNG in varchar2,
  vCDTN_NGAYCHUYEN in date,
  vSOTHONGBAO in varchar2,
  vFILEID in number,
  vYCBS_THOIHAN in number,
  vTOAANID in number,
  vNGAYTHONGBAO in date,
  vDON_CHITIETID in number,
  vSOHIEU in varchar2,
  vNGAYBOSUNG in date,
  vDON_XULY_YCBS_ID in number,
  vSTB_PHU in varchar2,
  curReturn OUT sys_refcursor
);

PROCEDURE DEL_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0
);

PROCEDURE GET_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0,
  curReturn OUT sys_refcursor
);

PROCEDURE CHECK_LOAIGIAIQUYET_DON_YCBS
(
  DonYCBS_ID in number,
  vLoaiAn in number,
  curReturn OUT sys_refcursor
);
PROCEDURE CHECK_THULY_DON_YCBS
(
  vDONID in number,
  vLOAIAN in number,
  curReturn OUT sys_refcursor
);
PROCEDURE CHECK_NGAYGQ_DON_YCBS
(
  vID in number,
  vDonYCBS_ID in number,
  vNGAYGQ in varchar2,
  vLOAIAN in number,
  curReturn OUT sys_refcursor
);
END PKG_STPT_YCBS;
