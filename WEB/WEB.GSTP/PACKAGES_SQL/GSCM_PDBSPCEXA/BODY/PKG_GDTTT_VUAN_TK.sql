--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_TK
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_TK" AS

PROCEDURE GDKTTT_VUAN_TK_INS_UPD
    (
        V_TYPE_TK in VARCHAR2,
        V_VUAN_ID  in  NUMBER,
        V_GIATRI_TK in  NUMBER,
        V_NOIDUNG_TK in  VARCHAR2,
        V_GHICHU in  VARCHAR2,
        V_NGUOITAO IN VARCHAR2,
        V_NGAYTAO  IN DATE,
        V_NGUOISUA IN VARCHAR2,
        V_NGAYSUA  IN DATE
    ) AS
        
        V_COUNT_CHEK_TK NUMBER;
        V_COUNT_CHEK_QUAHAN NUMBER;
  BEGIN
    -- Kiem tra xem da luu Thong ke chua
    V_COUNT_CHEK_TK := 0;
    SELECT COUNT(V.VUANID) INTO V_COUNT_CHEK_TK FROM GDTTT_VUAN_THONGKE  V WHERE V.VUANID = V_VUAN_ID and TYPE_TK = V_TYPE_TK;

    IF V_COUNT_CHEK_TK > 0 THEN  -- Da ton tai thong ke        
                    update GDTTT_VUAN_THONGKE 
                                    set GIATRI_TK =  V_GIATRI_TK
                                        ,NOIDUNG_TK = V_NOIDUNG_TK
                                        ,GHICHU = V_GHICHU
                                        ,NGUOISUA = V_NGUOISUA
                                        ,NGAYSUA  = V_NGAYSUA
                                     where VUANID = V_VUAN_ID and TYPE_TK = V_TYPE_TK;
    ELSE   
                    INSERT INTO GDTTT_VUAN_THONGKE 
                        (VUANID,TYPE_TK,GIATRI_TK,NOIDUNG_TK,GHICHU,NGUOITAO,NGAYTAO) 
                    VALUES
                        (V_VUAN_ID,V_TYPE_TK,V_GIATRI_TK,V_NOIDUNG_TK,V_GHICHU,V_NGUOITAO,V_NGAYTAO) ;   
    END IF;   

  END GDKTTT_VUAN_TK_INS_UPD;


PROCEDURE  GDKTTT_VUAN_TK_GETBYID
(
     V_TYPE_TK IN VARCHAR2
     ,V_VUAN_ID  in NUMBER,
    curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM GDTTT_VUAN_THONGKE V WHERE V.VUANID = V_VUAN_ID and TYPE_TK = V_TYPE_TK;
END GDKTTT_VUAN_TK_GETBYID;


PROCEDURE  GDKTTT_VUAN_TK_DEL
( 
    V_TYPE_TK IN VARCHAR2
    ,V_VUAN_ID IN NUMBER

)
IS  
      V_COUNT_CHEK NUMBER;
BEGIN
        SELECT COUNT(V.VUANID) INTO V_COUNT_CHEK FROM GDTTT_VUAN_THONGKE  V WHERE V.VUANID = V_VUAN_ID and TYPE_TK = V_TYPE_TK;
        IF V_COUNT_CHEK >0 THEN
            DELETE GDTTT_VUAN_THONGKE V WHERE V.VUANID = V_VUAN_ID  and TYPE_TK = V_TYPE_TK;
        END IF;

END GDKTTT_VUAN_TK_DEL;


PROCEDURE  GDKTTT_VUAN_GET_ALL_ANLE
(
    curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM PUBLIC_DATA_AN_LE@DBLINK_CBBA.TOAAN.GOV.VN V order by v.SO_ANLE;
END GDKTTT_VUAN_GET_ALL_ANLE;


END PKG_GDTTT_VUAN_TK;
