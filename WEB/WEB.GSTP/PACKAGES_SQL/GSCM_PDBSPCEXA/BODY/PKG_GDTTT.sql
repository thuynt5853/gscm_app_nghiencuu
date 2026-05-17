create or replace NONEDITIONABLE PACKAGE BODY  "PKG_GDTTT" AS
PROCEDURE QHPL_DINHNGHIA_LIST
(   vPhongbanID in number,  
	curReturn    OUT       sys_refcursor
)IS
  vHS number;
  vDS number;
  vHC number;
  vHN number;
  vKT number;
  vLD number;
  vPS number;  
BEGIN
 select p.ISHINHSU into vHS from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISDANSU into vDS from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISHNGD into vHN from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISKDTM into vKT from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISHANHCHINH into vHC from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISLAODONG into vLD from DM_PHONGBAN p where p.ID=vPhongbanID;
 select p.ISPHASAN into vPS from DM_PHONGBAN p where p.ID=vPhongbanID;
 vHS:=NVL(vHS,0);
 vDS:=NVL(vDS,0);
 vHN:=NVL(vHN,0);
 vKT:=NVL(vKT,0);
 vHC:=NVL(vHC,0);
 vLD:=NVL(vLD,0);
 vPS:=NVL(vPS,0);
 open CurReturn for
  Select q.* 
  from GDTTT_DM_QHPL q
  where (q.LOAIAN=1 and vHS =1) Or (q.LOAIAN=2 and vDS =1)
         Or (q.LOAIAN=3 and vHN =1) Or (q.LOAIAN=4 and vKT =1)
         Or (q.LOAIAN=5 and vLD =1) Or (q.LOAIAN=6 and vHC =1)  Or (q.LOAIAN=7 and vPS =1)
  Order by q.LOAIAN,q.TENQHPL;
END QHPL_DINHNGHIA_LIST;
PROCEDURE CANBO_GETBYDONVI_2CHUCVU
( vDonViID in number,
  vPhongbanID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || '-' || d.TEN as MA_TEN,d.TEN as ChucVu from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2)) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID and a.PHONGBANID=vPhongbanID And a.HIEULUC=1 order by d.ThuTu; 
END CANBO_GETBYDONVI_2CHUCVU;

PROCEDURE CANBO_GETBYDONVI
( donviID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
vGroupChucDanhID number;
BEGIN
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
 if(vChucDanh='TP') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                          c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
    Order by c.Hoten;
elsif(vChucDanh='TTV') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU     
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
    Order by c.Hoten;    
Else
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA=vChucDanh) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1
    Order by c.Hoten;
End if;    
END CANBO_GETBYDONVI;
PROCEDURE CANBO_GETBYPHONGBAN
( donviID in number,
vPhongbanID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
vGroupChucDanhID number;
BEGIN
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
 if(vChucDanh='TP') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID and c.Phongbanid=vPhongbanID
      And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                          c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
    Order by c.Hoten;
elsif(vChucDanh='TTV') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU     
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID  and c.Phongbanid=vPhongbanID and c.HieuLuc =1
    Order by c.Hoten; 


Else
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA=vChucDanh) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID  and c.Phongbanid=vPhongbanID
      And c.HIEULUC=1
    Order by c.Hoten;
End if;    
END CANBO_GETBYPHONGBAN; 



FUNCTION PHANCONGNGAUNHIEN
    ( vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vNguoithuchien number
    )RETURN number AS
     vGroupChucDanhID number;
     vTT number;
     vRand number;
     vKetQuaID number;
     vThamphanID number;
     vLoaiAn number;
     vA number;/*Tổng số đơn đến thời điểm hiện tại*/
     vB number;/*Tổng số thẩm phán*/
     vC number;/*Số ngày đến thời điểm hiện tại*/
     vD number;/*Số ngày nghỉ phép, công tác*/
     vE number;/*Số đơn của thẩm phán đã được phân công*/
     vY number;/*Trọng số sắp xếp*/
     vCT number;/*gán đơn cho thẩm phán đã được phân công trước đây(đơn thụ lý mới lần thứ >1)*/
     vF  number;--Tổng số ngày thẩm phán không được quyền giải quyết đơn
     vN number;
     vVuAnID number; 
     vNgayPhanCongTP date;V_NGAYBONHIEM DATE;V_NGAY_GQD date;
     v_dem NUMBER:=0; --anhvh dùng để test
     vNGAY_GQD DATE; --//Thơi gian duoc phan cong giai quyet don
     vDAUKY DATE; --//Thơi gian đâu kỳ của năm hiện tại
BEGIN
  vN:=EXTRACT(YEAR FROM vDenNgay);
  --DELETE GDTTT_PCTP_CHITIET_TEST;
  --COMMIT;
  if(to_char(vDenNgay,'mm')='12') then
      vN:=vN+1;
  end if;
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select SYSTIMESTAMP into vNgayPhanCongTP from dual;

   /*Lưu thông tin lần phân công*/
    vKetQuaID:=GDTTT_PCTP_KETQUA_SEQ.nextval;
    vC:=TO_CHAR(vDenNgay, 'DDD');
--   vC:=round(sysdate - TO_DATE('11/09/2020','dd/MM/yyyy'),0);
   Insert into GDTTT_PCTP_KETQUA 
   VALUES(vKetQuaID,vNgayPhanCongTP,'',null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchien,null,0);         
   --VALUES(vKetQuaID,(SELECT SYSTIMESTAMP FROM DUAL),'',null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchien,null,0);         

   /*Lấy danh sách đơn ngẫu nhiên để phân công*/
    FOR i IN (Select  d.ID,d.BAQD_LOAIAN,d.BAQD_SO,d.BAQD_NGAYBA,d.BAQD_TOAANID
                                        ,d.BAQD_SO_PT,d.BAQD_NGAYBA_PT,d.BAQD_TOAANID_PT
                                        ,d.BAQD_SO_ST,d.BAQD_NGAYBA_ST,d.BAQD_TOAANID_ST  
                from GDTTT_DON d where d.TOAANID=vToaAnID 
--                and d.LOAIDON <=3 manhnd bo do co nhieu loai don hơn
                and NVL(d.THAMPHANID,0)=0 
                and   (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vDenNgay then 1 else 0 end)
                Or ( 1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vDenNgay then 1 else 0 end))
                       and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
               and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
                                 and d.CD_LOAI=0 and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 Order by DBMS_RANDOM.VALUE)
    LOOP  
    v_dem:=v_dem+1;
      /*Kiểm tra xem đã phân thẩm phán xử lý đơn trùng trước đó chưa*/
      vThamphanID:=NVL(vThamphanID,0); 
      SELECT COUNT(b.ID) into vCT FROM GDTTT_DON b 
          LEFT JOIN DM_CANBO C ON C.ID=b.THAMPHANID
          where NVL(THAMPHANID,0)>0 
                And b.ID<>i.ID 
                And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu 
                And b.isthuly = 1 -- Don thu ly moi
                And b.CD_LOAI = 0 --Noi chuyen Noi bo
--                  Lay ra TP dang xet xu và TP dung xet xu nhung con don dang giai quyet
                    AND ( C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet xử
--                            Dung xet xu nhung con Don dang giai quyet
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 0 and NVL(b.VUVIECID,0) = 0)
                            -- 
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 1 and NVL(b.VUVIECID,0) > 0
                                and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua not in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID) )
                         )  
                     
                    AND ( -- Co vu an duoc phan cong nhung chua giai quyet xong
                            (NVL(b.VUVIECID,0) > 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID))
                             OR NVL(b.VUVIECID,0) = 0
                        )
                    AND  NVL(THAMPHANID,0)>0 
                    AND ((REPLACE(REPLACE(upper(b.BAQD_SO),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO),'-'),'/')  
                                                and b.BAQD_NGAYBA=i.BAQD_NGAYBA 
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST)
                                         )       
                        ;
      vCT:=NVL(vCT,0); 
      if(vCT>0) Then/*gán đơn cho thẩm phán đã được phân công trước đây(đơn thụ lý mới lần thứ >1)*/
        SELECT THAMPHANID into vThamphanID  FROM 
        (SELECT THAMPHANID FROM GDTTT_DON b 
         LEFT JOIN DM_CANBO C ON C.ID=b.THAMPHANID
            where NVL(THAMPHANID,0)>0 
                    And b.ID<>i.ID
                    And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu
                    And b.isthuly = 1 -- Don thu ly moi
                    And b.CD_LOAI = 0 --Noi chuyen Noi bo
--                  Lay ra TP dang xet xu và TP dung xet xu nhung con don dang giai quyet
                    AND ( C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet xử
--                            Dung xet xu nhung con Don dang giai quyet
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 0 and NVL(b.VUVIECID,0) = 0)
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 0 
                                and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua not in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID) )
                         ) 
                        AND ( -- Co vu an duoc phan cong nhung chua giai quyet xong
                            (NVL(b.VUVIECID,0) > 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID))
                             OR NVL(b.VUVIECID,0) = 0
                           
                        )
                    AND  NVL(THAMPHANID,0)>0 
                    AND ((REPLACE(REPLACE(upper(b.BAQD_SO),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO),'-'),'/')  
                                                and b.BAQD_NGAYBA=i.BAQD_NGAYBA 
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST)
                                         )    
        ORDER BY b.NGAYTAO desc) WHERE ROWNUM = 1;
          vThamphanID:=NVL(vThamphanID,0); 
          Insert Into GDTTT_PCTP_CHITIET(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP)
            Values(vToaAnID,vKetQuaID,i.ID,vThamphanID,sysdate);
          Update GDTTT_DON Set THAMPHANID=vThamphanID Where ID=i.ID;
          ----------anhvh add để test GDTTT_PCTP_CHITIET_TEST
           Insert Into GDTTT_PCTP_CHITIET_TEST(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP,GHICHU)
          Values(vToaAnID,vKetQuaID,i.ID,vThamphanID,sysdate,
          '(VY:'||round(VY,5)||')(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')'
          ||'(vF:'||vF||')(DEM:'||v_dem||')đã PCTP trước đó');
          ---------
      Else  
      vLoaiAn:=i.BAQD_LOAIAN;
      /*Tính tổng số đơn đã phân công giải quyết*/    
      Select Count(d.ID) into vA from GDTTT_DON d  
         where d.TOAANID=vToaAnID 
--            and d.LOAIDON <=3 manhnd bo do co nhieu loai don hơn
                and NVL(d.THAMPHANID,0)>0 
              And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD')
              and 1=(Case When (vLoaiAn=1 and d.BAQD_LOAIAN=1) Then 1 When (vLoaiAn=2 and d.BAQD_LOAIAN=2) Then 1
               When (vLoaiAn=6 and d.BAQD_LOAIAN=6) Then 1 When (vLoaiAn in (3,4,5,7) and d.BAQD_LOAIAN  in (3,4,5,7)) Then 1 Else 0 End);
       vA:=NVL(vA,0);

      /*Tính tổng số thẩm phán*/
      Select Count(c.ID) into vB From DM_CANBO c 
        inner join (select i.ID,i.TEN from DM_DATAITEM i 
                    where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC')--'TP','TPSC','TPTC','TPCC', chỉ lấy thẩm phán tối cao
                    ) d1 on d1.ID=c.CHUCDANHID 
      WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet xử
      and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
      AND NVL(c.CHUCVUID,0)<>45 --45 chức vụ chánh án
          And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
                      WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
                      WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
                      WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
                      WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
                      WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
                      WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
          Else 0 End);          
     vB:=NVL(vB,0);
     vTT:=0;

     /*Tạo danh sách thẩm phán dùng phân công*/
      DELETE from GDTTT_PCTP_TMP where TOAANID=vToaAnID;
      FOR j in (
          Select c.ID into vB From DM_CANBO c 
          inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC')) d1 on d1.ID=c.CHUCDANHID --'TP','TPSC','TPTC','TPCC', chỉ lấy thẩm phán tối cao
          WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1
              and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
              AND NVL(c.CHUCVUID,0)<>45 --45 chức vụ chánh án
              And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
                          WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
                          WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
                          WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
                          WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
                          WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
                          WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
              Else 0 End)
          )
      LOOP  vTT:=vTT+1;

        /*Tổng số ngày nghỉ phép trong năm*/
        Select SUM(c.SONGAY) into vD From DM_CANBO_CONGTAC c 
        where TOAANID=vToaAnID AND c.CANBOID=j.ID
          and c.TUNGAY between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD')
                           and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD');
        vD:=NVL(vD,0);

        /*Tổng số đơn đã được phân công*/
        Select Count(d.ID) into vE from GDTTT_DON d 
        LEFT JOIN GDTTT_PCTP_CHITIET CT ON CT.DONID=D.ID
        where d.TOAANID=vToaAnID and d.THAMPHANID=j.ID 
         And d.NGAYTAO--CT.NGAYPHANCONGTP
         between TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
         And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"');/*TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD')  and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD');*/
         ------------ 
        vE:=NVL(vE,0);      
        --Tổng số ngày không được quyền giải quyết đơn trong năm
        SELECT NGAY_GQD INTO vNGAY_GQD FROM DM_CANBO cb where  cb.id=j.ID;
        --Ngay thang dau ky của năm hiện tại
            vDAUKY := TO_DATE(to_char(vN - 1)||'-12-01T23:54:14Z','YYYY-MM-DD"T"HH24:MI:SS"Z"');
--      Nếu ngày phần công đúng trong kỳ năm hiện tại thì lấy theo ngày được giải quyết; Nếu trước ngày năm hiện tại mặc định không mất ngày nào   
        IF (vNGAY_GQD > vDAUKY) THEN
            SELECT TO_CHAR(NGAY_GQD, 'DDD') INTO vF FROM DM_CANBO cb where  cb.id=j.ID;
        ELSE
            vF := 1;
        END IF;
        
        vF:=NVL(vF,0);      
        --tính trọng số cho từng thẩm phán
--        vY:=vE-(vC-vD)*vA*1.0/(vB*vC*1.0);
         vY:=vE/(vC-vD-vF)-(vA/(vB*vC));
--        vA number;/*Tổng số đơn đến thời điểm hiện tại*/
--        vB number;/*Tổng số thẩm phán*/
--        vC number;/*Số ngày đến thời điểm hiện tại*/
--        vD number;/*Số ngày nghỉ phép, công tác*/
--        vE number;/*Số đơn của thẩm phán đã được phân công*/
--        vY number;/*Trọng số sắp xếp*/
--        vCT number;/*Trọng số sắp xếp*/
         Insert into GDTTT_PCTP_TMP VALUES(vToaAnID,j.ID,vY,Cast((vE) as varchar2(10)) || '-(' || Cast((vC) as varchar2(10))||'-'|| Cast((vD) as varchar2(10)) || ')*' ||  Cast((vA) as varchar2(10)) || '*1.0/' ||  Cast((vB) as varchar2(10)) || '*' || Cast((vC) as varchar2(10)),'(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')(VY:'||VY||')(id:'||j.ID||')');
         ----------anhvh add để test GDTTT_PCTP_CHITIET_TEST
          Insert Into GDTTT_PCTP_CHITIET_TEST(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP,GHICHU)
          Values(vToaAnID,vKetQuaID,i.ID,j.ID,sysdate,
          '(VY:'||round(VY,5)||')(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')'
          ||'(vF:'||vF||')(DEM:'||v_dem||')(j.ID:'||j.ID||')');
          -----------------------
      END LOOP;

      /*Lấy thẩm phán có trọng số thấp nhất*/
      Select CANBOID into vThamphanID 
      from (Select CANBOID from GDTTT_PCTP_TMP Where TOAANID=vToaAnID Order by THUTU) where rownum=1;
      vThamphanID:=NVL(vThamphanID,0); 
      if(vThamphanID>0) Then
          Insert Into GDTTT_PCTP_CHITIET(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP)
          Values(vToaAnID,vKetQuaID,i.ID,vThamphanID,sysdate);
          Update GDTTT_DON Set THAMPHANID=vThamphanID Where ID=i.ID;
          ---------------------- 
         begin
             select NVL(VuViecID,0) into vVuAnID from GDTTT_Don where ID=i.ID and CD_TrangThai=2;          
               if (NVL(vVuAnID,0)>0) then 
                    Update GDTTT_VuAn set ThamPhanID = vThamphanID where ID = NVL(vVuAnID,0);            
                end if;     
           EXCEPTION 
             WHEN OTHERS  THEN dbms_output.put_line(SQLCODE);
            END; 
      End If;
     End If; 
     END LOOP;
     COMMIT;
   Return vKetQuaID;
  END PHANCONGNGAUNHIEN;
  

PROCEDURE DON_GETCHUAPCTP
( 
  vToaAnID in number,
  vTuNgay in date,
  vDenNgay in date,
  vNoiChuyen in number,
  vTrangthai in number,  
  vIsThuLy in number,
  vNguoiNhap in varchar2,
  varrLoaiAn in varchar2,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  Select d.ID,d.MADON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      case when d.NGUOISUA is null then d.NGUOITAO else d.NGUOISUA end as NguoiNhap,
      case when d.NGAYSUA is null then d.NGAYTAO else d.NGAYSUA end as NgayNhap,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_SO Else d.KN_SOQD END) BAQD
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_NGAYBA Else d.KN_NGAY END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

      ,d.CV_TENDONVI
      , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          end ) NOICHUYEN
      ,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,'' TENTHAMPHAN
      ,d.TL_SO,d.TL_NGAY
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID      
       left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
       left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
       left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
    where d.TOAANID=vToaAnID and d.LOAIDON <=3 and NVL(d.THAMPHANID,0)=0
       and (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vDenNgay then 1 else 0 end)
        Or ( 1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vDenNgay then 1 else 0 end))
       and d.CD_LOAI=0  and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
       and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
       and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
        Order by d.NGAYTAO desc;        
END DON_GETCHUAPCTP;

