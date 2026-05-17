create or replace NONEDITIONABLE PROCEDURE AHC_TONGDAT_GETLIST
( vDONID in number,
  vToaAnID in number,
	curReturn OUT sys_refcursor
)
IS
  vGiaiDoan number DEFAULT 0;
BEGIN
select MAGIAIDOAN into vGiaiDoan from AHC_DON where ID=vDONID;
OPEN curReturn FOR  
  Select t.*,(b.MABM || '. ' || b.TENBM) TENBM,
  AHC_GET_VBTONGDAT_DUONGSU(vDONID,b.ID,t.ID) as TINHTRANGNHANVB
  From AHC_TONGDAT t   
  inner join (select a.ID,a.MABM,a.TENBM,a.THUTU from DM_BIEUMAU a 
                where a.ISAHC=1
--                  and 1=case when vGiaiDoan=1 and a.ISHOSO=1 then 1 ---- vnpt 08122025 không check giai đoạn
--                             when vGiaiDoan=2 and a.ISSOTHAM=1 then 1
--                             when vGiaiDoan=3 and a.ISPHUCTHAM=1 then 1
--                             when vGiaiDoan=4 and a.ISGDTTT=1 then 1 
--                             when vGiaiDoan=7 and a.ISPHUCTHAM=1 then 1 -- vnpt 5/12/2025 hien bm cho an tam dinh chi
--                             else 0 end
                ) b on b.ID=t.BIEUMAUID
  --inner join AHC_FILE f on t.FILEID=f.ID and f.MAGIAIDOAN=vGiaiDoan
  Where t.DONID=vDONID and t.TOAANID=vToaAnID
  ORder by b.THUTU;
END AHC_TONGDAT_GETLIST;