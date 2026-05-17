--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_BC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_BC" AS


PROCEDURE DON_SEARCH_TTRINH_PHANCONG
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  VLOAISOVB in varchar2,
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
  V_TENPHONGBANGUI varchar2(250);V_TENDONVI varchar2(250);V_COUNT NUMBER;V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DON_SEARCH;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(250);V_CD_NGUOIKY varchar2(250);V_NGUOIKY_CHUCVU  varchar2(250);
  V_CD_NGAYCV date;V_LOAIDON8_1 clob;V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(250);V_CD_NGAYTOTRINH DATE;V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DON_SEARCH();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
       IF(V_ID=1023 or V_CAPCHAID=1023) then
         V_LOAIDON8_1 := ' (do Đại biểu quốc hội, Các Cơ quan của Quốc hội, Đoàn đại biểu Quốc hội chuyển đến)';
       end if;
 END IF;
 --------
 
  FOR item IN (
          Select (case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                  when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                  when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                  when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
             ,D.ID,D.BAQD_LOAIAN,LA.LOAI_AN_TEN,D.NGAYTAO  
             
              ,SOTTXX.SOVB||SOTT_TLL.SOVB||SOTT.SOVB as CD_SOTOTRINH
              ,SOTTXX.NGAYVB||SOTT_TLL.NGAYVB||SOTT.NGAYVB as CD_NGAYTOTRINH
             ,SOTTXX.NGUOIKY||SOTT_TLL.NGUOIKY||SOTT.NGUOIKY as CD_NGUOIKY
              ,SOTTXX.CHUCVU||SOTT_TLL.CHUCVU||SOTT.CHUCVU as CD_NGUOIKY_CHUCVU
           ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
             WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
              and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                      and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                      and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                      and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                        and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
             ) arrDonID
            from GDTTT_DON d
                
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SOTT on SOTT.donid = d.id
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SOTTXX on SOTTXX.donid = d.id             
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SOTT_TLL on SOTT_TLL.donid = d.id
                            
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                and (vIsThuLy = -1 
                        OR (vIsThuLy=1 and ((vToaAnID = 1 and d.ISTHULY=1 and d.LOAIDON != 4 ) 
                                             OR (vToaAnID != 1 and d.ISTHULY=1) )  ) 
                        OR (vIsThuLy = 2 and d.ISTHULY=2) 
                        OR (vIsThuLy = 3 and d.ISTHULY=1 and d.ARR_DON_ID>0)
                        OR (vIsThuLy = 4 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)
                        OR (vIsThuLy = 5 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)
                        OR (vIsThuLy = 6 and (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4))
                      )
              
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
                and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                                                                    (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                                    Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                        (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
                 and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
                AND (VSOCONGVAN IS NULL 
                         OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where b.SOTHONGBAO =VSOCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND so.SOVB =VSOCONGVAN  AND sd.donid =  D.id)
                            )
                                                
                   )

                 AND (VNGAYCONGVAN IS NULL 
                       OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') =VNGAYCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') =VNGAYCONGVAN  AND sd.donid =  D.id)
                            )
                   )
               
               and
                1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                and
                1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                 and

                1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
                and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
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
        )
        LOOP
           V_CD_SOTOTRINH:=ITEM.CD_SOTOTRINH;
           V_CD_NGAYTOTRINH:=ITEM.CD_NGAYTOTRINH;
           V_CD_NGUOIKY_TEMP:=ITEM.CD_NGUOIKY;
             ---------    
                v_table.extend;
                v_table(v_table.count) := R_DON_SEARCH(
                ITEM.ID,ITEM.NOICHUYEN,ITEM.BAQD_LOAIAN,ITEM.LOAI_AN_TEN,null, null,
                V_CD_NGUOIKY_TEMP,ITEM.CD_NGUOIKY_CHUCVU,ITEM.NGAYTAO
                ,V_CD_SOTOTRINH,V_CD_NGAYTOTRINH);
        END LOOP;

     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:='Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapTu is null)then  
             vvNgayNhapTu:=null;
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:=null;   
      end if;
     ----------
    SELECT count(*)into V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     if(V_COUNT>0)then   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     end if;
     ----------
     SELECT LISTAGG(TT.NOICHUYEN,',') WITHIN GROUP (ORDER BY TT.NOICHUYEN DESC) INTO V_NOICHUYEN
     FROM (
         SELECT PA.NOICHUYEN  FROM TABLE(V_TABLE)PA
         GROUP BY PA.NOICHUYEN
         )TT;
     -------------
     SELECT LISTAGG(TT.BAQD_LOAIAN_NAME,', ') WITHIN GROUP (ORDER BY TT.BAQD_LOAIAN) INTO V_BAQD_LOAIAN_NAME
     FROM (
         SELECT PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
         FROM TABLE(V_TABLE)PA WHERE PA.BAQD_LOAIAN IS NOT NULL
         GROUP BY PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
     )TT;
     -------------
     select count(*) into V_COUNT FROM TABLE(V_TABLE)PA  WHERE PA.CD_SOTOTRINH IS NOT NULL;
     if(V_COUNT>0)then
         SELECT PA.CD_SOTOTRINH,PA.CD_NGAYTOTRINH,PA.CD_NGUOIKY,PA.CD_NGUOIKY_CHUCVU 
         INTO V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_NGUOIKY_CHUCVU  FROM TABLE(V_TABLE)PA  WHERE PA.CD_SOTOTRINH IS NOT NULL ORDER BY PA.NGAYTAO desc
         FETCH FIRST 1 ROWS ONLY;
     end if;
      -----
    SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,regexp_replace(HC.TEN,'thành phố|Thành phố ','') INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=vToaAnID;
    ------------------------
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
      -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="text-align: center; vertical-align: top; font-size: 11pt">'||V_TENDONVI||' </td>
                    <th style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr style="text-align: center;">
                    <td style="vertical-align: top;font-size: 11pt">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <th style="text-align: right;width: 15px; "><span>V</span></th>
                                <th style="border-bottom: 1px solid #000000;text-align: left;">
                                    <span>ĂN PHÒN</span>
                                </th>
                                <th style="text-align: left;"><span>G</span></th>
                            </tr>
                        </table>
                    </td>
                    <td style="vertical-align: top;">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000; text-align: left;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 13pt">Số: '||V_CD_SOCV||'/TTr-'||V_DONVI_CV||'-VP</td>
                    <td style="font-size: 12pt;font-style:italic"><span style="color: #ffffff;">......</span>'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                </tr>
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 650pt;"></td>
                    <td style="width: 750pt"></td>
                </tr>
            </table>
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-bottom:4px;">
                    TỜ TRÌNH 
               </p>     
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-top:3px;">
                 Về việc thụ lý đơn và phân công Thẩm phán giải quyết đơn đề nghị<br/>
                    xem xét lại quyết định, bản án đã có hiệu lực pháp luật<br/>
                    theo trình tự giám đốc thẩm, tái thẩm<br/>
             </p>
              <p style="font-size: 14pt; text-align: center;line-height: 100%;margin-top:28pt;">
                    Kính trình: Đồng chí Chánh án '||V_TENDONVI_FULL||'
               </p>  
            <p style="font-size: 14pt; text-align: justify;margin-top:28pt;"><span style="color:white;">............</span>  '||vvNgayNhapTu||vvNgayNhapDen||REPLACE(V_TENPHONGBANGUI,'TANDTC',NULL)||' '||V_TENDONVI_FULL||' nhận và thụ lý các đơn đề nghị, kiến nghị, thông báo của công dân, tổ chức gửi '||V_TENDONVI_FULL||V_LOAIDON8_1||' đề nghị xem xét lại quyết định, bản án <b> '||V_BAQD_LOAIAN_NAME||' </b> đã có hiệu lực pháp luật theo trình tự giám đốc thẩm và dự kiến phân công các Thẩm phán giải quyết đơn (có danh sách kèm theo). </p>
            <p style="font-size: 14pt; text-align: justify"><span style="color:white;">............</span> '||V_TENPHONGBANGUI||' báo cáo và kính đề nghị đồng chí Chánh án '||V_TENDONVI_FULL||' xem xét, cho ý kiến về việc phân công Thẩm phán '||V_TENDONVI_FULL||' giải quyết đơn.</p> 
               <p style="font-size: 14pt; text-align: left;line-height: 100%;">
                 <span style="color:white;">............</span>Kính trình Đồng chí./.
               </p> 
             ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                            <i><b>Nơi nhận:</b></i><br/>
                            - Như kính trình;<br />
                            - Lưu: HCTP.<br />

                        </p>
                    </td>
                    <td>
                         <p style="font-size:13pt;">');
                  IF(lower(V_NGUOIKY_CHUCVU) = 'chánh văn phòng' ) then
                      DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                                <strong>CHÁNH VĂN PHÒNG<br /><br /><br /><br /><br /><br />
                                
                                </strong>');
                  ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                            <strong>KT. CHÁNH VĂN PHÒNG<br /><br /><br /><br /><br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>');
                   END IF;    
                   
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'                                
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                         <p style="font-size:13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
--                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
--                <br clear=all style="mso-special-character:line-break;page-break-before:always">
--                </span>
--                ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_SEARCH_TTRINH_PHANCONG;



PROCEDURE GIAYTRIEUTAP
( 
  vVbToTungID in number,
  strDiadiem varchar2,
  strDiaDiemToaAn varchar2,
  curReturn OUT sys_refcursor
)
IS 
  V_EXPORT_TEXT clob;
  strNguoiTrieuTap varchar(250);
  iNamSinh number;
  strGioiTinh varchar(250);
  strVuAn varchar(250);
  strTuCachToTung varchar(250);
  strGiaiDoanVuAn varchar(250);
  strSoThuLy varchar(250);
  dNgayThuLy varchar(250);
  strNoiCuTru varchar(250);
  strLstNguyenDon varchar(4000);
  strLstBiDon varchar(4000);
  strNoiDung clob;
  strTuCacNguyenDon varchar(250);
  strTuCacBiDon varchar(250);
  strThamPhan varchar(250);
  strQuanHePhapLuat varchar(250);

  iDonID number;
  strLoaiDoiTuong varchar(250);
  iIdDoiTuong number;
  strLoaiAn varchar(250);
  strTuCachThamGiaToTung varchar(250);
  iMaGiaiDoan number;
  iSoLuongNguyenDon number;
  iSoLuongBiDon number;
