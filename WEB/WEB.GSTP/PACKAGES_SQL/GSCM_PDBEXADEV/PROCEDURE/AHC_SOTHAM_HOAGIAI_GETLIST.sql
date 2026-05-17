CREATE OR REPLACE PROCEDURE GSCM."AHC_SOTHAM_HOAGIAI_GETLIST" 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select t.ID
       , (CASE t.LOAITHONGBAO WHEN 1 THEN 'Thông báo kiểm tra giao nộp chứng cứ và đối thoại' 
                       WHen 2 then 'Thông báo hoãn kiểm tra giao nộp chứng cứ và đối thoại' 
         END) as TENLOAITHONGBAO                     
       ,t.SO,t.NGAY,c.HOTEN ,t.NGAYTAO,t.NGUOITAO,t.TENFILE
       , t.TOA_GIAIQUYET_ID
  From AHC_SOTHAM_HOAGIAI t   
  inner join DM_CANBO c on c.ID=t.NGUOIKY
  Where t.DONID=vDONID
  ORder by t.NGAY desc;
END AHC_SOTHAM_HOAGIAI_GETLIST;

