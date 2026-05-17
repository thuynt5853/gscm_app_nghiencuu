--------------------------------------------------------
--  DDL for Package PKG_JOBSHARE_C06
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_JOBSHARE_C06" AS 

PROCEDURE JobShareUpdateStatusAHC
( vID number,
  vReturn OUT number
);

PROCEDURE JobShareUpdateStatusADS
( vID number,
  vReturn OUT number
);

PROCEDURE JobShareUpdateStatusAHN
( vID number,
  vReturn OUT number
);

PROCEDURE JobShareUpdateStatusAKT
( vID number,
  vReturn OUT number
);

PROCEDURE JobShareUpdateStatusALD
( vID number,
  vReturn OUT number
);

PROCEDURE JobShareUpdateStatusAHS
( vID number,
  vReturn OUT number
);

END PKG_JOBSHARE_C06;

/
