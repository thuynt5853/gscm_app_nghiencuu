--------------------------------------------------------
--  DDL for Package PKG_DM_HINHTHUCGUI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_DM_HINHTHUCGUI" AS 

PROCEDURE DM_HINHTHUCGUI_INSERT_UPDATE
( 
    v_ID in number,
    v_TEN_HINHTHUCGUI in varchar2,
    v_HIEULUC in number,
    v_CO_GUI_VBDH in number,
    v_NGUOITAO in varchar2,
    v_NGAYTAO in date,
    v_GIATRI in number,
	curReturn OUT sys_refcursor
);

PROCEDURE GETALL_CHECK_UNIQUE
( 
	curReturn OUT sys_refcursor
);

PROCEDURE DM_HINHTHUCGUI_DEL
( 
	v_ID in number
);

PROCEDURE DM_HINHTHUCGUI_GETBYID
( 
	v_ID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE DM_HINHTHUCGUI_GETBYGIATRI
( 	
    vGiaTri in number,
    curReturn OUT sys_refcursor
);

PROCEDURE GETALL_PAGING
( 
	PageIndex in int,
    PageSize in int,
    curReturn OUT sys_refcursor
);

PROCEDURE GETALL_ISHIEULUC
( 
    curReturn OUT sys_refcursor
);

END PKG_DM_HINHTHUCGUI;

/
