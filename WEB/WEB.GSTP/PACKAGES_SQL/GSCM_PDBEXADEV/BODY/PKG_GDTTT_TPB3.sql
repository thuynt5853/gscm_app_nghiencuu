create or replace PACKAGE BODY        "PKG_GDTTT_TPB3" AS


PROCEDURE TONGDON_TP3_GETBYDONVI
( vToaAnID in number,
  vPhongBanId in number, 
  vNamTL  in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
    vGroupChucDanhID number;
     vN number;
     vTT number;
     vNGAY_GQD DATE; --//Thơi gian duoc phan cong giai quyet don
     vDAUKY DATE; --//Thơi gian đâu kỳ của năm hiện tại

BEGIN
    vN:=vNamTL;
    select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';

 OPEN curReturn FOR 
     SELECT 
            ROW_NUMBER() OVER (ORDER BY 
                        CASE
                            WHEN cv.TEN LIKE '%Vụ trưởng%' AND cv.TEN NOT LIKE 'Phó%' THEN 1
                            WHEN cv.TEN LIKE '%Phó%' THEN 2
                            ELSE 3
                        END, cb.hoten) AS STT,
                    cb.hoten || Decode(cv.TEN, null, '', ' (' || cv.TEN || ')') AS HOTEN_CHUCVU,
                    COUNT(d.ID) AS SO_LUONG, 
                    pb.tenphongban
                FROM DM_CANBO cb
                -- 1. Lấy chức vụ và chức danh (Bắt buộc phải có để hiển thị tên)
                INNER JOIN (
                    SELECT i.ID, i.TEN FROM DM_DATAITEM i 
                    WHERE i.GROUPID = 12 AND i.MA IN ('TPBAC3')
                ) d1 ON d1.ID = cb.CHUCDANHID
                LEFT JOIN (
                    SELECT i.ID, i.TEN FROM DM_DATAITEM i 
                    WHERE i.GROUPID = 13
                ) cv ON cv.ID = cb.CHUCVUID
                LEFT JOIN dm_phongban pb ON pb.id = cb.phongbanid
                
                -- 2. LEFT JOIN với bảng đơn (Điều kiện thời gian phải nằm ở đây)
                LEFT JOIN GDTTT_DON d ON d.THAMPHANID = cb.id 
                    AND d.BAQD_LOAIAN = 2
                    AND d.TOAANID = 1 -- Lọc đơn của tòa án 1
                    AND d.NGAYTAO BETWEEN TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                                        And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                -- 3. Điều kiện lọc Cán bộ (Đơn vị công tác)
                WHERE cb.TOAANID = vToaAnID -- Đảm bảo chỉ lấy cán bộ thuộc Tòa án này
                  AND cb.phongbanid = vPhongBanId
                  AND cb.hieuluc = 1 -- Ví dụ: Chỉ lấy cán bộ đang làm việc
                
                GROUP BY cb.hoten, cv.TEN, pb.tenphongban
                ORDER BY STT;     
       
END TONGDON_TP3_GETBYDONVI;

FUNCTION PHANCONGCHIDINH
    ( vToaAnID in number,
      vTuNgay in date,
      vDenNgay in date,
      vNguoiNhap in varchar2,
      varrLoaiAn in varchar2,
      vNguoithuchien varchar2,
      vNguoithuchienID in number,
      vDs varchar,
      vLoaithamphan varchar2,
      vThamphan number
    )RETURN number AS
     vGroupChucDanhID number;
     vTT number;
     vRand number;
     vKetQuaID number;
     vKetQuaChiTietID number;
     vLoaiAn number;

     vVuAnID number; 
     vNgayPhanCongTP date;V_NGAYBONHIEM DATE;V_NGAY_GQD date;
     v_dem NUMBER:=0; --anhvh dùng ?? test  
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select SYSTIMESTAMP into vNgayPhanCongTP from dual;   

   /*L?u thông tin l?n phân công*/
    vKetQuaID:=GDTTT_PCTP_KETQUA_CHIDINH_SEQ.nextval;
--   vC:=round(sysdate - TO_DATE('11/09/2020','dd/MM/yyyy'),0);
   Insert into GDTTT_PCTP_KETQUA_CHIDINH
   VALUES(vKetQuaID,vNgayPhanCongTP,vNguoithuchien,null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchienID,null,0,vLoaithamphan);  

   /*L?y danh sách ??n  ?? phân công*/
    FOR i IN (Select  d.ID,d.BAQD_LOAIAN,d.BAQD_SO,d.BAQD_NGAYBA,d.BAQD_TOAANID
                                        ,d.BAQD_SO_PT,d.BAQD_NGAYBA_PT,d.BAQD_TOAANID_PT
                                        ,d.BAQD_SO_ST,d.BAQD_NGAYBA_ST,d.BAQD_TOAANID_ST,d.isTPB3 INVALID  
                from GDTTT_DON d 
                where d.TOAANID=vToaAnID 
                and 1=case when vDs || ' '=' ' then 1 when  lower(vDs) like ('%,' || lower(d.ID)|| ',%') then 1 else 0 end)

    LOOP  
        v_dem:=v_dem+1;
        --Insert lan phan cong voi don
          Insert Into GDTTT_PCTP_CHITIET_CHIDINH(ID,TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP)
            Values(GDTTT_PCTP_KETQUA_CHITIET_CHIDINH_SEQ.nextval,vToaAnID,vKetQuaID,i.ID,vThamphan,sysdate);
         -- Cap nhat Tham phan vao Don su khi phan cong và c?p nh?t ??n là phân công ch? ??nh
           Update GDTTT_DON Set THAMPHANID=vThamphan,isChiDinh = 1 Where ID=i.ID;

     END LOOP;
     COMMIT;
   Return vKetQuaID;
  END PHANCONGCHIDINH;


FUNCTION PHANCONGNGAUNHIEN_TPB3
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
     vA number;/*T?ng s? ??n ??n th?i ?i?m hi?n t?i*/
     vA1 number;/*T?ng s? v? án ??n th?i ?i?m hi?n t?i*/
     vB number;/*T?ng s? th?m phán*/
     vC number;/*S? ngày ??n th?i ?i?m hi?n t?i*/
     vD number;/*S? ngày ngh? phép, công tác*/
     vE number;/*S? ??n c?a th?m phán ?ã ???c phân công*/
     vE1 number;/*S? v? án c?a th?m phán ?ã ???c phân công*/
     vY number;/*Tr?ng s? s?p x?p*/
     vCT number;/*gán ??n cho th?m phán ?ã ???c phân công tr??c ?ây(??n th? lý m?i l?n th? >1)*/
     vF  number;--T?ng s? ngày th?m phán không ???c quy?n gi?i quy?t ??n
     vN number;
     vVuAnID number; 
     vNgayPhanCongTP date;V_NGAYBONHIEM DATE;V_NGAY_GQD date;
     v_dem NUMBER:=0; --anhvh dùng ?? test
     vNGAY_GQD DATE; --//Th?i gian duoc phan cong giai quyet don
     vDAUKY DATE; --//Th?i gian ?âu k? c?a n?m hi?n t?i
     vChucVu_TPB3 number; --//Ma chuc vu
BEGIN
  vN:=EXTRACT(YEAR FROM vDenNgay);
  --DELETE GDTTT_PCTP_CHITIET_TEST;
  --COMMIT;
  if(to_char(vDenNgay,'mm')='12') then
      vN:=vN+1;
  end if;
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select SYSTIMESTAMP into vNgayPhanCongTP from dual;

   /*L?u thông tin l?n phân công*/
    vKetQuaID:=GDTTT_PCTP_KETQUA_SEQ.nextval;
    vC:=TO_CHAR(vDenNgay, 'DDD');
--   vC:=round(sysdate - TO_DATE('11/09/2020','dd/MM/yyyy'),0);
   Insert into GDTTT_PCTP_KETQUA 
   VALUES(vKetQuaID,vNgayPhanCongTP,'',null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchien,null,0);         
   --VALUES(vKetQuaID,(SELECT SYSTIMESTAMP FROM DUAL),'',null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchien,null,0);         

   /*L?y danh sách ??n ng?u nhiên ?? phân công*/
    FOR i IN (Select  d.ID,d.BAQD_LOAIAN,d.BAQD_SO,d.BAQD_NGAYBA,d.BAQD_TOAANID,d.CD_TA_DONVIID
                                        ,d.BAQD_SO_PT,d.BAQD_NGAYBA_PT,d.BAQD_TOAANID_PT
                                        ,d.BAQD_SO_ST,d.BAQD_NGAYBA_ST,d.BAQD_TOAANID_ST  
                from GDTTT_DON d where d.TOAANID=vToaAnID 
--                and d.LOAIDON <=3 manhnd bo do co nhieu loai don h?n
                and NVL(d.THAMPHANID,0)=0 
                and   (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vDenNgay then 1 else 0 end)
                Or ( 1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vDenNgay then 1 else 0 end))
                       and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
               and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
                                 and d.CD_LOAI=0 and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
                and d.isTPB3 = 1 --Don cua tham phan b?c 3
                Order by DBMS_RANDOM.VALUE)
    LOOP  
    v_dem:=v_dem+1;
      /*Ki?m tra xem ?ã phân th?m phán x? lý ??n trùng tr??c ?ó ch?a*/
      vThamphanID:=NVL(vThamphanID,0); 
      SELECT COUNT(b.ID) into vCT FROM GDTTT_DON b 
          LEFT JOIN DM_CANBO C ON C.ID=b.THAMPHANID and c.PHONGBANID = b.CD_TA_DONVIID --dieppv ch? l?y th?m phán thu?c phòng ban c?a ??n v? chuy?n ??n (thu?c ??n ?ang xét)
          where NVL(THAMPHANID,0)>0 
                And b.isTPB3 = 1 --Don cua tham phan b?c 3
                And b.ID<>i.ID 
                And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu 
                And b.isthuly = 1 -- Don thu ly moi
                And b.CD_LOAI = 0 --Noi chuyen Noi bo
