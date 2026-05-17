--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_GDT_APP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_GDT_APP" AS
PROCEDURE DASHBOARD_GDT_CREATE_DATA
 AS    
    V_SYSDATE DATE;V_COUNTS NUMBER;
    V_KQLOAI NUMBER; V_SOTHULYXX VARCHAR2(512);V_NGAYTHULYXX DATE;V_NGUOIGUIDON  VARCHAR2(2000);
    V_SOTHULY VARCHAR2(512);V_NGAYTHULY DATE;V_SOBA VARCHAR2(512);V_NGAYBA  VARCHAR2(512);
    V_SOQDXX VARCHAR2(512);V_NGAYQDXX DATE;V_THUOCDON VARCHAR2(512);V_QH VARCHAR2(512);V_QH_ID VARCHAR2(1000);
BEGIN
    DELETE DASHBOARD_GDT;COMMIT;
    -----
    select LISTAGG(id,',')WITHIN GROUP (ORDER BY id DESC) INTO V_QH_ID from dm_dataitem where ma like 'CV8.1%' or   ma like 'CV9.3%' or ma ='CVCHUYEN';
    SELECT SYSDATE INTO V_SYSDATE FROM DUAL; 
    -----------lấy những vụ án có ----v.TRUONGHOPTHULY=1 and d.vuviecid is null
   FOR item in (
           SELECT  a.id DONID,decode(a.toaanid,null,1,a.toaanid)toaanid,a.CD_TA_DONVIID PHONGBANID,v.LOAIAN
           ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOBA
           ,DECODE(a.BAQD_CAPXETXU,4,a.BAQD_SO,2,a.BAQD_SO_ST,3,a.BAQD_SO_PT,a.BAQD_SO_PT)DON_SOBA
           ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYBA
           ,DECODE(a.BAQD_CAPXETXU,4,to_char(a.BAQD_NGAYBA,'dd/MM/yyyy'),2,to_char(a.BAQD_NGAYBA_ST,'dd/MM/yyyy'),3,to_char(a.BAQD_NGAYBA_PT,'dd/MM/yyyy'),to_char(a.BAQD_NGAYBA_PT,'dd/MM/yyyy'))DON_NGAYBA
           ,DECODE(v.BAQD_CAPXETXU,4,v.TOAQDID,3,v.TOAPHUCTHAMID,2,v.ToaAnSoTham,v.SOANPHUCTHAM)TOAXX
           ,v.BAQD_CAPXETXU CAPXX
           --,decode(v.TRUONGHOPTHULY,1,4,a.LOAIDON)LOAIDON
           ,decode(a.VUVIECID,null,decode(v.TRUONGHOPTHULY,1,4,a.LOAIDON),a.LOAIDON)LOAIDON
           ,a.TL_SO SOTHULY-- if loai don =4 thi se day vao SOTHULYXX
           ,a.TL_NGAY NGAYTHULY
           ,a.DONGKHIEUNAI NGUOIGUIDON
           ,DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
                                                                  ,819,'<b>Kháng nghị của CA TANDCC tại Hà Nội</b>'
																	,820,'<b>Kháng nghị của CA TANDCC tại Đà Nẵng</b>'
																	,821,'<b>Kháng nghị của CA TANDCC tại Hồ Chí Minh</b>'
                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIGUIDON_KN
           ,a.NGUOIGUI_DIACHI DIACHI
           ,a.LOAICONGVAN THUOCDON--cv.ten
           ,a.THAMPHANID,null NGAYTRINH,null NGAYYKIEN
           ,DECODE(v.LOAIAN,1,DECODE(HS_TLD.LOAI,NULL,NULL,0)||DECODE(HS_KN.LOAI,NULL,NULL,1)
           ,DECODE(TLD_DS.LOAI,NULL,NULL,0)||DECODE(KN_DS.LOAI,NULL,NULL,1)||DECODE(XD_DS.LOAI,NULL,NULL,2) ) KQLOAI --if loaidon=4 then KQLOAI=1
           ,v.gqd_loaiketqua
           ,decode(DECODE(v.LOAIAN,1,HS_TLD.SO||HS_KN.SO,TLD_DS.SO||KN_DS.SO||XD_DS.SO),NULL,V.GDQ_SO,
           DECODE(v.LOAIAN,1,HS_TLD.SO||HS_KN.SO,TLD_DS.SO||KN_DS.SO||XD_DS.SO) )KQSO
           ,DECODE(DECODE(v.LOAIAN,1,HS_TLD.NGAY||HS_KN.NGAY,TLD_DS.NGAY||KN_DS.NGAY||XD_DS.NGAY),NULL,V.GDQ_NGAY
           ,DECODE(v.LOAIAN,1,HS_TLD.NGAY||HS_KN.NGAY,TLD_DS.NGAY||KN_DS.NGAY||XD_DS.NGAY))KQNGAY
           ,v.XXGDTTT_SOQD  SOQDXX
           ,v.XXGDTTT_NGAYQD NGAYQDXX
           ,ct.CANBOID CHUTOA
           ,NULL NGAYDONGBO
           ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
           ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
           --,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QUANHEPL
           ,decode(Trim(v.QHPL_TEXT),null,decode(Trim(qhpl.TenQHPL),null,TD.DIEU ||'.'|| TD.TENTOIDANH,qhpl.TenQHPL),v.QHPL_TEXT) QUANHEPL  
           ,DECODE(V.XXGDT_THAMTRAVIENID,null,V.THAMTRAVIENID,V.XXGDT_THAMTRAVIENID) THAMTRAVIENID
           ,decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)  LANHDAO
           ,v.id VUANID
           ,DTNT.NGAYTRINH DUTHAONGAYTRINH 
           ,DECODE(DTLKK.LOAIYKIEN,3,2,DTLKK.LOAIYKIEN) DUTHAOLOAIKQ --ep LOAIYKIEN=2(xep don de dong nhat voi truong KQLOAI that)
           ,DTLKK.YKIEN DUTHAO_NOIDUNG
           ,v.SOTHULYXXGDT SOTHULYXX
           ,v.NGAYTHULYXXGDT NGAYTHULYXX
           ,v.THULYLAI_VUANID,v.SOTHULYDON,v.NGAYTHULYDON
           ,a.CV_SO,a.CV_NGAY           
           ,DECODE(a.CV_ISTRONGNGANH,1,ta.ma_ten,a.CV_TENDONVI)CV_TENDONVI
           ,v.THAMQUYENXXGDT
           ,v.ISRUTKN,v.SORUTKN,v.NGAYRUTKN
           FROM GDTTT_DON a
           FULL OUTER JOIN GDTTT_VUAN V ON A.VUVIECID=V.ID --OR (V.TRUONGHOPTHULY =1 AND A.VUVIECID IS NULL) )--V.TRUONGHOPTHULY =1 hồ sơ kháng nghị
           LEFT JOIN DM_TOAAN TA ON TA.ID=a.CV_TOAANID
           LEFT JOIN DM_BOLUAT_TOIDANH td ON V.QHPL_THONGKEID = td.ID
