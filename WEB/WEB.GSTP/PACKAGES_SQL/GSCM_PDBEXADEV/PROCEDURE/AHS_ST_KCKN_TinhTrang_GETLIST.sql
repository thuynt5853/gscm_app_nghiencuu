create or replace NONEDITIONABLE PROCEDURE        "AHS_ST_KCKN_TINHTRANG_GETLIST" 
( vVUANID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
        ,s.HOTEN || l.HOTEN as NguoiKCCapKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        --,d.NGAYKHANGCAO as NgayKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        --,d.NGAYQDBA as NGAYQDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        ,d.TOA_GIAIQUYET_ID
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGCAO d
  left join (select g.ID,g.KHANGCAOID,g.NGAYRUT,g.TINHTRANG,g.NOIDUNG from AHS_SOTHAM_RUTKHANGCAO g) r on r.KHANGCAOID=d.ID
  left join (select a.ID,a.HOTEN from AHS_BICANBICAO a where a.VUANID=vVUANID) s on s.ID=d.NGUOIKCID
  left join (select l.ID,l.HOTEN from AHS_NGUOITHAMGIATOTUNG l where l.VUANID=vVUANID) l on l.ID=d.NGUOIKCID
  left join (select e.VUANID,e.SOBANAN from AHS_SOTHAM_BANAN e where e.VUANID=vVUANID) b on b.VUANID=d.VUANID
  left join (select f.VUANID,f.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN f where f.VUANID=vVUANID) q on q.VUANID=d.SOQDBA
  Where d.VUANID=vVUANID
  union all
  Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
        ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        --,d.NGAYKN as NgayKCKN
        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        --,d.NGAYBANAN as NGAYQDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        ,d.TOA_GIAIQUYET_ID
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGNGHI d 
  left join (select g.ID,g.KHANGNGHIID,g.NGAYRUT,g.TINHTRANG,g.NOIDUNG from AHS_SOTHAM_RUTKHANGNGHI g) r on r.KHANGNGHIID=d.ID
  left join (select a.VUANID,a.SOBANAN from AHS_SOTHAM_BANAN a where a.VUANID=vVuAnID) b on b.VUANID=d.VUANID
  left join (select c.VUANID,c.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN c where c.VUANID=vVuAnID) q on q.VUANID=d.VUANID
  Where d.VUANID=vVuAnID;

END AHS_ST_KCKN_TinhTrang_GETLIST;