--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_APP" AS




FUNCTION DELETE_XULYLAI_DONTLM
(  
    vDON_ID in number,
    vNguoiXoa  IN VARCHAR2
)RETURN NUMBER AS
    vID NUMBER;
    vTOAANID  NUMBER;
    vLOAIDON  NUMBER;
    vBAQD_LOAIAN  NUMBER;
    vTL_SO VARCHAR2(100);
    vTL_NGAY date;
    vThamphanid   NUMBER;
    vCOUNT_TT  number; 
    vSOTT   VARCHAR2(100); 
    vNGAYTT date;
    vCOUNT_TB  number;
    vSOTB   VARCHAR2(100); 
    vNGAYTB date;
    
BEGIN

SAVEPOINT P1;  
        
        select TOAANID,BAQD_LOAIAN,TL_SO,TL_NGAY,thamphanid,loaidon 
                INTO vTOAANID,vBAQD_LOAIAN,vTL_SO,vTL_NGAY,vThamphanid, vLOAIDON
                FROM GDTTT_DON WHERE ID = vDON_ID;
  
        --Lay thong tin To tinh, TB phan cong TP neu co
         select count(s.id) into vCOUNT_TT from  QUANLY_SOPHATHANH s 
                left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL');
         if (vCOUNT_TT > 0) then
            select s.SOVB,s.NGAYVB into vSOTT,vNGAYTT from  QUANLY_SOPHATHANH s 
                    left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                    where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL');
         end if;
         ------
          select count(s.id) into vCOUNT_TB from  QUANLY_SOPHATHANH s 
                left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                where sd.DONID = vDON_ID and s.MASO in ('TBTP');
          if (vCOUNT_TB > 0) then
            select s.SOVB,s.NGAYVB into vSOTB,vNGAYTB from  QUANLY_SOPHATHANH s 
                    left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                    where sd.DONID = vDON_ID and s.MASO in ('TBTP');
           end if;
           
        --1. Xoa don khoi so van ban
        if (vCOUNT_TT > 0) then
            DELETE SOPHATHANH_DON WHERE DONID = vDON_ID  
                                    and SOPHATHANH_ID in (select s.id from  QUANLY_SOPHATHANH s 
                                                                        left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                                                                        where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL')) ;
        end if;
        if (vCOUNT_TB > 0) then
            DELETE SOPHATHANH_DON WHERE DONID = vDON_ID 
                                    and SOPHATHANH_ID in (select s.id from  QUANLY_SOPHATHANH s 
                                                                        left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                                                                        where sd.DONID = vDON_ID and s.MASO in ('TBTP')) ;
        end if;
        
        --2. UPDATE   GDTTT_DON Thanh don da thu ly
        UPDATE GDTTT_DON 
                SET 
                TL_SO = null, 
                TL_NGAY = null,
                ISTHULY = 2, --DON DA THU LY
                CD_SOTOTRINH = NULL,
                CD_NGAYTOTRINH = NULL,
                CD_NGUOIKY = NULL,
                THAMPHANID = NULL,
                NGUOISUA = vNguoiXoa,
                NGAYSUA  = SYSDATE
                WHERE ID = vDON_ID;
       RETURN 1;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END DELETE_XULYLAI_DONTLM;


FUNCTION DELETE_SOTHULY_DON
(  
    vDON_ID in number,
    vLydo  IN VARCHAR2,
    vNguoiXoa  IN VARCHAR2,
    in_OBJECT     IN CLOB
)RETURN NUMBER AS
    vID NUMBER;
    vTOAANID  NUMBER;
    vLOAIDON  NUMBER;
    vBAQD_LOAIAN  NUMBER;
    vTL_SO VARCHAR2(100);
    vTL_NGAY date;
    vThamphanid   NUMBER;
    vCOUNT_TT  number; 
    vSOTT   VARCHAR2(100); 
    vNGAYTT date;
    vCOUNT_TB  number;
    vSOTB   VARCHAR2(100); 
    vNGAYTB date;

BEGIN

SAVEPOINT P1;  

        select TOAANID,BAQD_LOAIAN,TL_SO,TL_NGAY,thamphanid,loaidon 
                INTO vTOAANID,vBAQD_LOAIAN,vTL_SO,vTL_NGAY,vThamphanid, vLOAIDON
                FROM GDTTT_DON WHERE ID = vDON_ID;

        --Lay thong tin To tinh, TB phan cong TP neu co
         select count(s.id) into vCOUNT_TT from  QUANLY_SOPHATHANH s 
                left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL');
         if (vCOUNT_TT > 0) then
            select s.SOVB,s.NGAYVB into vSOTT,vNGAYTT from  QUANLY_SOPHATHANH s 
                    left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                    where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL');
         end if;
         ------
          select count(s.id) into vCOUNT_TB from  QUANLY_SOPHATHANH s 
                left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                where sd.DONID = vDON_ID and s.MASO in ('TBTP');
          if (vCOUNT_TB > 0) then
            select s.SOVB,s.NGAYVB into vSOTB,vNGAYTB from  QUANLY_SOPHATHANH s 
                    left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                    where sd.DONID = vDON_ID and s.MASO in ('TBTP');
           end if;


        --1.INNSERT GDTTT_DON_XOATL
        vID:= GDTTT_DON_XOATL_SEQ.NEXTVAL;        
        INSERT INTO GDTTT_DON_XOATL (ID,TOAANID,LOAIDON,LOAIAN,SOTHULY,NGAYTHULY,GHICHU,DONID
                                    ,Thamphanid,SOTT,NGAYTT,SOTB,NGAYTB
                                    ,NGUOIXOA,NGAYXOA,THONGTINDON)
                            VALUES (vID,vTOAANID, vLOAIDON,vBAQD_LOAIAN,vTL_SO,vTL_NGAY,vLydo,vDON_ID
                                    ,vThamphanid,vSOTT,vNGAYTT,vSOTB,vNGAYTB
                                    ,vNguoiXoa,SYSDATE,in_OBJECT);
        --2. Xoa don khoi so van ban
        if (vCOUNT_TT > 0) then
            DELETE SOPHATHANH_DON WHERE DONID = vDON_ID  
                                    and SOPHATHANH_ID in (select s.id from  QUANLY_SOPHATHANH s 
                                                                        left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                                                                        where sd.DONID = vDON_ID and s.MASO in ('SoTT','SoTT_TLL')) ;
        end if;
        if (vCOUNT_TB > 0) then
            DELETE SOPHATHANH_DON WHERE DONID = vDON_ID  
                                    and SOPHATHANH_ID in (select s.id from  QUANLY_SOPHATHANH s 
                                                                        left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                                                                        where sd.DONID = vDON_ID and s.MASO in ('TBTP')) ;
        end if;

        --3. UPDATE   GDTTT_DON Thanh don da thu ly
        UPDATE GDTTT_DON 
                SET 
                TL_SO = null, 
                TL_NGAY = null,
                ISTHULY = 2, --DON DA THU LY
                CD_SOTOTRINH = NULL,
                CD_NGAYTOTRINH = NULL,
                CD_NGUOIKY = NULL,
                THAMPHANID = NULL,
                NGUOISUA = vNguoiXoa,
                NGAYSUA  = SYSDATE
                WHERE ID = vDON_ID;
       RETURN 1;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END DELETE_SOTHULY_DON;


FUNCTION TLXXGDT_GETMAXTT
(   vToaanid in number,
    vYear in number,
    vLoaian in number
)RETURN NUMBER AS 
    vY number;
    v_maxTLxxgdt number;
BEGIN

    vY:=vYear;

    select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) into v_maxTLxxgdt
        from (
            select              
                lower(DECODE(INSTR(d.TL_SO,'/')
                            ,0,decode(INSTR(d.TL_SO,'0'),1,regexp_replace(d.TL_SO,'0','',1,1),d.TL_SO),decode(INSTR(d.TL_SO,'0')
                            ,1,SUBSTR(regexp_replace(d.TL_SO,'0','',1,1),1,instr(regexp_replace(d.TL_SO,'0','',1,1),'/')-1),SUBSTR(d.TL_SO,1,instr(d.TL_SO,'/')-1) )
                             )
                        ) as sotlxx 
                from gdttt_don d
              Where d.TOAANID=vToaanid  
                And d.LOAIDON = 4
                and d.TL_NGAY between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
                and d.BAQD_LOAIAN = vLoaian
             UNION ALL 
             select 
                 lower(DECODE(INSTR(v.SOTHULYXXGDT,'/')
                            ,0,decode(INSTR(v.SOTHULYXXGDT,'0'),1,regexp_replace(v.SOTHULYXXGDT,'0','',1,1),v.SOTHULYXXGDT),decode(INSTR(v.SOTHULYXXGDT,'0')
                            ,1,SUBSTR(regexp_replace(v.SOTHULYXXGDT,'0','',1,1),1,instr(regexp_replace(v.SOTHULYXXGDT,'0','',1,1),'/')-1),SUBSTR(v.SOTHULYXXGDT,1,instr(v.SOTHULYXXGDT,'/')-1) )
                             )
                        ) as sotlxx 
                from gdttt_vuan v 
                    where  
                     v.toaanid = vToaanid
                        and v.LOAIAN = vLoaian
                        and NVL(v.IsVienTruongKN,0) = 0
                        and v.GQD_LOAIKETQUA = 1 -- Kháng nghị
                        and NVL(v.truonghopthuly,0) not in (8,10,1) -- Đơn khiếu nại tư pháp và ho so kn
                        and v.NGAYTHULYXXGDT between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')

    )tt;

    return NVL(v_maxTLxxgdt,0);
