--------------------------------------------------------
--  DDL for Package Body PKG_STPT_DS_BC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_DS_BC" AS

PROCEDURE DS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,/*0: chưa chuyển; 1: đã chuyển*/
  vDonan in number,/*0: là đơn; 1: là vụ án*/
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS; -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
  BEGIN

  IF (vTrangthai=0 and vDonan = 0) then
  -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by dxl.NGAYGQ_YC DESC,d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG =>NULL,
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL,
        V_CHUYENNHANID=>NULL
      )-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d
      join ADS_DON_XULY dxl on dxl.DONID = d.ID
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And dxl.LOAIGIAIQUYET = 1
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1 Or d.MAGIAIDOAN=7)) --toancau-anhnt. thêm check pt tđc
                 OR(d.TOAPHUCTHAMID=vToaAnID and (d.MAGIAIDOAN=3  Or d.MAGIAIDOAN=7)) --toancau-anhnt. thêm check pt tđc
                 OR(d.TOAPHUCTHAMID=vToaAnID and (d.MAGIAIDOAN=3 Or d.MAGIAIDOAN=7)) --toancau-anhnt. thêm check pt tđc             
                )
           And (Select Count(ID) from ADS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0
           Order by dxl.NGAYGQ_YC DESC,d.TENVUVIEC;
           End IF;
    IF (vTrangthai=1 and vDonan = 0)then
    -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by cna.NGAYGIAO DESC,d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID,
        V_CHUYENNHANID=>CNA.ID
      )-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d  
      INNER JOIN ADS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      join ADS_DON_XULY dxl on dxl.DONID = d.ID
      WHERE 
            (
                (((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
                   And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))                      
                )
            OR -- TRƯỜNG HỢP CÓ ÁN PHÚC THẨM CHUYỂN VỀ
                (((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
                   And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (SELECT COUNT(QD1.ID) FROM ADS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1 Else 0 END))        
                )
            )     
            And dxl.LOAIGIAIQUYET = 1
            And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
            And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))         
            And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
            And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
            And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))  
            And (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
    Order by cna.NGAYGIAO DESC,d.TENVUVIEC;
    End If;
    IF (vTrangthai=0 and vDonan = 1) then
    -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by d.NGAYTAO DESC,d.TENVUVIEC),-- TOANCAU-24-05-2023 chuyển sttl.NGAYTHULY => d.NGAYTAO
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG =>NULL,
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL,
        V_CHUYENNHANID=>NULL
      )-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d
--      LEFT join ADS_SOTHAM_THULY sttl on sttl.DONID = d.ID
-- TOANCAU 04-04-2023 CHECK CHUYỂN NHẬN ÁN
    LEFT JOIN (
            SELECT
                CNA.ID,
                CNA.VUANID,
                CNA.TOACHUYENID
            FROM
                ADS_CHUYEN_NHAN_AN CNA
            WHERE
                CNA.TOACHUYENID = vToaAnID
        )                GNPT ON GNPT.VUANID = D.ID
                  AND D.MAGIAIDOAN IN ( 3, 7 )
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
                        ROW_NUMBER()
                        OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                             ORDER BY
                                 CA.ID DESC
                        ) RN
                    FROM
                        ADS_CHUYEN_NHAN_AN CA
                    WHERE
                        CA.TOACHUYENID = vToaAnID
                ) CNA
            WHERE
                    CNA.RN = 1
                AND NOT EXISTS (
                    SELECT
                        'X'
                    FROM
                             ADS_CHUYEN_NHAN_AN CN1
                        JOIN ADS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                    WHERE
                            CN1.VUANID = CNA.VUANID
                        AND CN2.TOANHANID = vToaAnID
                        AND CN2.ID > CNA.ID
                )
        )                GNST ON GNST.VUANID = D.ID
                  AND D.MAGIAIDOAN = 2
                  -- TOANCAU 04-04-2023 CHECK CHUYỂN NHẬN ÁN
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  (LOWER(vMavuviec)) THEN 1 Else 0 END))
            And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))

           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1 or d.MAGIAIDOAN =7 )--toancau-anhnt. thêm check pt tđc
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from ADS_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0
              --toancau-anhnt CHECK ĐÃ GIẢI QUYẾT CHƯA-ĐÃ RÚT TOÀN BỘ CHƯA
              and (kc.TINHTRANG_GIAIQUYET IS NULL OR kc.TINHTRANG_GIAIQUYET=0)
              and not exists (select 'x' from ads_sotham_rutkckn where ISKCKN = 1 and IDKCKN = kc.ID and TRANGTHAI =2))>0 
              --toancau-anhnt CHECK ĐÃ GIẢI QUYẾT CHƯA-ĐÃ RÚT TOÀN BỘ CHƯA
              --toancau-anhnt sửa lấy thêm kháng cáo quyết định khác
              
              Or (Select Count(kc.ID) from ADS_SOTHAM_KHANGCAO kc 
                                              inner join ADS_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                              inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                          where kc.DONID=d.ID and kc.LOAIKHANGCAO = 1
                                          and (kc.TINHTRANG_GIAIQUYET IS NULL OR kc.TINHTRANG_GIAIQUYET=0)
                                          and not exists (select 'x' from ads_sotham_rutkckn where ISKCKN = 1 and IDKCKN = kc.ID and TRANGTHAI =2))>0 
            or (Select Count(kc.ID) from ADS_SOTHAM_KHANGCAO kc 
                                              inner join ADS_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                              inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 0
                                          where kc.DONID=d.ID and kc.LOAIKHANGCAO = 2
                                          and (kc.TINHTRANG_GIAIQUYET IS NULL OR kc.TINHTRANG_GIAIQUYET=0)
                                          and not exists (select 'x' from ads_sotham_rutkckn where ISKCKN = 1 and IDKCKN = kc.ID and TRANGTHAI =2))>0 
              --toancau-anhnt sửa lấy thêm kháng cáo quyết định khác
              Or (Select Count(kn.ID) from ADS_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID 
              --toancau-anhnt CHECK ĐÃ GIẢI QUYẾT CHƯA-ĐÃ RÚT TOÀN BỘ CHƯA
              and (kn.TINHTRANG_GIAIQUYET IS NULL OR kn.TINHTRANG_GIAIQUYET=0) 
              and not exists (select 'x' from ads_sotham_rutkckn where ISKCKN = 2 and IDKCKN = kn.ID and TRANGTHAI =2))>0)
                     --toancau-anhnt CHECK ĐÃ GIẢI QUYẾT CHƯA-ĐÃ RÚT TOÀN BỘ CHƯA
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           --And sttl.TRUONGHOPTHULY > 0
              )
              Or
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from ADS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and k.MA in ('04','06'))>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
             -- Hiển thị Quyết định gây kết thúc (Phúc thẩm)
             Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM ADS_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM ADS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ADS_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ADS_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
------------------------toancau-anhnt. thêm check pt tđc
            Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ADS_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ADS_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
            ------------------------toancau-anhnt. thêm check pt tđc
--            Or (d.TOAPHUCTHAMID=vToaAnID and (d.MAGIAIDOAN=3  or d.MAGIAIDOAN =7 ))--toancau-anhnt-30-03-2023 bỏ đi
              )
           --  And (Select Count(ID) from ADS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0
           --TOANCAU 04-04-2023-ANHNT THÊM CHECK ĐÃ NHẬN RỒI THÌ CÓ THỂ CHUYỂN TIẾP
           --anhvh // 13/11/2023 đóng lại để test thêm
            AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND GNPT.ID IS NULL ) THEN
                                1
                            ELSE
                                0
                        END
                    )
           Order by d.NGAYTAO DESC,d.TENVUVIEC;-- TOANCAU-24-05-2023 chuyển sttl.NGAYTHULY => d.NGAYTAO
--TOANCAU 04-04-2023-ANHNT THÊM CHECK ĐÃ NHẬN RỒI THÌ CÓ THỂ CHUYỂN TIẾP
           End IF;
   IF (vTrangthai=1 and vDonan = 1) then
   -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by cna.NGAYGIAO DESC,d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,--TOANCAU - 01-04-2023 LẤY NỘI DUNG TỪ BẢNH CHUYỂN NHẬN ÁN
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID,
        V_CHUYENNHANID=>CNA.ID
      )-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d  
      INNER JOIN ADS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID  
      --      LEFT join ADS_SOTHAM_THULY sttl on sttl.DONID = d.ID TOANCAU-24-05-2023 bỏ
      WHERE 
            (
                (((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
                   And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))                      
                )
            OR -- TRƯỜNG HỢP CÓ ÁN PHÚC THẨM CHUYỂN VỀ
                (((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
                   And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (SELECT COUNT(QD1.ID) FROM ADS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1 Else 0 END))        
                )
            )  
            ------ tuanvna
            And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM ADS_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM ADS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM ADS_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                        WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                    ELSE 0 END)

            --And 1=(CASE WHEN d.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)
            And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
            And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))         
            And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
            And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
            And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))  
            And (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
    Order by d.NGAYTAO DESC,d.TENVUVIEC;-- TOANCAU-24-05-2023 chuyển sttl.NGAYTHULY => d.NGAYTAO
   End If;

    FILL_DS_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
   FROM TABLE(v_ARRAY)PA;
END DS_CHUYENAN;  
PROCEDURE FILL_DS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
)
AS
     V_EXPORT_TEXT CLOB;
     V_NOIDUNGNHANAN CLOB;
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM ADS_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         FOR items in (

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                     ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NOIDUNG
                FROM ADS_SOTHAM_KHANGCAO T2
                    INNER JOIN ADS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                     --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN

                UNION ALL

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))  --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                     ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NOIDUNG
                FROM ADS_SOTHAM_KHANGCAO T2
                    INNER JOIN ADS_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO  in (1,2) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- Tổng hợp kháng nghị
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
--        INNER JOIN ADS_SOTHAM_KHANGNGHI T2 ON T2.DONID=(case when not exists(select 'x' from ads_don where ID = T1.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
--                                    then T1.v_VUANID else
--                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = T1.v_VUANID and rownum =1) end)
    ) LOOP
    --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM ADS_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
        FOR items in (

            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENAN.(kháng nghị)*/ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM ADS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quyết định
                          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          LEFT JOIN ADS_SOTHAM_RUTKCKN RUT ON T2.ID = RUT.IDKCKN
                           --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                  AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác

                                   -- and T2.ID NOT IN (select T.ID from ADS_SOTHAM_KHANGNGHI T where T.TINHTRANG_GIAIQUYET != 0 )
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau-anhnt check lỗi ko có kháng nghị
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check lỗi ko có kháng nghị
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
     END LOOP;



END;
PROCEDURE DS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
    v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  vDonan in number,--toancau-anhnt thêm trường check là đơn hay án
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
  --toancau-anhnt tìm theo đơn
  If (vDonan = 0) then
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Dân sự',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM ADS_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN ADS_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    join ADS_DON_XULY dxl on dxl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            And dxl.LOAIGIAIQUYET = 1
	  Order by a.NGAYGIAO DESC;
     else
     --toancau-anhnt tìm theo đơn
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Dân sự',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM ADS_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN ADS_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    --LEFT join ADS_SOTHAM_THULY sttl on sttl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            --And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)
            --tuanvna
--TOANCAU-29-06-2023 
             And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM ADS_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ('41-DS','42-DS')) and QD1.donid = c.id) or exists (SELECT 'X' FROM ADS_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM ADS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) THEN 1
                    ELSE 0 END)
	  Order by a.NGAYGIAO DESC;
      End If;--toancau-anhnt tìm theo đơn

  FILL_DS_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)A WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM ADS_SOTHAM_KHANGCAO T2
                            INNER JOIN ADS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM ADS_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )     
             ;
END DS_NHANAN;
PROCEDURE FILL_DS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)
AS
     V_EXPORT_TEXT CLOB; 
     V_NOIDUNGNHANAN CLOB;--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
BEGIN 

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU - 17-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM ADS_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 17-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
             FOR items in (
                    SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_NHANAN.(kháng cáoị)*/ T2.DONID,T2.DUONGSUID,
                        '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                        LISTAGG(
                        '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || nvl(QD.SOQD,QD2.SOQD) || ', Ngày: ' || TO_CHAR(nvl(QD.NGAYQD,QD2.NGAYQD),'dd/MM/yyyy')) --toancau-anhnt: thêm  nvl(QD.SOQD,QD2.SOQD) kc tđc
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                        ,',')
                        WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                        NOIDUNG
                    FROM ADS_SOTHAM_KHANGCAO T2
                        INNER JOIN ADS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                        left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                        LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                        LEFT JOIN ADS_SOTHAM_QUYETDINH QD2 ON QD2.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=2 --> Kháng cáo quyết định --toancau-anhnt kc tđc
                        LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                    --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                        --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN

                    UNION ALL

                    SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HN_CHUYENAN.(kháng cáoị)*/ T2.DONID,T2.DUONGSUID,
                        '<b> - '||DM.TEN||': '||T3.HOTEN||'</b><br/> '||
                        LISTAGG(
                        '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || nvl(QD.SOQD,QD2.SOQD) || ', Ngày: ' || TO_CHAR(nvl(QD.NGAYQD,QD2.NGAYQD),'dd/MM/yyyy')) --toancau-anhnt: thêm  nvl(QD.SOQD,QD2.SOQD) kc tđc
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                        ,',')
                        WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NOIDUNG
                    FROM ADS_SOTHAM_KHANGCAO T2
                        INNER JOIN ADS_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                        left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                        LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                        LEFT JOIN ADS_SOTHAM_QUYETDINH QD2 ON QD2.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=2 --> Kháng cáo quyết định --toancau-anhnt kc tđc
                        LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                     --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                     --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    GROUP BY T2.DONID,T2.DUONGSUID,T3.HOTEN,DM.TEN
             )
              LOOP
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
              END LOOP;
             dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
             DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
             DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
             --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- Tổng hợp kháng nghị
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --toancau 29-03-2023-anhnt bỏ vì làm nhân đôi nội dung
--        INNER JOIN ADS_SOTHAM_KHANGNGHI T2 ON T2.DONID=(case when not exists(select 'x' from ads_don where ID = T1.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
--                                    then T1.v_VUANID else
--                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = T1.v_VUANID and rownum =1) end)
    ) LOOP
    --TOANCAU - 17-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'|| NOIDUNG INTO V_NOIDUNGNHANAN
        FROM ADS_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 17-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_NHANAN.(kháng nghi)*/  T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || nvl(QD.SOQD,QD2.SOQD) || ', Ngày: ' || TO_CHAR(nvl(QD.NGAYQD,QD2.NGAYQD),'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM ADS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                        LEFT JOIN ADS_SOTHAM_QUYETDINH QD2 ON QD2.ID=T2.BANANID AND T2.LOAIKN=2 --> Kháng cáo quyết định --toancau-anhnt kc tđc
                           --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ads_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                 --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau 29-03-2023-anhnt check lỗi ko có kháng nghị
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau 29-03-2023-anhnt check lỗi ko có kháng nghị
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
     END LOOP;

END;

PROCEDURE HN_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS;
  BEGIN

  IF vTrangthai=0 then
        -- TOANCAU  LẤY THÊM TRƯỜNG
            SELECT R_CHUYENAN_STPT_GS(
                v_STT =>row_number() over (order by nvl(d.ID,0)),
                v_VUANID => d.ID,
                v_TOAANID =>vToaAnID,
                v_TENVUAN =>d.TENVUVIEC,
                v_MAVUAN =>d.MAVUVIEC,
                v_NGAYCHUYEN =>NULL,
                v_NGAYNHAN =>NULL,
                v_NGAYTHULY =>NULL,
                v_NOIDUNG =>NULL,
                v_TOANHAN =>NULL,
                v_LYDOID =>NULL,
                V_CHUYENNHANID=>NULL
              )-- TOANCAU  LẤY THÊM TRƯỜNG
              BULK COLLECT INTO v_ARRAY
              FROM AHN_DON d
              -- TOANCAU 04-04-2023 CHECK CHUYỂN NHẬN ÁN
                LEFT JOIN (
                        SELECT
                            CNA.ID,
                            CNA.VUANID,
                            CNA.TOACHUYENID
                        FROM
                            AHN_CHUYEN_NHAN_AN CNA
                        WHERE
                            CNA.TOACHUYENID = vToaAnID
                    )                GNPT ON GNPT.VUANID = D.ID
                              AND D.MAGIAIDOAN IN ( 3, 7 )
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
                                    ROW_NUMBER()
                                    OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                                         ORDER BY
                                             CA.ID DESC
                                    ) RN
                                FROM
                                    AHN_CHUYEN_NHAN_AN CA
                                WHERE
                                    CA.TOACHUYENID = vToaAnID
                            ) CNA
                        WHERE
                                CNA.RN = 1
                            AND NOT EXISTS (
                                SELECT
                                    'X'
                                FROM
                                         AHN_CHUYEN_NHAN_AN CN1
                                    JOIN AHN_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = vToaAnID
                                    AND CN2.ID > CNA.ID
                            )
                    )                GNST ON GNST.VUANID = D.ID
                              AND D.MAGIAIDOAN = 2
                              -- TOANCAU 04-04-2023 CHECK CHUYỂN NHẬN ÁN
              WHERE 
                   (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHN_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
                   And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                         And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                         And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
                   And ((Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
                      Or (Select Count(kc.ID) from AHN_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0 and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0 
                      Or (Select Count(kc.ID) from AHN_SOTHAM_KHANGCAO kc 
                                                      inner join AHN_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                    Or (Select Count(kc.ID) from AHN_SOTHAM_KHANGCAO kc 
                                                      inner join AHN_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.MA IN ('41-DS','42-DS')
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                      Or (Select Count(kn.ID) from AHN_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID and nvl(kn.tinhtrang_giaiquyet,0) = 0)>0)
                   And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                   And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      )
                      OR
                        (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN in (3,7) --toancau-anhnt thêm check án tđc
                           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                           And (Select Count(b.ID) from AHN_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                                Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                          And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                          And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                        )
                  Or -- Hiển thị Quyết định gây kết thúc (Phúc thẩm)
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                    AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AHN_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                        AND (SELECT COUNT(QD1.ID) FROM AHN_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                      And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHN_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHN_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  )

                        --toancau-linhnd
                        Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHN_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHN_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              --toancau-linhnd

                      )
                  -- And (Select Count(ID) from AHN_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
                  --TOANCAU-ANHNT THÊM CHECK ĐÃ NHẬN RỒI THÌ CÓ THỂ CHUYỂN TIẾP
                 AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND GNPT.ID IS NULL ) THEN
                                1
                            ELSE
                                0
                        END
                    )
               Order by d.ID;
                --TOANCAU-ANHNT THÊM CHECK ĐÃ NHẬN RỒI THÌ CÓ THỂ CHUYỂN TIẾP
       Else
        SELECT R_CHUYENAN_STPT_GS(
            v_STT =>row_number() over (order by d.TENVUVIEC),
            v_VUANID => d.ID,
            v_TOAANID =>vToaAnID,
            v_TENVUAN =>d.TENVUVIEC,
            v_MAVUAN =>d.MAVUVIEC,
            v_NGAYCHUYEN =>cna.NGAYGIAO,
            v_NGAYNHAN =>cna.NGAYNHAN,
            v_NGAYTHULY =>NULL,
            v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,
            v_TOANHAN =>ta.TEN,
            v_LYDOID =>cna.TRUONGHOPGIAONHANID,
            V_CHUYENNHANID=>CNA.ID
          )
          BULK COLLECT INTO v_ARRAY
          FROM AHN_DON d  
          INNER JOIN AHN_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
          INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
          WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))                
               ------ tuanvna
               And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM AHN_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AHN_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AHN_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                        WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                    ELSE 0 END)
               And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
               And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
               And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHN_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
               And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
               AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
        Order by d.TENVUVIEC;
   End If;
    FILL_HN_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU L?Y THÊM TR??NG
   FROM TABLE(v_ARRAY)PA;
