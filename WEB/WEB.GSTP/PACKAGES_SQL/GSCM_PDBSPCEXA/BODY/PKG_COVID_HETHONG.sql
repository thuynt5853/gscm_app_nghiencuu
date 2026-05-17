--------------------------------------------------------
--  DDL for Package Body PKG_COVID_HETHONG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_COVID_HETHONG" AS
FUNCTION UPDATE_NGUOISUDUNG
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
       FOR item in (
                 SELECT CB.* FROM COVID_DM_CANBO CB WHERE CB.HIEULUC=1
       )
       loop
                update COVID_NGUOISUDUNG
                set DV_TRUCTHUOC=item.DV_TRUCTHUOC,PHONGBANID=item.PHONGBANID
                where CANBOID=item.ID;
                COMMIT;
       end loop;
   OPEN v_cursor FOR
       SELECT ND.* FROM COVID_NGUOISUDUNG ND;
 RETURN v_cursor;   
END UPDATE_NGUOISUDUNG;
FUNCTION TAO_DS_USER_EXPORT_01
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;dem NUMBER:=0;v_count NUMBER;
BEGIN
    DELETE COVID_USER_TEMP;COMMIT;
    FOR dv_item IN (
            SELECT ROW_NUMBER() OVER (ORDER BY DV.TEN_ALIAS)DV_TT,DV.ID DV_TTHUOC_ID
            ,DV.TEN_ALIAS DV_TTHUOC_TEN
            FROM COVID_DV_TRUCTHUOC DV
            )
    LOOP
    SELECT COUNT(*) INTO v_count  FROM COVID_DM_CANBO CB  INNER JOIN COVID_NGUOISUDUNG ND ON ND.CANBOID=CB.ID
    WHERE CB.DV_TRUCTHUOC=dv_item.DV_TTHUOC_ID AND CB.TOAANID=1 AND CB.NOT_IN_PMQLCB=1;
     ------   
    IF(v_count>0)THEN
                 dem:=dem+1;
               INSERT INTO COVID_USER_TEMP
                            (TT,DV_TT,DV_TTHUOC_ID,DV_TTHUOC_TEN)
                           VALUES(dem,dv_item.DV_TT,dv_item.DV_TTHUOC_ID,dv_item.DV_TTHUOC_TEN);
               FOR cb_item IN (
                        SELECT ROW_NUMBER() OVER (ORDER BY SUBSTR(CB.HOTEN,INSTR(CB.HOTEN,' ',-1)+ 1))CB_TT,
                        CB.ID CANBO_ID,CB.HOTEN CANBO_TEN,ND.USERNAME USER_NAME
                        FROM COVID_DM_CANBO CB 
                        INNER JOIN COVID_NGUOISUDUNG ND ON ND.CANBOID=CB.ID
                        WHERE CB.DV_TRUCTHUOC=dv_item.DV_TTHUOC_ID AND CB.TOAANID=1 AND CB.NOT_IN_PMQLCB=1
                 )
                 LOOP
                 dem:=dem+1;
                    INSERT INTO COVID_USER_TEMP
                            (TT,CB_TT,CANBO_ID,CANBO_TEN,USER_NAME)
                           VALUES(dem,cb_item.CB_TT,cb_item.CANBO_ID,cb_item.CANBO_TEN,cb_item.USER_NAME);
                 END LOOP;
       END IF;  
    END LOOP;
    COMMIT;
   OPEN v_cursor FOR
       SELECT UR.TT,DECODE(UR.DV_TT,NULL,NULL,UR.DV_TT||'.'||UR.DV_TTHUOC_TEN) DV_TTHUOC_TEN,
   DECODE(UR.CB_TT,NULL,NULL,UR.CB_TT||'.'||UR.CANBO_TEN) CANBO_TEN,UR.USER_NAME 
   FROM COVID_USER_TEMP UR ORDER BY UR.TT;
 RETURN v_cursor;   