BEGIN
    --lấy thông tin vb/tb tố tụng
    select v.DONID,v.LOAIDOITUONG,v.IDDOITUONG,v.LOAIAN,
            v.GIAIDOANVUAN,v.NOIDUNG into iDonID,strLoaiDoiTuong,iIdDoiTuong,strLoaiAn,iMaGiaiDoan,strNoiDung from VBTB_TOTUNG v where v.ID=vVbToTungID;

    --nếu là loại án dân sự
    if  strLoaiAn='02' then

        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from ADS_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from ADS_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from ADS_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from ADS_PHUCTHAM_THULY a where a.DONID=iDonID;
            select b.HOTEN into strThamPhan from ADS_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'dân sự';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from ADS_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from ADS_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from ADS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from ADS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from ADS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from ADS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if;
        end if;


    end if;

    --nếu là loại án hôn nhân gia đình
    if  strLoaiAn='03' then
        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from AHN_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHN_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AHN_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHN_PHUCTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AHN_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'hôn nhân gia đình';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AHN_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AHN_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from AHN_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from AHN_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from AHN_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from AHN_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if;
        end if;
    end if;

    --nếu là loại án kinh doanh thương mại
    if  strLoaiAn='04' then
        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from AKT_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AKT_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AKT_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AKT_PHUCTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AKT_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'kinh doanh thương mại';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AKT_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AKT_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from AKT_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from AKT_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from AKT_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from AKT_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if;
        end if;
    end if;

        --nếu là loại án lao động
    if  strLoaiAn='05' then
        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from ALD_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from ALD_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from ALD_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from ALD_PHUCTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from ALD_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'lao động';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from ALD_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from ALD_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from ALD_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from ALD_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from ALD_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from ALD_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if;
        end if;
    end if;

            --nếu là loại án hành chính
    if  strLoaiAn='06' then
        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from AHC_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHC_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AHC_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHC_PHUCTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from AHC_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'hành chính';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AHC_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from AHC_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from AHC_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from AHC_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from AHC_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from AHC_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if;
        end if;

    end if;

                --nếu là loại án phá sản
    if  strLoaiAn='07' then
        select LOWER(a.QUANHEPHAPLUAT_NAME) into strQuanHePhapLuat from APS_DON a where a.ID=iDonID ;
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from APS_SOTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from APS_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from APS_PHUCTHAM_THULY a where a.DONID=iDonID;
             --lấy thẩm phán
            select b.HOTEN into strThamPhan from APS_DON_THAMPHAN a inner join DM_CANBO b on a.CANBOID=b.ID where a.DONID=iDonID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            strVuAn := 'phá sản';
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='DUONGSU' then
            select 
            a.TENDUONGSU,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTOTUNG_MA,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from APS_DON_DUONGSU a where a.ID=iIdDoiTuong;
            -----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.TUCACHTGTTID,
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachThamGiaToTung,strNoiCuTru
            from APS_DON_THAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select d.TEN into strTuCachToTung  from DM_DATAITEM d where d.MA=strTuCachThamGiaToTung;
        end if;

        --lấy số lượng nguyên đơn
        select count(*) into iSoLuongNguyenDon from APS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON';

        ---lấy list nguyên đơn
        FOR item IN (select * from APS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='NGUYENDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.TENDUONGSU||', ');
                else
                    strLstNguyenDon:=CONCAT(strLstNguyenDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongNguyenDon)>0 then
            strLstNguyenDon:=SUBSTR(strLstNguyenDon, 0, LENGTH(strLstNguyenDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacNguyenDon:=' các ';
                strLstNguyenDon:=CONCAT(': ',strLstNguyenDon);
            else
                strTuCacNguyenDon:=' ';
            end if;
        end if;

        --lấy danh sách bị đơn
        select count(*) into iSoLuongBiDon from APS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON';

        ---lấy list bị đơn
        FOR item IN (select * from APS_DON_DUONGSU a where a.DONID=iDonID and a.TUCACHTOTUNG_MA='BIDON')
        LOOP
            if item.LOAIDUONGSU=1 then
            ---cá nhân
                strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
            elsif item.LOAIDUONGSU=2 then
                if item.CHUCVU=null then
                    strLstBiDon:=CONCAT(strLstBiDon,item.TENDUONGSU||', ');
                else
                    strLstBiDon:=CONCAT(strLstBiDon,item.CHUCVU || '-'|| item.TENDUONGSU|| ', ');
                end if;
            end if;
        END LOOP; 
        --cắt bỏ dấu , ở cuối
        if LENGTH(iSoLuongBiDon)>0 then
            strLstBiDon:=SUBSTR(strLstBiDon, 0, LENGTH(strLstBiDon) - 2);
            ---kiểm tra có từ các hay không
            if LENGTH(iSoLuongNguyenDon)>1 then
                strTuCacBiDon:=' các ';
                strLstBiDon:=CONCAT(': ',strLstBiDon);
            else
                strTuCacBiDon:=' ';
            end if; 
        end if;

    end if;

 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

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
      -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <style>
               .content p{
                   text-indent: 35px;
                   font-size:18px !important;
               }
            </style>
            <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="text-align: center; vertical-align: top; font-size: 13pt;width:40%"><span style="color:white">...</span><span style="font-weight: 600;">TÒA ÁN NHÂN DÂN</span></td>
                    <th style="text-align: center; vertical-align: top; font-size: 13pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr style="text-align: center;">
                    <td style="vertical-align: top;font-size: 16pt;width:40%">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <th style="text-align: right;width: 13px; "><span></span></th>
                                <th style="border-bottom: 1px solid #000000;text-align: left; font-size: 13pt;">
                                    <span>'||UPPER(strDiaDiemToaAn)||'</span>
                                </th>
                            </tr>
                        </table>
                    </td>
                    <td style="vertical-align: top;">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                <th style="width: 30px; text-align: right;"><span></span></th>
                                <th style="border-bottom: 1px solid #000000; text-align: left;">
                                    <span>Độc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 13pt">Số:..../GTT</td>
                    <td style="font-size: 13pt;font-style:italic"><span style="">'||REPLACE(strDiaDiemToaAn,'huyện','Huyện')||', ngày....tháng....năm....</span></td>
                </tr>
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 650pt;"></td>
                    <td style="width: 750pt"></td>
                </tr>
            </table>
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-bottom:4px;">
                    GIẤY TRIỆU TẬP 
               </p>     
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-top:3px;">
                 TÒA ÁN NHÂN DÂN '||UPPER(strDiaDiemToaAn)||'
             </p>
            <p style="font-size: 14pt; text-align: justify;margin-top:15pt;"><span style="color:white;">.....</span> Triệu tập: </p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">......</span><b>'||REPLACE(REPLACE(strGioiTinh,'ÔNG','Ông'),'BÀ','Bà')||' '|| strNguoiTrieuTap ||'</b>, sinh năm '||  iNamSinh  ||';</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">.....</span> Nơi cư trú: '||strNoiCuTru||';</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">.....</span> 
            Là '||LOWER(strTuCachToTung)||' trong vụ án '||strVuAn||' '||strGiaiDoanVuAn||' thụ lý số '||strSoThuLy||' ngày '||dNgayThuLy||' về việc '||strQuanHePhapLuat||' 
            giữa nguyên đơn'||strTuCacNguyenDon||' '||REPLACE(REPLACE(strGioiTinh,'ÔNG','ông'),'BÀ','bà')||' '||strLstNguyenDon||' với 
            bị đơn'||strTuCacBiDon||' '||REPLACE(REPLACE(strGioiTinh,'ÔNG','ông'),'BÀ','bà')||' '||strLstBiDon||' .</p>

            <div style="font-size: 14pt; text-align: justify;margin-top:15pt;"><div class="content">'||strNoiDung||'</div></div>

            <p style="font-size: 14pt; text-align: justify;margin-top:15pt;"><span style="color:white;">.......</span>Khi đến Tòa án, ông (bà) cần đem theo giấy triệu tập này, 
            chứng minh nhân dân/căn cước công dân bản chính cùng các tài liệu liên quan đến vụ án.</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:15pt;"><span style="color:white;">.......</span>Ông (bà) phải có mặt đúng vào ngày, giờ và địa điểm nêu trên.
            Nếu vắng mặt phải được sự chấp nhận của Tòa án.</p>
             ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="width: 12%;">

                        <br> <br><br> <br>
                    </td>
                    <td style="vertical-align: top;width: 27%;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">

                        </p>
                    </td>
                    <td >
                         <p style="font-size:13pt;margin-top:5px">
                              <strong>
                                  TÒA ÁN NHÂN DÂN '||UPPER(strDiaDiemToaAn)||'<br />
                                  THẨM PHÁN
                            </strong>
                        </p>
                        <br /> <br /><br /> <p style="font-size:13pt;;margin-bottom:5px"><strong>'||strThamPhan||'</strong></p>
                    </td>
                </tr>

                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
--                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
--                <br clear=all style="mso-special-character:line-break;page-break-before:always">
--                </span>
--                ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END GIAYTRIEUTAP;

PROCEDURE GIAYTRIEUTAP_AHS
( 
  vVbToTungID in number,
  strDiadiem varchar2,
  strDiaDiemToaAn varchar2,
  curReturn OUT sys_refcursor
)
IS 
  V_EXPORT_TEXT clob;
  strNguoiTrieuTap varchar(250);
  iNamSinh number;
  strGioiTinh varchar(250);
  strVuAn varchar(250);
  strTuCachToTung varchar(250);
  strGiaiDoanVuAn varchar(250);
  strSoThuLy varchar(250);
  strBiCaoDauVu varchar(250);
  dNgayThuLy varchar(250);
  strNoiCuTru varchar(250);
  strNoiDung clob;
  strDiem varchar(250);
  strKhoan varchar(250);
  strDieu varchar(250);
  strTenBoLuat varchar(250);

  strGioiTinhNguoiDaiDien varchar(250);
  strTenNguoiDaiDien varchar(250);
  iNamSinhNguoiDaiDien number;
  strDiaChiNguoiDaiDien number;
  strNguoiDaiDienBiCanBiCao varchar(4000);
  strThamPhan varchar(250);

  iVuAnID number;
  strLoaiDoiTuong varchar(250);
  iIdDoiTuong number;
  strLoaiAn varchar(250);
  strTuCachThamGiaToTung varchar(250);
  iMaGiaiDoan number;
  iSoLuongNguyenDon number;
  iSoLuongBiDon number;
  iIdNguoiThamGiaToTung number;
  iIdDoiTuongDauVuAn number;
  iCountNguoiDaiDien number;
BEGIN
    --lấy thông tin vb/tb tố tụng
    select v.DONID,v.LOAIDOITUONG,v.IDDOITUONG,v.LOAIAN,
            v.GIAIDOANVUAN,v.NOIDUNG into iVuAnID,strLoaiDoiTuong,iIdDoiTuong,strLoaiAn,iMaGiaiDoan,strNoiDung from VBTB_TOTUNG v where v.ID=vVbToTungID;
    --nếu là loại án hình sự
    if  strLoaiAn='01' then
        ---lấy giai đoạn vụ án, thông tin thụ lý
        if iMaGiaiDoan=2 then
        ---sơ thẩm
            strGiaiDoanVuAn:='sơ thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHS_SOTHAM_THULY a where a.VUANID=iVuAnID;
            select b.HOTEN into strThamPhan from AHS_THAMPHANGIAIQUYET a inner join DM_CANBO b on a.CANBOID=b.ID where a.VUANID=iVuAnID and a.MAVAITRO='VTTP_GIAIQUYETSOTHAM';
        elsif iMaGiaiDoan=3 then 
        ---phúc thẩm
            strGiaiDoanVuAn:='phúc thẩm';
            select a.SOTHULY,TO_CHAR(a.NGAYTHULY, 'DD/MM/YYYY') into strSoThuLy,dNgayThuLy  from AHS_PHUCTHAM_THULY a where a.VUANID=iVuAnID;
            select b.HOTEN into strThamPhan from AHS_THAMPHANGIAIQUYET a inner join DM_CANBO b on a.CANBOID=b.ID where a.VUANID=iVuAnID and a.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM';
        end if;
        --lấy tên vụ án
            --select a.TENVUAN into strVuAn  from AHS_VUAN a where a.ID=iVuAnID;
        --lấy thông in người triệu tập
        if strLoaiDoiTuong='BICANBICAO' then
            select 
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            'Bị cáo',
            a.TAMTRUCHITIET
            into strNguoiTrieuTap,iNamSinh,strGioiTinh,strTuCachToTung,strNoiCuTru
            from AHS_BICANBICAO a where a.ID=iIdDoiTuong;

            -----nếu có người đại diện theo pháp luật của bị can bị cáo
            select count(*) into iCountNguoiDaiDien  from AHS_BICANBICAO a inner join AHS_NGUOITHAMGIATOTUNG_TUCACH b on a.ID=b.NGUOIID where b.TUCACHID=128 and a.VUANID=iVuAnID;

            if iCountNguoiDaiDien !=0 then
                select 
                a.HOTEN,
                a.NAMSINH,
                (
                    CASE
                      WHEN a.GIOITINH =1 THEN 'ÔNG'
                      WHEN a.GIOITINH =0 THEN 'Bà'
                    END
                ),
                a.TAMTRUCHITIET
                into strTenNguoiDaiDien,iNamSinhNguoiDaiDien,strGioiTinhNguoiDaiDien,strDiaChiNguoiDaiDien
                from AHS_BICANBICAO a where a.ID in (select a.ID  from AHS_BICANBICAO a inner join AHS_NGUOITHAMGIATOTUNG_TUCACH b on a.ID=b.NGUOIID where b.TUCACHID=128 and a.VUANID=iVuAnID and ROWNUM=1);

                strNguoiDaiDienBiCanBiCao:='<p style="font-size: 14pt; text-align: justify;margin-top:28pt;"><span style="color:white;">............</span>Người đại diện theo pháp luật:'
                ||strGioiTinhNguoiDaiDien||' '||strTenNguoiDaiDien||' sinh năm '||iNamSinhNguoiDaiDien||'. Địa chỉ:'||strDiaChiNguoiDaiDien||'.</p>';

            end if;

        elsif strLoaiDoiTuong='NGUOITHAMGIATOTUNG' then
            select 
            a.ID,
            a.HOTEN,
            a.NAMSINH,
            (
                CASE
                  WHEN a.GIOITINH =1 THEN 'ÔNG'
                  WHEN a.GIOITINH =0 THEN 'Bà'
                END
            ),
            a.DIACHICHITIET
            into iIdNguoiThamGiaToTung, strNguoiTrieuTap,iNamSinh,strGioiTinh,strNoiCuTru
            from AHS_NGUOITHAMGIATOTUNG a where a.ID=iIdDoiTuong;

            ----lấy tư cách tố tụng
            select b.TEN into strTuCachToTung from AHS_NGUOITHAMGIATOTUNG_TUCACH a inner join DM_DATAITEM b on a.TUCACHID=b.ID where a.NGUOIID=iIdNguoiThamGiaToTung;
        end if;

            --lấy thông tin đối tượng đầu vụ

            select count(*) into iIdDoiTuongDauVuAn from AHS_BICANBICAO a where a.VUANID=iVuAnID and a.BICANDAUVU=1;
            if (iIdDoiTuongDauVuAn)=0 then
                select a.ID,a.HOTEN into iIdDoiTuongDauVuAn,strBiCaoDauVu from AHS_BICANBICAO a where a.VUANID=iVuAnID and ROWNUM =1;
            else
                select a.ID,a.HOTEN into iIdDoiTuongDauVuAn,strBiCaoDauVu from AHS_BICANBICAO a where a.VUANID=iVuAnID and a.BICANDAUVU=1 and ROWNUM =1;
            end if;
        ---lấy tên tội danh
        select REPLACE(c.TenToiDanh,';','') into strVuAn
                from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                  inner join (select Id, TenBoLuat, Loai from DM_BoLuat  
                              where HieuLuc=1 and (Loai = '01' or Loai='1')
                              ) b on a.DieuLuatID = b.ID
                  inner join (select ID,LuatID, TenToiDanh
                              from DM_BoLuat_ToiDanh where HieuLuc=1 and (diem is null and khoan is null)) c on c.LuatID = b.ID and a.ToiDanhID = c.ID
                where   a.BICANID= iIdDoiTuongDauVuAn and a.VUANID = iVuAnID  and ROWNUM = 1 ;
                --- lấy điều khoản

                select c.Diem, c.Khoan, c.Dieu,b.TenBoLuat into strDiem,strKhoan,strDieu,strTenBoLuat
                from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                  inner join (select Id, TenBoLuat, Loai from DM_BoLuat  
                              where HieuLuc=1 and (Loai = '01' or Loai='1')
                              ) b on a.DieuLuatID = b.ID
                  inner join (select ID, LuatID, Chuong, Diem, Khoan, dieu, TenToiDanh, capChaID, Loai, ArrSapXep, LOAITOIPHAM 
                              from DM_BoLuat_ToiDanh where HieuLuc=1 order by diem) c on c.LuatID = b.ID and a.ToiDanhID = c.ID
                where   a.BICANID= iIdDoiTuongDauVuAn and a.VUANID = iVuAnID  and ROWNUM = 1 ;
        --kiểm tra trường dữ liệu điểm
        if strDiem is null then
            strDiem:='';
            else
            strDiem:='điểm '||strDiem||' ';
        end if;
        ---kiểm tra trường khoản
        if strKhoan is null then
            strKhoan:='';
            else
            strKhoan:='khoản '||strKhoan||' ';
        end if;
        ---kiểm tra trường điều
        if strDieu is null then
            strDieu:='';
            else
            strDieu:='điều '||strDieu||' ';
        end if;
        ----tên bộ luật
        if strTenBoLuat is null then
            strTenBoLuat:='';
        end if;

    end if;





 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

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
      -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'

            <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14px; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="text-align: center; vertical-align: top; font-size: 13pt;width:40%"><span style="color:white">.....</span><span style="font-weight: 600;">TÒA ÁN NHÂN DÂN</span></td>
                    <th style="text-align: center; vertical-align: top; font-size: 13pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr style="text-align: center;">
                    <td style="vertical-align: top;font-size: 16pt;width:40%">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <th style="text-align: right;width: 14pt; "><span></span></th>
                                <th style="border-bottom: 1px solid #000000;text-align: left; font-size: 13pt;">
                                    <span>'||UPPER(strDiaDiemToaAn)||'</span>
                                </th>
                            </tr>
                        </table>
                    </td>
                    <td style="vertical-align: top;">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 13p1">
                                <th style="width: 30px; text-align: right;"><span></span></th>
                                <th style="border-bottom: 1px solid #000000; text-align: left;">
                                    <span>Độc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 13pt">Số:..../GTT</td>
                    <td style="font-size: 13pt;font-style:italic"><span style="">'||REPLACE(strDiaDiemToaAn,'huyện','Huyện')||', ngày....tháng....năm....</span></td>
                </tr>
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 650pt;"></td>
                    <td style="width: 750pt"></td>
                </tr>
            </table>
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-bottom:4px;">
                    GIẤY TRIỆU TẬP 
               </p>     
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-top:3px;">
                 TÒA ÁN NHÂN DÂN '||UPPER(strDiaDiemToaAn)||'
             </p>
             <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">.......</span>Căn cứ vào hồ sơ vụ án hình sự đã thụ lý số: '||strSoThuLy||' ngày '||dNgayThuLy||';</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">......</span> Triệu tập: </p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">.......</span><b>'||REPLACE(REPLACE(strGioiTinh,'ÔNG','Ông'),'BÀ','Bà')||' '|| strNguoiTrieuTap ||'</b>, sinh năm '||  iNamSinh  ||';</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:10pt;"><span style="color:white;">......</span> Nơi cư trú: '||strNoiCuTru||';</p>
            <style>
               .content{
                   text-indent: 35px;
                   font-size:18px;
               }
            </style>
            <p style="font-size: 14pt; text-align: justify;margin-top:10t;"><span style="color:white;">......</span> 
            Là '||LOWER(strTuCachToTung)||' trong vụ án: '||strBiCaoDauVu||' bị Viện kiểm sát nhân dân '||strDiaDiemToaAn||' truy tố về tội '||strVuAn||' theo '||CONCAT(CONCAT(strDiem,strKhoan),CONCAT(strDieu,strTenBoLuat))||' .</p>
            '||strNguoiDaiDienBiCanBiCao||'
            <div class="content">'||strNoiDung||'</div>
            <p style="font-size: 14pt; text-align: justify;margin-top:15pt;"><span style="color:white;">......</span>Ông (bà) phải có mặt đúng vào ngày, giờ và địa điểm nêu trên. Nếu vắng mặt phải được sự chấp nhận của Tòa án.</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:15pt;"><span style="color:white;">......</span>Khi đến Tòa án, ông (bà) cần đem theo giấy triệu tập này, chứng minh 
            nhân dân/căn cước công dân bản chính cùng các tài liệu liên quan đến vụ án (nếu có).</p>
             ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="width: 12%;">

                        <br> <br><br> <br>
                    </td>
                    <td style="vertical-align: top;width: 27%;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">

                        </p>
                    </td>
                    <td >
                         <p style="font-size:13pt;margin-top:5px">
                              <strong>
                                  TÒA ÁN NHÂN DÂN '||UPPER(strDiaDiemToaAn)||'<br />
                                  THẨM PHÁN
                            </strong>
                        </p>
                        <br /> <br /><br /> <p style="font-size:13pt;;margin-bottom:5px"><strong>'||strThamPhan||'</strong></p>
                    </td>
                </tr>

                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
--                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
--                <br clear=all style="mso-special-character:line-break;page-break-before:always">
--                </span>
--                ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END GIAYTRIEUTAP_AHS;



PROCEDURE DON_SEARCH_PCHUYEN_TLM
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  VLOAISOVB in varchar2,
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
  V_TENPHONGBANGUI varchar2(250);
  V_TENDONVI varchar2(250);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DON_SEARCH;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(250);V_CD_NGUOIKY varchar2(250); V_NGUOIKY_CHUCVU varchar2(250); 
  V_CD_NGAYCV varchar2(250);V_COUNT_CHECK number;
  V_NGAY varchar2(250):=NULL;V_THANG varchar2(250):=NULL;V_NAM varchar2(250):=NULL;V_COUNT NUMBER;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DON_SEARCH();
 -------
  FOR item IN (
          Select (case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                  when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                  when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                  when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
             ,D.ID,D.BAQD_LOAIAN,LA.LOAI_AN_TEN,
             SoCVC.SOVB as CD_SOCV,
             SoCVC.NGAYVB as CD_NGAYCV,
             D.NGAYTAO,  
             
            SoTT.SOVB AS CD_SOTOTRINH,
            SoTT.NGAYVB AS CD_NGAYTOTRINH,
            SoTT.NGUOIKY as CD_NGUOIKY,
            SoTT.CHUCVU as CD_NGUOIKY_CHUVU
           
            from GDTTT_DON d
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in('SoCVC','SoCVCN') )SoCVC on SoCVC.donid = d.id 
               
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTT_TLL','SoTTXX') )SoTT on SoTT.donid = d.id                
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                AND (vIsThuLy =-1  OR(vIsThuLy=1 AND d.ISTHULY=1)
                            OR(vIsThuLy=3 AND d.ISTHULY=1 AND (vNgayNhapTu is not null and  vNgayNhapDen is not null) and d.ARR_DON_ID!=0)--PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(d.id)>1) -- TLM trùng
                            OR(vIsThuLy=4 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0) -- TLM đã phan cong
                            OR(vIsThuLy=5 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0 ) -- TLM chua phan cong
                            OR(vIsThuLy=2 and d.ISTHULY=2)
                             )
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD
                                                    then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
                and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%' 
                                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%' 
                                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                    (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                                    Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                    Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                    Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end        
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
               
               AND (VSOCONGVAN IS NULL 
                         OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where b.SOTHONGBAO =VSOCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND so.SOVB =VSOCONGVAN  AND sd.donid =  D.id)
                            )
                                                
                   )

                 AND (VNGAYCONGVAN IS NULL 
                       OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') =VNGAYCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') =VNGAYCONGVAN  AND sd.donid =  D.id)
                            )
                   )
               
               and
                1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                and
                1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                 and

                1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
                and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
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
        )
        LOOP
             v_table.extend;
                 v_table(v_table.count) := R_DON_SEARCH(
                            ITEM.ID,
                            ITEM.NOICHUYEN,
                            ITEM.BAQD_LOAIAN,
                            ITEM.LOAI_AN_TEN,
                            ITEM.CD_SOCV, 
                            ITEM.CD_NGAYCV, 
                            ITEM.CD_NGUOIKY,
                            ITEM.CD_NGUOIKY_CHUVU,
                            ITEM.NGAYTAO,
                            ITEM.CD_SOTOTRINH,
                            ITEM.CD_NGAYTOTRINH);
        END LOOP;

     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:='Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapTu is null)then  
             vvNgayNhapTu:=null;
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:=null;   
      end if;
      ---
     SELECT count(*)into V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     if(V_COUNT>0)then   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     end if;
     ----------
     SELECT LISTAGG(TT.NOICHUYEN,',') WITHIN GROUP (ORDER BY TT.NOICHUYEN DESC) INTO V_NOICHUYEN
     FROM (
         SELECT PA.NOICHUYEN  FROM TABLE(V_TABLE)PA
         GROUP BY PA.NOICHUYEN
         )TT;
     -------------
     SELECT LISTAGG(TT.BAQD_LOAIAN_NAME,', ') WITHIN GROUP (ORDER BY TT.BAQD_LOAIAN) INTO V_BAQD_LOAIAN_NAME
     FROM (
         SELECT PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
         FROM TABLE(V_TABLE)PA WHERE PA.BAQD_LOAIAN IS NOT NULL
         GROUP BY PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
     )TT;

       IF(V_BC_SoCV IS NOT NULL) THEN
           V_CD_SOCV:=V_BC_SoCV;
       ELSIF(V_BC_SoCV IS NULL) THEN
           SELECT PA.CD_SOCV INTO V_CD_SOCV FROM TABLE(V_TABLE)PA
           ORDER BY PA.NGAYTAO desc FETCH FIRST 1 ROWS ONLY;
       END IF;
       ---------------
      IF(V_BC_NGAYDK IS NOT NULL) THEN
            V_CD_NGAYCV:=V_BC_NGAYDK;
             V_NGAY:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'dd');
             V_THANG:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'MM');
              V_NAM:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'yyyy');
       ELSIF(V_BC_NGAYDK IS NULL) THEN
           SELECT to_char(PA.CD_NGAYCV,'dd/MM/yyyy') INTO V_CD_NGAYCV FROM TABLE(V_TABLE)PA
           ORDER BY PA.NGAYTAO desc FETCH FIRST 1 ROWS ONLY;
            IF(V_CD_NGAYCV IS NOT NULL) THEN
             V_NGAY:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'dd');
             V_THANG:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'MM');
             V_NAM:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'yyyy');
            else
            V_NGAY:='<span style="color: #ffffff;">.....</span>'; V_THANG:='<span style="color: #ffffff;">.....</span>'; V_NAM:='<span style="color: #ffffff;">.....</span>';
            END IF;
       END IF;
       -----------
        BEGIN
            SELECT PA.CD_NGUOIKY,PA.CD_NGUOIKY_CHUCVU INTO V_CD_NGUOIKY,V_NGUOIKY_CHUCVU FROM TABLE(V_TABLE)PA
                ORDER BY PA.NGAYTAO desc FETCH FIRST 1 ROWS ONLY;
        EXCEPTION 
        WHEN OTHERS 
                THEN 
                V_CD_NGUOIKY := null;
                V_NGUOIKY_CHUCVU := null;
        END; 
       --Chuc vu Nguoi ky
