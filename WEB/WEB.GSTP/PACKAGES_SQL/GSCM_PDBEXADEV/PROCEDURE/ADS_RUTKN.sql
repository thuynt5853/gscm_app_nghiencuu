CREATE OR REPLACE PROCEDURE GSCM."ADS_RUTKN" 
(
  vDonViID in number,
  vMaVuViec in varchar2, 
  vTenVuViec in varchar2,
  vSoQD_BA in varchar2,
  vTenDuongSu in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vTrangThai in number,
  vPageIndex in int,
  vPageSize in int,
  curReturn OUT sys_refcursor
) AS
  vTotalItem number;
  vMinIndex	number;
  vMaxIndex	number;
BEGIN
  vMinIndex := vPageSize*(vPageIndex - 1) + 1;
  vMaxIndex := vPageIndex*vPageSize ;
  -- Vụ án đã giải quyết xong (có bản án hoặc có quyết định đình chỉ hoặc quyết định công nhận thỏa thuận)
  -- Tính tổng
  select count(a.ID) into vTotalItem
    from ADS_DON a
    INNER JOIN (SELECT G.* FROM ADS_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID
    inner join DM_TOAAN ta on a.TOAANID=ta.ID
    where (1=case when (vMaVuViec || ' ')=' ' then 1 when LOWER(a.MAVUVIEC) like  ('%' || LOWER(vMaVuViec) || '%') then 1 else 0 end)
          and
          (1=case when (vTenVuViec || ' ')=' ' then 1 when LOWER(a.TENVUVIEC) like  ('%' || LOWER(vTenVuViec) || '%') then 1 else 0 end)
          and
          (
            (1=(case when (select count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            inner join DM_QD_QUYETDINH DMQD on DMQD.ID=qd.QUYETDINHID 
                            where qd.DONID=a.ID AND DMQD.KET_THUC = 1 AND 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when  LOWER(qd.SOQD) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where ba.DONID=a.ID and 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when LOWER(ba.SOBANAN) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            inner join DM_QD_QUYETDINH DMQD on DMQD.ID=qd.QUYETDINHID 
                            where qd.DONID=a.ID AND DMQD.KET_THUC = 1 AND 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when  LOWER(qd.SOQD) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where ba.DONID=a.ID and 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when LOWER(ba.SOBANAN) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
          )
          and
          (1=(case when (select count(ds.ID) from ADS_DON_DUONGSU ds 
                          where ds.DONID=a.ID and 
                          (1=case when (vTenDuongSu || ' ')=' ' then 1 when LOWER(ds.TENDUONGSU) like ('%' || LOWER(vTenDuongSu) || '%') then 1 else 0 end)
                          )>0 then 1 else 0 end))
          and 
          (
            (1=(case when (select Count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            where (1=case when vTuNgay is null then 1 when vTungay <= qd.NGAYQD then 1 else 0 end)
                              and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where (1=case when vTuNgay is null then 1 when vTuNgay <= ba.NGAYTUYENAN then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            where (1=case when vTuNgay is null then 1 when vTungay <= qd.NGAYQD then 1 else 0 end)
                              and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where (1=case when vTuNgay is null then 1 when vTuNgay <= ba.NGAYTUYENAN then 1 else 0 end)
                            and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
          )
          and 
          (
            (1=(case when (select Count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            where (1=case when vDenNgay is null then 1 when qd.NGAYQD <= vDenngay then 1 else 0 end)
                            and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where (1=case when vDenNgay is null then 1 when ba.NGAYTUYENAN <= vDenngay then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            where (1=case when vDenNgay is null then 1 when qd.NGAYQD <= vDenngay then 1 else 0 end)
                            and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where (1=case when vDenNgay is null then 1 when ba.NGAYTUYENAN <= vDenngay then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
          )
          and
          (1=(case when vTrangThai=0 and (Select Count(sx.ID) from ADS_SAUXETXU sx where sx.VUANID=a.ID)=0 then 1
                   when vTrangThai>0 and (Select Count(sx.ID) from ADS_SAUXETXU sx where sx.VUANID=a.ID)>0 then 1
                   else 0 end));
--          and (1= case when a.MAGIAIDOAN=2 and a.TOAANID=vDonViID then 1
--                         when a.MAGIAIDOAN=3 and a.TOAPHUCTHAMID=vDonViID then 1 else 0 end);
  -- Lấy dữ liệu theo PageIndex
  open curReturn for
    select a.ID,a.MAVUVIEC,a.TENVUVIEC,a.GiaiDoan, vTotalItem as CountAll
    from(
      select ROW_NUMBER() OVER (ORDER BY a.MAVUVIEC) as stt,a.ID,a.MAVUVIEC,a.TENVUVIEC,
        case a.MAGIAIDOAN when 1 then 'Hồ sơ'
                          when 2 then 'Sơ thẩm'
                          when 3 then 'Phúc thẩm'
                          when 4 then 'Giám đốc thẩm, tái thẩm' else '' end as GiaiDoan,
                          a.TOA_GIAIQUYET_ID
      from ADS_DON a
      INNER JOIN (SELECT G.* FROM ADS_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID
      inner join DM_TOAAN ta on a.TOAANID=ta.ID
      where (1=case when (vMaVuViec || ' ')=' ' then 1 when LOWER(a.MAVUVIEC) like  ('%' || LOWER(vMaVuViec) || '%') then 1 end)
            and
            (1=case when (vTenVuViec || ' ')=' ' then 1 when LOWER(a.TENVUVIEC) like  ('%' || LOWER(vTenVuViec) || '%') then 1 end)
            and
            (
            (1=(case when (select count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            inner join DM_QD_QUYETDINH DMQD on DMQD.ID=qd.QUYETDINHID 
                            where qd.DONID=a.ID AND DMQD.KET_THUC = 1 AND 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when  LOWER(qd.SOQD) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where ba.DONID=a.ID and 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when LOWER(ba.SOBANAN) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            inner join DM_QD_QUYETDINH DMQD on DMQD.ID=qd.QUYETDINHID 
                            where qd.DONID=a.ID AND DMQD.KET_THUC = 1 AND 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when  LOWER(qd.SOQD) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
            or
            (1=(case when (select count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where ba.DONID=a.ID and 
                            (1=case when (vSoQD_BA || ' ')=' ' then 1 when LOWER(ba.SOBANAN) like ('%' || LOWER(vSoQD_BA) || '%') then 1 else 0 end)
                            )>0 then 1 else 0 end))
          )
          and
          (1=(case when (select count(ds.ID) from ADS_DON_DUONGSU ds 
                          where ds.DONID=a.ID and 
                          (1=case when (vTenDuongSu || ' ')=' ' then 1 when LOWER(ds.TENDUONGSU) like ('%' || LOWER(vTenDuongSu) || '%') then 1 else 0 end)
                          )>0 then 1 else 0 end))
          and 
          (
            (1=(case when (select Count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            where (1=case when vTuNgay is null then 1 when vTungay <= qd.NGAYQD then 1 else 0 end)
                              and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where (1=case when vTuNgay is null then 1 when vTuNgay <= ba.NGAYTUYENAN then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            where (1=case when vTuNgay is null then 1 when vTungay <= qd.NGAYQD then 1 else 0 end)
                              and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where (1=case when vTuNgay is null then 1 when vTuNgay <= ba.NGAYTUYENAN then 1 else 0 end)
                            and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
          )
          and 
          (
            (1=(case when (select Count(qd.ID) from ADS_SOTHAM_QUYETDINH qd 
                            where (1=case when vDenNgay is null then 1 when qd.NGAYQD <= vDenngay then 1 else 0 end)
                            and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_SOTHAM_BANAN ba 
                            where (1=case when vDenNgay is null then 1 when ba.NGAYTUYENAN <= vDenngay then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(qd.ID) from ADS_PHUCTHAM_QUYETDINH qd 
                            where (1=case when vDenNgay is null then 1 when qd.NGAYQD <= vDenngay then 1 else 0 end)
                            and qd.DONID=a.ID 
                            )>0  then 1 else 0 end))
            or
            (1=(case when (select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba 
                            where (1=case when vDenNgay is null then 1 when ba.NGAYTUYENAN <= vDenngay then 1 else 0 end)
                              and ba.DONID=a.ID 
                            )>0  then 1 else 0 end))
          )
            and
            (1=(case when vTrangThai=0 and (Select Count(sx.ID) from ADS_SAUXETXU sx where sx.VUANID=a.ID)=0 then 1
                     when vTrangThai>0 and (Select Count(sx.ID) from ADS_SAUXETXU sx where sx.VUANID=a.ID)>0 then 1
                     else 0 end))
--            and (1= case when a.MAGIAIDOAN=2 and a.TOAANID=vDonViID then 1
--                         when a.MAGIAIDOAN=3 and a.TOAPHUCTHAMID=vDonViID then 1 else 0 end)
          ) a where a.stt between vMinIndex and vMaxIndex
    ;
END ADS_RUTKN;