END TAO_DS_USER_EXPORT_01;
FUNCTION EDIT_USER_TRUNG_TEMP_01
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
               SELECT TT.USERNAME FROM (
               SELECT USERNAME FROM COVID_NGUOISUDUNG  WHERE  NOT_IN_PMQLCB=0
               UNION ALL
               SELECT USERNAME FROM COVID_NGUOISUDUNG  WHERE  NOT_IN_PMQLCB=1
               )TT
               GROUP BY TT.USERNAME HAVING COUNT(*) > 1--tìm những user trùng
            )
     LOOP
           FOR item_stt IN (
                         --lấy những USERNAME trùng
                         SELECT (ROW_NUMBER() OVER (ORDER BY CV.ID))STT,CV.* FROM COVID_NGUOISUDUNG CV
                         WHERE CV.USERNAME=item.USERNAME AND CV.NOT_IN_PMQLCB=1
                         --(ROW_NUMBER() OVER (ORDER BY CV.ID)-1) số thứ tự -1 để số thứ tự bắt đầu từ 0, lúc đầu là số thứ tự bắt đầu từ 1   
                        )
             LOOP
                 UPDATE COVID_NGUOISUDUNG
                 SET USERNAME=item.USERNAME||item_stt.STT --cộng thêm số thứ tự từ user thứ 1 đã bỏ user thứ tự = 0
                 WHERE ID=item_stt.ID;
                 COMMIT;
             END LOOP;
     END LOOP;
   OPEN v_cursor FOR
      SELECT COVI.USERNAME FROM COVID_NGUOISUDUNG COVI 
      WHERE COVI.NOT_IN_PMQLCB=1
      GROUP BY COVI.USERNAME HAVING COUNT(*) > 1;
   RETURN v_cursor;
END EDIT_USER_TRUNG_TEMP_01;
FUNCTION TAO_USER_NOT_IN_QLCB
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
        SELECT TTS.PHONGBANID,TTS.ID,TTS.HOTEN,TTS.USERNAME FROM(
        SELECT TS.PHONGBANID,TS.ID,TS.HOTEN,
        LOWER(TS.LAST_NAME||SUBSTR(TS.FIRST_NAME,0,1)||SUBSTR(MID_NAME_0,0,1)||SUBSTR(TS.LAST_NAME_0,0,1))USERNAME
        FROM (
             SELECT TT.PHONGBANID,TT.ID,TT.HOTEN,TT.LAST_NAME,TT.FIRST_NAME,SUBSTR(TT.MID_NAME,0,INSTR(TT.MID_NAME,' ')- 1) AS MID_NAME_0,SUBSTR(MID_NAME,INSTR(MID_NAME,' ',-1)+ 1) AS LAST_NAME_0 
             FROM (
                    SELECT CB1.PHONGBANID,CB1.ID,CB1.HOTEN
                    ,SUBSTR(CB1.HOTENS,0,INSTR(CB1.HOTENS,' ')- 1) AS FIRST_NAME
                    ,SUBSTR(CB1.HOTENS,INSTR(CB1.HOTENS,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTENS,' ') -1) AS MID_NAME
                    ,SUBSTR(CB1.HOTENS,INSTR(CB1.HOTENS,' ',-1)+ 1) AS LAST_NAME
                    FROM  (SELECT cb.ID,cb.PHONGBANID,BO_DAU_TIENG_VIET(cb.HOTEN)HOTENS,cb.TOAANID,cb.HOTEN FROM COVID_DM_CANBO cb where CB.HIEULUC=1 AND CB.NOT_IN_PMQLCB=1) CB1 WHERE TOAANID=1
                    ) TT --WHERE TT.HOTEN='Vũ Hoàng Anh'--'Hoàng Thị Thúy Vinh'--
              )TS  
        )TTS
    )
   LOOP
    INSERT INTO COVID_NGUOISUDUNG
    (ID,USERNAME,PASSWORD,HOTEN,DONVIID,CANBOID,HIEULUC,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA,NOT_IN_PMQLCB)
    VALUES(COVID_NGUOISUDUNG_SEQ.NEXTVAL,item.USERNAME,'2e9c79036991f19d4ec9a72baf868409',item.HOTEN,1,item.ID,1,'admin',sysdate,'admin',sysdate,1);
    COMMIT;
   END LOOP;
   OPEN v_cursor FOR
   SELECT COUNT(*) OVER() COUNTS,COVI.* FROM COVID_NGUOISUDUNG COVI WHERE COVI.NOT_IN_PMQLCB=1;
 RETURN v_cursor;   
