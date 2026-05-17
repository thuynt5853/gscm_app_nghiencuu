--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_GDT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_GDT" AS

PROCEDURE   MHCA_DANHSACH_SEARCH_DON (
    v_ID_USER VARCHAR2,
    v_colume IN VARCHAR2,
    v_asc_desc IN VARCHAR2,
    vToaAnID IN NUMBER,
    vPhongBanID IN NUMBER,
    vToaRaBAQD IN NUMBER,
    vSoBAQD IN VARCHAR2,
    vNgayBAQD IN VARCHAR2,
    vNguoiGui IN VARCHAR2, 
    vCoquanchuyendon IN VARCHAR2,
    vNguyendon IN VARCHAR2,
    vBidon IN VARCHAR2, 
    vLoaiAn IN NUMBER,
    vThamphan IN NUMBER,
    vQHPLID IN NUMBER,
    vQHPLDNID IN NUMBER,
    vNgayThulyTu IN DATE,
    vNgayThulyDen IN DATE,
    vSoThuly IN VARCHAR2,
    vKetquathuly IN NUMBER,
    vKetquaxetxu IN NUMBER,
    isTTYKienKLTotrinh IN NUMBER,
    LoaiAnDB IN NUMBER,
    vLoaiAnDB_TH IN VARCHAR2,
    v_ISXINANGIAM IN NUMBER,
    v_GDT_ISXINANGIAM IN NUMBER,
    v_loaingaysearch IN NUMBER,
    v_NgaySearch_Tu IN DATE,
    v_NgaySearch_Den IN DATE,
    PageIndex IN INT,
    PageSize IN INT,
    curReturn OUT SYS_REFCURSOR
  ) IS
    TotalItem number;  MinIndex	number;  MaxIndex	number;
  BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

    OPEN curReturn FOR
        select * from
        (
            select a.*,
            ROW_NUMBER() OVER (
                    ORDER BY 
                    CASE 
                        WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                    END ASC,
                    CASE 
                        WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                    END DESC
                ) AS STT
            from (
                SELECT
                D.VUVIECID ID,
                D.ID DONID,
                COUNT(1) OVER () AS CountAll,
                D.TL_SO,
                D.TL_NGAY,
                case when d.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(d.BAQD_SO, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (d.BAQD_SO_PT,null,'',' ','','<br/><br/>'||d.BAQD_SO_PT||'<br/>'||to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (d.BAQD_SO_ST,null,'',' ','','<br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when d.BAQD_CAPXETXU = 3  then
                                             NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_PT, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (d.BAQD_SO_ST,null,'',' ','','<br/><br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when d.BAQD_CAPXETXU = 2 
                                        then NVL(d.BAQD_SO_ST, NVL(d.BAQD_SO_ST, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_ST, ''))
                                            ||'<br/>'|| decode(to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),null,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA,
    --            decode(Trim(v.QHPL_TEXT),null,decode(Trim(qhpl.TenQHPL),null,TD.DIEU ||'.'|| TD.TENTOIDANH,qhpl.TenQHPL),v.QHPL_TEXT) QUANHEPL,
                CASE
                    WHEN D.VUVIECID > 0 
                    THEN DECODE(Trim(v.QHPL_TEXT), null,
                             decode(Trim(qhpl.TenQHPL), null, TD.DIEU ||'.'|| TD.TENTOIDANH, qhpl.TenQHPL),
                             v.QHPL_TEXT)
                    ELSE null
                END AS QUANHEPL,
    --            v.NGUYENDON,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 5 THEN d.NGUOIGUI_HOTEN
                ELSE v.NGUYENDON
                END AS NGUYENDON,
    --            v.BIDON,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 6 THEN d.NGUOIGUI_HOTEN                
                    --WHEN d.BAQD_LOAIAN = 1 and d.NGUOIGUI_TUCACHTOTUNG = 7 THEN d.NGUOIGUI_HOTEN
                ELSE v.BIDON
                END AS BIDON,
--                DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
--                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
--                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
--                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
--                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
--                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 9 THEN d.NGUOIGUI_HOTEN       
                    ELSE d.DONGKHIEUNAI
                END AS NGUOIKHIEUNAI,
                TP.HOTEN AS TENTHAMPHAN,
                d.BAQD_LOAIAN LOAIAN,
                v.gqd_loaiketqua KQLOAI,
                ct.CANBOID,
                D.LOAICONGVAN THUOCDON,            
                D.CV_SO,
                D.CV_TENDONVI,
                TO_CHAR(D.CV_NGAY, 'dd/MM/yyyy') CV_NGAY,
                --
                D.TL_SO SOTHULY,
                TO_CHAR(D.TL_NGAY, 'dd/MM/yyyy') NGAYTHULY,
                --
                v.XXGDTTT_SOQD SOQDXX,
                TO_CHAR(v.XXGDTTT_NGAYQD, 'dd/MM/yyyy') NGAYQDXX,
                --
                v.SOTHULYXXGDT SOTHULYXX,
                TO_CHAR(v.NGAYTHULYXXGDT, 'dd/MM/yyyy') NGAYTHULYXX,
                --
                v.GDQ_SO KQSO,
                TO_CHAR(v.GDQ_NGAY, 'dd/MM/yyyy') KQNGAY

            FROM GDTTT_DON D
            LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID 
            left join DM_TOAAN txx on d.BAQD_TOAANID_PT=txx.ID
            left join DM_TOAAN tst on d.BAQD_TOAANID_ST=tst.ID
            left join DM_TOAAN tqd on d.BAQD_TOAANID=tqd.ID
            LEFT JOIN DM_CANBO tp on D.THAMPHANID=tp.ID
            left join(select HD.* FROM GDTTT_VuAn_XXGDTT_HoiDong HD where NVL(HD.IsChuToa,0)=1)ct on ct.VUANID=v.id
            left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
            LEFT JOIN DM_BOLUAT_TOIDANH td ON V.QHPL_THONGKEID = td.ID
            LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID

            WHERE 
            -- tìm theo tòa án
            D.TOAANID = vToaAnID  
            -- tìm theo phòng ban
    --        AND ((v.PhongBanID = vPhongBanID) OR (vPhongBanID = 0 OR vPhongBanID IS NULL)) 
            and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD 
            or d.BAQD_TOAANID = vToaRaBAQD)
            -- tìm theo loại án
            AND ( (vloaian = 0 AND ((instr(','||vloaian||',',','||d.BAQD_LOAIAN||',')>0 and vThamphan=0 and vPhongBanID=0) or (vThamphan!=0 or vPhongBanID!=0) ))
                                 or  (vloaian = d.BAQD_LOAIAN and vloaian!=0) 
                            ) 
            -- tìm theo thẩm phán                
            AND ( vThamphan = 0 or D.THAMPHANID=vThamphan 
            Or (vThamphan = -1 and NVL(D.THAMPHANID,0) = 0) 
            )
            -- tìm theo số bản án
            and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_ST) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_PT) like '%' || UPPER(vSoBAQD) || '%'
            )  
            -- tìm theo ngày bản án
             and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy') = vNgayBAQD
             )
            -- tìm theo nguyên đơn
            AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                            OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                      )

                                            ))

                                 OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                        AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                         )
                                        )
                                 OR trim(vNguyendon) || ' '=' '

                              )             
            -- tìm theo bị đơn
            and ( vBidon is null 
                                or vBidon = '' 
                                or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                      )
                                    )
            -- tìm theo người gửi đơn
            AND ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%'
            or UPPER(d.NGUOIGUI_HOTEN) like '%' || UPPER(vNguoiGui) || '%'
            )  
            -- tìm theo số thụ lý
            and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%'
            or UPPER(D.TL_SO) like '%' || UPPER(vSoThuly) || '%'
            )
            --Kết quả xét xử 
                         and ( vKetquaxetxu = 0
                            or (vKetquaxetxu = -1
                                      AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)=0)
                            or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)>0)
                            or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID and KETQUAID = vKetquaxetxu))
                            )
            -- tìm theo cột
            AND (
            ----COLUMN_2-------Tổng số vụ án thụ lý----------
                (vKetquathuly = 2 AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1  
                                  AND d.CD_LOAI = 0
                                  AND 
                                  (
                                       (d.TL_NGAY between vNgayThulyTu and vNgayThulyDen)
                                       OR
                                       (
                                                d.TL_NGAY < vNgayThulyTu                            
                                                     and ( 
                                                        (d.BAQD_LOAIAN != 1 AND  EXISTS(SELECT 1 FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= vNgayThulyTu))
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 1 FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))                        
                                                                    )
                                                  AND d.id !=319292                  
                                       )
                                  )  
                  )     
    ----        ------COLUMN_3 Tổng số giải quyết	                          
                OR 
                (vKetquathuly = 3  AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND( 
                                      (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen))                                                                   
                                      )
                    ) 
    ----        ------COLUMN_4 Tổng số giải quyết	                          
                OR 
                (vKetquathuly = 4 
                                      AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND 
                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )  
                    )    
    --        ------COLUMN_5 Tổng số giải quyết	                          
                OR (vKetquathuly = 5 
                                    AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND
                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                    )   
    --        ------COLUMN_6 Tổng số giải quyết	                           
                OR 
                (vKetquathuly = 6 
                                    AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND ( 
                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       )
                    )            
    --        ------COLUMN_7 Tổng số giải quyết	                          
                OR 
                (vKetquathuly = 7 
                                  AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND d.TL_NGAY <= vNgayThulyDen 
                                      and (KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > vNgayThulyDen)  
                    )  
            --- end vKetquathuly
                )
                order by d.TL_SO ASC
            ) a 
        ) b where stt>=MinIndex and stt<=MaxIndex;

  END MHCA_DANHSACH_SEARCH_DON; 

  PROCEDURE   MHCA_DANHSACH_SEARCH_DON_HS (
    v_ID_USER VARCHAR2,
    v_colume IN VARCHAR2,
    v_asc_desc IN VARCHAR2,
    vToaAnID IN NUMBER,
    vPhongBanID IN NUMBER,
    vToaRaBAQD IN NUMBER,
    vSoBAQD IN VARCHAR2,
    vNgayBAQD IN VARCHAR2,
    vNguoiGui IN VARCHAR2,
    vCoquanchuyendon IN VARCHAR2,
    vNguyendon IN VARCHAR2,
    vBidon IN VARCHAR2, 
    vLoaiAn IN NUMBER,
    vThamphan IN NUMBER,
    vQHPLID IN NUMBER,
    vQHPLDNID IN NUMBER,
    vNgayThulyTu IN DATE,
    vNgayThulyDen IN DATE,
    vSoThuly IN VARCHAR2,
    vKetquathuly IN NUMBER,
    vKetquaxetxu IN NUMBER,
    isTTYKienKLTotrinh IN NUMBER,
    LoaiAnDB IN NUMBER,
    vLoaiAnDB_TH IN VARCHAR2,
    v_ISXINANGIAM IN NUMBER,
    v_GDT_ISXINANGIAM IN NUMBER,
    v_loaingaysearch IN NUMBER,
    v_NgaySearch_Tu IN DATE,
    v_NgaySearch_Den IN DATE,
    PageIndex IN INT,
    PageSize IN INT,
    curReturn OUT SYS_REFCURSOR
  ) IS
    TotalItem number;  MinIndex	number;  MaxIndex	number;
  BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

    OPEN curReturn FOR
    select * from
    (
        select a.*,
        ROW_NUMBER() OVER (
                ORDER BY 
                CASE 
                    WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                END ASC,
                CASE 
                    WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                END DESC
            ) AS STT
        from (
        SELECT 
            COUNT(1) OVER () AS CountAll,
            D.VUVIECID ID,
            D.ID DONID,
            D.TL_NGAY,
            D.TL_SO,
--            CASE   
--                WHEN D.VUVIECID > 0   --trường hợp vuviecid > 0 thì lấy theo thông tin vụ án
--                THEN DECODE(v.BAQD_CAPXETXU, 
--                       4, v.so_qdgdt, 
--                       3, v.SOANPHUCTHAM, 
--                       2, v.SOANSOTHAM, 
--                       1, v.SOANPHUCTHAM, 
--                       NULL) || '<br/>' || 
--                DECODE(v.BAQD_CAPXETXU, 
--                       4, TO_CHAR(v.NGAYQD, 'dd/MM/yyyy'), 
--                       2, TO_CHAR(v.NGAYXUSOTHAM, 'dd/MM/yyyy'), 
--                       3, TO_CHAR(v.NGAYXUPHUCTHAM, 'dd/MM/yyyy'), 
--                       NULL) || '<br/>' || 
--                DM_CanBo_TenToaVT(tqd.Ma_Ten) || '<i>'
--                -----------------------------------
--            ELSE --TN null hoặc = 0 thì thì lấy thông tin của bảng đơn ( có thông tin đương sự)
--                DECODE(d.BAQD_CAPXETXU, 
--                       4, d.BAQD_SO, 
--                       3, d.BAQD_SO_PT, 
--                       2, d.BAQD_SO_ST, 
--                       1, d.BAQD_SO_PT, 
--                       NULL) || '<br/>' ||  
--                DECODE(d.BAQD_CAPXETXU, 
--                       4, TO_CHAR(d.BAQD_NGAYBA, 'dd/MM/yyyy'), 
--                       2, TO_CHAR(d.BAQD_NGAYBA_ST, 'dd/MM/yyyy'), 
--                       3, TO_CHAR(d.BAQD_NGAYBA_PT, 'dd/MM/yyyy'), 
--                       NULL) || '<br/>' || 
--                DM_CanBo_TenToaVT(tqd.Ma_Ten) || '<i>' 
--            END  AS InforBA,
            case when d.BAQD_CAPXETXU = 4 
                        then NVL(v.SO_QDGDT, NVL(d.BAQD_SO, 'null')) || 
                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'))||
                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                              decode (d.BAQD_SO_PT,null,'',' ','','<br/><br/>'||d.BAQD_SO_PT||'<br/>'||to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||
                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                              decode (d.BAQD_SO_ST,null,'',' ','','<br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
             when d.BAQD_CAPXETXU = 3  then
                             NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_PT, 'null')) || 
                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))||
                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                              decode (d.BAQD_SO_ST,null,'',' ','','<br/><br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

             when d.BAQD_CAPXETXU = 2 
                        then NVL(d.BAQD_SO_ST, NVL(d.BAQD_SO_ST, 'null')) || 
                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'))||
                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
             else
                            NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_ST, ''))
                            ||'<br/>'|| decode(to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),null,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))
                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
             end InforBA,
            CASE
                WHEN D.VUVIECID > 0 
                THEN DECODE(Trim(v.QHPL_TEXT), null,
                         decode(Trim(qhpl.TenQHPL), null, TD.DIEU ||'.'|| TD.TENTOIDANH, qhpl.TenQHPL),
                         v.QHPL_TEXT)
                ELSE null
            END AS QUANHEPL,
