CREATE OR REPLACE PACKAGE BODY GSCM.PKG_STPT_TONGDAT AS
PROCEDURE TONGDAT_DELETE_ERROR
(
    V_DONID in VARCHAR2,
    V_LOAIAN in VARCHAR2
)
    IS
        V_COUNT NUMBER;  
    Begin
     IF(V_LOAIAN='1')THEN
     SELECT COUNT(*)INTO V_COUNT FROM AHS_TONGDAT_DOITUONG DT WHERE 
     EXISTS(SELECT 'X' FROM AHS_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.VUANID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from AHS_TONGDAT where VUANID = V_DONID;
        END IF;
   END IF;
     IF(V_LOAIAN='2')THEN
     SELECT COUNT(*)INTO V_COUNT FROM ADS_TONGDAT_DOITUONG DT 
     WHERE EXISTS(SELECT 'X' FROM ADS_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from ADS_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
    IF(V_LOAIAN='3')THEN
     SELECT COUNT(*)INTO V_COUNT FROM AHN_TONGDAT_DOITUONG  DT 
     WHERE EXISTS(SELECT 'X' FROM AHN_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from AHN_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
    IF(V_LOAIAN='4')THEN
     SELECT COUNT(*)INTO V_COUNT FROM AKT_TONGDAT_DOITUONG  DT WHERE 
     EXISTS(SELECT 'X' FROM AKT_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from AKT_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
    IF(V_LOAIAN='5')THEN
     SELECT COUNT(*)INTO V_COUNT FROM ALD_TONGDAT_DOITUONG DT
     WHERE EXISTS(SELECT 'X' FROM ALD_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from ALD_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
   IF(V_LOAIAN='6')THEN
     SELECT COUNT(*)INTO V_COUNT FROM AHC_TONGDAT_DOITUONG DT 
     WHERE EXISTS(SELECT 'X' FROM AHC_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from AHC_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
    IF(V_LOAIAN='7')THEN
     SELECT COUNT(*)INTO V_COUNT FROM APS_TONGDAT_DOITUONG DT 
     WHERE EXISTS(SELECT 'X' FROM APS_TONGDAT TD WHERE TD.ID=DT.TONGDATID AND TD.DONID=V_DONID);
        IF(V_COUNT=0)THEN
             delete from APS_TONGDAT where DONID = V_DONID;
        END IF;
   END IF;
END TONGDAT_DELETE_ERROR;

PROCEDURE  ADS_TONGDAT_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,    
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER,
    v_MAP_TABLE IN varchar2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)IS
        V_COUNT NUMBER;
  BEGIN
  if (v_id >0) then
            UPDATE ads_tongdat
                    set
                        DONID     = v_DONID,
                        BIEUMAUID    = v_BIEUMAUID,
                        TOAANID   =    v_TOAANID,
                        IS_TD_VKS   =   v_IS_TD_VKS,
                        IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY ,
                        NGAYTAO = v_NGAYTAO,
                        NGUOITAO = v_NGUOITAO,
                        NGAYSUA = v_NGAYSUA,
                        NGUOISUA  =  v_NGUOISUA,
                        TENFILE = v_TENFILE,
                        KIEUFILE = v_KIEUFILE,
                        NOIDUNGFILE = v_NOIDUNGFILE,
                        FILEID = v_FILEID,
                        NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
                        NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
                        TRANGTHAI = v_TRANGTHAI,
                        NGAYTHUHOI = v_NGAYTHUHOI,
                        LYDOTHUHOI = v_LYDOTHUHOI,
                        URL_FILE = v_URL_FILE,
                        MAPID = v_MAPID
                    where id = v_id  
                    RETURNING ID INTO vID;
        else
        SELECT COUNT(*) INTO V_COUNT FROM ADS_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID AND MAPID = v_MAPID; 
            IF(V_COUNT=0)THEN
                insert into ADS_TONGDAT
                (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE, MAPID, MAP_TABLE,TOA_GIAIQUYET_ID)
                values ( ADS_TONGDAT_SEQ.nextval  ,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,v_LYDOTHUHOI,v_URL_FILE, v_MAPID, v_MAP_TABLE,v_TOA_GIAIQUYET_ID)
                RETURNING ID INTO vID;
            END IF;
        end if;
END ADS_TONGDAT_UP_IN;

    PROCEDURE ADS_TONGDAT_DEL(
        vID in number
    )
    IS
    Begin
    if(vID >= 0 ) then
        Delete from ads_tongdat where ID = vID ;
        Delete from ads_tongdat_doituong where TongdatID = vID ;
    end if ;
    END ADS_TONGDAT_DEL ;

PROCEDURE  ADS_TONGDATNOINHAN_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER 
) IS
  BEGIN

  if (v_id >0) then
            UPDATE ads_tongdat_doituong
                    set
                        TONGDATID     = v_TONGDATID,
                        MATUCACH    = v_MATUCACH,
                        NGAYGUI   =    v_NGAYGUI,
                        TRANGTHAI   =   v_TRANGTHAI,
                        HINHTHUCGUI = v_HINHTHUCGUI ,
                        DUONGSUID = v_DUONGSUID,
                        NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
                        QUOCGIA = v_QUOCGIA,
                        COQUAN  =  v_COQUAN,
                        NOIDUNG = v_NOIDUNG,
                        KETQUAUTTP = v_KETQUAUTTP,
                        -- NGAYPHATHANH = v_NGAYPHATHANH,
                        NGAYTAO = v_NGAYTAO,
                        NGUOITAO = v_NGUOITAO,
                        IS_UTTP = v_IS_UTTP,
                        UTTP = v_UTTP,
                        NOINHAN = v_NOINHAN,
                        DIACHI = v_DIACHI
                    where id = v_id  
                    RETURNING ID INTO vID;
        else
            insert into ADS_TONGDAT_DOITUONG
            (id,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA,TOA_GIAIQUYET_ID)
            values (ADS_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,v_UTTP,v_NOINHAN,v_DIACHI,1,v_TOA_GIAIQUYET_ID)
            RETURNING ID INTO vID;
        end if;

  END ADS_TONGDATNOINHAN_UP_IN;

-- PROCEDURE  ADS_TONGDATNOINHAN_UP_IN
--( 
--    v_id  in number DEFAULT 0,
--    v_TONGDATID in NUMBER , 
--    v_MATUCACH in VARCHAR2 , 
--    v_NGAYGUI in DATE,
--    v_TRANGTHAI in NUMBER ,
--    v_HINHTHUCGUI in NUMBER , 
--    V_DUONGSUID in NUMBER,
--    v_NGAYNHANTONGDAT in DATE,
--    v_QUOCGIA in NUMBER,
--    v_COQUAN in VARCHAR2,
--    v_NOIDUNG in CLOB ,
--    v_KETQUAUTTP in NUMBER ,
--    v_NGAYPHATHANH in DATE ,
--    v_NGAYTAO in DATE,
--    v_NGUOITAO in VARCHAR2 ,
--    v_IS_UTTP in NUMBER,
--    v_UTTP in NUMBER ,
--    v_NOINHAN in VARCHAR2 , 
--    v_DIACHI in VARCHAR2,
--    v_MAPPING_ID IN NUMBER, -- VNPT 16/06/2025 thêm mapping án phí
--    vID out NUMBER 
--) IS
--  BEGIN
--
--  if (v_id >0) then
--            UPDATE ads_tongdat_doituong
--                    set
--                        TONGDATID     = v_TONGDATID,
--                        MATUCACH    = v_MATUCACH,
--                        NGAYGUI   =    v_NGAYGUI,
--                        TRANGTHAI   =   v_TRANGTHAI,
--                        HINHTHUCGUI = v_HINHTHUCGUI ,
--                        DUONGSUID = v_DUONGSUID,
--                        NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
--                        QUOCGIA = v_QUOCGIA,
--                        COQUAN  =  v_COQUAN,
--                        NOIDUNG = v_NOIDUNG,
--                        KETQUAUTTP = v_KETQUAUTTP,
--                        -- NGAYPHATHANH = v_NGAYPHATHANH,
--                        NGAYTAO = v_NGAYTAO,
--                        NGUOITAO = v_NGUOITAO,
--                        IS_UTTP = v_IS_UTTP,
--                        UTTP = v_UTTP,
--                        NOINHAN = v_NOINHAN,
--                        DIACHI = v_DIACHI
--                    where id = v_id  
--                    RETURNING ID INTO vID;
--        else
--            insert into ADS_TONGDAT_DOITUONG
--            (id,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA, MAPPING_ID) -- VNPT 16/06/2025 thêm mapping án phí
--            values (ADS_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,v_UTTP,v_NOINHAN,v_DIACHI,1, v_MAPPING_ID) -- VNPT 16/06/2025 thêm mapping án phí
--            RETURNING ID INTO vID;
--        end if;
--
--  END ADS_TONGDATNOINHAN_UP_IN;


PROCEDURE ADS_TONGDATNOINHAN_DEL(
        vID in NUMBER
    )
    IS
    BEGIN
        if(vID >= 0) then
        Delete from ads_tongdat_doituong where TONGDATID = vID ;
        end if ; 
END ADS_TONGDATNOINHAN_DEL ;

PROCEDURE ADS_TONGDATDOITUONG_GETBY(
    vDonID in Decimal,
    vToaAnID in Decimal, 
    vBieuMauID in Decimal,
    vIsOnLyNKK in Decimal,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR  
    Select d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI, 
        (d.TAMTRUCHITIET || 
            (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
            (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
        td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID, 
        td.NGAYNHANTONGDAT, td.QUOCGIA,  td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
        NULL AS ANPHI_ID,  NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,  NULL AS MA_THONGBAO, -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
        case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG -- VNPT Đinh Hoàng Sơn 25/11/2025   xac dinh xacthuc_dldcqg
    From ADS_DON_DUONGSU d
    left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
    left join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')),TO_CHAR(astl.SOTHONGBAO)),TO_CHAR(apttl.SOTHONGBAO)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO),astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO) AS NGAYTHONGBAO,
                NVL(aptq.SOQD,asq.SOQD )AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(aptq.NGAYQD,asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID, af.DONID
			FROM
				ADS_FILE af
            LEFT JOIN ADS_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_SOTHAM_THULY astl ON astl.FILEID = af.ID    -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN ADS_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN ADS_DON_XULY a on af.ID = a.FILEID
    )aff on aff.FILEID = vFileID and aff.DONID = d.DONID
    left join (Select dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI,
                    dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT,
                    dt.QUOCGIA, dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
              from ADS_TONGDAT_DOITUONG dt inner join ADS_TONGDAT t on t.ID = dt.TONGDATID
              where t.DONID = vDONID and t.TOAANID = vTOAANID and t.BIEUMAUID = vBIEUMAUID
              and ( ---------21/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                    (vFileID > -1 and t.FILEID = vFileID)
                     or
                    (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                  )
              ) td on td.DUONGSUID = d.ID
    Where d.DONID = vDONID
--        And 1=(Case WHEN vIsOnlyNKK=1 And d.TUCACHTOTUNG_MA='NGUYENDON' THEN 1 
--                    WHEN vIsOnlyNKK=0 THEN 1 ELSE 0 END)
  AND d.TUCACHTOTUNG_MA IN ('NGUYENDON', 'BIDON')  -- VNPT - Lê Bá Thọ - 26/11/2025 tống đạt chỉ lấy ra nguyên đơn và bị đơn 
  AND (
        (vIsOnlyNKK = 1)
        OR
        (vIsOnlyNKK = 0)
      )
    ORder by d.ISDAIDIEN desc, d.TENDUONGSU;
END ADS_TONGDATDOITUONG_GETBY;

PROCEDURE ADS_TONGDAT_GETBYID(
    vID in Number,
    curReturn out SYS_REFCURSOR 
)
IS
BEGIN
    OPEN curReturn for 
    select ID ,
        DONID ,
        BIEUMAUID ,
        TOAANID ,
        IS_TD_VKS ,
        IS_TD_VKS_NGAY ,
        NGAYTAO ,
        NGUOITAO ,
        NGAYSUA ,
        NGUOISUA ,
        TENFILE ,
        KIEUFILE ,
        NOIDUNGFILE ,
        FILEID ,
        NGAYDANG_CTTDT ,
        NGAYNHANTONGDAT ,
        TRANGTHAI ,
        NGAYTHUHOI ,
        LYDOTHUHOI ,
        URL_FILE, 
        MAPID, -- VNPT 24/06/2025 thêm param trả ra
        MAP_TABLE -- VNPT 24/06/2025 thêm param trả ra
        from ads_tongdat 
        where ID = vID ;
  END ADS_TONGDAT_GETBYID ;

-- vnpt hoangndh: sua logic lay grid data man tong dat 29/10/2025 16:00:00
PROCEDURE ADS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number , 
    curReturn out SYS_REFCURSOR
 )
 IS
 BEGIN
    open curReturn for 
    select a.*, NULL AS ANPHI_ID,  
    NVL(NVL(NVL(NVL(NVL(NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU), TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)),
    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)),TO_CHAR(aptq.SOQD)),TO_CHAR(asq.SOQD))
    AS SOTHONGBAO,  NULL AS MA_THONGBAO , at2.MAPID
    , noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG, ads.XACTHUC_DLDCQG  --VNPT Lê BÁ Thọ 26/11/2025 sửa lấy cột XACTHUC_DLDCQG hiển thị VNeID
   	from ads_tongdat_doituong a 
   	LEFT JOIN ADS_TONGDAT at2 ON a.TONGDATID = at2.id
        left join dm_bieumau bm on at2.BIEUMAUID = bm.ID
    	LEFT JOIN ADS_ANPHI aa ON aa.ID = at2.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN ADS_SOTHAM_QUYETDINH asq ON asq.ID = at2.MAPID    -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_PHUCTHAM_QUYETDINH aptq ON aptq.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_DON_XULY axl on axl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_SOTHAM_THULY astl on astl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_PHUCTHAM_THULY apttl on apttl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    LEFT JOIN ADS_DON_DUONGSU ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 26/11/2025
   	-- vnpt: 29102025 lay thong tin thoi gian qua thong bao
   	LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 2
   	where a.TONGDATID = vTONGDATID ;
END ADS_TONGDATDOITUONG_GETBYTONGDATID ;

 PROCEDURE ADS_TONGDATDOITUONG_REMOVEBYID(
    vID in Number 
    ,
    returnID out Number
 )
 IS
 BEGIN
    if(vID > 0) then
    delete from ads_tongdat_doituong dt where dt.ID = vID returning
    ID into returnID
    ; 
    end if ;
 END ADS_TONGDATDOITUONG_REMOVEBYID ;

 PROCEDURE ADS_TONGDATDOITUONG_GETNAME(
    vID in Number  ,
    vDUONGSUID in Number , 
    curReturn out SYS_REFCURSOR 
 )
    IS
    BEGIN
    open curReturn for 
        Select ds.TENDUONGSU from ads_tongdat_doituong dt join ads_don_duongsu ds on dt.DUONGSUID = ds.ID  
        where dt.id = vID and dt.DUONGSUID = vDUONGSUID and ROWNUM = 1  ;
    END ADS_TONGDATDOITUONG_GETNAME ;

 PROCEDURE ADS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in Number , 
    curReturn out SYS_REFCURSOR
 )
    IS
     vDUONGSUID NUMBER := 0 ; 
    BEGIN
    select dt.DUONGSUID into vDUONGSUID from ads_tongdat_doituong dt where id = vID ;
    if(vDUONGSUID > 0) then 
        open curReturn for  
          Select ds.TENDUONGSU Ten from ads_tongdat_doituong dt join ads_don_duongsu ds on dt.DUONGSUID = ds.ID  
        where dt.id = vID  ;
    else  
        open curReturn for  
          Select dt.NOINHAN Ten from ads_tongdat_doituong dt where dt.id = vID   ;
    end if;
    END ADS_TONGDATDOITUONG_GETTENDUONGSU;

 PROCEDURE ADS_TONGDATDOITUONG_GETBYTONGDATDUONGSUID(
    vTONGDATID in number ,
    vDUONGSUID in number , 
    curReturn out SYS_REFCURSOR 
 )
 IS
 BEGIN
    open curReturn for 
    Select dt.ID ,
dt.TONGDATID ,
dt.MATUCACH ,
dt.NGAYGUI ,
dt.TRANGTHAI ,
dt.HINHTHUCGUI ,
dt.DUONGSUID ,
dt.NGAYNHANTONGDAT ,
dt.QUOCGIA ,
dt.COQUAN ,
dt.NOIDUNG ,
dt.KETQUAUTTP ,
dt.NGAYPHATHANH ,
dt.NGAYTAO ,
dt.NGUOITAO ,
dt.IS_UTTP ,
dt.UTTP ,
dt.NOINHAN ,
dt.DIACHI  from ads_tongdat_doituong dt where dt.TONGDATID = vTONGDATID and dt.DUONGSUID = vDUONGSUID ;
 END ADS_TONGDATDOITUONG_GETBYTONGDATDUONGSUID ;

PROCEDURE GetTENTCTT_BYMA(
    vID in varchar2,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
        SELECT TEN FROM DM_DATAITEM WHERE MA = vID;
END GetTENTCTT_BYMA;

PROCEDURE ADS_TONGDAT_THUHOI(
    v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2
 )
 IS 
BEGIN
    update ADS_TONGDAT
    set
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    where id = v_id;
    update ads_tongdat_doituong
    set
        TRANGTHAI = 2
    where TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END ADS_TONGDAT_THUHOI;

PROCEDURE ADS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS 
BEGIN
    UPDATE ADS_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE ADS_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END ADS_TONGDAT_THUHOI_DOITUONG;

PROCEDURE ADS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE ADS_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END ADS_TONGDAT_VBDH_DOITUONG;

PROCEDURE ADS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER , 
    curReturn out SYS_REFCURSOR 
)
IS
BEGIN
    open curReturn for
    Select bm.TENBM || CASE WHEN NVL(NVL(NVL(NVL(TO_CHAR(dm.SOTHONGBAO), TO_CHAR(aa.SOTHONGBAO)), TO_CHAR(axl.SOTHONGBAO)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)) IS NOT NULL -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    							THEN '<br/> (Số thông báo: ' || NVL(NVL(NVL(
                                                                    NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU),
                                                                         TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)
                                                                    ),
                                                                    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)
                                                                 ), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO),axl.NGAYTHONGBAO), astl.NGAYTHONGBAO), apttl.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)) IS NOT NULL
                            THEN '<br/> (QĐ: ' || NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptq.NGAYQD, asq.NGAYQD), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM
    	from ads_tongdat td 
    	join dm_bieumau bm on td.BIEUMAUID = bm.ID
    	LEFT JOIN ADS_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN ADS_SOTHAM_QUYETDINH asq ON asq.ID = td.MAPID and td.MAP_TABLE like 'ADS_SOTHAM_QUYETDINH'   -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_PHUCTHAM_QUYETDINH aptq ON aptq.ID = td.MAPID and td.MAP_TABLE like 'ADS_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_DON_XULY axl on axl.ID = td.MAPID and td.MAP_TABLE like 'ADS_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_SOTHAM_THULY astl on astl.ID = td.MAPID and td.MAP_TABLE like 'ADS_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_PHUCTHAM_THULY apttl on apttl.ID = td.MAPID and td.MAP_TABLE like 'ADS_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'ADS_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ADS_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'ADS_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    where td.ID = vTONGDATID ;
