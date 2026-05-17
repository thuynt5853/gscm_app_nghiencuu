CREATE OR REPLACE PROCEDURE GSCM."ALD_SOTHAM_HOAGIAI_GETLIST" 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select t.ID,
  (CASE t.LOAITHONGBAO WHEN 1 THEN 'Thông báo hòa giải' WHen 2 then 'Thông báo hoãn hòa giải' END) as TENLOAITHONGBAO
       ,t.SO,t.NGAY,c.HOTEN
       ,t.NGAYTAO,t.NGUOITAO,t.TENFILE,t.TOA_GIAIQUYET_ID
  From ALD_SOTHAM_HOAGIAI t   
  inner join DM_CANBO c on c.ID=t.NGUOIKY
  Where t.DONID=vDONID
  ORder by t.NGAY desc;
END ALD_SOTHAM_HOAGIAI_GETLIST;