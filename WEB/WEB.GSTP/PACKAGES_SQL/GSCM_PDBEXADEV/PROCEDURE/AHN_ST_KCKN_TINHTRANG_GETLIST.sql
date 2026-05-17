create or replace NONEDITIONABLE PROCEDURE        "AHN_ST_KCKN_TINHTRANG_GETLIST" 
( vDonID in number,
	curReturn OUT sys_refcursor
)
IS
vKhangCao NUMBER:=1;
vKhangNghi NUMBER:=2;
BEGIN
OPEN curReturn FOR
  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
        , case when  NVL(d.LoaiDuongSu,0) =0 then s.TenDuongSu
               when NVL(d.LoaiDuongSu, 0)>0 then tgtt.HoTen end  as NguoiKCCapKN               
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
        ,r.NGAYRUT ,r.TRANGTHAI,r.NOIDUNGRUT,D.TINHTRANG_GIAIQUYET,d.TOA_GIAIQUYET_ID
  From AHN_SOTHAM_KHANGCAO d
   left join (select ID, HoTen from AHN_Don_ThamGiaToTung
               where DonID = vDonID) tgtt on tgtt.ID =d.DuongSuID 
    left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from AHN_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangCao) r on r.IDKCKN=d.ID
    left join (select a.ID,a.TENDUONGSU from AHN_DON_DUONGSU a where a.DONID=vDonID) s on s.ID=d.DUONGSUID
    left join (select e.ID,e.SOBANAN from AHN_SOTHAM_BANAN e where e.DONID=vDonID) b on b.ID=d.SOQDBA
    left join (select f.ID,f.SOQD from AHN_SOTHAM_QUYETDINH f where f.DONID=vDonID) q on q.ID=d.SOQDBA
  Where d.DONID=vDonID
  union all
    Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
          ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
          ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
          ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
          ,r.NGAYRUT,r.TRANGTHAI ,r.NOIDUNGRUT,D.TINHTRANG_GIAIQUYET,d.TOA_GIAIQUYET_ID
    From AHN_SOTHAM_KHANGNGHI d
    left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from AHN_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangNghi) r on r.IDKCKN=d.ID
    left join (select a.ID,a.SOBANAN from AHN_SOTHAM_BANAN a where a.DONID=vDonID) b on b.ID=d.BANANID
    left join (select c.ID,c.SOQD from AHN_SOTHAM_QUYETDINH c where c.DONID=vDonID) q on q.ID=d.BANANID
    Where d.DONID=vDonID;

END AHN_ST_KCKN_TINHTRANG_GETLIST;