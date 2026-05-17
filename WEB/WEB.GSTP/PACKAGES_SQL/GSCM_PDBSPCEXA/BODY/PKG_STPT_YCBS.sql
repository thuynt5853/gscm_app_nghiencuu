--------------------------------------------------------
--  DDL for Package Body PKG_STPT_YCBS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_YCBS" AS

  PROCEDURE ADS_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 2 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join ADS_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join ADS_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=2 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a 
                    ORDER BY a.ID DESC;
    END ADS_DON_YCBS_GETBYDONID;

PROCEDURE AHC_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 6 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join AHC_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join AHC_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=6 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a
                    ORDER BY a.ID DESC;
    END AHC_DON_YCBS_GETBYDONID;

PROCEDURE AHN_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 3 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join AHN_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join AHN_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=3 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a 
                    ORDER BY a.NGAYTAO DESC;
    END AHN_DON_YCBS_GETBYDONID;

PROCEDURE AKT_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 4 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join AKT_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join AKT_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=4 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a 
                    ORDER BY a.NGAYTAO DESC;
    END AKT_DON_YCBS_GETBYDONID;

PROCEDURE ALD_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 5 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join ALD_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join ALD_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=5 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a
                    ORDER BY a.NGAYTAO DESC;
    END ALD_DON_YCBS_GETBYDONID;

PROCEDURE APS_DON_YCBS_GETBYDONID
(
  CurrDonID in number,
  DonYCBS_ID in number,
  PageIndex in	int,
  PageSize	in int,
  curReturn OUT sys_refcursor
) AS
    TotalItem number;
    MinIndex number;
    MaxIndex number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total     
    select count (a.ID) into TotalItem
    from DON_YEUCAUBOSUNG a where a.LOAIAN = 7 and a.DON_XULYID = DonYCBS_ID;
	---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll
			from (select ROWNUM  stt,g.*
                    from (select a.*
                        , t.noidungkhoikien as NoiDung
                        ,(case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                              when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                              when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i \0111\01a1n' 
                              when a.LoaiGiaiQuyet =4 then u'Y\00eau c\1ea7u b\1ed5 sung \0111\01a1n' 
                              when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd v\1ee5 vi\1ec7c' 
                              when a.LoaiGiaiQuyet =6 then u'Đơn trùng'
                         end) || DECODE(a.LoaiGiaiQuyet, 5, '', 6, '', '<br>Ngày thông báo: ' || TO_CHAR(a.NGAYTHONGBAO,'dd/MM/yyyy')) || DECODE(a.SOTHONGBAO, null, '','<br>Số thông báo: ' || a.SOTHONGBAO || a.STB_PHU) as BienPhapGQ
                        , c1.HOTEN as NguoiGQ
                      from DON_YEUCAUBOSUNG a
                        left join APS_DON t on t.ID = a.DONID OR t.ID = a.DON_XULYID
                        left join APS_DON_THAMPHAN tp on tp.DONID = t.ID and tp.MAVAITRO = 'VTTP_GIAIQUYETDON' -- lanh lay thong tin tham phan giai quyet
                        left join DM_CANBO c1 on c1.ID=tp.CANBOID
                      where a.DON_XULY_YCBS_ID=DonYCBS_ID AND a.LOAIAN=7 -- lay cua cac vu an duoc nhap
                      ) g
				    ) a
                    ORDER BY a.NGAYTAO DESC;
    END APS_DON_YCBS_GETBYDONID;

  PROCEDURE INSERT_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0,
  vDONID in number,
  vLOAIAN in number,
  vDON_XULYID in number,
  vLOAIGIAIQUYET in number,
  vNGAYGQ_YC in date,
  vLYDO in varchar2,
  vCDTN_TOAANID in number,
  vCDTN_NGAYNHAN in date,
  vCDNN_TENCQ in varchar2,
  vTRADON_CANCUID in number,
  vNGAYTAO in date,
  vNGUOITAO in varchar2,
  vNGAYSUA in date,
  vNGUOISUA in varchar2,
  vCDNN_NGAYCHUYEN in date,
  vTRADON_LYDOID in number,
  vTRADON_NGAYTRA in date,
  vYCBS_NGAYYEUCAU in date,
  vYCBS_NOIDUNG in varchar2,
  vCDTN_NGAYCHUYEN in date,
  vSOTHONGBAO in varchar2,
  vFILEID in number,
  vYCBS_THOIHAN in number,
  vTOAANID in number,
  vNGAYTHONGBAO in date,
  vDON_CHITIETID in number,
  vSOHIEU in varchar2,
  vNGAYBOSUNG in date,
  vDON_XULY_YCBS_ID in number,
  vSTB_PHU in varchar2,
  curReturn OUT sys_refcursor
) AS
  BEGIN
    if(vID > 0) then
        UPDATE DON_YEUCAUBOSUNG
            SET 
                DONID=vDONID,
                LOAIAN=vLOAIAN,
                DON_XULYID=vDON_XULYID,
                LOAIGIAIQUYET=vLOAIGIAIQUYET,
                NGAYGQ_YC=vNGAYGQ_YC,
                LYDO=vLYDO,
                CDTN_TOAANID=vCDTN_TOAANID,
                CDTN_NGAYNHAN=vCDTN_NGAYNHAN,
                CDNN_TENCQ=vCDNN_TENCQ,
                TRADON_CANCUID=vTRADON_CANCUID,
                NGAYSUA=vNGAYSUA,
                NGUOISUA=vNGUOISUA,
                CDNN_NGAYCHUYEN=vCDNN_NGAYCHUYEN,
                TRADON_LYDOID=vTRADON_LYDOID,
                TRADON_NGAYTRA=vTRADON_NGAYTRA,
                YCBS_NGAYYEUCAU=vYCBS_NGAYYEUCAU,
                YCBS_NOIDUNG=vYCBS_NOIDUNG,
                CDTN_NGAYCHUYEN=vCDTN_NGAYCHUYEN,
                SOTHONGBAO=vSOTHONGBAO,
                FILEID=vFILEID,
                YCBS_THOIHAN=vYCBS_THOIHAN,
                TOAANID=vTOAANID,
                NGAYTHONGBAO=vNGAYTHONGBAO,
                DON_CHITIETID=vDON_CHITIETID,
                SOHIEU=vSOHIEU,
                NGAYBOSUNG=vNGAYBOSUNG,
                DON_XULY_YCBS_ID=vDON_XULY_YCBS_ID,
                STB_PHU=vSTB_PHU
            WHERE ID = vID; 
    else
        INSERT INTO DON_YEUCAUBOSUNG(DONID,LOAIAN,DON_XULYID,LOAIGIAIQUYET,NGAYGQ_YC,LYDO,CDTN_TOAANID,CDTN_NGAYNHAN
        ,CDNN_TENCQ,TRADON_CANCUID,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,CDNN_NGAYCHUYEN,TRADON_LYDOID,TRADON_NGAYTRA,
        YCBS_NGAYYEUCAU,YCBS_NOIDUNG,CDTN_NGAYCHUYEN,SOTHONGBAO,FILEID,YCBS_THOIHAN,TOAANID,NGAYTHONGBAO,DON_CHITIETID,
        SOHIEU,NGAYBOSUNG,DON_XULY_YCBS_ID,STB_PHU)
        VALUES(vDONID,vLOAIAN,vDON_XULYID,vLOAIGIAIQUYET,vNGAYGQ_YC,vLYDO,vCDTN_TOAANID,vCDTN_NGAYNHAN,vCDNN_TENCQ,
        vTRADON_CANCUID,vNGAYTAO,vNGUOITAO,vNGAYSUA,vNGUOISUA,vCDNN_NGAYCHUYEN,vTRADON_LYDOID,vTRADON_NGAYTRA,
        vYCBS_NGAYYEUCAU,vYCBS_NOIDUNG,vCDTN_NGAYCHUYEN,vSOTHONGBAO,vFILEID,vYCBS_THOIHAN,vTOAANID,vNGAYTHONGBAO,
        vDON_CHITIETID,vSOHIEU,vNGAYBOSUNG,vDON_XULY_YCBS_ID,vSTB_PHU);
    end if;
  END INSERT_DON_YCBS_GETBYDONID;

  PROCEDURE DEL_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0
) AS
  BEGIN
    if (vID >0) then
        DELETE DON_YEUCAUBOSUNG where ID = vID ; 
    end if;
  END DEL_DON_YCBS_GETBYDONID;

  PROCEDURE GET_DON_YCBS_GETBYDONID
