create or replace PACKAGE BODY      PKG_LOAD_DM_QDVUAN_KETTHUC AS

--------------LOAD DROPDOWNLIST QUYẾT ĐỊNH KẾT THÚC-------------
PROCEDURE DM_QUYETDINH_VUAN_SOTHAM_KETTHUC
(
    VLOAIAN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) AS           
BEGIN  
    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE  ISHINHSU = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
        OPEN curReturn FOR    
            SELECT TEN, ID
            FROM DM_QD_QUYETDINH
            WHERE ISDANSU = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình 
        OPEN curReturn FOR    
            SELECT TEN, ID
            FROM DM_QD_QUYETDINH
            WHERE ISHNGD = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN; 
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế  
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE ISKDTM = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '5') THEN -- Lao động  
        OPEN curReturn FOR   
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE   ISLAODONG = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE ISHANHCHINH = 1 AND ISSOTHAM = 1  AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản  
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH 
            WHERE ISPHASAN = 1 AND ISSOTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    END IF;
END DM_QUYETDINH_VUAN_SOTHAM_KETTHUC;
PROCEDURE DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC
(
    VLOAIAN VARCHAR2,
    curReturn OUT SYS_REFCURSOR
) AS           
BEGIN  
    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE  ISHINHSU = 1 AND ISPHUCTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
        OPEN curReturn FOR    
            SELECT TEN, ID
            FROM DM_QD_QUYETDINH
            WHERE ISPHUCTHAM = 1 AND ISDANSU = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình 
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE ISHNGD = 1 AND ISPHUCTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN; 
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế  
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE ISKDTM = 1 AND ISPHUCTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '5') THEN -- Lao động  
        OPEN curReturn FOR   
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE   ISLAODONG = 1 AND ISPHUCTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH
            WHERE ISHANHCHINH = 1 AND ISPHUCTHAM = 1  AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản  
        OPEN curReturn FOR    
            SELECT TEN,ID
            FROM DM_QD_QUYETDINH 
            WHERE ISPHASAN = 1 AND ISPHUCTHAM = 1 AND KET_THUC = 1 AND HIEULUC = 1
            ORDER BY TEN;
    END IF;
END DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC;

-------------LOAD QUYẾT ĐỊNH KẾT THÚC DGLIST------------
PROCEDURE DGLIST_BAQD_QUYETDINH_KETTHUC_ST
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        VTHULYID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS    

    CountBanAnPT int;
  BEGIN    

    -- Hình sự
        OPEN curReturn FOR  
            select count(ID) into CountBanAnPT from AHS_SOTHAM_BANAN where VuAnID = VDONID;       
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
                  ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
                    else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
                  ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
                  , CountBanAnPT IsBanAnST,q.TOA_GIAIQUYET_ID
              From AHS_SOTHAM_QUYETDINH_VUAN q
              left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3  or d.loaiid = 10 or d.loaiid = 15 or q.quyetdinhid = 324)
              left join AHS_FILE f on q.FILEID = f.ID
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.DONVIID
              left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
              left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
              left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
              left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
              Where q.VUANID=VDONID AND Q.THULYID = VTHULYID
              ORder by q.NGAYTAO;
END DGLIST_BAQD_QUYETDINH_KETTHUC_ST;

PROCEDURE DGLIST_BAQD_QUYETDINH_KETTHUC_ST
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS    

    CountBanAnPT int;
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
            select count(ID) into CountBanAnPT from AHS_SOTHAM_BANAN where VuAnID = VDONID;       
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
                  ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
                    else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
                  ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
                  , CountBanAnPT IsBanAnST,q.TOA_GIAIQUYET_ID
              From AHS_SOTHAM_QUYETDINH_VUAN q
              left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND d.ket_thuc = 1--and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3  or d.loaiid = 10 or d.loaiid = 15 or q.quyetdinhid = 324)
              left join AHS_FILE f on q.FILEID = f.ID
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.DONVIID
              left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
              left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
              left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
              left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
              Where q.VUANID=VDONID
              ORder by q.NGAYTAO;
              
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
            select count(ID) into CountBanAnPT from ADS_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, Q.NOIDUNG,q.TOA_GIAIQUYET_ID
              From ADS_SOTHAM_QUYETDINH q
              left join ADS_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from ADS_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
            select count(ID) into CountBanAnPT from AHN_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, Q.NOIDUNG,q.TOA_GIAIQUYET_ID
              From AHN_SOTHAM_QUYETDINH q
              left join AHN_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AHN_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;    
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
            select count(ID) into CountBanAnPT from AKT_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, Q.NOIDUNG, q.TOA_GIAIQUYET_ID
              From AKT_SOTHAM_QUYETDINH q
              left join AKT_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AKT_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;    
    ELSIF(VLOAIAN = '5') THEN -- Lao động
            select count(ID) into CountBanAnPT from ALD_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, q.TOA_GIAIQUYET_ID
              From ALD_SOTHAM_QUYETDINH q
              left join ALD_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from ALD_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;   
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
            select count(ID) into CountBanAnPT from AHC_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, Q.NOIDUNG, q.TOA_GIAIQUYET_ID
              From AHC_SOTHAM_QUYETDINH q
              left join AHC_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AHC_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
            select count(ID) into CountBanAnPT from APS_SOTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST, Q.NOIDUNG
              From APS_SOTHAM_QUYETDINH q
              left join APS_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOAANID
              Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;    
    END IF;
