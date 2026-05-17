--------------------------------------------------------
--  DDL for Package XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO" AS

    -- Thủ tục lấy danh sách kháng cáo / kiến nghị / kháng nghị
    PROCEDURE XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST (
        vDonID     IN  NUMBER,
        curReturn  OUT SYS_REFCURSOR 
    ); 

    PROCEDURE XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST_V2 (
        vDonID     IN  NUMBER,
        curReturn  OUT SYS_REFCURSOR 
    ); 

    -- Thủ tục lấy tên người dùng và viện kiểm sát cùng cấp
    PROCEDURE GETNAME_KHANGNGHI (
        p_user_id  IN  NUMBER,
        curReturn  OUT SYS_REFCURSOR
    );
    PROCEDURE GETNAME_KHANGNGHI_ADMIN (
        p_donvi_id  IN  NUMBER,
        curReturn  OUT SYS_REFCURSOR
    );

	 PROCEDURE SP_GET_KIENNGHI_QD (
	    p_DonID IN NUMBER,
	    p_Cursor OUT SYS_REFCURSOR
	);
	PROCEDURE SP_GET_NGUOITHAMGIA_TT (
    p_donid IN NUMBER,
    p_result OUT SYS_REFCURSOR
	) ;

END XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO;

/
