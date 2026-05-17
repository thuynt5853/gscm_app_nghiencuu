--------------------------------------------------------
--  DDL for Package Body PKG_QLA_TH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_QLA_TH" AS

  PROCEDURE GETVUVIEC_NHANAN
(
  vToaAnID number,
  curReturn OUT sys_refcursor
) AS
  BEGIN
     open curReturn for
     select a.ID,c.TENVUVIEC,a.NGAYGIAO,b.TEN as TOACHUYEN,1 LOAIVV,'Dân sự' LOAIVUVIEC,i.TEN THGIAONHAN,a.NGAYNHAN
     from ADS_CHUYEN_NHAN_AN a  inner join DM_TOAAN b on a.TOACHUYENID=b.ID  inner join ADS_DON c on a.VUANID=c.ID
          inner join DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=0 order by a.NGAYGIAO DESC;  
  END GETVUVIEC_NHANAN;

FUNCTION FUN_GDTTT_VUVIEC_CHECK_DON 
(
  vIDQLA IN NUMBER,
  vMaVuViec in varchar2
) RETURN NUMBER
AS
vReturn number:=0;
BEGIN
--  select a.ID into vReturn from GDTTT_VUANVUVIEC a
--  where a.IDQLA=vIDQLA and lower(a.MAVUVIEC)=lower(vMaVuViec) and a.ISQLA=1;
  RETURN nvl(vReturn,0);
END FUN_GDTTT_VUVIEC_CHECK_DON;

PROCEDURE DS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
	  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
			And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
			And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
			And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
			And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
	  Order by a.NGAYGIAO DESC;
    
  PKG_QLA_TH.FILL_DS_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END DS_NHANAN;
   
PROCEDURE DS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
  IF vTrangthai=0 then
    SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d
      WHERE 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from ADS_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from ADS_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from ADS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              )
           And (Select Count(ID) from ADS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else
    SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM ADS_DON d  
      INNER JOIN ADS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ADS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ADS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ADS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ADS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If;
   
  PKG_QLA_TH.FILL_DS_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END DS_CHUYENAN;  
   
PROCEDURE HC_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
    SELECT R_NHANAN(
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
     from AHC_CHUYEN_NHAN_AN a  
     inner join DM_TOAAN b on a.TOACHUYENID=b.ID  
     inner join AHC_DON c on a.VUANID=c.ID
     inner join DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC;
  
  PKG_QLA_TH.FILL_HC_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END HC_NHANAN;

PROCEDURE HC_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
  IF vTrangthai=0 then --> Chưa chuyển
      SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHC_DON d
     Where 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHC_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from AHC_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from AHC_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from AHC_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              )
           And (Select Count(ID) from AHC_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else --> Đã chuyển
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHC_DON d  
      INNER JOIN AHC_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHC_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If; 
   
  PKG_QLA_TH.FILL_HC_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END HC_CHUYENAN;
   
PROCEDURE HN_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
     from AHN_CHUYEN_NHAN_AN a  
     inner join DM_TOAAN b on a.TOACHUYENID=b.ID  
     inner join AHN_DON c on a.VUANID=c.ID
     inner join DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC;
  PKG_QLA_TH.FILL_HN_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END HN_NHANAN;

PROCEDURE HN_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
 IF vTrangthai=0 then
        SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHN_DON d
     Where 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHN_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from AHN_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from AHN_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
              )
              OR
                (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                   And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_PHUCTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                   And (Select Count(b.ID) from AHN_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                        Where b.DONID=d.ID and INSTR('04,06',k.MA)>0)>0
                  And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                  And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
                )
              )
           And (Select Count(ID) from AHN_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else
    SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHN_DON d  
      INNER JOIN AHN_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHN_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHN_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHN_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHN_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If;
  PKG_QLA_TH.FILL_HN_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END HN_CHUYENAN;  

   
PROCEDURE KT_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC; 
  PKG_QLA_TH.FILL_KT_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END KT_NHANAN;

PROCEDURE KT_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
 IF vTrangthai=0 then
        SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AKT_DON d
     Where 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AKT_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AKT_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from AKT_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from AKT_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
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
              )
           And (Select Count(ID) from AKT_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM AKT_DON d  
      INNER JOIN AKT_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AKT_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AKT_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AKT_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AKT_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
    
   End If;
   PKG_QLA_TH.FILL_KT_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
  END KT_CHUYENAN;  

PROCEDURE LD_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
      v_LOAIVUVIEC =>'Lao động',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM ALD_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN ALD_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC;
  
  PKG_QLA_TH.FILL_LD_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END LD_NHANAN;

PROCEDURE LD_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN

IF vTrangthai=0 then
        SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM ALD_DON d
     Where 
           (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ALD_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
                 And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ALD_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                 And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from ALD_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from ALD_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
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
              )
           And (Select Count(ID) from ALD_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM ALD_DON d  
      INNER JOIN ALD_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from ALD_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from ALD_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from ALD_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from ALD_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If;
   
   PKG_QLA_TH.FILL_LD_CHUYENAN(v_ARRAY);
   OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END LD_CHUYENAN;  

PROCEDURE PS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC;
  PKG_QLA_TH.FILL_PS_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END PS_NHANAN;

PROCEDURE PS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
  IF vTrangthai=0 then
        SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM APS_DON d
     Where d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from APS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from APS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from APS_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from APS_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (Select Count(ID) from APS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
   Else
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM APS_DON d  
      INNER JOIN APS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from APS_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from APS_DON_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.TENDUONGSU)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from APS_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from APS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If;
   
  PKG_QLA_TH.FILL_PS_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END PS_CHUYENAN;  
  
PROCEDURE XLHC_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
     SELECT R_NHANAN(
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
    FROM XLHC_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN XLHC_DON c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
  Where a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
  Order by a.NGAYGIAO DESC;
  
  PKG_QLA_TH.FILL_XLHC_NHANAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
  END XLHC_NHANAN;

PROCEDURE XLHC_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
  IF vTrangthai=0 then
        SELECT R_CHUYENAN(
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
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM XLHC_DON d
     Where d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from XLHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from XLHC_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.HOTEN)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from XLHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And ((Select Count(sq.ID) from XLHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.TOAANID=vToaAnID And sq.DONID=d.ID And ql.MA='CVA')>0 
              Or (Select Count(kc.ID) from XLHC_SOTHAM_KHANGCAO kc where kc.DONID=d.ID )>0 Or (Select Count(kn.ID) from XLHC_SOTHAM_KHANGNGHI kn where kn.DONID=d.ID )>0)
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from XLHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from XLHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (Select Count(ID) from XLHC_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0
    Order by d.TENVUVIEC;
   Else
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUVIEC),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUVIEC,
        v_MAVUAN =>d.MAVUVIEC,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => NULL,
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM XLHC_DON d  
      INNER JOIN XLHC_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
    WHere ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
           And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUVIEC) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUVIEC) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from XLHC_SOTHAM_QUYETDINH sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONID=d.ID And ql.MA='CVA' And sq.SOQD=vSoQD  )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from XLHC_DUONGSU ds where ds.DONID=d.ID And LOWER(ds.HOTEN)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from XLHC_SOTHAM_BANAN ba where ba.DONID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
           And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from XLHC_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))
           And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from XLHC_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.DONID=d.ID )>0  THEN 1 Else 0 END))          
    Order by d.TENVUVIEC;
   End If;
   PKG_QLA_TH.FILL_XLHC_CHUYENAN(v_ARRAY);
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END XLHC_CHUYENAN;  
  
PROCEDURE HS_NHANAN
(
  vToaAnID number,
  vMavuviec in nvarchar2,
  vTenvuviec in nvarchar2,
  vToachuyen in nvarchar2,
  vTruongHopGiaoNhan in number,
  vTungay in date,
  vDenngay in date,
  vTrangthai in number,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY T_NHANAN;
  BEGIN
    SELECT R_NHANAN(
      v_STT =>row_number() over (order by a.NGAYGIAO DESC),
      v_TOAANID =>vToaAnID,
      v_VUANID =>c.ID,
      v_CHUYEN_NHAN_ANID => a.ID,
      v_TENVUAN =>c.TENVUAN,
      v_MAVUAN =>c.MAVUAN,
      v_NGAYGIAO =>a.NGAYGIAO,
      v_NGAYNHAN =>a.NGAYNHAN,
      v_NOIDUNG =>'<b>- Trường hợp giao nhận: </b>' || i.TEN,
      v_TOACHUYEN =>b.TEN,
      v_LOAIVUVIEC =>'Hình sự',
      v_LOAIVV =>1,
      v_TRUONGHOPGIAONHAN => i.TEN
    )
    BULK COLLECT INTO v_ARRAY
    FROM AHS_CHUYEN_NHAN_AN a  
    INNER JOIN DM_TOAAN b on a.TOACHUYENID=b.ID  
    INNER JOIN AHS_VUAN c on a.VUANID=c.ID
    INNER JOIN DM_DATAITEM i on i.ID=a.TRUONGHOPGIAONHANID
    WHERE a.TOANHANID=vToaAnID and a.TRANGTHAI=vTrangthai 
        And 1=(Case  when vTruongHopGiaoNhan=0 then 1 when i.ID=vTruongHopGiaoNhan then 1 Else 0 End)
        And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.MAVUAN) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(c.TENVUAN) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN (vToachuyen|| ' ')=' '  THEN 1 WHEN LOWER(b.TEN) LIKE  ('%' || LOWER(vToachuyen) || '%') THEN 1 Else 0 END))
        And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN a.NGAYGIAO >=vTungay THEN 1 Else 0 END))
        And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN a.NGAYGIAO <=vDenngay THEN 1 Else 0 END))
    Order by a.NGAYGIAO DESC;
  
    PKG_QLA_TH.FILL_HS_NHANAN(v_ARRAY);
    OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END HS_NHANAN;

