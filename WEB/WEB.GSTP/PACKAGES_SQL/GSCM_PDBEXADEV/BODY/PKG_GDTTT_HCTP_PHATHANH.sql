--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_PHATHANH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_PHATHANH" AS
PROCEDURE GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,  
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
IS
    TotalItem number;MinIndex    number;MaxIndex    number;
BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    SELECT Count(*) into TotalItem FROM ( 
    Select distinct(s.SOVB)
      from GDTTT_DON d
      LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
      LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID AND s.MASO = 'SoCVC' AND s.TRANGTHAI = 1
      LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
      LEFT JOIN TONGDAT_HCTP td on td.SOVB = s.SOVB and td.LOAIVB = 'Công văn chuyển' and td.NGAYVB = s.NGAYVB and d.ID = td.DON_ID
      LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
     ----------
      where d.TOAANID=vToaAnID AND d.CD_LOAI in (0,1,2) AND d.CD_TRANGTHAI in (0,1,2,3) and s.SOVB is not null
        And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
        AND (vLoaiAn=0
            OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
            OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
          )                                                    
        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )

        and  1=case when vNguoiGui || ' '=' ' then 1 
                    when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                    when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                    else 0 end       
        AND (vNoiChuyen=-1
             OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
             OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
             )
        and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
            OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
            OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
           AND ( V_SO_TU=0
              OR (TO_NUMBER(NVL(s.SOVB, 0)) >= V_SO_TU)
              )    
          AND ( V_SO_DEN=0
              OR(TO_NUMBER(NVL(s.SOVB, 0)) <= V_SO_DEN)
              ) 
           AND ( V_NGAY_FROM IS NULL
              OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
              )  
            AND ( V_NGAY_TO IS NULL
              OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
              )
             AND (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null))) 
      );
OPEN curReturn FOR
SELECT tbl.* 
FROM (
   SELECT d.STT, TotalItem as CountAll 
          , DECODE(td.ID, null, 0, td.ID) ID
          , count(*) over (partition by d.STT order by d.STT) ROWSPAN
          , row_number() over (partition by d.STT order by d.STT) RN
          , d.TENVANBAN
          , (SELECT s.ID from QUANLY_SOPHATHANH s where s.MASO = 'SoCVC' AND s.TRANGTHAI = 1 AND s.SOVB = d.SOVB and s.NGAYVB = d.NGAYVB and ROWNUM = 1) DONID
          , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
          , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
          , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
          , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
          , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
          , '' as NGUOIGUI, '' as DIACHIGUI, '' as NGAYGHITRENDON, '' as NGAYNHANDON, '' as BAQD, '' as BAQD_NGAYBA, '' as TOAXX, d.SOVB, d.NGAYVB, '6' LOAIVB
   from (
       select b.STT, DECODE(b1.TENVANBAN, null, b.TENVANBAN, b1.TENVANBAN) as TENVANBAN, b1.NOINHAN, DECODE(b1.NGAYVB, null, b.NGAYVB, b1.NGAYVB) as NGAYVB, DECODE(b1.SOVB, null, b.SOVB, b1.SOVB) as SOVB, b.DONGKHIEUNAI, B.NGUOIGUI_HOTEN, B.CV_TENDONVI, B.TENKS, B.LOAIDON from 
        (select a.*, ROW_NUMBER() OVER (ORDER BY TO_NUMBER(a.SOVB) desc) STT from (
          Select DISTINCT 'Số CV: <b>' || s.SOVB || '</b>' || DECODE(s.NGAYVB, null, '', ' Ngày CV: ' || '<b>' || to_char(s.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                , s.NGAYVB, s.SOVB, d.DONGKHIEUNAI, d.NGUOIGUI_HOTEN, d.CV_TENDONVI, KS.TEN AS TENKS, D.LOAIDON
          from GDTTT_DON d 
          LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
          LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID
          left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
          left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
          LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
          LEFT JOIN TONGDAT_HCTP td on td.SOVB = s.SOVB and td.LOAIVB = 'Công văn chuyển' and td.NGAYVB = s.NGAYVB
          LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
         ----------
          where d.TOAANID=vToaAnID AND d.CD_LOAI in (0,1,2) AND d.CD_TRANGTHAI in (0,1,2,3) and s.SOVB is not null AND s.MASO = 'SoCVC' AND s.TRANGTHAI = 1
            And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
            and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                            Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                            Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
            AND (vLoaiAn=0
                OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )                                                    
            and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                      And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                    )
                    Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                 )  
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        else 0 end 
            AND (vNoiChuyen=-1
                 OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                 OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                 )
            and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                        (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
               when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
               AND ( V_SO_TU=0
                  OR (TO_NUMBER(NVL(s.SOVB, 0)) >= V_SO_TU)
                  )    
              AND ( V_SO_DEN=0
                  OR(TO_NUMBER(NVL(s.SOVB, 0)) <= V_SO_DEN)
                  ) 
              AND ( V_NGAY_FROM IS NULL
                  OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                  )  
              AND ( V_NGAY_TO IS NULL
                  OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                  ) 
              AND (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null))) 
                ORDER BY TO_NUMBER(s.SOVB) desc, s.NGAYVB desc
              -----------------
        ) a 
      ) b 
      LEFT JOIN (select a.* from (
          Select DISTINCT 'Số CV: <b>' || s.SOVB || '</b>' || DECODE(s.NGAYVB, null, '', ' Ngày CV: ' || '<b>' || to_char(s.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
          , '<b>' || (Case when d.CD_LOAI=0 then TO_CHAR(pb.TENPHONGBAN)
                 when d.CD_LOAI=1 and d.CD_TK_NOIGUI=0 then TO_CHAR(tk.MA_TEN)
                 when d.CD_LOAI=1 and d.CD_TK_NOIGUI=1 then TO_CHAR('Chánh án ' || tk.MA_TEN)
                 Else TO_CHAR(d.CD_NTA_TENDONVI) End) ||'</b>' NOINHAN, s.NGAYVB, s.SOVB  
          from GDTTT_DON d 
          LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
          LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID AND s.MASO = 'SoCVC' AND s.TRANGTHAI = 1
          left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
          left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
          LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
          LEFT JOIN TONGDAT_HCTP td on td.SOVB = s.SOVB and td.LOAIVB = 'Công văn chuyển' and td.NGAYVB = s.NGAYVB
         ----------
          where d.TOAANID=vToaAnID AND d.CD_LOAI in (0,1,2) AND d.CD_TRANGTHAI in (0,1,2,3) and s.SOVB is not null AND td.ID is null
            And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
            and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                            Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                            Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
            AND (vLoaiAn=0
                OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )                                                    
            and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                      And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                    )
                    Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                 )

--            and  1=case when vNguoiGui || ' '=' ' then 1 
--                        when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                        else 0 end       
            AND (vNoiChuyen=-1
                 OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                 OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                 )
            and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                        (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
               when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
               AND ( V_SO_TU=0
                  OR (TO_NUMBER(NVL(s.SOVB, 0)) >= V_SO_TU)
                  )    
              AND ( V_SO_DEN=0
                  OR(TO_NUMBER(NVL(s.SOVB, 0)) <= V_SO_DEN)
                  ) 
              AND ( V_NGAY_FROM IS NULL
                  OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                  )  
              AND ( V_NGAY_TO IS NULL
                  OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                  ) 
                ORDER BY TO_NUMBER(s.SOVB) desc, s.NGAYVB desc
              -----------------
        ) a
      ) b1 ON b1.TENVANBAN = b.TENVANBAN AND b1.SOVB = b.SOVB AND b1.NGAYVB = b.NGAYVB
      where b.stt>=MinIndex and b.stt<=MaxIndex
    ) d
    LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Công văn chuyển' and td.NGAYVB = d.NGAYVB
    LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
    WHERE (1=case when vNguoiGui || ' '=' ' then 1 
                  when lower(DECODE(D.LOAIDON,4,D.TENKS,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                  when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                  when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end) AND
    (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' 
    AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
    ORDER BY STT) tbl
ORDER BY ID, STT, RN;
END GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH;

PROCEDURE GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,  
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
IS
    TotalItem number;MinIndex    number;MaxIndex    number;
BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    SELECT Count(*) into TotalItem FROM ( 
    Select s.SOVB
      from GDTTT_DON d
      LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
      LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID AND s.MASO = 'SoTT' AND s.TRANGTHAI = 1
      LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
      LEFT JOIN TONGDAT_HCTP td on td.SOVB = s.SOVB and td.LOAIVB = 'Tờ trình' and td.NGAYVB = s.NGAYVB
      LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
     ----------
      where d.TOAANID=vToaAnID AND s.SOVB is not null
        And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
        AND (vLoaiAn=0
            OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
            OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
          )                                                    
        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )

        and  1=case when vNguoiGui || ' '=' ' then 1 
                    when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                    when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                    else 0 end       
        AND (vNoiChuyen=-1
             OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
             OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
             )
        and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
            OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
            OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
           AND ( V_SO_TU=0
              OR (s.SOVB >= V_SO_TU)
              )    
          AND ( V_SO_DEN=0
              OR(s.SOVB <= V_SO_DEN)
              ) 
          AND ( V_NGAY_FROM IS NULL
              OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
              )  
          AND ( V_NGAY_TO IS NULL
              OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
              )
          AND (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null))) 
    GROUP BY s.SOVB);
