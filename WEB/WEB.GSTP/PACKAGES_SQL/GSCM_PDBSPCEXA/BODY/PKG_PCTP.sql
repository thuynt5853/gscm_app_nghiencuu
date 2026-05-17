--------------------------------------------------------
--  DDL for Package Body PKG_PCTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_PCTP" AS

PROCEDURE TPGQD_LICHSUPHANCONG
( 
vToaAnID in number,  
	curReturn    OUT       sys_refcursor
) IS 
BEGIN

OPEN curReturn FOR  
  Select k.*,(CASE k.LOAIPHANCONG when 'TPGQD' then 'Phân công TP giải quyết đơn' END) TENLOAIPHANCONG
      ,c.HOTEN
  From PCTP_KETQUA k left join DM_CANBO c on k.NGUOITHUCHIENID=c.ID
  where k.TOAANID=vToaAnID
  Order by k.NGAYPHANCONG desc;
END TPGQD_LICHSUPHANCONG;

  FUNCTION TPGQD_PHANCONGNGAUNHIEN
( vToaAnID in number,
  vNgayPhanCong in date,
  vChanhAnID in number,
  vNguoithuchien number,
  vFromDate in date,
  vToDate in date,
  vChucDanh in varchar2
) RETURN number AS 
 vGroupChucDanhID number;
 vTT number;
 vRand number;
 vKetQuaID number;
 vThamphanID number;
BEGIN
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
 
 /*Lưu thông tin lần phân công*/
  vKetQuaID:=PCTP_KETQUA_SEQ.nextval;
  Insert into PCTP_KETQUA VALUES(vKetQuaID,(SELECT SYSTIMESTAMP FROM DUAL),'',vChanhAnID,'TPGQD',vFromDate,vToDate,vToaAnID,vNguoithuchien);         
 /*End*/
 FOR i IN (Select ID,'DS' as LOAIVV  from ADS_DON v where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'DS','VTTP_GIAIQUYETDON')=0
    Union Select ID,'HC' as LOAIVV  from AHC_DON v  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'HC','VTTP_GIAIQUYETDON')=0
    Union Select ID,'HN' as LOAIVV  from AHN_DON v where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'HN','VTTP_GIAIQUYETDON')=0
    Union Select ID,'KT' as LOAIVV  from AKT_DON v where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'KT','VTTP_GIAIQUYETDON')=0
    Union Select ID,'LD' as LOAIVV  from ALD_DON v  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'LD','VTTP_GIAIQUYETDON')=0
    Union Select ID,'PS' as LOAIVV  from APS_DON v where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'PS','VTTP_GIAIQUYETDON')=0
    Union Select ID,'XLHC' as LOAIVV  from XLHC_DON v where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'XLHC','VTTP_GIAIQUYETDON')=0
    )LOOP
    /*Tạo danh sách thẩm phán dùng phân công*/
      DELETE from PCTP_TMPCANBO where TOAANID=vToaAnID;
      vTT:=0;
      FOR j in (Select c.TOAANID,c.ID From DM_CANBO c  inner join DM_TOAAN t on c.TOAANID=t.ID inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID   WHere c.TOAANID=vToaAnID  And c.HIEULUC=1)
      LOOP vTT:=vTT+1;
          Insert into PCTP_TMPCANBO VALUES(j.TOAANID,j.ID,vTT);
      END LOOP;  
     /*End*/   
    /*Phân công ngẫu nhiên cho vụ việc*/
        vRand:= ROUND(DBMS_RANDOM.value(low => 1, high => vTT),0);
        vThamphanID:=0;
        Select t.CANBOID into vThamphanID from PCTP_TMPCANBO t where t.TOAANID=vToaAnID And t.THUTU=vRand;
        if(vThamphanID>0) then
          Insert into PCTP_KETQUA_CHITIET Values(PCTP_KETQUA_CHITIET_SEQ.nextval,vToaAnID,vKetQuaID,i.ID,i.LOAIVV,vThamphanID,vChanhAnID,(SELECT SYSTIMESTAMP FROM DUAL),'TPGQD');
          If i.LOAIVV='DS' Then
            Insert Into ADS_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);
          ElsIf i.LOAIVV='HC' Then
            Insert Into AHC_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);
          ElsIf i.LOAIVV='HN' Then
            Insert Into AHN_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);
          ElsIf i.LOAIVV='KT' Then
            Insert Into AKT_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);  
          ElsIf i.LOAIVV='LD' Then
            Insert Into ALD_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);
          ElsIf i.LOAIVV='PS' Then
            Insert Into APS_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);
          ElsIf i.LOAIVV='XLHC' Then
            Insert Into XLHC_DON_THAMPHAN(DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID)
            VALUES(i.ID,vThamphanID,'VTTP_GIAIQUYETDON',(SELECT SYSTIMESTAMP FROM DUAL),(SELECT SYSTIMESTAMP FROM DUAL),vChanhAnID);    
          End If;
        End if;        
    /*End*/
   END LOOP;