--                  Lay ra TP dang xet xu và TP dung xet xu nhung con don dang giai quyet
                    AND ( C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet x?
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
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID
                                                and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                         )       
                        ;
      vCT:=NVL(vCT,0); 
      if(vCT>0) Then/*gán ??n cho th?m phán ?ã ???c phân công tr??c ?ây(??n th? lý m?i l?n th? >1)*/
        SELECT THAMPHANID into vThamphanID  FROM 
        (SELECT THAMPHANID FROM GDTTT_DON b 
         LEFT JOIN DM_CANBO C ON C.ID=b.THAMPHANID and c.PHONGBANID = b.CD_TA_DONVIID --dieppv ch? l?y th?m phán thu?c phòng ban c?a ??n v? chuy?n ??n (thu?c ??n ?ang xét)
            where NVL(THAMPHANID,0)>0 

                    And b.isTPB3 = 1 --Don cua tham phan b?c 3
                    And b.ID<>i.ID
                    And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu
                    And b.isthuly = 1 -- Don thu ly moi
                    And b.CD_LOAI = 0 --Noi chuyen Noi bo
--                  Lay ra TP dang xet xu và TP dung xet xu nhung con don dang giai quyet
                    AND ( C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet x?
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
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID
                                                and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                         )    
        ORDER BY b.NGAYTAO desc) WHERE ROWNUM = 1;
          vThamphanID:=NVL(vThamphanID,0); 
          Insert Into GDTTT_PCTP_CHITIET(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP)
            Values(vToaAnID,vKetQuaID,i.ID,vThamphanID,sysdate);
          Update GDTTT_DON Set THAMPHANID=vThamphanID Where ID=i.ID;
          ----------anhvh add ?? test GDTTT_PCTP_CHITIET_TEST
           Insert Into GDTTT_PCTP_CHITIET_TEST(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP,GHICHU)
          Values(vToaAnID,vKetQuaID,i.ID,vThamphanID,sysdate,
          '(VY:'||round(VY,5)||')(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')'
          ||'(vF:'||vF||')(DEM:'||v_dem||')?ã PCTP tr??c ?ó');
          ---------
      Else  
      vLoaiAn:=i.BAQD_LOAIAN;
      /*Tính t?ng s? ??n ?ã phân công gi?i quy?t*/    
      Select Count(d.ID) into vA from GDTTT_DON d  
         where d.TOAANID=vToaAnID 
                And d.isTPB3 = 1 --Don cua tham phan b?c 3