END ADS_GETTENBM_BYTONGDATID ; 

 PROCEDURE ADS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER , 
    curReturn out SYS_REFCURSOR 
)
IS
BEGIN
    open curReturn for 
    Select * from ads_tongdat_doituong where id = vID ;
END ADS_TONGDATDOITUONG_GETBYID;

-- Án hôn nhân gia đình
PROCEDURE AHN_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR
        SELECT d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI,
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID,
            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
            NULL AS ANPHI_ID,  NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,  NULL AS MA_THONGBAO, -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
            case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG  -- VNPT Đinh Hoàng Sơn 27/11/2025   xac dinh 
        FROM AHN_DON_DUONGSU d 
            LEFT JOIN DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA  
            left join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL( -- 1/12/2025 vnpt
                NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')),TO_CHAR(astl.SOTHONGBAO)),TO_CHAR(apttl.SOTHONGBAO))
                ,TO_CHAR(aptba.SOBANAN)),TO_CHAR(astba.SOBANAN))  -- 1/12/2025 vnpt
                AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO),astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO) AS NGAYTHONGBAO,
                NVL(aptq.SOQD,asq.SOQD )AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 29/11/2025
				NVL(aptq.NGAYQD,asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 29/11/2025
                af.ID AS FILEID, af.DONID
			FROM
				AHN_FILE af
            LEFT JOIN AHN_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHN_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHN_SOTHAM_THULY astl ON astl.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHN_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AHN_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN AHN_DON_XULY a on af.ID = a.FILEID
            LEFT JOIN AHN_SOTHAM_BANAN astba on af.ID = astba.FILEID  -- 1/12/2025 vnpt
            LEFT JOIN AHN_PHUCTHAM_BANAN aptba on af.ID = aptba.FILEID  -- 1/12/2025 vnpt
    )aff on aff.FILEID = vFileID and aff.DONID = d.DONID
            LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                        FROM AHN_TONGDAT_DOITUONG dt INNER JOIN AHN_TONGDAT t on t.ID = dt.TONGDATID
                        WHERE t.DONID = vDONID AND t.TOAANID = vTOAANID AND t.BIEUMAUID = vBIEUMAUID
                        and ( ---------27/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                                (vFileID > -1 and t.FILEID = vFileID)
                                 or
                                (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                              )
                        ) td on td.DUONGSUID = d.ID
        WHERE d.DONID = vDONID
--        AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.TUCACHTOTUNG_MA = 'NGUYENDON' THEN 1 
--                    WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END)
        AND d.TUCACHTOTUNG_MA IN ('NGUYENDON', 'BIDON')  -- VNPT - Lê Bá Thọ - 26/11/2025 tống đạt chỉ lấy ra nguyên đơn và bị đơn 
          AND (
                (vIsOnlyNKK = 1)
                OR
                (vIsOnlyNKK = 0)
              )
        ORDER BY d.ISDAIDIEN desc, d.TENDUONGSU;
END AHN_TONGDATDOITUONG_GETBY;

-- vnpt hoangndh: sua logic lay grid data man tong dat 29/10/2025 16:00:00
-- Án hôn nhân gia đình
PROCEDURE AHN_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT a.*, NULL AS ANPHI_ID,
     NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU), TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)),
    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)),TO_CHAR(aptq.SOQD)),TO_CHAR(asq.SOQD))
    ,TO_CHAR(aptba.SOBANAN)),TO_CHAR(astba.SOBANAN))
    AS SOTHONGBAO,  NULL AS MA_THONGBAO , at2.MAPID
   	-- vnpt: 29102025 lay thong tin thoi gian qua thong bao
   	, noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG, ads.XACTHUC_DLDCQG  --VNPT Lê BÁ Thọ 27/11/2025 sửa lấy cột XACTHUC_DLDCQG hiển thị VNeID
   	FROM AHN_TONGDAT_DOITUONG a 
        LEFT JOIN AHN_TONGDAT at2 ON a.TONGDATID = at2.id
        LEFT JOIN AHN_DON_DUONGSU ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 27/11/2025
        left join dm_bieumau bm on at2.BIEUMAUID = bm.ID 
    	LEFT JOIN AHN_ANPHI aa ON aa.ID = at2.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 29/11/2025 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 29/11/2025 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AHN_SOTHAM_QUYETDINH asq ON asq.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_SOTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_QUYETDINH aptq ON aptq.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_DON_XULY axl on axl.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_SOTHAM_THULY astl on astl.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_THULY apttl on apttl.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_SOTHAM_BANAN astba on astba.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_BANAN aptba on aptba.ID = at2.MAPID and at2.MAP_TABLE like 'AHN_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
   	LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 3
  	WHERE a.TONGDATID = vTONGDATID;
END AHN_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE AHN_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE AHN_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE AHN_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END AHN_TONGDAT_THUHOI;

PROCEDURE AHN_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE AHN_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE AHN_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END AHN_TONGDAT_THUHOI_DOITUONG;

PROCEDURE AHN_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE AHN_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END AHN_TONGDAT_VBDH_DOITUONG;

PROCEDURE AHN_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        DONID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM AHN_TONGDAT
        WHERE ID = vID;
END AHN_TONGDAT_GETBYID;

PROCEDURE AHN_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
    SELECT dt.DUONGSUID INTO vDUONGSUID FROM AHN_TONGDAT_DOITUONG dt WHERE ID = vID;
    if(vDUONGSUID > 0) THEN
        OPEN curReturn FOR  
        SELECT ds.TENDUONGSU Ten FROM AHN_TONGDAT_DOITUONG dt JOIN AHN_DON_DUONGSU ds on dt.DUONGSUID = ds.ID
        WHERE dt.ID = vID;
    else
        OPEN curReturn FOR
          SELECT dt.NOINHAN Ten FROM AHN_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
    end if;
END AHN_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE AHN_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM AHN_TONGDAT_DOITUONG WHERE ID = vID;
END AHN_TONGDATDOITUONG_GETBYID;

