create or replace PACKAGE BODY      PKG_LOAD_DM_QDVUAN AS

--------------SƠ THẨM------------- 
PROCEDURE ADS_QUYETDINH_NHAPVUAN
    (
        vdonid in number,
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT dm.ID,dm.TEN || ' số '|| q.SOQD || ' ngày ' || to_char(q.NGAYQD,'dd/MM/yyyy') as TEN
    FROM ADS_SOTHAM_QUYETDINH q
           left join DM_QD_QUYETDINH dm on q.QUYETDINHID = dm.id
    WHERE q.donid = vdonid
        and dm.MA = 'QDNHAP'
    ORDER BY q.NGAYQD;
END ADS_QUYETDINH_NHAPVUAN;


PROCEDURE ADS_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISDANSU = 1 AND ISSOTHAM = 1 AND KET_THUC != 1 AND HIEULUC = 1
            AND TEN like '%Quyết định%' OR TEN LIKE '14-DS. Thông báo về việc thu thập được tài liệu, chứng cứ%' 
            OR TEN LIKE '05-VDS. Thông báo nộp tiền tạm ứng lệ phí yêu cầu giải quyết việc dân sự%' -- Load tất cả quyết định - vnpt- lê bá thọ - 27/11/2025
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
            
    ORDER BY TEN;
END ADS_DM_QUYETDINH_VUAN;
PROCEDURE AHC_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISHANHCHINH = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
            AND TEN like '%Quyết định%' OR TEN LIKE '14-DS. Thông báo về việc thu thập được tài liệu, chứng cứ%' 
            OR TEN LIKE '05-VDS. Thông báo nộp tiền tạm ứng lệ phí yêu cầu giải quyết việc dân sự%' -- Load tất cả quyết định - vnpt- lê bá thọ - 27/11/2025
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
    ORDER BY TEN;
END AHC_DM_QUYETDINH_VUAN;
PROCEDURE AHN_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISHNGD = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
           AND TEN like '%Quyết định%' OR TEN LIKE '14-DS. Thông báo về việc thu thập được tài liệu, chứng cứ%' 
            OR TEN LIKE '05-VDS. Thông báo nộp tiền tạm ứng lệ phí yêu cầu giải quyết việc dân sự%' -- Load tất cả quyết định - vnpt- lê bá thọ - 27/11/2025
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
-- Bỏ đi vì đây là quyết định gây kết thúc
--            AND ID != 70       -- 93-DS. Quyết định giải quyết việc dân sự
--            AND ID != 425      -- 22-VDS. Quyết định sơ thẩm giải quyết việc dân sự
    ORDER BY TEN;
END AHN_DM_QUYETDINH_VUAN;
PROCEDURE AHS_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE  ISHINHSU = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
            AND TEN like '%Quyết định%' -- Load tất cả quyết định
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 121  -- Bắt, tạm giam
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
    ORDER BY TEN;
END AHS_DM_QUYETDINH_VUAN;
PROCEDURE AKT_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISKDTM = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
            AND TEN like '%Quyết định%' OR TEN LIKE '14-DS. Thông báo về việc thu thập được tài liệu, chứng cứ%' 
            OR TEN LIKE '05-VDS. Thông báo nộp tiền tạm ứng lệ phí yêu cầu giải quyết việc dân sự%' -- Load tất cả quyết định - vnpt- lê bá thọ - 27/11/2025
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
    ORDER BY TEN;
END AKT_DM_QUYETDINH_VUAN;
PROCEDURE ALD_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE   ISLAODONG = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
           AND TEN like '%Quyết định%' OR TEN LIKE '14-DS. Thông báo về việc thu thập được tài liệu, chứng cứ%' 
            OR TEN LIKE '05-VDS. Thông báo nộp tiền tạm ứng lệ phí yêu cầu giải quyết việc dân sự%' -- Load tất cả quyết định - vnpt- lê bá thọ - 27/11/2025
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS)
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
    ORDER BY TEN;
END ALD_DM_QUYETDINH_VUAN;
PROCEDURE APS_DM_QUYETDINH_VUAN
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH 
    WHERE ISPHASAN = 1 AND ISSOTHAM = 1 AND KET_THUC != 1  AND HIEULUC = 1
            AND TEN like '%Quyết định%' -- Load tất cả quyết định
            AND TEN not like '%Quyết định đình chỉ%' -- Trừ quyết định đình chỉ (vì có Đình chỉ BPXLHC và VDS) 
            AND LOAIID != 23   -- Công nhận thuận tình ly hôn và sự thỏa thuận của các đương sự
            AND LOAIID != 10   -- Công nhận thỏa thuận của các đương sự
            AND LOAIID != 3    -- Đình chỉ
            AND LOAIID != 15   -- Trả hồ sơ cho VKS
    ORDER BY TEN;
END APS_DM_QUYETDINH_VUAN;
----------------------------------

-------------PHÚC THẨM------------
PROCEDURE ADS_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISDANSU = 1 AND ISPHUCTHAM = 1 AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END ADS_DM_QUYETDINH_VUAN_PT;
PROCEDURE AHC_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISHANHCHINH = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END AHC_DM_QUYETDINH_VUAN_PT;
PROCEDURE AHN_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISHNGD = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END AHN_DM_QUYETDINH_VUAN_PT;
PROCEDURE AHS_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR  
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE  ISHINHSU = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
        AND LOAIID != 121 -- Không load quyết định bắt tạm giam
    ORDER BY TEN;