--            v.NGUYENDON,
            CASE
                WHEN d.NGUOIGUI_TUCACHTOTUNG = 5 THEN d.NGUOIGUI_HOTEN
            ELSE v.NGUYENDON
            END AS NGUYENDON,
            CASE
                WHEN d.NGUOIGUI_TUCACHTOTUNG = 6 THEN d.NGUOIGUI_HOTEN                
                WHEN d.BAQD_LOAIAN = 1 and (d.NGUOIGUI_TUCACHTOTUNG = 7 or d.NGUOIGUI_TUCACHTOTUNG = 1) THEN d.NGUOIGUI_HOTEN
            ELSE v.BIDON
            END AS BIDON,
--           DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
--                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
--                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
--                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
--                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
--                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI,
            CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 9 THEN d.NGUOIGUI_HOTEN                
                    --WHEN d.BAQD_LOAIAN = 1 and d.NGUOIGUI_TUCACHTOTUNG = 7 THEN d.NGUOIGUI_HOTEN
                ELSE d.DONGKHIEUNAI
                END AS NGUOIKHIEUNAI,
            TP.HOTEN AS TENTHAMPHAN,
            d.BAQD_LOAIAN LOAIAN,
            v.gqd_loaiketqua KQLOAI,
            ct.CANBOID,
            D.LOAICONGVAN THUOCDON,            
            D.CV_SO,
            D.CV_TENDONVI,
            TO_CHAR(D.CV_NGAY, 'dd/MM/yyyy') CV_NGAY,
            --
            D.TL_SO SOTHULY,
            TO_CHAR(D.TL_NGAY, 'dd/MM/yyyy') NGAYTHULY,
            --
            v.XXGDTTT_SOQD SOQDXX,
            TO_CHAR(v.XXGDTTT_NGAYQD, 'dd/MM/yyyy') NGAYQDXX,
            --
            v.SOTHULYXXGDT SOTHULYXX,
            TO_CHAR(v.NGAYTHULYXXGDT, 'dd/MM/yyyy') NGAYTHULYXX,
            --
            v.GDQ_SO KQSO,
            TO_CHAR(v.GDQ_NGAY, 'dd/MM/yyyy') KQNGAY

        FROM GDTTT_DON D
        LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID 
        left join DM_TOAAN txx on d.BAQD_TOAANID_PT=txx.ID
        left join DM_TOAAN tst on d.BAQD_TOAANID_ST=tst.ID
        left join DM_TOAAN tqd on d.BAQD_TOAANID=tqd.ID
        LEFT JOIN DM_CANBO tp on D.THAMPHANID=tp.ID
        left join(select HD.* FROM GDTTT_VuAn_XXGDTT_HoiDong HD where NVL(HD.IsChuToa,0)=1)ct on ct.VUANID=v.id
        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        LEFT JOIN DM_BOLUAT_TOIDANH td ON V.QHPL_THONGKEID = td.ID
        LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
        LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID

        WHERE 
        -- tìm theo tòa án
        D.TOAANID = vToaAnID  
        -- tìm theo phòng ban
