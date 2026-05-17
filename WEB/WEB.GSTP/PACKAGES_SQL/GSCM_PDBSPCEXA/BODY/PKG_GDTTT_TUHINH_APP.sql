--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_TUHINH_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_TUHINH_APP" AS
PROCEDURE DELETE_GDTTT_TUHINH_DON
  (
    V_ID IN VARCHAR2 DEFAULT NULL,
    V_Dele out DECIMAL
  )
AS
    
  count_hs number;
  l_cVuan number;
BEGIN        
    -- kiểm tra xem bảng GDTTT_TUHINH_VUAN có nhập thông tin chưa, nếu chưa nhập thì xóa cả 2
    -- Nếu nhập rồi thì yêu cầu xóa hết thông tin ở bảng GDTTT_TUHINH_VUAN mới được xóa đơn

     select count(tva.id) into count_hs
        from GDTTT_TUHINH_DON d
             left join GDTTT_TUHINH_VUAN tva on d.DUONGSUID = tva.DUONGSU_ID and d.VUANID = tva.VUAN_ID
            where d.id = v_ID
                and tva.SOQD_CA is not null
                and (tva.DONID IS NULL OR tva.DONID = 0);
        if (count_hs = 0) then
             -- kiem tra xoa vu an truoc khi xoa bang GDTTT_TUHINH_VUAN
--            select count(*) into l_cVuan 
--                from gdttt_vuan v 
--                left join GDTTT_TUHINH_VUAN tv on v.id = tv.vuan_id
--                left join GDTTT_TUHINH_DON d on d.id = tv.DON_ID_VU
--                where d.id = V_ID and
--                (v.ISHOSO = 1 or EXISTS(select ID from GDTTT_TOTRINH tt where tt.VUANID = d.vuanid));
--            -- XOA BANG VU AN VA DUONG SU ID
--            if (l_cVuan = 0) then
--                DELETE GDTTT_VUAN_DUONGSU WHERE VUANID = (SELECT VUANID FROM GDTTT_TUHINH_DON WHERE ID = V_ID);
--                DELETE gdttt_vuan WHERE ID = (SELECT VUANID FROM GDTTT_TUHINH_DON WHERE ID = V_ID);     
--            end if;

            DELETE GDTTT_TUHINH_DON d WHERE d.id=v_ID;

            V_Dele :=1;
        else
            V_Dele :=0;
        end if;

END; 
PROCEDURE GDTTT_TUHINH_DON_GET_BY_ID
(
  v_ID        IN NUMBER,
  curReturn OUT sys_refcursor
)
AS
BEGIN 
  OPEN curReturn FOR
    SELECT d.*,tva.id hosoid FROM GDTTT_TUHINH_DON d
    left join GDTTT_TUHINH_VUAN tva on d.DUONGSUID = tva.DUONGSU_ID and d.VUANID = tva.VUAN_ID 
        WHERE d.id=v_ID; 