(
  vID in number DEFAULT 0,
  curReturn OUT sys_refcursor
) AS
  BEGIN
    OPEN curReturn FOR
        SELECT d.*
        FROM DON_YEUCAUBOSUNG d
        WHERE d.ID = vID;
  END GET_DON_YCBS_GETBYDONID;

  PROCEDURE CHECK_LOAIGIAIQUYET_DON_YCBS 
(
  DonYCBS_ID in number,
  vLoaiAn in number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
  OPEN curReturn FOR
    SELECT * FROM DON_YEUCAUBOSUNG
    WHERE DON_XULY_YCBS_ID = DonYCBS_ID
    AND LOAIGIAIQUYET != 4
    AND LOAIAN = vLoaiAn;
  END CHECK_LOAIGIAIQUYET_DON_YCBS;

PROCEDURE CHECK_THULY_DON_YCBS
(
  vDONID in number,
  vLOAIAN in number,
  curReturn OUT sys_refcursor
)AS
  BEGIN
  OPEN curReturn FOR
    SELECT * FROM DON_YEUCAUBOSUNG
    WHERE DONID = vDONID
    AND LOAIGIAIQUYET = 5
    AND LOAIAN = vLOAIAN;
END CHECK_THULY_DON_YCBS;

PROCEDURE CHECK_NGAYGQ_DON_YCBS
(
  vID in number,
  vDonYCBS_ID in number,
  vNGAYGQ in varchar2,
  vLOAIAN in number,
  curReturn OUT sys_refcursor
)IS V_NGAYGQTU date; V_NGAYGQDEN date; v_NGAYTAO date;
BEGIN if(vNGAYGQ IS NOT NULL) then  V_NGAYGQTU:=to_date(trim(vNGAYGQ)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
      if(vNGAYGQ IS NOT NULL) then  V_NGAYGQDEN:=to_date(trim(vNGAYGQ)||' 00:00:00','dd/MM/yyyy HH24:MI:SS'); end if;
OPEN curReturn FOR  
    SELECT y.* FROM DON_YEUCAUBOSUNG y
    WHERE y.DON_XULY_YCBS_ID = vDonYCBS_ID AND y.LOAIAN = vLOAIAN AND ( vID = 0 OR y.ID <> vID) 
    AND (((vID = 0 OR y.ID < vID) AND y.NGAYGQ_YC > V_NGAYGQTU) OR (vID != 0 AND y.ID > vID AND y.NGAYGQ_YC < V_NGAYGQDEN));
END CHECK_NGAYGQ_DON_YCBS;
END PKG_STPT_YCBS;
