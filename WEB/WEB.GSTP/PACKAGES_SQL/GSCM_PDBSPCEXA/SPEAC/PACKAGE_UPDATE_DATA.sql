--------------------------------------------------------
--  DDL for Package PACKAGE_UPDATE_DATA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PACKAGE_UPDATE_DATA" AS 

PROCEDURE DELETE_DATA_AHS_SOTHAM_BANAN_DIEU_CHITIET
( 
    curReturn OUT sys_refcursor
);

PROCEDURE UPDATE_AHS_SOTHAM_BANAN_DIEU_CHITIET
( 
    curReturn OUT sys_refcursor
);

PROCEDURE DELETE_DATA_AHS_SOTHAM_CAOTRANG_DIEULUAT
( 
    curReturn OUT sys_refcursor
);

PROCEDURE UPDATE_AHS_SOTHAM_CAOTRANG_DIEULUAT
( 
    curReturn OUT sys_refcursor
);

END PACKAGE_UPDATE_DATA;
