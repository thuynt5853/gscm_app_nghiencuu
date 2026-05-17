create or replace PACKAGE BODY PKG_AHC
AS
-- Package body
PROCEDURE AHC_DON_ANPHI_GETBYDONID_V2
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
         --and a.magiaidoan = 2
    from AHC_ANPHI a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0));
		---------------------------------------------------
    OPEN curReturn FOR
			select a.*, TotalItem as CountAll
			from (	select ROWNUM  stt,a.ID, a.DonID
                , (SELECT LISTAGG(d.TENDUONGSU || '-' || di.TEN, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                    FROM AHC_DON_DUONGSU d left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA WHERE (d.DONID = CurrDonID OR d.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID)) AND a.DUONGSU_IDS like '%' || d.id ||'%' ) as duongsu
                , CASE WHEN m.ID IS NOT NULL THEN 'Miễn án phí'
	                  ELSE decode(a.TINHTRANG, 1, 'Miễn án phí', TO_CHAR(a.tamunganphi,'999,999,999,999,999,999'))
	              END  as TAMUNGAP
                , CASE WHEN m.ID IS NOT NULL THEN null
                	ELSE a.nguoinop
                	END AS nguoinop
                , CASE WHEN m.ID IS NOT NULL THEN null
                	ELSE a.ngaynopanphi
                	END AS ngaynopanphi
                , CASE WHEN m.ID IS NOT NULL THEN NULL
                	ELSE a.sobienlai
                	END AS sobienlai
                ,  CASE WHEN m.ID IS NOT NULL THEN m.sothongbao
                	ELSE  a.sothongbao
                	END AS sothongbao
                , CASE WHEN m.ID IS NOT NULL THEN m.ngaythongbao
                	ELSE  a.ngaythongbao
                	END AS ngaythongbao
                , a.hannop_songay As hannop
                , CASE WHEN m.ID IS NOT NULL THEN m.ngaytao
                	ELSE  a.ngaytao
                	END AS ngaytao
                , CASE WHEN m.ID IS NOT NULL THEN m.nguoitao
                	ELSE  a.nguoitao
                	END AS nguoitao
                , bf.FILE_NAME as TENFILE,bf.ID as FILEID
                 ,NVL(t.MA_THONGBAO, a.MATHONGBAO_OLD) AS MA_THONGBAO -- VNPT Lê Bá Thọ 02/12/2025 check lấy mã thông báo
                 ,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                 ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
                ,a.TOA_GIAIQUYET_ID
              from AHC_ANPHI a
              LEFT JOIN DON_MIENANPHI m ON a.ID = m.ANPHI_ID AND m.LOAIAN = 6
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID and t.maloaivuviec = 6
               left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM AHC_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where
                 ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1)))  and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              order by a.NgayTao desc
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END AHC_DON_ANPHI_GETBYDONID_V2;

