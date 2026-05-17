create or replace NONEDITIONABLE PROCEDURE AHS_ST_BANAN_BICAO_GetByVuAnID
(
     vu_an_id in int   
	 , PageIndex	in	int
	 , PageSize	in	int
	 , curReturn    OUT   sys_refcursor
)
AS
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;BEGIN	

    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;


   --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
   select count (a.ID) into TotalItem 
 from AHS_BiCanBiCao a 
                    inner join (select ID from AHS_VuAn where Id = vu_an_id) va on va.ID = a.VuAnID
                    left join (select ID, VuAnID from AHS_SoTham_BanAN where VuAnId =vu_an_id) st on st.VuAnId = va.ID
                    left join (select BanAnID, BiCaoID, IsThamGiaPhienToa, AnPhi, IsDinhchi, NgayNhanBanAN 
                                from AHS_SOTHAM_BANAN_BICAO)  b on a.Id = b.BiCaoID and b.BanANID = st.ID  
                where a.VuAnID=vu_an_id ;
		---------------------------------------------------
    OPEN curReturn FOR 
        select a.*, TotalItem as CountAll
        from (	 SELECT ROW_NUMBER() OVER (ORDER BY NVL(a.BiCanDauVu, 0) DESC, a.id) stt--NVL(a.BiCanDauVu, 0) desc,a.NgayThamGia desc
                    , a.ID, a.HoTen, a.NamSinh, a.NGAYTHAMGIA, a.TamTru   
                    , NVL(a.LOAIDOITUONG,0) LOAIDOITUONG,NVL(a.BICANDAUVU,0) BICANDAUVU
                    , nvl(b.BiCaoID, 0) BiCaoSoTham_ID
                    , case when nvl(b.BiCaoID, 0)>0 then 1  when nvl(b.BiCaoID, 0)=0 then 0 end IsShow                     
                    , NVL(b.IsThamGiaPhienToa, 0) IsThamGiaPhienToa, NVL(b.AnPhi, 0) AnPhi
                    , NVL(b.IsDinhCHi, 0) IsDinhChi
                    , b.NgayNhanBanAn
                    , a.TOA_GIAIQUYET_ID
                from AHS_BiCanBiCao a 
                    inner join (select ID from AHS_VuAn where Id = vu_an_id) va on va.ID = a.VuAnID
                    left join (select ID, VuAnID from AHS_SoTham_BanAN where VuAnId =vu_an_id) st on st.VuAnId = va.ID
                    left join (select BanAnID, BiCaoID, IsThamGiaPhienToa, AnPhi, IsDinhchi, NgayNhanBanAN 
                                from AHS_SOTHAM_BANAN_BICAO)  b on a.Id = b.BiCaoID and b.BanANID = st.ID  
                where a.VuAnID=vu_an_id
              ) a where a.stt>=MinIndex and a.stt<=MaxIndex;

END AHS_ST_BANAN_BICAO_GetByVuAnID;