--            and d.LOAIDON <=3 manhnd bo do co nhieu loai don h?n
                and NVL(d.THAMPHANID,0)>0 
              And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD')
              and 1=(Case When (vLoaiAn=1 and d.BAQD_LOAIAN=1) Then 1 When (vLoaiAn=2 and d.BAQD_LOAIAN=2) Then 1
               When (vLoaiAn=6 and d.BAQD_LOAIAN=6) Then 1 When (vLoaiAn in (3,4,5,7) and d.BAQD_LOAIAN  in (3,4,5,7)) Then 1 Else 0 End);

      /*Tính t?ng s? v? án ?ã phân công gi?i quy?t*/    
      Select Count(d.ID) into vA1 
        from GDTTT_DON d
        JOIN GDTTT_VUAN v on d.VUVIECID = v.ID
        JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and NVL(ctc.THAMPHANID,0) = 0 and ctc.TRANGTHAI = 2 --HCTP ?ã nh?n
         where d.TOAANID=vToaAnID 
            And d.isTPB3 = 0 --Don cua tham phan t?i cao
                and NVL(d.THAMPHANID,0)>0 
              And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD')
              and 1=(Case When (vLoaiAn=1 and d.BAQD_LOAIAN=1) Then 1 When (vLoaiAn=2 and d.BAQD_LOAIAN=2) Then 1
               When (vLoaiAn=6 and d.BAQD_LOAIAN=6) Then 1 When (vLoaiAn in (3,4,5,7) and d.BAQD_LOAIAN  in (3,4,5,7)) Then 1 Else 0 End);

       vA1:= NVL(vA1,0);
       vA:=NVL(vA,0);
       vA:= (vA + vA1);

      /*Tính t?ng s? th?m phán*/
      Select Count(c.ID) into vB From DM_CANBO c 
        inner join (select i.ID,i.TEN from DM_DATAITEM i 
                    where i.GROUPID=vGroupChucDanhID and i.MA in ('TPBAC3')--'TP','TPSC','TPTC','TPCC', ch? l?y th?m phán t?i cao
                    ) d1 on d1.ID=c.CHUCDANHID 
      WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet x?
      and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai l? TP D??ng v?n Th?ng v?n ???c phân án     
      AND NVL(c.CHUCVUID,0)<>45 --45 ch?c v? chánh án
      AND c.PHONGBANID = i.CD_TA_DONVIID -- dieppv l?y th?m phán thu?c phòng ban c?a ??n v? chuy?n ??n
