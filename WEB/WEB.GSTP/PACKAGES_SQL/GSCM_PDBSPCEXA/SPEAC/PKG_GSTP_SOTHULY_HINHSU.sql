--------------------------------------------------------
--  DDL for Package PKG_GSTP_SOTHULY_HINHSU
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GSTP_SOTHULY_HINHSU" AS 
    
    /*16 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ SƠ THẨM*/
	PROCEDURE FILL_HINHSU_SOTHAM
	(
		v_ARRAY IN OUT T_HINHSU_SOTHAM
	);

	PROCEDURE SO_HINHSU_SOTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	);

	/*17 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ PHÚC THẨM*/
	PROCEDURE FILL_HINHSU_PHUCTHAM
	(
		v_ARRAY IN OUT T_HINHSU_PHUCTHAM
	);
	PROCEDURE SO_HINHSU_PHUCTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	);

    PROCEDURE AHS_Y_AN_SO_THAM
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
    
    PROCEDURE  AHS_TONGHOPHINHPHAT_PT
    ( 
        VUANID in number,
        VBICAOID in number,
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
END PKG_GSTP_SOTHULY_HINHSU;