--        SELECT PA.CD_NGUOIKY_CHUCVU INTO V_NGUOIKY_CHUCVU FROM TABLE(V_TABLE)PA
--           ORDER BY PA.NGAYTAO desc FETCH FIRST 1 ROWS ONLY;
       
        -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,replace(HC.TEN,'thành phố ','') INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=vToaAnID;
    ------------------------
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
      -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <td style="text-align: center; vertical-align: top; height: 25px; font-size: 11pt">'||V_TENDONVI||'</td>
                    <th style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr>
                    <td style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <td style="text-align: right; padding-right: 2px; color: #ffffff;"><span>------</span></td>
                                <th style="border-bottom: 1px solid #000000;">
                                    <span>VĂN PHÒNG</span>
                                </th>
                                <td style="text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                            </tr>
                        </table>

                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000; text-align: left;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td style="font-size: 13pt">Số: '||V_CD_SOCV||'/'||V_DONVI_CV||'-VP</td>
                    <td style="font-style: italic; font-size: 12pt;"><span style="color: #ffffff;">........</span>'||V_TENDONVI_HC||', ngày <span>'||V_NGAY||'</span> tháng <span>'||V_THANG||'</span> năm <span>'||V_NAM||'</span></td>  
                </tr>
                <tr style="font-style: italic; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 530pt;"></td>
                    <td style="width: 680pt"></td>
                </tr>
            </table>
            <p style="font-size: 14pt; text-align: center; line-height: 130%">
                Kính gửi: '||V_NOICHUYEN||'
            </p>
            <p style="font-size: 14pt; text-align: justify; line-height: 120%;"><span style="color: white;">............</span> '||vvNgayNhapTu||vvNgayNhapDen||V_TENPHONGBANGUI||' '||V_TENDONVI_FULL||' đã nhận và thụ lý các đơn của công dân, tổ chức gửi '||V_TENDONVI_FULL||' đề nghị xem xét lại quyết định, bản án <b>'||V_BAQD_LOAIAN_NAME||' </b>đã có hiệu lực pháp luật theo trình tự giám đốc thẩm, tái thẩm (có danh sách đơn gửi kèm theo Công văn này).</p>
            <p style="font-size: 14pt; text-align: justify; line-height: 120%;"><span style="color: white;">............</span> '||V_TENPHONGBANGUI||' chuyển các đơn đề nghị, kiến nghị, thông báo đến Quý vụ để xem xét, giải quyết theo thẩm quyền. Đề nghị Quý vụ ký xác nhận và chuyển phát danh sách đã ký nhận về phòng Tiếp công dân và xử lý đơn tư pháp thuộc '||V_TENPHONGBANGUI||' '||V_TENDONVI_FULL||'./.</p>
             ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                            <i><b style="font-size: 12pt;">Nơi nhận:</b></i><br />
                            - Như trên;<br />
                            - Đ/c Chánh án '||V_DONVI_CV||' (để b/c);<br />
                            - Đ/c Chánh Văn phòng '||V_DONVI_CV||' (để b/c);<br />
                            - Lưu: VP '||V_DONVI_CV||'.<br />

                        </p>
                    </td>
                    <td>
                        <p style="font-size: 13pt;">');
                  IF (lower(V_NGUOIKY_CHUCVU) = 'chánh văn phòng' ) then
                      DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                                <strong>CHÁNH VĂN PHÒNG<br />
                                </strong>');
                  ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                            <strong>KT. CHÁNH VĂN PHÒNG<br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>');
                   END IF;    
                   
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'     
                        </p>
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
--                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
--                <br clear=all style="mso-special-character:line-break;page-break-before:always">
--                </span>
--                ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_SEARCH_PCHUYEN_TLM;



