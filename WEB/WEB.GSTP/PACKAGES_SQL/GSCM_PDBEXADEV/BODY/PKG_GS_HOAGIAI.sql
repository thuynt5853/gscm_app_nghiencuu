--------------------------------------------------------
--  DDL for Package Body PKG_GS_HOAGIAI
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GS_HOAGIAI" AS
   PROCEDURE GETLIST_THONGBAO (
      V_HGDON   IN NUMBER,
      V_LOAIAN IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
   IF V_LOAIAN = LOAIAN_ADS THEN L_TABLE_DS :='ADS_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHN THEN L_TABLE_DS :='AHN_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AKT THEN L_TABLE_DS :='AKT_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_ALD THEN L_TABLE_DS :='ALD_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHC THEN L_TABLE_DS :='AHC_DON_DUONGSU'; END IF;
    L_STATEMENT:= 'SELECT TB.ID,
                                TB.SOLAN,
                                TB.SOTHONGBAO,
                                TB.NGAYTHONGBAO,
                                 (SELECT
                                        LISTAGG(DS.TENDUONGSU
                                                || '' - ''
                                                || I.TEN, ''</br>'') WITHIN GROUP(
                                        ORDER BY
                                            TBDS.ID
                                        ) "Emp_list"
                                    FROM
                                        HOAGIAI_THONGBAO_DUONGSU TBDS
                                        LEFT JOIN '||L_TABLE_DS||'          DS ON DS.ID = TBDS.DUONGSUID
                                        LEFT JOIN DM_DATAITEM              I ON I.MA = DS.TUCACHTOTUNG_MA
                                        WHERE THONGBAOID = TB.ID) TENDUONGSU,
                                nvl(CB_NK.HOTEN,'''') NGUOIKY,
                                (CASE WHEN EXISTS (SELECT ''X'' FROM HOAGIAI_THONGBAO_KETQUA WHERE THONGBAOID = TB.ID) THEN 1
                                ELSE 0 END) READONLY,
                                TB.NGUOITAO,
                                FSR.ID FILEID,
                                F.TENFILE                      TENFILE
                            FROM HOAGIAI_THONGBAO TB
                            LEFT JOIN HOAGIAI_FILE     F ON TB.FILEID = F.ID
                            LEFT JOIN QT_FILE     FSR ON FSR.ID = F.FILESERVER_ID
                            LEFT JOIN DM_CANBO CB_NK ON CB_NK.ID = TB.NGUOIKYID
                         WHERE TB.HOAGIAIID = '||V_HGDON
                         ||' ORDER BY TB.NGAYTHONGBAO DESC';
      OPEN CURRETURN FOR L_STATEMENT;
   END GETLIST_THONGBAO;
   PROCEDURE GETLIST_GIAONHANDON (
      V_HGDON   IN NUMBER,
      V_LOAIAN IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
   IF V_LOAIAN = LOAIAN_ADS THEN L_TABLE_DS :='ADS_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHN THEN L_TABLE_DS :='AHN_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AKT THEN L_TABLE_DS :='AKT_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_ALD THEN L_TABLE_DS :='ALD_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHC THEN L_TABLE_DS :='AHC_DON_DUONGSU'; END IF;

   L_STATEMENT:= 'SELECT TB.ID,
                     TB.NGAYGIAO,
                     TB.NGAYNHAN,
                     DS.TENDUONGSU NGUOIGIAO,
                     TB.NGAYGIAOTHUC,
                     CB.HOTEN NGUOINHAN,
                     TB.GHICHU,
                     TB.NGUOITAO,
                     TB.TRANGTHAI,
                     DECODE(TB.TRANGTHAI, 1, ''Đã nhận'', 2, ''Không nhận'',
                           3, ''Bảo lưu'', '''') TRANGTHAI_TEXT
                              FROM HOAGIAI_DON_GIAONHAN TB
                              LEFT JOIN DM_CANBO CB ON CB.ID = TB.NGUOINHANID
                              LEFT JOIN '||L_TABLE_DS||' DS ON DS.ID = TB.NGUOIGIAOID
                  WHERE TB.HOAGIAIID = '||V_HGDON;
                  dbms_output.PUT_LINE(L_STATEMENT);
      --OPEN CURRETURN FOR L_STATEMENT;
      --duonghv-Cập nhật lại cách lấy thông tin
      OPEN CURRETURN FOR SELECT 
            TB.ID,
            TB.NGAYGIAO,
            TB.NGAYNHAN,
            CB_NG.HOTEN NGUOIGIAO,
            TB.NGAYGIAOTHUC,
            CB.HOTEN NGUOINHAN,
            TB.GHICHU,
            TB.NGUOITAO,
            TB.TRANGTHAI,
            DECODE(TB.TRANGTHAI, 1, 'Đã nhận', 2, 'Không nhận',
            3, 'Bảo lưu', '') TRANGTHAI_TEXT
        FROM HOAGIAI_DON_GIAONHAN TB
        LEFT JOIN DM_CANBO CB ON CB.ID = TB.NGUOINHANID
        LEFT JOIN DM_CANBO CB_NG ON CB_NG.ID = TB.NGUOIGIAOID
        WHERE TB.HOAGIAIID = V_HGDON;
--      EXECUTE IMMEDIATE L_STATEMENT USING OUT CURRETURN;
   END GETLIST_GIAONHANDON;
--Get list phân công thẩm phán
  PROCEDURE GETLIST_PHANCONGTHAMPHAN (
      V_HGDON   IN NUMBER,
      Page_Index in	int,
      Page_Size	in	int,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   TotalItem number;  MinIndex number; MaxIndex number;
   BEGIN
      MinIndex := Page_Size*(Page_Index - 1);
      OPEN CURRETURN FOR SELECT
                    HG_TP.ID                                                     ID,
                    DECODE(HG_TP.THAMPHANID, NULL, 'Hòa giải viên', 'Thẩm Phán') VAITRO,
                    NVL(HG_TP.THAMPHANID, HG_TP.HOAGIAIVIENID)                   CANBO,
                    CB.HOTEN                                                     HOTEN,
                    CB_NPC.HOTEN                                                 NGUOIPHANCONG,
                    HG_TP.NGAYPHANCONG                                           NGAYPHANCONG,
                    HG_TP.NGAYNHANPHANCONG                                       NGAYNHANPHANCONG,
                    TOA.TEN                                                      TOAANTRUCTHUOC,
                    (
                        CASE
                            WHEN EXISTS (
                                SELECT
                                    'X'
                                FROM
                                    HOAGIAI_GHINHANKETQUA
                                WHERE
                                        HOAGIAIID = V_HGDON
                                    AND NGUOIKYID = HG_TP.THAMPHANID
                            ) THEN
                                1
                            ELSE
                                0
                        END
                    )                                                            READONLY
                FROM
                         HOAGIAI_THAMPHAN HG_TP
                    INNER JOIN HOAGIAI_DON D ON D.ID = HG_TP.HOAGIAIID
                    LEFT JOIN DM_CANBO    CB ON CB.ID = NVL(HG_TP.THAMPHANID, HG_TP.HOAGIAIVIENID)
                    LEFT JOIN DM_CANBO    CB_NPC ON CB_NPC.ID = HG_TP.NGUOIPHANCONGID
                    LEFT JOIN DM_TOAAN    TOA ON TOA.ID = CB.TOAANID
                WHERE
                    D.ID = V_HGDON;
    END GETLIST_PHANCONGTHAMPHAN;
  PROCEDURE GETLIST_GHINHANKETQUAHOAGIAI (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      Page_Index in	int,
      Page_Size	in	int,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   BEGIN
      OPEN CURRETURN FOR
        Select hg_kq.ID,
                hg_kq.HOAGIAIID,
                hg_kq.NGAYHOAGIAI,
                hg_kq.DIADIEM,
                hg_kq.YEUCAUQD,
                hg_kq.KETQUAID,
                hg_kq.LYDOHOANID,
                hg_kq.LYDOID,
                hg_kq.NGUOIKYID,
                hg_kq.CHUCVU,
                NVL(hg_kq.NGAYTHONGBAO,hg_kq.NGAYBIENBAN) NGAYTHONGBAO,
                hg_kq.SOTHONGBAO,
                hg_kq.NGAYBIENBAN,
                hg_kq.FILEID,
                hg_kq.NGAYTAO,
                hg_kq.NGUOITAO,
                hg_kq.NGAYSUA,
                hg_kq.NGUOISUA,
                hg_kq.LYDOHOAN,
                hg_kq.NGUOIKY,hg_f.FILESERVER_ID FILESID from HOAGIAI_GHINHANKETQUA hg_kq 
        inner join HOAGIAI_DON hg_d on hg_d.ID = hg_kq.HOAGIAIID
        left join HOAGIAI_FILE hg_f on hg_f.ID = hg_kq.FILEID
        where hg_d.VUVIECID = V_VUVIECID and hg_d.LOAIANID = V_LOAIANID;
    END GETLIST_GHINHANKETQUAHOAGIAI;
--Hòa giải quyết định
  PROCEDURE GETLIST_HOAGIAIQUYETDINH (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      Page_Index in	int,
      Page_Size	in	int,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   BEGIN
      OPEN CURRETURN FOR
        Select 
            hg_qd.ID,
            hg_qd.KETQUAID, 
            hg_qd.NGAYHOAGIAI, 
            hg_qd.SOQUYETDINH,
            hg_qd.NGAYQUYETDINH,
            hg_qd.NGUOIKY NGUOIKY_TEN,
            hg_qd.CHUCVU,
            hg_qd.NGUOITAO,
            hg_qd.NGAYTAO,
            hg_f.FILESERVER_ID FILESID,
            ta.TEN TOAAN_TEN
        from HOAGIAI_QUYETDINH hg_qd
        inner join HOAGIAI_DON hg_d on hg_d.ID = hg_qd.HOAGIAIID
        inner join DM_TOAAN ta on ta.id = hg_d.TOAANID
        left join HOAGIAI_FILE hg_f on hg_f.ID = hg_qd.FILEID
        where hg_d.VUVIECID = V_VUVIECID and hg_d.LOAIANID = V_LOAIANID;
    END GETLIST_HOAGIAIQUYETDINH;
--Lấy danh sách đương sự của đơn và loại án tương ứng
    PROCEDURE GETLIST_DUONGSU (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
        IF V_LOAIANID = LOAIAN_ADS THEN L_TABLE_DS :='ADS';
        ELSIF V_LOAIANID = LOAIAN_AHN THEN L_TABLE_DS :='AHN';
        ELSIF V_LOAIANID = LOAIAN_AKT THEN L_TABLE_DS :='AKT';
        ELSIF V_LOAIANID = LOAIAN_ALD THEN L_TABLE_DS :='ALD';
        ELSIF V_LOAIANID = LOAIAN_AHC THEN L_TABLE_DS :='AHC'; END IF;
        L_STATEMENT:='SELECT D.ID,D.TENDUONGSU,i.TEN as TENTCTT
        FROM '||L_TABLE_DS||'_DON_DUONGSU D LEFT JOIN DM_DATAITEM     I ON I.MA = D.TUCACHTOTUNG_MA
        WHERE D.ID IN ( SELECT MAX(ID) FROM '||L_TABLE_DS||'_DON_DUONGSU GROUP BY TENDUONGSU, NAMSINH, SOCMND ) AND D.ISDON = 1
            AND ( D.DONID = '||V_VUVIECID||' OR D.DONID IN ( SELECT ID FROM '||L_TABLE_DS||'_DON WHERE VUANGOCID = '||V_VUVIECID||' AND IS_TACHAN IS NULL ) )';
       OPEN CURRETURN FOR L_STATEMENT;
   END GETLIST_DUONGSU;

--Test
FUNCTION GETLIST_DUONGSU_ITEM (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER
   )return T_GS_DUONGSU
   IS
   LOCAL_CUSTOR  sys_refcursor;
    V_TABLE T_GS_DUONGSU := T_GS_DUONGSU();
   BEGIN
       IF V_LOAIANID = 2 THEN  ADS_DON_DUONGSU_GETBY(VDONID => V_VUVIECID, CURRETURN => LOCAL_CUSTOR);
       ELSIF V_LOAIANID = 3 THEN AHN_DON_DUONGSU_GETBY(VDONID => V_VUVIECID, CURRETURN => LOCAL_CUSTOR);
       ELSIF V_LOAIANID = 4 THEN AKT_DON_DUONGSU_GETBY(VDONID => V_VUVIECID, CURRETURN => LOCAL_CUSTOR);
       ELSIF V_LOAIANID = 5 THEN ALD_DON_DUONGSU_GETBY(VDONID => V_VUVIECID, CURRETURN => LOCAL_CUSTOR);
       ELSIF V_LOAIANID = 6 THEN AHC_DON_DUONGSU_GETBY(VDONID => V_VUVIECID, CURRETURN => LOCAL_CUSTOR); END IF;
    RETURN v_table;
   END GETLIST_DUONGSU_ITEM;
--Lấy danh sách đương sự của đơn và loại án tương ứng
   PROCEDURE GETLIST_DENGHIKIENNGHI (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
   IF V_LOAIANID = LOAIAN_ADS THEN L_TABLE_DS :='ADS_DON_DUONGSU';
   ELSIF V_LOAIANID = LOAIAN_AHN THEN L_TABLE_DS :='AHN_DON_DUONGSU';
   ELSIF V_LOAIANID = LOAIAN_AKT THEN L_TABLE_DS :='AKT_DON_DUONGSU';
   ELSIF V_LOAIANID = LOAIAN_ALD THEN L_TABLE_DS :='ALD_DON_DUONGSU';
   ELSIF V_LOAIANID = LOAIAN_AHC THEN L_TABLE_DS :='AHC_DON_DUONGSU'; END IF;
    L_STATEMENT:='Select hg_dn_kn.ID,
            DECODE(hg_dn_kn.LOAIID, 1, ''Đề nghị'', 2, ''Kiến nghị'', '''') LOAI_TEXT,
            CASE 
                WHEN vks.ID is not null THEN vks.TEN 
            ELSE DECODE(hg_dn_kn.HINHTHUCNHANDON, 0, N''Trực tiếp'', 1, N''Qua bưu điện'', '''')
            END HINHTHUC_DONVI_TEXT,
            CASE WHEN ds.ID is null THEN DECODE(hg_dn_kn.NGUOIKIENNGHIID, 1, N''Sơ thẩm'', 2, N''Phúc thẩm'', '''')
            ELSE ds.TENDUONGSU
            END NGUOI_DN_CAP_KN_TEXT,
            CASE WHEN hg_dn_kn.LOAIID = 1 THEN hg_dn_kn.NGAYDENGHI
            ELSE hg_dn_kn.NGAYKIENNGHI
            END NGAYDNKN_TEXT,
            hg_dn_kn.SOQUYETDINH,hg_dn_kn.NGAYQUYETDINH,
            hg_f.FILESERVER_ID FILESID
        from HOAGIAI_DENGHI_KIENNGHI hg_dn_kn
        inner join HOAGIAI_DON hg_d on hg_d.ID = hg_dn_kn.HOAGIAIID
        left join DM_VKS vks on vks.ID = hg_dn_kn.DONVIKIENNGHIID
        left join '||L_TABLE_DS||' ds on ds.ID = hg_dn_kn.NGUOIDENGHIID
        left join HOAGIAI_FILE hg_f on hg_f.ID = hg_dn_kn.FILEID
        WHERE hg_d.VUVIECID = '||V_VUVIECID||'
        and hg_d.LOAIANID = '||V_LOAIANID;
      OPEN CURRETURN FOR L_STATEMENT;
   END GETLIST_DENGHIKIENNGHI;
   --Lấy danh sách kết quả giải quyết đề nghị kiến nghị
   PROCEDURE GETLIST_KETQUA_DENGHIKIENNGHI (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   BEGIN
      OPEN CURRETURN FOR SELECT 
            hg_dn_kn_kq.ID ID,
            DECODE(hg_dn_kn_kq.QUYETDINHID, 
                1, 'Huỷ QĐ công nhận HG/ĐT thành và giao cho toà án có thẩm quyền xem xét lại', 
                2, DECODE(V_LOAIANID,6, 'Không chấp nhận đề nghị/kiến nghị, giữ nguyên QĐ công nhận KQ Hoà giải thành', 'Không chấp nhận đề nghị/kiến nghị, giữ nguyên QĐ công nhận KQ Hoà giải thành'),
                3, 'Đình chỉ việc xem xét đề nghị, kiến nghị',
                '') KETQUA_TEXT, 
            dm_cb.hoten THAMPHAN_HOTEN,
            hg_dn_kn_kq.NGAYGIAO,
            hg_dn_kn_kq.NGAYNHAN,
            hg_dn_kn_kq.SOQUYETDINH,
            hg_dn_kn_kq.NGAYQUYETDINH,
            dm_toaan.TEN TOAAN_TRUC_THUOC
        FROM HOAGIAI_DENGHI_KIENNGHI_KETQUA hg_dn_kn_kq
        inner join HOAGIAI_DON hg_d on hg_d.ID = hg_dn_kn_kq.HOAGIAIID
        left join DM_CANBO dm_cb on dm_cb.ID = hg_dn_kn_kq.THAMPHANID
        left join DM_TOAAN dm_toaan on dm_toaan.ID = hg_dn_kn_kq.TOANHANID
        where hg_d.VUVIECID = V_VUVIECID and hg_d.LOAIANID = V_LOAIANID;
   END GETLIST_KETQUA_DENGHIKIENNGHI;
--Tìm kiếm đơn theo dnkn
   PROCEDURE GETLIST_VU_VIEC_KQDNKN (
      V_TOALOGIN IN NUMBER,
      V_LOAIANID  IN NUMBER,
      V_MAVUVIEC IN VARCHAR2,
      V_TENVUVIEC IN VARCHAR2,
      V_TUNGAY  IN VARCHAR2,
      V_DENNGAY  IN VARCHAR2,
      V_TINHTRANG IN NUMBER,
      Page_Index in	NUMBER,
      Page_Size	in	NUMBER,
      CURRETURN  OUT SYS_REFCURSOR
   ) AS
    L_STATEMENT VARCHAR2(2000);
    L_TABLE_DS VARCHAR2(20);
    VV_TU_NGAY DATE;
    VV_DEN_NGAY DATE;
    TotalItem number;  MinIndex number; MaxIndex number;
   BEGIN
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    IF(V_TUNGAY IS NOT NULL) THEN  VV_TU_NGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  END IF;
    IF(V_DENNGAY IS NOT NULL) THEN  VV_DEN_NGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); END IF;
   OPEN CURRETURN FOR select tt.*,
   DECODE(tt.KETQUAID,0,'Chưa giải quyết','Đã giải quyết') KETQUA
   from (   
	Select 
    ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,
    COUNT(*) OVER () as CountAll,
    d.*,dnkn.THONGTIN,
    t.TEN,
    --dnkn_kq.ID,
    -- 0 chưa giải quyết
    -- 1 Đã giải quyết
    Decode(dnkn_kq.quyetdinhid,null,0,1) KETQUAID
    from HOAGIAI_DON d 
	inner join (
		select HOAGIAIID,'<table class="tb-dnkn">'|| listagg(
		DECODE(LOAIID, 1, '<tr><td><b>Đề nghị: </b></td>', 2, '<tr><td><b>Kiến nghị: </b></td>', '') 
        ||'<td>'|| 
        TO_CHAR(nvl(NGAYDENGHI,NGAYKIENNGHI),'dd-mm-yyyy')
        || '</td></tr>'
		,'') within group( order by nvl(NGAYDENGHI,NGAYKIENNGHI) ) || '</table>' THONGTIN
		  from HOAGIAI_DENGHI_KIENNGHI
          where HOAGIAIID in (
            Select dnkn.HOAGIAIID from HOAGIAI_DENGHI_KIENNGHI dnkn
            where (V_TUNGAY IS NULL OR nvl(NGAYDENGHI,NGAYKIENNGHI) >=VV_TU_NGAY)
            AND (V_DENNGAY IS NULL OR nvl(NGAYDENGHI,NGAYKIENNGHI) <=VV_DEN_NGAY)

          )
          group by HOAGIAIID
	) dnkn
		on d.ID = dnkn.HOAGIAIID 
	inner join DM_TOAAN t ON t.ID = d.TOAANID
	left join HOAGIAI_DENGHI_KIENNGHI_KETQUA dnkn_kq on d.ID = dnkn_kq.HOAGIAIID
    where 
    d.LOAIANID = V_LOAIANID -- Lọc theo loại án
    AND t.CAPCHAID = V_TOALOGIN
    AND (1=(CASE WHEN (V_MAVUVIEC|| ' ')=' '   THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(V_MAVUVIEC) || '%')   THEN 1 END))
    AND (1=(CASE WHEN (V_TENVUVIEC|| ' ')=' '   THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(V_TENVUVIEC) || '%')  THEN 1  else 0 end))
    AND (CASE WHEN dnkn_kq.QUYETDINHID IS NOT NULL THEN 1 ELSE 0 END) = V_TINHTRANG
    /*AND Decode(dnkn_kq.ID,null,0,1) = V_TINHTRANG --Tình trạng giải quyết*/
)tt where tt.stt>=MinIndex and tt.stt<=MaxIndex; 
		--select HOAGIAIID, listagg(
		--DECODE(LOAIID, 1, '<b>Đề nghị: </b>', 2, '<b>Kiến nghị :</b>', '') || TO_CHAR(nvl(NGAYDENGHI,NGAYKIENNGHI),'dd-mm-yyyy')
		--,'</br>') within group( order by nvl(NGAYDENGHI,NGAYKIENNGHI) ) THONGTIN
		 -- from HOAGIAI_DENGHI_KIENNGHI group by HOAGIAIID
   END GETLIST_VU_VIEC_KQDNKN;
--End tìm kiếm đơn theo dnkn
PROCEDURE GETLIST_THONGBAO_DUONGSU (
      VTHONGBAOID   IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
       OPEN CURRETURN FOR SELECT * FROM HOAGIAI_THONGBAO_DUONGSU WHERE THONGBAOID = VTHONGBAOID;
   END GETLIST_THONGBAO_DUONGSU;

   PROCEDURE GETLIST_THONGBAO_KETQUA (
      V_HGDON   IN NUMBER,
      V_LOAIAN IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   L_TEXT VARCHAR2(255);
   L_TEXT2 VARCHAR2(255);
   BEGIN
    IF V_LOAIAN = LOAIAN_AHC THEN
        L_TEXT:='Đối thoại';
        L_TEXT2:='Không đối thoại';
    ELSE
        L_TEXT:='Hoà giải';
        L_TEXT2:='Không hoà giải';
    END IF;
   IF V_LOAIAN = LOAIAN_ADS THEN L_TABLE_DS :='ADS_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHN THEN L_TABLE_DS :='AHN_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AKT THEN L_TABLE_DS :='AKT_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_ALD THEN L_TABLE_DS :='ALD_DON_DUONGSU';
   ELSIF V_LOAIAN = LOAIAN_AHC THEN L_TABLE_DS :='AHC_DON_DUONGSU'; END IF;
    L_STATEMENT:= 'SELECT TBKQ.ID,
                        TB.ID THONGBAOID,
                        TB.SOLAN,
                        TB.SOTHONGBAO,
                        TB.NGAYTHONGBAO,
                        DS.TENDUONGSU || '' - '' || I.TEN TENDUONGSU,
                        TBKQ.NGAYDSTRALOI,
                        DECODE(TBKQ.LUACHONID, 1, '''|| L_TEXT||''', 2, '''||L_TEXT2||''',
                               3, ''Không trả lời'', '''') KETQUALUACHON,
                               CB.HOTEN HOAGIAIVIEN
                    FROM HOAGIAI_THONGBAO_KETQUA TBKQ
                    INNER JOIN HOAGIAI_THONGBAO TB ON TBKQ.THONGBAOID = TB.ID
                    LEFT JOIN HOAGIAI_FILE     F ON TB.FILEID = F.ID
                    LEFT JOIN QT_FILE     FSR ON FSR.ID = F.FILESERVER_ID
                    LEFT JOIN DM_CANBO CB ON CB.ID = TBKQ.HOAGIAIVIENID
                    LEFT JOIN '||L_TABLE_DS||'          DS ON DS.ID = TBKQ.DUONGSUID
                    LEFT JOIN DM_DATAITEM              I ON I.MA = DS.TUCACHTOTUNG_MA
                    WHERE TB.HOAGIAIID = '||V_HGDON ||' ORDER BY TB.NGAYTHONGBAO DESC';
--    DBMS_OUTPUT.PUT_LINE(L_STATEMENT);
      OPEN CURRETURN FOR L_STATEMENT;
   END GETLIST_THONGBAO_KETQUA;

    PROCEDURE GETLIST_DUONGSU_THONGBAO (
      V_VUVIECID   IN NUMBER,
      V_LOAIANID   IN NUMBER,
      V_THONGBAOID   IN NUMBER,
      CURRETURN OUT SYS_REFCURSOR
   ) AS
   L_STATEMENT VARCHAR2(2000);
   L_TABLE_DS VARCHAR2(20);
   BEGIN
        IF V_LOAIANID = LOAIAN_ADS THEN L_TABLE_DS :='ADS';
        ELSIF V_LOAIANID = LOAIAN_AHN THEN L_TABLE_DS :='AHN';
        ELSIF V_LOAIANID = LOAIAN_AKT THEN L_TABLE_DS :='AKT';
        ELSIF V_LOAIANID = LOAIAN_ALD THEN L_TABLE_DS :='ALD';
        ELSIF V_LOAIANID = LOAIAN_AHC THEN L_TABLE_DS :='AHC'; END IF;
        IF V_THONGBAOID IS NULL OR V_THONGBAOID = 0 THEN
            L_STATEMENT:='SELECT D.ID,D.TENDUONGSU || ''-''||I.TEN TENDUONGSU
            FROM '||L_TABLE_DS||'_DON_DUONGSU D LEFT JOIN DM_DATAITEM     I ON I.MA = D.TUCACHTOTUNG_MA
            WHERE D.ID IN ( SELECT MAX(ID) FROM '||L_TABLE_DS||'_DON_DUONGSU GROUP BY TENDUONGSU, NAMSINH, SOCMND ) AND D.ISDON = 1
                AND ( D.DONID = '||V_VUVIECID||' OR D.DONID IN ( SELECT ID FROM '||L_TABLE_DS||'_DON WHERE VUANGOCID = '||V_VUVIECID||' AND IS_TACHAN IS NULL ) )';
        ELSE
             L_STATEMENT:='SELECT D.ID,D.TENDUONGSU || ''-''||I.TEN TENDUONGSU
            FROM '||L_TABLE_DS||'_DON_DUONGSU D 
            LEFT JOIN DM_DATAITEM     I ON I.MA = D.TUCACHTOTUNG_MA
            INNER JOIN HOAGIAI_THONGBAO_DUONGSU HGD ON HGD.DUONGSUID = D.ID AND LOAIANID = '||V_LOAIANID||'
            WHERE HGD.THONGBAOID = '||V_THONGBAOID||'
            AND D.ID IN ( SELECT MAX(ID) FROM '||L_TABLE_DS||'_DON_DUONGSU GROUP BY TENDUONGSU, NAMSINH, SOCMND ) AND D.ISDON = 1
                AND ( D.DONID = '||V_VUVIECID||' OR D.DONID IN ( SELECT ID FROM '||L_TABLE_DS||'_DON WHERE VUANGOCID = '||V_VUVIECID||' AND IS_TACHAN IS NULL ) )';
        END IF;
       OPEN CURRETURN FOR L_STATEMENT;
   END GETLIST_DUONGSU_THONGBAO;
END PKG_GS_HOAGIAI;

/
