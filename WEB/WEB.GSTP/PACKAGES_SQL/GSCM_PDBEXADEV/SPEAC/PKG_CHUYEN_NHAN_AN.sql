--------------------------------------------------------
--  DDL for Package PKG_CHUYEN_NHAN_AN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_CHUYEN_NHAN_AN" AS 

PROCEDURE INSERT_ANPHI_DUONGSUID
(   VLOAIAN IN NUMBER,
    VDONID_OLD IN NUMBER,
    VDONID_NEW IN NUMBER,
    curReturn OUT sys_refcursor);

END PKG_CHUYEN_NHAN_AN;

/
