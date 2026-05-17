--------------------------------------------------------
--  DDL for Package Body PKG_STPT_BAQD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_BAQD" AS
PROCEDURE ADS_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from ADS_SOTHAM_BANAN where DonID = vDONID;  
    select count(q.ID) into CountQuyetDinhKTST 
    from ADS_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--(d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From ADS_SOTHAM_QUYETDINH q
      left join ADS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1--and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ADS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ADS_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHC_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from AHC_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from AHC_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From AHC_SOTHAM_QUYETDINH q
      left join AHC_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1-- and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3  or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHC_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHC_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHN_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from AHN_SOTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from AHN_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From AHN_SOTHAM_QUYETDINH q
      left join AHN_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1-- and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3  or q.quyetdinhid = 422 or q.quyetdinhid = 423 or d.loaiid = 23 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHN_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHN_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHS_ST_BAQD_VUAN_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS  
  CountBanAnST int;
  CountQuyetDinhKTST int;
BEGIN    
    select count(ID) into CountBanAnST from AHS_SOTHAM_BANAN where VuAnID = vVuAnID;
    select count(q.ID) into CountQuyetDinhKTST 
    from AHS_SOTHAM_QUYETDINH_VUAN  q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.VuAnID = vVuAnID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
          ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
            else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
          ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
          , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST, Case q.HINHTHUCXETXU when  1 then 'Xử kín trực tuyến' when 2 then 'Xử kín trực tiếp' when 3 then 'Xử công khai trực tuyến' when 4 then 'Xử công khai trực tiếp' when 0 then '' end as HINHTHUCXETXU
      From AHS_SOTHAM_QUYETDINH_VUAN q
      left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and q.quyetdinhid != 204 and q.quyetdinhid != 205 and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or d.loaiid = 15 or d.loaiid = 10)
      left join AHS_FILE f on q.FILEID = f.ID
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.DONVIID
      left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
      left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
      left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
      left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
      Where q.VUANID=vVuAnID
      ORder by q.NGAYQD;
END AHS_ST_BAQD_VUAN_GETLIST;

PROCEDURE AKT_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from AHC_SOTHAM_BANAN where DonID = vDONID;  
    select count(q.ID) into CountQuyetDinhKTST 
    from AKT_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From AKT_SOTHAM_QUYETDINH q
      left join AKT_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1-- and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AKT_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AKT_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE ALD_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from ALD_SOTHAM_BANAN where DonID = vDONID;    
    select count(q.ID) into CountQuyetDinhKTST 
    from ALD_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From ALD_SOTHAM_QUYETDINH q
      left join ALD_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1-- and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3  or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ALD_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ALD_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE APS_SOTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnST from APS_SOTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from APS_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
      From APS_SOTHAM_QUYETDINH q
      left join APS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ISSOTHAM = 1 and d.KET_THUC = 1-- and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 10 or d.loaiid = 3  or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END APS_SOTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE        ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
BEGIN

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        ADS_SOTHAM_KHANGCAO    KC
        LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        ADS_SOTHAM_KHANGNGHI   KN
        LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
    select count(ID) into CountBanAnST from ADS_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from ADS_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
          ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
      From ADS_SOTHAM_QUYETDINH q
      left join ADS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0--and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ADS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE        AHC_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
--toancau
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
--toancau
BEGIN
  BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        AHC_SOTHAM_KHANGCAO    KC
        LEFT JOIN AHC_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        AHC_SOTHAM_KHANGNGHI   KN
        LEFT JOIN AHC_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
    select count(ID) into CountBanAnST from AHC_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from AHC_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
          ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
           --toancau
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
        --toancau
      From AHC_SOTHAM_QUYETDINH q
      left join AHC_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0--and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHC_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHC_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE        AHN_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
BEGIN
  BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        AHN_SOTHAM_KHANGCAO    KC
        LEFT JOIN AHN_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        AHN_SOTHAM_KHANGNGHI   KN
        LEFT JOIN AHN_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
    select count(ID) into CountBanAnST from AHN_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from AHN_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
          ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
      From AHN_SOTHAM_QUYETDINH q
      left join AHN_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0--and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHN_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHN_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE        AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
  CountBanAnST int;
  CountQuyetDinhKTST int;
  CountQuyetDinhTL int;
  ngayQDTL date;
  CountThuLy int;
  ngayTL2 date;
