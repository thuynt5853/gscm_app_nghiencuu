--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_TP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_TP" AS
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
              where VA.TOAANID=v_toaanid  and va.TRUONGHOPTHULY in(0,1,2,3)
              and (vCapXetXu=0  
                    OR(vCapXetXu=2 AND VA.TOAANSOTHAM=vToaXetXu AND to_char(VA.NGAYXUSOTHAM,'dd/MM/yyyy')=vNgayBAQD  AND UPPER(VA.SOANSOTHAM) LIKE UPPER(vSoBAQD))
                    OR(vCapXetXu=3 AND VA.TOAPHUCTHAMID=vToaXetXu  AND to_char(VA.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD AND UPPER(VA.SOANPHUCTHAM)LIKE UPPER(vSoBAQD) )
                    OR(vCapXetXu=4 AND VA.TOAQDID=vToaXetXu AND to_char(VA.NGAYQD,'dd/MM/yyyy')=vNgayBAQD AND UPPER(VA.SO_QDGDT) LIKE UPPER(vSoBAQD) )
                    );

 IF(v_counts>0)THEN   
    OPEN curReturn FOR
      -- select TT.* from (
            SELECT D.ID,d.SOHIEUDON,d.NGAYNHANDON,D.DONGKHIEUNAI,t.MA_TEN TOAXETXU,g.MA_TEN TOAGDTTT 
            ,decode(VA.BAQD_CAPXETXU,2,VA.SOANSOTHAM,3,VA.SOANPHUCTHAM,VA.SO_QDGDT) SOBAQD
            ,decode(VA.BAQD_CAPXETXU,2,VA.NGAYXUSOTHAM,3,VA.NGAYXUPHUCTHAM,VA.NGAYQD)NGAYBAQD
            ,VA.DIACHINGUOIDENGHI Diachigui
            ,va.LOAIAN,DECODE(LA.LOAI_AN_TEN,NULL,NULL,'; Loại án: '||LA.LOAI_AN_TEN)LOAI_AN_TEN
            ,VA.Nguoitao,VA.Ngaytao,VA.ID VUAN_ID
            ,D.ISTHULY,NULL TRANGTHAIXULY,D.CD_TA_TRANGTHAI,to_char(D.TL_NGAY,'dd/MM/yyyy')TL_NGAY,D.TL_SO
            ,null KQGQNoiBo,d.CD_LOAI,D.vuviecid,va.GQD_LOAIKETQUA,D.LOAIDON,va.GDQ_SO,va.GDQ_NGAY
            ,TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX,va.GQD_NgayPhatHanhCV,d.CD_TRANGTHAI
            ,XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT) KQGQ_DANSU_EX
            FROM GDTTT_VUAN VA
            LEFT JOIN GDTTT_DON D ON D.VUVIECID=VA.ID --AND D.ID !=vCurrDonID--AND D.ISTHULY=1
            --Ket qua xx giam doc tham 
            LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID
            --16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID
            LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID
            -- --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID -- 1 đang dùng,0 xóa
            LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID 
            INNER JOIN DM_TOAAN g on g.ID=VA.TOAANID
            LEFT JOIN DM_LOAIAN LA ON VA.LOAIAN=LA.ID
            --LEFT JOIN (SELECT a.ID,a.VUVIECID FROM GDTTT_DON a where  (a.DONTRUNGID IS NULL OR a.DONTRUNGID=0) and a.VUVIECID is not null and a.VUVIECID !=0 )d on d.VUVIECID=VA.ID
            LEFT JOIN DM_TOAAN t on t.ID= decode(VA.BAQD_CAPXETXU,2,VA.TOAANSOTHAM,3,VA.TOAPHUCTHAMID,VA.TOAQDID)
            where  VA.TOAANID=v_toaanid and d.arr_don_id=0 --không lấy đơn trùng
            and va.TRUONGHOPTHULY in(0,1,2,3)
             and (vCapXetXu=0  
                        OR (vCapXetXu=2 AND VA.TOAANSOTHAM=vToaXetXu AND to_char(VA.NGAYXUSOTHAM,'dd/MM/yyyy')=vNgayBAQD  AND UPPER(VA.SOANSOTHAM) LIKE UPPER(vSoBAQD) )
                        OR(vCapXetXu=3 AND VA.TOAPHUCTHAMID=vToaXetXu  AND to_char(VA.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD AND UPPER(VA.SOANPHUCTHAM)LIKE UPPER(vSoBAQD) )
                        OR(vCapXetXu=4 AND VA.TOAQDID=vToaXetXu AND to_char(VA.NGAYQD,'dd/MM/yyyy')=vNgayBAQD AND UPPER(VA.SO_QDGDT) LIKE UPPER(vSoBAQD) )
                    )
            Order by D.Ngaytao desc        
             ;
       -- union all
       else
        OPEN curReturn FOR
            select D.ID,D.SOHIEUDON,D.NGAYNHANDON,D.DONGKHIEUNAI,t.MA_TEN TOAXETXU,g.MA_TEN TOAGDTTT
           ,decode(vIsBanAn,1,D.KN_SOQD,decode(D.BAQD_CAPXETXU,2,D.BAQD_SO_ST,3,D.BAQD_SO_PT,D.BAQD_SO_ST)) SOBAQD
            ,decode(vIsBanAn,1,D.KN_NGAY,decode(D.BAQD_CAPXETXU,2,D.BAQD_NGAYBA_ST,3,D.BAQD_NGAYBA_PT,D.BAQD_NGAYBA))NGAYBAQD
            ,D.NGUOIGUI_DIACHI ||(case when (D.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui
            ,D.BAQD_LOAIAN LOAIAN,DECODE(la.LOAI_AN_TEN,NULL,NULL,'; Loại án: '||la.LOAI_AN_TEN)LOAI_AN_TEN
            ,D.Nguoitao,D.Ngaytao,NULL VUAN_ID
            ,D.ISTHULY,NULL TRANGTHAIXULY,D.CD_TA_TRANGTHAI,to_char(D.TL_NGAY,'dd/MM/yyyy')TL_NGAY,D.TL_SO
            ,null KQGQNoiBo,D.CD_LOAI,D.vuviecid,va.GQD_LOAIKETQUA,D.LOAIDON,va.GDQ_SO,va.GDQ_NGAY
            ,TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX,va.GQD_NgayPhatHanhCV,d.CD_TRANGTHAI
            ,XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT) KQGQ_DANSU_EX
            from GDTTT_DON D
            left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = D.VuViecID 
            inner join DM_TOAAN g on g.ID=D.TOAANID
            left join DM_TOAAN t on t.ID= decode(D.BAQD_CAPXETXU,2,D.BAQD_TOAANID_ST,3,D.BAQD_TOAANID_PT,D.BAQD_TOAANID)
            left join DM_HANHCHINH h on D.NGUOIGUI_HUYENID=h.ID
            LEFT JOIN DM_LOAIAN LA ON D.BAQD_LOAIAN=D.ID
            --Ket qua xx giam doc tham 
            LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID
            --16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID
            LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID
            -- --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID -- 1 đang dùng,0 xóa
            LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID 
            LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID 
            where   D.TOAANID=v_toaanid AND D.LOAIDON=V_LOAIDON AND NVL(D.CD_TA_TRANGTHAI,0) IN (0,1)
            AND D.ID!=vCurrDonID and d.arr_don_id=0 --không lấy đơn trùng
            --and (vCurrDonID=0 OR (D.ID=vCurrDonID AND NVL(D.DONTRUNGID,0)!=0) )
            AND (vNguoiGui IS NULL OR (lower(D.NGUOIGUI_HOTEN)=lower(vNguoiGui) AND vNguoiGui IS NOT NULL ))  
            AND D.BAQD_LOAIQDBA=vIsBanAn 
            AND  (vCapXetXu=0 
                    OR (vCapXetXu=2 AND D.BAQD_TOAANID_ST=vToaXetXu AND to_char(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD AND UPPER(D.BAQD_SO_ST) LIKE UPPER(vSoBAQD) )
                    OR(vCapXetXu=3 AND D.BAQD_TOAANID_PT=vToaXetXu  AND to_char(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD AND UPPER(D.BAQD_SO_PT)LIKE UPPER(vSoBAQD) )
                    OR(vCapXetXu=4 AND D.BAQD_TOAANID=vToaXetXu AND to_char(D.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD AND UPPER(D.BAQD_SO) LIKE UPPER(vSoBAQD) )
                  )
          Order by D.Ngaytao desc
          ;
     end if;     
    --   )TT ;
      -- Order by tt.Ngaytao desc;
    --END IF;  
END DON_GETDONTRUNG;
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
           when 4 then  'Bị trả lại chỉ sửa'
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
      ,d.CD_TRANGTHAI 
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
       left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
       left join DM_CANBO c on d.THAMPHANID=c.ID
       left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
       left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
       left join DM_CANBO ld on d.CHIDAO_LANHDAOID=ld.ID
      where DECODE(d.ARR_DON_ID,0,d.ID,d.ARR_DON_ID)=varrID --and d.cd_ta_trangthai=2--varrID like ('%,' || cast(d.ID as varchar2(10)) || ',%')
    Order by d.Ngaytao desc;    
END DANHSACHDONTHEOID;
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,
      Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
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
           when 4 then  'Bị trả lại chỉ sửa'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG
     ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || replace(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','')) else '' End) arrCongvan
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
    where
     d.CD_TA_TRANGTHAI=2 and d.ID != vID
     and (d.ARR_DON_ID=vID)and vID!=0 
     --(d.CD_TA_TRANGTHAI=3) and vID!=0 
--      and ( (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.ARR_DON_ID=vID)>0)Or (d.ARR_DON_ID=vID Or  d.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID and ARR_DON_ID>0)
--      Or  d.ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID  and ARR_DON_ID>0))
--      )
    Order by d.Ngaytao desc;    
END DANHSACHDONTRUNG;
PROCEDURE DANHSACHDON_TLL
( 
    vID in number,
	curReturn OUT sys_refcursor
)
IS 
   V_ARR_DON_ID NUMBER;V_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_COUNT FROM GDTTT_DON a WHERE A.ID=vID;
    IF(V_COUNT>0)THEN
    SELECT ARR_DON_ID INTO V_ARR_DON_ID FROM GDTTT_DON a WHERE A.ID=vID;
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
              when 4 then  'Bị trả lại chỉ sửa'
             else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
          ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
          ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG
         ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || replace(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','')) else '' End) arrCongvan
           ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
          ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
          ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
          ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
          ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
          ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
          ,d.CD_TRANGTHAI
        from GDTTT_DON d
          left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
           left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
           left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
            left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
            left join DM_CANBO c on d.THAMPHANID=c.ID
            left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
            left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
        where d.ID=V_ARR_DON_ID AND D.isthuly=1 and V_ARR_DON_ID!=0
    --(d.CD_TA_TRANGTHAI=3) and vID!=0 
    --      and ( (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.ARR_DON_ID=vID)>0)Or (d.ARR_DON_ID=vID Or  d.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID and ARR_DON_ID>0)
    --      Or  d.ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID  and ARR_DON_ID>0))
    --      )
        Order by d.Ngaytao desc;    
      END IF;  
END DANHSACHDON_TLL;
PROCEDURE DANHSACHDON_KEMTHE0
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN--(CV_ISTRONGNGANH=1 then d.CV_TOAANID,CV_ISTRONGNGANH=0 then d.CV_TENDONVI đơn vị gửi ngoài ngành,)
  OPEN curReturn FOR
   Select  ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) TT,d.ID,replace(to_char(d.NGAYGHITRENDON,'dd/MM/yyyy'),'01/01/0001','') NGAYGHIDON,NVL(d.CV_ISTRONGNGANH,0) LOAIDONVI,d.CD_TA_TRANGTHAI,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN
   ,replace(to_char(d.NGAYNHANDON,'dd/MM/yyyy'),'01/01/0001','')NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CV_TOAANID
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,replace(to_char(d.NGAYGHITRENDON,'dd/MM/yyyy'),'01/01/0001','')NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,d.CV_SO,replace(to_char(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','')CV_NGAY,d.CV_TENDONVI
      ,DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
      ,DECODE((SELECT COUNT(*) FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON and ld.LOAIDON_ID IN(31,3,10,2,6,9)),0,0,1) HINHTHUCDON
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
          when 4 then  'Bị trả lại chỉ sửa'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || replace(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001','')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
      ,decode(CV_NGUOIKY,null, '',CV_NGUOIKY) CV_NGUOIKY ,decode(CV_CHUCVU,null, '',CV_CHUCVU) CV_CHUCVU
      ,d.CD_TRANGTHAI
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    where d.CD_TA_TRANGTHAI=3 and vID!=0
    and ( (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.ARR_DON_ID=vID)>0)Or (d.ARR_DON_ID=vID Or  d.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID and ARR_DON_ID>0)
      Or  d.ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID  and ARR_DON_ID>0))
      )