END TAO_USER_NOT_IN_QLCB;
FUNCTION COVID_DM_CANBO_INSERT
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
            SELECT TRIM(TN.HOTEN)HOTEN,TRIM(TN.PHONGBANID)PHONGBANID,TRIM(TN.DV_TTHUOC_ID)DV_TTHUOC_ID FROM COVID_TEMP_NEW TN
            )
     LOOP
          INSERT INTO COVID_DM_CANBO
          (ID,TOAANID,HOTEN,HIEULUC,PHONGBANID,DV_TRUCTHUOC,NOT_IN_PMQLCB,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA)
          VALUES(COVID_DM_CANBO_SEQ.NEXTVAL,1,item.HOTEN,1,item.PHONGBANID,item.DV_TTHUOC_ID,1,SYSDATE,'admin',SYSDATE,'admin');
     END LOOP;
     COMMIT;
   OPEN v_cursor FOR
      SELECT COUNT(*) OVER() COUNTS,COVI.* FROM COVID_DM_CANBO COVI 
      WHERE COVI.NOT_IN_PMQLCB=1;
   RETURN v_cursor;
END COVID_DM_CANBO_INSERT;

FUNCTION EDIT_USER_TRUNG_TEMP
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
            SELECT COVI.USERNAME FROM COVID_NGUOISUDUNG COVI  
            WHERE COVI.NOT_IN_PMQLCB=1
            GROUP BY COVI.USERNAME HAVING COUNT(*) > 1 --tìm những user trùng
            )
     LOOP
           FOR item_stt IN (
                     SELECT SS.* FROM (
                         --lấy những USERNAME trùng
                         SELECT (ROW_NUMBER() OVER (ORDER BY CV.ID)-1)STT,CV.* FROM COVID_NGUOISUDUNG CV 
                         WHERE CV.USERNAME=item.USERNAME AND CV.NOT_IN_PMQLCB=1
                         --(ROW_NUMBER() OVER (ORDER BY CV.ID)-1) số thứ tự -1 để số thứ tự bắt đầu từ 0, lúc đầu là số thứ tự bắt đầu từ 1
                     )SS WHERE SS.STT!=0 -- bỏ user bị trùng đầu tiên
             )
             LOOP
                 UPDATE COVID_NGUOISUDUNG
                 SET USERNAME=item.USERNAME||item_stt.STT --cộng thêm số thứ tự từ user thứ 1 đã bỏ user thứ tự = 0
                 WHERE ID=item_stt.ID;
             COMMIT;
             END LOOP;
     END LOOP;
   OPEN v_cursor FOR
      SELECT COVI.USERNAME FROM COVID_NGUOISUDUNG COVI 
      WHERE COVI.NOT_IN_PMQLCB=1
      GROUP BY COVI.USERNAME HAVING COUNT(*) > 1;
   RETURN v_cursor;
END EDIT_USER_TRUNG_TEMP;
FUNCTION TAO_DS_USER_EXPORT
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;dem NUMBER:=0;v_count NUMBER;
BEGIN
    DELETE COVID_USER_TEMP;COMMIT;
    FOR dv_item IN (
            SELECT ROW_NUMBER() OVER (ORDER BY DV.TEN_ALIAS)DV_TT,DV.ID DV_TTHUOC_ID
            ,DV.TEN_ALIAS DV_TTHUOC_TEN
            FROM COVID_DV_TRUCTHUOC DV
            )
    LOOP
    SELECT COUNT(*) INTO v_count  FROM COVID_DM_CANBO CB  INNER JOIN COVID_NGUOISUDUNG ND ON ND.CANBOID=CB.ID
    WHERE CB.DV_TRUCTHUOC=dv_item.DV_TTHUOC_ID AND CB.TOAANID=1;
     ------   
    IF(v_count>0)THEN
                 dem:=dem+1;
               INSERT INTO COVID_USER_TEMP
                            (TT,DV_TT,DV_TTHUOC_ID,DV_TTHUOC_TEN)
                           VALUES(dem,dv_item.DV_TT,dv_item.DV_TTHUOC_ID,dv_item.DV_TTHUOC_TEN);
               FOR cb_item IN (
                        SELECT ROW_NUMBER() OVER (ORDER BY SUBSTR(CB.HOTEN,INSTR(CB.HOTEN,' ',-1)+ 1))CB_TT,
                        CB.ID CANBO_ID,CB.HOTEN CANBO_TEN,ND.USERNAME USER_NAME
                        FROM COVID_DM_CANBO CB 
                        INNER JOIN COVID_NGUOISUDUNG ND ON ND.CANBOID=CB.ID
                        WHERE CB.DV_TRUCTHUOC=dv_item.DV_TTHUOC_ID AND CB.TOAANID=1
                 )
                 LOOP
                 dem:=dem+1;
                    INSERT INTO COVID_USER_TEMP
                            (TT,CB_TT,CANBO_ID,CANBO_TEN,USER_NAME)
                           VALUES(dem,cb_item.CB_TT,cb_item.CANBO_ID,cb_item.CANBO_TEN,cb_item.USER_NAME);
                 END LOOP;
       END IF;  
    END LOOP;
    COMMIT;
   OPEN v_cursor FOR
       SELECT UR.TT,DECODE(UR.DV_TT,NULL,NULL,UR.DV_TT||'.'||UR.DV_TTHUOC_TEN) DV_TTHUOC_TEN,
   DECODE(UR.CB_TT,NULL,NULL,UR.CB_TT||'.'||UR.CANBO_TEN) CANBO_TEN,UR.USER_NAME 
   FROM COVID_USER_TEMP UR ORDER BY UR.TT;
 RETURN v_cursor;   