END TLXXGDT_GETMAXTT;

PROCEDURE QLSOVB_GETMAXTT
(   vdonviID in number,    
    vPhongbanid in number,
    vYear in number,
    vLoaiso in varchar2,
	curReturn    OUT       sys_refcursor
) IS 
    vY number;
    vMaxSoDon number;
    vMaxSoVuAn number;
BEGIN
    vY:=vYear;
    
    select  Max(to_number(regexp_replace(tt.SOVB, '[^0-9]'))) SOVB into vMaxSoDon
    from (select lower(DECODE(INSTR(SOVB,'/'),0,decode(INSTR(SOVB,'0'),1,regexp_replace(SOVB,'0','',1,1),SOVB),
                decode(INSTR(SOVB,'0'),1,SUBSTR(regexp_replace(SOVB,'0','',1,1),1,instr(regexp_replace(SOVB,'0','',1,1),'/')-1),SUBSTR(SOVB,1,instr(SOVB,'/')-1)))) SOVB
            from QUANLY_SOPHATHANH d
            Where d.TOAANID=vdonviID and d.PHONGBANID=vPhongbanid AND d.MASO = vLoaiso and trim(d.SOVB) is not null 
            and d.NGAYVB between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
        )tt;
    
    if vLoaiso = 'TBTP' or vLoaiso = 'SoTT' then
        select Max(to_number(regexp_replace(tt.SOVB, '[^0-9]'))) SOVB into vMaxSoVuAn
        from (select lower(DECODE(INSTR(SOVB,'/'), 0, decode(INSTR(SOVB,'0'),1,regexp_replace(SOVB,'0','',1,1),SOVB),
                    decode(INSTR(SOVB,'0'),1,SUBSTR(regexp_replace(SOVB,'0','',1,1),1,instr(regexp_replace(SOVB,'0','',1,1),'/')-1),SUBSTR(SOVB,1,instr(SOVB,'/')-1)))) SOVB
                from sophathanh_vugiamdoc d
                Where d.TOAANID=vdonviID and d.PHONGBANID=vPhongbanid AND d.MASO = vLoaiso and trim(d.SOVB) is not null 
                and d.NGAYVB between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
            ) tt;
    end if;
    
    if NVL(vMaxSoVuAn, 0) > NVL(vMaxSoDon, 0) then
        OPEN curReturn FOR SELECT NVL(vMaxSoVuAn, 0) FROM dual;
    else
        OPEN curReturn FOR SELECT NVL(vMaxSoDon, 0) FROM dual;
    end if;
    
END QLSOVB_GETMAXTT;

FUNCTION CHECK_DON_LUUSO
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vDONID in number
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN

        SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM SOPHATHANH_DON a 
                                        INNER JOIN QUANLY_SOPHATHANH s on s.id = a.SOPHATHANH_ID
                                        LEFT JOIN GDTTT_DON d on d.id =a.DONID
                                WHERE s.ToaAnID = vToaAnID 
                                    AND s.PhongbanID = vPhongbanID 
                                    AND s.MASO = vLoaiSO
                                    AND a.DONID = vDONID
                                    AND (d.arr_don_id=0 or d.arr_don_id is null ) --27/08/2024
                                    ) 
                 THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
            FROM dual ;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  

END CHECK_DON_LUUSO;
FUNCTION CHECK_DON_LUUSO_CANHAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vUSERID  in number,
    vLoaiSO  in varchar2,
    vDONID in number
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN

         SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM SOPHATHANH_DON a 
                                        INNER JOIN QUANLY_SOPHATHANH s on s.id = a.SOPHATHANH_ID
                                            WHERE s.ToaAnID = vToaAnID 
                                                AND s.PhongbanID = vPhongbanID 
                                                AND s.THAMPHANID = vUSERID
                                                AND s.MASO = vLoaiSO
                                                AND a.DONID = vDONID) 
                 THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
            FROM dual ; 



        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  

END CHECK_DON_LUUSO_CANHAN;

FUNCTION CHECK_SOVANBAN_CANHAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vUSERID  in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
    vYear  varchar2(10);
    
BEGIN
     vYear := substr(vNgayVB,instr(vNgayVB,'/',1,2)+1);


       SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM QUANLY_SOPHATHANH a 
                                WHERE a.ToaAnID = vToaAnID 
                                    AND a.PhongbanID = vPhongbanID
                                    AND a.THAMPHANID = vUSERID
                                    AND a.MASO = vLoaiSO
                                    AND a.SOVB = vSoVB
                                    AND a.NGAYVB between TO_DATE(Cast((vYear) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vYear) as varchar2(4))||'-12-31','YYYY-MM-DD')
                                    --AND to_char(a.NGAYVB,'dd/MM/yyyy') = vNgayVB
                                    )  
           THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
            FROM dual ; 

        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  

END CHECK_SOVANBAN_CANHAN;



FUNCTION CHECK_SOVANBAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
    vYear  varchar2(10);
    
BEGIN
     vYear := substr(vNgayVB,instr(vNgayVB,'/',1,2)+1);

        SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM QUANLY_SOPHATHANH a 
                                WHERE a.ToaAnID = vToaAnID 
                                    AND a.PhongbanID = vPhongbanID 
                                    AND a.MASO = vLoaiSO
                                    AND a.SOVB = vSoVB
                                    AND a.NGAYVB between TO_DATE(Cast((vYear) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vYear) as varchar2(4))||'-12-31','YYYY-MM-DD')
                                    --AND to_char(a.NGAYVB,'dd/MM/yyyy') = vNgayVB
                                    AND  (vToaAnID = 1 OR (vToaAnID != 1 and  a.MASO not in ('SoGXN','SoGXN_DV')))
                                    )    
           THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
            FROM dual ;  



        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  

END CHECK_SOVANBAN;

PROCEDURE GET_THAMPHAN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    arrDonid  in varchar2,
    v_SOTOTRINH in varchar2,
    v_NGAYTOTRINH in varchar2,
	curReturn OUT sys_refcursor
)
IS 
BEGIN

  OPEN curReturn FOR
      select /*PKG_GDTTT_HCTP_APP.GET_THAMPHAN (Lay danh sach TP trong to trinh)*/
                 DISTINCT d.thamphanid , cb.hoten from gdttt_don d 
                                left JOIN dm_canbo cb on cb.id =d.thamphanid 
                                            where d.id in( select sd.donid  from  QUANLY_SOPHATHANH s 
                                                                      left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                                                      where  s.TOAANID=vToaAnID
                                                                        and s.PHONGBANID = vPhongbanID
                                                                        and   INSTR(','||vLoaiSO||',',','||s.MASO||',') > 0
                                                                        and ','||arrDonid||',' like  '%,'||sd.donid||',%'
                                                                        and lower(s.SOVB) = lower(v_SOTOTRINH)
                                                                        and s.NGAYVB = to_date(v_NGAYTOTRINH,'dd/MM/yyyy') 
                                                                        and s.trangthai = 1
                                                                         and d.thamphanid is not null);

END GET_THAMPHAN;