--        AND ((v.PhongBanID = vPhongBanID) OR (vPhongBanID = 0 OR vPhongBanID IS NULL)) 
        and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD
        or d.BAQD_TOAANID = vToaRaBAQD
        )
        -- tìm theo loại án
        AND ( (vloaian = 0 AND ((instr(','||vloaian||',',','||d.BAQD_LOAIAN||',')>0 and vThamphan=0 and vPhongBanID=0) or (vThamphan!=0 or vPhongBanID!=0) ))
                             or  (vloaian = d.BAQD_LOAIAN and vloaian!=0) 
                        ) 
        -- tìm theo thẩm phán                
        AND ( vThamphan = 0 or D.THAMPHANID=vThamphan 
        Or (vThamphan = -1 and NVL(D.THAMPHANID,0) = 0) 
        )
        -- tìm theo số bản án
        and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_ST) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_PT) like '%' || UPPER(vSoBAQD) || '%'
        )  
        -- tìm theo ngày bản án
         and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD
         or to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') = vNgayBAQD
         or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy') = vNgayBAQD
         or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy') = vNgayBAQD
         )
        -- tìm theo nguyên đơn
        AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )

                                        ))

                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                    AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                     )
                                    )
                             OR trim(vNguyendon) || ' '=' '

                          )             
        -- tìm theo bị đơn
        and ( vBidon is null 
                            or vBidon = '' 
                            or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                  )
                                )
        -- tìm theo người gửi đơn
        AND ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%'
        or UPPER(d.NGUOIGUI_HOTEN) like '%' || UPPER(vNguoiGui) || '%'
            )  
        -- tìm theo số thụ lý
        and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%'
        or UPPER(D.TL_SO) like '%' || UPPER(vSoThuly) || '%'
        )
        --Kết quả xét xử 
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID and KETQUAID = vKetquaxetxu))
                        )
        -- tìm theo cột
        AND (
        ----COLUMN_2-------Tổng số vụ án thụ lý----------
            (vKetquathuly = 2 AND NVL(d.LOAIDON,0) NOT IN(4)
                              AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                              AND D.ISTHULY = 1 
                              AND d.CD_LOAI = 0
                              AND 
                              (
                                   (d.TL_NGAY between vNgayThulyTu and vNgayThulyDen)
                                   OR
                                   (
                                            d.TL_NGAY < vNgayThulyTu                            
                                                 and (
                                                         (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 1 FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 1 FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= vNgayThulyTu)  )                     
                                                     )
                                        AND d.id !=319292
                                   )
                              ) 
              )     
----        ------COLUMN_3 Tổng số giải quyết	                          
            OR 
            (vKetquathuly = 3  AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1
                                  AND d.CD_LOAI = 0
                                  AND( 
                                  (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 1 FROM GDTTT_VUAN v 
                                                                                        WHERE v.ID = D.vuviecid 
                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                            and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen) ---XEP DON
                                                                       OR  EXISTS(SELECT 1 FROM GDTTT_DON_TRALOI kqd 
                                                                                                WHERE kqd.DONID = D.ID 
                                                                                                    and kqd.TYPETB in (3,4)
                                                                                                    and kqd.NGAY between vNgayThulyTu and vNgayThulyDen 
                                                                                                    )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )
                ) 
----        ------COLUMN_4 Tổng số giải quyết	                          
            OR 
            (vKetquathuly = 4 
                                  AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1
                                  AND d.CD_LOAI = 0
                                  AND( 
                                    (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 1 FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAY between vNgayThulyTu and vNgayThulyDen 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )    
                )    
--        ------COLUMN_5 Tổng số giải quyết	                          
            OR (vKetquathuly = 5 
                                AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1
                                  AND d.CD_LOAI = 0
                                  AND(
                                        (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 1 FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAY between vNgayThulyTu and vNgayThulyDen 
                                                                                                )    --KN                   
                                                               )                                                                                                              
                                                    )
                )   
--        ------COLUMN_6 Tổng số giải quyết	                           
            OR 
            (vKetquathuly = 6 
                                AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1
                                  AND d.CD_LOAI = 0
                                  AND ( 
                                           (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 1 FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                and v.gqd_loaiketqua in (2,3,4) 
                                                                                and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen) ---XEP DON
                                                               )
                                   )
                )            
--        ------COLUMN_7 Tổng số giải quyết	                          
            OR 
            (vKetquathuly = 7 
                              AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1
                                  AND d.CD_LOAI = 0
                                  AND d.TL_NGAY <= vNgayThulyDen             
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GDQ_NGAY > vNgayThulyDen
                                        )   
                )  
        --- end vKetquathuly
            )
            ORDER BY d.TL_SO ASC
        ) a  
        ) b where stt>=MinIndex and stt<=MaxIndex;

  END MHCA_DANHSACH_SEARCH_DON_HS;  

PROCEDURE  MHCA_DANHSACH_SEARCH_VUAN
( 
  v_ID_USER VARCHAR2,
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number, 
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  vKetquathuly in number,
  vKetquaxetxu in number,  
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,  

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);
  temp_sobanan nvarchar2(50);
  --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_CANBOID number;ma_chucvu_user VARCHAR2(150);
BEGIN
   -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  ---anhvh add 25/09/2020 check dữ liệu theo PCA
  SELECT NSD.CANBOID INTO V_CANBOID FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
  IF(vThamphan = -1)THEN