END HN_CHUYENAN;  
PROCEDURE FILL_HN_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS
)
AS
     V_EXPORT_TEXT CLOB; 
     V_NOIDUNGNHANAN CLOB;
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU neu khong co noi dung thi khong update
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 then
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AHN_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  neu khong co noi dung thi khong update
         FOR items in (
                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||decode(T3.TUCACHTOTUNG_MA,'NGUYENDON','Người khởi kiện','BIDON','Người bị kiện','QUYENNVLQ','Người có quyền và NVLQ',' ('||T3.TUCACHTOTUNG_MA || ')' )||':'||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM AHN_SOTHAM_KHANGCAO T2
                    INNER JOIN AHN_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt thêm check kc q? khác
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ahn_don where ID = ITEM.v_VUANID and AHN_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahn_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TUCACHTOTUNG_MA,T3.TENDUONGSU,DM.TEN

                UNION ALL

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||decode(T3.TUCACHTGTTID,'NGUYENDON','Người khởi kiện','BIDON','Người bị kiện','QUYENNVLQ','Người có quyền và NVLQ',' ('||T3.TUCACHTGTTID || ')' )||':'||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM AHN_SOTHAM_KHANGCAO T2
                    INNER JOIN AHN_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt thêm check kc q? khác
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from AHN_don where ID = ITEM.v_VUANID and AHN_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahn_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TUCACHTGTTID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN AHN_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID --toancau-anhnt b? vì gây duplicated n?i dung kháng cáo
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AHN_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM AHN_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt l?y thêm kháng ngh? q? khác
                          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ahn_don where ID = ITEM.v_VUANID and AHN_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahn_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                   AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
             DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau-anhnt check l?i ko có kháng ngh? 
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;
PROCEDURE HN_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
    v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Hôn nhân - Gia đình',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM AHN_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN AHN_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    --LEFT join AHN_SOTHAM_THULY sttl on sttl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            --And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)            
            --tuanvna
--TOANCAU-29-06-2023
            And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM AHN_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ('41-DS','42-DS')) and QD1.donid = c.id) or exists (SELECT 'X' FROM AHN_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM AHN_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) THEN 1
                    ELSE 0 END)
	  Order by a.NGAYGIAO DESC;

  FILL_HN_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)A WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM AHN_SOTHAM_KHANGCAO T2
                            INNER JOIN AHN_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM AHN_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )     
             ;
END HN_NHANAN;
PROCEDURE FILL_HN_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)AS
    V_EXPORT_TEXT   clob;
V_NOIDUNGNHANAN CLOB;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM AHN_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
             SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HN_NHANAN ( kháng cao)*/  T2.DONID,T2.DUONGSUID,
                     '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                     LISTAGG(
                     '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                         ,',')
                     WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                   NOIDUNG
                  FROM ahn_SOTHAM_KHANGCAO T2
                  LEFT JOIN ahn_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                  left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                  LEFT JOIN ahn_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anhnt kc t?c
                  LEFT JOIN ahn_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                  --toancau 30-03-2023-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    WHERE T2.DONID=(case when not exists(select 'x' from ahn_don where ID = ITEM.v_VUANID and AHN_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from ahn_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                        --toancau 30-03-2023-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                  GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN ahn_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID--toancau  anhnt b? vì làm nhân ?ôi n?i dung
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM Ahn_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HN_NHANAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM ahn_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN ahn_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anhnt kc t?c
                          LEFT JOIN ahn_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau 30-03-2023-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahn_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                 --toancau 30-03-2023-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         --toancau -anhnt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau -anhnt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;

PROCEDURE KT_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS; -- TOANCAU  L?Y THÊM TR??NG
  BEGIN

  IF vTrangthai=0 then
  -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by NVL(D.ID,0)),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG =>NULL,
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL,
        V_CHUYENNHANID=>NULL
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM AKT_DON d
      -- TOANCAU CHECK CHUY?N NH?N ÁN
    LEFT JOIN (
            SELECT
                CNA.ID,
                CNA.VUANID,
                CNA.TOACHUYENID
            FROM
                AKT_CHUYEN_NHAN_AN CNA
            WHERE
                CNA.TOACHUYENID = vToaAnID
        )                GNPT ON GNPT.VUANID = D.ID
                  AND D.MAGIAIDOAN IN ( 3, 7 )
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
                        ROW_NUMBER()
                        OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                             ORDER BY
                                 CA.ID DESC
                        ) RN
                    FROM
                        AKT_CHUYEN_NHAN_AN CA
                    WHERE
                        CA.TOACHUYENID = vToaAnID
                ) CNA
            WHERE
                    CNA.RN = 1
                AND NOT EXISTS (
                    SELECT
                        'X'
                    FROM
                             AKT_CHUYEN_NHAN_AN CN1
                        JOIN AKT_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                    WHERE
                            CN1.VUANID = CNA.VUANID
                        AND CN2.TOANHANID = vToaAnID
                        AND CN2.ID > CNA.ID
                )
        )                GNST ON GNST.VUANID = D.ID
                  AND D.MAGIAIDOAN = 2
                  -- TOANCAU CHECK CHUY?N NH?N ÁN
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AKT_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AKT_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
               Or (Select Count(kc.ID) from AKT_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0 and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0 
                      Or (Select Count(kc.ID) from AKT_SOTHAM_KHANGCAO kc 
                                                      inner join AKT_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                    Or (Select Count(kc.ID) from AKT_SOTHAM_KHANGCAO kc 
                                                      inner join AKT_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.MA IN ('41-DS','42-DS')
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                      Or (Select Count(kn.ID) from AKT_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID and nvl(kn.tinhtrang_giaiquyet,0) = 0)>0)
              --toancau-anhnt CHECK ?Ã GI?I QUY?T CH?A-?Ã RÚT TOÀN B? CH?A
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AKT_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from AKT_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              Or -- Hiển thị Quyết định gây kết thúc (Phúc thẩm) (vd: 72-DS)
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                    AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AKT_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                        AND (SELECT COUNT(QD1.ID) FROM AKT_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                      And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AKT_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AKT_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  )
                ------------------------toancau-anhnt. thêm check pt t?c
            Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AKT_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AKT_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
--                  And pttl.TRUONGHOPTHULY > 0

              )
------------------------toancau-anhnt. thêm check pt t?c
              )
--           And (Select Count(ID) from AKT_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
           --TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
            AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND GNPT.ID IS NULL ) THEN
                                1
                            ELSE
                                0
                        END
                    )
           Order by d.ID;
--TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
   Else
   -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,--TOANCAU - L?Y N?I DUNG T? B?NH CHUY?N NH?N ÁN
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID,
        V_CHUYENNHANID=>CNA.ID
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM AKT_DON d  
      INNER JOIN AKT_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           ------ tuanvna
           And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM AKT_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AKT_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AKT_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                    WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                ELSE 0 END)
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AKT_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AKT_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
           AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
    Order by d.TENVUVIEC;
   End If;
    FILL_KT_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU L?Y THÊM TR??NG
   FROM TABLE(v_ARRAY)PA;
END KT_CHUYENAN;  
PROCEDURE FILL_KT_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU  L?Y THÊM TR??NG
)
AS
     V_EXPORT_TEXT CLOB; 
      V_NOIDUNGNHANAN CLOB;-- TOANCAU  L?Y THÊM TR??NG
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
        FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AKT_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         FOR items in (
         
                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                     ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NOIDUNG
                FROM AKT_SOTHAM_KHANGCAO T2
                    INNER JOIN AKT_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                     --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from akt_don where ID = ITEM.v_VUANID and AKT_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN

                UNION ALL

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))  --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                     ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NOIDUNG
                FROM AKT_SOTHAM_KHANGCAO T2
                    INNER JOIN AKT_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO  in (1,2) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from akt_don where ID = ITEM.v_VUANID and AKT_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd nếu có rút kháng cáo toàn bộ thì không hiển thị ở phần chuyển án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- Tổng hợp kháng nghị
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
--        INNER JOIN AKT_SOTHAM_KHANGNGHI T2 ON T2.DONID=(case when not exists(select 'x' from akt_don where ID = T1.v_VUANID and AKT_DON.MAGIAIDOAN = 7) 
--                                    then T1.v_VUANID else
--                                    (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = T1.v_VUANID and rownum =1) end)
    ) LOOP
    --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AKT_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU - 01-04-2023 NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
        FOR items in (
       
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENAN.(kháng nghị)*/ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM AKT_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quyết định
                          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          LEFT JOIN AKT_SOTHAM_RUTKCKN RUT ON T2.ID = RUT.IDKCKN
                           --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from akt_don where ID = ITEM.v_VUANID and AKT_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                  AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                                    
                                   -- and T2.ID NOT IN (select T.ID from AKT_SOTHAM_KHANGNGHI T where T.TINHTRANG_GIAIQUYET != 0 )
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau-anhnt check lỗi ko có kháng nghị
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check lỗi ko có kháng nghị
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;
PROCEDURE KT_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Kinh tế',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
     from AKT_CHUYEN_NHAN_AN a  
     inner join DM_TOAAN b on a.TOACHUYENID=b.ID  
     inner join AKT_DON c on a.VUANID=c.ID
     inner join DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
                    And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
                    And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))            --And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)            
        --tuanvna
--TOANCAU-29-06-2023
            And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM AKT_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ('41-DS','42-DS')) and QD1.donid = c.id) or exists (SELECT 'X' FROM AKT_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM AKT_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) THEN 1
                    ELSE 0 END)
  Order by a.NGAYGIAO DESC; 
  FILL_KT_NHANAN(v_ARRAY);
   OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)  A WHERE   
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM AKT_SOTHAM_KHANGCAO T2
                            INNER JOIN AKT_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM AKT_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              ) 
             ;
END KT_NHANAN;
PROCEDURE FILL_KT_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)
AS
     V_EXPORT_TEXT CLOB; 
     V_NOIDUNGNHANAN CLOB;
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM AKT_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         FOR items in (
             SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HN_NHANAN ( kháng cao)*/  T2.DONID,T2.DUONGSUID,
                     '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                     LISTAGG(
                     '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                         ,',')
                     WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                   NOIDUNG
                  FROM AKT_SOTHAM_KHANGCAO T2
                  LEFT JOIN AKT_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                  left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                  LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO IN (1,2) --> Kháng cáo quyết định--toancau-anhnt kc tđc
                  LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                    WHERE T2.DONID=(case when not exists(select 'x' from akt_don where ID = ITEM.v_VUANID and AKT_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                        --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                  GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN AKT_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID--toancau  anhnt bỏ vì làm nhân đôi nội dung
    ) LOOP
    --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM AKT_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HN_NHANAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM AKT_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 -->  Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from akt_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                 --toancau 30-03-2023-anhnt thêm check nếu là án pttdc thì lấy thông tin sơ thẩm từ đơn khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
--toancau -anhnt check lỗi ko có kháng nghị
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau -anhnt check lỗi ko có kháng nghị
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  NẾU CÓ NỘI DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;

PROCEDURE HC_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS;
  BEGIN
        IF vTrangthai=0 then
        -- TOANCAU  L?Y THÊM TR??NG
            SELECT R_CHUYENAN_STPT_GS(
                v_STT =>row_number() over (order by nvl(d.ID,0)),
                v_VUANID => d.ID,
                v_TOAANID =>vToaAnID,
                v_TENVUAN =>d.TENVUVIEC,
                v_MAVUAN =>d.MAVUVIEC,
                v_NGAYCHUYEN =>NULL,
                v_NGAYNHAN =>NULL,
                v_NGAYTHULY =>NULL,
                v_NOIDUNG =>NULL,
                v_TOANHAN =>NULL,
                v_LYDOID =>NULL,
                V_CHUYENNHANID=>NULL
              )-- TOANCAU  L?Y THÊM TR??NG
              BULK COLLECT INTO v_ARRAY
              FROM AHC_DON d
              -- TOANCAU 04-04-2023 CHECK CHUY?N NH?N ÁN
                LEFT JOIN (
                        SELECT
                            CNA.ID,
                            CNA.VUANID,
                            CNA.TOACHUYENID
                        FROM
                            AHC_CHUYEN_NHAN_AN CNA
                        WHERE
                            CNA.TOACHUYENID = vToaAnID
                    )                GNPT ON GNPT.VUANID = D.ID
                              AND D.MAGIAIDOAN IN ( 3, 7 )
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
                                    ROW_NUMBER()
                                    OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                                         ORDER BY
                                             CA.ID DESC
                                    ) RN
                                FROM
                                    AHC_CHUYEN_NHAN_AN CA
                                WHERE
                                    CA.TOACHUYENID = vToaAnID
                            ) CNA
                        WHERE
                                CNA.RN = 1
                            AND NOT EXISTS (
                                SELECT
                                    'X'
                                FROM
                                         AHC_CHUYEN_NHAN_AN CN1
                                    JOIN AHC_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = vToaAnID
                                    AND CN2.ID > CNA.ID
                            )
                    )                GNST ON GNST.VUANID = D.ID
                              AND D.MAGIAIDOAN = 2
                              -- TOANCAU 04-04-2023 CHECK CHUY?N NH?N ÁN
              WHERE 
                   (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
                   And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHC_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
                   And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                         And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                         And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
                   And ((Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
                      Or (Select Count(kc.ID) from AHC_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0 and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0 
                      Or (Select Count(kc.ID) from AHC_SOTHAM_KHANGCAO kc 
                                                      inner join AHC_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                    Or (Select Count(kc.ID) from AHC_SOTHAM_KHANGCAO kc 
                                                      inner join AHC_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.MA IN ('10-HC','11-HC')
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                      Or (Select Count(kn.ID) from AHC_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID and nvl(kn.tinhtrang_giaiquyet,0) = 0)>0)
                   And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                   And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      )
                      OR
                        (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN in (3,7) --toancau-anhnt thêm check án t?c
                           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                           And (Select Count(b.ID) from AHC_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                                Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                          And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                          And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                        )
                  Or -- Hi?n th? Quy?t ??nh gây k?t thúc (Phúc th?m) (vd: 72-DS)
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                    AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AHC_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                        AND (SELECT COUNT(QD1.ID) FROM AHC_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                      And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHC_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHC_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  )

                        --toancau-linhnd
                        Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND DMQD.MA in ( '14-HC','15-HC','40-HC','41-HC','43-HC')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHC_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM AHC_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              --toancau-linhnd

                      )
                  -- And (Select Count(ID) from AHC_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
                  --TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
                 AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND GNPT.ID IS NULL ) THEN
                                1
                            ELSE
                                0
                        END
                    )
               Order by d.ID;
                --TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
       Else
        SELECT R_CHUYENAN_STPT_GS(
            v_STT =>row_number() over (order by d.TENVUVIEC),
            v_VUANID => d.ID,
            v_TOAANID =>vToaAnID,
            v_TENVUAN =>d.TENVUVIEC,
            v_MAVUAN =>d.MAVUVIEC,
            v_NGAYCHUYEN =>cna.NGAYGIAO,
            v_NGAYNHAN =>cna.NGAYNHAN,
            v_NGAYTHULY =>NULL,
            v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,--TOANCAU - L?Y N?I DUNG T? B?NH CHUY?N NH?N ÁN,
            v_TOANHAN =>ta.TEN,
            v_LYDOID =>cna.TRUONGHOPGIAONHANID,
            V_CHUYENNHANID=>CNA.ID
          )
          BULK COLLECT INTO v_ARRAY
          FROM AHC_DON d  
          INNER JOIN AHC_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
          INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
          WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
               ------ tuanvna
               And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM AHC_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AHC_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                        WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM AHC_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                        WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('14-HC','15-HC','40-HC','41-HC','43-HC')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                    ELSE 0 END)
               And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
               And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
               And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHC_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
               And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
               And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
               AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
        Order by d.TENVUVIEC;
       End If;
   FILL_HC_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU L?Y THÊM TR??NG
   FROM TABLE(v_ARRAY)PA;
END HC_CHUYENAN;  
PROCEDURE FILL_HC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU  L?Y THÊM TR??NG
)
AS
     V_EXPORT_TEXT CLOB; 
      V_NOIDUNGNHANAN CLOB;-- TOANCAU  L?Y THÊM TR??NG
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Ch? c?n update v_NOIDUNG
  -- T?ng h?p kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AHC_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM AHC_SOTHAM_KHANGCAO T2
                    INNER JOIN AHC_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt kc t?c
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from AHC_don where ID = ITEM.v_VUANID and AHC_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from AHC_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN

                UNION ALL 

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM AHC_SOTHAM_KHANGCAO T2
                    INNER JOIN AHC_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt kc t?c
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from AHC_don where ID = ITEM.v_VUANID and AHC_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from AHC_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
--        INNER JOIN AHC_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID --toancau-tamnc b? vì gây duplicated n?i dung kháng nghị 
    ) LOOP
     --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM AHC_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT  /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                           FROM AHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quyết định
                          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          LEFT JOIN AHC_SOTHAM_RUTKCKN RUT ON T2.ID = RUT.IDKCKN
                            --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from AHC_don where ID = ITEM.v_VUANID and AHC_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from AHC_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                  AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                                    
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         --toancau-anhnt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;
PROCEDURE HC_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
    v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Hành chính',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM AHC_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN AHC_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    --LEFT join AHC_SOTHAM_THULY sttl on sttl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            --And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)
            --tuanvna
