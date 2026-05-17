--------------------------------------------------------
--  DDL for Package Body PKG_STPT_KHANGNGHIQUAHAN_TIMKIEM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_KHANGNGHIQUAHAN_TIMKIEM" 
AS

PROCEDURE        XLHC_PT_KNQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKN        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR

    			SELECT X.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY KN.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'BP XLHC' AS LOAIAN, 

                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

--                             NVL(QD1.SOBANAN,'') AS SOBAQD1,
--                             NVL(TO_CHAR(QD1.NGAYTUYENAN, 'DD/MM/YYYY'),'') AS NGAYBAQD,

                             KN.ID AS KHANGNGHI_SOTHAM_ID,
--                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.NGUOITGT, S.TENDUONGSU) AS NGUOIKHANGNGHI,
                             TO_CHAR(KN.NGAYKHANGCAO,'DD/MM/YYYY') AS NgayKN,
                      		-- Gộp xử lý tên người cấp KN/KC/nghị
							        CASE 
							            WHEN KN."TYPE" = 1 THEN 
							                COALESCE(LQ.NGUOITGT, DS.NGUOIBIDENGHI)
							            WHEN KN."TYPE" = 2 THEN 
							                A.CQDN_TEN
							            WHEN KN."TYPE" = 3 THEN 
							                VKS.TEN
							        END AS NguoiKCCapKN,
                             NVL(
								    NULLIF(TO_CHAR(QD1.SOBANAN), ''),
								    NVL(
								        NULLIF(TO_CHAR(HMA.SO_QUYETDINH), ''),
								        NULLIF(TO_CHAR(QD2.SOQD), '')
								    )
								) AS SOBAQD,
                             NVL(
							    NULLIF(TO_CHAR(QD1.NGAYTUYENAN, 'DD/MM/YYYY'), ''),
							    NVL(
							        NULLIF(TO_CHAR(HMA.GQ_NGAY, 'DD/MM/YYYY'), ''),
							        NULLIF(TO_CHAR(QD2.NGAYQD, 'DD/MM/YYYY'), '')
							    )
							) AS NGAYQD,
                          	 KN.NGUOITAO,
							 KN.NGAYTAO,
							 KN.TENFILE,
                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM XLHC_DON A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID
                          INNER JOIN XLHC_SOTHAM_KHANGCAO KN ON KN.DONID = A.ID
                          LEFT JOIN (SELECT QD.SOBANAN, QD.NGAYTUYENAN, QD.DONID, QD.QUYETDINHID 
                                     FROM XLHC_SOTHAM_BANAN QD
                                     ) QD1 ON KN.DONID = QD1.DONID AND QD1.QUYETDINHID = KN.SOQDBA
                          LEFT JOIN (SELECT DM.TEN, DM.ID, HM.SO_QUYETDINH, HM.DONID, HM.GQ_NGAY
                          FROM DM_QD_QUYETDINH DM
                          LEFT JOIN XLHC_DONXIN_HOAN_MIEN HM
                          ON HM.DM_QUYETDINH_ID = DM.ID
                          ) HMA ON KN.SOQDBA = HMA.ID AND KN.DONID = HMA.DONID
                          LEFT JOIN (SELECT QD.DONID, QD.QUYETDINHID, QD.NGAYQD, QD.SOQD
                          FROM XLHC_SOTHAM_QUYETDINH QD
                          ) QD2 ON QD2.QUYETDINHID = KN.SOQDBA AND QD2.DONID = KN.DONID

                          LEFT JOIN (SELECT dv.TEN, dv.ID
                         			FROM DM_VKS dv
                          ) VKS ON VKS.ID = KN.DUONGSUID
						-- join bảng đương sự (đơn khiếu nại type = 1)

						LEFT JOIN (
						        SELECT
						            ID, DONID,
						            HOTEN || ' - ' || TUCACH  AS NGUOITGT
						        FROM
						            (
						            SELECT
						                t.ID,
						                t.HOTEN,
						                t.DONID,
						                dt.TEN AS TUCACH
						            FROM
						                XLHC_DON_THAMGIATOTUNG t
						            LEFT JOIN DM_DATAITEM dt ON
						                t.TUCACHTGTTID = dt.MA
						        )
						    ) LQ ON LQ.ID = KN.DUONGSUID AND LQ.DONID = KN.DONID                                            
                          LEFT JOIN (
							        SELECT A.ID, A.DONID, A.HOTEN || ' - Người bị đề nghị' AS NGUOIBIDENGHI, A.HOTEN AS TENDUONGSU
							        FROM XLHC_DUONGSU A
							    ) DS ON DS.ID = KN.DUONGSUID AND DS.DONID = KN.DONID
