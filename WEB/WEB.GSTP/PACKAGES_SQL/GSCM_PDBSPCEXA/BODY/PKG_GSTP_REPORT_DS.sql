--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_REPORT_DS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_REPORT_DS" AS

PROCEDURE ADS_REPORT_BM15
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_phuctham.HOTEN TENTHAMPHAN, thamphan_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join ( select * from ( select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='15-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
           , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                    )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
          where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.HOTEN TENTHAMPHAN, thamphan_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='15-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                    )thamphan_sotham on don.ID=thamphan_sotham.DONID
          where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM15;


PROCEDURE ADS_REPORT_BM16
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
     select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='16-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
          where don.ID=vDonID;

    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='16-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
          where don.ID=vDonID;
    END IF;

  END ADS_REPORT_BM16;  

PROCEDURE ADS_REPORT_BM17
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_phuctham.HOTEN TENTHAMPHAN, thamphan_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='17-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                    )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
          where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.HOTEN TENTHAMPHAN, thamphan_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='17-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                    )thamphan_sotham on don.ID=thamphan_sotham.DONID
          where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM17;

  PROCEDURE ADS_REPORT_BM18
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
     select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='18-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
          where don.ID=vDonID;

    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='18-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
          where don.ID=vDonID;
    END IF;

  END ADS_REPORT_BM18;

  PROCEDURE ADS_REPORT_BM19
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_phuctham.HOTEN TENTHAMPHAN, thamphan_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='19-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                    )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
          where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.HOTEN TENTHAMPHAN, thamphan_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='19-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                    )thamphan_sotham on don.ID=thamphan_sotham.DONID
          where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM19;

  PROCEDURE ADS_REPORT_BM20
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='20-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
          where don.ID=vDonID;

    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, nguyendon.TUCACHDUONGSU, nguyendon.DIACHI
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='20-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select a.ID, a.DONID, a.TENDUONGSU,'Nguyên đơn' TUCACHDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) nguyendon on don.ID=nguyendon.DONID
          left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
          where don.ID=vDonID;
    END IF;   
  END ADS_REPORT_BM20;



  PROCEDURE ADS_REPORT_BM21
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_phuctham.HOTEN TENTHAMPHAN, thamphan_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='21-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                    )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
          where don.ID=vDonID;

    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.HOTEN TENTHAMPHAN, thamphan_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='21-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY
                    , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_DON_THAMPHAN tp
                    left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                    )thamphan_sotham on don.ID=thamphan_sotham.DONID
          where don.ID=vDonID;
    END IF;   
  END ADS_REPORT_BM21;

  PROCEDURE ADS_REPORT_BM22
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC
            , replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY
            , qd_phuctham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='22-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
          left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
          where don.ID=vDonID;

    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC
            , replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY
            , qd_sotham.SOQD SOQD
          from ADS_DON don 
          inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
          left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='22-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
          left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
          where don.ID=vDonID;
    END IF;   
  END ADS_REPORT_BM22;

  PROCEDURE ADS_REPORT_BM25
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.LOAIGIAIQUYET, a.CDTN_TOAANID as TOAANIDCHUYENDEN, replace(ta.MA_TEN, ' - Tòa án nhân dân', ', ') as TOAANNDCHUYENDEN
      ,(CASE d.GIOITINH WHEN 1 THEN ('Ông ' || d.TENDUONGSU) ELSE ('Bà ' || d.TENDUONGSU) END) as TENDUONGSU
      ,(CASE c.HINHTHUCNHANDON WHEN 1 THEN 'nộp trực tiếp' WHEN 2 THEN 'do bưu điện chuyển đến' WHEN 3 THEN 'gửi trực tuyến bằng hình thức điện tử' END) as HINHTHUCNHANDON
      , d.DIACHI, d.EMAIL, d.DIENTHOAI, d.FAX, replace(c.TENTOAAN, ' - Tòa án nhân dân', ', ') as TENTOAAN, c.NGAYVIETDON
      ,c.NGAYNHANDON, c.NOIDUNGKHOIKIEN, NVL(e.TEN,'') as LYDOTRADON, a.YCBS_NOIDUNG, tp_gq.HOTEN as THAMPHANGIAIQUYET
      FROM ADS_DON_XULY a
      left join (select ID, TEN from DM_DATAITEM )e on e.ID = a.TRADON_LYDOID
      left join (select ID, MA_TEN from DM_TOAAN) ta on ta.ID=a.CDTN_TOAANID
      left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN  from ADS_DON_THAMPHAN tp
                       left join DM_CANBO cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETDON' and rownum<=1)tp_gq on tp_gq.DONID=a.DONID
      left join (select a.ID, b.ID as TOAANID, b.MA_TEN as TENTOAAN, a.HINHTHUCNHANDON, a.NGAYVIETDON, a.NGAYNHANDON, a.NOIDUNGKHOIKIEN from ADS_DON a
                                                        left join DM_TOAAN b on a.TOAANID=b.ID  where a.ID=vDonID) c on c.ID = a.DONID                                                
      left join (select a.ID, a.DONID, a.TENDUONGSU, a.EMAIL, a.DIENTHOAI, a.FAX, a.GIOITINH
                                , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                                       else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                                    end) DIACHI
                                from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                                where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) d on d.DONID= a.DONID
      WHERE (a.LOAIGIAIQUYET=1 or a.LOAIGIAIQUYET=2) and a.DONID=vDonID;

  END ADS_REPORT_BM25;

  PROCEDURE ADS_REPORT_BM26
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.LOAIGIAIQUYET, a.CDTN_TOAANID as TOAANIDCHUYENDEN, replace(ta.MA_TEN, ' - Tòa án nhân dân', ', ') as TOAANNDCHUYENDEN
      ,(CASE d.GIOITINH WHEN 1 THEN ('Ông ' || d.TENDUONGSU) ELSE ('Bà ' || d.TENDUONGSU) END) as TENDUONGSU
      ,(CASE c.HINHTHUCNHANDON WHEN 1 THEN 'nộp trực tiếp' WHEN 2 THEN 'do bưu điện chuyển đến' WHEN 3 THEN 'gửi trực tuyến bằng hình thức điện tử' END) as HINHTHUCNHANDON
      , d.DIACHI, d.EMAIL, d.DIENTHOAI, d.FAX, replace(c.TENTOAAN, ' - Tòa án nhân dân', ', ') as TENTOAAN, c.NGAYVIETDON
      ,c.NGAYNHANDON, c.NOIDUNGKHOIKIEN, NVL(e.TEN,'') as LYDOTRADON, a.YCBS_NOIDUNG, tp_gq.HOTEN as THAMPHANGIAIQUYET
      FROM ADS_DON_XULY a
      left join (select ID, TEN from DM_DATAITEM )e on e.ID = a.TRADON_LYDOID
      left join (select ID, MA_TEN from DM_TOAAN) ta on ta.ID=a.CDTN_TOAANID
      left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN  from ADS_DON_THAMPHAN tp
                       left join DM_CANBO cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETDON' and rownum<=1)tp_gq on tp_gq.DONID=a.DONID
      left join (select a.ID, b.ID as TOAANID, b.MA_TEN as TENTOAAN, a.HINHTHUCNHANDON, a.NGAYVIETDON, a.NGAYNHANDON, a.NOIDUNGKHOIKIEN from ADS_DON a
                                                        left join DM_TOAAN b on a.TOAANID=b.ID  where a.ID=vDonID) c on c.ID = a.DONID                                                
      left join (select a.ID, a.DONID, a.TENDUONGSU, a.EMAIL, a.DIENTHOAI, a.FAX, a.GIOITINH
                                , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                                       else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                                    end) DIACHI
                                from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                                where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) d on d.DONID= a.DONID
      WHERE a.LOAIGIAIQUYET=4 and a.DONID=vDonID;

  END ADS_REPORT_BM26;

  PROCEDURE ADS_REPORT_BM27
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.LOAIGIAIQUYET, a.CDTN_TOAANID as TOAANIDCHUYENDEN, replace(ta.MA_TEN, ' - Tòa án nhân dân', ', ') as TOAANNDCHUYENDEN
      ,(CASE d.GIOITINH WHEN 1 THEN ('Ông ' || d.TENDUONGSU) ELSE ('Bà ' || d.TENDUONGSU) END) as TENDUONGSU
      ,(CASE c.HINHTHUCNHANDON WHEN 1 THEN 'nộp trực tiếp' WHEN 2 THEN 'do bưu điện chuyển đến' WHEN 3 THEN 'gửi trực tuyến bằng hình thức điện tử' END) as HINHTHUCNHANDON
      , d.DIACHI, d.EMAIL, d.DIENTHOAI, d.FAX, replace(c.TENTOAAN, ' - Tòa án nhân dân', ', ') as TENTOAAN, c.NGAYVIETDON
      ,c.NGAYNHANDON, c.NOIDUNGKHOIKIEN, NVL(e.TEN,'') as LYDOTRADON, a.YCBS_NOIDUNG, tp_gq.HOTEN as THAMPHANGIAIQUYET
      FROM ADS_DON_XULY a
      left join (select ID, TEN from DM_DATAITEM )e on e.ID = a.TRADON_LYDOID
      left join (select ID, MA_TEN from DM_TOAAN) ta on ta.ID=a.CDTN_TOAANID
      left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN  from ADS_DON_THAMPHAN tp
                       left join DM_CANBO cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETDON' and rownum<=1)tp_gq on tp_gq.DONID=a.DONID
      left join (select a.ID, b.ID as TOAANID, b.MA_TEN as TENTOAAN, a.HINHTHUCNHANDON, a.NGAYVIETDON, a.NGAYNHANDON, a.NOIDUNGKHOIKIEN from ADS_DON a
                                                        left join DM_TOAAN b on a.TOAANID=b.ID  where a.ID=vDonID) c on c.ID = a.DONID                                                
      left join (select a.ID, a.DONID, a.TENDUONGSU, a.EMAIL, a.DIENTHOAI, a.FAX, a.GIOITINH
                                , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                                       else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                                    end) DIACHI
                                from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                                where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) d on d.DONID= a.DONID
      WHERE a.LOAIGIAIQUYET=3 and a.DONID=vDonID;

  END ADS_REPORT_BM27;

   PROCEDURE ADS_REPORT_BM29
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.LOAIGIAIQUYET, NVL(anphi.TAMUNGANPHI,0) TAMUNGANPHI, a.CDTN_TOAANID as TOAANIDCHUYENDEN, replace(ta.MA_TEN, ' - Tòa án nhân dân', ', ') as TOAANNDCHUYENDEN
      ,(CASE d.GIOITINH WHEN 1 THEN ('Ông ' || d.TENDUONGSU) ELSE ('Bà ' || d.TENDUONGSU) END) as TENDUONGSU
      ,(CASE c.HINHTHUCNHANDON WHEN 1 THEN 'nộp trực tiếp' WHEN 2 THEN 'do bưu điện chuyển đến' WHEN 3 THEN 'gửi trực tuyến bằng hình thức điện tử' END) as HINHTHUCNHANDON
      , d.DIACHI, d.EMAIL, d.DIENTHOAI, d.FAX, replace(c.TENTOAAN, ' - Tòa án nhân dân', ', ') as TENTOAAN, ta.DIACHI DIACHITRUSO, c.NGAYVIETDON
      ,c.NGAYNHANDON, c.NOIDUNGKHOIKIEN, NVL(e.TEN,'') as LYDOTRADON, a.YCBS_NOIDUNG, tp_gq.HOTEN as THAMPHANGIAIQUYET
      FROM ADS_DON_XULY a
      left join (select ID, TEN from DM_DATAITEM )e on e.ID = a.TRADON_LYDOID
      left join (select ID, MA_TEN, DIACHI from DM_TOAAN) ta on ta.ID=a.CDTN_TOAANID
      left join (select DONID, TAMUNGANPHI from ADS_ANPHI) anphi on anphi.DONID=a.DONID
      left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN  from ADS_DON_THAMPHAN tp
                       left join DM_CANBO cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETDON' and rownum<=1)tp_gq on tp_gq.DONID=a.DONID
      left join (select a.ID, b.ID as TOAANID, b.MA_TEN as TENTOAAN, a.HINHTHUCNHANDON, a.NGAYVIETDON, a.NGAYNHANDON, a.NOIDUNGKHOIKIEN from ADS_DON a
                                                        left join DM_TOAAN b on a.TOAANID=b.ID  where a.ID=vDonID) c on c.ID = a.DONID                                                
      left join (select a.ID, a.DONID, a.TENDUONGSU, a.EMAIL, a.DIENTHOAI, a.FAX, a.GIOITINH
                                , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                                       else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                                    end) DIACHI
                                from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                                where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) d on d.DONID= a.DONID
      WHERE a.LOAIGIAIQUYET=5 and a.DONID=vDonID;

  END ADS_REPORT_BM29;

  PROCEDURE ADS_REPORT_BM30
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.LOAIGIAIQUYET, a.CDTN_TOAANID as TOAANIDCHUYENDEN, replace(b.MA_TEN, ' - Tòa án nhân dân', ', ') as TOAANNDCHUYENDEN
      ,d.TENDUONGSU, d.DIACHI, d.EMAIL, d.DIENTHOAI, d.FAX, replace(c.TENTOAAN, ' - Tòa án nhân dân', ', ') as TENTOAAN, c.NGAYVIETDON
      ,c.NGAYNHANDON, c.NOIDUNGKHOIKIEN, NVL(e.TEN,'') as LYDOTRADON, a.YCBS_NOIDUNG, tp_gq.HOTEN as THAMPHANGIAIQUYET
      FROM ADS_DON_XULY a
      left join (select ID, TEN from DM_DATAITEM )e on e.ID = a.TRADON_LYDOID
      left join (select ID, MA_TEN from DM_TOAAN) b on b.ID=a.CDTN_TOAANID
      left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN  from ADS_DON_THAMPHAN tp
                       left join DM_CANBO cb on cb.ID=tp.CANBOID where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETDON' and rownum<=1)tp_gq on tp_gq.DONID=a.DONID
      left join (select a.ID, b.ID as TOAANID, b.MA_TEN as TENTOAAN, a.NGAYVIETDON, a.NGAYNHANDON, a.NOIDUNGKHOIKIEN from ADS_DON a
                                                        left join DM_TOAAN b on a.TOAANID=b.ID  where a.ID=vDonID) c on c.ID = a.DONID                                                
      left join (select a.ID, a.DONID, a.TENDUONGSU, a.EMAIL, a.DIENTHOAI, a.FAX, a.GIOITINH
                                , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                                       else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                                    end) DIACHI
                                from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                                where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1) d on d.DONID= a.DONID
      WHERE a.LOAIGIAIQUYET=5 and a.DONID=vDonID;

  END ADS_REPORT_BM30;

  PROCEDURE ADS_REPORT_BM41
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            ,thamphan_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='41-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                      )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='41-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY  from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID 
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                      )thamphan_sotham on don.ID=thamphan_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM41;

  PROCEDURE ADS_REPORT_BM42
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='42-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='42-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM42;

  PROCEDURE ADS_REPORT_BM43
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            ,thamphan_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='43-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                      )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='43-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY  from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID 
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                      )thamphan_sotham on don.ID=thamphan_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM43;

  PROCEDURE ADS_REPORT_BM44
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='44-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='44-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM44;

  PROCEDURE ADS_REPORT_BM45
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            ,thamphan_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='45-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' and rownum<=1
                      )thamphan_phuctham on don.ID=thamphan_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphan_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='45-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select tp.ID, tp.CANBOID, tp.DONID, cb.HOTEN TENKY  from ADS_DON_THAMPHAN tp
                            left join (select ID, TOAANID, HOTEN from DM_CANBO) cb on cb.ID=tp.CANBOID 
                            where tp.DONID=vDonID and tp.MAVAITRO='VTTP_GIAIQUYETSOTHAM' and rownum<=1
                      )thamphan_sotham on don.ID=thamphan_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM45;

  PROCEDURE ADS_REPORT_BM46
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY, qd_phuctham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='46-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY, qd_sotham.SOQD SOQD
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='46-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM46;

  PROCEDURE ADS_REPORT_BM47
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN

     select ad.MaGiaiDoan into vMaGiaiDoan from ADS_DON ad where ad.ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
          open curReturn for
           select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_phuctham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_phuctham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_phuctham.TENKY, qd_phuctham.SOQD SOQD
            , SoTL_phuctham.Ngay, SoTL_phuctham.Thang, SoTL_phuctham.Nam
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_phuctham on don.TOAPHUCTHAMID = dm_ta_phuctham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                        , DONID, SOTHULY, NGAYTHULY, to_char(sysdate, 'dd') Ngay, to_char(sysdate, 'MM') Thang
                        , to_char(sysdate, 'yyyy') Nam from ADS_PHUCTHAM_THULY where DONID=vDonID) where STT<=1
                      ) SoTL_phuctham on don.ID = SoTL_phuctham.DONID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(phuctham_QD.NGAYQD,'') desc) STT, phuctham_QD.ID, phuctham_QD.DONID, phuctham_QD.SOQD from ADS_PHUCTHAM_QUYETDINH phuctham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = phuctham_QD.QUYETDINHID
                      where DM_QD.MA='46-DS' and phuctham_QD.DONID=vDonID) where STT<=1
                    ) qd_phuctham on don.ID = qd_phuctham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                        ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_pt.CANBOID, hdxx_pt.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_PHUCTHAM_HDXX hdxx_pt 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_pt.CANBOID=cb.ID
                            where hdxx_pt.MAVAITRO='THAMPHAN' and hdxx_pt.DONID=vDonID and rownum<=1
                    )thamphanchutoa_phuctham on don.ID=thamphanchutoa_phuctham.DONID
            where don.ID=vDonID;
    ELSE
        open curReturn for
        select don.ID, don.TENVUVIEC, nguyendon.TENDUONGSU, replace(dm_ta_sotham.MA_TEN, ' - Tòa án nhân dân', ', ') TENTOAAN
            , thamphanchutoa_sotham.HOTEN TENTHAMPHANCHUTOA, thamphanchutoa_sotham.TENKY, qd_sotham.SOQD SOQD
            , SoTL_sotham.Ngay, SoTL_sotham.Thang, SoTL_sotham.Nam
            from ADS_DON don 
            inner join (select ID, MA_TEN from DM_TOAAN) dm_ta_sotham on don.TOAANID = dm_ta_sotham.ID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(NGAYTHULY,'') desc) STT
                        , DONID, SOTHULY, NGAYTHULY, to_char(sysdate, 'dd') Ngay, to_char(sysdate, 'MM') Thang
                        , to_char(sysdate, 'yyyy') Nam from ADS_SOTHAM_THULY where DONID=vDonID) where STT<=1
                      ) SoTL_sotham on don.ID = SoTL_sotham.DONID
            left join (select * from (select ROW_NUMBER() OVER (ORDER BY NVL(sotham_QD.NGAYQD,'') desc) STT, sotham_QD.ID, sotham_QD.DONID, sotham_QD.SOQD from ADS_SOTHAM_QUYETDINH sotham_QD
                      left join (select ID, MA from DM_QD_QUYETDINH) DM_QD on DM_QD.ID = sotham_QD.QUYETDINHID
                      where DM_QD.MA='46-DS' and sotham_QD.DONID=vDonID) where STT<=1
                    ) qd_sotham on don.ID = qd_sotham.DONID
            left join (select a.ID, a.DONID, a.TENDUONGSU
                          from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
                          where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID AND ISDAIDIEN=1
                      ) nguyendon on don.ID=nguyendon.DONID
            left join (select hdxx_st.CANBOID, hdxx_st.DONID, cb.HOTEN TENKY
                            , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN  from ADS_SOTHAM_HDXX hdxx_st 
                            left join (select ID, TOAANID, GIOITINH, HOTEN from DM_CANBO) cb on hdxx_st.CANBOID=cb.ID
                            where hdxx_st.MAVAITRO='THAMPHAN' and hdxx_st.DONID=vDonID and rownum<=1
                    )thamphanchutoa_sotham on don.ID=thamphanchutoa_sotham.DONID
        where don.ID=vDonID;
    END IF;    
  END ADS_REPORT_BM47;

  PROCEDURE ADS_REPORT_ThamPhan
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
           open curReturn for
           select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,phuct_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_PHUCTHAM_HDXX phuct_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on phuct_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THAMPHANHDXX';
      ELSE
          open curReturn for
          select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_SOTHAM_HDXX sot_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THAMPHANHDXX';
      END IF; 

  END ADS_REPORT_ThamPhan;

  PROCEDURE ADS_REPORT_HoiThamND
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
           open curReturn for
           select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,phuct_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_PHUCTHAM_HDXX phuct_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on phuct_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='HTND';
      ELSE
          open curReturn for
          select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_SOTHAM_HDXX sot_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='HTND';
      END IF; 

  END ADS_REPORT_HoiThamND;


