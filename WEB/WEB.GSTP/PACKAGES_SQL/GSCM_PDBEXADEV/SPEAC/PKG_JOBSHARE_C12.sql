--------------------------------------------------------
--  DDL for Package PKG_JOBSHARE_C12
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_JOBSHARE_C12" AS 

PROCEDURE JobShareUpdateStatusC12
( vID number,
  vReturn OUT number
);

FUNCTION GET_TRANGTHAIBAQD
( 
    vID IN NUMBER
)RETURN NUMBER;

FUNCTION GET_TRANGTHAI_DUONGSU
( 
    vID IN NUMBER
)RETURN NUMBER;

PROCEDURE JobShareUpdateStatusDoiTuongToTungC12
( vID number,
  vReturn OUT number
);

END PKG_JOBSHARE_C12;

/