--                          LEFT JOIN (SELECT A.ID, A.DONID, A.HOTEN AS TENDUONGSU 
--                                     FROM XLHC_DUONGSU A
--                                        ) S ON S.ID = KN.DUONGSUID AND S.DONID = KN.DONID

--                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKN 
--                                     FROM XLHC_DON_THAMGIATOTUNG L 
--                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = KN.DUONGSUID AND LQ.DONID = KN.DONID    
--					    LEFT JOIN (
--					        SELECT a.ID, a.CQDN_TEN AS TENDUONGSU
--					        FROM XLHC_DON a
--					    ) S ON S.ID = KN.DUONGSUID AND S.ID = KN.DONID

--						LEFT JOIN (SELECT TL.ID, TL.DONID, 
--                          TL.SOTHULY, TL.NGAYTHULY
--                                     FROM XLHC_SOTHAM_THULY TL 
--                                     ) THULY ON THULY.DONID = A.ID

--                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.DONID
--                                     FROM XLHC_SOTHAM_HDXX HDXX
--                                     WHERE HDXX.MAVAITRO LIKE 'THAMPHAN%'
--                                     GROUP BY HDXX.DONID) THAMPHAN ON THAMPHAN.DONID = THULY.ID 
--
--                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.DONID
--                                     FROM XLHC_SOTHAM_HDXX HDXX
--                                     WHERE HDXX.MAVAITRO LIKE 'THUKY%'
--                                     GROUP BY HDXX.DONID) THUKY ON THUKY.DONID = THULY.ID
--
					      LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND KN.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID
--                          LEFT JOIN XLHC_SOTHAM_QUYETDINH QD2 ON QD2.DONID = THULY.DONID 

                      WHERE 
                      		KN.GQ_TOAANID = VDONVIID AND
                      		KN.ISQUAHAN = 1 AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (  
                                (VSOBAQD IS NULL OR LOWER(QD1.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                 AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')
                                )
                               	OR
                               	(VSOBAQD IS NULL OR LOWER(HMA.SO_QUYETDINH) LIKE LOWER(VSOBAQD) || '%') 
                                 AND (VNGAYBAQD IS NULL OR TO_DATE(HMA.GQ_NGAY, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')
                                )
                                OR
                                (VSOBAQD IS NULL OR LOWER(QD2.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                 AND (VNGAYBAQD IS NULL OR TO_DATE(QD2.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')
                                )
                               	OR
                                (VSOBAQD IS NULL OR LOWER(QD.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     
                                )
                            )
                          	AND

                            (VNGUOIKN IS NULL OR LOWER(DS.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKN) || '%' OR LOWER(LQ.NGUOITGT) LIKE '%' || LOWER(VNGUOIKN) || '%'  
                            OR LOWER(DS.NGUOIBIDENGHI) LIKE '%' || LOWER(VNGUOIKN) || '%'
                            OR LOWER(VKS.TEN) LIKE '%' || LOWER(VNGUOIKN) || '%') AND
                            (VKCTUNGAY IS NULL OR KN.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR KN.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY'))) AND                       

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY'))) AND

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
--                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND KN.ID = THULY.KHANGCAOID
--                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND KN.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY')) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
--                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY')))
                                                                                )
                                                       )
                            ) AND

                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(KN.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY KN.NGAYKHANGCAO DESC
                    ) X
                    WHERE (X.STT >= VMININDEX AND X.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END XLHC_PT_KNQUAHAN;

PROCEDURE  ADS_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN 
	OPEN CURRETURN FOR SELECT 1 FROM DUAL;

END ADS_PT_KCQUAHAN_PRINT;

END PKG_STPT_KHANGNGHIQUAHAN_TIMKIEM;

/
