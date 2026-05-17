--------------------------------------------------------
--  DDL for Package PKG_STPT_TONGDAT_BIEUMAU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_STPT_TONGDAT_BIEUMAU" AS 

PROCEDURE BAN_AN_ST_ADD_BIEUMAU_TONGDAT
(
    vLoaiAn in NUMBER,
    vToaAnID in NUMBER,
    vDonID in NUMBER,
    vMaGiaiDoan in NUMBER,
    vLoaiFile in NUMBER,
    vNguoiTao in VARCHAR2
);
PROCEDURE TONGDAT_DOITUONG_VNID(
     V_ID IN NUMBER,
     V_LOAIAN IN VARCHAR2,
     V_NGAYNHANTONGDAT IN VARCHAR2
);
END PKG_STPT_TONGDAT_BIEUMAU;

/
