create or replace NONEDITIONABLE PROCEDURE        "AHS_SOTHAM_HDXX_GETLIST" 
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
CountBanAnST int;
BEGIN    
    select count(ID) into CountBanAnST from AHS_SOTHAM_BANAN where VuAnID = vVuAnID;
    OPEN curReturn FOR  
      Select d.ID,(Case MAVAITRO WHEN 'THAMPHAN' then 'Thẩm phán chủ tọa phiên tòa'
                                 WHEN 'THAMPHANHDXX' then 'Thẩm phán thành viên hội đồng xét xử'
                                 WHEN 'THAMPHANDUKHUYET' then 'Thẩm phán dự khuyết'
                                 WHEN 'HTND' then 'Hội thẩm nhân dân'
                                 WHEN 'THAMTRAVIEN' then 'Thẩm tra viên'
                                 WHEN 'THUKY' then 'Thư ký'
                                 WHEN 'THUKYDUKHUYET' then 'Thư ký dự khuyết'
                                 WHEN 'KSV' then 'Kiểm sát viên' End)  as TENVAITRO
            ,(CASE MAVAITRO WHEN 'KSV' THEN v.HOTEN  
                            --WHEN 'HTND' THEN v.HOTEN  
                            ELSE c.HOTEN END) || Decode (nvl(ISTHAYDOI,0),0,null,' (đã thay đổi)') as TENNGUOITHTT
            ,d.NGAYTHAMGIA,d.NGAYKETTHUC,d.NGAYPHANCONG,d.NGAYNHANPHANCONG, d.SOQD, d.NGAYQD
            ,d.NGUOITAO,d.NGAYTAO,e.HOTEN as NguoiPhanCong , CountBanAnST IsBanAnST,d.TOA_GIAIQUYET_ID
      From AHS_SOTHAM_HDXX d 
      left join DM_CANBO c on c.ID=d.CANBOID
      left join DM_CANBO e on e.ID=d.NGUOIPHANCONGID
      left join DM_CANBOVKS v on v.ID=d.CANBOID
      Where d.VUANID=vVuAnID
            and ((d.MAVAITRO='THAMPHAN')
                  or
                    (d.MAVAITRO<>'THAMPHAN')
                )
      ORder by  d.HOTEN;

END AHS_SOTHAM_HDXX_GETLIST;