--  Chua phan cong Tham phan
    curr_thamphan_id := -1;
  ELSE 
      if(vThamphan !=0 and vThamphan is not null) then
                 select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
                 select b.Ma  into ma_chucvu_user  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = V_CANBOID;
                if  ((ma_chucvu='PCA' OR ma_chucvu='CA') and (ma_chucvu_user='PCA' OR ma_chucvu_user='CA'))then 
                        -- if (ma_chucvu='PCA' OR ma_chucvu='CA')then 
                            curr_thamphan_id:=0;
                               ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                               SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                            SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                            SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                            DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                            FROM (
                                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                                    PB WHERE PB.Id = vThamphan
                                                 )
                                            UNPIVOT --chuyển từ cột thành dòng
                                            (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                            )TT WHERE CHECK_LOAIAN=1 
                                        )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                                       GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                         )TTS;
                               -----------------------------------------------
                    ELSE
                        curr_thamphan_id:= vThamphan;
                    end if;
        else
          curr_thamphan_id:=0;
        end if;
    END IF;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
    -----Thẩm phán---------------
        IF(vPhongBanID=0 and  vThamphan != -1) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

         vvvNgayThulyTu:=NULL;
         IF(vNgayThulyTu IS NOT NULL) THEN
             vvvNgayThulyDen:=TO_DATE(to_char(vNgayThulyTu,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
         ELSE
            vvvNgayThulyDen:=vNgayThulyTu;
         END IF;
   OPEN curReturn FOR
   SELECT TSS.* FROM (
SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END DESC
                                      ) STT,TTS.*   
         FROM (
           SELECT  TT.* FROM 
         ( 
           WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                      SELECT  V.NGAYTHULYDON NGAYTHULYDONS, NVL(v.TongDon,0 ) as TongDon 
                      --anhvh
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X') CV93
                      --
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY
                                                                ,818,'<b>Kháng nghị của CA TANDTC</b>'
                                                                ,819,'<b>Kháng nghị của CA TANDCC tại Hà Nội</b>'
                                                                ,820,'<b>Kháng nghị của CA TANDCC tại Đà Nẵng</b>'
                                                                ,821,'<b>Kháng nghị của CA TANDCC tại Hồ Chí Minh</b>'
                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                         --,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                         ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        --
                         ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tt.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,4,decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                                                , 2,u'X\1ebfp \0111\01a1n' 
                                                , 1, u'Kh\00e1ng ngh\1ecb'
                                                , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                                                ,3,v.GQD_KETQUA ) KQ_GQD
                        --DECODE(NVL(v.GQD_LOAIKETQUA,3), 3, '' , 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' ) KQ_GQD
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                            ,818,'CA TANDTC'
                                                                                                            ,819,'CA TANDCC tại Hà Nội'
                                                                                                            ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                            ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                            ,'VKS'))  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        ,DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                      , TTVSS.PHANCONGTTV PHANCONGTTV
                      -- Phuc vu khi du lieu cu khong co ID TTV chi co ten TTV
--                      ,decode(v.THAMTRAVIENID,null,v.TENTHAMTRAVIEN,TTVSS.PHANCONGTTV) PHANCONGTTV 

                      ,v.TRUONGHOPTHULY
                      , 0 DONID
                      , v.IsAnQuocHoi
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID 
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3  ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                       ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                       LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                      LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID         
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                       --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                       --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=vToaAnID AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID 
                      ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                     LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')')||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON VV.THAMTRAVIENID=TTV.ID
                                 UNION ALL    
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                       ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----          
                      where 
                      v.TOAANID=vToaAnID 
                      AND v.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                      --and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                         --and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                         and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
--                      -----------------------
                      and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                      and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                        AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        or exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))

                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%'))
                             OR trim(vNguyendon) || ' '=' '

                          )           
                      ----------------------
                       and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                  )
                                )

                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                    and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                      AND(( (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0) AND  vKetquathuly >= 0 and vKetquathuly!=3) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
--                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
                      and ( (vtrangthai = 0 )
                        or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            )--anhvh                
                        or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            ) --anhvh 
                        or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )
                        or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                        or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                        or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                        or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                        --or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 10 and EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
                        or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                        or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                        or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                        or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                        or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                            and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
                     )
                  -- ý kiến tờ trình
                  and ( isTTYKienKLTotrinh = 2
                        or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                        or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                        or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                        or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                        or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                        or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                        or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                        )      
                 ------------------------------------
                       AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
                 -- Bước giải quyết
                 and ( (isBuocTT = 0)
                       OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                                    AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                                WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                                     AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                                ) 
                                                 )
                                              OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                                   AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                              WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                                   AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                              )                                                                 
                                                  )  
                                             ) 
                           )                                                              
                        OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                                    AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                              WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                        OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                        )   
                                                               )                                                          
                                                 )
                                                OR (vPhongBanID=0 
                                                AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                           WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                         )  
                                                                                     OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                        )    
                                                                                    )
                                                                                AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                          )
                                                   )
                                              )    
                           )                                                                                                            

                      )
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
--                       and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
--                          )  
--
--                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
--                                                       or(vKetquathuly =4)
--                                                    )   
--                          )  

                           ------------------------------------------             
                 and ( 
                         (vKetquathuly = 2 AND ((v.NGAYTAO between vNgayThulyTu and vNgayThulyDen  
                                                and ( v.GDQ_NGAY >= vNgayThulyTu or v.GDQ_NGAY is null)) -- do nhap hoi to nen ngay tao lon hon ngay ket qua
                                        OR (v.NGAYTAO < vNgayThulyTu 
                                                and  (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
                                                and  (v.LOAIAN = 1 and  v.gqd_loaiketqua not in (0,1,2,3,4))
                                                )  
                                        OR (v.NGAYTAO < vNgayThulyTu
                                                and (
                                                        ( v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY >= vNgayThulyTu))
                                                    OR  (v.LOAIAN = 1 and  v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY >= vNgayThulyTu)
                                                    )
                                                )
                                            )
                        )
                       OR ( vKetquathuly = 3 AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen))
                                        OR (v.LOAIAN = 1  and v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)   
                                       )         
                            )  

                       OR (vKetquathuly = 4 AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                                            )
                                                       and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                                            )         
                                                                )
                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (0) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)                                           
                                        ) 
                           )           
                       OR (vKetquathuly = 5 AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 1 --KN
                                                                            ))
                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (1) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)         
                                     ) 
                           )           
                       OR ( vKetquathuly = 6 AND( (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA in (2,3,4)
                                                                            )
                                                        and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA in (0,1))                    

                                                                            )
                                                OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)       
                                           )    
                          )            
                       OR (vKetquathuly = 7 AND v.NGAYTAO <= vNgayThulyDen
                                             and  (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
                                 and  (v.LOAIAN = 1 and ( v.GDQ_NGAY is null or to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001' ))           
                            ) 
                       OR ( vKetquathuly = 8 AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null  and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                  AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1
                       )
                       OR ( vKetquathuly = 9 AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                      AND v.THAMQUYENXXGDT = 1
                                  AND NVL(V.TRUONGHOPTHULY,0) != 1
                       )               
                       OR (vKetquathuly = 10 AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                  AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1
                                  AND NVL(V.TRUONGHOPTHULY,0) = 1
                          )            
                       OR (vKetquathuly = 11 AND ( v.XXGDTTT_NGAYQD between vNgayThulyTu and vNgayThulyDen 
                                            OR v.ISRUTKN = 1)
                                  AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1   
                           )           
                       OR (vKetquathuly = 12 AND ((v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen  and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD > vNgayThulyDen))                                 
                                   AND (NVL(v.ISRUTKN,0) = 0 ) 
                                   AND (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                   AND v.NGAYTHULYXXGDT is not null   
                                  AND v.THAMQUYENXXGDT = 1 
                           )           
                     )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------ 

                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
                        )
                  -- Thuộc án
                  and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                               --án quốc hội gồm công văn 8.1 và 9.3
                             AND EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                           )
--                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)       
                        or (LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                        or (LoaiAnDB = 99 AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                           )                                 
                   )
                 --Án thời hiệu
                   AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 -- hết thời hiệu
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1 -- còn dưới 1 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  -- còn dưới 2 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  -- còn dưới 3 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90

--                    AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
--                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
--                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                         
                    )
                  or (vLoaiAnDB_TH = 6  -- còn dưới 6 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                 ------------------------------
               and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1 ))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
--               and (v_LoaiGDT = 4 
--                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
--                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
--                             or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
--                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
--                            ) 
                and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))
                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
--                    --Ngay Ban an
                    Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
--                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
--                        --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null) 
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )

                order by v.SOTHULYDON ASC
               )a 
       )TT
      )TTS
    )TSS where TSS.stt>=MinIndex and TSS.stt<=MaxIndex 
    ;

END MHCA_DANHSACH_SEARCH_VUAN;

PROCEDURE  MHCA_DANHSACH_SEARCH_VUAN_THOIHIEU
( 
  v_ID_USER VARCHAR2,
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number, 
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  vKetquathuly in number,
  vKetquaxetxu in number,  
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,  

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);
  temp_sobanan nvarchar2(50);
  --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_CANBOID number;ma_chucvu_user VARCHAR2(150);
BEGIN
   -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  ---anhvh add 25/09/2020 check dữ liệu theo PCA
  SELECT NSD.CANBOID INTO V_CANBOID FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
  IF(vThamphan = -1)THEN