PROCEDURE DS_KQ_DO_Q_HOI
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DS_KQ_DO_Q_HOI;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(500);V_CD_NGUOIKY varchar2(250);V_CD_NGAYCV varchar2(250);V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(500);V_CD_NGAYTOTRINH varchar2(250);V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
  V_NGUOIGUI clob;V_TL_SO_TEMP varchar2(500); V_TENTHAMPHAN varchar2(500);
  V_TT NUMBER;V_SODON_TONG NUMBER;V_TENPHONGBANNHAN VARCHAR2(500);V_COUNT NUMBER;V_GHICHU clob;
  V_QD_NGUOIKN varchar2(500):=NULL;
  V_COUNT_PB NUMBER;V_DEM_ROW NUMBER:=0;V_COUNT_DEM_ROW NUMBER:=0;V_DEM_TEXT clob;
  V_SOBA varchar2(500);V_NGAYBA varchar2(500);V_SOQD varchar2(500);V_NGAYQD varchar2(500);V_TOAXX varchar2(2000);
  V_COLUMN_4 clob;V_COLUMN_5 varchar2(1000):=null;V_COLUMN_6 varchar2(1000):=null;V_COLUMN_7 varchar2(1000):=null;V_COLUMN_8 varchar2(1000);V_COLUMN_9 varchar2(1000):=null;
  V_COLUMN_10 varchar2(1000):=NULL;V_COLUMN_11 varchar2(1000):=NULL;V_COLUMN_12 varchar2(1000):=NULL;V_COLUMN_13 varchar2(1000):=NULL;V_COLUMN_14 varchar2(1000):=NULL;
  V_NGUOIKY varchar2(500);V_COUNT_CHECK NUMBER;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_DEM_TEXT,true);
 v_table := T_DS_KQ_DO_Q_HOI();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
 END IF;
 --------phạm vi tìm kiếm, tất cả
  FOR item IN (
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
                     /*,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    End) Diachigui*/
                    ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else (case when d.LOAIDON NOT IN (6,9) then d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    else d.CV_DIACHI ||(case when (d.CV_DIACHI || ' ')=' '  then ' ' Else ', ' End) || hv.MA_TEN  End) --lanhnt
                    End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
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
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH
      ,d.CD_NGAYTOTRINH
      ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,d.THAMPHANID
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
        ,(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',  ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'))) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
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
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,d.NGAYTAO,d.LOAICONGVAN,d.NOIDUNGDON,d.VuViecID
               ,VA.GQD_KETQUA,VA.GDQ_SO,VA.GDQ_NGAY,kq.Ten,va.XXGDTTT_KETQUAID,va.XXGDTTT_SOQD,va.XXGDTTT_NGAYQD
               ,va.NGAYLICHGDT,XX.NGAYMOPT
               from GDTTT_DON d
              left join (select ID, GQD_KETQUA,GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,XXGDTTT_KETQUAID,XXGDTTT_SOQD,XXGDTTT_NGAYQD,NGAYLICHGDT from GDTTT_VuAn) va on va.ID = d.VuViecID
              left join DM_DAtaItem kq on kq.ID = va.XXGDTTT_KETQUAID
              LEFT JOIN GDTTT_VUAN_XETXUGDTTT XX ON XX.VUANID=VA.ID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
               -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID  --lanhnt
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )

                 and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                                                                    (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                                    Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                        (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
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
                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
--                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
--                    when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
--                    when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
--                                            (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
--                    when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
--                   when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)      
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
                    ----------------
                    AND d.LOAICONGVAN IN (1025,1198,1199)
                    AND ( (vNoiChuyen=0 AND d.CD_TA_DONVIID IN (2,3,4))
                          OR(vNoiChuyen=1 AND d.CD_TK_DONVIID IN (4,5,6))
                          )
                    AND d.NGUOITAO IN ('mainn.vp','huongntt.vp','namnd.vp','namnd.tkth','vvyen.tkth','ds.vp','kdhnld.vp','hc.vp','hs.vp')
        )
        LOOP
           V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.ARRCONGVAN IS NOT NULL)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')';
            ELSIF(item.LOAIDON=2)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
             IF(LENGTH(item.TL_SO)=1)THEN
                 V_TL_SO_TEMP:='0'||item.TL_SO;
                 ELSIF(LENGTH(item.TL_SO)>1)THEN
                 V_TL_SO_TEMP:=item.TL_SO;
                END IF;
            ----
            SELECT decode(item.TENTHAMPHAN,NULL,NULL,'Thẩm phán '||item.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;
            V_GHICHU:=item.GHICHU; 
            IF(item.BAQD_LOAIQDBA!='0')THEN--QD
                V_QD_NGUOIKN:=item.TOAXX;
                V_SOBA:=NULL;V_NGAYBA:=NULL;
                V_SOQD:=item.BAQD_SO;V_NGAYQD:=' - '||TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                V_TOAXX:=NULL;
            else -----------------------------BA
                V_QD_NGUOIKN:=NULL;
                V_SOBA:=item.BAQD_SO;V_NGAYBA:=' - '||TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                V_SOQD:=NULL;V_NGAYQD:=NULL;V_TOAXX:=item.TOAXX;
            END IF;
            ---------------
            DBMS_LOB.CREATETEMPORARY(V_COLUMN_4,true);
            IF(V_SOQD IS NULL AND replace(V_NGAYQD,' - ',null) IS NULL AND V_SOBA IS NULL AND replace(V_NGAYBA,' - ',null) IS NULL) THEN
                IF(V_GHICHU IS NULL) THEN
                     DBMS_LOB.APPEND(V_COLUMN_4,item.NOIDUNGDON);
                   ELSE
                     DBMS_LOB.APPEND(V_COLUMN_4,V_GHICHU);
                 END IF;
              ELSE
                DBMS_LOB.APPEND(V_COLUMN_4,V_SOBA||V_NGAYBA||V_SOQD||V_NGAYQD);
            END IF;
            ----Vụ án
        IF(vNoiChuyen=0)THEN  --dữ liệu liên quan đến các vụ giám đốc kiểm tra
            --Kháng nghị(CA)
            IF(item.GQD_LOAIKETQUA=1) THEN
               V_COLUMN_5:='Kháng nghị' 
               || case when Length(NVL(item.GDQ_SO, ''))>0 then ' số '||item.GDQ_SO  else '' end 
               || case when (Length(NVL(item.GDQ_NGAY,''))=0  or (to_char(item.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
               when Length(NVL(item.GDQ_NGAY,'')) >0 then ' ngày ' || to_char(item.GDQ_NGAY,'dd/MM/yyyy') end;
             else
               V_COLUMN_5:=NULL; 
            END IF;
            -----
             IF(item.GQD_LOAIKETQUA=0) THEN
                   V_COLUMN_6:='Trả lời đơn' 
                   || case when Length(NVL(item.GDQ_SO, ''))>0 then ' số '||item.GDQ_SO  else '' end 
                   || case when (Length(NVL(item.GDQ_NGAY,''))=0  or (to_char(item.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(item.GDQ_NGAY,'')) >0 then ' ngày ' || to_char(item.GDQ_NGAY,'dd/MM/yyyy') end;
               else
               V_COLUMN_6:=NULL;  
            END IF; 
            ----
            IF(item.GQD_LOAIKETQUA=6) THEN
                   V_COLUMN_7:='Giải quyết khác' 
                   || case when Length(NVL(item.GDQ_SO, ''))>0 then ' số '||item.GDQ_SO  else '' end 
                   || case when (Length(NVL(item.GDQ_NGAY,''))=0  or (to_char(item.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(item.GDQ_NGAY,'')) >0 then ' ngày ' || to_char(item.GDQ_NGAY,'dd/MM/yyyy') end;
                else
               V_COLUMN_7:=NULL; 
            END IF; 
             ----
            IF(item.GQD_LOAIKETQUA IS NULL) THEN
               V_COLUMN_8:='X';
            ELSE
                V_COLUMN_8:=NULL;
            END IF;
             ----
            IF(item.XXGDTTT_KETQUAID!=1318)THEN --1318 Không chấp nhận kháng nghị 
               V_COLUMN_9:='Số:  '||item.XXGDTTT_SOQD ||' ngày: '||to_char(item.XXGDTTT_NGAYQD,'dd/MM/yyyy')
               || ' nội dung: '||chr(10)|| NVL(item.Ten,' ');
            else
              V_COLUMN_9:=null;
            END IF;
             ----
              IF(item.XXGDTTT_KETQUAID=1318)THEN
               V_COLUMN_10:=chr(10)|| NVL(item.Ten,' ');
            else
              V_COLUMN_10:=null;
            END IF;
             ----
             IF(item.NGAYMOPT IS NULL)THEN
                V_COLUMN_11:='X';
             ELSE
                V_COLUMN_11:=NULL;
             END IF;
             ----Thông báo tình thế V_COLUMN_12
              SELECT LISTAGG(T.so_ngay, '; ') WITHIN GROUP (ORDER BY T.so_ngay) into V_COLUMN_12 
                     FROM (select 'Số: '||TLD.So||' Ngày: '||DECODE(TLD.Ngay,NULL,NULL,to_char(TLD.Ngay,'dd/MM/yyyy'))so_ngay 
                      from GDTTT_DON_TRALOI TLD
                      WHERE  TLD.TypeTB=1 and TLD.VuAnID=item.VuViecID AND TLD.DonID=item.ID AND TLD.So IS NOT NULL
                     )T;
             -----thông báo kết quả V_COLUMN_13
             SELECT LISTAGG(T.so_ngay, '; ') WITHIN GROUP (ORDER BY T.so_ngay) into V_COLUMN_13 
                     FROM (select 'Số: '||TLD.So||' Ngày: '||DECODE(TLD.Ngay,NULL,NULL,to_char(TLD.Ngay,'dd/MM/yyyy'))so_ngay 
                      from GDTTT_DON_TRALOI TLD
                      WHERE  TLD.TypeTB=2 and TLD.VuAnID=item.VuViecID AND TLD.DonID=item.ID AND TLD.So IS NOT NULL
                     )T; 
            ----
        END IF;
            v_table.extend;
                v_table(v_table.count) := R_DS_KQ_DO_Q_HOI(
                item.STT,V_NGUOIGUI,item.DIACHIGUI,V_SOBA,V_NGAYBA,
                V_TOAXX,V_SOQD,V_NGAYQD,V_QD_NGUOIKN,item.SODON,
                V_GHICHU,NULL,item.NOICHUYEN,item.CD_SOTOTRINH,NULL,
                NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,to_char(item.TL_NGAY,'dd/MM/yyyy'),
                to_char(item.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,item.CD_NGUOIKY,NULL,
                item.BAQD_LOAIAN,TO_CHAR(item.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,item.NGAYTAO,item.CD_SOCV,
                to_char(item.CD_NGAYCV,'dd/MM/yyyy'),
                ITEM.LOAICONGVAN,item.arrCongvan,item.DONGKHIEUNAI ||' ('||item.Diachigui||')',V_COLUMN_4||', '||V_TOAXX,V_COLUMN_5,
                V_COLUMN_6,V_COLUMN_7,V_COLUMN_8,V_COLUMN_9,V_COLUMN_10,
                V_COLUMN_11,V_COLUMN_12,V_COLUMN_13,NULL,item.VuViecID
                );
        END LOOP;
     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:=' Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy');
      elsif(vNgayNhapTu is null)then    
        vvNgayNhapTu:='';
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy');
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:='';
      end if;
    ----
    IF(vNoiChuyen=0)THEN
      V_NGUOIKY:='THỦ TRƯỞNG ĐƠN VỊ';
    ELSIF(vNoiChuyen=1)THEN
     V_NGUOIKY:='CHÁNH ÁN TÒA ÁN NHÂN DÂN CẤP CAO';
    END IF;
    ----
        SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
    ----
    SELECT COUNT(*) INTO V_COUNT_PB FROM (SELECT PA.TENPHONGBANNHAN FROM TABLE(V_TABLE)PA GROUP BY PA.TENPHONGBANNHAN)PS;
    ---
   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
   <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
   ');
    FOR item_s IN (
                 SELECT PA.TENPHONGBANNHAN FROM TABLE(V_TABLE)PA
                 LEFT JOIN DM_TOAAN TA ON TA.MA_TEN=PA.TENPHONGBANNHAN
                 GROUP BY PA.TENPHONGBANNHAN,TA.SOCAP
                 ORDER BY TA.SOCAP
    )
     LOOP
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN AND PA.CD_SOCV IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
--             DECODE(V_BC_SoCV,NULL,PA.SOTOTRINH,V_BC_SoCV)CD_SOCV
--            ,DECODE(V_BC_NGAYDK,NULL,PA.NGAYTOTRINH,V_BC_NGAYDK)CD_NGAYCV
--            ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
                 DECODE(V_BC_SoCV,NULL,PA.CD_SOCV,V_BC_SoCV)CD_SOCV
                ,DECODE(V_BC_NGAYDK,NULL,PA.CD_NGAYCV,V_BC_NGAYDK)CD_NGAYCV
                ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
                ,PA.TENTHAMPHAN
            INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_TENTHAMPHAN
            FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN AND PA.CD_SOCV IS NOT NULL  ORDER BY PA.NGAYTAO DESC
            FETCH FIRST 1 ROWS ONLY;
        END IF;
     -----  
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                  <tr align="center" style="text-align: center; font-weight: bold;">
                    <td colspan="14" style="text-align: center; vertical-align: middle; font-size: 14pt;">KẾT QUẢ, TIẾN ĐỘ GIẢI QUYẾT CÁC ĐƠN THƯ, THƯ DO CÁC CƠ QUAN CỦA QUỐC HỘI,
                        <br />
                        CƠ QUAN CỦA ỦY BAN THƯỜNG VỤ QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI,
                        <br />
                        ĐẠI BIỂU QUỐC HỘI CHUYỂN ĐẾN TÒA ÁN NHÂN DÂN
                        <br />
                        Đơn chuyển '||item_s.TENPHONGBANNHAN||'
                        <br />
                        <span style="font-size: 12pt; font-weight: normal; font-style: italic;">Kèm theo Công văn số '||V_CD_SOCV||' ngày '||V_CD_NGAYCV||' của Tòa án nhân dân tối cao</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="14" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Văn Bản chuyển đơn của các cơ quan của Quốc Hội, Ủy ban Thường vụ Quốc hội, Đoàn Đại biểu Quốc hội, Đại biểu Quốc hội ( Số ngày tháng năm)</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Cá nhân, tổ chức khiếu nại, tố cáo</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Nội dung khiếu nại, tố cáo</td>
                    <td colspan="4" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 69px;">Kết quả giải quyết đơn đề nghị GDT,TT</td>
                    <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Kết quả xét xử giám đốc thẩm, tái thẩm</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Chưa xét xử giám đốc thẩm, tái thẩm</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Văn bản thông báo việc thụ lý, đang giải quyết gửi các cơ quan chuyển đơn ( Số, ngày tháng năm)</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Văn bản thông báo kết quả giải quyết gửi các cơ quan chuyển đơn ( Số, ngày tháng năm)</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 297px;">Kháng nghị (Số, ngày tháng năm)</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Trả lời không có căn cứ kháng nghị (CV số, ngày tháng năm)</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Giải quyết khác</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Đang giải quyết</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Chấp nhận kháng nghị ( Số QĐ GĐT, ngày tháng năm)</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Không chấp nhận kháng nghị ( Số QĐ GĐT)</td>
                </tr>
               ');
           FOR item_loai IN (
                          Select DECODE(DI.ID,1025,2,1198,3,1199,1)STT, DECODE(DI.ID,1025,'II',1198,'III',1199,'I')STTS,
                            DI.ID,DI.TEN from DM_DATAITEM DI
                           INNER JOIN (SELECT PS.COLUMN_1 FROM TABLE(V_TABLE)PS WHERE  PS.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN  GROUP BY PS.COLUMN_1)PA ON PA.COLUMN_1=DI.ID
                           WHERE DI.ID IN (1025,1198,1199)
                           ORDER BY DECODE(DI.ID,1025,2,1198,3,1199,1) 
                          )
           LOOP     
                 V_DEM_ROW:=V_DEM_ROW+1;
            ------
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item_loai.STTS||'</td>
                    <th style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item_loai.TEN||'</th>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                </tr>
                ');   
                V_TT:=0; 
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN 
                         AND PA.COLUMN_1=item_loai.ID
                         ORDER BY  dbms_lob.SUBSTR(PA.COLUMN_2,150,1)
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 V_DEM_ROW:=V_DEM_ROW+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
               <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.COLUMN_2||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.COLUMN_3||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.COLUMN_4||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_5||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_6||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_7||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_8||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_9||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_10||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_11||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_12||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.COLUMN_13||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;"></td>
                </tr>
                ');   
                 END LOOP;
            END LOOP;
                 ---tính những dòng ngắt trang khi kết suất ra excel
                 V_DEM_ROW:=V_DEM_ROW+12;
                 V_COUNT_DEM_ROW:=V_COUNT_DEM_ROW+1;
                 IF(V_COUNT_DEM_ROW<V_COUNT_PB) THEN
                     DBMS_LOB.APPEND(V_DEM_TEXT,V_DEM_ROW||',');
                 END IF;
                 --------------------------------------------------
                SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN;
                ----
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                  <tr>
                    <td colspan="14" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="7" style="vertical-align: top; text-align: right;"></td>
                    <td colspan="7" style="vertical-align: top; text-align: center; font-style: italic">..... ngày ..... tháng ..... năm</td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="7" style="vertical-align: top; text-align: right;"></td>
                    <td colspan="7" style="vertical-align: top; text-align: center; font-weight: bold;">'||V_NGUOIKY||'</td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="7" style="vertical-align: top; text-align: right;"></td>
                    <td colspan="7" style="vertical-align: top; text-align: center; font-weight: bold; height: 100px;"></td>
                </tr>
           ');
           END LOOP;
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'          
                 <tr style="height: 0px;">
                    <td style="width: 30px"></td>
                    <td style="width: 129px"></td>
                    <td style="width: 121px"></td>
                    <td style="width: 199px"></td>
                    <td style="width: 48px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 40px"></td>
                    <td style="width: 40px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 52px"></td>
                    <td style="width: 40px"></td>
                    <td style="width: 49px"></td>
                    <td style="width: 56px"></td>
                    <td style="width: 49px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT,RTRIM(V_DEM_TEXT,',') INSERT_PAGE_BREAK FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);dbms_lob.freetemporary(V_DEM_TEXT);
        --dbms_lob.freetemporary(V_COLUMN_4);
END DS_KQ_DO_Q_HOI;
PROCEDURE GUI_COQUAN_CHUYENDON
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  VLOAISOVB in varchar2,
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
  V_EXPORT_TEXT clob;V_TABLE T_DT_NOIBO_THONGBAO;
  V_CD_NGAYCV date;V_LOAIDON8_1 NUMBER:=0;V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTB varchar2(250); v_dem NUMBER:=0;V_DIACHICOQUAN  varchar2(500);V_NOIDUNG varchar2(2000);V_GIOITINH varchar2(250);V_GIOITINHHOA varchar2(250);
  V_LoaiCV_MA  varchar2(250);V_TOAAN_TEN varchar2(250);
BEGIN
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DT_NOIBO_THONGBAO();
       -------
       IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
               SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
               IF(V_ID=1023 or V_CAPCHAID=1023) then
                V_LOAIDON8_1:=1;
               end if;
              END IF;
        ------   
  FOR item IN (
           Select  d.CV_TENDONVI
                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) BAQD_SO
                    --,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
                    --,d.BAQD_SO
                    ,d.CV_DIACHI CVDIACHI,d.CV_TRAIGIAMHIENTAI,decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) BAQD_NGAYBA
                    ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX,d.BAQD_TENTOA
                    ,d.NOIDUNGDON,d.GHICHU,d.CV_SO,d.CV_NGAY
                    ,d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.DONGKHIEUNAI,d.LOAICONGVAN
                    /*,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    End) Diachigui*/
                    ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else (case when d.LOAIDON NOT IN (6,9) then d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    else d.CV_DIACHI ||(case when (d.CV_DIACHI || ' ')=' '  then ' ' Else ', ' End) || hv.MA_TEN  End) --lanhnt
                    End) Diachigui

                    ,d.NGAYGHITRENDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,d.KN_SOQD,d.KN_NGAY
                    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                    when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                    when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                    when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
                    --,D.CD_SOCV,D.CD_NGAYCV  
                     ,(SoCVC.SOVB || SoCVCN.SOVB ||SoCVCTK.SOVB) as CD_SOCV
                    ,(SoCVC.NGAYVB ||SoCVCN.NGAYVB || SoCVCTK.NGAYVB)  as CD_NGAYCV
                    
                   

                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)BAQD_TOAANID
            from GDTTT_DON d
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id 
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id 
               LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id 
             
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID  --lanhnt
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID) = txx.ID 
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
                and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                                                                    (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                                    Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                        (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
                AND (VSOCONGVAN IS NULL 
                         OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where b.SOTHONGBAO =VSOCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND so.SOVB =VSOCONGVAN  AND sd.donid =  D.id)
                            )

                   )

                 AND (VNGAYCONGVAN IS NULL 
                       OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') =VNGAYCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') =VNGAYCONGVAN  AND sd.donid =  D.id)
                            )
                   )

               and
                1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                and
                1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                 and

                1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
                and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
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
        )
        LOOP
          v_dem:=v_dem+1;
           ---------
            IF(V_BC_SoCV IS NOT NULL) THEN
               V_CD_SOTB:=to_char(V_BC_SoCV+v_dem-1);
                IF(LENGTH(V_CD_SOTB)=1)THEN
                    V_CD_SOTB:='0'||V_CD_SOTB;
                END IF;
            ELSE
              V_CD_SOTB:='    ';
            END IF;

             --------
             if(item.BAQD_SO is not null)then
                     if(item.BAQD_LOAIQDBA='0')then
                     V_NOIDUNG:='đề nghị xem xét theo thủ tục giám đốc thẩm/tái thẩm đối với Bản án số ' ||item.BAQD_SO;
                     else
                      V_NOIDUNG:='đề nghị xem xét theo thủ tục giám đốc thẩm/tái thẩm đối với Quyết định số ' ||item.BAQD_SO;
                     end if;
                     ---    
                     if(item.BAQD_NGAYBA is not null)then                  
                        V_NOIDUNG:=V_NOIDUNG ||' ngày '||TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy');
                     else     
                       V_NOIDUNG:=V_NOIDUNG||' của ';
                    end if;
                    if(item.BAQD_TOAANID is not null and item.BAQD_TOAANID !=0) then
                     V_NOIDUNG:=V_NOIDUNG||' của '||item.TOAXX ||' đã có hiệu lực pháp luật.';
                     else
                      V_NOIDUNG:=V_NOIDUNG||' của '||item.BAQD_TENTOA ||' đã có hiệu lực pháp luật.';
                    end if;
                elsif(item.NOIDUNGDON is not null) then
                   V_NOIDUNG:=item.NOIDUNGDON||'.';
                 elsif(item.NOIDUNGDON is null and item.GHICHU is not null) then   
                    V_NOIDUNG:=item.GHICHU||'.';
             end if;
             -------
             IF(item.DUNGDONLA=1)then
               if(item.NGUOIGUI_GIOITINH=1)then
                  V_GIOITINH:='ông';
                  V_GIOITINHHOA:='Ông';
                else
                   V_GIOITINH:='bà';
                  V_GIOITINHHOA:='bà';
               end if;
              elsif(item.DUNGDONLA=2)then 
               V_GIOITINH:='Các ông, bà';
             end if;
             -------
              V_DIACHICOQUAN:=item.CVDIACHI;
              if(V_LOAIDON8_1=1)then
               IF(item.LOAICONGVAN is not null) then
                   SELECT i.MA into V_LoaiCV_MA from  DM_DATAITEM i where i.id=item.LOAICONGVAN;
                    V_NOIDUNG:='';
                      if(V_LoaiCV_MA='CV8.1.DBQH')then
                          V_DIACHICOQUAN:=item.CV_TRAIGIAMHIENTAI;
                          V_NOIDUNG:='Tòa án nhân dân tối cao nhận được Phiếu chuyển đơn của '|| item.CV_TENDONVI||', '||item.CV_TRAIGIAMHIENTAI;
                          V_NOIDUNG:=V_NOIDUNG||', chuyển đơn của '|| V_GIOITINH||' '|| item.DONGKHIEUNAI|| ' (có địa chỉ '||item.Diachigui|| ') ';
                      else
                        V_NOIDUNG:= 'Tòa án nhân dân tối cao nhận được Công văn số ' || item.CV_SO || ' ngày '|| to_char(item.CV_NGAY,'dd/MM/yyyy') || ' của ' || item.CV_TENDONVI;
                        V_NOIDUNG:= V_NOIDUNG||' về việc chuyển đơn của '|| V_GIOITINH||' '|| item.DONGKHIEUNAI || ' (có địa chỉ ' || item.Diachigui || ') ';
                        V_NOIDUNG:= V_NOIDUNG|| 'đề ngày ' || to_char(item.NGAYGHITRENDON,'dd/MM/yyyy') || ' ';
                      end if;
                   V_NOIDUNG:= V_NOIDUNG||' có nội dung';
                   ----------
                       if(item.BAQD_LOAIQDBA='0') then--BA
                           if(item.BAQD_SO is not null)then
                                V_NOIDUNG:=V_NOIDUNG ||' đề nghị xem xét theo thủ tục giám đốc thẩm đối với Bản án số ' ||item.BAQD_SO;
                                 if(item.BAQD_NGAYBA is not null)then                  
                                    V_NOIDUNG:=V_NOIDUNG ||' ngày '||TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy');
                                 else     
                                   V_NOIDUNG:=V_NOIDUNG||' của';
                                end if;
                                if(item.BAQD_TOAANID is not null and item.BAQD_TOAANID !=0) then
                                 V_NOIDUNG:=V_NOIDUNG||' của '||item.TOAXX ||' đã có hiệu lực pháp luật.';
                                 else
                                  V_NOIDUNG:=V_NOIDUNG||' của '||item.BAQD_TENTOA ||' đã có hiệu lực pháp luật.';
                                end if;
                              elsif(item.NOIDUNGDON is not null) then
                               V_NOIDUNG:=V_NOIDUNG||' '||item.NOIDUNGDON||'.';
                              elsif(item.NOIDUNGDON is null and item.GHICHU is not null) then   
                                V_NOIDUNG:=V_NOIDUNG||' '||item.GHICHU||'.';
                         end if;
                        else --Kháng nghị
                        V_NOIDUNG:=V_NOIDUNG||' kiến nghị đối với Quyết định kháng nghị giám đốc thẩm số ' || item.KN_SOQD || ' ngày '|| to_char(item.KN_NGAY,'dd/MM/yyyy');
                        V_NOIDUNG:=V_NOIDUNG||' của '||item.TOAXX || ' kháng nghị đối với Bản án số ' || item.BAQD_SO || ' ngày ' || TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy');
                        V_NOIDUNG:=V_NOIDUNG|| ' của ';
                        if(item.BAQD_TOAANID is not null and item.BAQD_TOAANID!=0)then
                             SELECT MA_TEN INTO V_TOAAN_TEN FROM DM_TOAAN WHERE ID=item.BAQD_TOAANID;
                             V_NOIDUNG:=V_NOIDUNG|| V_TOAAN_TEN||'.';
                        end if;
                      end if;
                   -----   
                end if;
              end if;
              ---
               v_table.extend;
                v_table(v_table.count) := R_DT_NOIBO_THONGBAO(
                 item.CD_SOCV,null,null,null,null,null,item.DONGKHIEUNAI,item.Diachigui,null,item.BAQD_SO
                ,item.BAQD_NGAYBA,item.TOAXX,V_NOIDUNG,null,null,V_GIOITINH,V_BC_Nguoiky,item.CV_TENDONVI,V_DIACHICOQUAN,item.CV_SO
                ,to_char(item.CV_NGAY,'dd/MM/yyyy'),null,item.NOICHUYEN,null,V_CD_SOTB,null,null,null,null,null
                ,null,null,null,null,null,null,null,to_char(to_date(item.CD_NGAYCV,'dd-MON-yy'),'dd/MM/yyyy'),V_GIOITINHHOA,null
                ,null,null,to_char(to_date(item.CD_NGAYCV,'dd-MON-yy'),'dd/MM/yyyy'),null);


        END LOOP;
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
      ----------
         if(V_BC_NGAYDK is not null) then
            V_CD_NGAYCV:=to_date(V_BC_NGAYDK,'dd/MM/yyyy');
         end if;
      -----------
      v_dem:=0;
      FOR item in (
         SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE)PA
      )
      LOOP
      v_dem:=v_dem+1;
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
               <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 60px; text-align: right;"><span>TÒA Á</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>N NHÂN DÂN T</span>
                            </th>
                            <th style="text-align: left;"><span>ỐI CAO</span></th>
                        </tr>
                    </table>
                </td>
                <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <td style="font-size: 13pt">Số: '||item.SOTHONGBAO||'/TB-TANDTC-VP</td>
                <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh phú</span>
                            </th>
                            <th style="text-align: left;"><span>c</span></th>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="font-size: 13pt"></td>');
            if(V_BC_NGAYDK is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="font-size: 13pt; font-style: italic"><span style="color: #ffffff;">..................</span>Hà Nội, ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                ');
              else
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="font-size: 13pt; font-style: italic"><span style="color: #ffffff;">.........................</span >Hà Nội, ngày <span style="color: #ffffff;">...</span> tháng <span style="color: #ffffff;">...</span> năm <span style="color: #ffffff;">...</span></td>
                ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
            </tr>
            <tr style="">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 500px"></td>
                <td style="width: 750px"></td>
            </tr>
        </table>
              <p style="font-size: 14pt; text-align: center;line-height: 100%;margin-top:28pt;">
                    Kính gửi: ');
                     if(item.DIACHICOQUAN is not null)then
                         DBMS_LOB.APPEND(V_EXPORT_TEXT, item.TENCOQUAN||', <br/>'||item.DIACHICOQUAN );
                     elsif(item.DIACHICOQUAN is null)then
                           DBMS_LOB.APPEND(V_EXPORT_TEXT, item.TENCOQUAN||' ');
                     end if;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'     
               </p> 
           ');    
          if(V_LOAIDON8_1=0)then
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
            Tòa án nhân dân tối cao nhận được Công văn số '||item.SOCV||' ngày '||item.NGAYCV||' của '||item.TENCOQUAN||' chuyển đơn của '||item.GIOITINH||' '||item.NGUOIGUI||' về việc '||item.NOIDUNG||'</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:0pt;margin-bottom:4pt"><span style="color:white;">............</span>
            Sau khi nghiên cứu đơn đề nghị nêu trên, Tòa án nhân dân tối cao đã chuyển đơn của '||item.GIOITINH||' '||item.NGUOIGUI||' đến '||item.TENPHONGBANNHAN||' theo công văn số '||item.SOTOTRINH||'/TANDTC-VP ngày '||item.NGAYTOTRINH||' để xem xét, giải quyết theo quy định pháp luật.</p>
           '); 
           elsif(V_LOAIDON8_1=1)then
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <p style="font-size: 14pt; text-align: justify;margin-top:2pt;margin-bottom:4pt"><span style="color:white;">............</span>'
            ||item.NOIDUNG||'</p>
            <p style="font-size: 14pt; text-align: justify;margin-top:0pt;margin-bottom:4pt"><span style="color:white;">............</span>
            Căn cứ theo quy định của pháp luật tố tụng, ngày '||item.CD_NGAY||' Tòa án nhân dân tối cao đã có Công văn số '||item.SOTOTRINH||'/TANDTC-VP chuyển đơn của '||item.GIOITINH||' '||item.NGUOIGUI||' đến '||item.TENPHONGBANNHAN||item.LYDO||' để xem xét, giải quyết theo thẩm quyền, báo cáo kết quả giải quyết đến Chánh án Tòa ánh nhân dân tối cao và thông báo kết quả giải quyết cho '||item.TENCOQUAN||'.</p>
           '); 
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">............</span> Tòa án nhân dân tối cao trân trọng thông báo để '||item.TENCOQUAN||' '||item.DIACHICOQUAN||' biết./.</p> 
          ');
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                            <i><b>Nơi nhận:</b></i><br/>
                            - Như trên;<br />
                            - Đ/c Chánh án TANDTC (để b/c);<br />
                            - Đ/c Chánh Văn phòng TANDTC (để b/c);<br />
                            - Lưu: VP TANDTC.<br />
                        </p>
                    </td>
                    <td>
                         <p style="font-size:13pt;">
                              <strong>
                                TL. CHÁNH ÁN<br />
                                KT. CHÁNH VĂN PHÒNG<br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                         <p style="font-size:13pt;margin-top:10pt;"><strong>'||V_BC_Nguoiky||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
            IF(v_dem<item.CountAll) THEN
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;
        END LOOP;
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END GUI_COQUAN_CHUYENDON;

FUNCTION TBL_GIAYXACNHANCC
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  PageIndex in  int,
  PageSize  in  int
) RETURN T_NOIBO_GIAYXACNHAN
IS 
  V_EXPORT_TEXT clob;V_TABLE T_NOIBO_GIAYXACNHAN;
  V_LOAIDON8_1 NUMBER:=0;V_ID NUMBER;
  V_CAPCHAID NUMBER;
  V_DIACHICOQUAN  varchar2(1000);
  V_NOIDUNG varchar2(2000);
  V_GIOITINH varchar2(250);
  V_GIOITINHHOA varchar2(250);
  V_CD_SOCV varchar2(250);
  V_CD_NGUOIKY varchar2(250);
  v_loaiBAQD varchar2(250);V_BASO varchar2(250); V_NGAYBA  varchar2(250);  V_TOAXX  varchar2(500); v_Loaidon varchar2(500); v_NguonDen  varchar2(500);
  v_CAPXX  varchar2(500);v_LOAIAN_TEXT  varchar2(250); v_BIDANH  varchar2(250); 
  v_loai_gdt  varchar2(250);
  V_COUNT NUMBER;
  V_NGUOIGUI_DONGKHIEUNAI VARCHAR2(2500);
  V_NGUOIGUI_DONGKHIEUNAI_DIACHI VARCHAR2(2500);
