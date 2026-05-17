--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_CC" AS
PROCEDURE INS_UP_TRUNG
    (
     V_DON_TRUNG	IN VARCHAR2,
     V_DONID_MOI	IN VARCHAR2,
     V_LOAIAN IN VARCHAR2
    )
AS
    V_COUNT_DS NUMBER;V_COUNT_KN NUMBER;V_COUNT_TD NUMBER;
BEGIN --xử lý trường hợp đơn trùng với đơn,nếu là đơn trùng với vụ án thì lấy bảng GDTTT_VUAN_DUONGSU thay cho bảng GDTTT_DON_DUONGSU_CC
--và bảng GDTTT_VUAN_DUONGSU phải thêm trương ID_TRUNG (để đương sự mới tham chiếu với đơn đương sựu cũ)
        SELECT COUNT(*) INTO V_COUNT_DS FROM GDTTT_DON_DUONGSU_CC WHERE DONID=V_DONID_MOI;
        -----------
        IF(V_COUNT_DS=0)THEN
             INSERT INTO GDTTT_DON_DUONGSU_CC
             (BICAOID,DIACHI,DONID,GIOITINH,HS_BICANDAUVU,HS_ISBICAO,HS_ISKHIEUNAI,HS_LOAIBAKHIEUNAI,HS_MUCAN,HS_NGAYBAKHIEUNAI,
             HS_NOIDUNGKHIEUNAI,HS_SOBAKHIEUNAI,HS_TENTOIDANH,HS_TOARABAKHIEUNAI,HS_TOIDANHID,HS_TUCACHTOTUNG,HUYENID,ID,
             ISINPUTADDRESS,LOAI,NAMSINH,NGAYSUA,NGAYTAO,NGUOISUA,NGUOITAO,TENDUONGSU,TINHID,TRANGTHAI_GET,TUCACHTOTUNG,VUANID,ID_TRUNG)
             SELECT BICAOID,DIACHI,V_DONID_MOI,GIOITINH,HS_BICANDAUVU,HS_ISBICAO,HS_ISKHIEUNAI,HS_LOAIBAKHIEUNAI,HS_MUCAN,HS_NGAYBAKHIEUNAI,
             HS_NOIDUNGKHIEUNAI,HS_SOBAKHIEUNAI,HS_TENTOIDANH,HS_TOARABAKHIEUNAI,HS_TOIDANHID,HS_TUCACHTOTUNG,HUYENID,GDTTT_DON_DUONGSU_CC_SEQ.NEXTVAL,
             ISINPUTADDRESS,LOAI,NAMSINH,NGAYSUA,NGAYTAO,NGUOISUA,NGUOITAO,TENDUONGSU,TINHID,TRANGTHAI_GET,TUCACHTOTUNG,VUANID,ID 
             FROM GDTTT_DON_DUONGSU_CC WHERE DONID=V_DON_TRUNG;
        END IF;
         -------------
         IF(V_LOAIAN='01')THEN
         SELECT COUNT(*) INTO V_COUNT_KN FROM GDTTT_DON_DS_KN_CC WHERE DONID=V_DONID_MOI;
         IF(V_COUNT_KN=0)THEN
             INSERT INTO GDTTT_DON_DS_KN_CC
             (BICAOID,DONID,ID,NGUOIKHIEUNAIID,NOIDUNGKHIEUNAI,VUANID,VUAN_BICAO_NEW,VUAN_NGUOIKHIEUNAI_NEW)
             SELECT BICAOID,V_DONID_MOI,GDTTT_DON_DS_KN_CC_SEQ.NEXTVAL,NGUOIKHIEUNAIID,NOIDUNGKHIEUNAI,VUANID,VUAN_BICAO_NEW,VUAN_NGUOIKHIEUNAI_NEW
             FROM GDTTT_DON_DS_KN_CC WHERE DONID=V_DON_TRUNG;
             FOR REC IN (SELECT DS.* FROM GDTTT_DON_DUONGSU_CC DS WHERE DS.DONID=V_DONID_MOI)--Lấy những đơn mới vừa tạo
             LOOP
                   UPDATE GDTTT_DON_DS_KN_CC --update xác định lại người khiếu nại mới khiếu nại cho bị cáo mới
                   SET BICAOID=REC.ID
                   WHERE BICAOID=REC.ID_TRUNG AND DONID=V_DONID_MOI;
                   UPDATE GDTTT_DON_DS_KN_CC
                   SET NGUOIKHIEUNAIID=REC.ID
                   WHERE NGUOIKHIEUNAIID=REC.ID_TRUNG AND DONID=V_DONID_MOI;
             END LOOP;
         END IF;
         --------------
          SELECT COUNT(*) INTO V_COUNT_TD FROM GDTTT_DON_DUONGSU_TOIDANH_CC WHERE DONID=V_DONID_MOI;
              IF(V_COUNT_TD=0)THEN
               INSERT INTO GDTTT_DON_DUONGSU_TOIDANH_CC
                 (DONID,DUONGSUID,ID,TENTOIDANH,TOIDANHID,VUANID)
                 SELECT V_DONID_MOI,DUONGSUID,GDTTT_DON_DUONGSU_TOIDANH_CC_SEQ.NEXTVAL,TENTOIDANH,TOIDANHID,VUANID
                 FROM GDTTT_DON_DUONGSU_TOIDANH_CC WHERE DONID=V_DON_TRUNG;

                 FOR REC IN (SELECT DS.* FROM GDTTT_DON_DUONGSU_CC DS WHERE DS.DONID=V_DONID_MOI)
                 LOOP
                       UPDATE GDTTT_DON_DUONGSU_TOIDANH_CC
                       SET DUONGSUID=REC.ID
                       WHERE DUONGSUID=REC.ID_TRUNG AND DONID=V_DONID_MOI;
                 END LOOP;
             END IF;
    END IF;