--TOANCAU-29-06-2023
             And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM AHC_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ( '10-HC', '11-HC' )) and QD1.donid = c.id) or exists (SELECT 'X' FROM AHC_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                         WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('14-HC','15-HC','40-HC','41-HC','43-HC')) THEN 1
                    ELSE 0 END)
        Order by a.NGAYGIAO DESC;

  FILL_HC_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)A WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_KHANGCAO T2
                            INNER JOIN AHC_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM AHC_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )     
             ;
END HC_NHANAN;
PROCEDURE FILL_HC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)
AS
     V_EXPORT_TEXT CLOB; 
V_NOIDUNGNHANAN CLOB;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM AHC_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
             SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_NHANAN ( kháng cao) */T2.DONID,T2.DUONGSUID,
                     '<b> - '||decode(T3.TUCACHTOTUNG_MA,'NGUYENDON','Người khởi kiện','BIDON','Người bị kiện','QUYENNVLQ','Người có quyền và NVLQ',' ('||T3.TUCACHTOTUNG_MA || ')' )||': '||T3.TENDUONGSU||'</b><br/> '||
                     LISTAGG(
                     '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                         ,',')
                     WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                   NOIDUNG
                  FROM AHC_SOTHAM_KHANGCAO T2
                  LEFT JOIN AHC_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                  left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                  LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt l?y thêm kháng cáo q? khác
                  LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                  --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ahc_don where ID = ITEM.v_VUANID and AHC_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahc_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                    and T2.TINHTRANG_GIAIQUYET = 0
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                  GROUP BY T2.DONID,T2.DUONGSUID,T3.TUCACHTOTUNG_MA,T3.TENDUONGSU,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        INNER JOIN AHC_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM AHC_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_NHANAN ( kháng nghi) */T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM AHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng cáo quy?t ??nh --TOANCAU-ANHNT THÊM KHÁNG NGH? Q? KHÁC
                          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ahc_don where ID = ITEM.v_VUANID and AHC_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ahc_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                    and T2.TINHTRANG_GIAIQUYET = 0
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau-anhnt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;

PROCEDURE LD_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS; -- TOANCAU  L?Y THÊM TR??NG
  BEGIN

  IF vTrangthai=0 then
  -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by NVL(D.ID,0)),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG =>NULL,
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL,
        V_CHUYENNHANID=>NULL
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM ALD_DON d
      -- TOANCAU CHECK CHUY?N NH?N ÁN
    LEFT JOIN (
            SELECT
                CNA.ID,
                CNA.VUANID,
                CNA.TOACHUYENID
            FROM
                ALD_CHUYEN_NHAN_AN CNA
            WHERE
                CNA.TOACHUYENID = vToaAnID
        )                GNPT ON GNPT.VUANID = D.ID
                  AND D.MAGIAIDOAN IN ( 3, 7 )
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
                        ROW_NUMBER()
                        OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                             ORDER BY
                                 CA.ID DESC
                        ) RN
                    FROM
                        ALD_CHUYEN_NHAN_AN CA
                    WHERE
                        CA.TOACHUYENID = vToaAnID
                ) CNA
            WHERE
                    CNA.RN = 1
                AND NOT EXISTS (
                    SELECT
                        'X'
                    FROM
                             ALD_CHUYEN_NHAN_AN CN1
                        JOIN ALD_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                    WHERE
                            CN1.VUANID = CNA.VUANID
                        AND CN2.TOANHANID = vToaAnID
                        AND CN2.ID > CNA.ID
                )
        )                GNST ON GNST.VUANID = D.ID
                  AND D.MAGIAIDOAN = 2
                  -- TOANCAU CHECK CHUY?N NH?N ÁN
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ALD_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ALD_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
               Or (Select Count(kc.ID) from ALD_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0 and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0 
                      Or (Select Count(kc.ID) from ALD_SOTHAM_KHANGCAO kc 
                                                      inner join ALD_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                    Or (Select Count(kc.ID) from ALD_SOTHAM_KHANGCAO kc 
                                                      inner join ALD_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.MA IN ('41-DS','42-DS')
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                      Or (Select Count(kn.ID) from ALD_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID and nvl(kn.tinhtrang_giaiquyet,0) = 0)>0)
              --toancau-anhnt CHECK ?Ã GI?I QUY?T CH?A-?Ã RÚT TOÀN B? CH?A
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ALD_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from ALD_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              Or -- Hi?n th? Quy?t ??nh gây k?t thúc (Phúc th?m) (vd: 72-DS)
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                    AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM ALD_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                        AND (SELECT COUNT(QD1.ID) FROM ALD_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                      And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ALD_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ALD_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  )
                ------------------------toancau-anhnt. thêm check pt t?c
            Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND   DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ALD_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM ALD_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
--                  And pttl.TRUONGHOPTHULY > 0

              )
------------------------toancau-anhnt. thêm check pt t?c
              )
--           And (Select Count(ID) from ALD_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
           --TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
            AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND GNPT.ID IS NULL ) THEN
                                1
                            ELSE
                                0
                        END
                    )
           Order by d.ID;
--TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
   Else
   -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,--TOANCAU - L?Y N?I DUNG T? B?NH CHUY?N NH?N ÁN
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID,
        V_CHUYENNHANID=>CNA.ID
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM ALD_DON d  
      INNER JOIN ALD_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           ------ tuanvna
           And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM ALD_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM ALD_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM ALD_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                    WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                ELSE 0 END)
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ALD_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ALD_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
           AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
    Order by d.TENVUVIEC;
   End If;
    FILL_LD_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU L?Y THÊM TR??NG
   FROM TABLE(v_ARRAY)PA;
END LD_CHUYENAN;  
PROCEDURE FILL_LD_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS
)
AS
     V_EXPORT_TEXT CLOB; 
     V_NOIDUNGNHANAN CLOB;
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU neu khong co noi dung thi khong update
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 then
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM ALD_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  neu khong co noi dung thi khong update
         FOR items in (
                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||decode(T3.TUCACHTOTUNG_MA,'NGUYENDON','Người khởi kiện','BIDON','Người bị kiện','QUYENNVLQ','Người có quyền và NVLQ',' ('||T3.TUCACHTOTUNG_MA || ')' )||':'||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM ALD_SOTHAM_KHANGCAO T2
                    INNER JOIN ALD_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anLDt thêm check kc q? khác
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                 --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from aLD_don where ID = ITEM.v_VUANID and ALD_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from aLD_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TUCACHTOTUNG_MA,T3.TENDUONGSU,DM.TEN

                UNION ALL

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||decode(T3.TUCACHTGTTID,'NGUYENDON','Người khởi kiện','BIDON','Người bị kiện','QUYENNVLQ','Người có quyền và NVLQ',' ('||T3.TUCACHTGTTID || ')' )||':'||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM ALD_SOTHAM_KHANGCAO T2
                    INNER JOIN ALD_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anLDt thêm check kc q? khác
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ALD_don where ID = ITEM.v_VUANID and ALD_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from aLD_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TUCACHTGTTID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN ALD_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID --toancau-anLDt b? vì gây duplicated n?i dung kháng cáo
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM ALD_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HC_CHUYENAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM ALD_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quy?t ??nh --toancau-anLDt l?y thêm kháng ngh? q? khác
                          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from aLD_don where ID = ITEM.v_VUANID and ALD_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from aLD_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                   AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
             DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
          --toancau-anLDt check l?i ko có kháng ngh? 
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anLDt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;
PROCEDURE LD_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
    v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Hôn nhân - Gia đình',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM ALD_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN ALD_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    LEFT join ALD_SOTHAM_THULY sttl on sttl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)
        --tuanvna
--TOANCAU-29-06-2023
            And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM ALD_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ('41-DS','42-DS')) and QD1.donid = c.id) or exists (SELECT 'X' FROM ALD_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM ALD_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) THEN 1
                    ELSE 0 END)
	  Order by a.NGAYGIAO DESC;

  FILL_LD_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)A WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM ALD_SOTHAM_KHANGCAO T2
                            INNER JOIN ALD_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM ALD_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )     
             ;
END LD_NHANAN;
PROCEDURE FILL_LD_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)AS
    V_EXPORT_TEXT   clob;
V_NOIDUNGNHANAN CLOB;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM ALD_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
             SELECT /*GSCM.PKG_STPT_DS_BC.FILL_LD_NHANAN ( kháng cao)*/  T2.DONID,T2.DUONGSUID,
                     '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                     LISTAGG(
                     '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                         ,',')
                     WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                   NOIDUNG
                  FROM ALD_SOTHAM_KHANGCAO T2
                  LEFT JOIN ALD_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                  left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                  LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anLDt kc t?c
                  LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                  --toancau 30-03-2023-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    WHERE T2.DONID=(case when not exists(select 'x' from ALD_don where ID = ITEM.v_VUANID and ALD_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from ALD_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                        --toancau 30-03-2023-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                  GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN ALD_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID--toancau  anLDt b? vì làm nhân ?ôi n?i dung
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM ALD_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_LD_NHANAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM ALD_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anLDt kc t?c
                          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau 30-03-2023-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from ALD_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                 --toancau 30-03-2023-anLDt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         --toancau -anLDt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau -anLDt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;

PROCEDURE PS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT_GS; -- TOANCAU  L?Y THÊM TR??NG
  BEGIN

  IF vTrangthai=0 then
  -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by NVL(D.ID,0)),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG =>NULL,
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL,
        V_CHUYENNHANID=>NULL
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM APS_DON d
      -- TOANCAU CHECK CHUY?N NH?N ÁN 
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
                        ROW_NUMBER()
                        OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                             ORDER BY
                                 CA.ID DESC
                        ) RN
                    FROM
                        APS_CHUYEN_NHAN_AN CA
                    WHERE
                        CA.TOACHUYENID = vToaAnID
                ) CNA
            WHERE
                    CNA.RN = 1
                AND NOT EXISTS (
                    SELECT
                        'X'
                    FROM
                             APS_CHUYEN_NHAN_AN CN1
                        JOIN APS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                    WHERE
                            CN1.VUANID = CNA.VUANID
                        AND CN2.TOANHANID = vToaAnID
                        AND CN2.ID > CNA.ID
                )
        )                GNST ON GNST.VUANID = D.ID
                  AND D.MAGIAIDOAN = 2
                  -- TOANCAU CHECK CHUY?N NH?N ÁN
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from APS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from APS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
               Or (Select Count(kc.ID) from APS_SOTHAM_KHANGCAO kc where kc.DONID=d.ID and kc.LOAIKHANGCAO = 0 and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0 
                      Or (Select Count(kc.ID) from APS_SOTHAM_KHANGCAO kc 
                                                      inner join APS_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.ket_thuc = 1
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                    Or (Select Count(kc.ID) from APS_SOTHAM_KHANGCAO kc 
                                                      inner join APS_SOTHAM_QUYETDINH sq on sq.id = kc.SOQDBA
                                                      inner join dm_qd_quyetdinh qd on qd.id = sq.QUYETDINHID and qd.MA IN ('41-DS','42-DS')
                                                  where kc.DONID=d.ID and kc.LOAIKHANGCAO in (1,2)
                                                  and nvl(kc.tinhtrang_giaiquyet,0) = 0)>0  
                      Or (Select Count(kn.ID) from APS_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID and nvl(kn.tinhtrang_giaiquyet,0) = 0)>0)
              --toancau-anhnt CHECK ?Ã GI?I QUY?T CH?A-?Ã RÚT TOÀN B? CH?A
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from APS_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from APS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              Or -- Hi?n th? Quy?t ??nh gây k?t thúc (Phúc th?m) (vd: 72-DS)
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3 
                    AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM APS_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                        AND (SELECT COUNT(QD1.ID) FROM APS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) > 0 
                      And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM APS_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                      And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM APS_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  )
                ------------------------toancau-anhnt. thêm check pt t?c
            Or
              (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN =7
                AND (1=(CASE WHEN (VSOQD || ' ') = ' ' THEN 1 WHEN (SELECT COUNT(QD.ID) FROM APS_KCKNQDK_PHUCTHAM_QUYETDINH QD WHERE QD.DONID = D.ID AND QD.SOQD = VSOQD) >0 THEN 1 ELSE 0 END))
                    AND (SELECT COUNT(QD1.ID) FROM APS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                        WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','04-PS')) > 0 --toancau 08-05-2023
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM APS_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) FROM APS_KCKNQDK_PHUCTHAM_THULY tl WHERE tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
--                  And pttl.TRUONGHOPTHULY > 0

              )
------------------------toancau-anhnt. thêm check pt t?c
              )
--           And (Select Count(ID) from APS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
           --TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
            AND 1 = (
                        CASE
                            WHEN ( D.MAGIAIDOAN = 2
                                   AND ( D.TOAPHUCTHAMID IS NULL
                                         OR D.TOAPHUCTHAMID != vToaAnID )
                                   AND GNST.ID IS NULL )
                                 OR ( D.MAGIAIDOAN IN ( 3, 7 )
                                      AND  not exists (SELECT 'x' FROM  APS_CHUYEN_NHAN_AN CNA WHERE CNA.TOACHUYENID = vToaAnID AND CNA.VUANID = D.ID) 
                                       ) THEN
                                1
                            ELSE
                                0
                        END
                    )
           Order by d.ID;
--TOANCAU-ANHNT THÊM CHECK ?Ã NH?N R?I THÌ CÓ TH? CHUY?N TI?P
   Else
   -- TOANCAU  L?Y THÊM TR??NG
    SELECT R_CHUYENAN_STPT_GS(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG=>CNA.LYDOCHUYEN||CNA.NOIDUNG,--TOANCAU - LẤY NỘI DUNG T? B?NH CHUY?N NH?N ÁN
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID,
        V_CHUYENNHANID=>CNA.ID
      )-- TOANCAU  L?Y THÊM TR??NG
      BULK COLLECT INTO v_ARRAY
      FROM APS_DON d  
      INNER JOIN APS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           ------ tuanvna
           And 1=(CASE WHEN d.MAGIAIDOAN = 2 AND (SELECT COUNT('X') FROM APS_DON_XULY DXL WHERE DXL.DONID = d.ID AND DXL.LOAIGIAIQUYET != 1) > 0 THEN 1 
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM APS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) >0 THEN 1
                    WHEN d.MAGIAIDOAN = 3 AND (SELECT COUNT('X') FROM APS_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22)) > 0 THEN 1 
                    WHEN D.MAGIAIDOAN = 7 AND (SELECT COUNT('X') FROM APS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = D.ID AND  DMQD.MA in ('72-DS','04-PS')) > 0 THEN 1 --TOANCAU-26-05-2023--THÊM CHECK ÁN PTTDC
                ELSE 0 END)
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from APS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from APS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
           AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
    Order by d.TENVUVIEC;
   End If;
    FILL_PS_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR 
  SELECT PA.v_STT,PA.v_VUANID,PA.v_TOAANID,PA.v_TENVUAN,PA.v_MAVUAN,PA.v_NGAYCHUYEN,PA.v_NGAYNHAN,
        PA.v_NGAYTHULY,PA.v_NOIDUNG v_NOIDUNG,PA.v_TOANHAN,PA.v_LYDOID,PA.V_CHUYENNHANID-- TOANCAU L?Y THÊM TR??NG
   FROM TABLE(v_ARRAY)PA;
END PS_CHUYENAN;  
PROCEDURE FILL_PS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT_GS-- TOANCAU  L?Y THÊM TR??NG
)
AS
     V_EXPORT_TEXT CLOB; 
      V_NOIDUNGNHANAN CLOB;-- TOANCAU  L?Y THÊM TR??NG