PROCEDURE AHN_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM AHN_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END AHN_TONGDATDOITUONG_REMOVEBYID;
PROCEDURE AHN_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE AHN_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO AHN_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA,TOA_GIAIQUYET_ID)
        VALUES (AHN_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1,v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
    end if;
END AHN_TONGDATNOINHAN_UP_IN;

PROCEDURE AHN_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    Select bm.TENBM || CASE WHEN NVL(NVL(NVL(NVL(TO_CHAR(dm.SOTHONGBAO), TO_CHAR(aa.SOTHONGBAO)), TO_CHAR(axl.SOTHONGBAO)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)) IS NOT NULL -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    							THEN '<br/> (Số thông báo: ' || NVL(NVL(NVL(
                                                                    NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU),
                                                                         TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)
                                                                    ),
                                                                    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)
                                                                 ), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO),axl.NGAYTHONGBAO), astl.NGAYTHONGBAO), apttl.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)) IS NOT NULL
                            THEN '<br/> (QĐ: ' || NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptq.NGAYQD, asq.NGAYQD), 'DD/MM/YYYY') || ')'
                             when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM

    from AHN_TONGDAT td 
    	JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
    	LEFT JOIN AHN_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 3 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AHN_SOTHAM_QUYETDINH asq ON asq.ID = td.MAPID and td.MAP_TABLE like 'AHN_SOTHAM_QUYETDINH'   -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_QUYETDINH aptq ON aptq.ID = td.MAPID and td.MAP_TABLE like 'AHN_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_DON_XULY axl on axl.ID = td.MAPID and td.MAP_TABLE like 'AHN_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_SOTHAM_THULY astl on astl.ID = td.MAPID and td.MAP_TABLE like 'AHN_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_THULY apttl on apttl.ID = td.MAPID and td.MAP_TABLE like 'AHN_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'AHN_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHN_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'AHN_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    WHERE td.ID = vTONGDATID;
END AHN_GETTENBM_BYTONGDATID;

PROCEDURE AHN_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER,
    v_MAP_TABLE IN varchar2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE AHN_TONGDAT
        SET DONID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE,
            MAPID = v_MAPID
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
     SELECT COUNT(*) INTO V_COUNT FROM AHN_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID  AND MAPID = v_MAPID; 
            IF(V_COUNT=0)THEN
        INSERT INTO AHN_TONGDAT (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
            TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE, MAPID, MAP_TABLE,TOA_GIAIQUYET_ID)
        VALUES (AHN_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
            v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
            v_LYDOTHUHOI,v_URL_FILE,  v_MAPID, v_MAP_TABLE,v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
         end if;
     end if;
END AHN_TONGDAT_UP_IN;

-- Án kinh doanh thương mại
PROCEDURE AKT_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR
        SELECT d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI, 
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID,
            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
            NULL AS ANPHI_ID,  NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,  NULL AS MA_THONGBAO, -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
            case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG  -- VNPT Đinh Hoàng Sơn 25/11/2025   xac dinh xacthuc_dldcqg
        FROM AKT_DON_DUONGSU d 
            LEFT JOIN DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA 
             left join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(
				NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')),TO_CHAR(astl.SOTHONGBAO)),TO_CHAR(apttl.SOTHONGBAO))
                ,TO_CHAR(astba.SOBANAN)),TO_CHAR(aptba.SOBANAN))
                AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO),astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO) AS NGAYTHONGBAO,
                NVL(aptq.SOQD,asq.SOQD )AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 29/11/2025
				NVL(aptq.NGAYQD,asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 29/11/2025
                af.ID AS FILEID, af.DONID
			FROM
				AKT_FILE af
            LEFT JOIN AKT_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AKT_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AKT_SOTHAM_THULY astl ON astl.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AKT_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AKT_SOTHAM_BANAN astba ON astba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
            LEFT JOIN AKT_PHUCTHAM_BANAN aptba ON aptba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AKT_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN AKT_DON_XULY a on af.ID = a.FILEID
    )aff on aff.FILEID = vFileID and aff.DONID = d.DONID
            LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                        FROM AKT_TONGDAT_DOITUONG dt INNER JOIN AKT_TONGDAT t on t.ID = dt.TONGDATID
                        WHERE t.DONID = vDONID AND t.TOAANID = vTOAANID AND t.BIEUMAUID = vBIEUMAUID
                         and ( ---------27/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                    (vFileID > -1 and t.FILEID = vFileID)
                     or
                    (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                  )
                        ) td on td.DUONGSUID = d.ID
        WHERE d.DONID = vDONID
--        AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.TUCACHTOTUNG_MA = 'NGUYENDON' THEN 1 
--                    WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END)
AND d.TUCACHTOTUNG_MA IN ('NGUYENDON', 'BIDON')  -- VNPT - Lê Bá Thọ - 26/11/2025 tống đạt chỉ lấy ra nguyên đơn và bị đơn 
          AND (
                (vIsOnlyNKK = 1)
                OR
                (vIsOnlyNKK = 0)
              )
        ORDER BY d.ISDAIDIEN desc, d.TENDUONGSU;
END AKT_TONGDATDOITUONG_GETBY;

-- vnpt quanvv: sua logic lay grid data man tong dat 03/11/2025 16:00:00
PROCEDURE AKT_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT  a.*, NULL AS ANPHI_ID,
    NVL(NVL(NVL(NVL(NVL(NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU), TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)),
    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)),TO_CHAR(aptq.SOQD)),TO_CHAR(asq.SOQD))
    AS SOTHONGBAO,  NULL AS MA_THONGBAO , at2.MAPID
    , noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG,ads.XACTHUC_DLDCQG  --VNPT Lê BÁ Thọ 27/11/2025 sửa lấy cột XACTHUC_DLDCQG hiển thị VNeID
   	FROM AKT_TONGDAT_DOITUONG a 
   	LEFT JOIN AKT_TONGDAT at2 ON a.TONGDATID = at2.id
    left join dm_bieumau bm on at2.BIEUMAUID = bm.ID
    	LEFT JOIN AKT_ANPHI aa ON aa.ID = at2.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AKT_SOTHAM_QUYETDINH asq ON asq.ID = at2.MAPID    -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_PHUCTHAM_QUYETDINH aptq ON aptq.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_DON_XULY axl on axl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_SOTHAM_THULY astl on astl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_PHUCTHAM_THULY apttl on apttl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    LEFT JOIN AKT_DON_DUONGSU ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 27/11/2025
   	 -- vnpt quanvv: 03112025 lay thong tin thoi gian qua thong bao
    LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 4
  	WHERE a.TONGDATID = vTONGDATID;
END AKT_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE AKT_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE AKT_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE AKT_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END AKT_TONGDAT_THUHOI;

PROCEDURE AKT_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE AKT_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE AKT_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END AKT_TONGDAT_THUHOI_DOITUONG;

PROCEDURE AKT_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE AKT_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END AKT_TONGDAT_VBDH_DOITUONG;

PROCEDURE AKT_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        DONID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM AKT_TONGDAT
        WHERE ID = vID;
END AKT_TONGDAT_GETBYID;

PROCEDURE AKT_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
    SELECT dt.DUONGSUID INTO vDUONGSUID FROM AKT_TONGDAT_DOITUONG dt WHERE ID = vID;
    if(vDUONGSUID > 0) THEN
        OPEN curReturn FOR  
        SELECT ds.TENDUONGSU Ten FROM AKT_TONGDAT_DOITUONG dt JOIN AKT_DON_DUONGSU ds on dt.DUONGSUID = ds.ID
        WHERE dt.ID = vID;
    else
        OPEN curReturn FOR
          SELECT dt.NOINHAN Ten FROM AKT_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
    end if;
END AKT_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE AKT_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM AKT_TONGDAT_DOITUONG WHERE ID = vID;
END AKT_TONGDATDOITUONG_GETBYID;

PROCEDURE AKT_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM AKT_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END AKT_TONGDATDOITUONG_REMOVEBYID;


PROCEDURE AKT_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE AKT_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO AKT_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA,TOA_GIAIQUYET_ID)
        VALUES (AKT_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1,v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
    end if;
END AKT_TONGDATNOINHAN_UP_IN;

PROCEDURE AKT_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
   Select bm.TENBM || CASE WHEN NVL(NVL(NVL(NVL(TO_CHAR(dm.SOTHONGBAO), TO_CHAR(aa.SOTHONGBAO)), TO_CHAR(axl.SOTHONGBAO)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)) IS NOT NULL -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    							THEN '<br/> (Số thông báo: ' || NVL(NVL(NVL(
                                                                    NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU),
                                                                         TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)
                                                                    ),
                                                                    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)
                                                                 ), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO),axl.NGAYTHONGBAO), astl.NGAYTHONGBAO), apttl.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)) IS NOT NULL
                            THEN '<br/> (QĐ: ' || NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptq.NGAYQD, asq.NGAYQD), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM
    	from AKT_TONGDAT td 
    	JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
    	LEFT JOIN AKT_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 4 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AKT_SOTHAM_QUYETDINH asq ON asq.ID = td.MAPID and td.MAP_TABLE like 'AKT_SOTHAM_QUYETDINH'   -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_PHUCTHAM_QUYETDINH aptq ON aptq.ID = td.MAPID and td.MAP_TABLE like 'AKT_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_DON_XULY axl on axl.ID = td.MAPID and td.MAP_TABLE like 'AKT_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_SOTHAM_THULY astl on astl.ID = td.MAPID and td.MAP_TABLE like 'AKT_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_PHUCTHAM_THULY apttl on apttl.ID = td.MAPID and td.MAP_TABLE like 'AKT_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'AKT_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AKT_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'AKT_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    WHERE td.ID = vTONGDATID;
END AKT_GETTENBM_BYTONGDATID;


PROCEDURE AKT_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE AKT_TONGDAT
        SET DONID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE, 
            MAPID = v_MAPID -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
     SELECT COUNT(*) INTO V_COUNT FROM AKT_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID AND MAPID = v_MAPID; 
            IF(V_COUNT=0)THEN
        INSERT INTO AKT_TONGDAT (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
            TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE,MAPID,MAP_TABLE,TOA_GIAIQUYET_ID) -- VNPT 25/06/2025 thêm tham số MAPID,MAP_TABLE INSERT tống đạt miễn án phí
        VALUES (AKT_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
            v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
            v_LYDOTHUHOI,v_URL_FILE,v_MAPID,v_MAP_TABLE,v_TOA_GIAIQUYET_ID) -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
        RETURNING ID INTO vID;
        end if;
    end if;
END AKT_TONGDAT_UP_IN;

-- Án lao động
PROCEDURE ALD_TONGDATDOITUONG_GETBY(
    vDonID in Decimal , 
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR
        SELECT d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI,
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID,
            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
            NULL AS ANPHI_ID,  NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,  NULL AS MA_THONGBAO, -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
            case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG  -- VNPT Đinh Hoàng Sơn 25/11/2025   xac dinh xacthuc_dldcqg
        FROM ALD_DON_DUONGSU d 
            LEFT JOIN DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA  
            left join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
                NVL(NVL(
				NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')),TO_CHAR(astl.SOTHONGBAO)),TO_CHAR(apttl.SOTHONGBAO))
                ,TO_CHAR(astba.SOBANAN)),TO_CHAR(aptba.SOBANAN))
                AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO),astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO) AS NGAYTHONGBAO,
                NVL(aptq.SOQD,asq.SOQD )AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 29/11/2025
				NVL(aptq.NGAYQD,asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 29/11/2025
                af.ID AS FILEID, af.DONID
			FROM
				ALD_FILE af
            LEFT JOIN ALD_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN ALD_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN ALD_SOTHAM_THULY astl ON astl.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN ALD_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN ALD_SOTHAM_BANAN astba ON astba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
            LEFT JOIN ALD_PHUCTHAM_BANAN aptba ON aptba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN ALD_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN ALD_DON_XULY a on af.ID = a.FILEID
    )aff on aff.FILEID = vFileID and aff.DONID = d.DONID
            LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                        FROM ALD_TONGDAT_DOITUONG dt INNER JOIN ALD_TONGDAT t on t.ID = dt.TONGDATID
                        WHERE t.DONID = vDONID AND t.TOAANID = vTOAANID AND t.BIEUMAUID = vBIEUMAUID
                         and ( ---------27/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                    (vFileID > -1 and t.FILEID = vFileID)
                     or
                    (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                    )
                        ) td on td.DUONGSUID = d.ID
        WHERE d.DONID = vDONID
--        AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.TUCACHTOTUNG_MA = 'NGUYENDON' THEN 1 
--                    WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END)
AND d.TUCACHTOTUNG_MA IN ('NGUYENDON', 'BIDON')  -- VNPT - Lê Bá Thọ - 26/11/2025 tống đạt chỉ lấy ra nguyên đơn và bị đơn 
            AND (
                    (vIsOnlyNKK = 1)
                    OR
                    (vIsOnlyNKK = 0)
                )
        ORDER BY d.ISDAIDIEN desc, d.TENDUONGSU;