END INS_UP_TRUNG;       
PROCEDURE DON_GETDONTRUNG 
(
  V_LOAIDON  in number,
  v_toaanid in number,
  vCurrDonID in number,
  vNguoiGui IN VARCHAR2,
  vSoBAQD IN VARCHAR2,
  vNgayBAQD IN VARCHAR2,
  vToaXetXu IN VARCHAR2,
  vCapXetXu IN VARCHAR2,
  vIsBanAn IN VARCHAR2,
  curReturn OUT sys_refcursor
) AS 
    v_counts NUMBER;
BEGIN
     v_counts:=0;
     SELECT COUNT(*) INTO v_counts FROM GDTTT_VUAN VA
                      where VA.TOAANID=v_toaanid 
                      and va.TRUONGHOPTHULY in(0,1,2,3)
                      and (vCapXetXu=0 OR (
                                                  (vCapXetXu=2 AND VA.TOAANSOTHAM=vToaXetXu
                                                   AND to_char(VA.NGAYXUSOTHAM,'dd/MM/yyyy')=vNgayBAQD 
                                                   AND UPPER(VA.SOANSOTHAM) LIKE'%'||UPPER(vSoBAQD)||'%'
                                                   ) 
                                                  OR(vCapXetXu=3 AND VA.TOAPHUCTHAMID=vToaXetXu
                                                   AND to_char(VA.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD 
                                                   AND UPPER(VA.SOANPHUCTHAM)LIKE'%'||UPPER(vSoBAQD)||'%'
                                                   )
                                                  OR(vCapXetXu=4 AND VA.TOAQDID=vToaXetXu
                                                   AND to_char(VA.NGAYQD,'dd/MM/yyyy')=vNgayBAQD 
                                                   AND UPPER(VA.SO_QDGDT) LIKE'%'||UPPER(vSoBAQD)||'%'
                                                   )
                                            )
                                );
 IF(v_counts>0)THEN   
    OPEN curReturn FOR
     SELECT va.ID,NULL SOHIEUDON,NULL NGAYNHANDON,VA.NGUOIKHIEUNAI NGUOIGUI_HOTEN,t.MA_TEN TOAXETXU,g.MA_TEN TOAGDTTT 
     ,decode(VA.BAQD_CAPXETXU,2,VA.SOANSOTHAM,3,VA.SOANPHUCTHAM,VA.SO_QDGDT) SOBAQD
     ,decode(VA.BAQD_CAPXETXU,2,VA.NGAYXUSOTHAM,3,VA.NGAYXUPHUCTHAM,VA.NGAYQD)NGAYBAQD
     ,VA.DIACHINGUOIDENGHI Diachigui,va.LOAIAN,DECODE(LA.LOAI_AN_TEN,NULL,NULL,'; Loại án: '||LA.LOAI_AN_TEN)LOAI_AN_TEN
     ,VA.Nguoitao,VA.Ngaytao,VA.ID VUAN_ID
     FROM GDTTT_VUAN VA
     INNER JOIN DM_TOAAN g on g.ID=VA.TOAANID
     LEFT JOIN DM_LOAIAN LA ON VA.LOAIAN=LA.ID
     --LEFT JOIN (SELECT a.ID,a.VUVIECID FROM GDTTT_DON a where  (a.DONTRUNGID IS NULL OR a.DONTRUNGID=0) and a.VUVIECID is not null and a.VUVIECID !=0 )d on d.VUVIECID=VA.ID
     LEFT JOIN DM_TOAAN t on t.ID= decode(VA.BAQD_CAPXETXU,2,VA.TOAANSOTHAM,3,VA.TOAPHUCTHAMID,VA.TOAQDID)
     where  VA.TOAANID=v_toaanid 
      and va.TRUONGHOPTHULY in(0,1,2,3)
      and(vCapXetXu=0 OR (
                                  (vCapXetXu=2 AND VA.TOAANSOTHAM=vToaXetXu
                                   AND to_char(VA.NGAYXUSOTHAM,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(VA.SOANSOTHAM) LIKE'%'||UPPER(vSoBAQD)||'%'
                                   ) 
                                  OR(vCapXetXu=3 AND VA.TOAPHUCTHAMID=vToaXetXu
                                   AND to_char(VA.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(VA.SOANPHUCTHAM)LIKE'%'||UPPER(vSoBAQD)||'%'
                                   )
                                  OR(vCapXetXu=4 AND VA.TOAQDID=vToaXetXu
                                   AND to_char(VA.NGAYQD,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(VA.SO_QDGDT) LIKE'%'||UPPER(vSoBAQD)||'%'
                                   )
                            )
                )
       Order by VA.Ngaytao desc;
 ELSIF(v_counts=0)THEN
  --vIsBanAn:0 Bản án,2 Quyết định,1 QĐ kháng nghị;--anhvh add 27/04/2021
  OPEN curReturn FOR
  select a.ID,a.SOHIEUDON,a.NGAYNHANDON,a.NGUOIGUI_HOTEN,t.MA_TEN TOAXETXU,g.MA_TEN TOAGDTTT,
        decode(vIsBanAn,1,a.KN_SOQD,decode(a.BAQD_CAPXETXU,2,a.BAQD_SO_ST,3,a.BAQD_SO_PT,a.BAQD_SO_ST)) SOBAQD,
        decode(vIsBanAn,1,a.KN_NGAY,decode(a.BAQD_CAPXETXU,2,a.BAQD_NGAYBA_ST,3,a.BAQD_NGAYBA_PT,a.BAQD_NGAYBA))NGAYBAQD
        ,a.NGUOIGUI_DIACHI ||(case when (a.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui
        ,a.Nguoitao,a.Ngaytao,NULL VUAN_ID,a.BAQD_LOAIAN LOAIAN,DECODE(LA.LOAI_AN_TEN,NULL,NULL,'; Loại án: '||LA.LOAI_AN_TEN)LOAI_AN_TEN
  from GDTTT_DON a
  inner join DM_TOAAN g on g.ID=a.TOAANID
  left join DM_TOAAN t on t.ID= decode(a.BAQD_CAPXETXU,2,a.BAQD_TOAANID_ST,3,a.BAQD_TOAANID_PT,a.BAQD_TOAANID)
  left join DM_HANHCHINH h on a.NGUOIGUI_HUYENID=h.ID
  LEFT JOIN DM_LOAIAN LA ON a.BAQD_LOAIAN=LA.ID
  where   a.TOAANID=v_toaanid AND a.LOAIDON=V_LOAIDON
         and (vCurrDonID=0 OR (a.ID=vCurrDonID AND NVL(a.DONTRUNGID,0)!=0) )
         AND(a.DONTRUNGID IS NULL OR a.DONTRUNGID=0)--thụ lý mới
         AND (vNguoiGui IS NULL OR (lower(a.NGUOIGUI_HOTEN)=lower(vNguoiGui) AND vNguoiGui IS NOT NULL ))  
         AND a.BAQD_LOAIQDBA=vIsBanAn
         AND  (vCapXetXu=0 OR (
                                  (vCapXetXu=2 AND a.BAQD_TOAANID_ST=vToaXetXu
                                   AND to_char(a.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(a.BAQD_SO_ST) LIKE'%'||UPPER(vSoBAQD)||'%'
                                   ) 
                                  OR(vCapXetXu=3 AND a.BAQD_TOAANID_PT=vToaXetXu
                                   AND to_char(a.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(a.BAQD_SO_PT)LIKE'%'||UPPER(vSoBAQD)||'%'
                                   )
                                  OR(vCapXetXu=4 AND a.BAQD_TOAANID=vToaXetXu
                                   AND to_char(a.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                   AND UPPER(a.BAQD_SO) LIKE'%'||UPPER(vSoBAQD)||'%'
                                   )
                            )
                )
       Order by a.Ngaytao desc;
    END IF;   
END DON_GETDONTRUNG;
PROCEDURE GDTTT_LOAD_DONVI
( 
  V_LOAIANID IN varchar2,
  V_TOAANID IN varchar2,
  curReturn OUT sys_refcursor
)
IS 
BEGIN
    OPEN curReturn FOR
     SELECT TT.ID PHONGBAN_ID FROM (
                    SELECT decode(ISHINHSU,1,','||1)||decode(ISDANSU,1,','||2) ||decode(ISHNGD,1,','||3)||decode(ISKDTM,1,','||4)
                    ||decode(ISLAODONG,1,','||5)||decode(ISHANHCHINH,1,','||6)||decode(ISPHASAN,1,','||7)||',' LOAIAN
                    ,pb.ID,PB.TOAANID
                    FROM DM_PHONGBAN pb WHERE ((V_TOAANID=6 AND pb.ID in (14,15,16)) OR  (V_TOAANID=1 AND pb.ID in (2,3,4)) OR  (V_TOAANID=5 AND pb.ID in (10,11)) 
                    OR  (V_TOAANID=4 AND pb.ID in (6,7,8)) )
)TT WHERE INSTR(TT.LOAIAN,','||replace(V_LOAIANID,'0','')||',')>0 AND TT.TOAANID=V_TOAANID;
end GDTTT_LOAD_DONVI;
PROCEDURE GDTTT_AHS_GETALLBYLOAIDS
( 
  VDONID in number,
  type_ds in number, 
  curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
        Select ROW_NUMBER() OVER (ORDER BY TuCachToTung, NgayTao) STT
          , ID, VuAnId, TenDuongSu, TuCachToTung
          , HS_BiCanDauVu, NVL(HS_IsKhieuNai, 0) HS_IsKhieuNai 

          , case when TuCachToTung like '%BIDON%' and NVL(HS_BiCanDauVu,0)=1 then 'Bị cáo đầu vụ'
                 when TuCachToTung like '%BIDON%' and NVL(HS_BiCanDauVu,0)=0 then 'Bị cáo khiếu nại'
                 when TuCachToTung like 'KHAC' then
                      (case when NVL(HS_IsKhieuNai, 0)=1 
                                then 'Người khiếu nại' ||  (case when Length(NVL(HS_TuCachToTung, ''))>0 
                                                                      then ' ('||HS_TuCachToTung||')'
                                                              else '' end)
                       else HS_tucachtotung end)
                else hs_tucachtotung  end as DuongSu_TuCachToTung
          , hs_tucachtotung 
          , HS_TenToiDanh,DiaChi, HS_MucAn, HS_LoaiBAKhieuNai
          , NVL(HS_NoiDungKhieuNai,'') HS_NoiDungKhieuNai
          , ((case when Length(NVL(HS_SOBAKHIEUNAI, ''))>0 then 'Số BA: '|| cast(hs_soBAKhieuNai as varchar2(100))
                 else '' end)
                || (case when (Length(NVL(HS_NGAYBAKHIEUNAI,''))=0 
                              or (to_char(HS_NGAYBAKHIEUNAI,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(HS_NGAYBAKHIEUNAI,'')) >0
                              then ' Ngày BA '||to_char(HS_NGAYBAKHIEUNAI,'dd/MM/yyyy')
                        end)
                || case when Length(NVL(HS_SOBAKHIEUNAI, ''))>0  
                             or Length(NVL(HS_NGAYBAKHIEUNAI,'')) >0 then '<br/>'
                        else '' end
                || HS_NoiDungKhieuNai
            ) NoiDungKhieuNai
        from GDTTT_DON_DUONGSU_CC   
        where DONID =VDONID        
             and 1= case when (type_ds>2) then 1 
                         when  (type_ds=2) and NVL(HS_IsKhieuNai,0) =1 then 1 
                         when  ((type_ds=0) or (type_ds=1))
                               and (NVL(HS_ISBICAO,0) =1 or  NVL(HS_BiCanDauVu,0) =1) then 1 
                     end
        order by VuAnID;
end GDTTT_AHS_GetAllByLoaiDS;
PROCEDURE GDTTT_DS_TOIDANH_GETALL
( 
   VDONID in number,
   vTucachtotung varchar2,
   isDauVu in number,
   curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
        Select ROW_NUMBER() OVER (ORDER BY NVL(ds.HS_IsKhieuNai, 0) desc
                                       , NVL(ds.HS_BiCanDauVu, 0) desc
                                       , NVL(ds.HS_IsBiCao, 0) desc) STT
          , ds.ID, ds.VuAnId, ds.TenDuongSu, ds.TuCachToTung
          , NVL(ds.HS_BiCanDauVu,0) HS_BiCanDauVu          
          , NVL(ds.HS_IsBiCao, 0) HS_IsBiCao
          , NVL(ds.HS_IsKhieuNai, 0) HS_IsKhieuNai , case when NVL(ds.HS_IsKhieuNai, 0)=1 then 'Có' else '' end as CheckKN

          , (GDTTT_AHS_GetTuCachTT(NVL(ds.HS_BICANDAUVU, 0)
                                  , NVL(ds.HS_ISBICAO, 0), NVL(ds.HS_ISKHIEUNAI, 0))
          ||(case when Length(NVL(ds.HS_TuCachToTung, ''))>0 
                       then ' ('||ds.HS_TuCachToTung||')'
             else '' end)
             ) as DuongSu_TuCachToTung
          , hs_tucachtotung 

          , ds.HS_TenToiDanh,ds.DiaChi, ds.HS_MucAn, ds.HS_LoaiBAKhieuNai
          , NVL(ds.HS_NoiDungKhieuNai,'') HS_NoiDungKhieuNai
          , ((case when Length(NVL(ds.HS_SOBAKHIEUNAI, ''))>0 then 'Số BA: '|| cast(ds.hs_soBAKhieuNai as varchar2(100))
                 else '' end)
                || (case when (Length(NVL(ds.HS_NGAYBAKHIEUNAI,''))=0 
                              or (to_char(ds.HS_NGAYBAKHIEUNAI,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(ds.HS_NGAYBAKHIEUNAI,'')) >0
                              then ' Ngày BA '||to_char(ds.HS_NGAYBAKHIEUNAI,'dd/MM/yyyy')
                        end)
                || case when Length(NVL(ds.HS_SOBAKHIEUNAI, ''))>0  
                             or Length(NVL(ds.HS_NGAYBAKHIEUNAI,'')) >0 then '<br/>'
                        else '' end
                || HS_NoiDungKhieuNai
            ) NoiDungKhieuNai
            ,d.CD_TRANGTHAI,ds.DONID
        from GDTTT_DON_DUONGSU_CC ds
        left join gdttt_don d on ds.DONID=d.id
        where ds.DONID =VDONID            
             and 1= case when (vTucachtotung is null) then 1 
                         when  (vTucachtotung is not null) 
                              and TuCachToTung = vTucachtotung and isDauVu=2 then 1 
                         when  (vTucachtotung is not null) and ds.TuCachToTung = vTucachtotung 
                              and isDauVu<2 and NVL(ds.hs_Bicandauvu,0)=isDauVu then 1 end
        order by DONID;
end GDTTT_DS_TOIDANH_GETALL;
PROCEDURE GDTTT_AHS_GETBICAOKN_BYNGUOIKN
( 
  VDONID in number,
  vNguoiKhieuNaiID in number,
  curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR

      select ROW_NUMBER() OVER (ORDER BY NVL(bc.HS_IsKhieuNai, 0) desc
                                       , NVL(bc.HS_BiCanDauVu, 0) desc
                                       , NVL(bc.HS_IsBiCao, 0) desc) stt
        ,1 as Rowspan
        , b.ID, b.VuAnID, b.NguoiKhieuNaiId 
        , b.biCaoId,bc.TuCachToTung, bc.TenDuongSu BiCaoName
        , NVL(bc.HS_MucAn,'') HS_MucAn
         , NVL(bc.HS_tuCachToTung, '') HS_tuCachToTung
        , NVL(bc.HS_BiCanDauVu,0) HS_BiCanDauVu          
        , NVL(bc.HS_IsBiCao, 0) HS_IsBiCao
        , NVL(bc.HS_IsKhieuNai, 0) HS_IsKhieuNai
        , GDTTT_AHS_GetTuCachTT(NVL(bc.HS_BICANDAUVU, 0)
                              , NVL(bc.HS_ISBICAO, 0), NVL(bc.HS_ISKHIEUNAI, 0)) as BiCao_TuCachTT
        , bc.HS_TenToiDanh as ListToiDanhBC
        , NVL(b.NOIDUNGKHIEUNAI,'') NoiDungKhieuNai
      from GDTTT_DON_DS_KN_CC b 
         inner join (select * from GDTTT_DON_DUONGSU_CC where DONID =VDONID
                     ) bc on b.BiCaoID = bc.ID 
      where b.DONID =VDONID and b.NguoiKhieuNaiID =vNguoiKhieuNaiID
   UNION ALL
      select ROW_NUMBER() OVER (ORDER BY NVL(NguoiKhieuNaiId, 0) desc) stt
        ,1 as Rowspan
        , ID, VuAnID,NguoiKhieuNaiId 
        , biCaoId
        , null TuCachToTung
        ,null BiCaoName
        , null HS_MucAn
         , null HS_tuCachToTung
        , null HS_BiCanDauVu          
        , null HS_IsBiCao
        , null HS_IsKhieuNai
        , null BiCao_TuCachTT
        , null  ListToiDanhBC
        , NVL(NOIDUNGKHIEUNAI,'') NoiDungKhieuNai
      from GDTTT_DON_DS_KN_CC where BiCaoID = 1 and DONID =VDONID and NguoiKhieuNaiID =vNguoiKhieuNaiID 
      ;
end GDTTT_AHS_GETBICAOKN_BYNGUOIKN;
PROCEDURE   GDTTT_VUANDS_GETBYDON
(
  VDONID in number,
  vTucachtotung in nvarchar2,
  CurReturn OUT sys_refcursor 
) AS 
Begin
  open CurReturn for
    select a.ID, a.VuAnID, a.TuCachToTung,NVL(a.HUYENID,0) HUYENID
      --, Decode(a.GioiTinh, 0, N'Nữ', 1, N'Nam', 2, N'') GioiTinh
      , a.Loai, Decode(a.Loai, 0, u'C\00e1 nh\00e2n', 1,u'C\01a1 quan', 2, u'T\1ed5 ch\1ee9c') LoaiDuongSu
      , a.TenDuongSu, a.DiaChi, 1 IsDelete      
      , NVL(a.ISINPUTADDRESS,0) ISINPUTADDRESS
      , a.TuCachToTung
     /* , a.HS_BiCanDauVu  
      --, a.HS_ToiDanhID, a.HS_TenToiDanh
      , a.HS_MUCAN  -- muc an cua bị can 

      , a.HS_LoaiBAKhieuNai, a.HS_SoBAKhieuNai, a.HS_NgayBAKhieuNai
      , a.HS_ToaRaBAKhieuNai
      --, a.HS_NoiDungKhieuNai
      ,(SELECT LISTAGG(cast(dt.TenToiDanh as varchar2(2000)), ',')
               WITHIN GROUP (ORDER BY dt.DuongSuID, dt.VuAnID) FROM GDTTT_VuAn_DuongSu_ToiDanh dt 
               WHERE  dt.DuongSuID=a.ID) DsToiDanh*/
      ,d.CD_TRANGTHAI         
    from GDTTT_DON_DUONGSU_CC a 
    LEFT JOIN GDTTT_DON D on a.DONID=d.ID
    where a.DONID =VDONID  and (lower(a.TuCachToTung) like lower(vTucachtotung))
    order by a.TuCachToTung, a.TenDuongSu;
END GDTTT_VUANDS_GETBYDON;
FUNCTION GDTTT_DON_CC_REID
RETURN NUMBER
AS
       V_DONID NUMBER;
BEGIN
    SELECT GDTTT_DON_CC_SEQ.NEXTVAL INTO V_DONID FROM DUAL;
    RETURN V_DONID;
END;     
FUNCTION GDTTT_VUAN_REID
RETURN NUMBER
AS
       V_VUANID NUMBER;
BEGIN
    SELECT GDTTT_VUAN_SEQ.NEXTVAL INTO V_VUANID FROM DUAL;
    RETURN V_VUANID;
END;    
PROCEDURE UPDATE_GDTTT_DON_FORM_VT
( 
  curReturn OUT sys_refcursor
)
IS 
    ID_ NUMBER;
BEGIN  
        FOR REC IN (
                select D.ID,V.SO_HS,V.NGAY_HS,V.DONVICHUYEN_HS
                ,D.SO_HSKN,D.NGAY_HSKN,D.DONVICHUYEN_HSKN from GDTTT_DON D
                INNER JOIN VT_CHUYEN_NHAN  CN ON CN.GDTTT_DON_ID=D.ID
                INNER JOIN VT_VANBANDEN V ON V.ID=CN.VANBANDEN_ID
                WHERE D.LOAIDON=4
          )
        LOOP
                   UPDATE GDTTT_DON
                   SET SO_HSKN=REC.SO_HS,NGAY_HSKN=REC.NGAY_HS,DONVICHUYEN_HSKN=REC.DONVICHUYEN_HS
                   WHERE ID=REC.ID AND LOAIDON=4;
                   ID_:=REC.ID;
                   DBMS_OUTPUT.PUT_LINE(ID_);
                   COMMIT;
            OPEN curReturn FOR
            SELECT ID_ V_ID FROM DUAL;
        END LOOP;
END UPDATE_GDTTT_DON_FORM_VT;
------
PROCEDURE UP_GDTTTDON_NGUOIDUNGDON
( 
  curReturn OUT sys_refcursor
)
IS 
    count_item NUMBER;
BEGIN  
    count_item:=0;
    FOR item IN (
                SELECT D.ID,VT.NGUOIDUNGDON,D.NGUOIGUI_HOTEN,VT.DIACHI_NDD,D.NGUOIGUI_DIACHI FROM GDTTT_DON D 
                INNER JOIN VT_CHUYEN_NHAN CN ON  CN.GDTTT_DON_ID=D.ID
                INNER JOIN VT_VANBANDEN VT ON VT.ID=CN.VANBANDEN_ID
                WHERE D.LOAIDON IN (1,3)
            )
        LOOP
                UPDATE GDTTT_DON
                SET NGUOIGUI_HOTEN=item.NGUOIDUNGDON, NGUOIGUI_DIACHI=item.DIACHI_NDD
                where id=item.id;
                count_item:=count_item+1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('count_item = ' || count_item);
       -- COMMIT;
        OPEN curReturn FOR
        SELECT count_item count_item FROM DUAL;
END UP_GDTTTDON_NGUOIDUNGDON;
-------------------------------
PROCEDURE SO_THU_LY
(
  V_TOAANID IN VARCHAR2,
  V_LOAI_VB IN VARCHAR2,
  V_BAQD_LOAIAN IN VARCHAR2,
  V_SOTL OUT NUMBER
)
AS   
BEGIN       
    V_SOTL:=0;
    SELECT nvl(Max(to_number(regexp_replace(D.TL_SO, '[^[:digit:]]', ''))),0)INTO V_SOTL FROM GDTTT_DON D
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.TL_NGAY, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))
    AND(V_LOAI_VB not in (4,8,10)   
            OR (D.LOAIDON=V_LOAI_VB AND V_LOAI_VB  = 4) --LOAIDON=4 Hồ sơ Kháng nghị GĐT,TT
            Or (D.LOAIDON in (8,10) AND V_LOAI_VB in (8,10)) -- Lay so theo don Khieu nai tu phap
            )  
    AND D.TOAANID=V_TOAANID AND D.BAQD_LOAIAN=V_BAQD_LOAIAN AND TRIM(D.TL_SO) IS NOT NULL
    AND D.NGUOITAO NOT IN ('phong1hsxx.cchcm','phong2DSXX.cchcm','phong2.KDTMXX.cchcm','phong1.cchcm','phong3.HNGD.cchcm',
'phong3.HNGDXX.cchcm','phong2DS.cchcm','phong3.LDXX.cchcm','phong2.KDTM.cchcm','phong3.LD.cchcm','phong1hs.cchcm');
    V_SOTL := V_SOTL+1;   
END; 

PROCEDURE DON_TL_CHECK_CC
(   vdonviID in number,
    vYear in number,
    vLoaiAn in number,
    vTL_SO in varchar2,
    vHinhThucDon in number,
    vDonID in number,
	curReturn    OUT       sys_refcursor
)
IS 
    vY number;
BEGIN
    vY:=vYear;
    OPEN curReturn FOR  
          Select d.ID
          From GDTTT_DON d 
          Where  d.TOAANID=vdonviID 
            And d.isthuly = 1
            and d.BAQD_LOAIAN=vLoaiAn 
            and d.TL_SO=trim(vTL_SO) 
          AND d.TL_NGAY between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
          AND(vHinhThucDon not in (4,8,10)   
            OR (D.LOAIDON= vHinhThucDon AND vHinhThucDon  = 4) --LOAIDON=4 Hồ sơ Kháng nghị GĐT,TT
            Or (D.LOAIDON in (8,10) AND vHinhThucDon in (8,10)) -- Lay so theo don Khieu nai tu phap
            )
          and d.ID != vDonID
          ;
        --  and d.TL_NGAY between TO_DATE(Cast((vY-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-11-30','YYYY-MM-DD'); 
END DON_TL_CHECK_CC;

PROCEDURE UP_VANTHU_V_NULL
(
    V_DON_ID IN VARCHAR2
)
AS 
BEGIN
    --hàm up lại thông tin Người đứng đơn và Công văn chuyển đơn
            FOR item IN (
            SELECT VT.ID VTID,D.ID DON_ID,TO_CHAR(VT.NGAY_TAO,'dd/MM/yyyy') NGAY_TAOVT,VT.NGUOIDUNGDON NGUOIDUNGDONVT,
                D.BAQD_SO,D.BAQD_SO_PT,D.BAQD_SO_ST,D.BAQD_NGAYBA,D.BAQD_NGAYBA_PT,D.BAQD_NGAYBA_ST,
                TO_CHAR(D.NGAYGHITRENDON,'dd/MM/yyyy') NGAYGHITRENDON,D.DONTRUNGID,vt.SOLUONG_DON
                ,VT.DIACHI_NDD_ID,VT.DIACHI_NDD,d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,D.NGUOIGUI_HOTEN,D.DONGKHIEUNAI
                ,d.CV_SO,vt.SO_CV,d.CV_NGAY,vt.NGAY_CV,d.CV_TENDONVI,vt.DONVICHUYEN_CV,d.NOIDUNGDON,vt.NOIDUNG_CV
            FROM VT_VANBANDEN vt
            INNER JOIN VT_CHUYEN_NHAN CN ON CN.VANBANDEN_ID=VT.ID
            INNER JOIN GDTTT_DON D ON D.ID=CN.GDTTT_DON_ID
            WHERE VT.LOAI_VB=3 AND CN.TRANG_THAI_XLY=4
            AND D.ID=V_DON_ID
            ORDER BY VT.NGAY_TAO DESC
           )
           LOOP
                     --DIACHI_NDD_ID
                     UPDATE VT_VANBANDEN 
                     SET DIACHI_NDD_ID=item.NGUOIGUI_HUYENID
                     where id=item.vtid and DIACHI_NDD_ID=0;
                     --DIACHI_NDD
                     UPDATE VT_VANBANDEN 
                     SET DIACHI_NDD=item.NGUOIGUI_DIACHI
                     where id=item.vtid and DIACHI_NDD is null;
                      --NGUOIGUI_HOTEN
                     UPDATE GDTTT_DON 
                     SET NGUOIGUI_HOTEN=item.DONGKHIEUNAI
                     where id=item.don_id and NGUOIGUI_HOTEN is null;
                      --NGUOIDUNGDON
                     UPDATE VT_VANBANDEN 
                     SET NGUOIDUNGDON=item.DONGKHIEUNAI
                     where id=item.vtid and NGUOIDUNGDON is null;
                      --SOLUONG_DON
                     UPDATE VT_VANBANDEN 
                     SET SOLUONG_DON=1
                     where id=item.vtid and SOLUONG_DON=0 AND item.NGUOIDUNGDONVT is null;
                     --CV_SO
                     UPDATE VT_VANBANDEN 
                     SET SO_CV=item.CV_SO
                     where id=item.vtid and SO_CV is null;
                      --NGAY_CV
                     UPDATE VT_VANBANDEN 
                     SET NGAY_CV=item.CV_NGAY
                     where id=item.vtid 
                     AND  (to_char(NGAY_CV,'dd/MM/yyyy')='01/01/0001' OR NGAY_CV IS NULL);
                      --DONVICHUYEN_CV
                     UPDATE VT_VANBANDEN 
                     SET DONVICHUYEN_CV=item.CV_TENDONVI
                     where id=item.vtid and DONVICHUYEN_CV is null;
                    --NOIDUNG_CV
                     UPDATE VT_VANBANDEN 
                     SET NOIDUNG_CV=item.NOIDUNGDON
                     where id=item.vtid and NOIDUNG_CV is null;
           END LOOP;
END;
PROCEDURE GDTTTT_HOSO_INPHIEU
( 
  vToaAnID in number,
  vPhieuID in number,
  curReturn OUT sys_refcursor
)
IS 
    vGDTTT_QUANLYHS GDTTT_QUANLYHS%rowtype;
    vGDTTT_VUAN     GDTTT_VUAN%rowtype;
    vLoaian varchar2(100);
    V_COUNT NUMBER;
    V_TENPHONGBANGUI varchar2(250);
    V_TENDONVI varchar2(250);
    V_TENDONVI_FULL varchar2(250);
    V_DONVI_CV varchar2(250);
    V_TENDONVI_HC varchar2(250);

    V_TENDONVI_HC_GIUHS varchar2(250);
    V_TENVUAN varchar2(2000);
    V_TENTOAXETXU varchar2(500);

    v_CAPXX varchar2(250);
    v_SOBA   varchar2(250);
    v_NGAYXX varchar2(250);
    V_EXPORT_TEXT clob;

BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     -- Truy van ten don vi in Phieu  
    SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
         ,replace(HC.TEN,'thành phố ','') INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
         LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
         WHERE TA.ID= vToaAnID;  
     -- Truy van lay thong tin phieu
    Select hs.* into vGDTTT_QUANLYHS from GDTTT_QUANLYHS  hs where hs.ID = vPhieuID;

     --Truy vấn ten don vi giu ho so-------
    if (NVL(vGDTTT_QUANLYHS.TOAANMUONHSID,0)>0) then
         SELECT TA.TEN INTO V_TENDONVI_HC_GIUHS FROM DM_TOAAN TA WHERE TA.ID= vGDTTT_QUANLYHS.TOAANMUONHSID;
    end if;
    -- Lay ten phong ban
    IF NVL(vGDTTT_QUANLYHS.VUANID,0) >0 THEN
        SELECT P.TENPHONGBAN INTO V_TENPHONGBANGUI FROM DM_PHONGBAN P WHERE P.ID = (SELECT V.PHONGBANID FROM GDTTT_VUAN V WHERE V.ID = vGDTTT_QUANLYHS.VUANID);
        SELECT V.* INTO vGDTTT_VUAN FROM GDTTT_VUAN V WHERE V.ID = vGDTTT_QUANLYHS.VUANID;
        IF (NVL(vGDTTT_VUAN.BAQD_CAPXETXU,0) = 4 AND NVL(vGDTTT_VUAN.TOAQDID,0) > 0) THEN 
            SELECT TA.TEN INTO V_TENTOAXETXU FROM DM_TOAAN TA WHERE TA.ID= vGDTTT_VUAN.TOAQDID;
        ELSIF (NVL(vGDTTT_VUAN.BAQD_CAPXETXU,0) = 3 AND NVL(vGDTTT_VUAN.TOAPHUCTHAMID,0) > 0) THEN 
            SELECT TA.TEN INTO V_TENTOAXETXU FROM DM_TOAAN TA WHERE TA.ID= vGDTTT_VUAN.TOAPHUCTHAMID;
        ELSIF  (NVL(vGDTTT_VUAN.BAQD_CAPXETXU,0) = 3 AND NVL(vGDTTT_VUAN.TOAANSOTHAM,0) > 0) THEN 
            SELECT TA.TEN INTO V_TENTOAXETXU FROM DM_TOAAN TA WHERE TA.ID= vGDTTT_VUAN.TOAANSOTHAM;
        END IF;
    ELSE
            V_TENTOAXETXU := NULL;    
    END IF;

    --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');

    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
               <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                        <th colspan ="3" style="width: 250px;"><span>TÒA ÁN NHÂN DÂN CẤP CAO</span></th>
                        </tr>
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 65px; text-align: right;"><span>TẠI</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: center;">
                                <span>THÀNH PHỐ</span>
                            </th>
                            <th style="text-align: left;"><span>'||Upper(V_TENDONVI_HC)||'</span></th>
                        </tr>
                    </table>
                </td>
                <th style="text-align: center; vertical-align: top; font-size: 12pt;">
                    <table cellpadding="0" cellspacing="0">
                        <tr><th colspan="3" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th></tr>
                        <tr><th style="width: 80px;"><span style="color: #ffffff;">....</span></th>
                            <th style="width: 240px;border-bottom: 1px solid #000000; text-align: center;">
                                <span>Độc lập - Tự do - Hạnh phúc</span></th>
                            <th style="width: 80px;"><span style="color: #ffffff;">....</span></th>
                        </tr>
                    </table>
                </th>
            </tr>
            <tr style="text-align: center;">
                <td style="font-size: 13pt">Số: '||vGDTTT_QUANLYHS.SOPHIEU||'/CV-'||V_DONVI_CV||'</td>
                <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="font-size: 13pt"></td>');
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                            <td style="font-size: 13pt; font-style: italic">Tp.'||V_TENDONVI_HC||', ngày <span>'||to_char(vGDTTT_QUANLYHS.NGAYTAO,'dd')||'</span> tháng <span>'||to_char(vGDTTT_QUANLYHS.NGAYTAO,'MM')||'</span> năm <span>'||to_char(vGDTTT_QUANLYHS.NGAYTAO,'yyyy')||'</span></td>
                            ');

         DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                        </tr>
                    </table>
                </td>
            </tr>

            <tr style="">
                <td></td>
                <td></td>
            </tr>

            <tr style="height: 20px;">
                <td style="width: 500px"></td>
                <td style="width: 750px"></td>
            </tr>
        </table>
        <table>
            <tr><td style="font-size: 14pt; text-align: left;width: 190px">
                <span style="color:white;">.......................</span>Kính gửi:</td>
                <td  style="font-size: 14pt; text-align: left;"> '||V_TENDONVI_HC_GIUHS||'</span></td>
            </tr>
        </table>
             ');    

           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">............</span>
            Căn cứ vào khoản 1 Điều 20 Luật Tổ chức Tòa án nhân dân và Điều 18 Bộ luật tố tụng dân sự;.</p>
           '); 

          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span>
          Để có cơ sở giải quyết đơn đề nghị xem xét theo thủ tục giám đốc thẩm/ tái thẩm của đương sự, đề nghị '
          ||V_TENDONVI_HC_GIUHS||' chỉ đạo chuyển cho '||V_TENPHONGBANGUI||' - '||V_TENDONVI_FULL ||'hồ sơ vụ án "'
          ||vGDTTT_VUAN.TENVUAN||'" giữa các đương sự là:</p>');

          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span>
          - Nguyên đơn: '||vGDTTT_VUAN.NGUYENDON||'</p>');
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span>
          - Bị đơn: '||vGDTTT_VUAN.BIDON||'</p>');

          IF (NVL(vGDTTT_VUAN.BAQD_CAPXETXU,0) = 2) THEN
            v_CAPXX := 'sơ thẩm';
            v_SOBA  := vGDTTT_VUAN.SOANSOTHAM;
            v_NGAYXX:= TO_char(vGDTTT_VUAN.NGAYXUSOTHAM,'dd/MM/yyyy');
          ELSE
            v_CAPXX := 'phúc thẩm';
            v_SOBA  := vGDTTT_VUAN.SOANPHUCTHAM;
            v_NGAYXX:= TO_char(vGDTTT_VUAN.NGAYXUPHUCTHAM,'dd/MM/yyyy');
          END IF;
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">............</span>
          Do '||V_TENTOAXETXU||' xét xử '||v_CAPXX||' tại Bản án '||v_CAPXX||' số '||v_SOBA||' ngày '||v_NGAYXX||'.</p>');
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">............</span>
          <i>(Hồ sơ xin gửi phát nhanh theo địa chỉ: '||V_TENPHONGBANGUI||' - '||V_TENDONVI_FULL ||')</i></p>');

          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                            <i><b>Nơi nhận:</b></i><br/>
                            - Như trên;<br />
                            - Lưu: Lưu VT, '||V_TENPHONGBANGUI||';
                        </p>
                    </td>
                    <td>
                         <p style="font-size:13pt;">
                              <strong>
                                TL. CHÁNH ÁN<br />
                                KT. TRƯỞNG '||UPPER(V_TENPHONGBANGUI)||'
                            </strong>
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');

    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
            ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
            <br clear=all style="mso-special-character:line-break;page-break-before:always">
            </span>
            ');
    -- Day du ra         
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END GDTTTT_HOSO_INPHIEU;


END PKG_GDTTT_CC;