FUNCTION CHECK_SOTOTRINH_DON
( 
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2,
    vMASO in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN


      select /*PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_DON (Lay danh sach TP trong to trinh)*/
             count(s.id) into V_COUNT  from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          left join GDTTT_DON D ON D.ID=SD.donid
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and upper(s.MASO)  = upper(vMASO)
                                            and sd.donid = vDonid
                                            AND (d.arr_don_id=0 or d.arr_don_id is null ) --28/08/2024
                                            ;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN V_COUNT;
        ELSE
            RETURN 0;
        END IF;
END CHECK_SOTOTRINH_DON;
FUNCTION CHECK_SOTOTRINH_DON_TLL
( 
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN


      select /*PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_DON (Lay danh sach TP trong to trinh)*/
             count(s.id) into V_COUNT  from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          LEFT JOIN GDTTT_DON D on d.id=sd.donid
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and upper(s.MASO)  = 'SOTT_TLL'
                                            and sd.donid = vDonid
                                            AND (d.arr_don_id!=0) -- and d.ISTHULY=1 thu ly lai 27/08/2024
                                            ;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN V_COUNT;
        ELSE
            RETURN 0;
        END IF;
END CHECK_SOTOTRINH_DON_TLL;
FUNCTION CHECK_SOVB_DON
(  
    V_MASO in varchar2,
    vToaAnID in number,
    vPhongbanID in number,
    vDonid in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
      select /*PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_DON (Lay danh sach TP trong to trinh)*/
             count(s.id) into V_COUNT  from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and upper(s.MASO)  = upper(V_MASO)
                                            and sd.donid = vDonid
                                            ;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN V_COUNT;
        ELSE
            RETURN 0;
        END IF;        
END CHECK_SOVB_DON;

PROCEDURE GET_SOTOTRINH_SOVB
(  
   vToaAnID in number,
    vPhongbanID in number,
    vLoaiso   in varchar2,
    vSOVB in varchar2,
    vYear in number,
    curReturn OUT sys_refcursor
)
IS 
BEGIN


      OPEN curReturn FOR  /*PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_SOVB*/
            select s.*  from  QUANLY_SOPHATHANH s 
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and s.MASO  = vLoaiso
                                            and s.SOVB = vSOVB
                                            and s.NGAYVB between TO_DATE(Cast((vYear) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vYear) as varchar2(4))||'-12-31','YYYY-MM-DD')
                                           ;

END GET_SOTOTRINH_SOVB;

PROCEDURE GET_SOTOTRINH_DON
(  
    vToaAnID in number,
    vPhongbanID in number,
    arrDonid in varchar2,    
    curReturn OUT sys_refcursor
)
IS 
BEGIN


      OPEN curReturn FOR /*PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_DON*/
            select s.SOVB, s.NGAYVB from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and upper(s.MASO) in ('SOTT','SOTTXX','SOTT_TLL')
                                            and ','||arrDonid||',' like  '%,'||sd.donid||',%'
                                            group by s.SOVB, s.NGAYVB,s.MASO;

END GET_SOTOTRINH_DON;

PROCEDURE GET_TBTP_SOVANBAN
(  
   vToaAnID in number,
    vPhongbanID in number,
    vMASO in varchar2,
    vThamphanid in number,
    vDonid in varchar2,
    curReturn OUT sys_refcursor
)
IS 
BEGIN
 
   
      OPEN curReturn FOR /*PKG_GDTTT_HCTP_APP.GET_TBTP_SOVANBAN */
            select s.SOVB, to_char(s.NGAYVB,'dd/MM/yyyy') NGAYVB, s.NGUOIKY,s.CHUCVU from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and s.THAMPHANID = vThamphanid
                                            and upper(s.MASO)  = upper(vMASO)
                                            and sd.donid = vDonid
                                            group by s.SOVB, s.NGAYVB, s.NGUOIKY,s.CHUCVU;
        
END GET_TBTP_SOVANBAN;

PROCEDURE GET_DON_SOVANBAN
(  
   vToaAnID in number,
    vPhongbanID in number,
    vMASO in varchar2,
    vDonid in varchar2,
    curReturn OUT sys_refcursor
)
IS 
BEGIN

      OPEN curReturn FOR /*PKG_GDTTT_HCTP_APP.GET_DON_SOVANBAN */
            select s.SOVB, to_char(s.NGAYVB,'dd/MM/yyyy') NGAYVB, NGUOIKY from  QUANLY_SOPHATHANH s 
                                          left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID 
                                          where  s.TOAANID=vToaAnID
                                            and s.PHONGBANID = vPhongbanID
                                            and s.trangthai = 1
                                            and upper(s.MASO)  = upper(vMASO)
                                            and sd.donid = vDonid
                                            group by s.SOVB, s.NGAYVB, NGUOIKY;

END GET_DON_SOVANBAN;




PROCEDURE QUANLYSOVB_HCTP
( 
    vToaAnID in number,
    vPhongbanID in number,
    vISDONVI in number,
    vUSERID in varchar2,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    vLoaiAn in number,
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
  
    IF vLoaiSO = 'YCBS' THEN
        OPEN curReturn FOR
          select /*+ result_cache *//*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ văn ban hctp ycbs)*/
                a.*
                from ( Select ROW_NUMBER() OVER (ORDER BY b.NGAYTHONGBAO desc ,b.SOTHONGBAO desc) STT, 
                                   (SELECT COUNT(*)TONG_SODON  FROM GDTTT_DON tg 
                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                        AS soluongdon,
                                    (SELECT LISTAGG(TO_CHAR(tg.ID), ',') WITHIN GROUP (ORDER BY tg.ARR_DON_ID DESC) arrDonID  FROM GDTTT_DON tg 
                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                        AS ARR_DON_IDS,
                                    COUNT(*) OVER () as CountAll, 
                                    'Người gửi:'||d.DONGKHIEUNAI ||'<br>'
                                    ||' '|| d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN  ||'<br>'
                                    ||'Ngày nhận đơn:'|| TO_CHAR(d.NGAYNHANDON,'dd/MM/yyyy') ||'<br>'
                                    ||'Ngày trên đơn:'|| TO_CHAR(d.NGAYGHITRENDON,'dd/MM/yyyy') ||'<br>'
                                        AS infordon,
                                   b.id,lvb.ma AS MASO,lvb.TEN AS TENSO,
                                   b.SOTHONGBAO AS SOVB,to_char(b.NGAYTHONGBAO,'dd/MM/yyyy') NGAYVB,b.NGUOIKY,
                                      '<b>Lý do:</b><br>'  ||DECODE(b.CD_TA_LYDO_ISBAQD, 1, 'Bản án, quyết định<br>', '' ) 
                                        || DECODE(b.CD_TA_LYDO_ISXACNHAN, 1, 'Xác nhận<br>', '' )
                                        || DECODE(b.CD_TA_LYDO_ISKHAC, 1, 'Lý do khác: ' || b.NOIDUNG, '<br>' )
                                        ||  DECODE(TO_CHAR(b.NGAYBOSUNG,'dd/MM/yyyy'), '01/01/0001', '','Đã bổ sung lần' || b.LANTHU || '<br>ngày:' || TO_CHAR(b.NGAYBOSUNG,'dd/MM/yyyy'))
                                        trangthai, 'SODON' TYPESO, b.NGAYTAO,b.NGUOITAO,null NGUOISUA,null NGAYSUA

                           From GDTTT_DON_YEUCAU_BOSUNG b
                                LEFT JOIN GDTTT_DON d on b.DONID= d.id
                                left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
                                left join DM_DATAITEM lvb on lvb.ma = vLoaiSO and lvb.HIEULUC=1
                                                    
                            WHERE
                                D.TOAANID=vToaAnID
                                --and d.CD_TA_TRANGTHAI  in (0,1) --Du dieu kien / chua du dieu kien
                                and (vSoVB is null or lower(b.SOTHONGBAO)=lower(vSoVB))
                                and b.NGAYTHONGBAO between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS') 
                                and (vLoaiAn = 0 Or d.BAQD_LOAIAN = vLoaian)
                    ) a         
             where a.stt>=MinIndex and a.stt<=MaxIndex ;
    
    ELSIF vLoaiSO = 'SOTHULY' THEN
         OPEN curReturn FOR
           select /*+ result_cache *//*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ thu ly)*/
                        a.*
                            from (SELECT  ROW_NUMBER() OVER (ORDER BY b.TL_NGAY desc ,b.TL_SO desc) STT,COUNT(b.id) OVER () as CountAll, b.*
                                            from (SELECT d.TL_SO,d.TL_NGAY, 
                                                   (SELECT COUNT(*)TONG_SODON  FROM GDTTT_DON tg 
                                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                                        AS soluongdon
                                                    ,(SELECT LISTAGG(TO_CHAR(tg.ID), ',') WITHIN GROUP (ORDER BY tg.ARR_DON_ID DESC) arrDonID  FROM GDTTT_DON tg 
                                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                                        AS ARR_DON_IDS
                                                   ,To_char('Người gửi:'||d.DONGKHIEUNAI ||'<br>'
                                                    ||' '|| d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN  ||'<br>'
                                                    ||'Ngày nhận đơn:'|| TO_CHAR(d.NGAYNHANDON,'dd/MM/yyyy') ||'<br>'
                                                    ||'Ngày trên đơn:'|| TO_CHAR(d.NGAYGHITRENDON,'dd/MM/yyyy') ||'<br>')
                                                        AS infordon
                                                   ,Decode(NVL(d.cd_trangthai,0),0,'Chưa chuyển','Đã chuyển') trangthai, 'SODON' TYPESO
                                                   ,d.id
                                                   ,'SOTHULY' AS MASO
                                                   ,'Đơn Thụ lý mới <br> <b> án '|| Decode(d.BAQD_LOAIAN,1,'Hình sự',2,'Dân sự',3,'Hôn nhân',4,'KDTM',5,'Lao động',6,'Hành chính',7,'Phá sản') ||'</b>'  AS TENSO
                                                   ,d.TL_SO AS SOVB
                                                   ,to_char(d.TL_NGAY,'dd/MM/yyyy') NGAYVB
                                                   ,'' NGUOIKY
                                                   ,d.NGAYTAO
                                                   ,d.NGUOITAO
                                                   ,null NGUOISUA
                                                   ,null NGAYSUA
                    
                                               From GDTTT_DON d
                                                    left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID                                
                                                                        
                                                WHERE
                                                    D.TOAANID=vToaAnID
                                                    and (vSoVB is null or lower(d.TL_SO)=lower(vSoVB))
                                                    and d.TL_NGAY between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS')
                                                    and (vLoaiAn = 0 Or d.BAQD_LOAIAN = vLoaian)
                                                    AND D.ISTHULY = 1   -- la don thu ly moi 
                                                    AND D.CD_TA_TRANGTHAI = 0 --Du dieu kien 
                                                    AND D.LOAIDON not in (4,8,10)
                                               UNION
                                                   SELECT  xtl.SOTHULY as TL_SO, xtl.NGAYTHULY TL_NGAY
                                                        ,1 as soluongdon,'0' as ARR_DON_IDS
                                                           ,To_char('Người gửi:'||json_value(xtl.THONGTINDON, '$.DONGKHIEUNAI') ||'<br>'
                                                            ||' '|| json_value(xtl.THONGTINDON, '$.NGUOIGUI_DIACHI') ||'<br>'
                                                            ||'Ngày nhận đơn:'|| decode(json_value(xtl.THONGTINDON, '$.NGAYNHANDON'),null,null,TO_CHAR(json_value(xtl.THONGTINDON, '$.NGAYNHANDON'))) ||'<br>'
                                                            ||'Ngày trên đơn:'|| decode(json_value(xtl.THONGTINDON, '$.NGAYGHITRENDON'),null,null,TO_CHAR(json_value(xtl.THONGTINDON, '$.NGAYGHITRENDON'))) ||'<br>'
                                                            ) AS infordon
                                                           ,Decode(NVL(json_value(xtl.THONGTINDON, '$.cd_trangthai'),0),0,'Chưa chuyển','Đã chuyển') trangthai, 'SODON' TYPESO
                                                           ,to_number( json_value(xtl.THONGTINDON, '$.ID')) as id
                                                           ,'SOTHULY' AS MASO
                                                           ,' Xóa Sổ Thụ lý <br>
                                                           Lý do:'||xtl.ghichu||' <br> 
                                                           <b> án '|| Decode(json_value(xtl.THONGTINDON, '$.BAQD_LOAIAN') ,1,'Hình sự',2,'Dân sự',3,'Hôn nhân',4,'KDTM',5,'Lao động',6,'Hành chính',7,'Phá sản') ||'</b>'  AS TENSO
                                                           ,xtl.SOTHULY AS SOVB
                                                           ,to_char(xtl.NGAYTHULY,'dd/MM/yyyy') NGAYVB
                                                           ,'' NGUOIKY
                                                          ,xtl.NGAYXOA as NGAYTAO
                                                          ,xtl.NGUOIXOA as NGUOITAO
                                                           ,null NGUOISUA,null NGAYSUA
                                                   
                                                   FROM GDTTT_DON_XOATL xtl 
                                                        WHERE 
                                                        xtl.TOAANID = vToaAnID 
                                                        and (vSoVB is null or lower(xtl.SOTHULY)=lower(vSoVB))
                                                        and xtl.NGAYTHULY between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS') 
                                                        and (vLoaiAn = 0 Or xtl.LOAIAN = vLoaian)
                                                        AND xtl.LOAIDON not in (4,8,10)
                                        )b  
                            ) a         
                     where a.stt>=MinIndex and a.stt<=MaxIndex ;
     ELSIF vLoaiSO = 'SOTHULYXX' THEN
        OPEN curReturn FOR
          select /*+ result_cache *//*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ thu ly xx)*/
                a.*
                            from (SELECT  ROW_NUMBER() OVER (ORDER BY b.TL_NGAY desc ,b.TL_SO desc) STT,COUNT(b.id) OVER () as CountAll, b.*
                                            from (SELECT d.TL_SO,d.TL_NGAY, 
                                                   (SELECT COUNT(*)TONG_SODON  FROM GDTTT_DON tg 
                                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                                        AS soluongdon
                                                    ,(SELECT LISTAGG(TO_CHAR(tg.ID), ',') WITHIN GROUP (ORDER BY tg.ARR_DON_ID DESC) arrDonID  FROM GDTTT_DON tg 
                                                                    where tg.ID = d.id or (tg.CD_TA_TRANGTHAI  in (2,3) and  tg.ARR_DON_ID= d.id )) 
                                                        AS ARR_DON_IDS
                                                   ,to_char('<b>Hồ sơ kháng nghị:</b> '||d.NGUOIGUI_HOTEN ||'<br>'
                                                    ||' '|| d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN  ||'<br>'
                                                    ||'Ngày nhận đơn:'|| TO_CHAR(d.NGAYNHANDON,'dd/MM/yyyy') ||'<br>'
                                                    ||'Ngày trên đơn:'|| TO_CHAR(d.NGAYGHITRENDON,'dd/MM/yyyy') ||'<br>')
                                                        AS infordon
                                                   ,Decode(NVL(d.cd_trangthai,0),0,'Chưa chuyển','Đã chuyển') trangthai, 'SODON' TYPESO
                                                   ,d.id
                                                   ,'SOTHULY' AS MASO
                                                   ,'Thụ lý xét xử GDTT <br> <b> án '|| Decode(d.BAQD_LOAIAN,1,'Hình sự',2,'Dân sự',3,'Hôn nhân',4,'KDTM',5,'Lao động',6,'Hành chính',7,'Phá sản') ||'</b>'  AS TENSO
                                                   ,d.TL_SO AS SOVB
                                                   ,to_char(d.TL_NGAY,'dd/MM/yyyy') NGAYVB
                                                   ,'' NGUOIKY
                                                   ,d.NGAYTAO
                                                   ,d.NGUOITAO
                                                   ,null NGUOISUA
                                                   ,null NGAYSUA
                    
                                               From GDTTT_DON d
                                                    left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID                                
                                                                        
                                                WHERE
                                                    D.TOAANID=vToaAnID
                                                    and (vSoVB is null or lower(d.TL_SO)=lower(vSoVB))
                                                    and d.TL_NGAY between to_Date(vNgayVB,'dd/MM/yyyy') and to_Date(vNgayVB_den,'dd/MM/yyyy') 
                                                    and (vLoaiAn = 0 Or d.BAQD_LOAIAN = vLoaian)
                                                    AND D.ISTHULY = 1   -- la don thu ly moi 
                                                    AND D.CD_TA_TRANGTHAI = 0 --Du dieu kien 
                                                    AND D.LOAIDON  in (4)
                                               UNION
                                                   SELECT  xtl.SOTHULY as TL_SO, xtl.NGAYTHULY TL_NGAY
                                                        ,1 as soluongdon,'0' as ARR_DON_IDS
                                                           ,To_char('<b>Hồ sơ kháng nghị:</b>'||json_value(xtl.THONGTINDON, '$.NGUOIGUI_HOTEN') ||'<br>'
                                                            ||' '|| json_value(xtl.THONGTINDON, '$.NGUOIGUI_DIACHI') ||'<br>'
                                                            ||'Ngày nhận đơn:'|| decode(json_value(xtl.THONGTINDON, '$.NGAYNHANDON'),null,null,TO_CHAR(json_value(xtl.THONGTINDON, '$.NGAYNHANDON'))) ||'<br>'
                                                            ||'Ngày trên đơn:'|| decode(json_value(xtl.THONGTINDON, '$.NGAYGHITRENDON'),null,null,TO_CHAR(json_value(xtl.THONGTINDON, '$.NGAYGHITRENDON'))) ||'<br>'
                                                            ) AS infordon
                                                           ,Decode(NVL(json_value(xtl.THONGTINDON, '$.cd_trangthai'),0),0,'Chưa chuyển','Đã chuyển') trangthai, 'SODON' TYPESO
                                                           ,to_number( json_value(xtl.THONGTINDON, '$.ID')) as id
                                                           ,'SOTHULY' AS MASO
                                                           ,' Xóa Sổ Thụ lý xét xử GDT <br> 
                                                            Lý do:'||xtl.ghichu||' <br> 
                                                            <b> án '|| Decode(json_value(xtl.THONGTINDON, '$.BAQD_LOAIAN') ,1,'Hình sự',2,'Dân sự',3,'Hôn nhân',4,'KDTM',5,'Lao động',6,'Hành chính',7,'Phá sản') ||'</b>'  AS TENSO
                                                           ,xtl.SOTHULY AS SOVB
                                                           ,to_char(xtl.NGAYTHULY,'dd/MM/yyyy') NGAYVB
                                                           ,'' NGUOIKY
                                                          ,xtl.NGAYXOA as NGAYTAO
                                                          ,xtl.NGUOIXOA as NGUOITAO
                                                           ,null NGUOISUA,null NGAYSUA
                                                   
                                                   FROM GDTTT_DON_XOATL xtl 
                                                        WHERE 
                                                        xtl.TOAANID = vToaAnID 
                                                        and (vSoVB is null or lower(xtl.SOTHULY)=lower(vSoVB))
                                                        and xtl.NGAYTHULY between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS') 
                                                        and (vLoaiAn = 0 Or xtl.LOAIAN = vLoaian)
                                                        AND xtl.LOAIDON in (4)
                                        )b  
                            ) a     
             where a.stt>=MinIndex and a.stt<=MaxIndex ;    
    
    ELSE 
        IF vLoaiSO = 'TBTP' or vLoaiSO = 'SoTT' THEN
            OPEN curReturn FOR
                select /*+ result_cache *//*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ văn ban hctp cc)*/
                    a.*
                    from (SELECT ROW_NUMBER() OVER (ORDER BY data.NGAYVB desc, data.SOVB desc) STT, COUNT(*) OVER () as CountAll, data.*
                          FROM (SELECT svb.id, NULL SOPHATHANH_VUAN_ID, NULL MAVUAN, svb.MASO, lvb.TEN AS TENSO, svb.SOVB, to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB, svb.NGUOIKY,
                                   Decode(svb.ISDONVI,1,Decode(NVL(tt.trangthai,0),0,'Chưa chuyển','Đã chuyển'),0,Decode(NVL(tptt.trangthai,0),0,'Chưa chuyển','Đã chuyển')) trangthai, 'SODON' TYPESO,
                                   svb.NGAYTAO, svb.NGUOITAO, svb.NGUOISUA, svb.NGAYSUA, null infordon, svb.ISDONVI, svb.TOAANID, svb.PHONGBANID, svb.THAMPHANID, sd.soluongdon, sd.ARR_DON_IDS
                                from QUANLY_SOPHATHANH svb
                                left join (select SOPHATHANH_ID,count(*) soluongdon , RTRIM(XMLAGG(XMLELEMENT(e, donID || ',') ORDER BY donID).EXTRACT('//text()').getClobVal(), ',') as ARR_DON_IDS
                                            from SOPHATHANH_DON group by SOPHATHANH_ID
                                           ) sd on svb.id = sd.SOPHATHANH_ID 
                                left join DM_DATAITEM lvb on lvb.ma = svb.MASO and lvb.HIEULUC=1
                                inner join DM_DATAGROUP g on g.ID=lvb.GROUPID and ((svb.TOAANID = 1 and svb.PHONGBANID = 1 and g.MA= 'QLSO_HCTP_TC')
                                                                                            OR (svb.TOAANID = 1 and svb.PHONGBANID = 102  and g.MA = 'QLSO_THAMPHAN')
                                                                                            OR (svb.TOAANID != 1 and g.MA = 'QLSO'))
                                left join (Select dvb.SOPHATHANH_ID,count(d.ID) trangthai
                                            From SOPHATHANH_DON dvb left join GDTTT_DON d on dvb.DONID = d.id Where d.CD_TRANGTHAI in (1,2) group by dvb.SOPHATHANH_ID
                                            ) tt on svb.id = tt.SOPHATHANH_ID
                                left join (Select dvb.SOPHATHANH_ID,count(dc.ID) trangthai
                                            From SOPHATHANH_DON dvb left join GDTTT_DON_CHUYEN dc on dvb.DONID = dc.DONID Where dc.TRANGTHAI in (4) group by dvb.SOPHATHANH_ID
                                            ) tptt on svb.id = tptt.SOPHATHANH_ID 
                                WHERE svb.TOAANID = vToaAnID and svb.PHONGBANID = vPhongbanID and svb.ISDONVI = vISDONVI and (vUSERID is null or svb.THAMPHANID = vUSERID) 
                                    and svb.MASO = vLoaiSO and (vSoVB is null or vSoVB = '' or lower(svb.SOVB)=lower(vSoVB)) and svb.TRANGTHAI = 1
                                    and svb.NGAYVB between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS')                                
                                UNION ALL
                                SELECT svb.id, sd.ID as SOPHATHANH_VUAN_ID, sd.MAVUAN, svb.MASO, lvb.TEN AS TENSO, svb.SOVB, to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB, svb.NGUOIKY,
                                    Decode(svb.ISDONVI,1,Decode(NVL(tptt.trangthai,0),0,'Chưa chuyển','Đã chuyển') ) trangthai, 'SOVUAN' TYPESO,
                                    svb.NGAYTAO, svb.NGUOITAO, svb.NGUOISUA, svb.NGAYSUA, null infordon, 1 AS ISDONVI, svb.TOAANID, svb.PHONGBANID, svb.THAMPHANID, NULL soluongdon, NULL ARR_DON_IDS
                                from SOPHATHANH_vugiamdoc svb
                                left join (select sv.ID, sv.SOPHATHANH_ID, va.MAVUAN, count(*) soluongdon , LISTAGG(TO_CHAR(donID), ',')  WITHIN GROUP (ORDER BY donID desc) as ARR_DON_IDS
                                            from SOPHATHANH_VUAN sv join GDTTT_VUAN va on sv.VUANID = va.ID group by sv.ID, sv.SOPHATHANH_ID, va.MAVUAN
                                          ) sd on svb.id = sd.SOPHATHANH_ID
                                left join DM_DATAITEM lvb on lvb.ma = svb.MASO and lvb.HIEULUC=1
                                left join (Select dvb.SOPHATHANH_ID,count(dc.ID) trangthai 
                                            From SOPHATHANH_VUAN dvb
                                            left join GDTTT_VUAN_CHITIET_CHUYEN dc on dvb.VUANID = dc.VUANID
                                            Where  dc.TRANGTHAI not in (1, 2) group by dvb.SOPHATHANH_ID
                                           ) tptt on svb.id = tptt.SOPHATHANH_ID
                                WHERE svb.TOAANID=vToaAnID and svb.PHONGBANID = vPhongbanID and svb.ISDONVI = vISDONVI and (vUSERID is null or svb.THAMPHANID = vUSERID) 
                                    and svb.MASO = vLoaiSO and (vSoVB is null or vSoVB = '' or lower(svb.SOVB)=lower(vSoVB)) and svb.TRANGTHAI = 1
                                    and svb.NGAYVB between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS')                                
                            ) data
                        ) a         
                where a.stt>=MinIndex and a.stt<=MaxIndex ;
        ELSE
            OPEN curReturn FOR
                select /*+ result_cache *//*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ văn ban hctp cc)*/
                    a.*
                    from (Select ROW_NUMBER() OVER (ORDER BY svb.NGAYVB desc ,svb.SOVB desc) STT, sd.soluongdon,sd.ARR_DON_IDS, COUNT(*) OVER () as CountAll, 
                                   svb.id, svb.MASO,lvb.TEN AS TENSO,svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB,svb.NGUOIKY,
                                   Decode(svb.ISDONVI,1,Decode(NVL(tt.trangthai,0),0,'Chưa chuyển','Đã chuyển'),0,Decode(NVL(tptt.trangthai,0),0,'Chưa chuyển','Đã chuyển')) trangthai, 'SODON' TYPESO,
                                   svb.NGAYTAO,svb.NGUOITAO,svb.NGUOISUA,svb.NGAYSUA,null infordon
                            from QUANLY_SOPHATHANH svb
                            -- phai sưa lai do dữ lieu qua nhieu
                            left join (select SOPHATHANH_ID,count(*) soluongdon , RTRIM(XMLAGG(XMLELEMENT(e, donID || ',') ORDER BY donID).EXTRACT('//text()').getClobVal(), ',') as ARR_DON_IDS
                                        from SOPHATHANH_DON group by SOPHATHANH_ID
                                       ) sd on svb.id = sd.SOPHATHANH_ID 
                            left join DM_DATAITEM lvb on lvb.ma = svb.MASO and lvb.HIEULUC=1
                            inner join DM_DATAGROUP g on g.ID=lvb.GROUPID and ((svb.TOAANID = 1 and svb.PHONGBANID = 1 and g.MA= 'QLSO_HCTP_TC')
                                                                                        OR (svb.TOAANID = 1 and svb.PHONGBANID = 102  and g.MA = 'QLSO_THAMPHAN')
                                                                                        OR (svb.TOAANID != 1 and g.MA = 'QLSO'))
                            left join (Select dvb.SOPHATHANH_ID,count(d.ID) trangthai 
                                        From SOPHATHANH_DON dvb 
                                        left join GDTTT_DON d on dvb.DONID = d.id
                                        Where d.CD_TRANGTHAI in (1,2)
                                        group by dvb.SOPHATHANH_ID
                                        ) tt on svb.id = tt.SOPHATHANH_ID
                            left join (Select dvb.SOPHATHANH_ID,count(dc.ID) trangthai 
                                        From SOPHATHANH_DON dvb 
                                        left join GDTTT_DON_CHUYEN dc on dvb.DONID = dc.DONID
                                        Where dc.TRANGTHAI in (4)
                                        group by dvb.SOPHATHANH_ID
                                        ) tptt on svb.id = tptt.SOPHATHANH_ID                                                          
                            where svb.TOAANID=vToaAnID and svb.PHONGBANID = vPhongbanID and svb.ISDONVI = vISDONVI and (vUSERID is null or svb.THAMPHANID = vUSERID)
                                and svb.MASO  = vLoaiSO and (vSoVB is null or vSoVB = '' or lower(svb.SOVB)=lower(vSoVB)) and svb.TRANGTHAI = 1
                                and svb.NGAYVB between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS')
                        ) a         
                where a.stt>=MinIndex and a.stt<=MaxIndex ;
        END IF;
    END IF;
END QUANLYSOVB_HCTP;

PROCEDURE DON_CVCHUYEN_CHECK
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
)
IS 
vY number;
BEGIN

OPEN curReturn FOR  
  Select count(d.ID) vcheck
  From SOPHATHANH_DON dvb
  left join QUANLY_SOPHATHANH vb on vb.id = dvb.SOPHATHANH_ID
  left join GDTTT_DON d on dvb.DONID = d.id
  Where dvb.SOPHATHANH_ID=vSOPHATHANH_ID
        and  ((vb.ISDONVI = 1 and d.CD_TRANGTHAI in (1,2)) -- don đã chuyen hoac đã nhận cua don vi
                OR 
                --Don cua Tham phan khi đã chuyển các vụ không duoc xóa
                (vb.ISDONVI = 0 and Exists (select 'X' from GDTTT_DON_CHUYEN dc where dc.donid = dvb.donid and dc.TRANGTHAI = 4)) 
                )
        and dvb.TRANGTHAI = 1
        --select  decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển') from GDTTT_DON_CHUYEN
        ;
END DON_CVCHUYEN_CHECK;


FUNCTION SOVANBAN_INSERT
(  
    v_ToaAnID in number,
    v_PhongbanID in number,
    v_ISDONVI in number,
    v_ThamphanID IN VARCHAR2,
    v_MASO   IN VARCHAR2,
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
SAVEPOINT P1;     
        vPHATHANHID:= QUANLY_SOPHATHANH_SEQ.NEXTVAL;
        --1.INNSERT SOPHATHANH
        INSERT INTO QUANLY_SOPHATHANH (ID,TOAANID,PHONGBANID,ISDONVI,ThamphanID,MASO,SOVB,NGAYVB
                                        ,NGUOIKY,CHUCVU,NGUOITAO,NGAYTAO)
                            VALUES (vPHATHANHID,v_ToaAnID,v_PhongbanID,v_ISDONVI,v_ThamphanID,v_MASO,v_SOVB,to_date(v_NGAYVB,'dd/MM/yyyy')
                                        ,v_NGUOIKY,v_CHUCVU,V_NGUOITAO,SYSDATE);
       RETURN vPHATHANHID;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_INSERT;


FUNCTION SOPHATHANH_DON_INSERT
(  
    v_PHATHANHID IN NUMBER,
    v_DONID     IN NUMBER,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER AS
BEGIN
SAVEPOINT P1;     
            --2.INSERT SOPHATHANH_DON
           Insert Into SOPHATHANH_DON (ID,SOPHATHANH_ID,DONID,NGUOITAO,NGAYTAO)
                                    VALUES (SOPHATHANH_DON_SEQ.nextval,v_PHATHANHID,v_DONID,V_NGUOITAO,SYSDATE);

           RETURN 1;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOPHATHANH_DON_INSERT;

FUNCTION SOVANBAN_UPDATE
(  
    v_SOPHATHANH_ID in number, 
   -- v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER AS
    vMaSo varchar2(50);
BEGIN
    SAVEPOINT P1;
    --Update--------
    UPDATE QUANLY_SOPHATHANH 
                SET 
                --SOVB = v_SOVB, 
                NGAYVB = to_date(v_NGAYVB,'dd/MM/yyyy'),
                NGUOIKY  = v_NGUOIKY,
                CHUCVU   = v_CHUCVU,
                NGUOISUA = V_NGUOISUA,
                NGAYSUA  = SYSDATE
                WHERE ID = v_SOPHATHANH_ID;
                
     -----Update ngay tren don-----------           
--        select s.MASO into vMaSo from  QUANLY_SOPHATHANH s where s.id = v_SOPHATHANH_ID;
--        if (vMaSo = 'SoTT' OR vMaSo = 'SoTT_TLL') then
--            Update GDTTT_DON SET CD_NGAYTOTRINH = to_date(v_NGAYVB,'dd/MM/yyyy'),
--                     CD_NGUOIKY = v_NGUOIKY 
--                    WHERE ID IN (SELECT sd.DONID FROM SOPHATHANH_DON sd where sd.SOPHATHANH_ID = v_SOPHATHANH_ID);
--        elsif (vMaSo = 'SoCVC' OR vMaSo = 'SoCVCN' OR vMaSo = 'SoCVCTK' OR vMaSo = 'SoTralaidon') then
--            Update GDTTT_DON SET CD_NGAYCV = to_date(v_NGAYVB,'dd/MM/yyyy'), CD_NGUOIKY = v_NGUOIKY 
--                WHERE ID IN (SELECT sd.DONID FROM SOPHATHANH_DON sd where sd.SOPHATHANH_ID = v_SOPHATHANH_ID);
--        end if;        
     
        RETURN 1;
        
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_UPDATE;

FUNCTION SOVANBAN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER AS
 vMaSo varchar2(50);
BEGIN

    SAVEPOINT P1;
    --Xoa So van ban khoi Don
     select s.MASO into vMaSo from  QUANLY_SOPHATHANH s where s.id = v_SOPHATHANH_ID;
    if (vMaSo = 'SoTT' OR vMaSo = 'SoTT_TLL') then
        Update GDTTT_DON SET CD_SOTOTRINH = NULL,CD_NGAYTOTRINH = NULL,CD_NGUOIKY = NULL 
                WHERE ID IN (SELECT sd.DONID FROM SOPHATHANH_DON sd where sd.SOPHATHANH_ID = v_SOPHATHANH_ID);
    elsif (vMaSo = 'SoCVC' OR vMaSo = 'SoCVCN' OR vMaSo = 'SoCVCTK' OR vMaSo = 'SoTralaidon') then
        Update GDTTT_DON SET CD_SOCV = NULL,CD_NGAYCV = NULL,CD_NGUOIKY = NULL 
            WHERE ID IN (SELECT sd.DONID FROM SOPHATHANH_DON sd where sd.SOPHATHANH_ID = v_SOPHATHANH_ID);
    end if;        

   --Xoa So van ban khoi Sổ Văn Đơn
    DELETE SOPHATHANH_DON WHERE SOPHATHANH_ID = v_SOPHATHANH_ID;
    ---Xoa So van ban 
    DELETE QUANLY_SOPHATHANH WHERE ID = v_SOPHATHANH_ID;
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_DEL_ALL;

FUNCTION SOVANBAN_DEL_ONE
(   v_DON_ID  in number,
    v_SOPHATHANH_ID in number
)RETURN NUMBER AS
 vMaSo varchar2(50);
BEGIN
    --Xoa Don khoi Sổ Văn Đơn
    SAVEPOINT P1;
    select s.MASO into vMaSo from  QUANLY_SOPHATHANH s 
                left join SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
                where sd.DONID = v_DON_ID ;

    DELETE SOPHATHANH_DON WHERE DONID = v_DON_ID and SOPHATHANH_ID = v_SOPHATHANH_ID ;
    ---------------------
    if (vMaSo = 'SoTT' OR vMaSo = 'SoTT_TLL') then
        Update GDTTT_DON SET CD_SOTOTRINH = NULL,CD_NGAYTOTRINH = NULL,CD_NGUOIKY = NULL 
                WHERE ID = v_DON_ID;
    elsif (vMaSo = 'SoCVC' OR vMaSo = 'SoCVCN' OR vMaSo = 'SoCVCTK' OR vMaSo = 'SoTralaidon') then
        Update GDTTT_DON SET CD_SOCV = NULL,CD_NGAYCV = NULL,CD_NGUOIKY = NULL 
                WHERE ID = v_DON_ID;
    end if; 

    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_DEL_ONE;
FUNCTION SOVANBAN_XOATHEO_MA
(   V_DON_ID  in number,
    V_MASO in varchar2
)RETURN NUMBER AS
BEGIN
    -- 20/09/2024 xoa don khoi so quan ly so
    SAVEPOINT P1;
    DELETE SOPHATHANH_DON D WHERE D.DONID = V_DON_ID 
    AND EXISTS(SELECT 'X' FROM QUANLY_SOPHATHANH qs WHERE INSTR(','||V_MASO||',',','||qs.MASO||',')>0 AND D.SOPHATHANH_ID=qs.ID);
    --------------------
    if(INSTR(','||V_MASO||',',',SoTT_TLL,')>0) then
        Update GDTTT_DON SET CD_SOTOTRINH = NULL,CD_NGAYTOTRINH = NULL,CD_NGUOIKY = NULL 
                WHERE ID = V_DON_ID;
    END IF; 
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_XOATHEO_MA;


PROCEDURE SUAVANBAN_SEARCH
( 
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select /*PKG_GDTTT_HCTP_APP.SUACONGVAN_SEARCH (Sua Cong Van)*/ ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,
      Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
      d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO
      ,svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB ,svb.NGUOIKY || '-'||svb.Chucvu  NGUOIKY
      ,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(d.ToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET  
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

         ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          ) arrCongvan

        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,5)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 5, 'Đang giải quyết'
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
                                    ) end   
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
              ,lvb.ten TenSOVB,svb.MASO MaSOVB
              --,svb.SOVB GXNSO,svb.NGAYVB GXNNGAY, decode (svb.SOVB,null,'none','block') IsGXN
              ,'' GXNSO,'' GXNNGAY,'none' IsGXN
    from SOPHATHANH_DON dvb
        --left join QUANLY_SOPHATHANH svb on svb.id = dvb.SOPHATHANH_ID and svb.maso = 'SoGXN'
--        LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
--                                    left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
--                                    where so.maso = 'SoGXN')sph on sph.donid = d.id
        left join QUANLY_SOPHATHANH svb on svb.id = dvb.SOPHATHANH_ID
        left join DM_DATAITEM lvb on lvb.ma = svb.MASO and ((svb.TOAANID = 1 and lvb.ma = 'QLSO_HCTP_TC') OR lvb.ma = 'QLSO')
        left join GDTTT_DON d on dvb.DONID = d.id
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
        left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV from GDTTT_VuAn) va on va.ID = d.VuViecID
     where dvb.SOPHATHANH_ID=vSOPHATHANH_ID
        and dvb.TRANGTHAI in (1)
        order by d.NGAYTAO desc
     ) a;


END SUAVANBAN_SEARCH;




PROCEDURE  DM_CANBO_GETBYDONVI_2CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || '-' || d.TEN as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2)) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  And a.HIEULUC=1
  order by d.ThuTu;
END DM_CANBO_GETBYDONVI_2CHUCVU;


PROCEDURE  DM_CANBO_GETBYDONVI_ARR_CHUCVU 
(
  vDonViID in number,
  vArrChucVu in varchar2, 
  vLoaiso  in varchar2, 
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || '-' || d.TEN as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS  
  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID 
                and '%,'||vArrChucVu||',%' like '%,'||c.MA||',%'
                ) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  and ((vLoaiso in ('SoTT','SoTTXX','SoTT_TLL','TBTP') and lower(d.TEN) = 'chánh văn phòng') 
        OR vLoaiso not in ('SoTT','SoTTXX','SoTT_TLL','TBTP')  and lower(d.TEN) != 'chánh văn phòng' )
  And a.HIEULUC=1
  order by d.TEN;
END DM_CANBO_GETBYDONVI_ARR_CHUCVU;


PROCEDURE CHECK_DONTRUNGID
( 
    V_ID in number,
    V_IS_DONTRUNG OUT number
)
IS 
     V_DONTRUNGID NUMBER;V_COUNT_DONTRUNG NUMBER;
BEGIN
   V_IS_DONTRUNG:=1;--ton tai trong group đơn gốc
   SELECT DONTRUNGID INTO V_DONTRUNGID  FROM GDTTT_DON D WHERE D.ID =V_ID;
   IF(V_DONTRUNGID IS NULL OR V_DONTRUNGID =0) THEN
       SELECT COUNT(*) INTO V_COUNT_DONTRUNG  FROM GDTTT_DON D WHERE D.DONTRUNGID =V_ID;
        IF(V_COUNT_DONTRUNG=0)THEN
        V_IS_DONTRUNG:=0;--không tồn tại trong group đơn gốc
        END IF;
   END IF;
END;
PROCEDURE CHECK_DONTRUNGID_ARR
( 
    V_ID in number,
    V_IS_ARR_DON_ID OUT number
)
IS 
     V_ARR_DON_ID NUMBER;V_COUNT_DONTRUNG NUMBER;
BEGIN
   V_IS_ARR_DON_ID:=1;--ton tai trong group đơn gốc
   SELECT ARR_DON_ID INTO V_ARR_DON_ID  FROM GDTTT_DON D WHERE D.ID =V_ID;
   IF(V_ARR_DON_ID IS NULL OR V_ARR_DON_ID =0) THEN
       SELECT COUNT(*) INTO V_COUNT_DONTRUNG  FROM GDTTT_DON D WHERE D.ARR_DON_ID =V_ID;
        IF(V_COUNT_DONTRUNG=0)THEN
        V_IS_ARR_DON_ID:=0;--không tồn tại trong group đơn gốc
        END IF;
   END IF;
END;
PROCEDURE CANBO_GETBYDONVI
( 
   v_CANBO_ID in varchar2,
   donviID in number,
   vChucDanh in varchar2,
   curReturn    OUT       sys_refcursor
)
IS 
    vGroupChucDanhID number;TOTAL_CHECK number;
    vChucvuid number;
BEGIN
    SELECT COUNT(*)INTO TOTAL_CHECK FROM DM_CANBO c 
    INNER JOIN (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=12 and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC'))d1 on d1.ID=c.CHUCDANHID
    WHERE C.ID=v_CANBO_ID;
    ------
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
    if(vChucDanh='TP') then
          Select c.chucvuid into vChucvuid from DM_CANBO c where c.id = v_CANBO_ID;
--    Nếu là PCA hoac CA thi phai lay them các Tham phan ma minh phu trach de cho tim kiem
        if (vChucvuid in (74,46)) THEN
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
                            WHere c.TOAANID=donviID AND (TOTAL_CHECK=0 OR (C.ID=v_CANBO_ID AND TOTAL_CHECK!=0))
                               -- manh them cả nguoi da nghi huu    
                              And (c.HIEULUC=1 or c.HIEULUC=0) 
                              --OR C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
                              AND (c.MADONGBO IS NOT NULL) --anhvh add 07/09/2020 chỉ lấy những cán bộ mà đồng bộ với pm cán bộ
                              and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                                  c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                        union 
                            Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
                              ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
                              ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
                                || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
                                || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
                                || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
                                From DM_CANBO c
                                 inner join DM_TOAAN t on c.TOAANID=t.ID
                                 inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
                                 left join (Select * from DM_CANBO where id = v_CANBO_ID) PCA on PCA.CHUCDANHID = c.CHUCDANHID
                                 left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
                                WHere c.TOAANID=donviID 
                                   -- manh them cả nguoi da nghi huu    
                                        and c.HIEULUC=1 and c.CHUCDANHID = 486 and c.chucvuid is null
                                        and (
                                                (c.ISHINHSU= PCA.ISHINHSU and c.ISHINHSU=1)
                                                Or (c.ISDANSU= PCA.ISDANSU and c.ISDANSU=1 )
                                                Or (c.ISHNGD=PCA.ISHNGD  and c.ISHNGD=1 )
                                                Or (c.ISKDTM=PCA.ISKDTM  and c.ISKDTM=1 )
                                                Or (c.ISLAODONG=PCA.ISLAODONG   and c.ISLAODONG=1 )
                                                Or (c.ISHANHCHINH=PCA.ISHANHCHINH  and c.ISHANHCHINH=1 ) 
                                                Or (c.ISPHASAN=PCA.ISPHASAN and c.ISPHASAN=1 ) 
                                                )
                                        and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                    ;

        ELSE
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
                WHere c.TOAANID=donviID AND (TOTAL_CHECK=0 OR (C.ID=v_CANBO_ID AND TOTAL_CHECK!=0))
                   -- manh them cả nguoi da nghi huu    
                  And (c.HIEULUC=1 or c.HIEULUC=0) 
                  --OR C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
                  AND (c.MADONGBO IS NOT NULL) --anhvh add 07/09/2020 chỉ lấy những cán bộ mà đồng bộ với pm cán bộ
                  and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                      c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                Order by c.Hoten;
        END IF;
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
--------------------------------------------------------------------
PROCEDURE SUACONGVAN_SEARCH
( 
    vToaAnID in number,
    vSoCongVan in varchar2,
    vNgayCongVan in varchar2,
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select /*PKG_GDTTT_HCTP_APP.SUACONGVAN_SEARCH (Sua Cong Van)*/ ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,to_char(d.CD_NGAYCV,'dd/MM/yyyy') CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
--      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else ('BA: ' || d.BAQD_SO) END) BAQD
--      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else d.BAQD_NGAYBA END) BAQD_NGAYBA
--      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET  
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

         ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          ) arrCongvan

        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,5)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 5, 'Đang giải quyết'
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
                                    ) end   
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
    from GDTTT_DON d
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID

        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
        left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV from GDTTT_VuAn) va on va.ID = d.VuViecID
     where (vSoCongVan is not null and lower(d.CD_SOCV)=lower(vSoCongVan))
        and d.TOAANID=vToaAnID
        and ((vNgayCongVan is null) or (vNgayCongVan is not null and  to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan))
        and d.CD_TRANGTHAI in (0,3)
        order by d.NGAYTAO desc
     ) a;