BEGIN    
    select count(ID) into CountBanAnST from AHS_SOTHAM_BANAN where VuAnID = vVuAnID;
    
    select count(q.ID) into CountQuyetDinhKTST 
    from AHS_SOTHAM_QUYETDINH_VUAN  q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.VuAnID = vVuAnID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15) AND q.QUYETDINHID != 221 AND q.QUYETDINHID != 222;
    
    select count(q.ID) into CountQuyetDinhTL 
    from AHS_SOTHAM_QUYETDINH_VUAN  q
    where q.VuAnID = vVuAnID AND (q.QUYETDINHID = 221 OR q.QUYETDINHID = 222);
    
    if (CountQuyetDinhTL > 0) then select q.NGAYTAO into ngayQDTL
    from AHS_SOTHAM_QUYETDINH_VUAN  q
    where q.VuAnID = vVuAnID AND (q.QUYETDINHID = 221 OR q.QUYETDINHID = 222) AND ROWNUM=1; end if;
    
    Select count(ID) into CountThuLy from AHS_SOTHAM_THULY where VuAnID = vVuAnID and NGAYTAO > ngayQDTL;
    
    if (CountQuyetDinhTL > 0) then select q.NGAYTHULY into ngayTL2
    from AHS_SOTHAM_THULY q where q.VuAnID = vVuAnID AND ROWNUM=1 ORDER BY q.NGAYTAO desc ; end if;
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,f.TENFILE,q.FILEID,q.QUYETDINHID
          ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
            else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
          ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
          --,DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
          , case when CountBanAnST > 0 then 1
                 when CountQuyetDinhKTST > 0 then 1
                 when CountQuyetDinhTL > 0 and CountThuLy=1 and q.NGAYQD < ngayQDTL then 1
                 when CountQuyetDinhTL > 0 and CountThuLy>=2 and ngayTL2 > q.NGAYQD then 1
                 else 0 end as IsBanAnST
          , Case q.HINHTHUCXETXU when  1 then 'Xử kín trực tuyến' when 2 then 'Xử kín trực tiếp' when 3 then 'Xử công khai trực tuyến' when 4 then 'Xử công khai trực tiếp' when 0 then '' end as HINHTHUCXETXU
      From AHS_SOTHAM_QUYETDINH_VUAN q
      left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and d.loaiid != 15))
      left join AHS_FILE f on f.ID=q.FILEID
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.DONVIID
      left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
      left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
      left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
      left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
      Where q.VUANID=vVuAnID
      ORder by q.NGAYQD;
END AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST;

PROCEDURE        AKT_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
CountQuyetDinhKTST int;
--toancau
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
--toancau
BEGIN
--toancau

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        AKT_SOTHAM_KHANGCAO    KC
        LEFT JOIN AKT_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        AKT_SOTHAM_KHANGNGHI   KN
        LEFT JOIN AKT_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
  
--toancau
    select count(ID) into CountBanAnST from AKT_SOTHAM_BANAN where DonID = vDONID;  
    select count(q.ID) into CountQuyetDinhKTST 
    from AKT_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
      ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
       ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN, DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST,q.FILEID,f.TENFILE
       --TOANCAU
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
		--TOANCAU
  From AKT_SOTHAM_QUYETDINH q 
  left join AKT_FILE f on f.ID = q.FILEID
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0-- and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3  and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
    left join DM_TOAAN t on t.ID=q.TOAANID
  Where q.DONID=vDONID or q.DonID in (Select id from AKT_DON where vuangocid = vDonid)
  ORder by q.NGAYQD;
END AKT_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE        ALD_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)

IS 
CountBanAnST int;
CountQuyetDinhKTST int;
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
BEGIN

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        ALD_SOTHAM_KHANGCAO    KC
        LEFT JOIN ALD_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        ALD_SOTHAM_KHANGNGHI   KN
        LEFT JOIN ALD_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
    select count(ID) into CountBanAnST from ALD_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from ALD_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
          ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
      From ALD_SOTHAM_QUYETDINH q
      left join ALD_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0--and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ALD_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ALD_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE        APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)

IS 
CountBanAnST int;
CountQuyetDinhKTST int;
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;
BEGIN

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyet
    FROM
        APS_SOTHAM_KHANGCAO    KC
        LEFT JOIN APS_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
                                             AND KC.LOAIKHANGCAO IN (
            1,
            2
        )
    WHERE
        KC.TINHTRANG_GIAIQUYET = 1
        AND KC.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyet := 0;
END;

BEGIN
    SELECT
        QD.ID
    INTO idCuoiDaGiaiQuyetKN
    FROM
        APS_SOTHAM_KHANGNGHI   KN
        LEFT JOIN APS_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
                                             AND KN.LOAIKN IN (
            1,
            2
        )
    WHERE
        KN.TINHTRANG_GIAIQUYET = 1
        AND KN.DONID = VDONID
    ORDER BY
        QD.ID DESC
    FETCH FIRST 1 ROW ONLY;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        idCuoiDaGiaiQuyetKN := 0;
