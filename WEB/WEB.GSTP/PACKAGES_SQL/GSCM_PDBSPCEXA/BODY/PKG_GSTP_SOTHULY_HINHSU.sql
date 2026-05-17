--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_SOTHULY_HINHSU
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_SOTHULY_HINHSU" AS

    /*16 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ SƠ THẨM*/
PROCEDURE FILL_HINHSU_SOTHAM
	(
		v_ARRAY IN OUT T_HINHSU_SOTHAM
	) AS
        VV_HOTENBICAO_2 CLOB;               VV_THOIHANTAMGIAM_3 CLOB;               
        VV_CAOTRANG_4 CLOB;                 VV_BANCAOTRANG VARCHAR(250);             
        VV_NGUOITHAMGIATOTUNG_5 CLOB;       VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 CLOB;     VV_GQ_TDC_8 CLOB;
        VV_GQ_TRAHOSOCHOVKS_9 CLOB;          VV_GQ_TRAHOSOCHOVKS_10 CLOB;
        VV_GQ_DC_11 CLOB;                   VV_GQ_TAPHUCHOIVA_12 CLOB;              VV_GQ_LYDO_13 CLOB;
        VV_XX_NGUOITIENHANHTOTUNG_14 CLOB;  
        VV_PTNTBICAO_TREMOCOI_18 CLOB;
        VV_KC_22 CLOB;                      VV_KN_23 CLOB;                          VV_GHICHU_26 CLOB;
        TEXT_REPORT CLOB DEFAULT '';
        CHECK_NUMBER NUMBER;

        TOIDANH CLOB DEFAULT ''; HINHPHAT CLOB DEFAULT ''; HINHPHATID NUMBER;
        V_CURSOR sys_refcursor; 
        TEXT_TOIDANH CLOB DEFAULT '';

        VV_NGAYTHULY DATE;
        VV_BANANID NUMBER;
	BEGIN	
    -- Cột 1 - v_TL_1 - THỤ LÝ HỒ SƠ Số, ngày tháng năm
    FOR ITEM IN (SELECT T1.v_STT, T2.SOTHULY || CHR(10) || TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1,
                        T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_SOTHAM_THULY T2 ON T1.v_THULYID=T2.ID)
    LOOP
        v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
        v_ARRAY(ITEM.v_STT).V_NGAYTHULY:= ITEM.V_NGAYTHULY;
        
                          if(ITEM.V_NGAYTHULY IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(ITEM.V_NGAYTHULY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
                          
        v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
    END LOOP;

    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1 GROUP BY T1.v_STT, T1.v_VUANID) 
    LOOP
        -- Cột 2 - v_HOTENBICAO_2 - HỌ TÊN BỊ CÁO Năm sinh,nơi cư trú, giới tính, quốc tịch, dân tộc, nghề nghiệp,  -- Công chức, viên chức, đảng viên, tái phạm, tái phạm nguy hiểm, nghiện ma túy (nếu có)
        FOR ITEMS IN (SELECT  '- ' || T2.HOTEN || '; ' || DECODE(T2.NAMSINH,0,' ',T2.NAMSINH ||'; ')
                              || 'Nơi cư trú: ' || T2.TAMTRUCHITIET || DECODE(T2.TAMTRUCHITIET,'','',', ')
                                                || T7.TEN || DECODE(T7.TEN,'','',', ' )
                                                || T8.TEN || DECODE(T8.TEN,'','', ', ' )
                              || DECODE(T2.GIOITINH,0,' Giới tính: Nữ;',1,' Giới tính: Nam;', '')
                              || DECODE(NVL(T5.TEN,''),'','',' Quốc tịch: '     ||T5.TEN    ||'; ')
                              || DECODE(NVL(T6.TEN,''),'','',' Dân tộc: '       ||T6.TEN    ||'; ')
                              || DECODE(NVL(T4.TEN,''),'','',' Nghề nghiệp: '   ||T4.TEN    ||'; ')
                              || DECODE(T2.CHUCVUCHINHQUYENID,1,'Công chức, viên chức: Có; ','')
                              || DECODE(T2.CHUCVUDANGID,1,'Đảng viên: Có; ','')
                              || DECODE(T2.TAIPHAM,1,'Tái phạm, tái phạm nguy hiểm: Có; ','')
                              || DECODE(T2.NGHIENHUT,1,'Nghiện ma túy: Có; ','')
                              || CHR(10) AS VV_BICAO
                        FROM AHS_BICANBICAO T2
                            LEFT JOIN DM_DATAITEM T4 ON T4.ID = T2.NGHENGHIEPID AND T4.GROUPID  =22 -- NGHỀ NGHIỆP
                            LEFT JOIN DM_DATAITEM T5 ON T5.ID = T2.QUOCTICHID AND T5.GROUPID = 2 --QUỐC TỊCH
                            LEFT JOIN DM_DATAITEM T6 ON T6.ID = T2.DANTOCID AND T6.GROUPID = 1 --DÂN TỘC
                            LEFT JOIN DM_HANHCHINH T7 ON T7.ID = T2.TAMTRU_HUYEN -- Huyện
                            LEFT JOIN DM_HANHCHINH T8 ON T8.ID = T2.TAMTRU -- Tỉnh
                        WHERE T2.VUANID = ITEM.v_VUANID 
                        ORDER BY T2.BICANDAUVU DESC, T2.ID)
        LOOP
            VV_HOTENBICAO_2 := VV_HOTENBICAO_2 || ITEMS.VV_BICAO;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_HOTENBICAO_2 := VV_HOTENBICAO_2;
        VV_HOTENBICAO_2 := '';

        -- Cột 3 - v_THOIHANTAMGIAM_3 - THỜI HẠN TẠM GIAM -- (Nguyên nhân vi phạm nếu có)
        -- (Trường hợp thay đổi biện pháp ngăn chặn thì phải ghi vào cột này)
        FOR ITEMS IN (SELECT T2.HOTEN, TRUNC(T3.NGAYKETTHUC - T3.NGAYBATDAU) THTG_BP, TRUNC(T4.HIEULUCDEN - T4.HIEULUCTU) THTG_QD
                      FROM AHS_BICANBICAO T2    
                          LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN T3 ON T3.BICANID = T2.ID --AND (VV_NGAYTHULY < T3.NGAYBATDAU AND T3.NGAYBATDAU IS NOT NULL)
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN T4 ON T4.BICANID = T2.ID AND T4.LOAIQDID = 121-- AND (VV_NGAYTHULY < T4.NGAYQD AND T4.NGAYQD IS NOT NULL)
                      WHERE T2.VUANID = ITEM.v_VUANID
                      ORDER BY T2.BICANDAUVU DESC, T2.ID)
        LOOP
            IF(ITEMS.THTG_QD IS NOT NULL AND ITEMS.THTG_QD > 0) THEN
                VV_THOIHANTAMGIAM_3 := VV_THOIHANTAMGIAM_3 || '- ' || ITEMS.HOTEN ||' '|| ITEMS.THTG_QD ||' ngày;'|| CHR(10);
            ELSIF(ITEMS.THTG_BP IS NOT NULL AND ITEMS.THTG_BP > 0) THEN
                VV_THOIHANTAMGIAM_3 := VV_THOIHANTAMGIAM_3 || '- ' || ITEMS.HOTEN ||' '|| ITEMS.THTG_BP ||' ngày;'|| CHR(10);
            END IF;

        END LOOP;

        v_ARRAY(ITEM.v_STT).v_THOIHANTAMGIAM_3:=VV_THOIHANTAMGIAM_3;
        VV_THOIHANTAMGIAM_3 := '';

        -- Cột 4 - v_CAOTRANG_4 - CÁO TRẠNG  -- Số, ngày, tháng, năm -- Điều luật, Tội danh, hình phạt theo đề nghị của Kiểm sát viên tại phiên tòa
        FOR ITEMS IN (SELECT T3.CAOTRANG || '; ' || CHR(10) AS VV_CAOTRANG
                        FROM AHS_BICANBICAO T2
                            INNER JOIN (SELECT CT.BICANID, LISTAGG( '- Điều ' || T4.DIEU || ': ' || T4.TENTOIDANH, ', ') WITHIN GROUP (ORDER BY CT.ID) AS CAOTRANG
                                        FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CT
                                            INNER JOIN DM_BOLUAT_TOIDANH T4 ON T4.ID = CT.TOIDANHID AND T4.LUATID = CT.DIEULUATID
                                        WHERE CT.ISMAIN = 1
                                        GROUP BY CT.BICANID
                                        ) T3 ON T3.BICANID = T2.ID
                        WHERE T2.VUANID = ITEM.v_VUANID
                        ORDER BY T2.BICANDAUVU DESC, T2.ID)
        LOOP
            VV_CAOTRANG_4 := VV_CAOTRANG_4 || ITEMS.VV_CAOTRANG;
		END LOOP;

        SELECT DECODE(VA.SOBANCAOTRANG,NULL,'',' Số '|| VA.SOBANCAOTRANG || ' ') || DECODE(VA.NGAYBANCAOTRANG,NULL,'','ngày '|| TO_CHAR(VA.NGAYBANCAOTRANG,'DD/MM/YYYY') || ' ') INTO VV_BANCAOTRANG
        FROM AHS_VUAN VA
        WHERE VA.ID = ITEM.v_VUANID;

        IF(VV_BANCAOTRANG IS NULL OR VV_BANCAOTRANG LIKE '') THEN
            v_ARRAY(ITEM.v_STT).v_CAOTRANG_4:=VV_CAOTRANG_4;
        ELSE
            v_ARRAY(ITEM.v_STT).v_CAOTRANG_4:=  '- ' || VV_BANCAOTRANG || ';' || CHR(10) ||VV_CAOTRANG_4;
        END IF;
        VV_CAOTRANG_4 := '';

        -- Cột 5 - v_NGUOITHAMGIATOTUNG_5 - NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Họ tên, năm sinh, nơi cư trú, giới tính
        FOR ITEMS IN (SELECT ('- '||T2.HOTEN || '; ' 
                              ||case when T2.NAMSINH = 0 then ' ' else ' ' 
                              || T2.NAMSINH ||'; ' end 
                              || DECODE(T2.DIACHICHITIET,NULL,'','','',T2.DIACHICHITIET || '; ')
                              || DECODE(T2.GIOITINH,0,' Giới tính: Nữ;',1,' Giới tính: Nam;', '')) AS VV_NGUOITHAMGIATOTUNG
                      FROM AHS_NGUOITHAMGIATOTUNG T2
                          INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                          INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_01,TGTTHS_03,TGTTHS_04,TGTTHS_05,TGTTHS_08',T4.MA)>0
                      WHERE T2.VUANID = ITEM.v_VUANID) --AND T2.ISHOSO = 1 ) --AND T2.ISSOTHAM = 1 
                      --Vì người dùng không nhập NGƯỜI THAM GIA TỐ TỤNG sơ thẩm nên hệ thông không lấy ra VÀ PHẢI LẤY CỦA GIAI ĐOẠN HỒ SƠ
        LOOP
            VV_NGUOITHAMGIATOTUNG_5 := VV_NGUOITHAMGIATOTUNG_5 || ITEMS.VV_NGUOITHAMGIATOTUNG;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_NGUOITHAMGIATOTUNG_5:=VV_NGUOITHAMGIATOTUNG_5;
        VV_NGUOITHAMGIATOTUNG_5 := '';

        -- Cột 6 - v_NGUOIBC_NGUOIBV_QLIHP_DS_6 - NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ  -- Họ tên, địa chỉ hoặc đơn vị hành nghề
        FOR ITEMS IN (SELECT ('- '|| T2.HOTEN || '; ' 
                                  || DECODE(T2.DIACHICHITIET,NULL,'','','',T2.DIACHICHITIET || '; ') 
                                  || DECODE(T2.TEN_VPLS,NULL,'','','',T2.TEN_VPLS || '; ') || CHR(10)) AS VV_NGUOIBC_NGUOIBV_QLIHP_DS
                      FROM AHS_NGUOITHAMGIATOTUNG T2
                          INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                          INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_02,TGTTHS_06,TGTTHS_09,TGTTHS_10,TGTTHS_17',T4.MA)>0
                      WHERE T2.VUANID = ITEM.v_VUANID)-- AND T2.ISHOSO = 1 --AND T2.ISSOTHAM = 1 --Vì người dùng không nhập NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ tham gia sơ thẩm nên hệ thông không lấy ra VÀ PHẢI LẤY CỦA GIAI ĐOẠN HỒ SƠ
        LOOP
            VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 || ITEMS.VV_NGUOIBC_NGUOIBV_QLIHP_DS;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_NGUOIBC_NGUOIBV_QLIHP_DS_6:=VV_NGUOIBC_NGUOIBV_QLIHP_DS_6;
        VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := '';

        -- Cột 7 - v_GQ_CHUYENHS_VA_13 - GIẢI QUYẾT - CHUYỂN HỒ SƠ VỤ ÁN -- Số, ngày, tháng, năm
        -- Cột 7 - “Chuyển hồ sơ vụ án” tạm thời ko lấy dữ liệu vì cần trao đổi lại với phòng tổng hợp, vì đối với án HS thì ko chuyển hồ sơ cho toà án khác khi ko thuộc thẩm quyển mà phải trả hồ sơ cho VKS theo điều 274 BLTTHS

        -- Cột 8 - v_GQ_TDC_11 - GIẢI QUYẾT - TẠM ĐÌNH CHỈ -- Số, ngày, tháng, năm
        FOR ITEMS IN (SELECT T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) AS v_GQ_TDC
                      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
                         INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL)
                      ORDER BY T2.NGAYQD)
        LOOP
            VV_GQ_TDC_8 := VV_GQ_TDC_8 || ITEMS.v_GQ_TDC;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_GQ_TDC_11:=VV_GQ_TDC_8;
        VV_GQ_TDC_8 := '';

        -- Cột 9 - v_GQ_TRAHOSOCHOVKS_7 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Số, ngày, tháng, năm
        FOR ITEMS IN (SELECT T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) AS v_GQ_TRAHOSOCHOVKS
                      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
                         INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TRAHS'
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL)
                      ORDER BY T2.NGAYQD)
        LOOP
            VV_GQ_TRAHOSOCHOVKS_9 := VV_GQ_TRAHOSOCHOVKS_9 || ITEMS.v_GQ_TRAHOSOCHOVKS;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_GQ_TRAHOSOCHOVKS_7:=VV_GQ_TRAHOSOCHOVKS_9;
        VV_GQ_TRAHOSOCHOVKS_9 := '';

        -- Cột 10 - v_GQ_TRAHOSOCHOVKS_8 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Kết quả trả hồ sơ
        FOR ITEMS IN (SELECT '- ' || DECODE(T2.TRUONGHOPTHULY, 233, 'Chấp nhận', 234, 'Không chấp nhận', '') || CHR(10) AS v_GQ_TRAHOSOCHOVKS
                      FROM AHS_SOTHAM_THULY T2
                         INNER JOIN DM_DATAITEM T3 on T3.ID=T2.TRUONGHOPTHULY
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYTHULY AND T2.NGAYTHULY IS NOT NULL) )
        LOOP
            VV_GQ_TRAHOSOCHOVKS_10 := VV_GQ_TRAHOSOCHOVKS_10 || ITEMS.v_GQ_TRAHOSOCHOVKS;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_GQ_TRAHOSOCHOVKS_8:=VV_GQ_TRAHOSOCHOVKS_10;
        VV_GQ_TRAHOSOCHOVKS_10 := '';

        -- Cột 11 - v_GQ_DC_12 - GIẢI QUYẾT - ĐÌNH CHỈ  -- Số, ngày, tháng, năm
        FOR ITEMS IN (SELECT T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) AS V_GQ_DC
                      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
                         INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL)
                      ORDER BY T2.NGAYQD)
        LOOP
            VV_GQ_DC_11 := VV_GQ_DC_11 || ITEMS.V_GQ_DC;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_GQ_DC_12:=VV_GQ_DC_11;
        VV_GQ_DC_11 := '';

        -- Cột 12 - v_GQ_TAPHUCHOIVA_14 - GIẢI QUYẾT - TÒA ÁN PHỤC HỒI VỤ ÁN  -- Số, ngày, tháng, năm     
        FOR ITEMS IN (SELECT T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) AS v_GQ_TAPHUCHOIVA
                      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
                          INNER JOIN DM_QD_QUYETDINH T3 ON T3.ID = T2.QUYETDINHID AND TEN LIKE '%phục hồi%'
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL)
                      ORDER BY T2.NGAYQD)
        LOOP
            VV_GQ_TAPHUCHOIVA_12 := VV_GQ_TAPHUCHOIVA_12 || ITEMS.v_GQ_TAPHUCHOIVA;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_GQ_TAPHUCHOIVA_14 := VV_GQ_TAPHUCHOIVA_12;
        VV_GQ_TAPHUCHOIVA_12 := '';

        -- Cột 13 - v_GQ_LYDO_15 - GIẢI QUYẾT - LÝ DO
        -- hiện tại chỉ có lý do của qd đình chỉ, nếu sau này bổ sung thêm được lý do của các giải quyết khác thì hãy làm để order theo ngày giải quyết
        FOR ITEMS IN (SELECT T4.TEN || CHR(10) AS v_GQ_LYDO
                      FROM AHS_SOTHAM_QUYETDINH_VUAN T2
                          INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
                          INNER JOIN DM_QD_QUYETDINH_LYDO T4 ON T4.ID = T2.LYDOID
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL)
                      ORDER BY T2.NGAYQD)
        LOOP
            VV_GQ_LYDO_13 := VV_GQ_LYDO_13 || ITEMS.V_GQ_LYDO;
        END LOOP; 

        v_ARRAY(ITEM.v_STT).v_GQ_LYDO_15 := VV_GQ_LYDO_13;
        VV_GQ_LYDO_13 := '';

        -- Cột 14 - v_XX_NGUOITIENHANHTOTUNG_16 - XÉT XỬ - NGƯỜI TIẾN HÀNH TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên
        FOR ITEMS IN (SELECT '- ' || NVL(T3.HOTEN,'')||NVL(T4.HOTEN,'')|| ' ('||DECODE(T2.MAVAITRO,'HTND','HTND','KSV','KSV','THAMPHAN','TPCT','THAMPHANDUKHUYET','TPDK','THAMPHANHDXX','TPTV','THUKY','TK','THUKYDUKHUYET','TKDK','')||')' || CHR(10)  v_XX_NGUOITIENHANHTOTUNG
                      FROM AHS_SOTHAM_HDXX T2
                          LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('HTND,THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
                          LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('KSV',T2.MAVAITRO)>0
                      WHERE T2.VUANID = ITEM.v_VUANID AND (VV_NGAYTHULY <= T2.NGAYQD AND T2.NGAYQD IS NOT NULL) -- Kiểm sát viên k bắt nhập ngày phân công
                      ) 
        LOOP
            VV_XX_NGUOITIENHANHTOTUNG_14 := VV_XX_NGUOITIENHANHTOTUNG_14 || ITEMS.v_XX_NGUOITIENHANHTOTUNG;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_XX_NGUOITIENHANHTOTUNG_16 := VV_XX_NGUOITIENHANHTOTUNG_14;
        VV_XX_NGUOITIENHANHTOTUNG_14 := '';

    END LOOP;

    -- Cột 15 - v_XX_TAYCVKS_BXTLCC_17 - XÉT XỬ - TÒA ÁN YÊU CẦU VKS BỔ SUNG TÀI LIỆU, CHỨNG CỨ -- Số, ngày, tháng, năm
    -- Cột 15 - QLTA không có chỗ nhập số và ngày TÒA ÁN YÊU CẦU VKS BỔ SUNG TÀI LIỆU, CHỨNG CỨ

    -- Cột 16 - v_XX_BA_QDST_18 - XÉT XỬ - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM  -- Số, ngày, tháng, năm
    -- Trường hợp có qđ gây kết thúc và bản án có lôi cả 2 ra không?
    FOR ITEM IN (SELECT T1.v_STT, 
                LISTAGG( cast( T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') || CHR(10) as varchar2(4000)) , CHR(10) ) WITHIN GROUP (ORDER BY T1.v_STT) ||
                LISTAGG( cast( T3.SOQUYETDINH || CHR(10) || TO_CHAR(T3.NGAYQD,'DD/MM/YYYY') || CHR(10) as varchar2(4000)) , CHR(10) ) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_BA_QDST
        FROM TABLE(v_ARRAY) T1 
            LEFT JOIN (SELECT BA.VUANID, BA.SOBANAN, BA.NGAYBANAN, T3.TEN 
                       FROM AHS_SOTHAM_BANAN BA 
                           INNER JOIN DM_TOAAN T3 on T3.ID=BA.TOAANID
                       WHERE BA.NGAYBANAN >= VV_NGAYTHULY) T2 ON T1.v_VUANID=T2.VUANID
            LEFT JOIN (SELECT QD.VUANID, QD.SOQUYETDINH, QD.NGAYQD, T3.TEN 
                       FROM AHS_SOTHAM_QUYETDINH_VUAN QD 
                           INNER JOIN DM_TOAAN T3 ON T3.ID = QD.DONVIID 
                           INNER JOIN DM_QD_QUYETDINH T4 ON T4.ID = QD.QUYETDINHID AND T4.KET_THUC = 1 AND T4.TEN NOT LIKE '%Quyết định trả hồ sơ để điều tra bổ sung%'
                       WHERE QD.NGAYQD >= VV_NGAYTHULY AND QD.NGAYQD IS NOT NULL)  T3 ON T3.VUANID = T1.v_VUANID
        GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_XX_BA_QDST_18:=ITEM.v_XX_BA_QDST;
    END LOOP;

    -- Cột 17 - v_XX_QDCUABA_QDST_19 - XÉT XỬ - QUYẾT ĐỊNH CỦA BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM -- Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung -- Miễn trách nhiệm hình sự, miễn hình phạt, giáo dục tại trường giáo dưỡng (nếu có)           
    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1  GROUP BY T1.v_STT, T1.v_VUANID )
    LOOP

        BEGIN
            SELECT 1 INTO CHECK_NUMBER
            FROM AHS_SOTHAM_BANAN BA
            WHERE BA.VUANID = ITEM.v_VUANID AND BA.NGAYBANAN >= VV_NGAYTHULY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECK_NUMBER := 0;
        END;

        IF(CHECK_NUMBER > 0) THEN

            SELECT ID INTO VV_BANANID
            FROM AHS_SOTHAM_BANAN BA
            WHERE BA.VUANID = ITEM.v_VUANID AND BA.NGAYBANAN >= VV_NGAYTHULY;

            FOR ITEMS IN (SELECT T2.ID FROM AHS_BICANBICAO T2 WHERE T2.VUANID = ITEM.v_VUANID ORDER BY T2.BICANDAUVU DESC, T2.ID)
            LOOP
                FOR ITEMTOIDANH IN (SELECT DECODE(T4.DIEU, NULL, '', '- Điều: ' ||T4.DIEU || ': ' || T4.TENTOIDANH || '; ') AS TOIDANH
                                    FROM AHS_SOTHAM_BANAN_DIEU_CHITIET T3
                                         INNER JOIN DM_BOLUAT_TOIDANH T4 ON T4.ID = T3.TOIDANHID AND T4.HIEULUC = 1 AND T4.LOAI = 2
                                    WHERE T3.BICANID = ITEMS.ID AND T3.ISMAIN = 1 AND T3.BANANID = VV_BANANID)
                LOOP
                    TEXT_TOIDANH := TEXT_TOIDANH || ITEMTOIDANH.TOIDANH;
                END LOOP;

                CHECK_NUMBER := 0;

                SELECT COUNT(T7.ID) INTO CHECK_NUMBER
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET T8
                    LEFT JOIN DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID
                WHERE T8.BICANID = ITEMS.ID AND T8.BANANID = VV_BANANID;

                IF(CHECK_NUMBER > 0) THEN

                    SELECT count('x') INTO HINHPHATID
                    FROM AHS_SOTHAM_BANAN_DIEU_CHITIET T8
                    WHERE T8.BICANID = ITEMS.ID AND T8.HINHPHATID IN (5,6,8) AND T8.BANANID = VV_BANANID ;

                    IF(HINHPHATID > 0) THEN
                            PKG_GSTP_SOTHULY_HINHSU.AHS_TONGHOPHINHPHAT_ST(0,ITEMS.ID,V_CURSOR);
                            LOOP FETCH V_CURSOR INTO HINHPHAT;
                            EXIT WHEN V_CURSOR%NOTFOUND;
                            END LOOP;
                            CLOSE V_CURSOR;
                        ELSE
                            SELECT LISTAGG( CAST(T7.TENHINHPHAT AS VARCHAR2(4000)) , '; ' ) WITHIN GROUP (ORDER BY T8.ID) INTO HINHPHAT
                            FROM AHS_SOTHAM_BANAN_DIEU_CHITIET T8
                                LEFT JOIN DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID
                            WHERE T8.BICANID = ITEMS.ID AND T8.BANANID = VV_BANANID;
                    END IF;

                END IF;

                TEXT_REPORT := TEXT_REPORT || TEXT_TOIDANH || HINHPHAT || CHR(10);
                TEXT_TOIDANH := '';
                HINHPHAT := '';

            END LOOP;

            v_ARRAY(ITEM.v_STT).v_XX_QDCUABA_QDST_19:= TEXT_REPORT;
            TEXT_REPORT := '';

        END IF;     
    END LOOP;

    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1 GROUP BY T1.v_STT, T1.v_VUANID) 
    LOOP

        -- Cột 18 - [V_PTNTBICAO_TREMOCOI_24] - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ LÀ NGƯỜI DƯỚI 18 TUỔI ĐÃ XÉT XỬ (Ghi rõ: mồ côi cha hoặc mẹ; bố mẹ ly hôn; bỏ học; lang thang; có người đủ 18 tuổi trở lên xúi giục).
        FOR ITEMS IN (SELECT  '- ' || T2.HOTEN || ': ' as V_HOTEN,
                                decode(T2.TREMOCOI,1,'Trẻ mồ côi cha hoặc mẹ;','') 
                              ||decode(T2.BOMELYHON,1,'Bố mẹ ly hôn;','')
                              ||decode(T2.TREBOHOC,1,'Trẻ bỏ học;','')
                              ||decode(T2.TRELANGTHANG,1,'Trẻ lang thang;','')
                              ||decode(T2.CONGUOIXUIGIUC,1,'Có người đủ 18 tuổi trở lên xúi giục;','')
                              || CHR(10) AS V_PTNTBICAO_DUOI18TUOI,
                              T2.ISTREVITHANHNIEN AS ISTREVITHANHNIEN
                        FROM AHS_BICANBICAO T2
                        WHERE T2.VUANID = ITEM.v_VUANID
                        ORDER BY T2.BICANDAUVU DESC, T2.ID)
        LOOP
            IF(ITEMS.ISTREVITHANHNIEN = 1) THEN
                VV_PTNTBICAO_TREMOCOI_18 := VV_PTNTBICAO_TREMOCOI_18 || ITEMS.V_HOTEN || ITEMS.V_PTNTBICAO_DUOI18TUOI;
            END IF;
        END LOOP;
        v_ARRAY(ITEM.v_STT).V_PTNTBICAO_TREMOCOI_24:= VV_PTNTBICAO_TREMOCOI_18;
        VV_PTNTBICAO_TREMOCOI_18 := '';

        -- Cột 19-20-21 hiện chưa có trường nhập 

        -- Cột 22 - v_KC_31 - KHÁNG CÁO -- Ngày, tháng, năm
        FOR ITEMS IN (SELECT (TO_CHAR(NGAYKHANGCAO,'DD/MM/YYYY') ||  '; ' || CHR(10)) AS VV_KC
                      FROM AHS_SOTHAM_KHANGCAO T2
                      WHERE T2.VUANID = ITEM.v_VUANID AND T2.NGAYKHANGCAO >= VV_NGAYTHULY AND T2.NGAYKHANGCAO IS NOT NULL)
        LOOP
            VV_KC_22 := VV_KC_22 || ITEMS.VV_KC;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_KC_31:=VV_KC_22;
        VV_KC_22 := '';

        -- Cột 23 - v_KN_32 - KHÁNG NGHỊ  -- Số, ngày, tháng, năm
        FOR ITEMS IN (SELECT T2.SOKN || CHR(10) || TO_CHAR(T2.NGAYKN,'DD/MM/YYYY') || '; ' || CHR(10) AS VV_KN
                      FROM AHS_SOTHAM_KHANGNGHI T2
                      WHERE T2.VUANID = ITEM.v_VUANID AND T2.NGAYKN >= VV_NGAYTHULY AND T2.NGAYKN IS NOT NULL)
        LOOP
            VV_KN_23 := VV_KN_23 || ITEMS.VV_KN;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_KN_32 := VV_KN_23;
        VV_KN_23 := '';    


    END LOOP;    

    -- Cột 24 - v_CHUYENHS_TA_PT_33 - CHUYỂN HỒ SƠ CHO TÒA PHÚC THẨM -- Ngày, tháng, năm
    FOR ITEM IN (SELECT T1.v_STT, LISTAGG(TO_CHAR(T2.NGAYGIAO,'DD/MM/YYYY'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT)  v_CHUYENHS_TA_PT_33
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_CHUYEN_NHAN_AN T2 ON T1.v_VUANID=T2.VUANID AND T2.TOACHUYENID = T1.v_TOAANID AND T2.TRUONGHOPGIAONHANID IN (267,268,269) AND T2.NGAYGIAO >= VV_NGAYTHULY
                 GROUP BY T1.v_STT) 
    LOOP
        v_ARRAY(ITEM.v_STT).v_CHUYENHS_TA_PT_33:=ITEM.v_CHUYENHS_TA_PT_33;
    END LOOP;

    -- Cột 25 - v_QD_TA_PT_34 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM -- Số, ngày, tháng, năm -- Tóm tắt phần quyết định    
    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1  GROUP BY T1.v_STT, T1.v_VUANID )
    LOOP

        BEGIN
            SELECT 1 INTO CHECK_NUMBER
            FROM AHS_PHUCTHAM_BANAN BA
            WHERE EXISTS (SELECT 1 FROM DM_KETQUA_PHUCTHAM KQPT WHERE KQPT.ID = BA.KETQUAPHUCTHAMID)
                          AND BA.VUANID = ITEM.v_VUANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECK_NUMBER := 0;
        END;

        IF(CHECK_NUMBER > 0) THEN

            SELECT  BA.SOBANAN || CHR(10) || to_char(BA.NGAYBANAN,'dd/MM/yyyy')  || CHR(10) || KQPT.TEN || ';' || CHR(10) INTO TEXT_REPORT
            FROM AHS_PHUCTHAM_BANAN BA
                INNER JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
            WHERE BA.VUANID = ITEM.v_VUANID;

        ELSE
            BEGIN
                SELECT 1 INTO CHECK_NUMBER
                FROM DUAL 
                WHERE EXISTS (SELECT NULL
                              FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                  INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.id = QUYETDINHID AND DMQD.KET_THUC = 1
                                  LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = QD.KETQUAID AND KQPT.ID in (101,102,103)
                              WHERE QD.VUANID = ITEM.v_VUANID);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN CHECK_NUMBER := 0;
            END;

            IF(CHECK_NUMBER > 0) THEN
                SELECT QD.SOQUYETDINH || CHR(10) || to_char(QD.NGAYQD,'dd/MM/yyyy')  || CHR(10) ||
                       DECODE(COALESCE(KQPT.TEN,DMQD.TEN),NULL,';',COALESCE(KQPT.TEN,DMQD.TEN)) || ';' || CHR(10) INTO TEXT_REPORT
                FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                    INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.id = QUYETDINHID AND DMQD.KET_THUC = 1
                    LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = QD.KETQUAID AND KQPT.ID in (101,102,103)
                WHERE QD.VUANID = ITEM.v_VUANID;
            END IF;
        END IF;          

    v_ARRAY(ITEM.v_STT).v_QD_TA_PT_34:= TEXT_REPORT;
    TEXT_REPORT := '';

    END LOOP;

    -- Cột 26 - v_GHICHU_36 - GHI CHÚ - Vụ án xét xử có áp dụng án lệ (Số án lệ đã áp dụng), tổ chức phiên tòa rút kn, án lưu động, án điểm, ... (nếu có) 
    -- Hiện tại đang chỉ lấy án lưu động
    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1 GROUP BY T1.v_STT, T1.v_VUANID) 
    LOOP        
        FOR ITEMS IN (SELECT DECODE(T2.ISXXLUUDONG,1,'Án lưu động;','') AS v_GHICHU
                      FROM AHS_SOTHAM_BANAN T2
                      WHERE T2.VUANID = ITEM.v_VUANID AND T2.NGAYBANAN >= VV_NGAYTHULY)
        LOOP
            VV_GHICHU_26 := VV_GHICHU_26 || ITEMS.v_GHICHU;
        END LOOP;
        v_ARRAY(ITEM.v_STT).v_GHICHU_36:= VV_GHICHU_26;
        VV_GHICHU_26 := '';    

    END LOOP; 

END FILL_HINHSU_SOTHAM;

PROCEDURE SO_HINHSU_SOTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_SOTHAM;
		v_IDS T_ID;
	BEGIN
		--
		--TÒA ÁN CẤP CON
		v_IDS:=T_ID();
		IF (in_TOAANCAPCON='TRUE') THEN
			SELECT R_ID(ID) BULK COLLECT INTO v_IDS FROM DM_TOAAN WHERE CAPCHAID=in_TOAANID;
		END IF;
		v_IDS.EXTEND();
		v_IDS(v_IDS.COUNT):=R_ID(in_TOAANID);
		--
		--XAC DINH ID THU LY AN THEO THAM SO
		SELECT R_HINHSU_SOTHAM(
			v_STT=>row_number() over (order by nvl(TL.ID,0)),
			v_THULYID=>nvl(TL.ID,0),
			v_VUANID=>nvl(TL.VUANID,0),
			v_TOAANID=>nvl(T2.TOAANID,0),
			v_TL_1=>NULL,
			v_HOTENBICAO_2=>NULL,
			v_THOIHANTAMGIAM_3=>NULL,
			v_CAOTRANG_4=>NULL,
			v_NGUOITHAMGIATOTUNG_5=>NULL,
			v_NGUOIBC_NGUOIBV_QLIHP_DS_6=>NULL,
			v_GQ_TRAHOSOCHOVKS_7=>NULL,
			v_GQ_TRAHOSOCHOVKS_8=>NULL,
			v_GQ_TA_XMTT_BSCC_9=>NULL,
			v_GQ_TA_DENGHI_BPBAOVE_10=>NULL,
			v_GQ_TDC_11=>NULL,
			v_GQ_DC_12=>NULL,
			v_GQ_CHUYENHS_VA_13=>NULL,
			v_GQ_TAPHUCHOIVA_14=>NULL,
			v_GQ_LYDO_15=>NULL,
			v_XX_NGUOITIENHANHTOTUNG_16=>NULL,
			v_XX_TAYCVKS_BXTLCC_17=>NULL,
			v_XX_BA_QDST_18=>NULL,
			v_XX_QDCUABA_QDST_19=>NULL,
			v_XX_KHOITOVATAIPHIENTOA_20=>NULL,
			v_XX_THIETHAI_21=>NULL,
			v_XX_ANLQDENBAOLUCGD_22=>NULL,
			v_XX_AD_ALD_ARG_23=>NULL,
			v_PTNTBICAO_Tremocoi_24=>NULL,
			v_PTNTBICAO_Bomelyhon_25=>NULL,
			v_PTNTBICAO_Trebohoc_26=>NULL,
			v_PTNTBICAO_Trelangthang_27=>NULL,
			v_PTNTBICAO_Coxuigiuc_28=>NULL,
			v_PTNTBIHAI_Tttl16tuoi_29=>NULL,
			v_PTNTBIHAI_Tttl18tuoi_30=>NULL,
			v_KC_31=>NULL,
			v_KN_32=>NULL,
			v_CHUYENHS_TA_PT_33=>NULL,
			v_QD_TA_PT_34=>NULL,
			v_APDUNGANLE_35=>NULL,
			v_GHICHU_36=>NULL,
            V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM 
			AHS_SOTHAM_THULY TL 
			INNER JOIN AHS_VUAN T2 ON T2.ID=TL.VUANID-->CHÚ Ý TRƯỜNG HỢP CHUYỂN ÁN
			INNER JOIN TABLE(v_IDS) I ON I.v_ID=T2.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')
		GROUP BY
			TL.ID,TL.VUANID,T2.TOAANID;
           --ORDER BY TL.NGAYTHULY ;
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY_HINHSU.FILL_HINHSU_SOTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR 
                SELECT * 
                FROM TABLE(v_ARRAY) 
                ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	/*17 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ PHÚC THẨM*/
PROCEDURE FILL_HINHSU_PHUCTHAM
(
    v_ARRAY IN OUT T_HINHSU_PHUCTHAM
) AS
    VV_HOTENBICAO_3 CLOB;       VV_HOTEN_5 CLOB;    VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 CLOB;
    VV_KC_7 CLOB;               VV_KN_8 CLOB;       VV_APDUNGANLE_21 CLOB;

    VV_XX_QD_BA_PT_15 CLOB;
    TOIDANH CLOB DEFAULT ''; HINHPHAT CLOB DEFAULT ''; CHECK_NUMBER NUMBER; HINHPHATID NUMBER;
    V_CURSOR sys_refcursor; 
    TEXT_REPORT CLOB DEFAULT ''; TEXT_TOIDANH CLOB DEFAULT '';
BEGIN	
    --v_ARRAY:=T_HINHSU_PHUCTHAM();
    -- v_TL_1 - THỤ LÝ HỒ SƠ Số, ngày tháng năm - 1
    FOR ITEM IN (SELECT T1.v_STT, T2.SOTHULY|| CHR(10) ||TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1
                 FROM TABLE(v_ARRAY) T1 
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID) 
    LOOP
        v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
    END LOOP;
    --V_NGAYTHULY
    FOR ITEM IN (SELECT T1.v_STT, T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
                 FROM TABLE(v_ARRAY) T1 
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID)
    LOOP
        v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;
        v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
    END LOOP;

    -- v_BA_QDST_2 - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM -- Số, ngày, tháng, năm  -- Tòa án cấp sơ thẩm đã giải quyết - 2
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG( cast( T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') || CHR(10) || T2.TEN as varchar2(4000)) , CHR(10) ) WITHIN GROUP (ORDER BY T1.v_STT) ||
                        LISTAGG( cast( T3.SOQUYETDINH || CHR(10) || TO_CHAR(T3.NGAYQD,'DD/MM/YYYY') || CHR(10) || T3.TEN as varchar2(4000)) , CHR(10) ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDST_2
                FROM TABLE(v_ARRAY) T1 
                    LEFT JOIN (SELECT BA.VUANID, BA.SOBANAN, BA.NGAYBANAN, T3.TEN FROM AHS_SOTHAM_BANAN BA inner join DM_TOAAN T3 on T3.ID=BA.TOAANID) T2 ON T1.v_VUANID=T2.VUANID
                    LEFT JOIN (SELECT QD.VUANID, QD.SOQUYETDINH, QD.NGAYQD, T3.TEN FROM AHS_SOTHAM_QUYETDINH_VUAN QD INNER JOIN DM_TOAAN T3 ON T3.ID = QD.DONVIID INNER JOIN DM_QD_QUYETDINH T4 ON T4.ID = QD.QUYETDINHID AND T4.KET_THUC = 1)  T3 ON T3.VUANID = T1.v_VUANID
                GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_BA_QDST_2:=ITEM.v_BA_QDST_2;
    END LOOP;



    -- v_THOIHANTAMGIAM_4 - THỜI HẠN TẠM GIAM -- (Nguyên nhân vi phạm nếu có) - 4
    FOR ITEM IN (SELECT T1.v_STT,
                        LISTAGG(cast('- '||T2.HOTEN||' '||CAST(T3.HIEULUCDEN-T3.HIEULUCTU as varchar(50))||' ngày;' as varchar2(4000)), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_THOIHANTAMGIAM_4
                FROM TABLE(v_ARRAY) T1
                    INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_BICAN T3 ON T3.BICANID=T2.ID
                    INNER JOIN DM_QD_LOAI T4 on T3.LOAIQDID=T4.ID and T4.MA='BTG'
                WHERE T3.HIEULUCDEN-T3.HIEULUCTU>0
                GROUP BY T1.v_STT) 
    LOOP
        v_ARRAY(ITEM.v_STT).v_THOIHANTAMGIAM_4:=ITEM.v_THOIHANTAMGIAM_4;
    END LOOP;

    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1 GROUP BY T1.v_STT, T1.v_VUANID) 
    LOOP

        -- v_HOTENBICAO_3 - HỌ TÊN BỊ CÁO Năm sinh, nơi cư trú, nghề nghiệp - 3  
        FOR ITEMS IN (SELECT ('- ' || T2.HOTEN || '; ' || DECODE(T2.NAMSINH,0,' ',T2.NAMSINH ||'; ')
                              || DECODE(NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET),'','',NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET)||'; ')
                              || DECODE(NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET),'','', 'Nơi cư trú: ' || NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET)||'; ')
                              || DECODE(T4.TEN,'','',T4.TEN ||'; ')|| CHR(10) ) AS VV_HOTENBICAO
            FROM AHS_BICANBICAO T2
                LEFT JOIN DM_DATAITEM T4 ON T4.ID = T2.NGHENGHIEPID AND T4.GROUPID=22--NGHỀ NGHIỆP 
            WHERE T2.VUANID = ITEM.v_VUANID
            ORDER BY T2.BICANDAUVU DESC, T2.ID
            )
        LOOP
            VV_HOTENBICAO_3 := VV_HOTENBICAO_3 || ITEMS.VV_HOTENBICAO;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_HOTENBICAO_3:=VV_HOTENBICAO_3;
        VV_HOTENBICAO_3 := '';

        -- v_HOTEN_5 - HỌ TÊN --  NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Năm sinh, nơi cư trú - 5       
        FOR ITEMS IN (SELECT ('- '||T2.HOTEN || '; ' ||case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||nvl2(T2.DIACHICHITIET,'',T2.DIACHICHITIET || '; ')) AS VV_HOTEN
            FROM AHS_NGUOITHAMGIATOTUNG T2
                INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_01,TGTTHS_03,TGTTHS_04,TGTTHS_05,TGTTHS_08',T4.MA)>0
            WHERE T2.VUANID = ITEM.v_VUANID --AND T2.ISPHUCTHAM=1
            )
        LOOP
            VV_HOTEN_5 := VV_HOTEN_5 || ITEMS.VV_HOTEN;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_HOTEN_5:=VV_HOTEN_5;
        VV_HOTEN_5 := '';

        -- v_NGUOIBC_NGUOIBV_QLIHP_DS_6 - NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ  -- Họ tên, địa chỉ hoặc đơn vị hành nghề - 6           
        FOR ITEMS IN (SELECT ('- '||T2.HOTEN || '; ' ||nvl2(T2.DIACHICHITIET,T2.DIACHICHITIET || '; ','') ) AS VV_NGUOIBC_NGUOIBV_QLIHP_DS
            FROM AHS_NGUOITHAMGIATOTUNG T2
                INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_06,TGTTHS_10',T4.MA)>0
            WHERE T2.VUANID = ITEM.v_VUANID --AND T2.ISPHUCTHAM=1
            )
        LOOP
            VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 || ITEMS.VV_NGUOIBC_NGUOIBV_QLIHP_DS;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_NGUOIBC_NGUOIBV_QLIHP_DS_6:=VV_NGUOIBC_NGUOIBV_QLIHP_DS_6;
        VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := '';

        -- v_KC_7 - KHÁNG CÁO -- Người kháng cáo; ngày, tháng, năm và nội dung kháng cáo - 7       
        FOR ITEMS IN (SELECT ('- ' || DECODE(T2.NGUOIKCLOAI,0,T5.HOTEN,1,T4.HOTEN,' ') || ' ' || TO_CHAR(NGAYKHANGCAO,'DD/MM/YYYY')|| ' ' || YC.YEUCAU || '; ') AS VV_KC
            FROM AHS_SOTHAM_KHANGCAO T2
                LEFT JOIN (SELECT T5.ID ,T5.HOTEN FROM AHS_BICANBICAO T5) T5 ON T2.NGUOIKCID = T5.ID 
                LEFT JOIN (SELECT T4.ID ,T4.HOTEN FROM AHS_NGUOITHAMGIATOTUNG T4) T4 ON T2.NGUOIKCID=T4.ID
                LEFT JOIN (SELECT T5.KHANGCAOID, LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGCAOID) YEUCAU
                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                            INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                            GROUP BY T5.KHANGCAOID) YC ON YC.KHANGCAOID=T2.ID
            WHERE T2.VUANID = ITEM.v_VUANID
            )
        LOOP
            VV_KC_7 := VV_KC_7 || ITEMS.VV_KC;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_KC_7:=VV_KC_7;
        VV_KC_7 := '';

        -- v_KN_8 - KHÁNG NGHỊ -- Số, ngày, tháng, năm và nội dung kháng nghị - 8
        FOR ITEMS IN (SELECT ('- ' || TO_CHAR(NGAYKN,'DD/MM/YYYY') || ' '|| YC.YEUCAU || '; ') AS VV_KN
            FROM AHS_SOTHAM_KHANGNGHI T2
                LEFT JOIN (SELECT T5.KHANGNGHIID, LISTAGG(T6.TEN || '; ') WITHIN GROUP (ORDER BY T5.KHANGNGHIID) YEUCAU
                           FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                INNER JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                           GROUP BY T5.KHANGNGHIID) YC ON YC.KHANGNGHIID=T2.ID

            WHERE T2.VUANID = ITEM.v_VUANID
            )
        LOOP
            VV_KN_8 := VV_KN_8 || ITEMS.VV_KN;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_KN_8:=VV_KN_8;
        VV_KN_8 := '';

    END LOOP;

    -- v_TDC_9 - TẠM ĐÌNH CHỈ -- Số, ngày, tháng, năm;  -- Lý do - 9
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG(cast(T2.SOQUYETDINH || CHR(10) ||TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) || T4.TEN as varchar2(4000)), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_TDC_9
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
                     INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
                     INNER JOIN DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID
                 GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_TDC_9:=ITEM.v_TDC_9;
    END LOOP;
    -- v_QD_DC_RUT_KC_10 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - RÚT KHÁNG CÁO  -- Ngày, tháng, năm -- (Xác định việc rút kháng cáo trước khi mở phiên tòa hay tại phiên tòa) - 10
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG(T2.SOQUYETDINH || CHR(10) ||TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) || decode(T4.MA,'RUT_KC_TRUOC_MOPT','Rút kháng cáo trước khi mở phiên tòa','Rút kháng cáo tại phiên tòa'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_RUT_KC_10
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
                     inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
                     inner join DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and instr('RUT_KC_TAI_PHIENTOA,RUT_KC_TRUOC_MOPT',T4.MA)>0
                GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_QD_DC_RUT_KC_10:=ITEM.v_QD_DC_RUT_KC_10;
    END LOOP;
    -- v_QD_DC_RUT_KN_11 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - RÚT KHÁNG NGHỊ  -- Ngày, tháng, năm -- (Xác định việc rút kháng cáo trước khi mở phiên tòa hay tại phiên tòa) - 11
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG(T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) || decode(T4.MA,'RUT_KN_TRUOC_MOPT','Rút kháng nghị trước khi mở phiên tòa','Rút kháng nghị tại phiên tòa'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_RUT_KN_11
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
                     INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
                     INNER JOIN DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and instr('RUT_KN_TAI_PHIENTOA,RUT_KN_TRUOC_MOPT',T4.MA)>0
                GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_QD_DC_RUT_KN_11:=ITEM.v_QD_DC_RUT_KN_11;
    END LOOP;
    -- v_QD_DC_LYDOKHAC_12 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - LÝ DO KHÁC -- Ngày, tháng, năm - 12
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG(TO_CHAR(T2.NGAYQD,'DD/MM/YYYY'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_LYDOKHAC_12
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
                     INNER JOIN DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
                     INNER JOIN DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and T4.MA='KHAC'
                 GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_QD_DC_LYDOKHAC_12:=ITEM.v_QD_DC_LYDOKHAC_12;
    END LOOP;
    -- v_XX_NGUOITIENHANHTOTUNG_13 - XÉT XỬ - NHỮNG NGƯỜI TIẾN HÀNH --  TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên - 13
    FOR ITEM IN (SELECT T1.v_STT, 
                        LISTAGG(CAST('- ' || NVL(T3.HOTEN,'')||NVL(T4.HOTEN,'') || ' ('||DECODE(T2.MAVAITRO,'HTND','HTND','KSV','KSV','THAMPHAN','TPCT','THAMPHANDUKHUYET','TPDK','THAMPHANHDXX','TPTV','THUKY','TK','THUKYDUKHUYET','TKDK','')||')' AS VARCHAR2(4000)), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_NGUOITIENHANHTOTUNG_13
                 FROM TABLE(v_ARRAY) T1
                    INNER JOIN AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
                    LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('HTND,THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
                    LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('KSV',T2.MAVAITRO)>0
                 GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_XX_NGUOITIENHANHTOTUNG_13:=ITEM.v_XX_NGUOITIENHANHTOTUNG_13;
    END LOOP;

    -- v_XX_BA_PT_14 - XÉT XỬ - BẢN ÁN PHÚC THẨM  -- Số, ngày, tháng, năm - 14
    FOR ITEM IN(SELECT T1.v_STT, LISTAGG( T2.SOBANAN || CHR(10) || to_char(T2.NGAYBANAN,'dd/MM/yyyy')) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_BA_PT_14
                FROM TABLE(v_ARRAY) T1
                    INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
                GROUP BY T1.v_STT) 
    LOOP
        v_ARRAY(ITEM.v_STT).v_XX_BA_PT_14:=ITEM.v_XX_BA_PT_14;
    END LOOP;

    -- v_XX_QD_BA_PT_15 - XÉT XỬ - QUYẾT ĐỊNH CỦA BẢN ÁN PHÚC THẨM -- Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung - 15
     FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID FROM TABLE(v_ARRAY) T1  GROUP BY T1.v_STT, T1.v_VUANID )
     LOOP

        BEGIN
            SELECT 1 INTO CHECK_NUMBER
            FROM AHS_PHUCTHAM_BANAN BA
            WHERE EXISTS (SELECT 1 FROM DM_KETQUA_PHUCTHAM KQPT WHERE KQPT.ID = BA.KETQUAPHUCTHAMID)
                          AND BA.VUANID = ITEM.v_VUANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECK_NUMBER := 0;
        END;

        IF(CHECK_NUMBER > 0) THEN

            SELECT KQPT.TEN || ';' || CHR(10) INTO TEXT_REPORT
            FROM AHS_PHUCTHAM_BANAN BA
                INNER JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
            WHERE BA.VUANID = ITEM.v_VUANID; -- DM_KETQUA_PHUCTHAM

            ELSE
                BEGIN
                    SELECT 1 INTO CHECK_NUMBER
                    FROM DUAL 
                    WHERE EXISTS (SELECT NULL
                                  FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                      INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.id = QUYETDINHID AND DMQD.KET_THUC = 1
                                      LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = QD.KETQUAID AND KQPT.ID in (101,102,103)
                                  WHERE QD.VUANID = ITEM.v_VUANID);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN CHECK_NUMBER := 0;
                END;

                IF(CHECK_NUMBER > 0) THEN
                    SELECT DECODE(COALESCE(KQPT.TEN,DMQD.TEN),NULL,';',COALESCE(KQPT.TEN,DMQD.TEN)) || ';' || CHR(10) INTO TEXT_REPORT
                    FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                        INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.id = QUYETDINHID AND DMQD.KET_THUC = 1
                        LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = QD.KETQUAID AND KQPT.ID in (101,102,103)
                    WHERE QD.VUANID = ITEM.v_VUANID;
                END IF;
        END IF;           

        IF(UPPER(TEXT_REPORT) LIKE '%SỬA%') THEN
            -- vòng lặp lấy bị cáo
            FOR ITEMS IN (SELECT T2.ID FROM AHS_BICANBICAO T2 WHERE T2.VUANID = ITEM.v_VUANID ORDER BY T2.BICANDAUVU DESC, T2.ID)
            LOOP
                FOR ITEMTOIDANH IN (SELECT DECODE(T4.DIEU, NULL, '', T4.DIEU || ': ' || T4.TENTOIDANH || '; ') AS TOIDANH
                                    FROM AHS_PHUCTHAM_BANAN_DIEU_CT T3
                                         INNER JOIN DM_BOLUAT_TOIDANH T4 ON T4.ID = T3.TOIDANHID AND T4.HIEULUC = 1 AND T4.LOAI = 2
                                    WHERE T3.BICANID = ITEMS.ID AND T3.ISMAIN = 1)
                LOOP
                    TEXT_TOIDANH := TEXT_TOIDANH || ITEMTOIDANH.TOIDANH;
                END LOOP;

                CHECK_NUMBER := 0;

                SELECT COUNT(T7.ID) INTO CHECK_NUMBER
                FROM AHS_PHUCTHAM_BANAN_DIEU_CT T8
                    LEFT JOIN DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID
                WHERE T8.BICANID = ITEMS.ID;

                IF(CHECK_NUMBER > 0) THEN

                    SELECT count('x') INTO HINHPHATID
                    FROM AHS_PHUCTHAM_BANAN_DIEU_CT T8
                    WHERE T8.BICANID = ITEMS.ID AND T8.HINHPHATID IN (5,6,8) ;

                    IF(HINHPHATID > 0) THEN
                            PKG_GSTP_SOTHULY_HINHSU.AHS_TONGHOPHINHPHAT_PT(0,ITEMS.ID,V_CURSOR);
                            LOOP FETCH V_CURSOR INTO HINHPHAT;
                            EXIT WHEN V_CURSOR%NOTFOUND;
                            END LOOP;
                            CLOSE V_CURSOR;
                        ELSE
                            SELECT LISTAGG( CAST(T7.TENHINHPHAT AS VARCHAR2(4000)) , '; ' ) WITHIN GROUP (ORDER BY T8.ID) INTO HINHPHAT
                            FROM AHS_PHUCTHAM_BANAN_DIEU_CT T8
                                LEFT JOIN DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID
                            WHERE T8.BICANID = ITEMS.ID;
                    END IF;

                END IF;

                TEXT_REPORT := TEXT_REPORT || TEXT_TOIDANH || HINHPHAT || CHR(10);
                TEXT_TOIDANH := '';
                HINHPHAT := '';

            END LOOP;
        END IF;
        v_ARRAY(ITEM.v_STT).v_XX_QD_BA_PT_15:= VV_XX_QD_BA_PT_15 || TEXT_REPORT;
        VV_XX_QD_BA_PT_15 := '';
        TEXT_REPORT := '';
     END LOOP;

    -- v_XX_LYDO_SH_STSAI_16 - XÉT XỬ - LÝ DO SỬA, HỦY - Do cấp sơ thẩm sai - 16
    FOR ITEM IN (SELECT T1.v_STT, DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_XX_LYDO_SH_STSAI_16
                 FROM TABLE(v_ARRAY) T1 
                     INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
                     INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISAHS=1 --SỬA,HỦY
                     INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do cấp sơ thẩm sai',lower(T4.TEN))>0 --Do cấp sơ thẩm sai
                 GROUP BY T1.v_STT) 
    LOOP
        v_ARRAY(ITEM.v_STT).v_XX_LYDO_SH_STSAI_16:=ITEM.v_XX_LYDO_SH_STSAI_16;
    END LOOP;

    -- v_XX_LYDO_SH_TTM_17 - XÉT XỬ - LÝ DO SỬA, HỦY - Do có tình tiết mới - 17
    FOR ITEM IN (SELECT T1.v_STT, DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_XX_LYDO_SH_TTM_17
                 FROM TABLE(v_ARRAY) T1 
                    INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
                    INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISAHS=1 --SỬA,HỦY
                    INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do có tình tiết mới',lower(T4.TEN))>0 --Do có tình tiết mới
                 GROUP BY T1.v_STT)
    LOOP
        v_ARRAY(ITEM.v_STT).v_XX_LYDO_SH_TTM_17:=ITEM.v_XX_LYDO_SH_TTM_17;
    END LOOP;

    -- v_XX_SOBCTACHAPNHANKN_VKS_18 - XÉT XỬ - SỐ BỊ CÁO TÒA ÁN CHẤP NHẬN KHÁNG NGHỊ CỦA VIỆN KIỂM SÁT - 18
    for item in(select T1.v_STT, replace(to_char(T2.SBC_CHAPNHAN_TOANBO,'999,999,999,999,999,999'),',','.') v_XX_SOBCTACHAPNHANKN_VKS_18
                from TABLE(v_ARRAY) T1
                    inner join AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID)
    loop
        v_ARRAY(ITEM.v_STT).v_XX_SOBCTACHAPNHANKN_VKS_18:=ITEM.v_XX_SOBCTACHAPNHANKN_VKS_18;
    end loop;

    -- v_XX_KHOITOVATAIPHIENTOA_19 - XÉT XỬ - KHỞI TỐ VỤ ÁN TẠI PHIÊN TÒA -- Số, ngày, tháng, năm - 19
    --		for item in(
    --      select 
    --        T1.v_STT,
    --        LISTAGG(
    --          T2.SOBANAN || CHR(10) ||
    --          to_char(T2.NGAYBANAN,'dd/MM/yyyy')
    --          ) within group (order by T1.v_STT) v_XX_KHOITOVATAIPHIENTOA_19
    --      from TABLE(v_ARRAY) T1
    --      inner join AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
    --      GROUP BY T1.v_STT
    --    ) loop
    --    v_ARRAY(ITEM.v_STT).v_XX_KHOITOVATAIPHIENTOA_19:=ITEM.v_XX_KHOITOVATAIPHIENTOA_19;
    --    end loop;

    -- v_QD_GDTTT_20 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày, tháng, năm - 20

    -- v_APDUNGANLE_21 - ÁP DỤNG ÁN LỆ  -- Số án lệ - 21
    FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
                 FROM TABLE(v_ARRAY) T1 
                 GROUP BY T1.v_STT, T1.v_VUANID) 
    LOOP
        FOR ITEMS IN (SELECT ('- ') AS VV_APDUNGANLE
                      FROM AHS_PHUCTHAM_BANAN T2
                      WHERE T2.VUANID = ITEM.v_VUANID AND T2.ISANLE = 1)
        LOOP
            VV_APDUNGANLE_21 := VV_APDUNGANLE_21 || ITEMS.VV_APDUNGANLE;
        END LOOP;

        v_ARRAY(ITEM.v_STT).v_APDUNGANLE_21:=VV_APDUNGANLE_21;
        VV_APDUNGANLE_21 := '';
    END LOOP;
    -- v_GHICHU_22 - GHI CHÚ - 22
END;

PROCEDURE SO_HINHSU_PHUCTHAM
(
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
) AS
    v_ARRAY T_HINHSU_PHUCTHAM;
    v_IDS T_ID;
BEGIN
    --
    --TÒA ÁN CẤP CON
    v_IDS:=T_ID();
    IF (in_TOAANCAPCON='TRUE') THEN
        SELECT R_ID(ID) BULK COLLECT INTO v_IDS FROM DM_TOAAN WHERE CAPCHAID=in_TOAANID;
    END IF;
    v_IDS.EXTEND();
    v_IDS(v_IDS.COUNT):=R_ID(in_TOAANID);
    --
    --XAC DINH ID THU LY AN THEO THAM SO
    SELECT R_HINHSU_PHUCTHAM(
        v_STT=>row_number() over (order by TL.ID),
        v_THULYID=>TL.ID,
        v_VUANID=>TL.VUANID,
        v_TOAANID=>TL.TOAANID,
        v_TL_1=>NULL,
        v_BA_QDST_2=>NULL,
        v_HOTENBICAO_3=>NULL,
        v_THOIHANTAMGIAM_4=>NULL,
        v_HOTEN_5=>NULL,
        v_NGUOIBC_NGUOIBV_QLIHP_DS_6=>NULL,
        v_KC_7=>NULL,
        v_KN_8=>NULL,
        v_TDC_9=>NULL,
        v_QD_DC_RUT_KC_10=>NULL,
        v_QD_DC_RUT_KN_11=>NULL,
        v_QD_DC_LYDOKHAC_12=>NULL,
        v_XX_NGUOITIENHANHTOTUNG_13=>NULL,
        v_XX_BA_PT_14=>NULL,
        v_XX_QD_BA_PT_15=>NULL,
        v_XX_LYDO_SH_STSAI_16=>NULL,
        v_XX_LYDO_SH_TTM_17=>NULL,
        v_XX_SOBCTACHAPNHANKN_VKS_18=>NULL,
        v_XX_KHOITOVATAIPHIENTOA_19=>NULL,
        v_QD_GDTTT_20=>NULL,
        v_APDUNGANLE_21=>NULL,
        v_GHICHU_22=>NULL,
        V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
    )
    BULK COLLECT INTO v_ARRAY
    FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
    WHERE
        NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');

    --
    --THONG TIN SO THU LY
    PKG_GSTP_SOTHULY_HINHSU.FILL_HINHSU_PHUCTHAM(v_ARRAY);
    /*--
    FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
        DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
    END LOOP;
    --*/
    OPEN curReturn FOR 
            SELECT * 
            FROM TABLE(v_ARRAY) 
            ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
    --
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
END;

PROCEDURE AHS_Y_AN_SO_THAM
(
    VBICANID NUMBER,
    curReturn OUT sys_refcursor
)
AS
    COUNT_AHS NUMBER DEFAULT 0; -- KIỂM TRA XEM CÓ Y ÁN SƠ THẨM KO
    COUNT_AHS2 NUMBER DEFAULT 0; -- KIỂM TRA XEM CÓ HÌNH PHẠT KO
    COUNT_AHS_EXP NUMBER DEFAULT 0; -- KẾT QUẢ CỦA SO SÁNH
BEGIN

SELECT SUM(A) INTO COUNT_AHS
FROM (SELECT COUNT(*) A
        FROM (SELECT  HINHPHATID,BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY,K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT 
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO
MINUS
              SELECT HINHPHATID, BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                      ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO)
      UNION ALL
      SELECT COUNT(*)
        FROM (SELECT  HINHPHATID,BICANID, LOAIHINHPHAT,TF_VALUE, SH_VALUE,SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO
MINUS
              SELECT HINHPHATID, BICANID, LOAIHINHPHAT, TF_VALUE, SH_VALUE, SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, K_VALUE1, K_VALUE2,
                      ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
              FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT 
              WHERE CT.BICANID = VBICANID
              GROUP BY  BICANID, HINHPHATID,LOAIHINHPHAT,TF_VALUE, SH_VALUE,K_VALUE1, K_VALUE2,ISANTREO));

    IF (COUNT_AHS = 0) THEN
        SELECT COUNT(*) INTO COUNT_AHS2
        FROM AHS_PHUCTHAM_BANAN_DIEU_CT ct
        WHERE HINHPHATID IS NOT NULL AND HINHPHATID <> 0 AND LOAIHINHPHAT IS NOT NULL AND LOAIHINHPHAT <> 0 AND ISMAIN <> 1
              AND  exists (SELECT TENTOIDANH
                                 FROM DM_BOLUAT_TOIDANH BL 
                                 WHERE DIEM IS NULL 
                                 AND KHOAN IS NULL and ct.TENTOIDANH = BL.TENTOIDANH) 
              AND BICANID = VBICANID;
    END IF;

    IF(COUNT_AHS = 0 and COUNT_AHS2 = 0) then COUNT_AHS_EXP := 0;
        elsif(COUNT_AHS > 0 and COUNT_AHS2 = 0) then COUNT_AHS_EXP := -2;
        else COUNT_AHS_EXP := -1;
        end if;


    OPEN curReturn FOR 
        SELECT COUNT_AHS_EXP FROM DUAL;  
END AHS_Y_AN_SO_THAM; 

PROCEDURE AHS_TONGHOPHINHPHAT_ST
(
    VVUANID in number,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS
    HP_CHINH VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC 
    HP_BOSUNG VARCHAR(200) DEFAULT ''; -- HÌNH PHẠT BỔ SUNG
    MAHINHPHAT VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- MÃ HÌNH PHẠT DÙNG ĐỂ LOẠI BỎ HÌNH PHẠT TÙ THEO NĂM KHI ĐÃ CÓ TỬ HÌNH HOẶC CHUNG THÂN
    THOIGIANTU VARCHAR(200) DEFAULT ''; -- LƯU THỜI GIAN ĐỂ ĐIỀN SAU KHI LOAI BỎ
    V_RESULT_EXPORT VARCHAR(500) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
    CHECK_TT INT DEFAULT 0; 
    V_QD_DINHCHI_VUAN number DEFAULT 0;
    V_QD_DINHCHI_BC number DEFAULT 0;
    V_QD_TAMDINHCHI_BICAO NUMBER DEFAULT 0;
BEGIN
        SELECT COUNT('x') INTO V_QD_DINHCHI_VUAN
        FROM AHS_SOTHAM_QUYETDINH_VUAN
        INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                    WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
        WHERE VUANID = VVUANID;

        SELECT COUNT('x') INTO V_QD_DINHCHI_BC
        FROM AHS_SOTHAM_QUYETDINH_BICAN
        INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                    WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
        WHERE BICANID = VBICANID;

        SELECT COUNT('x') INTO V_QD_TAMDINHCHI_BICAO
        FROM AHS_SOTHAM_QUYETDINH_BICAN
        INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                    WHERE TEN LIKE '%Quyết định tạm đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
        WHERE BICANID = VBICANID;

        IF(V_QD_DINHCHI_VUAN > 0 OR V_QD_DINHCHI_BC >0 OR V_QD_TAMDINHCHI_BICAO >0) THEN 
                IF(V_QD_TAMDINHCHI_BICAO >0) THEN V_RESULT_EXPORT := 'QĐ tạm đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_BC >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ bị cáo; '; END IF;
                IF(V_QD_DINHCHI_VUAN >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ tạm đình chỉ vụ án; '; END IF;
            ELSE 
                    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                        BICANID, LOAIHINHPHAT,
                                        TF_VALUE, SH_VALUE,
                                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                                        K_VALUE1, K_VALUE2,
                                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                                    UNION ALL
                                                    SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                                WHERE  LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                          LOAIHINHPHAT,
                                          TF_VALUE, SH_VALUE,
                                          K_VALUE1, K_VALUE2,
                                          ISANTREO, DM_HP.TENHINHPHAT)
                    LOOP
                        IF(ITEM.NAM > 30) THEN ITEM.NAM := 30; ITEM.THANG := 0; ITEM.NGAY := 0; END IF;
                        IF(ITEM.NAMT > 30) THEN ITEM.NAMT := 30; ITEM.THANGT := 0; ITEM.NGAYT := 0; END IF;

                        --HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC
                        IF(ITEM.NHOMHINHPHAT = 144 OR ITEM.NHOMHINHPHAT = 146) THEN
                                -- TỬ HÌNH
                                IF(ITEM.HINHPHATID = 8) THEN
                                        MAHINHPHAT := 'TUHINH';
                                    -- CHUNG THÂN
                                    ELSIF (ITEM.HINHPHATID = 6 AND MAHINHPHAT != 'TUHINH') THEN    
                                        MAHINHPHAT := 'TUCHUNGTHAN';
                                    -- TÙ CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 5) THEN
                                        IF (MAHINHPHAT != 'TUHINH' AND MAHINHPHAT != 'TUCHUNGTHAN') THEN
                                            IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NAM || ' năm ';
                                                END IF;
                                            IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.THANG || ' tháng ';
                                                END IF;
                                            IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                                THOIGIANTU := THOIGIANTU || ITEM.NGAY || ' ngày ';
                                                END IF;
                                            IF (ITEM.ISANTREO = 0) THEN
                                                    THOIGIANTU := THOIGIANTU || ' tù giam; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                ELSIF (ITEM.ISANTREO = 1) THEN
                                                    THOIGIANTU := THOIGIANTU || ' án treo; ';
                                                    MAHINHPHAT := 'TUCOTHOIHAN';
                                                END IF;
                                             -- THỬ THÁCH
                                            IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NAMT || ' năm ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.THANGT || ' tháng ';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF (ITEM.NGAYT != 0 AND ITEM.NGAYT IS NOT NULL) THEN
                                                HP_CHINH := HP_CHINH || ITEM.NGAYT || ' ngày';
                                                CHECK_TT := 1;
                                                END IF;
                                            IF(CHECK_TT = 1) THEN
                                                HP_CHINH := 'Thử thách: '|| HP_CHINH || '; ';
                                                END IF;
                                            END IF;

                                    -- PHẠT TIỀN
                                    ELSIF (ITEM.HINHPHATID = 2) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ' || ITEM.SH_VALUE ||' VND; ';

                                    -- CẢI TẠO KHÔNG GIAM GIỮ VÀ ĐÌNH CHỈ HOẠT ĐỘNG CÓ THỜI HẠN
                                    ELSIF (ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || ' ';
                                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NAM || ' năm ';
                                            END IF;
                                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.THANG || ' tháng ';
                                            END IF;
                                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                            HP_CHINH := HP_CHINH || ITEM.NGAY || ' ngày ';
                                            END IF;
                                        HP_CHINH := HP_CHINH || '; ';

                                    -- CÁC HÌNH PHẠT KHÁC
                                    ELSE 
                                        HP_CHINH := HP_CHINH || ITEM.TENHINHPHAT || '; ';
                                    END IF;
                            END IF;
                        -- HÌNH PHẠT BỔ SUNG (CÁC HÌNH PHẠT BỔ SUNG KHÁC)
                        IF(ITEM.NHOMHINHPHAT = 145) THEN
                            IF (ITEM.K_VALUE1 != 0) THEN
                                    HP_BOSUNG := HP_BOSUNG || TO_CHAR(ITEM.K_VALUE1 || '; ');
                                END IF;
                            IF (ITEM.K_VALUE2 IS NOT NULL ) THEN
                                    HP_BOSUNG := HP_BOSUNG || ITEM.K_VALUE2 || '; ';
                                END IF;
                            END IF;
                    END LOOP;

                    -- SO SÁNH HÌNH PHẠT TÙ VÀ TỬ HÌNH, XÁC ĐỊNH ĐỘ ƯU TIÊN
                    IF (MAHINHPHAT = 'TUHINH') THEN
                            V_RESULT_EXPORT := 'Từ hình; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCHUNGTHAN') THEN
                            V_RESULT_EXPORT := 'Tù chung thân; ' || V_RESULT_EXPORT;
                        ELSIF (MAHINHPHAT = 'TUCOTHOIHAN') THEN
                            V_RESULT_EXPORT := THOIGIANTU || V_RESULT_EXPORT;
                        END IF;

                    IF (HP_CHINH IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_CHINH;
                        END IF;
                    IF (HP_BOSUNG IS NOT NULL) THEN
                        V_RESULT_EXPORT := V_RESULT_EXPORT || HP_BOSUNG;
                        END IF;
        END IF;
    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT FROM DUAL;  
END AHS_TONGHOPHINHPHAT_ST;

PROCEDURE AHS_TONGHOPHINHPHAT_PT
(
    VUANID IN NUMBER, 
    VBICAOID IN NUMBER,
    curReturn OUT SYS_REFCURSOR
)
AS  
    CHECK_TH_CT_TG INT DEFAULT 0; -- CHECK STATUS ĐỂ KHÔNG VÀO LẦN 2 AHS_PHUCTHAM_HINHPHAT_TH_CT_TG
    HP_TU VARCHAR(500) DEFAULT '';        

    HP_SOHOC VARCHAR(500) DEFAULT '';    -- HÌNH PHẠT SỐ HỌC (TIỀN, ...)
    HP_THOIGIAN VARCHAR(500) DEFAULT ''; -- HÌNH PHẠT CÓ THỜI GIAN
    HP_KHAC VARCHAR(1000) DEFAULT '';    -- CÁC HÌNH PHẠT CHÍNH KHÁC      
    HP_BOSUNG VARCHAR(200) DEFAULT '';  -- HÌNH PHẠT BỔ SUNG

    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';    -- MÃ HÌNH PHẠT DÙNG ĐỂ LOẠI BỎ HÌNH PHẠT TÙ THEO NĂM KHI ĐÃ CÓ TỬ HÌNH HOẶC CHUNG THÂN
    THOIGIANTU VARCHAR(200) DEFAULT ''; -- LƯU THỜI GIAN ĐỂ ĐIỀN SAU KHI LOAI BỎ
    CHECK_TT INT DEFAULT 0;

    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
    CHECK_Y_AN_SO_THAM NUMBER DEFAULT 0; -- NẾU Y ÁN SƠ THẨM THÌ KHÔNG CẦN LÀM CÁC BƯỚC TIẾP THEO
    CHECK_KETQUAPHUCTHAM NUMBER DEFAULT 0; -- TRUỜNG HỢP GIỮ HOẶC SỬA BẢN ÁN MỚI CHO NHẬP ĐIỀU LUẬT VÀ LẤY THÔNG TIN
    V_CURSOR SYS_REFCURSOR;

    KHANGNGHI NUMBER DEFAULT 0; RUTKHANGNGHI NUMBER DEFAULT 0;
    TGTTKHANGCAO NUMBER DEFAULT 0; TGTTRUTKHANGCAO NUMBER DEFAULT 0; TENRUTKHANGCAO VARCHAR(200) DEFAULT '';
    BCKHANGCAO NUMBER DEFAULT 0; BCRUTKHANGCAO NUMBER DEFAULT 0;

    RUTKHANGCAOKHANGNGHI VARCHAR(200) DEFAULT '';
    VVUANID NUMBER DEFAULT 0;
    V_QD_DINHCHI_VUAN NUMBER DEFAULT 0;
    V_QD_DINHCHI_BICAO NUMBER DEFAULT 0;
    V_QD_TAMDINHCHI_BICAO NUMBER DEFAULT 0;

BEGIN

    --LẤY VỤ ÁN ID
    SELECT DISTINCT VUANID INTO VVUANID FROM AHS_SOTHAM_CAOTRANG_DIEULUAT WHERE BICANID = VBICAOID;

    SELECT COUNT('x') INTO V_QD_DINHCHI_VUAN
    FROM AHS_PHUCTHAM_QUYETDINH_VUAN
    INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
    WHERE VUANID = VVUANID;

    SELECT COUNT('x') INTO V_QD_DINHCHI_BICAO
            FROM AHS_PHUCTHAM_QUYETDINH_BICAN
            INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                        WHERE TEN LIKE '%Quyết định đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
            WHERE BICANID = VBICAOID;

    SELECT COUNT('x') INTO V_QD_TAMDINHCHI_BICAO
            FROM AHS_PHUCTHAM_QUYETDINH_BICAN
            INNER JOIN (SELECT ID,TEN FROM dm_qd_quyetdinh 
                        WHERE TEN LIKE '%Quyết định tạm đình chỉ%') dmqd ON dmqd.id = QUYETDINHID
            WHERE BICANID = VBICAOID;

    IF(V_QD_DINHCHI_VUAN > 0 OR V_QD_DINHCHI_BICAO >0 OR V_QD_TAMDINHCHI_BICAO >0) THEN 
            IF(V_QD_TAMDINHCHI_BICAO >0) THEN V_RESULT_EXPORT := 'QĐ tạm đình chỉ bị cáo; '; END IF;
            IF(V_QD_DINHCHI_BICAO >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ đình chỉ bị cáo; '; END IF;
            IF(V_QD_DINHCHI_VUAN >0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'QĐ tạm đình chỉ vụ án; '; END IF;
        ELSE
                select count('x') into BCKHANGCAO from ahs_bicanbicao bc 
                    inner join (select nguoikcid from ahs_sotham_khangcao) bckc on bckc.nguoikcid = bc.id
                    where vuanid = VVUANID and bckc.nguoikcid = VBICAOID;
                select count('x') into BCRUTKHANGCAO from ahs_bicanbicao bc 
                    inner join (select id,nguoikcid from ahs_sotham_khangcao) bckc on bckc.nguoikcid = bc.id
                    inner join (select khangcaoid from ahs_sotham_rutkhangcao where tinhtrang = 2 and caprutkn = 3) bhrkc on bhrkc.khangcaoid = bckc.id
                    where vuanid = VVUANID and bckc.nguoikcid = VBICAOID;

                select count('x') into TGTTKHANGCAO from ahs_nguoithamgiatotung tgtt 
                    inner join (select nguoikcid from ahs_sotham_khangcao) bhkc on bhkc.nguoikcid = tgtt.id
                    where vuanid = VVUANID;
                select count('x') into TGTTRUTKHANGCAO from ahs_nguoithamgiatotung tgtt 
                    inner join (select id,nguoikcid from ahs_sotham_khangcao) bhkc on bhkc.nguoikcid = tgtt.id
                    inner join (select khangcaoid from ahs_sotham_rutkhangcao where tinhtrang = 2 and caprutkn = 3) bhrkc on bhrkc.khangcaoid = bhkc.id
                    where vuanid = VVUANID;

                if(TGTTRUTKHANGCAO > 0 ) then
                    select listagg(hoten, ', ') within group (order by '') into TENRUTKHANGCAO from ahs_nguoithamgiatotung tgtt
                            inner join (select id,nguoikcid from ahs_sotham_khangcao) bhkc on bhkc.nguoikcid = tgtt.id 
                            inner join (select khangcaoid from ahs_sotham_rutkhangcao where tinhtrang = 2 and caprutkn = 3) bhrkc on bhrkc.khangcaoid = bhkc.id
                    where vuanid = VVUANID;
                end if;
                select count('x') into KHANGNGHI from ahs_sotham_khangnghi where vuanid = vvuanid;
                select count('x') into RUTKHANGNGHI from ahs_sotham_khangnghi kn
                    inner join (select khangnghiid from ahs_sotham_rutkhangnghi where caprutkn = 3 and tinhtrang = 2) rkn on rkn.khangnghiid = kn.id
                    where vuanid = vvuanid;

                --Check trường hợp giữ nguyên hình phạt
                PKG_GSTP_SOTHULY_HINHSU.AHS_Y_AN_SO_THAM(VBICAOID,V_CURSOR); LOOP FETCH V_CURSOR INTO CHECK_Y_AN_SO_THAM; EXIT WHEN V_CURSOR%NOTFOUND; END LOOP; CLOSE V_CURSOR;

                SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM
                FROM AHS_PHUCTHAM_BANAN BA
                    INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE '%Giữ nguyên %') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                WHERE BA.VUANID = VVUANID;

                IF(CHECK_KETQUAPHUCTHAM > 0 ) THEN 
                     IF(BCRUTKHANGCAO > 0 ) THEN
                            V_RESULT_EXPORT := 'Rút k/c;';
                        ELSE
                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Y án sơ thẩm; ';
                        END IF;
                    ELSE   
                        SELECT COUNT(BA.ID) INTO CHECK_KETQUAPHUCTHAM
                        FROM AHS_PHUCTHAM_BANAN BA
                        INNER JOIN (SELECT ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Hủy%') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                        WHERE BA.VUANID = VVUANID;

                        IF(CHECK_KETQUAPHUCTHAM = 1 ) THEN 
                                SELECT TEN INTO V_RESULT_EXPORT
                                FROM AHS_PHUCTHAM_BANAN BA
                                INNER JOIN (SELECT TEN,ID FROM DM_KETQUA_PHUCTHAM WHERE TEN LIKE 'Hủy%') KQPT ON KQPT.ID = BA.KETQUAPHUCTHAMID
                                WHERE BA.VUANID = VVUANID;
                            ELSE
                                IF(BCRUTKHANGCAO > 0) THEN V_RESULT_EXPORT := 'Rút k/c;';
                                    ELSE
                                        IF(CHECK_Y_AN_SO_THAM = 0) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || 'Y án sơ thẩm; ';
                                        ELSIF(CHECK_Y_AN_SO_THAM = -1) THEN V_RESULT_EXPORT := 'Chưa nhập hình phạt'; -- nếu chưa nhập hình phạt
                                        ELSE
                                            FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                                            BICANID, LOAIHINHPHAT,
                                                            TF_VALUE, SH_VALUE,
                                                            SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                                                            K_VALUE1, K_VALUE2,
                                                            ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                                                    FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                                                            INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                                                        UNION ALL
                                                                        SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                                                        )DM_HP ON DM_HP.ID = CT.HINHPHATID
                                                    WHERE    LOAIHINHPHAT > 0 AND CT.BICANID = VBICAOID
                                                    GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                                                              LOAIHINHPHAT,
                                                              TF_VALUE, SH_VALUE,
                                                              K_VALUE1, K_VALUE2,
                                                              ISANTREO, DM_HP.TENHINHPHAT)
                                            LOOP
                                                --HÌNH PHẠT CHÍNH VÀ QUYẾT ĐỊNH KHÁC
                                                IF(ITEM.NHOMHINHPHAT = 144 OR ITEM.NHOMHINHPHAT = 146) THEN
                                                        IF(ITEM.HINHPHATID = 8 OR ITEM.HINHPHATID = 6 OR ITEM.HINHPHATID = 5 OR ITEM.HINHPHATID = 2 OR ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN
                                                            ---------------------- PHÚC THẨM (TỬ HÌNH, TÙ GIAM, ÁN TRAO, THỬ THÁCH) ---------------------------
                                                            IF(CHECK_TH_CT_TG = 0) THEN
                                                               IF (ITEM.HINHPHATID = 6 OR ITEM.HINHPHATID = 8 OR ITEM.HINHPHATID = 5) THEN          
                                                                    PKG_GSTP_SOTHULY_HINHSU.AHS_KQXXPT(VBICAOID,V_CURSOR);
                                                                    LOOP 
                                                                    FETCH V_CURSOR 
                                                                        INTO  HP_TU;
                                                                        EXIT WHEN V_CURSOR%NOTFOUND;
                                                                    END LOOP;    
                                                                    CLOSE V_CURSOR;
                                                                    CHECK_TH_CT_TG := 1; -- ĐỔI STATUS ĐỂ KHÔNG VÀO LẦN 2
                                                                END IF;
                                                            END IF;
                                                            ---------------CẢI TẠO KHÔNG GIAM GIỮ VÀ ĐÌNH CHỈ HOẠT ĐỘNG CÓ THỜI HẠN-------------------------
                                                            IF (ITEM.HINHPHATID = 3 OR ITEM.HINHPHATID = 65) THEN                        
                                                                PKG_GSTP_SOTHULY_HINHSU.AHS_SOSANH_HINHPHAT_THOIGIAN(ITEM.HINHPHATID,VBICAOID,V_CURSOR);
                                                                LOOP 
                                                                FETCH V_CURSOR 
                                                                    INTO  HP_THOIGIAN;
                                                                    EXIT WHEN V_CURSOR%NOTFOUND;
                                                                END LOOP;    
                                                                CLOSE V_CURSOR;
                                                            END IF;
                                                            ----------------PHẠT TIỀN-----------------------------------------------------------------------
                                                            IF (ITEM.HINHPHATID = 2) THEN
                                                                PKG_GSTP_SOTHULY_HINHSU.AHS_SOSANH_HINHPHAT_SOHOC(ITEM.HINHPHATID,VBICAOID,V_CURSOR);
                                                                LOOP 
                                                                FETCH V_CURSOR 
                                                                    INTO  HP_SOHOC;
                                                                    EXIT WHEN V_CURSOR%NOTFOUND;
                                                                END LOOP;    
                                                                CLOSE V_CURSOR;
                                                            END IF;
                                                        -------HÌNH PHẠT KHÁC--------------------------------
                                                            ELSE 
                                                                HP_KHAC := HP_KHAC || ITEM.TENHINHPHAT || '; ';
                                                        END IF;
                                                    ----------------HÌNH PHẠT BỔ SUNG KHÁC----------------------------
                                                    IF(ITEM.NHOMHINHPHAT = 145) THEN
                                                        IF (ITEM.K_VALUE1 != 0) THEN
                                                                HP_BOSUNG := HP_BOSUNG || TO_CHAR(ITEM.K_VALUE1 || '; ');
                                                            END IF;
                                                        IF (ITEM.K_VALUE2 IS NOT NULL ) THEN
                                                                HP_BOSUNG := HP_BOSUNG || ITEM.K_VALUE2 || '; ';
                                                            END IF;
                                                        END IF;
                                                END IF;
                                            END LOOP;

                                            IF (HP_TU IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_TU;    END IF;
                                            IF (HP_THOIGIAN IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_THOIGIAN;    END IF;
                                            IF (HP_SOHOC IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_SOHOC;    END IF;
                                            IF (HP_KHAC IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_KHAC;    END IF;
                                            IF (HP_BOSUNG IS NOT NULL) THEN V_RESULT_EXPORT := V_RESULT_EXPORT || HP_BOSUNG;    END IF;
                                        END IF;
                                    END IF;
                            END IF;
                    END IF;
        END IF;
        OPEN curReturn FOR 
            SELECT V_RESULT_EXPORT FROM DUAL;
END AHS_TONGHOPHINHPHAT_PT;

PROCEDURE AHS_KQXXPT
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS 
    V_CURSOR sys_refcursor;
    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ

    -------------------------------------- SƠ THẨM ---------------------------------------------------   
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN  
    CHECK_TT_ST NUMBER DEFAULT 0;
    NAM   NUMBER DEFAULT 0;  THANG    NUMBER DEFAULT 0;   NGAY   NUMBER DEFAULT 0;   -- TÙ GIAM
    NAMT  NUMBER DEFAULT 0;  THANGT   NUMBER DEFAULT 0;   NGAYT  NUMBER DEFAULT 0;  -- TÙ TREO
    NAMTT NUMBER DEFAULT 0;  THANGTT  NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0; -- THỬ THÁCH
    TUGIAM_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    --------------------------------------------------------------------------------------------------

    -------------------------------------- PHÚC THẨM ---------------------------------------------------   
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE'; -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN  
    CHECK_TT_PT NUMBER DEFAULT 0;
    NAM_PT   NUMBER DEFAULT 0;  THANG_PT    NUMBER DEFAULT 0;   NGAY_PT   NUMBER DEFAULT 0;   -- TÙ GIAM
    NAMT_PT  NUMBER DEFAULT 0;  THANGT_PT   NUMBER DEFAULT 0;   NGAYT_PT  NUMBER DEFAULT 0;  -- TÙ TREO
    NAMTT_PT NUMBER DEFAULT 0;  THANGTT_PT  NUMBER DEFAULT 0;   NGAYTT_PT NUMBER DEFAULT 0; -- THỬ THÁCH
    TUGIAM_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    --------------------------------------------------------------------------------------------------
    THOIHANST NUMBER DEFAULT 0;
    THOIHANPT NUMBER DEFAULT 0;
    CHECK_INTO NUMBER DEFAULT 0;

BEGIN   
        SELECT COUNT(*)INTO CHECK_INTO
        FROM (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT);

        IF (CHECK_INTO > 0 ) THEN
        -------------------------------------- SƠ THẨM ---------------------------------------------------
        PKG_GSTP_SOTHULY_HINHSU.AHS_SOTHAM_HINHPHAT_TH_CT_TG(VBICANID,V_CURSOR);
        LOOP 
        FETCH V_CURSOR 
            INTO   MAHINHPHAT_ST, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, 
                   NAMTT, THANGTT, NGAYTT, TUGIAM_ST, ANTREO_ST, THUTHACH_ST;
            EXIT WHEN V_CURSOR%NOTFOUND;
        END LOOP;    
        CLOSE V_CURSOR;
        --------------------------------------------------------------------------------------------------
        END IF;

        CHECK_INTO := 0;

        SELECT COUNT(*)INTO CHECK_INTO
        FROM (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                            BICANID, LOAIHINHPHAT,
                            TF_VALUE, SH_VALUE,
                            SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                            K_VALUE1, K_VALUE2,
                            ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                    FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                            INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                        UNION ALL
                                        SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 145 AND ID = 44
                                        )DM_HP ON DM_HP.ID = CT.HINHPHATID
                    WHERE    LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                    GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                              LOAIHINHPHAT,
                              TF_VALUE, SH_VALUE,
                              K_VALUE1, K_VALUE2,
                              ISANTREO, DM_HP.TENHINHPHAT);
        IF (CHECK_INTO > 0 ) THEN
        -------------------------------------- PHÚC THẨM -------------------------------------------------  
        PKG_GSTP_SOTHULY_HINHSU.AHS_PHUCTHAM_HINHPHAT_TH_CT_TG(VBICANID,V_CURSOR);
        LOOP 
        FETCH V_CURSOR 
            INTO   MAHINHPHAT_PT, NAM_PT, THANG_PT, NGAY_PT, NAMT_PT, THANGT_PT, NGAYT_PT, 
                   NAMTT_PT, THANGTT_PT, NGAYTT_PT, TUGIAM_PT, ANTREO_PT, THUTHACH_PT;
            EXIT WHEN V_CURSOR%NOTFOUND;
        END LOOP;    
        CLOSE V_CURSOR;
        --------------------------------------------------------------------------------------------------
        END IF;
        ---------------- SO SÁNH HÌNH PHẠT TÙ VÀ TỬ HÌNH, XÁC ĐỊNH ĐỘ ƯU TIÊN ----------------------------
            IF(MAHINHPHAT_PT = 'TUHINH') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  V_RESULT_EXPORT := 'Tử hình; ';                                  END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ tù chung thân lên tử hình; ';   END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ';
                        IF(TUGIAM_ST != 'DEFAULT VALUE')            THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_ST;  END IF;
                        IF(ANTREO_ST != 'DEFAULT VALUE')            THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_ST;  END IF;
                        IF(THUTHACH_ST != 'DEFAULT VALUE')          THEN V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_ST;END IF;
                        V_RESULT_EXPORT := V_RESULT_EXPORT ||' lên tử hình; '; 
                        END IF;
                    IF(MAHINHPHAT_ST = 'DEFAULT VALUE')             THEN  V_RESULT_EXPORT := 'Tử hình; ' || V_RESULT_EXPORT;END IF;
                ELSIF(MAHINHPHAT_PT = 'TUCHUNGTHAN') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  V_RESULT_EXPORT := 'Giảm hình phạt từ tử hình xuống tù chung thân; '; END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  V_RESULT_EXPORT := 'Tù chung thân; ';                                  END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  V_RESULT_EXPORT := 'Tăng hình phạt từ ';
                        IF(TUGIAM_ST != 'DEFAULT VALUE')     THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_ST;     END IF;
                        IF(ANTREO_ST != 'DEFAULT VALUE')     THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_ST;     END IF;
                        IF(THUTHACH_ST != 'DEFAULT VALUE')   THEN 
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_ST;   END IF;
                        V_RESULT_EXPORT := V_RESULT_EXPORT ||' lên tù chung thân; ';
                        END IF;
                    IF(MAHINHPHAT_ST = 'DEFAULT VALUE')             THEN  V_RESULT_EXPORT := 'Tù chung thân; ' || V_RESULT_EXPORT;END IF;
                ELSIF(MAHINHPHAT_PT = 'TUCOTHOIHAN') THEN
                    IF(MAHINHPHAT_ST = 'TUHINH')       THEN  
                        V_RESULT_EXPORT := 'Giảm hình phạt từ tử hình xuống ';
                        IF(TUGIAM_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_PT;               END IF;
                        IF(ANTREO_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_PT;               END IF;
                        IF(THUTHACH_PT != 'DEFAULT VALUE')          THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_PT;             END IF;                  
                        END IF;
                    IF(MAHINHPHAT_ST = 'TUCHUNGTHAN')  THEN  
                        V_RESULT_EXPORT := 'Giảm hình phạt từ tù chung thân xuống ';
                        IF(TUGIAM_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || TUGIAM_PT;               END IF;
                        IF(ANTREO_PT != 'DEFAULT VALUE')            THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || ANTREO_PT;               END IF;
                        IF(THUTHACH_PT != 'DEFAULT VALUE')          THEN  
                            V_RESULT_EXPORT := V_RESULT_EXPORT || ' ' || THUTHACH_PT;             END IF;                  
                        END IF;
                    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN')  THEN  
                            IF(TUGIAM_PT != 'DEFAULT VALUE' AND TUGIAM_ST != 'DEFAULT VALUE') THEN 
                                    THOIHANPT := NAM_PT * 365 + THANG_PT *30 + NGAY_PT;
                                    THOIHANST := NAM * 365 + THANG *30 + NGAY;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || TUGIAM_ST || ' lên ' || TUGIAM_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || TUGIAM_ST || ' xuống ' || TUGIAM_PT || '; ';
                                        END IF;
                                ELSIF(TUGIAM_PT != 'DEFAULT VALUE' AND TUGIAM_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || TUGIAM_PT || '; ';
                            END IF;          
                            IF(ANTREO_PT != 'DEFAULT VALUE' AND ANTREO_ST != 'DEFAULT VALUE') THEN
                                    THOIHANPT := NAMT_PT * 365 + THANGT_PT *30 + NGAYT_PT;
                                    THOIHANST := NAMT * 365 + THANGT *30 + NGAYT;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || ANTREO_ST || ' lên ' || ANTREO_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || ANTREO_ST || ' xuống ' || ANTREO_PT || '; ';
                                        END IF;
                                ELSIF(ANTREO_PT != 'DEFAULT VALUE' AND ANTREO_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || ANTREO_PT || '; ';
                            END IF;                         
                            IF(THUTHACH_PT != 'DEFAULT VALUE' AND THUTHACH_ST != 'DEFAULT VALUE') THEN
                                    THOIHANPT := NAMTT_PT * 365 + THANGTT_PT *30 + NGAYTT_PT;
                                    THOIHANST := NAMTT * 365 + THANGTT *30 + NGAYTT;
                                    IF(THOIHANPT > THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Tăng hình phạt từ ' || THUTHACH_ST || ' lên ' || THUTHACH_PT || '; ';
                                        ELSIF(THOIHANPT < THOIHANST) THEN
                                            V_RESULT_EXPORT := V_RESULT_EXPORT || 'Giảm hình phạt từ ' || THUTHACH_ST || ' xuống ' || THUTHACH_PT || '; ';
                                        END IF;
                                ELSIF(THUTHACH_PT != 'DEFAULT VALUE' AND THUTHACH_ST = 'DEFAULT VALUE') THEN
                                    V_RESULT_EXPORT := V_RESULT_EXPORT || THUTHACH_PT || '; ';
                            END IF;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                        ELSE 
                            IF(TUGIAM_PT != 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || TUGIAM_PT || '; '; END IF;
                            IF(ANTREO_PT NOT LIKE 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || ANTREO_PT || '; '; END IF;
                            IF(THUTHACH_PT NOT LIKE 'DEFAULT VALUE') THEN V_RESULT_EXPORT:= V_RESULT_EXPORT || THUTHACH_PT || '; '; END IF;
                        END IF;
            END IF;
        V_RESULT_EXPORT := REPLACE(V_RESULT_EXPORT, 'DEFAULT VALUE', '');
    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT FROM DUAL;  
END AHS_KQXXPT;

PROCEDURE AHS_SOSANH_HINHPHAT_THOIGIAN
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS    
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';

    NAM_ST NUMBER DEFAULT 0;    THANG_ST NUMBER DEFAULT 0;     NGAY_ST NUMBER DEFAULT 0; 
    NAM_PT NUMBER DEFAULT 0;    THANG_PT NUMBER DEFAULT 0;     NGAY_PT NUMBER DEFAULT 0;

    THOIGIAN_ST VARCHAR(500) DEFAULT '';
    THOIGIAN_PT VARCHAR(500) DEFAULT '';

    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE   NHOMHINHPHAT = 144
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 3)THEN
            IF(ITEM.MAHINHPHAT = 'CAITAOKGG') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                NAM_ST := ITEM.NAM;
                THANG_ST := ITEM.THANG;
                NGAY_ST := ITEM.NGAY;
            END IF; 
        END IF;
        IF(VHINHPHATID = 65)THEN
            IF(ITEM.MAHINHPHAT = 'DCHDCTH') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                NAM_ST := ITEM.NAM;
                THANG_ST := ITEM.THANG;
                NGAY_ST := ITEM.NGAY;
            END IF; 
        END IF;
    END LOOP;    
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144
                                    )DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 3)THEN
            IF(ITEM.MAHINHPHAT = 'CAITAOKGG') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                NAM_PT := ITEM.NAM;
                THANG_PT := ITEM.THANG;
                NGAY_PT := ITEM.NGAY;
            END IF; 
        END IF;
        IF(VHINHPHATID = 65)THEN
            IF(ITEM.MAHINHPHAT = 'DCHDCTH') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                NAM_PT := ITEM.NAM;
                THANG_PT := ITEM.THANG;
                NGAY_PT := ITEM.NGAY;
            END IF; 
        END IF;
    END LOOP;

    IF (NAM_ST > 0)       THEN THOIGIAN_ST := THOIGIAN_ST || NAM_ST || ' năm ';            END IF;
    IF (THANG_ST > 0)     THEN THOIGIAN_ST := THOIGIAN_ST || THANG_ST || ' tháng ';        END IF;
    IF (NGAY_ST > 0)      THEN THOIGIAN_ST := THOIGIAN_ST || NGAY_ST || ' ngày';          END IF;

    IF (NAM_PT > 0)       THEN THOIGIAN_PT := THOIGIAN_PT || NAM_PT || ' năm ';            END IF;
    IF (THANG_PT > 0)     THEN THOIGIAN_PT := THOIGIAN_PT || THANG_PT || ' tháng ';        END IF;
    IF (NGAY_PT > 0)      THEN THOIGIAN_PT := THOIGIAN_PT || NGAY_PT || ' ngày';          END IF;    

    IF(VHINHPHATID = 3)THEN
        IF(MAHINHPHAT_ST = 'CAITAOKGG' AND MAHINHPHAT_PT = 'CAITAOKGG') THEN
            IF(NAM_PT > NAM_ST) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT < NAM_ST) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT = NAM_ST) THEN
                    IF(THANG_PT > THANG_PT) THEN
                            V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT < THANG_PT) THEN
                            V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT = THANG_ST) THEN
                            IF(NGAY_PT > NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Tăng hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT < NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Giảm hình phạt cải tạo không giam giữ từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT = NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Cải tạo không giam giữ ' || THOIGIAN_PT || '';
                            END IF;
                    END IF;
            END IF;
            ELSIF(MAHINHPHAT_ST = 'DEFAULT VALUE' AND MAHINHPHAT_PT = 'CAITAOKGG') THEN
                V_RESULT_EXPORT := 'Cải tạo không giam giữ ' || THOIGIAN_PT || '; ';
        END IF;
    END IF;

    IF(VHINHPHATID = 65)THEN
        IF(MAHINHPHAT_ST = 'DCHDCTH' AND MAHINHPHAT_PT = 'DCHDCTH') THEN
            IF(NAM_PT > NAM_ST) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT < NAM_ST) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                ELSIF(NAM_PT = NAM_ST) THEN
                    IF(THANG_PT > THANG_PT) THEN
                            V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT < THANG_PT) THEN
                            V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                        ELSIF(THANG_PT = THANG_ST) THEN
                            IF(NGAY_PT > NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Tăng hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' lên ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT < NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Giảm hình phạt đình chỉ hoạt động từ ' || THOIGIAN_ST || ' xuống ' || THOIGIAN_PT || '';
                                ELSIF(NGAY_PT = NGAY_ST) THEN
                                    V_RESULT_EXPORT := 'Đình chỉ hoạt động ' || THOIGIAN_PT || '; ';
                            END IF;
                    END IF;
            END IF;
            ELSIF(MAHINHPHAT_ST = 'DEFAULT VALUE' AND MAHINHPHAT_PT = 'DCHDCTH') THEN
                V_RESULT_EXPORT := 'Đình chỉ hoạt động ' || THOIGIAN_PT || '';
        END IF;
    END IF;

    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT
        FROM DUAL;   
END AHS_SOSANH_HINHPHAT_THOIGIAN;

PROCEDURE AHS_SOSANH_HINHPHAT_SOHOC
(
    VHINHPHATID IN NUMBER,
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS  
    MAHINHPHAT_ST VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    MAHINHPHAT_PT VARCHAR(200) DEFAULT 'DEFAULT VALUE';
    SOHOC_ST NUMBER DEFAULT 0;
    SOHOC_PT NUMBER DEFAULT 0;
    V_RESULT_EXPORT VARCHAR(1000) DEFAULT ''; -- BIẾN ĐỂ TRẢ GIÁ TRỊ
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE   NHOMHINHPHAT = 144
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 2)THEN
            IF(ITEM.MAHINHPHAT = 'PHATTIEN') THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                SOHOC_ST := ITEM.SH_VALUE;
            END IF; 
        END IF;
    END LOOP;    
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM    AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144
                                    )DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE     LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                            AND HINHPHATID = VHINHPHATID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(VHINHPHATID = 2)THEN
            IF(ITEM.MAHINHPHAT = 'PHATTIEN') THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                SOHOC_PT := ITEM.SH_VALUE;
            END IF; 
        END IF;
    END LOOP;

    IF(VHINHPHATID = 2)THEN
        IF(MAHINHPHAT_ST = 'PHATTIEN' AND MAHINHPHAT_PT = 'PHATTIEN') THEN
            IF(SOHOC_ST > SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Giảm hình phạt từ ' || SOHOC_ST || ' vnđ xuống ' || SOHOC_PT || ' VND; ';
                ELSIF(SOHOC_ST < SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Tăng hình phạt từ ' || SOHOC_ST || ' vnđ lên ' || SOHOC_PT || ' VND; ';
                ELSIF(SOHOC_ST = 0 AND SOHOC_PT > 0) THEN
                    V_RESULT_EXPORT := 'Phạt tiền: ' || SOHOC_PT || ' vnđ; ';
                ELSIF(SOHOC_ST > 0 AND SOHOC_PT = 0) THEN
                    V_RESULT_EXPORT := '';
                ELSIF(SOHOC_ST = SOHOC_PT) THEN
                    V_RESULT_EXPORT := 'Phạt tiền: ' || SOHOC_PT || ' vnđ; ';
            END IF;
        END IF;
    END IF;

    OPEN curReturn FOR 
        SELECT V_RESULT_EXPORT
        FROM DUAL;   
END AHS_SOSANH_HINHPHAT_SOHOC;

PROCEDURE AHS_SOTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS    
    MAHINHPHAT_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';      -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN
    NAM NUMBER DEFAULT 0;    THANG NUMBER DEFAULT 0;     NGAY NUMBER DEFAULT 0; 
    NAMT NUMBER DEFAULT 0;   THANGT NUMBER DEFAULT 0;    NGAYT NUMBER DEFAULT 0; 
    NAMTT NUMBER DEFAULT 0;  THANGTT NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0;

    TUGIAM_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    ANTREO_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';
    THUTHACH_ST VARCHAR(500) DEFAULT 'DEFAULT VALUE';

    CHECK_TUS_TG NUMBER DEFAULT 0;
    CHECK_TUS_AT NUMBER DEFAULT 0;
    CHECK_TUS_TT NUMBER DEFAULT 0;
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(ITEM.HINHPHATID = 8) THEN
                MAHINHPHAT_ST := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 6 AND MAHINHPHAT_ST NOT LIKE 'TUHINH') THEN
                    MAHINHPHAT_ST := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 5) THEN 
                IF(MAHINHPHAT_ST NOT LIKE 'TUHINH' AND MAHINHPHAT_ST NOT LIKE 'TUCHUNGTHAN') THEN
                    MAHINHPHAT_ST := ITEM.MAHINHPHAT;
                    IF(ITEM.ISANTREO = 1) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAMT := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANGT := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAYT := ITEM.NGAY;
                        END IF;

                        IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                NAMTT := ITEM.NAMT;
                        END IF;
                        IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                THANGTT := ITEM.THANGT;
                        END IF;
                        IF (ITEM.NGAYT != 0) THEN
                            IF(ITEM.NGAYT IS NOT NULL) THEN 
                                NGAYTT := ITEM.NGAYT;
                            END IF;
                        END IF;
                    END IF;                   
                    IF(ITEM.ISANTREO = 0) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAM := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANG := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAY := ITEM.NGAY;
                        END IF;
                    END IF;                    
                END IF;
        END IF;
    END LOOP;

    IF(MAHINHPHAT_ST = 'TUCOTHOIHAN') THEN
    ------------------------------------- GÁN GIÁ TRỊ --------------------------------------------------------
        IF (NAM > 0)       THEN TUGIAM_ST := TUGIAM_ST || NAM || ' năm ';           CHECK_TUS_TG := 1;      END IF;
        IF (THANG > 0)     THEN TUGIAM_ST := TUGIAM_ST || THANG || ' tháng ';       CHECK_TUS_TG := 1;      END IF;
        IF (NGAY > 0)      THEN TUGIAM_ST := TUGIAM_ST || NGAY || ' ngày';          CHECK_TUS_TG := 1;      END IF;

        IF (NAMT > 0)      THEN ANTREO_ST := ANTREO_ST || NAMT || ' năm ';          CHECK_TUS_AT := 1;      END IF;
        IF (THANGT > 0)    THEN ANTREO_ST := ANTREO_ST || THANGT || ' tháng ';      CHECK_TUS_AT := 1;      END IF;
        IF (NGAYT > 0)     THEN ANTREO_ST := ANTREO_ST || NGAYT || ' ngày';         CHECK_TUS_AT := 1;      END IF;

        IF (NAMTT > 0)     THEN THUTHACH_ST := THUTHACH_ST || NAMTT || ' năm ';     CHECK_TUS_TT := 1;      END IF;
        IF (THANGTT > 0)   THEN THUTHACH_ST := THUTHACH_ST || THANGTT || ' tháng '; CHECK_TUS_TT := 1;      END IF;
        IF (NGAYTT > 0)    THEN THUTHACH_ST := THUTHACH_ST || NGAYTT || ' ngày';    CHECK_TUS_TT := 1;      END IF;

        IF (CHECK_TUS_TG = 1)   THEN TUGIAM_ST := TUGIAM_ST || ' tù giam';                                  END IF;        
        IF (CHECK_TUS_AT = 1)   THEN ANTREO_ST := ANTREO_ST || ' án treo';                                  END IF;    
        IF (CHECK_TUS_TT = 1)   THEN THUTHACH_ST := THUTHACH_ST || ' thử thách';                            END IF;
    -----------------------------------------------------------------------------------------------------------
    END IF;

    OPEN curReturn FOR 
        SELECT MAHINHPHAT_ST, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, NAMTT, THANGTT, NGAYTT, TUGIAM_ST, ANTREO_ST, THUTHACH_ST
        FROM DUAL;   
END AHS_SOTHAM_HINHPHAT_TH_CT_TG;

PROCEDURE AHS_PHUCTHAM_HINHPHAT_TH_CT_TG
(
    VBICANID in number,
    curReturn OUT sys_refcursor
)
AS        
    MAHINHPHAT_PT VARCHAR(500) DEFAULT 'DEFAULT VALUE';      -- TỬ HÌNH, TÙ CHUNG THÂN, TÙ GIAM THỜI HẠN
    NAM NUMBER DEFAULT 0;    THANG NUMBER DEFAULT 0;     NGAY NUMBER DEFAULT 0; 
    NAMT NUMBER DEFAULT 0;   THANGT NUMBER DEFAULT 0;    NGAYT NUMBER DEFAULT 0; 
    NAMTT NUMBER DEFAULT 0;  THANGTT NUMBER DEFAULT 0;   NGAYTT NUMBER DEFAULT 0;

    TUGIAM_PT VARCHAR(500) DEFAULT '';
    ANTREO_PT VARCHAR(500) DEFAULT '';
    THUTHACH_PT VARCHAR(500) DEFAULT '';

    CHECK_TUS_TG NUMBER DEFAULT 0;
    CHECK_TUS_AT NUMBER DEFAULT 0;
    CHECK_TUS_TT NUMBER DEFAULT 0;
BEGIN
    FOR ITEM IN (SELECT DM_HP.TENHINHPHAT, NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                        BICANID, LOAIHINHPHAT,
                        TF_VALUE, SH_VALUE,
                        SUM(TG_NAM) NAM, SUM(TG_THANG) THANG, SUM(TG_NGAY) NGAY, 
                        K_VALUE1, K_VALUE2,
                        ISANTREO, SUM(TGTT_NAM) NAMT, SUM(TGTT_THANG) THANGT, SUM(TGTT_NGAY) NGAYT
                FROM AHS_PHUCTHAM_BANAN_DIEU_CT CT
                        INNER JOIN (SELECT ID, TENHINHPHAT, NHOMHINHPHAT, MAHINHPHAT FROM DM_HINHPHAT WHERE NHOMHINHPHAT = 144 OR NHOMHINHPHAT = 146
                                    ) DM_HP ON DM_HP.ID = CT.HINHPHATID
                WHERE LOAIHINHPHAT > 0 AND CT.BICANID = VBICANID
                GROUP BY  BICANID,  NHOMHINHPHAT, HINHPHATID, MAHINHPHAT,
                          LOAIHINHPHAT,
                          TF_VALUE, SH_VALUE,
                          K_VALUE1, K_VALUE2,
                          ISANTREO, DM_HP.TENHINHPHAT)
    LOOP
        IF(ITEM.HINHPHATID = 8) THEN
                MAHINHPHAT_PT := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 6 AND MAHINHPHAT_PT NOT LIKE 'TUHINH') THEN
                    MAHINHPHAT_PT := ITEM.MAHINHPHAT;
            ELSIF(ITEM.HINHPHATID = 5) THEN 
                IF(MAHINHPHAT_PT NOT LIKE 'TUHINH' AND MAHINHPHAT_PT NOT LIKE 'TUCHUNGTHAN') THEN
                    MAHINHPHAT_PT := ITEM.MAHINHPHAT;
                    IF(ITEM.ISANTREO = 1) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAMT := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANGT := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAYT := ITEM.NGAY;
                        END IF;

                        IF (ITEM.NAMT != 0 AND ITEM.NAMT IS NOT NULL) THEN
                                NAMTT := ITEM.NAMT;
                        END IF;
                        IF (ITEM.THANGT != 0 AND ITEM.THANGT IS NOT NULL) THEN
                                THANGTT := ITEM.THANGT;
                        END IF;
                        IF (ITEM.NGAYT != 0) THEN
                            IF(ITEM.NGAYT IS NOT NULL) THEN 
                                NGAYTT := ITEM.NGAYT;
                            END IF;
                        END IF;
                    END IF;                   
                    IF(ITEM.ISANTREO = 0) THEN
                        IF (ITEM.NAM != 0 AND ITEM.NAM IS NOT NULL) THEN
                                NAM := ITEM.NAM;
                        END IF;
                        IF (ITEM.THANG != 0 AND ITEM.THANG IS NOT NULL) THEN
                                THANG := ITEM.THANG;
                        END IF;
                        IF (ITEM.NGAY != 0 AND ITEM.NGAY IS NOT NULL) THEN
                                NGAY := ITEM.NGAY;
                        END IF;
                    END IF;                    
                END IF;
        END IF;
    END LOOP;

    IF(NAM > 30) THEN NAM := 30; THANG := 0; NGAY := 0; END IF;
    IF(NAMT > 30) THEN NAMT := 30; THANGT := 0; NGAYT := 0; END IF;
    IF(NAMTT > 30) THEN NAMTT := 30; THANGTT := 0; NGAYTT := 0; END IF;

    IF(MAHINHPHAT_PT = 'TUCOTHOIHAN') THEN
    ------------------------------------- GÁN GIÁ TRỊ --------------------------------------------------------
        IF (NAM > 0)       THEN TUGIAM_PT := TUGIAM_PT || NAM || ' năm ';    CHECK_TUS_TG := 1;        END IF;
        IF (THANG > 0)     THEN TUGIAM_PT := TUGIAM_PT || THANG || ' tháng ';CHECK_TUS_TG := 1;        END IF;
        IF (NGAY > 0)      THEN TUGIAM_PT := TUGIAM_PT || NGAY || ' ngày';CHECK_TUS_TG := 1;           END IF;

        IF (NAMT > 0)      THEN ANTREO_PT := ANTREO_PT || NAMT || ' năm ';CHECK_TUS_AT := 1;           END IF;
        IF (THANGT > 0)    THEN ANTREO_PT := ANTREO_PT || THANGT || ' tháng ';CHECK_TUS_AT := 1;       END IF;
        IF (NGAYT > 0)     THEN ANTREO_PT := ANTREO_PT || NGAYT || ' ngày';CHECK_TUS_AT := 1;          END IF;

        IF (NAMTT > 0)     THEN THUTHACH_PT := THUTHACH_PT || NAMTT || ' năm ';CHECK_TUS_TT := 1;      END IF;
        IF (THANGTT > 0)   THEN THUTHACH_PT := THUTHACH_PT || THANGTT || ' tháng ';CHECK_TUS_TT := 1;  END IF;
        IF (NGAYTT > 0)    THEN THUTHACH_PT := THUTHACH_PT || NGAYTT || ' ngày';CHECK_TUS_TT := 1;     END IF;

        IF (CHECK_TUS_TG = 1)   THEN TUGIAM_PT := TUGIAM_PT || ' tù giam';           END IF;        
        IF (CHECK_TUS_AT = 1)   THEN ANTREO_PT := ANTREO_PT || ' án treo';           END IF;    
        IF (CHECK_TUS_TT = 1)   THEN THUTHACH_PT := THUTHACH_PT || 'thử thách';    END IF;
    -----------------------------------------------------------------------------------------------------------
    END IF;
    OPEN curReturn FOR 
        SELECT MAHINHPHAT_PT, NAM, THANG, NGAY, NAMT, THANGT, NGAYT, NAMTT, THANGTT, NGAYTT, TUGIAM_PT, ANTREO_PT, THUTHACH_PT
        FROM DUAL;   
END AHS_PHUCTHAM_HINHPHAT_TH_CT_TG;

END PKG_GSTP_SOTHULY_HINHSU;
