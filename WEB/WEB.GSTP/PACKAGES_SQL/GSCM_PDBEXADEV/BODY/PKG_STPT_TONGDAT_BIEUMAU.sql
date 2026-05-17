--------------------------------------------------------
--  DDL for Package Body PKG_STPT_TONGDAT_BIEUMAU
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_TONGDAT_BIEUMAU" AS

PROCEDURE BAN_AN_ST_ADD_BIEUMAU_TONGDAT
(
	vLoaiAn in NUMBER,
    vToaAnID in NUMBER,
    vDonID in NUMBER,
    vMaGiaiDoan in NUMBER,
    vLoaiFile in NUMBER,
    vNguoiTao in VARCHAR2
) 
IS
BEGIN
    DECLARE
        vRecordCount NUMBER;
    BEGIN
		IF vLoaiAn = 2 THEN
			-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM ADS_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO ADS_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO) 
				VALUES(ADS_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE));
			END IF;
		ELSIF vLoaiAn = 3 THEN
			-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM AHN_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO AHN_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO) 
				VALUES(AHN_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE));
			END IF;
		ELSIF vLoaiAn = 4 THEN
		-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM AKT_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO AKT_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO) 
				VALUES(AKT_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE));
			END IF;
		ELSIF vLoaiAn = 5 THEN
		-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM ALD_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO ALD_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO, TOA_GIAIQUYET_ID) 
				VALUES(ALD_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE), vToaAnID);
			END IF;
		ELSIF vLoaiAn = 6 THEN
		-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM AHC_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO AHC_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO, TOA_GIAIQUYET_ID) 
				VALUES(AHC_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE), vToaAnID);
			END IF;
		ELSIF vLoaiAn = 7 THEN
		-- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
			SELECT COUNT(*) INTO vRecordCount
			FROM APS_FILE
			WHERE DONID = vDonID AND TOAANID = vToaAnID AND BIEUMAUID = 230;

			-- Nếu không tồn tại bản ghi, thực hiện chèn
			IF vRecordCount = 0 THEN
				INSERT INTO APS_FILE(ID, TOAANID, NAM, DONID, MAGIAIDOAN, BIEUMAUID, 
					LOAIFILE, NGUOITAO, NGAYTAO) 
				VALUES(APS_FILE_SEQ.nextval, vToaAnID, TO_CHAR(SYSDATE, 'YYYY'), vDonID, vMaGiaiDoan, 
					230, vLoaiFile, vNguoiTao, TRUNC(SYSDATE));
			END IF;
		END IF;
    END;
END BAN_AN_ST_ADD_BIEUMAU_TONGDAT;
PROCEDURE TONGDAT_DOITUONG_VNID(
     V_ID IN NUMBER,
     V_LOAIAN IN VARCHAR2,
     V_NGAYNHANTONGDAT IN VARCHAR2
)
IS 
     VV_NGAYNHANTONGDAT DATE;
BEGIN
  -- select decode(V_NGAYNHANTONGDAT,null,null,to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy')) into VV_NGAYNHANTONGDAT FROM DUAL;
  IF(V_LOAIAN='1') THEN
        UPDATE AHS_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;
   ELSIF(V_LOAIAN='2') THEN
        UPDATE ADS_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;
    ELSIF(V_LOAIAN='3') THEN
        UPDATE AHN_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;
      ELSIF(V_LOAIAN='4') THEN
        UPDATE AKT_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;  
     ELSIF(V_LOAIAN='5') THEN
        UPDATE ALD_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;     
         ELSIF(V_LOAIAN='6') THEN
        UPDATE AHC_TONGDAT_DOITUONG
        SET
            NGAYNHANTONGDAT = to_date(V_NGAYNHANTONGDAT,'dd/MM/yyyy'),
            NGAYNHANTONGDAT_SYS=SYSDATE
        WHERE ID = V_ID;     
     END IF;   
END TONGDAT_DOITUONG_VNID;

END PKG_STPT_TONGDAT_BIEUMAU;

/
