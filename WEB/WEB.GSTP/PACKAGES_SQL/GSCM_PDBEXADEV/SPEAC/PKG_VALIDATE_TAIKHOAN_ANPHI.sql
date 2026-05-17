--------------------------------------------------------
--  DDL for Package PKG_VALIDATE_TAIKHOAN_ANPHI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_VALIDATE_TAIKHOAN_ANPHI" AS

  PROCEDURE  VALIDATE_TAIKHOAN_ANPHI_INSERT
(
            V_ID in NUMBER,
            V_NGAY_THAY_DOI_MK  DATE,
            V_MATKHAU_OLD in VARCHAR2
);

END PKG_VALIDATE_TAIKHOAN_ANPHI;

/
