--------------------------------------------------------
--  DDL for Package PACKAGE_UPDATE_DATA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PACKAGE_UPDATE_DATA" AS 

PROCEDURE UPDATE_DATA_AHS_TONGHOPHINHPHAT_ST
( 
    curReturn OUT sys_refcursor
);

PROCEDURE UPDATE_DATA_AHS_TONGHOPHINHPHAT_PT
( 
    curReturn OUT sys_refcursor
);

--PROCEDURE XOATHULYTHUA
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE UPDATE_DUONGSUIDS_ANPHI_AHN
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE INSERT_THULYID_SOTHAM
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE CONVERT_DATA_KHANGCAOQUAHAN
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE DELETE_DATA_AHS_SOTHAM_BANAN_DIEU_CHITIET
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE UPDATE_AHS_SOTHAM_BANAN_DIEU_CHITIET
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE DELETE_DATA_AHS_SOTHAM_CAOTRANG_DIEULUAT
--( 
--    curReturn OUT sys_refcursor
--);
--
--PROCEDURE UPDATE_AHS_SOTHAM_CAOTRANG_DIEULUAT
--( 
--    curReturn OUT sys_refcursor
--);

END PACKAGE_UPDATE_DATA;

/