--  Chua phan cong Tham phan
    curr_thamphan_id := -1;
  ELSE 
      if(vThamphan !=0 and vThamphan is not null) then
                 select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
                 select b.Ma  into ma_chucvu_user  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = V_CANBOID;
                if  ((ma_chucvu='PCA' OR ma_chucvu='CA') and (ma_chucvu_user='PCA' OR ma_chucvu_user='CA'))then 
                        -- if (ma_chucvu='PCA' OR ma_chucvu='CA')then 
                            curr_thamphan_id:=0;
                               ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                               SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                            SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                            SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                            DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                            FROM (
                                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                                    PB WHERE PB.Id = vThamphan
                                                 )
                                            UNPIVOT --chuyển từ cột thành dòng
                                            (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                            )TT WHERE CHECK_LOAIAN=1 
                                        )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                                       GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                         )TTS;
                               -----------------------------------------------
                    ELSE
                        curr_thamphan_id:= vThamphan;
                    end if;
        else
          curr_thamphan_id:=0;
        end if;
    END IF;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
    -----Thẩm phán---------------
        IF(vPhongBanID=0 and  vThamphan != -1) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

         vvvNgayThulyTu:=NULL;
         IF(vNgayThulyTu IS NOT NULL) THEN
             vvvNgayThulyDen:=TO_DATE(to_char(vNgayThulyTu,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
         ELSE
            vvvNgayThulyDen:=vNgayThulyTu;
         END IF;
   OPEN curReturn FOR
   SELECT TSS.* FROM (
SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END DESC
                                      ) STT,TTS.*   
         FROM (
           SELECT  TT.* FROM 
         ( 
           WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                      SELECT  V.NGAYTHULYDON NGAYTHULYDONS, NVL(v.TongDon,0 ) as TongDon 
                      --anhvh
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93 
                      --
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
                                                                    ,819,'<b>Kháng nghị của CA TANDCC tại Hà Nội</b>'
                                                                    ,820,'<b>Kháng nghị của CA TANDCC tại Đà Nẵng</b>'
                                                                    ,821,'<b>Kháng nghị của CA TANDCC tại Hồ Chí Minh</b>'
                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                         --,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                         ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        --
                         ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tt.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,4,decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                                                , 2,u'X\1ebfp \0111\01a1n' 
                                                , 1, u'Kh\00e1ng ngh\1ecb'
                                                , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                                                ,3,v.GQD_KETQUA ) KQ_GQD
                        --DECODE(NVL(v.GQD_LOAIKETQUA,3), 3, '' , 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' ) KQ_GQD
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                    ,818,'CA TANDTC'
                                                                                                    ,819,'CA TANDCC tại Hà Nội'
                                                                                                      ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                      ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                    ,'VKS'))  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        ,DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                      , TTVSS.PHANCONGTTV PHANCONGTTV
                      -- Phuc vu khi du lieu cu khong co ID TTV chi co ten TTV
--                      ,decode(v.THAMTRAVIENID,null,v.TENTHAMTRAVIEN,TTVSS.PHANCONGTTV) PHANCONGTTV 

                      ,v.TRUONGHOPTHULY
                      , 0 DONID
                      , v.IsAnQuocHoi
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3  ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                       ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                       LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                      LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID         
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                       --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                       --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=vToaAnID AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID 
                      ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                     LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')')||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON VV.THAMTRAVIENID=TTV.ID
                                 UNION ALL    
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                       ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----          
                      where 
                      v.TOAANID=vToaAnID 
                      AND v.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                      --and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                         --and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                         and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
--                      -----------------------
                      and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                      and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                        AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        or exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))

                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%'))
                             OR trim(vNguyendon) || ' '=' '

                          )           
                      ----------------------
                       and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                  )
                                )

                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                    and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                      AND(( (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0) AND  vKetquathuly >= 0 and vKetquathuly!=3) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
--                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
                      and ( (vtrangthai = 0 )
                        or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            )--anhvh                
                        or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            ) --anhvh 
                        or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )
                        or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                        or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                        or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                        or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                        --or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 10 and EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
                        or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                        or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                        or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                        or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                        or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                            and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
                     )
                  -- ý kiến tờ trình
                  and ( isTTYKienKLTotrinh = 2
                        or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                        or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                        or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                        or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                        or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                        or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                        or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                        )      
                 ------------------------------------
                       AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
                 -- Bước giải quyết
                 and ( (isBuocTT = 0)
                       OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                                    AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                                WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                                     AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                                ) 
                                                 )
                                              OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                                   AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                              WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                                   AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                              )                                                                 
                                                  )  
                                             ) 
                           )                                                              
                        OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                                    AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                              WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                        OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                        )   
                                                               )                                                          
                                                 )
                                                OR (vPhongBanID=0 
                                                AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                           WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                         )  
                                                                                     OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                        )    
                                                                                    )
                                                                                AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                          )
                                                   )
                                              )    
                           )                                                                                                            

                      )
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
--                       and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
--                          )  
--
--                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
--                                                       or(vKetquathuly =4)
--                                                    )   
--                          )  

                           ------------------------------------------             
                 and ( 
                         (vKetquathuly = 2 
                                --- Co ket qua la tra loi don va khong co ket qua nao la khang nghi
                                  AND ((v.NGAYTAO between vNgayThulyTu and vNgayThulyDen  
                                                and ( v.GDQ_NGAY >= vNgayThulyTu or v.GDQ_NGAY is null)) -- do nhap hoi to nen ngay tao lon hon ngay ket qua
                                        OR (v.NGAYTAO < vNgayThulyTu  and v.gqd_loaiketqua is null
                                                )  
                                        OR (v.NGAYTAO < vNgayThulyTu

                                                    and (  ( v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY >= vNgayThulyTu))
                                                            OR  (v.LOAIAN = 1 and  v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY >= vNgayThulyTu)
                                                    )
                                                )
                                  )      
                        )
                       OR ( vKetquathuly = 3 
                                  AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen))
                                        OR (v.LOAIAN = 1  and v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)   
                                       )       
                            )  

                       OR (vKetquathuly = 4 
                                --- Co ket qua la tra loi don va khong co ket qua nao la khang nghi
                                  AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                                            )
                                                       and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                                            )         
                                                                )
                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (0) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)                                           
                                        )  
                           )           
                       OR (vKetquathuly = 5                                 
                                   AND (
                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA = 1 --KN
                                                                            ))
                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (1) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)         
                                     )    
                           )           
                       OR ( vKetquathuly = 6 
                                  ---Co ket qua la xu ly khac, xep don, vks dang gq va khong co kq nao là tld va kn                          
                                  AND( (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA in (2,3,4)
                                                                            )
                                                        and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
                                                                            AND KQ.GQD_LOAIKETQUA in (0,1))                    

                                                                            )
                                                OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)       
                                           )     
                          )            
                       OR (vKetquathuly = 7 
                                   AND v.NGAYTAO <= vNgayThulyDen
--                                  and ( (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
--                                        OR  (v.LOAIAN = 1 and  v.gqd_loaiketqua not in (0,1,2,3,4)) )  
                                  AND v.gqd_loaiketqua is null                
                            ) 
                       OR ( vKetquathuly = 8 
                                   AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                   AND v.NGAYTHULYXXGDT is not null
                                   AND v.THAMQUYENXXGDT = 1
                       )
                       OR ( vKetquathuly = 9 
                                  AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                  AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1
                                  AND NVL(V.TRUONGHOPTHULY,0) != 1 
                       )               
                       OR (vKetquathuly = 10 
                                  AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                      AND v.THAMQUYENXXGDT = 1
                                  AND NVL(V.TRUONGHOPTHULY,0) = 1
                          )            
                       OR (vKetquathuly = 11 
                                  AND ( v.XXGDTTT_NGAYQD between vNgayThulyTu and vNgayThulyDen 
                                            OR v.ISRUTKN = 1)
                                  AND v.THAMQUYENXXGDT = 1
                                  AND v.NGAYTHULYXXGDT is not null  
                           )           
                       OR (vKetquathuly = 12 
                                   AND ((v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen  and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD > vNgayThulyDen))

                                   AND (NVL(v.ISRUTKN,0) = 0 ) 
                                   AND (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                   AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1
                           )           
                     )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------ 

                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
                        )
                  -- Thuộc án
                  and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                               --án quốc hội gồm công văn 8.1 và 9.3
                             AND EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                           )