--    (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.DONTRUNGID=vID)>0)Or (d.DONTRUNGID=vID Or  d.DONTRUNGID in (Select DONTRUNGID from GDTTT_DON where ID=vID and DONTRUNGID>0)
--    Or  d.ID in (Select DONTRUNGID from GDTTT_DON where ID=vID  and DONTRUNGID>0))
    Order by d.Ngaytao desc;    
END DANHSACHDON_KEMTHE0;
PROCEDURE SET_THAMPHAN_THULYLAI
(
     V_DONTRUNGID IN VARCHAR2,
     V_DON_ID  IN VARCHAR2,
     V_CD_TA_TRANGTHAI IN VARCHAR2, --1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện,2 chuyển từ chưa đủ đk sang đủ đk
     V_ISTHULY IN VARCHAR2--1 Thụ lý mới,2 Đã thụ lý
)
IS 
        V_COUNT NUMBER;VV_CD_TA_TRANGTHAI VARCHAR2(100);VV_ISTHULY VARCHAR2(100);V_CD_TRANGTHAI NUMBER;V_THAMPHANID VARCHAR2(100);
BEGIN
       SELECT ISTHULY,THAMPHANID INTO VV_ISTHULY,V_THAMPHANID FROM GDTTT_DON WHERE  ID=V_DONTRUNGID;
         if(VV_ISTHULY='1')THEN  --dontrung hien tai la thu ly moi
           if(V_ISTHULY='1')THEN --don vua luu la thu ly moi
                   IF(V_THAMPHANID IS NOT NULL) THEN
                          UPDATE GDTTT_DON
                          SET THAMPHANID=V_THAMPHANID
                          WHERE ID=V_DON_ID;
                   END IF;
           END IF;
        END IF;  