Return vKetQuaID;
END TPGQD_PHANCONGNGAUNHIEN;
  PROCEDURE TPGQD_DAPHANCONG
( 
vKetQuaID in number,
vToaAnID in number,  
	curReturn    OUT       sys_refcursor
) IS 
BEGIN

OPEN curReturn FOR  
SELECT d.* FROM (
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Dân sự' as TENLOAIVV,'DS' as MALOAIVV,k.HOTEN TENTPGQD
  from ADS_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='DS') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID 
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Hành chính' as TENLOAIVV,'HC' as MALOAIVV,k.HOTEN TENTPGQD
  from AHC_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='HC') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID 
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Hôn nhân & Gia đình' as TENLOAIVV,'HN' as MALOAIVV,k.HOTEN TENTPGQD
  from AHN_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='HN') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID 
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Kinh doanh & Thương mại' as TENLOAIVV,'KT' as MALOAIVV,k.HOTEN TENTPGQD
  from AKT_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='KT') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID   
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Lao động' as TENLOAIVV,'LD' as MALOAIVV,k.HOTEN TENTPGQD
  from ALD_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='LD') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID 
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Phá sản' as TENLOAIVV,'PS' as MALOAIVV,k.HOTEN TENTPGQD
  from APS_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='PS') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID   
Union
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Biện pháp XLHC' as TENLOAIVV,'XLHC' as MALOAIVV,k.HOTEN TENTPGQD
  from XLHC_DON v  inner join (Select q.CANBOID,q.VUVIECID,c.HOTEN from PCTP_KETQUA_CHITIET q inner join DM_CANBO c on c.ID=q.CANBOID 
            where q.KETQUAID=vKetQuaID And q.LOAIVUVIEC='XLHC') k on k.VUVIECID=v.ID
  where v.ToaAnID=vToaAnID     
) d order by d.NGAYNHANDON desc;
END TPGQD_DAPHANCONG;

  PROCEDURE TPGQD_CHUAPHANCONG
( vToaAnID in number,
  vNgayPhanCong in date,
  vChanhAnID in number,
  vFromDate in date,
  vToDate in date,
	curReturn    OUT       sys_refcursor
) IS 
BEGIN

OPEN curReturn FOR  
SELECT d.* FROM (
	Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Dân sự' as TENLOAIVV,'DS' as MALOAIVV, '' TENTPGQD
  from ADS_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'DS','VTTP_GIAIQUYETDON')=0
Union
  Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Hành chính' as TENLOAIVV,'HC' as MALOAIVV, '' TENTPGQD
  from AHC_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'HC','VTTP_GIAIQUYETDON')=0
Union
  Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Hôn nhân & Gia đình' as TENLOAIVV,'HN' as MALOAIVV, '' TENTPGQD
  from AHN_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'HN','VTTP_GIAIQUYETDON')=0
Union
    Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Kinh doanh & Thương mại' as TENLOAIVV,'KT' as MALOAIVV, '' TENTPGQD
  from AKT_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'KT','VTTP_GIAIQUYETDON')=0
Union
  Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Lao động' as TENLOAIVV,'LD' as MALOAIVV, '' TENTPGQD
  from ALD_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'LD','VTTP_GIAIQUYETDON')=0