--                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)       
                        or (LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                        or (LoaiAnDB = 99 AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                           )                                 
                   )
                 --Án thời hiệu
                   AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 -- hết thời hiệu
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1 -- còn dưới 1 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  -- còn dưới 2 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  -- còn dưới 3 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90

--                    AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
--                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
--                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                         
                    )
                  or (vLoaiAnDB_TH = 6  -- còn dưới 6 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                 ------------------------------
               and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1 ))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
--               and (v_LoaiGDT = 4 
--                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
--                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
--                             or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
--                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
--                            ) 
                and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))
                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
--                    --Ngay Ban an
                    Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
--                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
--                        --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null) 
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )

                order by v.SOTHULYDON ASC
               )a 
       )TT
      )TTS
    )TSS where TSS.stt>=MinIndex and TSS.stt<=MaxIndex 
    ;

END MHCA_DANHSACH_SEARCH_VUAN_THOIHIEU;

PROCEDURE   MHCA_DANHSACH_SEARCH_DON_TP (
    v_ID_USER VARCHAR2,
    v_colume IN VARCHAR2,
    v_asc_desc IN VARCHAR2,
    vToaAnID IN NUMBER,
    vPhongBanID IN NUMBER,
    vToaRaBAQD IN NUMBER,
    vSoBAQD IN VARCHAR2,
    vNgayBAQD IN VARCHAR2,
    vNguoiGui IN VARCHAR2, 
    vCoquanchuyendon IN VARCHAR2,
    vNguyendon IN VARCHAR2,
    vBidon IN VARCHAR2, 
    vLoaiAn IN NUMBER,
    vThamphan IN NUMBER,
    vQHPLID IN NUMBER,
    vQHPLDNID IN NUMBER,
    vNgayThulyTu IN DATE,
    vNgayThulyDen IN DATE,
    vSoThuly IN VARCHAR2,
    vKetquathuly IN NUMBER,
    vKetquaxetxu IN NUMBER,
    isTTYKienKLTotrinh IN NUMBER,
    LoaiAnDB IN NUMBER,
    vLoaiAnDB_TH IN VARCHAR2,
    v_ISXINANGIAM IN NUMBER,
    v_GDT_ISXINANGIAM IN NUMBER,
    v_loaingaysearch IN NUMBER,
    v_NgaySearch_Tu IN DATE,
    v_NgaySearch_Den IN DATE,
    PageIndex IN INT,
    PageSize IN INT,
    curReturn OUT SYS_REFCURSOR
  ) IS
    TotalItem number;  MinIndex	number;  MaxIndex	number;
  BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

    OPEN curReturn FOR
        select * from
        (
            select a.*,
            ROW_NUMBER() OVER (
                    ORDER BY 
                    CASE 
                        WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                    END ASC,
                    CASE 
                        WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN a.TL_NGAY 
                    END DESC
                ) AS STT
            from (
                SELECT
                D.VUVIECID ID,
                D.ID DONID,
                COUNT(1) OVER () AS CountAll,
                D.TL_SO,
                D.TL_NGAY,
                case when d.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(d.BAQD_SO, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (d.BAQD_SO_PT,null,'',' ','','<br/><br/>'||d.BAQD_SO_PT||'<br/>'||to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (d.BAQD_SO_ST,null,'',' ','','<br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when d.BAQD_CAPXETXU = 3  then
                                             NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_PT, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (d.BAQD_SO_ST,null,'',' ','','<br/><br/>'||d.BAQD_SO_ST||'<br/>'||to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when d.BAQD_CAPXETXU = 2 
                                        then NVL(d.BAQD_SO_ST, NVL(d.BAQD_SO_ST, 'null')) || 
                                             '<br/>'|| decode (to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(d.BAQD_SO_PT, NVL(d.BAQD_SO_ST, ''))
                                            ||'<br/>'|| decode(to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'),null,to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy'),'01/01/0001','',to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA,
    --            decode(Trim(v.QHPL_TEXT),null,decode(Trim(qhpl.TenQHPL),null,TD.DIEU ||'.'|| TD.TENTOIDANH,qhpl.TenQHPL),v.QHPL_TEXT) QUANHEPL,
                CASE
                    WHEN D.VUVIECID > 0 
                    THEN DECODE(Trim(v.QHPL_TEXT), null,
                             decode(Trim(qhpl.TenQHPL), null, TD.DIEU ||'.'|| TD.TENTOIDANH, qhpl.TenQHPL),
                             v.QHPL_TEXT)
                    ELSE NULL
                END AS QUANHEPL,
    --            v.NGUYENDON,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 5 THEN d.NGUOIGUI_HOTEN
                ELSE v.NGUYENDON
                END AS NGUYENDON,
    --            v.BIDON,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 6 THEN d.NGUOIGUI_HOTEN                
                    WHEN d.BAQD_LOAIAN = 1 and (d.NGUOIGUI_TUCACHTOTUNG = 7 or d.NGUOIGUI_TUCACHTOTUNG = 1) THEN d.NGUOIGUI_HOTEN
                ELSE v.BIDON
                END AS BIDON,
--                DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
--                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
--                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
--                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
--                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
--                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI,
                CASE
                    WHEN d.NGUOIGUI_TUCACHTOTUNG = 9 THEN d.NGUOIGUI_HOTEN                
                ELSE d.DONGKHIEUNAI
                END AS NGUOIKHIEUNAI,
                TP.HOTEN AS TENTHAMPHAN,
                d.BAQD_LOAIAN LOAIAN,
                v.gqd_loaiketqua KQLOAI,
                ct.CANBOID,
                D.LOAICONGVAN THUOCDON,            
                D.CV_SO,
                D.CV_TENDONVI,
                TO_CHAR(D.CV_NGAY, 'dd/MM/yyyy') CV_NGAY,
                --
                D.TL_SO SOTHULY,
                TO_CHAR(D.TL_NGAY, 'dd/MM/yyyy') NGAYTHULY,
                --
                v.XXGDTTT_SOQD SOQDXX,
                TO_CHAR(v.XXGDTTT_NGAYQD, 'dd/MM/yyyy') NGAYQDXX,
                --
                v.SOTHULYXXGDT SOTHULYXX,
                TO_CHAR(v.NGAYTHULYXXGDT, 'dd/MM/yyyy') NGAYTHULYXX,
                --
                v.GDQ_SO KQSO,
                TO_CHAR(v.GDQ_NGAY, 'dd/MM/yyyy') KQNGAY

            FROM GDTTT_DON D
            LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID 
            left join DM_TOAAN txx on d.BAQD_TOAANID_PT=txx.ID
            left join DM_TOAAN tst on d.BAQD_TOAANID_ST=tst.ID
            left join DM_TOAAN tqd on d.BAQD_TOAANID=tqd.ID
            LEFT JOIN DM_CANBO tp on D.THAMPHANID=tp.ID
            left join(select HD.* FROM GDTTT_VuAn_XXGDTT_HoiDong HD where NVL(HD.IsChuToa,0)=1)ct on ct.VUANID=v.id
            left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
            LEFT JOIN DM_BOLUAT_TOIDANH td ON V.QHPL_THONGKEID = td.ID
            LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID

            WHERE 
            -- tìm theo tòa án
            D.TOAANID = vToaAnID  
            -- tìm theo phòng ban
    --        AND ((v.PhongBanID = vPhongBanID) OR (vPhongBanID = 0 OR vPhongBanID IS NULL))
            and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD 
            or d.BAQD_TOAANID = vToaRaBAQD
            )
            -- tìm theo loại án
            AND ( (vloaian = 0 AND ((instr(','||vloaian||',',','||d.BAQD_LOAIAN||',')>0 and vThamphan=0 and vPhongBanID=0) or (vThamphan!=0 or vPhongBanID!=0) ))
                                 or  (vloaian = d.BAQD_LOAIAN and vloaian!=0) 
                            ) 
            -- tìm theo thẩm phán                
            AND ( vThamphan = 0 or D.THAMPHANID=vThamphan 
            Or (vThamphan = -1 and NVL(D.THAMPHANID,0) = 0) 
            )
            -- tìm theo số bản án
            and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_ST) like '%' || UPPER(vSoBAQD) || '%'
            or UPPER(d.BAQD_SO_PT) like '%' || UPPER(vSoBAQD) || '%'
            )  
            -- tìm theo ngày bản án
             and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy') = vNgayBAQD
             or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy') = vNgayBAQD
             )
            -- tìm theo nguyên đơn
            AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                            OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                      )

                                            ))

                                 OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                        AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                         )
                                        )
                                 OR trim(vNguyendon) || ' '=' '

                              )             
            -- tìm theo bị đơn
            and ( vBidon is null 
                                or vBidon = '' 
                                or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                            and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                      )
                                    )
            -- tìm theo người gửi đơn
            AND ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%'
            or UPPER(d.NGUOIGUI_HOTEN) like '%' || UPPER(vNguoiGui) || '%'
            )  
            -- tìm theo số thụ lý
            and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%'
            or UPPER(D.TL_SO) like '%' || UPPER(vSoThuly) || '%'
            )
            --Kết quả xét xử 
                         and ( vKetquaxetxu = 0
                            or (vKetquaxetxu = -1
                                      AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)=0)
                            or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(D.VUVIECID, 0)>0)
                            or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where D.VUVIECID = VUANID and KETQUAID = vKetquaxetxu))
                            )
            -- tìm theo cột
            AND (
            ----COLUMN_2-------Tổng số vụ án thụ lý----------
                (vKetquathuly = 2 AND NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                  AND D.ISTHULY = 1  
                                  AND d.CD_LOAI = 0
                                  AND 
                                  (
                                       (d.TL_NGAY between vNgayThulyTu and vNgayThulyDen)
                                       OR
                                       (
                                                d.TL_NGAY < vNgayThulyTu                            
                                                     and ( 
                                                        (d.BAQD_LOAIAN != 1 AND  EXISTS(SELECT 1 FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GDQ_NGAY >= vNgayThulyTu))
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 1 FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1)) 
                                                        or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GDQ_NGAY >= vNgayThulyTu)  )                                                
                                                                    )
                                                  AND d.id !=319292                  
                                       )
                                  )  
                  )     
    ----        ------COLUMN_3 Tổng số giải quyết	                          
                OR 
                (vKetquathuly = 3  AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao > to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND( 
                                      (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen))  
                                      OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAY between vNgayThulyTu and vNgayThulyDen  
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                          
                                      )
                    ) 
    ----        ------COLUMN_4 Tổng số giải quyết	                          