END SET_THAMPHAN_THULYLAI;  
PROCEDURE GET_KETQUA_GQ
(
     V_DONTRUNGID IN VARCHAR2,  
     V_GQD_LOAIKETQUA OUT VARCHAR2
)
IS 
        v_vuviecid VARCHAR2(100);v_count number;V_LOAIAN number;
BEGIN
     V_GQD_LOAIKETQUA:='0';
     SELECT count(*) INTO v_count FROM GDTTT_DON WHERE ID=V_DONTRUNGID AND NVL(vuviecid,0)>0 AND cd_loai= 0; ---cd_loai:0 nội bộ
     if(v_count>0)then
            SELECT BAQD_LOAIAN INTO V_LOAIAN FROM GDTTT_DON WHERE ID=V_DONTRUNGID;
            SELECT vuviecid INTO v_vuviecid  FROM GDTTT_DON WHERE ID=V_DONTRUNGID AND NVL(vuviecid,0)>0 AND cd_loai= 0; 
            IF(v_vuviecid>0)THEN
                BEGIN
                    IF V_LOAIAN=1 THEN--hinh su
                      SELECT COUNT(*) INTO V_GQD_LOAIKETQUA FROM GDTTT_DON_TRALOI WHERE DONID=V_DONTRUNGID;
                      ELSE--dan su mo rong
                      SELECT COUNT(*) INTO V_GQD_LOAIKETQUA FROM GDTTT_VUAN_KETQUA_DON WHERE DONID=V_DONTRUNGID AND TRANGTHAI=1; 
                      END IF;
                EXCEPTION
                      WHEN no_data_found THEN
                      NULL;
                END;
            END IF;   
     end if;       