END SUACONGVAN_SEARCH;



PROCEDURE CANBO_GETBYDONVI_HDTP
(   donviID in number,
    vGroupChucDanhID in number,
	curReturn  OUT sys_refcursor
)
IS 

BEGIN

 OPEN curReturn FOR 
        Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
          ,(c.Hoten || ' - ' || decode(c.CHUCVUID,null,cd.TEN,cv.TEN)) as MA_TEN,t.TEN as TenDonVi,cd.TEN as TENCHUCDANH, cv.TEN as TENCHUCVU         
        From DM_CANBO c
         inner join DM_TOAAN t on c.TOAANID=t.ID
         inner join (select i.ID,i.TEN from DM_DATAITEM i where i.ID=vGroupChucDanhID) cd on cd.ID=c.CHUCDANHID--'TP','TPSC','TPTC','TPCC',
         left join DM_DATAITEM cv  on cv.ID=c.CHUCVUID
        WHere c.TOAANID=donviID
          And c.HIEULUC=1                       
        Order by c.CHUCVUID;

END CANBO_GETBYDONVI_HDTP;




PROCEDURE CANBO_GETBYDONVI_XX
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
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC')) d1 on d1.ID=c.CHUCDANHID--'TP','TPSC','TPTC','TPCC',
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                          c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
      AND C.TRANGTHAI_XETXU=1 --anhvh add 19/09/2020 chỉ lấy những thẩm phán đang xét xử                   
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
END CANBO_GETBYDONVI_XX;

