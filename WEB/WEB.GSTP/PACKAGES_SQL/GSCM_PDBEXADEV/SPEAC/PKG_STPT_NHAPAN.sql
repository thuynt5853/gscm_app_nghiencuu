--------------------------------------------------------
--  DDL for Package PKG_STPT_NHAPAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_NHAPAN" AS 

PROCEDURE ADS_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

PROCEDURE AHN_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

PROCEDURE AKT_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

PROCEDURE ALD_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

PROCEDURE AHC_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

PROCEDURE APS_UPDATE
(
    v_DonGocID in number,
    v_DonConID in number,
    curReturn out sys_refcursor
);

END PKG_STPT_NHAPAN;

/