BEGIN
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_NOIBO_GIAYXACNHAN();
       -------
       IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
           SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
           IF(V_ID=1023 or V_CAPCHAID=1023) then
            V_LOAIDON8_1:=1;
           end if;
        END IF;
        select GHICHU into v_BIDANH from QT_NGUOISUDUNG where id=v_ID_USER;

  FOR item IN (
           Select   D.ID,d.CV_TENDONVI
                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) BAQD_SO
                    ,d.CV_DIACHI CVDIACHI,d.CV_TRAIGIAMHIENTAI,decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) BAQD_NGAYBA
                    ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
                    ,d.NOIDUNGDON,d.GHICHU,d.CV_SO,d.CV_NGAY,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
                    ,Decode(d.loaidon,2,d.CV_TENDONVI,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,NVL(d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI)) DONGKHIEUNAI
                    ,d.LOAICONGVAN
                    ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else (case when d.LOAIDON NOT IN (6,9) then d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    else d.CV_DIACHI ||(case when (d.CV_DIACHI || ' ')=' '  then ' ' Else ', ' End) || hv.MA_TEN  End)
                    End) Diachigui  --lanhnt
                    ,d.NGAYGHITRENDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,d.KN_SOQD,d.KN_NGAY
                    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                    when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                    when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                    when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
                    ,D.CD_SOCV,D.CD_NGAYCV
                    ,d.BAQD_TOAANID
                    ,decode(d.BAQD_CAPXETXU,2,TAS.MA_TEN,3,TAP.MA_TEN,TAG.MA_TEN) BAQD_TOAAN_NAME
                    ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME, VTD.NGUON_DEN, VTD.NGAY_BT
                    ,D.LOAIDON,D.NGAYNHANDON,D.BAQD_LOAIAN,D.LOAI_GDTTTT,D.BAQD_CAPXETXU,D.BAQD_SO_PT,D.BAQD_NGAYBA_PT
                    ,TAG.MA_TEN BAQD_TENTOA,TAP.MA_TEN BAQD_TENTOA_PT,TAS.MA_TEN BAQD_TENTOA_ST,D.BAQD_TOAANID_PT,D.BAQD_SO_ST,D.BAQD_NGAYBA_ST,D.BAQD_TOAANID_ST
                     ,null NGUOIGUI_DONGKHIEUNAI,null NGUOIGUI_DONGKHIEUNAI_DIACHI
                    ,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,sph.NGUOIKY GXNNGUOIKY , decode (sph.SOVB,null,'none','block') IsGXN
            from GDTTT_DON d
             --Thong tin Giay xac nhận
               LEFT JOIN(select so.*,sd.donid  from  SOPHATHANH_DON sd 
                                LEFT JOIN QUANLY_SOPHATHANH so on so.id = sd.SOPHATHANH_ID 
                                    where ( (so.maso = 'SoGXN' AND vToaAnID = 4) 
                                             OR(so.maso = 'SoGXN_DV' AND vToaAnID != 4)
                                          )--29/10/2024
                                         and so.trangthai = 1)sph on sph.donid = d.id
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAG ON TAG.ID = D.BAQD_TOAANID
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAP ON TAP.ID = D.BAQD_TOAANID_PT
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAS ON TAS.ID = D.BAQD_TOAANID_ST
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
              LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
              LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
              LEFT JOIN (
                     SELECT CN.GDTTT_DON_ID,VT.NGUON_DEN,VT.MABD,VT.NGAY_BT from VT_CHUYEN_NHAN  CN 
                                    inner join (select * from VT_VANBANDEN) VT on  CN.VANBANDEN_ID = VT.ID
                        ) VTD on D.ID = VTD.GDTTT_DON_ID
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID  --lanhnt
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                WHERE (INSTR(VARRSELECTID,','||D.ID||',')>0)
                ORDER BY d.NGAYTAO DESC
        )
        LOOP
           SELECT COUNT(*) INTO V_COUNT FROM GDTTT_DON_NGUOIKN DKN WHERE DKN.DONID=item.ID;
           V_NGUOIGUI_DONGKHIEUNAI:='';V_NGUOIGUI_DONGKHIEUNAI_DIACHI:='';
            IF(V_COUNT>0)THEN
             SELECT LISTAGG(DECODE(DKN.GIOITINH,0, ' bà ', 1, ' ông ', ' ') || DKN.HOTEN, ',') WITHIN GROUP (ORDER BY DKN.ID DESC)
                    ,LISTAGG(DECODE(DKN.GIOITINH,0, ' - Bà ', 1, ' - Ông ', ' - ') || DKN.HOTEN || ', ' || 'địa chỉ: ' || DKN.DIACHI, ';' || CHR(10)) WITHIN GROUP (ORDER BY DKN.ID DESC)
                    INTO V_NGUOIGUI_DONGKHIEUNAI,V_NGUOIGUI_DONGKHIEUNAI_DIACHI
             FROM GDTTT_DON_NGUOIKN DKN
             WHERE DKN.DONID=item.ID
             GROUP BY DKN.DONID;
            END IF; 
            IF(vToaAnID != 4) THEN --29/10/2024
                IF(item.DUNGDONLA=1)then
               if(item.NGUOIGUI_GIOITINH=1)then
                  V_GIOITINH:='ông';
                  V_GIOITINHHOA:='Ông';
                else
                   V_GIOITINH:='bà';
                  V_GIOITINHHOA:='Bà';
               end if;
              elsif(item.DUNGDONLA=2)then 
               V_GIOITINH:='Các ông, bà';
             end if;
           end if;  
             -------
              V_DIACHICOQUAN:=item.CVDIACHI;
              ---
                if (item.LOAIDON in (7)) then
                    v_Loaidon := 'thông báo';
                 elsif (item.LOAIDON in (6,9)) then
                    v_Loaidon := 'công văn kiến nghị';
                 else 
                    v_Loaidon := 'đơn đề nghị';
                 end if;
                 ---
                V_NOIDUNG:='';  
             if (item.LOAIDON in (3,9)) then
                if(item.CV_SO is not null)then
                    V_NOIDUNG:=V_NOIDUNG ||' (theo công văn số '||item.CV_SO;
                     if(item.CV_NGAY is not null)then                  
                        V_NOIDUNG:=V_NOIDUNG ||' ngày '||TO_char(item.CV_NGAY,'dd/MM/yyyy');
                    end if;
                    if(item.CV_TENDONVI is not null) then
                     V_NOIDUNG:=V_NOIDUNG||' của '||item.CV_TENDONVI;
                    end if;

                    V_NOIDUNG:=V_NOIDUNG||')';

                end if;
             end if;

                  if (item.NGUON_DEN = 1) then
                        v_NguonDen := 'gửi qua dịch vụ bưu chính chuyển đến';
                  else
                        v_NguonDen := 'nộp trực tiếp';
                  end if;

               if (item.BAQD_CAPXETXU = 3) then
                    v_CAPXX := 'phúc thẩm';
                 elsif (item.BAQD_CAPXETXU = 2) then
                    v_CAPXX := 'sơ thẩm';
                 else 
                    v_CAPXX := '';
                 end if;

              if (item.BAQD_LOAIAN = 1)then
                v_LOAIAN_TEXT := 'HS';
              elsif (item.BAQD_LOAIAN = 2)then
                v_LOAIAN_TEXT := 'DS';
              elsif (item.BAQD_LOAIAN = 3)then
                v_LOAIAN_TEXT := 'HNGD';
              elsif (item.BAQD_LOAIAN = 4)then
                v_LOAIAN_TEXT := 'KDTM';
              elsif (item.BAQD_LOAIAN = 5)then
                v_LOAIAN_TEXT := 'LD';
              elsif (item.BAQD_LOAIAN = 6)then
                v_LOAIAN_TEXT := 'HC';
              elsif (item.BAQD_LOAIAN = 7)then
                v_LOAIAN_TEXT := 'PS';
              end if;

              if (item.LOAI_GDTTTT = '1')then
                    v_loai_gdt:= 'giám đốc thẩm';
              elsif (item.LOAI_GDTTTT = '2')then
                    v_loai_gdt:= 'tái thẩm';
              else
                    v_loai_gdt:= '';
              end if;

              if (item.BAQD_LOAIQDBA = 0)then
                    v_loaiBAQD:= 'Bản án';
              else
                    v_loaiBAQD:= 'Quyết định';
              end if;

                v_table.extend;
                v_table(v_table.count) := R_NOIBO_GIAYXACNHAN(
                v_Loaidon,item.DUNGDONLA,item.NGUOIGUI_GIOITINH,v_NguonDen,to_char(item.NGAYGHITRENDON,'dd/MM/yyyy'), item.DONGKHIEUNAI,V_GIOITINHHOA,item.Diachigui,to_char(item.NGAYNHANDON,'dd/MM/yyyy'),item.CV_SO,to_char(item.CV_NGAY,'dd/MM/yyyy'),
                V_NOIDUNG,item.CV_TENDONVI,V_DIACHICOQUAN,v_LOAIAN_TEXT,item.BAQD_LOAIAN_NAME,
                v_loai_gdt,v_loaiBAQD,v_CAPXX,item.BAQD_SO, TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy'),item.BAQD_TOAAN_NAME,
                V_NGUOIGUI_DONGKHIEUNAI, V_NGUOIGUI_DONGKHIEUNAI_DIACHI,
                item.GXNSO,item.GXNNGAY,item.GXNNGUOIKY);
        END LOOP;
        RETURN V_TABLE;