PROCEDURE  GDTTT_VUAN_GETALLCBTHEOPB
(  vPhongBanID in number
, vToaAnID in number, vChucDanh in varchar2
,	curReturn    OUT       sys_refcursor
)
as
   vGroupChucDanhID number;
   vGroupChucVuID number;
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';  
   select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';

   ------------------------------------------------ 
 if(vChucDanh='TTV') then
    OPEN curReturn FOR 
     select a.ID, a.HoTen, a.HieuLuc
     from 
      ( (  Select c.ID, c.Hoten, 1 HieuLuc
            From DM_CANBO c
             inner join (select i.ID,i.TEN from DM_DATAITEM i 
                          where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC','TK1','TK','TKVC','C027','C010','C008','C009')
                        ) d1 on d1.ID=c.CHUCDANHID           
            WHere c.TOAANID=vToaAnID  and c.Phongbanid=vPhongBanID and c.HieuLuc=1   
         ) union 
         (
          select distinct a.ThamTraVienID ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc
            from GDTTT_VuAn a
              inner join (select Id, HoTen, PhongBanID from DM_CanBo
                          where NVL(HieuLuc,0)=0 or NVL(PhongBanID,0)<> vPhongBanID) b on a.ThamTraVienId = b.ID
            where NVL(a.ThamTraVienId, 0)>0
                and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
         )
      ) a order by a.HieuLuc desc,a.HoTen;
  elsif(vChucDanh='TP') then
    OPEN curReturn FOR 
       select a.ID, a.HoTen, a.HieuLuc
       from 
        ( ( Select c.ID,c.HoTen,1 HieuLuc From DM_CANBO c
             inner join (select i.ID, i.TEN from DM_DATAITEM i 
                         where i.GROUPID=vGroupChucDanhID 
                              and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')
                        ) d1 on d1.ID=c.CHUCDANHID    
             left join (select c.ID, c.TEN from DM_DATAITEM c 
                          where c.GROUPID=vGroupChucVuID  and c.Ma in ('CA', 'PCA')
                        ) d on d.ID=c.CHUCVUID    
              WHere c.TOAANID=vToaAnID  and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0 OR C.ID=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án                                   
              And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                  c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
              AND C.TRANGTHAI_XETXU=1 --anhvh add 19/09/2020 trang thai dang xet xử                    
           ) union 
           (
            select distinct a.ThamPhanID ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc 
            from GDTTT_VuAn a
                inner join (select Id, HoTen, PhongBanID from DM_CanBo
                            where NVL(HieuLuc,0)=0 or NVL(TOAANID,0)<> vToaAnID
                            ) b on a.ThamPhanID = b.ID
              where NVL(a.ThamPhanID, 0)>0
                  and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
           )
        ) a order by a.HieuLuc desc, a.HoTen;
    elsif(vChucDanh='LDV') then
    OPEN curReturn FOR 
       select a.ID, a.HoTen, a.HieuLuc
       from (
            ( Select c.ID,c.Hoten, 1 HieuLuc From DM_CANBO c
                  inner join (select i.ID,i.TEN from DM_DATAITEM i 
                              where i.GROUPID=vGroupChucVuID and (i.MA='PVT' or i.Ma='VT')
                             ) d1 on d1.ID=c.CHUCVUID    
              WHere c.TOAANID=vToaAnID and c.Phongbanid=vPhongBanID and c.HieuLuc=1
               and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
            )
            union 
           (
            select distinct a.LanhDaoVuId ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc
            from GDTTT_VuAn a
                inner join (select Id, HoTen, PhongBanID from DM_CanBo
                            where NVL(HieuLuc,0)=0 or NVL(PhongBanID,0)<> vPhongBanID) b on a.LanhDaoVuId = b.ID
              where NVL(a.LanhDaoVuId, 0)>0
                  and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
           )
       ) a order by a.HieuLuc desc, a.HoTen;
    end if;
end GDTTT_VuAn_GetAllCBTheoPB;
END PKG_GDTTT_HCTP_APP;

/
