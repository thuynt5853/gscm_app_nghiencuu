--------------------------------------------------------
--  DDL for Package Body PKG_DM_HINHTHUCGUI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_DM_HINHTHUCGUI" AS

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
) AS
  BEGIN
    if(v_ID > 0) then
        UPDATE DM_HINHTHUCGUI
            SET 
                ID = v_ID,
                TEN_HINHTHUCGUI = v_TEN_HINHTHUCGUI,
                HIEULUC = v_HIEULUC,
                CO_GUI_VBDH = v_CO_GUI_VBDH,
                GIATRI = v_GIATRI
            WHERE ID = v_ID; 
    else
        INSERT INTO DM_HINHTHUCGUI(TEN_HINHTHUCGUI, HIEULUC, CO_GUI_VBDH, NGUOITAO, NGAYTAO, GIATRI)
        VALUES(v_TEN_HINHTHUCGUI, v_HIEULUC, v_CO_GUI_VBDH, v_NGUOITAO, v_NGAYTAO, v_GIATRI);
    end if;
  END DM_HINHTHUCGUI_INSERT_UPDATE;

  PROCEDURE GETALL_CHECK_UNIQUE
( 
	curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR
        SELECT ID, GIATRI FROM DM_HINHTHUCGUI;
  END GETALL_CHECK_UNIQUE;

  PROCEDURE DM_HINHTHUCGUI_DEL
( 
	v_ID in number
) AS
  BEGIN
    if (v_ID >0) then
        DELETE DM_HINHTHUCGUI where ID = v_ID;
    end if;
  END DM_HINHTHUCGUI_DEL;

  PROCEDURE DM_HINHTHUCGUI_GETBYID
( 
	v_ID in number,
    curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR
        SELECT * FROM DM_HINHTHUCGUI WHERE ID = v_ID;
  END DM_HINHTHUCGUI_GETBYID;

  PROCEDURE DM_HINHTHUCGUI_GETBYGIATRI
( 
	vGiaTri in number,
    curReturn OUT sys_refcursor
)AS
  BEGIN
    OPEN curReturn FOR
    SELECT CO_GUI_VBDH FROM DM_HINHTHUCGUI WHERE GIATRI = vGiaTri;
  END DM_HINHTHUCGUI_GETBYGIATRI;

  PROCEDURE GETALL_PAGING
( 
	PageIndex in int,
    PageSize in int,
    curReturn OUT sys_refcursor
) AS
	TotalItem number;
    MinIndex number;
    MaxIndex number;
  BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

    select count (ID) into TotalItem from DM_HINHTHUCGUI;

    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (SELECT ROW_NUMBER() OVER (ORDER BY NGAYTAO desc) STT
                    ,ID ,TEN_HINHTHUCGUI, HIEULUC, CO_GUI_VBDH
                    , GIATRI, NGAYTAO, NGUOITAO
                    from DM_HINHTHUCGUI
                 ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
  END GETALL_PAGING;

  PROCEDURE GETALL_ISHIEULUC
( 
    curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR
        SELECT * FROM DM_HINHTHUCGUI WHERE HIEULUC = 1 ORDER BY NGAYTAO;
  END GETALL_ISHIEULUC;

END PKG_DM_HINHTHUCGUI;

/