PROCEDURE HS_CHUYENAN
(
  vToaAnID number,
  vToaAnNhanID number,
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
  v_ARRAY T_CHUYENAN;
  BEGIN
    IF vTrangthai=0 then --> Chưa chuyển
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by NVL(D.ID,0)),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUAN,
        v_MAVUAN =>d.MAVUAN,
        v_NGAYCHUYEN =>NULL,
        v_NGAYNHAN =>NULL,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000)),
        v_TOANHAN =>NULL,
        v_LYDOID =>NULL
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_VUAN d
      WHERE 
             (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUAN) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
             And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUAN) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
             And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHS_BICANBICAO ds where ds.VUANID=d.ID And LOWER(ds.HOTEN)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
             And  ((d.TOAANID=vToaAnID and (d.MAGIAIDOAN=2 Or d.MAGIAIDOAN=1)
             And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
             And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA='CVA' And sq.SOQUYETDINH=vSoQD  )>0 THEN 1 Else 0 END))
             And ((Select Count(sq.ID) from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.DONVIID=vToaAnID And sq.VUANID=d.ID And ql.MA='CVA')>0 
                Or (Select Count(kc.ID) from AHS_SOTHAM_KHANGCAO kc where kc.VUANID=d.ID )>0 Or (Select Count(kn.ID) from AHS_SOTHAM_KHANGNGHI kn where kn.VUANID=d.ID )>0)
             And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))
             And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))
                )
                OR
                  (d.TOAPHUCTHAMID=vToaAnID and d.MAGIAIDOAN=3
                     And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHS_PHUCTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
                     And (Select Count(b.ID) from AHS_PHUCTHAM_BANAN b inner join DM_KETQUA_PHUCTHAM k on b.KETQUAPHUCTHAMID=k.ID
                          Where b.VUANID=d.ID and INSTR('04,06',k.MA)>0)>0
                    And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))
                    And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_PHUCTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))
                  )
                )
             And (Select Count(ID) from AHS_CHUYEN_NHAN_AN cn where cn.VUANID=d.ID And cn.TOACHUYENID=vToaAnID)=0;
    Else --> Đã chuyển
      SELECT R_CHUYENAN(
        v_STT =>row_number() over (order by d.TENVUAN),
        v_VUANID => d.ID,
        v_TOAANID =>vToaAnID,
        v_TENVUAN =>d.TENVUAN,
        v_MAVUAN =>d.MAVUAN,
        v_NGAYCHUYEN =>cna.NGAYGIAO,
        v_NGAYNHAN =>cna.NGAYNHAN,
        v_NGAYTHULY =>NULL,
        v_NOIDUNG => CAST('- <b>Số bút lục: </b>' || d.SOBUTLUC AS VARCHAR(4000)),
        v_TOANHAN =>ta.TEN,
        v_LYDOID =>cna.TRUONGHOPGIAONHANID
      )
      BULK COLLECT INTO v_ARRAY
      FROM AHS_VUAN d  
      INNER JOIN AHS_CHUYEN_NHAN_AN cna ON cna.VUANID=d.ID
      INNER JOIN DM_TOAAN ta ON cna.TOANHANID=ta.ID
      WHERE ((d.TOAANID=vToaAnID And cna.TOACHUYENID=vToaAnID) Or (d.TOAPHUCTHAMID=vToaAnID And cna.TOACHUYENID=vToaAnID))
             And (1=(CASE WHEN (vMavuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.MAVUAN) LIKE  ('%' || LOWER(vMavuviec) || '%') THEN 1 Else 0 END))
             And (1=(CASE WHEN (vTenvuviec|| ' ')=' '  THEN 1 WHEN LOWER(d.TENVUAN) LIKE  ('%' || LOWER(vTenvuviec) || '%') THEN 1 Else 0 END))
             And (1=(CASE WHEN (vSoQD|| ' ')=' '  THEN 1  WHEN (Select Count(sq.ID) from AHS_SOTHAM_QUYETDINH_VUAN sq Inner join DM_QD_LOAI ql on ql.ID=sq.LOAIQDID where sq.VUANID=d.ID And ql.MA='CVA' And sq.SOQUYETDINH=vSoQD  )>0 THEN 1 Else 0 END))
             And (1=(CASE WHEN (vDuongsu|| ' ')=' '  THEN 1  WHEN (Select Count(ds.ID) from AHS_BICANBICAO ds where ds.VUANID=d.ID And LOWER(ds.HOTEN)  LIKE  ('%' || LOWER(vDuongsu) || '%') )>0 THEN 1 Else 0 END))
             And (1=(CASE WHEN (vSoBA|| ' ')=' '  THEN 1  WHEN (Select Count(ba.ID) from AHS_SOTHAM_BANAN ba where ba.VUANID=d.ID And ba.SOBANAN=vSoBA )>0 THEN 1 Else 0 END))
             And (1=(CASE WHEN vTungay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_SOTHAM_THULY tl where tl.NGAYTHULY>=vTungay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))
             And (1=(CASE WHEN vDenngay is NULL THEN 1 WHEN (Select Count(tl.ID) from AHS_SOTHAM_THULY tl where tl.NGAYTHULY<=vDenngay and tl.VUANID=d.ID )>0  THEN 1 Else 0 END))          
      ORDER BY d.TENVUAN;
    END IF;
    
    PKG_QLA_TH.FILL_HS_CHUYENAN(v_ARRAY);
    OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
  END HS_CHUYENAN;