END;
PROCEDURE  GDTTT_TUHINH_DON_SEARCH
( 
  v_Loaidon in number,
  v_nguoinhan in number,
  v_loaingay    in number,
  v_tungay  in date,
  v_denngay in date,
  v_nguoigui in varchar2,
  v_diachi in varchar2,
  v_soba    in varchar2,
  v_ngayba  in date,
  v_toaxx   in number,
  PageIndex	in	number,
  PageSize	in	number,
  curReturn  OUT sys_refcursor
)
AS
    MinIndex	number;  MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR
   select a.* from (
            select  COUNT(*) OVER () as CountAll,d.ID,ROW_NUMBER() OVER (ORDER BY d.id) STT,
            (ds.TENDUONGSU ||' (năm sinh: '||ds.NAMSINH||')<br/> Tội danh: '||ds.HS_TENTOIDANH
                                         ||decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,'','01/01/0001','','<br/><b>BA/QĐ:'||v.SOANPHUCTHAM||' - '||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||'</b>')
                                         ||decode(to_char(v.ngayxusotham,'dd/MM/yyyy'),null,'','01/01/0001','','<br/><b>BAST:'||v.soansotham||' - '||to_char(v.ngayxusotham,'dd/MM/yyyy')||'</b>')) TENBIAN,
            d.NGUOIGUI||'<br/> Địa chỉ: '||d.NGUOIGUI_DIACHI||'<br/> Ngày trên đơn: '|| to_char(d.NGAYTRENDON,'dd/MM/yyyy') NGUOIGUI,
            DECODE(d.LOAI,1,'Xin ân giảm',2,'Xin ân giảm + kêu oan',3,'Xin thi hành án') LOAI,
            cb.HOTEN||'<br/> Ngày nhận đơn: '||to_char(d.NGAYNHAN,'dd/MM/yyyy') NGAYNHAN,
            SD.USERNAME||'<br/>'||to_char(d.NGAYTAO,'dd/MM/yyyy HH24:MI:SS') NGAYTAO,
            SD1.USERNAME||'<br/>'||to_char(d.NGAYSUA,'dd/MM/yyyy HH24:MI:SS') NGAYSUA 
            from GDTTT_TUHINH_DON d 
            LEFT JOIN DM_CANBO CB ON CB.ID=d.NGUOINHAN_ID
            LEFT JOIN QT_NGUOISUDUNG SD ON SD.ID=D.NGUOITAO_ID
            LEFT JOIN QT_NGUOISUDUNG SD1 ON SD1.ID=D.NGUOISUA_ID
            LEFT JOIN GDTTT_VUAN_DUONGSU ds ON ds.id = d.DUONGSUID   
            LEFT JOIN GDTTT_VUAN V ON v.id = d.vuanid

            where  (v_Loaidon = 0 or d.loai = v_Loaidon)
                and (v_nguoinhan = 0 or d.NGUOINHAN_ID = v_nguoinhan)
                and (v_tungay is null or d.NGAYNHAN>=v_tungay)
                and (v_denngay is null or d.NGAYNHAN <= v_denngay)
                and (v_nguoigui is null or d.NGUOIGUI like '%'||v_nguoigui||'%')
                and (v_diachi is null or d.NGUOIGUI_DIACHI like '%'||v_diachi||'%')
                and (v_soba is null or v.SOANPHUCTHAM like '%'||v_soba||'%' or v.SOANSOTHAM  like '%'||v_soba||'%' or  v.so_qdgdt  like '%'||v_soba||'%' )
                and (v_ngayba is null or v.NGAYXUPHUCTHAM = v_ngayba or v.NGAYXUSOTHAM = v_ngayba  or v.ngayqd = v_ngayba)
                and (v_toaxx = 0 or  v.TOAPHUCTHAMID = v_toaxx or  v.TOAANSOTHAM = v_toaxx or v.toaqdid = v_toaxx)

         )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTT_TUHINH_DON_SEARCH;


PROCEDURE  GDTTT_VUAN_GETALLDUONGSU
( 

  vVuanid      in number,
  vDuongsuid    in number,
  curReturn OUT sys_refcursor
)
AS 

BEGIN
   ----- 

   OPEN curReturn FOR 
       select   ds.ID,ds.TENDUONGSU, ds.GIOITINH, ds.diachi,ds.HS_TENTOIDANH,ds.hs_mucan,ds.vuanid,ds.NAMSINH
                    ,v.SOANPHUCTHAM, v.NGAYXUPHUCTHAM,v.TOAPHUCTHAMID
                    ,v.SOANSOTHAM, v.NGAYXUSOTHAM,v.TOAANSOTHAM
                  from  GDTTT_VUAN_DUONGSU ds
                    left join GDTTT_VUAN  v on ds.vuanid = v.id 
                    ---left join ( select id,tentoidanh from GDTTT_VUAN_DUONGSU_TOIDANH) td on td.id = ds.hs_toidanhid 
                  ---------- 
                    where   Loaian = 1   
                            and  ds.vuanid = vVuanid
                            and (vDuongsuid = 0 or ds.id = vDuongsuid)
                    order by ds.TENDUONGSU desc;             
END GDTTT_VUAN_GETALLDUONGSU;


