--------------------------------------------------------
--  DDL for Package Body PKG_BPXLHC
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_BPXLHC" 
AS
-- Package body


PROCEDURE XLHC_PHUCTHAM_THULY_GETLIST_V2
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
	vGroupTHGiaoNhan number;
BEGIN
  select ID into vGroupTHGiaoNhan from DM_DATAGROUP where MA='TRUONGHOP_GIAONHAN';
OPEN curReturn FOR  
  SELECT 
  	t.ID,
  	t.MATHULY,
  	thtl.TEN as TENTRUONGHOPTHULY,
    qhpl.TEN as QuanHePL,
    qhpltk.CASE_NAME as QuanHePLTK,
    t.NGAYTHULY,
    t.SOTHULY,
    t.THOIHANTUNGAY,
    t.THOIHANDENNGAY,
    t.NGAYTAO,
    t.NGUOITAO,
    t.NGAYTHONGBAO,
    t.SOTHONGBAO,
    t.NGUOIKY,
    t.TOA_GIAIQUYET_ID
  From XLHC_PHUCTHAM_THULY t
  left join (select a.ID,a.TEN from DM_DATAITEM a where a.GROUPID=vGroupTHGiaoNhan and a.MA in ('02','03','04')) thtl on thtl.ID=t.TRUONGHOPTHULY
  left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID
  left join DM_QHPL_TK qhpltk on qhpltk.ID=t.QHPLTKID
  Where t.DONID=vDONID
  ORder by t.NGAYTHULY desc;
END XLHC_PHUCTHAM_THULY_GETLIST_V2;

PROCEDURE XLHC_SOTHAM_QUYETDINH_GETLIST
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU, d.MA
      ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
       ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE
       ,q.QUYETDINHID
       ,q.TOA_GIAIQUYET_ID 
  From XLHC_SOTHAM_QUYETDINH q 
  left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
  inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
  left join DM_CANBO c on c.ID=q.NGUOIKYID
     left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
  Where q.DONID=vDONID
  ORder by q.NGAYQD;
END XLHC_SOTHAM_QUYETDINH_GETLIST;

PROCEDURE XLHC_DON_TGTT_GETLIST_V2
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,d.HOTEN
        ,i.TEN as TENTC
        ,d.TAMTRUCHITIET as Tamtru
        ,d.HKTTCHITIET as ThuongTru
        ,d.NGAYTHAMGIA,d.NGAYKETTHUC,d.NGAYSINH,d.NGUOIDAIDIEN
        ,d.NGUOITAO,d.NGAYTAO
        , (d.HOTEN || ' - ' || h1.MA_TEN || ' - ' || i.TEN) as arrTEN
        ,d.TUCACHTGTTID 
        ,d.TOA_GIAIQUYET_ID
  From XLHC_DON_THAMGIATOTUNG d 
  left join DM_DATAITEM i on i.MA=d.TUCACHTGTTID
  left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
  Where d.DONID=vDONID
  ORder by  d.HOTEN;