--                OR 
--                (vKetquathuly = 4 
--                                      AND NVL(d.LOAIDON,0) NOT IN(4)
--                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                      AND D.ISTHULY = 1
--                                      AND d.CD_LOAI = 0
--                                      AND 
--                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
--                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
--                                                            WHERE KQD.DONID = D.ID 
--                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                            AND KQ.GQD_LOAIKETQUA = 0
--                                                            AND KQD.TRANGTHAI = 1
--                                                            )
--                                                        )  
--                    )    
    --        ------COLUMN_5 Tổng số giải quyết	                          
--                OR (vKetquathuly = 5 
--                                    AND NVL(d.LOAIDON,0) NOT IN(4)
--                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                      AND D.ISTHULY = 1
--                                      AND d.CD_LOAI = 0
--                                      AND
--                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
--                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
--                                                            WHERE KQD.DONID = D.ID 
--                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                            AND KQ.GQD_LOAIKETQUA = 1
--                                                            AND KQD.TRANGTHAI = 1
--                                                            )
--                                                        )
--                    )   
    --        ------COLUMN_6 Tổng số giải quyết	                           
--                OR 
--                (vKetquathuly = 6 
--                                    AND NVL(d.LOAIDON,0) NOT IN(4)
--                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
--                                      AND D.ISTHULY = 1
--                                      AND d.CD_LOAI = 0
--                                      AND ( 
--                                      (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
--                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
--                                                            WHERE KQD.DONID = D.ID 
--                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
--                                                            AND KQD.TRANGTHAI = 1
--                                                            )
--                                                        )
--                                       )
--                    )            
    --        ------COLUMN_7 Tổng số giải quyết	                          
                OR 
                (vKetquathuly = 7 
                                  AND NVL(d.LOAIDON,0) NOT IN(4)
                                      AND d.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                                      AND D.ISTHULY = 1
                                      AND d.CD_LOAI = 0
                                      AND d.TL_NGAY <= vNgayThulyDen 
                                      and (
                                            (d.BAQD_LOAIAN != 1 AND KQ.gqd_loaiketqua IS NULL OR KQ.GDQ_NGAY > vNgayThulyDen)

                                            OR ( d.BAQD_LOAIAN = 1              
                                                  and ( v.gqd_loaiketqua IS NULL 
                                                        OR  v.GDQ_NGAY > vNgayThulyDen
                                                        )  
                                                )
                                            )
                    )  
            --- end vKetquathuly
                )
            ) a 
        ) b where stt>=MinIndex and stt<=MaxIndex;

  END MHCA_DANHSACH_SEARCH_DON_TP; 

PROCEDURE  MHCA_DANHSACH_SEARCH_VUAN_TP
( 
  v_ID_USER VARCHAR2,
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number, 
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  vKetquathuly in number,
  vKetquaxetxu in number,  
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,  

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);
  temp_sobanan nvarchar2(50);
  --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_CANBOID number;ma_chucvu_user VARCHAR2(150);
BEGIN
   -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  ---anhvh add 25/09/2020 check dữ liệu theo PCA
  SELECT NSD.CANBOID INTO V_CANBOID FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
  IF(vThamphan = -1)THEN