PROCEDURE FILL_HS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- Bị can/bị cáo: ' || T3.HOTEN || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.VUANID,T2.NGUOIKCID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Yêu cầu: ' || SUBSTR(YC.YeuCau,1,LENGTH(YC.YeuCau)-2) || '<br />' || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                  FROM AHS_SOTHAM_KHANGCAO T2
                  INNER JOIN (SELECT T5.KHANGCAOID,
                              LISTAGG(
                                      CAST(T6.TEN || '; ' AS VARCHAR2(4000))
                                      ) WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.VUANID,T2.NGUOIKCID) ND ON ND.VUANID=T1.v_VUANID
      INNER JOIN AHS_BICANBICAO T3 ON ND.NGUOIKCID=T3.ID and T3.VUANID=T1.v_VUANID
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || T4.TEN || '</b><br />' || ND.NoiDung
                          AS VARCHAR2(4000)
                        )
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.VUANID,T2.TOAANRAQDID,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Yêu cầu: '|| SUBSTR(YC.YeuCau,1,LENGTH(YC.YeuCau)-2) || '<br />' || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.VUANID,T2.TOAANRAQDID) NoiDung
                          FROM AHS_SOTHAM_KHANGNGHI T2
                          INNER JOIN (SELECT T5.KHANGNGHIID,
                                      LISTAGG(
                                        CAST(T6.TEN || '; ' AS VARCHAR2(4000) )
                                      ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YeuCau
                                    FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                    INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                    GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.VUANID,T2.TOAANRAQDID
                          ) ND ON ND.VUANID=T1.v_VUANID
              INNER JOIN DM_VKS T4 ON ND.TOAANRAQDID=T4.ID
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_HS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- Bị can/bị cáo: ' || T3.HOTEN || '</b><br />' ||SUBSTR(ND.NoiDung,1,100) 
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
--                    LISTAGG(
--                    CAST('<b>- Bị can/bị cáo: ' || T3.HOTEN || '</b><br />' || ND.NoiDung
--                      AS VARCHAR2(4000)
--                    ),'<br />'
--                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.VUANID,T2.NGUOIKCID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Yêu cầu: ' || SUBSTR(YC.YeuCau,1,LENGTH(YC.YeuCau)-2) || '<br />' || '&nbsp;&nbsp;+ Nội dung: ' || SUBSTR(T2.NOIDUNGKHANGCAO,1,100) 
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.VUANID,T2.NGUOIKCID) NoiDung
                  FROM AHS_SOTHAM_KHANGCAO T2
                  INNER JOIN (SELECT T5.KHANGCAOID,
                              LISTAGG(
                                      CAST(T6.TEN || '; ' AS VARCHAR2(4000))
                                      ) WITHIN GROUP (ORDER BY T5.KHANGCAOID) YeuCau
                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.VUANID,T2.NGUOIKCID) ND ON ND.VUANID=T1.v_VUANID
      INNER JOIN AHS_BICANBICAO T3 ON ND.NGUOIKCID=T3.ID
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || T4.TEN || '</b><br />' || ND.NoiDung
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.VUANID,T2.TOAANRAQDID,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(QD.ID,NULL,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Yêu cầu: '|| SUBSTR(YC.YeuCau,1,LENGTH(YC.YeuCau)-2) || '<br />' || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.VUANID,T2.TOAANRAQDID) NoiDung
                          FROM AHS_SOTHAM_KHANGNGHI T2
                          INNER JOIN (SELECT T5.KHANGNGHIID,
                                      LISTAGG(
                                        CAST(T6.TEN || '; ' AS VARCHAR2(4000) )
                                      ) WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YeuCau
                                    FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                    INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                    GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.VUANID,T2.TOAANRAQDID
                          ) ND ON ND.VUANID=T1.v_VUANID
              INNER JOIN DM_VKS T4 ON ND.TOAANRAQDID=T4.ID
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_DS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM ADS_SOTHAM_KHANGCAO T2
                  LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN ADS_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM ADS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_DS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
) AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
--                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' ||  SUBSTR(ND.NoiDung,0,500)
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM ADS_SOTHAM_KHANGCAO T2
                  LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN ADS_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
    		
        END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM ADS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN ADS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_HC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM AHC_SOTHAM_KHANGCAO T2
                  
                  LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AHC_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_HC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM AHC_SOTHAM_KHANGCAO T2
                  LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AHC_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_HN_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM AHN_SOTHAM_KHANGCAO T2
                  LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AHN_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AHN_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_HN_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM AHN_SOTHAM_KHANGCAO T2
                  LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AHN_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AHN_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AHN_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_KT_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':'|| T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM AKT_SOTHAM_KHANGCAO T2
                  LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AKT_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AKT_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_KT_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS NVARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
--                    LISTAGG(
--                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || NVL2(T2.NGAYKHANGCAO,TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy'),'')  || '<br />'
----                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
----                            || '&nbsp;&nbsp;+ Nội dung: ' || NVL2(T2.NOIDUNGKHANGCAO,TRIM(T2.NOIDUNGKHANGCAO),'')
--                          AS NVARCHAR2(4000)
--                      ),'<br />'
--                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  '' NoiDung
                  FROM AKT_SOTHAM_KHANGCAO T2
                  LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN AKT_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS NVARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || NVL2(T2.NGAYKN,TO_CHAR(T2.NGAYKN,'dd/MM/yyyy'),'') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || NVL2(T2.NOIDUNGKN,T2.NOIDUNGKN,'')
                                    AS NVARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM AKT_SOTHAM_KHANGNGHI T2
                          LEFT JOIN AKT_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_LD_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM ALD_SOTHAM_KHANGCAO T2
                  LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN ALD_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM ALD_SOTHAM_KHANGNGHI T2
                          LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_LD_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM ALD_SOTHAM_KHANGCAO T2
                  LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN ALD_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM ALD_SOTHAM_KHANGNGHI T2
                          LEFT JOIN ALD_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_PS_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM APS_SOTHAM_KHANGCAO T2
                  LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN APS_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM APS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_PS_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '||DM.TEN||':' || T3.TENDUONGSU || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM APS_SOTHAM_KHANGCAO T2
                  LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN APS_DON_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      left join DM_DATAITEM DM on DM.MA=T3.TUCACHTOTUNG_MA
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM APS_SOTHAM_KHANGNGHI T2
                          LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
    END LOOP;
END;
PROCEDURE FILL_XLHC_CHUYENAN
(
  v_ARRAY IN OUT T_CHUYENAN
)
AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>- '|| T3.HOTEN || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM XLHC_SOTHAM_KHANGCAO T2
                  LEFT JOIN XLHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN XLHC_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM XLHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN XLHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE FILL_XLHC_NHANAN
(
  v_ARRAY IN OUT T_NHANAN
)AS
BEGIN
  -- Chỉ cần update v_NOIDUNG
  -- Tổng hợp kháng cáo
    FOR ITEM IN (
      SELECT T1.v_STT,
                  LISTAGG(
                    CAST('<b>-'|| T3.HOTEN || '</b><br />' || ND.NoiDung
                      AS VARCHAR2(4000)
                    ),'<br />'
                  ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKC
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN (SELECT T2.DONID,T2.DUONGSUID,
                    LISTAGG(
                      CAST('&nbsp;&nbsp;<b>* Ngày kháng cáo: </b>' || TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy') || '<br />'
                            || DECODE(T2.LOAIKHANGCAO,0,'&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                            || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKHANGCAO
                          AS VARCHAR2(4000)
                      ),'<br />'
                    ) WITHIN GROUP (ORDER BY T2.DONID,T2.DUONGSUID) NoiDung
                  FROM XLHC_SOTHAM_KHANGCAO T2
                  LEFT JOIN XLHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.SOQDBA AND T2.LOAIKHANGCAO=1 --> Kháng cáo quyết định
                  LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.ID= T2.SOQDBA AND T2.LOAIKHANGCAO=0 --> Kháng cáo bản án
                  GROUP BY T2.DONID,T2.DUONGSUID) ND ON ND.DONID=T1.v_VUANID
      INNER JOIN XLHC_DUONGSU T3 ON ND.DUONGSUID=T3.ID
      GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br/>' || ITEM.NoiDungKC;
		END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEM IN (
    SELECT T1.v_STT,
                LISTAGG(
                        CAST('<b>- Đơn vị kháng nghị: ' || DECODE(ND.DONVIKN,1,T4.TEN,T5.TEN) || '</b><br />' || ND.NoiDung 
                          AS VARCHAR2(4000)
                        ),'<br/>'
                      ) WITHIN GROUP (ORDER BY T1.v_STT) NoiDungKN
              FROM TABLE(v_ARRAY) T1
              INNER JOIN (SELECT T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN,
                          LISTAGG(
                                  CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN,'dd/MM/yyyy') || '<br />' 
                                    || DECODE(T2.LOAIKN,0,'&nbsp;&nbsp;+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy'),'&nbsp;&nbsp;+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy')) || '<br/>'
                                    || '&nbsp;&nbsp;+ Nội dung: ' || T2.NOIDUNGKN
                                    AS VARCHAR2(4000)
                                  ),'<br/>'
                                ) WITHIN GROUP (ORDER BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN) NoiDung
                          FROM XLHC_SOTHAM_KHANGNGHI T2
                          LEFT JOIN XLHC_SOTHAM_QUYETDINH QD ON QD.ID=T2.BANANID AND T2.LOAIKN=1 --> Kháng cáo quyết định
                          LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0 --> Kháng cáo bản án
                          GROUP BY T2.DONID,T2.TOAAN_VKS_KN,T2.DONVIKN
                          ) ND ON ND.DONID=T1.v_VUANID
              LEFT JOIN DM_VKS T4 ON ND.TOAAN_VKS_KN=T4.ID AND ND.DONVIKN=1 --> Viện trưởng Viện kiểm sát
              LEFT JOIN DM_TOAAN T5 ON ND.TOAAN_VKS_KN=T5.ID AND ND.DONVIKN=0 --> Chánh án Tòa án
              GROUP BY T1.v_STT
    ) LOOP
			v_ARRAY(ITEM.v_STT).v_NOIDUNG := v_ARRAY(ITEM.v_STT).v_NOIDUNG || '<br />' || ITEM.NoiDungKN;
		END LOOP;
END;
PROCEDURE QLA_CHANH_AN_TRANG_CHU
(
  vToaAnID in number, 
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY_SOTHAM QLA_CHANH_AN_TRANG_CHU_T;
  v_ARRAY_PHUCTHAM QLA_CHANH_AN_TRANG_CHU_T;
BEGIN
    /* Sơ thẩm */
    v_ARRAY_SOTHAM:= new QLA_CHANH_AN_TRANG_CHU_T();
    v_ARRAY_SOTHAM.EXTEND(9);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','AHS',vToaAnID,1,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','AHS_CHUA_THANH_NIEN',vToaAnID,2,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','ADS',vToaAnID,3,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','AKT',vToaAnID,4,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','AHC',vToaAnID,5,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','AHN',vToaAnID,6,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','ALD',vToaAnID,7,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','APS',vToaAnID,8,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('ST','XLHC',vToaAnID,9,vTungay,vDenngay,v_ARRAY_SOTHAM);
    /* Phúc thẩm */
    v_ARRAY_PHUCTHAM:= new QLA_CHANH_AN_TRANG_CHU_T();
    v_ARRAY_PHUCTHAM.EXTEND(9);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','AHS',vToaAnID,1,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','AHS_CHUA_THANH_NIEN',vToaAnID,2,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','ADS',vToaAnID,3,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','AKT',vToaAnID,4,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','AHC',vToaAnID,5,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','AHN',vToaAnID,6,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','ALD',vToaAnID,7,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','APS',vToaAnID,8,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU('PT','XLHC',vToaAnID,9,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    
    open curReturn for
    select * 
    from table(v_ARRAY_SOTHAM) st
    union all
    select * from table(v_ARRAY_PHUCTHAM) pt
    ;
END;  
PROCEDURE FILL_QLA_CHANH_AN_TRANG_CHU
(
    v_CAP_XET_XU IN VARCHAR2,
    v_LOAIAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_INDEX IN NUMBER,
    v_DATE_TUNGAY Date,
    v_DATE_DENNGAY Date,
    v_ARRAY IN OUT QLA_CHANH_AN_TRANG_CHU_T
)AS
    v_NHAPVUAN NUMBER DEFAULT 0;
    v_CHUYENVUAN NUMBER DEFAULT 0;
    v_AN_TON NUMBER DEFAULT 0;
    v_AN_CHO_THU_LY NUMBER DEFAULT 0;
    v_AN_THU_LY_CHUA_PC NUMBER DEFAULT 0;
    v_AN_THU_LY_DA_PC NUMBER DEFAULT 0;
    v_DA_LEN_LICH_XET_XU NUMBER DEFAULT 0;
    v_DA_GIAI_QUYET NUMBER DEFAULT 0;
    v_CON_LAI NUMBER DEFAULT 0;
    v_AN_TDC NUMBER DEFAULT 0;
    v_AN_SUA_HUY NUMBER DEFAULT 0;
    v_AN_QH_DANG_GQ NUMBER DEFAULT 0;
    v_AN_QH_DA_GQ NUMBER DEFAULT 0;
    v_THULY_MOI NUMBER DEFAULT 0;-- Thụ lý trong kỳ nhưng chưa kết thúc
    /* Thời hạn chuẩn bị xét xử sơ thẩm và gia hạn theo điều 277 Bộ luật tố tụng hình sự 2015 */
    /* Án hình sự tính theo NGÀY */
    v_AHS_DAY_CBXX_CHUA_XAC_DINH NUMBER DEFAULT 120;
    v_AHS_DAY_CBXX_IT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_CBXX_N_TRONG NUMBER DEFAULT 60;
    v_AHS_DAY_CBXX_RAT_N_TRONG NUMBER DEFAULT 90;
    v_AHS_DAY_CBXX_DB_N_TRONG NUMBER DEFAULT 120;
    
    v_AHS_DAY_GIAHAN_CHUA_XAC_DINH NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_IT_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_RAT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_DB_N_TRONG NUMBER DEFAULT 30;
    /* Các án khác tính theo THÁNG */
    v_ADS_MONTH_CBXX NUMBER DEFAULT 6;
    v_AHN_MONTH_CBXX NUMBER DEFAULT 6;
    v_AKT_MONTH_CBXX NUMBER DEFAULT 3;
    v_APS_MONTH_CBXX NUMBER DEFAULT 3;
    v_ALD_MONTH_CBXX NUMBER DEFAULT 3;
    v_AHC_MONTH_CBXX NUMBER DEFAULT 6;
    v_XLHC_MONTH_CBXX NUMBER DEFAULT 6;
    /* Gia hạn sơ thẩm theo THÁNG */
    v_ADS_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AHN_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AKT_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_APS_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_ALD_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_AHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_XLHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    /* Gia hạn phúc thẩm theo NGÀY */
    v_ADS_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AHN_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AKT_DAY_GIAHAN NUMBER DEFAULT 30;
    v_APS_DAY_GIAHAN NUMBER DEFAULT 30;
    v_ALD_DAY_GIAHAN NUMBER DEFAULT 30;
    v_AHC_DAY_GIAHAN NUMBER DEFAULT 30;
    v_XLHC_DAY_GIAHAN NUMBER DEFAULT 30;
    /* Thời hạn chuẩn bị xét xử phúc thẩm tính theo NGÀY */
    v_PHUCTHAM_DAY_CBXX NUMBER DEFAULT 90;
    /* Giai đoạn vụ án */
    v_GIAIDOAN_SOTHAM NUMBER DEFAULT 2;
    v_GIAIDOAN_PHUCTHAM NUMBER DEFAULT 3;
BEGIN
    -- Cấp sơ thẩm
    IF v_CAP_XET_XU='ST' THEN
        BEGIN
            IF v_LOAIAN='AHS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHS_VUAN T2
                    INNER JOIN AHS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
                    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHS_VUAN T2
                    LEFT JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    WHERE T3.ID  || ' '=' '
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHINHSU=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAHS=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2
                    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                                WHERE a.MA='LOAITOIPHAM'
                                ) loai ON loai.ID=T2.LOAITOIPHAMID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
                    WHERE BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                     WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                               WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_SOTHAM_BANAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                               WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                               ELSE 0 END
                              ) BA ON BA.ID=T1.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHS_CHUA_THANH_NIEN' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHS_VUAN T2
                    INNER JOIN AHS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
                    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHS_VUAN T2
                    INNER JOIN AHS_BICANBICAO T4 ON T4.VUANID=T2.ID AND T4.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHS_VUAN T1
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHINHSU=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AHS_VUAN T1
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAHS=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                                WHERE a.MA='LOAITOIPHAM'
                                ) loai ON loai.ID=T2.LOAITOIPHAMID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
                    WHERE BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                     WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                     WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T1
                    INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                               WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                               WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_SOTHAM_BANAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                                               WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                                               WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    --
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='ADS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM ADS_DON T2
                    INNER JOIN ADS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ADS_DON T2
                    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM ADS_DON T2
                    LEFT JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ADS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISDANSU=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ADS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISADS=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ADS_DON T2
                    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1 ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ADS_DON T1
                    INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                                INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ADS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                                INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ADS_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AKT' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AKT_DON T2
                    INNER JOIN AKT_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AKT_DON T2
                    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AKT_DON T2
                    LEFT JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AKT_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISKDTM=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AKT_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAKT=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AKT_DON T2
                    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AKT_DON T1
                    INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                                INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AKT_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                                INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AKT_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHC' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHC_DON T2
                    INNER JOIN AHC_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHC_DON T2
                    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHC_DON T2
                    LEFT JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHANHCHINH=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAHC=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHC_DON T2
                    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHC_DON T1
                    INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                                INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                                INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHN' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHN_DON T2
                    INNER JOIN AHN_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHN_DON T2
                    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHN_DON T2
                    LEFT JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHN_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHNGD=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHN_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAHN=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHN_DON T2
                    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHN_DON T1
                    INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                                INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHN_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                                INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHN_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='ALD' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM ALD_DON T2
                    INNER JOIN ALD_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ALD_DON T2
                    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM ALD_DON T2
                    LEFT JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ALD_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISLAODONG=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ALD_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISALD=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ALD_DON T2
                    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ALD_DON T1
                    INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                                INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ALD_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                                INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ALD_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='APS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM APS_DON T2
                    INNER JOIN APS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM APS_DON T2
                    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM APS_DON T2
                    LEFT JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN APS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISPHASAN=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN APS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAPS=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM APS_DON T2
                    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM APS_DON T1
                    INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                                INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN APS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                                INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN APS_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='XLHC' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM XLHC_DON T2
                    INNER JOIN XLHC_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAANID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM XLHC_DON T2
                    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM XLHC_DON T2
                    LEFT JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
                          AND T2.TOAANID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0
                    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAANID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAANID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN XLHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISXLHC=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN XLHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISXLHC=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAANID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM XLHC_DON T2
                    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAANID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM XLHC_DON T1
                    INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                                INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN XLHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                                INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN XLHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAANID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAANID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            END IF;
        END;
    -- Cấp phúc thẩm
    ELSE
        BEGIN
            IF v_LOAIAN='AHS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHS_VUAN T2
                    INNER JOIN AHS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
                    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHS_VUAN T2
                    LEFT JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHINHSU=1 AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    SELECT COUNT(distinct T1.ID) INTO v_AN_SUA_HUY FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_KETQUA_PHUCTHAM T4 on T4.ID=T3.KETQUAPHUCTHAMID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND T4.ISAHS=1 
                          AND (LOWER(T4.TEN) LIKE '%sửa%' OR LOWER(T4.TEN) LIKE '%hủy%')
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2
                    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                                WHERE a.MA='LOAITOIPHAM'
                                ) loai ON loai.ID=T2.LOAITOIPHAMID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
                    WHERE BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                               ELSE 0 END
                              ) BA ON BA.ID=T1.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHS_CHUA_THANH_NIEN' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHS_VUAN T2
                    INNER JOIN AHS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
                    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHS_VUAN T2
                    INNER JOIN AHS_BICANBICAO T4 ON T4.VUANID=T2.ID AND T4.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.VUANID=T1.ID
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHS_VUAN T1
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHINHSU=1 AND (T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY) AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                      -- Giai đoạn phúc thẩm chưa rõ cách tính án bị hủy, sửa
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
                    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
                    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                                WHERE a.MA='LOAITOIPHAM'
                                ) loai ON loai.ID=T2.LOAITOIPHAMID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.VUANID 
                    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
                    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
                    WHERE BA.VUANID || ' '=' ' 
                          AND QD.VUANID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                     WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T1
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                    INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHS_VUAN T1
                                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                                INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                                INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                                               WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    --
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='ADS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM ADS_DON T2
                    INNER JOIN ADS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ADS_DON T2
                    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM ADS_DON T2
                    LEFT JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ADS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISDANSU=1 AND (T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY) AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                    -- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa.
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ADS_DON T2
                    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ADS_DON T1
                    INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                                INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ADS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                                INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ADS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AKT' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AKT_DON T2
                    INNER JOIN AKT_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AKT_DON T2
                    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AKT_DON T2
                    LEFT JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AKT_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISKDTM=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
						-- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AKT_DON T2
                    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AKT_DON T1
                    INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                                INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AKT_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                                INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AKT_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHC' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHC_DON T2
                    INNER JOIN AHC_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHC_DON T2
                    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHC_DON T2
                    LEFT JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHANHCHINH=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
						-- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHC_DON T2
                    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHC_DON T1
                    INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                                INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                                INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='AHN' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM AHN_DON T2
                    INNER JOIN AHN_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHN_DON T2
                    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM AHN_DON T2
                    LEFT JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN AHN_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISHNGD=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
						-- Giai đoạn phúc thẩm chưa rõ xác định án hủy, sửa
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHN_DON T2
                    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHN_DON T1
                    INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                                INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHN_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                                INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN AHN_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='ALD' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM ALD_DON T2
                    INNER JOIN ALD_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ALD_DON T2
                    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM ALD_DON T2
                    LEFT JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN ALD_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISLAODONG=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                     -- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa.
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ALD_DON T2
                    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ALD_DON T1
                    INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                                INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ALD_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                                INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN ALD_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='APS' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM APS_DON T2
                    INNER JOIN APS_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM APS_DON T2
                    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM APS_DON T2
                    LEFT JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN APS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN APS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN APS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISPHASAN=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
                      -- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa.
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM APS_DON T2
                    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM APS_DON T1
                    INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                                INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN APS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                                INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN APS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            ELSIF v_LOAIAN='XLHC' THEN
                BEGIN
                    -- 1. Nhập vụ án -- v_NHAPVUAN -- Chưa xây dựng control để thực hiện chức năng nhập (Gộp) vụ án
                    
                    -- 2. Chuyển vụ án -- v_CHUYENVUAN
                    SELECT COUNT(distinct T2.ID) INTO v_CHUYENVUAN 
                    FROM XLHC_DON T2
                    INNER JOIN XLHC_CHUYEN_NHAN_AN T3 ON T2.ID=T3.VUANID AND T3.TOACHUYENID=T2.TOAANID
                    WHERE T2.TOAPHUCTHAMID=v_TOAANID 
                        AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                        AND T3.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 3. Án tồn chuyển sang -- v_AN_TON
                    SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM XLHC_DON T2
                    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    WHERE T3.NGAYTHULY < v_DATE_TUNGAY
                          AND BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 4. Án chờ thụ lý -- v_AN_CHO_THU_LY
                    SELECT COUNT(distinct T2.ID) INTO v_AN_CHO_THU_LY FROM XLHC_DON T2
                    LEFT JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    WHERE T3.ID  || ' '=' '
                          AND T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
                          AND T2.TOAPHUCTHAMID=v_TOAANID;
                    -- 5. Đã thụ lý -- Chưa  phân công TP -- v_AN_THU_LY_CHUA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_CHUA_PC FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T3.ID || ' '=' ' 
                        AND T4.ID || ' '=' ';
                    -- 6. Đã thụ lý -- Đã phân công TP -- v_AN_THU_LY_DA_PC
                    SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_DA_PC FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND T3.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
                    WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND (T3.ID>0 OR T4.ID>0);
                    -- 7. Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU -- chưa hiểu Đã lên lịch xét xử
                    
                    -- 8. Đã giải quyết -- v_DA_GIAI_QUYET
                    SELECT COUNT(distinct T1.ID) INTO v_DA_GIAI_QUYET FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND (BA.ID>0 OR QD.ID>0)
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 9. Còn lại (Chưa GQ xong) -- v_CON_LAI
                    SELECT COUNT(distinct T1.ID) INTO v_THULY_MOI FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T3 
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON QD.DONID=T1.ID
                    LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
                    WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND BA.ID || ' '=' ' 
                          AND QD.ID || ' '=' '
                          AND T1.TOAPHUCTHAMID=v_TOAANID;
                    v_CON_LAI:=v_AN_TON+v_THULY_MOI-v_DA_GIAI_QUYET;
                    -- 10. Án TĐC -- v_AN_TDC
                    SELECT COUNT(DISTINCT T1.ID) INTO v_AN_TDC 
                    FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    INNER JOIN XLHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                    INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                    WHERE T4.MA='TDC' AND T4.ISXLHC=1 AND T1.TOAPHUCTHAMID=v_TOAANID AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY;
                    -- 11. Án bị sửa/hủy -- v_AN_SUA_HUY
						-- Giai đoạn phúc thẩm chưa rõ cách xác định án hủy, sửa
                    -- 12. Án quá hạn -- Đang giải quyết -- v_AN_QH_DANG_GQ
                    SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM XLHC_DON T2
                    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                              ) QD ON T2.ID =QD.DONID 
                    LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
                    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
                    WHERE BA.DONID || ' '=' ' 
                          AND QD.DONID || ' '=' '
                          AND T2.TOAPHUCTHAMID=v_TOAANID
                          AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                          AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                     ELSE 0 END;
                    -- 13. Án quá hạn -- Đã giải quyết -- v_AN_QH_DA_GQ
                    SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM XLHC_DON T1
                    INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                                INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN XLHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) QD ON QD.ID=T1.ID 
                    LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                                INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                                INNER JOIN XLHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                                WHERE T1.TOAPHUCTHAMID=v_TOAANID
                                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                                    AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1
                                               ELSE 0 END
                              ) BA ON BA.ID=T2.ID
                    WHERE (BA.ID >0 OR QD.ID >0)
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND T1.TOAPHUCTHAMID=v_TOAANID;
                    -- 
                    v_ARRAY(v_INDEX):=QLA_CHANH_AN_TRANG_CHU_R(v_INDEX,v_TOAANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_TON,v_AN_CHO_THU_LY,v_AN_THU_LY_CHUA_PC,v_AN_THU_LY_DA_PC,v_DA_LEN_LICH_XET_XU,v_DA_GIAI_QUYET,v_CON_LAI,v_AN_TDC,v_AN_SUA_HUY,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
                END;
            END IF;
        END;
    END IF;
END;
PROCEDURE QLA_CHANH_AN_TRANG_CHU_TP
(
  vToaAnID in number, 
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
) AS
  v_ARRAY QLA_THAM_PHAN_TRANG_CHU_T;
BEGIN
   v_ARRAY:= new QLA_THAM_PHAN_TRANG_CHU_T();
   SELECT QLA_THAM_PHAN_TRANG_CHU_R(
      V_STT => ROW_NUMBER() OVER(ORDER BY T1.HOTEN),
      v_TOAANID =>vToaAnID,
      v_THAMPHANID =>T1.ID,
      /* Tên thẩm phán */
      v_TENTHAMPHAN =>T1.HOTEN,
      /* Nhập vụ án */
      v_NHAPVUAN =>0,
      /* Chuyển vụ án */
      v_CHUYENVUAN =>0,
      /* Án được phân công */
	    v_AN_DUOC_PC =>0,
      /* Án đã giải quyết xong */
      v_AN_DA_GQ =>0,
      /* Án Tồn */
      v_AN_TON =>0,
      /* Án Thụ lý mới */
      v_AN_THU_LY_MOI =>0,
      /* Còn lại (chưa giải quyết xong) */
      v_CON_LAI =>0,
      /* Đã lên lịch xét xử */
      v_DA_LEN_LICH_XET_XU =>0,
      /* Đang hoãn */
      v_DANG_HOAN =>0,
      /* Án tạm đình chỉ */
      v_AN_TDC =>0,
      /* Án bị hủy */
      v_AN_HUY =>0,
      /* Án bị sửa */
      v_AN_SUA =>0,
      /* Án quá hạn đang giải quyết */
      v_AN_QH_DANG_GQ =>0,
      /* Án quá hạn đã giải quyết */
      v_AN_QH_DA_GQ =>0
    ) BULK COLLECT INTO v_ARRAY
    from DM_CANBO T1
    inner join DM_TOAAN T2 on T2.ID=T1.TOAANID
    inner join DM_DATAITEM T3 on T3.ID=T1.CHUCDANHID
    where T2.ID=vToaAnID and INSTR('TPSC,TPTC,TPCC',T3.MA)>0;
    
    PKG_QLA_TH.FILL_QLA_CHANH_AN_TRANG_CHU_TP(vToaAnID,vTungay,vDenngay,v_ARRAY);
    
    open curReturn for
    select NVL(V_STT,0) V_STT,v_TOAANID,v_THAMPHANID,NVL(v_TENTHAMPHAN,'TỔNG') v_TENTHAMPHAN
      ,sum(v_NHAPVUAN) v_NHAPVUAN,sum(v_CHUYENVUAN) v_CHUYENVUAN,sum(v_AN_DUOC_PC) v_AN_DUOC_PC,sum(v_AN_DA_GQ) v_AN_DA_GQ,sum(v_AN_TON) v_AN_TON,sum(v_AN_THU_LY_MOI) v_AN_THU_LY_MOI
      ,sum(v_CON_LAI) v_CON_LAI,sum(v_DA_LEN_LICH_XET_XU) v_DA_LEN_LICH_XET_XU,sum(v_DANG_HOAN) v_DANG_HOAN,sum(v_AN_TDC) v_AN_TDC,sum(v_AN_HUY) v_AN_HUY,sum(v_AN_SUA) v_AN_SUA
      ,sum(v_AN_QH_DANG_GQ) v_AN_QH_DANG_GQ,sum(v_AN_QH_DA_GQ) v_AN_QH_DA_GQ
    from table(v_ARRAY)
    group by 
      grouping sets (
                      (V_STT,v_TOAANID,v_THAMPHANID,v_TENTHAMPHAN),
                      ()
                    )
    order by V_STT;
END;
PROCEDURE FILL_QLA_CHANH_AN_TRANG_CHU_TP
(
    v_ToaAnID IN number,
    v_DATE_TUNGAY IN Date,
    v_DATE_DENNGAY IN Date,
    v_ARRAY IN OUT QLA_THAM_PHAN_TRANG_CHU_T
)
AS
  /* Thời hạn chuẩn bị xét xử sơ thẩm và gia hạn theo điều 277 Bộ luật tố tụng hình sự 2015 */
    /* Án hình sự tính theo NGÀY */
    v_AHS_DAY_CBXX_CHUA_XAC_DINH NUMBER DEFAULT 120;
    v_AHS_DAY_CBXX_IT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_CBXX_N_TRONG NUMBER DEFAULT 60;
    v_AHS_DAY_CBXX_RAT_N_TRONG NUMBER DEFAULT 90;
    v_AHS_DAY_CBXX_DB_N_TRONG NUMBER DEFAULT 120;
    
    v_AHS_DAY_GIAHAN_CHUA_XAC_DINH NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_IT_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_RAT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_DB_N_TRONG NUMBER DEFAULT 30;
    /* Các án khác tính theo THÁNG */
    v_ADS_MONTH_CBXX NUMBER DEFAULT 6;
    v_AHN_MONTH_CBXX NUMBER DEFAULT 6;
    v_AKT_MONTH_CBXX NUMBER DEFAULT 3;
    v_APS_MONTH_CBXX NUMBER DEFAULT 3;
    v_ALD_MONTH_CBXX NUMBER DEFAULT 3;
    v_AHC_MONTH_CBXX NUMBER DEFAULT 6;
    v_XLHC_MONTH_CBXX NUMBER DEFAULT 6;
    /* Gia hạn sơ thẩm theo THÁNG */
    v_ADS_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AHN_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AKT_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_APS_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_ALD_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_AHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_XLHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    /* Gia hạn phúc thẩm theo NGÀY */
    v_ADS_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AHN_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AKT_DAY_GIAHAN NUMBER DEFAULT 30;
    v_APS_DAY_GIAHAN NUMBER DEFAULT 30;
    v_ALD_DAY_GIAHAN NUMBER DEFAULT 30;
    v_AHC_DAY_GIAHAN NUMBER DEFAULT 30;
    v_XLHC_DAY_GIAHAN NUMBER DEFAULT 30;
    /* Thời hạn chuẩn bị xét xử phúc thẩm tính theo NGÀY */
    v_PHUCTHAM_DAY_CBXX NUMBER DEFAULT 90;
  /* Giai đoạn vụ án */
  v_GIAIDOAN_SOTHAM NUMBER DEFAULT 2;
  v_GIAIDOAN_PHUCTHAM NUMBER DEFAULT 3;
BEGIN
  --v_ARRAY:= new QLA_THAM_PHAN_TRANG_CHU_T();
  /* Nhập vụ án -- v_NHAPVUAN */

  /* Chuyển vụ án -- v_CHUYENVUAN */
  -- Án Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Kinh tế
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  -- Án Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHS_SOTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_CHUYENVUAN
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_PHUCTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
    WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
      AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND (T4.ID>0 OR T6.ID>0)
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_CHUYENVUAN := v_ARRAY(ITEM.V_STT).v_CHUYENVUAN + ITEM.v_CHUYENVUAN;
  END LOOP;
  /* Án được phân công -- v_AN_DUOC_PC */
  -- Án Dân sự
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Hôn nhân
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Kinh tế
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Lao động
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Hành chính
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Phá sản
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án BP XLHC
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_SOTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  -- Án Hình sự
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETVUAN,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_SOTHAM_HDXX T5 ON T5.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_DUOC_PC
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_PHUCTHAM_HDXX T5 ON T5.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0 AND T5.CANBOID=T1.v_THAMPHANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (T4.ID>0 OR T5.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC := v_ARRAY(ITEM.V_STT).v_AN_DUOC_PC + ITEM.v_AN_DUOC_PC;
  END LOOP;
  /* Án đã giải quyết xong -- v_AN_DA_GQ */
  -- Dân sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM ADS_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM ADS_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN ADS_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Hôn nhân
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AHN_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AHN_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AHN_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Kinh tế
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AKT_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AKT_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AKT_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Lao động
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM ALD_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM ALD_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN ALD_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Hành chính
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AHC_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM AHC_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Phá sản
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM APS_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM APS_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN APS_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- BP XLHC
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM XLHC_SOTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.DONID,T5.MA FROM XLHC_PHUCTHAM_QUYETDINH T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.TOAANID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.DONID=T2.ID
      LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
    -- Hình sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_SOTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.VUANID,T5.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.DONVIID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.VUANID=T2.ID
      LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(T2.ID) v_AN_DA_GQ 
      FROM TABLE(v_ARRAY) T1
      INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND T4.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_PHUCTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T4.ID,T4.VUANID,T5.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T4 
                  INNER JOIN DM_QD_LOAI T5 ON T5.ID=T4.LOAIQDID
                  WHERE T4.DONVIID=v_ToaAnID AND INSTR('CNTT,CVA,DC',T5.MA)>0
                 ) QD ON QD.VUANID=T2.ID
      LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T2.ID AND BA.TOAANID=v_ToaAnID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND (BA.ID>0 OR QD.ID>0)
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_DA_GQ + ITEM.v_AN_DA_GQ;
  END LOOP;
  /* Án tồn */
  -- Dân sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Hôn nhân
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Kinh tế
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Lao động
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Hành chính
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Phá sản
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- BP XLHC
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  -- Án Hình sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_SOTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.VUANID 
      LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.VUANID || ' '=' ' 
        AND QD.VUANID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_TON 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_PHUCTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.VUANID 
      LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
      WHERE T3.NGAYTHULY < v_DATE_TUNGAY
        AND BA.VUANID || ' '=' ' 
        AND QD.VUANID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TON := v_ARRAY(ITEM.V_STT).v_AN_TON + ITEM.v_AN_TON;
  END LOOP;
  /* Thụ lý mới */
  /* Còn lại (chưa giải quyết xong) -- v_CON_LAI:= án tồn + thụ lý mới - đã giải quyết */
  -- Dân sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ADS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ADS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Hôn nhân
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHN_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHN_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Kinh tế
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AKT_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AKT_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Lao động
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN ALD_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ALD_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Hành chính
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN AHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Phá sản
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN APS_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN APS_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- BP XLHC
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_SOTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
      LEFT JOIN XLHC_DON_THAMPHAN T4 ON T4.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN XLHC_PHUCTHAM_HDXX T6 ON T6.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.DONID 
      LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.DONID || ' '=' ' 
        AND QD.DONID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  -- Án Hình sự
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
      INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_SOTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.VUANID 
      LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.VUANID || ' '=' ' 
        AND QD.VUANID || ' '=' '
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP;
  FOR ITEM IN
    (
      SELECT T1.V_STT,COUNT(DISTINCT T2.ID) v_AN_THU_LY_MOI 
      FROM TABLE(v_ARRAY) T1 
      INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
      INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
      LEFT JOIN AHS_THAMPHANGIAIQUYET T4 ON T4.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T4.MAVAITRO)>0 AND T4.CANBOID=T1.v_THAMPHANID
      LEFT JOIN AHS_PHUCTHAM_HDXX T6 ON T6.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T6.MAVAITRO || ',')>0 AND T6.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                  INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                  WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                ) QD ON T2.ID =QD.VUANID 
      LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
      WHERE T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND BA.VUANID || ' '=' ' 
        AND QD.VUANID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T6.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI := v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI + ITEM.v_AN_THU_LY_MOI;
    v_ARRAY(ITEM.V_STT).v_CON_LAI := v_ARRAY(ITEM.V_STT).v_CON_LAI + v_ARRAY(ITEM.V_STT).v_AN_TON + v_ARRAY(ITEM.V_STT).v_AN_THU_LY_MOI - v_ARRAY(ITEM.V_STT).v_AN_DA_GQ;
  END LOOP; 
  /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */

  /* Đang hoãn -- v_DANG_HOAN */
  -- Án Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án Kinh Tế
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  -- Án Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_DANG_HOAN 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='HPT'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_DANG_HOAN := v_ARRAY(ITEM.V_STT).v_DANG_HOAN + ITEM.v_DANG_HOAN;
   END LOOP;
  /* Án tạm đình chỉ -- v_AN_TDC */
  -- Án Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ADS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHN_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án Kinh Tế
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AKT_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN ALD_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN AHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN APS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    INNER JOIN XLHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  -- Án Hình sự
   FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAANID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_TDC 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    WHERE T6.MA='TDC'
      AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T2.TOAPHUCTHAMID=v_ToaAnID
      AND (T4.ID>0 OR T7.ID>0)
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_TDC := v_ARRAY(ITEM.V_STT).v_AN_TDC + ITEM.v_AN_TDC;
   END LOOP;
  /* Án bị hủy -- v_AN_HUY */
  --Án Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISADS=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHN=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Kinh tế
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAKT=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISALD=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHC=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAPS=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISXLHC=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  --Án Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_HUY
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
    INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 on T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHS=1 
      AND LOWER(T6.TEN) LIKE '%hủy%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_HUY := v_ARRAY(ITEM.V_STT).v_AN_HUY + ITEM.v_AN_HUY;
  END LOOP;
  /* Án bị sửa -- v_AN_SUA */
  --Án Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISADS=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHN=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Kinh tế
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAKT=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISALD=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHC=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAPS=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
    INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISXLHC=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  --Án Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_SUA
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
    INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=T1.v_THAMPHANID
    INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
    INNER JOIN DM_KETQUA_PHUCTHAM T6 on T6.ID=T5.KETQUAPHUCTHAMID
    WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
      AND T6.ISAHS=1 
      AND LOWER(T6.TEN) LIKE '%sửa%'
      AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_SUA := v_ARRAY(ITEM.V_STT).v_AN_SUA + ITEM.v_AN_SUA;
  END LOOP;
  /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
  -- Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Kinh tế
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DANG_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
              ) QD ON T2.ID =QD.DONID 
    LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
    LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
              ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
    WHERE BA.DONID || ' '=' ' 
      AND QD.DONID || ' '=' '
      AND T2.TOAPHUCTHAMID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END
    GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
   END LOOP;
  -- Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_QH_DANG_GQ
    FROM TABLE(v_ARRAY) T1 
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
                ) loai ON loai.ID=T2.LOAITOIPHAMID
    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
               ) QD ON T2.ID =QD.VUANID 
    LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
               ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
    WHERE BA.VUANID || ' '=' ' 
      AND QD.VUANID || ' '=' '
      AND T2.TOAANID=v_TOAANID
      AND (T4.ID>0 OR T7.ID>0)
      AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
      AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                 WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                 ELSE 0 END
    GROUP BY T1.V_STT
  ) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT, COUNT(DISTINCT T2.ID) v_AN_QH_DANG_GQ
    FROM TABLE(v_ARRAY) T1 
    INNER JOIN AHS_VUAN T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
    
    INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
               ) loai ON loai.ID=T2.LOAITOIPHAMID
     LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
     LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1
                 INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                 WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
               ) QD ON T2.ID =QD.VUANID 
    LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
    LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
               ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
    WHERE BA.VUANID || ' '=' ' 
        AND QD.VUANID || ' '=' '
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                   WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                   WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                   WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                   WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                   ELSE 0 END
	GROUP BY T1.V_STT
	) LOOP
  v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DANG_GQ + ITEM.v_AN_QH_DANG_GQ;
  END LOOP;
  /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
  -- Dân sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ADS_DON T1
                INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN ADS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN ADS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ADS_DON T1
                 INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN ADS_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN ADS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_ADS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ADS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ADS_DON T1
                INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN ADS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ADS_DON T1
                 INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN ADS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN ADS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  -- Hôn nhân
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHN_DON T1
                INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AHN_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AHN_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHN_DON T1
                 INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AHN_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN AHN_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHN_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHN_DON T1
                INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AHN_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHN_DON T1
                 INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AHN_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AHN_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  -- Kinh tế
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AKT_DON T1
                INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AKT_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AKT_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AKT_DON T1
                 INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AKT_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN AKT_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AKT_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AKT_DON T1
                INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AKT_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AKT_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AKT_DON T1
                 INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AKT_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN AKT_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN AKT_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AKT_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  -- Lao động
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ALD_DON T1
                INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN ALD_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ALD_DON T1
                 INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN ALD_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN ALD_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ALD_DON T1
                INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN ALD_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM ALD_DON T1
                 INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN ALD_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN ALD_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
   -- Hành chính
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHC_DON T1
                INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHC_DON T1
                 INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN AHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHC_DON T1
                INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN AHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM AHC_DON T1
                 INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN AHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN AHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
   -- Phá sản
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM APS_DON T1
                INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN APS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN APS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM APS_DON T1
                 INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN APS_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN APS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN APS_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM APS_DON T1
                INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN APS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM APS_DON T1
                 INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN APS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN APS_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
   -- BP XLHC
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM XLHC_DON T1
                INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN XLHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN XLHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
              ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM XLHC_DON T1
                 INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN XLHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                 LEFT JOIN XLHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN XLHC_DON T2 ON T2.TOAPHUCTHAMID=T1.v_TOAANID
    INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
    LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM XLHC_DON T1
                INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                INNER JOIN XLHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                LEFT JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T5.CANBOID FROM XLHC_DON T1
                 INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                 INNER JOIN XLHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                 INNER JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                 LEFT JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                 LEFT JOIN XLHC_DON_THAMPHAN T7 ON T7.DONID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                 LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T5.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                 ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
     GROUP BY T1.V_STT
    ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
   END LOOP;
   -- Hình sự
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
    LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0 AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                LEFT JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                           ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T8.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                             WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                             ELSE 0 END
              ) QD ON QD.ID=T2.ID  AND QD.CANBOID=T1.v_THAMPHANID
     LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                 INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                 INNER JOIN AHS_SOTHAM_BANAN T3 ON T3.VUANID=T1.ID
                 INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                 LEFT JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                 LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T7.MAVAITRO)>0
                 LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                   AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                   AND (T8.ID>0 OR T7.ID>0)
                   AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                              WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                              ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
      WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAANID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
      ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
  END LOOP;
  FOR ITEM IN
  (
    SELECT T1.V_STT,COUNT(T2.ID) v_AN_QH_DA_GQ 
    FROM TABLE(v_ARRAY) T1
    INNER JOIN AHS_VUAN T2 ON T2.TOAANID=T1.v_TOAANID
    INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
    LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=T1.v_THAMPHANID
    LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T2.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND T7.CANBOID=T1.v_THAMPHANID
    LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                LEFT JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                          ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND (T8.ID>0 OR T7.ID>0)
                  AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                             WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                             WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                             WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                             WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                             ELSE 0 END
               ) QD ON QD.ID=T2.ID AND QD.CANBOID=T1.v_THAMPHANID
      LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                  INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                  INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                  INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                  LEFT JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                  LEFT JOIN AHS_THAMPHANGIAIQUYET T7 ON T7.VUANID=T1.ID AND T7.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                  LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                              INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                              WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                             ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                  WHERE T1.TOAPHUCTHAMID=v_TOAANID
                    AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                    AND (T8.ID>0 OR T7.ID>0)
                    AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 
                               WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 
                               WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 
                               WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 
                               WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 
                               ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=T1.v_THAMPHANID
       WHERE (BA.ID >0 OR QD.ID >0)
        AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
        AND T2.TOAPHUCTHAMID=v_TOAANID
        AND (T4.ID>0 OR T7.ID>0)
      GROUP BY T1.V_STT
      ) LOOP
    v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ := v_ARRAY(ITEM.V_STT).v_AN_QH_DA_GQ + ITEM.v_AN_QH_DA_GQ;
  END LOOP;
     