PROCEDURE ADS_REPORT_TPDuKhuyet
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
           open curReturn for
           select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,phuct_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_PHUCTHAM_HDXX phuct_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on phuct_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THAMPHANDUKHUYET';
      ELSE
          open curReturn for
          select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_SOTHAM_HDXX sot_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THAMPHANDUKHUYET';
      END IF; 

  END ADS_REPORT_TPDuKhuyet;

  PROCEDURE ADS_REPORT_ThuKy
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
           open curReturn for
           select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,phuct_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_PHUCTHAM_HDXX phuct_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on phuct_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THUKY';
      ELSE
          open curReturn for
          select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_SOTHAM_HDXX sot_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='THUKY';
      END IF; 

  END ADS_REPORT_ThuKy;

  PROCEDURE ADS_REPORT_KiemSatVien
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  vMaGiaiDoan number;
  BEGIN
    select MaGiaiDoan into vMaGiaiDoan from ADS_DON where ID=vDonID;
     --vMaGiaiDoan=2: so tham
     --vMaGiaiDoan=3: Phuc tham
     IF vMaGiaiDoan = 3 THEN
           open curReturn for
           select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,phuct_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_PHUCTHAM_HDXX phuct_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on phuct_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='KIEMSOATVIEN';
      ELSE
          open curReturn for
          select ROW_NUMBER () OVER (ORDER BY NGAYPHANCONG) STT ,sot_hdxx.DONID
                , DECODE(NVL(cb.GIOITINH,0) ,0, ('Bà ' || cb.HOTEN),1, ('Ông ' || cb.HOTEN)) HOTEN 
                from ADS_SOTHAM_HDXX sot_hdxx
                inner join (select ID, GIOITINH, HOTEN from DM_CANBO) cb on sot_hdxx.CANBOID=cb.ID
                where DONID=vDonID and MAVAITRO='KIEMSOATVIEN';
      END IF; 

  END ADS_REPORT_KiemSatVien;

PROCEDURE ADS_REPORT_GETNGUYENDON
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
           open curReturn for
           select a.ID, a.DONID, a.TENDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'NGUYENDON' and a.DONID=vDonID;

  END ADS_REPORT_GETNGUYENDON;

  PROCEDURE ADS_REPORT_GETBIDON
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
           open curReturn for
           select a.ID, a.DONID, a.TENDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'BIDON' and a.DONID=vDonID;

  END ADS_REPORT_GETBIDON;

  PROCEDURE ADS_REPORT_NGUOICOQUYENNVLQ
(
  vDonID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
           open curReturn for
           select a.ID, a.DONID, a.TENDUONGSU
            , (case when (a.HKTTCHITIET|| ' ')=' ' then b.Ma_ten
                               else (a.HKTTCHITIET || ', ' || b.MA_TEN )
                            end) DIACHI
              from ADS_DON_DUONGSU a left join DM_HANHCHINH b on b.ID = a.HKTTID
              where a.TUCACHTOTUNG_MA = 'QUYENNVLQ' and a.DONID=vDonID;

  END ADS_REPORT_NGUOICOQUYENNVLQ;

END PKG_GSTP_REPORT_DS;