--          And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
--                      WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
--                      WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
--                      WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
--                      WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
--                      WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
--                      WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
--          Else 0 End)
          ;          
     vB:=NVL(vB,0);
     vTT:=0;

     /*T?o danh sách th?m phán dùng phân công*/
      DELETE from GDTTT_PCTP_TMP where TOAANID=vToaAnID;
      FOR j in (
          Select c.ID into vB From DM_CANBO c 
          inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TPBAC3')) d1 on d1.ID=c.CHUCDANHID -- ch? l?y th?m phán b?c 3
          WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1
              and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai l? TP D??ng v?n Th?ng v?n ???c phân án     
              AND NVL(c.CHUCVUID,0)<>45 --45 ch?c v? chánh án
              AND c.PHONGBANID = i.CD_TA_DONVIID -- dieppv l?y th?m phán thu?c phòng ban c?a ??n v? chuy?n ??n
--              And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
--                          WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
--                          WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
--                          WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
--                          WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
--                          WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
--                          WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
--                    Else 0 End)     
          )
      LOOP  vTT:=vTT+1;

        /*T?ng s? ngày ngh? phép trong n?m*/
        Select SUM(c.SONGAY) into vD From DM_CANBO_CONGTAC c 
        where TOAANID=vToaAnID AND c.CANBOID=j.ID
          and c.TUNGAY between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD')
                           and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD');
        vD:=NVL(vD,0);

        /*T?ng s? ??n ?ã ???c phân công*/
        Select Count(d.ID) into vE from GDTTT_DON d 
        LEFT JOIN GDTTT_PCTP_CHITIET CT ON CT.DONID=D.ID
        where d.TOAANID=vToaAnID 
            and d.THAMPHANID=j.ID 
            And d.isTPB3 = 1 --Don cua tham phan b?c 3
         And d.NGAYTAO--CT.NGAYPHANCONGTP
         between TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
         And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"');/*TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD')  and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD');*/

        /*T?ng s? v? án kháng ngh? ?ã ???c phân công cho TPTC ?ang xét*/
        Select Count(d.ID) into vE1 
        from GDTTT_DON d 
        JOIN GDTTT_VUAN v on d.VUVIECID = v.ID
        JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and ctc.TRANGTHAI = 2 --HCTP ?ã nh?n
        where d.TOAANID=vToaAnID and ctc.THAMPHANID=j.ID 
         And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
         And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"');
         ------------

        vE:=NVL(vE,0);      
        --T?ng s? ngày không ???c quy?n gi?i quy?t ??n trong n?m
        SELECT NGAY_GQD INTO vNGAY_GQD FROM DM_CANBO cb where  cb.id=j.ID;
        --Ngay thang dau ky c?a n?m hi?n t?i
            vDAUKY := TO_DATE(to_char(vN - 1)||'-12-01T23:54:14Z','YYYY-MM-DD"T"HH24:MI:SS"Z"');