END;
    select count(ID) into CountBanAnST from APS_SOTHAM_BANAN where DonID = vDONID;   
    select count(q.ID) into CountQuyetDinhKTST 
    from APS_SOTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;--AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
          ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST
           ,(case when (idCuoiDaGiaiQuyet>0 and q.id <= idCuoiDaGiaiQuyet)
           or (idCuoiDaGiaiQuyetKN>0 and q.id <= idCuoiDaGiaiQuyetKN) then 1 
        else 0 end)as READONLY
      From APS_SOTHAM_QUYETDINH q
      left join APS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0--and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

--PROCEDURE        APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST 
--( vDONID in number,
--	curReturn    OUT       sys_refcursor
--)
--IS 
--CountBanAnST int;
--CountQuyetDinhKTST int;
--BEGIN
--    select count(ID) into CountBanAnST from APS_SOTHAM_BANAN where DonID = vDONID;
--    select count(q.ID) into CountQuyetDinhKTST 
--    from APS_SOTHAM_QUYETDINH q
--    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
--    where q.DONID = vDONID AND d.ISSOTHAM = 1 and d.KET_THUC = 1;-- AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 70 or q.quyetdinhid = 425);
--OPEN curReturn FOR  
--  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
--          ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
--      ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
--       ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN, DECODE(CountBanAnST,0,CountQuyetDinhKTST,CountBanAnST) IsBanAnST,q.FILEID,f.TENFILE
--  From APS_SOTHAM_QUYETDINH q 
--  left join APS_FILE f on f.ID = q.FILEID
--  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
--  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ISSOTHAM = 1 and d.KET_THUC = 0-- and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3  and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 70 and q.quyetdinhid != 425))
--  left join DM_CANBO c on c.ID=q.NGUOIKYID
--    left join DM_TOAAN t on t.ID=q.TOAANID
--  Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
--  ORder by q.NGAYQD;
--END APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST;

PROCEDURE ADS_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from ADS_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From ADS_PHUCTHAM_QUYETDINH q
      left join ADS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212 or q.quyetdinhid = 213)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ADS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ADS_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHC_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from AHC_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From AHC_PHUCTHAM_QUYETDINH q
      left join AHC_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 101 or q.quyetdinhid = 110 or q.quyetdinhid = 293)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHC_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHC_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHN_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from AHN_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From AHN_PHUCTHAM_QUYETDINH q
      left join AHN_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212 or q.quyetdinhid = 213)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AHN_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AHN_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AKT_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from AKT_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From AKT_PHUCTHAM_QUYETDINH q
      left join AKT_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212 or q.quyetdinhid = 213)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from AKT_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END AKT_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE ALD_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from ALD_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From ALD_PHUCTHAM_QUYETDINH q
      left join ALD_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212 or q.quyetdinhid = 213)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from ALD_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END ALD_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE APS_PHUCTHAM_BANANQUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnST int;
BEGIN
    select count(ID) into CountBanAnST from APS_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
          ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
           ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
           , CountBanAnST IsBanAnST
      From APS_PHUCTHAM_QUYETDINH q
      left join APS_FILE f on q.FILEID=f.ID
      left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or D.TEN LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'  or d.loaiid = 10 or d.loaiid = 3  or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212 or q.quyetdinhid = 213)
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.TOAANID
      Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
      ORder by q.NGAYQD;
END APS_PHUCTHAM_BANANQUYETDINH_GETLIST;

PROCEDURE AHS_PT_BAQD_VUAN_GETLIST 
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
  CountBanAnST int;
BEGIN    
    select count(ID) into CountBanAnST from AHS_PHUCTHAM_BANAN where VuAnID = vVuAnID;

    --------------------------
    OPEN curReturn FOR  
      Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
          ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
            else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
          ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
          , CountBanAnST IsBanAnST
      From AHS_PHUCTHAM_QUYETDINH_VUAN q
      left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3  or d.loaiid = 10 or d.loaiid = 15 or q.quyetdinhid = 324)
      left join AHS_FILE f on q.FILEID = f.ID
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      left join DM_TOAAN t on t.ID=q.DONVIID
      left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
      left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
      left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
      left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
      Where q.VUANID=vVuAnID
      ORder by q.NGAYQD;
END AHS_PT_BAQD_VUAN_GETLIST;