END XLHC_DON_TGTT_GETLIST_V2;
PROCEDURE XLHC_PT_KCQUAHAN_V2
(
  vDonViID in number,
  vMaVuViec in varchar2, 
  vTenVuViec in varchar2,
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
  -- Tính tổng
  select count(a.ID) into vTotalItem
  from XLHC_DON a
  inner join DM_TOAAN ta on a.TOAANID=ta.ID
  inner join XLHC_SOTHAM_KHANGCAO b on a.ID=b.DONID
  where (1=case when vMaVuViec='' then 1 when LOWER(a.MAVUVIEC) LIKE  ('%' || LOWER(vMaVuViec) || '%') then 1 else 0 end)
        and
        (1=case when vTenVuViec='' then 1 when LOWER(a.TENVUVIEC) LIKE  ('%' || LOWER(vTenVuViec) || '%') then 1 else 0 end)
        and
        (1=case when vTuNgay is null then 1 when vTuNgay <= b.NGAYKHANGCAO then 1 else 0 end)
        and
        (1=case when vDenNgay is null then 1 when b.NGAYKHANGCAO <= vDenNgay then 1 else 0 end)
        and b.GQ_TINHTRANG=vTrangThai and b.TOAANRAQDID=vDonViID;
  -- Lấy dữ liệu theo PageIndex
  open curReturn for
    select a.ID,a.MAVUVIEC,a.TENVUVIEC,a.TenToaAn,a.NGAYKHANGCAO,a.KETQUA, vTotalItem as CountAll, a.idKhangCao AS idKhangCao
    from(
      select ROW_NUMBER() OVER (ORDER BY a.MAVUVIEC) as stt,a.ID,a.MAVUVIEC,a.TENVUVIEC,b.NGAYKHANGCAO,ta.TEN as TenToaAn,
              case when b.GQ_ISCHAPNHAN=1 then 'Chấp nhận' 
                   when b.GQ_ISCHAPNHAN=0 then 'Không chấp nhận' else 'Chưa giải quyết' end as KETQUA,
                   b.ID AS idKhangCao
      from XLHC_DON a
      inner join DM_TOAAN ta on a.TOAANID=ta.ID
      inner join XLHC_SOTHAM_KHANGCAO b on a.ID=b.DONID
      where (1=case when vMaVuViec='' then 1 when LOWER(a.MAVUVIEC) LIKE  ('%' || LOWER(vMaVuViec) || '%') then 1 else 0 end)
            and
            (1=case when vTenVuViec='' then 1 when LOWER(a.TENVUVIEC) LIKE  ('%' || LOWER(vTenVuViec) || '%') then 1 else 0 end)
            and
            (1=case when vTuNgay is null then 1 when vTuNgay <= b.NGAYKHANGCAO then 1 else 0 end)
            and
            (1=case when vDenNgay is null then 1 when b.NGAYKHANGCAO <= vDenNgay then 1 else 0 end)
            and b.GQ_TINHTRANG=vTrangThai and b.TOAANRAQDID=vDonViID
      order by b.NGAYKHANGCAO desc
      ) a where a.stt between vMinIndex and vMaxIndex
  ;
END XLHC_PT_KCQUAHAN_V2;
PROCEDURE XLHC_SOTHAM_THULY_GETLIST_V2
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS
BEGIN
OPEN curReturn FOR
  Select t.ID,t.MATHULY,
    (CASE t.TRUONGHOPTHULY WHEN 1 THEN 'Thụ lý mới'
                           WHen 2 then 'Thụ lý từ Tòa án khác chuyển đến'
                           When 3 then 'Thụ lý xét xử lại (do Tạm đình chỉ)' END) as TENTRUONGHOPTHULY
    --qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
    ,t.NGAYTHULY,t.SOTHULY
    ,t.THOIHANTUNGAY,t.THOIHANDENNGAY,t.NGAYTAO,t.NGUOITAO,
    t.NGAYTHONGBAO, t.SOTHONGBAO,t.TOA_GIAIQUYET_ID
  From XLHC_SOTHAM_THULY t
--  left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID
--  left join DM_QHPL_TK qhpltk on qhpltk.ID=t.QHPLTKID
  Where t.DONID=vDONID
  ORder by t.NGAYTHULY desc;
END XLHC_SOTHAM_THULY_GETLIST_V2;
PROCEDURE XLHC_DON_XULY_GETBYDONID_V2
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
    from XLHC_DON_XULY a where a.DonID =CurrDonID;
		---------------------------------------------------
    OPEN curReturn FOR 
			select a.*, TotalItem as CountAll 
			from (	select ROWNUM  stt,a.ID, a.DonID
                , a.LoaiGiaiQuyet
                ,case when a.LoaiGiaiQuyet =1 then u'Chuy\1ec3n \0111\01a1n trong ng\00e0nh'
                      when a.LoaiGiaiQuyet =2 then u'Chuy\1ec3n \0111\01a1n ngo\00e0i ng\00e0nh' 
                      when a.LoaiGiaiQuyet =3 then u'Tr\1ea3 l\1ea1i h\1ed3 s\01a1' 
                      when a.LoaiGiaiQuyet =4 then u'B\1ed5 sung ch\1ee9ng c\1ee9' 
                      when a.LoaiGiaiQuyet =5 then u'Th\1ee5 l\00fd h\1ed3 s\01a1' 
                 end as BienPhapGQ
                , a.NgayGQ_YC, a.LyDo
                , a.CDTN_ToaAnID, b.Ten, a.CDTN_NGAYNHAN
                , a.CDNN_TenCQ
                , a.TraDon_CanCuID
                , a.NgayTao, a.NguoiTao
                , a.NgaySua, a.NguoiSua
                ,a.TOA_GIAIQUYET_ID
              from XLHC_DON_XULY a
                left join DM_ToaAn b on a.CDTN_ToaAnID = b.ID
              where a.DonID =CurrDonID
              order by a.NgayTao desc
				    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END XLHC_DON_XULY_GETBYDONID_V2;
PROCEDURE XLHC_ST_KCKN_TINHTRANG_GETLIST
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
        --,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From XLHC_SOTHAM_KHANGCAO d
  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from XLHC_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangCao) r on r.IDKCKN=d.ID
  left join (select a.ID,a.HOTEN as TENDUONGSU from XLHC_DUONGSU a where a.DONID=vDonID) s on s.ID=d.DUONGSUID
  left join (select e.ID,e.SOBANAN from XLHC_SOTHAM_BANAN e where e.DONID=vDonID) b on b.ID=d.SOQDBA
  left join (select f.ID,f.SOQD from XLHC_SOTHAM_QUYETDINH f where f.DONID=vDonID) q on q.ID=d.SOQDBA
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
--        ,(case r.TRANGTHAI when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From XLHC_SOTHAM_KHANGNGHI d
  left join (select g.ID,g.IDKCKN,g.NGAYRUT,g.TRANGTHAI,g.NOIDUNGRUT from XLHC_SOTHAM_RUTKCKN g where g.DONID=vDonID and g.ISKCKN=vKhangNghi) r on r.IDKCKN=d.ID
  left join (select a.ID,a.SOBANAN from XLHC_SOTHAM_BANAN a where a.DONID=vDonID) b on b.ID=d.BANANID
  left join (select c.ID,c.SOQD from XLHC_SOTHAM_QUYETDINH c where c.DONID=vDonID) q on q.ID=d.BANANID
  Where d.DONID=vDonID;

END XLHC_ST_KCKN_TINHTRANG_GETLIST;

PROCEDURE HOANMIEN_SOTHAM_HDXX_GETLIST
(   vDONID IN number,
    vLOAIAN IN number,
    vDONHOANMIEN_ID IN number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,(Case MAVAITRO WHEN 'THAMPHAN' then 'Thẩm phán chủ tọa phiên tòa'
                             WHEN 'THAMPHANHDXX' then 'Thẩm phán thành viên hội đồng xét xử'
                             WHEN 'THAMPHANDUKHUYET' then 'Thẩm phán dự khuyết'
                             WHEN 'HTND' then 'Hội thẩm nhân dân'
                             WHEN 'THUKY' then 'Thư ký'
                             WHEN 'THUKYDUKHUYET' then 'Thư ký dự khuyết'
                             WHEN 'KSV' then 'Kiểm sát viên' End) as TENVAITRO
        ,CASE d.MAVAITRO WHEN 'KSV' THEN v.HOTEN ELSE c.HOTEN END as TENNGUOITHTT
        ,d.NGAYTHAMGIA,d.NGAYKETTHUC,d.NGAYPHANCONG,d.NGAYNHANPHANCONG
        ,d.NGUOITAO,d.NGAYTAO,e.HOTEN as NguoiPhanCong, d.TOA_GIAIQUYET_ID -- VNPT- Lê Bá Thọ - thêm TOA_GIAIQUYET_ID - 15-9-2025 08:00
  From HOANMIEN_SOTHAM_HDXX d 
  left join DM_CANBO c on c.ID=d.CANBOID
  left join DM_CANBO e on e.ID=d.NGUOIPHANCONGID
  left join DM_CANBOVKS v on v.ID=d.CANBOID
  Where d.DONID = vDONID AND d.LOAIAN = vLOAIAN AND d.DON_XIN_HOAN_MIEN_ID = vDONHOANMIEN_ID
  ORder by  d.HOTEN;

END HOANMIEN_SOTHAM_HDXX_GETLIST;

PROCEDURE XLHC_ST_KCKN_TINHTRANG_GETLIST_V2
( 
	vDonID IN NUMBER,
	curReturn OUT sys_refcursor
)
IS
BEGIN
OPEN curReturn FOR
    WITH 
    CTE (QUYETDINHID, SO_QUYETDINH, type) AS (
            SELECT QUYETDINHID, SOBANAN AS SO_QUYETDINH, '1|' || SOBANAN AS type
	    FROM XLHC_SOTHAM_BANAN ba 
	    WHERE DONID = vDonID 
	    UNION ALL  
	    SELECT QUYETDINHID, SOQD AS SO_QUYETDINH, '2|' || SOQD AS type
	    FROM XLHC_SOTHAM_QUYETDINH     
	    WHERE DONID = vDonID          
	    UNION ALL
	    SELECT DM_QUYETDINH_ID AS QUYETDINHID, TO_CHAR(SO_QUYETDINH) AS SO_QUYETDINH, '3|' ||SO_QUYETDINH   AS type
	    FROM XLHC_DONXIN_HOAN_MIEN hm
	    WHERE hm.DONID = vDonID AND hm.ISGIAIQUYET = 1
    ),
    KN AS ( 
        SELECT c.SO_QUYETDINH , qd.TEN , c.QUYETDINHID, c.type
	    FROM CTE c
	    JOIN DM_QD_QUYETDINH qd ON c.QUYETDINHID = qd.ID
    )
	SELECT 
		R.ID,
		K.ID AS KNKNKCID,
		K.TYPE,
		CASE K.TYPE
			WHEN 1 THEN 'Khiếu nại'
		    WHEN 2 THEN 'Kiến nghị'
		    WHEN 3 THEN 'Kháng nghị'
		    ELSE 'Khiếu nại'  
	  	END AS KNKNKCName,
	  	CASE K.TYPE
			WHEN 1 THEN COALESCE(TT.TENDUONGSU, DS.TENDUONGSU)
		    WHEN 2 THEN D.TENDUONGSU
		    WHEN 3 THEN V.TENDUONGSU
	  	END AS TEN,
	  	'Quyết định' AS LOAI_QD,
		KN.SO_QUYETDINH AS SO_QD,
	  	R.NGAYRUT,
	  	R.TRANGTHAI,
	  	R.NOIDUNGRUT,
	  	(case R.TRANGTHAI WHEN 1 THEN 'Rút một phần' WHEN 2 THEN 'Rút toàn bộ'  ELSE 'Chưa rút' END) AS TINHTRANGNAME,
        R.TOA_GIAIQUYET_ID -- VNPT- Lê Bá Thọ - thêm TOA_GIAIQUYET_ID - 15-9-2025 08:00
	  	FROM XLHC_SOTHAM_KHANGCAO K
	  	LEFT JOIN (SELECT ID, IDKCKN, NGAYRUT, TRANGTHAI, NOIDUNGRUT,TOA_GIAIQUYET_ID FROM XLHC_SOTHAM_RUTKCKN WHERE DONID = vDonID) R on R.IDKCKN = K.ID
	  	LEFT JOIN (SELECT ID, HOTEN AS TENDUONGSU FROM XLHC_DON_THAMGIATOTUNG WHERE DONID = vDonID) TT ON TT.ID = K.DUONGSUID
	  	LEFT JOIN (SELECT ID, HOTEN AS TENDUONGSU FROM XLHC_DUONGSU WHERE DONID = vDonID) DS ON DS.ID = K.DUONGSUID
		LEFT JOIN (SELECT ID, CQDN_TEN AS TENDUONGSU FROM XLHC_DON WHERE ID = vDonID) D ON D.ID = K.DUONGSUID
		LEFT JOIN (SELECT ID, TEN AS TENDUONGSU FROM DM_VKS) V ON V.ID = K.DUONGSUID  
		LEFT JOIN KN ON KN.QUYETDINHID = K.SOQDBA 
--	  	LEFT JOIN (SELECT ID, SOBANAN FROM XLHC_SOTHAM_BANAN WHERE DONID = vDonID) BA ON BA.ID = K.SOQDBA
--	  	LEFT JOIN (SELECT ID, SOQD FROM XLHC_SOTHAM_QUYETDINH WHERE DONID = vDonID) Q ON Q.ID = K.SOQDBA
--	  	LEFT JOIN (SELECT ID, SO_QUYETDINH FROM XLHC_DONXIN_HOAN_MIEN WHERE DONID = vDonID AND ISGIAIQUYET = 1) DHM ON DHM.ID = K.SOQDBA
	  	WHERE K.DONID = vDonID
	  	ORDER BY K.ID ASC;
END XLHC_ST_KCKN_TINHTRANG_GETLIST_V2;

PROCEDURE XLHC_DONXIN_HOAN_MIEN_GETLIST_V2
(
    CurrDonID   IN  NUMBER, 
    pVaiTro     IN  VARCHAR2,  
	PageIndex	IN	NUMBER,
	PageSize	IN	NUMBER,
	curReturn   OUT   sys_refcursor
)
AS
	TotalItem   NUMBER;
    MinIndex	NUMBER;
    MaxIndex	NUMBER;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

	--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
	select count (a.ID) into TotalItem 
    from XLHC_DONXIN_HOAN_MIEN a where a.DONID = CurrDonID;
		---------------------------------------------------
    OPEN curReturn FOR 
		SELECT 
            ret.*
            , ret.SOTHULY || ' - ' || CASE WHEN ret.NGAYTHULY IS NOT NULL THEN TO_CHAR(NGAYTHULY, 'dd/MM/yyyy') ELSE '' END AS TT_THULY 
            , TotalItem as CountAll 
		FROM (	
		SELECT ROWNUM  stt, d.* FROM (
            SELECT DISTINCT a.ID, a.DONID
                , a.LOAIDON
                ,case when a.LOAIDON =1 then u'\0110\1ec1 ngh\1ecb ho\00e3n vi\1ec7c ch\1ea5p h\00e0nh'
                      when a.LOAIDON =2 then u'\0110\1ec1 ngh\1ecb mi\1ec5n vi\1ec7c ch\1ea5p h\00e0nh' 
                      when a.LOAIDON =3 then u'\0110\1ec1 ngh\1ecb gi\1ea3m th\1eddi h\1ea1n ch\1ea5p h\00e0nh' 
                      when a.LOAIDON =4 then u'\0110\1ec1 ngh\1ecb t\1ea1m \0111\00ecnh ch\1ec9 ch\1ea5p h\00e0nh' 
                      when a.LOAIDON =5 then u'\0110\1ec1 ngh\1ecb mi\1ec5n ch\1ea5p h\00e0nh ph\1ea7n th\1eddi gian c\00f2n l\1ea1i' 
                 end as TENLOAIDON
                , a.NGAYVIETDON, a.NGAYNHANDON
                , a.ISGIAIQUYET,case when a.ISGIAIQUYET = 0 then u'Ch\01b0a gi\1ea3i quy\1ebft'
                                     when a.ISGIAIQUYET = 1 then dqq.TEN End as TENGIAIQUYET
                , a.NgayTao, a.NguoiTao
                , a.NgaySua, a.NguoiSua
                , a.NGUOI_DUNG_DON, a.DM_QUYETDINH_ID , dt.SOTHULY , dt.NGAYTHULY
                , dc.HOTEN AS TENTHAMPHAN
                , a.TOA_GIAIQUYET_ID 
            FROM XLHC_DONXIN_HOAN_MIEN a
            LEFT JOIN DONXINHOANMIEN_THULY dt 
            ON a.ID = dt.DON_XIN_HOAN_MIEN_ID AND a.DONID = dt.DONID
            LEFT JOIN DM_QD_QUYETDINH dqq 
            ON a.DM_QUYETDINH_ID = dqq.ID
            LEFT JOIN HOANMIEN_SOTHAM_HDXX xsh 
            ON a.DONID = xsh.DONID AND xsh.DON_XIN_HOAN_MIEN_ID = a.ID AND xsh.MAVAITRO = pVaiTro AND xsh.LOAIAN = 8
            LEFT JOIN DM_CANBO dc ON xsh.CANBOID = dc.ID
            WHERE a.DonID = CurrDonID
            order by a.NgayTao desc
			) d
		) ret where ret.stt >= MinIndex and ret.stt <= MaxIndex;
END XLHC_DONXIN_HOAN_MIEN_GETLIST_V2;

PROCEDURE UPSERT_HOANMIEN_SOTHAM_HDXX (
		N_ID  			IN NUMBER,
		N_DONID 		IN NUMBER,
		V_MAVAITRO 		IN VARCHAR2,
		N_CANBOID 		IN NUMBER,
		V_HOTEN			IN VARCHAR2,
		D_NGAYPHANCONG  IN DATE,
		D_NGAYNHANPHANCONG IN DATE,
		D_NGAYTHAMGIA 	IN DATE,
		D_NGAYKETTHUC 	IN DATE,
		N_NGUOIPHANCONGID IN NUMBER,
		N_DUKHUYET		IN NUMBER,
		V_NGUOITAO 		IN NVARCHAR2,
		D_NGAYTAO 		IN DATE,
		V_NGUOISUA 		IN NVARCHAR2, 
		D_NGAYSUA 		IN DATE,
		N_LOAIAN 		IN NUMBER,
		N_DON_XIN_HOAN_MIEN_ID 	IN NUMBER,
        N_TOA_GIAIQUYET_ID IN NUMBER,
		OUT_ID OUT NUMBER
)
AS
	ID_NEW NUMBER;
	ID_UPDATE NUMBER;
BEGIN
	IF (N_ID IS NULL OR N_ID = 0) THEN
		SELECT HOANMIEN_SOTHAM_HDXX_SEQ.NEXTVAL INTO ID_NEW FROM DUAL;

		INSERT INTO
			HOANMIEN_SOTHAM_HDXX (ID,
			DONID,
			MAVAITRO,
			CANBOID,
			HOTEN,
			NGAYPHANCONG,
			NGAYNHANPHANCONG,
			NGAYTHAMGIA,
			NGAYKETTHUC,
			NGUOIPHANCONGID,
			DUKHUYET,
			NGAYTAO,
			NGUOITAO,
			NGAYSUA,
			NGUOISUA,
			LOAIAN,
			DON_XIN_HOAN_MIEN_ID,
            TOA_GIAIQUYET_ID)
			VALUES(ID_NEW,
				N_DONID,
				V_MAVAITRO,
				N_CANBOID,
				V_HOTEN,
				D_NGAYPHANCONG,
				D_NGAYNHANPHANCONG,
				D_NGAYTHAMGIA,
				D_NGAYKETTHUC,
				N_NGUOIPHANCONGID,
				N_DUKHUYET,
				D_NGAYTAO,
				V_NGUOITAO,
				D_NGAYSUA,
				V_NGUOISUA,
				N_LOAIAN,
				N_DON_XIN_HOAN_MIEN_ID,
                N_TOA_GIAIQUYET_ID);
		OUT_ID := ID_NEW;	
	ELSE
		ID_UPDATE := N_ID;
		UPDATE
			HOANMIEN_SOTHAM_HDXX
		SET
			DONID = N_DONID,
			MAVAITRO = V_MAVAITRO,
			CANBOID = N_CANBOID,
			HOTEN = V_HOTEN,
			NGAYPHANCONG = D_NGAYPHANCONG,
			NGAYNHANPHANCONG = D_NGAYNHANPHANCONG,
			NGAYTHAMGIA = D_NGAYTHAMGIA,
			NGAYKETTHUC = D_NGAYKETTHUC,
			NGUOIPHANCONGID = N_NGUOIPHANCONGID,
			DUKHUYET = N_DUKHUYET,
			NGAYSUA = D_NGAYSUA,
			NGUOISUA = V_NGUOISUA,
			LOAIAN = N_LOAIAN,
			DON_XIN_HOAN_MIEN_ID = N_DON_XIN_HOAN_MIEN_ID
		WHERE
			ID = ID_UPDATE;
		OUT_ID := ID_UPDATE;
	END IF;
END UPSERT_HOANMIEN_SOTHAM_HDXX;


PROCEDURE GET_HOANMIEN_SOTHAM_HDXX_BY_ID (
	N_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR 
		SELECT * FROM HOANMIEN_SOTHAM_HDXX 
		WHERE ID = N_ID;

END GET_HOANMIEN_SOTHAM_HDXX_BY_ID;

PROCEDURE DELETE_HOANMIEN_SOTHAM_HDXX_BY_ID (
	N_ID IN NUMBER
)
AS
BEGIN
		DELETE FROM HOANMIEN_SOTHAM_HDXX 
		WHERE ID = N_ID;

END DELETE_HOANMIEN_SOTHAM_HDXX_BY_ID;

PROCEDURE GET_HOANMIEN_SOTHAM_HDXX_BY_DON_HOANMIEN (
	P_DON_HOANMIEN_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR 
		SELECT * FROM HOANMIEN_SOTHAM_HDXX 
		WHERE DON_XIN_HOAN_MIEN_ID  = P_DON_HOANMIEN_ID;

END GET_HOANMIEN_SOTHAM_HDXX_BY_DON_HOANMIEN;

PROCEDURE GET_HOANMIEN_SOTHAM_HDXX_BY_CONDITION (
	P_DON_ID IN NUMBER,
	P_DON_HOANMIEN_ID IN NUMBER,
	P_CANBO_ID IN NUMBER,
	P_LOAIAN IN NUMBER,
	P_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR 
		SELECT * FROM HOANMIEN_SOTHAM_HDXX 
		WHERE DONID = P_DON_ID 
			AND DON_XIN_HOAN_MIEN_ID = P_DON_HOANMIEN_ID
			AND CANBOID = P_CANBO_ID
			AND LOAIAN = P_LOAIAN
			AND ID != P_ID;

END GET_HOANMIEN_SOTHAM_HDXX_BY_CONDITION;

PROCEDURE GET_HOANMIEN_SOTHAM_HDXX_BY_DON_VAITRO (
	N_DONID IN NUMBER,
	N_DON_HOANMIEN_ID IN NUMBER,
	V_MAVAITRO IN VARCHAR2,
	N_LOAIAN IN NUMBER,
	N_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT
	*
	FROM
		HOANMIEN_SOTHAM_HDXX hsh
    JOIN XLHC_DONXIN_HOAN_MIEN d on d.ID = hsh.DON_XIN_HOAN_MIEN_ID
	WHERE
		hsh.DONID = N_DONID
		AND DON_XIN_HOAN_MIEN_ID = N_DON_HOANMIEN_ID
		AND MAVAITRO = V_MAVAITRO
		AND LOAIAN = N_LOAIAN
        AND hsh.TOA_GIAIQUYET_ID = d.TOAANID
		AND hsh.ID != N_ID;
END GET_HOANMIEN_SOTHAM_HDXX_BY_DON_VAITRO;

PROCEDURE GET_DONXINHOANMIEN_THULY_BY_HOAN_MIEN_ID(
	N_DON_XIN_HOAN_MIEN_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT * FROM DONXINHOANMIEN_THULY WHERE DON_XIN_HOAN_MIEN_ID = N_DON_XIN_HOAN_MIEN_ID;
END GET_DONXINHOANMIEN_THULY_BY_HOAN_MIEN_ID;


PROCEDURE GET_DONXINHOANMIEN_THULY_BY_DONID_HOAN_MIEN_ID(
	N_DONID IN NUMBER,
	N_LOAIAN IN NUMBER,
	N_DON_XIN_HOAN_MIEN_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT
	*
	FROM
		DONXINHOANMIEN_THULY
	WHERE
		DONID = N_DONID
		AND LOAIAN = N_LOAIAN
		AND DON_XIN_HOAN_MIEN_ID = N_DON_XIN_HOAN_MIEN_ID
	ORDER BY ID DESC;
END GET_DONXINHOANMIEN_THULY_BY_DONID_HOAN_MIEN_ID;

PROCEDURE GET_DONXINHOANMIEN_THULY_BY_SOTHULY_ID(
	N_SOTHULY IN NUMBER,
	N_LOAIAN IN NUMBER,
	N_ID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT
	*
	FROM
		DONXINHOANMIEN_THULY
	WHERE
		SOTHULY = N_SOTHULY
		AND LOAIAN = N_LOAIAN
		AND ID != N_ID
	ORDER BY ID DESC;
END GET_DONXINHOANMIEN_THULY_BY_SOTHULY_ID;


PROCEDURE UPSERT_DONXINHOANMIEN_THULY(
	N_ID IN NUMBER,
	N_LOAIAN IN NUMBER,
	N_DONID IN NUMBER,
	N_TOAANID IN NUMBER,
	N_DON_XIN_HOAN_MIEN_ID IN NUMBER,
	N_SOTHULY IN NUMBER,
	D_NGAYTHULY IN DATE,
	N_NGUOITHULYID IN NUMBER,
	D_NGAYTAO IN DATE,
	D_NGAYSUA IN DATE,
	V_NGUOITAO IN VARCHAR2,
	V_NGUOISUA IN VARCHAR2,
	OUT_ID OUT NUMBER
)
AS
	ID_NEW NUMBER;
	ID_UPDATE NUMBER;
BEGIN
	IF (N_ID IS NULL OR N_ID = 0) THEN
		SELECT DONXINHOANMIEN_THULY_SEQ.NEXTVAL INTO ID_NEW FROM DUAL;

		INSERT
			INTO
			DONXINHOANMIEN_THULY (ID,
			LOAIAN,
			DONID,
			TOAANID,
			DON_XIN_HOAN_MIEN_ID,
			SOTHULY,
			NGAYTHULY,
			NGUOITHULYID,
			NGAYTAO,
			NGAYSUA,
			NGUOITAO,
			NGUOISUA,
            TOA_GIAIQUYET_ID)
			VALUES(ID_NEW,
			N_LOAIAN,
			N_DONID,
			N_TOAANID,
			N_DON_XIN_HOAN_MIEN_ID,
			N_SOTHULY,
			D_NGAYTHULY,
			N_NGUOITHULYID,
			D_NGAYTAO,
			D_NGAYSUA,
			V_NGUOITAO,
			V_NGUOISUA,
            N_TOAANID);
		OUT_ID := ID_NEW;	
	ELSE
		ID_UPDATE := N_ID;
		UPDATE
			DONXINHOANMIEN_THULY
		SET
			LOAIAN = N_LOAIAN,
			DONID = N_DONID,
			DON_XIN_HOAN_MIEN_ID = N_DON_XIN_HOAN_MIEN_ID,
			SOTHULY = N_SOTHULY,
			NGAYTHULY = D_NGAYTHULY,
			NGUOITHULYID = N_NGUOITHULYID,
			NGAYSUA = D_NGAYSUA,
			NGUOISUA = V_NGUOISUA
		WHERE
			ID = ID_UPDATE;
		OUT_ID := ID_UPDATE;
	END IF;


END UPSERT_DONXINHOANMIEN_THULY;

PROCEDURE GET_DONXINHOANMIEN_THULY_BY_SOTHULY_NGAYTHULY(
	N_LOAIAN IN NUMBER,
	D_NGAYTHULY_START IN DATE,
	D_NGAYTHULY_END IN DATE,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT
	*
	FROM
		DONXINHOANMIEN_THULY
	WHERE
		LOAIAN = N_LOAIAN
		AND SOTHULY IS NOT NULL 
		AND NGAYTHULY >= D_NGAYTHULY_START
		AND NGAYTHULY <= D_NGAYTHULY_END
	ORDER BY SOTHULY DESC;
END GET_DONXINHOANMIEN_THULY_BY_SOTHULY_NGAYTHULY;

PROCEDURE DELETE_DONXINHOANMIEN_THULY_BY_ID (
	N_ID IN NUMBER
)
AS
BEGIN
	DELETE FROM DONXINHOANMIEN_THULY WHERE ID = N_ID;
END DELETE_DONXINHOANMIEN_THULY_BY_ID;

PROCEDURE GET_XLHC_DON_GIAIDOAN_BY_DONID (
	N_VUANID IN NUMBER,
	curReturn OUT sys_refcursor
)
AS
BEGIN
	OPEN curReturn FOR
	SELECT * FROM XLHC_DON_GIAIDOAN
	WHERE DONID = N_VUANID
	ORDER BY MAGIAIDOAN DESC ;
END GET_XLHC_DON_GIAIDOAN_BY_DONID;

END PKG_BPXLHC;

/
