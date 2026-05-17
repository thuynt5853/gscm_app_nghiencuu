CREATE OR REPLACE NONEDITIONABLE PROCEDURE GSCM."AHC_DON_XULY_GETBYDONID" 
(
   CurrDonID in int,   
	 PageIndex	in	int,
	 PageSize	in	int,
	 curReturn    OUT   sys_refcursor
)
AS
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

		--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
	  select count (a.ID) into TotalItem 
    from AHC_DON_XULY a where a.DonID =CurrDonID;
		---------------------------------------------------
    OPEN curReturn FOR 
    select a.*, TotalItem as CountAll 
			from (select ROWNUM  stt,g.ID, g.DonID, g.DON_CHITIETID, g.DON_GOCID
                , g.LoaiGiaiQuyet   
                , g.duongsu
                , g.NoiDung
                , g.BienPhapGQ
                , g.NguoiGQ
                , g.NgayGQ_YC, g.LyDo
                , g.CDTN_ToaAnID, g.Ten, g.CDTN_NGAYNHAN
                , g.CDNN_TenCQ
                , g.TraDon_CanCuID
                , g.NgayTao, g.NguoiTao
                , g.NgaySua, g.NguoiSua,g.TENFILE,g.FILEID, g.LOAIDON
                , g.TOA_GIAIQUYET_ID
                    from (select a.ID, t.ID as DONID, a.DON_CHITIETID, t.ID as DON_GOCID
                        , a.LoaiGiaiQuyet   
                        , to_char('Tên người khởi kiện: ' || d.tenduongsu || '<br>Địa chỉ: ' ||decode(d.tamtruchitiet,null,'',d.tamtruchitiet || ',')|| (CASE d.LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) 
                        || DECODE(TO_CHAR(t.ngayvietdon,'dd/MM/yyyy'), '01/01/0001', '','<br>Ngày ghi trên đơn: ' || TO_CHAR(t.ngayvietdon,'dd/MM/yyyy'))
                        || '<br>Ngày nhận đơn: ' ||TO_CHAR(t.ngaynhandon,'dd/MM/yyyy'))
                        as duongsu -- lanh lay them duong su
                        , t.noidungkhoikien as NoiDung
                         ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end)|| DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', null, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                        , a.NgayGQ_YC as NgayGQ_YC, a.LyDo
                        , a.CDTN_ToaAnID, b.Ten, a.CDTN_NGAYNHAN
                        , a.CDNN_TenCQ
                        , a.TraDon_CanCuID
                        , a.NgayTao, a.NguoiTao
                        , a.NgaySua, a.NguoiSua,f.TENFILE,a.FILEID, 0 as LOAIDON
                        , tp.TOA_GIAIQUYET_ID
                      from AHC_DON t
                        left join AHC_DON_XULY a on t.ID = a.DONID --lanh lay noi dung don
                        left join DM_ToaAn b on a.CDTN_ToaAnID = b.ID
                        left join AHC_FILE f on a.FILEID=f.ID
                        left join AHC_DON_DUONGSU d on d.DONID = t.ID and d.isdaidien=1 AND d.TUCACHTOTUNG_MA='NGUYENDON' -- lanh lay thong tin duong su đơn gốc
                        left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
                        left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID

                        left join AHC_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where t.ID =CurrDonID 
                      union all
                      select a.ID, a.DonID, c.ID as DON_CHITIETID, t.ID as DON_GOCID
                        , a.LoaiGiaiQuyet   
                        , to_char(DECODE(c.LOAIDON, 5, 'Người khởi kiện: ' || ds.TENNGUOINOP, 6, 'Người khởi kiện: ' || ds.TENNGUOINOP, nd.nguyendon)
                        || DECODE(TO_CHAR(c.ngayvietdon,'dd/MM/yyyy'), '01/01/0001', '','<br>Ngày ghi trên đơn: ' || TO_CHAR(c.ngayvietdon,'dd/MM/yyyy'))
                        || '<br>Ngày nhận đơn: ' ||TO_CHAR(c.ngaynhandon,'dd/MM/yyyy')
                        ||case when c.LOAIDON =1 then '<br>Loại đơn: <b>Đơn khởi kiện</b>'
                              when c.LOAIDON =2 then '<br>Loại đơn: <b>Đơn từ Tòa án khác chuyển đến</b>' 
                              when c.LOAIDON =3 then '<br>Loại đơn: <b>Đơn trùng</b>' 
                              when c.LOAIDON =4 then '<br>Loại đơn: <b>Đơn không thuộc thẩm quyền</b>' 
                              when c.LOAIDON =5 then '<br>Loại đơn: <b>Đơn có yêu cầu phản tố</b>' 
                              when c.LOAIDON =6 then '<br>Loại đơn: <b>Đơn có yêu cầu độc lập</b>'
                         end)
                        as duongsu -- lanh lay them duong su
                        , t.noidungkhoikien as NoiDung
                         ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end)|| DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', null, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                        , a.NgayGQ_YC as NgayGQ_YC, a.LyDo
                        , a.CDTN_ToaAnID, b.Ten, a.CDTN_NGAYNHAN
                        , a.CDNN_TenCQ
                        , a.TraDon_CanCuID
                        , a.NgayTao, a.NguoiTao
                        , a.NgaySua, a.NguoiSua,f.TENFILE,a.FILEID, c.LOAIDON
                        , tp.TOA_GIAIQUYET_ID
                      from DON_CHITIET c
                        left join AHC_DON t on c.DONID = t.ID
                        left join AHC_DON_XULY a on c.ID = a.DON_CHITIETID --lanh lay noi dung don
                        left join DM_ToaAn b on a.CDTN_ToaAnID = b.ID
                        left join AHC_FILE f on a.FILEID=f.ID                              
                        left join AHC_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                        left join (select * from (select ct.donchitietid, 'Tên người khởi kiện: ' || d.TENDUONGSU || '<br>Địa chỉ: ' ||decode(d.tamtruchitiet,null,'',d.tamtruchitiet || ',')|| (CASE d.LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) as nguyendon 
                            from AHC_DON_DUONGSU d
                            left join don_duongsu_chitiet ct on d.ID = ct.DUONGSUID and ct.loaian=6
                            left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
                            left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
                            where d.TUCACHTOTUNG_MA='NGUYENDON' and d.DONID = CurrDonID and d.ISDAIDIEN_DONCHITIET = 1
                            order by d.isdaidien DESC)
                          ) nd on nd.donchitietid = c.id
                        left join (SELECT 
                            DonChitietID,
                            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                                FROM (
                                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                                    from DON_DUONGSU_CHITIET a
                                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                                    left join AHC_DON_DUONGSU b on a.DuongSUid = b.id
                                    where a.donid = CurrDonID and c.LOAIANID = 6 and c.LOAIDON IN (5,6)
                                )
                            GROUP BY donchitietid  ) DS on ds.donchitietid =  c.id
                      where c.DONID =CurrDonID AND c.LOAIANID = 6
                      order by NgayTao desc) g
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;	
END AHC_DON_XULY_GETBYDONID;