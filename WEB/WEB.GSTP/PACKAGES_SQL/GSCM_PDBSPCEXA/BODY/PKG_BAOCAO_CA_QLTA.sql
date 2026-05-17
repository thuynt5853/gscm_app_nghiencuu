--------------------------------------------------------
--  DDL for Package Body PKG_BAOCAO_CA_QLTA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_BAOCAO_CA_QLTA" AS


FUNCTION TONGDONVISUDUNG_QLTA
(
    V_DATE_TO VARCHAR2
)
RETURN SYS_REFCURSOR
AS
    v_cursor SYS_REFCURSOR; v_TOAAN SYS_REFCURSOR;
    v_denngay date;
    v_Tongcong number;v_count number;
BEGIN
        v_denngay := TO_DATE(V_DATE_TO||'00:00:00', 'dd/MM/yyyy  hh24:mi:ss')+1;
        v_Tongcong:=0;
        v_count := 0;
--       FOR v_TOAAN In (
--                select dmva.id from GSCM.dm_toaan dmva 
--                                    left join BCTK_APP_V3.tc_courts v3a on v3a.MADONGBO=dmva.MADONGBO
--                                        where dmva.BAOCAO = 1
--                      )
--            LOOP
--
--      ----------------
--            select Sum(TongThuLyQLTA.id) into v_count from (
--                            select count(hs.id) id from ahs_sotham_thuly hs 
--                                                            where hs.ngaythuly <= v_denngay and hs.VUANID = v_TOAAN.id
--                            UNION 
--                            select count(hsp.id) id from ahs_phuctham_thuly hsp  
--                                                            where hsp.ngaythuly <= v_denngay and hsp.VUANID = v_TOAAN.id
--                            UNION
--                            select count(ds.id) id from ads_sotham_thuly ds  
--                                                            where ds.ngaythuly <= v_denngay and ds.toaanid = v_TOAAN.id
--                            UNION
--                            select count(dsp.id) id  from ads_phuctham_thuly dsp  
--                                                            where dsp.ngaythuly <= v_denngay and dsp.toaanid = v_TOAAN.id
--                            UNION
--                            select count(hc.id) id  from ahc_sotham_thuly hc  
--                                                            where hc.ngaythuly <= v_denngay and hc.toaanid = v_TOAAN.id
--                            UNION
--                            select count(hcp.id) id  from ahc_phuctham_thuly hcp  
--                                                            where hcp.ngaythuly <= v_denngay and hcp.toaanid = v_TOAAN.id
--                            UNION
--                            select count(hn.id) id  from ahn_sotham_thuly hn   
--                                                        where hn.ngaythuly <= v_denngay and hn.toaanid = v_TOAAN.id
--                            UNION
--                            select count(hnp.id) id  from ahn_phuctham_thuly hnp 
--                                                        where hnp.ngaythuly <= v_denngay and hnp.toaanid = v_TOAAN.id
--                            UNION
--                            select count(kt.id)  id from akt_sotham_thuly kt 
--                                                        where kt.ngaythuly <= v_denngay  and kt.toaanid = v_TOAAN.id
--                            UNION
--                            select count(ktp.id) id  from akt_phuctham_thuly ktp  
--                                                        where ktp.ngaythuly <= v_denngay  and ktp.toaanid = v_TOAAN.id
--                            UNION
--                            select count(ld.id)  id from ald_sotham_thuly ld  
--                                                        where ld.ngaythuly <= v_denngay  and ld.toaanid = v_TOAAN.id
--                            UNION
--                            select count(ldp.id) id  from ald_phuctham_thuly ldp  
--                                                    where ldp.ngaythuly <= v_denngay  and ldp.toaanid = v_TOAAN.id
--                            UNION
--                            select count(ps.id)  id from aps_sotham_thuly ps 
--                                                    where ps.ngaythuly <= v_denngay  and ps.toaanid = v_TOAAN.id
--                            UNION
--                            select count(psp.id) id  from aps_phuctham_thuly psp  
--                                                        where psp.ngaythuly <= v_denngay  and psp.toaanid = v_TOAAN.id
--                            ) TongThuLyQLTA;
--                if (v_count > 0)then
--                    v_Tongcong := v_Tongcong +1;
--                end if;
--
--
--        END LOOP;
        ---------------
        --SELECT COUNT(*) PUBLIC_JUDGMENT
       -----------------
     OPEN v_cursor FOR
     SELECT rtrim(to_char(v_Tongcong, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') V_TONGDONVISUDUNG_QLTA
     FROM DUAL;
      -----------------
    RETURN v_cursor;   
END TONGDONVISUDUNG_QLTA;

FUNCTION TONGTHULY_QLTA
(  V_DATE_FROM VARCHAR2 DEFAULT NULL,
    V_DATE_TO VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
AS
    v_cursor SYS_REFCURSOR;
    v_tungay date; v_denngay date;
    v_TongThuLy number; v_Tongcong number;v_count number;v_tongdonvi number;
BEGIN
    v_tungay := TO_DATE(V_DATE_FROM||'23:59:59', 'dd/MM/yyyy  hh24:mi:ss')-1;
    v_denngay := TO_DATE(V_DATE_TO||'00:00:00', 'dd/MM/yyyy  hh24:mi:ss')+1;
    -----Tong so Toa an toan quoc------------------------------ 
     select count(dmva.id) into v_tongdonvi from GSCM.dm_toaan dmva 
                                    left join BCTK_APP_V3.tc_courts@DBLINK_TK.TOAAN.GOV.VN v3a on v3a.MADONGBO=dmva.MADONGBO
                                        where dmva.BAOCAO = 1;
    -----Tong so don vi su dung den ngay-------------------        
        v_Tongcong:=0;
        v_count := 0;
       FOR v_TOAAN In (
                select dmva.id from GSCM.dm_toaan dmva 
                                    left join BCTK_APP_V3.tc_courts@DBLINK_TK.TOAAN.GOV.VN v3a on v3a.MADONGBO=dmva.MADONGBO
                                        where dmva.BAOCAO = 1
                      )
            LOOP

      ----------------
            select Sum(TongThuLyQLTA.id) into v_count from (
                            select count(hs.id) id from ahs_sotham_thuly hs 
                                                            where hs.ngaythuly BETWEEN v_tungay and v_denngay 
                                                                and hs.VUANID = v_TOAAN.id
                            UNION 
                            select count(hsp.id) id from ahs_phuctham_thuly hsp  
                                                            where hsp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                            and hsp.VUANID = v_TOAAN.id
                            UNION
                            select count(ds.id) id from ads_sotham_thuly ds  
                                                            where ds.ngaythuly BETWEEN v_tungay and v_denngay 
                                                            and ds.toaanid = v_TOAAN.id
                            UNION
                            select count(dsp.id) id  from ads_phuctham_thuly dsp  
                                                            where dsp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                            and dsp.toaanid = v_TOAAN.id
                            UNION
                            select count(hc.id) id  from ahc_sotham_thuly hc  
                                                            where hc.ngaythuly BETWEEN v_tungay and v_denngay 
                                                            and hc.toaanid = v_TOAAN.id
                            UNION
                            select count(hcp.id) id  from ahc_phuctham_thuly hcp  
                                                            where hcp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                            and hcp.toaanid = v_TOAAN.id
                            UNION
                            select count(hn.id) id  from ahn_sotham_thuly hn   
                                                        where hn.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and hn.toaanid = v_TOAAN.id
                            UNION
                            select count(hnp.id) id  from ahn_phuctham_thuly hnp 
                                                        where hnp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and hnp.toaanid = v_TOAAN.id
                            UNION
                            select count(kt.id)  id from akt_sotham_thuly kt 
                                                        where kt.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and kt.toaanid = v_TOAAN.id
                            UNION
                            select count(ktp.id) id  from akt_phuctham_thuly ktp  
                                                        where ktp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and ktp.toaanid = v_TOAAN.id
                            UNION
                            select count(ld.id)  id from ald_sotham_thuly ld  
                                                        where ld.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and ld.toaanid = v_TOAAN.id
                            UNION
                            select count(ldp.id) id  from ald_phuctham_thuly ldp  
                                                    where ldp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                    and ldp.toaanid = v_TOAAN.id
                            UNION
                            select count(ps.id)  id from aps_sotham_thuly ps 
                                                    where ps.ngaythuly BETWEEN v_tungay and v_denngay 
                                                    and ps.toaanid = v_TOAAN.id
                            UNION
                            select count(psp.id) id  from aps_phuctham_thuly psp  
                                                        where psp.ngaythuly BETWEEN v_tungay and v_denngay 
                                                        and psp.toaanid = v_TOAAN.id
                            ) TongThuLyQLTA;
                if (v_count > 0)then
                    v_Tongcong := v_Tongcong +1;
                end if;


        END LOOP;
    ----------------
    ------Tong so thu ly den ngay----------
    select Sum(TongThuLyQLTA.id) into v_TongThuLy from (
                    select count(hs.id) id from ahs_sotham_thuly hs 
                                                    where hs.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION 
                    select count(hsp.id) id from ahs_phuctham_thuly hsp  
                                                    where hsp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(ds.id) id from ads_sotham_thuly ds  
                                                    where ds.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(dsp.id) id  from ads_phuctham_thuly dsp  
                                                    where dsp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(hc.id) id  from ahc_sotham_thuly hc  
                                                    where hc.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(hcp.id) id  from ahc_phuctham_thuly hcp  
                                                    where hcp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(hn.id) id  from ahn_sotham_thuly hn   
                                                where hn.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(hnp.id) id  from ahn_phuctham_thuly hnp 
                                                where hnp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(kt.id)  id from akt_sotham_thuly kt 
                                                where kt.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(ktp.id) id  from akt_phuctham_thuly ktp  
                                                where ktp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(ld.id)  id from ald_sotham_thuly ld  
                                                where ld.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(ldp.id) id  from ald_phuctham_thuly ldp  
                                            where ldp.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(ps.id)  id from aps_sotham_thuly ps 
                                            where ps.ngaythuly BETWEEN v_tungay and v_denngay 
                    UNION
                    select count(psp.id) id  from aps_phuctham_thuly psp  
                                                where psp.ngaythuly BETWEEN v_tungay and v_denngay 
                    ) TongThuLyQLTA;
        ---------------

       -----------------
     OPEN v_cursor FOR
     SELECT rtrim(to_char(v_Tongcong, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') V_TONGDONVISUDUNG_QLTA,
            rtrim(to_char(ROUND(v_Tongcong/v_tongdonvi*100, 2), 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') V_TYLESUDUNG_QLTA,
            rtrim(to_char(v_tongdonvi - v_Tongcong, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') V_TONGCHUASUDUNG_QLTA,
            rtrim(to_char(v_TongThuLy, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') V_TONGTHULY_QLTA

     FROM DUAL;
      -----------------
    RETURN v_cursor;   
END TONGTHULY_QLTA;


END PKG_BAOCAO_CA_QLTA;
