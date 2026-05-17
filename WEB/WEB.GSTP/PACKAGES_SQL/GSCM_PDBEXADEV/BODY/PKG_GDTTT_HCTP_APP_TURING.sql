create or replace NONEDITIONABLE PACKAGE BODY PKG_GDTTT_HCTP_APP_TURING AS
PROCEDURE DON_SEARCHS
( 
    V_NDBD_VALUE VARCHAR2,
    V_NDBD_TEXT VARCHAR2,
    --van thu don den----
    V_DONVI_CHUYEN_ID in  VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    V_LOAI_VB	in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    --van thu don den end----
    v_ID_USER VARCHAR2,
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
    vLOAI_GDTTT in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
IS 
        TotalItem number;MinIndex	number;MaxIndex	number;
        ma_chucvu varchar2(10);curr_thamphan_id number:=0;vvloaian VARCHAR2(150);
        V_CANBOID number;v_phongban number;V_CURSOR sys_refcursor;
        ------------------
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
 ---add 09/09/2020 check dữ liệu theo PCA
 SELECT NSD.CANBOID,NSD.PHONGBANID INTO V_CANBOID,v_phongban FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
  select b.Ma  into ma_chucvu  from DM_CANBO a left join DM_DATAITEM b on a.ChucVuID = b.ID where a.Id = V_CANBOID;
   if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
            --          manh neu can bo dang nhap la PCA hoac CA thi cho phep tim kiem theo Tham phan theo linh vuc minh quan ly 
            if V_CANBOID =  vThamphanID then
                curr_thamphan_id:=0;
            else
                curr_thamphan_id:= vThamphanID;
            end if;
    ELSE
        curr_thamphan_id:= vThamphanID;
    end if;
     -----------Truong hop nay thuong dung cho cấp cao CW và luồng mới của tòa TW-------------
     ---ddlPhanloaiDdon.SelectedValue == "2" là tất cả  isDonGoc = 0;
    IF vIsDonGoc=0 then  
        OPEN curReturn FOR
   select 
         /*GSCM.PKG_GDTTT_HCTP_APP.DON_SEARCH (Danh sach Don HCTP) */ a.*,a.TotalItem CountAll from (--TotalItem as
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID-- Count(d.ID) OVER()TotalItem
       ,d.MADON
       ,d.LOAIDON   
      ,decode(D.LOAIDON,6,'<i>Mã CV</i>:',9,'<i>Mã CV</i>:',5,'<i>Mã VB</i>:','<i>Mã đơn</i>:')||d.MADON MADON_CC
      ,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,decode(to_char(d.NGAYNHANDON,'dd/MM/yyyy'),'01/01/0001',null,d.NGAYNHANDON)NGAYNHANDON,NULL NGAYNHANDONS
      , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  
      ,d.BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap
     ,d.CV_TENDONVI,d.DONGKHIEUNAI DONGKHIEUNAIS,DECODE(d.LOAIDON,9,d.CV_TENDONVI,6,d.CV_TENDONVI,d.DONGKHIEUNAI)DONGKHIEUNAI
     
      ,KS.TEN,decode(D.LOAIDON,1,'<i>Người đứng đơn:</i>',3,'<i>Người đứng đơn:</i>','<i>Người gửi:</i>')
          ||'<b>'||DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,d.DONGKHIEUNAI)||'</b>' DONGKHIEUNAI_CC
      ,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,D.TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL
      ,LAD.LOAIDON_TEN_VT HinhThuc --case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,decode(D.LOAIDON,6,'Ngày công văn',9,'Ngày công văn',5,'Ngày VB',4,'Ngày QĐKN','Ngày trên đơn')LBL_HINHTHUC_CC
      
      ,d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV ,(Case when d.NGUOIGUI_HUYENID=981 then d.NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
      End) DIACHIGUI
      ---------------------
      ,d.CV_SO,d.NGAYGHITRENDON,d.CV_NGAY,d.NGAY_HSKN
       ,DECODE(D.LOAIDON,4,d.NGAY_HSKN,5,d.CV_NGAY,d.NGAYGHITRENDON)NGAYGHITRENDON_CC       
       ,d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO
      --,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO      
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,'BA/QĐ: ')||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,decode(D.LOAIDON,5,null,'<i>Số </i><b>'||(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,'BA: ')||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END ))||'</b>' BAQD_CC
      ,d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      
      ,DECODE(D.LOAIDON,5,NULL,'<i>Ngày: <b>'||to_char((Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END),'dd/MM/yyyy')||'</b></i>') BAQD_NGAYBA_CC
      ,i.TEN TEN_I--, txx.Ma_Ten TOAXX
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
     -- ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT
      ,decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
      ,decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN) ) Infor_PT
      
      ,d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU GHICHU_D,d.GHICHU ||decode (d.CD_TRANGTHAI,3,'<i></br>Lý do trả lại đơn:</i> '||tralai.ghichu,'')  as GHICHU
      
      ,d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,d.CD_LOAI,pb.TENPHONGBAN,tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) 
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
     ----------------
     --,D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN
     ,DECODE(D.TOAANID,1,DECODE(D.ISTHULY,1,'Đơn vị giải quyết',TTC.TRANGTHAICHUYEN),TTC.TRANGTHAICHUYEN) TRANGTHAICHUYEN--ISTHULY 1 Thụ lý mới,2 Đã thụ lý
     ,DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS
     ,DECODE(D.ISTHULY,1,DECODE(DC.TRANGTHAICHUYEN_TP,NULL,decode(DC_HIS.TRANGTHAICHUYEN_TP,null,'<b><i><span style="color:#0e7eee"> Chưa chuyển:</span> Thẩm phán</i></b><br/>',NULL),NULL))
     ||DECODE(DC.TRANGTHAICHUYEN_TP,NULL,DC_HIS.TRANGTHAICHUYEN_TP,DC.TRANGTHAICHUYEN_TP) TRANGTHAICHUYEN_TP  
     
     ,DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN NGAYCHUYEN_DTL_NC
     ,DECODE(D.ISTHULY,1,DC.NGAYCHUYEN,DTL_NC.NGAYCHUYEN) NGAYCHUYEN
     
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH
      ,d.CD_NGAYTOTRINH
      ,c.HOTEN TENTHAMPHAN
      ,QLS.SOVB,QLS.NGAYVB
      ,DECODE(c.HOTEN,NULL,NULL,'<i>Thẩm phán: </i><b>'||c.HOTEN||'</b>'
      ||'('||d.CD_SOTOTRINH||'/TTr-TANDTC-VP'||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy')
      ||'<b>;</b> '||QLS.SOVB||'/TB-TANDTC-VP</b> '||' - '||TO_CHAR(QLS.NGAYVB,'dd/MM/yyyy')
      ||')<br/>')THAMPHAN_SONGAY 
      ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,d.THAMPHANID
      -------