END;
PROCEDURE QLA_CA_TRANG_CHU_TP_CHITIET
(
  vToaAnID in number, 
  vThamPhanID in number,
  vTungay in date,
  vDenngay in date,
  curReturn OUT sys_refcursor
)AS
  v_ARRAY_SOTHAM QLA_TP_TRANG_CHU_CHI_TIET_T;
  v_ARRAY_PHUCTHAM QLA_TP_TRANG_CHU_CHI_TIET_T;
BEGIN
    /* Sơ thẩm */
    v_ARRAY_SOTHAM:= new QLA_TP_TRANG_CHU_CHI_TIET_T();
    v_ARRAY_SOTHAM.EXTEND(9);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','AHS',vToaAnID,vThamPhanID,1,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','AHS_CHUA_THANH_NIEN',vToaAnID,vThamPhanID,2,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','ADS',vToaAnID,vThamPhanID,3,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','AKT',vToaAnID,vThamPhanID,4,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','AHC',vToaAnID,vThamPhanID,5,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','AHN',vToaAnID,vThamPhanID,6,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','ALD',vToaAnID,vThamPhanID,7,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','APS',vToaAnID,vThamPhanID,8,vTungay,vDenngay,v_ARRAY_SOTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('ST','XLHC',vToaAnID,vThamPhanID,9,vTungay,vDenngay,v_ARRAY_SOTHAM);
    /* Phúc thẩm */
    v_ARRAY_PHUCTHAM:= new QLA_TP_TRANG_CHU_CHI_TIET_T();
    v_ARRAY_PHUCTHAM.EXTEND(9);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','AHS',vToaAnID,vThamPhanID,1,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','AHS_CHUA_THANH_NIEN',vToaAnID,vThamPhanID,2,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','ADS',vToaAnID,vThamPhanID,3,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','AKT',vToaAnID,vThamPhanID,4,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','AHC',vToaAnID,vThamPhanID,5,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','AHN',vToaAnID,vThamPhanID,6,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','ALD',vToaAnID,vThamPhanID,7,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','APS',vToaAnID,vThamPhanID,8,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    PKG_QLA_TH.FILL_QLA_CA_HOME_TP_CHITIET('PT','XLHC',vToaAnID,vThamPhanID,9,vTungay,vDenngay,v_ARRAY_PHUCTHAM);
    
    open curReturn for
    select * 
    from table(v_ARRAY_SOTHAM) st
    union all
    select * from table(v_ARRAY_PHUCTHAM) pt
    ;
