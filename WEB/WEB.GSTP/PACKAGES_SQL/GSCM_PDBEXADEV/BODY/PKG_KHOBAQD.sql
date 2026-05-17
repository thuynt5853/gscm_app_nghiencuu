--------------------------------------------------------
--  DDL for Package Body PKG_KHOBAQD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_KHOBAQD" AS

PROCEDURE GET_LICH_SU_DULIEU_DONGBO
(  
    p_KHOBAQDID IN NUMBER,
    
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
TotalItem number;  MinIndex number; MaxIndex number;
BEGIN	
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
 OPEN CURRETURN FOR
        SELECT tt.* FROM(
            SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAY desc) STT, COUNT(*) OVER () as CountAll
                ,A.* FROM (
                SELECT  KHOBAQDID,
                    TO_CHAR(MIN(B.ngaytao), 'dd/MM/yyyy') AS NGAY,
                    CASE SUKIEN
                        WHEN 0 THEN 'Thêm mới'
                        ELSE 'Thu hồi'
                    END AS HOATDONG,
                    LISTAGG(
                         CASE 
                            WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                                CASE 
                                    WHEN TRANGTHAIDONGBO = 0 THEN
                                       NOIDONGBO ||  ': Đang thu hồi'
                                       ELSE
                                        NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                                END
                            ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                                CASE 
                                    WHEN TRANGTHAIDONGBO = 1 THEN
                                        NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                                    when TRANGTHAIDONGBO = 0 then
                                        NOIDONGBO || ': Đang đồng bộ'
                                     ELSE
                                        'Chưa đồng bộ'
                                END
                        END,
                        '<br/>'
                    ) WITHIN GROUP (ORDER BY NOIDONGBO) AS KETQUA
                    FROM KHOBAQD_DONGBO B
                    left join KHOBAQD C on C.ID = B.KHOBAQDID
                    WHERE KHOBAQDID = p_KHOBAQDID and C.STATUS = 1 and B.STATUS = 1
                    GROUP BY SUKIEN, KHOBAQDID
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<= MaxIndex
         ;
END GET_LICH_SU_DULIEU_DONGBO;


FUNCTION INSERT_KHOBAQD_DONGBO
( 
    p_KHOBAQDID IN NUMBER,
    v_TAIKHOANTAO in VARCHAR2,
    p_SUKIEN in NUMBER
)RETURN NUMBER AS

BEGIN
        SAVEPOINT INSERT_KHOBAQD_DONGBO;

        FOR item IN (
            select A.MA from DM_DATAITEM A
            left join DM_DATAGROUP B on A.GROUPID = B.ID
            where B.MA = 'NOIDONGBO'
        ) LOOP
            INSERT INTO KHOBAQD_DONGBO (
            ID,KHOBAQDID,NOIDONGBO,NGAYDONGBO,TRANGTHAIDONGBO,STATUS,TAIKHOANTAO,
            NGAYTAO,SUKIEN,LOAISUKIEN)
            Values(KHOBAQD_DONGBO_SEQ.NEXTVAL,p_KHOBAQDID,item.MA,null,0,1,
            v_TAIKHOANTAO,SYSDATE,p_SUKIEN,0);
        END LOOP;
        
    RETURN 1;
    EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT INSERT_KHOBAQD_DONGBO;
	RETURN 0;
END INSERT_KHOBAQD_DONGBO;

FUNCTION INSERT_KHOBAQD_DUONGSU_DONGBO
( 
    p_KHOBAQD_DUONGSU_ID IN NUMBER,
    p_TAIKHOANTAO in VARCHAR2,
    p_SUKIEN in NUMBER
)RETURN NUMBER AS

BEGIN
        SAVEPOINT INSERT_KHOBAQD_DUONGSU_DONGBO;
        
        FOR item IN (
            select A.MA from DM_DATAITEM A
            left join DM_DATAGROUP B on A.GROUPID = B.ID
            where B.MA = 'NOIDONGBO'
        ) LOOP
            INSERT INTO KHOBAQD_DUONGSU_DONGBO (
                    ID,KHOBAQD_DUONGSU_ID,NOIDONGBO,NGAYDONGBO,TRANGTHAIDONGBO,
                    STATUS,TAIKHOANTAO,NGAYTAO,SUKIEN
                )Values(KHOBAQD_DUONGSU_DONGBO_SEQ.nextval,p_KHOBAQD_DUONGSU_ID,
                item.MA, null, 0, 1, p_TAIKHOANTAO, SYSDATE, 
                p_SUKIEN);
        END LOOP;
    RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT INSERT_KHOBAQD_DUONGSU_DONGBO;
	RETURN 0;
END INSERT_KHOBAQD_DUONGSU_DONGBO;

-- hủy chuyển đối với dữ liệu KHOBAQD_DONGBO
FUNCTION HUYCHUYEN_DULIEU_KHOBAQD_DONGBO
(   
    p_KHOBAQDID IN NUMBER
)RETURN NUMBER AS
p_ID NUMBER := 0;
BEGIN

    SAVEPOINT HUYCHUYEN_DULIEU_KHOBAQD_DONGBO;
    --Xoa Don khoi Sổ Văn Đơn
        declare 
        countGuiLai NUMBER;
        Begin
            -- lấy dữ liệu kiểm tra có phải gửi lại hay không  
            SELECT 
            COUNT(1)
            INTO countGuiLai
            FROM KHOBAQD
            WHERE STATUS = 1
              AND ID = p_KHOBAQDID
              AND ISGUILAI = 1;
            
            IF countGuiLai > 0 then
                declare
                    p_DONID NUMBER;
                    p_LINHVUC VARCHAR2(200);
                    p_CAPXX VARCHAR2(200);
                    p_TOAANID NUMBER;
                    
                begin
                    select DONID,LINHVUC,CAPXX,TOAANID into p_DONID,p_LINHVUC,p_CAPXX,p_TOAANID from KHOBAQD where ID = p_KHOBAQDID;
                    
                    -- lấy Id bản án trước đó
                    select ID into p_ID
                    from KHOBAQD
                    where DONID = p_DONID
                      and LINHVUC = p_LINHVUC
                      and CAPXX = p_CAPXX
                      and TOAANID = p_TOAANID
                      and STATUS = 0
                      and ISGUILAI = 0
                      and TRANGTHAIBAQD = 5
                    order by NGAYTAO desc
                    fetch first 1 row only;
                    
                    -- xóa dữ liệu hủy chuyển
                    delete from KHOBAQD where ID = p_KHOBAQDID and STATUS = 1 and ISGUILAI = 1;
                    delete KHOBAQD_DONGBO where KHOBAQDID = p_KHOBAQDID and STATUS = 1;
                    
                    
                    update KHOBAQD set STATUS = 1 where ID = p_ID;
                    UPDATE KHOBAQD_DONGBO t
                    SET t.STATUS = 1
                    WHERE t.ID IN (
                        SELECT ID FROM (
                            SELECT t.ID,
                                   ROW_NUMBER() OVER (
                                        PARTITION BY NOIDONGBO
                                        ORDER BY NGAYTAO DESC, ID DESC
                                   ) AS rn
                            FROM KHOBAQD_DONGBO t
                            WHERE KHOBAQDID = p_ID
                              AND STATUS = 0 and SUKIEN = 1
                        )
                        WHERE rn = 1
                    );

                end;
            else
                delete KHOBAQD where Id = p_KHOBAQDID and STATUS = 1;
                delete KHOBAQD_DONGBO where KHOBAQDID = p_KHOBAQDID and STATUS = 1;
                
                p_ID := p_KHOBAQDID;
            end if;
        end;
    RETURN p_ID;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	--DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_KHOBAQD_DONGBO;
RETURN 0;
END HUYCHUYEN_DULIEU_KHOBAQD_DONGBO;
-- thu hồi đối với dữ liệu KHOBAQD_DUONGSU_DONGBO
FUNCTION HUYCHUYEN_DULIEU_DUONGSU
(   
    p_KHOBAQDID IN NUMBER,
    p_KHOBAQDID_OLD IN NUMBER,
    p_DUONGSUID IN NUMBER
)RETURN NUMBER AS
BEGIN
    SAVEPOINT HUYCHUYEN_DULIEU_DUONGSU;

    FOR duongsu IN (
    SELECT B.ID, B.DUONGSUID, B.DONID
    FROM KHOBAQD_DUONGSU B
    WHERE B.KHOBAQDID = p_KHOBAQDID and STATUS = 1 and (p_DUONGSUID is null or B.DUONGSUID = p_DUONGSUID)
    ) LOOP
        -- kiểm tra bản ghi đó đã thu hồi hay chưa
        declare 
        countGuiLai NUMBER;
        Begin
            -- lấy dữ liệu kiểm tra có đang thu hồi hay không
            --SELECT 
            --COUNT(1)
            --INTO countThuHoi
            --FROM KHOBAQD_DUONGSU_DONGBO
            --WHERE STATUS = 1
              --AND KHOBAQD_DUONGSU_ID = duongsu.Id 
              --AND SUKIEN = 1;
              
            -- lấy dữ liệu kiểm tra có phải gửi lại hay không  
            SELECT 
            COUNT(1)
            INTO countGuiLai
            FROM KHOBAQD_DUONGSU
            WHERE STATUS = 1
              AND ID = duongsu.Id 
              AND ISGUILAI = 1;
            
            -- nếu đang thu hồi
            --if countThuHoi >0 then
                -- xóa KHOBAQD_DUONGSU_DONGBO
                --delete KHOBAQD_DUONGSU_DONGBO where KHOBAQD_DUONGSU_ID = duongsu.Id and SUKIEN = 1 and STATUS = 1;
                --Update KHOBAQD_DUONGSU_DONGBO set STATUS = 1 where KHOBAQD_DUONGSU_ID = duongsu.Id;
                
                --UPDATE KHOBAQD_DUONGSU_DONGBO t
                --SET t.STATUS = 1
                --WHERE t.ID IN (
                    --SELECT ID FROM (
                        --SELECT t.ID,
                               --ROW_NUMBER() OVER (
                                    --PARTITION BY NOIDONGBO
                                    --ORDER BY NGAYTAO DESC, ID DESC
                               --) AS rn
                        --FROM KHOBAQD_DUONGSU_DONGBO t
                        --WHERE KHOBAQD_DUONGSU_ID = duongsu.Id
                          --AND STATUS = 0
                    --)
                    --WHERE rn = 1
                --);
            IF countGuiLai > 0 then
                -- xóa dữ liệu đương sự 
                delete from KHOBAQD_DUONGSU where Id = duongsu.Id and STATUS = 1 and ISGUILAI = 1 ;
                
                -- xóa dữ liệu đương sự đồng bộ
                delete KHOBAQD_DUONGSU_DONGBO where KHOBAQD_DUONGSU_ID = duongsu.Id and STATUS = 1;
                    
                -- update lại bản ghi cũ
                DECLARE
                    v_ID NUMBER;
                BEGIN
                        -- Lấy bản ghi mới nhất
                        SELECT ID INTO v_ID
                        FROM (
                            SELECT ID
                            FROM KHOBAQD_DUONGSU
                            WHERE STATUS = 0
                              AND KHOBAQDID = p_KHOBAQDID_OLD
                              AND DUONGSUID = duongsu.DUONGSUID
                            ORDER BY NGAYTAO DESC, ID DESC
                        )
                        WHERE ROWNUM = 1;
                
                        -- Update bảng cha
                        UPDATE KHOBAQD_DUONGSU
                        SET STATUS = 1
                        WHERE ID = v_ID;
                
                        -- Update bảng đồng bộ
                        UPDATE KHOBAQD_DUONGSU_DONGBO t
                        SET t.STATUS = 1
                        WHERE t.ID IN (
                            SELECT ID FROM (
                                SELECT t.ID,
                                       ROW_NUMBER() OVER (
                                           PARTITION BY NOIDONGBO
                                           ORDER BY NGAYTAO DESC, ID DESC
                                       ) rn
                                FROM KHOBAQD_DUONGSU_DONGBO t
                                WHERE KHOBAQD_DUONGSU_ID = v_ID
                                  AND STATUS = 0
                                  AND SUKIEN = 1
                            )
                            WHERE rn = 1
                        );
                
                
                END;
            else
                 -- xóa KHOBAQD_DUONGSU_DONGBO
                delete KHOBAQD_DUONGSU where Id = duongsu.Id;
            
                delete KHOBAQD_DUONGSU_DONGBO
                WHERE KHOBAQD_DUONGSU_ID = duongsu.Id;
                
            END IF;

        END;
    END LOOP;
    
    
    -- kiểm tra nếu hủy chuyển toàn bộ đương sự thì bản án cũng sẽ hủy chuyển theo
    declare
     v_CountDuongSu NUMBER;
     begin
        SELECT count(*) into v_CountDuongSu
        FROM KHOBAQD_DUONGSU B
        WHERE B.KHOBAQDID = p_KHOBAQDID and STATUS = 1;
        
        -- nếu không có đương sự thì xóa luôn bản án, bản án đông bộ
        if v_CountDuongSu = 0 then

        DECLARE
            v_ret NUMBER;
        BEGIN
            v_ret := HUYCHUYEN_DULIEU_KHOBAQD_DONGBO(p_KHOBAQDID);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_DONGBO;
                RETURN 0;
            end if;
        END;
        
        end if;
     end;
    
    RETURN 1;
--EXCEPTION
--WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	--DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	--ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_DUONGSU;
	--RETURN 0;
END HUYCHUYEN_DULIEU_DUONGSU;

FUNCTION HUYCHUYEN_DULIEU_DONGBO
(   
    p_KHOBAQDID IN NUMBER
)RETURN NUMBER AS

BEGIN
    SAVEPOINT HUYCHUYEN_DULIEU_DONGBO;
    
    DECLARE
        v_ret NUMBER;
        BEGIN
            v_ret := HUYCHUYEN_DULIEU_KHOBAQD_DONGBO(p_KHOBAQDID);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_DONGBO;
                RETURN 0;
            end if;
            
            v_ret := HUYCHUYEN_DULIEU_DUONGSU(p_KHOBAQDID,v_ret,null);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_DONGBO;
                RETURN 0;
            end if;
            
        END;
    RETURN 1;	
    	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT HUYCHUYEN_DULIEU_DONGBO;
	RETURN 0;
END HUYCHUYEN_DULIEU_DONGBO;


-- gửi lại đối với dữ liệu KHOBAQD_DUONGSU_DONGBO
FUNCTION GUILAI_DULIEU_DUONGSU_DONGBO
(   
    p_KHOBAQDID IN NUMBER,
    p_TAIKHOANTAO IN VARCHAR2,
    p_KHOBAQDID_NEW IN NUMBER,
    p_DUONGSUID IN NUMBER,
    P_Json IN CLOB
)RETURN NUMBER AS

BEGIN
    --Xoa Don khoi Sổ Văn Đơn
    SAVEPOINT GUILAI_DULIEU_DUONGSU_DONGBO;
    
    FOR duongsu IN (
    SELECT *
    FROM KHOBAQD_DUONGSU B
    WHERE B.KHOBAQDID = p_KHOBAQDID and STATUS = 1 and (p_DUONGSUID is null or B.DUONGSUID = p_DUONGSUID)
    ) LOOP
        declare p_KHOBAQD_DUONGSU_ID_NEW NUMBER;
        begin
             -- cập nhật status bảng KHOBAQD_DONGBO = 0 là inactive
            update KHOBAQD_DUONGSU set STATUS = 0 where Id = duongsu.Id;
            
            -- cập nhật status bảng KHOBAQD_DONGBO = 0 là inactive
            update KHOBAQD_DUONGSU_DONGBO set STATUS = 0 where KHOBAQD_DUONGSU_ID = duongsu.Id and STATUS = 1;
            
        end;
        
    END LOOP;
    
    FOR item IN (
            SELECT KHOBAQDID, DUONGSUID, DONID,DOITUONGPHAMTOI,SODINHDANH,HOVATEN,TENKHAC,GIOITINH,
        TONGIAO,DANTOC,QUOCTICH,NAMSINH,THANGNAM,NGAYTHANGNAM,DIACHICHITIET
        ,MAXA, MAHUYEN,MATINH,QUOCGIA,LOAIGIAYTO,NGAYCAP,SOGIAYTO,NGAYHETHAN,SODINHDANHNN,SOGIAYTOXNC,LOAIGIAYTOXNC,HOTENNN,
        QUOCTICHNN,NGAYSINHNN,NAMSINHNN,THANGNAMNN,NGAYTHANGNAMNN,GIOITINHNN,MADDTC,MASOTHUE,TENTOCHUCTIENGVIET,TENTOCHUCNUOCNGOAI,
        TENTOCHUCVIETTAT,LOAIHINHTC,SODINHDANHDAIDIEN,HOVATENDAIDIEN,DIACHICHITIETRUSO,
        MAXATRUSO,MAHUYENTRUSO,MATINHTRUSO,QUOCGIATRUSO,TUCACHTOTUNG,DSTOIDANH,ANPHI,MIENPHI,TAIKHOANTAO
        ,DSHINHPHATCHINH,DSHINHPHATBOSUNG,NGAYNHANTONGDAT,DSTOIDANHC06,TENTOIDANHC06,TENHINHPHATC06
          FROM JSON_TABLE(
            p_json,
            '$[*]' COLUMNS (
              KHOBAQDID NUMBER PATH '$.KHOBAQDID',
              DUONGSUID NUMBER PATH '$.DUONGSUID',
              DONID NUMBER PATH '$.DONID',
              DOITUONGPHAMTOI NUMBER PATH '$.DOITUONGPHAMTOI',
              SODINHDANH VARCHAR2(100) PATH '$.SODINHDANH',
              HOVATEN VARCHAR2(100) PATH '$.HOVATEN',
              TENKHAC VARCHAR2(100) PATH '$.TENKHAC',
              GIOITINH NUMBER PATH '$.GIOITINH',
              TONGIAO VARCHAR2(100) PATH '$.TONGIAO',
              DANTOC VARCHAR2(100) PATH '$.DANTOC',
              QUOCTICH VARCHAR2(100) PATH '$.QUOCTICH',
              NAMSINH VARCHAR2(100) PATH '$.NAMSINH',
              THANGNAM VARCHAR2(100) PATH '$.THANGNAM',
              NGAYTHANGNAM VARCHAR2(100) PATH '$.NGAYTHANGNAM',
              DIACHICHITIET VARCHAR2(100) PATH '$.DIACHICHITIET',
              MAXA VARCHAR2(100) PATH '$.MAXA',
              MAHUYEN VARCHAR2(100) PATH '$.MAHUYEN',
              MATINH VARCHAR2(100) PATH '$.MATINH',
              QUOCGIA VARCHAR2(100) PATH '$.QUOCGIA',
              LOAIGIAYTO VARCHAR2(100) PATH '$.LOAIGIAYTO',
              NGAYCAP VARCHAR2(100) PATH '$.NGAYCAP',
              SOGIAYTO VARCHAR2(100) PATH '$.SOGIAYTO',
              NGAYHETHAN VARCHAR2(100) PATH '$.NGAYHETHAN',
              SODINHDANHNN VARCHAR2(100) PATH '$.SODINHDANHNN',
              SOGIAYTOXNC VARCHAR2(100) PATH '$.SOGIAYTOXNC',
              LOAIGIAYTOXNC VARCHAR2(100) PATH '$.LOAIGIAYTOXNC',
              HOTENNN VARCHAR2(100) PATH '$.HOTENNN',
              QUOCTICHNN VARCHAR2(100) PATH '$.QUOCTICHNN',
              NGAYSINHNN VARCHAR2(100) PATH '$.NGAYSINHNN',
              NAMSINHNN VARCHAR2(100) PATH '$.NAMSINHNN',
              THANGNAMNN VARCHAR2(100) PATH '$.THANGNAMNN',
              NGAYTHANGNAMNN VARCHAR2(100) PATH '$.NGAYTHANGNAMNN',
              GIOITINHNN VARCHAR2(100) PATH '$.GIOITINHNN',
              MADDTC VARCHAR2(100) PATH '$.MADDTC',
              MASOTHUE VARCHAR2(100) PATH '$.MASOTHUE',
              TENTOCHUCTIENGVIET VARCHAR2(100) PATH '$.TENTOCHUCTIENGVIET',
              TENTOCHUCNUOCNGOAI VARCHAR2(100) PATH '$.TENTOCHUCNUOCNGOAI',
              TENTOCHUCVIETTAT VARCHAR2(100) PATH '$.TENTOCHUCVIETTAT',
              LOAIHINHTC VARCHAR2(100) PATH '$.LOAIHINHTC',
              SODINHDANHDAIDIEN VARCHAR2(100) PATH '$.SODINHDANHDAIDIEN',
              HOVATENDAIDIEN VARCHAR2(100) PATH '$.HOVATENDAIDIEN',
              DIACHICHITIETRUSO VARCHAR2(100) PATH '$.DIACHICHITIETRUSO',
              MAXATRUSO VARCHAR2(100) PATH '$.MAXATRUSO',
              MAHUYENTRUSO VARCHAR2(100) PATH '$.MAHUYENTRUSO',
              MATINHTRUSO VARCHAR2(100) PATH '$.MATINHTRUSO',
              QUOCGIATRUSO VARCHAR2(100) PATH '$.QUOCGIATRUSO',
              TUCACHTOTUNG VARCHAR2(100) PATH '$.TUCACHTOTUNG',
              DSTOIDANH VARCHAR2(4000) PATH '$.DSTOIDANH',
              ANPHI VARCHAR2(100) PATH '$.ANPHI',
              MIENPHI VARCHAR2(100) PATH '$.MIENPHI',
              TAIKHOANTAO VARCHAR2(100) PATH '$.TAIKHOANTAO',
              DSHINHPHATCHINH VARCHAR2(4000) PATH '$.DSHINHPHATCHINH',
              DSHINHPHATBOSUNG VARCHAR2(4000) PATH '$.DSHINHPHATBOSUNG',
              NGAYNHANTONGDAT date PATH '$.NGAYNHANTONGDAT',
              DSTOIDANHC06 VARCHAR2(4000) PATH '$.DSTOIDANHC06',
              TENTOIDANHC06 VARCHAR2(500) PATH '$.TENTOIDANHC06',
              TENHINHPHATC06 VARCHAR2(500) PATH '$.TENHINHPHATC06'
            )
          )
        ) LOOP
        
        DECLARE
            p_KHOBAQD_DUONGSU_ID_NEW NUMBER;
            BEGIN

                select KHOBAQD_DUONGSU_SEQ.nextval into p_KHOBAQD_DUONGSU_ID_NEW from dual;
            -- lưu vào bảng đương sự
                INSERT INTO KHOBAQD_DUONGSU (ID,KHOBAQDID, DUONGSUID, DONID,DOITUONGPHAMTOI,SODINHDANH,HOVATEN,TENKHAC,GIOITINH,
                TONGIAO,DANTOC,QUOCTICH,NAMSINH,THANGNAM,NGAYTHANGNAM,DIACHICHITIET
                ,MAXA, MAHUYEN,MATINH,QUOCGIA,LOAIGIAYTO,NGAYCAP,SOGIAYTO,NGAYHETHAN,SODINHDANHNN,SOGIAYTOXNC,LOAIGIAYTOXNC,HOTENNN,
                QUOCTICHNN,NGAYSINHNN,NAMSINHNN,THANGNAMNN,NGAYTHANGNAMNN,GIOITINHNN,MADDTC,MASOTHUE,TENTOCHUCTIENGVIET,TENTOCHUCNUOCNGOAI,
                TENTOCHUCVIETTAT,LOAIHINHTC,SODINHDANHDAIDIEN,HOVATENDAIDIEN,DIACHICHITIETRUSO
                ,MAXATRUSO,MAHUYENTRUSO,MATINHTRUSO,QUOCGIATRUSO,TUCACHTOTUNG,DSTOIDANH,ANPHI,MIENPHI,TAIKHOANTAO,NGAYTAO,STATUS
                ,DSHINHPHATCHINH,DSHINHPHATBOSUNG,NGAYNHANTONGDAT,DSTOIDANHC06,TENTOIDANHC06,TENHINHPHATC06,GHICHU,TRANGTHAIDUONGSU,ISGUILAI)
                Values(p_KHOBAQD_DUONGSU_ID_NEW,p_KHOBAQDID_NEW, item.DUONGSUID, item.DONID,item.DOITUONGPHAMTOI,item.SODINHDANH,item.HOVATEN,item.TENKHAC,item.GIOITINH,
                item.TONGIAO,item.DANTOC,item.QUOCTICH,item.NAMSINH,item.THANGNAM,item.NGAYTHANGNAM,item.DIACHICHITIET
                ,item.MAXA, item.MAHUYEN,item.MATINH,item.QUOCGIA,item.LOAIGIAYTO,item.NGAYCAP,item.SOGIAYTO,item.NGAYHETHAN,item.SODINHDANHNN,
                item.SOGIAYTOXNC,item.LOAIGIAYTOXNC,item.HOTENNN,
                item.QUOCTICHNN,item.NGAYSINHNN,item.NAMSINHNN,item.THANGNAMNN,item.NGAYTHANGNAMNN,item.GIOITINHNN,item.MADDTC
                ,item.MASOTHUE,item.TENTOCHUCTIENGVIET,item.TENTOCHUCNUOCNGOAI,
                item.TENTOCHUCVIETTAT,item.LOAIHINHTC,item.SODINHDANHDAIDIEN,item.HOVATENDAIDIEN,item.DIACHICHITIETRUSO
                ,item.MAXATRUSO,item.MAHUYENTRUSO,item.MATINHTRUSO,item.QUOCGIATRUSO,item.TUCACHTOTUNG,item.DSTOIDANH,item.ANPHI,
                item.MIENPHI,item.TAIKHOANTAO,SYSDATE,1,item.DSHINHPHATCHINH,item.DSHINHPHATBOSUNG,item.NGAYNHANTONGDAT,
                item.DSTOIDANHC06,item.TENTOIDANHC06,item.TENHINHPHATC06,null,0,1);
                
                -- lưu dữ liệu vào đương sự đồng bộ
                DECLARE
                v_ret NUMBER;
                BEGIN
                    v_ret := INSERT_KHOBAQD_DUONGSU_DONGBO(p_KHOBAQD_DUONGSU_ID_NEW,p_TAIKHOANTAO,0);
                    
                    if v_ret = 0 then
                            ROLLBACK TO SAVEPOINT GUILAI_DULIEU_DUONGSU_DONGBO;
                            RETURN 0;
                        end if;
                END;
            END;
        END LOOP;
    
    
    RETURN 1;	
    
    EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT GUILAI_DULIEU_DUONGSU_DONGBO;
	RETURN 0;
END GUILAI_DULIEU_DUONGSU_DONGBO;

-- thu hồi đối với dữ liệu KHOBAQD_DONGBO
FUNCTION GUILAI_DULIEU_KHOBAQD_DONGBO
(   
    p_KHOBAQDID IN NUMBER,
    v_DONID IN NUMBER,
    v_LINHVUC IN VARCHAR2,
    v_CAPXX IN NUMBER,
    v_LOAIBAQD IN NUMBER,
    v_IDBAQD IN NUMBER,
    v_QUANHEPHAPLUATID IN NUMBER,
    v_SOBAQD IN VARCHAR2,
    v_NGAYBAQD IN Date,
    v_NGAYHIEULUCBAQD IN Date,
    v_MACQ IN VARCHAR2,
    v_COQUANQD IN VARCHAR2,
    v_TAIKHOANTAO IN VARCHAR2,
    v_MAVANBAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_DSBAQDLIENQUAN IN VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    v_THAMPHAN IN VARCHAR2,
    v_LOAIQDHN IN VARCHAR2,
    v_TRANGTHAIBAQD IN NUMBER
)RETURN NUMBER AS
p_KHOBAQDID_NEW NUMBER;
BEGIN
    --Xoa Don khoi Sổ Văn Đơn
    SAVEPOINT GUILAI_DULIEU_KHOBAQD_DONGBO;
    
         -- cập nhật status bảng KHOBAQD = 0 là inactive
        update KHOBAQD set STATUS = 0 where ID = p_KHOBAQDID and STATUS = 1;
        
        select KHOBAQD_SEQ.nextval into p_KHOBAQDID_NEW from dual;
        -- insert toàn bộ bản ghi mới vào KHOBAQD với trạng thái là thu hồi
        INSERT INTO KHOBAQD (
            ID,DONID, LINHVUC, CAPXX, LOAIBAQD, IDBAQD, QUANHEPHAPLUATID, SOBAQD, NGAYBAQD, NGAYHIEULUCBAQD,
            MACQ, COQUANQD, TAIKHOANTAO, NGAYTAO, MAVANBAN, STATUS,TOAANID,DSBAQDLIENQUAN,SOTHULY,THAMPHAN,LOAIQDHN,TRANGTHAIBAQD
            ,GHICHU,ISGUILAI
        )
        Values(p_KHOBAQDID_NEW,v_DONID,v_LINHVUC,v_CAPXX,v_LOAIBAQD,v_IDBAQD,v_QUANHEPHAPLUATID,v_SOBAQD,v_NGAYBAQD,
        v_NGAYHIEULUCBAQD,v_MACQ,v_COQUANQD,v_TAIKHOANTAO,sysdate,v_MAVANBAN,1,v_TOAANID,v_DSBAQDLIENQUAN,v_SOTHULY,v_THAMPHAN,v_LOAIQDHN,v_TRANGTHAIBAQD,null, 1);            
            
        -- cập nhật status bảng KHOBAQD_DONGBO = 0 là inactive
        update KHOBAQD_DONGBO set STATUS = 0 where KHOBAQDID = p_KHOBAQDID and STATUS = 1;
        
        -- insert toàn bộ bản ghi mới vào KHOBAQD_DONGBO
        DECLARE
        v_ret NUMBER;
        BEGIN
            v_ret := INSERT_KHOBAQD_DONGBO(p_KHOBAQDID_NEW,v_TAIKHOANTAO,0);
            
            if v_ret = 0 then
                        ROLLBACK TO SAVEPOINT GUILAI_DULIEU_KHOBAQD_DONGBO;
                        RETURN 0;
                    end if;
        END;
        
    RETURN p_KHOBAQDID_NEW;
    
        EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT GUILAI_DULIEU_KHOBAQD_DONGBO;
	RETURN 0;
END GUILAI_DULIEU_KHOBAQD_DONGBO;

-- gửi lại dữ liệu đồng bộ
FUNCTION GUILAI_DULIEU_DONGBO
(   
    p_KHOBAQDID IN NUMBER,
    v_DONID IN NUMBER,
    v_LINHVUC IN VARCHAR2,
    v_CAPXX IN NUMBER,
    v_LOAIBAQD IN NUMBER,
    v_IDBAQD IN NUMBER,
    v_QUANHEPHAPLUATID IN NUMBER,
    v_SOBAQD IN VARCHAR2,
    v_NGAYBAQD IN Date,
    v_NGAYHIEULUCBAQD IN Date,
    v_MACQ IN VARCHAR2,
    v_COQUANQD IN VARCHAR2,
    v_TAIKHOANTAO IN VARCHAR2,
    v_MAVANBAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_DSBAQDLIENQUAN IN VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    v_THAMPHAN IN VARCHAR2,
    v_LOAIQDHN IN VARCHAR2,
    v_TRANGTHAIBAQD IN NUMBER,
    P_Json IN CLOB
)RETURN NUMBER AS

BEGIN
    SAVEPOINT GUILAI_DULIEU_DONGBO;
    
    DECLARE
        v_ret NUMBER;
        BEGIN
            v_ret := GUILAI_DULIEU_KHOBAQD_DONGBO(p_KHOBAQDID,
                                                    v_DONID,
                                                    v_LINHVUC,
                                                    v_CAPXX,
                                                    v_LOAIBAQD,
                                                    v_IDBAQD,
                                                    v_QUANHEPHAPLUATID,
                                                    v_SOBAQD,
                                                    v_NGAYBAQD,
                                                    v_NGAYHIEULUCBAQD,
                                                    v_MACQ,
                                                    v_COQUANQD,
                                                    v_TAIKHOANTAO,
                                                    v_MAVANBAN,
                                                    v_TOAANID,
                                                    v_DSBAQDLIENQUAN,
                                                    v_SOTHULY,
                                                    v_THAMPHAN,
                                                    v_LOAIQDHN,
                                                    v_TRANGTHAIBAQD);
            
            if v_ret = 0 then
                        ROLLBACK TO SAVEPOINT GUILAI_DULIEU_DONGBO;
                        RETURN 0;
                    end if;
            
            v_ret := GUILAI_DULIEU_DUONGSU_DONGBO(p_KHOBAQDID,v_TAIKHOANTAO,v_ret,null,P_Json);
            
            if v_ret = 0 then
                        ROLLBACK TO SAVEPOINT GUILAI_DULIEU_DONGBO;
                        RETURN 0;
                    end if;
        END;
    RETURN 1;	
    	--
        EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT GUILAI_DULIEU_DONGBO;
	RETURN 0;
END GUILAI_DULIEU_DONGBO;


-- thu hồi đối với dữ liệu KHOBAQD_DONGBO
FUNCTION THUHOI_DULIEU_KHOBAQD_DONGBO
(   
    p_KHOBAQDID IN NUMBER,
    p_TAIKHOANTAO in VARCHAR2,
    p_LYDO IN VARCHAR2
)RETURN NUMBER AS
BEGIN
    --Xoa Don khoi Sổ Văn Đơn
    SAVEPOINT THUHOI_DULIEU_KHOBAQD_DONGBO;
    
        -- cập nhật status bảng KHOBAQD_DONGBO = 0 là inactive
        update KHOBAQD set GHICHU = p_LYDO where ID = p_KHOBAQDID;
        
        update KHOBAQD_DONGBO set STATUS = 0 where KHOBAQDID = p_KHOBAQDID and STATUS = 1;
    
        -- insert toàn bộ bản ghi mới vào KHOBAQD_DONGBO với trạng thái là thu hồi
        DECLARE
        v_ret NUMBER;
        BEGIN
            v_ret := INSERT_KHOBAQD_DONGBO(p_KHOBAQDID,p_TAIKHOANTAO,1);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT THUHOI_DULIEU_KHOBAQD_DONGBO;
                RETURN 0;
            end if;
        END;
    RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT THUHOI_DULIEU_KHOBAQD_DONGBO;
	RETURN 0;
END THUHOI_DULIEU_KHOBAQD_DONGBO;

-- thu hồi đối với dữ liệu KHOBAQD_DUONGSU_DONGBO
FUNCTION THUHOI_DULIEU_DUONGSU
(   
    p_KHOBAQDID IN NUMBER,
    p_TAIKHOANTAO IN VARCHAR2,
    p_LYDO IN VARCHAR2,
    p_DUONGSUID IN NUMBER
)RETURN NUMBER AS
BEGIN
    --Xoa Don khoi Sổ Văn Đơn
    SAVEPOINT THUHOI_DULIEU_DUONGSU;
    
    FOR duongsu IN (
    SELECT B.ID, B.TRANGTHAIDUONGSU
    FROM KHOBAQD_DUONGSU B
    WHERE B.KHOBAQDID = p_KHOBAQDID and STATUS = 1 and (p_DUONGSUID is null or B.DUONGSUID = p_DUONGSUID)
    ) LOOP
        
        if duongsu.TRANGTHAIDUONGSU in (3,4,5) then
            continue;
        end if;
        
        DECLARE
        v_ret NUMBER;
        BEGIN
            -- cập nhật status bảng KHOBAQD_DONGBO = 0 là inactive
            update KHOBAQD_DUONGSU_DONGBO set STATUS = 0 where KHOBAQD_DUONGSU_ID = duongsu.Id;
        
            v_ret := INSERT_KHOBAQD_DUONGSU_DONGBO(duongsu.Id,p_TAIKHOANTAO,1);
            
            -- cập nhật lý do, trạng thái của đương sự đó
            update KHOBAQD_DUONGSU set GHICHU = p_LYDO, TRANGTHAIDUONGSU = 3
            where ID = duongsu.Id and STATUS = 1;
            
            if v_ret = 0  then
                ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DUONGSU;
                RETURN 0;
            end if;
        END;
    END LOOP;
    
    -- kiểm tra nếu thu hồi hết đương sự thì thu hồi bản án luôn
    if p_DUONGSUID is null then
        RETURN 1;
    end if;
        
    -- nếu đương sự thu hồi hết thì thu hồi cả bản án
    declare
     v_CountDuongSu NUMBER;
     begin
        SELECT count(*) into v_CountDuongSu
        FROM KHOBAQD_DUONGSU_DONGBO A
        left join KHOBAQD_DUONGSU B on B.ID = A.KHOBAQD_DUONGSU_ID and B.STATUS = 1
        WHERE B.KHOBAQDID = p_KHOBAQDID and A.STATUS = 1 and A.SUKIEN = 0;
        
        -- nếu số đương sự = 0 thì sẽ thu hồi cả bản án
        if v_CountDuongSu = 0 then
            DECLARE
                v_ret NUMBER;
            BEGIN
                v_ret := THUHOI_DULIEU_KHOBAQD_DONGBO(p_KHOBAQDID,p_TAIKHOANTAO,p_LYDO);
                -- cập nhật trạng thái bản án bằng 3
                update KHOBAQD set TRANGTHAIBAQD = 3 where ID = p_KHOBAQDID;
                if v_ret = 0 then
                    ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DONGBO;
                    RETURN 0;
                end if;
            END;
        end if;
     end;
    
    
    RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DUONGSU;
	RETURN 0;
END THUHOI_DULIEU_DUONGSU;


-- thu hồi đối với dữ liệu KHOBAQD_DONGBO
FUNCTION THUHOI_DULIEU_DONGBO
( 
    p_KHOBAQDID IN NUMBER,
    p_TAIKHOANTAO in VARCHAR2,
    p_LYDO IN VARCHAR2
)RETURN NUMBER AS

BEGIN
    SAVEPOINT THUHOI_DULIEU_DONGBO;
    
    DECLARE
        v_ret NUMBER;
        BEGIN
            v_ret := THUHOI_DULIEU_KHOBAQD_DONGBO(p_KHOBAQDID,p_TAIKHOANTAO,p_LYDO);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DONGBO;
                RETURN 0;
            end if;
            
            v_ret := THUHOI_DULIEU_DUONGSU(p_KHOBAQDID,p_TAIKHOANTAO,p_LYDO,null);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DONGBO;
                RETURN 0;
            end if;
            
            update KHOBAQD set TRANGTHAIBAQD = 3 where Id = p_KHOBAQDID;
            update KHOBAQD_DUONGSU set TRANGTHAIDUONGSU = 3 where KHOBAQDID = p_KHOBAQDID;
        END;
    RETURN 1;
    EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT THUHOI_DULIEU_DONGBO;
	RETURN 0;
END THUHOI_DULIEU_DONGBO;


FUNCTION INSERT_DULIEU_DONGBO
(   
    v_DONID IN NUMBER,
    v_LINHVUC IN VARCHAR2,
    v_CAPXX IN NUMBER,
    v_LOAIBAQD IN NUMBER,
    v_IDBAQD IN NUMBER,
    v_QUANHEPHAPLUATID IN NUMBER,
    v_SOBAQD IN VARCHAR2,
    v_NGAYBAQD IN Date,
    v_NGAYHIEULUCBAQD IN Date,
    v_MACQ IN VARCHAR2,
    v_COQUANQD IN VARCHAR2,
    v_TAIKHOANTAO IN VARCHAR2,
    v_MAVANBAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_DSBAQDLIENQUAN IN VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    v_THAMPHAN IN VARCHAR2,
    v_LOAIQDHN IN VARCHAR2,
    v_TRANGTHAIBAQD IN NUMBER,
    P_Json IN CLOB
)RETURN NUMBER AS

BEGIN
    SAVEPOINT INSERT_DULIEU_DONGBO;
        
        DECLARE
            id_khobaqd_new NUMBER;
        BEGIN
        Select KHOBAQD_SEQ.nextval into id_khobaqd_new from dual;
    
        INSERT INTO KHOBAQD (
           ID, DONID, LINHVUC, CAPXX, LOAIBAQD, IDBAQD, QUANHEPHAPLUATID, SOBAQD, NGAYBAQD, NGAYHIEULUCBAQD,
            MACQ, COQUANQD, TAIKHOANTAO, NGAYTAO, MAVANBAN,STATUS,TOAANID,DSBAQDLIENQUAN,SOTHULY,THAMPHAN,LOAIQDHN,TRANGTHAIBAQD,GHICHU,ISGUILAI
        )
        Values(id_khobaqd_new,v_DONID, v_LINHVUC, v_CAPXX, v_LOAIBAQD, v_IDBAQD, v_QUANHEPHAPLUATID, v_SOBAQD, v_NGAYBAQD, v_NGAYHIEULUCBAQD,
            v_MACQ, v_COQUANQD, v_TAIKHOANTAO, SYSDATE, v_MAVANBAN,1,v_TOAANID,v_DSBAQDLIENQUAN,v_SOTHULY,v_THAMPHAN,v_LOAIQDHN,v_TRANGTHAIBAQD,null,0);
            
     -- lưu vào bảng KHOBAQD_DONGBO
        
       declare v_ret NUMBER;
       begin
            v_ret := INSERT_KHOBAQD_DONGBO(id_khobaqd_new,v_TAIKHOANTAO,0);
            
            if v_ret = 0 then
                ROLLBACK TO SAVEPOINT INSERT_DULIEU_DONGBO;
                RETURN 0;
            end if;
            
            v_ret := INSERT_DULIEU_DUONGSU_DONGBO(id_khobaqd_new,v_TAIKHOANTAO,P_Json);
            
            if v_ret = 0 then
               ROLLBACK TO SAVEPOINT INSERT_DULIEU_DONGBO;
                RETURN 0;
            end if;
       END;
        
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT INSERT_DULIEU_DONGBO;
	RETURN 0;
	END;

END INSERT_DULIEU_DONGBO;


FUNCTION INSERT_DULIEU_DUONGSU_DONGBO
(   
    v_KHOBAQDID IN NUMBER,
    p_TAIKHOANTAO IN VARCHAR2,
    P_Json IN CLOB
)RETURN NUMBER AS

BEGIN

        SAVEPOINT INSERT_DULIEU_DUONGSU_DONGBO;
        BEGIN
 
        FOR item IN (
            SELECT KHOBAQDID, DUONGSUID, DONID,DOITUONGPHAMTOI,SODINHDANH,HOVATEN,TENKHAC,GIOITINH,
        TONGIAO,DANTOC,QUOCTICH,NAMSINH,THANGNAM,NGAYTHANGNAM,DIACHICHITIET
        ,MAXA, MAHUYEN,MATINH,QUOCGIA,LOAIGIAYTO,NGAYCAP,SOGIAYTO,NGAYHETHAN,SODINHDANHNN,SOGIAYTOXNC,LOAIGIAYTOXNC,HOTENNN,
        QUOCTICHNN,NGAYSINHNN,NAMSINHNN,THANGNAMNN,NGAYTHANGNAMNN,GIOITINHNN,MADDTC,MASOTHUE,TENTOCHUCTIENGVIET,TENTOCHUCNUOCNGOAI,
        TENTOCHUCVIETTAT,LOAIHINHTC,SODINHDANHDAIDIEN,HOVATENDAIDIEN,DIACHICHITIETRUSO,
        MAXATRUSO,MAHUYENTRUSO,MATINHTRUSO,QUOCGIATRUSO,TUCACHTOTUNG,DSTOIDANH,ANPHI,MIENPHI,TAIKHOANTAO
        ,DSHINHPHATCHINH,DSHINHPHATBOSUNG,NGAYNHANTONGDAT,DSTOIDANHC06,TENTOIDANHC06,TENHINHPHATC06
          FROM JSON_TABLE(
            p_json,
            '$[*]' COLUMNS (
              KHOBAQDID NUMBER PATH '$.KHOBAQDID',
              DUONGSUID NUMBER PATH '$.DUONGSUID',
              DONID NUMBER PATH '$.DONID',
              DOITUONGPHAMTOI NUMBER PATH '$.DOITUONGPHAMTOI',
              SODINHDANH VARCHAR2(100) PATH '$.SODINHDANH',
              HOVATEN VARCHAR2(100) PATH '$.HOVATEN',
              TENKHAC VARCHAR2(100) PATH '$.TENKHAC',
              GIOITINH NUMBER PATH '$.GIOITINH',
              TONGIAO VARCHAR2(100) PATH '$.TONGIAO',
              DANTOC VARCHAR2(100) PATH '$.DANTOC',
              QUOCTICH VARCHAR2(100) PATH '$.QUOCTICH',
              NAMSINH VARCHAR2(100) PATH '$.NAMSINH',
              THANGNAM VARCHAR2(100) PATH '$.THANGNAM',
              NGAYTHANGNAM VARCHAR2(100) PATH '$.NGAYTHANGNAM',
              DIACHICHITIET VARCHAR2(100) PATH '$.DIACHICHITIET',
              MAXA VARCHAR2(100) PATH '$.MAXA',
              MAHUYEN VARCHAR2(100) PATH '$.MAHUYEN',
              MATINH VARCHAR2(100) PATH '$.MATINH',
              QUOCGIA VARCHAR2(100) PATH '$.QUOCGIA',
              LOAIGIAYTO VARCHAR2(100) PATH '$.LOAIGIAYTO',
              NGAYCAP VARCHAR2(100) PATH '$.NGAYCAP',
              SOGIAYTO VARCHAR2(100) PATH '$.SOGIAYTO',
              NGAYHETHAN VARCHAR2(100) PATH '$.NGAYHETHAN',
              SODINHDANHNN VARCHAR2(100) PATH '$.SODINHDANHNN',
              SOGIAYTOXNC VARCHAR2(100) PATH '$.SOGIAYTOXNC',
              LOAIGIAYTOXNC VARCHAR2(100) PATH '$.LOAIGIAYTOXNC',
              HOTENNN VARCHAR2(100) PATH '$.HOTENNN',
              QUOCTICHNN VARCHAR2(100) PATH '$.QUOCTICHNN',
              NGAYSINHNN VARCHAR2(100) PATH '$.NGAYSINHNN',
              NAMSINHNN VARCHAR2(100) PATH '$.NAMSINHNN',
              THANGNAMNN VARCHAR2(100) PATH '$.THANGNAMNN',
              NGAYTHANGNAMNN VARCHAR2(100) PATH '$.NGAYTHANGNAMNN',
              GIOITINHNN VARCHAR2(100) PATH '$.GIOITINHNN',
              MADDTC VARCHAR2(100) PATH '$.MADDTC',
              MASOTHUE VARCHAR2(100) PATH '$.MASOTHUE',
              TENTOCHUCTIENGVIET VARCHAR2(100) PATH '$.TENTOCHUCTIENGVIET',
              TENTOCHUCNUOCNGOAI VARCHAR2(100) PATH '$.TENTOCHUCNUOCNGOAI',
              TENTOCHUCVIETTAT VARCHAR2(100) PATH '$.TENTOCHUCVIETTAT',
              LOAIHINHTC VARCHAR2(100) PATH '$.LOAIHINHTC',
              SODINHDANHDAIDIEN VARCHAR2(100) PATH '$.SODINHDANHDAIDIEN',
              HOVATENDAIDIEN VARCHAR2(100) PATH '$.HOVATENDAIDIEN',
              DIACHICHITIETRUSO VARCHAR2(100) PATH '$.DIACHICHITIETRUSO',
              MAXATRUSO VARCHAR2(100) PATH '$.MAXATRUSO',
              MAHUYENTRUSO VARCHAR2(100) PATH '$.MAHUYENTRUSO',
              MATINHTRUSO VARCHAR2(100) PATH '$.MATINHTRUSO',
              QUOCGIATRUSO VARCHAR2(100) PATH '$.QUOCGIATRUSO',
              TUCACHTOTUNG VARCHAR2(100) PATH '$.TUCACHTOTUNG',
              DSTOIDANH VARCHAR2(4000) PATH '$.DSTOIDANH',
              ANPHI VARCHAR2(100) PATH '$.ANPHI',
              MIENPHI VARCHAR2(100) PATH '$.MIENPHI',
              TAIKHOANTAO VARCHAR2(100) PATH '$.TAIKHOANTAO',
              DSHINHPHATCHINH VARCHAR2(4000) PATH '$.DSHINHPHATCHINH',
              DSHINHPHATBOSUNG VARCHAR2(4000) PATH '$.DSHINHPHATBOSUNG',
              NGAYNHANTONGDAT date PATH '$.NGAYNHANTONGDAT',
              DSTOIDANHC06 VARCHAR2(4000) PATH '$.DSTOIDANHC06',
              TENTOIDANHC06 VARCHAR2(500) PATH '$.TENTOIDANHC06',
              TENHINHPHATC06 VARCHAR2(500) PATH '$.TENHINHPHATC06'
            )
          )
        ) LOOP
        
        DECLARE
            id_duongsuId_new NUMBER;
            BEGIN
                Select KHOBAQD_DUONGSU_SEQ.nextval into id_duongsuId_new from dual;
                
            -- lưu vào bảng đương sự
                INSERT INTO KHOBAQD_DUONGSU (ID,KHOBAQDID, DUONGSUID, DONID,DOITUONGPHAMTOI,SODINHDANH,HOVATEN,TENKHAC,GIOITINH,
                TONGIAO,DANTOC,QUOCTICH,NAMSINH,THANGNAM,NGAYTHANGNAM,DIACHICHITIET
                ,MAXA, MAHUYEN,MATINH,QUOCGIA,LOAIGIAYTO,NGAYCAP,SOGIAYTO,NGAYHETHAN,SODINHDANHNN,SOGIAYTOXNC,LOAIGIAYTOXNC,HOTENNN,
                QUOCTICHNN,NGAYSINHNN,NAMSINHNN,THANGNAMNN,NGAYTHANGNAMNN,GIOITINHNN,MADDTC,MASOTHUE,TENTOCHUCTIENGVIET,TENTOCHUCNUOCNGOAI,
                TENTOCHUCVIETTAT,LOAIHINHTC,SODINHDANHDAIDIEN,HOVATENDAIDIEN,DIACHICHITIETRUSO
                ,MAXATRUSO,MAHUYENTRUSO,MATINHTRUSO,QUOCGIATRUSO,TUCACHTOTUNG,DSTOIDANH,ANPHI,MIENPHI,TAIKHOANTAO,NGAYTAO,STATUS
                ,DSHINHPHATCHINH,DSHINHPHATBOSUNG,NGAYNHANTONGDAT,DSTOIDANHC06,TENTOIDANHC06,TENHINHPHATC06,GHICHU,TRANGTHAIDUONGSU,ISGUILAI)
                Values(id_duongsuId_new,v_KHOBAQDID, item.DUONGSUID, item.DONID,item.DOITUONGPHAMTOI,item.SODINHDANH,item.HOVATEN,item.TENKHAC,item.GIOITINH,
                item.TONGIAO,item.DANTOC,item.QUOCTICH,item.NAMSINH,item.THANGNAM,item.NGAYTHANGNAM,item.DIACHICHITIET
                ,item.MAXA, item.MAHUYEN,item.MATINH,item.QUOCGIA,item.LOAIGIAYTO,item.NGAYCAP,item.SOGIAYTO,item.NGAYHETHAN,item.SODINHDANHNN,
                item.SOGIAYTOXNC,item.LOAIGIAYTOXNC,item.HOTENNN,
                item.QUOCTICHNN,item.NGAYSINHNN,item.NAMSINHNN,item.THANGNAMNN,item.NGAYTHANGNAMNN,item.GIOITINHNN,item.MADDTC
                ,item.MASOTHUE,item.TENTOCHUCTIENGVIET,item.TENTOCHUCNUOCNGOAI,
                item.TENTOCHUCVIETTAT,item.LOAIHINHTC,item.SODINHDANHDAIDIEN,item.HOVATENDAIDIEN,item.DIACHICHITIETRUSO
                ,item.MAXATRUSO,item.MAHUYENTRUSO,item.MATINHTRUSO,item.QUOCGIATRUSO,item.TUCACHTOTUNG,item.DSTOIDANH,item.ANPHI,
                item.MIENPHI,item.TAIKHOANTAO,SYSDATE,1,item.DSHINHPHATCHINH,item.DSHINHPHATBOSUNG,item.NGAYNHANTONGDAT,
                item.DSTOIDANHC06,item.TENTOIDANHC06,item.TENHINHPHATC06,null,0,0);
                
                -- lưu dữ liệu vào đương sự đồng bộ
                DECLARE
                v_ret NUMBER;
                BEGIN
                    v_ret := INSERT_KHOBAQD_DUONGSU_DONGBO(id_duongsuId_new,p_TAIKHOANTAO,0);
                    
                    if v_ret = 0 then
                        ROLLBACK TO SAVEPOINT INSERT_DULIEU_DUONGSU_DONGBO;
                        RETURN 0;
                    end if;
                END;
            END;
        END LOOP;
   
        IF P_Json IS NOT NULL then
            declare 
                v_TRANGTHAIBAQD NUMBER;
            begin
                select TRANGTHAIBAQD into v_TRANGTHAIBAQD from KHOBAQD where ID = v_KHOBAQDID;
                
                if v_TRANGTHAIBAQD = 2 then
                    update KHOBAQD set TRANGTHAIBAQD = 1 where ID = v_KHOBAQDID;
                end if;
            end;
        end if;
    
    RETURN 1;
    	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT INSERT_DULIEU_DUONGSU_DONGBO;
	RETURN 0;
	END;

END INSERT_DULIEU_DUONGSU_DONGBO;


PROCEDURE GET_PAGING_DUONGSU_DONGBO
(  
    p_KHOBAQDID IN NUMBER,
    p_DONID IN NUMBER,
    p_LINHVUC IN VARCHAR2,
    p_Search IN VARCHAR2,
    p_TRANGTHAIDONGBO IN NUMBER,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
TotalItem number;  MinIndex number; MaxIndex number;
BEGIN	
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
 OPEN CURRETURN FOR
        SELECT tt.* FROM(
            SELECT  ROW_NUMBER() OVER (ORDER BY A.ID desc) STT, COUNT(*) OVER () as CountAll
                ,A.* FROM (
                
                -- lấy danh sách đương sự đồng bộ án dân sự
                        SELECT 
                            DS.ID,
                            'Tên đương sự: '||DS.TENDUONGSU as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            DS.XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM ADS_DON_DUONGSU DS
                        LEFT JOIN KHOBAQD_DUONGSU KD 
                               ON KD.DUONGSUID = DS.ID
                               and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K 
                               ON KD.KHOBAQDID = K.ID
                               and K.STATUS = 1
                        LEFT JOIN (
                                SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.DONID = p_DONID
                          AND p_LINHVUC = 'ADS' AND (
                                   (DS.LOAIDUONGSU = 1 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                   OR
                                   (DS.LOAIDUONGSU <> 1 OR DS.QUOCTICHID <> 2)
                                )
                            AND (
                                p_Search IS NULL 
                                OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(p_Search) || '%'
                                OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                                OR DS.SOCMND LIKE '%' || p_Search || '%'
                              )
                               AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                        union all
                        
                        -- lấy danh sách đương sự đồng bộ án hôn nhân gia đình
                        SELECT 
                            DS.ID,
                            'Tên đương sự: '||DS.TENDUONGSU as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            DS.XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM AHN_DON_DUONGSU DS
                        LEFT JOIN KHOBAQD_DUONGSU KD 
                               ON KD.DUONGSUID = DS.ID
                               and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K 
                               ON KD.KHOBAQDID = K.ID
                               and K.STATUS = 1
                               LEFT JOIN (
                                SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.DONID = p_DONID
                          AND p_LINHVUC = 'AHN'
                           AND (
                                   (DS.LOAIDUONGSU = 1 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                   OR
                                   (DS.LOAIDUONGSU <> 1 OR DS.QUOCTICHID <> 2)
                                )
                        AND (
                                p_Search IS NULL 
                                OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(p_Search) || '%'
                                OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                                OR DS.SOCMND LIKE '%' || p_Search || '%'
                              )
                       AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                        union all
                        
                        -- lấy danh sách đương sự đồng bộ án hành chính
                        SELECT 
                            DS.ID,
                            'Tên đương sự: '||DS.TENDUONGSU as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            DS.XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM AHC_DON_DUONGSU DS
                        LEFT JOIN KHOBAQD_DUONGSU KD 
                               ON KD.DUONGSUID = DS.ID
                               and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K 
                               ON KD.KHOBAQDID = K.ID
                               and K.STATUS = 1
                               LEFT JOIN (
                                SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.DONID = p_DONID
                          AND p_LINHVUC = 'AHC'
                           AND (
                                   (DS.LOAIDUONGSU = 1 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                   OR
                                   (DS.LOAIDUONGSU <> 1 OR DS.QUOCTICHID <> 2)
                                )
                          AND (
                                p_Search IS NULL 
                                OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(p_Search) || '%'
                                OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                                OR DS.SOCMND LIKE '%' || p_Search || '%'
                              )
                               AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                          union all
                        
                        -- lấy danh sách đương sự đồng bộ án kinh tế
                        SELECT 
                            DS.ID,
                            'Tên đương sự: '||DS.TENDUONGSU as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            DS.XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM AKT_DON_DUONGSU DS
                        LEFT JOIN KHOBAQD_DUONGSU KD 
                               ON KD.DUONGSUID = DS.ID
                               and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K 
                               ON KD.KHOBAQDID = K.ID
                               and K.STATUS = 1
                               LEFT JOIN (
                                SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.DONID = p_DONID
                          AND p_LINHVUC = 'AKT'
                           AND (
                                   (DS.LOAIDUONGSU = 1 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                   OR
                                   (DS.LOAIDUONGSU <> 1 OR DS.QUOCTICHID <> 2)
                                )
                          AND (
                                p_Search IS NULL 
                                OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(p_Search) || '%'
                                OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                                OR DS.SOCMND LIKE '%' || p_Search || '%'
                              )
                               AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                           union all
                        
                        -- lấy danh sách đương sự đồng bộ án lao động
                        SELECT 
                            DS.ID,
                            'Tên đương sự: '||DS.TENDUONGSU as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            DS.XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM ALD_DON_DUONGSU DS
                        LEFT JOIN KHOBAQD_DUONGSU KD 
                               ON KD.DUONGSUID = DS.ID
                               and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K 
                               ON KD.KHOBAQDID = K.ID
                               and K.STATUS = 1
                               LEFT JOIN (
                                SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.DONID = p_DONID
                          AND p_LINHVUC = 'ALD'
                           AND (
                                   (DS.LOAIDUONGSU = 1 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                   OR
                                   (DS.LOAIDUONGSU <> 1 OR DS.QUOCTICHID <> 2)
                                )
                AND (
                        p_Search IS NULL 
                        OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(p_Search) || '%'
                        OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                        OR DS.SOCMND LIKE '%' || p_Search || '%'
                      )
                      AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                      union all 
                      
                      SELECT 
                            DS.ID,
                            'Tên bị đơn, bị cáo: '||DS.HOTEN as TENDUONGSU,
                            'Số CCCD: '||DS.SO_CCCD as SO_CCCD,
                            'Ngày sinh: '||TO_CHAR(DS.NGAYSINH,'dd/MM/yyyy') as NGAYSINH,
                            DS.GIOITINH,
                            CAST(DS.XACTHUC_DLDCQG AS NUMBER) AS XACTHUC_DLDCQG,
                            K.SOBAQD,
                            TO_CHAR(K.NGAYHIEULUCBAQD,'dd/MM/yyyy') AS NGAYHIEULUCBAQD,
                            TO_CHAR(K.NGAYBAQD,'dd/MM/yyyy') AS NGAYBAQD,
                            KD.GHICHU,
                            K.ID as KHOBAQDID,
                            KD.DUONGSUID,
                            KD.TRANGTHAIDUONGSU,
                            K.TRANGTHAIBAQD,
                            DBO.NOIDUNG_DONGBO
                        FROM AHS_BICANBICAO DS
                        INNER JOIN (select BICAOID, '0' AS loaibaqd,  '2' AS capxx
                                    from AHS_SOTHAM_BANAN_BICAO where ngayhieulucbanan IS NOT NULL
                                    union all
                                    select BICAOID, '0' AS loaibaqd,  '3' AS capxx
                                    from AHS_PHUCTHAM_BANAN_BICAO where NGAYNHANBANAN IS NOT NULL
                                    union all
                                    select ptbc.BICANID AS BICAOID, '1' AS loaibaqd,  '3' AS capxx
                                    from ahs_phuctham_quyetdinh_vuan va
                                    join AHS_PHUCTHAM_BICANBICAO ptbc ON ptbc.VUANID = va.VUANID                                    
                                    where va.HIEULUCTU is not null                                    
                                ) bicao ON DS.ID = bicao.BICAOID 

                        LEFT JOIN KHOBAQD_DUONGSU KD ON KD.DUONGSUID = DS.ID and KD.STATUS = 1 and KD.KHOBAQDID = p_KHOBAQDID
                        LEFT JOIN KHOBAQD K ON KD.KHOBAQDID = K.ID and K.STATUS = 1
                        LEFT JOIN (SELECT 
                                    KHOBAQD_DUONGSU_ID,
                                    LISTAGG(
            CASE 
                WHEN SUKIEN = 1 THEN   -- ⭐ Thu hồi
                    CASE 
                        WHEN TRANGTHAIDONGBO = 0 THEN
                           NOIDONGBO ||  ': Đang thu hồi'
                           ELSE
                            NOIDONGBO || ': Đã thu hồi ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                    END
                ELSE                   -- ⭐ Thêm mới (SUKIEN = 0)
                    CASE 
                        WHEN TRANGTHAIDONGBO = 1 THEN
                            NOIDONGBO || ': Đã đồng bộ ngày ' || TO_CHAR(NGAYDONGBO, 'dd/MM/yyyy')
                        when TRANGTHAIDONGBO = 0 then
                            NOIDONGBO || ': Đang đồng bộ'
                         ELSE
                            'Chưa đồng bộ'
                    END
            END,
            ' <br/> '
        ) WITHIN GROUP (ORDER BY ID) AS NOIDUNG_DONGBO,
        LISTAGG(TRANGTHAIDONGBO,'#') TRANGTHAIDONGBO,
        LISTAGG(SUKIEN,'#') SUKIEN
                                FROM KHOBAQD_DUONGSU_DONGBO
                                where STATUS =1
                                GROUP BY SUKIEN, KHOBAQD_DUONGSU_ID
                        ) DBO
                            ON DBO.KHOBAQD_DUONGSU_ID = KD.ID
                        WHERE DS.VUANID = p_DONID
                          AND p_LINHVUC = 'AHS'
                AND (
                        p_Search IS NULL 
                        OR LOWER(DS.HOTEN) LIKE '%' || LOWER(p_Search) || '%'
                        OR DS.SO_CCCD LIKE '%' || p_Search || '%'
                        OR DS.SOCMND LIKE '%' || p_Search || '%'
                      )
                      and (
                                   (DS.LOAIDOITUONG = 0 AND DS.QUOCTICHID = 2 AND DS.XACTHUC_DLDCQG = 1)
                                     OR
                                     (DS.LOAIDOITUONG in (1,2) AND DS.XACTHUC_DLDCQG = 1)
                                     OR
                                     1!=1
                                )
                                AND (p_TRANGTHAIDONGBO = 0
                            OR (p_TRANGTHAIDONGBO = 1 AND KD.TRANGTHAIDUONGSU is null)
                            OR (p_TRANGTHAIDONGBO = 2 AND KD.TRANGTHAIDUONGSU = 0)
                            OR (p_TRANGTHAIDONGBO = 3 AND KD.TRANGTHAIDUONGSU IN (1,2))
                            OR (p_TRANGTHAIDONGBO = 4 AND KD.TRANGTHAIDUONGSU IN (3,4,5)))
                        )A
                )tt where tt.stt>=MinIndex and tt.stt<= MaxIndex
         ;
END GET_PAGING_DUONGSU_DONGBO;

END PKG_KHOBAQD;

/
