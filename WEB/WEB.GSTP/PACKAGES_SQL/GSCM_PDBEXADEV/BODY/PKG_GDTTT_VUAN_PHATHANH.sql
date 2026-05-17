--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_PHATHANH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_PHATHANH" AS
PROCEDURE  TONGDAT_GDKT_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_VUAN_ID in NUMBER, 
    v_GIAIDOAN in NUMBER,
    v_ID_HS_TLDON in VARCHAR2, 
    v_LOAIVB in VARCHAR2, 
    v_LOAIANID in NUMBER,
    v_TENVANBAN in VARCHAR2, 
    v_SOVB in VARCHAR2,
    v_NGAYVB in DATE,
    v_NGUOIKY in VARCHAR2,
    v_DONVIPHATHANH_ID in NUMBER,
    v_DONVIPHATHANH in VARCHAR2, 
    v_TOAANID in NUMBER,
    v_NGAYTHUHOI in DATE,
    v_LYDOTHUHOI in VARCHAR2, 
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    v_NGAYSUA in DATE,
    v_NGUOISUA in VARCHAR2,
    v_TENFILE in VARCHAR2,
    v_FILE_URL in VARCHAR2,
    vID out number
)IS 
BEGIN
        if (v_id >0) then
            update TONGDAT_GDKT
                    set
                        VUAN_ID = v_VUAN_ID,
                        GIAIDOAN     = v_GIAIDOAN,
                        ID_HS_TLDON   = v_ID_HS_TLDON,
                        LOAIVB   =   v_LOAIVB,
                        LOAIANID = v_LOAIANID,
                        TENVANBAN = v_TENVANBAN,
                        SOVB = v_SOVB,
                        NGAYVB = v_NGAYVB,
                        NGUOIKY  =  v_NGUOIKY,
                        DONVIPHATHANH_ID = v_DONVIPHATHANH_ID,
                        DONVIPHATHANH = v_DONVIPHATHANH,
                        TOAANID = v_TOAANID,
                        NGAYTHUHOI = v_NGAYTHUHOI,
                        LYDOTHUHOI = v_LYDOTHUHOI,
                        NGAYSUA = v_NGAYSUA,
                        NGUOISUA = v_NGUOISUA,
                        TENFILE = v_TENFILE,
                        FILE_URL = v_FILE_URL
                    where id = v_id  
                    RETURNING ID INTO vID;
        else
            insert into TONGDAT_GDKT 
            (id,VUAN_ID,GIAIDOAN,ID_HS_TLDON,LOAIVB,LOAIANID,TENVANBAN,SOVB,NGAYVB,NGUOIKY,DONVIPHATHANH_ID,DONVIPHATHANH,TOAANID,NGAYTHUHOI,LYDOTHUHOI,ngaytao,NGUOITAO)
            values (TONGDAT_GDKT_SEQ.nextval,v_VUAN_ID,v_GIAIDOAN,v_ID_HS_TLDON,v_LOAIVB,v_LOAIANID,v_TENVANBAN,v_SOVB,v_NGAYVB,v_NGUOIKY,v_DONVIPHATHANH_ID,v_DONVIPHATHANH,v_TOAANID,v_NGAYTHUHOI,v_LYDOTHUHOI, sysdate,v_NGUOITAO)
            RETURNING ID INTO vID;
        end if;
End TONGDAT_GDKT_UP_IN;

PROCEDURE  TONGDAT_GDKT_GETBYID
( 
    v_id  in number DEFAULT 0,
    curReturn    OUT       sys_refcursor
)IS
BEGIN
OPEN curReturn FOR  
   SELECT * FROM TONGDAT_GDKT WHERE ID = v_id;
End TONGDAT_GDKT_GETBYID;

PROCEDURE  TONGDAT_GDKT_DEL
( 
    v_id  in number DEFAULT 0
)
IS 
BEGIN
        if (v_id >0) then
            DELETE TONGDAT_GDKT where id = v_id ; 
            DELETE TONGDAT_GDKT_NOINHAN where TONGDAT_GDKT_ID = v_id;
        end if;

End TONGDAT_GDKT_DEL;