PROCEDURE GDTTT_TUHINH_DON_INS_UP
(
  v_ID        IN NUMBER,
  V_VUANID    IN NUMBER,
  V_DUONGSUID IN NUMBER,
  v_hoso_id   IN NUMBER,
  V_NGUOIGUI    IN VARCHAR2,
  V_NGUOIGUI_DIACHI IN VARCHAR2,
  V_NGUOINHAN_ID IN NUMBER,
  V_NGAYTRENDON IN DATE ,
  V_NGAYNHAN IN DATE,
  V_LOAI IN NUMBER,
  V_NOIDUNG IN VARCHAR2,
  V_NGUOITAO_ID in number,
  V_NGUOITAO IN VARCHAR2,

  --thong tin ban an moi
  V_LOAIBA  IN NUMBER,
  V_SOANPHUCTHAM IN VARCHAR2,
  V_NGAYXUPHUCTHAM IN DATE ,
  V_TOAPHUCTHAMID IN NUMBER,
  V_SOANSOTHAM IN VARCHAR2,
  V_NGAYXUSOTHAM IN DATE ,
  V_TOAANSOTHAM IN NUMBER,
  --thong tin duong su moi
  V_HOTENBC   IN VARCHAR2,
  V_NAMSINH     IN NUMBER,
  V_DIACHI    IN VARCHAR2,
  V_TOIDANH_ID IN NUMBER,
  V_TENTOIDANH  IN VARCHAR2,
  --thong tin ttv và ldv
  V_NGAYPHANCONGTTV  IN DATE,
  V_THAMTRAVIENID  IN NUMBER,
  V_TENTHAMTRAVIEN  IN VARCHAR2,
  V_NgayNhanTieuHS  IN DATE,
  V_NgayNhanHS   IN DATE,
  V_LANHDAOVU  IN NUMBER,
  V_THAMPHAN  IN NUMBER
)
AS
  don_id number;
  vuan_id number;
  vduongsu_id number;
  v_ISXINANGIAM NUMBER;
  v_ishoso  NUMBER;
  l_history_ttv number;
  l_countHS number;
  vTENVUAN   varchar2(200);
  vTOIDANH  VARCHAR2(200);
  vTENDUONGSU   varchar2(100);
  vTENDUONGSU_BC   varchar2(100);
  v_isdauvu number;
  vTRANGTHAIID number;
BEGIN 
    -- v_id là đơn xin ân giảm của Vụ 1

    IF(v_ID=0) THEN  

        vuan_id := V_VUANID;
        vduongsu_id:= V_DUONGSUID;
        -- CHƯA CÓ VỤ ÁN => TẠO VỤ ÁN VÀ TẠO ĐƯƠNG SỰ
           if (vuan_id = 0) THEN 
                vduongsu_id:=  GDTTT_VUAN_DUONGSU_SEQ.NEXTVAL;
                IF (to_char(V_NgayNhanHS,'dd/MM/yyyy') !='01/01/0001') THEN
                    v_ishoso := 1;
                ELSE
                    v_ishoso := 0;
                END IF;

               IF(V_LOAI = 1 or V_LOAI = 3) THEN
                    v_ISXINANGIAM := 1;
               ELSE
                    v_ISXINANGIAM := 2;
               END IF;

               if V_TENTHAMTRAVIEN is not null then
                    vTRANGTHAIID:=2 ;
               else
                    vTRANGTHAIID:=1;
               end if;
                vTENVUAN := V_HOTENBC||' - '||V_TENTOIDANH;
                vuan_id := GDTTT_VUAN_SEQ.NEXTVAL;
                INSERT INTO GDTTT_VUAN 
                    (ID,TENVUAN,LOAIAN,TOAANID,PHONGBANID,SOANPHUCTHAM,NGAYXUPHUCTHAM,TOAPHUCTHAMID,SOANSOTHAM,NGAYXUSOTHAM,TOAANSOTHAM,ISXINANGIAM,NGUOITAO,NGAYTAO,
                    NGAYPHANCONGTTV,THAMTRAVIENID, TENTHAMTRAVIEN,NGAYTTVNHAN_THS,NGAYNHANHOSO,ISHOSO, LANHDAOVUID, THAMPHANID,BIDON,QHPL_DINHNGHIAID,TRANGTHAIID,BAQD_CAPXETXU) 
                    VALUES (vuan_id,vTENVUAN,1,1,2,V_SOANPHUCTHAM,V_NGAYXUPHUCTHAM,V_TOAPHUCTHAMID,V_SOANSOTHAM,V_NGAYXUSOTHAM,V_TOAANSOTHAM,v_ISXINANGIAM,V_NGUOITAO,sysdate,
                    V_NGAYPHANCONGTTV,V_THAMTRAVIENID,V_TENTHAMTRAVIEN,V_NgayNhanTieuHS,V_NgayNhanHS,v_ishoso,V_LANHDAOVU,V_THAMPHAN,V_HOTENBC,V_TOIDANH_ID,vTRANGTHAIID,V_LOAIBA);
                if (v_ishoso = 1)then
                -- Tao phieu nhan Ho so- Do vao bang Ho so
                    insert into GDTTT_QUANLYHS 
                            (VUANID,LOAI,TRANGTHAI, NGAYTAO,CANBOID, TENCANBO, NGAYNHAN)
                            values
                            (vuan_id,3,3,V_NgayNhanHS,V_THAMTRAVIENID,V_TENTHAMTRAVIEN,V_NgayNhanHS);
                end if;


                INSERT INTO GDTTT_VUAN_DUONGSU
                    (ID,VUANID,TUCACHTOTUNG,LOAI,TENDUONGSU,NAMSINH,DIACHI,HS_TOIDANHID,HS_TENTOIDANH,HS_MUCAN,HS_BICANDAUVU,HS_ISBICAO,NGUOITAO,NGAYTAO)
                    VALUES (vduongsu_id,vuan_id,'BIDON',0,V_HOTENBC,V_NAMSINH,V_DIACHI,V_TOIDANH_ID,V_TENTOIDANH,'tử hình',0,1,V_NGUOITAO,sysdate );
            ELSE
              -- ĐÃ CÓ VỤ ÁN NHƯNG CHƯA CÓ ĐƯƠNG SỰ thì Tạo đương sự mới 
                IF (V_DUONGSUID = 0  and V_VUANID > 0 and V_HOTENBC is not null) THEN 
                -- ĐÃ CÓ VỤ ÁN NHƯNG CHƯA CÓ ĐƯƠNG SỰ
                        vduongsu_id:=  GDTTT_VUAN_DUONGSU_SEQ.NEXTVAL;
                        INSERT INTO GDTTT_VUAN_DUONGSU
                            (ID,VUANID,TUCACHTOTUNG,LOAI,TENDUONGSU,NAMSINH,DIACHI,HS_TOIDANHID,HS_TENTOIDANH,HS_MUCAN,HS_BICANDAUVU,HS_ISBICAO,NGUOITAO,NGAYTAO)
                            VALUES (vduongsu_id,V_VUANID,'BIDON',0,V_HOTENBC,V_NAMSINH,V_DIACHI,V_TOIDANH_ID,V_TENTOIDANH,'tử hình',0,1,V_NGUOITAO,sysdate);
                   
                end if;
            END IF;

           --INSERT VAO BANG DON 
            IF (vuan_id > 0) THEN
                don_id := GDTTT_TUHINH_DON_SEQ.NEXTVAL;
                  INSERT INTO GDTTT_TUHINH_DON
                      (ID,VUANID,DUONGSUID,NGUOIGUI,NGUOIGUI_DIACHI ,NGUOINHAN_ID,NGAYTRENDON,NGAYNHAN,LOAI,NOIDUNG,NGAYTAO,NGUOITAO_ID)
                      VALUES (don_id,vuan_id,vduongsu_id,V_NGUOIGUI,V_NGUOIGUI_DIACHI ,V_NGUOINHAN_ID,V_NGAYTRENDON,V_NGAYNHAN,V_LOAI,V_NOIDUNG ,sysdate,v_nguoitao_id);                      
            END IF;

    ELSE