END ALD_TONGDATDOITUONG_GETBY;

-- vnpt quanvv: sua logic lay grid data man tong dat 03/11/2025 16:00:00
PROCEDURE ALD_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT a.*,NULL AS ANPHI_ID, 
    NVL(NVL(NVL(NVL(NVL(NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU), TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)),
    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)),TO_CHAR(aptq.SOQD)),TO_CHAR(asq.SOQD))
    AS SOTHONGBAO,  NULL AS MA_THONGBAO , at2.MAPID
    , noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG,ads.XACTHUC_DLDCQG  --VNPT Lê BÁ Thọ 26/11/2025 sửa lấy cột XACTHUC_DLDCQG hiển thị VNeID
   	FROM ALD_TONGDAT_DOITUONG a 
   	LEFT JOIN ALD_TONGDAT at2 ON a.TONGDATID = at2.id
          left join dm_bieumau bm on at2.BIEUMAUID = bm.ID
    	LEFT JOIN ALD_ANPHI aa ON aa.ID = at2.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN ALD_SOTHAM_QUYETDINH asq ON asq.ID = at2.MAPID    -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_PHUCTHAM_QUYETDINH aptq ON aptq.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_DON_XULY axl on axl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_SOTHAM_THULY astl on astl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_PHUCTHAM_THULY apttl on apttl.ID = at2.MAPID -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    LEFT JOIN ALD_DON_DUONGSU ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 26/11/2025
   	-- vnpt: 29102025 lay thong tin thoi gian qua thong bao
    LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 5
   	WHERE a.TONGDATID = vTONGDATID;
END ALD_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE ALD_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE ALD_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE ALD_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END ALD_TONGDAT_THUHOI;

PROCEDURE ALD_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE ALD_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE ALD_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END ALD_TONGDAT_THUHOI_DOITUONG;

PROCEDURE ALD_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE ALD_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END ALD_TONGDAT_VBDH_DOITUONG;

PROCEDURE ALD_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        DONID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM ALD_TONGDAT
        WHERE ID = vID;
END ALD_TONGDAT_GETBYID;

PROCEDURE ALD_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
    SELECT dt.DUONGSUID INTO vDUONGSUID FROM ALD_TONGDAT_DOITUONG dt WHERE ID = vID;
    if(vDUONGSUID > 0) THEN
        OPEN curReturn FOR  
        SELECT ds.TENDUONGSU Ten FROM ALD_TONGDAT_DOITUONG dt JOIN ALD_DON_DUONGSU ds on dt.DUONGSUID = ds.ID
        WHERE dt.ID = vID;
    else
        OPEN curReturn FOR
          SELECT dt.NOINHAN Ten FROM ALD_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
    end if;
END ALD_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE ALD_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM ALD_TONGDAT_DOITUONG WHERE ID = vID;
END ALD_TONGDATDOITUONG_GETBYID;

PROCEDURE ALD_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM ALD_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END ALD_TONGDATDOITUONG_REMOVEBYID;

PROCEDURE ALD_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE ALD_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO ALD_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA, TOA_GIAIQUYET_ID)
        VALUES (ALD_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1, v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
    end if;
END ALD_TONGDATNOINHAN_UP_IN;

PROCEDURE ALD_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
  Select bm.TENBM || CASE WHEN NVL(NVL(NVL(NVL(TO_CHAR(dm.SOTHONGBAO), TO_CHAR(aa.SOTHONGBAO)), TO_CHAR(axl.SOTHONGBAO)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)) IS NOT NULL -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    							THEN '<br/> (Số thông báo: ' || NVL(NVL(NVL(
                                                                    NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU),
                                                                         TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)
                                                                    ),
                                                                    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)
                                                                 ), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO),axl.NGAYTHONGBAO), astl.NGAYTHONGBAO), apttl.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)) IS NOT NULL
                            THEN '<br/> (QĐ: ' || NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptq.NGAYQD, asq.NGAYQD), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM
    from ALD_TONGDAT td 
    JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
    LEFT JOIN ALD_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 5 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    LEFT JOIN ALD_SOTHAM_QUYETDINH asq ON asq.ID = td.MAPID and td.MAP_TABLE like 'ALD_SOTHAM_QUYETDINH'   -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_PHUCTHAM_QUYETDINH aptq ON aptq.ID = td.MAPID and td.MAP_TABLE like 'ALD_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_DON_XULY axl on axl.ID = td.MAPID and td.MAP_TABLE like 'ALD_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_SOTHAM_THULY astl on astl.ID = td.MAPID and td.MAP_TABLE like 'ALD_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_PHUCTHAM_THULY apttl on apttl.ID = td.MAPID and td.MAP_TABLE like 'ALD_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'ALD_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN ALD_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'ALD_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    WHERE td.ID = vTONGDATID;
END ALD_GETTENBM_BYTONGDATID;

PROCEDURE ALD_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE ALD_TONGDAT
        SET DONID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE,
            MAPID = v_MAPID
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
     SELECT COUNT(*) INTO V_COUNT FROM ALD_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID AND MAPID = v_MAPID; 
            IF(V_COUNT=0)THEN
                INSERT INTO ALD_TONGDAT (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
                    TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE, MAPID,MAP_TABLE,TOA_GIAIQUYET_ID)
                VALUES (ALD_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
                    v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
                    v_LYDOTHUHOI,v_URL_FILE, v_MAPID, v_MAP_TABLE,v_TOA_GIAIQUYET_ID)
                RETURNING ID INTO vID;
           end if;      
    end if;
END ALD_TONGDAT_UP_IN;

-- Án hành chính
PROCEDURE AHC_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR
        SELECT d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI, 
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID,
            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
            NULL AS ANPHI_ID,  NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,  NULL AS MA_THONGBAO, -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
            case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG  -- VNPT Đinh Hoàng Sơn 25/11/2025   xac dinh xacthuc_dldcqg
        FROM AHC_DON_DUONGSU d 
            LEFT JOIN DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA 
             left join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')),TO_CHAR(astl.SOTHONGBAO)),TO_CHAR(apttl.SOTHONGBAO))
                ,TO_CHAR(aptba.SOBANAN)),TO_CHAR(astba.SOBANAN))
                AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO),astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO) AS NGAYTHONGBAO,
                NVL(NVL(aptq.SOQD,asq.SOQD ),apqdtdc.SOQD)AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 29/11/2025
				NVL(NVL(aptq.NGAYQD,asq.NGAYQD),apqdtdc.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 29/11/2025
                af.ID AS FILEID, af.DONID
			FROM
				AHC_FILE af
            LEFT JOIN AHC_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHC_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHC_SOTHAM_THULY astl ON astl.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHC_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHC_KCKNQDK_PHUCTHAM_QUYETDINH apqdtdc ON apqdtdc.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AHC_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 6
            LEFT JOIN AHC_DON_XULY a on af.ID = a.FILEID
            LEFT JOIN AHC_SOTHAM_BANAN astba ON astba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
            LEFT JOIN AHC_PHUCTHAM_BANAN aptba ON aptba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 5/12/2025
    )aff on aff.FILEID = vFileID and aff.DONID = d.DONID
            LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                        FROM AHC_TONGDAT_DOITUONG dt INNER JOIN AHC_TONGDAT t on t.ID = dt.TONGDATID
                        WHERE t.DONID = vDONID AND t.TOAANID = vTOAANID AND t.BIEUMAUID = vBIEUMAUID
                        and ( ---------27/11/2025---- Đinh Hoàng Sơn vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                                (vFileID > -1 and t.FILEID = vFileID)
                                 or
                                (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                              )
                        ) td on td.DUONGSUID = d.ID
        WHERE d.DONID = vDONID
--        AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.TUCACHTOTUNG_MA = 'NGUYENDON' THEN 1 
--                    WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END)
    AND d.TUCACHTOTUNG_MA IN ('NGUYENDON', 'BIDON')  -- VNPT - Lê Bá Thọ - 26/11/2025 tống đạt chỉ lấy ra nguyên đơn và bị đơn 
            AND (
                    (vIsOnlyNKK = 1)
                    OR
                    (vIsOnlyNKK = 0)
                )
        ORDER BY d.ISDAIDIEN desc, d.TENDUONGSU;
END AHC_TONGDATDOITUONG_GETBY;

-- vnpt quanvv: sua logic lay grid data man tong dat 03/11/2025 16:00:00
PROCEDURE AHC_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT a.*, NULL AS ANPHI_ID,
    NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL(NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU), TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)),
    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)),TO_CHAR(aptq.SOQD)),TO_CHAR(asq.SOQD))
    ,TO_CHAR(aptba.SOBANAN)),TO_CHAR(astba.SOBANAN)),TO_CHAR(apqdtdc.SOQD))
    AS SOTHONGBAO,  NULL AS MA_THONGBAO , at2.MAPID
    , noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG, ads.XACTHUC_DLDCQG  --VNPT Lê BÁ Thọ 26/11/2025 sửa lấy cột XACTHUC_DLDCQG hiển thị VNeID
   	FROM AHC_TONGDAT_DOITUONG a 
   	LEFT JOIN AHC_TONGDAT at2 ON a.TONGDATID = at2.id
     left join dm_bieumau bm on at2.BIEUMAUID = bm.ID
    	LEFT JOIN AHC_ANPHI aa ON aa.ID = at2.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    	LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 2 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AHC_SOTHAM_QUYETDINH asq ON asq.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_SOTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_QUYETDINH aptq ON aptq.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_DON_XULY axl on axl.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_SOTHAM_THULY astl on astl.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_THULY apttl on apttl.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_SOTHAM_BANAN astba on astba.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_BANAN aptba on aptba.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_QUYETDINH apqdtdc on apqdtdc.ID = at2.MAPID and at2.MAP_TABLE like 'AHC_KCKNQDK_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    LEFT JOIN AHC_DON_DUONGSU ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 26/11/2025
   	-- vnpt: 29102025 lay thong tin thoi gian qua thong bao
   	LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 6
   	WHERE a.TONGDATID = vTONGDATID;
END AHC_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE AHC_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE AHC_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE AHC_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END AHC_TONGDAT_THUHOI;

PROCEDURE AHC_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE AHC_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE AHC_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END AHC_TONGDAT_THUHOI_DOITUONG;

PROCEDURE AHC_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE AHC_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END AHC_TONGDAT_VBDH_DOITUONG;

PROCEDURE AHC_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        DONID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM AHC_TONGDAT
        WHERE ID = vID;
END AHC_TONGDAT_GETBYID;

PROCEDURE AHC_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
    SELECT dt.DUONGSUID INTO vDUONGSUID FROM AHC_TONGDAT_DOITUONG dt WHERE ID = vID;
    if(vDUONGSUID > 0) THEN
        OPEN curReturn FOR  
        SELECT ds.TENDUONGSU Ten FROM AHC_TONGDAT_DOITUONG dt JOIN AHC_DON_DUONGSU ds on dt.DUONGSUID = ds.ID
        WHERE dt.ID = vID;
    else
        OPEN curReturn FOR
          SELECT dt.NOINHAN Ten FROM AHC_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
    end if;
END AHC_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE AHC_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM AHC_TONGDAT_DOITUONG WHERE ID = vID;
END AHC_TONGDATDOITUONG_GETBYID;

PROCEDURE AHC_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM AHC_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END AHC_TONGDATDOITUONG_REMOVEBYID;