END;
PROCEDURE FILL_QLA_CA_HOME_TP_CHITIET
(
    v_CAP_XET_XU IN VARCHAR2,
    v_LOAIAN IN VARCHAR2,
    v_TOAANID IN NUMBER,
    v_THAMPHANID IN NUMBER,
    v_INDEX IN NUMBER,
    v_DATE_TUNGAY IN Date,
    v_DATE_DENNGAY IN Date,
    v_ARRAY IN OUT QLA_TP_TRANG_CHU_CHI_TIET_T
)AS
  v_NHAPVUAN NUMBER DEFAULT 0;
  v_CHUYENVUAN NUMBER DEFAULT 0;
  v_AN_DUOC_PC NUMBER DEFAULT 0;
  v_AN_DA_GQ NUMBER DEFAULT 0;
  v_AN_TON NUMBER DEFAULT 0;
  v_AN_THU_LY_MOI NUMBER DEFAULT 0;
  v_CON_LAI NUMBER DEFAULT 0;
  v_DA_LEN_LICH_XET_XU NUMBER DEFAULT 0;
  v_DANG_HOAN NUMBER DEFAULT 0;
  v_AN_TDC NUMBER DEFAULT 0;
  v_AN_HUY NUMBER DEFAULT 0;
  v_AN_SUA NUMBER DEFAULT 0;
  v_AN_QH_DANG_GQ NUMBER DEFAULT 0;
  v_AN_QH_DA_GQ NUMBER DEFAULT 0;
  /* Thời hạn chuẩn bị xét xử sơ thẩm và gia hạn theo điều 277 Bộ luật tố tụng hình sự 2015 */
    /* Án hình sự tính theo NGÀY */
    v_AHS_DAY_CBXX_CHUA_XAC_DINH NUMBER DEFAULT 120;
    v_AHS_DAY_CBXX_IT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_CBXX_N_TRONG NUMBER DEFAULT 60;
    v_AHS_DAY_CBXX_RAT_N_TRONG NUMBER DEFAULT 90;
    v_AHS_DAY_CBXX_DB_N_TRONG NUMBER DEFAULT 120;
    
    v_AHS_DAY_GIAHAN_CHUA_XAC_DINH NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_IT_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_N_TRONG NUMBER DEFAULT 15;
    v_AHS_DAY_GIAHAN_RAT_N_TRONG NUMBER DEFAULT 30;
    v_AHS_DAY_GIAHAN_DB_N_TRONG NUMBER DEFAULT 30;
    /* Các án khác tính theo THÁNG */
    v_ADS_MONTH_CBXX NUMBER DEFAULT 6;
    v_AHN_MONTH_CBXX NUMBER DEFAULT 6;
    v_AKT_MONTH_CBXX NUMBER DEFAULT 3;
    v_APS_MONTH_CBXX NUMBER DEFAULT 3;
    v_ALD_MONTH_CBXX NUMBER DEFAULT 3;
    v_AHC_MONTH_CBXX NUMBER DEFAULT 6;
    v_XLHC_MONTH_CBXX NUMBER DEFAULT 6;
    /* Gia hạn sơ thẩm theo THÁNG */
    v_ADS_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AHN_MONTH_GIAHAN NUMBER DEFAULT 2;
    v_AKT_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_APS_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_ALD_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_AHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    v_XLHC_MONTH_GIAHAN NUMBER DEFAULT 1;
    /* Gia hạn phúc thẩm theo NGÀY */
    v_ADS_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AHN_DAY_GIAHAN NUMBER DEFAULT 60;
    v_AKT_DAY_GIAHAN NUMBER DEFAULT 30;
    v_APS_DAY_GIAHAN NUMBER DEFAULT 30;
    v_ALD_DAY_GIAHAN NUMBER DEFAULT 30;
    v_AHC_DAY_GIAHAN NUMBER DEFAULT 30;
    v_XLHC_DAY_GIAHAN NUMBER DEFAULT 30;
    /* Thời hạn chuẩn bị xét xử phúc thẩm tính theo NGÀY */
    v_PHUCTHAM_DAY_CBXX NUMBER DEFAULT 90;
  /* Giai đoạn vụ án */
  v_GIAIDOAN_SOTHAM NUMBER DEFAULT 2;
  v_GIAIDOAN_PHUCTHAM NUMBER DEFAULT 3;