--           LEFT JOIN(SELECT i.ID,i.MA,i.TEN,((Case SOCAP WHen 2 then '...' when 3 then '......' else '' End)||i.Ten) MA_TEN
--                    FROM DM_DATAITEM i
--                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
--                    Where g.MA='LOAICVGDTTT' and i.HIEULUC=1
--                    Order By i.ARRTHUTU
--           )cv on cv.id=a.LOAICONGVAN
           LEFT JOIN(SELECT TT.VUANID,DECODE(instr(TT.LOAIYKIEN,','),0,TT.LOAIYKIEN,SUBSTR(TT.LOAIYKIEN,0,instr(TT.LOAIYKIEN,',') - 1))LOAIYKIEN
                      ,DECODE(instr(TT.YKIEN,','),0,TT.YKIEN,SUBSTR(TT.YKIEN,0,instr(TT.YKIEN,',') - 1))YKIEN  FROM (
                      select TK.VUANID,LISTAGG(TK.LOAIYKIEN,',')WITHIN GROUP (ORDER BY NGAYTRINH)LOAIYKIEN  
                      ,LISTAGG(TK.YKIEN,',')WITHIN GROUP (ORDER BY NGAYTRINH)YKIEN     
                      from  GDTTT_TOTRINH TK WHERE (TK.LOAIYKIEN IN (0,1,3))
                      group by TK.VUANID
                      )TT 
              )DTLKK ON  DTLKK.VUANID=v.id
           LEFT JOIN(SELECT TT.VUANID,DECODE(instr(TT.NGAYTRINH,','),0,TT.NGAYTRINH,SUBSTR(TT.NGAYTRINH,0,instr(TT.NGAYTRINH,',') - 1))NGAYTRINH FROM (
                      select TK.VUANID,LISTAGG(TK.NGAYTRINH,',')WITHIN GROUP (ORDER BY NGAYTRINH)NGAYTRINH     
                      from  GDTTT_TOTRINH TK WHERE (TK.TINHTRANGID IN (11,12) or TK.CAPTRINHTIEP IN (11,12))
                      group by TK.VUANID
                      )TT 
            )DTNT ON DTNT.VUANID=v.id
           left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
           LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
           left join gdttt_vuan v on a.VUVIECID=v.id  
           LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                        FROM GDTTT_VUAN_DUONGSU DS
                        WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                        GROUP BY DS.VUANID
                )ND ON ND.VUANID=V.ID     
           LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                        FROM GDTTT_VUAN_DUONGSU DS
                        WHERE DS.TUCACHTOTUNG='BIDON' 
                        GROUP BY DS.VUANID
            )BD ON BD.VUANID=V.ID 
           left join(select HD.* FROM GDTTT_VuAn_XXGDTT_HoiDong HD where NVL(HD.IsChuToa,0)=1)ct on ct.VUANID=v.id
           LEFT JOIN (SELECT TT.DONID
                        ,DECODE(instr(TT.SO,','),0,TT.SO,SUBSTR(TT.SO,0,instr(TT.SO,',') - 1))SO
                        ,DECODE(instr(TT.NGAY,','),0,TT.NGAY,SUBSTR(TT.NGAY,0,instr(TT.NGAY,',') - 1))NGAY
                        ,SUBSTR(TT.LOAI,0,1)LOAI 
                       FROM (
                            select TK.DONID,LISTAGG(TK.SO,',')WITHIN GROUP (ORDER BY ID DESC)SO
                            ,LISTAGG(TK.NGAY,',')WITHIN GROUP (ORDER BY ID DESC)NGAY
                            ,LISTAGG(TK.TYPETB,',')WITHIN GROUP (ORDER BY ID DESC)LOAI
                            from GDTTT_DON_TRALOI TK WHERE  TK.TYPETB=3 AND TK.DONID!=0 group by TK.DONID  )TT
                        ) HS_TLD ON HS_TLD.DONID=A.ID
             LEFT JOIN (SELECT TT.DONID
                        ,DECODE(instr(TT.SO,','),0,TT.SO,SUBSTR(TT.SO,0,instr(TT.SO,',') - 1))SO
                        ,DECODE(instr(TT.NGAY,','),0,TT.NGAY,SUBSTR(TT.NGAY,0,instr(TT.NGAY,',') - 1))NGAY
                        ,SUBSTR(TT.LOAI,0,1)LOAI 
                        FROM (
                            select TK.DONID,LISTAGG(TK.SO,',')WITHIN GROUP (ORDER BY ID DESC)SO
                            ,LISTAGG(TK.NGAY,',')WITHIN GROUP (ORDER BY ID DESC)NGAY
                            ,LISTAGG(TK.TYPETB,',')WITHIN GROUP (ORDER BY ID DESC)LOAI
                            from GDTTT_DON_TRALOI TK WHERE  TK.TYPETB=4 AND TK.DONID!=0 group by TK.DONID  )TT
                        ) HS_KN ON HS_KN.DONID=A.ID   
             LEFT JOIN (SELECT TT.DONID
                        ,DECODE(instr(TT.SO,','),0,TT.SO,SUBSTR(TT.SO,0,instr(TT.SO,',') - 1))SO
                        ,DECODE(instr(TT.NGAY,','),0,TT.NGAY,SUBSTR(TT.NGAY,0,instr(TT.NGAY,',') - 1))NGAY
                        ,SUBSTR(TT.LOAI,0,1)LOAI 
                        FROM (
                            select TK.DONID,LISTAGG(TK.SO,',')WITHIN GROUP (ORDER BY ID DESC)SO
                            ,LISTAGG(TK.NGAY,',')WITHIN GROUP (ORDER BY ID DESC)NGAY
                            ,LISTAGG(TK.LOAI,',')WITHIN GROUP (ORDER BY ID DESC)LOAI
                            from  GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1 AND TK.DONID!=0
                            group by TK.DONID)TT
                            )TLD_DS  ON TLD_DS.DONID=A.ID      
             LEFT JOIN (SELECT TT.DONID
                    ,DECODE(instr(TT.SO,','),0,TT.SO,SUBSTR(TT.SO,0,instr(TT.SO,',') - 1))SO
                    ,DECODE(instr(TT.NGAY,','),0,TT.NGAY,SUBSTR(TT.NGAY,0,instr(TT.NGAY,',') - 1))NGAY
                    ,SUBSTR(TT.LOAI,0,1)LOAI 
                    FROM (
                        select TK.DONID,LISTAGG(TK.SO,',')WITHIN GROUP (ORDER BY ID DESC)SO
                        ,LISTAGG(TK.NGAY,',')WITHIN GROUP (ORDER BY ID DESC)NGAY
                        ,LISTAGG(TK.LOAI,',')WITHIN GROUP (ORDER BY ID DESC)LOAI
                        from  GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1 AND TK.DONID!=0
                        group by TK.DONID)TT
                     )KN_DS  ON KN_DS.DONID=A.ID    
              LEFT JOIN (SELECT TT.DONID
                     ,DECODE(instr(TT.SO,','),0,TT.SO,SUBSTR(TT.SO,0,instr(TT.SO,',') - 1))SO
                     ,DECODE(instr(TT.NGAY,','),0,TT.NGAY,SUBSTR(TT.NGAY,0,instr(TT.NGAY,',') - 1))NGAY
                      ,SUBSTR(TT.LOAI,0,1)LOAI 
                      FROM (
                          select TK.DONID,LISTAGG(TK.SO,',')WITHIN GROUP (ORDER BY ID DESC)SO
                          ,LISTAGG(TK.NGAY,',')WITHIN GROUP (ORDER BY ID DESC)NGAY
                          ,LISTAGG(TK.LOAI,',')WITHIN GROUP (ORDER BY ID DESC)LOAI
                          from  GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI in  (2,3,4) AND TK.TRANGTHAI=1 AND TK.DONID!=0
                          group by TK.DONID)TT
                     )XD_DS  ON XD_DS.DONID=A.ID   
          WHERE           
           (a.id is null or (a.ISTHULY=1 or a.LOAIDON=4)) --a.id is null trường hợp không tồn tại ở bảng đơn
            AND (a.id is null or (a.TL_SO IS NOT NULL AND a.TL_NGAY IS NOT NULL) )
            AND v.LOAIAN in(1,2,3,4,5,6,7)
            AND  (a.id is null or a.toaanid=1)
           -- AND (a.id is not null or (v.TRUONGHOPTHULY=1 and a.vuviecid is null) )
    )
    LOOP
      -------------
        IF(item.LOAIDON=4)THEN
            V_KQLOAI:=1;
             select decode(item.SOTHULY,null,item.SOTHULYXX,item.SOTHULY) into V_SOTHULYXX from dual;
             select decode(item.NGAYTHULY,null,item.NGAYTHULYXX,item.NGAYTHULY) into V_NGAYTHULYXX from dual;
             SELECT DECODE(item.NGUOIGUIDON,NULL,item.NGUOIGUIDON_KN,item.NGUOIGUIDON) INTO V_NGUOIGUIDON FROM DUAL;
             V_SOTHULY:=item.SOTHULY;V_NGAYTHULY:=item.NGAYTHULY; --truong hop du lieu cu
        ELSE
           SELECT DECODE(item.KQLOAI,NULL,item.gqd_loaiketqua,item.KQLOAI) INTO V_KQLOAI FROM DUAL;
           SELECT DECODE(V_KQLOAI,4,2,3,2,V_KQLOAI)INTO V_KQLOAI FROM DUAL;--3,4 la xu ly khac ep thanh xep don
            V_SOTHULYXX:=item.SOTHULYXX;
            V_NGAYTHULYXX:=item.NGAYTHULYXX;
            V_NGUOIGUIDON:=item.NGUOIGUIDON;
            SELECT  DECODE(item.SOTHULY,null,item.SOTHULYDON,item.SOTHULY)INTO V_SOTHULY FROM DUAL;           
            SELECT  DECODE(item.NGAYTHULY,null,item.NGAYTHULYDON,item.NGAYTHULY)INTO V_NGAYTHULY FROM DUAL; --truong hop du lieu cu
        END IF;         
        SELECT DECODE(item.SOBA,null,item.DON_SOBA,item.SOBA)INTO V_SOBA  from dual;
        SELECT DECODE(item.NGAYBA,null,item.DON_NGAYBA,item.NGAYBA)INTO V_NGAYBA  from dual;
        SELECT DECODE(item.ISRUTKN,1,'QĐ rút KN: '||item.SORUTKN,item.SOQDXX) into V_SOQDXX from dual;
        SELECT DECODE(item.ISRUTKN,1,item.NGAYRUTKN,item.NGAYQDXX) into V_NGAYQDXX from dual;