PROCEDURE AHC_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE AHC_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO AHC_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA,TOA_GIAIQUYET_ID)
        VALUES (AHC_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1,v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
    end if;
END AHC_TONGDATNOINHAN_UP_IN;

PROCEDURE AHC_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
      Select bm.TENBM || CASE WHEN NVL(NVL(NVL(NVL(TO_CHAR(dm.SOTHONGBAO), TO_CHAR(aa.SOTHONGBAO)), TO_CHAR(axl.SOTHONGBAO)), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)) IS NOT NULL -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    							THEN '<br/> (Số thông báo: ' || NVL(NVL(NVL(
                                                                    NVL( TO_CHAR(dm.SOTHONGBAO) || TO_CHAR(dm.STB_PHU),
                                                                         TO_CHAR(aa.SOTHONGBAO) || TO_CHAR(aa.STB_PHU)
                                                                    ),
                                                                    TO_CHAR(axl.SOTHONGBAO) || TO_CHAR(axl.STB_PHU)
                                                                 ), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO),axl.NGAYTHONGBAO), astl.NGAYTHONGBAO), apttl.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
                            when NVL(NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)),TO_CHAR(apqdtdc.SOQD)) IS NOT NULL
                            THEN '<br/> (QĐ: ' || NVL(NVL(TO_CHAR(aptq.SOQD), TO_CHAR(asq.SOQD)),TO_CHAR(apqdtdc.SOQD))
                                || ' - Ngày: ' || TO_CHAR(NVL(NVL(aptq.NGAYQD, asq.NGAYQD),apqdtdc.NGAYQD), 'DD/MM/YYYY') || ')'
                             when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM
    from AHC_TONGDAT td 
    JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
    LEFT JOIN AHC_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 6 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
        LEFT JOIN AHC_SOTHAM_QUYETDINH asq ON asq.ID = td.MAPID and td.MAP_TABLE like 'AHC_SOTHAM_QUYETDINH'   -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_QUYETDINH aptq ON aptq.ID = td.MAPID and td.MAP_TABLE like 'AHC_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_DON_XULY axl on axl.ID = td.MAPID and td.MAP_TABLE like 'AHC_DON_XULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_SOTHAM_THULY astl on astl.ID = td.MAPID and td.MAP_TABLE like 'AHC_SOTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_THULY apttl on apttl.ID = td.MAPID and td.MAP_TABLE like 'AHC_PHUCTHAM_THULY' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'AHC_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'AHC_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_QUYETDINH apqdtdc on apqdtdc.ID = td.MAPID and td.MAP_TABLE like 'AHC_KCKNQDK_PHUCTHAM_QUYETDINH' -- VNPT - Lê Bá Thọ 5/12/2025 lấy Số quyết định và ngày quyết định
    WHERE td.ID = vTONGDATID;
END AHC_GETTENBM_BYTONGDATID;

PROCEDURE AHC_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE AHC_TONGDAT
        SET DONID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE,
            MAPID = v_MAPID
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
      SELECT COUNT(*) INTO V_COUNT FROM AHC_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID  AND MAPID = v_MAPID; 
                    IF(V_COUNT=0)THEN
                INSERT INTO AHC_TONGDAT (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
                    TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE, MAPID,MAP_TABLE,TOA_GIAIQUYET_ID)
                VALUES (AHC_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
                    v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
                    v_LYDOTHUHOI,v_URL_FILE,  v_MAPID, v_MAP_TABLE,v_TOA_GIAIQUYET_ID)
                RETURNING ID INTO vID;
             end if;    
    end if;
END AHC_TONGDAT_UP_IN;

-- Án phá sản
PROCEDURE APS_TONGDATDOITUONG_GETBY(
    vDonID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    curReturn out SYS_REFCURSOR)
IS 
BEGIN 
    OPEN curReturn FOR
        SELECT d.ID, d.TENDUONGSU, d.TUCACHTOTUNG_MA, i.TEN as TENTCTT, td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI,
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRUID = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRUID)) AS DIACHI,
            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, d.ID DUONGSUID, td.BIEUMAUID,
            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG,
            NULL AS ANPHI_ID,  NULL AS SOTHONGBAO,  NULL AS MA_THONGBAO -- VNPT 16/06/2025 thêm trường trả về với trường hợp không phải án phí
        FROM APS_DON_DUONGSU d 
            LEFT JOIN DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA  
            LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                        FROM APS_TONGDAT_DOITUONG dt INNER JOIN APS_TONGDAT t on t.ID = dt.TONGDATID
                        WHERE t.DONID = vDONID AND t.TOAANID = vTOAANID AND t.BIEUMAUID = vBIEUMAUID
                        ) td on td.DUONGSUID = d.ID
        WHERE d.DONID = vDONID
        AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.TUCACHTOTUNG_MA = 'NGUYENDON' THEN 1 
                    WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END)
        ORDER BY d.ISDAIDIEN desc, d.TENDUONGSU;
END APS_TONGDATDOITUONG_GETBY;

PROCEDURE APS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT a.*, NULL AS ANPHI_ID,  NULL AS SOTHONGBAO,  NULL AS MA_THONGBAO, at2.MAPID 
   	FROM APS_TONGDAT_DOITUONG a
   	LEFT JOIN APS_TONGDAT at2 ON a.TONGDATID = at2.id
   	WHERE TONGDATID = vTONGDATID;
END APS_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE APS_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE APS_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE APS_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END APS_TONGDAT_THUHOI;

PROCEDURE APS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE APS_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE APS_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END APS_TONGDAT_THUHOI_DOITUONG;

PROCEDURE APS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE APS_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END APS_TONGDAT_VBDH_DOITUONG;

PROCEDURE APS_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        DONID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM APS_TONGDAT
        WHERE ID = vID;
END APS_TONGDAT_GETBYID;

PROCEDURE APS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
    SELECT dt.DUONGSUID INTO vDUONGSUID FROM APS_TONGDAT_DOITUONG dt WHERE ID = vID;
    if(vDUONGSUID > 0) THEN
        OPEN curReturn FOR  
        SELECT ds.TENDUONGSU Ten FROM APS_TONGDAT_DOITUONG dt JOIN APS_DON_DUONGSU ds on dt.DUONGSUID = ds.ID
        WHERE dt.ID = vID;
    else
        OPEN curReturn FOR
          SELECT dt.NOINHAN Ten FROM APS_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
    end if;
END APS_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE APS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM APS_TONGDAT_DOITUONG WHERE ID = vID;
END APS_TONGDATDOITUONG_GETBYID;

PROCEDURE APS_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM APS_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END APS_TONGDATDOITUONG_REMOVEBYID;

PROCEDURE APS_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE APS_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO APS_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA)
        VALUES (APS_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1)
        RETURNING ID INTO vID;
    end if;
END APS_TONGDATNOINHAN_UP_IN;

PROCEDURE APS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT bm.TENBM || CASE WHEN NVL(dm.SOTHONGBAO, aa.SOTHONGBAO) IS NOT NULL 
    							THEN ' (Số thông báo: ' || NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU) || ' - Ngày: ' || TO_CHAR(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), 'DD/MM/YYYY') || ')'
    					END AS TENBM
    from APS_TONGDAT td 
    JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
    LEFT JOIN APS_ANPHI aa ON aa.ID = td.MAPID AND aa.MAGIAIDOAN = 2 AND bm.MABM = '100-DS' -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    LEFT JOIN DON_MIENANPHI dm ON dm.ANPHI_ID = aa.ID AND dm.LOAIAN = 7 -- VNPT 24/06/2026 lấy thông tin số thông báo, ngày thông báo
    WHERE td.ID = vTONGDATID;
END APS_GETTENBM_BYTONGDATID;

PROCEDURE APS_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    v_MAP_TABLE IN varchar2, -- VNPT 25/06/2025 thêm tham số INSERT tống đạt miễn án phí
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE APS_TONGDAT
        SET DONID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE,
            MAPID = v_MAPID
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
      SELECT COUNT(*) INTO V_COUNT FROM APS_TONGDAT WHERE DONID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID  AND MAPID = v_MAPID; 
            IF(V_COUNT=0)THEN
                INSERT INTO APS_TONGDAT (id,DONID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
                    TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE, MAPID,MAP_TABLE)
                VALUES (APS_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
                    v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
                    v_LYDOTHUHOI,v_URL_FILE,  v_MAPID, v_MAP_TABLE)
                RETURNING ID INTO vID;
            end if;     
    end if;
END APS_TONGDAT_UP_IN;

-- Án hình sự
PROCEDURE AHS_TONGDATDOITUONG_GETBY(
    vVuAnID in Decimal ,
    vToaAnID in Decimal , 
    vBieuMauID in Decimal ,
    vIsOnLyNKK in Decimal ,
    vFileID in Decimal,
    curReturn out SYS_REFCURSOR)
IS
    vGroupID number;
