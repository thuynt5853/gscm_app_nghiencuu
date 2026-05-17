--------------------------------------------------------
--  DDL for Package Body PKG_JOBSHARE_C12
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_JOBSHARE_C12" AS

PROCEDURE JobShareUpdateStatusC12
( vID number,
  vReturn OUT number
)
IS 
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQDID = vID AND STATUS = 1 AND NOIDONGBO = 'C12';
    
    -- kiểm tra trạng thái của toàn bản án
    declare
        v_TRANGTHAIBAQD NUMBER;
    begin
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(vID);
        
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = vID;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusC12;


FUNCTION GET_TRANGTHAIBAQD
( 
    vID IN NUMBER
)RETURN NUMBER AS
    v_TRANGTHAIBAQD NUMBER;
BEGIN
    declare
        v_TRANGTHAIBAQD_HIENTAI NUMBER;
        
        v_TOTAL NUMBER;
        v_TOTAL_DONGBO NUMBER;
        v_TOTAL_CHO_DONGBO NUMBER;
        v_TOTAL_DONGBO_THUHOI NUMBER;
        v_TOTAL_CHO_THUHOI NUMBER;
        
        v_TOTAL_KHOBAQD NUMBER;
        v_TOTAL_KHOBAQD_DONGBO NUMBER;
        v_TOTAL_KHOBAQD_CHO_DONGBO NUMBER;
        v_TOTAL_KHOBAQD_DONGBO_THUHOI NUMBER;
        v_TOTAL_KHOBAQD_CHO_THUHOI NUMBER;
        
        v_TOTAL_KHOBAQD_DUOGNSU NUMBER;
        v_TOTAL_KHOBAQD_DUOGNSU_DONGBO NUMBER;
        v_TOTAL_KHOBAQD_DUOGNSU_CHO_DONGBO NUMBER;
        v_TOTAL_KHOBAQD_DUOGNSU_DONGBO_THUHOI NUMBER;
        v_TOTAL_KHOBAQD_DUOGNSU_CHO_THUHOI NUMBER;
    BEGIN
        select TRANGTHAIBAQD into v_TRANGTHAIBAQD_HIENTAI from KHOBAQD where ID = vID;
        
        SELECT 
            SUM(CASE WHEN STATUS = 1 THEN 1 ELSE 0 END),
            SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 0 THEN 1 ELSE 0 END),
            SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 1 THEN 1 ELSE 0 END),
            SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 1 THEN 1 ELSE 0 END)
        INTO 
            v_TOTAL_KHOBAQD,
            v_TOTAL_KHOBAQD_DONGBO,
            v_TOTAL_KHOBAQD_CHO_DONGBO,
            v_TOTAL_KHOBAQD_DONGBO_THUHOI,
            v_TOTAL_KHOBAQD_CHO_THUHOI
        FROM KHOBAQD_DONGBO
        WHERE KHOBAQDID = vID;
        
        
        select 
        SUM(CASE WHEN STATUS = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 0 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 0 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 1 THEN 1 ELSE 0 END)
        INTO 
            v_TOTAL_KHOBAQD_DUOGNSU,
            v_TOTAL_KHOBAQD_DUOGNSU_DONGBO,
            v_TOTAL_KHOBAQD_DUOGNSU_CHO_DONGBO,
            v_TOTAL_KHOBAQD_DUOGNSU_DONGBO_THUHOI,
            v_TOTAL_KHOBAQD_DUOGNSU_CHO_THUHOI
        from KHOBAQD_DUONGSU_DONGBO
        where KHOBAQD_DUONGSU_ID in (select ID from KHOBAQD_DUONGSU where STATUS = 1 and KHOBAQDID = vID) and STATUS = 1;
        
        v_TOTAL := v_TOTAL_KHOBAQD + v_TOTAL_KHOBAQD_DUOGNSU;
        v_TOTAL_DONGBO := v_TOTAL_KHOBAQD_DONGBO + v_TOTAL_KHOBAQD_DUOGNSU_DONGBO;
        v_TOTAL_DONGBO_THUHOI := v_TOTAL_KHOBAQD_DONGBO_THUHOI + v_TOTAL_KHOBAQD_DUOGNSU_DONGBO_THUHOI;
        v_TOTAL_CHO_DONGBO := v_TOTAL_KHOBAQD_CHO_DONGBO + v_TOTAL_KHOBAQD_DUOGNSU_CHO_DONGBO;
        v_TOTAL_CHO_THUHOI := v_TOTAL_KHOBAQD_CHO_THUHOI + v_TOTAL_KHOBAQD_DUOGNSU_CHO_THUHOI;
        -- kiểm tra trạng thái đang đồng bộ, là trạng thái chỉ có 
        
        CASE 
            WHEN v_TRANGTHAIBAQD_HIENTAI IN (0, 1) THEN
                -- Xử lý nhóm trạng thái đồng bộ
                if v_TOTAL_CHO_DONGBO = v_TOTAL then
                    v_TRANGTHAIBAQD := 0;
                elsIF v_TOTAL_DONGBO = v_TOTAL THEN
                    v_TRANGTHAIBAQD := 2; -- đã đồng bộ
                elsIF v_TOTAL_DONGBO > 0 THEN
                    v_TRANGTHAIBAQD := 1; -- đã đồng bộ
                END IF;
            WHEN v_TRANGTHAIBAQD_HIENTAI = 2 THEN
                v_TRANGTHAIBAQD := 2;
            -- kiểm tra có về trạng thái đang đồng bộ hay chờ đồng bộ, hay chờ thu hồi hay đang thu hồi
            WHEN v_TRANGTHAIBAQD_HIENTAI IN (3, 4) THEN
                -- Xử lý nhóm trạng thái thu hồi
                IF v_TOTAL_CHO_THUHOI = v_TOTAL THEN
                    v_TRANGTHAIBAQD := 3; -- chờ thu hồi
                ELSIF v_TOTAL_DONGBO_THUHOI = v_TOTAL THEN
                    v_TRANGTHAIBAQD := 5; -- đã thu hồi
                ELSIF v_TOTAL_DONGBO_THUHOI > 0 THEN
                    v_TRANGTHAIBAQD := 4; -- đang thu hồi
                END IF;
        END CASE;
        
    END;
    
    RETURN v_TRANGTHAIBAQD;