--      ,(Case d.CD_LOAI when 0 then 
--              (Case vIsDonGoc when 0 then 1 else
--                  (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                              and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                              and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
--                            )
--                     + (Case when d.DONTRUNGID>0 then 
--                        (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                              and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                              and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
--                            )
--                     Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
--                     ) End
--                )
--              Else 
--              (Case vIsDonGoc when 0 then 1 else
--              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
--                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
--                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
--              End)
--         End)SODON
        ,1 SODON
       ,TSD.TONG_SODON,TSD.ARR_DON_IDS,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
       ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET  
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' 
              when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) 
              then 'block' 
              Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
       ,(Case  when va.NGAYTHULYXXGDT is not null 
                    and (to_char(va.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')
                    and NVL(va.IsVienTruongKN,0) = 0 then 'block' 
                        Else 'none' End) IsThulyXX 
                        
                        
                   
        ,decode(d.LOAIDON,1,'',
                      (NVL(d.CV_TENDONVI,'')
                    || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO)
                    || decode(NVL(d.CV_NGAY,''),'','',DECODE(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001',NULL,' ngày '||TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'))  )
                      )    
             ) arrCongvan
             
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
                  and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end 
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
         ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH|| ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')  || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL
            ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then 
                      (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
                      FROM GDTTT_DON cv  
                      WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
                            And cv.ID<d.ID) 
                    
               End
            ) arrTTTL_TL
           ,d.PHANLOAIXULY,NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
              ---------13/03/2024------------------------run 5s
              ----GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
              ----D.cd_loai:0 nội bộ
            ,TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX
            ,XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT) KQGQ_DANSU_EX
            ,va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT
            ,CASE  WHEN D.cd_loai= 0 AND nvl(D.vuviecid, 0)>0  THEN
                   CASE WHEN va.LOAIAN =1 THEN -- hinh su
                          CASE WHEN  va.GQD_LOAIKETQUA=0 OR va.GQD_LOAIKETQUA=1 THEN
                                   decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',TLD.TLDKN||KN.TLDKN||kq.KQXXGDT) 
                            WHEN va.GQD_LOAIKETQUA=2
                                 THEN 'Xếp đơn <b>'||decode(va.GDQ_SO,null,null,' số ') || to_char(va.GDQ_SO)||decode(va.GDQ_NGAY,null,null,' ngày ')||to_char(va.GDQ_NGAY,'dd/MM/yyyy')||'</b>'
                            WHEN va.GQD_LOAIKETQUA=3 THEN
                                 'Xử lý khác <b>'||decode(va.GDQ_SO,null,null,' số ')||to_char(va.GDQ_SO)||decode(va.GQD_NgayPhatHanhCV,null,null,' ngày ')||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||'</b>'
                            WHEN va.GQD_LOAIKETQUA=4 THEN
                                 'Thông báo VKS đang giải quyết'
                             WHEN va.GQD_LOAIKETQUA IS NULL THEN
                                  decode(d.CD_TRANGTHAI,2,'Đang giải quyết','') 
                           END 
                    ELSE  --dan su mo rong
                    CASE WHEN va.GQD_LOAIKETQUA IS NOT NULL THEN
                                CASE WHEN XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS
                                        ||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT) IS  NULL THEN
                             ---------xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--------------           
                              case when NVL(va.GQD_LOAIKETQUA,5)=3 then ' Xử lý khác <b>'||to_char(va.GDQ_SO)||' ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||'</b>'
                              when NVL(va.GQD_LOAIKETQUA,5)<>3 
                                      then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                                  , 5, decode(d.CD_TRANGTHAI,2,'Đang giải quyết','')                            
                                                  , 2, u'X\1ebfp \0111\01a1n'
                                                  , 1,decode(d.loaidon,8,'Không chấp nhận khiếu nại',10,'Không chấp nhận khiếu nại',u'Kh\00e1ng ngh\1ecb')
                                                  , 0,decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',u'Tr\1ea3 l\1eddi \0111\01a1n') 
                                                  ,4,'Thông báo VKS đang giải quyết'
                                                  )
        
                                            || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                                    else '' end 
                                            || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                          or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                    when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                          then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                            || Decode (va.GQD_LOAIKETQUA ,1,'<br/>KQXXGDT: ' || to_char(kq.KQXXGDT),'')
                                            ) end 
                                ---------------------------    
                                else
                                DECODE(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',
                                        XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS
                                        ||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT))
                               end          
                              WHEN va.GQD_LOAIKETQUA IS NULL
                             THEN  decode(d.CD_TRANGTHAI,2,'Đang giải quyết','') 
                    END 
                END   
             END
             KQGQNoiBo