--------Kiểm tra vụ an------------------------- 
        vduongsu_id:= V_DUONGSUID;
            IF (V_VUANID >0) then

              begin
                select isxinangiam into v_ISXINANGIAM  from gdttt_vuan where id =  V_VUANID;
              exception 
                    when NO_DATA_FOUND then
                    v_ISXINANGIAM:=0;
              end;

               IF(v_ISXINANGIAM = 1 and (V_LOAI = 1 or V_LOAI = 3)) THEN
                    v_ISXINANGIAM := 1;
               ELSE
                    v_ISXINANGIAM := 2;
               END IF;

                update GDTTT_vuan
                    set
                        ISXINANGIAM = v_ISXINANGIAM 
                      WHERE ID = V_VUANID and loaian = 1 and phongbanid =2;  
                -- luu lich su TTV truoc khi update
                -- LOAI =1 là TTV =2 là Lãnh đạo vụ

                select count(*) into l_history_ttv from GDTTT_vuan 
                                    where id = V_VUANID 
                                    and THAMTRAVIENID != V_THAMTRAVIENID
                                    and NGAYPHANCONGTTV < V_NGAYPHANCONGTTV;
                if l_history_ttv >0 then

                    insert into  GDTTT_VUAN_PHANCONGCB_HISTORY
                                 (LOAI,vuanid,CANBOID,TUNGAY)
                                 values (1,V_VUANID,(select THAMTRAVIENID from GDTTT_vuan where id = V_VUANID ),(select NGAYPHANCONGTTV from GDTTT_vuan where id = V_VUANID ));
                end if;

                --update thong tin nhan ho so
                IF (to_char(V_NgayNhanHS,'dd/MM/yyyy') !='01/01/0001') THEN
                    v_ishoso := 1;   
                ELSE
                   v_ishoso := 0;
                END IF;

                -- Tao phieu nhan Ho so khi chưa có hoặc ngày nhận hồ sơ khác lần nhận trước
                if (v_ishoso = 1 )then
                     select count(*) into l_countHS from GDTTT_QUANLYHS where VUANID = V_VUANID and NGAYTAO = V_NgayNhanHS and loai = 3;
                    if (l_countHS = 0) then
                        don_id := GDTTT_TUHINH_DON_SEQ.NEXTVAL;
                            insert into GDTTT_QUANLYHS 
                                (id,VUANID,LOAI,TRANGTHAI, NGAYTAO,CANBOID, TENCANBO, NGAYNHAN)
                                values
                                (don_id,V_VUANID,3,3,V_NgayNhanHS,V_THAMTRAVIENID,V_TENTHAMTRAVIEN,V_NgayNhanHS);
                    end if;
                end if;

                 select count(id) into v_isdauvu 
                                            from gdttt_vuan_duongsu 
                                                where VUANID = V_VUANID 
                                                and HS_BICANDAUVU = 1 ;
                if (vduongsu_id >0)then
                    if v_isdauvu >0 then
                        select TENDUONGSU into vTENDUONGSU_BC 
                                            from gdttt_vuan_duongsu 
                                                where VUANID = V_VUANID 
                                                and HS_BICANDAUVU = 1 
                                                and rownum = 1;
                        select HS_TENTOIDANH into vTOIDANH 
                                            from gdttt_vuan_duongsu 
                                                where VUANID = V_VUANID 
                                                and HS_BICANDAUVU = 1 
                                                and rownum = 1;
                        vTENVUAN := vTENDUONGSU_BC||' - '||vTOIDANH;
                    else   
                        select TENDUONGSU into vTENDUONGSU from gdttt_vuan_duongsu where id = vduongsu_id;
                        select HS_TENTOIDANH into vTOIDANH from gdttt_vuan_duongsu where id = vduongsu_id;
                        vTENVUAN := vTENDUONGSU||' - '||vTOIDANH;
                    end if;
                else
                    if v_isdauvu >0 then

                        select HS_TENTOIDANH into vTOIDANH 
                                            from gdttt_vuan_duongsu 
                                                where VUANID = V_VUANID 
                                                and HS_BICANDAUVU = 1 
                                                and rownum = 1;
                        select TENDUONGSU into vTENDUONGSU_BC 
                                            from gdttt_vuan_duongsu 
                                                where VUANID = V_VUANID 
                                                and HS_BICANDAUVU = 1 
                                                and rownum = 1;
                        vTENVUAN := vTENDUONGSU_BC||' - '||vTOIDANH;
                    else                    
                        vTENVUAN := V_HOTENBC||' - '||V_TENTOIDANH;
                    end if;

                end if;
                -- update thong tin vụ án
               if V_TENTHAMTRAVIEN is not null then
                    vTRANGTHAIID:=2 ;
               else
                    vTRANGTHAIID:=1;
               end if;
                update GDTTT_vuan
                    set
                     TENVUAN = vTENVUAN
                    ,SOANPHUCTHAM = v_SOANPHUCTHAM
                    ,NGAYXUPHUCTHAM = v_NGAYXUPHUCTHAM
                    ,TOAPHUCTHAMID = v_TOAPHUCTHAMID
                    ,SOANSOTHAM = v_SOANSOTHAM
                    ,NGAYXUSOTHAM = v_NGAYXUSOTHAM
                    ,TOAANSOTHAM = v_TOAANSOTHAM
                    ,ISXINANGIAM = v_ISXINANGIAM
                    ,NGAYPHANCONGTTV =  V_NGAYPHANCONGTTV
                    ,THAMTRAVIENID  = V_THAMTRAVIENID
                    ,TENTHAMTRAVIEN    = V_TENTHAMTRAVIEN
                    ,NGAYTTVNHAN_THS    = V_NgayNhanTieuHS
                    ,NGAYNHANHOSO   = V_NgayNhanHS
                    ,ISHOSO         = v_ishoso
                    ,LANHDAOVUID = V_LANHDAOVU
                    ,THAMPHANID = V_THAMPHAN
                    ,trangthaiid = vTRANGTHAIID
                    ,NGUOISUA    = V_NGUOITAO
                    ,NGAYSUA    = SYSDATE
                    ,BAQD_CAPXETXU = V_LOAIBA

                      WHERE ID = V_VUANID;  

            end if;
           -- Tạo đương sự mới 
            IF (V_DUONGSUID = 0  and V_VUANID > 0 and V_HOTENBC is not null) THEN 
            -- ĐÃ CÓ VỤ ÁN NHƯNG CHƯA CÓ ĐƯƠNG SỰ
                    vduongsu_id:=  GDTTT_VUAN_DUONGSU_SEQ.NEXTVAL;
                    INSERT INTO GDTTT_VUAN_DUONGSU
                        (ID,VUANID,TUCACHTOTUNG,LOAI,TENDUONGSU,NAMSINH,DIACHI,HS_TOIDANHID,HS_TENTOIDANH,HS_MUCAN,HS_BICANDAUVU,HS_ISBICAO,NGUOITAO,NGAYTAO)
                        VALUES (vduongsu_id,V_VUANID,'BIDON',0,V_HOTENBC,V_NAMSINH,V_DIACHI,V_TOIDANH_ID,V_TENTOIDANH,'tử hình',0,1,V_NGUOITAO,sysdate);

            end if;

            ---Update bang don của Vu---------------

          UPDATE GDTTT_TUHINH_DON
            SET  
            DUONGSUID = vduongsu_id,
            NGUOIGUI = V_NGUOIGUI,
            NGUOIGUI_DIACHI = V_NGUOIGUI_DIACHI,
            NGUOINHAN_ID = V_NGUOINHAN_ID,
            NGAYTRENDON = V_NGAYTRENDON,
            NGAYNHAN = V_NGAYNHAN,
            LOAI = V_LOAI,
            NOIDUNG = V_NOIDUNG,
            NGAYSUA = sysdate,
            NGUOISUA_ID = V_NGUOITAO_ID,
            vuanid = V_VUANID
            WHERE ID=v_ID;

    END IF;
