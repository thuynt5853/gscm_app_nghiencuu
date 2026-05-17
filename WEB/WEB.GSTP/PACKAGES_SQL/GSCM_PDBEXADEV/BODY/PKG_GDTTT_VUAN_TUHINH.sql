--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_TUHINH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_TUHINH" as

PROCEDURE GDTTT_SEARCH_VUAN_TUHINH
 (  
  vLoaiBanAn in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vToaRaBAQD in number,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;
BEGIN
   ----- 
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR 
       select  a.*,'' arrDONID 
			from (
                Select  COUNT(1) OVER () as CountAll,
                        ROW_NUMBER() OVER (ORDER BY v.NGAYTAO DESC)  STT
                    ,v.id vuanid
                    ,v.SOANPHUCTHAM 
                    ,v.NGAYXUPHUCTHAM
                    ,(SELECT TEN FROM DM_TOAAN WHERE ID =  v.TOAPHUCTHAMID) AS TOAXETXU
                    ,v.LoaiAn,v.TRANGTHAIID
                    , (select HS_TENTOIDANH from GDTTT_VUAN_DUONGSU where VUANID = v.id and HS_BICANDAUVU = 1) TOIDANH
                    ,(select LISTAGG(to_char(TENDUONGSU),';') WITHIN GROUP (ORDER BY VUANID DESC) from GDTTT_VUAN_DUONGSU where vuanid = v.id) TENDUONGSU
                    ,v.Nguyendon,v.BIDON 
                     ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , ld.HOTEN as TENLANHDAO, cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD
                  from gdttt_vuan v   
                  left join DM_CANBO tp on v.THAMPHANID=tp.ID
                  left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                  left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                  left join DM_DataITem cv on ld.ChucVuID = cv.ID
                  ---------- 
                    where   (vLoaiBanAn = 0 or 
                             (vLoaiBanAn = 1 
                              and UPPER(v.SOANPHUCTHAM) like UPPER(vSoBAQD) || '%' 
                              and to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = to_char(vNgayBAQD,'dd/MM/yyyy')
                              and v.TOAPHUCTHAMID = vToaRaBAQD) 
                              or
                              (vLoaiBanAn = 1 
                              and UPPER(v.SOANSOTHAM) like UPPER(vSoBAQD) || '%' 
                              and to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy') = to_char(vNgayBAQD,'dd/MM/yyyy')
                              and v.TOAANSOTHAM = vToaRaBAQD) 
                              )
                             
                        ------------------------------------------- EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                )a where a.stt>=MinIndex and a.stt<=MaxIndex;

    END GDTTT_SEARCH_VUAN_TUHINH; 

 PROCEDURE  GDTTTT_DUONGSU_TUHINH_SEARCH
( 
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  V_ID      in number,
  vHosoangiam in number,
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vLoaiBanAn in number,
  vBian in varchar2,
  vtungay in date,
  vdenngay in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;
  DUONGSU_ID number;
BEGIN
   ----- 
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR 
       select  a.*,'' arrDONID 
			from (
                Select  COUNT(1) OVER () as CountAll,
                        ROW_NUMBER() OVER (ORDER BY hs.NGAYTAO DESC)  STT
                    , ((select count(id) from GDTTT_VUAN_DS_KN where BICAOID = ds.ID)
                        +
                        (select count(id) from GDTTT_TUHINH_DON where DUONGSUID =  ds.ID ) )as TongDon
                    
--                    , GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon
                     ,(SELECT LISTAGG(TO_CHAR(CV.NGUOIGUI_HOTEN),'; ') WITHIN GROUP (ORDER BY CV.VUVIECID DESC)  FROM GDTTT_DON CV 
                             left join GDTTT_VUAN_DS_KN dskn on dskn.VUANID = CV.VUVIECID
                             WHERE  CV.VUVIECID=v.ID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 and dskn.BICAOID = ds.id and rownum = 1) LisThuLyDon
                    ,(select  LISTAGG(d.NGUOIGUI,'; ') WITHIN GROUP (ORDER BY d.VUANID DESC) from GDTTT_TUHINH_DON d where d.vuanid = v.id) listDonVu
                    
                    ,v.SOANPHUCTHAM ,v.NGAYXUPHUCTHAM,(SELECT TEN FROM DM_TOAAN WHERE ID =  v.TOAPHUCTHAMID) AS TOAXETXU
                    ,v.LoaiAn,v.TRANGTHAIID, NVL(v.IsVienTruongKN,0) IsVienTruongKN
                    ,ds.id ds_id,ds.TENDUONGSU,ds.NAMSINH,ds.VUANID
                    ,ds.DIACHI,ds.HS_TENTOIDANH,ds.HS_MUCAN,
                     tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , ld.HOTEN as TENLANHDAO, cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD
                    , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                    , case when (Length(NVL(hsv.NgayTao,''))=0 or (to_char(hsv.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(hsv.NgayTao,'')) >0 then to_char(hsv.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                   , case  when hs.id is not null then 'Đã tạo hồ sơ xin ân giảm'
                           when hs.id is null then 'Chưa tạo hồ sơ xin ân giảm'
                            end TinhTrang
                    , NSD.username
                    ,ttth.SOTT,to_char(ttth.NGAYTT,'dd/MM/yyyy') NGAYTT,ttth.CAPTRINH,ttth.LOAIYK
                    ,hs.*
                    ,(select hoten from dm_canbo cb where cb.id = hs.LUUHS_NGUOICHUYEN_ID) cabochuyen
                    --,(select tk.username from QT_NGUOISUDUNG tk where tk.id = v.nguoitao) TENTAIKHOAN
                  --from  GDTTT_TUHINH_VUAN hs
                  from GDTTT_VUAN_DUONGSU ds 
                  left join GDTTT_TUHINH_VUAN hs on hs.DUONGSU_ID = ds.id
                  left join gdttt_vuan v   on v.id = ds.vuanid
                  left join DM_CANBO tp on v.THAMPHANID=tp.ID
                  left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                  left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                  left join DM_DataITem cv on ld.ChucVuID = cv.ID
                  left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hsv on hsv.ID = NVL(v.HoSoID,0)
                  left join (select * from (select id,tuhinh_id, SOTT,NGAYTT,CAPTRINH,DECODE(LOAIYK,1,'Kháng nghị',2,'Không kháng nghị',3,'Bác đơn',4,'Ân giảm','') LOAIYK  FROM GDTTT_TOTRINH_TUHINH ORDER BY id desc) where rownum = 1) TTTH on hs.id = ttth.tuhinh_id
                  left join QT_NGUOISUDUNG nsd on HS.nguoitao = nsd.id
                
                  ---------- 
                    where     (V_ID =0 or ds.id = V_ID)
                              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SOANPHUCTHAM) like '%' || UPPER(vSoBAQD) || '%')   
                              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD)
                              --AND (vLoaiBanAn =0 OR hs.LOAIBANAN = vLoaiBanAn) 
                              ----------------------
                              and (vBian is null or vBian = '' or UPPER(ds.TENDUONGSU) like '%' || UPPER(vBian) || '%')
                              AND (vtungay IS NULL OR (V.NGAYTAO > vtungay OR V.NGAYTAO < vdenngay))
                              and ds.hs_mucan = 'tử hình'
                              and (ds.HS_ISBICAO =1 or ds.HS_BICANDAUVU =1)
                              and (vHosoangiam = 0 or (vHosoangiam = 1 and exists (select id from GDTTT_TUHINH_VUAN where duongsu_id = ds.id))
                                                    or (vHosoangiam = 2 and NOT exists (select id from GDTTT_TUHINH_VUAN where duongsu_id = ds.id))
                                    )
                        ------------------------------------------- EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                )a where a.stt>=MinIndex and a.stt<=MaxIndex;

END GDTTTT_DUONGSU_TUHINH_SEARCH;


PROCEDURE  GDTTTT_HOSO_TUHINH_SEARCH
( 
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  V_ID      in number,
  vToaAnID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in date,
  vLoaiBanAn in number,
  vBian in varchar2,
  vtungay in date,
  vdenngay in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;
  DUONGSU_ID number;
BEGIN
   ----- 
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR 
       select  a.*,'' arrDONID 
			from (
                Select  COUNT(1) OVER () as CountAll,
                        ROW_NUMBER() OVER (ORDER BY hs.NGAYTAO DESC)  STT
                     , ((select count(id) from GDTTT_VUAN_DS_KN where BICAOID = hs.DUONGSU_ID)
                        +
                        (select count(id) from GDTTT_TUHINH_DON where DUONGSUID =  hs.DUONGSU_ID ) )as TongDon
                      --, GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon
                    ,(SELECT LISTAGG(TO_CHAR(CV.NGUOIGUI_HOTEN),'; ') WITHIN GROUP (ORDER BY CV.VUVIECID DESC) FROM GDTTT_DON CV 
                             left join GDTTT_VUAN_DS_KN dskn on dskn.VUANID = CV.VUVIECID
                             WHERE  CV.VUVIECID=v.ID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 and dskn.BICAOID = ds.id) LisThuLyDon
                    ,(select  LISTAGG(d.NGUOIGUI,'; ') WITHIN GROUP (ORDER BY d.VUANID DESC) from GDTTT_TUHINH_DON d where d.vuanid = v.id) listDonVu
                    ,(select  LISTAGG(to_char(d.NGAYNHAN,'dd/MM/yyyy'),'; ') WITHIN GROUP (ORDER BY d.VUANID DESC) from GDTTT_TUHINH_DON d where d.vuanid = v.id) ngaynhandon_vu
                    ,(SELECT to_char(CV.NGAYNHANDON,'dd/MM/yyyy') FROM GDTTT_DON CV 
                             left join GDTTT_VUAN_DS_KN dskn on dskn.VUANID = CV.VUVIECID
                             WHERE  CV.VUVIECID=v.ID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 and dskn.BICAOID = ds.id) ngaynhandon_hctp
                    
                    ,v.SOANPHUCTHAM ,v.NGAYXUPHUCTHAM,(SELECT TEN FROM DM_TOAAN WHERE ID =  v.TOAPHUCTHAMID) AS TOAXETXU
                    ,v.LoaiAn,v.TRANGTHAIID, NVL(v.IsVienTruongKN,0) IsVienTruongKN
                    ,ds.id ds_id,ds.TENDUONGSU,ds.NAMSINH,ds.VUANID
                    ,ds.DIACHI,ds.HS_TENTOIDANH,ds.HS_MUCAN,
                     tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , ld.HOTEN as TENLANHDAO, cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD
                    , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                    , case when (Length(NVL(hsv.NgayTao,''))=0 or (to_char(hsv.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(hsv.NgayTao,'')) >0 then to_char(hsv.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                   , case when LUUHS_NGAYCHUYEN is not null then 'Lưu hồ sơ ngày '|| to_char(hs.LUUHS_NGAYCHUYEN,'dd/MM/yyyy')
                                when hs.THA_NGAY is not null then '<b>Kết quả thi hành án</b><br>'||DECODE(hs.THA_KETQUA,1,'Đã thi hành án',2,'Đã chết') || '<br> Ngày THA:' || to_char(hs.THA_NGAY,'dd/MM/yyyy')
                                when hs.LOAIKETQUAXM >0 and hs.LOAIKETQUAXM is not null then '<b>Kết quả XM: '||DECODE(hs.LOAIKETQUAXM,1,'Đúng thông tin ',2,'Không đúng thông tin ') ||'<br> Ngày: '||to_char(hs.NGAYKQXM,'dd/MM/yyyy')||'<br>'
                                when hs.SOCVXM is not null then '<b>Công văn xác minh</b><br>Số: '||hs.SOCVXM||'<br>'|| 'Ngày: '||to_char(hs.NGAYCVXM,'dd/MM/yyyy')||'<br>'
                                when hs.CTN_SOQĐ is not null then '<b>Chủ tịch nước '||DECODE(hs.CTN_LOAIQD,1,'Bác đơn ',2,'Ân giảm ') ||'</b><br>Số: ' ||CTN_SOQĐ ||'<br>'||'Ngày: '||to_char(hs.CTN_NGAYQD,'dd/MM/yyyy')
                                when hs.SOQD_VKS is not null then '<b>Viện kiểm sát '|| decode(hs.KETLUAN_VKS,1,'Không kháng nghị',2,'Kháng nghị') ||'</b><br>Số: '||SOQD_VKS||'<br>'||'Ngày: ' ||to_char(hs.NGAYQD_VKS,'dd/MM/yyyy')
                                when hs.SOQD_CA is not null then '<b>Chánh án '|| decode(hs.KETLUAN_CA,1,'Không kháng nghị',2,'Kháng nghị') ||'</b><br>Số: '||SOQD_CA ||'<br>'|| 'Ngày: '||to_char(hs.NGAYQD_CA,'dd/MM/yyyy')
                                when ttth.tuhinh_id is not null then decode(ttth.CAPTRINH,18,'<b>Trình Chủ Tịch Nước</b>','<b>Đã có tờ trình</b>)')||'<br>Số: '||ttth.SOTT ||'<br>'|| 'Ngày: '||to_char(ttth.NGAYTT,'dd/MM/yyyy')
                            end TinhTrang
                    , NSD.username
                    ,ttth.SOTT,to_char(ttth.NGAYTT,'dd/MM/yyyy') NGAYTT,ttth.CAPTRINH,ttth.LOAIYK
                    ,hs.*
                    ,(select hoten from dm_canbo cb where cb.id = hs.LUUHS_NGUOICHUYEN_ID) cabochuyen
                    --,(select tk.username from QT_NGUOISUDUNG tk where tk.id = v.nguoitao) TENTAIKHOAN
                  from  GDTTT_TUHINH_VUAN hs
                  left join GDTTT_VUAN_DUONGSU ds on hs.DUONGSU_ID = ds.id
                  left join gdttt_vuan v   on v.id = hs.vuan_id
                  left join DM_CANBO tp on v.THAMPHANID=tp.ID
                  left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                  left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                  left join DM_DataITem cv on ld.ChucVuID = cv.ID
                  left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hsv on hsv.ID = NVL(v.HoSoID,0)
                  left join (select * from (select id,tuhinh_id, SOTT,NGAYTT,CAPTRINH,DECODE(LOAIYK,1,'Kháng nghị',2,'Không kháng nghị',3,'Bác đơn',4,'Ân giảm','') LOAIYK  FROM GDTTT_TOTRINH_TUHINH ORDER BY id desc) where rownum = 1) TTTH on hs.id = ttth.tuhinh_id
                  left join QT_NGUOISUDUNG nsd on HS.nguoitao = nsd.id

                  ---------- 
                    where     (V_ID =0 or hs.id = V_ID)
                              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SOANPHUCTHAM) like '%' || UPPER(vSoBAQD) || '%')   
                              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD)
                              --AND (vLoaiBanAn =0 OR hs.LOAIBANAN = vLoaiBanAn) 
                              ----------------------
                              and (vBian is null or vBian = '' or UPPER(ds.TENDUONGSU) like '%' || UPPER(vBian) || '%')
                              AND (vtungay IS NULL OR (V.NGAYTAO > vtungay OR V.NGAYTAO < vdenngay))    

                        ------------------------------------------- 
                )a where a.stt>=MinIndex and a.stt<=MaxIndex;

END GDTTTT_HOSO_TUHINH_SEARCH;

FUNCTION GDTTT_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2 AS 
  DSTHULY VARCHAR2(2000);
BEGIN
    SELECT (SELECT LISTAGG(TO_CHAR(CV.NGUOIGUI_HOTEN))
            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)            
            FROM GDTTT_DON CV  
            WHERE CV.VUVIECID=VVUANID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
    )  INTO DSTHULY FROM DUAL;
  RETURN NVL(DSTHULY, '');
END GDTTT_DON_GETTHULYBYVUAN;


PROCEDURE  GDTTTT_DSTOTRINH_TUHINH
( 

  V_ID      in number,
  V_HoSo_ID in number,
  curReturn OUT sys_refcursor
)
IS 

BEGIN
   ----- 

   OPEN curReturn FOR 
       select tt.*, decode(tt.CAPTRINH,18,'Trình Chủ Tịch Nước',cp.TENTINHTRANG) TENTINHTRANG,tl.hoten TENLANHDAO,tp.hoten TENTHAMPHAN,  case when tt.LOAIYK = 0 then ''
                                                     when tt.LOAIYK = 1 then 'Không kháng nghị'
                                                     when  tt.LOAIYK = 2 then 'Kháng nghị' 
                                                      when tt.LOAIYK = 3 then 'Bác đơn'
                                                     when  tt.LOAIYK = 4 then 'Ân giảm' 
                                                     
                                                     end TENYKIEN
                ,(select  'Yêu cầu '||dm.tentinhtrang||':' from GDTTT_DM_TINHTRANG dm where dm.id =  tt.CAPTRINHTIEP ) TENCAPTRINHTIEP
                ,LANTRINH
                ,SOTT
                ,NGAYTT

                  from  GDTTT_TOTRINH_TUHINH  tt    
                  left join GDTTT_DM_TINHTRANG cp on tt.CAPTRINH=cp.ID
                  left join DM_CANBO tl on tt.LANHDAOID=tl.ID
                  left join DM_CANBO tp on tt.TRINHTIEP_LANHDAO_ID=tp.ID
                  ---------- 
                    where    ( V_ID = 0  or tt.id = V_ID)   
                              and ( V_HoSo_ID = 0 or tt.TUHINH_ID = V_HoSo_ID)

                    order by tt.id desc;             
END GDTTTT_DSTOTRINH_TUHINH;



PROCEDURE  GDTTTT_TOTRINH_TUHINH
( 
    v_id  in  number,
    V_TUHINH_ID in number,
    V_SOTT IN VARCHAR2,
    V_NGAYTT IN DATE,
    V_DX_TTV  IN VARCHAR2,
    V_CAPTRINH IN NUMBER,
    V_LANHDAOID IN NUMBER,
    V_NGAYTRINH  IN DATE,
    V_NGAYDUKIENBC  IN DATE,
    V_NGAYNHANTT  IN DATE,
    V_NGAYTRATT  IN DATE,
    V_LOAIYK in number,
    V_NOIDUNGYKIEN IN VARCHAR2,
    V_CAPTRINHTIEP IN NUMBER,
    V_TRINHTIEP_LANHDAO_ID IN NUMBER,
    V_GHICHU   IN VARCHAR2,
    V_USER_ID IN NUMBER
)
IS 

BEGIN
    if v_id >0 then
       update GDTTT_TOTRINH_TUHINH  
                set SOTT=v_SOTT
                    ,NGAYTT=v_NGAYTT
                    ,DX_TTV=v_DX_TTV
                    ,CAPTRINH=v_CAPTRINH
                    ,LANHDAOID=v_LANHDAOID
                    ,NGAYTRINH=v_NGAYTRINH
                    ,NGAYDUKIENBC=v_NGAYDUKIENBC
                    ,NGAYNHANTT =v_NGAYNHANTT
                    ,NGAYTRATT =v_NGAYTRATT
                    ,LOAIYK = v_LOAIYK
                    ,NOIDUNGYKIEN = V_NOIDUNGYKIEN
                    ,CAPTRINHTIEP =V_CAPTRINHTIEP
                    ,TRINHTIEP_LANHDAO_ID = V_TRINHTIEP_LANHDAO_ID
                    ,GHICHU = V_GHICHU
                    ,NGUOISUA = V_USER_ID
                    ,NGAYSUA = sysdate
                where ID =v_id;                
    elsif v_id = 0 then
      insert into GDTTT_TOTRINH_TUHINH 
                        (ID,TUHINH_ID,SOTT,NGAYTT,DX_TTV,CAPTRINH,LANHDAOID,NGAYTRINH,NGAYDUKIENBC,NGAYNHANTT,NGAYTRATT,LOAIYK
                        ,NOIDUNGYKIEN,CAPTRINHTIEP,TRINHTIEP_LANHDAO_ID,GHICHU,NGUOITAO,NGAYTAO)
                        values 
                        (GDTTTT_TOTRINH_TUHINH_UP_SEQ.nextval,V_TUHINH_ID,V_SOTT,V_NGAYTT,V_DX_TTV,V_CAPTRINH,V_LANHDAOID,V_NGAYTRINH,V_NGAYDUKIENBC,V_NGAYNHANTT,V_NGAYTRATT,V_LOAIYK
                        ,V_NOIDUNGYKIEN,V_CAPTRINHTIEP,V_TRINHTIEP_LANHDAO_ID,V_GHICHU,V_USER_ID,SYSDATE);
    end if;
END GDTTTT_TOTRINH_TUHINH; 

PROCEDURE  GDTTTT_DELETE_TTTH
( 
    v_id  in  number)

IS
BEGIN
   if v_id >0 then
            delete GDTTT_TOTRINH_TUHINH where id = v_id;
   end if;
END GDTTTT_DELETE_TTTH;


PROCEDURE  DELETE_GDTTT_TUHINH_VUAN
( 
    v_id  in  number,
    V_Dele out DECIMAL)
IS
    count_hs number;
BEGIN
   if v_id >0 then
    select count(id) into count_hs from GDTTT_TUHINH_VUAN where id = v_id and SOQD_CA IS not NULL;
        if count_hs = 0 then
            delete GDTTT_TUHINH_VUAN where id = v_id;
            V_Dele := 1;
        else
            V_Dele := 0;
        end if;
   end if;
END DELETE_GDTTT_TUHINH_VUAN;

procedure  GDTTT_TUHINH_HOSO_IN(
    v_vuanid    in number,
    v_duongsu_id in number,
    V_NGUOITAO_ID in number,
    vInsert out  DECIMAL
)
is
    vCount number;
    vdonHC_id number;
    vdonid  number;
begin
    IF (v_duongsu_id >0 and v_vuanid >0) then
        select count(id) into vCount from GDTTT_TUHINH_VUAN where DUONGSU_ID = v_duongsu_id and VUAN_ID = v_vuanid;
        -- lấy Donid từ bảng đơn của HCTP
        begin
            select DONID into vdonHC_id from GDTTT_VUAN_DUONGSU where ID = v_duongsu_id;
        EXCEPTION when NO_DATA_FOUND THEN
            vdonHC_id:=0;
        end;
        -- lấy Donid vụ 1 nhập
        begin
            select ID into vdonid from GDTTT_TUHINH_DON where DUONGSUID = v_duongsu_id;
        EXCEPTION when NO_DATA_FOUND THEN
            vdonid:=0;
        end;
        
        if vCount = 0 then
          insert into GDTTT_TUHINH_VUAN 
                (id,VUAN_ID,duongsu_id,DON_ID_VU,DONID,ngaytao,nguoitao)
                values (GDTTT_TUHINH_VUAN_SEQ.nextval,v_vuanid,v_duongsu_id,vdonid,vdonHC_id,sysdate,V_NGUOITAO_ID);
            vInsert := 1;      
        else
            vInsert := 0;   
        end if;
    end if;

end GDTTT_TUHINH_HOSO_IN;


PROCEDURE  GDTTTT_GIAIQUYET_TUHINH_UP
( 
    v_loailuu in number,
    v_id  in number DEFAULT 0,

    v_KETLUAN_CA in number,
    v_SOQD_CA     in varchar2,
    v_NGAYQD_CA in date,
    v_NOIDUNG_QD_CA IN varchar2,

    --v_SOCVGUI_VKS  in varchar2,
    --v_NGAYCVGUI_VKS in date,
    --v_NGAYNHAN_VKS in date,
    v_NGAYPHCV_VKS  in date,
    v_GHICHUCV_GUI in varchar2,
    

    v_SOQD_VKS     in varchar2,
    v_NGAYQD_VKS   in date,
    v_KETLUAN_VKS  in number DEFAULT 0,
    v_SOTT_VKS     in varchar2,
    v_NGAYTT_VKS in date,
    v_NOIDUNGTT_VKS in number,
    v_GHICHU_VKS_TRA in varchar2,

--    v_CTN_NGAYCHUYEN  in date,
--    v_CTN_NGUOICHUYEN_ID in number,
--    v_CTN_NGUOINHAN in varchar2,
--    v_CTN_NGAYNHAN in date,
    v_CTN_SOQĐ    in varchar2,
    v_CTN_NGAYQD in date,
    v_CTN_LOAIQD in number DEFAULT 0,
    v_CTN_NGAYTRA in date,
    v_CTN_GHICHU  in varchar2,

    v_SOCVXM in varchar2,
    v_NGAYCVXM in date,
    v_NOIDUNGXM in varchar2,

    v_LOAIKETQUAXM  in number DEFAULT 0,
    v_NGAYKQXM in date,
    v_NOIDUNG_KQXM  in varchar2,

--    v_THA_SOCV  in varchar2,
--    v_THA_NGAYCV in date,
--    v_THA_NGAYPHCV in date,
    v_THA_KETQUA  in varchar2,
    v_THA_NGAY in date,
    v_THA_DIADIEM  in varchar2,
    v_THA_GHICHU  in varchar2,

    v_LUUHS_NGAYCHUYEN in date,
    v_LUUHS_NGUOICHUYEN_ID  in number,
--    v_LUUHS_NGAYNHAN in date,
    v_LUUHS_NGUOINHAN  in varchar2,
    v_LUUHS_DONVINHAN  in varchar2,
    v_LUUHS_TINHTRANGHS  in varchar2,
--    v_LUUHS_VBLIENQUAN  in varchar2,
--    v_LUUHS_NGAYTRINH_CA in date,
    v_LUUHS_GHICHU  in varchar2

)
IS 
  soqdca varchar2(100);
BEGIN


    if v_id != 0 then
     if v_loailuu = 1 then
      -- Cập nhật kết luận của CA
                update GDTTT_TUHINH_VUAN
                    set
                        KETLUAN_CA = v_KETLUAN_CA,
                        SOQD_CA     = v_SOQD_CA,
                        NGAYQD_CA   = v_NGAYQD_CA,
                        NOIDUNG_QD_CA   =   v_NOIDUNG_QD_CA,
                        NGAYPHCV_VKS = v_NGAYPHCV_VKS,
                        GHICHUCV_GUI  =  v_GHICHUCV_GUI

                    where id = v_id ;   

      ELSIF v_loailuu = 2 then
            -- Cập nhật KL của VKS
            -- insert
                update GDTTT_TUHINH_VUAN
                    set
                        SOQD_VKS = v_SOQD_VKS,
                        NGAYQD_VKS     = v_NGAYQD_VKS,
                        KETLUAN_VKS   = v_KETLUAN_VKS,
                        SOTT_VKS  = v_SOTT_VKS,
                        NGAYTT_VKS   =   v_NGAYTT_VKS,
                        NOIDUNGTT_VKS =   v_NOIDUNGTT_VKS,
                        GHICHU_VKS_TRA = v_GHICHU_VKS_TRA 
                    where id = v_id ;

      ELSIF v_loailuu = 3 then  
         -- Kết luận của Chủ tịch nước
        -- insert

                update GDTTT_TUHINH_VUAN
                    set
--                        CTN_NGUOICHUYEN_ID = v_CTN_NGUOICHUYEN_ID,
--                        CTN_NGAYCHUYEN = v_CTN_NGAYCHUYEN,
--                        CTN_NGUOINHAN = v_CTN_NGUOINHAN,
--                        CTN_NGAYNHAN = v_CTN_NGAYNHAN,
                        CTN_SOQĐ = v_CTN_SOQĐ,
                        CTN_NGAYQD = v_CTN_NGAYQD,
                        CTN_LOAIQD = v_CTN_LOAIQD,
                        CTN_NGAYTRA = v_CTN_NGAYTRA,
                        CTN_GHICHU = v_CTN_GHICHU	
                    where id = v_id ;

      ELSIF v_loailuu = 4 then  
         -- Công văn xác minh
         -- insert
          if v_SOCVXM is not null then
                update GDTTT_TUHINH_VUAN
                    set
                        SOCVXM = v_SOCVXM,
                        NGAYCVXM = v_NGAYCVXM,
                        NOIDUNGXM = v_NOIDUNGXM	
                    where id = v_id ;
        --- xóa
            elsif v_SOCVXM is null then
                update GDTTT_TUHINH_VUAN
                    set
                        SOCVXM = null,
                        NGAYCVXM = null,
                        NOIDUNGXM = null	
                    where id = v_id ;

            end if;
      ELSIF v_loailuu = 5 then  
         -- kết quả xác minh
         if v_LOAIKETQUAXM != 0 then
                update GDTTT_TUHINH_VUAN
                    set 
                        LOAIKETQUAXM = v_LOAIKETQUAXM,
                        NGAYKQXM = v_NGAYKQXM,
                        NOIDUNG_KQXM = v_NOIDUNG_KQXM	
                    where id = v_id ;
          else
            update GDTTT_TUHINH_VUAN
                    set 
                        LOAIKETQUAXM = null,
                        NGAYKQXM = null,
                        NOIDUNG_KQXM = null	
                    where id = v_id ;
          end if;

--      ELSIF v_loailuu = 7 then  
--         -- Vụ GDKT gửi Công văn Thi hành án
--                update GDTTT_TUHINH_VUAN
--                    set   
--                        THA_SOCV	=	v_THA_SOCV,
--                        THA_NGAYCV	=	v_THA_NGAYCV,
--                        THA_NGAYPHCV	=	v_THA_NGAYPHCV
--
--                    where id = v_id ;
       ELSIF v_loailuu = 8 then  
         -- Kết quả Thi hành án
             if v_THA_KETQUA is null then
                    update GDTTT_TUHINH_VUAN
                        set   
                            THA_KETQUA	=	null,
                            THA_NGAY	=	null,
                            THA_DIADIEM	=	null,
                            THA_GHICHU	=	null
                        where id = v_id ;
              else
                    update GDTTT_TUHINH_VUAN
                        set   
                            THA_KETQUA	=	v_THA_KETQUA,
                            THA_NGAY	=	v_THA_NGAY,
                            THA_DIADIEM	=	v_THA_DIADIEM,
                            THA_GHICHU	=	v_THA_GHICHU
                        where id = v_id ;
              end if;

         ELSIF v_loailuu = 9 then  
            if v_LUUHS_NGUOICHUYEN_ID = 0 then -- xóa
                   update GDTTT_TUHINH_VUAN
                        set   
                            LUUHS_NGAYCHUYEN	=	null,
                            LUUHS_NGUOICHUYEN_ID	=	null,
--                            LUUHS_NGAYNHAN	=	null,
                            LUUHS_NGUOINHAN	=	null,
                            LUUHS_DONVINHAN	=	null,
                            LUUHS_TINHTRANGHS	=	null,
--                            LUUHS_VBLIENQUAN	=	null,
--                            LUUHS_NGAYTRINH_CA	=	null,
                            LUUHS_GHICHU	=	null
                        where id = v_id ;  
            else -- insert
                    update GDTTT_TUHINH_VUAN
                            set   
                                LUUHS_NGAYCHUYEN	=	v_LUUHS_NGAYCHUYEN,
                                LUUHS_NGUOICHUYEN_ID	=	v_LUUHS_NGUOICHUYEN_ID,
--                                LUUHS_NGAYNHAN	=	v_LUUHS_NGAYNHAN,
                                LUUHS_NGUOINHAN	=	v_LUUHS_NGUOINHAN,
                                LUUHS_DONVINHAN	=	v_LUUHS_DONVINHAN,
                                LUUHS_TINHTRANGHS	=	v_LUUHS_TINHTRANGHS,
--                                LUUHS_VBLIENQUAN	=	v_LUUHS_VBLIENQUAN,
--                                LUUHS_NGAYTRINH_CA	=	v_LUUHS_NGAYTRINH_CA,
                                LUUHS_GHICHU	=	v_LUUHS_GHICHU
                        where id = v_id ;
          end if;

      end if;
    END IF;

END GDTTTT_GIAIQUYET_TUHINH_UP;



end PKG_GDTTT_VUAN_TUHINH;

/