END AHS_DM_QUYETDINH_VUAN_PT;
PROCEDURE AKT_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE ISKDTM = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END AKT_DM_QUYETDINH_VUAN_PT;
PROCEDURE ALD_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH
    WHERE   ISLAODONG = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END ALD_DM_QUYETDINH_VUAN_PT;
PROCEDURE APS_DM_QUYETDINH_VUAN_PT
    (
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    
OPEN curReturn FOR    
    SELECT TEN,ID
    FROM DM_QD_QUYETDINH 
    WHERE ISPHASAN = 1 AND ISPHUCTHAM = 1  AND KET_THUC != 1 AND HIEULUC = 1
        AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
    ORDER BY TEN;
END APS_DM_QUYETDINH_VUAN_PT;
----------------------------------


-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định vụ án/vụ việc)------------ procedure %_PT_QD_VUAN_GETLIST, %_PHUCTHAM_QUYETDINH_GETLIST
PROCEDURE DGLIST_QUYETDINH_PT
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS      
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
         OPEN curReturn FOR  
            Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU
                ,case when instr(d.TEN,'03-HS')>0 then decode(q.THAYDOITCTT,2,d.TEN || ' (' || htnd_pc.HOTEN || ' - ' || htnd_bthay.HOTEN || ')',d.TEN || ' (' || tptk_pc.HOTEN || ' - ' || tptk_bthay.HOTEN || ')') 
                    else d.TEN end as TenQD,c.HOTEN as NguoiKy,q.NGAYTAO,q.NGUOITAO,
                q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo,q.TENFILE,q.TOA_GIAIQUYET_ID
            From AHS_PHUCTHAM_QUYETDINH_VUAN q
            left join DM_QD_QUYETDINH_LYDO ld on q.LYDOID=ld.ID
            inner join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID and d.Ket_thuc = 0
            left join DM_CANBO c on c.ID=q.NGUOIKYID
            left join DM_CANBO tptk_pc on q.NGUOIDUOCPHANCONG=tptk_pc.ID
            left join DM_CANBOVKS htnd_pc on q.NGUOIDUOCPHANCONG=htnd_pc.ID
            left join DM_CANBO tptk_bthay on q.NGUOIBITHAY=tptk_bthay.ID
            left join DM_CANBOVKS htnd_bthay on q.NGUOIBITHAY=htnd_bthay.ID
          Where q.VUANID=VDONID
          ORder by q.NGAYTAO;          
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
         OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE,q.TOA_GIAIQUYET_ID
          From ADS_PHUCTHAM_QUYETDINH q
          left join ADS_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISDANSU = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%' ) and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYQD;           
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
        OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE, q.TOA_GIAIQUYET_ID
          From AHN_PHUCTHAM_QUYETDINH q 
          left join AHN_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISHNGD = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%') and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYTAO;             
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
        OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE,q.TOA_GIAIQUYET_ID
          From AKT_PHUCTHAM_QUYETDINH q 
          left join AKT_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISKDTM = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%') and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYTAO;              
    ELSIF(VLOAIAN = '5') THEN -- Lao động
        OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE
              ,q.TOA_GIAIQUYET_ID -- hoangndh vnpt 09072025
          From ALD_PHUCTHAM_QUYETDINH q 
          left join ALD_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISLAODONG = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%') and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYTAO;              
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE
              ,q.TOA_GIAIQUYET_ID -- hoangndh vnpt 09072025
          From AHC_PHUCTHAM_QUYETDINH q 
          left join AHC_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISHANHCHINH = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%') and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYTAO;            
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
        OPEN curReturn FOR  
          Select q.ID,q.SOQD,q.NGAYQD,q.CHUCVU
                  ,d.TEN || DECODE(q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)' , 3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)' , 5, ' (Không xác định hình thức xét xử)', '')as TenQD
              ,c.HOTEN as NguoiKy,q.HIEULUCTU,q.HIEULUCDEN,ld.TEN as LyDo
              ,q.NGAYTAO,q.NGUOITAO,q.FILEID,f.TENFILE
          From APS_PHUCTHAM_QUYETDINH q 
          left join APS_FILE f on f.ID = q.FILEID
          left join DM_QD_QUYETDINH_LYDO ld on ld.ID=q.LYDOID
          INNER join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID AND (D.ISPHASAN = 1 AND D.ISPHUCTHAM = 1 AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%') and D.KET_THUC != 1
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.DONID=vDONID
          ORder by q.NGAYQD;               
    END IF;
END DGLIST_QUYETDINH_PT;
-----------------------------------------------

-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định bị can/bị cáo)------------ procedure AHS_PT_QD_BICAN_GETLIST
PROCEDURE DGLIST_QUYETDINH_BICAN_PT
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS      
  BEGIN    
    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
          Select q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU
              ,d.TEN as TenQD
              ,c.HOTEN as NguoiKy
               ,q.NGAYTAO,q.NGUOITAO,bc.HOTEN,q.TENFILE,q.HINHPHAT_VUAN_KHAC,q.TOA_GIAIQUYET_ID
          From AHS_PHUCTHAM_QUYETDINH_BICAN q
          inner join AHS_BICANBICAO bc on bc.ID=q.BICANID
          left join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
          left join DM_CANBO c on c.ID=q.NGUOIKYID
          Where q.VUANID=VDONID
          ORder by q.NGAYQD;         
    END IF;
END DGLIST_QUYETDINH_BICAN_PT;
-----------------------------------------------

END PKG_LOAD_DM_QDVUAN;