END;

PROCEDURE  GDTTT_TUHINH_INSERT
( 
    V_USER_ID  in number,
    V_VUAN_ID in number,
    V_DUONGSU_ID in number
)
IS 
   V_TOTAL number;V_TOTAL_DON number;V_DUONGSU number; V_BICAOID number;V_DONID number;
   V_TOTAL_DON_KEUOAN NUMBER;
BEGIN
    -- kiểm tra xem đơn này có phải là xin ân giảm của án tử hình hay không ISTH_KEUOAN
    SELECT COUNT(*) INTO V_TOTAL_DON FROM GDTTT_DON DN WHERE DN.VUVIECID=V_VUAN_ID AND DN.ISTH_ANGIAM=1;
    IF(V_TOTAL_DON>0) THEN
            ------lấy mã đơn
            SELECT DN.ID INTO V_DONID FROM GDTTT_DON DN WHERE DN.VUVIECID=V_VUAN_ID AND DN.ISTH_ANGIAM=1;                
            ----------------kiểm tra xem đã tồn tại hồ sơ của  đương sự đó chưa
            SELECT COUNT(*) INTO V_TOTAL FROM GDTTT_TUHINH_VUAN TH WHERE TH.DUONGSU_ID=V_DUONGSU_ID;
            ---Chưa tồn tại thì insert vào bảng hồ sơ tử hình
              IF(V_TOTAL=0)THEN
                             insert into GDTTT_TUHINH_VUAN 
                            (id, vuan_id,DONID,DUONGSU_ID,NGAYTAO,NGUOITAO)
                            values 
                            (GDTTT_TUHINH_VUAN_SEQ.nextval,V_VUAN_ID,V_DONID,V_DUONGSU_ID,SYSDATE,V_USER_ID);
              END IF;
            -- update trạng thái isxinangiam của bảng gdttt_vuan
            SELECT COUNT(*) INTO V_TOTAL_DON_KEUOAN FROM GDTTT_DON WHERE VUVIECID=V_VUAN_ID AND ISTH_KEUOAN=1 and ISTH_ANGIAM=1;
            IF (V_TOTAL_DON_KEUOAN >0) THEN
                -- Vừa kêu oan vừa xin ân giảm
                UPDATE GDTTT_VUAN SET ISXINANGIAM = 2 WHERE ID = V_VUAN_ID;
            ELSE
                -- chỉ xin ân giảm
                UPDATE GDTTT_VUAN SET ISXINANGIAM = 1 WHERE ID = V_VUAN_ID;
            END IF;
      END IF;   
END GDTTT_TUHINH_INSERT;
END PKG_GDTTT_TUHINH_APP;