--  Chua phan cong Tham phan
    curr_thamphan_id := -1;
  ELSE 
      if(vThamphan !=0 and vThamphan is not null) then
                 select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
                 select b.Ma  into ma_chucvu_user  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = V_CANBOID;
                if  ((ma_chucvu='PCA' OR ma_chucvu='CA') and (ma_chucvu_user='PCA' OR ma_chucvu_user='CA'))then 
                        -- if (ma_chucvu='PCA' OR ma_chucvu='CA')then 
                            curr_thamphan_id:=0;
                               ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                               SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                            SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                            SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                            DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                            FROM (
                                                    SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                                    PB WHERE PB.Id = vThamphan
                                                 )
                                            UNPIVOT --chuyển từ cột thành dòng
                                            (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                            )TT WHERE CHECK_LOAIAN=1 
                                        )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                                       GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                         )TTS;
                               -----------------------------------------------
                    ELSE
                        curr_thamphan_id:= vThamphan;
                    end if;
        else
          curr_thamphan_id:=0;
        end if;
    END IF;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
    -----Thẩm phán---------------
        IF(vPhongBanID=0 and  vThamphan != -1) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

         vvvNgayThulyTu:=NULL;
         IF(vNgayThulyTu IS NOT NULL) THEN
             vvvNgayThulyDen:=TO_DATE(to_char(vNgayThulyTu,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
         ELSE
            vvvNgayThulyDen:=vNgayThulyTu;
         END IF;
   OPEN curReturn FOR
   SELECT TSS.* FROM (
SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END DESC
                                      ) STT,TTS.*   
         FROM (
           SELECT  TT.* FROM 
         ( 
           WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                      SELECT  V.NGAYTHULYDON NGAYTHULYDONS, NVL(v.TongDon,0 ) as TongDon 
                      --anhvh
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93 
                      --
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                       ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
                                                                  ,819,'<b>Kháng nghị của CA TANDCC tại Hà Nội</b>'
																	,820,'<b>Kháng nghị của CA TANDCC tại Đà Nẵng</b>'
																	,821,'<b>Kháng nghị của CA TANDCC tại Hồ Chí Minh</b>'
                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                         --,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                         ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        --
                         ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tt.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,4,decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                                                , 2,u'X\1ebfp \0111\01a1n' 
                                                , 1, u'Kh\00e1ng ngh\1ecb'
                                                , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                                                ,3,v.GQD_KETQUA ) KQ_GQD
                        --DECODE(NVL(v.GQD_LOAIKETQUA,3), 3, '' , 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' ) KQ_GQD
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                        ,818,'CA TANDTC'
                                                                                                        ,819,'CA TANDCC tại Hà Nội'
                                                                                                        ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                        ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                        ,'VKS'))  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        ,DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                      , TTVSS.PHANCONGTTV PHANCONGTTV
                      -- Phuc vu khi du lieu cu khong co ID TTV chi co ten TTV
--                      ,decode(v.THAMTRAVIENID,null,v.TENTHAMTRAVIEN,TTVSS.PHANCONGTTV) PHANCONGTTV 

                      ,v.TRUONGHOPTHULY
                      , 0 DONID
                      , v.IsAnQuocHoi
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3  ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                       ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                       LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                      LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID         
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                       --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                       --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=vToaAnID AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID 
                      ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                     LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')')||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON VV.THAMTRAVIENID=TTV.ID
                                 UNION ALL    
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                       ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----          
                      where 
                      v.TOAANID=vToaAnID 
                      AND v.ngaytao> to_Date('01/01/2024','dd/MM/yyyy')
                      --and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                         --and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                         and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
--                      -----------------------
                      and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                      and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                        AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        or exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))

                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%'))
                             OR trim(vNguyendon) || ' '=' '

                          )           
                      ----------------------
                       and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                  )
                                )

                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                    and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                      AND(( (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0) AND  vKetquathuly >= 0 and vKetquathuly!=3) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
--                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
                      and ( (vtrangthai = 0 )
                        or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            )--anhvh                
                        or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            ) --anhvh 
                        or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )
                        or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                        or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                        or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                        or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                        --or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 10 and EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID AND PA.TINHTRANGID=10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
                        or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                        or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                        or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                        or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                        or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                            and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
                     )
                  -- ý kiến tờ trình
                  and ( isTTYKienKLTotrinh = 2
                        or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                        or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                        or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                        or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                        or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                        or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                        or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                        )      
                 ------------------------------------
                       AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
                 -- Bước giải quyết
                 and ( (isBuocTT = 0)
                       OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                                    AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                                WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                                     AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                                ) 
                                                 )
                                              OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                                   AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                              WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                                   AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                              )                                                                 
                                                  )  
                                             ) 
                           )                                                              
                        OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                                    AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                              WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                        OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                        )   
                                                               )                                                          
                                                 )
                                                OR (vPhongBanID=0 
                                                AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                           WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                         )  
                                                                                     OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                          AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                        )    
                                                                                    )
                                                                                AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                          )
                                                   )
                                              )    
                           )                                                                                                            

                      )
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
--                       and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
--                          )  
--
--                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
--                                                       or(vKetquathuly =4)
--                                                    )   
--                          )  

                           ------------------------------------------             
                 and ( 
--                         (vKetquathuly = 2 
--                                --- Co ket qua la tra loi don va khong co ket qua nao la khang nghi
--                                  AND ((v.NGAYTAO between vNgayThulyTu and vNgayThulyDen  
--                                                and ( v.GDQ_NGAY >= vNgayThulyTu or v.GDQ_NGAY is null)) -- do nhap hoi to nen ngay tao lon hon ngay ket qua
--                                        OR (v.NGAYTAO < vNgayThulyTu  and v.gqd_loaiketqua is null
--                                                )  
--                                        OR (v.NGAYTAO < vNgayThulyTu
--                                                
--                                                    and (  ( v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY >= vNgayThulyTu))
--                                                            OR  (v.LOAIAN = 1 and  v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY >= vNgayThulyTu)
--                                                    )
--                                                )
--                                  )      
--                        )
--                       OR ( vKetquathuly = 3 
--                                  AND (
--                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen))
--                                        OR (v.LOAIAN = 1  and v.gqd_loaiketqua  in (0,1,2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)   
--                                       )       
--                            )  
--
--                       OR (vKetquathuly = 4 
--                                --- Co ket qua la tra loi don va khong co ket qua nao la khang nghi
--                                  AND (
--                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
--                                                                        WHERE KQ.VUANID = v.ID 
--                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                                            AND KQ.GQD_LOAIKETQUA = 0
--                                                                            )
--                                                       and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
--                                                                        WHERE KQ.VUANID = v.ID 
--                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                                            AND KQ.GQD_LOAIKETQUA = 1
--                                                                            )         
--                                                                )
--                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (0) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)                                           
--                                        )  
--                           )           
--                       OR (vKetquathuly = 5                                 
--                                   AND (
--                                        (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
--                                                                        WHERE KQ.VUANID = v.ID 
--                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                                            AND KQ.GQD_LOAIKETQUA = 1 --KN
--                                                                            ))
--                                         OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (1) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)         
--                                     )    
--                           )           
--                       OR ( vKetquathuly = 6 
--                                  ---Co ket qua la xu ly khac, xep don, vks dang gq va khong co kq nao là tld va kn                          
--                                  AND( (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
--                                                                        WHERE KQ.VUANID = v.ID 
--                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                                            AND KQ.GQD_LOAIKETQUA in (2,3,4)
--                                                                            )
--                                                        and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
--                                                                        WHERE KQ.VUANID = v.ID 
--                                                                            AND KQ.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen
--                                                                            AND KQ.GQD_LOAIKETQUA in (0,1))                    
--                                                                            
--                                                                            )
--                                                OR (v.LOAIAN = 1 and v.gqd_loaiketqua  in (2,3,4) and v.GDQ_NGAY between vNgayThulyTu and vNgayThulyDen)       
--                                           )     
--                          )            
--                       OR (vKetquathuly = 7 
--                                   AND v.NGAYTAO <= vNgayThulyDen
----                                  and ( (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
----                                        OR  (v.LOAIAN = 1 and  v.gqd_loaiketqua not in (0,1,2,3,4)) )  
--                                  AND v.gqd_loaiketqua is null                
--                            ) 
                       ( vKetquathuly = 8 
                                   AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
                                   AND v.NGAYTHULYXXGDT is not null
                                   AND v.THAMQUYENXXGDT = 1
                       )
--                       OR ( vKetquathuly = 9 
--                                  AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
--                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
--                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
--                                  AND v.NGAYTHULYXXGDT is not null
--                                  AND v.THAMQUYENXXGDT = 1
--                                  AND NVL(V.TRUONGHOPTHULY,0) != 1 
--                       )               
--                       OR (vKetquathuly = 10 
--                                  AND (v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen
--                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) )
--                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD >= vNgayThulyTu))     
--                                      AND v.THAMQUYENXXGDT = 1
--                                  AND NVL(V.TRUONGHOPTHULY,0) = 1
--                          )            
                       OR (vKetquathuly = 11 
                                  AND ( v.XXGDTTT_NGAYQD between vNgayThulyTu and vNgayThulyDen 
                                            OR v.ISRUTKN = 1)
                                  AND v.THAMQUYENXXGDT = 1
                                  AND v.NGAYTHULYXXGDT is not null  
                           )           
                       OR (vKetquathuly = 12 
                                   AND ((v.NGAYTHULYXXGDT between vNgayThulyTu and vNgayThulyDen  and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < vNgayThulyTu and v.XXGDTTT_NGAYQD is not null and to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.XXGDTTT_NGAYQD > vNgayThulyDen))

                                   AND (NVL(v.ISRUTKN,0) = 0 ) 
                                   AND (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ) 
                                   AND v.NGAYTHULYXXGDT is not null
                                  AND v.THAMQUYENXXGDT = 1
                           )           
                     )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------ 

                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
                        )
                  -- Thuộc án
                  and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                               --án quốc hội gồm công văn 8.1 và 9.3
                             AND EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                           )
--                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)       
                        or (LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                        or (LoaiAnDB = 99 AND EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                           )                                 
                   )
                 --Án thời hiệu
                   AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 -- hết thời hiệu
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1 -- còn dưới 1 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  -- còn dưới 2 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  -- còn dưới 3 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90

--                    AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
--                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
--                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                         
                    )
                  or (vLoaiAnDB_TH = 6  -- còn dưới 6 tháng
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                 ------------------------------
               and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1 ))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
--               and (v_LoaiGDT = 4 
--                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
--                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
--                             or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
--                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
--                            ) 
                and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))
                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
--                    --Ngay Ban an
                    Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
--                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
--                        --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or ThamTraVienId is not null) 
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )

                order by v.SOTHULYDON ASC
               )a 
       )TT
      )TTS
    )TSS where TSS.stt>=MinIndex and TSS.stt<=MaxIndex 
    ;

END MHCA_DANHSACH_SEARCH_VUAN_TP;

END PKG_DASHBOARD_GDT;

/