--      N?u ngày ph?n công ?úng trong k? n?m hi?n t?i thì l?y theo ngày ???c gi?i quy?t; N?u tr??c ngày n?m hi?n t?i m?c ??nh không m?t ngày nào   
        IF (vNGAY_GQD > vDAUKY) THEN
            SELECT TO_CHAR(NGAY_GQD, 'DDD') INTO vF FROM DM_CANBO cb where  cb.id=j.ID;
        ELSE
            vF := 1;
        END IF;

        vE:=NVL(vE,0);
        vE1:=NVL(vE1,0);
        vE:=(vE+vE1);
        --Kiem tra neu TP bac 3 la Vu truong thi giai quyet 1 vụ = 5 vụ của TP bac 3 khong chuc vụ
        --TP bac 3 la Pho Vu truong thi giai quyet 1 vu = 3 vụ của TP bac 3 khong chuc vu
        select c.id into vChucVu_TPB3 from DM_DATAITEM c 
                left join DM_CANBO cb on cb.chucvuid = c.id
                where c.GROUPID=13 and cb.id = j.ID; 
        if(vChucVu_TPB3 = 432)then
            vE := vE*5;
        elsif (vChucVu_TPB3 = 424)then
            vE := vE*3;
        end if;
        
        --tính tr?ng s? cho t?ng th?m phán
--        vY:=vE-(vC-vD)*vA*1.0/(vB*vC*1.0);
         vY:=vE/(vC-vD-vF)-(vA/(vB*vC));
--        vA number;/*T?ng s? ??n ??n th?i ?i?m hi?n t?i*/
--        vB number;/*T?ng s? th?m phán*/
--        vC number;/*S? ngày ??n th?i ?i?m hi?n t?i*/
--        vD number;/*S? ngày ngh? phép, công tác*/
--        vE number;/*S? ??n c?a th?m phán ?ã ???c phân công*/
--        vY number;/*Tr?ng s? s?p x?p*/
--        vCT number;/*Tr?ng s? s?p x?p*/
         Insert into GDTTT_PCTP_TMP VALUES(vToaAnID,j.ID,vY,Cast((vE) as varchar2(10)) || '-(' || Cast((vC) as varchar2(10))||'-'|| Cast((vD) as varchar2(10)) || ')*' ||  Cast((vA) as varchar2(10)) || '*1.0/' ||  Cast((vB) as varchar2(10)) || '*' || Cast((vC) as varchar2(10)),'(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')(VY:'||VY||')(id:'||j.ID||')');
         ----------anhvh add ?? test GDTTT_PCTP_CHITIET_TEST
          Insert Into GDTTT_PCTP_CHITIET_TEST(TOAANID,KETQUAID,DONID,CANBOID,NGAYPHANCONGTP,GHICHU)
          Values(vToaAnID,vKetQuaID,i.ID,j.ID,sysdate,
          '(VY:'||round(VY,5)||')(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')'
          ||'(vF:'||vF||')(DEM:'||v_dem||')(j.ID:'||j.ID||')');
          -----------------------
      END LOOP;

      /*L?y th?m phán có tr?ng s? th?p nh?t*/
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
  END PHANCONGNGAUNHIEN_TPB3;


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
  vHinhThuc in number,
    vNgayTL in date,      
    vSoThuLy in varchar2,
    vSoBAQD in varchar2,
	curReturn OUT sys_refcursor
)
IS 
    vvDenNgay date;