BEGIN
        SELECT ID INTO vGroupID FROM DM_DATAGROUP WHERE MA = 'TUCACHTGTTHS';
    OPEN curReturn FOR
        SELECT d.ID, d.HOTEN as TENDUONGSU,
            CASE d.BICANDAUVU WHEN 1 THEN u'BICANDAUVU'
                            WHEN 0 THEN u'BICAN' END as TUCACHTOTUNG_MA,
            CASE d.BICANDAUVU WHEN 1 THEN u'B\1ecb can \0111\1ea7u v\1ee5'
                            WHEN 0 THEN u'B\1ecb can' END as TENTCTT, 
            tdbc.NGAYGUI, tdbc.TRANGTHAI, tdbc.HINHTHUCGUI,
            (d.TAMTRUCHITIET || 
                (CASE WHEN d.TAMTRUCHITIET IS NULL OR d.TAMTRU_HUYEN = 0 THEN '' ELSE ', ' END) || 
                (SELECT MA_TEN FROM DM_HANHCHINH WHERE ID = d.TAMTRU_HUYEN)) AS DIACHI,
            tdbc.NGAYPHATHANH, tdbc.IS_UTTP, tdbc.UTTP, tdbc.NOINHAN, d.ID DUONGSUID, tdbc.BIEUMAUID,
            tdbc.NGAYNHANTONGDAT, tdbc.QUOCGIA, tdbc.COQUAN, tdbc.NOIDUNG, tdbc.KETQUAUTTP, tdbc.ID TONGDAT_DOITUONG
            , NVL(aff.SOTHONGBAO,aff.SOQUYETDINH) AS SOTHONGBAO,   case when d.XACTHUC_DLDCQG = 1 then 1 else 0 end AS XACTHUC_DLDCQG  -- VNPT 27/11/2025   xac dinh 
        FROM AHS_BICANBICAO d 
        left join (SELECT
				 BIEUMAUID,
				NVL(NVL(NVL( -- 1/12/2025 vnpt
                TO_CHAR(aptba.SOBANAN),TO_CHAR(astba.SOBANAN)),TO_CHAR(aptq.SOQUYETDINH)),TO_CHAR(asq.SOQUYETDINH))
                -- 1/12/2025 vnpt
                AS SOTHONGBAO,
                NVL(aptq.SOQUYETDINH,asq.SOQUYETDINH) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 29/11/2025
				--NVL(aptq.NGAYQD,asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 29/11/2025
                af.ID AS FILEID, af.VUANID
			FROM
				AHS_FILE af
            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHS_SOTHAM_BANAN astba on af.ID = astba.FILEID  -- 1/12/2025 vnpt
            LEFT JOIN AHS_PHUCTHAM_BANAN aptba on af.ID = aptba.FILEID  -- 1/12/2025 vnpt
        )aff on aff.FILEID = vFileID and aff.VUANID = d.VUANID
        LEFT JOIN (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
                  FROM AHS_TONGDAT_DOITUONG dt
                  INNER JOIN AHS_TONGDAT t ON t.ID = dt.TONGDATID
                  WHERE t.VUANID = vVuAnID AND t.TOAANID = vToaAnID AND t.BIEUMAUID = vBieuMauID
                  and ( ---------27/11/2025---- vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
                                (vFileID > -1 and t.FILEID = vFileID)
                                 or
                                (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
                              )
                  ) tdbc on tdbc.DUONGSUID = d.ID
        WHERE d.VUANID = vVuAnID
            AND 1 = (CASE WHEN vIsOnlyNKK = 1 AND d.BICANDAUVU = 1 THEN 1 WHEN vIsOnlyNKK = 0 THEN 1 ELSE 0 END);
          -- vnpt 3/12/2025  chi lay bi can bi cao
--        UNION ALL
--        SELECT a.ID, a.HOTEN as TENDUONGSU, tc_ten.MA as TUCACHTOTUNG_MA, tc_ten.TEN as TENTCTT, 
--            td.NGAYGUI, td.TRANGTHAI, td.HINHTHUCGUI, 
--            a.DIACHICHITIET,
--            td.NGAYPHATHANH, td.IS_UTTP, td.UTTP, td.NOINHAN, a.ID DUONGSUID, td.BIEUMAUID,
--            td.NGAYNHANTONGDAT, td.QUOCGIA, td.COQUAN, td.NOIDUNG, td.KETQUAUTTP, td.ID TONGDAT_DOITUONG
--            ,NULL AS SOTHONGBAO,  NULL AS XACTHUC_DLDCQG -- vnpt 27/11/2025
--        FROM AHS_NGUOITHAMGIATOTUNG a
--        inner join (SELECT tt_tc.NGUOIID,tc.TEN,tc.MA FROM AHS_NGUOITHAMGIATOTUNG_TUCACH tt_tc
--                    inner join (SELECT item.ID,item.TEN,item.MA FROM DM_DATAITEM item WHERE item.GROUPID=vGroupID) tc on tc.ID=tt_tc.TUCACHID 
--                    ) tc_ten on tc_ten.NGUOIID = a.ID
--        left join (SELECT dt.ID, dt.NGAYGUI, dt.NGAYPHATHANH, dt.IS_UTTP, dt.UTTP, dt.NOINHAN, dt.DIACHI ,
--                            dt.TRANGTHAI, dt.HINHTHUCGUI, dt.DUONGSUID, t.BIEUMAUID, dt.NGAYNHANTONGDAT, dt.QUOCGIA,
--                            dt.COQUAN, dt.NOIDUNG, dt.KETQUAUTTP
--                  FROM AHS_TONGDAT_DOITUONG dt 
--                  inner join AHS_TONGDAT t on t.ID=dt.TONGDATID
--                  WHERE t.VUANID=vVuAnID and t.TOAANID=vToaAnID and t.BIEUMAUID=vBieuMauID
--                  and ( ---------27/11/2025---- vnpt - Thêm biến FILEID để lọc riêng từng văn bản trùng
--                                (vFileID > -1 and t.FILEID = vFileID)
--                                 or
--                                (vFileID <= -1 and t.BIEUMAUID IS NOT NULL)
--                              )
--                  ) td on td.DUONGSUID=a.ID
--        WHERE a.VUANID=vVuAnID;
END AHS_TONGDATDOITUONG_GETBY;

PROCEDURE AHS_TONGDATDOITUONG_GETBYTONGDATID(
    vTONGDATID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn for 
    SELECT a.*, noti.NGAYXEM, noti.REQUEST_ID, noti.NGAYGUI_THANHCONG, 
    NVL(ads.XACTHUC_DLDCQG,0) AS XACTHUC_DLDCQG, NVL(NVL(NVL(aptqd.SOQUYETDINH, astqd.SOQUYETDINH), aptba.SOBANAN), astba.SOBANAN) AS SOTHONGBAO
    FROM AHS_TONGDAT_DOITUONG a
        LEFT JOIN AHS_TONGDAT at2 ON a.TONGDATID = at2.id
        LEFT JOIN AHS_BICANBICAO ads ON a.DUONGSUID = ads.id --VNPT Lê BÁ Thọ 27/11/2025
        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN astqd on astqd.ID = at2.MAPID and at2.MAP_TABLE like 'AHS_SOTHAM_QUYETDINH_VUAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN aptqd on aptqd.ID = at2.MAPID and at2.MAP_TABLE like 'AHS_PHUCTHAM_QUYETDINH_VUAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_SOTHAM_BANAN astba on astba.ID = at2.MAPID and at2.MAP_TABLE like 'AHS_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_PHUCTHAM_BANAN aptba on aptba.ID = at2.MAPID and at2.MAP_TABLE like 'AHS_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    LEFT JOIN VNEID_TOAANNOTIFICATION noti ON noti.TONGDATID = a.TONGDATID AND noti.DOITUONGID = a.ID AND noti.LOAIAN = 1
    WHERE a.TONGDATID = vTONGDATID;
END AHS_TONGDATDOITUONG_GETBYTONGDATID;

PROCEDURE AHS_TONGDAT_THUHOI(
    v_id in number,
    vNgayThuHoi in date,
    vLyDo in varchar2,
    vNguoiSua in varchar2
)
IS 
BEGIN
    UPDATE AHS_TONGDAT
    SET
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    WHERE ID = v_id;
    UPDATE AHS_TONGDAT_DOITUONG
    SET
        TRANGTHAI = 2
    WHERE TONGDATID = v_id AND (TRANGTHAI = 1 OR (NGAYPHATHANH IS NULL AND NGAYGUI IS NOT NULL));
END AHS_TONGDAT_THUHOI;

PROCEDURE AHS_TONGDAT_THUHOI_DOITUONG(
    v_DoiTuongTongDatId in number,
    v_tongDatID in number,
    v_lyDoThuHoi in nvarchar2,
    v_ngayThuHoi in date,
    v_nguoiSua in nvarchar2
)
IS
BEGIN
    UPDATE AHS_TONGDAT
    SET NGAYTHUHOI = v_ngayThuHoi,
        LYDOTHUHOI = v_lyDoThuHoi,
        NGUOISUA = v_nguoiSua,
        NGAYSUA = sysdate
    WHERE ID = v_tongDatID;

    UPDATE AHS_TONGDAT_DOITUONG
    SET TRANGTHAI = 2
    WHERE ID = v_DoiTuongTongDatId;
END AHS_TONGDAT_THUHOI_DOITUONG;

PROCEDURE AHS_TONGDAT_VBDH_DOITUONG(
    v_DoiTuongTongDatId in number
)
IS 
BEGIN
    UPDATE AHS_TONGDAT_DOITUONG
    SET IS_SUA = CASE
        WHEN IS_SUA = 0 THEN 1
        WHEN IS_SUA = 1 THEN 0 END
    WHERE ID = v_DoiTuongTongDatId;
END AHS_TONGDAT_VBDH_DOITUONG;

PROCEDURE AHS_TONGDAT_GETBYID(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR 
    SELECT ID,
        VUANID,
        BIEUMAUID,
        TOAANID,
        IS_TD_VKS,
        IS_TD_VKS_NGAY,
        NGAYTAO,
        NGUOITAO,
        NGAYSUA,
        NGUOISUA,
        TENFILE,
        KIEUFILE,
        NOIDUNGFILE,
        FILEID,
        NGAYDANG_CTTDT,
        NGAYNHANTONGDAT,
        TRANGTHAI,
        NGAYTHUHOI,
        LYDOTHUHOI,
        URL_FILE
        FROM AHS_TONGDAT
        WHERE ID = vID;
END AHS_TONGDAT_GETBYID;

PROCEDURE AHS_TONGDATDOITUONG_GETTENDUONGSU(
    vID in number,
    curReturn out SYS_REFCURSOR
)
IS
    vDUONGSUID number := 0;
BEGIN
-- vnpt chinh 4/12/2025
--    SELECT dt.DUONGSUID INTO vDUONGSUID FROM AHS_TONGDAT_DOITUONG dt WHERE ID = vID;
--    if(vDUONGSUID > 0) THEN
--        OPEN curReturn FOR  
--        SELECT ds.HOTEN Ten FROM AHS_TONGDAT_DOITUONG dt JOIN AHS_BICANBICAO ds on dt.DUONGSUID = ds.ID
--        WHERE dt.ID = vID;
--    else
--        OPEN curReturn FOR
--          SELECT dt.NOINHAN Ten FROM AHS_TONGDAT_DOITUONG dt WHERE dt.ID = vID;
--    end if;
OPEN curReturn FOR
    SELECT 
        CASE 
            WHEN tc.ID IS NOT NULL OR dt.MATUCACH IN('BICAN1','BICANDAUVU1') THEN TO_NCHAR(nt.HOTEN)  
            WHEN bc.ID IS NOT NULL OR dt.MATUCACH IN('BICAN','BICANDAUVU') THEN TO_NCHAR(bc.HOTEN)  
            ELSE TO_NCHAR(dt.NOINHAN)                   
        END AS Ten
    FROM AHS_TONGDAT_DOITUONG dt
    LEFT JOIN AHS_NGUOITHAMGIATOTUNG nt 
           ON nt.ID = dt.DUONGSUID
    LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH tt 
           ON tt.NGUOIID = nt.ID
    LEFT JOIN DM_DATAITEM tc
           ON tc.ID = tt.TUCACHID
    LEFT JOIN AHS_BICANBICAO bc
           ON bc.ID = dt.DUONGSUID
    WHERE dt.ID = vID;
END AHS_TONGDATDOITUONG_GETTENDUONGSU;

PROCEDURE AHS_TONGDATDOITUONG_GETBYID(
    vID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT * FROM AHS_TONGDAT_DOITUONG WHERE ID = vID;
END AHS_TONGDATDOITUONG_GETBYID;

PROCEDURE AHS_TONGDATDOITUONG_REMOVEBYID(
    vID in number,
    returnID out number)
IS
BEGIN
    if(vID > 0) then
    DELETE FROM AHS_TONGDAT_DOITUONG dt WHERE dt.ID = vID RETURNING
    ID into returnID;
    end if;
END AHS_TONGDATDOITUONG_REMOVEBYID;

PROCEDURE AHS_TONGDATNOINHAN_UP_IN
(
    v_id in number DEFAULT 0,
    v_TONGDATID in NUMBER , 
    v_MATUCACH in VARCHAR2 , 
    v_NGAYGUI in DATE,
    v_TRANGTHAI in NUMBER ,
    v_HINHTHUCGUI in NUMBER , 
    V_DUONGSUID in NUMBER,
    v_NGAYNHANTONGDAT in DATE,
    v_QUOCGIA in NUMBER,
    v_COQUAN in VARCHAR2,
    v_NOIDUNG in CLOB ,
    v_KETQUAUTTP in NUMBER ,
    v_NGAYPHATHANH in DATE ,
    v_NGAYTAO in DATE,
    v_NGUOITAO in VARCHAR2 ,
    v_IS_UTTP in NUMBER,
    v_UTTP in NUMBER ,
    v_NOINHAN in VARCHAR2 , 
    v_DIACHI in VARCHAR2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out NUMBER
) 
IS
BEGIN
    if (v_id >0) then
        UPDATE AHS_TONGDAT_DOITUONG
        SET TONGDATID = v_TONGDATID,
            MATUCACH = v_MATUCACH,
            NGAYGUI = v_NGAYGUI,
            TRANGTHAI = v_TRANGTHAI,
            HINHTHUCGUI = v_HINHTHUCGUI ,
            DUONGSUID = v_DUONGSUID,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            QUOCGIA = v_QUOCGIA,
            COQUAN  =  v_COQUAN,
            NOIDUNG = v_NOIDUNG,
            KETQUAUTTP = v_KETQUAUTTP,
            -- NGAYPHATHANH = v_NGAYPHATHANH,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            IS_UTTP = v_IS_UTTP,
            UTTP = v_UTTP,
            NOINHAN = v_NOINHAN,
            DIACHI = v_DIACHI
        WHERE ID = v_id  
        RETURNING ID INTO vID;
    else
        INSERT INTO AHS_TONGDAT_DOITUONG (ID,TONGDATID,MATUCACH,NGAYGUI,TRANGTHAI,HINHTHUCGUI,DUONGSUID,NGAYNHANTONGDAT,
            QUOCGIA,COQUAN,NOIDUNG,KETQUAUTTP,NGAYPHATHANH,NGAYTAO,NGUOITAO,IS_UTTP,UTTP,NOINHAN,DIACHI,IS_SUA,TOA_GIAIQUYET_ID)
        VALUES (AHS_TONGDAT_DOITUONG_SEQ.nextval,v_TONGDATID,v_MATUCACH,v_NGAYGUI,v_TRANGTHAI,v_HINHTHUCGUI,v_DUONGSUID,
            v_NGAYNHANTONGDAT,v_QUOCGIA,v_COQUAN,v_NOIDUNG,v_KETQUAUTTP,v_NGAYPHATHANH,v_NGAYTAO,v_NGUOITAO,v_IS_UTTP,
            v_UTTP,v_NOINHAN,v_DIACHI,1,v_TOA_GIAIQUYET_ID)
        RETURNING ID INTO vID;
    end if;
END AHS_TONGDATNOINHAN_UP_IN;

PROCEDURE AHS_GETTENBM_BYTONGDATID(
    vTONGDATID in NUMBER,
    curReturn out SYS_REFCURSOR
)
IS
BEGIN
    OPEN curReturn FOR
    SELECT bm.TENBM || CASE WHEN NVL(TO_CHAR(aptqd.SOQUYETDINH), TO_CHAR(astqd.SOQUYETDINH)) IS NOT NULL           -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
                            THEN '<br/> (QĐ: ' || NVL(TO_CHAR(aptqd.SOQUYETDINH), TO_CHAR(astqd.SOQUYETDINH))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptqd.NGAYQD, astqd.NGAYQD), 'DD/MM/YYYY') || ')'
                            when NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN)) IS NOT NULL
                            THEN '<br/> (Số: ' || NVL(TO_CHAR(aptba.SOBANAN), TO_CHAR(astba.SOBANAN))
                                || ' - Ngày: ' || TO_CHAR(NVL(aptba.NGAYMOPHIENTOA, astba.NGAYMOPHIENTOA), 'DD/MM/YYYY') || ')'
    					END AS TENBM        -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    from AHS_TONGDAT td JOIN DM_BIEUMAU bm ON td.BIEUMAUID = bm.ID
        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN astqd on astqd.ID = td.MAPID and td.MAP_TABLE like 'AHS_SOTHAM_QUYETDINH_VUAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN aptqd on aptqd.ID = td.MAPID and td.MAP_TABLE like 'AHS_PHUCTHAM_QUYETDINH_VUAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_SOTHAM_BANAN astba on astba.ID = td.MAPID and td.MAP_TABLE like 'AHS_SOTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
        LEFT JOIN AHS_PHUCTHAM_BANAN aptba on aptba.ID = td.MAPID and td.MAP_TABLE like 'AHS_PHUCTHAM_BANAN' -- VNPT - Lê Bá Thọ 26/11/2025 lấy Số quyết định và ngày quyết định
    WHERE td.ID = vTONGDATID;
END AHS_GETTENBM_BYTONGDATID;

PROCEDURE AHS_TONGDAT_UP_IN
( 
    v_id in number DEFAULT 0,
    v_DONID in NUMBER, 
    v_BIEUMAUID in NUMBER,
    v_TOAANID in NUMBER, 
    v_IS_TD_VKS in NUMBER, 
    v_IS_TD_VKS_NGAY in date,
    v_NGAYTAO in date, 
    v_NGUOITAO in VARCHAR2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2 ,
    v_KIEUFILE in VARCHAR2 ,
    v_NOIDUNGFILE in BLOB, 
    v_FILEID in number, 
    v_NGAYDANG_CTTDT in date,
    v_NGAYNHANTONGDAT in DATE,
    v_TRANGTHAI in NUMBER, 
    v_NGAYTHUHOI in date,
    v_LYDOTHUHOI in varchar2,
    v_URL_FILE in varchar2,
    v_MAPID IN NUMBER,
    v_MAP_TABLE IN varchar2,
    v_TOA_GIAIQUYET_ID in NUMBER,
    vID out number
)
IS
V_COUNT NUMBER;
BEGIN
    if (v_id >0) then
        UPDATE AHS_TONGDAT
        SET VUANID = v_DONID,
            BIEUMAUID = v_BIEUMAUID,
            TOAANID = v_TOAANID,
            IS_TD_VKS = v_IS_TD_VKS,
            IS_TD_VKS_NGAY = v_IS_TD_VKS_NGAY,
            NGAYTAO = v_NGAYTAO,
            NGUOITAO = v_NGUOITAO,
            NGAYSUA = v_NGAYSUA,
            NGUOISUA  =  v_NGUOISUA,
            TENFILE = v_TENFILE,
            KIEUFILE = v_KIEUFILE,
            NOIDUNGFILE = v_NOIDUNGFILE,
            FILEID = v_FILEID,
            NGAYDANG_CTTDT = v_NGAYDANG_CTTDT,
            NGAYNHANTONGDAT = v_NGAYNHANTONGDAT,
            TRANGTHAI = v_TRANGTHAI,
            NGAYTHUHOI = v_NGAYTHUHOI,
            LYDOTHUHOI = v_LYDOTHUHOI,
            URL_FILE = v_URL_FILE,
            MAPID = v_MAPID
        WHERE ID = v_id
        RETURNING ID INTO vID;
    else
      SELECT COUNT(*) INTO V_COUNT FROM AHS_TONGDAT WHERE VUANID=v_DONID AND TOAANID=v_TOAANID AND BIEUMAUID=v_BIEUMAUID AND MAPID = v_MAPID;  
            IF(V_COUNT=0)THEN
        INSERT INTO AHS_TONGDAT (id,VUANID,BIEUMAUID,TOAANID,IS_TD_VKS,IS_TD_VKS_NGAY,NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,
            TENFILE,KIEUFILE,FILEID,NGAYDANG_CTTDT,NGAYNHANTONGDAT,TRANGTHAI,NGAYTHUHOI,LYDOTHUHOI,URL_FILE,TOA_GIAIQUYET_ID,MAPID, MAP_TABLE)
        VALUES (AHS_TONGDAT_SEQ.nextval,v_DONID,v_BIEUMAUID,v_TOAANID,v_IS_TD_VKS,v_IS_TD_VKS_NGAY,v_NGAYTAO,v_NGUOITAO,
            v_NGAYSUA,v_NGUOISUA,v_TENFILE,v_KIEUFILE,v_FILEID,v_NGAYDANG_CTTDT,v_NGAYNHANTONGDAT,v_TRANGTHAI,v_NGAYTHUHOI,
            v_LYDOTHUHOI,v_URL_FILE,v_TOA_GIAIQUYET_ID,v_MAPID, v_MAP_TABLE)
        RETURNING ID INTO vID;
      end if;  
    end if;
END AHS_TONGDAT_UP_IN;

PROCEDURE GET_BM_TONGDAT
(
	vLoaiAn in number,
	vMaGiaiDoan number,
	vDonID number,
	curReturn out sys_refcursor
)
IS
	nCountTongDatAnphi NUMBER;
	nCountAnphi NUMBER;
BEGIN

IF vLoaiAn=1 THEN
	OPEN curReturn FOR 
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU
    , f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 21/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày
	From DM_BIEUMAU b 
		inner join (Select af.BIEUMAUID,
                        NVL(NVL(NVL(aptqd.SOQUYETDINH, astqd.SOQUYETDINH), apba.SOBANAN), asba.SOBANAN) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
                        NVL(NVL(NVL(aptqd.NGAYQD, astqd.NGAYQD), apba.NGAYMOPHIENTOA), asba.NGAYMOPHIENTOA) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                        af.ID AS FILEID,
                        af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 21/11/2025
					from AHS_FILE af
                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN astqd on astqd.FILEID = af.ID
                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN aptqd on aptqd.FILEID = af.ID
                    LEFT JOIN AHS_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
                    LEFT JOIN AHS_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
					where af.VUANID = vDonID
                    ) f on f.BIEUMAUID = b.ID
	Where b.ACTIVE = 1 and b.ISAHS = 1 
		AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
			OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
		AND 
--        b.ID NOT IN (SELECT BIEUMAUID 
--						FROM AHS_TONGDAT
--						WHERE VUANID = vDonID 
--							AND BIEUMAUID IS NOT NULL)
            f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 21/11/2025
			                     FROM AHS_TONGDAT
			                     WHERE VUANID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
	Order by f.FILE_NGAYTAO;

ELSIF vLoaiAn=2 THEN
--	OPEN curReturn FOR  
--	SELECT bb.* 
--	from(Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--			From DM_BIEUMAU b
--			inner join (Select DISTINCT BIEUMAUID 
--						from ADS_FILE 
--						where DONID=vDonID) f on f.BIEUMAUID=b.ID
--			Where b.ACTIVE=1 and b.ISADS=1 
--				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--					OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--	From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1
--        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
--        ) 
--    ) bb 
--    WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--                        FROM ADS_TONGDAT
--                        WHERE DONID = vDonID 
--                            AND BIEUMAUID IS NOT NULL)
--    Order by bb.THUTU;
	
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí
    -- VNPT Lê Bá Thọ Sửa lấy ra tất cả biểu mẫu 
	OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0') || '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID_ANPHI_ID, -- VNPT - Lê Bá Thọ 21/11/2025 Thêm biến FILEID để lọc riêng từng văn bản trùng
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO, f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 21/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày 
			From DM_BIEUMAU b
			inner join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)), TO_CHAR(asba.SOBANAN)), TO_CHAR(apba.SOBANAN)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO), astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO), asba.NGAYMOPHIENTOA),apba.NGAYMOPHIENTOA) AS NGAYTHONGBAO,
                NVL(aptq.SOQD, asq.SOQD) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(aptq.NGAYQD, asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID,
                af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 21/11/2025
			FROM
				ADS_FILE af
            LEFT JOIN ADS_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_SOTHAM_THULY astl ON astl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ADS_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN ADS_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN ADS_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN ADS_DON_XULY a on af.ID = a.FILEID
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM ADS_TONGDAT adt
											WHERE adt.DONID = vDonID
                                            AND adt.MAPID = aa.ID 
                                            ))
											)

				) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISADS=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
					AND (b.MABM = '100-DS' OR 
--                            b.ID NOT IN (SELECT BIEUMAUID -- VNPT - Lê Bá Thọ 21/11/2025
--			                     FROM ADS_TONGDAT
--			                     WHERE DONID = vDonID
--			                     AND BIEUMAUID IS NOT NULL
--                                 )
                            f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 21/11/2025
			                     FROM ADS_TONGDAT
			                     WHERE DONID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
                         )
                                
    UNION ALL
	Select TO_CHAR(b.ID) || '_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO,
    NULL AS SOQUYETDINH,  NULL AS NGAYQD, NULL AS FILE_NGAYTAO -- VNPT - Lê Bá Thọ 21/11/2025
	From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM ADS_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL 
                            )
    ) bb 
    WHERE 1 = 1 
    Order by bb.FILE_NGAYTAO;
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí
   