PROCEDURE  TONGDAT_GDKT_NOINHAN_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_TONGDAT_GDKT_ID in NUMBER, 
    v_DOITUONG in NUMBER,
    v_NOINHAN_ID in NUMBER, 
    v_NOINHAN in VARCHAR2, 
    v_TUCACHTOTUNG in VARCHAR2, 
    v_DIACHI in VARCHAR2, 
    v_TRANGTHAI in NUMBER,
    v_LYDO in VARCHAR2,
    v_NGAYGUI in DATE,
    v_NGAYPHATHANH in DATE, 
    v_NGAYNHAN in DATE, 
    v_HINHTHUCGUI in NUMBER,
    v_PHATHANHLAI_ID in NUMBER,
    v_IS_SUA in NUMBER,
    v_NGAYTAO in date,
    v_NGUOITAO in varchar2,
    vID out number
)IS 
BEGIN
        if (v_id >0) then
            update TONGDAT_GDKT_NOINHAN
                    set
                        TONGDAT_GDKT_ID = v_TONGDAT_GDKT_ID,
                        DOITUONG     = v_DOITUONG,
                        NOINHAN_ID   = v_NOINHAN_ID,
                        NOINHAN   =   v_NOINHAN,
                        TUCACHTOTUNG = v_TUCACHTOTUNG,
                        DIACHI = v_DIACHI,
                        TRANGTHAI = v_TRANGTHAI,
                        LYDO = v_LYDO,
                        NGAYGUI  =  v_NGAYGUI,
                        NGAYPHATHANH = v_NGAYPHATHANH,
                        NGAYNHAN = v_NGAYNHAN,
                        HINHTHUCGUI = v_HINHTHUCGUI,
                        PHATHANHLAI_ID = v_PHATHANHLAI_ID,
                        IS_SUA = v_IS_SUA
                    where id = v_id 
                    RETURNING ID INTO vID;   
        else
            insert into TONGDAT_GDKT_NOINHAN 
            (id,TONGDAT_GDKT_ID,DOITUONG,NOINHAN_ID,NOINHAN,TUCACHTOTUNG,DIACHI,TRANGTHAI,LYDO,NGAYGUI,NGAYPHATHANH,NGAYNHAN,HINHTHUCGUI,PHATHANHLAI_ID,IS_SUA,ngaytao,NGUOITAO)
            values (TONGDAT_GDKT_SEQ.nextval,v_TONGDAT_GDKT_ID,v_DOITUONG,v_NOINHAN_ID,v_NOINHAN,v_TUCACHTOTUNG,v_DIACHI,v_TRANGTHAI,v_LYDO,v_NGAYGUI,v_NGAYPHATHANH,v_NGAYNHAN,v_HINHTHUCGUI,v_PHATHANHLAI_ID,0, sysdate,v_NGUOITAO)
            RETURNING ID INTO vID;
        end if;
End TONGDAT_GDKT_NOINHAN_UP_IN;

PROCEDURE  TONGDAT_GDKT_NOINHAN_GETBYID
( 
    v_id  in number DEFAULT 0,
    curReturn    OUT       sys_refcursor
)IS
BEGIN
OPEN curReturn FOR  
   SELECT * FROM TONGDAT_GDKT_NOINHAN WHERE ID = v_id;
End TONGDAT_GDKT_NOINHAN_GETBYID;

PROCEDURE  TONGDAT_GDKT_NOINHAN_DEL
( 
    v_id  in number DEFAULT 0
)
IS 
BEGIN
        if (v_id >0) then
            DELETE TONGDAT_GDKT_NOINHAN where id = v_id ;   
        end if;

End TONGDAT_GDKT_NOINHAN_DEL;

