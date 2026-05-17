alter table ald_don_duongsu
add (XACTHUC_DLDCQG	NUMBER,
CHK_KHONG_CO	CHAR(1 BYTE));
/
 COMMENT ON COLUMN ald_don_duongsu.XACTHUC_DLDCQG IS '0: Chưa xác thư; 1: Đã xác thực; 3: Không thể làm sạch';
 COMMENT ON COLUMN ald_don_duongsu.CHK_KHONG_CO IS '1: checked, 0: unchecked';
/
alter table akt_don_duongsu
add (XACTHUC_DLDCQG	NUMBER,
CHK_KHONG_CO	CHAR(1 BYTE));
/
 COMMENT ON COLUMN akt_don_duongsu.XACTHUC_DLDCQG IS '0: Chưa xác thư; 1: Đã xác thực; 3: Không thể làm sạch';
  COMMENT ON COLUMN akt_don_duongsu.CHK_KHONG_CO IS '1: checked, 0: unchecked';
/
alter table ahc_don_duongsu
add (XACTHUC_DLDCQG	NUMBER,
CHK_KHONG_CO	CHAR(1 BYTE));
/
 COMMENT ON COLUMN ahc_don_duongsu.XACTHUC_DLDCQG IS '0: Chưa xác thư; 1: Đã xác thực; 3: Không thể làm sạch';
 COMMENT ON COLUMN ahc_don_duongsu.CHK_KHONG_CO IS '1: checked, 0: unchecked';
/
alter table ads_don_duongsu
add (XACTHUC_DLDCQG	NUMBER,
CHK_KHONG_CO	CHAR(1 BYTE));
/
 COMMENT ON COLUMN ads_don_duongsu.XACTHUC_DLDCQG IS '0: Chưa xác thư; 1: Đã xác thực; 3: Không thể làm sạch';
 COMMENT ON COLUMN ads_don_duongsu.CHK_KHONG_CO IS '1: checked, 0: unchecked';
/
-- 1, Alter thêm các cột lưu thông tin vào bảng ahs_bicanbicao
alter table ahs_bicanbicao add ("SO_CCCD" VARCHAR2(50 BYTE), 
  "SO_HOCHIEU" VARCHAR2(50 BYTE), 
  "XACTHUC_DLDCQG" CHAR(1 BYTE), 
  "CHK_KHONG_CO" CHAR(1 BYTE) DEFAULT '0');
   / 
 COMMENT ON COLUMN ahs_bicanbicao.XACTHUC_DLDCQG IS '0: Chưa xác thư; 1: Đã xác thực; 2: Không thể làm sạch';
 COMMENT ON COLUMN ahs_bicanbicao.CHK_KHONG_CO IS '1: checked, 0: unchecked';
 /

alter table C06_TOAAN_KDTM
modify TENQUANHEPHAPLUAT varchar2(1000);

alter table C06_TOAAN_DANSU
modify TENQUANHEPHAPLUAT varchar2(1000);

alter table C06_TOAAN_LAODONG
modify TENQUANHEPHAPLUAT varchar2(1000);

alter table C06_TOAAN_HANHCHINH
modify TENQUANHEPHAPLUAT varchar2(1000);

/

alter table C06_TOAAN_DANSU
add (NgayThuHoi DATE,
NguoiThuHoi varchar2(20),
NgayGuiLai  DATE,
NguoiGuiLai varchar2(20) );

alter table C06_TOAAN_HANHCHINH
add (NgayThuHoi DATE,
NguoiThuHoi varchar2(20),
NgayGuiLai  DATE,
NguoiGuiLai varchar2(20) );

alter table C06_TOAAN_HINHSU
add (NgayThuHoi DATE,
NguoiThuHoi varchar2(20),
NgayGuiLai  DATE,
NguoiGuiLai varchar2(20) );

alter table C06_TOAAN_KDTM
add (NgayThuHoi DATE,
NguoiThuHoi varchar2(20),
NgayGuiLai  DATE,
NguoiGuiLai varchar2(20) );

alter table C06_TOAAN_LAODONG
add (NgayThuHoi DATE,
NguoiThuHoi varchar2(20),
NgayGuiLai  DATE,
NguoiGuiLai varchar2(20) );

/

  CREATE TABLE "AHS_BICANBICAO_HISTORY" 
   (	"HIS_NGUOISUA" VARCHAR2(400 CHAR) NOT NULL ENABLE, 
	"HIS_TAIKHOANSUA" VARCHAR2(100 CHAR) NOT NULL ENABLE, 
	"HIS_NGAYSUA" DATE DEFAULT sysdate, 
	"HIS_BICAN" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"BICANID" NUMBER NOT NULL ENABLE
   );

  CREATE INDEX "AHS_BICANBICAO_HISTORY_BICAN_IDX" ON "AHS_BICANBICAO_HISTORY" ("BICANID");


alter table C06_TOAAN_HINHSU_HISTORY 
ADD (VUANID number, BICANID number, ACTION_TYPE varchar2(50));
alter table C06_TOAAN_HANHCHINH_HISTORY
ADD (DONID number, DUONGSUID number, ACTION_TYPE varchar2(50));
alter table C06_TOAAN_KDTM_HISTORY
ADD (DONID number, DUONGSUID number, ACTION_TYPE varchar2(50));
alter table C06_TOAAN_LAODONG_HISTORY
ADD (DONID number, DUONGSUID number, ACTION_TYPE varchar2(50));
alter table C06_TOAAN_DANSU_HISTORY
ADD (DONID number, DUONGSUID number, ACTION_TYPE varchar2(50));


/


alter table c06_toaan_hinhsu add (TOIDANH_TH varchar2(500), HINHPHAT_TH varchar2(500), THAMPHAN varchar2(200));

alter table ahs_sotham_banan_bicao
add ngayhieulucbanan date;