BEGIN

SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvDenNgay from dual;

  OPEN curReturn FOR
  Select d.ID,d.MADON,decode(d.NGUOIGUI_HOTEN,null,d.CV_TENDONVI,d.NGUOIGUI_HOTEN) NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      case when d.NGUOISUA is null then d.NGUOITAO else d.NGUOISUA end as NguoiNhap,
      case when d.NGAYSUA is null then d.NGAYTAO else d.NGAYSUA end as NgayNhap,
      case d.LOAIDON when 1 then '??n' when 2 then '??n t? cáo' when 3 then '??n + Công v?n' end as HinhThuc
      ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_SO Else d.KN_SOQD END) BAQD
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_NGAYBA Else d.KN_NGAY END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then ('Q?: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
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
      ,d.isTPB3 as INVALID
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID      
       left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
       left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
       left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
    where d.TOAANID=vToaAnID 
        --and d.LOAIDON in(11,1,31,32,2,6,9,4) 
        and NVL(d.THAMPHANID,0)=0
       and (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vvDenNgay then 1 else 0 end)
        Or ( 1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vvDenNgay then 1 else 0 end))
       and d.CD_LOAI=0  and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
       and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
       and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
     -- là TPB3
       and d.isTPB3 = 1
       and (vSoThuLy is null or d.TL_SO = vSoThuLy)
       and (vNgayTL is null or d.TL_NGAY = vNgayTL)
       and (vSoBAQD is null or (d.BAQD_SO = vSoBAQD or d.BAQD_SO_PT = vSoBAQD or d.BAQD_SO_ST = vSoBAQD or d.KN_SOQD = vSoBAQD))

       Order by d.NGAYTAO desc;        
END DON_GETCHUAPCTP;

PROCEDURE get_ds_thamphan (
        vloaitp   IN VARCHAR2,
        vtoaanid  IN NUMBER,
        vphongbanid in number,
        curReturn OUT SYS_REFCURSOR
    ) IS
    BEGIN
    if vphongbanid=0 then
        OPEN curReturn FOR SELECT
                                                  c.id,
                                                  c.macanbo,
                                                  c.hoten,
                                                  c.chucdanhid,
                                                  c.chucvuid,
                                                  C.PHONGBANID,
                                                  c.hoten ||' - '|| to_char(C.NGAYSINH,'dd/MM/yyyy') as hotenngaysinh,
                                                  ( (
                                                      CASE c.ishinhsu
                                                          WHEN 1 THEN
                                                              'HS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isdansu
                                                          WHEN 1 THEN
                                                              'DS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.ishngd
                                                          WHEN 1 THEN
                                                              'HN, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.iskdtm
                                                          WHEN 1 THEN
                                                              'KD, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.islaodong
                                                          WHEN 1 THEN
                                                              'L?, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.ishanhchinh
                                                          WHEN 1 THEN
                                                              'HC, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isphasan
                                                          WHEN 1 THEN
                                                              'PS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isbpxlhc
                                                          WHEN 1 THEN
                                                              'XLHC'
                                                          ELSE
                                                              ''
                                                      END
                                                  ) ) linhvuc
                                              FROM
                                                  dm_canbo    c
                                                  LEFT JOIN dm_dataitem b ON c.chucdanhid = b.id
                           WHERE
                               ( ( vloaitp = '0'
                                   AND b.ma = 'TPTATC' )
                                 OR ( vloaitp = '1'
                                      AND b.ma = 'TPBAC3' )
                                 OR ( vloaitp = '3' ) )
                              AND c.toaanid = vtoaanid
                               AND c.hieuluc = 1
                               AND c.trangthai_xetxu = 1;
    else 
        OPEN curReturn FOR SELECT
                                                  c.id,
                                                  c.macanbo,
                                                  c.hoten ||' - '|| to_char(C.NGAYSINH,'dd/MM/yyyy') as hotenngaysinh,
                                                  c.chucdanhid,
                                                  c.chucvuid,
                                                  C.PHONGBANID,
                                                  ( (
                                                      CASE c.ishinhsu
                                                          WHEN 1 THEN
                                                              'HS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isdansu
                                                          WHEN 1 THEN
                                                              'DS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.ishngd
                                                          WHEN 1 THEN
                                                              'HN, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.iskdtm
                                                          WHEN 1 THEN
                                                              'KD, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.islaodong
                                                          WHEN 1 THEN
                                                              'L?, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.ishanhchinh
                                                          WHEN 1 THEN
                                                              'HC, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isphasan
                                                          WHEN 1 THEN
                                                              'PS, '
                                                          ELSE
                                                              ''
                                                      END
                                                  )
                                                    || (
                                                      CASE c.isbpxlhc
                                                          WHEN 1 THEN
                                                              'XLHC'
                                                          ELSE
                                                              ''
                                                      END
                                                  ) ) linhvuc
                                              FROM
                                                  dm_canbo    c
                                                  LEFT JOIN dm_dataitem b ON c.chucdanhid = b.id
                           WHERE
                               ( ( vloaitp = '0'
                                   AND b.ma = 'TPTATC' )
                                 OR ( vloaitp = '1'
                                      AND b.ma = 'TPBAC3' )
                                 OR ( vloaitp = '3' ) )
                               AND c.toaanid = vtoaanid
                               AND c.hieuluc = 1
                               AND c.trangthai_xetxu = 1;
    end if;
    END;