END TBL_GIAYXACNHANCC;
PROCEDURE DON_SEARCH_GIAYXACNHANCC
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  PageIndex in  int,
  PageSize  in  int,
  curReturn OUT sys_refcursor
)
IS 
BEGIN
    OPEN curReturn FOR
       SELECT COUNT(*) OVER () as CountAll,
       PA.* FROM TABLE(PKG_GDTTT_HCTP_BC.TBL_GIAYXACNHANCC(V_BC_NGAYDK,V_BC_NGUOIKY,V_BC_SOCV,V_ID_USER,VTOAANID,VTOARABAQD,VSOBAQD,VNGAYBAQD,VNGUOIGUI,VSOCMND,VTUNGAY,VDENNGAY,VHINHTHUCDON,VSOHIEUDON,VDIACHITINH,VDIACHIHUYEN,VDIACHICT,VSOCONGVAN,VNGAYCONGVAN,VTRALOI,VNGUOINHAP,VNOICHUYEN,VTRANGTHAI,VCD_DONVIID,VCD_TA_TRANGTHAI,VCD_TENDONVI,VNGAYCHUYENTU,VNGAYCHUYENDEN,VARRSELECTID,VISTHULY,VPHANLOAIXULY,VNGAYTHULYTU,VNGAYTHULYDEN,VSOTHULY,VCHIDAO,VTRAIGIAM,VTBQUAHAN,VNGAYQUAHAN,VTHAMPHANID,VTHAMTRAVIENID,VLOAICVID,VNGAYNHAPTU,VNGAYNHAPDEN,VISDONGOC,VISTUHINH,VLOAIAN,VCVPC_SO,VCVPC_NGAY,VCVPC_TENCQ,VGUITOICA_TA,PAGEINDEX,PAGESIZE))  PA;
END DON_SEARCH_GIAYXACNHANCC;
PROCEDURE DON_SEARCH_GIAYXACNHANCC_S
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
)IS 
  V_EXPORT_TEXT clob;V_TABLE T_NOIBO_GIAYXACNHAN;  
  V_CD_NGAYCV date;
  V_CD_SOTB varchar2(250); v_dem NUMBER:=0;
  V_NGAY varchar2(250):=NULL;V_THANG varchar2(250):=NULL;V_NAM varchar2(250):=NULL;
  V_CD_NGUOIKY varchar2(250);
  V_TENDONVI varchar2(250);
  V_TENDONVI_FULL varchar2(250);
  V_DONVI_CV varchar2(250);
  V_TENDONVI_HC varchar2(250);
  v_Loaidon varchar2(500);
  v_BIDANH  varchar2(250); 
  v_TENDONVICC VARCHAR2(500);

BEGIN
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
       v_table := T_NOIBO_GIAYXACNHAN();
         FOR item in (
                SELECT PA.LOAIDON,PA.DUNGDONLA,PA.NGUOIGUI_GIOITINH,PA.HINHTHUCNHANDON,PA.NGAYTRENDON,PA.NGUOIGUI,PA.GIOITINH,PA.DIACHI,PA.NGAYNHANDON,PA.SOCV,PA.NGAYCV,PA.TAILIEU,PA.TENCOQUAN,PA.DIACHICOQUAN,PA.LOAIAN,
                       PA.TENLOAIAN,PA.LOAIGDTT,PA.LOAIBAQD,PA.CAPXX,PA.BA_SO,PA.BA_NGAY,PA.BA_TOAXX,PA.NGUOIGUI_DONGKHIEUNAI,PA.NGUOIGUI_DONGKHIEUNAI_DIACHI,PA.SOVANBAN,PA.NGAYVANBAN,PA.NGUOIKYVANBAN   
                FROM TABLE(PKG_GDTTT_HCTP_BC.TBL_GIAYXACNHANCC(V_BC_NGAYDK,V_BC_NGUOIKY,V_BC_SOCV,V_ID_USER,VTOAANID,VTOARABAQD,VSOBAQD,VNGAYBAQD,VNGUOIGUI,VSOCMND,VTUNGAY,VDENNGAY,VHINHTHUCDON,VSOHIEUDON,VDIACHITINH,VDIACHIHUYEN,VDIACHICT,VSOCONGVAN,VNGAYCONGVAN,VTRALOI,VNGUOINHAP,VNOICHUYEN,VTRANGTHAI,VCD_DONVIID,VCD_TA_TRANGTHAI,VCD_TENDONVI,VNGAYCHUYENTU,VNGAYCHUYENDEN,VARRSELECTID,VISTHULY,VPHANLOAIXULY,VNGAYTHULYTU,VNGAYTHULYDEN,VSOTHULY,VCHIDAO,VTRAIGIAM,VTBQUAHAN,VNGAYQUAHAN,VTHAMPHANID,VTHAMTRAVIENID,VLOAICVID,VNGAYNHAPTU,VNGAYNHAPDEN,VISDONGOC,VISTUHINH,VLOAIAN,VCVPC_SO,VCVPC_NGAY,VCVPC_TENCQ,VGUITOICA_TA,PAGEINDEX,PAGESIZE))  PA
                )
        LOOP
            v_table.extend;
            v_table(v_table.count) := R_NOIBO_GIAYXACNHAN(
            item.LOAIDON,item.DUNGDONLA,item.NGUOIGUI_GIOITINH,item.HINHTHUCNHANDON,item.NGAYTRENDON,item.NGUOIGUI,item.GIOITINH,item.DIACHI,item.NGAYNHANDON,item.SOCV,item.NGAYCV,item.TAILIEU
            ,item.TENCOQUAN,item.DIACHICOQUAN,item.LOAIAN,item.TENLOAIAN,item.LOAIGDTT,item.LOAIBAQD,item.CAPXX,item.BA_SO,item.BA_NGAY,item.BA_TOAXX,item.NGUOIGUI_DONGKHIEUNAI
            ,item.NGUOIGUI_DONGKHIEUNAI_DIACHI,item.SOVANBAN,item.NGAYVANBAN,item.NGUOIKYVANBAN
            );
        END LOOP;
       --Tạo dữ liệu báo cáo-------
      IF(V_BC_NGAYDK IS NOT NULL) THEN
            V_CD_NGAYCV:=to_date(V_BC_NGAYDK,'dd/MM/yyyy');
             V_NGAY:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'dd');
             V_THANG:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'MM');
            V_NAM:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'yyyy');
       END IF;
       -----------
       IF(V_BC_Nguoiky IS NOT NULL) THEN
           V_CD_NGUOIKY:=V_BC_Nguoiky;
       END IF;
    IF(vToaAnID = 4) THEN
            v_TENDONVICC := 'tại Hà Nội';
        ELSIF (vToaAnID = 5) THEN
            v_TENDONVICC := 'tại Đà Nẵng';
        ELSIF (vToaAnID = 6) THEN
            v_TENDONVICC := 'tại Thành phố Hồ Chí Minh';
        END IF;
        -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN,replace(replace(HC.TEN,'Thành phố ',''),'thành phố ','')
     INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=vToaAnID;
    --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      ----------
         if(V_BC_NGAYDK is not null) then
            V_CD_NGAYCV:=to_date(V_BC_NGAYDK,'dd/MM/yyyy');
         end if;
      -----------
      v_dem:=0;
      FOR item in (
         SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE)PA
      )
      LOOP
        v_dem:=v_dem+1;
           ---------
            IF(V_BC_SoCV IS NOT NULL) THEN
               V_CD_SOTB:=to_char(V_BC_SoCV+v_dem-1);
             ELSE
              V_CD_SOTB:=v_dem;
             END IF;
             IF(LENGTH(V_CD_SOTB)=1)THEN
                V_CD_SOTB:='0'||V_CD_SOTB;
             END IF;

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                    <th style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">TÒA ÁN NHÂN DÂN CẤP CAO</th>
                    <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr>
                    <td style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">
                        <table cellpadding="0" cellspacing="0">');
                        IF(vToaAnID = 4 or vToaAnID = 5) THEN
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <td style="text-align: right; padding-right: 2px; color: #ffffff;"><span>------</span></td>
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(v_TENDONVICC)||'</span>
                                    </th>
                                <td style="text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                            </tr>');
                                ELSIF (vToaAnID = 6) THEN
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(v_TENDONVICC)||'</span>
                                    </th>');
                                END IF;

                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        </table>

                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 12.5pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
            <tr style="text-align: center;">
                                <td style="font-size: 13pt">Số: '||V_CD_SOTB||'/GXN-'||item.LOAIAN||'-'||V_DONVI_CV||'</td>           
                <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="font-size: 13pt"></td>');

                            if(vToaAnID = 4 or vToaAnID = 5) THEN
                                if(V_BC_NGAYDK is not null) then
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                                    ');
                                  else
                                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">'||V_TENDONVI_HC||', ngày <span style="color: #ffffff;">.....</span> tháng <span style="color: #ffffff;">.....</span> năm <span style="color: #ffffff;">...</span></td>
                                    ');
                                end if;
                            else
                                if(V_BC_NGAYDK is not null) then
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">Tp.'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                                    ');
                                  else
                                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">Tp.'||V_TENDONVI_HC||', ngày <span style="color: #ffffff;">.....</span> tháng <span style="color: #ffffff;">.....</span> năm <span style="color: #ffffff;">...</span></td>
                                    ');
                                 end if;
                             end if;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                        </tr>
                    </table>
                </td>
            </tr>

            <tr style="">
                <td></td>
                <td></td>
            </tr>');            
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 10px;">
                <td style="width: 500px"></td>
                <td style="width: 750px"></td>
            </tr>
        </table>');
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table>
            <tr><th colspan="2" style="font-size: 14pt; text-align: center;">GIẤY XÁC NHẬN</th></tr>
            <tr><th colspan="2" style="font-size: 14pt; text-align: center;">Nhận '||v_Loaidon||' xem xét theo thủ tục '|| item.LOAIGDTT ||'</th></tr>
            <tr style="height: 10px;">
                <td style="width: 500px"></td>
                <td style="width: 750px"></td>
            </tr>
        </table>');

        IF(ITEM.NGUOIGUI_DONGKHIEUNAI IS NULL) THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <table>
                    <tr><td style="font-size: 14pt; text-align: left;width: 190px">
                        <span style="color:white;">.......................</span>Kính gửi:</td>
                        <td  style="font-size: 14pt; text-align: left;"> 
                                '||item.GIOITINH||' '|| item.NGUOIGUI||'</span></td>
                    </tr>
                    <tr><td style="font-size: 14pt;margin-top:5px;text-align: left;vertical-align: top;width: 190px">
                           <span style="color:white;">.......................</span>Địa chỉ:</td>
                           <td  style="font-size: 14pt; text-align: left;"> '|| item.DIACHI||'</td> 
                    </tr>
                </table>              
            ');  
        ELSE
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <table>
                    <tr>
                        <td style="font-size: 14pt; text-align: left; width: 190px; vertical-align: text-top;"><span style="color:white;">.......................</span>Kính gửi:</td>
                        <td style="font-size: 14pt; text-align: left;"> - '||item.GIOITINH||' '|| item.NGUOIGUI||' địa chỉ: '|| item.DIACHI||';<br/>
                                                                          '||ITEM.NGUOIGUI_DONGKHIEUNAI_DIACHI||'.</td>
                    </tr>
                </table>              
            ');
        END IF;   

            IF(ITEM.NGUOIGUI_DONGKHIEUNAI IS NULL) THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                            Tòa án nhân dân cấp cao '||v_TENDONVICC||' nhận được đơn đề ngày '||item.NGAYTRENDON||' của '||
                            lower(item.GIOITINH)||' '||item.NGUOIGUI||' '||item.HINHTHUCNHANDON||' '||item.TAILIEU||' về việc đề nghị Chánh án Tòa án nhân dân cấp cao '||v_TENDONVICC||' 
                            xem xét theo thủ tục '|| item.LOAIGDTT ||' đối với '|| item.LOAIBAQD||' '||
                           item.TENLOAIAN||' '||item.CAPXX||' số '||item.BA_SO||' ngày '||item.BA_NGAY||' của '|| item.BA_TOAXX||' đã có hiệu lực pháp luật.</p>
                           ');
            ELSE           
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:4pt"><span style="color:white;">............</span>
                            Tòa án nhân dân cấp cao '||v_TENDONVICC||' nhận được đơn đề ngày '||item.NGAYTRENDON||' của '||
                            lower(item.GIOITINH)||' '||item.NGUOIGUI||', '||ITEM.NGUOIGUI_DONGKHIEUNAI||' '||item.HINHTHUCNHANDON||' '||item.TAILIEU||' về việc đề nghị Chánh án Tòa án nhân dân cấp cao '||v_TENDONVICC||' 
                            xem xét theo thủ tục '|| item.LOAIGDTT ||' đối với '|| item.LOAIBAQD||' '||
                           item.TENLOAIAN||' '||item.CAPXX||' số '||item.BA_SO||' ngày '||item.BA_NGAY||' của '|| item.BA_TOAXX||' đã có hiệu lực pháp luật.</p>
                           ');
            END IF;               

                          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                          <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">............</span>
                          Tòa án nhân dân cấp cao '||v_TENDONVICC||' sẽ tiến hành xem xét '|| 
                          item.LOAIDON||' theo quy định của pháp luật.</p> 
                          ');
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                                            <i><b>Nơi nhận:</b></i><br/>
                                            - Như trên;<br />
                                            - Lưu: Tiểu hồ sơ ('||v_BIDANH||').<br />
                                        </p>
                                    </td>

                ');
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'

                    <td>
                         <p style="font-size:13pt;">
                              <strong>
                                TL. CHÁNH ÁN<br />
                                KT. CHÁNH VĂN PHÒNG<br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                         <p style="font-size:13pt;margin-top:10pt;"><strong>'||V_BC_Nguoiky||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
            IF(v_dem<item.CountAll) THEN
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;
        END LOOP;

    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);

  END DON_SEARCH_GIAYXACNHANCC_S;



