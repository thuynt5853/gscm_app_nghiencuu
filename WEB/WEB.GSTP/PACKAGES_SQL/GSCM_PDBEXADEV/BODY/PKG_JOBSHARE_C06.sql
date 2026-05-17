--------------------------------------------------------
--  DDL for Package Body PKG_JOBSHARE_C06
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_JOBSHARE_C06" AS

PROCEDURE JobShareUpdateStatusAHC
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C06' AND STATUS = 1; --update theo KHOBAQD_DUONGSU ID
    
    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID;
    
        UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
        WHERE KHOBAQDID = v_KHOBAQDID AND STATUS = 1 AND NOIDONGBO = 'C06';
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
        -- cập nhật trạng thái bản án
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        --update trạng thái của bản án
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;
    
    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusAHC;

PROCEDURE JobShareUpdateStatusADS
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C06' AND STATUS = 1; --update theo KHOBAQD_DUONGSU ID
        
    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID;
        
        UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
        WHERE KHOBAQDID = v_KHOBAQDID AND STATUS = 1 AND NOIDONGBO = 'C06';
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
        -- cập nhật trạng thái bản án
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        --update trạng thái của bản án
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;
        
    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusADS;

PROCEDURE JobShareUpdateStatusAHN
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQDID = vID AND STATUS = 1 AND NOIDONGBO = 'C06';  --update theo KHOBAQD ID
    
    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        FOR rs IN (SELECT ID FROM KHOBAQD_DUONGSU WHERE KHOBAQDID = vID AND STATUS = 1) LOOP
            UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 WHERE KHOBAQD_DUONGSU_ID = rs.ID AND STATUS = 1 AND NOIDONGBO = 'C06';
            
            v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(rs.ID);
            UPDATE KHOBAQD_DUONGSU SET TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU WHERE ID = rs.ID;
            
            -- cập nhật trạng thái bản án
            v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(vID);
            --update trạng thái của bản án
            update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = vID;
        END LOOP;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusAHN;

PROCEDURE JobShareUpdateStatusAHS
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C06' AND STATUS = 1; --update theo KHOBAQD_DUONGSU ID

    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID;
        
        UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
        WHERE KHOBAQDID = v_KHOBAQDID AND STATUS = 1 AND NOIDONGBO = 'C06';
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
        -- cập nhật trạng thái bản án
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        --update trạng thái của bản án
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusAHS;

PROCEDURE JobShareUpdateStatusAKT
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C06' AND STATUS = 1; --update theo KHOBAQD_DUONGSU ID

    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID;
        
        UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
        WHERE KHOBAQDID = v_KHOBAQDID AND STATUS = 1 AND NOIDONGBO = 'C06';
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
        -- cập nhật trạng thái bản án
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        --update trạng thái của bản án
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusAKT;

PROCEDURE JobShareUpdateStatusALD
( vID number,
  vReturn OUT number
) IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C06' AND STATUS = 1; --update theo KHOBAQD_DUONGSU ID

    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID;
    
        UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
        WHERE KHOBAQDID = v_KHOBAQDID AND STATUS = 1 AND NOIDONGBO = 'C06';
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
                -- cập nhật trạng thái bản án
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        --update trạng thái của bản án
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusALD;

END PKG_JOBSHARE_C06;

/
