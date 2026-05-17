--------------------------------------------------------
--  DDL for Package Body PKG_APS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_APS" 
AS
-- Package body
PROCEDURE APS_DON_ANPHI_GETBYDONID_V2 (
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
    from APS_ANPHI a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0)) AND  a.magiaidoan = 2;
		---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll 
			from (	select ROWNUM  stt,a.ID, a.DonID
                , d.tenduongsu || '-' || di.TEN as duongsu
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
                 ,T.MA_THONGBAO,THA.ANPHI_ID,THA.FILE_NAME FILE_NAME_THA
                 ,a.ENABLE
                ,to_char(t.THOIGIANTHANHTOAN,'dd/MM/yyyy HH24:MI:SS')THOIGIANTHANHTOAN
                ,t.HOTENNGUOINOPTIEN
                ,to_char(a.NGAYNOPBIENLAI,'dd/MM/yyyy')NGAYNOPBIENLAI
                ,t.id DVCQG_TT_ID
              from APS_ANPHI a
              LEFT JOIN DON_MIENANPHI m ON a.ID = m.ANPHI_ID AND m.LOAIAN = 7
              left join APS_DON_DUONGSU d on d.ID = a.DUONGSU_ID
              left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID  and t.maloaivuviec = 7
              left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM ADS_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where 
              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and  
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and 
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM APS_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              order by a.NgayTao desc
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END APS_DON_ANPHI_GETBYDONID_V2;

PROCEDURE APS_ANPHI_LICHSU_GETBYDONID (
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
--    from APS_ANPHI_LICHSU a where a.DonID =CurrDonID and ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0)) AND a.A_ANPHI_ID = anPhiId;
		---------------------------------------------------
    OPEN curReturn FOR 
			select a.*
			from (select ROWNUM  stt, cte.* FROM (
		select a.ID,0 as mienanphiId, a.DonID
                , d.tenduongsu || '-' || di.TEN as duongsu
                , decode(a.TINHTRANG, 1, 'Miễn án phí', TO_CHAR(a.tamunganphi,'999,999,999,999,999,999')) as TAMUNGAP
                , a. nguoinop
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
              from APS_ANPHI a
              left join APS_DON_DUONGSU d on d.ID = a.DUONGSU_ID
              left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID  and t.maloaivuviec = 7
              left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM ADS_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where 
              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and  
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and 
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM APS_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              AND a.ID = anPhiId
          UNION ALL
          	select a.ID, m.ID as mienanphiId, a.DonID
                , d.tenduongsu || '-' || di.TEN as duongsu
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
              from APS_ANPHI a
              INNER JOIN DON_MIENANPHI m ON a.ID = m.ANPHI_ID AND m.LOAIAN = 7
              left join APS_DON_DUONGSU d on d.ID = a.DUONGSU_ID
              left join DM_DATAITEM di on di.MA=d.TUCACHTOTUNG_MA
              left join dvcqg_thanh_toan t on t.ANPHI_ID=a.ID  and t.maloaivuviec = 7
              left join tuphap_anphi tp on tp.dvcqg_tt_id=t.id
              left join tuphap_anphi_cn cn on cn.tuphap_anphi_id=tp.id
              left join DVCQG_FILE_BIENLAI bf on bf.TP_THANH_TOAN_ID=t.ID
              LEFT JOIN (SELECT ANPHI_ID,FILE_NAME FROM ADS_FILE_THA WHERE STATUS=1) THA ON THA.ANPHI_ID=A.ID and cn.trang_thai=1
              where 
              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and ( a.sobienlai is not null Or t.trangthaithanhtoan = 1))) and  
               a.magiaidoan = 2 and
--                Tạm dong do chua lay duoc SOBIENLAI
--              ( V_TINHTRANG = 1 OR (V_TINHTRANG = 0 and  a.TINHTRANG = 0 and a.sobienlai is not null)) and 
              (a.DonID =CurrDonID or a.DonID IN (SELECT ID FROM APS_DON WHERE VUANGOCID=CurrDonID AND IS_TACHAN IS NULL)) -- lay cua cac vu an duoc nhap
              AND a.ID = anPhiId
	) cte
	ORDER BY cte.ngaytao DESC
		) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END APS_ANPHI_LICHSU_GETBYDONID;

