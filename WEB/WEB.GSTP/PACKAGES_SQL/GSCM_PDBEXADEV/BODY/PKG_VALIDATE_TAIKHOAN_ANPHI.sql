--------------------------------------------------------
--  DDL for Package Body PKG_VALIDATE_TAIKHOAN_ANPHI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_VALIDATE_TAIKHOAN_ANPHI" AS

  PROCEDURE  VALIDATE_TAIKHOAN_ANPHI_INSERT
(
            V_ID in number,
            V_NGAY_THAY_DOI_MK in date,
            V_MATKHAU_OLD in varchar2
) IS
  BEGIN
    if (V_ID >0) then
            insert into VALIDATE_TAIKHOAN_ANPHI
            (
                ID,
                NGAY_THAY_DOI_MK,
                MATKHAU_OLD
            )
            values
            (
                V_ID,
                V_NGAY_THAY_DOI_MK,
                V_MATKHAU_OLD
            );

        end if;
  END VALIDATE_TAIKHOAN_ANPHI_INSERT;

END PKG_VALIDATE_TAIKHOAN_ANPHI;

/
