create or replace NONEDITIONABLE PROCEDURE        "AHS_ST_QD_BICAN_GETLIST" 
( vVuAnID in number,
	curReturn OUT sys_refcursor
)
IS 
CountBanAnST int;
BEGIN    
    select count(ID) into CountBanAnST from AHS_SOTHAM_BANAN where VuAnID = vVuAnID;
    OPEN curReturn FOR  
      SELECT ROW_NUMBER() OVER (ORDER BY q.NgayQD desc) stt
          , q.ID,q.SOQUYETDINH,q.NGAYQD,q.CHUCVU
          , d.TEN as TenQD,c.HOTEN as NguoiKy
          , q.NGAYTAO,q.NGUOITAO, q.TenFile,bc.HOTEN
          , CountBanAnST IsBanAnST,q.TOA_GIAIQUYET_ID
      From AHS_SOTHAM_QUYETDINH_BICAN q
      inner join AHS_BICANBICAO bc on bc.ID=q.BICANID
      left join DM_QD_QUYETDINH d on d.ID=q.QUYETDINHID
      left join DM_CANBO c on c.ID=q.NGUOIKYID
      Where q.VUANID=vVuAnID;
END AHS_ST_QD_BICAN_GETLIST;