Union
    Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Phá sản' as TENLOAIVV,'PS' as MALOAIVV, '' TENTPGQD
  from APS_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'PS','VTTP_GIAIQUYETDON')=0
Union
    Select ID,MAVUVIEC,TENVUVIEC,v.NGAYNHANDON,'Biện pháp XLHC' as TENLOAIVV,'XLHC' as MALOAIVV, '' TENTPGQD
  from XLHC_DON v
  where v.ToaAnID=vToaAnID and v.NGAYNHANDON between vFromDate and vToDate And CheckIsNotGQD(v.ID,'XLHC','VTTP_GIAIQUYETDON')=0
) d order by d.NGAYNHANDON desc;
END TPGQD_CHUAPHANCONG;

FUNCTION GETTENTP 
(
  vDonID IN NUMBER,
  vLoaiAn in nvarchar2,
  vMavaitro in nvarchar2,
  vLoaiTP in nvarchar2,
  vGiaidoan nvarchar2
) RETURN nvarchar2 AS
  vTenTP nvarchar2(250); 
  BEGIN
    vTenTP:=',';
     if vLoaiAn='DS' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from ADS_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from ADS_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from ADS_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;
     Elsif vLoaiAn='HN' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from AHN_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from AHN_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from AHN_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;   
     Elsif vLoaiAn='HC' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from AHC_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from AHC_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from AHC_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;  
     Elsif vLoaiAn='KT' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from AKT_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from AKT_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from AKT_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if; 
     Elsif vLoaiAn='LD' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from ALD_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from ALD_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from ALD_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;  
     Elsif vLoaiAn='PS' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from APS_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from APS_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from APS_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;  
     Elsif vLoaiAn='XLHC' then    
        If vLoaiTP='TPGQ' then
          Select HOTEN into vTenTP from (Select c.HOTEN from XLHC_DON_THAMPHAN t left join DM_CANBO c on c.ID=t.CANBOID where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc) where rownum = 1;
        ElsIf vLoaiTP='HDXX' then
          If vGiaidoan='ST' then
           Begin
                FOR i IN ( Select c.HOTEN from XLHC_SOTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          Else
            Begin
                FOR i IN ( Select c.HOTEN from XLHC_PHUCTHAM_HDXX t left join DM_CANBO c on c.ID=t.CANBOID  where t.DONID=vDonID and t.MAVAITRO=vMavaitro Order by t.NGAYPHANCONG desc )
                LOOP If vTenTP = ',' then vTenTP:=i.HOTEN; Else vTenTP:=vTenTP || ', ' || i.HOTEN; End if; END LOOP;
            End;
          End if;
        End if;          
     end if;
     
     If vTenTP=',' then vTenTP:=''; End if;
    RETURN vTenTP;
  END GETTENTP;
FUNCTION CheckIsNotGQD 
(
  vDonID IN NUMBER,
  vLoaiAn in nvarchar2,
  vMavaitro in nvarchar2
) RETURN number AS
  visCheck number; 
  BEGIN
    visCheck:=0;
     if vLoaiAn='DS' then    
         Select Count(t.ID) into visCheck from ADS_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
     ELSif vLoaiAn='HN' then    
         Select Count(t.ID) into visCheck from AHN_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
    ELSif vLoaiAn='KT' then    
         Select Count(t.ID) into visCheck from AKT_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
    ELSif vLoaiAn='HC' then    
         Select Count(t.ID) into visCheck from AHC_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
    ELSif vLoaiAn='LD' then    
         Select Count(t.ID) into visCheck from ALD_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
    ELSif vLoaiAn='PS' then    
         Select Count(t.ID) into visCheck from APS_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
    ELSif vLoaiAn='XLHC' then    
         Select Count(t.ID) into visCheck from XLHC_DON_THAMPHAN t where t.DONID=vDonID and t.MAVAITRO=vMavaitro ;
     end if;
     
     
    RETURN visCheck;
  END CheckIsNotGQD;
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
        || (Case c.ISHNGD when 1 then 'HN&GĐ, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD&TM, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1
    Order by c.Hoten;
Else
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN&GĐ, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD&TM, ' Else '' End)
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
 
END PKG_PCTP;
