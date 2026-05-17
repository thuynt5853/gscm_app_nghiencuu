CREATE OR REPLACE PROCEDURE GSCM."AHC_SOTHAM_KCAOKNGHI_GETLIST" 
( vDonID in number,
	curReturn OUT sys_refcursor
)
IS 
--toancau
idCuoiDaGiaiQuyet number;
idCuoiDaGiaiQuyetKN number;

ISCHUYENAN NUMBER;
VTOAANID NUMBER;
--toancau
BEGIN
--toancau
    BEGIN
        SELECT
            MAX(ID)
        INTO IDCUOIDAGIAIQUYET
        FROM
            AHC_SOTHAM_KHANGCAO
        WHERE
            TINHTRANG_GIAIQUYET = 1
            AND DONID = VDONID;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IDCUOIDAGIAIQUYET := 0;
    END;
    
    BEGIN
        SELECT
            MAX(ID)
        INTO IDCUOIDAGIAIQUYETKN
        FROM
            AHC_SOTHAM_KHANGNGHI
        WHERE
            TINHTRANG_GIAIQUYET = 1
            AND DONID = VDONID;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IDCUOIDAGIAIQUYETKN := 0;
    END;
    
    BEGIN
        SELECT
            TOAANID
        INTO VTOAANID
        FROM
            AHC_DON
        WHERE
            ID = VDONID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN VTOAANID := 0;
    END;
    
    BEGIN
        SELECT
            (
                CASE
                    WHEN GNST.VUANID IS NULL THEN
                        0
                    ELSE
                        1
                END
            ) ISCHUYENAN into ISCHUYENAN
        FROM
            AHC_DON D
            LEFT JOIN (
                SELECT
                    CNA.ID,
                    CNA.VUANID,
                    CNA.TOACHUYENID
                FROM
                    (
                        SELECT
                            CA.ID,
                            CA.VUANID,
                            CA.TOACHUYENID,
                            ROW_NUMBER() OVER(
                                PARTITION BY CA.VUANID, CA.TOACHUYENID
                                ORDER BY
                                    CA.ID DESC
                            ) RN
                        FROM
                            AHC_CHUYEN_NHAN_AN CA
                        WHERE
                            CA.TOACHUYENID = VTOAANID
                    ) CNA
                WHERE
                    CNA.RN = 1
                    AND NOT EXISTS (
                        SELECT
                            'X'
                        FROM
                            AHC_CHUYEN_NHAN_AN   CN1
                            JOIN AHC_CHUYEN_NHAN_AN   CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                        WHERE
                            CN1.VUANID = CNA.VUANID
                            AND CN2.TOANHANID = VTOAANID
                            AND CN2.ID > CNA.ID
                    )
            ) GNST ON GNST.VUANID = D.ID
                      AND D.MAGIAIDOAN = 2
        WHERE
            D.ID = VDONID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN ISCHUYENAN := 0;
    END;
    --toancau
OPEN curReturn FOR  
  Select d.ID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
        ,(Case d.HINHTHUCNHAN WHEN 0 then 'Trực tiếp'
                              WHEN 1 then 'Qua bưu điện' End) as HTNhanDonDonViKN
--        ,s.TENDUONGSU as NguoiKCCapKN
        ,(decode(s.TENDUONGSU,null,lq.TENKC,s.TENDUONGSU) ||''|| decode(d.ISQUAHAN,1,decode(d.GQ_TINHTRANG,1,'<br>(Kháng cao quá hạn: Đã duyệt)','<br>(Kháng cao quá hạn: Chờ duyệt)'),'')) as NguoiKCCapKN
        
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' WHEN 1 THEN 'Quyết định' ELSE 'Quyết định khác' END) as LoaiKCKN
        ,d.NGAYKHANGCAO as NgayKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
        ,d.NGAYQDBA as NGAYQDBA
        ,d.NGUOITAO,d.NGAYTAO,d.TENFILE
        --toancau-anhnt thêm trường
        ,(case when d.TINHTRANG_GIAIQUYET = 1 then 'Đã giải quyết'
            when d.TINHTRANG_GIAIQUYET = 2 then 'Rút kháng cáo'
            else '' end) as TINHTRANG_GIAIQUYET
        ,(case when (idCuoiDaGiaiQuyet>0 and d.id <= idCuoiDaGiaiQuyet) OR D.GQ_TINHTRANG=1 OR d.TINHTRANG_GIAIQUYET = 2 OR ISCHUYENAN = 1 then 1 
        
        else 0 end)as READONLY, d.TOA_GIAIQUYET_ID
        --toancau-anhnt thêm trường
  From AHC_SOTHAM_KHANGCAO d 
  left join (select a.ID,a.TENDUONGSU||' -- '|| i.ten as TENDUONGSU from AHC_DON_DUONGSU a 
                                left join DM_DATAITEM i on i.MA=a.TUCACHTOTUNG_MA
                                    where a.DONID=vDonID) s on s.ID=d.DUONGSUID
  left join (select l.ID,l.HOTEN||' -- '|| i.ten as TENKC from AHC_DON_THAMGIATOTUNG l 
                            left join DM_DATAITEM i on i.MA=l.TUCACHTGTTID   
                                    where l.DONID=vDonID) lq on lq.ID=d.DUONGSUID
  left join (select e.ID,e.SOBANAN from AHC_SOTHAM_BANAN e where e.DONID=vDonID) b on b.ID=d.SOQDBA
  left join (select f.ID,f.SOQD from AHC_SOTHAM_QUYETDINH f where f.DONID=vDonID) q on q.ID=d.SOQDBA
  Where d.DONID=vDonID
  union
  Select d.ID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
        ,(Case d.DONVIKN WHEN 1 then 'Viện trưởng' else '' End) as HTNhanDonDonViKN
        ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án'  WHEN 1 THEN 'Quyết định' ELSE 'Quyết định khác' END) as LoaiKCKN
        ,d.NGAYKN as NgayKCKN
        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQD END) as SO_QDBA
        ,d.NGAYBANAN as NGAYQDBA
        ,d.NGUOITAO,d.NGAYTAO,d.TENFILE
        --toancau-anhnt thêm trường
        ,(case when d.TINHTRANG_GIAIQUYET = 1 then 'Đã giải quyết'
            when d.TINHTRANG_GIAIQUYET = 3 then 'Rút kháng nghị'
            else '' end) as TINHTRANG_GIAIQUYET
        ,(case when (idCuoiDaGiaiQuyetKN>0 and d.id <= idCuoiDaGiaiQuyetKN ) OR d.TINHTRANG_GIAIQUYET = 3 OR ISCHUYENAN = 1 then 1 
        else 0 end)as READONLY, d.TOA_GIAIQUYET_ID
        --toancau-anhnt thêm trường
  From AHC_SOTHAM_KHANGNGHI d 
  left join (select a.ID,a.SOBANAN from AHC_SOTHAM_BANAN a where a.DONID=vDonID) b on b.ID=d.BANANID
  left join (select c.ID,c.SOQD from AHC_SOTHAM_QUYETDINH c where c.DONID=vDonID) q on q.ID=d.BANANID
  Where d.DONID=vDonID;


END AHC_SOTHAM_KCaoKNghi_GETLIST;