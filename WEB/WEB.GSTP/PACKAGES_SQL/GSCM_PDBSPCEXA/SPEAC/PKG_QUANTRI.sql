--------------------------------------------------------
--  DDL for Package PKG_QUANTRI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_QUANTRI" AS 
PROCEDURE  QT_NHOM_HOME_GET
( 
    v_CHUONGTRINHID in number,
    v_NHOMID in number,
    curReturn OUT sys_refcursor
);
PROCEDURE  QT_NHOM_HOME_IN_UP
( 
    v_CHUONGTRINHID in number,
    v_NHOMID in number,
    v_XEM in number,
    v_XEM_ALL in number
);
PROCEDURE  QT_NHOM_ISHOME_GET
( 
    v_NHOMID in number,
    curReturn OUT sys_refcursor
);
PROCEDURE  QT_NHOM_ISHOME_IN_UP
( 
    v_NHOMID in number,
    v_VIEW_TK in number
);
END PKG_QUANTRI;