PROCEDURE DON_SEARCH_THONG_BAO_YCBSCC
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  PageIndex in  int,
  PageSize  in  int,
  curReturn OUT sys_refcursor
)
IS 
  V_EXPORT_TEXT clob;V_TABLE T_NOIBO_YCBS;
  V_CD_NGAYCV date;V_LOAIDON8_1 NUMBER:=0;V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTB varchar2(250); v_dem NUMBER:=0;V_DIACHICOQUAN  varchar2(500);V_NOIDUNG varchar2(2000);V_GIOITINH varchar2(250);V_GIOITINHHOA varchar2(250);
  V_LoaiCV_MA  varchar2(250);V_TOAAN_TEN varchar2(250);
  V_NGAY varchar2(250):=NULL;V_THANG varchar2(250):=NULL;V_NAM varchar2(250):=NULL;
  V_CD_SOCV varchar2(250);V_CD_NGUOIKY varchar2(250);
  V_TENDONVI varchar2(250);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
  v_loaiBAQD  varchar2(250);V_BASO varchar2(250); V_NGAYBA  varchar2(250);  V_TOAXX  varchar2(500); v_Loaidon varchar2(500); v_NguonDen  varchar2(500);
  v_CAPXX  varchar2(250);v_LOAIAN_TEXT  varchar2(250); v_BIDANH  varchar2(250); v_loaidon_dn  varchar2(250);v_loai_gdt   varchar2(250);
  v_TailieuBS  varchar2(2000);v_TENDONVICC VARCHAR2(500); VV_NGUOIKY VARCHAR2(500);VV_NGUOITAO VARCHAR2(500); retVal int;numYCBS int; v_TRANGTHAIDON int;
  v_FileName varchar2(250);
BEGIN
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_NOIBO_YCBS(); VV_NGUOIKY := V_BC_Nguoiky;
       -------
       IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
           SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
           IF(V_ID=1023 or V_CAPCHAID=1023) then
            V_LOAIDON8_1:=1;
           end if;
        END IF;
        v_TRANGTHAIDON := vCD_TA_TRANGTHAI;
        select GHICHU into v_BIDANH from QT_NGUOISUDUNG where id=v_ID_USER;
              
        -----   
  FOR item IN (
           Select  d.ID,d.CV_TENDONVI
                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) BAQD_SO
                    --,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
                    --,d.BAQD_SO
                    ,d.CV_DIACHI CVDIACHI,d.CV_TRAIGIAMHIENTAI,decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) BAQD_NGAYBA
                    ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
                    ,d.NOIDUNGDON,d.GHICHU,d.CV_SO,d.CV_NGAY,d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.DONGKHIEUNAI,d.LOAICONGVAN
                    /*,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    End) Diachigui*/
                    ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else (case when d.LOAIDON NOT IN (6,9) then d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    else d.CV_DIACHI ||(case when (d.CV_DIACHI || ' ')=' '  then ' ' Else ', ' End) || hv.MA_TEN  End) --lanhnt
                    End) Diachigui
                    ,d.NGAYGHITRENDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,d.KN_SOQD,d.KN_NGAY
                    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                    when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                    when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                    when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
                    ,D.CD_SOCV,D.CD_NGAYCV
                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)BAQD_TOAANID
                    ,decode(d.BAQD_CAPXETXU,2,TAS.MA_TEN,3,TAP.MA_TEN,TAG.MA_TEN) BAQD_TOAAN_NAME
                    ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME, VTD.NGUON_DEN, VTD.NGAY_BT
                    ,D.LOAIDON,D.NGAYNHANDON,D.BAQD_LOAIAN,D.LOAI_GDTTTT,D.BAQD_CAPXETXU,D.BAQD_SO_PT,D.BAQD_NGAYBA_PT
                    ,TAG.TEN BAQD_TENTOA ,TAP.TEN BAQD_TENTOA_PT,TAS.TEN BAQD_TENTOA_ST,D.BAQD_TOAANID_PT,D.BAQD_SO_ST,D.BAQD_NGAYBA_ST,D.BAQD_TOAANID_ST
                    ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CD_TA_LYDO_KHAC
            from GDTTT_DON d
             
             ----
             LEFT JOIN (SELECT ID,TEN,MA_TEN FROM DM_TOAAN) TAG ON TAG.ID = D.BAQD_TOAANID
            LEFT JOIN (SELECT ID,TEN,MA_TEN FROM DM_TOAAN) TAP ON TAP.ID = D.BAQD_TOAANID_PT
            LEFT JOIN (SELECT ID,TEN,MA_TEN FROM DM_TOAAN) TAS ON TAS.ID = D.BAQD_TOAANID_ST
             left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
             -----
             LEFT JOIN (
                     SELECT CN.GDTTT_DON_ID,VT.NGUON_DEN,VT.MABD,VT.NGAY_BT from VT_CHUYEN_NHAN  CN 
                                    inner join (select * from VT_VANBANDEN) VT on  CN.VANBANDEN_ID = VT.ID
                        ) VTD on D.ID = VTD.GDTTT_DON_ID
             -----------
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID  --lanhnt
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                 and (vIsThuLy = -1 
                        OR (vIsThuLy=1 and ((vToaAnID = 1 and d.ISTHULY=1 and d.LOAIDON != 4 ) 
                                             OR (vToaAnID != 1 and d.ISTHULY=1) )  ) 
                        OR (vIsThuLy = 2 and d.ISTHULY=2) 
                        OR (vIsThuLy = 3 and d.ISTHULY=1 and d.ARR_DON_ID>0)
                        OR (vIsThuLy = 4 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)
                        OR (vIsThuLy = 5 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)
                        OR (vIsThuLy = 6 and (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4))
                      )
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
                and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                                                                    (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                                    Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                                    Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                        (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
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

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                   when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                     OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                     OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=D.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
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
                ORDER BY d.NGAYTAO desc
        )
        LOOP
          --v_dem:=v_dem+1; lanhnt
           --------- lanhnt
            
            SELECT COUNT(*) INTO retVal FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=item.ID;
          IF (retVal > 0) THEN 
                   SELECT YC.NGUOIKY,YC.SOTHONGBAO,YC.NGAYTHONGBAO INTO VV_NGUOIKY,V_CD_SOTB,V_CD_NGAYCV FROM GDTTT_DON_YEUCAU_BOSUNG YC WHERE YC.DONID=item.ID AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = item.ID);
                  
                   IF(LENGTH(V_CD_SOTB)=1)THEN
                      V_CD_SOTB:='0'||V_CD_SOTB;
                   END IF;
           ELSE
              v_dem:=v_dem+1;
              IF(V_BC_SoCV IS NOT NULL) THEN
                   V_CD_SOTB:=to_char(V_BC_SoCV+v_dem-1);
                 ELSE
                  V_CD_SOTB:=v_dem;
                 END IF;
                 IF(LENGTH(V_CD_SOTB)=1)THEN
                    V_CD_SOTB:='0'||V_CD_SOTB;
                 END IF;                 
              IF(V_BC_NGAYDK IS NOT NULL) THEN
                 V_CD_NGAYCV:=to_date(V_BC_NGAYDK,'dd/MM/yyyy');
              ELSE 
                 V_CD_NGAYCV:=SYSDATE;
              END IF;
              SELECT TK.USERNAME INTO VV_NGUOITAO FROM QT_NGUOISUDUNG TK WHERE TK.ID = v_ID_USER;
                insert into GDTTT_DON_YEUCAU_BOSUNG 
                (id,DONID,LANTHU,NGUOIKY,SOTHONGBAO,NGAYTHONGBAO,CD_TA_LYDO_ISBAQD,CD_TA_LYDO_ISXACNHAN,CD_TA_LYDO_ISKHAC,NOIDUNG,KETQUA,ngaytao,NGUOITAO)
                values (GDTTT_DON_YEUCAU_BOSUNG_SEQ.nextval,item.ID,1,V_BC_Nguoiky,V_BC_SoCV,V_CD_NGAYCV,item.CD_TA_LYDO_ISBAQD,item.CD_TA_LYDO_ISXACNHAN,item.CD_TA_LYDO_ISKHAC,item.CD_TA_LYDO_KHAC,0, sysdate,VV_NGUOITAO);           
           END IF;
           
              
             -------
             IF(item.DUNGDONLA=1)then
               if(item.NGUOIGUI_GIOITINH=1)then
                  V_GIOITINH:='ông';
                  V_GIOITINHHOA:='Ông';
                else
                   V_GIOITINH:='bà';
                  V_GIOITINHHOA:='bà';
               end if;
              elsif(item.DUNGDONLA=2)then 
               V_GIOITINH:='Các ông, bà';
             end if;
             -------
              V_DIACHICOQUAN:=item.CVDIACHI;
              ---
               
                if (item.LOAIDON in (7)) then
                    v_Loaidon := 'thông báo';
                 elsif (item.LOAIDON in (6,9)) then
                    v_Loaidon := 'văn bản kiến nghị';
                 else 
                    v_Loaidon := 'đơn đề nghị';
                 end if;
                 ---
                  -- (theo công văn số '||item.SOCV||' ngày '||item.NGAYCV||'của'||item.TENCOQUAN||')
            V_NOIDUNG:='';
             if (item.LOAIDON in (3,9)) then
                if(item.CV_SO is not null)then
                    V_NOIDUNG:=V_NOIDUNG ||' (theo công văn số '||item.CV_SO;
                     if(item.CV_NGAY is not null)then                  
                        V_NOIDUNG:=V_NOIDUNG ||' ngày '||TO_char(item.CV_NGAY,'dd/MM/yyyy');
                    end if;
                    if(item.CV_TENDONVI is not null) then
                     V_NOIDUNG:=V_NOIDUNG||' của '||item.CV_TENDONVI;
                    end if;
                  
                    V_NOIDUNG:=V_NOIDUNG||')';
                end if;
             end if;
                 ----
                  if (item.NGUON_DEN = 1) then
                        v_NguonDen := 'do tổ chức dịch vụ bưu chính chuyển đến';
                  else
                        v_NguonDen := 'nộp trực tiếp';
                  end if;
                  
              --
               if (item.BAQD_CAPXETXU = 3) then
                    v_CAPXX := 'phúc thẩm';
                 elsif (item.BAQD_CAPXETXU = 2) then
                    v_CAPXX := 'sơ thẩm';
                 else 
                    v_CAPXX := '';
                 end if;
             ---
             --
              if (item.BAQD_LOAIAN = 1)then
                v_LOAIAN_TEXT := 'HS';
              elsif (item.BAQD_LOAIAN = 2)then
                v_LOAIAN_TEXT := 'DS';
              elsif (item.BAQD_LOAIAN = 3)then
                v_LOAIAN_TEXT := 'HNGD';
              elsif (item.BAQD_LOAIAN = 4)then
                v_LOAIAN_TEXT := 'KDTM';
              elsif (item.BAQD_LOAIAN = 5)then
                v_LOAIAN_TEXT := 'LD';
              elsif (item.BAQD_LOAIAN = 6)then
                v_LOAIAN_TEXT := 'HC';
              elsif (item.BAQD_LOAIAN = 7)then
                v_LOAIAN_TEXT := 'PS';
              end if;
              ---
              if (item.LOAI_GDTTTT = '1')then
                    v_loai_gdt:= 'giám đốc thẩm';
              elsif (item.LOAI_GDTTTT = '2')then
                    v_loai_gdt:= 'tái thẩm';
              else
                    v_loai_gdt:= '';
              end if;
              --
                if (item.CD_TA_LYDO_ISBAQD = 1) then
                  v_TailieuBS := '<p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i>- Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.</i></p>';
                  --v_TailieuBS := '<p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i>Bản án '||item.BAQD_LOAIAN_NAME||' '|| v_loai_gdt ||' số '||V_BASO||' ngày '||V_NGAYBA||' của '||V_TOAXX||'.</i></p>';
                end if;
                if (item.CD_TA_LYDO_ISXACNHAN = 1) then
                  v_TailieuBS := v_TailieuBS||'<p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i>- Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.</i></p>';
                end if;
                if (item.CD_TA_LYDO_ISKHAC = 1) then
                  v_TailieuBS := v_TailieuBS||'<p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">............</span><i>- '||item.CD_TA_LYDO_KHAC||'.</i></p>';
                end if;
            ----
              if (item.BAQD_LOAIQDBA = 0)then
                    v_loaiBAQD:= 'Bản án';
              else
                    v_loaiBAQD:= 'Quyết định';
              end if;
              ---
                v_table.extend;
                v_table(v_table.count) := R_NOIBO_YCBS(
                 v_Loaidon,v_NguonDen,to_char(item.NGAYGHITRENDON,'dd/MM/yyyy'), item.DONGKHIEUNAI,V_GIOITINHHOA,item.Diachigui,to_char(item.NGAYNHANDON,'dd/MM/yyyy'),
                 V_NOIDUNG,v_TailieuBS,item.CV_TENDONVI,V_DIACHICOQUAN,v_LOAIAN_TEXT,item.BAQD_LOAIAN_NAME,
                 v_loai_gdt,v_loaiBAQD,v_CAPXX,item.BAQD_SO, TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy'),item.BAQD_TOAAN_NAME,V_CD_SOTB,V_CD_NGAYCV,VV_NGUOIKY);
        END LOOP;  --Truy vấn tạo dữ liệu báo cáo-------
       ---------------
     

    IF(vToaAnID = 4) THEN
            v_TENDONVICC := 'tại Hà Nội';
        ELSIF (vToaAnID = 5) THEN
            v_TENDONVICC := 'tại Đà Nẵng';
        ELSIF (vToaAnID = 6) THEN
            v_TENDONVICC := 'tại Thành phố Hồ Chí Minh';
        END IF;
        -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,regexp_replace(HC.TEN,'thành phố|Thành phố ','') INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=vToaAnID;

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
     
      -----------<th style="width: 60px; text-align: right;">'||V_TENDONVI||'</th>
      v_dem:=0;
      FOR item in (
         SELECT COUNT(*) OVER () as CountAll,PA.*  FROM TABLE(V_TABLE)PA
      )
      LOOP
      v_dem:=v_dem+1;
      
            ------------------
            v_FileName := 'THONG_BAO_YCBS ' ||INITCAP(item.GIOITINH)||' '|| REPLACE(item.NGUOIGUI,',','_');
       ---------
          IF (item.CD_NGAYCV IS NOT NULL) THEN
                 V_NGAY:=to_char(to_date(item.CD_NGAYCV,'dd/MM/yyyy'),'dd');
                 V_THANG:=to_char(to_date(item.CD_NGAYCV,'dd/MM/yyyy'),'MM');
                V_NAM:=to_char(to_date(item.CD_NGAYCV,'dd/MM/yyyy'),'yyyy'); 
          ELSIF(V_BC_NGAYDK IS NOT NULL) THEN
                V_CD_NGAYCV:=to_date(V_BC_NGAYDK,'dd/MM/yyyy');
                 V_NGAY:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'dd');
                 V_THANG:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'MM');
                V_NAM:=to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'yyyy');       
           END IF;
           -----------
           IF(item.NGUOIKY IS NOT NULL) THEN
               V_CD_NGUOIKY:=item.NGUOIKY;
           END IF;
    
            IF(LENGTH(item.CD_SOTB)=1)THEN
                V_CD_SOTB:='0'||V_CD_SOTB;
            ELSE
                V_CD_SOTB := item.CD_SOTB;
            END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                    <th style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">TÒA ÁN NHÂN DÂN CẤP CAO</th>
                    <th style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr>
                    <td style="text-align: center; vertical-align: top; height: 25px; font-size: 12pt">
                        <table cellpadding="0" cellspacing="0">');
                        IF(vToaAnID = 4 or vToaAnID = 5) THEN
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <td style="text-align: right; padding-right: 2px; color: #ffffff;"><span>------</span></td>
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(v_TENDONVICC)||'</span>
                                    </th>
                                <td style="text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                            </tr>');
                                ELSIF (vToaAnID = 6) THEN
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                    <th style="border-bottom: 1px solid #000000;">
                                        <span>'||Upper(v_TENDONVICC)||'</span>
                                    </th>');
                                END IF;

                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        </table>

                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 12.5pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
            <tr style="text-align: center;">');
                if(vToaAnID = 4) THEN -- CẤP CAO HÀ NỘI
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="font-size: 13pt">Số: '||V_CD_SOTB|| '/'||to_char(V_CD_NGAYCV,'yyyy')||'/TB-TA</td>');
                ELSIF (vToaAnID = 6) THEN -- CẤP CAO HỒ CHÍ MINH
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="font-size: 13pt">Số: '||V_CD_SOTB|| '/TB-'||item.LOAIAN||'-'||V_DONVI_CV||'</td>');
                else --CÁC TÒA CÒN LẠI
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="font-size: 13pt">Số: '||V_CD_SOTB||'/GXN-'||item.LOAIAN||'-'||V_DONVI_CV||'</td>');
                    end if;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                
                <td style="vertical-align: top;">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="font-size: 13pt"></td>');

                            if(vToaAnID = 4 or vToaAnID = 5) THEN
                                if(V_CD_NGAYCV is not null) then
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                                    ');
                                  else
                                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">'||V_TENDONVI_HC||', ngày <span style="color: #ffffff;">.....</span> tháng <span style="color: #ffffff;">.....</span> năm <span style="color: #ffffff;">...</span></td>
                                    ');
                                end if;
                            else
                                if(V_CD_NGAYCV is not null) then
                                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">Tp.'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                                    ');
                                  else
                                   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                                    <td style="font-size: 13pt; font-style: italic">Tp.'||V_TENDONVI_HC||', ngày <span style="color: #ffffff;">.....</span> tháng <span style="color: #ffffff;">.....</span> năm <span style="color: #ffffff;">...</span></td>
                                    ');
                                 end if;
                             end if;
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
            <tr>
                <th style="width: 1250px" colspan="2">THÔNG BÁO</th>
            </tr>
            <tr>
                <th style="width: 1250px" colspan="2">YÊU CẦU SỬA ĐỔI, BỔ SUNG</th>
            </tr>
            <tr>');
            
            IF(vToaAnID = 6) THEN -- CẤP CAO HCM
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<th style="width: 1250px" colspan="2">'||UPPER(item.LOAIDON)||' '||UPPER(item.LOAIGDTT)||'</th>');
                ELSE
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<th style="width: 1250px" colspan="2">'||UPPER(item.LOAIDON)||' '||UPPER(item.LOAIGDTT)||'</th>');
            END IF;
                
                
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'  
            </tr>
            <tr style="height: 20px;">
                <td style="width: 500px"></td>
                <td style="width: 750px"></td>
            </tr>
        </table>
        <table>
            <tr><td style="font-size: 14pt; text-align: right;width: 190px">
                <span style="color:white;">.......................</span>Kính gửi:</td>
                <td  style="font-size: 14pt; text-align: left;"> '||INITCAP(item.GIOITINH)||' '|| item.NGUOIGUI||'</span></td>
            </tr>');
DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                    <td style="font-size: 14pt;margin-top:5px;text-align: left; margin-left:18px; vertical-align: top; width: 190px">
                                    <span style="color:white;">.....................</span>Địa chỉ:
                    </td>
                   <td  style="font-size: 14pt;margin-top:5px; text-align: left;"> '|| item.DIACHI||'</td> 
            </tr>
        </table>
             ');    
        
         if (item.LOAIDON = 'đơn đề nghị')then
            v_loaidon_dn := 'đề nghị';
         elsif (item.LOAIDON = 'văn bản kiến nghị')then
            v_loaidon_dn := 'kiến nghị';
         elsif (item.LOAIDON = 'văn bản thông báo')then
            v_loaidon_dn := 'thông báo';
         end if;


        if(vToaAnID = 4 OR vToaAnID = 5 OR vToaAnID = 6) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'            
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                Căn cứ ');
               if (item.LOAIGDTT = 'tái thẩm') then
                    if (lower(item.TENLOAIAN) = 'hành chính') then
                        if(vToaAnID = 4) then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'Điều 280 và Điều 282 Luật Tố tụng hành chính');
                        else
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'Điều 258 và Điều 282 Luật Tố tụng hành chính');
                        end if;
                    elsif (lower(item.TENLOAIAN) = 'hình sự') then
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'quy định của Bộ luật Tố tụng hình sự');
                    else
                        --DBMS_LOB.APPEND(V_EXPORT_TEXT,'khoản 2 Điều 329 và Điều 357 Bộ luật Tố tụng dân sự');
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'Điều 351 và Điều 357 Bộ luật Tố tụng dân sự');
                    end if;
               else
                    if (lower(item.TENLOAIAN) = 'hành chính') then
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'khoản 2 Điều 258 Luật Tố tụng hành chính');
                    elsif (lower(item.TENLOAIAN) = 'hình sự') then
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'quy định của Bộ luật Tố tụng hình sự');
                    else
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'khoản 2 Điều 329 Bộ luật Tố tụng dân sự');
                    end if;
               end if;
               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' về thủ tục nhận đơn đề nghị xem xét bản án, quyết định của Tòa án đã có hiệu lực
                pháp luật theo thủ tục '||item.LOAIGDTT||';</p>

                <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                Xét đơn '||v_loaidon_dn||' '||item.LOAIGDTT||' của '|| LOWER(item.GIOITINH) ||' '||item.NGUOIGUI||' đề ngày '||item.NGAYTRENDON||' về việc '||v_loaidon_dn||' Chánh án Tòa án nhân dân cấp cao '|| v_TENDONVICC ||'
                xem xét theo thủ tục '||item.LOAIGDTT||' đối với '|| item.LOAIBAQD||' 
                '||lower(item.TENLOAIAN)||' '||item.CAPXX||' số '||item.BA_SO||' ngày '||item.BA_NGAY||' của '|| item.BA_TOAXX||'.</p>

                <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                Tòa án nhân dân cấp cao '||v_TENDONVICC||' yêu cầu '||lower(item.GIOITINH)||' '||item.NGUOIGUI||' bổ sung nội dung sau đây trong thời hạn 30 ngày, 
                kể từ ngày nhận được thông báo này:</p>'||item.TAILIEU ||
                
                '<p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                Trường hợp người '||v_loaidon_dn||' không sửa đổi, bổ sung đơn '||v_loaidon_dn||' và gửi lại cho Tòa án trong thời hạn trên thì Tòa án
                trả lại đơn đề nghị, tài liệu chứng cứ kèm theo cho người đề nghị./.</p>

                <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                <i>Lưu ý: Khi nộp bổ sung các nội dung trên cần gửi kèm theo bản photo Thông báo này.</i></p>
            ');
            
        else
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <p style="font-size: 14pt; text-align: justify;margin-top:17pt;margin-bottom:6pt"><span style="color:white;">.....</span>
                Tòa án nhân dân cấp cao '||v_TENDONVICC||' nhận được '||item.LOAIDON||' của '||
                item.GIOITINH||' '||item.NGUOIGUI||' đề ngày '||item.NGAYTRENDON||' về việc '||v_loaidon_dn ||' Chánh án Tòa án nhân dân cấp cao '||v_TENDONVICC||' xem xét theo thủ tục '||item.LOAIGDTT||' đối với '|| item.LOAIBAQD||' '||
               item.TENLOAIAN||' '||item.CAPXX||' số '||item.BA_SO||' ngày '||item.BA_NGAY||' của '|| item.BA_TOAXX||'.</p>
               '); 
              
              DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:6pt"><span style="color:white;">.....</span>
              Tòa án nhân dân cấp cao '||v_TENDONVICC||' yêu cầu '|| LOWER(item.GIOITINH) ||' '||item.NGUOIGUI||' bổ sung tài liệu sau đây trong thời hạn 01 tháng, 
              kể từ ngày nhận được Thông báo này:</p>'||item.TAILIEU);
              
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">.....</span>
              Yêu cầu '||item.GIOITINH||' '||item.NGUOIGUI||' gửi tài liệu bổ sung nêu trên (kèm theo Thông báo này) đến Tòa án nhân dân cấp cao 
              '||v_TENDONVICC||', địa chỉ: ');
              if (vToaAnID = 6) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'Số 8 đường 57, khu phố 3, phường Cái Lái, thành phố Thủ Đức, Thành phố '||V_TENDONVI_HC||'.</p>');
              elsif (vToaAnID = 5) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'372 Núi Thành, Hoà Cường Bắc, Hải Châu, Thành phố '||V_TENDONVI_HC||'.</p>');
              elsif (vToaAnID = 4) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'Số 1 đường Phạm Văn Bạch, phường Yên Hòa, quận Cầu Giấy, Thành phố '||V_TENDONVI_HC||'.</p>');
              end if;
              if(item.LOAIAN = '1') then
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                  <p style="font-size: 14pt; text-align: justify;margin-top:6pt;margin-bottom:16pt"><span style="color:white;">.....</span>
                  Trường hợp '||item.GIOITINH||' '||item.NGUOIGUI||' không bổ sung tài liệu và gửi cho Tòa án nhân dân cấp cao 
              '||v_TENDONVICC||' trong thời hạn trên thì Tòa án nhân dân cấp cao '||v_TENDONVICC||' sẽ trả lại đơn đề nghị và tài liệu chứng cứ kèm theo cho '||item.GIOITINH||' '||item.NGUOIGUI||'</p>');
            end if;
        end if;

          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    ');
                    if(vToaAnID = 4 OR vToaAnID = 5 OR vToaAnID = 6) THEN
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <td style="vertical-align: top;">
                            <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                                <i><b>Nơi nhận:</b></i><br/>
                                - Như kính gửi;<br />
                                - Chánh án TANDCC (để báo cáo);<br />
                                - Lưu: VT, HCTP.('||v_BIDANH||').<br />
                            </p>
                        </td>                            
                        ');
                    else
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'                    
                        <td style="vertical-align: top;">
                            <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                                <i><b>Nơi nhận:</b></i><br/>
                                - Như trên;<br />
                                - Lưu: Lưu HCTP ('||v_BIDANH||').<br />
                            </p>
                        </td>
                        ');
                        end if;
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td>
                         <p style="font-size:13pt;">
                              <strong>
                                TL. CHÁNH ÁN<br />
                                KT. CHÁNH VĂN PHÒNG<br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                         <p style="font-size:13pt;margin-top:10pt;"><strong>'||item.NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
            IF(v_dem<item.CountAll) THEN
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <span style="font-size:12.0pt;font-family:''Times New Roman'',serif;mso-fareast-font-family:
                ''Times New Roman'';mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                mso-fareast-language:EN-US;mso-bidi-language:AR-SA">
                <br clear=all style="mso-special-character:line-break;page-break-before:always">
                </span>
                ');
            END IF;
        END LOOP;
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT,v_FileName FileName FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_SEARCH_THONG_BAO_YCBSCC;


END PKG_GDTTT_HCTP_BC;

/