--PROCEDURE AHS_PT_BAQD_VUAN_GETLIST 
--( vVuAnID in number,
--	curReturn OUT sys_refcursor
--)
--IS 
--  CountBanAnST int;
--BEGIN    
--    select count(ID) into CountBanAnST from AHS_PHUCTHAM_BANAN where VuAnID = vVuAnID;
--
--    --------------------------
--    OPEN curReturn FOR  
--      Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
--          ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
--            else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
--          ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
--          , CountBanAnST IsBanAnST
--      From AHS_PHUCTHAM_QUYETDINH_VUAN q
--      left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
--      inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3  or d.loaiid = 10 or d.loaiid = 15 or q.quyetdinhid = 324)
--      left join AHS_FILE f on q.FILEID = f.ID
--      left join DM_CANBO c on c.ID=q.NGUOIKYID
--      left join DM_TOAAN t on t.ID=q.DONVIID
--      left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
--      left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
--      left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
--      left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
--      Where q.VUANID=vVuAnID
--      ORder by q.NGAYQD;
--END AHS_PT_BAQD_VUAN_GETLIST;

PROCEDURE        AHS_PT_QD_VUAN_GETLIST 
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from AHS_PHUCTHAM_BANAN where VUANID = vVuAnID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from AHS_PHUCTHAM_QUYETDINH_VUAN q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.VUANID = vVuAnID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15);
  OPEN curReturn FOR  
    Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU
        ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
            else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,
        q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,q.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
    From AHS_PHUCTHAM_QUYETDINH_VUAN q
    left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and d.loaiid != 15))
    left join DM_CANBO c on c.ID=q.NGUOIKYID
    left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
    left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
    left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
    left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
  Where q.VUANID=vVuAnID
  ORder by q.NGAYQD;
END AHS_PT_QD_VUAN_GETLIST;

PROCEDURE        ADS_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from ADS_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from ADS_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From ADS_PHUCTHAM_QUYETDINH q
  left join ADS_FILE f on f.ID = q.FILEID 
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 212))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END ADS_PHUCTHAM_QUYETDINH_GETLIST;

PROCEDURE        AHC_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from AHC_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from AHC_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 101 or q.quyetdinhid = 110);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From AHC_PHUCTHAM_QUYETDINH q 
  left join AHC_FILE f on f.ID = q.FILEID
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 101 and q.quyetdinhid != 110))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END AHC_PHUCTHAM_QUYETDINH_GETLIST;

PROCEDURE        AHN_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from AHN_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from AHN_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or d.loaiid = 23 or q.quyetdinhid = 212);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From AHN_PHUCTHAM_QUYETDINH q 
    left join AHN_FILE f on f.ID = q.FILEID 
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and d.loaiid != 23 and q.quyetdinhid != 212))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END AHN_PHUCTHAM_QUYETDINH_GETLIST;

PROCEDURE        AKT_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from AKT_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from AKT_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From AKT_PHUCTHAM_QUYETDINH q 
  left join AKT_FILE f on f.ID = q.FILEID 
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3 and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 212))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END AKT_PHUCTHAM_QUYETDINH_GETLIST;

PROCEDURE        ALD_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from ALD_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from ALD_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From ALD_PHUCTHAM_QUYETDINH q 
  left join ALD_FILE f on f.ID = q.FILEID 
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3  and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 212))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END ALD_PHUCTHAM_QUYETDINH_GETLIST;

PROCEDURE        APS_PHUCTHAM_QUYETDINH_GETLIST 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
CountBanAnPT int;
CountQuyetDinhKTST int;
BEGIN
    select count(ID) into CountBanAnPT from APS_PHUCTHAM_BANAN where DonID = vDONID; 
    select count(q.ID) into CountQuyetDinhKTST 
    from APS_PHUCTHAM_QUYETDINH q
    inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
    where q.DONID = vDONID AND (d.loaiid = 10 or d.loaiid = 3 or d.loaiid = 15 or q.quyetdinhid = 422 or q.quyetdinhid = 423 or q.quyetdinhid = 212);
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
      ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, DECODE(CountBanAnPT,0,CountQuyetDinhKTST,CountBanAnPT) IsBanAnST
  From APS_PHUCTHAM_QUYETDINH q 
  left join APS_FILE f on f.ID = q.FILEID
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten NOT LIKE ('%Quyết định đình chỉ%') and (d.loaiid != 10 and d.loaiid != 3  and q.quyetdinhid != 422 and q.quyetdinhid != 423 and q.quyetdinhid != 212))
  left join DM_CANBO c on c.ID=q.NGUOIKYID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END APS_PHUCTHAM_QUYETDINH_GETLIST;
END PKG_STPT_BAQD;