--             ,TLD.TLDKN||KN.TLDKN
--              ||XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS
--              ||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT)
--             KQGQNoiBo   
             -------------------
            ,d.CV_TRALOI_NOIDUNG
            ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME 
            ---văn thư đến-----
            ,vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,DECODE(vt.TRANG_THAI_XLY,3,null,4,'Dữ liệu từ VBĐ') TRANG_THAI_XLY_NAME
            ,vbd.LOAI_VB,vbd.NGUOIDUNGDON--,vbd.NGUOI_GUI_BT
            ,decode(vbd.LOAI_VB,1,'<i>Người đứng đơn: </i><b>'||vbd.NGUOIDUNGDON,3,'<i>Người đứng đơn: </i><b>'||vbd.NGUOIDUNGDON,'<i>Người gửi:</i><b>'||vbd.NGUOI_GUI_BT)NGUOI_GUI_BT
            ,vbd.DIACHI_NDD--,vbd.DIACHI_GUI_BT
            ,decode(vbd.LOAI_VB,1,vbd.DIACHI_NDD,3,vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT)DIACHI_GUI_BT
            ,vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S
            ,decode(to_char(vbd.NGAY_DEN,'dd/MM/yyyy'),'01/01/0001',null,to_char(vbd.NGAY_DEN,'dd/MM/yyyy'))NGAY_DEN
            ,decode(to_char(vbd.NGAY_BT,'dd/MM/yyyy'),'01/01/0001',null,to_char(vbd.NGAY_BT,'dd/MM/yyyy'))NGAY_BT
            ,vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV
            ,DECODE(vbd.LOAI_VB
                                 ,1,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,4,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,5,'Số <b>VB: '||vbd.SO_VB||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_VB,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_VB,'dd/MM/yyyy'))||' '||vbd.NGUOI_GUI_BT ||'</b>'
                                 ,'Số CV: <b>'||vbd.SO_CV||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_CV,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_CV,'dd/MM/yyyy'))||'</b> Cơ quan/Đơn vị chuyển: <b>'||' '||vbd.DONVICHUYEN_CV ||'</b>'
                                 ) THONGTIN_VBD 
               ,pbvt.TEN TEN_PBVT,vbd.SODEN--,vbd.NGUON_DEN                
              ,decode(pbvt.TEN,null,null,'<i>Đơn vị tiếp nhận:</i><b style="color:#0da520" > Văn thư</b><br />') DONVITIEPNHAN                   
              ,decode(vbd.NGUON_DEN,1,'Bưu điện',2,'Tiếp công dân',3,'Trực tiếp')NGUON_DEN
            ---------------------------------- 
          ,d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI--,NULL YCBS
          ,(case d.LOAI_GDTTTT when 1 then 'Giám đốc thẩm'
                            when 2 then  'Tái thẩm'
                            when 3 then  'Chưa xác định' 
                            else ' '   end ) TRANGTHAILOAI_GDTTTT
                            
                ,(SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') 
                     FROM GDTTT_DON_YEUCAU_BOSUNG y WHERE y.DONID = d.ID 
                     AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = d.ID)
                ) AS YCBS
                ,THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV,gxndv.NGAYVB GXNNGAYDV--,null LOAIGDTT,null IsGXN,null IsGXNDV
                ,decode(d.LOAI_GDTTTT,1,'giám đốc thẩm',2,'tái thẩm','') LOAIGDTT
                ,decode (sph.SOVB,null,'none','block') IsGXN
                ,decode (gxndv.SOVB,null,'none','block') IsGXNDV        
         ----manhnd canh bao an thoi hieu
               ,case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                        
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                      when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0
                        then '(Hết thời hiệu giải quyết)'
                    else ''
               end THOIHIEU
        from GDTTT_DON d
          --LEFT JOIN CHUYENDOI_VALUE CVD ON CVD.VALUE_COL=D.LOAIDON AND CVD.NAME_COL='LOAIDON'
          -------------------
          LEFT JOIN(SELECT COUNT(*)TONG_SODON,DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS FROM GDTTT_DON cv WHERE
                      (vNgayNhapTu is null or vNgayNhapTu <= cv.NGAYTAO)
                      and (vNguoiNhap is null or lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%'))
                   GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)
              ) TSD ON TSD.ARR_DON_IDS=D.ID   
         LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                    left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso = 'SoGXN')sph on sph.donid = d.id
          LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                    left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id                            
        -- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
             left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v
                    inner join ( SELECT TT.DONID,TT.ID FROM (  
                                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID
                                 FROM  GDTTT_DON_CHUYEN_HISTORY
                                 )TT GROUP BY TT.DONID,TT.ID
                                )t on t.id=v.id
                )tralai on d.id = tralai.donid
      LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=vToaAnID)LAD ON LAD.LOAIDON_ID=d.LOAIDON
      left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID
      LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
      ----Ket qua xx giam doc tham 
     LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID
     --16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
     --decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
     LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID
     LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID
     --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
     LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID -- 1 đang dùng,0 xóa
     LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID
     LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID
     LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID   
     LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID  
      ---hoan thi hanh an tha----
     LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID 
     -----------------------
        LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
             ----van thu den 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
        --------add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
        LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id  LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id    LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id   
        --lấy trạng thái chuyển luồng thụ lý mới thẩm phán    
        LEFT JOIN (SELECT tc.donid,'<i><b> <span  style="color: #0e7eee;">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id 
        -----------------
        LEFT JOIN (SELECT tc.donid,'<i><b> <span  style="color: #0e7eee;">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id  
        --lấy trạng thái chuyển luồng đã thụ lý  
       LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID 
       LEFT JOIN (SELECT dvc.DONID,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển: '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID  
       LEFT JOIN ( SELECT SD.DONID,S.SOVB,S.NGAYVB  FROM  QUANLY_SOPHATHANH S LEFT JOIN  SOPHATHANH_DON SD ON S.ID = SD.SOPHATHANH_ID WHERE  S.MASO = 'TBTP' AND S.TRANGTHAI=1)QLS ON QLS.DONID=D.ID
         where d.TOAANID=vToaAnID 
         AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1) --19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
         AND (vIsThuLy =-1  OR(vIsThuLy=1 AND d.ISTHULY=1)
                            OR(vIsThuLy=3 AND d.ISTHULY=1 AND (vNgayNhapTu is not null and  vNgayNhapDen is not null) and d.ARR_DON_ID!=0)--PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(d.id)>1) -- TLM trùng
                            OR(vIsThuLy=4 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0) -- TLM đã phan cong
                            OR(vIsThuLy=5 and d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0 ) -- TLM chua phan cong
                            OR(vIsThuLy=2 and d.ISTHULY=2)
                             )
         AND (vToaRaBAQD=0  OR(d.BAQD_TOAANID=vToaRaBAQD Or d.BAQD_TOAANID_PT=vToaRaBAQD Or d.BAQD_TOAANID_ST=vToaRaBAQD) )
         AND (vLoaiAn=0 OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )    
        AND (VSOBAQD IS NULL  OR(LOWER(D.BAQD_SO) LIKE LOWER(VSOBAQD)||'%' 
                                    OR LOWER(D.BAQD_SO_PT) LIKE LOWER(VSOBAQD)||'%'
                                    OR LOWER(D.BAQD_SO_ST) LIKE LOWER(VSOBAQD)||'%'
                                    OR LOWER(D.KN_SOQD) LIKE LOWER(VSOBAQD)||'%'
                              )
            )
        AND (VNGAYBAQD IS NULL  OR(TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')=VNGAYBAQD
                                    OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=VNGAYBAQD
                                    OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=VNGAYBAQD
                                    OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')=VNGAYBAQD
                              )
            )    
        AND (VNGUOIGUI IS NULL OR (LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,DECODE(VTOAANID,6,D.NGUOIGUI_HOTEN,D.DONGKHIEUNAI) )) LIKE '%' || LOWER(VNGUOIGUI) || '%'))                        
        AND(VSOCMND IS NULL OR (D.NGUOIGUI_CMND LIKE '%'||VSOCMND ||'%') )       
        AND(VTUNGAY IS NULL OR ( D.NGAYNHANDON >=VTUNGAY))
        AND(VDENNGAY IS NULL OR (D.NGAYNHANDON <= VDENNGAY))         
        AND(VHINHTHUCDON=0 OR(D.LOAIDON=VHINHTHUCDON))
        AND(VSOHIEUDON IS NULL OR(D.MADON =VSOHIEUDON OR D.SOHIEUDON=VSOHIEUDON))        
        AND (VDIACHITINH=0 OR(D.NGUOIGUI_TINHID=VDIACHITINH))        
        AND (VDIACHIHUYEN=0 OR(D.NGUOIGUI_HUYENID=VDIACHIHUYEN))        
        AND (VDIACHICT IS NULL OR(LOWER(D.NGUOIGUI_DIACHI) LIKE '%' || LOWER(VDIACHICT) || '%'))
        
        AND (VSOCONGVAN IS NULL OR  ( D.ISTHULY = 1 AND ( (LOWER(D.CD_SOCV) =LOWER(VSOCONGVAN) AND VNOICHUYEN=2) 
                                                             OR(LOWER(D.CD_SOCV) =LOWER(VSOCONGVAN) AND VCD_TENDONVI='CVPC') 
                                                             OR (LOWER(D.CD_SOTOTRINH) = LOWER(VSOCONGVAN) AND VCD_TENDONVI='TTR' ))
                                    
                                    )
          )        
        
        AND(VNGAYCONGVAN IS NULL OR (TO_CHAR(D.CD_NGAYCV,'dd/MM/yyyy')=VNGAYCONGVAN  AND VNOICHUYEN=2) 
                                OR (TO_CHAR(D.CD_NGAYCV,'dd/MM/yyyy')=VNGAYCONGVAN  AND VCD_TENDONVI='CVPC') 
                                OR (TO_CHAR(D.CD_NGAYTOTRINH,'dd/MM/yyyy')=VNGAYCONGVAN AND VCD_TENDONVI='TTR')
        )      
        
        AND(VCVPC_SO IS NULL OR ( LOWER(D.CV_SO) LIKE '%' || LOWER(VCVPC_SO) || '%'))
        
        AND (vCVPC_Ngay IS NULL OR(to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay))
        
        AND(vCVPC_TenCQ IS NULL OR( lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' ))
        
        AND (vTraLoi=0 OR (d.TRALOIDON=vTraLoi))
        
        AND (vNguoiNhap IS NULL OR (lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%')))
        --13/02/2020
        AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
             )
         AND(vTrangthai=-1 OR(d.CD_TRANGTHAI in (1,2) AND vTrangthai=1)
                           OR(d.CD_TRANGTHAI=vTrangthai)
         )    
         AND((vNoiChuyen=-1 OR vNoiChuyen=-2) 
                        OR(vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and 
                                            (vCD_TA_TRANGTHAI=-1 
                                                Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                                                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID) ) --lanhnt thêm trạng thái đơn
                                                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)) )
                                            )
                           )
                        OR(vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) 
                                                              Or (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')) )
                                            )
                         )
                        OR(vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%')
                        OR(vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen)
              )
          AND (vNgaychuyenTu is null OR(vNgaychuyenTu <= d.CD_NGAYXULY))              
          AND (vNgaychuyenDen is null OR(d.CD_NGAYXULY <= vNgaychuyenDen))              
          AND (vNgayThulyTu is null OR(vNgayThulyTu <= d.TL_NGAY))    
          AND (vNgayThulyDen is null OR(d.TL_NGAY <= vNgayThulyDen)) 
          
          AND (vSoThuly IS NULL OR(lower(d.TL_SO) like '%' || lower(vSoThuly) || '%') )
          AND (vArrSelectID IS NULL OR(vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%') )
          
          AND (vChidao=-1 OR(vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 ) -- Có ý kiến chỉ đạo
                          OR(vChidao=1 and NVL(d.CHIDAO_COKHONG,0)=0 )-- Không có ý kiến chỉ đạo
                          OR(vChidao>1 and d.CHIDAO_LANHDAOID=vChidao)
              )
          AND (vTraigiam=-1 OR(NVL(d.CV_ISTRAIGIAM,0)=vTraigiam ) )    
          AND (vPhanloaixuly=0 OR(d.PHANLOAIXULY=vPhanloaixuly))
          --------đang turning dở 23/05/2024; sau khi đi du lịch về sẽ làm tiếp--------------
          AND (vTBQuahan=0 OR(d.TB1_NGAY<(vNgayQuahan - 30)))
          
          AND (curr_thamphan_id=0 OR(d.THAMPHANID=curr_thamphan_id))
          
          AND  ( (    (vNgayNhapTu is null or d.NGAYTAO>=vNgayNhapTu) AND (vNgayNhapDen is null or d.NGAYTAO<=vNgayNhapDen) )
                    Or(visthuly=1 and(vNgayNhapTu is null or d.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or d.TL_NGAY <= vNgayNhapDen) )
          )
          AND (vIsTuHinh=0 OR(vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0)
                           OR(vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1)
                           OR(vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)
                           OR(vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)
          )
         AND (vThamtravienID=0 OR(d.GQ_THAMTRAVIENID=vThamtravienID) )
         AND (vLoaiCVID=0 OR(vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))
                          OR(d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID))
             )
         AND (vGuitoiCA_TA=-1 OR(vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0)
                              OR(vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1)
            )       
        ----add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
               AND ((TRIM(V_NDBD_TEXT) IS NULL)
                        OR(V_NDBD_VALUE ='0' AND nds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(nds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE ='1' AND bds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE='2' AND bcs.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bcs.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        )  
         ------- add 22/10/2020 vanthu den
          AND (V_DONVI_CHUYEN_ID IS NULL 
               OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
            AND ( V_TRANGTHAICHUYEN IS NULL
                      OR(
                         (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3  AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                      )
                      OR(V_TRANGTHAICHUYEN=4  
                       AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3  AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                      )
                  )
          AND ( V_LOAI_VB IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=V_LOAI_VB  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
           AND ( V_SODEN_TU IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=V_SODEN_TU  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )    
          AND ( V_SODEN_DEN IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=V_SODEN_DEN  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
           AND ( V_NGAY_FROM IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS')  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
            AND ( V_NGAY_TO IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS')  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
           AND ( V_NGUOI_GUI_BT IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                    WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%' AND  cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
               ) 
          AND (vLOAI_GDTTT=0 OR (d.LOAI_GDTTTT= vLOAI_GDTTT) )
          -----------------
        ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
End if;
END DON_SEARCHS;
END PKG_GDTTT_HCTP_APP_TURING;