PROCEDURE APS_DON_DSDUONGSU_GETBY_V2
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
	SELECT 
	    d.NgaySinh, d.NamSinh, d.ID, d.TENDUONGSU, d.NGAYSINH, d.NAMSINH,

	    -- TENLOAIDS: lấy từ DM_DATAITEM nếu là NGUOIYEUCAUPS, lấy từ DM_QHPL_TK nếu là DNHTXBITUYENBOPS
	    CASE 
	        WHEN d.TUCACHTOTUNG_MA = 'NGUOIYEUCAUPS' THEN i1.TEN
	        WHEN d.TUCACHTOTUNG_MA = 'DNHTXBITUYENBOPS' THEN tk.CASE_NAME
	        ELSE NULL
	    END AS TENLOAIDS,

	    DECODE(ISDAIDIEN, 1, 'X ', '') DAIDIEN,

	    CASE 
	        WHEN p.SOBIENLAI IS NOT NULL OR p.tinhtrang = 1 THEN 'X ' 
	        ELSE '' 
	    END AS THULY,

	    DECODE(LOAIDUONGSU, 1, h1.MA_TEN, h2.MA_TEN) AS DIACHIDS,

	    i2.TEN AS TENTCTT,
	    d.NGUOITAO, d.NGAYTAO, d.ISPHUCTHAM,

	    (d.TENDUONGSU || ' - ' || DECODE(LOAIDUONGSU, 1, h1.MA_TEN, h2.MA_TEN) || ' - ' || i2.TEN) AS ARRDUONGSU

	FROM 
	    APS_DON_DUONGSU d

	-- Tên tư cách tố tụng
	LEFT JOIN DM_DATAITEM i2 ON i2.MA = d.TUCACHTOTUNG_MA AND i2.GROUPID = 11

	-- Địa chỉ
	LEFT JOIN DM_HANHCHINH h1 ON h1.ID = d.TAMTRUID
	LEFT JOIN DM_HANHCHINH h2 ON h2.ID = d.NDD_DIACHIID

	-- Án phí
	LEFT JOIN APS_ANPHI p ON p.duongsu_id = d.ID

	-- Join điều kiện LOAIDUONGSU theo từng loại
	LEFT JOIN DM_DATAITEM i1 
	    ON i1.ID = d.LOAIDUONGSU 
	   AND i1.HIEULUC = 1 
	   AND d.TUCACHTOTUNG_MA = 'NGUOIYEUCAUPS' AND i1.GROUPID = 121

	LEFT JOIN DM_DATAGROUP g 
	    ON g.ID = i1.GROUPID 
	   AND g.MA = 'DOITUONGNOPYCPS'

	LEFT JOIN DM_QHPL_TK tk 
	    ON tk.ID = d.LOAIDUONGSU 
	   AND tk.STYLES = 5 
	   AND d.TUCACHTOTUNG_MA = 'DNHTXBITUYENBOPS'

	WHERE 
	    d.ISDON = 1 
	    AND (
	        d.DONID = vDONID 
	        OR d.DONID IN (
	            SELECT ID FROM APS_DON 
	            WHERE VUANGOCID = vDONID AND IS_TACHAN IS NULL
	        )
	    )

	ORDER BY 
	    d.ISDAIDIEN DESC, d.TENDUONGSU;

END APS_DON_DSDUONGSU_GETBY_V2;

 PROCEDURE APS_DON_DUONGSU_BIENLAI_V2
(
  vDONID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) IS 
BEGIN
OPEN curReturn FOR  
      SELECT d.ID, d.TENDUONGSU || ' - ' || i.TEN AS TENDUONGSU 
      FROM APS_ANPHI a      
      INNER JOIN APS_DON_DUONGSU d ON d.ID = a.DUONGSU_ID
       LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = a.ID AND dm.LOAIAN = 7
      left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
      WHERE a.DONID = vDONID AND a.TINHTRANG = 0 AND dm.ID IS NULL;
END APS_DON_DUONGSU_BIENLAI_V2;

END PKG_APS;

/
