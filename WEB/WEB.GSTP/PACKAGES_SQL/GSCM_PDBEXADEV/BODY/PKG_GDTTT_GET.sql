--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_GET
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_GET" AS

FUNCTION GET_DONVI_TINH
(
 V_CAPCHAID in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
BEGIN
  OPEN V_CURSOR FOR
         --SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
        SELECT MN.ID,MN.CAPCHAID,TO_CHAR(MN.TEN)TEN  FROM DM_TOAAN MN 
                 WHERE MN.ID=V_CAPCHAID AND mn.hieuluc = 1 
       UNION ALL 
         SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,MN.CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                 WHERE MN.CAPCHAID=V_CAPCHAID AND mn.hieuluc = 1  
                 ORDER BY MN.ARRTHUTU
         )TT;
  RETURN v_cursor;   
END;

FUNCTION GET_DONVI_HUYEN
(
 V_TOAANID in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
BEGIN
  OPEN V_CURSOR FOR
         --SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
        SELECT MN.ID,MN.CAPCHAID,TO_CHAR(MN.TEN)TEN  FROM DM_TOAAN MN 
                 WHERE MN.ID=V_TOAANID AND mn.hieuluc = 1 ;
  RETURN v_cursor;   
END;

PROCEDURE DM_TOAAN_GET_DonViBYCC
(
     vID in number
    ,CurReturn OUT sys_refcursor 
) 
AS 
  sCapChaPath varchar2(250); vvCapChaID VARCHAR2(100);
begin
  OPEN CurReturn FOR  
    SELECT d.ID,d.MA,d.TEN,d.MA_TEN, d.CapChaID,d.ThuTu, d.SoCap, d.ArrSapXep, d.ArrThuTu 
    from DM_TOAAN d 
          where 
            d.HieuLuc =1 
            And d.ID = vID
            --And d.ArrSapXep like (sCapChaPath||'/%')
    order by d.ArrThuTu;
end DM_TOAAN_GET_DonViBYCC;

procedure CANBO_GETBYDONVI_LANHDAO
( vDonViID in number,
  vPhongbanID in number,
  vChucVu in varchar2,
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
                where c.GROUPID=vGroupChucVuID and (instr(vChucVu,','||c.MA||',')>0)) d on d.ID=a.CHUCVUID
                -- anhvh add vao dung cho cap cao --'042','043','041','059' Phó Trưởng phòng,Quyền Trưởng phòng,Trưởng phòng,Phó Trưởng phòng phụ trách
  where a.TOAANID=vDonViID and a.PHONGBANID=vPhongbanID And a.HIEULUC=1 order by d.ThuTu; 
END CANBO_GETBYDONVI_LANHDAO;
PROCEDURE   PERMI_MENU_BAOCAO
( vMenuPath in varchar2,
  vUserID number,
  curReturn    OUT       sys_refcursor
)
IS 
vMenuID  number;
vAction  number;
vCapchaID  number;
BEGIN
   SELECT M.ID,M.ACTION,M.CAPCHAID INTO VMENUID,VACTION,VCAPCHAID 
   FROM (SELECT ID,ACTION,CAPCHAID FROM QT_MENU D WHERE LOWER('/' || D.DUONGDAN)=LOWER(VMENUPATH)) M
   WHERE ROWNUM = 1;
OPEN CURRETURN FOR  
    SELECT MN.ID,MN.TENMENU,MN.MAACTION  FROM QT_NHOMNGUOIDUNG_MENU M
        INNER JOIN QT_NGUOISUDUNG NSD ON NSD.NHOMNSDID=M.NHOMID
        LEFT JOIN QT_MENU MN ON MN.ID=M.MENUID
    WHERE NSD.ID=VUSERID AND M.XEM=1
         AND M.MENUID IN (SELECT ID FROM QT_MENU M WHERE M.CAPCHAID=VMENUID)
          ORDER BY MN.THUTU;
END PERMI_MENU_BAOCAO;
PROCEDURE  GET_TP_VU_GDKT
(
  V_TOAANID in VARCHAR2,
  V_PHONGBANID in VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
        open CurReturn for
        SELECT V.THAMPHANID,CB.HOTEN FROM GDTTT_VUAN V
        INNER JOIN DM_CANBO CB ON CB.ID=V.THAMPHANID
        WHERE V.TOAANID=V_TOAANID AND V.PHONGBANID=V_PHONGBANID AND V.THAMPHANID!=0 AND V.THAMPHANID IS NOT NULL
        GROUP BY V.THAMPHANID,CB.HOTEN;
END;
PROCEDURE  GET_PHUTRACH_TP_BC
(
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
) AS 
       VLOAIAN varchar2(50);v_ma_chucvu varchar2(10);
BEGIN
     --add by anhvh 30/10/2019
     --c.GROUPID =13--chức vụ ;i.GROUPID=12 chuc danh
    Select replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',')
    INTO VLOAIAN From DM_CANBO c  where c.id=vThamphan_id;  --truyền thẩm phán là lãnh đạo phục trách là phó chánh án hoặc chánh án
    ------
    select b.Ma  into v_ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan_id;
   ----------------------------
   open CurReturn for
    -- thêm thẩm phán là CA và Phó chánh án vào đầu danh sách
--    Select lss.id,lss.hoten  From DM_CANBO lss  where lss.id=vThamphan_id
--    UNION all
   select lss.id,lss.hoten from (
       select ls.id,ls.hoten from (
           select la.id,la.hoten,SUBSTR(la.hoten,INSTR(la.hoten,' ',-1)+ 1)HOTEN_LAST_NAME,regexp_substr(la.loaian,'[^,]+', 1, level)loaian FROM ( 
               Select c.ID,c.HoTen,replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',') LOAIAN From DM_CANBO c
                 --chỉ lấy chức danh là thẩm phán
                 inner join (select i.ID, i.TEN from DM_DATAITEM i where   i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC') and i.GROUPID=12 ) d1 on d1.ID=c.CHUCDANHID  
                 WHere c.TOAANID=1 and c.HieuLuc=1 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
                 --v_ma_chucvu='PCA' nếu thẩm phán là phó chánh án thì không lấy thẩm phán và các phó chánh án khác
                 --v_ma_chucvu='CA' nếu thẩm phán là chánh án thì chỉ loại bỏ chính thẩm phán đó
                 and  (  (v_ma_chucvu='PCA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA', 'PCA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
                         or (v_ma_chucvu='CA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
                      )
                 order by  C.HoTen                  
                 )la 
               CONNECT BY regexp_substr(la.loaian, '[^,]+', 1, level) IS NOT NULL
            )ls  where instr(VLOAIAN,','||ls.loaian||',')>0 
        group by ls.id,ls.hoten,ls.HOTEN_LAST_NAME
        Order by ls.HOTEN_LAST_NAME
    )lss;

------------------------------------  
--          select regexp_substr(',2,4,','[^,]+', 1, level) FROM dual 
--          CONNECT BY regexp_substr(',2,4,', '[^,]+', 1, level) IS NOT NULL;
END GET_PHUTRACH_TP_BC;
PROCEDURE PHONGBANID_GET
(
  V_TOAANID in VARCHAR2,
  V_PHONGBANID in VARCHAR2,
  curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 --V_PHONGBANID=1 phòng ban là văn phòng
 OPEN curReturn FOR 
    Select pb.* from DM_PHONGBAN pb WHERE 
    ((PB.ID=V_PHONGBANID AND V_PHONGBANID IS NOT NULL AND V_PHONGBANID!='1') OR (V_PHONGBANID IS NULL OR V_PHONGBANID='1') )
    AND pb.TOAANID=V_TOAANID AND pb.HAUTOCV LIKE 'GĐKT%'
    ORDER BY pb.ID;
END PHONGBANID_GET;
PROCEDURE DM_TOAAN_GETBYNOTCUR_ST
(
  curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR 
    Select t.ID,t.MA,t.TEN,t.MA_TEN  from DM_TOAAN t  
    Where T.LOAITOA IN ('CAPHUYEN','CAPTINH','QSKHUVUC','QSQUANKHU')
    Order by t.ARRTHUTU;
END DM_TOAAN_GETBYNOTCUR_ST;
PROCEDURE  GDTTT_XXGDTTT_SEARCHBYTP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  vThamphan in number,
  vTuNgay in date,
  vDenNgay in date,
  vTrangthai in number,
  vKetquaxetxu in number,  
  curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR

      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYXXGDT desc, v.NGAYTHULYDON desc) STT
          ,v.ID,v.MAVUAN  , v.NGUYENDON,v.BIDON        
          , (v.SOANPHUCTHAM || chr(10) ||' '
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT   
          , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
          , ttv.HOTEN as TENTHAMTRAVIEN  , NVL(ld.HOTEN,'') as TENLANHDAO,  NVL(cv.Ma,'') MaChucVuLD   

          ------------------------------------------
          , v.SOTHULYXXGDT
            , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT

          , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')
                    end  XXGDTTT_NGAYVKSTRAHS
          --------------
          , v.XXGDTTT_SOQD
           , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                    end  XXGDTTT_NGAYQD
            , (v.XXGDTTT_SOQD || chr(10) || '  '
                || case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                    end) as TTQD_XXGDTTT         

          , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')
                    end  NGAYXUGIAMDOCTHAM
          , NVL(kq.Ten,' ') KetQuaXXGDT
           ------------------------------------------
           , GDTTT_ToTrinh_GetLastByDK(v.Id, 11, 'NGAYNHANDUTHAO') NGAYNHANDUTHAO   
           , GDTTT_ToTrinh_GetLastByDK(v.Id, 11, 'NGAYTRADUTHAO') NGAYTRADUTHAO   
           --------------------------------------
           ,  NVL(v.ISVIENTRUONGKN,0) ISVIENTRUONGKN
           , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
           , '' KN_VKS, '' KN_ChanhAn
           --------------------------------------
           ,(select case when NVL(IsChuToa,0)=0 then DECODE(TYPEHD, 1, u'H\0110TT',2,'HĐ5')
                          when NVL(IsChuToa,0)=1 then u'Ch\1ee7 t\1ecda'
                    end
            from GDTTT_VUAN_XXGDTT_HOIDONG 
            where VuAnId=v.ID and CanBoID=vThamphan
           ) as HoiDongTP
      from GDTTT_VUAN v 
         left join (select ID, Ma_Ten from DM_TOAAN) txx on v.TOAPHUCTHAMID=txx.ID
         left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
         left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
         left join DM_DataITem cv on ld.ChucVuID = cv.ID
         left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
       where v.TOAANID=vToaAnID and v.LoaiAn<>7-- and v.PhongBanID=vPhongBanID
          and 1=case when vLoaiAn=0 then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
          and (v.THAMPHANID=vThamphan 
              or  vThamphan in (select distinct(canboid) from GDTTT_VuAn_XXGDTT_HoiDong 
                                where VuAnId = v.ID)
              )

          and  1=case when vTuNgay is null then 1 when vTuNgay <= v.NgayThuLyXXGDT then 1 else 0 end
          and 1=case when vDenNgay is null then 1 when v.NgayThuLyXXGDT <= vDenNgay then 1 else 0 end

          and v.TrangThaiId = 15 and NVL(v.IsRutKN,0)=0

          and 1=case when vTrangthai=-1 and v.TrangThaiID in (14,15) then 1
                     when vTrangthai=0 and v.TrangThaiID=15 
                        and NVL(v.XXGDTTT_KETQUAID,0)=0 then 1 
                     when vTrangthai=1 and  v.TrangThaiID=15 
                        and NVL(v.XXGDTTT_KETQUAID,0)>0 then 1 else 0 end

          ---------Ket qua xet xu GDTTT-----------------------------
          and 1= case when vKetquaxetxu =0 then 1
                      when vKetquaxetxu =-1 and (NVL(v.XXGDTTT_KETQUAID,0) =0) then 1
                      when vKetquaxetxu>0  and (NVL(v.XXGDTTT_KETQUAID,0) = vKetquaxetxu) then 1
                 end  ;   
END GDTTT_XXGDTTT_SearchByTP;
PROCEDURE GDTTTT_VUAN_GQD_SEARCH_BYTP
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  vThamphan in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,
  vKetquathuly in number,
  curReturn OUT sys_refcursor
)
IS 
BEGIN 
   OPEN curReturn FOR
            Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                , v.ID,v.MAVUAN
                , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                , v.NGUYENDON,v.BIDON

                , (v.SOANPHUCTHAM || chr(10) 
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT                    
                , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
                , ttv.HOTEN as TENTHAMTRAVIEN
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ten,'') ChucVuLanhDao, NVL(cv.Ma,'') MaChucVuLD  
                ----------------------------------
                , v.GDQ_SO 
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , (v.GDQ_SO || chr(10) || chr(10) || '  '
                  || case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                      end 
                  ) TT_VBGQD

                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID               
                 , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3,GQD_KETQUA) KQ_GQD
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')
                  end LoaiKN   

                , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV                
                -------------------------------
              , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',1) NgayTPDuyet
              , GDTTT_ToTrinh_GetYKien(v.Id, 'TP',1) YKienTP
              -------------------------------    
              , GDTTT_ToTrinh_GetLastByDK(v.Id, 6, 'NGAYDK') NgayDangKyBC    
              , GDTTT_ToTrinh_GetLastByDK(v.Id, 6, 'NGAYNHANTT') NGAYNHANTT
              , GDTTT_ToTrinh_GetLastByDK(v.Id, 11, 'NGAYNHANDUTHAO') NGAYNHANDUTHAO
              , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
               left join DM_DataITem cv on ld.ChucVuID = cv.ID
             where v.TOAANID=vToaAnID --and (vPhongBanID=0 OR (v.PhongBanID=vPhongBanID and vPhongBanID!=0 ))
                and 1=case when vLoaiAn=0  and v.LoaiAn<>7 then 1 
                           when v.LOAIAN=vLoaiAn then 1 else 0 end
                and 1=case when vThamphan=0 then 1 
                           when v.THAMPHANID=vThamphan then 1 else 0 end

              and 1= case when (vGQD_TuNgay is null) and (vGQD_DenNgay is null) then 1

                            ----GQD_NGAYPHATHANHCV--<=--vGQD_DenNgay---<=--GDQ_NGAY-----
                            ----GDQ_NGAY--<=--vGQD_DenNgay--<=--GQD_NGAYPHATHANHCV----
                            ----GDQ_NGAY-<=--GQD_NGAYPHATHANHCV----vGQD_DenNgay-------                            
                            when vGQD_TuNgay is null and vGQD_DenNgay is not null
                                and (vKetquathuly<3 or vKetquathuly=5) and NVL(v.GQD_LOAIKETQUA,5)<5 -- da co kq giai quyet don
                                and ((vGQD_DenNgay between v.GDQ_NGAY and v.GQD_NGAYPHATHANHCV )
                                      or (vGQD_DenNgay between v.GQD_NGAYPHATHANHCV and v.GDQ_NGAY )
                                      or (vGQD_DenNgay>=  v.GQD_NGAYPHATHANHCV 
                                          and vGQD_DenNgay>=  v.GDQ_NGAY )
                                     ) then 1

                            ------vGQD_TuNgay--<=-GDQ_NGAY---GQD_NGAYPHATHANHCV-------        
                            when vGQD_TuNgay is not null and vGQD_DenNgay is null
                                and (vKetquathuly<3 or vKetquathuly=5) and NVL(v.GQD_LOAIKETQUA,5)<5 -- da co kq giai quyet don
                                and ((vGQD_TuNgay between v.GDQ_NGAY and v.GQD_NGAYPHATHANHCV )
                                      or (vGQD_TuNgay between v.GQD_NGAYPHATHANHCV and v.GDQ_NGAY )
                                      or (vGQD_TuNgay<=  v.GQD_NGAYPHATHANHCV 
                                          and vGQD_TuNgay<= v.GDQ_NGAY )
                                     ) then 1    

                             ------vGQD_TuNgay--GDQ_NGAY---GQD_NGAYPHATHANHCV----vGQD_DenNgay---                                     
                            when vGQD_TuNgay is not null and vGQD_DenNgay is not null  
                                and (vKetquathuly<3 or vKetquathuly=5) and NVL(v.GQD_LOAIKETQUA,5)<5 -- da co kq giai quyet don
                                and ( (v.GDQ_NGAY between vGQD_TuNgay and vGQD_DenNgay )
                                      or (v.GQD_NGAYPHATHANHCV between vGQD_TuNgay and vGQD_DenNgay )
                                     ) then 1
                       end

                -- vKetquathuly =3--> tat ca, =4-->chua co kqgq, <3--> da co kqgq
                and 1=case when vKetquathuly=5 and NVL(v.GQD_LOAIKETQUA,5) <5 then 1
                           when vKetquathuly<3 and  NVL(v.GQD_LOAIKETQUA,5)=vKetquathuly then 1 
                end  ;

END GDTTTT_VUAN_GQD_SEARCH_ByTP;
PROCEDURE DM_TOAAN_GETBYCAPCHAID
(
     vCapChaID in number
    , CurReturn OUT sys_refcursor 
) 
AS 
  sCapChaPath varchar2(250); vvCapChaID VARCHAR2(100);
begin
    --Map các tòa Phúc thẩm tối cao vào TAND cấp cao//anhvh 13/11/2019
    --1138 PT TANDTC tại Hà Nội,1139,1200 PT TANDTC tại Đà Nẵng,PT TANDTC tại thành phố Hồ Chí Minh,1201 PT TANDTC
    --4	TANDCC tại Hà Nội,5	TANDCC tại Đà Đà Nẵng,6 TANDCC tại thành phố Hồ Chí Minh
  SELECT DECODE(vCapChaID,1138,'4,5,6',1200,'4,5,6',1139,'4,5,6',1201,'4,5,6',vCapChaID) into vvCapChaID FROM DUAL;
  ----------------------
 -- select ArrSapXep into sCapChaPath from DM_ToaAn where  instr(','||to_char(vvCapChaID)||',',','||to_char(ID)||',')>0;
  OPEN CurReturn FOR  
    SELECT d.ID,d.MA,d.TEN,d.MA_TEN, d.CapChaID,d.ThuTu, d.SoCap, d.ArrSapXep, d.ArrThuTu 
    from DM_TOAAN d 
          where --d.HieuLuc =1 
           instr(','||vvCapChaID||',',','||d.CapChaID||',')>0
          --and d.ArrSapXep like (sCapChaPath||'/%')
    order by d.ArrThuTu;
end DM_ToaAn_GetByCapChaID;
PROCEDURE GDTTT_AHS_GETALLBYLOAIDS
( 
    VVUANID IN NUMBER,
    TYPE_DS IN NUMBER, 
    CURRETURN OUT SYS_REFCURSOR
)
IS 
   vCount_BC number:=0;
BEGIN
  OPEN CURRETURN FOR
        SELECT ROW_NUMBER() OVER (ORDER BY TUCACHTOTUNG, NGAYTAO) STT
          , ID, VUANID, TENDUONGSU, TUCACHTOTUNG
          , HS_BICANDAUVU, NVL(HS_ISKHIEUNAI, 0) HS_ISKHIEUNAI 

          , CASE WHEN TUCACHTOTUNG LIKE '%BIDON%' AND NVL(HS_BICANDAUVU,0)=1 THEN 'Bị cáo đầu vụ'
                 WHEN TUCACHTOTUNG LIKE '%BIDON%' AND NVL(HS_BICANDAUVU,0)=0 THEN 'Bị cáo khiếu nại'
                 WHEN TUCACHTOTUNG LIKE 'KHAC' THEN
                      (CASE WHEN NVL(HS_ISKHIEUNAI, 0)=1 
                                THEN 'Người khiếu nại' ||  (CASE WHEN LENGTH(NVL(HS_TUCACHTOTUNG, ''))>0 
                                                                      THEN ' ('||HS_TUCACHTOTUNG||')'
                                                              ELSE '' END)
                       ELSE HS_TUCACHTOTUNG END)
                ELSE HS_TUCACHTOTUNG  END AS DUONGSU_TUCACHTOTUNG
          , HS_TUCACHTOTUNG 
          , HS_TENTOIDANH,DIACHI, HS_MUCAN, HS_LOAIBAKHIEUNAI
          , NVL(HS_NOIDUNGKHIEUNAI,'') HS_NOIDUNGKHIEUNAI
          , ((CASE WHEN LENGTH(NVL(HS_SOBAKHIEUNAI, ''))>0 THEN 'Số BA: '|| CAST(HS_SOBAKHIEUNAI AS VARCHAR2(100))
                 ELSE '' END)
                || (CASE WHEN (LENGTH(NVL(HS_NGAYBAKHIEUNAI,''))=0 
                              OR (TO_CHAR(HS_NGAYBAKHIEUNAI,'dd/MM/yyyy') ='01/01/0001')) THEN ''
                         WHEN LENGTH(NVL(HS_NGAYBAKHIEUNAI,'')) >0
                              THEN ' Ngày BA '||TO_CHAR(HS_NGAYBAKHIEUNAI,'dd/MM/yyyy')
                        END)
                || CASE WHEN LENGTH(NVL(HS_SOBAKHIEUNAI, ''))>0  
                             OR LENGTH(NVL(HS_NGAYBAKHIEUNAI,'')) >0 THEN '<br/>'
                        ELSE '' END
                || HS_NOIDUNGKHIEUNAI
            ) NOIDUNGKHIEUNAI
        FROM GDTTT_VUAN_DUONGSU DS  
        WHERE DS.VUANID =VVUANID    
         AND ( TYPE_DS>2
              OR (TYPE_DS=2 AND NVL(DS.HS_ISKHIEUNAI,0) =1)
              OR( (TYPE_DS=0 OR TYPE_DS=1) AND( (NVL(DS.HS_ISBICAO,0) =1 OR NVL(DS.HS_BICANDAUVU,0) =1)  
                                                 --add by anhvh 07/11/2019 là trường hợp người khiếu nại chính là bị cáo, 
                                                 --add vào dropbicao trong trường hợp trong bảng  GDTTT_VUAN_DS_KN chưa tồn tại bị cáo đó 
                                                or( NVL(DS.HS_ISKHIEUNAI,0) =1  AND ( NOT EXISTS (SELECT 'X' FROM GDTTT_VUAN_DS_KN KN WHERE KN.BICAOID=DS.ID) 
                                                                                      OR  EXISTS (SELECT 'X' FROM GDTTT_VUAN_DS_KN KN WHERE KN.BICAOID=DS.ID)    
                                                                                     )
                                                  )
                                              ) 
                  )
        )
        ORDER BY VUANID;
END GDTTT_AHS_GETALLBYLOAIDS;
PROCEDURE GET_YEAR_THEO_TP 
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
)
as
  ma_chucvu varchar2(10); curr_thamphan_id number;
BEGIN
  select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0; 
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  
         curr_thamphan_id:=0; 
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
   ------------------------------------------------ 
    OPEN curReturn FOR 
         SELECT TT.NGAYTAO YEAR_ID,'Năm '||TT.NGAYTAO YEAR_TEN FROM (
                    select EXTRACT(year FROM a.NGAYTAO)NGAYTAO from GDTTT_VUAN a 
                    where a.TOAANID=vToaAnID AND a.NGAYTAO IS NOT NULL and ((a.ThamPhanID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0) 
            )TT WHERE TT.NGAYTAO>=2018 GROUP BY TT.NGAYTAO,'Năm '||TT.NGAYTAO 
--          )TT WHERE TT.NGAYTAO>=2018 GROUP BY TT.NGAYTAO,'Năm '||TT.NGAYTAO 
            ORDER BY TT.NGAYTAO DESC;
END GET_YEAR_THEO_TP;
PROCEDURE DM_CANBO_PB_CHUCDANH 
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
)
as
  ma_chucvu varchar2(10); curr_thamphan_id number;
BEGIN
  select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0; 
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  
         curr_thamphan_id:=0; 
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
   ------------------------------------------------ 
    OPEN curReturn FOR 
        select cb.id,cb.hoten
        --cb.hoten||' ('||b.MA||' - '||REPLACE(pb.TENPHONGBAN,'Vụ Giám đốc, kiểm tra','vụ GĐKT')||')' hoten
        from GDTTT_VuAn a 
        inner join DM_CanBo cb on cb.id=a.LANHDAOVUID
        left join DM_DataItem b on cb.ChucVuID = b.ID
         --left join DM_PHONGBAN pb on cb.PHONGBANID = pb.ID
           where cb.TOAANID=vToaAnID and ((a.ThamPhanID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                and a.LANHDAOVUID is not null --and cb.HieuLuc=1   
        group by cb.id,cb.hoten,b.MA--,pb.TENPHONGBAN
        ORDER BY SUBSTR(cb.hoten,INSTR(cb.hoten,' ',-1)+ 1);--pb.TENPHONGBAN,
END DM_CANBO_PB_CHUCDANH;
PROCEDURE   GDTTT_GETTTT_THEOTP
(  
 vThamPhanID in number,
 vToaAnID in number,
 curReturn    OUT       sys_refcursor
)
as
  ma_chucvu varchar2(10); curr_thamphan_id number;
BEGIN
  select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0; 
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  
         curr_thamphan_id:=0; 
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
   ------------------------------------------------ 
    OPEN curReturn FOR 
        select cb.id,cb.hoten from GDTTT_VuAn a inner join DM_CanBo cb on cb.id=a.ThamTraVienID
           where cb.TOAANID=vToaAnID and ((a.ThamPhanID=curr_thamphan_id AND curr_thamphan_id!=0) OR curr_thamphan_id=0)
                and a.ThamTraVienID is not null --and cb.HieuLuc=1   
        group by cb.id,cb.hoten 
        ORDER BY SUBSTR(cb.hoten,INSTR(cb.hoten,' ',-1)+ 1);
end GDTTT_GETTTT_THEOTP;
PROCEDURE  GDTTT_VUAN_LOAD_TT
( 
  vThamPhanID in number,
  vVuAnID in number,
  curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  SELECT TT.ID TOTRINH_ID,DECODE(NVL(TT.CAPTRINHTIEP,0),TT.LANHDAOID,TT.TRINHTIEP_LANHDAO_ID)LANHDAOID,
          DECODE(NVL(TT.CAPTRINHTIEP,0),TT.TINHTRANGID,TT.CAPTRINHTIEP)TINHTRANGID,TT.NGAYTRA
                    FROM
                    (Select t.ID,T.CAPTRINHTIEP,T.TINHTRANGID,T.LANHDAOID,T.TRINHTIEP_LANHDAO_ID,T.NGAYTRA  From GDTTT_TOTRINH t 
                     inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
                     WHere t.VUANID=vVuAnID
                     order by t.NGAYTRINH desc,d.ThuTu desc
                     )TT
  WHERE ROWNUM=1 AND TT.NGAYTRA IS NULL AND TT.TINHTRANGID IN(6,7,8) AND LANHDAOID=vThamPhanID;
END GDTTT_VUAN_LOAD_TT;

PROCEDURE  GET_PHUTRACH_TP
(
  vToaAnID in VARCHAR2,
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
) AS 
       VLOAIAN varchar2(50);v_ma_chucvu varchar2(10);
BEGIN
     --add by anhvh 30/10/2019
     --c.GROUPID =13--chức vụ ;i.GROUPID=12 chuc danh
    Select replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',')
    INTO VLOAIAN From DM_CANBO c  where c.id=vThamphan_id;  --truyền thẩm phán là lãnh đạo phục trách là phó chánh án hoặc chánh án
    ------
    select b.Ma  into v_ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan_id;
   ----------------------------
   open CurReturn for
    -- thêm thẩm phán là CA và Phó chánh án vào đầu danh sách
    Select lss.id,translate ('--- Tất cả Thẩm phám ---' using nchar_cs) as hoten From DM_CANBO lss  where lss.id=vThamphan_id
    UNION all
    
--   select lss.id,lss.hoten from (
--     select ls.id,ls.hoten from (
--            select la.id,la.hoten,SUBSTR(la.hoten,INSTR(la.hoten,' ',-1)+ 1)HOTEN_LAST_NAME,la.loaian FROM ( 
--                   Select c.ID,c.HoTen,replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',') 
--                   LOAIAN From DM_CANBO c
--                     inner join (select i.ID, i.TEN from DM_DATAITEM i where   i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC') and i.GROUPID=12 ) d1 on d1.ID=c.CHUCDANHID  
--                     WHere c.TOAANID=vToaAnID and c.HieuLuc=1 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
--                     and  (  (v_ma_chucvu='PCA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA', 'PCA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
--                         or (v_ma_chucvu='CA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
--                      )
--                 )la
--        )ls where instr(VLOAIAN,ls.loaian)>0
--         Order by ls.HOTEN_LAST_NAME
--           )lss;
   select lss.id,lss.hoten from (
       select ls.id,ls.hoten from (
           select la.id,la.hoten,SUBSTR(la.hoten,INSTR(la.hoten,' ',-1)+ 1)HOTEN_LAST_NAME,regexp_substr(la.loaian,'[^,]+', 1, level)loaian FROM ( 
               Select c.ID,c.HoTen,replace(DECODE(c.ISHINHSU,1,','||1||',','')||DECODE(c.ISDANSU,1,','||2||',','')|| DECODE(c.ISHNGD,1,','||3||',','')||DECODE(c.ISKDTM,1,','||4||',','')||DECODE(c.ISHANHCHINH,1,','||6||',','')||DECODE(c.ISLAODONG,1,','||5||',',''),',,',',') LOAIAN From DM_CANBO c
                 --chỉ lấy chức danh là thẩm phán
                 inner join (select i.ID, i.TEN from DM_DATAITEM i where   i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC') and i.GROUPID=12 ) d1 on d1.ID=c.CHUCDANHID  
                 WHere c.TOAANID=vToaAnID and NVL(c.HIEULUC,0) != 0 and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
                 --v_ma_chucvu='PCA' nếu thẩm phán là phó chánh án thì không lấy thẩm phán và các phó chánh án khác
                 --v_ma_chucvu='CA' nếu thẩm phán là chánh án thì chỉ loại bỏ chính thẩm phán đó
                 and  (  (v_ma_chucvu='PCA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA', 'PCA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
                         or (v_ma_chucvu='CA' AND not exists(select dt.ID, dt.TEN from DM_DATAITEM dt where dt.Ma in ('CA')  and dt.GROUPID =13 and dt.ID=c.CHUCVUID) )
                      )
                 And (c.TOAANID!=1 OR (c.TOAANID=1 and d1.ten = 'TPTATC'))
                 order by  C.HoTen                  
                 )la 
               CONNECT BY regexp_substr(la.loaian, '[^,]+', 1, level) IS NOT NULL and instr(VLOAIAN,','||la.loaian||',')>0 --tuanvna chuyển where instr(VLOAIAN,','||ls.loaian||',')>0 
            )ls -- where instr(VLOAIAN,','||ls.loaian||',')>0 
        group by ls.id,ls.hoten,ls.HOTEN_LAST_NAME
        Order by ls.HOTEN_LAST_NAME
    )lss;
------------------------------------  
--          select regexp_substr(',2,4,','[^,]+', 1, level) FROM dual 
--          CONNECT BY regexp_substr(',2,4,', '[^,]+', 1, level) IS NOT NULL;
END GET_PHUTRACH_TP;
FUNCTION GET_SELECT_TP5
(
      v_VuAnID in number,
      v_Loai_hd in number,
      vPhongBanID in number,--hoi dong 5
      vToaAnID in number, --hoi dong 5
      vLoaiAn in number--hoi dong 5
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;V_COUNTS NUMBER;vGroupChucDanhID NUMBER;item_id VARCHAR2(500):='';
    item_id_temp VARCHAR2(500):=''; v_TYPEHD NUMBER;
    V_EXPORT_TEXT CLOB;

    BEGIN    
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     SELECT COUNT(*) INTO V_COUNTS FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.VUANID=v_VuAnID;
     IF(V_COUNTS>0) THEN
        SELECT HD.TYPEHD INTO v_TYPEHD FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.VUANID=v_VuAnID AND ROWNUM<=1;
     END IF;
     select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH'; 
      --chua luu nhung tham phan tren vao vu an V_COUNTS=0
     IF(V_COUNTS=0 OR v_TYPEHD=1) THEN
     --OR v_TYPEHD=1 nghĩa là khi dữ liệu đã được lưu ở hội đồng 5 mà người dùng check chọn hội đồng toàn thể thì load lại mặc định
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<select id=''selectList'' multiple = ''multiple'' size = ''10'' name = ''duallistbox_get_TP'' class=''get_TP'' title=''duallistbox_get_TP''>');
         --load mac dinh nhung tham phan theo loai an
         FOR item IN ( 
                       SELECT TT.ID,TT.hoten FROM (
                            SELECT C.ID, C.hoten, 1 hieuluc FROM dm_canbo C
                            INNER JOIN (SELECT I.ID,I.ten FROM dm_dataitem I  WHERE I.groupid=vgroupchucdanhid 
                                      AND I.ma IN ('TP','TPSC','TPTC','TPCC','TPTATC')
                                      ) d1 ON d1.ID=C.chucdanhid    
                              WHERE C.toaanid=vToaAnID AND C.hieuluc=1
                                  AND (C.ishinhsu=1 OR C.isdansu=1 OR C.ishngd=1 OR C.iskdtm=1 OR
                                      C.islaodong=1 OR C.ishanhchinh=1 OR C.isphasan=1)                  
                                  AND  (  (vloaian=1 AND C.ishinhsu =1)
                                            OR(vloaian=2 AND C.isdansu =1) OR(vloaian=3 AND C.ishngd =1) OR(vloaian=4 AND C.iskdtm =1)
                                            OR(vloaian=5 AND C.islaodong =1)OR(vloaian=6 AND C.ishanhchinh =1)
                                            OR(vloaian=7 AND C.isphasan =1)OR(vloaian=8 AND C.isbpxlhc =1)
                                      )
                          UNION ALL
                          select distinct a.ThamPhanID ID,b.HoTen, 0 HieuLuc
                             from GDTTT_VuAn a
                              inner join (select c.Id, c.HoTen, c.PhongBanID from DM_CanBo c
                                  where NVL(c.HieuLuc,0)=0 or NVL(c.TOAANID,0)<> vToaAnID
                                    and  (  
                                    (vLoaiAn=1 and c.IsHinhSu =1)
                                    OR(vLoaiAn=2 and c.IsDanSu =1) OR(vLoaiAn=3 and c.IsHNGD =1) OR(vLoaiAn=4 and c.IsKDTM =1)
                                    OR(vLoaiAn=5 and c.IsLaoDong =1)OR(vLoaiAn=6 and c.IsHanhChinh =1)
                                    OR(vLoaiAn=7 and c.IsPHASAN =1)OR(vLoaiAn=8 and c.IsBPXLHC =1)
                                        )
                                  ) b on a.ThamPhanID = b.ID
                              where NVL(a.ThamPhanID, 0)>0
                             and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
                            )TT
                          INNER JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                          FROM  DM_CANBO CB1
                          WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                          )CC2 ON  TT.ID=CC2.ID 
                        ORDER BY CC2.LAST_NAME
                    )
         LOOP
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||''' selected=''selected''>'|| item.HOTEN ||'</option>');
          item_id_temp:=item_id_temp||item.id||','; --cộng các id lại để loại trừ những item đã chọn -> tạo ra tập item chưa chọn
          -- AND instr(','||item_id||',',','||CC.ID||',')=0 trong đoạn code lấy những item chưa chọn
          END LOOP;
          item_id_temp:=RTRIM(item_id_temp,',');
          item_id:=item_id_temp;
          ------load mac dinh-------load nhung tham phan con lai chua duoc chon----
           FOR  item IN (
                     SELECT CC.ID,CC.HOTEN FROM DM_CANBO CC
                     INNER JOIN DM_DATAITEM DT ON DT.ID=CC.CHUCDANHID
                     LEFT JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                          FROM  DM_CANBO CB1
                          WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                          )CC2 ON CC.ID=CC2.ID 
                    WHERE 
                    ( (DT.MA='TPTATC' and CC.CHUCDANHID=486 and vToaAnID=1)
                         or (DT.MA='TPCC' and CC.CHUCDANHID=507 and vToaAnID!=1)
                         )
                    --DT.MA='TPTATC' AND CC.CHUCDANHID=486 
                    AND CC.HIEULUC=1 AND CC.TOAANID=vToaAnID
                    AND instr(','||item_id||',',','||CC.ID||',')=0
                    ORDER BY CC2.LAST_NAME
                 )
         LOOP
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||'''>'|| item.HOTEN ||'</option>');
          END LOOP;
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'</select>');
    -------load khi da duoc luu hoi dong-----------------
    ELSE
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'<select id=''selectList'' multiple = ''multiple'' size = ''10'' name = ''duallistbox_get_TP'' class=''get_TP'' title=''duallistbox_get_TP''>');
            --nhung tham phan da duoc chon
          FOR  item_select IN (
                 SELECT HD.CANBOID,HD.TENCANBO FROM GDTTT_VUAN_XXGDTT_HOIDONG HD 
                 --tách trường full_name de sap xep
                  LEFT JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                      ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                      ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                      FROM  DM_CANBO CB1
                      WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                      )CC2 ON HD.CANBOID=CC2.ID
                 WHERE HD.VUANID=v_VuAnID
             ORDER BY CC2.LAST_NAME 
                 )
         LOOP
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'<option value = '''||item_select.CANBOID  ||''' selected=''selected''>'|| item_select.TENCANBO ||'</option>');
          END LOOP;
          --nhung tham phan trong hộp chưa chọn
          FOR  item IN (
                     SELECT CC.ID,CC.HOTEN FROM DM_CANBO CC
                     INNER JOIN DM_DATAITEM DT ON DT.ID=CC.CHUCDANHID
                     LEFT JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                          ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                          FROM  DM_CANBO CB1
                          WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                          )CC2 ON CC.ID=CC2.ID 
                    WHERE
                    ( (DT.MA='TPTATC' and CC.CHUCDANHID=486 and vToaAnID=1)
                         or (DT.MA='TPCC' and CC.CHUCDANHID=507 and vToaAnID!=1)
                         )
                    --DT.MA='TPTATC' AND CC.CHUCDANHID=486 
                    AND CC.HIEULUC=1 AND CC.TOAANID=vToaAnID
                    AND NOT EXISTS (SELECT HD.CANBOID FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.CANBOID=CC.ID AND HD.VUANID=v_VuAnID)
                    ORDER BY CC2.LAST_NAME
                 )
         LOOP
             IF(V_COUNTS=0) THEN --la gia tri mac dinh thi load toan bo cac tham phan la da chon
              DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||''' selected=''selected''>'|| item.HOTEN ||'</option>');
            ELSE
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||'''>'|| item.HOTEN ||'</option>');
            END IF;
          END LOOP;
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'</select>');
   END IF;
     OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END GET_SELECT_TP5;
FUNCTION GET_SELECT_TP
(
      v_VuAnID in number,
      v_Loai_hd in number,
      vPhongBanID in number,--hoi dong 5
      vToaAnID in number, --hoi dong 5
      vLoaiAn in number--hoi dong 5
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;V_COUNTS NUMBER;vGroupChucDanhID NUMBER;
    V_EXPORT_TEXT CLOB;v_TYPEHD NUMBER:=0;

    BEGIN    
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     ------
     SELECT COUNT(*) INTO V_COUNTS FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.VUANID=v_VuAnID;
     IF(V_COUNTS>0) THEN
        SELECT HD.TYPEHD INTO v_TYPEHD FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.VUANID=v_VuAnID AND ROWNUM<=1;
     END IF;
     --------------
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'<select id=''selectList'' multiple = ''multiple'' size = ''10'' name = ''duallistbox_get_TP'' class=''get_TP'' title=''duallistbox_get_TP''>');
     FOR  item_select IN (
             SELECT HD.CANBOID,HD.TENCANBO FROM GDTTT_VUAN_XXGDTT_HOIDONG HD 
             --tách full_nam de sap xep
              LEFT JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                  ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                  ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                  FROM  DM_CANBO CB1
                  WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                  )CC2 ON HD.CANBOID=CC2.ID
             WHERE HD.VUANID=v_VuAnID
             ORDER BY CC2.LAST_NAME 
             )
     LOOP
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'<option value = '''||item_select.CANBOID  ||''' selected=''selected''>'|| item_select.TENCANBO ||'</option>');
      END LOOP;
      -------------------------------
      FOR  item IN (
                SELECT CC.ID,CC.HOTEN FROM DM_CANBO CC
                INNER JOIN DM_DATAITEM DT ON DT.ID=CC.CHUCDANHID
                 LEFT JOIN (SELECT CB1.ID,SUBSTR(CB1.HOTEN,0,INSTR(CB1.HOTEN,' ')- 1) AS FIRST_NAME
                  ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ') +1,  INSTR(CB1.HOTEN,' ',-1,1) - INSTR(CB1.HOTEN,' ') -1) AS MID_NAME
                  ,SUBSTR(CB1.HOTEN,INSTR(CB1.HOTEN,' ',-1)+ 1) AS LAST_NAME
                  FROM  DM_CANBO CB1
                  WHERE CB1.HIEULUC = 1 -- MANHND THEM CHI LAY CAN BO DANG CONG TÁC
                  )CC2 ON CC.ID=CC2.ID
                 WHERE( (DT.MA='TPTATC' and CC.CHUCDANHID=486 and vToaAnID=1)
                         or (DT.MA='TPCC' and CC.CHUCDANHID=507 and vToaAnID!=1)
                         )
                 AND CC.HIEULUC=1 AND CC.TOAANID=vToaAnID
                 AND NOT EXISTS (SELECT HD.CANBOID FROM GDTTT_VUAN_XXGDTT_HOIDONG HD WHERE HD.CANBOID=CC.ID AND HD.VUANID=v_VuAnID)
                 ORDER BY CC2.LAST_NAME 
             )
     LOOP
         IF(V_COUNTS=0 OR v_TYPEHD=2) THEN --la gia tri mac dinh thi load toan bo cac tham phan la da chon
         -- OR v_TYPEHD=2 nghia la dang la hoi dong 5 chuyển sang hội đồng toàn thể thì load lại theo mặc định
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||''' selected=''selected''>'|| item.HOTEN ||'</option>');
        ELSE
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' <option value = '''||item.id  ||'''>'|| item.HOTEN ||'</option>');
        END IF;
      END LOOP;
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'</select>');
     --------------------------------------
   OPEN v_cursor FOR
     SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
    ------------
    dbms_lob.freetemporary(V_EXPORT_TEXT);
    RETURN v_cursor;
END GET_SELECT_TP;
PROCEDURE GET_BOLUAT_TOIDANH
( 
  curReturn OUT SYS_REFCURSOR
) AS    
BEGIN
    OPEN curReturn FOR 
       select TD.ID,TD.DIEU ||'.'|| TD.TENTOIDANH 
        ||' ('|| DECODE(BL.ID,7,'BLHS 2017',53,'LHS 1985',54,'LHS 2015',51,'LHS 2009',52,'LHS 1999')||')' TENTOIDANH 
        from DM_BOLUAT_TOIDANH TD
        INNER JOIN DM_BOLUAT BL ON BL.ID=TD.LUATID
        WHERE  TD.LUATID IN (7,51,52,53,54) AND TD.LOAI = 2--TD.LOAI = 2 (điều)
       ;
END GET_BOLUAT_TOIDANH;
END PKG_GDTTT_GET;

/
