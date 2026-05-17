create or replace NONEDITIONABLE PROCEDURE ADS_TONGDAT_GETLIST
( vDONID in number,
  vToaAnID in number,
	curReturn OUT sys_refcursor
)
IS
  vGiaiDoan number DEFAULT 0;
BEGIN
select MAGIAIDOAN into vGiaiDoan from ADS_DON where ID=vDONID;
OPEN curReturn FOR  
  Select t.*,(b.MABM || '. ' || b.TENBM) TENBM,
  ADS_GET_VBTONGDAT_DUONGSU(vDONID,b.ID,t.ID) as TINHTRANGNHANVB,
  t.TOA_GIAIQUYET_ID,f.NGAYTAO AS FILE_NGAYTAO
  From ADS_TONGDAT t   
  inner join (select a.ID,a.MABM,a.TENBM,a.THUTU from DM_BIEUMAU a 
                where a.ISADS=1
--                  and 1=case when vGiaiDoan=1 and a.ISHOSO=1 then 1 ---- vnpt 08122025 không check giai đoạn
--                             when vGiaiDoan=2 and a.ISSOTHAM=1 then 1
--                             when vGiaiDoan=3 and a.ISPHUCTHAM=1 then 1
--                             when vGiaiDoan=4 and a.ISGDTTT=1 then 1 else 0 end
                ) b on b.ID=t.BIEUMAUID
                LEFT JOIN ADS_FILE f ON f.ID = t.FILEID
  --inner join ADS_FILE f on t.FILEID=f.ID and f.MAGIAIDOAN=vGiaiDoan
  Where t.DONID=vDONID and t.TOAANID=vToaAnID
  ORder by FILE_NGAYTAO ASC NULLS FIRST;
END ADS_TONGDAT_GETLIST;