END GET_KETQUA_GQ;  
PROCEDURE ARR_DONTRUNGID_UP
(
     V_CD_LOAI IN VARCHAR2,--0 Nội bộ,1 Tòa khác,2 Ngoài tòa án, 3 Trả lại đơn,4 Xếp đơn 
     V_DONTRUNGID IN VARCHAR2,--được hiểu là đơn được chọn hiện tại 
     V_DON_ID  IN VARCHAR2,--được hiểu là đơn hiện tại chuẩn bị lưu
     V_CD_TA_TRANGTHAI IN VARCHAR2, --1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện,2 chuyển từ chưa đủ đk sang đủ đk, 3 đơn kèm theo
     V_ISTHULY IN VARCHAR2--1 Thụ lý mới,1 Thụ lý lại,2 Đã thụ lý
)
IS 
       VV_CD_TA_TRANGTHAI VARCHAR2(100);V_CD_TRANGTHAI NUMBER;VV_DON_ID NUMBER;V_COUNT NUMBER;
       V_GQD_LOAIKETQUA VARCHAR2(255);
BEGIN
   V_GQD_LOAIKETQUA:='0';
   PKG_GDTTT_TP.GET_KETQUA_GQ(V_DONTRUNGID,V_GQD_LOAIKETQUA);
   -------------------
   SELECT NVL(CD_TRANGTHAI,0),NVL(CD_TA_TRANGTHAI,0) INTO V_CD_TRANGTHAI,VV_CD_TA_TRANGTHAI FROM GDTTT_DON WHERE ID=V_DONTRUNGID; --đơn hiện tại
    ---đơn chuyển tòa khác hoặc ngoài tòa là 1 luồng riêng
    if(V_CD_LOAI='1' or V_CD_LOAI='2') THEN
        UPDATE GDTTT_DON
            SET CD_TA_TRANGTHAI=0,ARR_DON_ID=0,CD_LOAI=V_CD_LOAI
            WHERE  (ID=V_DON_ID OR ID=V_DONTRUNGID);
    ELSE
    --đơn kèm theo sẽ là 1 luồng riêng
             if(V_CD_TA_TRANGTHAI=3)then --3 đơn kèm theo
                                    UPDATE GDTTT_DON
                                    SET CD_TA_TRANGTHAI=3,ARR_DON_ID=V_DONTRUNGID --trường họp này V_DONTRUNGID được hiểu là đơn chính 
                                    WHERE  ID=V_DON_ID;--V_DON_ID được hiểu là những đơn kèm theo được thêm vào đơn chính
             ELSE             
               --07/05/2025 IF(V_GQD_LOAIKETQUA=0)THEN-- V_CD_TRANGTHAI=0 AND 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)';
                             IF(VV_CD_TA_TRANGTHAI='1')THEN --đơn hiện tại là chưa đủ điều kiên
                                 IF(V_CD_TA_TRANGTHAI='1')THEN  --1 Đơn chưa đủ điều kiện (là đơn sẽ lưu)
                                        UPDATE GDTTT_DON
                                        SET ARR_DON_ID=V_DON_ID
                                        WHERE  (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID);
                                       -----------không update đơn kèm theo
                                        UPDATE GDTTT_DON
                                        SET CD_TA_TRANGTHAI=2
                                        WHERE  (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID) AND CD_TA_TRANGTHAI!=3;
                                 END IF;
                                if(V_ISTHULY=1 or V_ISTHULY=2) THEN--đơn hiện tại là đơn: 1 Thụ lý mới,2 Đã thụ lý
                                       UPDATE GDTTT_DON
                                        SET ARR_DON_ID=V_DON_ID
                                        WHERE  (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID);
                                        -----------không update đơn kèm theo
                                        UPDATE GDTTT_DON
                                        SET CD_TA_TRANGTHAI=2
                                        WHERE  (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID)AND CD_TA_TRANGTHAI!=3;
                                END IF;
                            ELSIF(VV_CD_TA_TRANGTHAI='0')THEN --đơn hiện tại là đủ điều kiên
                                select COUNT(*) INTO V_COUNT FROM GDTTT_DON WHERE ISTHULY=1 AND (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID);
                                IF(V_COUNT!=0)THEN
                                   select ID INTO VV_DON_ID FROM GDTTT_DON WHERE ISTHULY=1 AND (ARR_DON_ID=V_DONTRUNGID OR ID=V_DONTRUNGID)
                                   ORDER BY ID FETCH FIRST 1 ROWS ONLY;
                                    IF(V_ISTHULY=1) THEN --thụ lý lại và phải có ARR_DON_ID để sau này lấy danh sách những đơn thụ lý lại
                                      UPDATE GDTTT_DON--cần phải update ARR_DON_ID của đơn mới thụ lý đầu tiên vào đơn thụ lý lại đã lưu
                                            SET ARR_DON_ID=VV_DON_ID 
                                            WHERE  ID=V_DON_ID;--đơn thụ lý lại đơn sẽ lưu hay vừa lưu
                                    END IF;
                                END IF;    
                         END IF;     
               -- END IF;
    end if;   
   END IF;--V_CD_LOAI