END DGLIST_BAQD_QUYETDINH_KETTHUC_ST;

PROCEDURE DGLIST_BAQD_QUYETDINH_KETTHUC_PT
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS    

    CountBanAnPT int;
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
            select count(ID) into CountBanAnPT from AHS_PHUCTHAM_BANAN where VuAnID = VDONID;       
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU,q.TENFILE,q.FILEID,q.QUYETDINHID
                  ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
                    else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,c.ID as NGUOIKYID
                  ,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,t.TEN TENTOAAN
                  , CountBanAnPT IsBanAnST
                  ,q.TOA_GIAIQUYET_ID
              From AHS_PHUCTHAM_QUYETDINH_VUAN q
              left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and (d.ten LIKE '%Quyết định đình chỉ%' or d.loaiid = 3  or d.loaiid = 10 or d.loaiid = 15 or q.quyetdinhid = 324)
              left join AHS_FILE f on q.FILEID = f.ID
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.DONVIID
              left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
              left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
              left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
              left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
              Where q.VUANID=VDONID
              ORder by q.NGAYTAO;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
            select count(ID) into CountBanAnPT from ADS_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST
                   ,q.TOA_GIAIQUYET_ID
              From ADS_PHUCTHAM_QUYETDINH q
              left join ADS_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from ADS_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
            select count(ID) into CountBanAnPT from AHN_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST
                   , q.TOA_GIAIQUYET_ID
              From AHN_PHUCTHAM_QUYETDINH q
              left join AHN_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AHN_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;    
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
            select count(ID) into CountBanAnPT from AKT_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST,q.TOA_GIAIQUYET_ID
              From AKT_PHUCTHAM_QUYETDINH q
              left join AKT_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AKT_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;    
    ELSIF(VLOAIAN = '5') THEN -- Lao động
            select count(ID) into CountBanAnPT from ALD_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST
                   ,q.TOA_GIAIQUYET_ID --hoangndh vnpt 09072025
              From ALD_PHUCTHAM_QUYETDINH q
              left join ALD_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from ALD_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;   
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
            select count(ID) into CountBanAnPT from AHC_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST
                   ,q.TOA_GIAIQUYET_ID --hoangndh vnpt 10072025
              From AHC_PHUCTHAM_QUYETDINH q
              left join AHC_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOA_GIAIQUYET_ID
              Where q.DONID=vDONID or q.DonID in (Select id from AHC_DON where vuangocid = vDonid)
              ORder by q.NGAYTAO;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
            select count(ID) into CountBanAnPT from APS_PHUCTHAM_BANAN where DonID = vDONID;    
            --------------------------
            OPEN curReturn FOR  
              Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU,q.QUYETDINHID
                  ,d.TEN as TenQD,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
                   ,q.NGAYTAO,q.NGUOITAO,t.TEN TENTOAAN,q.TENFILE,q.FILEID
                   , CountBanAnPT IsBanAnST
              From APS_PHUCTHAM_QUYETDINH q
              left join APS_FILE f on q.FILEID=f.ID
              left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
              inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.ket_thuc = 1
              left join DM_CANBO c on c.ID=q.NGUOIKYID
              left join DM_TOAAN t on t.ID=q.TOAANID
              Where q.DONID=vDONID or q.DonID in (Select id from APS_DON where vuangocid = vDonid)
              ORder by q.NGAYQD;    
    END IF;
END DGLIST_BAQD_QUYETDINH_KETTHUC_PT;


--------PHÚC THẨM KC/KN TĐC-------------
PROCEDURE ADS_DM_QUYETDINH_VUAN_PTQDK
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN, ID
    FROM DM_QD_QUYETDINH
    WHERE ISPHUCTHAM = 1 AND ISDANSU = 1 
            AND (  TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%')
    ORDER BY TEN;
END ADS_DM_QUYETDINH_VUAN_PTQDK;

END PKG_LOAD_DM_QDVUAN_KETTHUC;