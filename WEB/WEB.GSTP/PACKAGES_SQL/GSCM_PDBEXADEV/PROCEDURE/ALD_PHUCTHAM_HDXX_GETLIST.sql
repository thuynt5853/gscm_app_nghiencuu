CREATE OR REPLACE PROCEDURE GSCM."ALD_PHUCTHAM_HDXX_GETLIST" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,(Case MAVAITRO WHEN 'THAMPHAN' then 'Thẩm phán chủ tọa phiên tòa'
                             WHEN 'THAMPHANHDXX' then 'Thẩm phán thành viên hội đồng xét xử'
                             WHEN 'THAMPHANDUKHUYET' then 'Thẩm phán dự khuyết'
                             WHEN 'HTND' then 'Hội thẩm nhân dân'
                             WHEN 'THUKY' then 'Thư ký'
                              WHEN 'THUKYDUKHUYET' then 'Thư ký dự khuyết'
                             WHEN 'KSV' then 'Kiểm sát viên' End) as TENVAITRO
        ,CASE d.MAVAITRO WHEN 'KSV' THEN v.HOTEN ELSE c.HOTEN END as TENNGUOITHTT
        ,d.NGAYTHAMGIA,d.NGAYKETTHUC,d.NGAYPHANCONG,d.NGAYNHANPHANCONG
        ,d.NGUOITAO,d.NGAYTAO,e.HOTEN as NguoiPhanCong
        ,d.TOA_GIAIQUYET_ID
  From ALD_PHUCTHAM_HDXX d 
  left join DM_CANBO c on c.ID=d.CANBOID
  left join DM_CANBO e on e.ID=d.NGUOIPHANCONGID
  left join DM_CANBOVKS v on v.ID=d.CANBOID
  Where d.DONID=vDONID
  ORder by  d.HOTEN;

END ALD_PHUCTHAM_HDXX_GETLIST;