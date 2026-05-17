CREATE OR REPLACE PROCEDURE GSCM."ADS_ST_KCKN_TINHTRANG_GETLIST" 
( vDonID in number,
	curReturn OUT sys_refcursor
)
IS
vKhangCao NUMBER:=1;
vKhangNghi NUMBER:=2;
BEGIN
OPEN curReturn FOR
  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
--        ,(Case d.HINHTHUCNHAN WHEN 1 then 'Trực tiếp'
--                              WHEN 2 then 'Qua bưu điện' End) as HTNhanDonDonViKN
        ,s.TENDUONGSU as NguoiKCCapKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
--        ,d.NGAYKHANGCAO as NgayKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
--        ,d.NGAYQDBA as NGAYQDBA
        ,r.NGAYRUT
        ,r.TRANGTHAI
        ,r.NOIDUNGRUT
        ,d.TINHTRANG_GIAIQUYET
        ,d.TOA_GIAIQUYET_ID
        --,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From ADS_SOTHAM_KHANGCAO d
  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from ADS_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangCao) r on r.IDKCKN=d.ID
  left join (select a.ID,a.TENDUONGSU from ADS_DON_DUONGSU a where a.DONID=vDonID) s on s.ID=d.DUONGSUID
  left join (select e.ID,e.SOBANAN from ADS_SOTHAM_BANAN e where e.DONID=vDonID) b on b.ID=d.SOQDBA
  left join (select f.ID,f.SOQD from ADS_SOTHAM_QUYETDINH f where f.DONID=vDonID) q on q.ID=d.SOQDBA
  Where d.DONID=vDonID
  union all
  Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
--        ,(Case d.DONVIKN WHEN 1 then 'Viện trưởng'
--                              WHEN 2 then '' End) as HTNhanDonDonViKN
        ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
--        ,d.NGAYKN as NgayKCKN
        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
--        ,d.NGAYBANAN as NGAYQDBA
        ,r.NGAYRUT
        ,r.TRANGTHAI
        ,r.NOIDUNGRUT
        ,d.TINHTRANG_GIAIQUYET
        ,d.TOA_GIAIQUYET_ID
--        ,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From ADS_SOTHAM_KHANGNGHI d
  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from ADS_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangNghi) r on r.IDKCKN=d.ID
  left join (select a.ID,a.SOBANAN from ADS_SOTHAM_BANAN a where a.DONID=vDonID) b on b.ID=d.BANANID
  left join (select c.ID,c.SOQD from ADS_SOTHAM_QUYETDINH c where c.DONID=vDonID) q on q.ID=d.BANANID
  Where d.DONID=vDonID;

END ADS_ST_KCKN_TINHTRANG_GETLIST;

-- Bản cũ trước khi toàn cầu sửa yêu cầu về tạm đình chỉ (xóa sau khi đã test xong)
--create or replace NONEDITIONABLE PROCEDURE        "ADS_ST_KCKN_TINHTRANG_GETLIST" 
--( vDonID in number,
--	curReturn OUT sys_refcursor
--)
--IS
--vKhangCao NUMBER:=1;
--vKhangNghi NUMBER:=2;
--BEGIN
--OPEN curReturn FOR
--  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
----        ,(Case d.HINHTHUCNHAN WHEN 1 then 'Trực tiếp'
----                              WHEN 2 then 'Qua bưu điện' End) as HTNhanDonDonViKN
--        ,s.TENDUONGSU as NguoiKCCapKN
--        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
----        ,d.NGAYKHANGCAO as NgayKCKN
--        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
----        ,d.NGAYQDBA as NGAYQDBA
--        ,r.NGAYRUT
--        ,r.TRANGTHAI
--        ,r.NOIDUNGRUT
--        --,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
--  From ADS_SOTHAM_KHANGCAO d
--  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from ADS_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangCao) r on r.IDKCKN=d.ID
--  left join (select a.ID,a.TENDUONGSU from ADS_DON_DUONGSU a where a.DONID=vDonID) s on s.ID=d.DUONGSUID
--  left join (select e.ID,e.SOBANAN from ADS_SOTHAM_BANAN e where e.DONID=vDonID) b on b.ID=d.SOQDBA
--  left join (select f.ID,f.SOQD from ADS_SOTHAM_QUYETDINH f where f.DONID=vDonID) q on q.ID=d.SOQDBA
--  Where d.DONID=vDonID
--  union all
--  Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
----        ,(Case d.DONVIKN WHEN 1 then 'Viện trưởng'
----                              WHEN 2 then '' End) as HTNhanDonDonViKN
--        ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
--        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
----        ,d.NGAYKN as NgayKCKN
--        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
----        ,d.NGAYBANAN as NGAYQDBA
--        ,r.NGAYRUT
--        ,r.TRANGTHAI
--        ,r.NOIDUNGRUT
----        ,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
--  From ADS_SOTHAM_KHANGNGHI d
--  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from ADS_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangNghi) r on r.IDKCKN=d.ID
--  left join (select a.ID,a.SOBANAN from ADS_SOTHAM_BANAN a where a.DONID=vDonID) b on b.ID=d.BANANID
--  left join (select c.ID,c.SOQD from ADS_SOTHAM_QUYETDINH c where c.DONID=vDonID) q on q.ID=d.BANANID
--  Where d.DONID=vDonID;
--
--END ADS_ST_KCKN_TINHTRANG_GETLIST;