--------------------------------------------------------
--  DDL for Package PKG_STPT_AHS_TONGHOPHINHPHAT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_STPT_AHS_TONGHOPHINHPHAT" AS

PROCEDURE AHS_RETURN_ALL_HINHPHAT_BICAN
( 
    VVUANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_Y_AN_SO_THAM
( 
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_KQXXPT
( 
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_SOSANH_HINHPHAT_THOIGIAN
(     
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_SOSANH_HINHPHAT_SOHOC
( 
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_PHUCTHAM_HINHPHAT_TH_CT_TG
( 
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE AHS_SOTHAM_HINHPHAT_TH_CT_TG
( 
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE  AHS_TONGHOPHINHPHAT_ST
( 
    VVUANID IN NUMBER,
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE  AHS_TONGHOPHINHPHAT_SOSANH
( 
    VUANID in number,
    VBICAOID in number,
    	curReturn    OUT       sys_refcursor
);
PROCEDURE  AHS_TONGHOPHINHPHAT_PT
( 
    VVUANID in number,
    VBICANID in number,
    	curReturn    OUT       sys_refcursor
);


END PKG_STPT_AHS_TONGHOPHINHPHAT;

/