END ARR_DONTRUNGID_UP; 
PROCEDURE BICAO_DUONGSU_UP
(
     V_DONID IN VARCHAR2, --don goc
     V_DONID_CC IN VARCHAR2,--don tam
     V_USERNAME IN VARCHAR2
)
IS 
    V_VUAN_ID VARCHAR2(100);V_LOAIAN VARCHAR2(100);V_COUNTS NUMBER;
BEGIN
      SELECT VUVIECID,BAQD_LOAIAN INTO V_VUAN_ID,V_LOAIAN FROM GDTTT_DON WHERE ID=V_DONID;
      IF(V_DONID_CC IS NOT NULL) THEN
          IF(V_VUAN_ID IS NOT NULL) THEN  --bị cáo lấy từ vụ án
                IF(V_LOAIAN='1')THEN
                    NULL;--ADD_BICAO_DON
                 ELSE
                     NULL;--ADD_DUONGSU_DON
                END IF;
            ELSE--Bị cáo đương sự lấy từ đơn
               IF(V_LOAIAN='1')THEN
                    --ADD_BICAO_DON_FROM_DON 
                    --tạo dữ liệu từ đơn gốc đổ vào bảng tạm
                    SELECT COUNT(*)into V_COUNTS FROM GDTTT_DON_DUONGSU_CC WHERE DONID=V_DONID;
                    if(V_COUNTS>0)then
                            INSERT INTO GDTTT_DON_DUONGSU_CC
                            (VUANID,DONID,TENDUONGSU,LOAI,TUCACHTOTUNG,GIOITINH,TINHID,HUYENID,DIACHI,NGAYTAO,NGUOITAO,ISINPUTADDRESS,HS_BICANDAUVU,BICAOID,HS_ISBICAO,HS_TOIDANHID,HS_TENTOIDANH,HS_MUCAN,HS_TUCACHTOTUNG,HS_ISKHIEUNAI,HS_LOAIBAKHIEUNAI,HS_NGAYBAKHIEUNAI,HS_NOIDUNGKHIEUNAI,NAMSINH)
                            SELECT 0,V_DONID_CC,TENDUONGSU,LOAI,TUCACHTOTUNG,GIOITINH,TINHID,HUYENID,DIACHI,SYSDATE,V_USERNAME,ISINPUTADDRESS,HS_BICANDAUVU,BICAOID,HS_ISBICAO,HS_TOIDANHID,HS_TENTOIDANH,HS_MUCAN,HS_TUCACHTOTUNG,HS_ISKHIEUNAI,HS_LOAIBAKHIEUNAI,HS_NGAYBAKHIEUNAI,HS_NOIDUNGKHIEUNAI,NAMSINH 
                            FROM GDTTT_DON_DUONGSU_CC WHERE DONID=V_DONID; 
                    end if;
                 ELSE
                     NULL;--ADD_DUONGSU_DON_FROM_DON
                END IF;
          END IF;  
      END IF;
END BICAO_DUONGSU_UP; 
END PKG_GDTTT_TP;

/
