CREATE OR REPLACE PACKAGE GSCM.PKG_THA_DIEULUAT
AS
-- Package header

-- vnpt - Lưu Quang Huy - lấy ds điều luật bị án khi THA - 22/09/2025 17:25
PROCEDURE THA_BANANST_DIEUCT_GETALL
(
     bi_can_id in int, p_vuanId in int
   , bo_luat_id in int 
   , curr_textsearch in nvarchar2

	 , PageIndex	in	int, PageSize	in	int
	 , curReturn    OUT   sys_refcursor
);

PROCEDURE THA_TONGHOPHINHPHAT_ST
(
    VVUANID in number,
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_TONGHOPHINHPHAT_PT
(
    VVUANID in number,
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_TONGHOPHINHPHAT_SOSANH
(
    VUANID IN NUMBER, 
    VBICAOID IN NUMBER,
    curReturn OUT SYS_REFCURSOR
);

PROCEDURE THA_TONGHOPTOIDANHSOTHAM
(
     CurrVuAnID in number
   , CurrBiCanID in number
   , CurReturn OUT sys_refcursor 
);

PROCEDURE THA_KQXXPT
(
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_SOTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_PHUCTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_Y_AN_SO_THAM
(
    VBICANID NUMBER,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_SOSANH_HINHPHAT_THOIGIAN
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE THA_SOSANH_HINHPHAT_SOHOC
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
);

PROCEDURE GETALL_DIEULUAT_PT_PAGING
(
     bi_can_id in int, vu_an_id in int
   , bo_luat_id in int 
   , curr_textsearch in nvarchar2

	 , PageIndex	in	int, PageSize	in	int
	 , curReturn    OUT   sys_refcursor
);

END PKG_THA_DIEULUAT;