--      tạm thời đóng lại vì có sự thay đổi nghiệp vụ
--        if(item.THUOCDON is null)then
        --CV9.3,CVCHUYEN,CV8.1.CQQH
--            select count(*),LISTAGG(a.LOAICONGVAN,',')WITHIN GROUP (ORDER BY a.LOAICONGVAN DESC) into V_COUNTS,V_QH from gdttt_don a 
--            where a.vuviecid = item.VUANID             
--            AND instr(','||V_QH_ID||',',','||a.loaicongvan||',')>0; --and a.loaicongvan in (select id from dm_dataitem where ma like 'CV8.1%' or   ma like 'CV9.3%' or ma ='CVCHUYEN')  
--        if(V_COUNTS>0)THEN
--            V_THUOCDON:=V_QH;                
--        END IF;
--        else
--        V_THUOCDON:=item.THUOCDON;
--        end if;      
          V_THUOCDON:=item.THUOCDON;
           -------------
          IF(V_SOBA IS NOT NULL AND V_NGAYBA IS NOT NULL) THEN
              insert into DASHBOARD_GDT
                            (DONID,TOAANID,PHONGBANID,LOAIAN
                            ,SOBA,NGAYBA
                            ,TOAXX,CAPXX,LOAIDON
                            ,SOTHULY,NGAYTHULY
                            ,NGUOIGUIDON,DIACHI
                            ,THUOCDON
                            ,THAMPHANID,NGAYTRINH,NGAYYKIEN
                            ,KQLOAI,KQSO,KQNGAY
                            ,SOQDXX,NGAYQDXX
                            ,CHUTOA,NGAYDONGBO,NGUYENDON,BIDON,QUANHEPL,THAMTRAVIENID,LANHDAO,VUANID,DUTHAONGAYTRINH,DUTHAOLOAIKQ,DUTHAO_NOIDUNG
                            ,SOTHULYXX,NGAYTHULYXX,THULYLAI_VUANID
                            ,CV_SO,CV_NGAY,CV_TENDONVI
                            ,THAMQUYENXXGDT)
                            values 
                            (item.DONID,item.TOAANID,item.PHONGBANID,item.LOAIAN
                            ,V_SOBA,V_NGAYBA
                            ,item.TOAXX,item.CAPXX,item.LOAIDON
                            ,V_SOTHULY,V_NGAYTHULY
                            ,V_NGUOIGUIDON,item.DIACHI
                            ,V_THUOCDON
                            ,item.THAMPHANID,item.NGAYTRINH,item.NGAYYKIEN
                            ,V_KQLOAI,item.KQSO,item.KQNGAY
                            ,V_SOQDXX,V_NGAYQDXX
                            ,item.CHUTOA,V_SYSDATE,item.NGUYENDON,item.BIDON,item.QUANHEPL,item.THAMTRAVIENID,item.LANHDAO,item.VUANID,item.DUTHAONGAYTRINH,item.DUTHAOLOAIKQ,item.DUTHAO_NOIDUNG
                            ,V_SOTHULYXX,V_NGAYTHULYXX,item.THULYLAI_VUANID
                            ,item.CV_SO,item.CV_NGAY,item.CV_TENDONVI
                            ,item.THAMQUYENXXGDT);
                 COMMIT;          
        END IF;
    END LOOP;
END;
END PKG_DASHBOARD_GDT_APP;

/