END TAO_DS_USER_EXPORT;
FUNCTION EDIT_COVID_DMCANBO
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
           SELECT CB.ID CANBO_ID,E.FULLNAME,PB.ID PHONGBANID, PB.TENPHONGBAN,TT.ID TRUCTHUOC_ID
            ,TT.TEN TEN_DVTT,TT.TEN_ALIAS TEN_DVTT_MOI 
            FROM HU_EMPLOYEE@dblink_qlcb E
            INNER JOIN COVID_DM_CANBO CB ON CB.MADONGBO=E.ID
            INNER JOIN DM_TOAAN TA ON TA.MADONGBO=E.ORG_ID
            LEFT JOIN COVID_DV_TRUCTHUOC TT ON TT.MADONGBO=E.ORG_CHILD
            LEFT JOIN  COVID_PHONGBAN PB ON PB.MADONGBO= E.DEPARTMENT_ID
            WHERE  TA.ID=1 --tòa án tối cao
        )
    LOOP
        UPDATE COVID_DM_CANBO
        SET PHONGBANID=item.PHONGBANID,DV_TRUCTHUOC=item.TRUCTHUOC_ID
        WHERE ID=item.CANBO_ID;
    END LOOP;
    COMMIT;
 OPEN v_cursor FOR
   SELECT PB.* FROM COVID_DM_CANBO PB WHERE PB.TOAANID=1;
   RETURN v_cursor;
END EDIT_COVID_DMCANBO;
FUNCTION TAO_PHONGBAN
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
        SELECT TR.ID TRUCTHUOC_ID,W.NAME TENPHONGBAN,W.ID MADONGBO FROM HU_DEPARTMENT@dblink_qlcb W
        INNER JOIN COVID_DV_TRUCTHUOC TR ON TR.MADONGBO=W.SUBBORDINATE_ID
        WHERE TR.TOAANID=1
        )
    LOOP
        INSERT INTO COVID_PHONGBAN
        (ID,TRUCTHUOC_ID,TENPHONGBAN,HIEULUC,MADONGBO,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA)
        VALUES (COVID_PHONGBAN_SEQ.NEXTVAL,item.TRUCTHUOC_ID,item.TENPHONGBAN,1,item.MADONGBO,'admin',sysdate,'admin',sysdate);
    END LOOP;
    COMMIT;
 OPEN v_cursor FOR
   SELECT PB.* FROM COVID_PHONGBAN PB;
   RETURN v_cursor;
END TAO_PHONGBAN;
FUNCTION TAO_DV_TRUCTHUOC
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
        SELECT TA.ID TOAANID,NA.* FROM HU_SUBORDINATE@dblink_qlcb NA
        INNER JOIN DM_TOAAN TA ON TA.MADONGBO=NA.ORG_ID
        WHERE TA.ID=1
        )
    LOOP
        INSERT INTO COVID_DV_TRUCTHUOC
        (ID,TOAANID,TEN,TEN_ALIAS,HIEULUC,MADONGBO,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA)
        VALUES (COVID_DV_TRUCTHUOC_SEQ.NEXTVAL,item.TOAANID,item.NAME,item.NAME_ALIAS,1,item.ID,'admin',sysdate,'admin',sysdate);
    END LOOP;
    COMMIT;
 OPEN v_cursor FOR
   SELECT TT.* FROM COVID_DV_TRUCTHUOC TT;
   RETURN v_cursor;