PROCEDURE  GET_VAN_BAN_PHAT_HANH
( 
    v_VuAn_ID  in number,
    curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR  
    select 'HS' || a.ID as ID, DECODE(a.LOAI, 0, 'Phiếu mượn', 1, 'Phiếu trả', 2, 'Phiếu chuyển', 4, 'Công văn XM,BS', 5, 'Công văn khác') 
    || DECODE(a.SOPHIEU, null, '', ' số ' || DECODE(LENGTH(a.SOPHIEU), 1, '0' || a.SOPHIEU,a.SOPHIEU)) 
    || DECODE(a.NGAYTAO, null, '', ' ngày ' || to_char(a.NGAYTAO,'dd/MM/yyyy')) as VBPH
    from GDTTT_QUANLYHS a
    Where a.VUANID=v_VuAn_ID AND a.LOAI in (0,1,2,4,5)  AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'HS' || a.ID)
    UNION
     select 'GQD' || a.ID as ID, DECODE(a.GQD_LOAIKETQUA, 
     0, 'Trả lời đơn' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')), 
     1, 'Kháng nghị' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')),
     4, 'VKS đang giải quyết' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')) 
     )  as VBPH
    from GDTTT_VUAN a
    Where a.ID=v_VuAn_ID AND a.GQD_LOAIKETQUA IN (0,1,4) AND a.LOAIAN != 1 
    AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND ((a.GQD_LOAIKETQUA=0 AND t.LOAIVB='Trả lời đơn') OR (a.GQD_LOAIKETQUA=1 AND t.LOAIVB='Kháng nghị') OR (a.GQD_LOAIKETQUA=4 AND t.LOAIVB='VKS đang giải quyết')))
    UNION
     select 'GQD' || DECODE(a.GQD_LOAIKETQUA, 1, t1.ID, t.ID) as ID, DECODE(a.GQD_LOAIKETQUA, 
     0, 'Trả lời đơn' || DECODE(t.SO, null, '',' số ' || DECODE(LENGTH(t.SO), 1, '0' || t.SO,t.SO)) 
     || DECODE(t.NGAY, null, '',' ngày ' || to_char(t.NGAY,'dd/MM/yyyy')), 
     1, 'Kháng nghị' || DECODE(t1.SO, null, '',' số ' || DECODE(LENGTH(t1.SO), 1, '0' || t1.SO,t1.SO)) 
     || DECODE(t1.NGAY, null, '',' ngày ' || to_char(t1.NGAY,'dd/MM/yyyy')),
     4, 'VKS đang giải quyết' || DECODE(a.GDQ_SO, null, '',' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '',' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy'))
     )  as VBPH
    from GDTTT_VUAN a
    LEFT JOIN GDTTT_DON_TRALOI t ON a.GQD_LOAIKETQUA IN (0,4) AND t.VUANID = a.ID AND t.TYPETB=3
    LEFT JOIN GDTTT_DON_TRALOI t1 ON a.GQD_LOAIKETQUA=1 AND t1.VUANID = a.ID AND t1.TYPETB=4
    Where a.ID=v_VuAn_ID AND a.GQD_LOAIKETQUA IN (0,1,4) AND a.LOAIAN = 1 
    AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT td WHERE td.ID_HS_TLDON = 'TL' || DECODE(a.GQD_LOAIKETQUA, 1, t1.ID, t.ID) AND ((a.GQD_LOAIKETQUA=0 AND td.LOAIVB='Trả lời đơn') OR (a.GQD_LOAIKETQUA=1 AND td.LOAIVB='Kháng nghị') OR (a.GQD_LOAIKETQUA=4 AND td.LOAIVB='VKS đang giải quyết')))
    UNION 
     select 'GDT' || a.ID as ID, 'Thông báo thụ lý xét xử GĐT'
    || ' số ' || DECODE(LENGTH(a.SOTHULYXXGDT), 1, '0' || a.SOTHULYXXGDT,a.SOTHULYXXGDT) || DECODE(a.NGAYTHULYXXGDT, null, '',' ngày ' || to_char(a.NGAYTHULYXXGDT,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a 
    Where a.ID=v_VuAn_ID AND a.SOTHULYXXGDT is not null AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND t.LOAIVB = 'Thông báo thụ lý xét xử GĐT')
    UNION 
     select 'GDT' || a.ID as ID, 'Kết quả xét xử GĐT'
    || ' số ' || DECODE(LENGTH(a.XXGDTTT_SOQD), 1, '0' || a.XXGDTTT_SOQD,a.XXGDTTT_SOQD) || DECODE(a.XXGDTTT_NGAYQD, null, '',' ngày ' || to_char(a.XXGDTTT_NGAYQD,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a 
    Where a.ID=v_VuAn_ID AND a.XXGDTTT_ISKETQUA = 1 AND a.XXGDTTT_SOQD is not null AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND t.LOAIVB = 'Kết quả xét xử GĐT')
    UNION 
    select 'DBQH' || t.ID as ID, DECODE(t.TYPETB, 1, 'Thông báo tình thế', 2, 'Trả lời tình thế') 
    || DECODE(t.SO, null, '',' số ' || DECODE(LENGTH(t.SO), 1, '0' || t.SO,t.SO)) 
    || DECODE(t.NGAY, null, '',' ngày ' || to_char(t.NGAY,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a
    LEFT JOIN GDTTT_DON_TRALOI t ON a.LOAIAN = 1 AND t.VUANID = a.ID 
    Where a.ID=v_VuAn_ID AND t.TYPETB IN (1,2) 
    AND NOT EXISTS(SELECT * FROM TONGDAT_GDKT td WHERE td.ID_HS_TLDON = 'TL' || t.ID AND ((t.TYPETB=1 AND td.LOAIVB='Thông báo tình thế') OR (t.TYPETB=2 AND td.LOAIVB='Trả lời tình thế')))
    ;
END GET_VAN_BAN_PHAT_HANH;

PROCEDURE  GET_VAN_BAN_PHAT_HANH_NOINHAN
( 
    v_VuAn_ID  in number,
    v_HoSo_ID  in number,
    v_GiaiDoan  in varchar2,
    curReturn    OUT       sys_refcursor
)IS 
BEGIN
if(v_GiaiDoan !='DBQH') then
    OPEN curReturn FOR  
        select 0 as ID, DECODE(a.ISMUONHOSOVKS, 0, t.ID, 1, v.ID, 0) as NOINHANID, '2' as HINHTHUCGUI, 0 as TRANGTHAI,
        DECODE(a.ISMUONHOSOVKS, 0, t.TEN, 1, v.TEN, a.TENDONVIMUONHS) as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
        DECODE(a.ISMUONHOSOVKS, 0, TO_CHAR(t.DIACHI), '') as DIACHI, 0 as CHECKTONGDAT, 2 as DOITUONG, '' as NGAYGUI
        from GDTTT_QUANLYHS a
        LEFT JOIN DM_TOAAN t ON a.ISMUONHOSOVKS = 0 AND t.ID = a.TOAANMUONHSID
        LEFT JOIN DM_VKS v ON a.ISMUONHOSOVKS = 1 AND v.ID = a.VKSMUONHSID
        Where v_GiaiDoan='HS' AND a.ID=v_HoSo_ID
        UNION
        select 0 as ID, DECODE(a.BAQD_CAPXETXU, 4, t.ID, 3, t1.ID, 2, t2.ID) as NOINHANID, '2' as HINHTHUCGUI, 0 as TRANGTHAI,
        DECODE(a.BAQD_CAPXETXU, 4, t.TEN, 3, t1.TEN, 2, t2.TEN) as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
        TO_CHAR(DECODE(a.BAQD_CAPXETXU, 4, t.DIACHI, 3, t1.DIACHI, 2, t2.DIACHI)) as DIACHI, 0 as CHECKTONGDAT, 2 as DOITUONG, '' as NGAYGUI
        from GDTTT_VUAN a
        LEFT JOIN DM_TOAAN t ON a.TOAQDID = t.ID AND a.BAQD_CAPXETXU=4
        LEFT JOIN DM_TOAAN t1 ON a.TOAPHUCTHAMID = t1.ID AND a.BAQD_CAPXETXU=3
        LEFT JOIN DM_TOAAN t2 ON a.TOAANSOTHAM = t2.ID AND a.BAQD_CAPXETXU=2
        Where a.ID=v_VuAn_ID AND v_GiaiDoan!='HS'
        UNION  
        select 0 as ID,  DECODE(a.ID, 0, 1, 0) as NOINHANID, '2' as HINHTHUCGUI, 0 as TRANGTHAI,
        a.CV_TENDONVI || '( Theo CV ' || DECODE(a.CV_SO, null, '', ' số ' || a.CV_SO) || DECODE( TO_CHAR(a.CV_NGAY, 'dd/MM/yyyy'), null, '', '01/01/0001', '', ' ngày ' || TO_CHAR(a.CV_NGAY, 'dd/MM/yyyy')) || ')' as NOINHAN,  '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
        DECODE(a.CV_DIACHI, null, '', a.CV_DIACHI || ', ') || DECODE(a.CV_HUYENID, null, '', d1.TEN || ', ', d.TEN) as DIACHI,0 as CHECKTONGDAT, 2 as DOITUONG, '' as NGAYGUI
        from GDTTT_DON a
        left join DM_HANHCHINH d on d.ID = a.CV_TINHID 
        left join DM_HANHCHINH d1 on d1.ID = a.CV_HUYENID
        Where (a.LOAIDON=3 OR a.LOAIDON=31) AND a.VUVIECID=v_VuAn_ID; -- Loại đơn = 3, 31
else
    OPEN curReturn FOR 
        select 0 as ID,  CV_TOAANID as NOINHANID,  '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
        TO_CHAR(a.CV_TENDONVI) as NOINHAN, 0 as CHECKTONGDAT, 2 as DOITUONG, '' as NGAYGUI,'2' as HINHTHUCGUI, 0 as TRANGTHAI,
        (DECODE(a.CV_DIACHI, null, '', a.CV_DIACHI || ', ') || DECODE(a.CV_HUYENID, null, '', d1.TEN || ', ', d.TEN)) as DIACHI                 
        from GDTTT_DON a   
        left join DM_HANHCHINH d on d.ID = a.CV_TINHID
        left join DM_HANHCHINH d1 on d1.ID = a.CV_HUYENID
        Where a.VUVIECID=v_VuAn_ID AND a.LOAICONGVAN in (1033,1025,1198,1199);
end if;
END GET_VAN_BAN_PHAT_HANH_NOINHAN;

PROCEDURE  GET_VBPH_NOINHAN_DOITUONG
( 
    v_VuAn_ID  in number,
    v_GiaiDoan  in varchar2,
    v_LoaiAn  in number,
    v_ThuLy  in number,
    v_IsKhangNghi in number,
    curReturn    OUT       sys_refcursor
)IS 
BEGIN
   OPEN curReturn FOR  
    select 0 as ID, a.NGUOIGUI_HOTEN as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
    TO_CHAR(tctt.TEN) as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI,
    (DECODE(a.NGUOIGUI_DIACHI, null, '', a.NGUOIGUI_DIACHI || ', ') || DECODE(a.NGUOIGUI_HUYENID, null, '', d1.TEN || ', ', d.TEN)) as DIACHI                 
    from GDTTT_DON a   
    left join DM_DATAITEM tctt on tctt.ID = a.NGUOIGUI_TUCACHTOTUNG
    left join DM_HANHCHINH d on d.ID = a.NGUOIGUI_TINHID
    left join DM_HANHCHINH d1 on d1.ID = a.NGUOIGUI_HUYENID
    Where v_LoaiAn != 1 AND v_ThuLy = 1 AND a.ISTHULY=1 AND a.VUVIECID=v_VuAn_ID AND a.NGUOIGUI_HOTEN is not null-- dan su chung, thu ly =1
    UNION  
    select 0 as ID, a.HOTEN as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
    'Người khiếu nại' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI,
    To_CHAR(a.DIACHI) as DIACHI                 
    from GDTTT_DON_NGUOIKN a   
    inner join GDTTT_DON d ON d.ID = a.DONID
    Where v_LoaiAn != 1 AND v_ThuLy = 1 AND d.ISTHULY=1 AND d.VUVIECID=v_VuAn_ID AND a.HOTEN is not null-- dan su chung, thu ly =1
    UNION  
    select 0 as ID, a.NGUOIKHIEUNAI as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
    'Người khiếu nại' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI,
    TO_CHAR(a.DIACHINGUOIDENGHI) as DIACHI
    from GDTTT_VUAN a
    Where v_LoaiAn != 1 AND v_ThuLy = 2 AND a.ID=v_VuAn_ID AND a.NGUOIKHIEUNAI is not null-- dan su chung, thu ly =2
    UNION  
    SELECT distinct ID, trim(regexp_substr(TENDUONGSU, '[^;]+', 1, level)) NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID, 'Nguyên đơn' TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI, '' DIACHI
    FROM (SELECT 0 as ID, NGUYENDON TENDUONGSU FROM GDTTT_VUAN Where v_LoaiAn != 1 AND v_IsKhangNghi=1 AND ID=v_VuAn_ID AND NGUYENDON is not null) t
    CONNECT BY instr(TENDUONGSU, ';', 1, level - 1) > 0   -- Kháng nghị lấy thêm nguyên đơn
    UNION  
    SELECT distinct ID, trim(regexp_substr(TENDUONGSU, '[^;]+', 1, level)) NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID, 'Bị đơn' TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI, '' DIACHI
    FROM (SELECT 0 as ID, BIDON TENDUONGSU FROM GDTTT_VUAN Where v_LoaiAn != 1 AND v_IsKhangNghi=1 AND ID=v_VuAn_ID AND BIDON is not null) t
    CONNECT BY instr(TENDUONGSU, ';', 1, level - 1) > 0   -- Kháng nghị lấy thêm bị đơn
    UNION   
    select 0 as ID, a.NGUOINHAN as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID,
    'Người khiếu nại' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 1 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI,
    TO_CHAR(a.DIACHINHAN) as DIACHI
    from GDTTT_DON_TRALOI a
    Where v_LoaiAn=1 AND a.VUANID=v_VuAn_ID AND a.NGUOINHAN is not null; -- Hình sự

END GET_VBPH_NOINHAN_DOITUONG;

PROCEDURE  GET_TONGDAT_GDKT
( 
    v_VuAn_ID  in number,
    curReturn    OUT       sys_refcursor
)IS
BEGIN
OPEN curReturn FOR  
    select n.ID,n.TONGDAT_GDKT_ID, a.TENVANBAN, n.NOINHAN, to_char(n.NGAYGUI,'dd/MM/yyyy') as NGAYGUI, to_char(n.NGAYPHATHANH,'dd/MM/yyyy') as NGAYPHATHANH, 
     count(*) over (partition by n.TONGDAT_GDKT_ID order by n.TONGDAT_GDKT_ID) ROWSPAN,
     row_number() over (partition by n.TONGDAT_GDKT_ID order by n.TONGDAT_GDKT_ID) RN,
     CASE WHEN EXISTS(SELECT * FROM TONGDAT_GDKT_NOINHAN where TRANGTHAI not in (0,2,6,7) AND TONGDAT_GDKT_ID = n.TONGDAT_GDKT_ID) 
     THEN 0 
     ELSE 1 
     END as HASSUA,   
     CASE WHEN EXISTS(SELECT * FROM TONGDAT_GDKT_NOINHAN where TRANGTHAI = 1 AND TONGDAT_GDKT_ID = n.TONGDAT_GDKT_ID) 
     THEN 1 
     ELSE 0 
     END as HASTHUHOI,
     CASE WHEN EXISTS(SELECT * FROM TONGDAT_GDKT_NOINHAN where PHATHANHLAI_ID = n.ID) 
     THEN 0 
     ELSE 1 
     END as HAS_PHATHANHLAI,
    to_char(n.NGAYNHAN,'dd/MM/yyyy') as NGAYNHAN, DECODE(n.TRANGTHAI, 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7, 'Niêm yết công khai') AS TRANGTHAI,
    n.IS_SUA
    from TONGDAT_GDKT_NOINHAN n 
    left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
    Where a.VUAN_ID=v_VuAn_ID ORDER BY n.TONGDAT_GDKT_ID desc, RN;
END GET_TONGDAT_GDKT;

PROCEDURE  GET_VBPH_NOINHAN_EDIT
( 
    v_TONGDAT_GDKT_ID  in number,
    v_Loai  in number,
    v_NOINHAN_ID in number,
    curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR  
    select n.ID, n.NOINHAN, n.NOINHAN_ID as NOINHANID, DECODE(n.TRANGTHAI, 0, 0, 6, 1, 7, 1, 1) AS CHECKTONGDAT
    , n.DOITUONG, n.DIACHI, n.TUCACHTOTUNG, n.HINHTHUCGUI, n.NGAYGUI, n.TRANGTHAI, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
    from TONGDAT_GDKT_NOINHAN n 
    Where n.TONGDAT_GDKT_ID = v_TONGDAT_GDKT_ID AND ((v_Loai=1 AND n.DOITUONG in (1,3)) OR (v_Loai=2 AND n.DOITUONG in (2,4)))
          AND (n.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_GDKT_NOINHAN WHERE PHATHANHLAI_ID = n.ID))
    UNION
    select 0 as ID, n.NOINHAN, n.NOINHAN_ID as NOINHANID,0 AS CHECKTONGDAT
    , n.DOITUONG, n.DIACHI, n.TUCACHTOTUNG, 2 as HINHTHUCGUI, SYSDATE() as NGAYGUI, 0 as TRANGTHAI, '1' ISBOSUNG, v_NOINHAN_ID as PHATHANHLAI_ID
    from TONGDAT_GDKT_NOINHAN n 
    Where n.ID = v_NOINHAN_ID AND ((v_Loai=1 AND n.DOITUONG in (1,3)) OR (v_Loai=2 AND n.DOITUONG in (2,4)))
    ORDER BY ID DESC;
END GET_VBPH_NOINHAN_EDIT;

PROCEDURE  THUHOI_TONGDAT_GDKT
( 
    v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2
)IS 
BEGIN
    update TONGDAT_GDKT
    set
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    where id = v_id;
    update TONGDAT_GDKT_NOINHAN
    set
        TRANGTHAI = 2
    where TONGDAT_GDKT_ID = v_id AND TRANGTHAI=1;
END THUHOI_TONGDAT_GDKT;

PROCEDURE  TONGDAT_GDKT_DONG_MO_KHOA
( 
    v_NOI_NHAN_ID  in number,
    v_IS_SUA  in number
)IS 
BEGIN
    update TONGDAT_GDKT_NOINHAN
    set
        IS_SUA = v_IS_SUA
    where id = v_NOI_NHAN_ID;
END TONGDAT_GDKT_DONG_MO_KHOA;

PROCEDURE    GET_VAN_BAN_PHAT_HANH_CHUAGUI
( 
   v_VuAn_ID in number,
   v_LoaiVBPH in varchar2,
   curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR
SELECT  LISTAGG('- ' || a.VBPH, ';<br/>') WITHIN GROUP (ORDER BY a.VBPH) as VBPH FROM (
   select 'HS' || a.ID as ID, DECODE(a.LOAI, 0, 'Phiếu mượn', 1, 'Phiếu trả', 2, 'Phiếu chuyển', 4, 'Công văn XM,BS', 5, 'Công văn khác') 
    || DECODE(a.SOPHIEU, null, '', ' số ' || DECODE(LENGTH(a.SOPHIEU), 1, '0' || a.SOPHIEU,a.SOPHIEU)) 
    || DECODE(a.NGAYTAO, null, '', ' ngày ' || to_char(a.NGAYTAO,'dd/MM/yyyy')) as VBPH
    from GDTTT_QUANLYHS a
    Where a.VUANID=v_VuAn_ID AND ((v_LoaiVBPH is null AND a.LOAI IN (0,1,2,4,5)) OR (v_LoaiVBPH=0 AND a.LOAI=0) OR (v_LoaiVBPH=1 AND a.LOAI=1) OR (v_LoaiVBPH=2 AND a.LOAI=2) OR (v_LoaiVBPH=3 AND a.LOAI=4) OR  (v_LoaiVBPH=4 AND a.LOAI=5)) 
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'HS' || a.ID) 
    OR EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
              left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
              Where a.VUAN_ID=v_VuAn_ID AND ((v_LoaiVBPH=0 AND a.LOAIVB='Phiếu mượn') OR (v_LoaiVBPH=1 AND a.LOAIVB='Phiếu trả') OR (v_LoaiVBPH=2 AND a.LOAIVB='Phiếu chuyển')OR (v_LoaiVBPH=4 AND a.LOAIVB='Công văn XM,BS') OR (v_LoaiVBPH=5 AND a.LOAIVB='Công văn khác'))and n.TRANGTHAI=0))
    UNION
     select 'GQD' || a.ID as ID, DECODE(a.GQD_LOAIKETQUA, 
     0, 'Trả lời đơn' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')), 
     1, 'Kháng nghị' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')),
     4, 'VKS đang giải quyết' || DECODE(a.GDQ_SO, null,'', ' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '', ' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy')) 
     )  as VBPH
    from GDTTT_VUAN a
    Where a.ID=v_VuAn_ID AND ((v_LoaiVBPH is null AND a.GQD_LOAIKETQUA IN (0,1,4)) OR (v_LoaiVBPH=5 AND a.GQD_LOAIKETQUA=0) OR (v_LoaiVBPH=6 AND a.GQD_LOAIKETQUA=1) OR (v_LoaiVBPH=7 AND a.GQD_LOAIKETQUA=4)) AND a.LOAIAN != 1 
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND ((a.GQD_LOAIKETQUA=0 AND t.LOAIVB='Trả lời đơn') OR (a.GQD_LOAIKETQUA=1 AND t.LOAIVB='Kháng nghị') OR (a.GQD_LOAIKETQUA=4 AND t.LOAIVB='VKS đang giải quyết')))
    OR EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
              left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
              Where a.VUAN_ID=v_VuAn_ID AND ((a.LOAIVB='Trả lời đơn' AND v_LoaiVBPH=5) OR (a.LOAIVB='Kháng nghị' AND v_LoaiVBPH=6) OR (a.LOAIVB='VKS đang giải quyết' AND v_LoaiVBPH=7)) and n.TRANGTHAI=0)
    )
    UNION
     select 'GQD' || DECODE(a.GQD_LOAIKETQUA, 1, t1.ID, t.ID) as ID, DECODE(a.GQD_LOAIKETQUA, 
     0, 'Trả lời đơn' || DECODE(t.SO, null, '',' số ' || DECODE(LENGTH(t.SO), 1, '0' || t.SO,t.SO)) 
     || DECODE(t.NGAY, null, '',' ngày ' || to_char(t.NGAY,'dd/MM/yyyy')), 
     1, 'Kháng nghị' || DECODE(t1.SO, null, '',' số ' || DECODE(LENGTH(t1.SO), 1, '0' || t1.SO,t1.SO)) 
     || DECODE(t1.NGAY, null, '',' ngày ' || to_char(t1.NGAY,'dd/MM/yyyy')),
     4, 'VKS đang giải quyết' || DECODE(a.GDQ_SO, null, '',' số ' || DECODE(LENGTH(a.GDQ_SO), 1, '0' || a.GDQ_SO,a.GDQ_SO)) 
     || DECODE(a.GDQ_NGAY, null, '',' ngày ' || to_char(a.GDQ_NGAY,'dd/MM/yyyy'))
     )  as VBPH
    from GDTTT_VUAN a
    LEFT JOIN GDTTT_DON_TRALOI t ON a.GQD_LOAIKETQUA IN (0,4) AND t.VUANID = a.ID AND t.TYPETB=3
    LEFT JOIN GDTTT_DON_TRALOI t1 ON a.GQD_LOAIKETQUA=1 AND t1.VUANID = a.ID AND t1.TYPETB=4
    Where a.ID=v_VuAn_ID AND ((v_LoaiVBPH is null AND a.GQD_LOAIKETQUA IN (0,1,4)) OR (v_LoaiVBPH=5 AND a.GQD_LOAIKETQUA=0) OR (v_LoaiVBPH=6 AND a.GQD_LOAIKETQUA=1) OR (v_LoaiVBPH=7 AND a.GQD_LOAIKETQUA=4)) AND a.LOAIAN = 1 
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT td WHERE td.ID_HS_TLDON = 'TL' || DECODE(a.GQD_LOAIKETQUA, 1, t1.ID, t.ID) AND ((a.GQD_LOAIKETQUA=0 AND td.LOAIVB='Trả lời đơn') OR (a.GQD_LOAIKETQUA=1 AND td.LOAIVB='Kháng nghị') OR (a.GQD_LOAIKETQUA=4 AND td.LOAIVB='VKS đang giải quyết')))
    OR EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
              left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
              Where a.VUAN_ID=v_VuAn_ID AND ((a.LOAIVB='Trả lời đơn' AND v_LoaiVBPH=5) OR (a.LOAIVB='Kháng nghị' AND v_LoaiVBPH=6) OR (a.LOAIVB='VKS đang giải quyết' AND v_LoaiVBPH=7)) and n.TRANGTHAI=0)
    )
    UNION 
     select 'GDT' || a.ID as ID, 'Thông báo thụ lý xét xử GĐT'
    || ' số ' || DECODE(LENGTH(a.SOTHULYXXGDT), 1, '0' || a.SOTHULYXXGDT,a.SOTHULYXXGDT) || DECODE(a.NGAYTHULYXXGDT, null, '',' ngày ' || to_char(a.NGAYTHULYXXGDT,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a 
    Where a.ID=v_VuAn_ID AND (v_LoaiVBPH is null OR v_LoaiVBPH=8) AND a.SOTHULYXXGDT is not null 
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND t.LOAIVB = 'Thông báo thụ lý xét xử GĐT')
    OR  EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
               left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
               Where a.VUAN_ID=v_VuAn_ID AND a.LOAIVB='Thông báo thụ lý xét xử GĐT' AND n.TRANGTHAI=0)
    )
    UNION 
     select 'GDT' || a.ID as ID, 'Kết quả xét xử GĐT'
    || ' số ' || DECODE(LENGTH(a.XXGDTTT_SOQD), 1, '0' || a.XXGDTTT_SOQD,a.XXGDTTT_SOQD) || DECODE(a.XXGDTTT_NGAYQD, null, '',' ngày ' || to_char(a.XXGDTTT_NGAYQD,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a 
    Where a.ID=v_VuAn_ID AND (v_LoaiVBPH is null OR v_LoaiVBPH=9) AND a.XXGDTTT_ISKETQUA = 1 AND a.XXGDTTT_SOQD is not null 
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT t WHERE t.ID_HS_TLDON = 'VA' || a.ID AND t.LOAIVB = 'Kết quả xét xử GĐT')
    OR EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
              left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
              Where a.VUAN_ID=v_VuAn_ID AND a.LOAIVB='Kết quả xét xử GĐT' AND n.TRANGTHAI=0)
    )
    UNION 
    select 'DBQH' || t.ID as ID, DECODE(t.TYPETB, 1, 'Thông báo tình thế', 2, 'Trả lời tình thế') 
    || DECODE(t.SO, null, '',' số ' || DECODE(LENGTH(t.SO), 1, '0' || t.SO,t.SO)) 
    || DECODE(t.NGAY, null, '',' ngày ' || to_char(t.NGAY,'dd/MM/yyyy')) as VBPH
    from GDTTT_VUAN a
    LEFT JOIN GDTTT_DON_TRALOI t ON a.LOAIAN = 1 AND t.VUANID = a.ID 
    Where a.ID=v_VuAn_ID AND ((v_LoaiVBPH is null AND t.TYPETB in (1,2)) OR (v_LoaiVBPH=10 AND t.TYPETB=1) OR (v_LoaiVBPH=11 AND t.TYPETB=2))
    AND (NOT EXISTS(SELECT * FROM TONGDAT_GDKT td WHERE td.ID_HS_TLDON = 'TL' || t.ID AND ((t.TYPETB=1 AND td.LOAIVB='Thông báo tình thế') OR (t.TYPETB=2 AND td.LOAIVB='Trả lời tình thế')))
    OR EXISTS(SELECT 'x' from TONGDAT_GDKT_NOINHAN n 
              left join TONGDAT_GDKT a on a.ID = n.TONGDAT_GDKT_ID 
              Where a.VUAN_ID=v_VuAn_ID AND ((a.LOAIVB='Thông báo tình thế' AND v_LoaiVBPH=10) OR (a.LOAIVB='Trả lời tình thế' AND v_LoaiVBPH=11)) AND n.TRANGTHAI=0))
    ) a
    ;