PROCEDURE DON_GETTHEOKETQUAID
( 
  vToaAnID in number,  
  vKetQuaID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
 vNgayThuly in varchar2,
  vSoThuly in varchar2,
vThamphanID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  Select * from (
  Select ROW_NUMBER() OVER (ORDER BY cast(NVL(d.TL_SO,'0') as number)) STT, k.ID,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,d.NGAYGHITRENDON,d.MADON, case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Select TENPHONGBAN from DM_PHONGBAN where ID=d.CD_TA_DONVIID) NOICHUYEN
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_SO Else d.KN_SOQD END) BAQD
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_NGAYBA Else d.KN_NGAY END) BAQD_NGAYBA

       ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 0 then  (Select MA_TEN from DM_TOAAN where ID=decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID))
      Else (Select TEN from DM_DATAITEM where ID=d.NGUOIKHANGNGHI)
      END) TOAXX

        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST
        ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,d.CV_TENDONVI,c1.HOTEN TENTHAMPHAN
      ,c2.HOTEN TENTHAMPHANSUA,d.NGUOIGUI_HUYENID
      ,d.NGUOIGUI_DIACHI || ' '  Diachigui,
      k.CANBOID,CANBOID_SUA,k.GHICHU
      ,d.TL_SO,d.TL_NGAY, d.CD_SOTOTRINH
      , decode(d.CD_NGAYTOTRINH,null,null,to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')) CD_NGAYTOTRINH
      , decode(k.NGAYPHANCONGTP,null,to_char(kq.NGAYPHANCONG,'dd/MM/yyyy'),to_char(k.NGAYPHANCONGTP,'dd/MM/yyyy')) NGAYPHANCONGTP
      ,GDTTT_PCTP_GetAll_BY_DON(K.DONID) PhanCongTP
      ,(select count(id) from gdttt_vuan where id = d.VUVIECID) CHECK_VUAN
  From GDTTT_PCTP_CHITIET k 
        Inner join GDTTT_DON d on k.DONID=d.ID
        left join GDTTT_PCTP_KETQUA kq on kq.id = k.KETQUAID
        left join DM_CANBO c1 on c1.ID=k.CANBOID
        left join DM_CANBO c2 on c2.ID=k.CANBOID_SUA
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
              WHere k.KETQUAID=vKetQuaID
                    and 1=case when vToaRaBAQD=0 then 1 when (d.BAQD_TOAANID=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD)
                                                    then 1 else 0 end        
                    and 1=case when vSoBAQD || ' '=' ' then 1 when ( lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
                    and 1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                    and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                    and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                    and  1=case when vNgayThuly || ' '=' ' then 1 when to_char(d.TL_NGAY,'dd/MM/yyyy')=vNgayThuly  then 1 else 0 end);  

END DON_GETTHEOKETQUAID;
PROCEDURE DON_LICHSUPHANCONG
( 
    vToaAnID in number,  
    vSoToTrinh in varchar2,
    vNgayToTrinh in varchar2,
    vPC_TuNgay in varchar2,
    vPC_DenNgay in varchar2,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vNgayThuly in varchar2,
    vSoThuly in varchar2,
    vThamphanID in number,  
	curReturn OUT sys_refcursor
) IS 
BEGIN

OPEN curReturn FOR  
  Select c.USERNAME,k.*
      ,c.HOTEN
      ,(Select Count(ID) from GDTTT_PCTP_CHITIET where KETQUAID=k.ID) SODON
      ,GDTTT_PCTP_CHECK_HUYPC(k.id) CHECK_VUAN
  From GDTTT_PCTP_KETQUA k left join 
          (Select nsd.ID,cb.HOTEN,nsd.USERNAME from QT_NGUOISUDUNG nsd inner join DM_CANBO cb on nsd.CANBOID=cb.ID ) c 
          on k.NGUOITHUCHIENID=c.ID
  where k.TOAANID=vToaAnID 
        and (vPC_TuNgay|| ' '=' '  Or  k.NGAYPHANCONG >= to_Date(vPC_TuNgay,'dd/MM/yyyy'))
        and (vPC_DenNgay|| ' '=' ' Or  k.NGAYPHANCONG <= to_Date(vPC_DenNgay,'dd/MM/yyyy'))
        and (vSoToTrinh || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where lower(d.CD_SOTOTRINH) like '%' || lower(vSoToTrinh) || '%' 
                                                    and ct.KETQUAID = k.id)  
            )
        and (vNgayToTrinh || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayToTrinh and ct.KETQUAID = k.id)  
            ) 

        and (vToaRaBAQD = 0 or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID 
                                            where (d.BAQD_TOAANID= vToaRaBAQD
                                                or d.BAQD_TOAANID_PT = vToaRaBAQD
                                                or d.BAQD_TOAANID_ST = vToaRaBAQD)
                                                and ct.KETQUAID = k.id)  
            )
        and (vSoBAQD || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID 
                                                 where (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%'
                                                    Or  lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                    Or  lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') 
                                                    and ct.KETQUAID = k.id)  
            )  
         and (vNgayBAQD || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID 
                                    where (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                                                    and ct.KETQUAID = k.id)  
            )  
        and (vNguoiGui || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' 
                                                    and ct.KETQUAID = k.id)  
            )
        and (vSoThuly || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' 
                                                    and ct.KETQUAID = k.id)  
            )
        and (vNgayThuly || ' '=' ' or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where to_char(d.TL_NGAY,'dd/MM/yyyy')=vNgayThuly and ct.KETQUAID = k.id)  
            )  
        and (vThamphanID=0 or EXISTS(select 'X' From GDTTT_PCTP_CHITIET ct 
                    Inner join GDTTT_DON d on ct.DONID=d.ID where d.THAMPHANID=vThamphanID and ct.KETQUAID = k.id)  
            )
  Order by k.NGAYPHANCONG desc;
END DON_LICHSUPHANCONG;
PROCEDURE DON_CHECKDONTRUNG 
(
  vToaXetXu IN VARCHAR2,
  vNgayXetXu IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNguoiGui IN VARCHAR2,
  vIsBanAn IN VARCHAR2,
  curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select a.ID,a.MADON,a.NGAYNHANDON,a.NGUOIGUI_HOTEN,
        case a.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc,
        case when a.BAQD_SO is null then a.KN_SOQD else a.BAQD_SO end as SOBAQD,
        case when a.BAQD_SO is null then a.KN_NGAY else a.BAQD_NGAYBA end as SOBAQD
  from GDTTT_DON a
  where   (vNguoiGui || ' '=' ' OR lower(a.NGUOIGUI_HOTEN)=lower(vNguoiGui))
        AND ((vIsBanAn='1' and (vSoBAQD || ' '=' ' OR lower(a.KN_SOQD)=lower(vSoBAQD))
                          and (vNgayXetXu || ' '=' ' OR to_char(a.KN_NGAY,'dd/MM/yyyy')=vNgayXetXu)
                          and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID)=vToaXetXu))
            OR (vIsBanAn='0' 
                and( ((vSoBAQD || ' '=' ' OR (a.BAQD_SO = lower(vSoBAQD))) 
                        and (vNgayXetXu || ' '=' ' OR to_char(a.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayXetXu)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID)=vToaXetXu))
                    OR ((vSoBAQD || ' '=' ' OR (a.BAQD_SO_PT = lower(vSoBAQD))) 
                        and (vNgayXetXu || ' '=' ' OR to_char(a.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayXetXu)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID_PT)=vToaXetXu))
                    OR ((vSoBAQD || ' '=' ' OR (a.BAQD_SO_ST = lower(vSoBAQD)))
                        and (vNgayXetXu || ' '=' ' OR to_char(a.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayXetXu)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID_ST)=vToaXetXu))
                    )
                )
            )
--      and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID)=vToaXetXu)
--      and (vNgayXetXu || ' '=' ' OR to_char(a.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayXetXu)
--      and (vSoBAQD || ' '=' ' OR (a.BAQD_SO = lower(vSoBAQD) and vIsBanAn='0') 
--                            OR (lower(a.KN_SOQD)=lower(vSoBAQD) and vIsBanAn='1') )
  ;
END DON_CHECKDONTRUNG;
PROCEDURE DON_SEARCH
( 
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vCD_TA_TRANGTHAI in number,
  vCD_TENDONVI in varchar2,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vChidao in number,
  vTraigiam in number,
  vTBQuahan in number,
  vNgayQuahan in date,
  vThamphanID in number,
  vThamtravienID in number,
  vLoaiCVID in number,
  vNgayNhapTu in date,
  vNgayNhapDen in date,
  vIsDonGoc in number,
  vIsTuHinh in number,
  vLoaiAn in number,
    vCVPC_So in varchar2,
  vCVPC_Ngay in varchar2,
  vCVPC_TenCQ in varchar2,
  vGuitoiCA_TA in number,
  PageIndex	in	int,
  PageSize	in	int,
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
If vIsDonGoc=0 then    
    Select Count(d.ID)into TotalItem 
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on c.ID=d.THAMPHANID
    where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1 when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1 Else 0 End)
          And 1=(Case when vIsThuLy=-1 then 1 
              when vIsThuLy=1  and d.ISTHULY=1  then 1 
              when vIsThuLy=2 and d.ISTHULY=2 then 1 
              when vIsThuLy=3 and d.ISTHULY=3 then 1 
               when (vIsThuLy=4 and ((d.ISTHULY=1 and NVL(d.DONTRUNGID,0)=0 )or d.ISTHULY=3)) then 1 
              Else 0 End)       
              and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end        
       and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
        and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and
        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
         and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        and  1=case when vTrangthai=-1 then 1 
              when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 
              when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when vNoiChuyen=-1 then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
             when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1
            else 0 end)   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end

        and  1=case when vNgayThulyTu is null then 1 
                    when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1
                   when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end

        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
            and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
               and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                     and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                     when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
         and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
        and 1=case when vPhanloaixuly=0 then 1 
        when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
        And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end;

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
  ,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

  ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn'
                     when 2 then 'Công văn' 
                     when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else d.BAQD_NGAYBA END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX

      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat

       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID

      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
      ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                   and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and cv.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                     when (cv.LOAICONGVAN=vLoaiCVID Or cv.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
         ) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
           , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then ''
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
    from GDTTT_DON d
      left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
          And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end
        and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
--        and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end        
        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )    
        and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
         and
         1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
       and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and

        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when vNoiChuyen=-1 then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)      
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
        and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
        and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                  and 1=case when vLoaiCVID=0 then 1 
                   when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                  when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                  And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
Else--Lọc theo tìm kiếm đơn gốc
--Tính tỏng số đơn
 Select Count(g.ID)into TotalItem 
 From (Select MAX(ID) ID from 
  (select d.ID,(Case NVL(d.DONTRUNGID,0) when 0 then ID else d.DONTRUNGID END) DTID 
  from GDTTT_DON d 
  where d.TOAANID=vToaAnID 
          And 1=(Case when vIsThuLy=-1 then 1 
              when vIsThuLy=1  and d.ISTHULY=1  then 1 
              when vIsThuLy=2 and d.ISTHULY=2 then 1 
              when vIsThuLy=3 and d.ISTHULY=3 then 1 
               when (vIsThuLy=4 and ((d.ISTHULY=1 and NVL(d.DONTRUNGID,0)=0 )or d.ISTHULY=3)) then 1 
              Else 0 End)       
        and 
        1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end       
        and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
--       and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )   
        
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end  
         and
       1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
        and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and
        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
         and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        and  1=case when vTrangthai=-1 then 1 
              when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 
              when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when vNoiChuyen=-1 then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
             when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1
            else 0 end)   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
            and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
               and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                     and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                     when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
         and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
        and 1=case when vPhanloaixuly=0 then 1 
        when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
  order by d.NGAYTAO desc
  ) GROUP BY DTID) g;