PROCEDURE DON_GETTHEOKETQUAID_CHIDINH
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
    vLoaiTP varchar,
    curReturn OUT sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR
  Select * from (
  Select ROW_NUMBER() OVER (ORDER BY cast(NVL(d.TL_SO,'0') as number)) STT, k.ID
  ,decode(d.NGUOIGUI_HOTEN,null,d.CV_TENDONVI,d.NGUOIGUI_HOTEN)NGUOIGUI_HOTEN --05/07/2024
  ,d.NGAYNHANDON,d.NGAYGHITRENDON,d.MADON
  , case d.LOAIDON when 1 then '??n' when 2 then '??n t? cáo' when 3 then '??n + Công v?n' end as HinhThuc
      ,(Select TENPHONGBAN from DM_PHONGBAN where ID=d.CD_TA_DONVIID) NOICHUYEN
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_SO Else d.KN_SOQD END) BAQD
--      ,(Case d.BAQD_LOAIQDBA When 0 then  d.BAQD_NGAYBA Else d.KN_NGAY END) BAQD_NGAYBA

       ,(Case d.BAQD_LOAIQDBA When 1 then ('Q?: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 0 then  (Select MA_TEN from DM_TOAAN where ID=decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID))
      Else (Select TEN from DM_DATAITEM where ID=d.NGUOIKHANGNGHI)
      END) TOAXX

        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST
        ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,d.CV_TENDONVI, c1.HOTEN || '(' || TO_CHAR(c1.NGAYSINH, 'DD/MM/YYYY') || ')' TENTHAMPHAN
      ,c2.HOTEN TENTHAMPHANSUA,d.NGUOIGUI_HUYENID
      ,d.NGUOIGUI_DIACHI || ' '  Diachigui,
      k.CANBOID,CANBOID_SUA,k.GHICHU
      ,d.TL_SO,d.TL_NGAY, d.CD_SOTOTRINH
      , decode(d.CD_NGAYTOTRINH,null,null,to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')) CD_NGAYTOTRINH
      , decode(k.NGAYPHANCONGTP,null,to_char(kq.NGAYPHANCONG,'dd/MM/yyyy'),to_char(k.NGAYPHANCONGTP,'dd/MM/yyyy')) NGAYPHANCONGTP
      ,null PhanCongTP--GDTTT_PCTP_GetAll_BY_DON(K.DONID) PhanCongTP --yeu cau cua Duy, chi huong xoa di de in
      ,(select count(id) from gdttt_vuan where id = d.VUVIECID) CHECK_VUAN, d.ISTPB3
  From GDTTT_PCTP_CHITIET_CHIDINH k 
        Inner join GDTTT_DON d on k.DONID=d.ID
        left join GDTTT_PCTP_KETQUA_CHIDINH kq on kq.id = k.KETQUAID
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

END DON_GETTHEOKETQUAID_CHIDINH;

END PKG_GDTTT_TPB3;