END TAO_DV_TRUCTHUOC;
FUNCTION EDIT_USER_TRUNG --sửa những user trùng lặp bằng cách cộng thêm số thứ tự
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
            SELECT COVI.USERNAME FROM COVID_NGUOISUDUNG COVI  
            GROUP BY COVI.USERNAME HAVING COUNT(*) > 1 
            --tìm những user trùng
            )
     LOOP
           FOR item_stt IN (
                     SELECT SS.* FROM (
                         --lấy những USERNAME trùng
                         SELECT (ROW_NUMBER() OVER (ORDER BY CV.ID)-1)STT,CV.* FROM COVID_NGUOISUDUNG CV WHERE CV.USERNAME=item.USERNAME
                         --(ROW_NUMBER() OVER (ORDER BY CV.ID)-1) số thứ tự -1 để số thứ tự bắt đầu từ 0, lúc đầu là số thứ tự bắt đầu từ 1
                     )SS WHERE SS.STT!=0 -- bỏ user bị trùng đầu tiên
             )
             LOOP
                 UPDATE COVID_NGUOISUDUNG
                 SET USERNAME=item.USERNAME||item_stt.STT --cộng thêm số thứ tự từ user thứ 1 đã bỏ user thứ tự = 0
                 WHERE ID=item_stt.ID;
             COMMIT;
             END LOOP;
     END LOOP;
   OPEN v_cursor FOR
      SELECT COVI.USERNAME FROM COVID_NGUOISUDUNG COVI 
      GROUP BY COVI.USERNAME HAVING COUNT(*) > 1;
   RETURN v_cursor;
END EDIT_USER_TRUNG;
FUNCTION TAO_USER
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;
BEGIN
   FOR item IN (
        SELECT TTS.PHONGBANID,TTS.ID,TTS.HOTEN,TTS.USERNAME FROM(
        SELECT TS.PHONGBANID,TS.ID,TS.HOTEN,
        LOWER(TS.LAST_NAME||SUBSTR(TS.FIRST_NAME,0,1)||SUBSTR(MID_NAME_0,0,1)||SUBSTR(TS.LAST_NAME_0,0,1))USERNAME
        FROM (
             SELECT TT.PHONGBANID,TT.ID,TT.HOTEN,TT.LAST_NAME,TT.FIRST_NAME,SUBSTR(TT.MID_NAME,0,INSTR(TT.MID_NAME,' ')- 1) AS MID_NAME_0,SUBSTR(MID_NAME,INSTR(MID_NAME,' ',-1)+ 1) AS LAST_NAME_0 
             FROM (
                    SELECT CB1.PHONGBANID,CB1.ID,CB1.HOTEN
                    ,SUBSTR(CB1.HOTENS,0,INSTR(CB1.HOTENS,' ')- 1) AS FIRST_NAME
                    ,SUBSTR(CB1.HOTENS,INSTR(CB1.HOTENS,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTENS,' ') -1) AS MID_NAME
                    ,SUBSTR(CB1.HOTENS,INSTR(CB1.HOTENS,' ',-1)+ 1) AS LAST_NAME
                    FROM  (SELECT cb.ID,cb.PHONGBANID,BO_DAU_TIENG_VIET(cb.HOTEN)HOTENS,cb.TOAANID,cb.HOTEN FROM DM_CANBO cb where CB.HIEULUC=1) CB1 WHERE CB1.TOAANID=1
                    ) TT --WHERE TT.HOTEN='Vũ Hoàng Anh'--'Hoàng Thị Thúy Vinh'--
              )TS  
        )TTS
    )
   LOOP
    INSERT INTO COVID_NGUOISUDUNG
    (ID,USERNAME,PASSWORD,HOTEN,DONVIID,CANBOID,HIEULUC,NGUOITAO,NGAYTAO,NGUOISUA,NGAYSUA)
    VALUES(COVID_NGUOISUDUNG_SEQ.NEXTVAL,item.USERNAME,'2e9c79036991f19d4ec9a72baf868409',item.HOTEN,1,item.ID,1,'admin',sysdate,'admin',sysdate);
    COMMIT;
   END LOOP;
   OPEN v_cursor FOR
   SELECT COVI.* FROM COVID_NGUOISUDUNG COVI;
 RETURN v_cursor;   
END TAO_USER;
FUNCTION BO_DAU_TIENG_VIET
(
p_string VARCHAR2
) 
--Loại bỏ dấu tiếng Việt trong Oracle PL/SQL
RETURN VARCHAR2 AS BEGIN RETURN TRANSLATE(p_string, 'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ', 'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'); 
END BO_DAU_TIENG_VIET;
END PKG_COVID_HETHONG;