OPEN curReturn FOR
SELECT tbl.* 
FROM (
   SELECT d.STT, TotalItem as CountAll 
          , DECODE(td.ID, null, 0, td.ID) ID
          , count(*) over (partition by d.STT order by d.STT) ROWSPAN
          , row_number() over (partition by d.STT order by d.STT) RN
          , d.TENVANBAN
          , (SELECT s.ID from QUANLY_SOPHATHANH s where s.MASO = 'SoTT' AND s.TRANGTHAI = 1 AND s.SOVB = d.SOVB and s.NGAYVB = d.NGAYVB and ROWNUM = 1) DONID
          , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
          , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
          , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
          , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
          , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
          , '' as NGUOIGUI, '' as DIACHIGUI, '' as NGAYGHITRENDON, '' as NGAYNHANDON, '' as BAQD, '' as BAQD_NGAYBA, '' as TOAXX, d.SOVB, d.NGAYVB, '7' LOAIVB
   from (
       select b.STT, DECODE(b1.TENVANBAN, null, b.TENVANBAN, b1.TENVANBAN) as TENVANBAN, b1.NOINHAN, DECODE(b1.NGAYVB, null, b.NGAYVB, b1.NGAYVB) as NGAYVB, DECODE(b1.SOVB, null, b.SOVB, b1.SOVB) as SOVB, b.DONGKHIEUNAI, B.NGUOIGUI_HOTEN, B.CV_TENDONVI, B.TENKS, B.LOAIDON from 
        (select a.*, ROW_NUMBER() OVER (ORDER BY a.TENVANBAN desc) STT from (
          Select DISTINCT 'Số tờ trình: <b>' || s.SOVB || '</b>' || DECODE(s.NGAYVB, null, '', ' Ngày TTr: ' || '<b>' || to_char(s.NGAYVB,'dd/MM/yyyy') || '</b>') 
          as TENVANBAN
          , '<b>' || 'Chánh án ' || tk.MA_TEN ||'</b>' NOINHAN, s.NGAYVB, s.SOVB, d.DONGKHIEUNAI, d.NGUOIGUI_HOTEN, d.CV_TENDONVI, KS.TEN AS TENKS, D.LOAIDON  
          from GDTTT_DON d 
          LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
          LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID AND s.MASO = 'SoTT' AND s.TRANGTHAI = 1
          left join (select ID,MA_TEN from DM_TOAAN) tk on d.TOAANID=tk.ID
          LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
          LEFT JOIN TONGDAT_HCTP td on td.SOVB = s.SOVB and td.LOAIVB = 'Tờ trình' and td.NGAYVB = s.NGAYVB
          LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
         ----------
          where d.TOAANID=vToaAnID AND s.SOVB is not null
            And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
            and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                            Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                            Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
            AND (vLoaiAn=0
                OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )                                                    
            and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                      And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                    )
                    Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                 )

            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end       
            AND (vNoiChuyen=-1
                 OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                 OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                 )
            and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                        (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
               when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                AND ( V_SO_TU=0
                  OR (TO_NUMBER(NVL(s.SOVB, 0)) >= V_SO_TU)
                  )    
                AND ( V_SO_DEN=0
                  OR(TO_NUMBER(NVL(s.SOVB, 0)) <= V_SO_DEN)
                  ) 
                AND ( V_NGAY_FROM IS NULL
                  OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                  )  
                AND ( V_NGAY_TO IS NULL
                  OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                  ) 
                AND (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null))) 
                ORDER BY TO_NUMBER(s.SOVB) desc, s.NGAYVB desc
              -----------------
       ) a 
      ) b 
      LEFT JOIN (select a.* from (
          Select DISTINCT 'Số tờ trình: <b>' || s.SOVB || '</b>' || DECODE(s.NGAYVB, null, '', ' Ngày TTr: ' || '<b>' || to_char(s.NGAYVB,'dd/MM/yyyy') || '</b>') 
          as TENVANBAN
          , '<b>' || 'Chánh án ' || tk.MA_TEN ||'</b>' NOINHAN, s.NGAYVB, s.SOVB  
          from GDTTT_DON d 
          LEFT JOIN SOPHATHANH_DON sd ON d.ID = sd.DONID
          LEFT JOIN QUANLY_SOPHATHANH s ON sd.SOPHATHANH_ID = s.ID AND s.MASO = 'SoTT' AND s.TRANGTHAI = 1
          left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
          left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
          LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
          LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.CD_SOTOTRINH and td.LOAIVB = 'Tờ trình' and td.NGAYVB = d.CD_NGAYTOTRINH
         ----------
          where d.TOAANID=vToaAnID AND CD_SOTOTRINH is not null AND td.ID is null
            And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
            and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                            Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                            Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
            AND (vLoaiAn=0
                OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )                                                    
            and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                      And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                    )
                    Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                 )


            AND (vNoiChuyen=-1
                 OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                 OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                 )
            and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                        (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
               when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                AND ( V_SO_TU=0
                  OR (TO_NUMBER(NVL(s.SOVB, 0)) >= V_SO_TU)
                  )    
                AND ( V_SO_DEN=0
                  OR(TO_NUMBER(NVL(s.SOVB, 0)) <= V_SO_DEN)
                  ) 
                AND ( V_NGAY_FROM IS NULL
                  OR(s.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                  )  
                AND ( V_NGAY_TO IS NULL
                  OR(s.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                  ) 
            ORDER BY TO_NUMBER(s.SOVB) desc, s.NGAYVB desc
              -----------------
        ) a
      ) b1 ON b1.TENVANBAN = b.TENVANBAN AND b1.SOVB = b.SOVB AND b1.NGAYVB = b.NGAYVB
      where b.stt>=MinIndex and b.stt<=MaxIndex
    ) d
    LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Tờ trình' and td.NGAYVB = d.NGAYVB
    LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
    WHERE (1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(DECODE(D.LOAIDON,4,D.TENKS,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end ) AND
    (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' 
    AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
    ORDER BY STT) tbl
ORDER BY ID, STT, RN;
END GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH;

PROCEDURE GDTTT_HCTP_PHATHANH_DON_SEARCH
( 
    vToaAnID in number,
    vNguoiGui in varchar2, 
    vSoBAQD in varchar2,  
    vNgayBAQD in varchar2, 
    vToaRaBAQD in number, 
    vLoaiAn in number, 
    vTrangThai_PH in varchar2,
    vNoiChuyen in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    V_LOAI_VB	in	VARCHAR2,
    V_SO_TU	in	NUMBER,
    V_SO_DEN	in	NUMBER,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,  
    vIsThuLy in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
IS
    TotalItem number;MinIndex    number;MaxIndex    number;
BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    SELECT Count(*) into TotalItem 
    FROM ( 
       SELECT  b.DONID, b.LOAIVB FROM (
        SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Yêu cầu bổ sung số <b>' || b.SOTHONGBAO || '</b>' || DECODE(b.NGAYTHONGBAO, null, '', ' ngày ' || '<b>' || to_char(b.NGAYTHONGBAO,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOTHONGBAO as SOVB, b.NGAYTHONGBAO as NGAYVB, b.DONID, '1' LOAIVB
                  from GDTTT_DON_YEUCAU_BOSUNG b
                  left join GDTTT_DON d ON d.ID = b.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '1')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOTHONGBAO, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOTHONGBAO, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYTHONGBAO >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYTHONGBAO <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY b.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.NGAYVB = d.NGAYVB and td.LOAIVB = 'Yêu cầu bổ sung' and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Giấy xác nhận nhận đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '2' LOAIVB, sd.DONID
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO  = 'SoGXN' AND b.TRANGTHAI = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '2')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Giấy xác nhận nhận đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select d.ID, 'Trả lại đơn <b>' || d.CD_SOCV || '</b>' || DECODE(d.CD_NGAYCV, null, '', ' ngày ' || '<b>' || to_char(d.CD_NGAYCV,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, d.CD_SOCV as SOVB, d.CD_NGAYCV as NGAYVB, '3' LOAIVB, d.ID as DONID
                  from GDTTT_DON d
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND d.CD_LOAI = 3 AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '3')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(d.CD_SOCV, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(d.CD_SOCV, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(d.CD_NGAYCV >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(d.CD_NGAYCV <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY d.ID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Trả lại đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo phân công thẩm phán <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  ,  'TP ' || tp.HOTEN as NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '4' LOAIVB, sd.DONID, Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN_NGUOIGUI
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO  = 'TBTP' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '4')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo phân công thẩm phán' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null))
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN_NGUOIGUI) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(nd.NGAYGUI, null, '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo gửi cơ quan chuyển đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '5' LOAIVB, sd.DONID
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO  = 'SoGXN_DV' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1'  OR V_LOAI_VB = '5')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo gửi cơ quan chuyển đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            ) b
            GROUP BY b.DONID, b.LOAIVB);
OPEN curReturn FOR
    SELECT TotalItem as CountAll, dt.NOINHAN, dt.NGAYPHATHANH, dt.NGAYGUI, dt.NGAYNHAN, dt.TRANGTHAI, tbl.* 
           , count(*) over (partition by tbl.STT order by tbl.STT) ROWSPAN
           , row_number() over (partition by tbl.STT order by tbl.STT) RN
    FROM (
        SELECT tmp.*, rownum STT
        FROM (
          SELECT ds.DONID, ds.LOAIVB, ds.SOVB, ds.NGAYVB, ds.NGUOIGUI, ds.DIACHIGUI, ds.NGAYGHITRENDON, ds.NGAYNHANDON, ds.BAQD, ds.BAQD_NGAYBA, ds.TOAXX, ds.ID, ds.TENVANBAN FROM (
           SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , d.NGUOIGUI, d.DIACHIGUI, d.NGAYGHITRENDON, d.NGAYNHANDON, d.BAQD, d.BAQD_NGAYBA, d.TOAXX, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Yêu cầu bổ sung số <b>' || b.SOTHONGBAO || '</b>' || DECODE(b.NGAYTHONGBAO, null, '', ' ngày ' || '<b>' || to_char(b.NGAYTHONGBAO,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOTHONGBAO as SOVB, b.NGAYTHONGBAO as NGAYVB, b.DONID, '1' LOAIVB
                  ,d.DONGKHIEUNAI as NGUOIGUI
                  ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                    End) as DIACHIGUI
                  , d.NGAYGHITRENDON
                  , d.NGAYNHANDON
                  , (Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) as BAQD
                  , (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) as BAQD_NGAYBA
                  , (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) as TOAXX
                  from GDTTT_DON_YEUCAU_BOSUNG b
                  left join GDTTT_DON d ON d.ID = b.DONID
                  left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
                  left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                  left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '1')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOTHONGBAO, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOTHONGBAO, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYTHONGBAO >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYTHONGBAO <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY b.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.NGAYVB = d.NGAYVB and td.LOAIVB = 'Yêu cầu bổ sung' and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , d.NGUOIGUI, d.DIACHIGUI, d.NGAYGHITRENDON, d.NGAYNHANDON, d.BAQD, d.BAQD_NGAYBA, d.TOAXX, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Giấy xác nhận nhận đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '2' LOAIVB, sd.DONID
                  ,d.DONGKHIEUNAI as NGUOIGUI
                  ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                    End) as DIACHIGUI
                  , d.NGAYGHITRENDON
                  , d.NGAYNHANDON
                  , (Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) as BAQD
                  , (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) as BAQD_NGAYBA
                  , (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) as TOAXX
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
                  left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                  left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO = 'SoGXN' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '2')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB < = TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Giấy xác nhận nhận đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.DONID order by td.ID) ROWSPAN
                  , row_number() over (partition by d.DONID order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , d.NGUOIGUI, d.DIACHIGUI, d.NGAYGHITRENDON, d.NGAYNHANDON, d.BAQD, d.BAQD_NGAYBA, d.TOAXX, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select d.ID, 'Trả lại đơn <b>' || d.CD_SOCV || '</b>' || DECODE(d.CD_NGAYCV, null, '', ' ngày ' || '<b>' || to_char(d.CD_NGAYCV,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, d.CD_SOCV as SOVB, d.CD_NGAYCV as NGAYVB, '3' LOAIVB, d.ID as DONID
                  ,d.DONGKHIEUNAI as NGUOIGUI
                  ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                    End) as DIACHIGUI
                  , d.NGAYGHITRENDON
                  , d.NGAYNHANDON
                  , (Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) as BAQD
                  , (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) as BAQD_NGAYBA
                  , (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) as TOAXX
                  from GDTTT_DON d
                  left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
                  left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                  left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND d.CD_LOAI = 3 AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '3')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(d.CD_SOCV, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(d.CD_SOCV, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(d.CD_NGAYCV >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(d.CD_NGAYCV <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY d.ID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on ((d.SOVB is null AND td.SOVB is null) OR td.SOVB = d.SOVB) and ((d.NGAYVB is null AND td.NGAYVB is null) OR td.NGAYVB = d.NGAYVB) and td.LOAIVB = 'Trả lại đơn' and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null))
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , d.NGUOIGUI, d.DIACHIGUI, d.NGAYGHITRENDON, d.NGAYNHANDON, d.BAQD, d.BAQD_NGAYBA, d.TOAXX, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo phân công thẩm phán <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  ,  'TP ' || tp.HOTEN as NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '4' LOAIVB, sd.DONID, Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN_NGUOIGUI
                  ,d.DONGKHIEUNAI as NGUOIGUI
                  ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                    End) as DIACHIGUI
                  , d.NGAYGHITRENDON
                  , d.NGAYNHANDON
                  , (Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) as BAQD
                  , (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) as BAQD_NGAYBA
                  , (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) as TOAXX
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
                  left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                  left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO  = 'TBTP' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '4')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo phân công thẩm phán' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN_NGUOIGUI) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , d.NGUOIGUI, d.DIACHIGUI, d.NGAYGHITRENDON, d.NGAYNHANDON, d.BAQD, d.BAQD_NGAYBA, d.TOAXX, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo gửi cơ quan chuyển đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '5' LOAIVB
                  ,d.DONGKHIEUNAI as NGUOIGUI
                  ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                    End) as DIACHIGUI
                  , d.NGAYGHITRENDON
                  , d.NGAYNHANDON
                  , (Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) as BAQD
                  , (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) as BAQD_NGAYBA
                  , (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) as TOAXX
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                  left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
                  left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                  left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO = 'SoGXN_DV' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1'  OR V_LOAI_VB = '5')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo gửi cơ quan chuyển đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
         ) ds GROUP BY ds.DONID, ds.LOAIVB, ds.SOVB, ds.NGAYVB, ds.NGUOIGUI, ds.DIACHIGUI, ds.NGAYGHITRENDON, ds.NGAYNHANDON, ds.BAQD, ds.BAQD_NGAYBA, ds.TOAXX, ds.ID, ds.TENVANBAN
        ) tmp 
    ) tbl 
    left join 
    (SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Yêu cầu bổ sung số <b>' || b.SOTHONGBAO || '</b>' || DECODE(b.NGAYTHONGBAO, null, '', ' ngày ' || '<b>' || to_char(b.NGAYTHONGBAO,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOTHONGBAO as SOVB, b.NGAYTHONGBAO as NGAYVB, b.DONID, '1' LOAIVB
                  from GDTTT_DON_YEUCAU_BOSUNG b
                  left join GDTTT_DON d ON d.ID = b.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '1')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOTHONGBAO, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOTHONGBAO, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYTHONGBAO >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYTHONGBAO <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY b.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.NGAYVB = d.NGAYVB and td.LOAIVB = 'Yêu cầu bổ sung' and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) OR 
            (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Giấy xác nhận nhận đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '2' LOAIVB, sd.DONID
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID 
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO = 'SoGXN' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '2')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )                                                                   
--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Giấy xác nhận nhận đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.DONID order by td.ID) ROWSPAN
                  , row_number() over (partition by d.DONID order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select d.ID, 'Trả lại đơn <b>' || d.CD_SOCV || '</b>' || DECODE(d.CD_NGAYCV, null, '', ' ngày ' || '<b>' || to_char(d.CD_NGAYCV,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, d.CD_SOCV as SOVB, d.CD_NGAYCV as NGAYVB, '3' LOAIVB, d.ID as DONID
                  from GDTTT_DON d
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where d.TOAANID=vToaAnID AND d.CD_LOAI = 3 AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '3')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(d.CD_SOCV, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(d.CD_SOCV, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(d.CD_NGAYCV >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(d.CD_NGAYCV <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY d.ID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on ((d.SOVB is null AND td.SOVB is null) OR td.SOVB = d.SOVB) and ((d.NGAYVB is null AND td.NGAYVB is null) OR td.NGAYVB = d.NGAYVB) and td.LOAIVB = 'Trả lại đơn' and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo phân công thẩm phán <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , 'TP ' || tp.HOTEN as NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '4' LOAIVB, sd.DONID, Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN_NGUOIGUI
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where  b.MASO = 'TBTP' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1' OR V_LOAI_VB = '4')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo phân công thẩm phán' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN_NGUOIGUI) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            UNION
            SELECT DECODE(td.ID, null, 0, td.ID) ID
                  , count(*) over (partition by d.TENVANBAN order by td.ID) ROWSPAN
                  , row_number() over (partition by d.TENVANBAN order by td.ID) RN
                  , d.ID as DONID
                  , d.TENVANBAN
                  , DECODE(nd.NOINHAN, null, d.NOINHAN, nd.NOINHAN) as NOINHAN
                  , DECODE(TO_CHAR(nd.NGAYGUI,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYGUI,'dd/MM/yyyy')) as NGAYGUI
                  , DECODE(TO_CHAR(nd.NGAYPHATHANH,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYPHATHANH,'dd/MM/yyyy')) as NGAYPHATHANH
                  , DECODE(TO_CHAR(nd.NGAYNHAN,'dd/MM/yyyy'), null, '', '01/01/0001', '', to_char(nd.NGAYNHAN,'dd/MM/yyyy')) as NGAYNHAN
                  , DECODE(nd.TRANGTHAI, 0, 'Chưa gửi', 1, 'Đã gửi', 2, 'Đã thu hồi', 3, 'Đã phát hành', 4, 'Phát hành thành công', 5, 'Phát hành không thành công', 6, 'Trực tiếp', 7,  'Niêm yết công khai') TRANGTHAI
                  , '' as THONGTINDON, d.SOVB, d.NGAYVB, d.LOAIVB
           from (
               select a.* from (
                  select b.ID, 'Thông báo gửi cơ quan chuyển đơn <b>' || b.SOVB || '</b>' || DECODE(b.NGAYVB, null, '', ' ngày ' || '<b>' || to_char(b.NGAYVB,'dd/MM/yyyy') || '</b>') as TENVANBAN
                  , Case when d.LOAIDON in (1,11,3,31,8,10) then d.NGUOIGUI_HOTEN
                         else d.CV_TENDONVI end NOINHAN, b.SOVB as SOVB, b.NGAYVB as NGAYVB, '5' LOAIVB
                  from QUANLY_SOPHATHANH b
                  left join  SOPHATHANH_DON sd on b.id = sd.SOPHATHANH_ID
                  left join GDTTT_DON d ON d.ID = sd.DONID
                  LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                 ----------
                  where b.MASO  = 'SoGXN_DV' AND b.trangthai = 1 AND d.TOAANID=vToaAnID AND (V_LOAI_VB = '-1'  OR V_LOAI_VB = '5')
                    And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                    and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
                    AND (vLoaiAn=0
                        OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                      )                                                    
                    and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )

--                    and  1=case when vNguoiGui || ' '=' ' then 1 
--                                when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 
--                                when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
--                                else 0 end       
                    AND (vNoiChuyen=-1
                         OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                        OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                        when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)       
                       AND ( V_SO_TU=0
                          OR (TO_NUMBER(NVL(b.SOVB, 0)) >= V_SO_TU)
                          )    
                      AND ( V_SO_DEN=0
                          OR(TO_NUMBER(NVL(b.SOVB, 0)) <= V_SO_DEN)
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(b.NGAYVB >= TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS'))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(b.NGAYVB <= TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS'))
                          ) 
                        ORDER BY sd.DONID desc
                      -----------------
               ) a
            ) d
            LEFT JOIN TONGDAT_HCTP td on td.SOVB = d.SOVB and td.LOAIVB = 'Thông báo gửi cơ quan chuyển đơn' and td.NGAYVB = d.NGAYVB and d.ID = td.DON_ID
            LEFT JOIN TONGDAT_HCTP_NOINHAN nd on td.ID = nd.TONGDAT_HCTP_ID AND (nd.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = nd.ID))
            WHERE (vTrangThai_PH = '0' OR (vTrangThai_PH = '1' AND nd.TRANGTHAI IN (3,4,5)) OR (vTrangThai_PH = '2' AND (nd.TRANGTHAI IN (0,1,2) OR nd.TRANGTHAI is null)) 
            OR (vTrangThai_PH = '3' AND nd.TRANGTHAI = 1) OR (vTrangThai_PH = '4' AND (nd.TRANGTHAI IN (0,2) OR nd.TRANGTHAI is null)))
            and  1=case when vNguoiGui || ' '=' ' then 1 
                        when lower(d.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1 
                        when lower(nd.NOINHAN) like '%' || lower(vNguoiGui) || '%' then 1
                        else 0 end
            ) dt on dt.DONID = tbl.DONID AND dt.ID = tbl.ID AND dt.TENVANBAN = tbl.TENVANBAN AND dt.LOAIVB = tbl.LOAIVB
    where tbl.stt>=MinIndex and tbl.stt<=MaxIndex
    ;
END GDTTT_HCTP_PHATHANH_DON_SEARCH;
PROCEDURE  GET_VAN_BAN_PHAT_HANH
( 
    vID  in number,
    vLoaiVB in number,
    curReturn    OUT       sys_refcursor
)IS
BEGIN
   if(vLoaiVB = 6) then
     OPEN curReturn FOR
       SELECT s.ID, 'Phiếu chuyển công văn số ' || s.SOVB || ' ngày ' || TO_CHAR(s.NGAYVB, 'dd/MM/yyyy')  VBPH
       FROM QUANLY_SOPHATHANH s
       WHERE s.ID = vID;
   elsif (vLoaiVB = 7) then
     OPEN curReturn FOR
       SELECT s.ID, 'Phiếu chuyển tờ trình số ' || s.SOVB || ' ngày ' || TO_CHAR(s.NGAYVB, 'dd/MM/yyyy')  VBPH
       FROM QUANLY_SOPHATHANH s
       WHERE s.ID = vID;
   elsif (vLoaiVB = 1) then 
     OPEN curReturn FOR
       SELECT d.ID, 'Yêu cầu bổ sung số ' || d.SOTHONGBAO || ' ngày ' || TO_CHAR(d.NGAYTHONGBAO, 'dd/MM/yyyy')  VBPH
       FROM GDTTT_DON_YEUCAU_BOSUNG d
       WHERE d.ID = vID;
   elsif (vLoaiVB = 2) then 
     OPEN curReturn FOR
       SELECT d.ID, 'Giấy xác nhận nhận đơn số ' || d.SOVB || ' ngày ' || TO_CHAR(d.NGAYVB, 'dd/MM/yyyy')  VBPH
       FROM QUANLY_SOPHATHANH d
       WHERE d.ID = vID AND d.MASO  = 'SoGXN' and d.trangthai = 1;
   elsif (vLoaiVB = 3) then 
     OPEN curReturn FOR
       SELECT d.ID,  'Trả lại đơn số ' || d.CD_SOCV || ' ngày ' || TO_CHAR(d.CD_NGAYCV, 'dd/MM/yyyy')  VBPH
       FROM GDTTT_DON d
       WHERE d.ID = vID;
   elsif (vLoaiVB = 4) then 
     OPEN curReturn FOR
       SELECT d.ID, 'Thông báo phân công thẩm phán số ' || d.SOVB || ' ngày ' || TO_CHAR(d.NGAYVB, 'dd/MM/yyyy')  VBPH
       FROM QUANLY_SOPHATHANH d
       WHERE d.ID = vID AND d.MASO  = 'TBTP' and d.trangthai = 1;
   elsif (vLoaiVB = 5) then 
     OPEN curReturn FOR
       SELECT d.ID, 'Thông báo gửi cơ quan chuyển đơn số ' || d.SOVB || ' ngày ' || TO_CHAR(d.NGAYVB, 'dd/MM/yyyy')  VBPH
       FROM QUANLY_SOPHATHANH d
       WHERE d.ID = vID and d.MASO  = 'SoGXN_DV' and d.trangthai = 1; 
   end if;
END GET_VAN_BAN_PHAT_HANH;

PROCEDURE  GET_VBPH_NOINHAN_DOITUONG
( 
    vID  in number,
    vLoaiVB in number,
    curReturn    OUT       sys_refcursor
)IS
BEGIN
   if(vLoaiVB = 6) then -- công văn
     OPEN curReturn FOR
       select DISTINCT 0 as ID
       , DECODE(d.ISTHULY, 1, d.THAMPHANID, d.CD_TA_DONVIID) as NOINHAN_ID
       , DECODE(d.ISTHULY, 1, 'TP. ' || tp.HOTEN, pb.TENPHONGBAN) as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , DECODE(d.ISTHULY, 1, '4.Thẩm phán ', '') as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from QUANLY_SOPHATHANH s 
    left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
    LEFT JOIN GDTTT_DON d ON d.ID = sd.DONID
    LEFT JOIN DM_CANBO tp ON tp.ID = d.THAMPHANID AND d.ISTHULY = 1
    left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID AND d.ISTHULY = 2
    left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
    Where s.ID = vID;
   elsif (vLoaiVB = 7) then -- tờ trình
     OPEN curReturn FOR
       select DISTINCT 0 as ID
       , 0 as NOINHAN_ID
       , 'Chánh án ' || tk.MA_TEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'4.Khác' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from QUANLY_SOPHATHANH s 
    left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
    LEFT JOIN GDTTT_DON d ON d.ID = sd.DONID  
    left join (select ID,MA_TEN from DM_TOAAN) tk on d.TOAANID=tk.ID
    Where s.ID = vID ;
   elsif (vLoaiVB = 1) then  -- yêu cầu bs
     OPEN curReturn FOR
       select 0 as ID
       , 0 as NOINHAN_ID
       , d.NGUOIGUI_HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , (Case when d.NGUOIGUI_TUCACHTOTUNG=1 then '1.Bị can/ đương sự'
                 when d.NGUOIGUI_TUCACHTOTUNG=2 then '2.Người tham gia tố tụng'
                 when d.NGUOIGUI_TUCACHTOTUNG=3 then '3.Người không liên quan đến vụ án'
                 when d.NGUOIGUI_TUCACHTOTUNG=4 then '4.Khác'
                 when d.NGUOIGUI_TUCACHTOTUNG=5 then '5.Nguyên đơn/ Người khởi kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=6 then '6.Bị đơn/ Người bị kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=7 then '7.Bị cáo'
                 when d.NGUOIGUI_TUCACHTOTUNG=8 then '8.Bị hại'
                 Else '9.Người có quyền lợi nghĩa vụ liên quan'
                 End) as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , (DECODE(d.NGUOIGUI_DIACHI, null, '', d.NGUOIGUI_DIACHI || ', ') || DECODE(d.NGUOIGUI_HUYENID, null, '', hh.TEN || ', ' || ht.TEN)) as DIACHI                 
    from GDTTT_DON_YEUCAU_BOSUNG y
    left join GDTTT_DON d on d.ID = y.DONID   
    left join DM_HANHCHINH ht on d.NGUOIGUI_TINHID = ht.ID
    left join DM_HANHCHINH hh on d.NGUOIGUI_HUYENID = hh.ID
    left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
    Where y.ID = vID and d.LOAIDON in (1,11,3,31,8,10)
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , kn.HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , 'Người khiếu nại' as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , TO_CHAR(kn.DIACHI) as DIACHI                 
    from GDTTT_DON_YEUCAU_BOSUNG y
    left join GDTTT_DON d on d.ID = y.DONID   
    left join GDTTT_DON_NGUOIKN kn ON kn.DONID = d.ID
    Where y.ID = vID and d.LOAIDON in (1,11,3,31,8,10) AND kn.ID is not null
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , d.CV_TENDONVI  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from GDTTT_DON_YEUCAU_BOSUNG y
    left join GDTTT_DON d on d.ID = y.DONID 
    Where y.ID = vID and d.LOAIDON in (2,6,9,12);
    elsif (vLoaiVB = 2) then  -- giấy xác nhận
     OPEN curReturn FOR
       select 0 as ID
       , 0 as NOINHAN_ID
       , d.NGUOIGUI_HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , (Case when d.NGUOIGUI_TUCACHTOTUNG=1 then '1.Bị can/ đương sự'
                 when d.NGUOIGUI_TUCACHTOTUNG=2 then '2.Người tham gia tố tụng'
                 when d.NGUOIGUI_TUCACHTOTUNG=3 then '3.Người không liên quan đến vụ án'
                 when d.NGUOIGUI_TUCACHTOTUNG=4 then '4.Khác'
                 when d.NGUOIGUI_TUCACHTOTUNG=5 then '5.Nguyên đơn/ Người khởi kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=6 then '6.Bị đơn/ Người bị kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=7 then '7.Bị cáo'
                 when d.NGUOIGUI_TUCACHTOTUNG=8 then '8.Bị hại'
                 Else '9.Người có quyền lợi nghĩa vụ liên quan'
                 End) as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , (DECODE(d.NGUOIGUI_DIACHI, null, '', d.NGUOIGUI_DIACHI || ', ') || DECODE(d.NGUOIGUI_HUYENID, null, '', hh.TEN || ', ' || ht.TEN)) as DIACHI                 
    from QUANLY_SOPHATHANH y
    left join  SOPHATHANH_DON sd on y.id = sd.SOPHATHANH_ID 
    left join GDTTT_DON d on d.ID = sd.DONID     
    left join DM_HANHCHINH ht on d.NGUOIGUI_TINHID = ht.ID
    left join DM_HANHCHINH hh on d.NGUOIGUI_HUYENID = hh.ID
    left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
    Where y.ID = vID and d.LOAIDON in (1,11,3,31,8,10)
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , kn.HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , 'Người khiếu nại' as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , TO_CHAR(kn.DIACHI) as DIACHI                 
    from QUANLY_SOPHATHANH y
    left join  SOPHATHANH_DON sd on y.id = sd.SOPHATHANH_ID 
    left join GDTTT_DON d on d.ID = sd.DONID   
    left join GDTTT_DON_NGUOIKN kn ON kn.DONID = d.ID
    Where y.ID = vID and d.LOAIDON in (1,11,3,31,8,10) AND kn.ID is not null
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , d.CV_TENDONVI  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from QUANLY_SOPHATHANH y
    left join  SOPHATHANH_DON sd on y.id = sd.SOPHATHANH_ID 
    left join GDTTT_DON d on d.ID = sd.DONID 
    Where y.ID = vID and d.LOAIDON in (2,6,9,12);
   elsif (vLoaiVB = 3) then  -- trả lại đơn
     OPEN curReturn FOR
       select 0 as ID
       , 0 as NOINHAN_ID
       , d.NGUOIGUI_HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , (Case when d.NGUOIGUI_TUCACHTOTUNG=1 then '1.Bị can/ đương sự'
                 when d.NGUOIGUI_TUCACHTOTUNG=2 then '2.Người tham gia tố tụng'
                 when d.NGUOIGUI_TUCACHTOTUNG=3 then '3.Người không liên quan đến vụ án'
                 when d.NGUOIGUI_TUCACHTOTUNG=4 then '4.Khác'
                 when d.NGUOIGUI_TUCACHTOTUNG=5 then '5.Nguyên đơn/ Người khởi kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=6 then '6.Bị đơn/ Người bị kiện'
                 when d.NGUOIGUI_TUCACHTOTUNG=7 then '7.Bị cáo'
                 when d.NGUOIGUI_TUCACHTOTUNG=8 then '8.Bị hại'
                 Else '9.Người có quyền lợi nghĩa vụ liên quan'
                 End) as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , (DECODE(d.NGUOIGUI_DIACHI, null, '', d.NGUOIGUI_DIACHI || ', ') || DECODE(d.NGUOIGUI_HUYENID, null, '', hh.TEN || ', '|| ht.TEN)) as DIACHI                 
    from GDTTT_DON d   
    left join DM_HANHCHINH ht on d.NGUOIGUI_TINHID = ht.ID
    left join DM_HANHCHINH hh on d.NGUOIGUI_HUYENID = hh.ID
    left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
    Where d.ID = vID and d.LOAIDON in (1,11,3,31,8,10)
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , kn.HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       , 'Người khiếu nại' as TUCACHTOTUNG
       , 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       , TO_CHAR(kn.DIACHI) as DIACHI                 
    from GDTTT_DON d   
    left join GDTTT_DON_NGUOIKN kn ON kn.DONID = d.ID
    Where d.ID = vID and d.LOAIDON in (1,11,3,31,8,10) AND kn.ID is not null
    UNION ALL 
    select 0 as ID
       , 0 as NOINHAN_ID
       , d.CV_TENDONVI  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from GDTTT_DON d
    Where d.ID = vID and d.LOAIDON in (2,6,9,12);
   elsif (vLoaiVB = 4) then  -- phân công thẩm phán
     OPEN curReturn FOR
       select 0 as ID
       , tp.ID as NOINHAN_ID
       , 'TP ' || tp.HOTEN  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI                 
    from QUANLY_SOPHATHANH c 
    left join  SOPHATHANH_DON sd on c.id = sd.SOPHATHANH_ID
    left join GDTTT_DON d on sd.DONID = d.ID
    left join (select ID,HOTEN from DM_CANBO) tp on d.THAMPHANID=tp.ID
    Where c.ID = vID;
   elsif (vLoaiVB = 5) then  -- gửi cơ quan chuyển đơn
     OPEN curReturn FOR
       select 0 as ID
       , 0 as NOINHAN_ID
       , d.CV_TENDONVI  as NOINHAN, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
       ,'' as TUCACHTOTUNG, 0 as CHECKTONGDAT, '2' as HINHTHUCGUI, 0 as DOITUONG, '' as NGAYGUI, 0 as TRANGTHAI
       ,'' as DIACHI  
       FROM QUANLY_SOPHATHANH s
       left join  SOPHATHANH_DON sd on s.id = sd.SOPHATHANH_ID
    left join GDTTT_DON d on sd.DONID = d.ID
       WHERE s.ID = vID; 
   end if; 
END GET_VBPH_NOINHAN_DOITUONG;
PROCEDURE  GET_VBPH_NOINHAN_DOITUONG_EDIT
( 
    v_TONGDAT_HCTP_ID  in number,
    v_NOINHAN_ID in number,
    curReturn    OUT       sys_refcursor
)IS 
BEGIN
OPEN curReturn FOR  
    select n.ID, n.NOINHAN, n.NOINHAN_ID as NOINHANID, DECODE(n.TRANGTHAI, 0, 0, 6, 1, 7, 1, 1) AS CHECKTONGDAT
    , n.DOITUONG, n.DIACHI, n.TUCACHTOTUNG, n.HINHTHUCGUI, n.NGAYGUI, n.TRANGTHAI, '0' ISBOSUNG, 0 as PHATHANHLAI_ID
    from TONGDAT_HCTP_NOINHAN n 
    Where n.TONGDAT_HCTP_ID = v_TONGDAT_HCTP_ID AND (n.TRANGTHAI != 5 OR NOT EXISTS(SELECT 'X' FROM TONGDAT_HCTP_NOINHAN WHERE PHATHANHLAI_ID = n.ID))
    UNION
    select 0 as ID, n.NOINHAN, n.NOINHAN_ID as NOINHANID,0 AS CHECKTONGDAT
    , n.DOITUONG, n.DIACHI, n.TUCACHTOTUNG, 2 as HINHTHUCGUI, SYSDATE() as NGAYGUI, 0 as TRANGTHAI, '1' ISBOSUNG, v_NOINHAN_ID as PHATHANHLAI_ID
    from TONGDAT_HCTP_NOINHAN n 
    Where n.ID = v_NOINHAN_ID 
    ORDER BY ID DESC;
END GET_VBPH_NOINHAN_DOITUONG_EDIT;

PROCEDURE  THUHOI_TONGDAT_HCTP
( 
    v_id  in number,
    vNgayThuHoi  in date,
    vLyDo  in varchar2,
    vNguoiSua in varchar2,
     vCount out number
)IS 
BEGIN
    select count(*) INTO vCount from TONGDAT_HCTP_NOINHAN where TONGDAT_HCTP_ID = v_id AND TRANGTHAI=1;
    update TONGDAT_HCTP
    set
        NGAYTHUHOI = vNgayThuHoi,
        LYDOTHUHOI = vLyDo,
        NGAYSUA = SYSDATE,
        NGUOISUA = vNguoiSua
    where id = v_id;
    update TONGDAT_HCTP_NOINHAN
    set
        TRANGTHAI = 2
    where TONGDAT_HCTP_ID = v_id AND TRANGTHAI=1;
END THUHOI_TONGDAT_HCTP;
END PKG_GDTTT_HCTP_PHATHANH;

/