BEGIN 
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Ch? c?n update v_NOIDUNG
  -- T?ng h?p kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM APS_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_PS_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM APS_SOTHAM_KHANGCAO T2
                    INNER JOIN APS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                    LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt kc t?c
                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from APS_don where ID = ITEM.v_VUANID and APS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from APS_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN

                UNION ALL 

                SELECT /*GSCM.PKG_STPT_DS_BC.FILL_PS_CHUYENAN ( kháng cao) */ T2.DONID,T2.DUONGSUID,
                    '<b> - '||DM.TEN||': '||T3.HOTEN||'</b><br/> '||
                    LISTAGG(
                    '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                    || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                    ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                    || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                    ,',')
                    WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                    NOIDUNG
                FROM APS_SOTHAM_KHANGCAO T2
                    INNER JOIN APS_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID=T3.ID AND (T3.DONID = T2.DONID) 
                    left join DM_DATAITEM DM on DM.MA=T3.TUCACHTGTTID
                    LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO in (1,2) --> Kháng cáo quy?t ??nh --toancau-anhnt kc t?c
                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                 --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from APS_don where ID = ITEM.v_VUANID and APS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from APS_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                        AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL  AND T2.TINHTRANG_GIAIQUYET =1 ) )
                    --toancau-linhnd n?u có rút kháng cáo toàn b? thì không hi?n th? ? ph?n chuy?n án
                GROUP BY T2.DONID,T2.DUONGSUID,T3.HOTEN,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        INNER JOIN APS_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID
    ) LOOP
     --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       IF v_ARRAY(ITEM.v_STT).V_CHUYENNHANID > 0 THEN--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
            SELECT NOIDUNG INTO V_NOIDUNGNHANAN
            FROM APS_CHUYEN_NHAN_AN
            WHERE ID = v_ARRAY(ITEM.v_STT).V_CHUYENNHANID;
        END IF;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT  /*GSCM.PKG_STPT_DS_BC.FILL_PS_CHUYENAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
							FROM APS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Viện trưởng Viện kiểm sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN in (1,2) --> Kháng cáo quyết định
                          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          LEFT JOIN APS_SOTHAM_RUTKCKN RUT ON T2.ID = RUT.IDKCKN
                            --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from APS_don where ID = ITEM.v_VUANID and APS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from APS_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                  AND ((v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NULL  AND (T2.TINHTRANG_GIAIQUYET IS NULL OR T2.TINHTRANG_GIAIQUYET = 0))
                        OR (v_ARRAY(ITEM.v_STT).v_NGAYNHAN IS NOT NULL AND T2.TINHTRANG_GIAIQUYET =1  ) )
                                    --toancau-anhnt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                                    
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         --toancau-anhnt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau-anhnt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         END IF;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;
PROCEDURE PS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
    v_so_qd in varchar2,
  v_ngay_qd in varchar2,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN_STPT;
  BEGIN
     SELECT R_NHANAN_STPT(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUVIEC,
      v_MAVUAN =>c.MAVUVIEC,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Phá sản',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM APS_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN APS_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    --LEFT join APS_SOTHAM_THULY sttl on sttl.DONID = a.VUANID
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.MAVUVIEC)) LIKE  ('%' || LOWER(trim(vMavuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(trim(c.TENVUVIEC)) LIKE  ('%' || LOWER(trim(vTenvuviec)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(trim(b.TEN)) LIKE  ('%' || LOWER(trim(vToachuyen)) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
            --And 1=(CASE WHEN C.MAGIAIDOAN IN(2, 3) AND sttl.TRUONGHOPTHULY IS NULL THEN 0 ELSE 1 END)
        --tuanvna
        --toancau thêm check trạng thái
         And 1=(CASE WHEN vTrangthai = 1 AND NOT EXISTS (SELECT 'X' FROM APS_DON_XULY DXL WHERE DXL.DONID = C.ID AND DXL.LOAIGIAIQUYET = 1) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 2 AND (EXISTS (SELECT 'X' FROM APS_SOTHAM_QUYETDINH  QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE (DMQD.KET_THUC = 1 OR DMQD.MA IN ('41-DS','42-DS')) and QD1.donid = c.id) or exists (SELECT 'X' FROM APS_SOTHAM_BANAN WHERE DONID = C.ID)) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 3 AND (EXISTS (SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND DMQD.KET_THUC = 1 AND QD1.KETQUAID in (103)) OR EXISTS (SELECT 'X' FROM APS_PHUCTHAM_BANAN BA WHERE BA.KETQUAPHUCTHAMID IN (4,22))) THEN 1
                        WHEN vTrangthai = 0 AND C.MAGIAIDOAN = 7 AND EXISTS (SELECT 'X' FROM APS_KCKNQDK_PHUCTHAM_QUYETDINH QD1 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID WHERE QD1.DONID = C.ID AND  DMQD.MA in ('72-DS','69-DS','70-DS')) THEN 1
                    ELSE 0 END)
                     --toancau thêm check trạng thái
	  Order by a.NGAYGIAO DESC;

  FILL_PS_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)A WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.v_VUANID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYTUYENAN,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.v_VUANID=QSV.DONID  )
                 )
             )
            AND (V_NG_KC IS NULL--tìm người kháng cáo
               OR(     EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_KHANGCAO T2
                            INNER JOIN APS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                            WHERE T2.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR  EXISTS (
                           SELECT 'X' FROM APS_DON_DUONGSU T3 
                            WHERE T3.DONID=A.v_VUANID AND UPPER(T3.TENDUONGSU) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )     
             ;
END PS_NHANAN;
PROCEDURE FILL_PS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN_STPT
)AS
    V_EXPORT_TEXT   clob;
V_NOIDUNGNHANAN CLOB;--TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) LOOP
       --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
       V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM APS_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         FOR items in (
             SELECT /*GSCM.PKG_STPT_DS_BC.FILL_PS_NHANAN ( kháng cao)*/  T2.DONID,T2.DUONGSUID,
                     '<b> - '||DM.TEN||': '||T3.TENDUONGSU||'</b><br/> '||
                     LISTAGG(
                     '<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')|| '<br/>' 
                        || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN|| ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        ,'+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) 
                        || '<br/><div style="text-align:justify" >+ Nội dung: '|| T2.NOIDUNGKHANGCAO ||'</div>'
                         ,',')
                     WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID)
                   NOIDUNG
                  FROM APS_SOTHAM_KHANGCAO T2
                  LEFT JOIN APS_DON_DUONGSU T3 ON T2.DUONGSUID=T3.ID
                  left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
                  LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anPSt kc t?c
                  LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo b?n án
                  --toancau 30-03-2023-anPSt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                    WHERE T2.DONID=(case when not exists(select 'x' from APS_don where ID = ITEM.v_VUANID and APS_DON.MAGIAIDOAN = 7) 
                                        then ITEM.v_VUANID else
                                        (select vuanid from APS_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                                        --toancau 30-03-2023-anPSt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                  GROUP BY T2.DONID,T2.DUONGSUID,T3.TENDUONGSU,DM.TEN
         )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
		END LOOP;
  -- T?ng h?p kháng ngh?
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
  FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        --INNER JOIN APS_SOTHAM_KHANGNGHI T2 ON T2.DONID=T1.v_VUANID--toancau  anPSt b? vì làm nhân ?ôi n?i dung
    ) LOOP
    --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
    V_NOIDUNGNHANAN:='';
       SELECT LYDOCHUYEN||'<br/>'||NOIDUNG INTO V_NOIDUNGNHANAN
        FROM APS_CHUYEN_NHAN_AN
        WHERE ID = v_ARRAY(ITEM.v_STT).v_CHUYEN_NHAN_ANID;
        IF V_NOIDUNGNHANAN||' ' =' ' THEN
        --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
        FOR items in (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_PS_NHANAN ( kháng nghi) */ T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                         ,'<b> - '||DECODE(T2.DONVIKN,1,T4.TEN,T5.TEN) ||'</b><br/>'||
                          LISTAGG(
                                  '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')
                                    ,'+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Nội dung: ' || T2.NOIDUNGKN
                                  ,',' )
                           WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NOIDUNG
                          FROM APS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN DM_VKS T4 ON T2.TOAAN_VKS_KN=T4.ID AND T2.DONVIKN=1 --> Vi?n tr??ng Vi?n ki?m sát
                          LEFT JOIN DM_TOAAN T5 ON T2.TOAAN_VKS_KN=T5.ID AND T2.DONVIKN=0 --> Chánh án Tòa án
                          LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng cáo quy?t ??nh--toancau-anPSt kc t?c
                          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo b?n án
                          --toancau 30-03-2023-anPSt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                WHERE T2.DONID=(case when not exists(select 'x' from ads_don where ID = ITEM.v_VUANID and ADS_DON.MAGIAIDOAN = 7) 
                                    then ITEM.v_VUANID else
                                    (select vuanid from APS_chuyen_nhan_an where map_vuanid_new = ITEM.v_VUANID and rownum =1) end)
                 --toancau 30-03-2023-anPSt thêm check n?u là án pttdc thì l?y thông tin s? th?m t? ??n khác
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,T4.TEN,T5.TEN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         --toancau -anPSt check l?i ko có kháng ngh?
          IF V_EXPORT_TEXT || ' ' = ' ' THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG);
          END IF;
          --toancau -anPSt check l?i ko có kháng ngh?
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
         ELSE 
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,v_ARRAY(ITEM.v_STT).v_NOIDUNG||V_NOIDUNGNHANAN);
         END IF;
         --TOANCAU -  N?U CÓ N?I DUNG THÌ KHÔNG UPDATE
     END LOOP;
END;