--08/12/2025 vnpt le ba tho sua de luu an phi KCKN
PROCEDURE AHC_DON_ANPHI_GETBYDONID_KCKN
(
   CurrDonID in int,
   V_TINHTRANG in int,
	 PageIndex	in	int,
     P_GIAIDOAN in int, --08/12/2025 vnpt le ba tho sua de luu an phi KCKN
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
         --and a.magiaidoan = 2
      --08/12/2025 vnpt le ba tho sua de luu an phi KCKN
    from AHC_ANPHI a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0)) AND a.magiaidoan = P_GIAIDOAN;
		---------------------------------------------------
    OPEN curReturn FOR
			select a.*, TotalItem as CountAll
			from (	select ROWNUM  stt,a.ID, a.DonID
                , (SELECT LISTAGG(d.TENDUONGSU || '-' || di.TEN, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                    FROM AHC_DON_DUONGSU d left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA WHERE (d.DONID = CurrDonID OR d.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID)) AND a.DUONGSU_IDS like '%' || d.id ||'%' ) as duongsu
                , CASE WHEN m.ID IS NOT NULL THEN 'Miễn án phí'
	                  ELSE decode(a.TINHTRANG, 1, 'Miễn án phí', TO_CHAR(a.tamunganphi,'999,999,999,999,999,999'))
	              END  as TAMUNGAP
                , CASE WHEN m.ID IS NOT NULL THEN null
                	ELSE a.nguoinop
                	END AS nguoinop
                , CASE WHEN m.ID IS NOT NULL THEN null
                	ELSE a.ngaynopanphi
                	END AS ngaynopanphi
                , CASE WHEN m.ID IS NOT NULL THEN NULL
                	ELSE a.sobienlai
                	END AS sobienlai
                ,  CASE WHEN m.ID IS NOT NULL THEN m.sothongbao
                	ELSE  a.sothongbao
                	END AS sothongbao
                , CASE WHEN m.ID IS NOT NULL THEN m.ngaythongbao
                	ELSE  a.ngaythongbao
                	END AS ngaythongbao
                , a.hannop_songay As hannop
                , CASE WHEN m.ID IS NOT NULL THEN m.ngaytao
                	ELSE  a.ngaytao
                	END AS ngaytao
                , CASE WHEN m.ID IS NOT NULL THEN m.nguoitao
                	ELSE  a.nguoitao
                	END AS nguoitao
                , bf.FILE_NAME as TENFILE,bf.ID as FILEID
                 ,NVL(t.MA_THONGBAO, a.MATHONGBAO_OLD) AS MA_THONGBAO -- VNPT Lê Bá Thọ 02/12/2025 check lấy mã thông báo
                 ,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                 ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
                ,a.TOA_GIAIQUYET_ID
              from AHC_ANPHI a
              LEFT JOIN DON_MIENANPHI m ON a.ID = m.ANPHI_ID AND m.LOAIAN = 6
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID and t.maloaivuviec = 6
               left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM AHC_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where
                 ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) 
                 --08/12/2025 vnpt le ba tho sua de luu an phi KCKN
                 and a.magiaidoan = P_GIAIDOAN and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              order by a.NgayTao desc
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END AHC_DON_ANPHI_GETBYDONID_KCKN;


PROCEDURE AHC_DON_ANPHI_LICHSU_GETBYDONID
(
   CurrDonID in int,
   anPhiId IN int,
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
--	  select count (a.ID) into TotalItem
--    from AHC_ANPHI_LICHSU a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0)) AND a.A_ANPHI_ID = anPhiId;
		---------------------------------------------------
    OPEN curReturn FOR
			select a.*
			from (	select ROWNUM  stt, cte.* FROM (
			SELECT a.ID, 0 AS mienanphiId, a.DonID
                , (SELECT LISTAGG(d.TENDUONGSU || '-' || di.TEN, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                    FROM AHC_DON_DUONGSU d left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA WHERE (d.DONID = CurrDonID OR d.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID)) AND a.DUONGSU_IDS like '%' || d.id ||'%' ) as duongsu
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
                 ,T.MA_THONGBAO,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                 ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
              from AHC_ANPHI a
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID and t.maloaivuviec = 6
               left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM AHC_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=a.ID and cn.trang_thai=1
              where
                 ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              AND a.ID = anPhiId
            UNION ALL
             	select a.ID, m.id as mienanphiId, a.DonID
                , (SELECT LISTAGG(d.TENDUONGSU || '-' || di.TEN, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP"
                    FROM AHC_DON_DUONGSU d left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA WHERE (d.DONID = CurrDonID OR d.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID)) AND a.DUONGSU_IDS like '%' || d.id ||'%' ) as duongsu
                , 'Miễn án phí' as TAMUNGAP
                , null AS nguoinop
                , null AS ngaynopanphi
                , null AS sobienlai
                , m.sothongbao
                , m.ngaythongbao
                , a.hannop_songay As hannop
                , m.ngaytao
                , m.nguoitao
                , bf.FILE_NAME as TENFILE,bf.ID as FILEID
                 ,T.MA_THONGBAO,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                 ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
              from AHC_ANPHI a
              INNER JOIN DON_MIENANPHI m ON a.ID = m.ANPHI_ID AND m.LOAIAN = 6
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID and t.maloaivuviec = 6
               left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM AHC_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=a.ID and cn.trang_thai=1
              where
                 ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              AND a.ID = anPhiId
              ) cte
              ORDER BY cte.ngaytao DESC
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END AHC_DON_ANPHI_LICHSU_GETBYDONID;


END PKG_AHC;