BEGIN
  IF v_CAP_XET_XU='ST' THEN
    BEGIN
      IF v_LOAIAN='AHS' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETVUAN,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
                ) loai ON loai.ID=T2.LOAITOIPHAMID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                 ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                 ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
          WHERE BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                 WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                INNER JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID
                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                      INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                      WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                       ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                  AND T8.CANBOID=v_THAMPHANID
                  AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                       WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                       ELSE 0 END
                ) QD ON QD.ID=T2.ID  AND QD.CANBOID=v_THAMPHANID
           LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                 INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                 INNER JOIN AHS_SOTHAM_BANAN T3 ON T3.VUANID=T1.ID
                 INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                 INNER JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID
                 LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                       INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                       WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                      ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAANID=v_TOAANID
                   AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                   AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                   AND T8.CANBOID=v_THAMPHANID
                   AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                        WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                        ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=v_THAMPHANID
            WHERE (BA.ID >0 OR QD.ID >0)
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T2.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHS_CHUA_THANH_NIEN' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
          LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETVUAN,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHS_VUAN T1
          INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T1.ID AND T5.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2 
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
          INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
                ) loai ON loai.ID=T2.LOAITOIPHAMID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                 ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_SOTHAM_BANAN BA ON T2.ID =BA.VUANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                 ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
          WHERE BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                 WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T2
          INNER JOIN AHS_SOTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_SOTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_BICANBICAO T5 ON T5.VUANID=T2.ID AND T5.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                      INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                      INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                      INNER JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID
                      INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
                      LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                            INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                            WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                             ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                        AND T8.CANBOID=v_THAMPHANID
                        AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                             WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                             WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                             ELSE 0 END
                    ) QD ON QD.ID=T2.ID  AND QD.CANBOID=v_THAMPHANID
           LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                       INNER JOIN AHS_SOTHAM_THULY T2 ON T2.VUANID=T1.ID
                       INNER JOIN AHS_SOTHAM_BANAN T3 ON T3.VUANID=T1.ID
                       INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                       INNER JOIN AHS_SOTHAM_HDXX T8 ON T8.VUANID=T1.ID
                       INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
                       LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_SOTHAM_QUYETDINH_VUAN T6 
                             INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                             WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                            ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                       WHERE T1.TOAANID=v_TOAANID
                         AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                         AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                         AND T8.CANBOID=v_THAMPHANID
                         AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_CHUA_XAC_DINH + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                              WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_IT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_RAT_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                              WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_AHS_DAY_CBXX_DB_N_TRONG + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                              ELSE 0 END
                      ) BA ON BA.ID=T2.ID AND BA.CANBOID=v_THAMPHANID
            WHERE (BA.ID >0 OR QD.ID >0)
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T2.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID;

          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='ADS' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM ADS_DON T2
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM ADS_DON T1
          INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM ADS_DON T1
          INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ADS_DON T2
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ADS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM ADS_DON T1
          INNER JOIN ADS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM ADS_DON T2
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISDANSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM ADS_DON T2
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISDANSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ADS_DON T2 
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISADS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ADS_DON T2 
          INNER JOIN ADS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ADS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISADS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ADS_DON T1
          INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                      INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                      INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
            
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AKT' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AKT_DON T2
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AKT_DON T1
          INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AKT_DON T1
          INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AKT_DON T2
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AKT_DON T1
          INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AKT_DON T2
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISKDTM=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AKT_DON T2
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISKDTM=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AKT_DON T2 
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAKT=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AKT_DON T2 
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAKT=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AKT_DON T2
          INNER JOIN AKT_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AKT_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AKT_DON T1
          INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                      INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AKT_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AKT_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                      INNER JOIN AKT_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AKT_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AKT_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AKT_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
            
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHC' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHC_DON T2
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHC_DON T1
          INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHC_DON T1
          INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHC_DON T2
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHC_DON T1
          INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHC_DON T2
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHANHCHINH=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHC_DON T2
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHANHCHINH=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHC_DON T2 
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHC=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHC_DON T2 
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHC=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHC_DON T2
          INNER JOIN AHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHC_DON T1
          INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                      INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                      INNER JOIN AHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHN' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHN_DON T2
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHN_DON T1
          INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHN_DON T1
          INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHN_DON T2
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHN_DON T1
          INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHN_DON T2
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHNGD=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHN_DON T2
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHNGD=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHN_DON T2 
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHN=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHN_DON T2 
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHN=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHN_DON T2
          INNER JOIN AHN_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHN_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHN_DON T1
          INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                      INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHN_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AHN_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                      INNER JOIN AHN_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHN_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AHN_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_AHN_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='ALD' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM ALD_DON T2
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM ALD_DON T1
          INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM ALD_DON T1
          INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ALD_DON T2
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM ALD_DON T1
          INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM ALD_DON T2
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISLAODONG=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM ALD_DON T2
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISLAODONG=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ALD_DON T2 
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISALD=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ALD_DON T2 
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISALD=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ALD_DON T2
          INNER JOIN ALD_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ALD_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ALD_DON T1
          INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                      INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ALD_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                      INNER JOIN ALD_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ALD_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN ALD_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_ALD_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='APS' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM APS_DON T2
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM APS_DON T1
          INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM APS_DON T1
          INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM APS_DON T2
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM APS_DON T1
          INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM APS_DON T2
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISPHASAN=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM APS_DON T2
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISPHASAN=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  APS_DON T2 
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAPS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  APS_DON T2 
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAPS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM APS_DON T2
          INNER JOIN APS_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN APS_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM APS_DON T1
          INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                      INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN APS_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN APS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                      INNER JOIN APS_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN APS_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN APS_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_APS_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='XLHC' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM XLHC_DON T2
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_SOTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAANID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM XLHC_DON T1
          INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAANID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM XLHC_DON T1
          INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAANID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM XLHC_DON T2
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM XLHC_DON T1
          INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAANID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM XLHC_DON T2
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISXLHC=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM XLHC_DON T2
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISXLHC=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAANID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  XLHC_DON T2 
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISXLHC=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  XLHC_DON T2 
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISXLHC=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAANID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM XLHC_DON T2
          INNER JOIN XLHC_SOTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_SOTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN XLHC_SOTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAANID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN MONTHS_BETWEEN(SYSDATE,T3.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM XLHC_DON T1
          INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_SOTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                      INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN XLHC_SOTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN XLHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYQD,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                      INNER JOIN XLHC_SOTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN XLHC_SOTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN XLHC_SOTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_SOTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAANID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN MONTHS_BETWEEN(T3.NGAYTUYENAN,T2.NGAYTHULY) > v_XLHC_MONTH_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_MONTH_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAANID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      END IF;
    END;
  ELSIF v_CAP_XET_XU='PT' THEN
    BEGIN
      IF v_LOAIAN='AHS' THEN
        BEGIN
                    /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
          LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
                ) loai ON loai.ID=T2.LOAITOIPHAMID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                 ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                 ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
          WHERE BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                 WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
                INNER JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID
                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                      INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                      WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                       ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                  AND T8.CANBOID=v_THAMPHANID
                  AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                       WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                       ELSE 0 END
                ) QD ON QD.ID=T2.ID  AND QD.CANBOID=v_THAMPHANID
           LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                 INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                 INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                 INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
                 INNER JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID
                 LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                       INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                       WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                      ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                   AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                   AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                   AND T8.CANBOID=v_THAMPHANID
                   AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                        WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                        ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=v_THAMPHANID
            WHERE (BA.ID >0 OR QD.ID >0)
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHS_CHUA_THANH_NIEN' THEN
        BEGIN
                    /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T1.ID AND T6.ISTREVITHANHNIEN=1
          LEFT JOIN AHS_THAMPHANGIAIQUYET T3 ON T3.VUANID=T1.ID AND INSTR('VTTP_GIAIQUYETPHUCTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T1.ID AND T6.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHS_VUAN T1
          INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T1.ID AND T6.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT T3.ID,T3.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.VUANID=T1.ID
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON BA.VUANID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
		  INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHINHSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
		  INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID 
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHS_PHUCTHAM_BANAN T5 ON T5.VUANID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
		  INNER JOIN AHS_BICANBICAO T7 ON T7.VUANID=T2.ID AND T7.ISTREVITHANHNIEN=1
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DANG_GQ FROM AHS_VUAN T2 
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          INNER JOIN (SELECT b.ID,b.TEN,b.MA FROM DM_DATAGROUP a
                INNER JOIN DM_DATAITEM b ON b.GROUPID=a.ID
                WHERE a.MA='LOAITOIPHAM'
                ) loai ON loai.ID=T2.LOAITOIPHAMID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                 ) QD ON T2.ID =QD.VUANID 
          LEFT JOIN AHS_PHUCTHAM_BANAN BA ON T2.ID =BA.VUANID
          LEFT JOIN ( SELECT T1.VUANID,T4.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                WHERE T1.DONVIID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                 ) GIA_HAN ON T2.ID =GIA_HAN.VUANID -- Nếu có gia hạn
          WHERE BA.VUANID || ' '=' ' 
            AND QD.VUANID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND 1=CASE WHEN (LOWER(loai.TEN) LIKE '%chưa xác định%' OR loai.MA='LTP00') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                 WHEN (LOWER(loai.TEN) LIKE '%ít nghiêm trọng%' OR loai.MA='LTP01') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%nghiêm trọng%' OR loai.MA='LTP02') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%rất nghiêm trọng%' OR loai.MA='LTP03') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                 WHEN (LOWER(loai.TEN) LIKE '%đặc biệt nghiêm trọng%' OR loai.MA='LTP04') AND TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_QH_DA_GQ FROM AHS_VUAN T2
          INNER JOIN AHS_PHUCTHAM_THULY T3 ON T3.VUANID=T2.ID
          INNER JOIN AHS_PHUCTHAM_HDXX T4 ON T4.VUANID=T2.ID
		  INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T2.ID AND T6.ISTREVITHANHNIEN=1
          LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T3 ON T3.VUANID=T1.ID
                INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                INNER JOIN DM_DATAITEM T5 ON T5.ID=T1.LOAITOIPHAMID
				INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T1.ID AND T6.ISTREVITHANHNIEN=1
                INNER JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID
                LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                      INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                      WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                       ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                  AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                  AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                  AND T8.CANBOID=v_THAMPHANID
                  AND 1=CASE WHEN (LOWER(T5.TEN) LIKE '%chưa xác định%' OR T5.MA='LTP00') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                       WHEN (LOWER(T5.TEN) LIKE '%ít nghiêm trọng%' OR T5.MA='LTP01') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%nghiêm trọng%' OR T5.MA='LTP02') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%rất nghiêm trọng%' OR T5.MA='LTP03') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                       WHEN (LOWER(T5.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T5.MA='LTP04') AND TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                       ELSE 0 END
                ) QD ON QD.ID=T2.ID  AND QD.CANBOID=v_THAMPHANID
           LEFT JOIN ( SELECT DISTINCT T1.ID,T8.CANBOID FROM AHS_VUAN T1
                 INNER JOIN AHS_PHUCTHAM_THULY T2 ON T2.VUANID=T1.ID
                 INNER JOIN AHS_PHUCTHAM_BANAN T3 ON T3.VUANID=T1.ID
                 INNER JOIN DM_DATAITEM T4 ON T4.ID=T1.LOAITOIPHAMID
				 INNER JOIN AHS_BICANBICAO T6 ON T6.VUANID=T1.ID AND T6.ISTREVITHANHNIEN=1
                 INNER JOIN AHS_PHUCTHAM_HDXX T8 ON T8.VUANID=T1.ID
                 LEFT JOIN ( SELECT T6.VUANID,T7.MA FROM AHS_PHUCTHAM_QUYETDINH_VUAN T6 
                       INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                       WHERE T6.DONVIID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                      ) GIA_HAN ON GIA_HAN.VUANID=T1.ID -- Nếu có gia hạn
                 WHERE T1.TOAPHUCTHAMID=v_TOAANID
                   AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                   AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T8.MAVAITRO || ',')>0
                   AND T8.CANBOID=v_THAMPHANID
                   AND 1=CASE WHEN (LOWER(T4.TEN) LIKE '%chưa xác định%' OR T4.MA='LTP00') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_CHUA_XAC_DINH) THEN 1 -- Chưa xác định
                        WHEN (LOWER(T4.TEN) LIKE '%ít nghiêm trọng%' OR T4.MA='LTP01') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_IT_N_TRONG) THEN 1 -- Ít nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%nghiêm trọng%' OR T4.MA='LTP02') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_N_TRONG) THEN 1 -- Nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%rất nghiêm trọng%' OR T4.MA='LTP03') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_RAT_N_TRONG) THEN 1 -- Rất nghiêm trọng
                        WHEN (LOWER(T4.TEN) LIKE '%đặc biệt nghiêm trọng%' OR T4.MA='LTP04') AND TRUNC(T3.NGAYBANAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.VUANID,NULL,0,v_AHS_DAY_GIAHAN_DB_N_TRONG) THEN 1 -- Đặc biệt nghiêm trọng
                        ELSE 0 END
                ) BA ON BA.ID=T2.ID AND BA.CANBOID=v_THAMPHANID
            WHERE (BA.ID >0 OR QD.ID >0)
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='ADS' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM ADS_DON T1
          INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN ADS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM ADS_DON T1
          INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN ADS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM ADS_DON T1
          INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN ADS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISDANSU=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISDANSU=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ADS_DON T2 
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISADS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ADS_DON T2 
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ADS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISADS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ADS_DON T2
          INNER JOIN ADS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ADS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ADS_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ADS_DON T1
          INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ADS_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                      INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ADS_DON T1
                      INNER JOIN ADS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN ADS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ADS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ADS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
           
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AKT' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AKT_DON T2
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AKT_DON T1
          INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AKT_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AKT_DON T1
          INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AKT_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AKT_DON T2
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AKT_DON T1
          INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AKT_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AKT_DON T2
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISKDTM=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AKT_DON T2
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISKDTM=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AKT_DON T2 
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAKT=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AKT_DON T2 
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AKT_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAKT=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AKT_DON T2
          INNER JOIN AKT_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AKT_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AKT_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AKT_DON T1
          INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AKT_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                      INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AKT_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AKT_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AKT_DON T1
                      INNER JOIN AKT_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AKT_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AKT_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AKT_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AKT_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHC' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHC_DON T2
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHC_DON T1
          INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHC_DON T1
          INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHC_DON T2
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHC_DON T1
          INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHC_DON T2
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHANHCHINH=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHC_DON T2
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHANHCHINH=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHC_DON T2 
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHC=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHC_DON T2 
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHC=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHC_DON T2
          INNER JOIN AHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHC_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHC_DON T1
          INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHC_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                      INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHC_DON T1
                      INNER JOIN AHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHC_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='AHN' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM AHN_DON T2
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM AHN_DON T1
          INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN AHN_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM AHN_DON T1
          INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHN_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM AHN_DON T2
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM AHN_DON T1
          INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN AHN_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM AHN_DON T2
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHNGD=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM AHN_DON T2
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISHNGD=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHN_DON T2 
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHN=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  AHN_DON T2 
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN AHN_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAHN=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM AHN_DON T2
          INNER JOIN AHN_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN AHN_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM AHN_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM AHN_DON T1
          INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN AHN_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                      INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHN_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM AHN_DON T1
                      INNER JOIN AHN_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN AHN_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN AHN_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM AHN_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_AHN_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='ALD' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM ALD_DON T2
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM ALD_DON T1
          INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN ALD_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM ALD_DON T1
          INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN ALD_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM ALD_DON T2
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM ALD_DON T1
          INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN ALD_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM ALD_DON T2
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISLAODONG=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM ALD_DON T2
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISLAODONG=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ALD_DON T2 
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISALD=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  ALD_DON T2 
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN ALD_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISALD=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM ALD_DON T2
          INNER JOIN ALD_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN ALD_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM ALD_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM ALD_DON T1
          INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN ALD_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                      INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ALD_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM ALD_DON T1
                      INNER JOIN ALD_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN ALD_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN ALD_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM ALD_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_ALD_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='APS' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM APS_DON T2
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM APS_DON T1
          INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN APS_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM APS_DON T1
          INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN APS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM APS_DON T2
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM APS_DON T1
          INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN APS_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM APS_DON T2
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISPHASAN=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM APS_DON T2
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISPHASAN=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  APS_DON T2 
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAPS=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  APS_DON T2 
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN APS_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISAPS=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM APS_DON T2
          INNER JOIN APS_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN APS_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN APS_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM APS_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM APS_DON T1
          INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN APS_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                      INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN APS_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM APS_DON T1
                      INNER JOIN APS_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN APS_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN APS_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM APS_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_APS_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      ELSIF v_LOAIAN='XLHC' THEN
        BEGIN
          /* Nhập vụ án -- v_NHAPVUAN */
          /* Chuyển vụ án -- v_CHUYENVUAN */
          SELECT COUNT(DISTINCT T2.ID) INTO v_CHUYENVUAN FROM XLHC_DON T2
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_CHUYEN_NHAN_AN T5 ON T5.VUANID=T2.ID AND T5.TOACHUYENID=T2.TOAANID
          WHERE T2.MAGIAIDOAN=v_GIAIDOAN_PHUCTHAM
            AND (T5.NGAYGIAO BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án được phân công -- v_AN_DUOC_PC */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DUOC_PC FROM XLHC_DON T1
          INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          LEFT JOIN XLHC_DON_THAMPHAN T3 ON T3.DONID=T1.ID AND INSTR('VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM',T3.MAVAITRO)>0 AND T3.CANBOID=v_THAMPHANID
          LEFT JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          WHERE T1.TOAPHUCTHAMID=v_TOAANID
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (T3.ID>0 OR T4.ID>0);
          /* Án đã giải quyết xong -- v_AN_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_DA_GQ FROM XLHC_DON T1
          INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON QD.DONID=T1.ID
          LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND (BA.ID>0 OR QD.ID>0)
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Án Tồn -- v_AN_TON */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TON FROM XLHC_DON T2
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                     ) QD ON T2.ID =QD.DONID 
          LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          WHERE T3.NGAYTHULY < v_DATE_TUNGAY
            AND BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án Thụ lý mới -- v_AN_THU_LY_MOI */
          SELECT COUNT(distinct T1.ID) INTO v_AN_THU_LY_MOI FROM XLHC_DON T1
          INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T1.ID AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0 AND T4.CANBOID=v_THAMPHANID
          LEFT JOIN ( SELECT T3.ID,T3.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T3 
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      WHERE T3.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON QD.DONID=T1.ID
          LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID=T1.ID AND BA.TOAANID=v_TOAANID
          WHERE T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND BA.ID || ' '=' ' 
            AND QD.ID || ' '=' '
            AND T1.TOAPHUCTHAMID=v_TOAANID;
          /* Còn lại (chưa giải quyết xong) -- v_CON_LAI */
          v_CON_LAI := v_AN_TON + v_AN_THU_LY_MOI - v_AN_DA_GQ;
          /* Đã lên lịch xét xử -- v_DA_LEN_LICH_XET_XU */
          /* Đang hoãn -- v_DANG_HOAN */
          SELECT COUNT(distinct T2.ID) INTO v_DANG_HOAN FROM XLHC_DON T2
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISXLHC=1 AND T6.MA='HPT'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án tạm đình chỉ -- v_AN_TDC */
          SELECT COUNT(distinct T2.ID) INTO v_AN_TDC FROM XLHC_DON T2
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_QUYETDINH T5 ON T5.DONID=T2.ID
          INNER JOIN DM_QD_LOAI T6 ON T6.ID=T5.LOAIQDID
          WHERE INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND T6.ISXLHC=1 AND T6.MA='TDC'
            AND (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T2.TOAPHUCTHAMID=v_ToaAnID;
          /* Án bị hủy -- v_AN_HUY */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  XLHC_DON T2 
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISXLHC=1 
            AND LOWER(T6.TEN) LIKE '%hủy%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án bị sửa -- v_AN_SUA */
          SELECT COUNT(DISTINCT T2.ID) INTO v_AN_HUY FROM  XLHC_DON T2 
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID 
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID AND T4.CANBOID=v_THAMPHANID
          INNER JOIN XLHC_PHUCTHAM_BANAN T5 ON T5.DONID=T2.ID
          INNER JOIN DM_KETQUA_PHUCTHAM T6 ON T6.ID=T5.KETQUAPHUCTHAMID
          WHERE (T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY)
            AND T6.ISXLHC=1 
            AND LOWER(T6.TEN) LIKE '%sửa%'
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T2.TOAPHUCTHAMID=v_TOAANID;
          /* Án quá hạn đang giải quyết -- v_AN_QH_DANG_GQ */
          SELECT COUNT(distinct T2.ID) INTO v_AN_QH_DANG_GQ FROM XLHC_DON T2
          INNER JOIN XLHC_PHUCTHAM_THULY T3 ON T3.DONID=T2.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T4 ON T4.DONID=T2.ID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                    ) QD ON T2.ID =QD.DONID 
          LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON T2.ID =BA.DONID
          LEFT JOIN ( SELECT T1.DONID,T4.MA FROM XLHC_PHUCTHAM_QUYETDINH T1 
                      INNER JOIN DM_QD_LOAI T4 ON T1.LOAIQDID=T4.ID
                      WHERE T1.TOAANID=v_TOAANID AND (T4.MA='GHTHXX' OR LOWER(T4.TEN) LIKE '%gia hạn%' )
                    ) GIA_HAN ON T2.ID =GIA_HAN.DONID -- Nếu có gia hạn
          WHERE BA.DONID || ' '=' ' 
            AND QD.DONID || ' '=' '
            AND T2.TOAPHUCTHAMID=v_TOAANID
            AND T3.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T4.MAVAITRO || ',')>0
            AND T4.CANBOID=v_THAMPHANID
            AND 1=CASE WHEN TRUNC(SYSDATE - T3.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END;
          /* Án quá hạn đã giải quyết -- v_AN_QH_DA_GQ */
          SELECT COUNT(distinct T1.ID) INTO v_AN_QH_DA_GQ FROM XLHC_DON T1
          INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
          INNER JOIN XLHC_PHUCTHAM_HDXX T3 ON T3.DONID=T1.ID
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                      INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN XLHC_PHUCTHAM_QUYETDINH T3 ON T3.DONID=T1.ID
                      INNER JOIN DM_QD_LOAI T4 ON T4.ID=T3.LOAIQDID
                      INNER JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID AND INSTR('CNTT,CVA,DC',T4.MA)>0
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYQD - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) QD ON QD.ID=T1.ID 
          LEFT JOIN ( SELECT DISTINCT T1.ID FROM XLHC_DON T1
                      INNER JOIN XLHC_PHUCTHAM_THULY T2 ON T2.DONID=T1.ID
                      INNER JOIN XLHC_PHUCTHAM_BANAN T3 ON T3.DONID=T1.ID
                      INNER JOIN XLHC_PHUCTHAM_HDXX T5 ON T5.DONID=T1.ID
                      LEFT JOIN ( SELECT T6.DONID,T7.MA FROM XLHC_PHUCTHAM_QUYETDINH T6 
                                  INNER JOIN DM_QD_LOAI T7 ON T7.ID=T6.LOAIQDID
                                  WHERE T6.TOAANID=v_TOAANID AND (T7.MA='GHTHXX' OR LOWER(T7.TEN) LIKE '%gia hạn%' )
                                 ) GIA_HAN ON GIA_HAN.DONID=T1.ID -- Nếu có gia hạn
                      WHERE T1.TOAPHUCTHAMID=v_TOAANID
                        AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
                        AND 1=CASE WHEN TRUNC(T3.NGAYTUYENAN - T2.NGAYTHULY) > v_PHUCTHAM_DAY_CBXX + DECODE(GIA_HAN.DONID,NULL,0,v_XLHC_DAY_GIAHAN) THEN 1 ELSE 0 END
                        AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T5.MAVAITRO || ',')>0
                        AND T5.CANBOID=v_THAMPHANID
                    ) BA ON BA.ID=T2.ID
          WHERE (BA.ID >0 OR QD.ID >0)
            AND T2.NGAYTHULY BETWEEN v_DATE_TUNGAY AND v_DATE_DENNGAY
            AND T1.TOAPHUCTHAMID=v_TOAANID
            AND INSTR('THAMPHAN,THAMPHANHDXX,HTND,',T3.MAVAITRO || ',')>0
            AND T3.CANBOID=v_THAMPHANID;
          
          v_ARRAY(v_INDEX):=QLA_TP_TRANG_CHU_CHI_TIET_R(v_INDEX,v_TOAANID,v_THAMPHANID,v_CAP_XET_XU,v_LOAIAN,v_NHAPVUAN,v_CHUYENVUAN,v_AN_DUOC_PC,v_AN_DA_GQ,v_AN_TON,v_AN_THU_LY_MOI,v_CON_LAI,v_DA_LEN_LICH_XET_XU,v_DANG_HOAN,v_AN_TDC,v_AN_HUY,v_AN_SUA,v_AN_QH_DANG_GQ,v_AN_QH_DA_GQ);
        END;
      END IF;
    END;
  END IF;
END;
END PKG_QLA_TH;