--Lấy danh sách đơn
 OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else d.BAQD_NGAYBA END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID
      ,(Case vIsThuLy when 1  then
          (1+(Select Count(t.ID) from GDTTT_DON t where t.ISTHULY<>1 and  (t.DONTRUNGID=d.ID  or t.DONTRUNGID=d.ID Or ( t.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID or ID=d.DonTrungID) And d.DontrungID>0)))
                  and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                ))      
         Else g.SODONTRUNG End) SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

         ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and cv.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                     when (cv.LOAICONGVAN=vLoaiCVID Or cv.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
         ) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                   and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end

         ) arrDonID
        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết', 2, u'X\1ebfp \0111\01a1n'  
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                                          )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end   
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
    from GDTTT_DON d
     left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV from GDTTT_VuAn) va on va.ID = d.VuViecID

    inner join
    (
    (Select Count(ID) SODONTRUNG,MAX(ID) ID from 
  (select dtk.ID,(Case NVL(dtk.DONTRUNGID,0) when 0 then ID else dtk.DONTRUNGID END) DTID
  from GDTTT_DON dtk 
  where dtk.TOAANID=vToaAnID-- and 1=(Case when vIsDonGoc=0 then 1 when vIsDonGoc=1 And NVL(dtk.DONTRUNGID,0)=0 then 1 Else 0 End)
          And 1=(Case when vIsThuLy=-1 then 1 
              when vIsThuLy=1  and dtk.ISTHULY=1  then 1 
              when vIsThuLy=2 and dtk.ISTHULY=2 then 1 
              when vIsThuLy=3 and dtk.ISTHULY=3 then 1 
               when (vIsThuLy=4 and ((dtk.ISTHULY=1 and NVL(dtk.DONTRUNGID,0)=0 )or dtk.ISTHULY=3)) then 1 
              Else 0 End)       
        and 
        1=case when vToaRaBAQD=0 then 1 when dtk.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end  
        and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
       and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(dtk.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(dtk.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(dtk.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when dtk.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= dtk.NGAYNHANDON then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when dtk.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when dtk.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when (dtk.MADON =vSoHieuDon Or dtk.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when dtk.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when dtk.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(dtk.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        1=case when vSoCongVan || ' '=' ' then 1 when ((lower(dtk.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(dtk.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(dtk.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(dtk.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(dtk.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(dtk.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
       and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(dtk.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(dtk.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and
        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(dtk.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when dtk.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(dtk.nguoitao)|| ',%') then 1 else 0 end
         and 1=case when vNoiChuyen=-1 then 1 when dtk.CD_LOAI=vNoiChuyen then 1 else 0 end
        and  1=case when vTrangthai=-1 then 1 
              when vTrangthai=1 and   dtk.CD_TRANGTHAI in (1,2) then 1 
              when dtk.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when vNoiChuyen=-1 then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
             when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And dtk.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(dtk.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and dtk.CD_LOAI=vNoiChuyen) then 1
            else 0 end)   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dtk.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dtk.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= dtk.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when dtk.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(dtk.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(dtk.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(dtk.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and dtk.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(dtk.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
            and 1=case when vTBQuahan=0 then 1 when dtk.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
               and 1=case when vThamphanID=0 then 1 when dtk.THAMPHANID=vThamphanID then 1 else 0 end
                 and 1=case when vThamtravienID=0 then 1 when dtk.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                     and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and dtk.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                     when (dtk.LOAICONGVAN=vLoaiCVID Or dtk.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
         and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.NGAYTAO then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when dtk.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.TL_NGAY then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when dtk.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
        and 1=case when vPhanloaixuly=0 then 1 when dtk.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(dtk.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(dtk.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and dtk.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and dtk.CD_TK_NOIGUI=1 then 1 else 0 end
  order by dtk.NGAYTAO desc
  ) GROUP BY DTID)
    ) g on g.ID=d.ID
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
End if;

END DON_SEARCH;
PROCEDURE DON_NHAN_SEARCH
( 
  vToaAnID in number,
  vToaChuyenID in number,
  vLoaiAn in number,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vMaDon in varchar2,  
  vSoCongVan in varchar2,  
  vTrangthai in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
    IF vTrangthai = 3 THEN
         OPEN curReturn FOR
          Select dc.ID,d.MADON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,      
              case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
              ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
              ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
              ,d.CV_TENDONVI,BAQD_NGAYBA,d.CV_NGAY,d.CV_DIACHI CVDIACHI
              ,dc.NGAYCHUYEN,dc.NGAYNHAN,dc.SOCV,dc.TENTOACHUYEN
              ,(Case dc.TRANGTHAI when 1 then 'Chưa nhận' when 2 then 'Đã nhận' when 3 then 'Trả lại do ' Else '' End) ||dc.GHICHU||'<br/>' TENTRANGTHAI
            from GDTTT_DON d
              inner join (Select gdc.ID,gdc.DONID,gdc.DONVICHUYENID,gdc.DONVINHANID,gdc.NGAYCHUYEN,
                            gdc.NGAYNHAN,gdc.TRANGTHAI,gdc.SOCV,gdc.LOAICHUYEN,gtk.MA_TEN TENTOACHUYEN,gdc.GHICHU
                            From GDTTT_DON_CHUYEN_HISTORY gdc inner join DM_TOAAN gtk on gdc.DONVICHUYENID=gtk.ID
                            WHere 1=(Case When vToaChuyenID=0 then 1 When gdc.DONVICHUYENID=vToaChuyenID then 1 Else 0 End)
                                and
                                1=case when vTuNgay is null then 1 when vTuNgay <= gdc.NGAYCHUYEN then 1 else 0 end
                                and
                                1=case when vDenNgay is null then 1 when gdc.NGAYCHUYEN <= vDenNgay then 1 else 0 end            
                                And gdc.DONVINHANID=vToaAnID 
                                and gdc.LOAICHUYEN=1
                                and gdc.TRANGTHAI=vTrangthai
                                ) dc on dc.DONID=d.ID
              left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
              left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID        
            where  d.LOAIDON <=3 and 1=(Case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 Else 0 End)
                and 
                (1=case when vNguoiGui || ' '=' ' then 1 when lower(d.NGUOIGUI_HOTEN) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                  Or 1=case when vNguoiGui || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end)
                and
                1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end        
                and
                1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and
                1=case when vMaDon || ' '=' ' then 1 when d.MADON =vMaDon  then 1 else 0 end               
                and
                1=case when vSoCongVan || ' '=' ' then 1 when lower(dc.SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
        
                Order by dc.NGAYCHUYEN desc;
    ELSE

      OPEN curReturn FOR
          Select dc.ID,d.MADON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,      
              case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
              ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
              ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
              ,d.CV_TENDONVI,BAQD_NGAYBA,d.CV_NGAY,d.CV_DIACHI CVDIACHI
              ,dc.NGAYCHUYEN,dc.NGAYNHAN,dc.SOCV,dc.TENTOACHUYEN
              ,(Case dc.TRANGTHAI when 1 then 'Chưa nhận' when 2 then 'Đã nhận' when 3 then 'Trả lại' Else '' End) TENTRANGTHAI
            from GDTTT_DON d
              inner join (Select gdc.ID,gdc.DONID,gdc.DONVICHUYENID,gdc.DONVINHANID,gdc.NGAYCHUYEN,
                            gdc.NGAYNHAN,gdc.TRANGTHAI,gdc.SOCV,gdc.LOAICHUYEN,gtk.MA_TEN TENTOACHUYEN
                            From GDTTT_DON_CHUYEN gdc inner join DM_TOAAN gtk on gdc.DONVICHUYENID=gtk.ID
                            WHere 1=(Case When vToaChuyenID=0 then 1 When gdc.DONVICHUYENID=vToaChuyenID then 1 Else 0 End)
                                and
                                1=case when vTuNgay is null then 1 when vTuNgay <= gdc.NGAYCHUYEN then 1 else 0 end
                                and
                                1=case when vDenNgay is null then 1 when gdc.NGAYCHUYEN <= vDenNgay then 1 else 0 end            
                                And gdc.DONVINHANID=vToaAnID 
                                and gdc.LOAICHUYEN=1
                                and gdc.TRANGTHAI=vTrangthai
                                ) dc on dc.DONID=d.ID
              left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
              left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID        
            where  d.LOAIDON <=3 and 1=(Case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 Else 0 End)
                and 
                (1=case when vNguoiGui || ' '=' ' then 1 when lower(d.NGUOIGUI_HOTEN) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                  Or 1=case when vNguoiGui || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end)
                and
                1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end        
                and
                1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and
                1=case when vMaDon || ' '=' ' then 1 when d.MADON =vMaDon  then 1 else 0 end               
                and
                1=case when vSoCongVan || ' '=' ' then 1 when lower(dc.SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
        
                Order by dc.NGAYCHUYEN desc;
     END IF;   

END DON_NHAN_SEARCH;
PROCEDURE LICHSUDON
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select gdc.NGAYCHUYEN,gdc.NGAYNHAN,gdc.TRANGTHAI,gdc.SOCV,gdc.LOAICHUYEN
                  ,(Case gdc.TRANGTHAI when 0 then 'Chưa chuyển' when 1 then 'Chuyển  nhận' when 2 then 'Đã nhận' when 3 then 'Trả lại' Else '' End) TENTRANGTHAI
                  ,tc.MA_TEN TENTOACHUYEN,tn.MA_TEN TENTOANHAN
                  ,ptc.TENPHONGBAN PHONGBANCHUYEN
                  ,ptn.TENPHONGBAN PHONGBANNHAN
                    From GDTTT_DON_CHUYEN gdc 
                    inner join DM_TOAAN tc on gdc.DONVICHUYENID=tc.ID
                    inner join DM_TOAAN tn on gdc.DONVINHANID=tn.ID
                    left join DM_PHONGBAN ptc on ptc.ID=gdc.PHONGBANCHUYENID
                    left join DM_PHONGBAN ptn on ptn.ID=gdc.PHONGBANNHANID
                    WHere gdc.DONID=vID order by gdc.NGAYCHUYEN desc;

END LICHSUDON;
PROCEDURE CONGVAN_SEARCH
( 
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2, 
  vTuNgay in date,
  vDenNgay in date,  
  vSoHieuDon in varchar2, 
  vDonViGui in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vLoaiVuviec in varchar2,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  Select d.ID,d.MADON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,
      case when d.NGUOISUA is null then d.NGUOITAO else d.NGUOISUA end as NguoiNhap,
      case when d.NGAYSUA is null then d.NGAYTAO else d.NGAYSUA end as NgayNhap,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' when 4 then 'Công văn' end as HinhThuc
      ,h.MA_TEN Diachigui,d.CV_SO,d.CV_NGAY
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,d.CV_TENDONVI
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
    where d.LOAIDON =4
       and 
        1=case when vLoaiVuviec=0 then 1 when d.BAQD_LOAIAN=vLoaiVuviec then 1 else 0 end
        and 
        1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end
        and
        1=case when vSoBAQD || ' '=' ' then 1 when lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' then 1 else 0 end         
        and
          1=case when vNgayBAQD || ' '=' ' then 1 when to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD then 1 else 0 end 
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end       
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when lower(d.SOHIEUDON) like '%' || lower(vSoHieuDon) || '%' then 1 else 0 end       
        and
        1=case when vDonViGui || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vDonViGui) || '%' then 1 else 0 end
        and
        1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when lower(d.nguoitao) = lower(vNguoiNhap) then 1 else 0 end;

END CONGVAN_SEARCH;
PROCEDURE DON_GETMAXTT
( vdonviID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select NVL(MAX(d.TT),0)
  From GDTTT_DON d 
  Where d.TOAANID=vdonviID; 
END DON_GETMAXTT;
PROCEDURE DON_UPDATESOLUONGDON
( vDonID in number,
	curReturn    OUT       sys_refcursor
)
IS 
vDonTrungID number;
BEGIN 
      Update GDTTT_DON Set SOLUONGDON=(Select Count(ID) from GDTTT_DON 
                              where ID=vDonID Or DONTRUNGID=vDonID )
      Where ID=vDonID;
      OPEN curReturn FOR  Select 1 from dual;
END DON_UPDATESOLUONGDON;
PROCEDURE DON_TL_GETMAXTT
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
	curReturn    OUT       sys_refcursor
)
IS 
vY number;
BEGIN
vY:=vYear;
--if(to_char(SYSDATE,'mm')='12') then
-- vY:=vY+1;
-- end if;
OPEN curReturn FOR  
    select Max(to_number(tt.TL_SO))TL_SO from (
    select TL_SO from gdttt_don d
      Where d.TOAANID=vdonviID 
        And d.isthuly = 1
        and d.BAQD_LOAIAN=vLoaiAn  and trim(d.TL_SO) is not null 
        and d.TL_NGAY between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
--        and d.TL_NGAY between TO_DATE(Cast((vY-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-11-30','YYYY-MM-DD')
        
    )tt;
END DON_TL_GETMAXTT;
PROCEDURE DON_TL_CHECK
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
  vTL_SO IN VARCHAR2,
    vDonID in number,
	curReturn    OUT       sys_refcursor
)
IS 
vY number;
BEGIN
vY:=vYear;
--if(to_char(SYSDATE,'mm')='12') then
-- vY:=vY+1;
-- end if;
OPEN curReturn FOR  
  Select d.ID
  From GDTTT_DON d 
  Where 1= case  when vDonID=0 then 1 
                 when d.ID=vDonID then  0 
                 else 1 End
        And d.isthuly = 1
        And d.TOAANID=vdonviID and d.BAQD_LOAIAN=vLoaiAn and d.TL_SO=vTL_SO 
        and d.TL_NGAY between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD');
--  and d.TL_NGAY between TO_DATE(Cast((vY-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-11-30','YYYY-MM-DD'); 
END DON_TL_CHECK;


PROCEDURE DON_CV_GETMAXTT
(   vdonviID in number,
    vYear in number,
    vNoiChuyen in number,
    vTrangthaidon in number,
	curReturn    OUT       sys_refcursor
)
IS 
vY number;
BEGIN
vY:=vYear;
--if(to_char(SYSDATE,'mm')='12') then
-- vY:=vY+1;
-- end if;
OPEN curReturn FOR  
    select Max(to_number(tt.CD_SOCV)) CD_SOCV from (
    select CD_SOCV from gdttt_don d
      Where d.TOAANID=vdonviID 
--        and d.CD_LOAI=vNoiChuyen  
        And 1=case  when vNoiChuyen = 0 and d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI != 1 and vTrangthaidon = 0 then 1 
                    when vNoiChuyen != 0 and (d.CD_LOAI != 0 
                                                Or (d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI = 1)) then 1 
                    when vNoiChuyen = 0 and vTrangthaidon = 1 and ((d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI = 1) Or d.CD_LOAI != 0) then 1 end
        and trim(d.CD_SOCV) is not null 
        and d.CD_NGAYCV between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
    )tt;
END DON_CV_GETMAXTT;

PROCEDURE DON_CV_CHECK
(   vdonviID in number,
    vNoiChuyen in number,
    vTrangthaidon in number,
    vSO_CV in number,
    vYear in number,
	curReturn    OUT       sys_refcursor
)
IS 
vY number;
BEGIN
vY:=vYear;
--if(to_char(SYSDATE,'mm')='12') then
-- vY:=vY+1;
-- end if;
OPEN curReturn FOR  
  Select d.ID
  From GDTTT_DON d 
  Where 
  d.TOAANID=vdonviID 
--  And 1=case when vNoiChuyen = 0 
--                        and d.CD_LOAI=0 
--                        and d.CD_TA_TRANGTHAI != 1
--                then 1 
--             when (vNoiChuyen != 0 and d.CD_LOAI!=0) 
--                Or (vNoiChuyen = 0 and d.CD_LOAI=0 and d.CD_TA_TRANGTHAI = 1) then 1 end
  And 1=case  when vNoiChuyen = 0 and d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI != 1 and vTrangthaidon = 0 then 1 
                    when vNoiChuyen != 0 and (d.CD_LOAI != 0 
                                                Or (d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI = 1)) then 1 
                    when vNoiChuyen = 0 and vTrangthaidon = 1 and ((d.CD_LOAI = 0 and d.CD_TA_TRANGTHAI = 1) Or d.CD_LOAI != 0) then 1 end              
  and d.CD_SOCV=vSO_CV 
  and d.CD_NGAYCV between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD');
--  and d.TL_NGAY between TO_DATE(Cast((vY-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-11-30','YYYY-MM-DD'); 
END DON_CV_CHECK;


PROCEDURE DON_GETDONTRUNG 
(
  vCurrDonID in number,
  vNguoiGui IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNgayBAQD IN VARCHAR2,
  vToaXetXu IN VARCHAR2,
  curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select a.ID,a.SOHIEUDON,a.NGAYNHANDON,a.NGUOIGUI_HOTEN,t.MA_TEN TOAXETXU,g.MA_TEN TOAGDTTT,
        case when a.BAQD_SO is null then a.KN_SOQD else a.BAQD_SO end as SOBAQD,
        case when a.BAQD_SO is null then a.KN_NGAY else a.BAQD_NGAYBA end as NGAYBAQD
        ,a.NGUOIGUI_DIACHI ||(case when (a.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui
        ,a.Nguoitao,a.Ngaytao
  from GDTTT_DON a
  inner join DM_TOAAN g on g.ID=a.TOAANID
  left join DM_TOAAN t on t.ID=decode(a.BAQD_CAPXETXU,2,a.BAQD_TOAANID_ST,3,a.BAQD_TOAANID_PT,a.BAQD_TOAANID)
   left join DM_HANHCHINH h on a.NGUOIGUI_HUYENID=h.ID
  where 
        1=(Case when vCurrDonID=0 then 1 when a.ID=vCurrDonID then 0 else 1 End)      
      And NVL(a.DONTRUNGID,0)=0
      and (vNguoiGui || ' '=' ' OR lower(a.NGUOIGUI_HOTEN)=lower(vNguoiGui))
        AND ( ( (vSoBAQD || ' '=' ' OR lower(a.KN_SOQD)=lower(vSoBAQD))
                          and (vNgayBAQD || ' '=' ' OR to_char(a.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD)
                          and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID)=vToaXetXu))
            OR (
                ( ((vSoBAQD || ' '=' ' OR (lower(a.BAQD_SO) = lower(vSoBAQD))) 
                        and (vNgayBAQD || ' '=' ' OR to_char(a.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID)=vToaXetXu))
                    OR ((vSoBAQD || ' '=' ' OR (lower(a.BAQD_SO_PT) = lower(vSoBAQD))) 
                        and (vNgayBAQD || ' '=' ' OR to_char(a.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID_PT)=vToaXetXu))
                    OR ((vSoBAQD || ' '=' ' OR (lower(a.BAQD_SO_ST) = lower(vSoBAQD)))
                        and (vNgayBAQD || ' '=' ' OR to_char(a.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD)
                        and (vToaXetXu || ' '=' ' OR vToaXetXu='0' OR  to_char(a.BAQD_TOAANID_ST)=vToaXetXu))
                    )
                )
            )

--      and
--      1=case when vNguoiGui || ' '=' ' then 1 when lower(a.NGUOIGUI_HOTEN)=lower(vNguoiGui) then 1 else 0 end
--      And 1=case when vToaXetXu || ' '=' ' or vToaXetXu='0' then 1 when a.BAQD_TOAANID || ''=vToaXetXu then 1 else 0 end
--      and 1=case when vSoBAQD || ' '=' ' then 1 when lower(a.BAQD_SO) like '%' || lower(vSoBAQD) || '%'  then 1 else 0 end 
--      And 1=case when vNgayBAQD || ' '=' ' then 1 when to_char(a.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD then 1 else 0 end            
  Order by a.Ngaytao desc;
END DON_GETDONTRUNG;
PROCEDURE DON_GETCONGVAN 
(
  vTenDonVi IN VARCHAR2,
  vToaAn IN VARCHAR2,
  vSoCongVan IN VARCHAR2,
  vNgayCongVan IN VARCHAR2,
  vIsDVTrongNganh IN NUMBER,
  curReturn OUT sys_refcursor
) AS 
BEGIN
  OPEN curReturn FOR
  select a.ID,a.MADON,a.NGAYNHANDON,a.NGUOIGUI_HOTEN,
        case a.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc,
        a.CV_SO,a.CV_NGAY
  from GDTTT_DON a
  left join DM_TOAAN toa on a.CV_TOAANID=toa.ID
  where 
      1=case when vSoCongVan || ' '=' ' then 1 when lower(a.CV_SO) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
      and
      1=case when vNgayCongVan || ' '=' ' then 1 when to_char(a.CV_NGAY,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
      and
      1=case when vTenDonVi || ' '=' ' then 1 when vIsDVTrongNganh=0 and lower(a.CV_TENDONVI) like '%' || lower(vTenDonVi) || '%' then 1 else 0 end
      and
      1=case when vToaAn || ' '=' ' or vToaAn='0' then 1 when vIsDVTrongNganh=1 and a.CV_TOAANID || ''=vToaAn then 1 else 0 end
      and a.LOAIDON=3
  ;
END DON_GETCONGVAN;

PROCEDURE DON_SUA_SEARCH
( 
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vCD_TA_TRANGTHAI in number,
  vCD_TENDONVI in varchar2,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vChidao in number,
  vTraigiam in number,  
  vTBQuahan in number,
  vThamphanID in number,
  vThamtravienID in number,
  vLoaiCVID in number,
  vNgayNhapTu in date,
  vNgayNhapDen in date,
  vIsDonGoc in number,  
  vIsTuHinh in number,
  vLoaiAn in number,
    vCVPC_So in varchar2,
  vCVPC_Ngay in varchar2,
  vCVPC_TenCQ in varchar2,
  vGuitoiCA_TA in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
 If vIsDonGoc=0 then    

  OPEN curReturn FOR  
  Select d.ID,d.MADON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,d.BAQD_LOAIQDBA,CV_SO,CV_NGAY,CV_TENDONVI
         --,d.BAQD_SO,BAQD_NGAYBA,d.BAQD_TOAANID
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_SO,3,d.BAQD_SO_PT,2,d.BAQD_SO_ST,d.BAQD_SO) BAQD_SO
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA) BAQD_NGAYBA
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID) BAQD_TOAANID
     
     ,d.GHICHU,TL_NGAY,TL_SO,NGUOIGUI_TINHID,NGUOIGUI_HUYENID,NGUOIGUI_DIACHI
     ,d.CD_TK_DONVIID,d.CD_NTA_TENDONVI
      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                  
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SOLUONGDON  
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
          And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end
        and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
--        and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end        
         and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             ) 
        and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and 1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
        and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and
        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when vNoiChuyen=-1 then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)      
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end

        and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
        and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                  and 1=case when vLoaiCVID=0 then 1 
                   when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                  when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                  And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
       Order by CASE WHEN d.TL_SO IS NOT NULL THEN TO_NUMBER(d.TL_SO) END;
Else--Lọc theo tìm kiếm đơn gốc
--Tính tỏng số đơn

 OPEN curReturn FOR

  Select d.ID,d.MADON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,d.BAQD_LOAIQDBA,CV_SO,CV_NGAY,CV_TENDONVI
        --,d.BAQD_SO,BAQD_NGAYBA,d.BAQD_TOAANID
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_SO,3,d.BAQD_SO_PT,2,d.BAQD_SO_ST,d.BAQD_SO) BAQD_SO
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,2,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA) BAQD_NGAYBA
     ,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID) BAQD_TOAANID
     ,d.GHICHU,TL_NGAY,TL_SO,NGUOIGUI_TINHID,NGUOIGUI_HUYENID,NGUOIGUI_DIACHI
     ,d.CD_TK_DONVIID,d.CD_NTA_TENDONVI
      ,(Case vIsThuLy when 1  then
          (1+(Select Count(t.ID) from GDTTT_DON t where t.ISTHULY<>1 and  (t.DONTRUNGID=d.ID  or t.DONTRUNGID=d.ID Or ( t.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID or ID=d.DonTrungID) And d.DontrungID>0)))
                  and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                ))      
         Else g.SODONTRUNG End) SOLUONGDON  

    from GDTTT_DON d
    inner join 
    (SELECT TT.SODONTRUNG,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',') ID 
                FROM (   
                      Select Count(*) SODONTRUNG,DD.DTID,
                            LISTAGG (DD.ID, ',') WITHIN GROUP (ORDER BY CASE WHEN DD.visthuly=1 THEN DD.ID END 
                            ,CASE WHEN DD.visthuly!=1 THEN DD.ID END DESC)||','ID
                            from (select dtk.ID
                                        ,DECODE(dtk.DONTRUNGID,NULL,dtk.ID,0,dtk.ID,dtk.DONTRUNGID)DTID
                                        ,DECODE(dtk.isthuly,NULL,0,dtk.isthuly) visthuly 
                                  from GDTTT_DON dtk 
                                  where dtk.TOAANID=vToaAnID-- and 1=(Case when vIsDonGoc=0 then 1 when vIsDonGoc=1 And NVL(dtk.DONTRUNGID,0)=0 then 1 Else 0 End)
                                          And 1=(Case when vIsThuLy=-1 then 1 
                                              when vIsThuLy=1  and dtk.ISTHULY=1  then 1 
                                              when vIsThuLy=2 and dtk.ISTHULY=2 then 1 
                                              when vIsThuLy=3 and dtk.ISTHULY=3 then 1 
                                               when (vIsThuLy=4 and ((dtk.ISTHULY=1 and NVL(dtk.DONTRUNGID,0)=0 )or dtk.ISTHULY=3)) then 1 
                                              Else 0 End)       
                                        and 
                                        1=case when vToaRaBAQD=0 then 1 when dtk.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end  
                                        and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end        
--                                       and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(dtk.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(dtk.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--                                        and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
                                          and (  ((vSoBAQD || ' '=' '  Or lower(dtk.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                                                              And (vNgayBAQD || ' '=' ' Or  to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                                                            )
                                                            Or((vSoBAQD || ' '=' ' Or lower(dtk.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                                                And (vNgayBAQD || ' '=' ' Or to_char(dtk.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                                                            )
                                                            Or ((vSoBAQD || ' '=' ' Or lower(dtk.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                                                And (vNgayBAQD || ' '=' ' Or to_char(dtk.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                                                            )
                                                            Or ((vSoBAQD || ' '=' ' Or lower(dtk.KN_SOQD) like  lower(vSoBAQD) || '%')
                                                                And (vNgayBAQD || ' '=' ' Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                                                            )
                                                         )
                                           
                                        and
                                        1=case when vNguoiGui || ' '=' ' then 1 when lower(dtk.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                                        and
                                        1=case when vSoCMND || ' '=' ' then 1 when dtk.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                                        and
                                        1=case when vTuNgay is null then 1 when vTuNgay <= dtk.NGAYNHANDON then 1 else 0 end
                                        and
                                        1=case when vDenNgay is null then 1 when dtk.NGAYNHANDON <= vDenNgay then 1 else 0 end
                                        and
                                        1=case when vHinhThucDon=0 then 1 when dtk.LOAIDON=vHinhThucDon then 1 else 0 end
                                        and
                                        1=case when vSoHieuDon || ' '=' ' then 1 when (dtk.MADON =vSoHieuDon Or dtk.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                                        and
                                        1=case when vDiaChiTinh=0 then 1 when dtk.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                                        and
                                        1=case when vDiaChiHuyen=0 then 1 when dtk.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                                        and
                                        1=case when vDiaChiCT || ' '=' ' then 1 when lower(dtk.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
                                        and
                                        1=case when vSoCongVan || ' '=' ' then 1 when lower(dtk.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
                                        and
                                        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(dtk.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
                                         and
                                        1=case when vCVPC_So || ' '=' ' then 1 when lower(dtk.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                                        and
                                        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(dtk.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                                         and
                                        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(dtk.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                                        and
                                        1=case when vTraLoi=0 then 1 when dtk.TRALOIDON=vTraLoi then 1 else 0 end
                                        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(dtk.nguoitao)|| ',%') then 1 else 0 end
                                         and 1=case when vNoiChuyen=-1 then 1 when dtk.CD_LOAI=vNoiChuyen then 1 else 0 end
                                        and  1=case when vTrangthai=-1 then 1 
                                              when vTrangthai=1 and   dtk.CD_TRANGTHAI in (1,2) then 1 
                                              when dtk.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                                        and  (1=case when vNoiChuyen=-1 then 1 
                                            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
                                             when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TK_DONVIID=vCD_DONVIID) Or
                                                                    (vCD_DONVIID=-1 And dtk.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                                            when (vNoiChuyen=2 and lower(dtk.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                                           when (vNoiChuyen>2 and dtk.CD_LOAI=vNoiChuyen) then 1
                                            else 0 end)   
                                        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dtk.CD_NGAYXULY then 1 else 0 end
                                        and 1=case when vNgaychuyenDen is null then 1 when dtk.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
                                        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= dtk.TL_NGAY then 1 else 0 end
                                        and 1=case when vNgayThulyDen is null then 1 when dtk.TL_NGAY <= vNgayThulyDen then 1 else 0 end
                                        and 1=case when vSoThuly || ' '=' ' then 1 when lower(dtk.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                                        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(dtk.ID as varchar2(10)) || ',%' then 1 else 0 end
                                        and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(dtk.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and dtk.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
                                          and 1=case when vTraigiam=-1 then 1 when NVL(dtk.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end

                                               and 1=case when vThamphanID=0 then 1 when dtk.THAMPHANID=vThamphanID then 1 else 0 end
                                                 and 1=case when vThamtravienID=0 then 1 when dtk.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                                                     and 1=case when vLoaiCVID=0 then 1 
                                                     when vLoaiCVID=-1 and dtk.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                                                     when (dtk.LOAICONGVAN=vLoaiCVID Or dtk.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                                         and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.NGAYTAO then 1 else 0 end
                                        and 1=case when vNgayNhapDen is null then 1 when dtk.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                                        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.TL_NGAY then 1 else 0 end
                                        and 1=case when vNgayNhapDen is null then 1 when dtk.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                                        and 1=case when vPhanloaixuly=0 then 1 when dtk.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
                                        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(dtk.ISANTUHINH,0)=0 then 1 
                                                 when vIsTuHinh=2 and NVL(dtk.ISANTUHINH,0)=1 then 1
                                                 when vIsTuHinh=3 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_ANGIAM,0)=1 then 1
                                                 when vIsTuHinh=4 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_KEUOAN,0)=1 then 1  else 0 end
                                                 And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and dtk.CD_TK_NOIGUI=0 then 1
                                                      when vGuitoiCA_TA=1 and dtk.CD_TK_NOIGUI=1 then 1 else 0 end
--                                  order by CASE WHEN dtk.TL_SO IS NOT NULL THEN TO_NUMBER(dtk.TL_SO) END
--                                  ) GROUP BY DTID)
                                        order by isthuly asc,dtk.NGAYTAO desc 
                            ) DD  GROUP BY DD.DTID
                    ) TT 
    ) g on g.ID=d.ID
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    Order by CASE WHEN d.TL_SO IS NOT NULL THEN TO_NUMBER(d.TL_SO) END;

End if;  
END DON_SUA_SEARCH;



PROCEDURE DON_GIAIQUYET_SEARCH
( 
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vSoCMND in varchar2,
  vTuNgay in date,
  vDenNgay in date,
  vHinhThucDon in number,
  vSoHieuDon in varchar2,
  vDiaChiTinh in number,
  vDiaChiHuyen in number,
  vDiaChiCT in varchar2,
  vSoCongVan in varchar2,
  vNgayCongVan in varchar2,
  vTraLoi in number,
  vNguoiNhap in varchar2,
  vNoiChuyen in number,
  vTrangthai in number,
  vCD_DONVIID in number,
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vPhancongTTV in number,
  vloaian in number,-- them loai an
  IsGhepVuAn in number,
  PageIndex	in	int,
  PageSize	in	int,
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

    Select Count(d.ID)into TotalItem 
    from GDTTT_DON d
         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID

    where  d.TOAANID=vToaAnID 
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end
        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end
        and
        1=case when vSoBAQD || ' '=' ' then 1 when lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' then 1 else 0 end         
        and
          1=case when vNgayBAQD || ' '=' ' then 1 when to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD then 1 else 0 end        
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        --1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
         1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end

        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
       -- and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like lower(vSoThuly) then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
                    end
            -- them loai an
--        and 1 = case when vloaian  = 0 then 1
--                     when vloaian >0 and NVL(va.LOAIAN,0) = vloaian then 1
--                end
          and 1 = case when vloaian  = 0 then 1
                        when NVL(d.BAQD_LOAIAN,0) = vloaian then 1
                        end
            ;

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
        , case when length(NVL(a.arrCongvan, ''))>0 then (' (' || a.arrCongvan || ')') else '' end as CV_NguoiKhieuNai
  from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      , d.ID  ,dc.ID as DCID 
      , NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                  then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
            else 0 end,0) DonThuLyMoi_ID
      ,d.MADON,d.NGUOIGUI_HOTEN, NVL(d.VuviecID,0) VuViecID
      ,d.SOTHUTUDON,d.NGAYNHANDON

      , NVL(d.ISTHULY,0) IsThuLy
      , (case NVL(d.ISTHULY,0) when 1 then u'Th\1ee5 l\00fd m\1edbi' else u'\0110\00e3 th\1ee5 l\00fd' end) TrangThaiThuLy
      ,d.BAQD_LOAIQDBA,d.BAQD_SO, d.BAQD_NGAYBA, d.BAQD_CAPXETXU
       , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  
      ,d.BAQD_LOAIAN, d.BAQD_TOAANID
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD

      , va.NGUYENDON ,va.BIDON , cf.TenQHPL
      ,d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI
      ,d.NGAYTAO NgayNhap 
        ,case when (Length(NVL(d.NgayTao,''))=0 or (to_char(d.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NgayTao,'')) >0 then to_char(d.NgayTao,'dd/MM/yyyy')
        end  NgayTaoStr 
      ,TL_NGAY ,TL_SO,d.ISSHOWFULL
      , case when (Length(NVL(d.TL_NGAY,''))=0 or (to_char(d.TL_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.TL_NGAY,'')) >0 then to_char(d.TL_NGAY,'dd/MM/yyyy')
                    end  TL_NGAY_TEXT 
      ,d.LOAIDON
      ,case d.LOAIDON when 1 then 'Đơn' 
                      when 2 then 'Đơn tố cáo' 
                      when 3 then 'Đơn + Công văn' end as HinhThuc
      ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO
      , case when (Length(NVL(d.NGAYGHITRENDON,''))=0 or (to_char(d.NGAYGHITRENDON,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NGAYGHITRENDON,'')) >0 then to_char(d.NGAYGHITRENDON,'dd/MM/yyyy')
        end  NGAYGHITRENDON

      , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH

      ,d.CV_TENDONVI
      ,d.CV_NGAY,d.CV_DIACHI CVDIACHI

      ,d.CD_SOCV,d.CD_NGUOIKY
      ,case when (Length(NVL(d.CD_NGAYCV,''))=0 or (to_char(d.CD_NGAYCV,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.CD_NGAYCV,'')) >0 then to_char(d.CD_NGAYCV,'dd/MM/yyyy')
        end  CD_NGAYCV  

      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC, d.CD_TA_LYDO_KHAC
      ,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
          when 1 then 'Đã chuyển'           
          when 2 then  'Đã chuyển và chưa nhận'
          when 3 then  'Đã chuyển và đã nhận'
          when 4 then  'Bị trả lại'
          end ) TRANGTHAICHUYEN

      , d.CHIDAO_THOIHAN ,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      , va.THAMTRAVIENID,(Select HOTEN from DM_CANBO where ID=va.THAMTRAVIENID) TENTHAMTRAVIEN
      , va.LANHDAOVUID,(Select HOTEN from DM_CANBO where ID=va.LANHDAOVUID) TENLANHDAOVU 
      , va.THAMPHANID,(Select HOTEN from DM_CANBO where ID=va.THAMPHANID) TENTHAMPHAN
      , NVL(va.ID, 0) VuAnID, NVL(va.TOAPHUCTHAMID, 0) IsMapVuAn
      ,(case NVL(va.TRANGTHAIID, 3) when 3 then 0 else 1 end) as IsKetQuaGQDon 

      , NVL(va.SOTHULYDON,0) VA_SoThuLy, va.NGAYTHULYDON VA_NgayThuLy
      , NVL(va.SOANPHUCTHAM,'') VA_SoBA, va.NGAYXUPHUCTHAM VA_NgayBA
      , NVL(va.TOAPHUCTHAMID,0) VA_ToaPT, NVL(va.QHPL_DINHNGHIAID,0) VA_QHPL
      ,dc.ARRDONTRUNG, dc.SOLUONGDON SODON

      ,(SELECT LISTAGG(TO_CHAR(cv.CV_TENDONVI) 
                      || ' chuyển đến theo CV/PC số ' || cv.CV_SO 
                      || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'), '; ')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE cv.LOAIDON=3 
            and  (',' || dc.ARRDONTRUNG || ',') like ('%,' || cast(cv.ID as varchar2(10)) || ',%')
         ) arrCongvan

       , d.PHANLOAIXULY
      ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 
        then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Theo số TL: ') || cv.TL_SO
        || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy')
        || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  
           WHERE cv.ISTHULY=1 And cv.ID<d.ID
                  And (cv.ID = d.ID or cv.DONTRUNGID=d.ID 
                     Or ( cv.ID in ( select ID from GDTTT_DON 
                                    where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           )  End) arrTTTL
    from GDTTT_DON d
         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID

    where d.TOAANID=vToaAnID  
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD then 1 else 0 end
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end
        and
        1=case when vSoBAQD || ' '=' ' then 1 when lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' then 1 else 0 end         
        and
          1=case when vNgayBAQD || ' '=' ' then 1 when to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD then 1 else 0 end        
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        and
        1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and 1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end      
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end       
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like  lower(vSoThuly)  then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
            end
            -- them loai an
        and 1 = case when vloaian  = 0 then 1
                     when vloaian >0 and NVL(d.BAQD_LOAIAN,0) = vloaian then 1
            end
        ) a
        where a.stt>=MinIndex and a.stt<=MaxIndex;
END DON_GIAIQUYET_SEARCH;
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,
      DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
      ,DECODE(d.Toaanid,1,'',(SELECT ld.LOAIDON_TEN FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON)) HINHTHUCDON
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
     ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'               
          when 1 then  'Đã chuyển'
          when 2 then  'Đã nhận'
          when 3 then  'Bị trả lại'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    where  (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.DONTRUNGID=vID)>0)Or (d.DONTRUNGID=vID Or  d.DONTRUNGID in (Select DONTRUNGID from GDTTT_DON where ID=vID and DONTRUNGID>0)
    Or  d.ID in (Select DONTRUNGID from GDTTT_DON where ID=vID  and DONTRUNGID>0))
    Order by d.Ngaytao desc;    
END DANHSACHDONTRUNG;

PROCEDURE DANHSACHDONTHEOID
( 
  varrID in varchar2,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,
      DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
     ,DECODE(d.Toaanid,1,'',(SELECT ld.LOAIDON_TEN FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON)) HINHTHUCDON
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
     ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'               
          when 1 then  'Đã chuyển'
          when 2 then  'Đã nhận'
          when 3 then  'Bị trả lại'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG      
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
      ,d.CV_TENDONVI,d.CV_SO,d.CV_NGAY,d.CHIDAO_NOIDUNG,ld.HOTEN TENLANHDAO
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
         left join DM_CANBO ld on d.CHIDAO_LANHDAOID=ld.ID
    where varrID like ('%,' || cast(d.ID as varchar2(10)) || ',%')
    Order by d.Ngaytao desc;    
END DANHSACHDONTHEOID;
PROCEDURE DANHSACHDONTHEOVuAnID
( 
  vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,
      DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
      ,DECODE(d.Toaanid,1,'',(SELECT ld.LOAIDON_TEN FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON)) HINHTHUCDON
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
     ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'               
          when 1 then  'Đã chuyển'
          when 2 then  'Đã nhận'
          when 3 then  'Bị trả lại'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG      
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
      ,d.CV_TENDONVI,d.CV_SO,d.CV_NGAY,d.CHIDAO_NOIDUNG,ld.HOTEN TENLANHDAO
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
         left join DM_CANBO ld on d.CHIDAO_LANHDAOID=ld.ID
    where d.VuViecID = vVuAnID   
      AND d.CD_TRANGTHAI =1 -----don da chuyen

    Order by d.NgayNhanDon desc, d.NgayGhiTrenDon desc;    
END DANHSACHDONTHEOVuAnID;
PROCEDURE BOSUNGTAILIEU
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select b.*,(Case b.TRANGTHAI when 0 then 'Đủ điều kiện' else 'Chưa đủ điều kiện' End) TENTRANGTHAI
   From GDTTT_DON_BOSUNG b 
   WHere b.DONID=vID order by b.NGAYBOSUNG desc;

END BOSUNGTAILIEU;

PROCEDURE YEUCAUBOSUNG
( 
    vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select b.*,DECODE(b.CD_TA_LYDO_ISBAQD, 1, 'Bản án, quyết định<br>', '' ) 
   || DECODE(b.CD_TA_LYDO_ISXACNHAN, 1, 'Xác nhận<br>', '' )
   || DECODE(b.CD_TA_LYDO_ISKHAC, 1, 'Lý do khác: ' || b.NOIDUNG, '' ) TENLYDO,
   DECODE(TO_CHAR(b.NGAYBOSUNG,'dd/MM/yyyy'), '01/01/0001', '', TO_CHAR(b.NGAYBOSUNG,'dd/MM/yyyy')) NGAYBS
   From GDTTT_DON_YEUCAU_BOSUNG b 
   WHere b.DONID=vID order by b.LANTHU desc;

END YEUCAUBOSUNG;

PROCEDURE GDTTT_DON_YEUCAU_BOSUNG_GETBYID
( 
    vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select b.*
   From GDTTT_DON_YEUCAU_BOSUNG b 
   WHere b.ID=vID;

END GDTTT_DON_YEUCAU_BOSUNG_GETBYID;

PROCEDURE  GDTTT_DON_YEUCAU_BOSUNG_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_DONID in number,
    v_LANTHU in number,
    v_NGUOIKY in varchar2,
    v_SOTHONGBAO in varchar2,
    v_NGAYTHONGBAO in date,
    v_CD_TA_LYDO_ISBAQD in number,
    v_CD_TA_LYDO_ISXACNHAN in number,
    v_CD_TA_LYDO_ISKHAC in number,
    v_NOIDUNG in varchar2,
    v_KETQUA in number,
    v_NOIDUNGKQ in varchar2,
    v_NGAYBOSUNG in date,
    v_NGAYTAO in date,
    v_NGUOITAO     in varchar2
)
IS 
BEGIN
        if (v_id >0) then
            update GDTTT_DON_YEUCAU_BOSUNG
                    set
                        DONID = v_DONID,
                        LANTHU = v_LANTHU,
                        NGUOIKY     = v_NGUOIKY,
                        SOTHONGBAO   = v_SOTHONGBAO,
                        NGAYTHONGBAO   =   v_NGAYTHONGBAO,
                        CD_TA_LYDO_ISBAQD = v_CD_TA_LYDO_ISBAQD,
                        CD_TA_LYDO_ISXACNHAN = v_CD_TA_LYDO_ISXACNHAN,
                        CD_TA_LYDO_ISKHAC = v_CD_TA_LYDO_ISKHAC,
                        NOIDUNG = v_NOIDUNG,
                        KETQUA  =  v_KETQUA,
                        NOIDUNGKQ = v_NOIDUNGKQ,
                        NGAYBOSUNG = v_NGAYBOSUNG
                    where id = v_id ;   
        else
            insert into GDTTT_DON_YEUCAU_BOSUNG 
                (id,DONID,LANTHU,NGUOIKY,SOTHONGBAO,NGAYTHONGBAO,CD_TA_LYDO_ISBAQD,CD_TA_LYDO_ISXACNHAN,CD_TA_LYDO_ISKHAC,NOIDUNG,KETQUA,NOIDUNGKQ,NGAYBOSUNG,ngaytao,NGUOITAO)
                values (GDTTT_DON_YEUCAU_BOSUNG_SEQ.nextval,v_DONID,v_LANTHU,v_NGUOIKY,v_SOTHONGBAO,v_NGAYTHONGBAO,v_CD_TA_LYDO_ISBAQD,v_CD_TA_LYDO_ISXACNHAN,v_CD_TA_LYDO_ISKHAC,v_NOIDUNG,v_KETQUA,v_NOIDUNGKQ,v_NGAYBOSUNG, sysdate,v_NGUOITAO);

        end if;

End GDTTT_DON_YEUCAU_BOSUNG_UP_IN;

PROCEDURE  GDTTT_DON_YEUCAU_BOSUNG_DEL
( 
    v_id  in number DEFAULT 0
)
IS 
BEGIN
        if (v_id >0) then
            DELETE GDTTT_DON_YEUCAU_BOSUNG where id = v_id ;   
        end if;

End GDTTT_DON_YEUCAU_BOSUNG_DEL;
PROCEDURE DON_YEUCAU_GETMAXTT
( vdonviID in number,
  vYear in number,
  vLoaiAn in number,
	curReturn    OUT       sys_refcursor
)
IS 
vY number;
BEGIN
vY:=vYear;
--if(to_char(SYSDATE,'mm')='12') then
-- vY:=vY+1;
-- end if;
OPEN curReturn FOR  
    select Max(to_number(regexp_replace(tt.SOTHONGBAO, '[^0-9]')))TL_SO from (
    select y.SOTHONGBAO from GDTTT_DON_YEUCAU_BOSUNG y
      JOIN gdttt_don d ON d.ID = y.DONID
      Where d.TOAANID=vdonviID 
        and d.BAQD_LOAIAN=vLoaiAn  and trim(y.SOTHONGBAO) is not null 
        and y.NGAYTHONGBAO between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
    )tt;
END DON_YEUCAU_GETMAXTT;

PROCEDURE DON_YEUCAU_GETMAXLANTHU
(   vdonID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
    select Max(to_number(tt.LANTHU))TL_SO from (
    select y.LANTHU from GDTTT_DON_YEUCAU_BOSUNG y
      Where y.DONID=vdonID 
        )tt;
END DON_YEUCAU_GETMAXLANTHU;
PROCEDURE CHECK_YEUCAU_LANTHUTRUNG
( 
    vID in number,
    vdonID in number,
    vLanThu in number,
	curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR  
    select y.* from GDTTT_DON_YEUCAU_BOSUNG y
    Where y.DONID=vdonID AND ( y.ID = 0 OR y.ID <> vID) AND y.LANTHU = vLanThu;
END CHECK_YEUCAU_LANTHUTRUNG;

PROCEDURE CHECK_YEUCAU_SOTHONGBAO_TRUNG
( 
    vID in number,
    vdonID in number,
    vSoThongBao in varchar2,
	curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR  
    select y.* from GDTTT_DON_YEUCAU_BOSUNG y
    Where y.DONID=vdonID AND ( y.ID = 0 OR y.ID <> vID) AND y.SOTHONGBAO = vSoThongBao;
END CHECK_YEUCAU_SOTHONGBAO_TRUNG;

PROCEDURE CHECK_YEUCAU_NGAYTHONGBAO
( 
    vID in number,
    vdonID in number,
    vNgayThongBao in varchar2,
    vLanThu in number,
	curReturn    OUT       sys_refcursor
)IS V_NGAYTBTU date; V_NGAYTBDEN date;
BEGIN if(vNgayThongBao IS NOT NULL) then  V_NGAYTBTU:=to_date(trim(vNgayThongBao)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
      if(vNgayThongBao IS NOT NULL) then  V_NGAYTBDEN:=to_date(trim(vNgayThongBao)||' 00:00:00','dd/MM/yyyy HH24:MI:SS'); end if;
OPEN curReturn FOR  
    select y.* from GDTTT_DON_YEUCAU_BOSUNG y
    Where y.DONID=vdonID AND ( y.ID = 0 OR y.ID <> vID) 
    AND ((y.LANTHU < vLanThu AND y.NGAYTHONGBAO > V_NGAYTBTU) OR (y.LANTHU > vLanThu AND y.NGAYTHONGBAO < V_NGAYTBDEN));
END CHECK_YEUCAU_NGAYTHONGBAO;

PROCEDURE CHECK_YEUCAU_SOTB_NGAYTB
( 
    vdonID in number,
    vSoThongBao in varchar2,
    vNgayThongBao in varchar2,
	curReturn    OUT       sys_refcursor
)IS V_NGAYTB date;
BEGIN if(vNgayThongBao IS NOT NULL) then  V_NGAYTB:=to_date(trim(vNgayThongBao)||' 00:00:00','dd/MM/yyyy HH24:MI:SS'); end if;
OPEN curReturn FOR  
    select y.* from GDTTT_DON_YEUCAU_BOSUNG y
    Where y.DONID=vdonID AND y.SOTHONGBAO=vSoThongBao
    AND (vNgayThongBao IS NULL OR y.NGAYTHONGBAO=V_NGAYTB);
END CHECK_YEUCAU_SOTB_NGAYTB;

PROCEDURE VUAN_PHANCONGTTV
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2, 
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number, 

  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_GIAIDOAN in number,
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        --left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        --left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        --left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        --left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      -----------------------
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)        
          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
           and 1=case when vTrangthai=0  and NVL(v.TrangThaiID, 1)=1 and NVL(v.THAMTRAVIENID,0)=0 then 1  
                     when vTrangthai=1 and NVL(v.THAMTRAVIENID,0)>0 then 1 
                     else 0 end
        ---Đơn xin ân giảm,vụ án tử hình
        AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )         

                     ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc, v.SoThuLyDon DESC) STT
          ,v.ID,v.MAVUAN
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON

          --,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
          , v.SOANPHUCTHAM || chr(10) ||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') TTBANANPT 
            ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --


          ,v.NGUYENDON,v.BIDON,v.NGUOIKHIEUNAI          
          , txx.Ma_Ten ToaXX 
          --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
          ,qhpl.TENQHPL QHPLDN

          , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
              end  NGAYPHANCONGTTV
          , case when (Length(NVL(v.NGAYTTVNHAN_THS,''))=0 or (to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYTTVNHAN_THS,'')) >0 then to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy')
              end  NGAYTTVNHAN_THS


          , case when (Length(NVL(v.NGAYPHANCONGLD,''))=0 or (to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGLD,'')) >0 then to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy')
              end  NGAYPHANCONGLD
          ,v.LANHDAOVUID,ld.HOTEN as TENLANHDAO

          ,v.GHICHU,v.NGUOITAO,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
          ,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
          ,tt.TENTINHTRANG
           , GDTTT_PCCB_GetAllByType(v.ID, 1,1) PhanCongTTV
           , GDTTT_PCCB_GetAllByType(v.ID, 1,2) PhanCongTTV_GDT
          , GDTTT_PCCB_GetAllByType(v.ID, 2,1) PhanCongLD
          , GDTTT_PCCB_GetAllByType(v.ID, 2,2) PhanCongLD_GDT
          ,v.THAMTRAVIENID,ttv.HOTEN as TENTHAMTRAVIEN
          ,v.XXGDT_THAMTRAVIENID,ttvxx.HOTEN as TENTHAMTRAVIEN_GDT, v.XXGDT_NGAYPHANCONGTTV
          ,v.XXGDT_LANHDAOVUID,ldxx.HOTEN as TENLANHDAO_GDT,v.XXGDT_NGAYPHANCONGLD
       from GDTTT_VUAN v 
        left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
        left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
        left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
        left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
        left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and 1=case when vToaRaBAQD=0 then 1 when v.TOAPHUCTHAMID=vToaRaBAQD then 1 else 0 end
          and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(v.SOANPHUCTHAM) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end
          and 1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end      

          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          and 1=case when vTrangthai=0 and NVL(v.THAMTRAVIENID,0)=0 and NVL(v.TrangThaiID, 1)=1 then 1 
                     when vTrangthai=1 and NVL(v.THAMTRAVIENID,0)>0 then 1 
                     else 0 end
        --Đơn xin ân giảm,vụ án tử hình
         AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
         AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        --Tim kiem TTV theo giai doan Giai quyet don hoặc xet xu GĐT
        And (v_GIAIDOAN = 0 
            or  (v_GIAIDOAN = 2 and EXISTS(select id from GDTTT_VUAN_PHANCONGCB_HISTORY where GIAIDOANGQ= 2 and v.id = VUANID))
            or  v_GIAIDOAN = 1
        )
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END VUAN_PHANCONGTTV;
PROCEDURE VUAN_XETXU_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vKetquaxetxu in number,  
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        --left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        --left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        --left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        --left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and 1=case when vToaRaBAQD=0 then 1 when v.TOAPHUCTHAMID=vToaRaBAQD then 1 else 0 end
          and 1=case when vSoBAQD || ' '=' ' then 1 
                     when (lower(v.SOANPHUCTHAM) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end
          and 1=case when vNgayBAQD || ' '=' ' then 1
                     when (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end      

          and 1=case when vNguyendon || ' '=' ' then 1 
                     when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
          and 1=case when vBidon || ' '=' ' then 1 
                     when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end

          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end

          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end

          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          and  v.TRANGTHAIID>=14
          and 1=case when vTrangthai=-1 then 1
                     when vTrangthai=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 then 1 
                     when vTrangthai=1 and NVL(v.XXGDTTT_KETQUAID,0)>0 then 1 else 0 end
          and 1=case when vKetquaxetxu=0 then 1
                     when v.XXGDTTT_KETQUAID=vKetquaxetxu then 1 else 0 end   
          and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and (Select Count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))>0 then 1
                     when (Select Count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)))>0 then 1 else 0 end
          ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
          ,v.ID,v.MAVUAN
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
          , v.SOTHULYDON || chr(10) ||to_char(v.NGAYTHULYDON,'dd/MM/yyyy') TTThuLyDon
          , v.SOTHULYXXGDT, to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') NGAYTHULYXXGDT

          ,v.NGUYENDON,v.BIDON,v.NGUOIKHIEUNAI
          ,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
          --,txx.MA_TEN TOAXX
          ,txx.Ma_Ten ToaXX, DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat

          ,qhpl.TENQHPL QHPLDN,tp.HOTEN as TENTHAMPHAN,ttv.HOTEN as TENTHAMTRAVIEN,ld.HOTEN as TENLANHDAO
          ,v.GHICHU,v.NGUOITAO,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
          ,tt.TENTINHTRANG,v.QUATRINH_GHICHU

          , NVL(kq.Ten,' ') KetQuaXXGDT
          , case when NVL(v.GQD_LOAIKETQUA,0) > 0 then (u'S\1ed1 '||v.GDQ_So || u' Ng\00e0y ' || to_char(v.GDQ_Ngay,'dd/MM/yyyy'))
                 when NVL(v.GQD_LOAIKETQUA,0) = 0 then u' ' 
            end  LoaiKQ_GiaiQuyetDon
          , v.TrangThaiID
          ,(Select count(ID) from GDTTT_DON d where d.VUVIECID=v.ID and d.CD_TRANGTHAI=2) TONGDON
          ,(SELECT LISTAGG(cast(dt.ID as varchar2(10)), ',')
            WITHIN GROUP (ORDER BY dt.NGAYTAO desc) FROM GDTTT_DON dt  WHERE  dt.VUVIECID=v.ID and dt.CD_TRANGTHAI=2) arrDONID
          ,(SELECT LISTAGG(cast(dt.ID as varchar2(10)), ',')
             WITHIN GROUP (ORDER BY dt.NGAYTAO desc) FROM GDTTT_DON dt  WHERE  dt.VUVIECID=v.ID  and  dt.LOAICONGVAN in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023)) arrCV81ID
          ,(Select count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and  d.LOAICONGVAN in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023)) SoCV81
       from GDTTT_VUAN v 
         left join (select ID, Ma_Ten from DM_TOAAN) txx on v.TOAPHUCTHAMID=txx.ID
         left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
         left join DM_CANBO tp on v.THAMPHANID=tp.ID
         left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
         left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
         left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
         left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and 1=case when vToaRaBAQD=0 then 1 when v.TOAPHUCTHAMID=vToaRaBAQD then 1 else 0 end
          and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(v.SOANPHUCTHAM) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end
          and 1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end      

          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end

          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end

          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          and  v.TRANGTHAIID>=14
          and 1=case when vTrangthai=-1 then 1
                     when vTrangthai=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 then 1 
                     when vTrangthai=1 and NVL(v.XXGDTTT_KETQUAID,0)>0 then 1 else 0 end
          and 1=case when vKetquaxetxu=0 then 1
                     when v.XXGDTTT_KETQUAID=vKetquaxetxu then 1 else 0 end       
          and 1=case when vLoaiCVID=0 then 1 
                     when vLoaiCVID=-1 and (Select Count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))>0 then 1
                     when (Select Count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)))>0 then 1 else 0 end
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END VUAN_XETXU_SEARCH;
PROCEDURE TRALOIDON_DANHSACH
( 
  vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
  IsShow number;
BEGIN
  select NVL(IsAnQuochoi,0) into IsShow from GDTTT_VuAn where ID = vVuAnID;
  ------------------------------------
  OPEN curReturn FOR
   --Đương sự
   select a.* , NVL(IsShow,0) as IsShowNhapQH
   from (
        select  1 as LOAITLD
           , d.ID,To_char(d.TENDUONGSU) as HOTEN
           ,(CASE d.TUCACHTOTUNG WHEN 'NGUYENDON' then 'Nguyên đơn'  WHEN 'BIDON' then 'Bị đơn' Else 'Người có QL1' END) LOAIDS
           ,( d.DIACHI || ' ' || h.MA_TEN) DIACHI 
        from GDTTT_VUAN_DUONGSU d
        left join DM_HANHCHINH h on h.ID=d.HUYENID
        where d.VUANID=vVuAnID
        Union
        Select   0 as LOAITLD
          , d.ID,To_char(d.NGUOIGUI_HOTEN), 'Người khiếu nại' LOAIDS
          ,( d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN) DIACHI 
        from GDTTT_DON d
        inner join (
        select Max(ID) DONID,NGUOIGUI_HOTEN from GDTTT_DON  where VUVIECID=vVuAnID Group By NGUOIGUI_HOTEN ) g on g.DONID=d.ID
        left join DM_HANHCHINH h on h.ID=d.NGUOIGUI_HUYENID 
        --Order by d.NGUOIGUI_HOTEN
        Union
        Select   2 as LOAITLD
         ,d.ID,To_char(d.CV_TENDONVI), 'Cơ quan chuyển đơn' LOAIDS
         ,( d.CV_DIACHI || ' ' || h.MA_TEN) DIACHI 
        from GDTTT_DON d
        inner join (
        select Max(ID) DONID,CV_TENDONVI from GDTTT_DON  where LOAIDON=3 And VUVIECID=vVuAnID Group By CV_TENDONVI ) g on g.DONID=d.ID
        left join DM_HANHCHINH h on h.ID=d.CV_HUYENID 
      ) a;
        --Order by d.CV_TENDONVI;        
END TRALOIDON_DANHSACH;

PROCEDURE THONGKE_TONGHOP
( 
 vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  ---thong ke theo trang thai
   Select t.ID,'',
    (Select Count(v.ID) from GDTTT_VUAN v 
      where  NVL(v.LOAIAN,0)<>7  and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
        and NVL(v.TrangthaiID,0) not in (13, 14, 15, 16)
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 
                     when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 
                     when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        And 1=(case when t.ID =1 and NVL(v.THAMTRAVIENID,0)=0  
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1                   
                    when t.ID=2 and NVL(v.ThamtravienID,0)>0 
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1
                    when t.ID =3 and NVL(v.IsHoSo, 0) >0 and NVL(v.IsToTrinh,0)=0 
                        and NVL(v.ThamTraVienID,0)>0 
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1
                    when (t.ID >3) and NVL(v.TrangthaiID,0)=t.ID then 1 
                    else 0 End)
    ) SL
   From GDTTT_DM_TINHTRANG t
   union ----trinhTP chua TL
        Select 61,''
        , (Select Count(ID)  from GDTTT_VUAN v 
           where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and NVL(v.LOAIAN,0)<>7          
            and NVL(v.TrangthaiID,0)=6 and GDTTT_ToTrinh_GetLastTT(v.ID,0)=6
            and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
            and 1=(case  when vLanhdaoVu=0 then 1 
                         when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
            and 1=(case  when vThamTraVien=0 then 1 
                         when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)

            ) SL from dual
   union ----trinhTP co TL
        Select 62,''
        , (Select Count(ID)  from GDTTT_VUAN v 
           where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and NVL(v.LOAIAN,0)<>7          
            and NVL(v.TrangthaiID,0)=6 and GDTTT_ToTrinh_GetLastTT(v.ID,1)=6
            and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
            and 1=(case  when vLanhdaoVu=0 then 1 
                         when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
            and 1=(case  when vThamTraVien=0 then 1 
                         when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)

            ) SL from dual
   union -- da co ho so
   Select 1000,''
    , (Select Count(ID)  from GDTTT_VUAN v 
       where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
        and NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0)<>7          
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 
                     when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 
                     when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and NVL(v.ISHOSO,0)>0) SL from dual
  union -- chua co ho so
     Select 2000,'', (Select Count(ID)  from GDTTT_VUAN v 
     where NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0)<>7 
        and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        --and NVL(v.THAMTRAVIENID,0)>0
        and NVL(v.IsHoSo,0)=0 ) SL from dual  
  union --Hoãn Thi Hành án
     Select 3000,''
      , (Select Count(ID)  from GDTTT_VUAN v 
          where NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0)<>7 
              and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
              and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
              and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
              and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
              and v.GQD_ISHOANTHA=1) SL from dual;        
END THONGKE_TONGHOP;
PROCEDURE THONGKE_ANQUOCHOI_THOIHIEU
( 
 vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
    vAnQuocHoi number,
  vAnThoiHieu number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select t.ID,'',
    (Select Count(v.ID) from GDTTT_VUAN v
      where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and NVL(v.LOAIAN,0)<>7 
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)

        and 1=(case  when vAnQuocHoi=0 then 1 
                     when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
        and 1=(case  when vAnThoiHieu=0 then 1 
                     when vAnThoiHieu =1 and (NVL(v.TrangThaiID,0) not in (13,14,15,16))
                        and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0
                        then 1    
                       else 0 end)
         And 1=(case when t.ID =1 and NVL(v.THAMTRAVIENID,0)=0  
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1                   
                    when t.ID=2 and NVL(v.ThamtravienID,0)>0 
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1
                    when t.ID =3 and NVL(v.IsHoSo, 0) >0 and NVL(v.IsToTrinh,0)=0 
                        and NVL(v.ThamTraVienID,0)>0 
                        and (NVL(v.TrangThaiID,0) not in (13,14,15,16)) then 1
                    when (t.ID >3) and NVL(v.TrangthaiID,0)=t.ID then 1                     
                    else 0 End)
    ) SL
   From GDTTT_DM_TINHTRANG t
   union ----trinhTP chua TL
        Select 61,''
        , (Select Count(ID)  from GDTTT_VUAN v 
           where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and NVL(v.LOAIAN,0)<>7  
            and NVL(v.TrangthaiID,0)=6 and GDTTT_ToTrinh_GetLastTT(v.ID,0)>0
            and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
            and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
            and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
            and 1=(case  when vAnQuocHoi=0 then 1 
                         when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
            and 1=(case  when vAnThoiHieu=0 then 1 
                         when vAnThoiHieu =1 and (NVL(v.TrangThaiID,0) not in (13,14,15,16))
                              and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0
                            then 1    
                       else 0 end)            
            ) SL from dual
   union ----trinhTP co TL
        Select 62,''
        , (Select Count(ID)  from GDTTT_VUAN v 
            where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and NVL(v.LOAIAN,0)<>7  
                and NVL(v.TrangthaiID,0)=6 and GDTTT_ToTrinh_GetLastTT(v.ID,1)>0
                and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
                and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
                and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
                and 1=(case  when vAnQuocHoi=0 then 1 
                             when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
                and 1=(case  when vAnThoiHieu=0 then 1 
                             when vAnThoiHieu =1 and (NVL(v.TrangThaiID,0) not in (13,14,15,16))
                                  and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0
                                then 1    
                           else 0 end) 
            ) SL from dual
   union 
   Select 1000,'', (Select Count(ID)  from GDTTT_VUAN v
   where  v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
        and NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0)<>7         
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and 1=(case  when vAnQuocHoi=0 then 1
                     when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
        and 1=(case  when vAnThoiHieu=0 then 1 
                     when (vAnThoiHieu=1 and (v.TrangThaiID not in (13,14,15,16))
                            and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0) then 1                         
                     else 0 end)                              
        and NVL(v.IsHoSo,0)>0) SL from dual
  union
     Select 2000,'', (Select Count(ID)  from GDTTT_VUAN v 
     where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
        and NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0)<>7          
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and 1=(case  when vAnQuocHoi=0 then 1 when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
        and 1=(case  when vAnThoiHieu=0 then 1 
                      when vAnThoiHieu =1 and (v.TrangThaiID not in (13,14,15,16))
                        and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0
                        then 1 
                     else 0 end)  
        --and NVL(v.THAMTRAVIENID,0)>0
        and NVL(v.IsHoSo,0)=0 ) SL from dual  
  union
     Select 3000,'', (Select Count(ID)  from GDTTT_VUAN v 
      where  NVL(v.TrangthaiID,0) not in (13,14,15,16) and NVL(v.LOAIAN,0) <>7 
        and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID       
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0) =vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and 1=(case  when vAnQuocHoi=0 then 1
                     when vAnQuocHoi=1 and NVL(v.ISANQUOCHOI,0)=1 then 1 else 0 end)
        ---v.LoaiAn =1 : an hinh su, v.LoaiAn>1--> cac loai an khac             
        and 1=(case  when vAnThoiHieu=0 then 1 
                     when vAnThoiHieu=1 and v.TrangThaiID not in (13,14,15,16)
                        and GDTTT_VuAn_CheckAnThoiHieu(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0))>0 
                        then 1
                     else 0 end)                              
        and v.GQD_ISHOANTHA=1) SL from dual  ;
END THONGKE_ANQUOCHOI_THOIHIEU;
PROCEDURE THONGKE_CHUNG
( 
 vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn number,
  vLanhdaoVu number,
  vThamTraVien number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR   
   Select 'TS' LOAI, (Select Count(ID)  from GDTTT_VUAN v 
      where  NVL(v.TrangthaiID,0) not in (13,14,15,16) 
        and NVL(v.LOAIAN,0) <>7 and v.LoaiAn is not null
        and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0) =vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 
                     when NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 
                     when  NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)

                     ) SL
  from dual
  union
  Select 'QH' LOAI, (Select Count(ID)  from GDTTT_VUAN v 
    where --(v.TrangthaiID <13 Or v.TrangthaiID=17)   
        v.TrangthaiID not in (13,14,15,16) and NVL(v.LOAIAN,0) <>7 
        and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 
                     when  NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 
                     when  NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and v.ISANQUOCHOI=1) SL
  from dual
  union
  Select 'CD' LOAI, (Select Count(ID)  from GDTTT_VUAN v 
    where --(v.TrangthaiID  not in (13,14,15,16) Or v.TrangthaiID=17)  
        v.TrangthaiID not in (13,14,15,16) and NVL(v.LOAIAN,0) <>7 
        and v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID       
        and 1=(case  when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0) =vLoaiAn then 1 else 0 end)
        and 1=(case  when vLanhdaoVu=0 then 1 when  NVL(v.LANHDAOVUID,0)=vLanhdaoVu then 1 else 0 end)
        and 1=(case  when vThamTraVien=0 then 1 when  NVL(v.THAMTRAVIENID,0)=vThamTraVien then 1 else 0 end)
        and v.ISANCHIDAO=1) SL
  from dual
  union
  Select 'TH' LOAI, 0 SL
  from dual;

END THONGKE_CHUNG;

	PROCEDURE BAOCAO_THONGKE_THULY
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	) AS    
		v_ARRAY T_GDT_TKTLGQD;
    r R_GDT_TKTLGQD;
    v_TT number;
    vHS number;vDS number;vHC number;vHN number;vKT number;vLD number;vPS number;
    vCC_HN_ID number;vCC_DN_ID number;vCC_HCM_ID number;
	BEGIN	

  v_TT:=0;
  vCC_HN_ID:=4;
  vCC_DN_ID:=5;
  vCC_HCM_ID:=6;
  Select ISHINHSU,ISDANSU,ISHANHCHINH,ISHNGD,ISKDTM,ISLAODONG,ISPHASAN
        into vHS,vDS,vHC,vHN,vKT,vLD,vPS from DM_PHONGBAN Where ID=vPhongBanID;
  v_ARRAY:=T_GDT_TKTLGQD();
  ----ÁN HÌNH SỰ---
  IF(vHS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;
  ----ÁN DÂN SỰ---
  IF(vDS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN HON nhan---
  IF(vHN=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
    ----ÁN KINH TẾ---
  IF(vKT=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;
  ----ÁN LAO ĐỌNG---
  IF(vLD=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN HÀNH CHÍNH---
  IF(vHC=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN PHÁ SẢN---
  IF(vPS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
	OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

	END BAOCAO_THONGKE_THULY;
  PROCEDURE FILL_BAOCAO_THONGKE_THULY
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  vToaRaBA_ID number,
  v_TT number,
  v_TKTL IN OUT R_GDT_TKTLGQD
	)AS 
   v_TenLoaiAn nvarchar2(100);v_TenToa nvarchar2(100);
  v_DON_TONGSO NUMBER;
	v_DON_TRUNG NUMBER;
	v_DON_CHUAXULY NUMBER;
	v_THAMQUYEN_CU NUMBER;
  v_THAMQUYEN_MOI NUMBER;
  v_THAMQUYEN_TONGSO NUMBER;
  v_THAMQUYEN_QUOCHOI NUMBER;
  v_GQ_TLD_TONGSO NUMBER;
  v_GQ_TLD_QUOCHOI NUMBER;
  v_GQ_KN_TONGSO NUMBER;
  v_GQ_KN_QUOCHOI NUMBER;
  v_GQ_KHAC NUMBER;
  v_GQ_CONG NUMBER;
  v_CONLAI_TONGSO NUMBER;
  v_CONLAI_QUOCHOI NUMBER;
  v_DATRINH NUMBER;
  v_DANGNGHIENCUU NUMBER;
  v_DANGRUTHOSO NUMBER;
  BEGIN	
  IF(vLoaiAn=1) THEN v_TenLoaiAn:='Hình sự';
  Elsif (vLoaiAn=2) THEN v_TenLoaiAn:='Dân sự';
  Elsif (vLoaiAn=3) THEN v_TenLoaiAn:='Hôn nhân gia đình';
  Elsif (vLoaiAn=4) THEN v_TenLoaiAn:='Kinh doanh thương mại';
  Elsif (vLoaiAn=5) THEN v_TenLoaiAn:='Lao động';
  Elsif (vLoaiAn=6) THEN v_TenLoaiAn:='Hành chính';
  Elsif (vLoaiAn=7) THEN v_TenLoaiAn:='Phá sản';
  End IF;
  IF(vToaRaBA_ID=4) THEN v_TenToa:='TACC HN';
  Elsif (vToaRaBA_ID=5) THEN v_TenToa:='TACC ĐN';
  Elsif (vToaRaBA_ID=6) THEN v_TenToa:='TACC HCM';
  Else  v_TenToa:='ĐƠN VỊ KHÁC';
  End IF;
  --Tổng số đơn đã nhận --
  Select SUM(dc.SOLUONGDON) into v_DON_TONGSO 
  from GDTTT_DON_CHUYEN dc inner join GDTTT_DON d on d.ID=dc.DONID
  where dc.PHONGBANNHANID=vPhongBanID and dc.DONVINHANID=vToaAnID And dc.NGAYNHAN between vTuNgay and vDenNgay And dc.TRANGTHAI=2
          And d.BAQD_LOAIAN=vLoaiAn and 1=(Case when vToaRaBA_ID=4 and d.BAQD_TOAANID=4 then 1 
                when vToaRaBA_ID=5 and d.BAQD_TOAANID=5 then 1 when vToaRaBA_ID=6 and d.BAQD_TOAANID=6 then 1
                when vToaRaBA_ID=0 and d.BAQD_TOAANID not in (4,5,6) then 1 ELSE 0 END);
--Đơn trùng --
  Select SUM(dc.SOLUONGDON) into v_DON_TRUNG 
  from GDTTT_DON_CHUYEN dc inner join GDTTT_DON d on d.ID=dc.DONID
  where dc.PHONGBANNHANID=vPhongBanID and dc.DONVINHANID=vToaAnID And dc.NGAYNHAN between vTuNgay and vDenNgay And dc.TRANGTHAI=2
          And d.ISTHULY<>1 And d.BAQD_LOAIAN=vLoaiAn and 1=(Case when vToaRaBA_ID=4 and d.BAQD_TOAANID=4 then 1 
                when vToaRaBA_ID=5 and d.BAQD_TOAANID=5 then 1 when vToaRaBA_ID=6 and d.BAQD_TOAANID=6 then 1
                when vToaRaBA_ID=0 and d.BAQD_TOAANID not in (4,5,6) then 1 ELSE 0 END);
--CŨ CÒN LẠI--
  Select Count(v.ID) into v_THAMQUYEN_CU From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.NGAYTHULYDON  <vTuNgay And (v.GDQ_NGAY >=vTuNgay and v.GQD_LOAIKETQUA is not null)
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--MỚI THỤ LÝ--
  Select Count(v.ID) into v_THAMQUYEN_MOI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.NGAYTHULYDON  between vTuNgay and vDenNgay
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ
  v_THAMQUYEN_TONGSO:=nvl(v_THAMQUYEN_CU,0)+v_THAMQUYEN_MOI;
--CÓ KIẾN NGHỊ CỦA ĐBQH,...--
  Select Count(v.ID) into v_THAMQUYEN_QUOCHOI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and ((v.NGAYTHULYDON  <vTuNgay And (v.GDQ_NGAY >=vTuNgay and v.GQD_LOAIKETQUA is not null)) Or  v.NGAYTHULYDON  between vTuNgay and vDenNgay)
            And v.ISANQUOCHOI=1 and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ TRẢ LỜI ĐƠN--
  Select Count(v.ID) into v_GQ_TLD_TONGSO From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0)=vLoaiAn and v.GQD_LOAIKETQUA =0 And  v.GDQ_NGAY between vTuNgay and vDenNgay
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ TRẢ LỜI ĐƠN QUỐC HỘI--
  Select Count(v.ID) into v_GQ_TLD_QUOCHOI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.GQD_LOAIKETQUA =0 And  v.GDQ_NGAY between vTuNgay and vDenNgay
            And v.ISANQUOCHOI=1 and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ KHÁNG NGHỊ--
  Select Count(v.ID) into v_GQ_KN_TONGSO From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.GQD_LOAIKETQUA =1 And  v.GDQ_NGAY between vTuNgay and vDenNgay
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ KHÁNG NGHỊ QUỐC HỘI--
  Select Count(v.ID) into v_GQ_KN_QUOCHOI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.GQD_LOAIKETQUA =1 And  v.GDQ_NGAY between vTuNgay and vDenNgay
            And v.ISANQUOCHOI=1 and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--TỔNG SỐ XẾP ĐƠn--
  Select Count(v.ID) into v_GQ_KHAC From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.GQD_LOAIKETQUA =2 And  v.GDQ_NGAY between vTuNgay and vDenNgay
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
v_GQ_CONG:=v_GQ_TLD_TONGSO+v_GQ_KN_TONGSO+v_GQ_KHAC;
--CÒN LẠI--
v_CONLAI_TONGSO:=v_THAMQUYEN_TONGSO-v_GQ_CONG;
v_CONLAI_QUOCHOI:=v_THAMQUYEN_QUOCHOI-v_GQ_TLD_QUOCHOI-v_GQ_KN_QUOCHOI;
--ĐÃ TRÌNH --
  Select Count(v.ID) into v_DATRINH From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.NGAYTHULYDON <vDenNgay and v.GQD_LOAIKETQUA is null
            And (Select Count(ID) from GDTTT_TOTRINH where VUANID=v.ID)>0
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);
--ĐANG NGHIÊN CỨU --
  Select Count(v.ID) into v_DANGNGHIENCUU From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
            And NVL(v.LOAIAN,0) =vLoaiAn and v.NGAYTHULYDON <vDenNgay and v.GQD_LOAIKETQUA is null
            And (Select Count(ID) from GDTTT_TOTRINH where VUANID=v.ID)=0
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);  
--ĐANG RÚT HỒ SƠ --
  Select Count(v.ID) into v_DANGRUTHOSO From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn and v.NGAYTHULYDON <vDenNgay and v.GQD_LOAIKETQUA is null
            And ((Select Count(ID) from GDTTT_QUANLYHS where VUANID=v.ID AND LOAI=0)>0 
            And NVL(v.IsHoSo,0)=0)
            and 1=(Case when vToaRaBA_ID=4 and v.TOAPHUCTHAMID=4 then 1 
                when vToaRaBA_ID=5 and v.TOAPHUCTHAMID=5 then 1 when vToaRaBA_ID=6 and v.TOAPHUCTHAMID=6 then 1
                when vToaRaBA_ID=0 and v.TOAPHUCTHAMID not in (4,5,6) then 1 ELSE 0 END);                   
--INSERT NEW ROW                
  v_TKTL:=R_GDT_TKTLGQD(v_TT,v_TenLoaiAn,v_TenToa,v_DON_TONGSO,v_DON_TRUNG,v_DON_CHUAXULY,v_THAMQUYEN_CU,
          v_THAMQUYEN_MOI,v_THAMQUYEN_TONGSO,v_THAMQUYEN_QUOCHOI,v_GQ_TLD_TONGSO,v_GQ_TLD_QUOCHOI,v_GQ_KN_TONGSO,
          v_GQ_KN_QUOCHOI,v_GQ_KHAC,v_GQ_CONG,v_CONLAI_TONGSO,v_CONLAI_QUOCHOI,v_DATRINH,v_DANGNGHIENCUU,v_DANGRUTHOSO);


  END FILL_BAOCAO_THONGKE_THULY;

PROCEDURE BAOCAO_THONGKE_CHITIEU
	(
    vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLanhDaoID number,
  vThamtravienID number,
  curReturn OUT SYS_REFCURSOR
	) AS    
		v_ARRAY T_GDT_CHITIEU;
    r R_GDT_CHITIEU;
    v_TT number;
    vCC_HN_ID number;vCC_DN_ID number;vCC_HCM_ID number;
    vCount number;
	BEGIN	

  v_TT:=0;
  vCC_HN_ID:=4;
  vCC_DN_ID:=5;
  vCC_HCM_ID:=6;

SELECT R_GDT_CHITIEU(
			v_TT=>row_number() over (order by ch.ID),
  v_CANBOID=>ttv.ID,
	v_HOTEN=>ttv.HOTEN,
	v_TENLANHDAO=>ldv.HOTEN,
	v_TL_DON_PTTC_CC=>NULL,
	v_TL_DON_8_1=>NULL,
	v_TL_ANGDT=>NULL,
  v_TL_CONG=>NULL,
  v_TRALOIDON=>NULL,
  v_KHANGNGHI=>NULL,
  v_TOTRINH_ANHDTP=>NULL,
  v_CHITIEUKHAC=>NULL,
  v_TONGCHITIEU=>NULL,
  v_CHITIEUTOTRINH=>NULL,
  v_DONCONLAI=>NULL,
  v_TRINH_TRONGKY=>NULL,
  v_TRINH_TONGSO=>NULL,
  v_DNC_CC_HS=>NULL,
  v_DNC_CC_THS=>NULL,
  v_DNC_TINH_HS=>NULL,
  v_DNC_TINH_THS=>NULL,
  v_AN_CHUAXU=>NULL,
  v_CONG=>NULL,
  v_GHICHU=>NULL
		) 
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_CACVU_CAUHINH ch 
        INNER JOIN DM_CANBO ttv ON ttv.ID=ch.THAMTRAVIENID
        INNER JOIN DM_CANBO ldv ON ldv.ID=ch.LANHDAOID
		WHERE ttv.PHONGBANID=vPhongBanID and ch.PHONGBANID=vPhongBanID
        And 1=(Case when vLanhDaoID =0 then 1 when ch.LANHDAOID=vLanhDaoID then 1 else 0 End)
        And 1=(Case when vThamtravienID =0 then 1 when ch.THAMTRAVIENID=vThamtravienID then 1 else 0 End);

		FOR ITEM IN (
			SELECT 
				T.v_TT, 
				T.v_CANBOID
			FROM 
				TABLE(v_ARRAY) T 
		) LOOP
      --don thu ly tc CC--  
         Select SUM(dc.SOLUONGDON) into vCount from GDTTT_DON_CHUYEN dc inner join (Select h.ID, h.VUVIECID,h.BAQD_TOAANID from GDTTT_DON h inner join GDTTT_VUAN va on va.ID=h.VUVIECID  where va.THAMTRAVIENID=ITEM.v_CANBOID)d on d.ID=dc.DONID
                 where dc.PHONGBANNHANID=vPhongBanID and dc.DONVINHANID=vToaAnID And dc.NGAYNHAN between vTuNgay and vDenNgay And dc.TRANGTHAI=2
                        And d.BAQD_TOAANID in (4,5,6);
        v_ARRAY(ITEM.v_TT).v_TL_DON_PTTC_CC:=vCount;
      --ĐƠN THỤ LÝ TỈNH--  
         Select SUM(dc.SOLUONGDON) into vCount from GDTTT_DON_CHUYEN dc inner join (Select h.ID, h.VUVIECID,h.BAQD_TOAANID from GDTTT_DON h inner join GDTTT_VUAN va on va.ID=h.VUVIECID  where va.THAMTRAVIENID=ITEM.v_CANBOID) d on d.ID=dc.DONID
                 where dc.PHONGBANNHANID=vPhongBanID and dc.DONVINHANID=vToaAnID And dc.NGAYNHAN between vTuNgay and vDenNgay And dc.TRANGTHAI=2
                        And d.BAQD_TOAANID not in (4,5,6);
        v_ARRAY(ITEM.v_TT).v_TL_DON_8_1:=vCount;    

      --ÁN GĐT
        Select Count(v.ID) into vCount From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And  v.NGAYTHULYDON  between vTuNgay and vDenNgay And v.THAMTRAVIENID=ITEM.v_CANBOID;
        v_ARRAY(ITEM.v_TT).v_TL_ANGDT:=vCount;    
      --CỘNG--   
         v_ARRAY(ITEM.v_TT).v_TL_CONG:=NVL(v_ARRAY(ITEM.v_TT).v_TL_DON_PTTC_CC,0)+NVL(v_ARRAY(ITEM.v_TT).v_TL_DON_8_1,0)+NVL(v_ARRAY(ITEM.v_TT).v_TL_ANGDT,0);
      --TRẢ LỜI ĐƠN--
      Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and v.GQD_LOAIKETQUA =0 And  v.GDQ_NGAY between vTuNgay and vDenNgay And v.THAMTRAVIENID=ITEM.v_CANBOID;
         v_ARRAY(ITEM.v_TT).v_TRALOIDON:=vCount;    
      --KHÁNG NGHỊ--
      Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and v.GQD_LOAIKETQUA =1 And  v.GDQ_NGAY between vTuNgay and vDenNgay And v.THAMTRAVIENID=ITEM.v_CANBOID;
         v_ARRAY(ITEM.v_TT).v_KHANGNGHI:=vCount;       
      --XÉT XỬ GĐT--
      Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID and v.NGAYXUGIAMDOCTHAM between vTuNgay and vDenNgay And v.THAMTRAVIENID=ITEM.v_CANBOID;
         v_ARRAY(ITEM.v_TT).v_TOTRINH_ANHDTP:=vCount;
      --ĐÃ TRÌNH CHƯA CÓ KQ-TRONG KỲ--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And (Select Count(ID) from GDTTT_TOTRINH where VUANID=v.ID And NGAYTRINH between vTuNgay and vDenNgay)>0;
         v_ARRAY(ITEM.v_TT).v_TRINH_TRONGKY:=vCount;            
      --ĐÃ TRÌNH CHƯA CÓ KQ-TỔNG SỐ--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And (Select Count(ID) from GDTTT_TOTRINH where VUANID=v.ID)>0;
         v_ARRAY(ITEM.v_TT).v_TRINH_TONGSO:=vCount;   

      --ĐANG NGHIÊN CỨU -TATC- Hồ sơ--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
            And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And NVL(v.ISHOSO,0)=1
            And NVL(v.ISTOTRINH,0)=0  And v.TOAPHUCTHAMID  in (4,5,6);
         v_ARRAY(ITEM.v_TT).v_DNC_CC_HS:=vCount;         
      --ĐANG NGHIÊN CỨU -TATC- Tiểu hồ sơ--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
            And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And NVL(v.ISHOSO,0)=0
            And NVL(v.ISTOTRINH,0)=0  And v.TOAPHUCTHAMID  in (4,5,6);
         v_ARRAY(ITEM.v_TT).v_DNC_CC_THS:=vCount;      
      --ĐANG NGHIÊN CỨU -TATC- Hồ sơ-Án Tỉnh--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID
            And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And NVL(v.ISHOSO,0)=1
            And NVL(v.ISTOTRINH,0)=0  And v.TOAPHUCTHAMID not in (4,5,6);
         v_ARRAY(ITEM.v_TT).v_DNC_TINH_HS:=vCount;         
      --ĐANG NGHIÊN CỨU -TATC- Tiểu hồ sơ--Án Tỉnh--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
            And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID And NVL(v.ISHOSO,0)=0 
            And NVL(v.ISTOTRINH,0)=0  And v.TOAPHUCTHAMID not in (4,5,6);
         v_ARRAY(ITEM.v_TT).v_DNC_TINH_THS:=vCount;       
      --ÁN GĐT CHƯA XỬ--
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And v.TRANGTHAIID =15 
          and v.XXGDTTT_KETQUAID is null  And v.THAMTRAVIENID=ITEM.v_CANBOID;
         v_ARRAY(ITEM.v_TT).v_AN_CHUAXU:=vCount; 

      ---an GDT-Tong cong    
       Select Count(v.ID) into vCount From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
            And v.TRANGTHAIID not in (13,14,16) and v.GQD_LOAIKETQUA is null
            And v.THAMTRAVIENID=ITEM.v_CANBOID 
            And NVL(v.ISTOTRINH,0)=0 ; 
         v_ARRAY(ITEM.v_TT).v_CONG:=vCount;   
		END LOOP;
  OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
END BAOCAO_THONGKE_CHITIEU;
 PROCEDURE BAOCAO_THONGKE_THULY_QH
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	) AS    
		v_ARRAY T_GDT_TKTLGQD_QH;
    r R_GDT_TKTLGQD_QH;
    v_TT number;
    vHS number;vDS number;vHC number;vHN number;vKT number;vLD number;vPS number;
    vCC_HN_ID number;vCC_DN_ID number;vCC_HCM_ID number;
	BEGIN	

  v_TT:=0;
  vCC_HN_ID:=4;
  vCC_DN_ID:=5;
  vCC_HCM_ID:=6;
  Select ISHINHSU,ISDANSU,ISHANHCHINH,ISHNGD,ISKDTM,ISLAODONG,ISPHASAN
        into vHS,vDS,vHC,vHN,vKT,vLD,vPS from DM_PHONGBAN Where ID=vPhongBanID;
  v_ARRAY:=T_GDT_TKTLGQD_QH();

  ----ÁN HÌNH SỰ---
  IF(vHS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;
  ----ÁN DÂN SỰ---
  IF(vDS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN HON nhan---
  IF(vHN=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
    ----ÁN KINH TẾ---
  IF(vKT=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;
  ----ÁN LAO ĐỌNG---
  IF(vLD=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN HÀNH CHÍNH---
  IF(vHC=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF;  
  ----ÁN PHÁ SẢN---
  IF(vPS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_HN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao DN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_DN_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Cấp cao HCMN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,vCC_HCM_ID,v_TT,r);
    v_ARRAY(v_TT):=r;
    --Tòa khác--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_THULY_QH(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,0,v_TT,r);
    v_ARRAY(v_TT):=r;
  END IF; 
	OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

	END BAOCAO_THONGKE_THULY_QH;  
PROCEDURE FILL_BAOCAO_THONGKE_THULY_QH
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  vToaRaBA_ID number,
  v_TT number,
  v_TKTL IN OUT R_GDT_TKTLGQD_QH
	)AS 
   v_TenLoaiAn nvarchar2(100);v_TenToa nvarchar2(100);
	v_TL_TONGSO NUMBER;
	v_TL_DBQH NUMBER;
	v_TL_UBTP NUMBER;
	v_TL_CQK NUMBER;
  v_TL_TW NUMBER;
  v_TLD_TONGSO NUMBER;
  v_TLD_DBQH NUMBER;
    v_TLD_UBTP NUMBER;
  v_TLD_CQK NUMBER;
  v_TLD_TW NUMBER;
  v_KN_TONGSO NUMBER;
  v_KN_DBQH NUMBER;
  v_KN_UBTP NUMBER;
  v_KN_CQK NUMBER;
  v_KN_TW NUMBER;
  v_CL_TONGSO NUMBER;
  v_CL_DBQH NUMBER;
  v_CL_UBTP NUMBER;
  v_CL_CQK NUMBER;
  v_CL_TW NUMBER;
  BEGIN	
  IF(vLoaiAn=1) THEN v_TenLoaiAn:='Hình sự';
  Elsif (vLoaiAn=2) THEN v_TenLoaiAn:='Dân sự';
  Elsif (vLoaiAn=3) THEN v_TenLoaiAn:='Hôn nhân gia đình';
  Elsif (vLoaiAn=4) THEN v_TenLoaiAn:='Kinh doanh thương mại';
  Elsif (vLoaiAn=5) THEN v_TenLoaiAn:='Lao động';
  Elsif (vLoaiAn=6) THEN v_TenLoaiAn:='Hành chính';
  Elsif (vLoaiAn=7) THEN v_TenLoaiAn:='Phá sản';
  End IF;
  IF(vToaRaBA_ID=4) THEN v_TenToa:='TACC HN';
  Elsif (vToaRaBA_ID=5) THEN v_TenToa:='TACC ĐN';
  Elsif (vToaRaBA_ID=6) THEN v_TenToa:='TACC HCM';
  Else  v_TenToa:='ĐƠN VỊ KHÁC';
  End IF;
  --TỔNG THỤ LÝ--
          Select Count(v.ID) into v_TL_TONGSO From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And  v.NGAYTHULYDON  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1;
  --THỤ LÝ -- ĐBQH--    
          Select Count(v.ID) into v_TL_DBQH From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And  v.NGAYTHULYDON  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN in (1025,1062))>0;        
v_TL_UBTP:=0;              
  --THỤ LÝ -- CQ KHÁC của QH--    
          Select Count(v.ID) into v_TL_CQK From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And  v.NGAYTHULYDON  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN =1063)>0;    
v_TL_TW:=0;         
  --TRẢ LỜI ĐƠN--
          Select Count(v.ID) into v_TLD_TONGSO From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And v.GQD_LOAIKETQUA=0 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1;
  -- -- ĐBQH--    
          Select Count(v.ID) into v_TLD_DBQH From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
             And v.GQD_LOAIKETQUA=0 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN in (1025,1062))>0;        
v_TLD_UBTP:=0;              
  --CQ KHÁC của QH--    
          Select Count(v.ID) into v_TLD_CQK From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
             And v.GQD_LOAIKETQUA=0 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN =1063)>0;    
v_TLD_TW:=0;         
  --KHÁNG NGHỊ--
          Select Count(v.ID) into v_KN_TONGSO From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
              And v.GQD_LOAIKETQUA=1 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1;
  -- -- ĐBQH--    
          Select Count(v.ID) into v_KN_DBQH From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
             And v.GQD_LOAIKETQUA=1 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN in (1025,1062))>0;        
v_KN_UBTP:=0;              
  --CQ KHÁC của QH--    
          Select Count(v.ID) into v_KN_CQK From GDTTT_VUAN v   Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
             And v.GQD_LOAIKETQUA=1 and  v.GDQ_NGAY  between vTuNgay and vDenNgay And v.ISANQUOCHOI=1
              And (Select Count(ID) from GDTTT_DON where VUVIECID=v.ID and LOAICONGVAN =1063)>0;    
v_KN_TW:=0;    

v_CL_TONGSO:=v_TL_TONGSO-v_TLD_TONGSO-v_KN_TONGSO;
v_CL_DBQH:=v_TL_DBQH-v_TLD_DBQH-v_KN_DBQH;
v_CL_UBTP:=v_TL_UBTP-v_TLD_UBTP-v_KN_UBTP;
v_CL_CQK:=v_TL_CQK-v_TLD_CQK-v_KN_CQK;
v_CL_TW:=v_TL_TW-v_TLD_TW-v_KN_TW;
v_TKTL:=R_GDT_TKTLGQD_QH(v_TT,v_TenLoaiAn,v_TenToa,	v_TL_TONGSO,
                            v_TL_DBQH ,
                            v_TL_UBTP ,
                            v_TL_CQK ,
                            v_TL_TW ,
                            v_TLD_TONGSO ,
                            v_TLD_DBQH ,
                            v_TLD_UBTP ,
                            v_TLD_CQK ,
                            v_TLD_TW ,
                            v_KN_TONGSO ,
                            v_KN_DBQH ,
                            v_KN_UBTP ,
                            v_KN_CQK ,
                            v_KN_TW ,
                            v_CL_TONGSO ,
                            v_CL_DBQH ,
                            v_CL_UBTP ,
                            v_CL_CQK ,
                            v_CL_TW );

  END FILL_BAOCAO_THONGKE_THULY_QH;  

	PROCEDURE BAOCAO_THONGKE_XETXU
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	) AS    
		v_ARRAY T_GDT_TKTLXX;
    r R_GDT_TKTLXX;
    v_TT number;
    vHS number;vDS number;vHC number;vHN number;vKT number;vLD number;vPS number;
	BEGIN	 
  v_TT:=0;
  Select ISHINHSU,ISDANSU,ISHANHCHINH,ISHNGD,ISKDTM,ISLAODONG,ISPHASAN
        into vHS,vDS,vHC,vHN,vKT,vLD,vPS from DM_PHONGBAN Where ID=vPhongBanID;
  v_ARRAY:=T_GDT_TKTLXX();
  ----ÁN HÌNH SỰ---
  IF(vHS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,1,v_TT,r); 
    v_ARRAY(v_TT):=r;  
  END IF;
  ----ÁN DÂN SỰ---
  IF(vDS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,2,v_TT,r);
    v_ARRAY(v_TT):=r;   
  END IF;  
  ----ÁN HON nhan---
  IF(vHN=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,3,v_TT,r);
    v_ARRAY(v_TT):=r;   
  END IF;  
    ----ÁN KINH TẾ---
  IF(vKT=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,4,v_TT,r);
    v_ARRAY(v_TT):=r;   
  END IF;
  ----ÁN LAO ĐỌNG---
  IF(vLD=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,5,v_TT,r);
    v_ARRAY(v_TT):=r;   
  END IF;  
  ----ÁN HÀNH CHÍNH---
  IF(vHC=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,6,v_TT,r);
    v_ARRAY(v_TT):=r;    
  END IF;  
  ----ÁN PHÁ SẢN---
  IF(vPS=1) THEN
   --Cấp cao HN--
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_BAOCAO_THONGKE_XETXU(vToaAnID,vPhongBanID,vTuNgay,vDenNgay,7,v_TT,r);
    v_ARRAY(v_TT):=r;    
  END IF;  
	OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);

	END BAOCAO_THONGKE_XETXU;

  PROCEDURE FILL_BAOCAO_THONGKE_XETXU
	(
  vToaAnID in number,
  vPhongBanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  v_TT number,
  v_TKTL IN OUT R_GDT_TKTLXX
	)AS 
   v_TenLoaiAn nvarchar2(100);
	v_CU_CAKN NUMBER;
	v_CU_VTKN NUMBER;
	v_TLM_CAKN NUMBER;
  v_TLM_VTKN NUMBER;
  v_TONGSO_CAKN NUMBER;
  v_TONGSO_VTKN NUMBER;
  v_RUTKN_CAKN NUMBER;
  v_RUTKN_VTKN NUMBER;
  v_DAXU_CAKN NUMBER;
  v_DAXU_VTKN NUMBER;
  v_CONLAI_CAKN NUMBER;
  v_CONLAI_VTKN NUMBER;

  v_KQXX_GIAOST NUMBER;
  v_KQXX_GIAOPT NUMBER;
  v_KQXX_HUY_ST_LAI NUMBER;
  v_KQXX_HUY_DINHCHI NUMBER;
  v_KQXX_HUYSTGDT_ST_LAI NUMBER;
  v_KQXX_HUYPT_GIU_ST NUMBER;
  v_KQXX_HUYGDT_GIU_ST NUMBER;
  v_KQXX_HUYGDT_GIU_PT NUMBER;

  v_KHONG_CNKN_CAKN NUMBER;
  v_KHONG_CNKN_VTKN NUMBER;
  BEGIN	
  IF(vLoaiAn=1) THEN v_TenLoaiAn:='Hình sự';
  Elsif (vLoaiAn=2) THEN v_TenLoaiAn:='Dân sự';
  Elsif (vLoaiAn=3) THEN v_TenLoaiAn:='Hôn nhân gia đình';
  Elsif (vLoaiAn=4) THEN v_TenLoaiAn:='Kinh doanh thương mại';
  Elsif (vLoaiAn=5) THEN v_TenLoaiAn:='Lao động';
  Elsif (vLoaiAn=6) THEN v_TenLoaiAn:='Hành chính';
  Elsif (vLoaiAn=7) THEN v_TenLoaiAn:='Phá sản';
  End IF;
  --CŨ CÒN LẠI- CAKN--
  Select Count(v.ID) into v_CU_CAKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn and v.TRANGTHAIID =15 and NVL(v.XXGDTTT_IsKetQua,0)=0
          And  v.NGAYTHULYXXGDT <vTuNgay And v.NGAYXUGIAMDOCTHAM>vTuNgay
                  And NVL(v.ISVIENTRUONGKN,0)=0;
  --CŨ CÒN LẠI-VTKN--
  Select Count(v.ID) into v_CU_VTKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn and v.TRANGTHAIID =15 and NVL(v.XXGDTTT_IsKetQua,0)=0
          And  v.NGAYTHULYXXGDT <vTuNgay And v.NGAYXUGIAMDOCTHAM>vTuNgay
                  And NVL(v.ISVIENTRUONGKN,0)=1;
  --THỤ LÝ MỚI- CAKN--
  Select Count(v.ID) into v_TLM_CAKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn and v.TRANGTHAIID =15 and NVL(v.XXGDTTT_IsKetQua,0)=0
          And  v.NGAYTHULYXXGDT BETWEEN vTuNgay And vDenNgay
                  And NVL(v.ISVIENTRUONGKN,0)=0;            
  --THỤ LÝ MỚI- VTKN--
  Select Count(v.ID) into v_TLM_VTKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn and v.TRANGTHAIID =15 and NVL(v.XXGDTTT_IsKetQua,0)=0
          And  v.NGAYTHULYXXGDT BETWEEN vTuNgay And vDenNgay
          And NVL(v.ISVIENTRUONGKN,0)=1;   
  v_TONGSO_CAKN:= v_CU_CAKN+v_TLM_CAKN;              
  v_TONGSO_VTKN:= v_CU_VTKN+v_TLM_VTKN;

  --RÚT KHÁNG NGHỊ--
    Select Count(v.ID) into v_RUTKN_CAKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn and v.TRANGTHAIID in (14,15) 
          And NVL(v.ISRUTKN,0)=1 And v.NGAYRUTKN BETWEEN vTuNgay And vDenNgay
          And NVL(v.ISVIENTRUONGKN,0)=0;   
    Select Count(v.ID) into v_RUTKN_VTKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
          And NVL(v.LOAIAN,0) =vLoaiAn  and v.TRANGTHAIID in (14,15) 
          And  NVL(v.ISRUTKN,0)=1 And v.NGAYRUTKN BETWEEN vTuNgay And vDenNgay
          And NVL(v.ISVIENTRUONGKN,0)=1;                    
  --ĐÃ XỬ--
      Select Count(v.ID) into v_DAXU_CAKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn
              and v.TRANGTHAIID =15 and NVL(v.XXGDTTT_IsKetQua,0)>0
              And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
              And NVL(v.ISVIENTRUONGKN,0)=0;   
    Select Count(v.ID) into v_DAXU_VTKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn
              and v.TRANGTHAIID =15  and NVL(v.XXGDTTT_IsKetQua,0)>0
              And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
              And NVL(v.ISVIENTRUONGKN,0)=1;   

  --CÒN LẠI--
  v_CONLAI_CAKN:=v_TONGSO_CAKN-v_RUTKN_CAKN-v_DAXU_CAKN;
  select (case when NVL(v_CONLAI_CAKN,0) <0 then 0 
            else v_CONLAI_CAKN end ) into v_CONLAI_CAKN from dual;
  v_CONLAI_VTKN:=v_TONGSO_VTKN-v_RUTKN_VTKN-v_DAXU_VTKN;
  select (case when NVL(v_CONLAI_VTKN,0) <0 then 0 
            else v_CONLAI_VTKN end ) into v_CONLAI_VTKN from dual;

  --KẾT QUẢ XÉT XỬ--  
  --Sửa toàn bộ bản án, quyết định của Tòa án đã có hiệu lực pháp luật--
   Select Count(v.ID) into v_KQXX_GIAOST From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1319;   

    --Hủy bản án, quyết định có hiệu lực pháp luật và đình chỉ giải quyết vụ án-
   Select Count(v.ID) into v_KQXX_GIAOPT From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1322;   

  --Hủy bản án, quyết định phúc thẩm, giữ nguyên bản án, quyết định sơ thẩm--
   Select Count(v.ID) into v_KQXX_HUY_ST_LAI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1323;   

  --Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định sơ thẩm--
   Select Count(v.ID) into v_KQXX_HUY_DINHCHI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1324;   

  -----Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định phúc thẩm-------------                
   Select Count(v.ID) into v_KQXX_HUYSTGDT_ST_LAI From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1325;       

  ------Hủy quyết định của giám đốc thẩm,bản án quyết định phúc thẩm,giữ nguyên bản án,quyết định sơ thẩm
   Select Count(v.ID) into  v_KQXX_HUYPT_GIU_ST From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1326;     

 -----------Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục sơ thẩm                 
   Select Count(v.ID) into v_KQXX_HUYGDT_GIU_ST From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1327;     

-----------Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục phúc thẩm                 
   Select Count(v.ID) into v_KQXX_HUYGDT_GIU_PT From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=1328;   


------------------------------------------------------------
   Select Count(v.ID) into v_KHONG_CNKN_CAKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn 
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=509  And NVL(v.ISVIENTRUONGKN,0)=0;    

   Select Count(v.ID) into v_KHONG_CNKN_VTKN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID And NVL(v.LOAIAN,0) =vLoaiAn
          and v.TRANGTHAIID =15 And  v.NGAYXUGIAMDOCTHAM BETWEEN vTuNgay And vDenNgay
                  And NVL(v.XXGDTTT_KETQUAID,0)=509  And NVL(v.ISVIENTRUONGKN,0)=1;    

  v_TKTL:=R_GDT_TKTLXX(v_TT,v_TenLoaiAn,
	v_CU_CAKN ,
	v_CU_VTKN ,
	v_TLM_CAKN ,
  v_TLM_VTKN ,
  v_TONGSO_CAKN ,
  v_TONGSO_VTKN ,
  v_RUTKN_CAKN ,
  v_RUTKN_VTKN ,
  v_DAXU_CAKN ,
  v_DAXU_VTKN ,
  v_CONLAI_CAKN ,
  v_CONLAI_VTKN ,
  v_KQXX_GIAOST ,
  v_KQXX_GIAOPT ,
  v_KQXX_HUY_ST_LAI ,
  v_KQXX_HUY_DINHCHI ,
  v_KQXX_HUYSTGDT_ST_LAI ,
  v_KQXX_HUYPT_GIU_ST ,
  v_KQXX_HUYGDT_GIU_ST,
  v_KQXX_HUYGDT_GIU_PT,
  v_KHONG_CNKN_CAKN ,
  v_KHONG_CNKN_VTKN);

  END FILL_BAOCAO_THONGKE_XETXU;  

  PROCEDURE THONGKE_THEO_THAMPHAN
	(
  vToaAnID in number,
  vThamphanID  in number,
  vTuNgay in date,
  vDenNgay in date,
  curReturn OUT SYS_REFCURSOR
	) AS    
		v_ARRAY T_GDTTT_BCTHAMPHAN;
    r R_GDTTT_BCTHAMPHAN;
    v_TT number;
  vTongso number;
  vHoso_Daco number;
  vHoso_Chuaco number;
    v_TTV_Daco number;
    v_TTV_Chuaco number;
  vTTV_Nghiencuu number;
  vTotrinh_Chuagiaiquyet number;  
  vTotrinh_CoYKienGQ number;
  v_Totrinh_DangKyBCTP number;
  vTotrinh_BaocaoTTP number;
  vTotrinh_Dagiaiquyet number;
  vKetqua_TLD number;
  vKetqua_KN number;
  vKetqua_Xepdon number;
  vKetqua_DTTLD number;
  vKetqua_DTKN number;
  v_Xetxu_TS number;
  vXetxu_ChuaXX number;
  vXetxu_DaXX number;
   v_Xetxu_ChuToa number;
  v_Xetxu_HDTT number;
  v_Xetxu_HD5 number;

  ma_chucvu varchar2(10);
  tp_IsHinhSu number; tp_IsHNGD number;
  tp_IsKDTM number;tp_IsDanSu number; 
  tp_IsHanhChinh number; tp_IsLaoDong number;

  curr_thamphan_id number;
  curr_tungay date;
  curr_denngay date;
	BEGIN	
    v_TT:=0;
    v_ARRAY:=T_GDTTT_BCTHAMPHAN();  

    --------------------------------
    select b.Ma , NVL(a.ISHinhSu,0), NVL(a.IsHNGD,0), NVL(a.IsKDTM,0)
          , NVL(a.IsDanSu,0),NVL(a.IsHanhChinh,0), NVL(a.IsLaoDong,0)
      into ma_chucvu , tp_IsHinhSu, tp_IsHNGD, tp_IsKDTM
          , tp_IsDanSu, tp_IsHanhChinh, tp_IsLaoDong
    from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;

    curr_thamphan_id:=0;  
    curr_tungay:= null;
    curr_denngay:= null;
    if  (ma_chucvu is null) or (NVL(ma_chucvu,'') <> 'PCA') then 
        curr_thamphan_id:= vThamphanID;
        curr_tungay:=vTuNgay;
        curr_denngay:=vDenNgay;
    end if;

 --Hinh su--
 if tp_IsHinhSu=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,1,v_TT,r); 
    v_ARRAY(v_TT):=r;  
  end if;

  ----ÁN DÂN SỰ---
 if tp_IsDanSu=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,2,v_TT,r);
    v_ARRAY(v_TT):=r;   
end if;

  ----ÁN HON nhan---
if tp_IsHNGD=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,3,v_TT,r);
    v_ARRAY(v_TT):=r;      
end if;

    ----ÁN KINH TẾ---
if tp_IsKDTM=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,4,v_TT,r);
    v_ARRAY(v_TT):=r;      
end if;

  ----ÁN LAO ĐỌNG---
if tp_IsLaoDong=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,5,v_TT,r);
    v_ARRAY(v_TT):=r;      
end if;

  ----ÁN HÀNH CHÍNH---
if tp_IsHanhChinh=1 then 
    v_ARRAY.extend();    
    v_TT:=v_TT+1;    
    FILL_THONGKE_THEO_THAMPHAN(vToaAnID,curr_thamphan_id,vThamphanID,curr_tungay,curr_denngay,6,v_TT,r);
    v_ARRAY(v_TT):=r;       
end if;

    --------------------------------------------
    Select Sum(v_Tongso) into vTongso FROM TABLE(v_ARRAY);
    Select Sum(v_Hoso_Daco) into vHoso_Daco FROM TABLE(v_ARRAY);
    Select Sum(v_Hoso_Chuaco) into vHoso_Chuaco FROM TABLE(v_ARRAY);

	  Select Sum(v_TTV_Daco) into v_TTV_Daco FROM TABLE(v_ARRAY);
	  Select Sum(v_TTV_Chuaco) into v_TTV_Chuaco FROM TABLE(v_ARRAY);
    Select Sum(v_TTV_Nghiencuu) into vTTV_Nghiencuu FROM TABLE(v_ARRAY);

    -----------------------------
    Select Sum(v_Totrinh_Chuagiaiquyet) into vTotrinh_Chuagiaiquyet FROM TABLE(v_ARRAY);      
    Select Sum(v_Totrinh_CoYKienGQ) into vTotrinh_CoYKienGQ FROM TABLE(v_ARRAY);  
    Select Sum(v_Totrinh_DangKyBCTP) into v_Totrinh_DangKyBCTP FROM TABLE(v_ARRAY);    
    Select Sum(v_Totrinh_BaocaoTTP) into vTotrinh_BaocaoTTP FROM TABLE(v_ARRAY);
    Select Sum(v_Totrinh_Dagiaiquyet) into vTotrinh_Dagiaiquyet FROM TABLE(v_ARRAY);
    -------------------------------
    Select Sum(v_Ketqua_TLD) into vKetqua_TLD FROM TABLE(v_ARRAY);
    Select Sum(v_Ketqua_KN) into vKetqua_KN FROM TABLE(v_ARRAY);
    Select Sum(v_Ketqua_Xepdon) into vKetqua_Xepdon FROM TABLE(v_ARRAY);
    Select Sum(v_Ketqua_DTTLD) into vKetqua_DTTLD FROM TABLE(v_ARRAY);
    Select Sum(v_Ketqua_DTKN) into vKetqua_DTKN FROM TABLE(v_ARRAY);
    ----------------------
    Select Sum(v_Xetxu_TS) into v_Xetxu_TS FROM TABLE(v_ARRAY);
    Select Sum(v_Xetxu_ChuaXX) into vXetxu_ChuaXX FROM TABLE(v_ARRAY);
    Select Sum(v_Xetxu_DaXX) into vXetxu_DaXX FROM TABLE(v_ARRAY);

    select Sum(v_Xetxu_ChuToa) into v_Xetxu_ChuToa FROM TABLE(v_ARRAY);
    Select Sum(v_Xetxu_HDTT) into v_Xetxu_HDTT FROM TABLE(v_ARRAY);
    Select Sum(v_Xetxu_HD5) into v_Xetxu_HD5 FROM TABLE(v_ARRAY);     
    -----------------------
   v_ARRAY.extend();    
    v_TT:=v_TT+1;
    r:=R_GDTTT_BCTHAMPHAN(0,'<span id="tong_cong_tp"> TỔNG CỘNG </span>',
                          vTongso ,

                          vHoso_Daco ,vHoso_Chuaco ,vTTV_Nghiencuu,

                          v_TTV_Daco,v_TTV_Chuaco ,                   

                          vTotrinh_Chuagiaiquyet ,vTotrinh_CoYKienGQ,
                          v_Totrinh_DangKyBCTP,
                          vTotrinh_BaocaoTTP ,

                          vTotrinh_Dagiaiquyet,
                          vKetqua_TLD ,vKetqua_KN ,vKetqua_Xepdon ,
                          vKetqua_DTTLD , vKetqua_DTKN ,                          

                          v_Xetxu_TS,
                          vXetxu_ChuaXX ,vXetxu_DaXX,
                          v_Xetxu_ChuToa, v_Xetxu_HDTT,v_Xetxu_HD5
                        );  
  v_ARRAY(v_TT):=r;
	OPEN curReturn FOR SELECT v_TT,PA.* FROM TABLE(v_ARRAY) PA;

	END THONGKE_THEO_THAMPHAN;
    PROCEDURE FILL_THONGKE_THEO_THAMPHAN
	(
  vToaAnID in number,
  vThamphanID  in number, vThamPhan_ChuToa_HD5_TT in number,
  vTuNgay in date,
  vDenNgay in date,
  vLoaiAn number,
  v_TT number,
  v_TKTL IN OUT R_GDTTT_BCTHAMPHAN
	)AS 
   v_TenLoaiAn nvarchar2(100);
	v_Tongso number;
  v_Hoso_Daco number;
  v_Hoso_Chuaco number;
    v_TTV_Daco number;
    v_TTV_Chuaco number;
  v_TTV_Nghiencuu number;
  v_Totrinh_Chuagiaiquyet number;
  v_Totrinh_CoYKienGQ number;
  v_Totrinh_DangKyBCTP number;
  v_Totrinh_DKTrinhTP number;
  v_Totrinh_BaocaoTTP number;
  v_Totrinh_Dagiaiquyet number;
  v_Ketqua_TLD number;
  v_Ketqua_KN number;
  v_Ketqua_Xepdon number;
  v_Ketqua_DTTLD number;
  v_Ketqua_DTKN number;
  v_Xetxu_TS number;
  v_Xetxu_ChuaXX number;
  v_Xetxu_DaXX number;
  v_Totrinh_TrinhPCA number;
  v_Totrinh_TrinhCA number;
  v_Totrinh_TrinhHDTP number;

  v_Xetxu_ChuToa number;
  v_Xetxu_HDTT number;
  v_Xetxu_HD5 number;

  BEGIN	
  IF(vLoaiAn=1) THEN v_TenLoaiAn:='Hình sự';
  Elsif (vLoaiAn=2) THEN v_TenLoaiAn:='Dân sự';
  Elsif (vLoaiAn=3) THEN v_TenLoaiAn:='Hôn nhân gia đình';
  Elsif (vLoaiAn=4) THEN v_TenLoaiAn:='Kinh doanh thương mại';
  Elsif (vLoaiAn=5) THEN v_TenLoaiAn:='Lao động';
  Elsif (vLoaiAn=6) THEN v_TenLoaiAn:='Hành chính';
  End IF;
  Select Count(v.ID) into v_Tongso From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   ;
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end;

   ----da phan cong TTV-----
    Select Count(v.ID) into v_TTV_Daco From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end    
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and (NVL(v.THAMTRAVIENID,0)>0 or LENGTH(NVL(V.TenThamTRaVien,''))>0 ) ;--and (NVL(v.TrangThaiID,0) not in (13,14,15,16));
  ----chua phan cong TTV-----
     Select Count(v.ID) into v_TTV_Chuaco From GDTTT_VUAN v
        Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end    
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.THAMTRAVIENID,0)=0  and (v.TenThamTraVien is null or Length(NVL(v.TenThamTraVien,0))=0);
	----------------------------------
  Select Count(v.ID) into v_Hoso_Daco From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.ISHOSO,0)>0;-- and (NVL(v.TrangThaiID,0) not in (13,14,15,16));
  Select Count(v.ID) into v_Hoso_Chuaco From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end    
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.ISHOSO,0)=0;-- and NVL(v.TrangthaiID,0) not in (13,14,15,16) ;  
  -------------------------------------
  Select Count(v.ID) into v_TTV_Nghiencuu From GDTTT_VUAN v
           Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.ThamTraVienID,0)>0  
                                and (NVL(v.IsHoSo,0)>0) and (NVL(v.ISToTrinh,0)=0)                               
                                and NVL(v.TrangThaiID,0) not in (13,14,15,16) ;
  -------------------------------------                              
  Select Count(v.ID) into v_Totrinh_Chuagiaiquyet From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end            
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.GQD_LOAIKETQUA,5) = 5 and v.TrangThaiID not in (13,14,15,16) 
            and NVL(v.ISToTrinh,0)>0  and GDTTT_TOTRINH_GETLASTTT(v.ID,1)=0;

Select Count(v.ID) into v_Totrinh_CoYKienGQ From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID  And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end            
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.GQD_LOAIKETQUA,5) = 5 and v.TrangThaiID not in (13,14,15,16)
            and NVL(v.ISToTrinh,0)>0 and GDTTT_TOTRINH_GETLASTTT(v.ID,1)>0;

  -----Co dang ky BC tham phan---------

        Select Count(v.ID) CountDKBCTP into v_Totrinh_DangKyBCTP
          --, GDTTT_ToTrinh_GetLastByDK(v.ID, 6, 'NGAYDK') NgayDKBC 
          From GDTTT_VUAN v
         Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end            
            and NVL(v.GQD_LOAIKETQUA,5) = 5  and NVL(v.TrangThaiID ,1) =6 
            and GDTTT_ToTrinh_GetLastByDK(v.ID, 6, 'NGAYDK') is not null;

  -----Bao cao TTP,HDTP,CA,PCA---------------
   Select Count(v.ID) into v_Totrinh_BaocaoTTP From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and NVL(v.GQD_LOAIKETQUA,5) = 5 and v.TrangThaiID not in (13,14,16)  and NVL(v.ISToTrinh,0)>0 
            And v.TRANGTHAIID in (7,8,9,17);

  --------------------------------------------------------------
  Select Count(v.ID) into v_Ketqua_TLD From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID  =13;  
  Select Count(v.ID) into v_Ketqua_KN From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and (NVL(v.GQD_LOAIKETQUA,5) = 1 or v.TrangThaiID in (14,15));
           -- and v.TrangThaiID  =14;              
  Select Count(v.ID) into v_Ketqua_Xepdon From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID  =16;  
  Select Count(v.ID) into v_Ketqua_DTTLD From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end        
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID =11;  
  Select Count(v.ID) into v_Ketqua_DTKN From GDTTT_VUAN v
           Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end    
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID  =12;  

   -----To trinh -da giai quyet, chua xet xu GDTTT---------------   
   select (NVL(v_Ketqua_TLD,0) + NVL(v_Ketqua_KN,0)
            + NVL(v_Ketqua_Xepdon,0) + NVL(v_Ketqua_DTTLD,0) 
            + NVL(v_Ketqua_DTKN,0)) into v_Totrinh_Dagiaiquyet from dual;  
  --------------------------------------------------------------
  ---TS khang nghi : CA +VKS
     Select Count(v.ID) into v_Xetxu_TS From GDTTT_VUAN v
         Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and (NVL(v.GQD_LOAIKETQUA,5) = 1 or v.TrangThaiID in (14,15));
  ---------------------------
  Select Count(v.ID) into v_Xetxu_ChuaXX From GDTTT_VUAN v
     Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end   
            --and 1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID =15  and GDTTT_XXGDTTT_GetLastXX(v.ID, 0)=0;
  ---------------------------
  Select Count(v.ID) into v_Xetxu_DaXX From GDTTT_VUAN v
      Where v.TOAANID=vToaAnID And NVL(v.LOAIAN,0) =vLoaiAn 
            and 1=case when vThamphanID = 0 then 1
                       when vThamphanID>0 and v.THAMPHANID=vThamphanID then 1 end    
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end           
            and v.TrangThaiID = 15  and GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0;
  -------HDTP - Chu toa: vu an da xet xu-------------------------- 
   Select Count(v.ID) into v_Xetxu_ChuToa From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID  And NVL(v.LOAIAN,0) =vLoaiAn and v.LoaiAn<>7
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID=15 and GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0
            and (select count(ID) from GDTTT_VuAn_XXGDTT_HoiDong 
                  where VuAnId= v.ID and NVL(IsChuToa,0)=1 
                      and 1=case when vThamphanID = 0 and CanBoID=vThamPhan_ChuToa_HD5_TT then 1
                                 when vThamphanID>0 and CanBoID=vThamphanID then 1 end)>0 ;
  --------HDTT-------------------          
  Select Count(v.ID) into v_Xetxu_HDTT From GDTTT_VUAN v
  Where v.TOAANID=vToaAnID  And NVL(v.LOAIAN,0) =vLoaiAn 
            --and 1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID =15 and GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0
            and (select count(ID) from GDTTT_VuAn_XXGDTT_HoiDong 
                  where VuAnId= v.ID  and TypeHD=1
                      and 1=case when vThamphanID = 0 and CanBoID=vThamPhan_ChuToa_HD5_TT then 1
                                 when vThamphanID>0 and CanBoID=vThamphanID then 1 end)>0 ;    
  --------HT5-------------------
  Select Count(v.ID) into v_Xetxu_HD5 From GDTTT_VUAN v
          Where v.TOAANID=vToaAnID  And NVL(v.LOAIAN,0) =vLoaiAn 
            --and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NGAYTHULYDON then 1 else 0 end
            --and 1=case when vDenNgay is null then 1 when v.NGAYTHULYDON <= vDenNgay then 1 else 0 end
            and v.TrangThaiID =15 and GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0
            and (select count(ID) from GDTTT_VuAn_XXGDTT_HoiDong 
                  where VuAnId= v.ID and TypeHD=2
                      and 1=case when vThamphanID = 0 and CanBoID=vThamPhan_ChuToa_HD5_TT  then 1
                                 when vThamphanID>0 and CanBoID=vThamphanID then 1 end)>0 ;  

   ---------------------------------              
 v_TKTL:=R_GDTTT_BCTHAMPHAN(vLoaiAn,v_TenLoaiAn,
	v_Tongso ,
	v_Hoso_Daco , v_Hoso_Chuaco  ,v_TTV_Nghiencuu ,
    v_TTV_Daco , v_TTV_Chuaco ,

  v_Totrinh_Chuagiaiquyet ,v_Totrinh_CoYKienGQ,
  v_Totrinh_DangKyBCTP,
  v_Totrinh_BaocaoTTP ,
  v_Totrinh_Dagiaiquyet ,

  v_Ketqua_TLD ,
  v_Ketqua_KN ,
  v_Ketqua_Xepdon ,
  v_Ketqua_DTTLD , v_Ketqua_DTKN ,

  v_Xetxu_TS ,
  v_Xetxu_ChuaXX ,  v_Xetxu_DaXX,  
  v_Xetxu_ChuToa,  v_Xetxu_HDTT, v_Xetxu_HD5
  );

  END FILL_THONGKE_THEO_THAMPHAN;     
END PKG_GDTTT;