--PROCEDURE HS_CHUYENAN
--(
--  vToaAnID number,
--  vToaAnNhan_ten in varchar2,
--  vMavuviec in nvarchar2,
--  vTenvuviec in nvarchar2,
--  vSoQD in nvarchar2,
--  vSoBA in nvarchar2,  
--  vTungay in date,
--  vDenngay in date,
--  vDuongsu in nvarchar2,  
--  vTrangthai in number,
--  curReturn OUT sys_refcursor
--) AS
--  v_ARRAY T_CHUYENAN_STPT;
--  BEGIN
--    IF vTrangthai=0 then --> Chưa chuyển
--     OPEN curReturn FOR 
--      SELECT row_number() over (order by NVL(D.ID,0)) v_STT,d.ID v_VUANID,vToaAnID v_TOAANID,d.TENVUAN||'<br/>Mã vụ việc: '||d.MAVUAN v_TENVUAN,
--              d.MAVUAN v_MAVUAN,NULL v_NGAYCHUYEN,NULL v_NGAYNHAN,NULL v_NGAYTHULY,
--             CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000))
--            ||TT.BAQD_KC||TTS.BAQD_KN
--            ||'<br/>- Số lượng kháng cáo: '||KC.COUNTKC||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN
--             v_NOIDUNG,NULL v_TOANHAN,NULL v_LYDOID
--      FROM AHS_VUAN d
--      LEFT JOIN (      SELECT KC.VUANID,KC.BAQD_KC FROM (
--                 SELECT T2.VUANID,DECODE(T2.LOAIKHANGCAO,0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                  BAQD_KC
--                  FROM AHS_SOTHAM_KHANGCAO T2
--                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                 )KC GROUP BY KC.VUANID,KC.BAQD_KC
--           )TT ON TT.VUANID=D.ID
--       LEFT JOIN (
--                    SELECT KN.vuanid,KN.BAQD_KN FROM (
--                    SELECT t2.vuanid,DECODE(QD.ID,NULL,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                    BAQD_KN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
--                    )KN
--                    GROUP BY  KN.vuanid,KN.BAQD_KN
--               )TTS ON TTS.VUANID=D.ID    
--               LEFT JOIN (SELECT COUNT(*)COUNTKC,CO.VUANID FROM (SELECT KK.VUANID,kk.nguoikcid FROM AHS_SOTHAM_KHANGCAO KK GROUP BY KK.VUANID,kk.nguoikcid)CO GROUP BY CO.VUANID)KC ON KC.VUANID=D.ID      
--               --WHERE KK.NGUOIKCLOAI=0 
--               LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
--               SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
--                    SELECT t2.vuanid, DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                    )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
--           )KN_CC ON KN_CC.vuanid=D.ID
--       LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
--                 SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
--                    SELECT t2.vuanid,DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
--                    )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
--           )KN_CT ON KN_CT.vuanid=D.ID   
--      WHERE 
--             (vMavuviec IS NULL OR UPPER(d.MAVUAN)LIKE  ('%' || UPPER(vMavuviec) || '%')  )
--             AND (vTenvuviec IS NULL OR UPPER(d.TENVUAN)LIKE  ('%' || UPPER(vTenvuviec) || '%')  )
--             AND (vDuongsu IS NULL OR ( EXISTS(Select 'X' from AHS_BICANBICAO ds where ds.VUANID=d.ID And UPPER(ds.HOTEN)  LIKE  ('%' || UPPER(vDuongsu) || '%') ) ) )
--             AND (   (d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
--                        AND (vSoBA IS NULL OR EXISTS (Select 'X' from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA ) )
--                         AND (vSoQD IS NULL OR EXISTS(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA='CVA' And sq.SOQUYETDINH=vSoQD))
--                         And (exists(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq 
--                                       Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONVIID=vToaAnID And sq.VUANID=d.ID And ql.MA='CVA'
--                                       ) 
--                               Or exists(Select 'x' from AHS_SOTHAM_KHANGCAO kc where kc.VUANID=d.ID)
--                               Or exists(Select 'x' from AHS_SOTHAM_KHANGNGHI kn where kn.VUANID=d.ID)
--                             )
--                         AND (vTungay IS NULL OR EXISTS(Select 'X' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID ) )
--                         AND (vDenngay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID  ) )
--                        )
--                        OR
--                          (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
--                             AND (vSoBA IS NULL OR EXISTS(Select 'x' from AHS_PHUCTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA) )
--                             AND EXISTS(Select 'X' from AHS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID Where b.VUANID=d.ID and INSTR('04,06',k.MA)>0)
--                             AND(vTungay is NULL OR EXISTS (Select 'X' from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID ))
--                             AND(vDenngay is NULL OR EXISTS(Select 'x' from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID ) )
--                          )
--                )
--             And not exists(Select 'x' from AHS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID);
--    Else --> Đã chuyển
--     OPEN curReturn FOR 
--      SELECT  row_number() over (order by d.TENVUAN) v_STT,d.ID v_VUANID,vToaAnID v_TOAANID,d.TENVUAN||'<br/>Mã vụ việc: '||d.MAVUAN v_TENVUAN,
--          d.MAVUAN v_MAVUAN,cna.NGAYGIAO v_NGAYCHUYEN,
--          cna.NGAYNHAN v_NGAYNHAN,NULL v_NGAYTHULY,CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000)) 
--          ||TT.BAQD_KC||TTS.BAQD_KN
--            ||'<br/>- Số lượng kháng cáo: '||KC.COUNTKC||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN
--          v_NOIDUNG,ta.TEN v_TOANHAN,cna.TRUONGHOPGIAONHANID v_LYDOID
--        FROM AHS_VUAN d  
--      INNER JOIN AHS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
--      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
--       LEFT JOIN (      SELECT KC.VUANID,KC.BAQD_KC FROM (
--                 SELECT T2.VUANID,DECODE(T2.LOAIKHANGCAO,0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                  BAQD_KC
--                  FROM AHS_SOTHAM_KHANGCAO T2
--                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                 )KC GROUP BY KC.VUANID,KC.BAQD_KC
--           )TT ON TT.VUANID=D.ID
--       LEFT JOIN (
--                    SELECT KN.vuanid,KN.BAQD_KN FROM (
--                    SELECT t2.vuanid,DECODE(QD.ID,NULL,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                    BAQD_KN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
--                    )KN
--                    GROUP BY  KN.vuanid,KN.BAQD_KN
--               )TTS ON TTS.VUANID=D.ID    
--          LEFT JOIN (SELECT COUNT(*)COUNTKC,CO.VUANID FROM (SELECT KK.VUANID,kk.nguoikcid FROM AHS_SOTHAM_KHANGCAO KK  GROUP BY KK.VUANID,kk.nguoikcid)CO GROUP BY CO.VUANID)KC ON KC.VUANID=D.ID      
--          --WHERE KK.NGUOIKCLOAI=0
--               LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
--               SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
--                    SELECT t2.vuanid, DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                    )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
--           )KN_CC ON KN_CC.vuanid=D.ID
--       LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
--                 SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
--                    SELECT t2.vuanid,DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
--                    )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
--           )KN_CT ON KN_CT.vuanid=D.ID   
--      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
--             And (vMavuviec IS NULL OR UPPER(d.MAVUAN)LIKE  ('%' || UPPER(vMavuviec) || '%')  )
--             AND (vTenvuviec IS NULL OR UPPER(d.TENVUAN)LIKE  ('%' || UPPER(vTenvuviec) || '%')  )
--             AND (vDuongsu IS NULL OR (EXISTS(Select 'X' from AHS_BICANBICAO ds where ds.VUANID=d.ID And UPPER(ds.HOTEN)  LIKE  ('%' || UPPER(vDuongsu) || '%') ) ) )
--             AND (vSoBA IS NULL OR EXISTS (Select 'x' from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA ) )
--             AND (vSoQD IS NULL OR EXISTS(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA='CVA' And sq.SOQUYETDINH=vSoQD))
--             AND (vTungay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID))
--             AND (vDenngay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID ) )
--            -- AND (vToaAnNhan_ten IS NULL OR exists(Select 'x' from DM_TOAAN TA where TA.ID=cna.TOANHANID AND UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
--             AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
--      ORDER BY d.TENVUAN;
--    END IF;
--  END HS_CHUYENAN;
--PROCEDURE HS_CHUYEN_AN_CHITIET
--(
--  V_VUANID IN NUMBER,
--  CURRETURN OUT SYS_REFCURSOR
--) 
--IS
--    V_EXPORT_TEXT CLOB;V_KNID NUMBER;V_COUNT NUMBER; V_TENVUVIEC VARCHAR2(1000):=NULL; V_BICAO_TEXT CLOB;V_SONGAY_THULY_ST  VARCHAR2(100):=NULL;
--    V_NGAY_BA_QD_ST  VARCHAR2(4000):=NULL;V_COUNT_BAQD_ST NUMBER;V_TH_GIAONHAN VARCHAR2(1000):=NULL;V_KHANGNGHI VARCHAR2(4000);V_KHANGCAO_TEXT CLOB;
--    V_TH_GIAONHAN_COUNT VARCHAR2(1000):=NULL;
--   BEGIN
--        DBMS_LOB.CREATETEMPORARY(V_BICAO_TEXT,true);  DBMS_LOB.CREATETEMPORARY(V_KHANGCAO_TEXT,true); 
--        SELECT TENVUAN INTO V_TENVUVIEC FROM AHS_VUAN WHERE ID=V_VUANID;
--        ----------bicao
--        FOR ITEM IN (
--            SELECT ROW_NUMBER() OVER (ORDER BY bc.bicandauvu desc)||'. '||BC.HOTEN ||', Năm sinh '|| bc.namsinh||''||DECODE(BICANDAUVU,1,'(đầu vụ)',null)||', '||C.TENTOIDANH||'<br/>'  
--             V_BICAO FROM AHS_BICANBICAO BC
--            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
--            WHERE VUANID = V_VUANID
--        )
--        LOOP
--            DBMS_LOB.APPEND(V_BICAO_TEXT, ITEM.V_BICAO
--             );
--        END LOOP;
--       ----------thu ly so tham
--       SELECT 'Số '||sothuly||' Ngày '||TO_CHAR(ngaythuly,'dd/MM/yyyy') INTO V_SONGAY_THULY_ST FROM AHS_SOTHAM_THULY WHERE vuanid=V_VUANID
--       ORDER BY ngaythuly DESC,sothuly DESC
--       fetch  first 1 rows only ;
--       ----------ban an quyet dinh
--       SELECT COUNT(*) INTO  V_COUNT_BAQD_ST  FROM AHS_SOTHAM_BANAN BA
--       LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=V_VUANID;
--       ---------ban an quyet dinh
--       IF(V_COUNT_BAQD_ST>0) THEN
--            SELECT 'Bản án số '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') ||' của '||ta.ma_ten INTO V_NGAY_BA_QD_ST
--            FROM AHS_SOTHAM_BANAN BA 
--            LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=V_VUANID;
--          ELSE
--               SELECT LISTAGG(TT.QD_SN, ', ') WITHIN GROUP (ORDER BY QD_SN) INTO V_NGAY_BA_QD_ST
--                         FROM (           
--                              SELECT 'QĐ'|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày'||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN
--                              FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
--                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
--                              where PQD.VUANID=V_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 
--                              OR instr(',CVA,',','||QDL.MA||',')>0 )
--                          )TT
--                    GROUP BY TT.QD_SN;
--        END IF;
--          ----truong hop giao nhan 
--         SELECT COUNT(*) INTO V_TH_GIAONHAN_COUNT FROM AHS_CHUYEN_NHAN_AN a WHERE a.vuanid=V_VUANID; 
--         ----------
--        IF(V_TH_GIAONHAN_COUNT>0)THEN
--            SELECT I.TEN INTO V_TH_GIAONHAN FROM AHS_CHUYEN_NHAN_AN a  
--            INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
--            WHERE a.vuanid=V_VUANID GROUP BY I.TEN;
--          END IF;   
----        -----khang nghi
--           SELECT TT.V_KHANGNGHI INTO V_KHANGNGHI FROM (
--            SELECT TTS.BAQD_KN||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN||TTS.NOIDUNGKN||TTS.YEUCAU  V_KHANGNGHI
--            FROM AHS_VUAN a  
--            LEFT JOIN (
--                            SELECT KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU  FROM (
--                            SELECT t2.vuanid,DECODE(QD.ID,NULL,' Kháng nghị bản án số ' || BA.SOBANAN || ' Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),' Kháng nghị quyết định số ' || QD.SOQUYETDINH || ' Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                            BAQD_KN,'</br> Nội dung'||T2.NOIDUNGKN NOIDUNGKN,'</br> Yêu cầu '||YC.YEUCAU YEUCAU
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án  
--                            LEFT JOIN (SELECT T5.KHANGNGHIID,
--                                            LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YEUCAU
--                                            FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
--                                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                            GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID   
--                            )KN
--                            GROUP BY  KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU 
--                       )TTS ON TTS.VUANID=A.ID
--            LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
--                       SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
--                            SELECT t2.vuanid, DECODE(T2.CAPKN,0,' Của ' || T4.TEN,NULL) DVKN_TEN
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> KN quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> KN bản án
--                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                            )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
--                   )KN_CC ON KN_CC.vuanid=A.ID
--               LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
--                         SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
--                            SELECT t2.vuanid,DECODE(T2.CAPKN,1,' Của ' || T4.TEN,NULL) DVKNCT_TEN
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> KN quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> KN bản án
--                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
--                            )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
--                   )KN_CT ON KN_CT.vuanid=A.ID 
--                   WHERE a.ID=V_VUANID
--           )TT  GROUP BY  TT.V_KHANGNGHI;
--
--        -----khang cao
--         FOR ITEMS in 
--         (
--         select '<b>'||ROW_NUMBER() OVER (ORDER BY TT.HOTEN)|| '. Người kháng cáo ' || TT.HOTEN || '</b><br />'||TT.NoiDung NoiDung FROM (
--              SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
--                        T3.HOTEN,
--                        LISTAGG(
--                          '+ Ngày kháng cáo ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
--                                || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                                || '+ Yêu cầu ' || YC.YeuCau || '<br />' || '+ Nội dung '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')  ||'<br />'
--                          ,'<br />'
--                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--
--                      FROM AHS_SOTHAM_KHANGCAO T2
--                      INNER JOIN (SELECT T5.KHANGCAOID,
--                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                      LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
--                      AND BP.ngaytao =
--                        ( SELECT ahs_sotham_bienphapnganchan.ngaytao
--                          FROM AHS_SOTHAM_BIENPHAPNGANCHAN
--                          WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
--                        )
--                      LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                      INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
--                      WHERE T2.VUANID=v_VUANID AND T2.NGUOIKCLOAI = 0 --// bỏ NGUOIKCLOAI = 0 để hiển thị tất cả người kháng cáo
--                      GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
--             UNION ALL
--             SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */ T2.VUANID,T2.NGUOIKCID,
--                       T4.HOTEN,
--                        (Select LISTAGG('<b>- Người bị kháng cáo ' || c.HOTEN || '</b><br />'
--                                    || '+ Biện pháp ngăn chặn ' || '<b>' ||dm.ten  || ' </b>'
--                                    || '<br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || ', ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')|| '<br/>'
--                                        ,'')
--                                  WITHIN GROUP (ORDER BY c.ID) 
--                          From   AHS_BICANBICAO c
--                          LEFT JOIN                            
--                               (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
--                                    from AHS_SOTHAM_BIENPHAPNGANCHAN t
--                                    inner join 
--                                    (SELECT bicanid,MAX(ngaytao) as max_date
--                                    FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
--                                    WHERE b.vuanid = T2.VUANID 
--                                    GROUP BY bicanid)a
--                                    on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
--
--                     LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                          Where  c.ID In
--                                 (Select Regexp_Substr(T2.DSNGUOIBIKC
--                                           ,'[^,]+'
--                                           ,1
--                                           ,Level)
--                                  From   Dual
--                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC
--                                               ,'[^,]+'
--                                               ,1
--                                               ,Level) Is Not Null) 
--                          and c.vuanid = T2.VUANID 
--                          and 
--                          c.ID In
--                                 (Select Regexp_Substr(T2.DSNGUOIBIKC
--                                           ,'[^,]+'
--                                           ,1
--                                           ,Level)
--                                  From   Dual
--                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC
--                                               ,'[^,]+'
--                                               ,1
--                                               ,Level) Is Not Null)
--                         ) 
--                         ||
--                      LISTAGG(
--                                '+ Ngày kháng cáo' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
--                                || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                                || '+ Yêu cầu '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO||'<br/>'
--                              ,'<br/>'
--                            ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--                      FROM AHS_SOTHAM_KHANGCAO T2
--                      INNER JOIN (SELECT T5.KHANGCAOID,
--                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                      INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
--                      INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
--                      INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
--                      WHERE T2.VUANID=V_VUANID AND T2.NGUOIKCLOAI = 1
--                      GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
--             )TT
--         )
--          LOOP
--              DBMS_LOB.APPEND(V_KHANGCAO_TEXT,ITEMS.NOIDUNG);
--          END LOOP;
--        -------
--         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
--         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thông tin vụ án 
--                </td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TENVUVIEC||'
--                </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bị cáo</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_BICAO_TEXT||' </td>
--            </tr>
--             <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thụ lý sơ thẩm</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_SONGAY_THULY_ST||' </td>
--            </tr>
--             <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bản án/ Quyết định sơ thẩm</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_NGAY_BA_QD_ST||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Trường hợp giao nhận</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TH_GIAONHAN||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng nghị</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGNGHI||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng cáo</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGCAO_TEXT||' </td>
--            </tr>
--           ');
--
--         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--              <tr>
--                    <td style="width: 200px;"></td>
--                    <td style="width: 500px;"></td>
--                </tr>
--        </table>
--    ');
--        -----------------------------------
--       OPEN curReturn FOR
--       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
--       dbms_lob.freetemporary(V_EXPORT_TEXT);
--       dbms_lob.freetemporary(V_BICAO_TEXT);
--       dbms_lob.freetemporary(V_KHANGCAO_TEXT);
--END HS_CHUYEN_AN_CHITIET; 
--PROCEDURE FILL_HS_CHUYENAN
--(
--  v_ARRAY IN OUT T_CHUYENAN_STPT
--)
--AS
--    V_EXPORT_TEXT CLOB; kk NUMBER:=0;
--BEGIN
--  --anhvh edit 08/11/2021
--  --anhvh được chuyển từ PKG_QLA_TH.HS_NHANAN xử lý vấn thay đổi LISTAGG thành 'FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY)' do lỗi không đủ bộ nhớ để lưu noidung 
--   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true); 
--  -- Chỉ cần update v_NOIDUNG
--  -- Tổng hợp kháng cáo
--   FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
--       ) 
--       LOOP
--       kk:=0;
--         FOR items in 
--         (
--          SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
--                    '<b>- Bị can/bị cáo: ' || T3.HOTEN || '</b><br />'||
--                    LISTAGG(
--                      '<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
--                            || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                            || '+ Yêu cầu: ' || YC.YeuCau || '<br />' || '+ Nội dung: '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
--                      ,'<br />'
--                    ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--                  FROM AHS_SOTHAM_KHANGCAO T2
--                  INNER JOIN (SELECT T5.KHANGCAOID,
--                              LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                  LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
--                  AND BP.ngaytao =
--                    ( SELECT ahs_sotham_bienphapnganchan.ngaytao
--                      FROM AHS_SOTHAM_BIENPHAPNGANCHAN
--                      WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
--                    )
--                  LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                  INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
--                  WHERE T2.VUANID=ITEM.v_VUANID AND T2.NGUOIKCLOAI = 0 --// NGUOIKCLOAI = 0 - Bị can// NGUOIKCLOAI = 1 - Khác
--                  GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
--         UNION 
--         SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
--                    '<b>- Người kháng cáo: ' || T4.HOTEN || '</b><br />'||
--                    (Select LISTAGG('<b>* Người bị kháng cáo: </b>' || c.HOTEN || '<br />'
--                                || '+ Biện pháp ngăn chặn: ' || '<b>' ||dm.ten  || ' </b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
--                              ,'<br/>') WITHIN GROUP (ORDER BY c.ID) 
--                      From   AHS_BICANBICAO c
--                      LEFT JOIN                            
--                   (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
--                        from AHS_SOTHAM_BIENPHAPNGANCHAN t
--                        inner join 
--                        (SELECT bicanid,MAX(ngaytao) as max_date
--                        FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
--                        WHERE b.vuanid = T2.VUANID 
--                        GROUP BY bicanid)a
--                        on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
--                  LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                      Where  c.ID In
--                             (Select Regexp_Substr(T2.DSNGUOIBIKC
--                                       ,'[^,]+'
--                                       ,1
--                                       ,Level)
--                              From   Dual
--                              Connect By Regexp_Substr(T2.DSNGUOIBIKC
--                                           ,'[^,]+'
--                                           ,1
--                                           ,Level) Is Not Null)
--                     ) || '<br />'  || 
--                  LISTAGG(
--                            '<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
--                            || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                            || '+ Yêu cầu: '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO
--                          ,'<br/>'
--                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--                  FROM AHS_SOTHAM_KHANGCAO T2
--                  INNER JOIN (SELECT T5.KHANGCAOID,
--                              LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                  INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
--                  INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
--                  INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
--                  WHERE T2.VUANID=ITEM.v_VUANID AND T2.NGUOIKCLOAI = 1
--                  GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
--         )
--          LOOP
--             IF(kk=0) THEN
--              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
--              ELSE
--               DBMS_LOB.APPEND(V_EXPORT_TEXT,'<br/>'||ITEMS.NOIDUNG);
--              END IF;
--          kk:=kk+1;
--          END LOOP;
--         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
--         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
--         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
--    END LOOP;
--       -- Tổng hợp kháng nghị
--     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
--
--     FOR ITEM IN (
--        SELECT T1.* FROM TABLE(v_ARRAY) T1
--        INNER JOIN AHS_SOTHAM_KHANGNGHI T2 ON T2.VUANID=T1.v_VUANID
--    ) LOOP
--        FOR items in (
--                         SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng nghi) */ T2.VUANID,T2.TOAANRAQDID,
--                         '<b>- Đơn vị kháng nghị: ' || T4.TEN || '</b><br />' || 
--                          (Select LISTAGG('<b>* Người bị kháng nghị:  ' || c.HOTEN || '</b><br />'
--                                        || '+ Biện pháp ngăn chặn: ' || '<b>' ||dm.ten  || ' </b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
--                                      ,'<br/>') WITHIN GROUP (ORDER BY c.ID) 
--                              From   AHS_BICANBICAO c
--                              LEFT JOIN                            
--                           (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
--                                from AHS_SOTHAM_BIENPHAPNGANCHAN t
--                                inner join 
--                                (SELECT bicanid,MAX(ngaytao) as max_date
--                                FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
--                                WHERE b.vuanid = T2.VUANID 
--                                GROUP BY bicanid)a
--                                on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
--                          LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                              Where  c.ID In
--                                     (Select Regexp_Substr(T2.DSNGUOIBIKN,'[^,]+',1,Level)
--                                      From   Dual
--                                      Connect By Regexp_Substr(T2.DSNGUOIBIKN,'[^,]+',1,Level) Is Not Null)
--                             ) || '<br/>' ||                   
--                          LISTAGG(
--                                    '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
--                                    || DECODE(QD.ID,NULL,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                                    || '+ Yêu cầu: '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKN  
--                                  ,'<br/>'
--                                ) WITHIN GROUP (ORDER BY T2.VUANID,T2.TOAANRAQDID) NoiDung
--                          FROM AHS_SOTHAM_KHANGNGHI T2
--                          INNER JOIN (SELECT T5.KHANGNGHIID,
--                                      LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YeuCau
--                                    FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
--                                    INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                    GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID
--                          LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                          INNER JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                          WHERE T2.VUANID=ITEM.v_VUANID
--                          GROUP BY T2.VUANID,T2.TOAANRAQDID,T4.TEN,T2.DSNGUOIBIKN
--            )
--          LOOP
--              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
--          END LOOP;
--         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
--         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
--         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
--     END LOOP;
--END;
--PROCEDURE HS_NHANAN
--(
--  V_NG_KC IN VARCHAR2,
--  V_SO_QD IN VARCHAR2,
--  V_NGAY_QD IN VARCHAR2,
--  VTOAANID NUMBER,
--  VMAVUVIEC IN NVARCHAR2,
--  VTENVUVIEC IN NVARCHAR2,
--  VTOACHUYEN IN NVARCHAR2,
--  VTRUONGHOPGIAONHAN IN NUMBER,
--  VTUNGAY IN DATE,
--  VDENNGAY IN DATE,
--  VTRANGTHAI IN NUMBER,
--  CURRETURN OUT SYS_REFCURSOR
--) AS
--  BEGIN
--   OPEN curReturn FOR
--    SELECT ROW_NUMBER() OVER (ORDER BY A.NGAYGIAO DESC) STT,VTOAANID V_TOAANID,C.ID V_VUANID,A.ID V_CHUYEN_NHAN_ANID,
--      C.TENVUAN||'<br/>Mã vụ việc: '||c.MAVUAN V_TENVUAN,C.MAVUAN V_MAVUAN,A.NGAYGIAO V_NGAYGIAO,A.NGAYNHAN V_NGAYNHAN,
--      '<b>- Trường hợp giao nhận: </b>' || I.TEN ||TT.BAQD_KC||TTS.BAQD_KN
--      ||'<br/>- Số lượng kháng cáo: '||KC.COUNTKC||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN
--      V_NOIDUNG,
--      B.TEN V_TOACHUYEN,'Hình sự' V_LOAIVUVIEC,'1' V_LOAIVV,I.TEN V_TRUONGHOPGIAONHAN
--    FROM AHS_CHUYEN_NHAN_AN a  
--    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
--    INNER JOIN AHS_VUAN c on a.VUANID=c.ID
--    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
--    LEFT JOIN (      SELECT KC.VUANID,KC.BAQD_KC FROM (
--                     SELECT T2.VUANID,DECODE(T2.LOAIKHANGCAO,0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                      BAQD_KC
--                      FROM AHS_SOTHAM_KHANGCAO T2
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                     )KC GROUP BY KC.VUANID,KC.BAQD_KC
--               )TT ON TT.VUANID=A.VUANID
--    LEFT JOIN (
--                    SELECT KN.vuanid,KN.BAQD_KN FROM (
--                    SELECT t2.vuanid,DECODE(QD.ID,NULL,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                    BAQD_KN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
--                    )KN
--                    GROUP BY  KN.vuanid,KN.BAQD_KN
--               )TTS ON TTS.VUANID=A.VUANID
--   -- LEFT JOIN (SELECT COUNT(*)COUNTKC,KK.VUANID FROM AHS_SOTHAM_KHANGCAO KK  GROUP BY KK.VUANID)KC ON KC.VUANID=a.VUANID
--     LEFT JOIN (SELECT COUNT(*)COUNTKC,CO.VUANID FROM (SELECT KK.VUANID,kk.nguoikcid FROM AHS_SOTHAM_KHANGCAO KK  GROUP BY KK.VUANID,kk.nguoikcid)CO GROUP BY CO.VUANID)KC ON KC.VUANID=a.VUANID
--     --WHERE KK.NGUOIKCLOAI=0
--     LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
--               SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
--                    SELECT t2.vuanid, DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                    )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
--           )KN_CC ON KN_CC.vuanid=A.VUANID
--       LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
--                 SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
--                    SELECT t2.vuanid,DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
--                    FROM AHS_SOTHAM_KHANGNGHI T2
--                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
--                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
--                    LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
--                    )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
--           )KN_CT ON KN_CT.vuanid=A.VUANID   
--    WHERE A.TOANHANID=VTOAANID AND A.TRANGTHAI=VTRANGTHAI 
--        AND (VTRUONGHOPGIAONHAN=0 OR I.ID=VTRUONGHOPGIAONHAN )
--        AND (VMAVUVIEC IS NULL OR LOWER(TRIM(C.MAVUAN)) LIKE  ('%' || LOWER(TRIM(VMAVUVIEC)) || '%'))
--        AND (VTENVUVIEC IS NULL OR LOWER(TRIM(C.TENVUAN)) LIKE  ('%' || LOWER(TRIM(VTENVUVIEC)) || '%'))
--        AND(VTOACHUYEN IS NULL OR LOWER(TRIM(B.TEN)) LIKE  ('%' || LOWER(TRIM(VTOACHUYEN)) || '%') )
--        AND (VTUNGAY IS NULL OR A.NGAYGIAO >=VTUNGAY)
--        AND (VDENNGAY IS NULL OR A.NGAYGIAO <=VDENNGAY)
--        AND (V_SO_QD IS NULL
--                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(LTRIM(QSV.SOBANAN,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(LTRIM(QSV.SOBANAN,'0'))LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(LTRIM(QSV.SOQUYETDINH,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(LTRIM(QSV.SOQUYETDINH,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
--                     --  OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.VUANID=QSV.VUANID  )
--                     --  OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.VUANID=QSV.VUANID  )
--                     )
--                 )
--              AND (v_ngay_qd IS NULL
--                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
--                     )
--                )
--          AND (V_NG_KC IS NULL
--               OR(     EXISTS (
--                            SELECT 'X' FROM AHS_SOTHAM_KHANGCAO T2--tìm người kháng cáo
--                            INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
--                            WHERE T2.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
--                          ) 
--                       OR   EXISTS (
--                            SELECT 'X' FROM AHS_SOTHAM_KHANGCAO T2--tìm người kháng cáo
--                            INNER JOIN AHS_NGUOITHAMGIATOTUNG T3 ON T2.NGUOIKCID=T3.ID
--                            WHERE T2.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
--                          ) 
--                       OR    EXISTS (
--                           SELECT 'X' FROM AHS_BICANBICAO T3 --bi can bi cao
--                            WHERE T3.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
--                       ) 
--                 )
--              )      
--            ;
--END HS_NHANAN;
--PROCEDURE HS_NHANAN_CHITIET
--(
--  V_VUANID IN NUMBER,
--  CURRETURN OUT SYS_REFCURSOR
--) 
--IS
--    V_EXPORT_TEXT CLOB;V_KNID NUMBER;V_COUNT NUMBER; V_TENVUVIEC VARCHAR2(1000):=NULL; V_BICAO_TEXT CLOB;V_SONGAY_THULY_ST  VARCHAR2(100):=NULL;
--    V_NGAY_BA_QD_ST  VARCHAR2(4000):=NULL;V_COUNT_BAQD_ST NUMBER;V_TH_GIAONHAN VARCHAR2(1000):=NULL;V_KHANGNGHI VARCHAR2(4000);V_KHANGCAO_TEXT CLOB;
--  BEGIN
--        DBMS_LOB.CREATETEMPORARY(V_BICAO_TEXT,true);  DBMS_LOB.CREATETEMPORARY(V_KHANGCAO_TEXT,true); 
--        SELECT TENVUAN INTO V_TENVUVIEC FROM AHS_VUAN WHERE ID=V_VUANID;
--        ----------bicao
--        FOR ITEM IN (
--            SELECT ROW_NUMBER() OVER (ORDER BY bc.bicandauvu desc)||'. '||BC.HOTEN ||', Năm sinh '|| bc.namsinh||''||DECODE(BICANDAUVU,1,'(đầu vụ)',null)||', '||C.TENTOIDANH||'<br/>'  
--             V_BICAO FROM AHS_BICANBICAO BC
--            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
--            WHERE VUANID = V_VUANID
--        )
--        LOOP
--            DBMS_LOB.APPEND(V_BICAO_TEXT, ITEM.V_BICAO
--             );
--        END LOOP;
--       ----------thu ly so tham
--       SELECT 'Số '||sothuly||' Ngày '||TO_CHAR(ngaythuly,'dd/MM/yyyy') INTO V_SONGAY_THULY_ST FROM AHS_SOTHAM_THULY WHERE vuanid=V_VUANID
--       ORDER BY ngaythuly DESC,sothuly DESC
--       fetch  first 1 rows only ;
--       ----------ban an quyet dinh
--       SELECT COUNT(*) INTO  V_COUNT_BAQD_ST  FROM AHS_SOTHAM_BANAN BA
--       LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=V_VUANID;
--       ---------ban an quyet dinh
--       IF(V_COUNT_BAQD_ST>0) THEN
--            SELECT 'Bản án số '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') ||' của '||ta.ma_ten INTO V_NGAY_BA_QD_ST
--            FROM AHS_SOTHAM_BANAN BA 
--            LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=V_VUANID;
--          ELSE
--               SELECT LISTAGG(TT.QD_SN, ', ') WITHIN GROUP (ORDER BY QD_SN) INTO V_NGAY_BA_QD_ST
--                         FROM (           
--                              SELECT 'QĐ'|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày'||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN
--                              FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
--                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
--                              where PQD.VUANID=V_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 
--                              OR instr(',CVA,',','||QDL.MA||',')>0 )
--                          )TT
--                    GROUP BY TT.QD_SN;
--        END IF;
--        ----truong hop giao nhan 
--            SELECT I.TEN INTO V_TH_GIAONHAN FROM AHS_CHUYEN_NHAN_AN a  
--            INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
--            WHERE a.vuanid=V_VUANID GROUP BY I.TEN;
----        -----khang nghi
--           SELECT TT.V_KHANGNGHI INTO V_KHANGNGHI FROM (
--            SELECT TTS.BAQD_KN||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN||TTS.NOIDUNGKN||TTS.YEUCAU  V_KHANGNGHI
--            FROM AHS_VUAN a  
--            LEFT JOIN (
--                            SELECT KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU  FROM (
--                            SELECT t2.vuanid,DECODE(QD.ID,NULL,' Kháng nghị bản án số ' || BA.SOBANAN || ' Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),' Kháng nghị quyết định số ' || QD.SOQUYETDINH || ' Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
--                            BAQD_KN,'</br> Nội dung'||T2.NOIDUNGKN NOIDUNGKN,'</br> Yêu cầu '||YC.YEUCAU YEUCAU
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án  
--                            LEFT JOIN (SELECT T5.KHANGNGHIID,
--                                            LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YEUCAU
--                                            FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
--                                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                            GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID   
--                            )KN
--                            GROUP BY  KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU 
--                       )TTS ON TTS.VUANID=A.ID
--            LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
--                       SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
--                            SELECT t2.vuanid, DECODE(T2.CAPKN,0,' Của ' || T4.TEN,NULL) DVKN_TEN
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> KN quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> KN bản án
--                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
--                            )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
--                   )KN_CC ON KN_CC.vuanid=A.ID
--               LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
--                         SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
--                            SELECT t2.vuanid,DECODE(T2.CAPKN,1,' Của ' || T4.TEN,NULL) DVKNCT_TEN
--                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> KN quyết định
--                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> KN bản án
--                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
--                            )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
--                   )KN_CT ON KN_CT.vuanid=A.ID 
--                   WHERE a.ID=V_VUANID
--           )TT  GROUP BY  TT.V_KHANGNGHI;
--        -----khang cao
--         FOR ITEMS in 
--         (
--         select '<b>'||ROW_NUMBER() OVER (ORDER BY TT.HOTEN)|| '. Người kháng cáo ' || TT.HOTEN || '</b><br />'||TT.NoiDung NoiDung FROM (
--              SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
--                        T3.HOTEN,
--                        LISTAGG(
--                          '+ Ngày kháng cáo ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
--                                || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                                || '+ Yêu cầu ' || YC.YeuCau || '<br />' || '+ Nội dung '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')  ||'<br />'
--                          ,'<br />'
--                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--
--                      FROM AHS_SOTHAM_KHANGCAO T2
--                      INNER JOIN (SELECT T5.KHANGCAOID,
--                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                      LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
--                      AND BP.ngaytao =
--                        ( SELECT ahs_sotham_bienphapnganchan.ngaytao
--                          FROM AHS_SOTHAM_BIENPHAPNGANCHAN
--                          WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
--                        )
--                      LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                      INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
--                      WHERE T2.VUANID=v_VUANID AND T2.NGUOIKCLOAI = 0 --// bỏ NGUOIKCLOAI = 0 để hiển thị tất cả người kháng cáo
--                      GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
--             UNION ALL
--             SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */ T2.VUANID,T2.NGUOIKCID,
--                       T4.HOTEN,
--                        (Select LISTAGG('<b>- Người bị kháng cáo ' || c.HOTEN || '</b><br />'
--                                    || '+ Biện pháp ngăn chặn ' || '<b>' ||dm.ten  || ' </b>'
--                                    || '<br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || ', ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')|| '<br/>'
--                                        ,'')
--                                  WITHIN GROUP (ORDER BY c.ID) 
--                          From   AHS_BICANBICAO c
--                          LEFT JOIN                            
--                               (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
--                                    from AHS_SOTHAM_BIENPHAPNGANCHAN t
--                                    inner join 
--                                    (SELECT bicanid,MAX(ngaytao) as max_date
--                                    FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
--                                    WHERE b.vuanid = T2.VUANID 
--                                    GROUP BY bicanid)a
--                                    on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
--
--                     LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
--                          Where  c.ID In
--                                 (Select Regexp_Substr(T2.DSNGUOIBIKC
--                                           ,'[^,]+'
--                                           ,1
--                                           ,Level)
--                                  From   Dual
--                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC
--                                               ,'[^,]+'
--                                               ,1
--                                               ,Level) Is Not Null) 
--                          and c.vuanid = T2.VUANID 
--                          and 
--                          c.ID In
--                                 (Select Regexp_Substr(T2.DSNGUOIBIKC
--                                           ,'[^,]+'
--                                           ,1
--                                           ,Level)
--                                  From   Dual
--                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC
--                                               ,'[^,]+'
--                                               ,1
--                                               ,Level) Is Not Null)
--                         ) 
--                         ||
--                      LISTAGG(
--                                '+ Ngày kháng cáo' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
--                                || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
--                                || '+ Yêu cầu '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO||'<br/>'
--                              ,'<br/>'
--                            ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
--                      FROM AHS_SOTHAM_KHANGCAO T2
--                      INNER JOIN (SELECT T5.KHANGCAOID,
--                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
--                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
--                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
--                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
--                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
--                      INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
--                      INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
--                      INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
--                      WHERE T2.VUANID=V_VUANID AND T2.NGUOIKCLOAI = 1
--                      GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
--             )TT
--         )
--          LOOP
--              DBMS_LOB.APPEND(V_KHANGCAO_TEXT,ITEMS.NOIDUNG);
--          END LOOP;
--        -------
--         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
--         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thông tin vụ án 
--                </td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TENVUVIEC||'
--                </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bị cáo</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_BICAO_TEXT||' </td>
--            </tr>
--             <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thụ lý sơ thẩm</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_SONGAY_THULY_ST||' </td>
--            </tr>
--             <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bản án/ Quyết định sơ thẩm</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_NGAY_BA_QD_ST||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Trường hợp giao nhận</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TH_GIAONHAN||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng nghị</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGNGHI||' </td>
--            </tr>
--            <tr>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng cáo</td>
--                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGCAO_TEXT||' </td>
--            </tr>
--           ');
--
--         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--              <tr>
--                    <td style="width: 200px;"></td>
--                    <td style="width: 500px;"></td>
--                </tr>
--        </table>
--    ');
--        -----------------------------------
--       OPEN curReturn FOR
--       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
--       dbms_lob.freetemporary(V_EXPORT_TEXT);
--       dbms_lob.freetemporary(V_BICAO_TEXT);
--       dbms_lob.freetemporary(V_KHANGCAO_TEXT);
--END HS_NHANAN_CHITIET;
PROCEDURE HS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhan_ten in varchar2,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vSoQD in nvarchar2,
  vSoBA in nvarchar2,  
  vTungay in date,
  vDenngay in date,
  vDuongsu in nvarchar2,  
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_CHUYENAN_STPT;
  BEGIN
    IF vTrangthai=0 then --> Chưa chuyển
     OPEN curReturn FOR 
      SELECT row_number() over (order by NVL(D.ID,0)) v_STT,d.ID v_VUANID,vToaAnID v_TOAANID,d.TENVUAN||'<br/>Mã vụ việc: '||d.MAVUAN v_TENVUAN,
              d.MAVUAN v_MAVUAN,NULL v_NGAYCHUYEN,NULL v_NGAYNHAN,NULL v_NGAYTHULY,
             PKG_STPT_AHS_GS2.CHUYENAN_NOIDUNG(D.ID,D.MAGIAIDOAN,0,0,CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000)))-- TOANCAU 
             v_NOIDUNG,NULL v_TOANHAN,NULL v_LYDOID
             , 0 v_CHUYENNHANID-- TOANCAU - THÊM CHUYỂN NHẬN ID
      FROM AHS_VUAN d
      LEFT JOIN (
            SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID
            FROM
                (
                    SELECT CA.ID, CA.VUANID, CA.TOACHUYENID,CA.NGAYTAO, ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.NGAYTAO DESC ) RN
                    FROM
                        AHS_CHUYEN_NHAN_AN CA WHERE CA.TOACHUYENID = vToaAnID
                ) CNA
            WHERE
                    CNA.RN = 1
                AND NOT EXISTS (
                    SELECT 'X'
                    FROM
                             AHS_CHUYEN_NHAN_AN CN1
                        JOIN AHS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                    WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = vToaAnID AND CN2.NGAYTAO > CNA.NGAYTAO
                )
        )                GNST ON GNST.VUANID = D.ID AND D.MAGIAIDOAN = 2
      WHERE 
             (vMavuviec IS NULL OR UPPER(d.MAVUAN)LIKE  ('%' || UPPER(vMavuviec) || '%')  )
             AND (vTenvuviec IS NULL OR UPPER(d.TENVUAN)LIKE  ('%' || UPPER(vTenvuviec) || '%')  )
             AND (vDuongsu IS NULL OR ( EXISTS(Select 'X' from AHS_BICANBICAO ds where ds.VUANID=d.ID And UPPER(ds.HOTEN)  LIKE  ('%' || UPPER(vDuongsu) || '%') ) ) )
             AND (   (d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                        AND (vSoBA IS NULL OR EXISTS (Select 'X' from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA ) )
                         AND (vSoQD IS NULL 
                            OR EXISTS(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA IN ('TDC','CVA') And sq.SOQUYETDINH=vSoQD))
                         And (exists(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq 
                                       Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONVIID=vToaAnID And sq.VUANID=d.ID And ql.MA IN ('CVA')
                                       ) 
                               Or exists(Select 'x' from AHS_SOTHAM_KHANGCAO kc where kc.VUANID=d.ID AND NVL(KC.TINHTRANG_GIAIQUYET,0) = 0)
                               Or exists(Select 'x' from AHS_SOTHAM_KHANGNGHI kn where kn.VUANID=d.ID AND NVL(KN.TINHTRANG_GIAIQUYET,0) = 0)
                             )
                         AND (vTungay IS NULL OR EXISTS(Select 'X' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID ) )
                         AND (vDenngay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID  ) )
                        )
                        OR
                          (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                             AND (vSoBA IS NULL OR EXISTS(Select 'x' from AHS_PHUCTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA) )
                             AND EXISTS(Select 'X' from AHS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID Where b.VUANID=d.ID and INSTR('04,06',k.MA)>0)
                             AND(vTungay is NULL OR EXISTS (Select 'X' from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID ))
                             AND(vDenngay is NULL OR EXISTS(Select 'x' from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID ) )
                          )
                        OR
                          (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=7
                             AND EXISTS(Select 'X' from AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN b inner join DM_QD_QUYETDINH QD on b.QUYETDINHID=QD.ID Where b.VUANID=d.ID and QD.MA IN ('46-HS','51-HS','52-HS'))
                             AND(vTungay is NULL OR EXISTS (Select 'X' from AHS_KCKNQDK_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID ))
                             AND(vDenngay is NULL OR EXISTS(Select 'x' from AHS_KCKNQDK_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID ) )
                          )
                )
                AND ( (D.MAGIAIDOAN = 2 AND ( D.TOAPHUCTHAMID IS NULL OR D.TOAPHUCTHAMID != vToaAnID ) AND GNST.ID IS NULL )
                 OR ( D.MAGIAIDOAN IN ( 3, 7 ) AND not exists (SELECT 'x' FROM  AHS_CHUYEN_NHAN_AN CNA WHERE CNA.TOACHUYENID = vToaAnID AND CNA.VUANID = D.ID)))
             ;
    Else --> Đã chuyển
     OPEN curReturn FOR 
      SELECT  row_number() over (order by d.TENVUAN) v_STT,d.ID v_VUANID,vToaAnID v_TOAANID,d.TENVUAN||'<br/>Mã vụ việc: '||d.MAVUAN v_TENVUAN,
          d.MAVUAN v_MAVUAN,cna.NGAYGIAO v_NGAYCHUYEN,
          cna.NGAYNHAN v_NGAYNHAN,NULL v_NGAYTHULY, 
          PKG_STPT_AHS_GS2.CHUYENAN_NOIDUNG(D.ID,D.MAGIAIDOAN,cna.ID,1,CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000)))  -- TOANCAU   
         v_NOIDUNG,ta.TEN v_TOANHAN,cna.TRUONGHOPGIAONHANID v_LYDOID
           , cna.ID v_CHUYENNHANID-- TOANCAU - THÊM CHUYỂN NHẬN ID
        FROM AHS_VUAN d  
      INNER JOIN AHS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
             And (vMavuviec IS NULL OR UPPER(d.MAVUAN)LIKE  ('%' || UPPER(vMavuviec) || '%')  )
             AND (vTenvuviec IS NULL OR UPPER(d.TENVUAN)LIKE  ('%' || UPPER(vTenvuviec) || '%')  )
             AND (vDuongsu IS NULL OR (EXISTS(Select 'X' from AHS_BICANBICAO ds where ds.VUANID=d.ID And UPPER(ds.HOTEN)  LIKE  ('%' || UPPER(vDuongsu) || '%') ) ) )
             AND (vSoBA IS NULL OR EXISTS (Select 'x' from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA ) )
             AND (vSoQD IS NULL OR EXISTS(Select 'x' from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA='CVA' And sq.SOQUYETDINH=vSoQD))
             AND (vTungay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID))
             AND (vDenngay is NULL OR EXISTS(Select 'x' from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID ) )
            -- AND (vToaAnNhan_ten IS NULL OR exists(Select 'x' from DM_TOAAN TA where TA.ID=cna.TOANHANID AND UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
             AND (vToaAnNhan_ten IS NULL OR (UPPER(TA.TEN) LIKE '%'||upper(vToaAnNhan_ten)||'%' ))
      ORDER BY d.TENVUAN;
    END IF;
  END HS_CHUYENAN;
PROCEDURE HS_CHUYEN_AN_CHITIET
(
  V_VUANID IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
) 
IS
    V_EXPORT_TEXT CLOB;V_KNID NUMBER;V_COUNT NUMBER; V_TENVUVIEC VARCHAR2(1000):=NULL; V_BICAO_TEXT CLOB;V_SONGAY_THULY_ST  VARCHAR2(100):=NULL;
    V_NGAY_BA_QD_ST  VARCHAR2(4000):=NULL;V_COUNT_BAQD_ST NUMBER;V_TH_GIAONHAN VARCHAR2(1000):=NULL;V_KHANGNGHI VARCHAR2(4000);V_KHANGCAO_TEXT CLOB;
    V_TH_GIAONHAN_COUNT VARCHAR2(1000):=NULL;
    L_VUANID NUMBER;
    L_MAGIAIDOAN NUMBER;
    
   BEGIN
        SELECT MAGIAIDOAN INTO L_MAGIAIDOAN FROM AHS_VUAN WHERE ID = V_VUANID;
        IF L_MAGIAIDOAN = 7 THEN 
            SELECT VUANID INTO L_VUANID
            FROM AHS_CHUYEN_NHAN_AN WHERE MAP_VUANID_NEW = V_VUANID;
        ELSE
            L_VUANID := V_VUANID;
        END IF;
        DBMS_LOB.CREATETEMPORARY(V_BICAO_TEXT,true);  DBMS_LOB.CREATETEMPORARY(V_KHANGCAO_TEXT,true); 
        SELECT TENVUAN INTO V_TENVUVIEC FROM AHS_VUAN WHERE ID=L_VUANID;
        ----------bicao
        FOR ITEM IN (
            SELECT ROW_NUMBER() OVER (ORDER BY bc.bicandauvu desc)||'. '||BC.HOTEN ||', Năm sinh '|| bc.namsinh||''||DECODE(BICANDAUVU,1,'(đầu vụ)',null)||', '||C.TENTOIDANH||'<br/>'  
             V_BICAO FROM AHS_BICANBICAO BC
            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
            WHERE VUANID = L_VUANID
        )
        LOOP
            DBMS_LOB.APPEND(V_BICAO_TEXT, ITEM.V_BICAO
             );
        END LOOP;
       ----------thu ly so tham
           SELECT 'Số '||sothuly||' Ngày '||TO_CHAR(ngaythuly,'dd/MM/yyyy') INTO V_SONGAY_THULY_ST FROM AHS_SOTHAM_THULY WHERE vuanid=L_VUANID
           ORDER BY ngaythuly DESC,sothuly DESC fetch  first 1 rows only ;
       
       ----------ban an quyet dinh
       SELECT COUNT(*) INTO  V_COUNT_BAQD_ST  FROM AHS_SOTHAM_BANAN BA
       LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=L_VUANID ;
       ---------ban an quyet dinh
       IF(V_COUNT_BAQD_ST>0) THEN
            SELECT 'Bản án số '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') ||' của '||ta.ma_ten INTO V_NGAY_BA_QD_ST
            FROM AHS_SOTHAM_BANAN BA 
            LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=L_VUANID;
          ELSE--TOANCAU- THÊM QĐ BICAN
               SELECT LISTAGG(TT.QD_SN, '<br/>') WITHIN GROUP (ORDER BY TT.VUANID) INTO V_NGAY_BA_QD_ST
                         FROM (           
                              SELECT 'QĐ '|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN,PQD.VUANID
                              FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
                              where PQD.VUANID=L_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 
                              OR instr(',CVA,',','||QDL.MA||',')>0 )
                              union
                              SELECT 'QĐ '|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN,PQD.VUANID
                              FROM  AHS_SOTHAM_QUYETDINH_BICAN PQD
                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
                              where PQD.VUANID=L_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 )
                          )TT
                    GROUP BY TT.VUANID;
        END IF;
          ----truong hop giao nhan 
         SELECT COUNT(*) INTO V_TH_GIAONHAN_COUNT FROM AHS_CHUYEN_NHAN_AN a WHERE a.vuanid=L_VUANID; 
         ----------
        IF(V_TH_GIAONHAN_COUNT>0)THEN
            SELECT I.TEN INTO V_TH_GIAONHAN FROM AHS_CHUYEN_NHAN_AN a  
            INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
            WHERE a.vuanid=L_VUANID AND ROWNUM = 1 GROUP BY I.TEN;
          END IF;   
--        -----khang nghi
           SELECT TT.V_KHANGNGHI INTO V_KHANGNGHI FROM (
            SELECT TTS.BAQD_KN||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN||TTS.NOIDUNGKN||TTS.YEUCAU  V_KHANGNGHI
            FROM AHS_VUAN a  
            LEFT JOIN (
                            SELECT KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU  FROM (
                            SELECT t2.vuanid,DECODE(QD.ID,NULL,' Kháng nghị bản án số ' || BA.SOBANAN || ' Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),' Kháng nghị quyết định số ' || QD.SOQUYETDINH || ' Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                            BAQD_KN,'</br> Nội dung'||T2.NOIDUNGKN NOIDUNGKN,'</br> Yêu cầu '||YC.YEUCAU YEUCAU
                            FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = L_VUANID) QD ON QD.ID=T2.BANANID 
                                        AND ((T2.LOAIKN IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKN = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng N quyết định
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án  
                            LEFT JOIN (SELECT T5.KHANGNGHIID,
                                            LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YEUCAU
                                            FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                            GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID   
                            )KN
                            GROUP BY  KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU 
                       )TTS ON TTS.VUANID=A.ID
            LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
                       SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
                            SELECT t2.vuanid, DECODE(T2.CAPKN,0,' Của ' || T4.TEN,NULL) DVKN_TEN
                            FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                            )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
                   )KN_CC ON KN_CC.vuanid=A.ID
               LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
                         SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
                            SELECT t2.vuanid,DECODE(T2.CAPKN,1,' Của ' || T4.TEN,NULL) DVKNCT_TEN
                            FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                            )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
                   )KN_CT ON KN_CT.vuanid=A.ID 
                   WHERE a.ID=L_VUANID
           )TT  GROUP BY  TT.V_KHANGNGHI;
       
        -----khang cao
         FOR ITEMS in 
         (
         select '<b>'||ROW_NUMBER() OVER (ORDER BY TT.HOTEN)|| '. Người kháng cáo ' || TT.HOTEN || '</b><br />'||TT.NoiDung NoiDung FROM (
              SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
                        T3.HOTEN,
                        LISTAGG(
                          '+ Ngày kháng cáo ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                                || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                || '+ Yêu cầu ' || YC.YeuCau || '<br />' || '+ Nội dung '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')  ||'<br />'
                          ,'<br />'
                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung

                      FROM AHS_SOTHAM_KHANGCAO T2
                      INNER JOIN (SELECT T5.KHANGCAOID,
                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
                      LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = L_VUANID) QD ON QD.ID=T2.SOQDBA
                                        AND ((T2.LOAIKHANGCAO IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKHANGCAO = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng cáo quyết định
                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                      LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
                      AND BP.ngaytao =
                        ( SELECT ahs_sotham_bienphapnganchan.ngaytao
                          FROM AHS_SOTHAM_BIENPHAPNGANCHAN
                          WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
                        )
                      LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                      INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
                      WHERE T2.VUANID=L_VUANID AND T2.NGUOIKCLOAI = 0 --// bỏ NGUOIKCLOAI = 0 để hiển thị tất cả người kháng cáo
                      GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
             UNION ALL
             SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */ T2.VUANID,T2.NGUOIKCID,
                       T4.HOTEN,
                        (Select LISTAGG('<b>- Người bị kháng cáo ' || c.HOTEN || '</b><br />'
                                    || '+ Biện pháp ngăn chặn ' || '<b>' ||dm.ten  || ' </b>'
                                    || '<br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || ', ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')|| '<br/>'
                                        ,'')
                                  WITHIN GROUP (ORDER BY c.ID) 
                          From   AHS_BICANBICAO c
                          LEFT JOIN                            
                               (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
                                    from AHS_SOTHAM_BIENPHAPNGANCHAN t
                                    inner join 
                                    (SELECT bicanid,MAX(ngaytao) as max_date
                                    FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
                                    WHERE b.vuanid = T2.VUANID 
                                    GROUP BY bicanid)a
                                    on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID

                     LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                          Where  c.ID In
                                 (Select Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level)
                                  From   Dual
                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level) Is Not Null) 
                          and c.vuanid = T2.VUANID 
                          and 
                          c.ID In
                                 (Select Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level)
                                  From   Dual
                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level) Is Not Null)
                         ) 
                         ||
                      LISTAGG(
                                '+ Ngày kháng cáo' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
                                || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                || '+ Yêu cầu '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO||'<br/>'
                              ,'<br/>'
                            ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                      FROM AHS_SOTHAM_KHANGCAO T2
                      INNER JOIN (SELECT T5.KHANGCAOID,
                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                    LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = L_VUANID) QD ON QD.ID=T2.SOQDBA
                                        AND ((T2.LOAIKHANGCAO IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKHANGCAO = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng cáo quyết định
                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                      INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
                      INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
                      INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
                      WHERE T2.VUANID=L_VUANID AND T2.NGUOIKCLOAI = 1
                      GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
             )TT
         )
          LOOP
              DBMS_LOB.APPEND(V_KHANGCAO_TEXT,ITEMS.NOIDUNG);
          END LOOP;
        -------
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thông tin vụ án 
                </td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TENVUVIEC||'
                </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bị cáo</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_BICAO_TEXT||' </td>
            </tr>
             <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thụ lý sơ thẩm</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_SONGAY_THULY_ST||' </td>
            </tr>
             <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bản án/ Quyết định sơ thẩm</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_NGAY_BA_QD_ST||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Trường hợp giao nhận</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TH_GIAONHAN||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng nghị</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGNGHI||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng cáo</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGCAO_TEXT||' </td>
            </tr>
           ');

         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <tr>
                    <td style="width: 200px;"></td>
                    <td style="width: 500px;"></td>
                </tr>
        </table>
    ');
        -----------------------------------
       OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
       dbms_lob.freetemporary(V_EXPORT_TEXT);
       dbms_lob.freetemporary(V_BICAO_TEXT);
       dbms_lob.freetemporary(V_KHANGCAO_TEXT);
END HS_CHUYEN_AN_CHITIET; 
PROCEDURE FILL_HS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN_STPT
)
AS
    V_EXPORT_TEXT CLOB; kk NUMBER:=0;
BEGIN
  --anhvh edit 08/11/2021
  --anhvh được chuyển từ PKG_QLA_TH.HS_NHANAN xử lý vấn thay đổi LISTAGG thành 'FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY)' do lỗi không đủ bộ nhớ để lưu noidung 
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true); 
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
   FOR ITEM IN (SELECT T1.* FROM TABLE(v_ARRAY) T1
       ) 
       LOOP
       kk:=0;
         FOR items in 
         (
          SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
                    '<b>- Bị can/bị cáo: ' || T3.HOTEN || '</b><br />'||
                    LISTAGG(
                      '<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '+ Yêu cầu: ' || YC.YeuCau || '<br />' || '+ Nội dung: '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
                      ,'<br />'
                    ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                  FROM AHS_SOTHAM_KHANGCAO T2
                  INNER JOIN (SELECT T5.KHANGCAOID,
                              LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
                  AND BP.ngaytao =
                    ( SELECT ahs_sotham_bienphapnganchan.ngaytao
                      FROM AHS_SOTHAM_BIENPHAPNGANCHAN
                      WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
                    )
                  LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                  INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
                  WHERE T2.VUANID=ITEM.v_VUANID AND T2.NGUOIKCLOAI = 0 --// NGUOIKCLOAI = 0 - Bị can// NGUOIKCLOAI = 1 - Khác
                  GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
         UNION 
         SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
                    '<b>- Người kháng cáo: ' || T4.HOTEN || '</b><br />'||
                    (Select LISTAGG('<b>* Người bị kháng cáo: </b>' || c.HOTEN || '<br />'
                                || '+ Biện pháp ngăn chặn: ' || '<b>' ||dm.ten  || ' </b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
                              ,'<br/>') WITHIN GROUP (ORDER BY c.ID) 
                      From   AHS_BICANBICAO c
                      LEFT JOIN                            
                   (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
                        from AHS_SOTHAM_BIENPHAPNGANCHAN t
                        inner join 
                        (SELECT bicanid,MAX(ngaytao) as max_date
                        FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
                        WHERE b.vuanid = T2.VUANID 
                        GROUP BY bicanid)a
                        on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
                  LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                      Where  c.ID In
                             (Select Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level)
                              From   Dual
                              Connect By Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level) Is Not Null)
                     ) || '<br />'  || 
                  LISTAGG(
                            '<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
                            || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '+ Yêu cầu: '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          ,'<br/>'
                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                  FROM AHS_SOTHAM_KHANGCAO T2
                  INNER JOIN (SELECT T5.KHANGCAOID,
                              LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
                  INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
                  INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
                  WHERE T2.VUANID=ITEM.v_VUANID AND T2.NGUOIKCLOAI = 1
                  GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
         )
          LOOP
             IF(kk=0) THEN
              DBMS_LOB.APPEND(V_EXPORT_TEXT,ITEMS.NOIDUNG);
              ELSE
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'<br/>'||ITEMS.NOIDUNG);
              END IF;
          kk:=kk+1;
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    END LOOP;
       -- Tổng hợp kháng nghị
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

     FOR ITEM IN (
        SELECT T1.* FROM TABLE(v_ARRAY) T1
        INNER JOIN AHS_SOTHAM_KHANGNGHI T2 ON T2.VUANID=T1.v_VUANID
    ) LOOP
        FOR items in (
                         SELECT /*GSCM.PKG_STPT_DS_BC.FILL_HS_CHUYENAN ( kháng nghi) */ T2.VUANID,T2.TOAANRAQDID,
                         '<b>- Đơn vị kháng nghị: ' || T4.TEN || '</b><br />' || 
                          (Select LISTAGG('<b>* Người bị kháng nghị:  ' || c.HOTEN || '</b><br />'
                                        || '+ Biện pháp ngăn chặn: ' || '<b>' ||dm.ten  || ' </b> <br/>' || '+ Ngày bắt đầu: ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')
                                      ,'<br/>') WITHIN GROUP (ORDER BY c.ID) 
                              From   AHS_BICANBICAO c
                              LEFT JOIN                            
                           (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
                                from AHS_SOTHAM_BIENPHAPNGANCHAN t
                                inner join 
                                (SELECT bicanid,MAX(ngaytao) as max_date
                                FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
                                WHERE b.vuanid = T2.VUANID 
                                GROUP BY bicanid)a
                                on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID
                          LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                              Where  c.ID In
                                     (Select Regexp_Substr(T2.DSNGUOIBIKN,'[^,]+',1,Level)
                                      From   Dual
                                      Connect By Regexp_Substr(T2.DSNGUOIBIKN,'[^,]+',1,Level) Is Not Null)
                             ) || '<br/>' ||                   
                          LISTAGG(
                                    '<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(QD.ID,NULL,'+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '+ Yêu cầu: '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKN  
                                  ,'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.VUANID,T2.TOAANRAQDID) NoiDung
                          FROM AHS_SOTHAM_KHANGNGHI T2
                          INNER JOIN (SELECT T5.KHANGNGHIID,
                                      LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YeuCau
                                    FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                    INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                    GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          INNER JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                          WHERE T2.VUANID=ITEM.v_VUANID
                          GROUP BY T2.VUANID,T2.TOAANRAQDID,T4.TEN,T2.DSNGUOIBIKN
            )
          LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,v_ARRAY(ITEM.v_STT).v_NOIDUNG||'<br/>'||ITEMS.NOIDUNG);
          END LOOP;
         dbms_lob.createtemporary(v_ARRAY(ITEM.v_STT).v_NOIDUNG, TRUE);
         DBMS_LOB.APPEND(v_ARRAY(ITEM.v_STT).v_NOIDUNG,V_EXPORT_TEXT);
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     END LOOP;
END;
PROCEDURE HS_NHANAN
(
  V_NG_KC IN VARCHAR2,
  V_SO_QD IN VARCHAR2,
  V_NGAY_QD IN VARCHAR2,
  VTOAANID NUMBER,
  VMAVUVIEC IN NVARCHAR2,
  VTENVUVIEC IN NVARCHAR2,
  VTOACHUYEN IN NVARCHAR2,
  VTRUONGHOPGIAONHAN IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE,
  VTRANGTHAI IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
) AS
  BEGIN
   OPEN curReturn FOR
    SELECT ROW_NUMBER() OVER (ORDER BY A.NGAYGIAO DESC) STT,VTOAANID V_TOAANID,C.ID V_VUANID,A.ID V_CHUYEN_NHAN_ANID,
      C.TENVUAN||'<br/>Mã vụ việc: '||c.MAVUAN V_TENVUAN,C.MAVUAN V_MAVUAN,A.NGAYGIAO V_NGAYGIAO,A.NGAYNHAN V_NGAYNHAN,
      PKG_STPT_AHS_GS2.NHANAN_NOIDUNG(c.ID,C.MAGIAIDOAN,A.ID,VTRANGTHAI, '<b>- Trường hợp giao nhận: </b>' || I.TEN )
      V_NOIDUNG,
      B.TEN V_TOACHUYEN,'Hình sự' V_LOAIVUVIEC,'1' V_LOAIVV,I.TEN V_TRUONGHOPGIAONHAN
    FROM AHS_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN AHS_VUAN c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    WHERE A.TOANHANID=VTOAANID AND A.TRANGTHAI=VTRANGTHAI 
        AND (VTRUONGHOPGIAONHAN=0 OR I.ID=VTRUONGHOPGIAONHAN )
        AND (VMAVUVIEC IS NULL OR LOWER(TRIM(C.MAVUAN)) LIKE  ('%' || LOWER(TRIM(VMAVUVIEC)) || '%'))
        AND (VTENVUVIEC IS NULL OR LOWER(TRIM(C.TENVUAN)) LIKE  ('%' || LOWER(TRIM(VTENVUVIEC)) || '%'))
        AND(VTOACHUYEN IS NULL OR LOWER(TRIM(B.TEN)) LIKE  ('%' || LOWER(TRIM(VTOACHUYEN)) || '%') )
        AND (VTUNGAY IS NULL OR A.NGAYGIAO >=VTUNGAY)
        AND (VDENNGAY IS NULL OR A.NGAYGIAO <=VDENNGAY)
        AND (V_SO_QD IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(LTRIM(QSV.SOBANAN,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(LTRIM(QSV.SOBANAN,'0'))LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(LTRIM(QSV.SOQUYETDINH,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(LTRIM(QSV.SOQUYETDINH,'0')) LIKE LTRIM(V_SO_QD,'0') AND A.VUANID=QSV.VUANID  )
                     --  OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.VUANID=QSV.VUANID  )
                     --  OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.VUANID=QSV.VUANID  )
                     )
                 )
              AND (v_ngay_qd IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.VUANID=QSV.VUANID  )
                     )
                )
          AND (V_NG_KC IS NULL
               OR(     EXISTS (
                            SELECT 'X' FROM AHS_SOTHAM_KHANGCAO T2--tìm người kháng cáo
                            INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
                            WHERE T2.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR   EXISTS (
                            SELECT 'X' FROM AHS_SOTHAM_KHANGCAO T2--tìm người kháng cáo
                            INNER JOIN AHS_NGUOITHAMGIATOTUNG T3 ON T2.NGUOIKCID=T3.ID
                            WHERE T2.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
                          ) 
                       OR    EXISTS (
                           SELECT 'X' FROM AHS_BICANBICAO T3 --bi can bi cao
                            WHERE T3.VUANID=A.VUANID AND UPPER(T3.HOTEN) LIKE '%'||UPPER(V_NG_KC)||'%'
                       ) 
                 )
              )      
            ;
END HS_NHANAN;
PROCEDURE HS_NHANAN_CHITIET
(
  V_VUANID IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
) 
IS
    V_EXPORT_TEXT CLOB;V_KNID NUMBER;V_COUNT NUMBER; V_TENVUVIEC VARCHAR2(1000):=NULL; V_BICAO_TEXT CLOB;V_SONGAY_THULY_ST  VARCHAR2(100):=NULL;
    V_NGAY_BA_QD_ST  VARCHAR2(4000):=NULL;V_COUNT_BAQD_ST NUMBER;V_TH_GIAONHAN VARCHAR2(1000):=NULL;V_KHANGNGHI VARCHAR2(4000);V_KHANGCAO_TEXT CLOB;
        V_TH_GIAONHAN_COUNT VARCHAR2(1000):=NULL;
    L_VUANID NUMBER;
    L_MAGIAIDOAN NUMBER;
  BEGIN
             SELECT MAGIAIDOAN INTO L_MAGIAIDOAN FROM AHS_VUAN WHERE ID = V_VUANID;
        IF L_MAGIAIDOAN = 7 THEN 
            SELECT VUANID INTO L_VUANID
            FROM AHS_CHUYEN_NHAN_AN WHERE MAP_VUANID_NEW = V_VUANID;
        ELSE
            L_VUANID := V_VUANID;
        END IF;
        DBMS_LOB.CREATETEMPORARY(V_BICAO_TEXT,true);  DBMS_LOB.CREATETEMPORARY(V_KHANGCAO_TEXT,true); 
        SELECT TENVUAN INTO V_TENVUVIEC FROM AHS_VUAN WHERE ID=L_VUANID;
        ----------bicao
        FOR ITEM IN (
            SELECT ROW_NUMBER() OVER (ORDER BY bc.bicandauvu desc)||'. '||BC.HOTEN ||', Năm sinh '|| bc.namsinh||''||DECODE(BICANDAUVU,1,'(đầu vụ)',null)||', '||C.TENTOIDANH||'<br/>'  
             V_BICAO FROM AHS_BICANBICAO BC
            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
            WHERE VUANID = L_VUANID
        )
        LOOP
            DBMS_LOB.APPEND(V_BICAO_TEXT, ITEM.V_BICAO
             );
        END LOOP;
       ----------thu ly so tham
       SELECT 'Số '||sothuly||' Ngày '||TO_CHAR(ngaythuly,'dd/MM/yyyy') INTO V_SONGAY_THULY_ST FROM AHS_SOTHAM_THULY WHERE vuanid=L_VUANID
       ORDER BY ngaythuly DESC,sothuly DESC
       fetch  first 1 rows only ;
       ----------ban an quyet dinh
       SELECT COUNT(*) INTO  V_COUNT_BAQD_ST  FROM AHS_SOTHAM_BANAN BA
       LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=L_VUANID;
       ---------ban an quyet dinh
       IF(V_COUNT_BAQD_ST>0) THEN
            SELECT 'Bản án số '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') ||' của '||ta.ma_ten INTO V_NGAY_BA_QD_ST
            FROM AHS_SOTHAM_BANAN BA 
            LEFT JOIN DM_TOAAN TA ON TA.ID=ba.toaanid WHERE  BA.VUANID=L_VUANID;
          ELSE
               SELECT LISTAGG(TT.QD_SN, ', ') WITHIN GROUP (ORDER BY VUANID) INTO V_NGAY_BA_QD_ST
                         FROM (           
                              SELECT 'QĐ'|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN,PQD.VUANID
                              FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
                              where PQD.VUANID=L_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 
                              OR instr(',CVA,',','||QDL.MA||',')>0 )
                              union 
                              SELECT 'QĐ'|| QDL.MA||' số '||PQD.SOQUYETDINH||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy') ||' của '||ta.ma_ten  QD_SN,PQD.VUANID
                              FROM  AHS_SOTHAM_QUYETDINH_BICAN PQD
                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               LEFT JOIN DM_TOAAN TA ON TA.ID=PQD.DONVIID 
                              where PQD.VUANID=L_VUANID AND (instr(',HPT,',','||QDL.MA||',')>0 OR instr(',TDC,',','||QDL.MA||',')>0 OR instr(',DC,',','||QDL.MA||',')>0 )
                              
                          )TT
                    GROUP BY TT.VUANID;
        END IF;
        ----truong hop giao nhan 
--            SELECT I.TEN INTO V_TH_GIAONHAN FROM AHS_CHUYEN_NHAN_AN a  
--            INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
--            WHERE a.vuanid=L_VUANID GROUP BY I.TEN;
        SELECT COUNT(*) INTO V_TH_GIAONHAN_COUNT FROM AHS_CHUYEN_NHAN_AN a WHERE a.vuanid=L_VUANID; 
         ----------
        IF(V_TH_GIAONHAN_COUNT>0)THEN
            SELECT I.TEN INTO V_TH_GIAONHAN FROM AHS_CHUYEN_NHAN_AN a  
            INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
            WHERE a.vuanid=L_VUANID AND ROWNUM = 1 GROUP BY I.TEN;
          END IF;  
--        -----khang nghi
           SELECT TT.V_KHANGNGHI INTO V_KHANGNGHI FROM (
            SELECT TTS.BAQD_KN||KN_CC.DVKN_TEN||KN_CT.DVKNCT_TEN||TTS.NOIDUNGKN||TTS.YEUCAU  V_KHANGNGHI
            FROM AHS_VUAN a  
            LEFT JOIN (
                            SELECT KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU  FROM (
                            SELECT t2.vuanid,DECODE(QD.ID,NULL,' Kháng nghị bản án số ' || BA.SOBANAN || ' Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),' Kháng nghị quyết định số ' || QD.SOQUYETDINH || ' Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                            BAQD_KN,'</br> Nội dung'||T2.NOIDUNGKN NOIDUNGKN,'</br> Yêu cầu '||YC.YEUCAU YEUCAU
                            FROM AHS_SOTHAM_KHANGNGHI T2
--                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng N quyết định
                            LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = L_VUANID) QD ON QD.ID=T2.BANANID 
                                        AND ((T2.LOAIKN IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKN = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng N quyết định
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án  
                            LEFT JOIN (SELECT T5.KHANGNGHIID,
                                            LISTAGG(T6.TEN || '; '  ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YEUCAU
                                            FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                            GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID   
                            )KN
                            GROUP BY  KN.vuanid,KN.BAQD_KN,KN.NOIDUNGKN,KN.YEUCAU 
                       )TTS ON TTS.VUANID=A.ID
            LEFT JOIN (-- Tổng hợp kháng nghị Cung cap
                       SELECT KNCC.vuanid,KNCC.DVKN_TEN FROM (
                            SELECT t2.vuanid, DECODE(T2.CAPKN,0,' Của ' || T4.TEN,NULL) DVKN_TEN
                            FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                            )KNCC GROUP BY KNCC.vuanid,KNCC.DVKN_TEN
                   )KN_CC ON KN_CC.vuanid=A.ID
               LEFT JOIN ( -- Tổng hợp kháng nghị Cap tren
                         SELECT KNCT.vuanid,KNCT.DVKNCT_TEN FROM (
                            SELECT t2.vuanid,DECODE(T2.CAPKN,1,' Của ' || T4.TEN,NULL) DVKNCT_TEN
                            FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                            )KNCT GROUP BY KNCT.vuanid,KNCT.DVKNCT_TEN
                   )KN_CT ON KN_CT.vuanid=A.ID 
                   WHERE a.ID=L_VUANID
           )TT  GROUP BY  TT.V_KHANGNGHI;
        -----khang cao
         FOR ITEMS in 
         (
         select '<b>'||ROW_NUMBER() OVER (ORDER BY TT.HOTEN)|| '. Người kháng cáo ' || TT.HOTEN || '</b><br />'||TT.NoiDung NoiDung FROM (
              SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */T2.VUANID,T2.NGUOIKCID,
                        T3.HOTEN,
                        LISTAGG(
                          '+ Ngày kháng cáo ' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                                || DECODE(T2.LOAIKHANGCAO,0,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng cáo quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                || '+ Yêu cầu ' || YC.YeuCau || '<br />' || '+ Nội dung '||T2.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || dm.ten || '</b> <br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || '- Ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')  ||'<br />'
                          ,'<br />'
                        ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung

                      FROM AHS_SOTHAM_KHANGCAO T2
                      INNER JOIN (SELECT T5.KHANGCAOID,
                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                    LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = V_VUANID)QD ON QD.ID=T2.SOQDBA 
                                        AND ((T2.LOAIKHANGCAO IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKHANGCAO = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng CÁO quyết định
                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                      LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BP ON BP.vuanid = t2.vuanid AND bp.bicanid = t2.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
                      AND BP.ngaytao =
                        ( SELECT ahs_sotham_bienphapnganchan.ngaytao
                          FROM AHS_SOTHAM_BIENPHAPNGANCHAN
                          WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.vuanid = t2.vuanid AND AHS_SOTHAM_BIENPHAPNGANCHAN.bicanid = t2.NGUOIKCID AND ROWNUM = 1
                        )
                      LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                      INNER JOIN AHS_BICANBICAO T3 ON T2.NGUOIKCID=T3.ID
                      WHERE T2.VUANID=L_VUANID AND T2.NGUOIKCLOAI = 0 --// bỏ NGUOIKCLOAI = 0 để hiển thị tất cả người kháng cáo
                      GROUP BY T2.VUANID,T2.NGUOIKCID,T3.HOTEN
             UNION ALL
             SELECT /*GSCM.PKG_STPT_DS_BC.HS_NHANAN_CHITIET ( kháng cao) */ T2.VUANID,T2.NGUOIKCID,
                       T4.HOTEN,
                        (Select LISTAGG('<b>- Người bị kháng cáo ' || c.HOTEN || '</b><br />'
                                    || '+ Biện pháp ngăn chặn ' || '<b>' ||dm.ten  || ' </b>'
                                    || '<br/>' || '+ Ngày bắt đầu ' || TO_CHAR(bp.ngaybatdau,'dd/MM/yyyy') || ', ngày kết thúc ' || TO_CHAR(bp.ngayketthuc,'dd/MM/yyyy')|| '<br/>'
                                        ,'')
                                  WITHIN GROUP (ORDER BY c.ID) 
                          From   AHS_BICANBICAO c
                          LEFT JOIN                            
                               (Select t.bienphapnganchanid, t.ngaybatdau, t.ngayketthuc, t.bicanid
                                    from AHS_SOTHAM_BIENPHAPNGANCHAN t
                                    inner join 
                                    (SELECT bicanid,MAX(ngaytao) as max_date
                                    FROM AHS_SOTHAM_BIENPHAPNGANCHAN b
                                    WHERE b.vuanid = T2.VUANID 
                                    GROUP BY bicanid)a
                                    on a.bicanid = t.bicanid and a.max_date = t.ngaytao) BP ON BP.bicanid = c.ID

                     LEFT JOIN  DM_DATAITEM DM ON DM.id = BP.bienphapnganchanid
                          Where  c.ID In
                                 (Select Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level)
                                  From   Dual
                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level) Is Not Null) 
                          and c.vuanid = T2.VUANID 
                          and 
                          c.ID In
                                 (Select Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level)
                                  From   Dual
                                  Connect By Regexp_Substr(T2.DSNGUOIBIKC ,'[^,]+' ,1 ,Level) Is Not Null)
                         ) 
                         ||
                      LISTAGG(
                                '+ Ngày kháng cáo' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />' 
                                || DECODE(QD.ID,NULL,'+ Kháng cáo bản án số ' || BA.SOBANAN || ', Ngày ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'+ Kháng nghị quyết định số ' || QD.SOQUYETDINH || ', Ngày ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                || '+ Yêu cầu '|| YC.YeuCau|| '<br />' || '+ Nội dung: ' || T2.NOIDUNGKHANGCAO||'<br/>'
                              ,'<br/>'
                            ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                      FROM AHS_SOTHAM_KHANGCAO T2
                      INNER JOIN (SELECT T5.KHANGCAOID,
                                  LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                                FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
--                      LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                    LEFT JOIN (SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 0 ISBICAN FROM AHS_SOTHAM_QUYETDINH_VUAN Q WHERE Q.VUANID = L_VUANID
                                        UNION 
                                        SELECT Q.ID,Q.SOQUYETDINH,Q.NGAYQD, 1 ISBICAN FROM AHS_SOTHAM_QUYETDINH_BICAN Q WHERE Q.VUANID = L_VUANID) QD ON QD.ID=T2.SOQDBA 
                                        AND ((T2.LOAIKHANGCAO IN (1,2) AND QD.ISBICAN=0) OR (T2.LOAIKHANGCAO = 3 AND QD.ISBICAN = 1)) -->TOANCAU Kháng N quyết định
                      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                      INNER JOIN AHS_NGUOITHAMGIATOTUNG T4 ON T2.NGUOIKCID=T4.ID
                      INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = T4.ID
                      INNER JOIN DM_DATAITEM DM ON DM.id = TC.TUCACHID
                      WHERE T2.VUANID=L_VUANID AND T2.NGUOIKCLOAI = 1
                      GROUP BY T2.VUANID,T2.NGUOIKCID,T4.HOTEN,T2.DSNGUOIBIKC
             )TT
         )
          LOOP
              DBMS_LOB.APPEND(V_KHANGCAO_TEXT,ITEMS.NOIDUNG);
          END LOOP;
        -------
         DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thông tin vụ án 
                </td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TENVUVIEC||'
                </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bị cáo</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_BICAO_TEXT||' </td>
            </tr>
             <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Thụ lý sơ thẩm</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_SONGAY_THULY_ST||' </td>
            </tr>
             <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Bản án/ Quyết định sơ thẩm</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_NGAY_BA_QD_ST||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Trường hợp giao nhận</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_TH_GIAONHAN||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng nghị</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGNGHI||' </td>
            </tr>
            <tr>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">Kháng cáo</td>
                <td style="border: 0.1pt solid Black; text-align: left; vertical-align: middle;">'||V_KHANGCAO_TEXT||' </td>
            </tr>
           ');

         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <tr>
                    <td style="width: 200px;"></td>
                    <td style="width: 500px;"></td>
                </tr>
        </table>
    ');
        -----------------------------------
       OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
       dbms_lob.freetemporary(V_EXPORT_TEXT);
       dbms_lob.freetemporary(V_BICAO_TEXT);
       dbms_lob.freetemporary(V_KHANGCAO_TEXT);
END HS_NHANAN_CHITIET;
END PKG_STPT_DS_BC;
