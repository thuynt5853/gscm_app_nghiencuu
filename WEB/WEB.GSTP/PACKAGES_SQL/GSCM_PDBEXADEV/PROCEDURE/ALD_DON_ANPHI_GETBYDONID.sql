create or replace PROCEDURE      ALD_DON_ANPHI_GETBYDONID
(
   CurrDonID in int,   
   V_TINHTRANG in int,   
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
    from ALD_ANPHI a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0));
		---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll 
			from (	select ROWNUM  stt,a.ID, a.DonID
               , (SELECT LISTAGG(d.TENDUONGSU || '-' || di.TEN, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                    FROM ALD_DON_DUONGSU d left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA WHERE (d.DONID = CurrDonID OR d.DonID IN (SELECT ID FROM ALD_DON WHERE VUANGOCID=CurrDonID)) AND a.DUONGSU_IDS like '%' || d.id ||'%' ) as duongsu
                , decode(a.TINHTRANG, 1, 'Miễn án phí', TO_CHAR(a.tamunganphi,'999,999,999,999,999,999')) as TAMUNGAP
                , a.nguoinop
                , a.ngaynopanphi
                , a.sobienlai
                , a.sothongbao
                , a.ngaythongbao
                , a.hannop_songay As hannop
                , a.ngaytao
                , a.nguoitao
                , bf.FILE_NAME as TENFILE,bf.ID as FILEID
                ,NVL(t.MA_THONGBAO, a.MATHONGBAO_OLD) AS MA_THONGBAO -- VNPT Lê Bá Thọ 02/12/2025 check lấy mã thông báo
                ,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
                ,a.TOA_GIAIQUYET_ID
              from ALD_ANPHI a
              left join ALD_DON_DUONGSU d on d.ID = a.DUONGSU_ID
              left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID and t.maloaivuviec = 5
               left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM ALD_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where 
              
               ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and 
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and 
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM ALD_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              order by a.NgayTao desc
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END ALD_DON_ANPHI_GETBYDONID;