END GET_TRANGTHAIBAQD;


FUNCTION GET_TRANGTHAI_DUONGSU
( 
    vID IN NUMBER
)RETURN NUMBER AS
    v_TRANGTHAIDUONGSU NUMBER;
BEGIN
    declare
        v_TRANGTHAI_DUONGSU_HIENTAI NUMBER;
        
        v_TOTAL NUMBER;
        v_TOTAL_DONGBO NUMBER;
        v_TOTAL_CHO_DONGBO NUMBER;
        v_TOTAL_DONGBO_THUHOI NUMBER;
        v_TOTAL_CHO_THUHOI NUMBER;
    begin
        
        select TRANGTHAIDUONGSU into v_TRANGTHAI_DUONGSU_HIENTAI from KHOBAQD_DUONGSU where ID = vID and STATUS = 1;
    
        select 
        SUM(CASE WHEN STATUS = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 0 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 0 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 1 and SUKIEN = 1 THEN 1 ELSE 0 END),
        SUM(CASE WHEN STATUS = 1 AND TRANGTHAIDONGBO = 0 and SUKIEN = 1 THEN 1 ELSE 0 END)
        INTO 
            v_TOTAL,
            v_TOTAL_DONGBO,
            v_TOTAL_CHO_DONGBO,
            v_TOTAL_DONGBO_THUHOI,
            v_TOTAL_CHO_THUHOI
        from KHOBAQD_DUONGSU_DONGBO
        where KHOBAQD_DUONGSU_ID = vID;
        
        CASE 
            WHEN v_TRANGTHAI_DUONGSU_HIENTAI IN (0, 1) THEN
                -- Xử lý nhóm trạng thái đồng bộ
                if v_TOTAL_CHO_DONGBO = v_TOTAL then
                    v_TRANGTHAIDUONGSU := 0;
                elsIF v_TOTAL_DONGBO = v_TOTAL THEN
                    v_TRANGTHAIDUONGSU := 2; -- đã đồng bộ
                elsIF v_TOTAL_DONGBO > 0 THEN
                    v_TRANGTHAIDUONGSU := 1; -- đã đồng bộ
                END IF;
            WHEN v_TRANGTHAI_DUONGSU_HIENTAI = 2 THEN
                v_TRANGTHAIDUONGSU := 2;
            -- kiểm tra có về trạng thái đang đồng bộ hay chờ đồng bộ, hay chờ thu hồi hay đang thu hồi
            WHEN v_TRANGTHAI_DUONGSU_HIENTAI IN (3, 4) THEN
                -- Xử lý nhóm trạng thái thu hồi
                IF v_TOTAL_CHO_THUHOI = v_TOTAL THEN
                    v_TRANGTHAIDUONGSU := 3; -- chờ thu hồi
                ELSIF v_TOTAL_DONGBO_THUHOI = v_TOTAL THEN
                    v_TRANGTHAIDUONGSU := 5; -- đã thu hồi
                ELSIF v_TOTAL_DONGBO_THUHOI > 0 THEN
                    v_TRANGTHAIDUONGSU := 4; -- đang thu hồi
                END IF;
        END CASE;
    end;
return v_TRANGTHAIDUONGSU;
END GET_TRANGTHAI_DUONGSU;


PROCEDURE JobShareUpdateStatusDoiTuongToTungC12
( vID number,
  vReturn OUT number
)
IS 
vKHOBAQDID number;
BEGIN
    SAVEPOINT P1;

    UPDATE KHOBAQD_DUONGSU_DONGBO SET NGAYDONGBO = SYSDATE, TRANGTHAIDONGBO = 1 --trạng thái = đã đồng bộ
    WHERE KHOBAQD_DUONGSU_ID = vID AND NOIDONGBO = 'C12' AND STATUS = 1;
    
    -- lấy ra Id của khobanqd
    declare
        v_KHOBAQDID NUMBER;
        v_TRANGTHAIBAQD NUMBER;
        v_TRANGTHAI_DUONGSU NUMBER;
    begin
        select KHOBAQDID into v_KHOBAQDID from KHOBAQD_DUONGSU where ID = vID; 
        
        v_TRANGTHAI_DUONGSU := PKG_JOBSHARE_C12.GET_TRANGTHAI_DUONGSU(vID);
        update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = v_TRANGTHAI_DUONGSU where ID = vID;
        
        v_TRANGTHAIBAQD := PKG_JOBSHARE_C12.GET_TRANGTHAIBAQD(v_KHOBAQDID);
        update KHOBAQD set TRANGTHAIBAQD = v_TRANGTHAIBAQD where Id = v_KHOBAQDID;
    end;

    COMMIT;
    vReturn := 1;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;
	vReturn := 0;
END JobShareUpdateStatusDoiTuongToTungC12;

END PKG_JOBSHARE_C12;

/
