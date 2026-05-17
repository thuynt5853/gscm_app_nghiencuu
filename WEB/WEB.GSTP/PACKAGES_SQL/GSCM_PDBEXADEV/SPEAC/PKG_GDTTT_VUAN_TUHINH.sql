--------------------------------------------------------
--  DDL for Package PKG_GDTTT_VUAN_TUHINH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTT_VUAN_TUHINH" as 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
  PROCEDURE GDTTT_SEARCH_VUAN_TUHINH
 ( 
  vLoaiBanAn in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vToaRaBAQD in number,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);
  
  PROCEDURE      GDTTTT_DUONGSU_TUHINH_SEARCH
( 
   v_colume  in varchar2,
  v_asc_desc in varchar2,
  V_ID      in number,
  vHosoangiam in number,
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vLoaiBanAn in number,
  vBian in varchar2,
  vtungay in date,
  vdenngay in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);
 PROCEDURE      GDTTTT_HOSO_TUHINH_SEARCH
( 
   v_colume  in varchar2,
  v_asc_desc in varchar2,
  V_ID      in number,
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vLoaiBanAn in number,
  vBian in varchar2,
  vtungay in date,
  vdenngay in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);

FUNCTION GDTTT_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2;


PROCEDURE  GDTTTT_DSTOTRINH_TUHINH
( 

  V_ID      in number,
  V_HoSo_ID in number,
  curReturn OUT sys_refcursor
);

PROCEDURE  GDTTTT_TOTRINH_TUHINH
( 
    v_id  in  number,
    V_TUHINH_ID in number,
    V_SOTT IN VARCHAR2,
    V_NGAYTT IN DATE,
    V_DX_TTV  IN VARCHAR2,
    V_CAPTRINH IN NUMBER,
    V_LANHDAOID IN NUMBER,
    V_NGAYTRINH  IN DATE,
    V_NGAYDUKIENBC  IN DATE,
    V_NGAYNHANTT  IN DATE,
    V_NGAYTRATT  IN DATE,
    V_LOAIYK in number,
    V_NOIDUNGYKIEN IN VARCHAR2,
    V_CAPTRINHTIEP IN NUMBER,
    V_TRINHTIEP_LANHDAO_ID IN NUMBER,
    V_GHICHU   IN VARCHAR2,
    V_USER_ID IN NUMBER
);
PROCEDURE  GDTTTT_DELETE_TTTH
( 
    v_id  in  number
);

PROCEDURE  DELETE_GDTTT_TUHINH_VUAN
( 
    v_id  in  number,
    V_Dele out DECIMAL
);

procedure  GDTTT_TUHINH_HOSO_IN(
    v_vuanid    in number,
    v_duongsu_id in number,
    V_NGUOITAO_ID in number,
    vInsert out  DECIMAL
);  
    
PROCEDURE  GDTTTT_GIAIQUYET_TUHINH_UP
( 
    v_loailuu in number,
    v_id  in number DEFAULT 0,

    v_KETLUAN_CA in number,
    v_SOQD_CA     in varchar2,
    v_NGAYQD_CA in date,
    v_NOIDUNG_QD_CA IN varchar2,

    --v_SOCVGUI_VKS  in varchar2,
    --v_NGAYCVGUI_VKS in date,
    --v_NGAYNHAN_VKS in date,
    v_NGAYPHCV_VKS  in date,
    v_GHICHUCV_GUI in varchar2,
    

    v_SOQD_VKS     in varchar2,
    v_NGAYQD_VKS   in date,
    v_KETLUAN_VKS  in number DEFAULT 0,
    v_SOTT_VKS     in varchar2,
    v_NGAYTT_VKS in date,
    v_NOIDUNGTT_VKS in number,
    v_GHICHU_VKS_TRA in varchar2,

--    v_CTN_NGAYCHUYEN  in date,
--    v_CTN_NGUOICHUYEN_ID in number,
--    v_CTN_NGUOINHAN in varchar2,
--    v_CTN_NGAYNHAN in date,
    v_CTN_SOQĐ    in varchar2,
    v_CTN_NGAYQD in date,
    v_CTN_LOAIQD in number DEFAULT 0,
    v_CTN_NGAYTRA in date,
    v_CTN_GHICHU  in varchar2,

    v_SOCVXM in varchar2,
    v_NGAYCVXM in date,
    v_NOIDUNGXM in varchar2,

    v_LOAIKETQUAXM  in number DEFAULT 0,
    v_NGAYKQXM in date,
    v_NOIDUNG_KQXM  in varchar2,

--    v_THA_SOCV  in varchar2,
--    v_THA_NGAYCV in date,
--    v_THA_NGAYPHCV in date,
    v_THA_KETQUA  in varchar2,
    v_THA_NGAY in date,
    v_THA_DIADIEM  in varchar2,
    v_THA_GHICHU  in varchar2,

    v_LUUHS_NGAYCHUYEN in date,
    v_LUUHS_NGUOICHUYEN_ID  in number,
--    v_LUUHS_NGAYNHAN in date,
    v_LUUHS_NGUOINHAN  in varchar2,
    v_LUUHS_DONVINHAN  in varchar2,
    v_LUUHS_TINHTRANGHS  in varchar2,
--    v_LUUHS_VBLIENQUAN  in varchar2,
--    v_LUUHS_NGAYTRINH_CA in date,
    v_LUUHS_GHICHU  in varchar2

);

end PKG_GDTTT_VUAN_TUHINH;

/