ElsIF vLoaiAn=3 Then
--    OPEN curReturn FOR   
--    SELECT bb.* 
--	from(Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
--			From DM_BIEUMAU b 
--				inner join (Select DISTINCT BIEUMAUID 
--							from AHN_FILE 
--							where DONID=vDonID) f on f.BIEUMAUID=b.ID
--			Where b.ACTIVE=1 and b.ISAHN=1 
--				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--					OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHN=1 
--        AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
--        ) 
--    ) bb 
--    WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--                        FROM AHN_TONGDAT
--                        WHERE DONID = vDonID 
--                            AND BIEUMAUID IS NOT NULL)
--    Order by bb.THUTU;

	OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0') || '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID_ANPHI_ID, -- VNPT - Lê Bá Thọ 27/11/2025 Thêm biến FILEID để lọc riêng từng văn bản trùng
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO, f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 27/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày 
			From DM_BIEUMAU b
			inner join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
--				NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU) AS SOTHONGBAO, 
--				NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO) AS NGAYTHONGBAO
               NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)), TO_CHAR(asba.SOBANAN)), TO_CHAR(apba.SOBANAN)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO), astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO), asba.NGAYMOPHIENTOA),apba.NGAYMOPHIENTOA) AS NGAYTHONGBAO,
                NVL(aptq.SOQD, asq.SOQD) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(aptq.NGAYQD, asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID,
                af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 26/11/2025
			FROM
				AHN_FILE af
            LEFT JOIN AHN_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 27/11/2025
            LEFT JOIN AHN_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 27/11/2025
            LEFT JOIN AHN_SOTHAM_THULY astl ON astl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHN_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 29/11/2025
            LEFT JOIN AHN_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN AHN_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AHN_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 3
            LEFT JOIN AHN_DON_XULY a on af.ID = a.FILEID
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM AHN_TONGDAT adt
											WHERE adt.DONID = vDonID AND adt.MAPID = aa.ID AND adt.BIEUMAUID = db.ID))
											)) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISAHN=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
					AND (b.MABM = '100-DS' OR 
--                            b.ID NOT IN (SELECT BIEUMAUID 
--			                     FROM AHN_TONGDAT
--			                     WHERE DONID = vDonID 
--			                     AND BIEUMAUID IS NOT NULL)
                              f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 27/11/2025
			                     FROM AHN_TONGDAT
			                     WHERE DONID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
                        )
    UNION ALL
	Select TO_CHAR(b.ID) || '_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO,
	NULL AS SOQUYETDINH,  NULL AS NGAYQD, NULL AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 29/11/2025
    From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHN=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM AHN_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL )
    ) bb 
    WHERE 1 = 1 
    Order by bb.FILE_NGAYTAO;

ElsIF vLoaiAn=4 Then
--    OPEN curReturn FOR  
--    SELECT bb.* 
--	from(Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--		From DM_BIEUMAU b 
--			inner join (Select DISTINCT BIEUMAUID 
--						from AKT_FILE 
--						where DONID=vDonID) f on f.BIEUMAUID=b.ID
--		Where b.ACTIVE=1 and b.ISAKT=1 
--			AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--				OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--				OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--				OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--	From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAKT=1 
--        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--        ) bb
--        WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--                            FROM AKT_TONGDAT
--                            WHERE DONID = vDonID 
--                                AND BIEUMAUID IS NOT NULL)
--        Order by bb.THUTU;
		
	OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0')|| '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID_ANPHI_ID, -- VNPT - Lê Bá Thọ 27/11/2025 Thêm biến FILEID để lọc riêng từng văn bản trùng , 
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO,f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 27/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày 
			From DM_BIEUMAU b
			inner join (SELECT
                BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)), TO_CHAR(asba.SOBANAN)), TO_CHAR(apba.SOBANAN)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO), astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO), asba.NGAYMOPHIENTOA),apba.NGAYMOPHIENTOA) AS NGAYTHONGBAO,
                NVL(aptq.SOQD, asq.SOQD) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(aptq.NGAYQD, asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID,
                af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 27/11/2025
			FROM
				AKT_FILE af
            LEFT JOIN AKT_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 27/11/2025
            LEFT JOIN AKT_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 27/11/2025
            LEFT JOIN AKT_SOTHAM_THULY astl ON astl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AKT_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AKT_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN AKT_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AKT_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 4
            LEFT JOIN AKT_DON_XULY a on af.ID = a.FILEID
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM AKT_TONGDAT adt
											WHERE adt.DONID = vDonID AND adt.MAPID = aa.ID ))
											)) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISAKT=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
					AND (b.MABM = '100-DS' OR
--                    b.ID NOT IN (SELECT BIEUMAUID 
--			                     FROM AKT_TONGDAT
--			                     WHERE DONID = vDonID 
--			                     AND BIEUMAUID IS NOT NULL)
                            f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 27/11/2025
			                     FROM AKT_TONGDAT
			                     WHERE DONID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
                                 )
    UNION ALL
	Select TO_CHAR(b.ID) || '_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO,
    NULL AS SOQUYETDINH,  NULL AS NGAYQD, NULL AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 27/11/2025
	From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAKT=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM AKT_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL )
    ) bb 
    WHERE 1 = 1 
    Order by bb.FILE_NGAYTAO;
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí

ElsIF vLoaiAn=5 Then
--    OPEN curReturn FOR  
--    SELECT bb.* 
--	from(Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--		From DM_BIEUMAU b 
--			inner join (Select DISTINCT BIEUMAUID 
--						from ALD_FILE 
--						where DONID=vDonID) f on f.BIEUMAUID=b.ID
--    Where b.ACTIVE=1 and b.ISALD=1 
--		AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--			OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--	UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU
--	From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISALD=1 
--        AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--			OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
--    ) bb 
--    WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--                        FROM ALD_TONGDAT
--                        WHERE DONID = vDonID 
--                            AND BIEUMAUID IS NOT NULL)
--    Order by bb.THUTU;
  	
    OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0') || '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID_ANPHI_ID, -- VNPT - Lê Bá Thọ 21/11/2025 Thêm biến FILEID để lọc riêng từng văn bản trùng
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO, f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 21/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày 
			From DM_BIEUMAU b
			inner join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)), TO_CHAR(asba.SOBANAN)), TO_CHAR(apba.SOBANAN)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO), astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO), asba.NGAYMOPHIENTOA),apba.NGAYMOPHIENTOA) AS NGAYTHONGBAO,
                NVL(aptq.SOQD, asq.SOQD) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(aptq.NGAYQD, asq.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID,
                af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 21/11/2025
			FROM
				ALD_FILE af
            LEFT JOIN ALD_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ALD_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ALD_SOTHAM_THULY astl ON astl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ALD_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN ALD_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN ALD_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN ALD_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 2
            LEFT JOIN ALD_DON_XULY a on af.ID = a.FILEID
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM ALD_TONGDAT adt
											WHERE adt.DONID = vDonID
                                            AND adt.MAPID = aa.ID 
                                            ))
											)

				) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISADS=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
					AND (b.MABM = '100-DS' OR 
--                            b.ID NOT IN (SELECT BIEUMAUID -- VNPT - Lê Bá Thọ 21/11/2025
--			                     FROM ADS_TONGDAT
--			                     WHERE DONID = vDonID
--			                     AND BIEUMAUID IS NOT NULL
--                                 )
                            f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 21/11/2025
			                     FROM ALD_TONGDAT
			                     WHERE DONID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
                         )
                                
    UNION ALL
	Select TO_CHAR(b.ID) || '_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO,
    NULL AS SOQUYETDINH,  NULL AS NGAYQD, NULL AS FILE_NGAYTAO -- VNPT - Lê Bá Thọ 21/11/2025
	From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM ALD_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL 
                            )
    ) bb 
    WHERE 1 = 1 
    Order by bb.FILE_NGAYTAO;
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí

ELSIF vLoaiAn=6 THEN
--	OPEN curReturn FOR  
--	SELECT bb.* 
--	from(Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--			From DM_BIEUMAU b
--			inner join (Select DISTINCT BIEUMAUID 
--						from ADS_FILE 
--						where DONID=vDonID) f on f.BIEUMAUID=b.ID
--			Where b.ACTIVE=1 and b.ISADS=1 
--				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--					OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--	From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1
--        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
--        ) 
--    ) bb 
--    WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--                        FROM ADS_TONGDAT
--                        WHERE DONID = vDonID 
--                            AND BIEUMAUID IS NOT NULL)
--    Order by bb.THUTU;
	
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí
    -- VNPT Lê Bá Thọ Sửa lấy ra tất cả biểu mẫu 
	OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0') || '_' || NVL(TO_CHAR(f.FILEID), '0') AS ID_ANPHI_ID, -- VNPT - Lê Bá Thọ 21/11/2025 Thêm biến FILEID để lọc riêng từng văn bản trùng
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO, f.SOQUYETDINH, f.NGAYQD, f.FILE_NGAYTAO   -- VNPT - Lê Bá Thọ 21/11/2025 Thêm để lấy ra thông tin văn bản + Quyết định và ngày 
			From DM_BIEUMAU b
			inner join (SELECT
				 BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU), TO_CHAR(a.SOTHONGBAO) || NVL(a.STB_PHU, '')), TO_CHAR(astl.SOTHONGBAO)), TO_CHAR(apttl.SOTHONGBAO)), TO_CHAR(asba.SOBANAN)), TO_CHAR(apba.SOBANAN)) AS SOTHONGBAO, 
				NVL(NVL(NVL(NVL(NVL(NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO), a.NGAYTHONGBAO), astl.NGAYTHONGBAO),apttl.NGAYTHONGBAO), asba.NGAYMOPHIENTOA),apba.NGAYMOPHIENTOA) AS NGAYTHONGBAO,
                NVL(NVL(aptq.SOQD, asq.SOQD), apqdtdc.SOQD) AS SOQUYETDINH, -- VNPT - Lê Bá Thọ 21/11/2025
				NVL(NVL(aptq.NGAYQD, asq.NGAYQD), apqdtdc.NGAYQD) AS NGAYQD,-- VNPT - Lê Bá Thọ 21/11/2025
                af.ID AS FILEID,
                af.NGAYTAO AS FILE_NGAYTAO-- VNPT - Lê Bá Thọ 21/11/2025
			FROM
				AHC_FILE af
            LEFT JOIN AHC_SOTHAM_QUYETDINH asq ON asq.FILEID = af.ID    -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AHC_PHUCTHAM_QUYETDINH aptq ON aptq.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AHC_SOTHAM_THULY astl ON astl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AHC_PHUCTHAM_THULY apttl ON apttl.FILEID = af.ID   -- VNPT - Lê Bá Thọ 21/11/2025
            LEFT JOIN AHC_PHUCTHAM_BANAN apba ON apba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN AHC_SOTHAM_BANAN asba ON asba.FILEID = af.ID   -- VNPT - Lê Bá Thọ 03/12/2025
            LEFT JOIN AHC_KCKNQDK_PHUCTHAM_QUYETDINH apqdtdc ON apqdtdc.FILEID = af.ID   -- VNPT -  05/12/2025
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN AHC_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 6
            LEFT JOIN AHC_DON_XULY a on af.ID = a.FILEID
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM AHC_TONGDAT adt
											WHERE adt.DONID = vDonID
                                            AND adt.MAPID = aa.ID 
                                            ))
											)

				) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISAHC=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                    OR (vMaGiaiDoan=7 and b.ISPHUCTHAM=1) 
                    ) 
					AND (b.MABM = '100-DS' OR 
--                            b.ID NOT IN (SELECT BIEUMAUID -- VNPT - Lê Bá Thọ 21/11/2025
--			                     FROM ADS_TONGDAT
--			                     WHERE DONID = vDonID
--			                     AND BIEUMAUID IS NOT NULL
--                                 )
                            f.FILEID NOT IN (SELECT FILEID  -- VNPT - Lê Bá Thọ 21/11/2025
			                     FROM AHC_TONGDAT
			                     WHERE DONID = vDonID
			                     AND FILEID IS NOT NULL AND f.BIEUMAUID = b.ID
                                 )
                         )
                                
    UNION ALL
	Select TO_CHAR(b.ID) || '_0_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO,
    NULL AS SOQUYETDINH,  NULL AS NGAYQD, NULL AS FILE_NGAYTAO -- VNPT - Lê Bá Thọ 21/11/2025
	From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHC=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM AHC_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL 
                            )
    ) bb 
    WHERE 1 = 1 
    Order by bb.FILE_NGAYTAO;
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí

ElsIF vLoaiAn=7 Then
--    OPEN curReturn FOR  
--    SELECT bb.* 
--	from(Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--        From DM_BIEUMAU b 
--			inner join (Select DISTINCT BIEUMAUID 
--						from APS_FILE 
--						where DONID=vDonID) f on f.BIEUMAUID=b.ID
--    Where b.ACTIVE=1 and b.ISAPS=1 
--        AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    UNION 
--	Select b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU 
--	From DM_BIEUMAU b 
--    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAPS=1 
--        AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
--			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
--            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
--			OR (vMaGiaiDoan=4 and b.ISGDTTT=1))
--    ) bb 
--    WHERE bb.ID NOT IN (SELECT BIEUMAUID 
--						FROM APS_TONGDAT
--						WHERE DONID = vDonID 
--							AND BIEUMAUID IS NOT NULL)
--    Order by bb.THUTU;   

	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí
		
	OPEN curReturn FOR  
	SELECT bb.* 
	from(
	Select TO_CHAR(b.ID) || '_' || NVL(TO_CHAR(f.ANPHI_ID), '0') AS ID_ANPHI_ID, 
			b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, f.ANPHI_ID, f.SOTHONGBAO, f.NGAYTHONGBAO
			From DM_BIEUMAU b
			inner join (SELECT
				DISTINCT BIEUMAUID,
				aa.ID ANPHI_ID, 
				NVL(dm.SOTHONGBAO || dm.STB_PHU, aa.SOTHONGBAO || aa.STB_PHU) AS SOTHONGBAO, 
				NVL(dm.NGAYTHONGBAO, aa.NGAYTHONGBAO) AS NGAYTHONGBAO
			FROM
				APS_FILE af
			LEFT JOIN DM_BIEUMAU db ON db.ID = af.BIEUMAUID
			LEFT JOIN APS_ANPHI aa ON
				af.DONID = aa.DONID AND db.MABM = '100-DS' AND aa.MAGIAIDOAN = 2
			LEFT JOIN DON_MIENANPHI dm ON
				dm.ANPHI_ID = aa.ID  AND dm.LOAIAN = 7
			WHERE
				af.DONID = vDonID 
				AND (db.MABM != '100-DS' OR (db.MABM = '100-DS'	AND (aa.TINHTRANG = 1 OR dm.ID IS NOT NULL)
										AND NOT EXISTS (SELECT adt.ID
											FROM APS_TONGDAT adt
											WHERE adt.DONID = vDonID AND adt.MAPID = aa.ID AND adt.BIEUMAUID = db.ID))
											)) f on f.BIEUMAUID=b.ID
			Where b.ACTIVE=1 and b.ISAPS=1 
				AND((vMaGiaiDoan=1 and b.ISHOSO=1) 
					OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
					OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
					OR (vMaGiaiDoan=4 and b.ISGDTTT=1)) 
					AND (b.MABM = '100-DS' OR b.ID NOT IN (SELECT BIEUMAUID 
			                     FROM APS_TONGDAT
			                     WHERE DONID = vDonID 
			                     AND BIEUMAUID IS NOT NULL))
    UNION ALL
	Select TO_CHAR(b.ID) || '_0' AS ID_ANPHI_ID , b.ID, b.MABM, b.DUONGDAN, b.TENBM, b.THUTU, NULL AS ANPHI_ID, NULL AS SOTHONGBAO, NULL AS NGAYTHONGBAO
	From DM_BIEUMAU b 
    where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAPS=1
        AND ((vMaGiaiDoan=1 and b.ISHOSO=1) 
			OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
            OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) 
			OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
        ) 
        AND b.ID NOT IN (SELECT BIEUMAUID 
                        FROM APS_TONGDAT
                        WHERE DONID = vDonID 
                            AND BIEUMAUID IS NOT NULL )
    ) bb 
    WHERE 1 = 1 
    Order by bb.THUTU;
	-- VNPT 16/06/2025 sửa hiển thị biểu mẫu miễn án phí
END IF;
END GET_BM_TONGDAT;

PROCEDURE GET_LYDO_THUHOI
(
	vLoaiAn in number,
	vTongDatID number,
	curReturn out sys_refcursor
)
IS
BEGIN
IF vLoaiAn = 1 THEN
	OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM AHS_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 2 THEN
	OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM ADS_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 3 THEN
    OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM AHN_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 4 THEN
    OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM AKT_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 5 THEN
    OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM ALD_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 6 THEN
    OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM AHC_TONGDAT
    WHERE ID = vTongDatID;
ELSIF vLoaiAn = 7 THEN
    OPEN curReturn FOR 
	SELECT TO_CHAR(NGAYTHUHOI, 'DD/MM/YYYY') AS NGAYTHUHOI, LYDOTHUHOI
    FROM APS_TONGDAT
    WHERE ID = vTongDatID;   
END IF;
END GET_LYDO_THUHOI;

END PKG_STPT_TONGDAT;