END GET_VAN_BAN_PHAT_HANH_CHUAGUI;

PROCEDURE    GET_VAN_BAN_PHAT_HANH_DAGUI
( 
   v_VUANID in number,
   v_LoaiVBPH in varchar2,
   v_TrangThai in varchar2,
   curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR
  SELECT  LISTAGG('- ' || a.VBPH, ';<br/>') WITHIN GROUP (ORDER BY a.VBPH) as VBPH FROM (
   SELECT a.TENVANBAN || DECODE(a.LYDOTHUHOI, null, '', ',<i> Ngày thu hồi: ' || TO_CHAR(a.NGAYTHUHOI, 'dd/MM/yyyy') || ', Lý do: ' || a.LYDOTHUHOI ||'</i>') as VBPH
   FROM TONGDAT_GDKT a
   LEFT JOIN TONGDAT_GDKT_NOINHAN n ON n.TONGDAT_GDKT_ID = a.ID
   WHERE a.VUAN_ID = v_VUANID 
   AND (v_LoaiVBPH is null 
       OR (v_LoaiVBPH = '0' AND a.LOAIVB='Phiếu mượn')
       OR (v_LoaiVBPH = '0' AND a.LOAIVB='Phiếu mượn')
       OR (v_LoaiVBPH = '1' AND a.LOAIVB='Phiếu trả')
       OR (v_LoaiVBPH = '2' AND a.LOAIVB='Phiếu chuyển')
       OR (v_LoaiVBPH = '3' AND a.LOAIVB='Công văn XM,BS')
       OR (v_LoaiVBPH = '4' AND a.LOAIVB='Công văn khác')
       OR (v_LoaiVBPH = '5' AND a.LOAIVB='Trả lời đơn')
       OR (v_LoaiVBPH = '6' AND a.LOAIVB='Kháng nghị')
       OR (v_LoaiVBPH = '7' AND a.LOAIVB='VKS đang giải quyết')
       OR (v_LoaiVBPH = '8' AND a.LOAIVB='Thông báo thụ lý xét xử GĐT')
       OR (v_LoaiVBPH = '9' AND a.LOAIVB='Kết quả xét xử GĐT')
       OR (v_LoaiVBPH = '10' AND a.LOAIVB='Thông báo tình thế')
       OR (v_LoaiVBPH = '11' AND a.LOAIVB='Trả lời tình thế'))
   AND (v_TRANGTHAI is null 
       OR (v_TrangThai=0 and n.TRANGTHAI=0)
       OR (v_TrangThai=2 and n.TRANGTHAI=2) 
       OR (v_TrangThai=6 and n.TRANGTHAI in (1,3,4,5)) 
       OR (v_TrangThai=1 and n.TRANGTHAI=1) 
       OR (v_TrangThai=3 and n.TRANGTHAI in (3,4,5))
       OR (v_TrangThai=4 and n.TRANGTHAI=4) 
       OR (v_TrangThai=5 and n.TRANGTHAI = 5))  
   GROUP BY a.TENVANBAN, a.NGAYTHUHOI, a.LYDOTHUHOI) a;
END GET_VAN_BAN_PHAT_HANH_DAGUI;

PROCEDURE TONGDAT_GDKT_NOINHAN_PHATHANH_UPD
( 
    v_ID  in number,
    v_NGAYPHATHANH  in date
)IS 
BEGIN
    UPDATE TONGDAT_GDKT_NOINHAN SET 
        NGAYPHATHANH = v_NGAYPHATHANH,
        TRANGTHAI = 3
    WHERE ID = v_ID AND TRANGTHAI = 1;
END TONGDAT_GDKT_NOINHAN_PHATHANH_UPD;

PROCEDURE TONGDAT_GDKT_FILE_UPD
( 
    v_ID  in number,
    v_TENFILE  in varchar2,
    v_FILE_URL in varchar2
)IS 
BEGIN
    UPDATE TONGDAT_GDKT SET 
        TENFILE = v_TENFILE,
        FILE_URL = v_FILE_URL
    WHERE ID = v_ID;
END TONGDAT_GDKT_FILE_UPD;

--- 20220907 --- PKG_GDTTT_VUAN_PHATHANH
PROCEDURE TONGDAT_GDKT_NOINHAN_TRAKETQUA
( 
    v_ID  in number,
    v_TRANGTHAI in number DEFAULT 0,
    v_NGAYNHAN  in date,
    v_LYDO in varchar2
)IS 
BEGIN
    IF (v_TRANGTHAI = 4) THEN
        UPDATE TONGDAT_GDKT_NOINHAN SET 
            NGAYNHAN = v_NGAYNHAN,
            TRANGTHAI = 4
        WHERE ID = v_ID AND TRANGTHAI = 3;
    ELSIF (v_TRANGTHAI = 5) THEN
        UPDATE TONGDAT_GDKT_NOINHAN SET 
            NGAYNHAN = v_NGAYNHAN,
            LYDO = v_LYDO,
            TRANGTHAI = 5
        WHERE ID = v_ID AND TRANGTHAI = 3;
    END IF;
END TONGDAT_GDKT_NOINHAN_TRAKETQUA;

END PKG_GDTTT_VUAN_PHATHANH;

/
