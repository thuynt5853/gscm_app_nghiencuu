--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_SOTHULY
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_SOTHULY" AS

	/*1 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC DÂN SỰ PHÚC THẨM*/
    --T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY,T2.SOTHULY V_SOTHULY
	PROCEDURE FILL_DANSU_PHUCTHAM
	(
		v_ARRAY IN OUT T_DANSU_PHUCTHAM
	) AS
	BEGIN	
		--v_ARRAY:=T_DANSU_PHUCTHAM();
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULY|| CHR(10) ||TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QD_TA_ST_2 - BẢN ÁN, QUYẾT ĐỊNH CỦA TOÀ ÁN CẤP SƠ THẨM Số, ngày tháng năm và tên Toà án đã giải quyết - 2 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY')|| CHR(10) || T3.QTENTOA 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY') || CHR(10) || T2.BTENTOA 
                         )
                        v_BA_QD_TA_ST_2
			FROM 
				TABLE(v_ARRAY) T1  
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,DM.TEN BTENTOA 
                                        FROM ADS_SOTHAM_BANAN B 
                                        LEFT JOIN DM_TOAAN DM ON B.TOAANID = DM.ID)T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,DM.TEN QTENTOA
                                        FROM ADS_SOTHAM_QUYETDINH Q
                                        LEFT JOIN DM_TOAAN DM ON Q.TOAANID = DM.ID
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QD_TA_ST_2:=ITEM.v_BA_QD_TA_ST_2;
		END LOOP;
       
		-- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, năm sinh, địa chỉ - 3 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM ADS_DON_DUONGSU 
                    where 
                    --ISPHUCTHAM=1 and 
                    TUCACHTOTUNG_MA ='NGUYENDON' --NGUYÊN ĐƠN
                    )T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
		END LOOP;

		-- v_BD_NLQ_DS_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VIỆC DÂN SỰ Họ tên, năm sinh, địa chỉ - 4 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU ||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQ_DS_4
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM ADS_DON_DUONGSU 
                    where 
                    --ISPHUCTHAM=1 and 
                    TUCACHTOTUNG_MA ='BIDON'
                    ) T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BD_NLQ_DS_4:=ITEM.v_BD_NLQ_DS_4;
		END LOOP;

		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, năm sinh, địa chỉ - 5 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU ||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						decode(T2.LOAIDUONGSU,1,T2.TAMTRUCHITIET,T2.NDD_DIACHICHITIET) 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_DON_DUONGSU T2 ON T1.v_VUANID=T2.DONID AND T2.TUCACHTOTUNG_MA='QUYENNVLQ' --AND T2.ISPHUCTHAM=1 --NGƯỜI CÓ QUYỀN LỢI NGHĨA VỤ LIÊN QUAN
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
		END LOOP;

		-- v_NGUOIBV_QLIHP_DS_6 - HỌ TÊN NGƯỜI BẢO VỆ QUYỀN, LỢI ÍCH HỢP PHÁP CỦA ĐƯƠNG SỰ - 6 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.HKTTCHITIET 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBV_QLIHP_DS_6
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_THAMGIATOTUNG T2 ON T2.TUCACHTGTTID='TGTTDS_07' AND T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIBV_QLIHP_DS_6:=ITEM.v_NGUOIBV_QLIHP_DS_6;
		END LOOP;

		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.TEN v_QHPL_7
                DECODE(D.QUANHEPHAPLUAT_NAME, NULL, D.TEN,D.QUANHEPHAPLUAT_NAME) v_QHPL_7
			FROM 
				TABLE(v_ARRAY) T1 
                INNER JOIN (select d1.id,d1.QUANHEPHAPLUAT_NAME,dm.TEN  
                                    From  ADS_DON d1
                                        left join DM_DATAITEM dm on dm.id = d1.QUANHEPHAPLUATID
                                        ) D ON T1.v_VUANID = D.ID --MANHND
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
		END LOOP;

		-- v_KC_8 - KHÁNG CÁO Ngày tháng năm - 8 -
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_KC_8
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_SOTHAM_KHANGCAO T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KC_8:=ITEM.v_KC_8;
		END LOOP;

		-- v_KN_9 - KHÁNG NGHỊ Số, ngày tháng năm - 9 - 
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOKN||', '||
					TO_CHAR(T2.NGAYKN,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT)  v_KN_9
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_SOTHAM_KHANGNGHI T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KN_9:=ITEM.v_KN_9;
		END LOOP;

		-- v_ADBPKCTT_10 - ÁP DỤNG BIỆN PHÁP KHẨN CẤP TẠM THỜI Số, ngày tháng năm - 10 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_ADBPKCTT_10
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='ADBPTT'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_ADBPKCTT_10:=ITEM.v_ADBPKCTT_10;
		END LOOP;

		-- v_RUT_KC_11 - RÚT KHÁNG CÁO Ngày tháng năm - 11 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KC_11
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=1 --RÚT KHÁNG CÁO
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KC_11:=ITEM.v_RUT_KC_11;
		END LOOP;

		-- v_RUT_KN_12 - RÚT KHÁNG NGHỊ Số, ngày tháng năm - 12 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KN_12
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=2 -- RÚT KHÁNG NGHỊ
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KN_12:=ITEM.v_RUT_KN_12;
		END LOOP;

		-- v_TDC_13 - TẠM ĐÌNH CHỈ Số, ngày tháng năm - 13 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_TDC_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TDC_13:=ITEM.v_TDC_13;
		END LOOP;

		-- v_DC_14 - ĐÌNH CHỈ Số, ngày tháng năm - 14 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_DC_14
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DC_14:=ITEM.v_DC_14;
		END LOOP;

		-- v_LYDO_15 - LÝ DO - 15 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T3.TEN v_LYDO_15
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_QUYETDINH T2 on T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T5 on T2.LOAIQDID=T5.ID
        inner join DM_QD_QUYETDINH_LYDO T3 ON T2.LYDOID=T3.ID and T5.MA='DC'
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_15:=ITEM.v_LYDO_15;
		END LOOP;

		-- v_HDXX_VKS_TKPT_16 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TOÀ -- Ghi đầy đủ họ tên - 16 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || NVL(T5.TenCanBoToaAn,'')||NVL(T5.TenKSV,'')||
						' ('||DECODE(T5.MAVAITRO,'THAMPHAN','TPCT','THAMPHANHDXX', 'TPTV','THAMPHANDUKHUYET', 'TPDK','HTND', 'HTND','THUKY', 'TK','THUKYDUKHUYET', 'TKDK','KSV', 'KSV','')||')' 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_16
			FROM 
				TABLE(v_ARRAY) T1 
				inner join (
        select T2.DONID,T3.HOTEN as TenCanBoToaAn,T4.HOTEN as TenKSV,T2.MAVAITRO from ADS_PHUCTHAM_HDXX T2
				LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
				LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('HTND,KSV',T2.MAVAITRO)>0
        ORDER BY NLSSORT(T2.MAVAITRO, 'NLS_SORT = VIETNAMESE')
        )T5 ON T1.v_VUANID=T5.DONID
      group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_16:=ITEM.v_HDXX_VKS_TKPT_16;
		END LOOP;

		-- v_BA_QDPT_17 - BẢN ÁN, QUYẾT ĐỊNH PHÚC THẨM Số, ngày tháng năm - 17 - 

		FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY') 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY')

                        )
                        v_BA_QDPT_17
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN ADS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                        FROM ADS_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QDPT_17:=ITEM.v_BA_QDPT_17;
		END LOOP;

		-- v_QD_TA_PT_18 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM  -- Tóm tắt phần quyết định - 18 - 
        FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.QTENKQ|| CHR(10)
                    ,T2.BTENKQ|| CHR(10) 
                        )
                        v_QD_TA_PT_18
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,BKQ.TEN BTENKQ 
                                        FROM ADS_PHUCTHAM_BANAN B
                                        LEFT JOIN DM_KETQUA_PHUCTHAM BKQ ON BKQ.ID = B.KETQUAPHUCTHAMID) T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,KQ.TEN QTENKQ 
                                        FROM ADS_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                        LEFT JOIN DM_KETQUA_PHUCTHAM KQ ON KQ.ID = Q.KETQUAID
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_TA_PT_18:=ITEM.v_QD_TA_PT_18;
		END LOOP;

		-- v_LYDO_SH_STSAI_19 - LÝ DO SỬA, HỦY… - Do cấp sơ thẩm sai - 19 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_STSAI_19
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISADS=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do cấp sơ thẩm sai',lower(T4.TEN))>0 --Do cấp sơ thẩm sai
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_STSAI_19:=ITEM.v_LYDO_SH_STSAI_19;
		END LOOP;

		-- v_LYDO_SH_LDK_20 - LÝ DO SỬA, HỦY… - Do có lý do khác - 20 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_LDK_20
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISADS=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do có tình tiết mới,lý do khác',lower(T4.TEN))>0 --Lý do khác
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_LDK_20:=ITEM.v_LYDO_SH_LDK_20;
		END LOOP;

		-- v_APDUNGANLE_21 - ÁP DỤNG ÁN LỆ - 21 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(T2.APDUNGANLE,1,'X','') v_APDUNGANLE_21
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_APDUNGANLE_21:=ITEM.v_APDUNGANLE_21;
		END LOOP;

		-- v_GQVA_TTRG_22 - GIẢI QUYẾT VỤ ÁN THEO THỦ TỤC RÚT GỌN -- Số, ngày tháng năm - 22 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
          T2.SOQD || CHR(10) ||
          TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
          , CHR(10)
        ) within group (order by T1.v_STT)  v_GQVA_TTRG_22
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='80-DS'
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQVA_TTRG_22:=ITEM.v_GQVA_TTRG_22;
		END LOOP;

		-- v_VIECDS_23 - VIỆC DÂN SỰ - 23 -
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(T2.LOAIQUANHE,2,'X','') v_VIECDS_23
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_THULY T2 ON T1.v_VUANID=T2.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_VIECDS_23:=ITEM.v_VIECDS_23;
		END LOOP;
		-- v_QD_GDTTT_24 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM Số, ngày tháng năm - 24 - 

		-- v_GHICHU_25 - GHI CHÚ - 25 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.GHICHU v_GHICHU_25
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ADS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GHICHU_25:=ITEM.v_GHICHU_25;
		END LOOP;
		--
	END;

	/*2 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ ÁN HÀNH CHÍNH SƠ THẨM*/
	

	/*3 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ ÁN HÀNH CHÍNH PHÚC THẨM*/
	PROCEDURE FILL_HANHCHINH_PHUCTHAM
	(
		v_ARRAY IN OUT T_HANHCHINH_PHUCTHAM
	) AS
	BEGIN	
		--v_ARRAY:=T_HANHCHINH_PHUCTHAM();
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
    FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULY|| CHR(10) ||TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDST_2 - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM Số, ngày tháng năm và tên Toà án đã giải quyết - 2 - 
		 --manhnd
        FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY')|| CHR(10) || T3.QTENTOA 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY') || CHR(10) || T2.BTENTOA 
                         )
                        v_BA_QDST_2
			FROM 
				TABLE(v_ARRAY) T1  
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,DM.TEN BTENTOA 
                                        FROM AHC_SOTHAM_BANAN B 
                                        LEFT JOIN DM_TOAAN DM ON B.TOAANID = DM.ID)T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,DM.TEN QTENTOA
                                        FROM AHC_SOTHAM_QUYETDINH Q
                                        LEFT JOIN DM_TOAAN DM ON Q.TOAANID = DM.ID
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QDST_2:=ITEM.v_BA_QDST_2;
		END LOOP;
    -- v_NGUOIKK_3 - NGƯỜI KHỞI KIỆN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 3 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIKK_3
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM AHC_DON_DUONGSU 
                    where 
                    --ISPHUCTHAM=1 and --Manhnd
                    TUCACHTOTUNG_MA ='NGUYENDON' --NGUYÊN ĐƠN
                    )T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIKK_3:=ITEM.v_NGUOIKK_3;
		END LOOP;
    -- v_NGUOIBIKIEN_4 - NGƯỜI BỊ KIỆN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 4 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBIKIEN_4
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM AHC_DON_DUONGSU 
                    where 
--                    ISPHUCTHAM=1 and  --Manhnd
                    TUCACHTOTUNG_MA ='BIDON'
                    ) T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIBIKIEN_4:=ITEM.v_NGUOIBIKIEN_4;
		END LOOP;
    -- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 5 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU ||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						decode(T2.LOAIDUONGSU,1,T2.TAMTRUCHITIET,T2.NDD_DIACHICHITIET) 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_DON_DUONGSU T2 ON T1.v_VUANID=T2.DONID AND T2.TUCACHTOTUNG_MA='QUYENNVLQ' --AND T2.ISPHUCTHAM=1 --NGƯỜI CÓ QUYỀN LỢI NGHĨA VỤ LIÊN QUAN
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
		END LOOP;
    -- v_NGUOIBV_QLIHP_DS_6 - NGƯỜI BẢO VỆ QUYỀN, LỢI ÍCH HỢP PHÁP CỦA ĐƯƠNG SỰ -- Họ tên, chức danh (nếu là Luật sư) - 6 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.HKTTCHITIET 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBV_QLIHP_DS_6
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_THAMGIATOTUNG T2 ON T2.TUCACHTGTTID='TGTTDS_07' AND T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIBV_QLIHP_DS_6:=ITEM.v_NGUOIBV_QLIHP_DS_6;
		END LOOP;

        -- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.TEN v_QHPL_7
                DECODE(D.QUANHEPHAPLUAT_NAME, NULL, D.TEN,D.QUANHEPHAPLUAT_NAME) v_QHPL_7
			FROM 
				TABLE(v_ARRAY) T1 
                INNER JOIN (select d1.id,d1.QUANHEPHAPLUAT_NAME,dm.TEN  
                                    From  AHC_DON d1
                                        left join DM_DATAITEM dm on dm.id = d1.QUANHEPHAPLUATID
                                        ) D ON T1.v_VUANID = D.ID --MANHND

				--INNER JOIN DM_DATAITEM T2 ON T1.v_QUANHEPHAPLUATID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
		END LOOP;

		-- v_KC_8 - KHÁNG CÁO Ngày tháng năm - 8 -Tóm tắt nội dung
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_KC_8
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_SOTHAM_KHANGCAO T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KC_8:=ITEM.v_KC_8;
		END LOOP;

		-- v_KN_9 - KHÁNG NGHỊ Số, ngày tháng năm - 9 - Tóm tắt nội dung
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOKN||', '||
					TO_CHAR(T2.NGAYKN,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT)  v_KN_9
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_SOTHAM_KHANGNGHI T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KN_9:=ITEM.v_KN_9;
		END LOOP;

    -- v_ADBPKCTT_10 - ÁP DỤNG BIỆN PHÁP KHẨN CẤP TẠM THỜI Số, ngày tháng năm - 10 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_ADBPKCTT_10
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='ADBPTT'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_ADBPKCTT_10:=ITEM.v_ADBPKCTT_10;
		END LOOP;
    -- v_RUT_KC_11 - RÚT KHÁNG CÁO Ngày tháng năm - 11 - 
        FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KC_11
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=1 --RÚT KHÁNG CÁO
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KC_11:=ITEM.v_RUT_KC_11;
		END LOOP;

		-- v_RUT_KN_12 - RÚT KHÁNG NGHỊ Số, ngày tháng năm - 12 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KN_12
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=2 -- RÚT KHÁNG NGHỊ
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KN_12:=ITEM.v_RUT_KN_12;
		END LOOP;

    -- v_TDC_13 - TẠM ĐÌNH CHỈ Số, ngày tháng năm - 13 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_TDC_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TDC_13:=ITEM.v_TDC_13;
		END LOOP;
    -- v_DC_14 - ĐÌNH CHỈ Số, ngày tháng năm - 14 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_DC_14
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DC_14:=ITEM.v_DC_14;
		END LOOP;
    -- v_LYDO_15 - LÝ DO - 15 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T3.TEN v_LYDO_15
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_QUYETDINH T2 on T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T5 on T2.LOAIQDID=T5.ID
        inner join DM_QD_QUYETDINH_LYDO T3 ON T2.LYDOID=T3.ID and T5.MA='DC'
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_15:=ITEM.v_LYDO_15;
		END LOOP;
    -- v_HDXX_VKS_TKPT_16 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TOÀ -- Ghi đầy đủ họ tên - 16 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || NVL(T5.TenCanBoToaAn,'')||NVL(T5.TenKSV,'')||
						' ('||DECODE(T5.MAVAITRO,'THAMPHAN','TPCT','THAMPHANHDXX', 'TPTV','THAMPHANDUKHUYET', 'TPDK','HTND', 'HTND','THUKY', 'TK','THUKYDUKHUYET', 'TKDK','KSV', 'KSV','')||')' 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_16
			FROM 
				TABLE(v_ARRAY) T1 
				inner join (
        select T2.DONID,T3.HOTEN as TenCanBoToaAn,T4.HOTEN as TenKSV,T2.MAVAITRO from AHC_PHUCTHAM_HDXX T2
				LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
				LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('HTND,KSV',T2.MAVAITRO)>0
        ORDER BY NLSSORT(T2.MAVAITRO, 'NLS_SORT = VIETNAMESE')
        )T5 ON T1.v_VUANID=T5.DONID
      group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_16:=ITEM.v_HDXX_VKS_TKPT_16;
		END LOOP;
    -- v_BA_QDPT_17 - BẢN ÁN, QUYẾT ĐỊNH PHÚC THẨM Số, ngày tháng năm - 17 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY') 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY')

                        )
                        v_BA_QDPT_17
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN AHC_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                        FROM AHC_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QDPT_17:=ITEM.v_BA_QDPT_17;
		END LOOP;

		-- v_QD_TA_PT_18 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM  -- Tóm tắt phần quyết định - 18 - 
        FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.QTENKQ|| CHR(10)
                    ,T2.BTENKQ|| CHR(10) 
                        )
                        v_QD_TA_PT_18
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,BKQ.TEN BTENKQ 
                                        FROM AHC_PHUCTHAM_BANAN B
                                        LEFT JOIN DM_KETQUA_PHUCTHAM BKQ ON BKQ.ID = B.KETQUAPHUCTHAMID) T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,KQ.TEN QTENKQ 
                                        FROM AHC_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                        LEFT JOIN DM_KETQUA_PHUCTHAM KQ ON KQ.ID = Q.KETQUAID
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_TA_PT_18:=ITEM.v_QD_TA_PT_18;
		END LOOP;

    -- v_LYDO_SH_ST_QDKDPL_19 - LÝ DO SỬA, HỦY… - Do cấp sơ thẩm quyết định không đúng pháp luật - 19 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_ST_QDKDPL_19
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISAHC=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do cấp sơ thẩm sai',lower(T4.TEN))>0 --Do cấp sơ thẩm sai
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_ST_QDKDPL_19:=ITEM.v_LYDO_SH_ST_QDKDPL_19;
		END LOOP;
    -- v_LYDO_SH_TTM_20 - LÝ DO SỬA, HỦY… - Do có tình tiết mới - 20 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_TTM_20
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISADS=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do có tình tiết mới',lower(T4.TEN))>0 --Lý do khác
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_TTM_20:=ITEM.v_LYDO_SH_TTM_20;
		END LOOP;
    -- v_APDUNGANLE_21 - ÁP DỤNG ÁN LỆ - 21 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(T2.APDUNGANLE,1,'X','') v_APDUNGANLE_21
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_APDUNGANLE_21:=ITEM.v_APDUNGANLE_21;
		END LOOP;
    -- v_GQ_TTRG_22 - GIẢI QUYẾT THEO THỦ TỤC RÚT GỌN - 22 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
          T2.SOQD || CHR(10) ||
          TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
          , CHR(10)
        ) within group (order by T1.v_STT)  v_GQ_TTRG_22
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHC_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='37-HC'
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TTRG_22:=ITEM.v_GQ_TTRG_22;
		END LOOP;
    -- v_KNGDTTT_23 - KHÁNG NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM Số, ngày tháng năm - 23 - 

    -- v_GHICHU_24 - GHI CHÚ - 24 - 

	END;

	/*4 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ ÁN HÀNH CHÍNH GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_HANHCHINH_GDTTT
	(
		v_ARRAY IN OUT T_HANHCHINH_GDTTT
	) AS
	BEGIN	
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 -         	
        FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ Số, ngày, tháng,năm và tên Toà án đã giải quyết - 2 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;
		-- v_NGUOIKK_3 - NGƯỜI KHỞI KIỆN Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 3 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.NGUYENDON, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIKK_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(ND.NGUYENDON_ND,NULL,v1.NGUYENDON,ND.NGUYENDON_ND) NGUYENDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOIKK_3:=ITEM.v_NGUOIKK_3;
        end loop;
		-- v_NGUOIBKK_4 - NGƯỜI BỊ KHỞI KIỆN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 4 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BIDON , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBKK_4
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id,  DECODE(ND.BIDON_BD,NULL,v1.BIDON,ND.BIDON_BD) BIDON  FROM GDTTT_VUAN V1
                                         LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='BIDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOIBKK_4:=ITEM.v_NGUOIBKK_4;
        end loop;
		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 5 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QUYENNVLQ , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, ND.QUYENNVLQ  FROM GDTTT_VUAN V1
                                         LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  QUYENNVLQ
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='QUYENNVLQ' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
        end loop;
		-- v_HDXX_VKS_TKPT_6 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TÒA -- Ghi đầy đủ họ tên - 6 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_6
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 

            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_6:=ITEM.v_HDXX_VKS_TKPT_6;
        end loop;
		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QHPLDN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QHPL_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(Trim(v1.QHPL_TEXT),null,qhpl.TENQHPL,v1.QHPL_TEXT) QHPLDN  
                                        FROM GDTTT_VUAN V1
                                        LEFT JOIN GDTTT_DM_QHPL qhpl on v1.QHPL_DINHNGHIAID=qhpl.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
        end loop;
		-- v_CHANHANKN_8 - CHÁNH ÁN KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 8 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_8
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_8:=ITEM.v_CHANHANKN_8;
        end loop;
		-- v_VIENTRUONGKN_9 - VIỆN TRƯỞNG KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 9 - 
          for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_9
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsVienTruongKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_9:=ITEM.v_VIENTRUONGKN_9;
        end loop;
		-- v_CHANHANRUT_KN_10 - CHÁNH ÁN RÚT KHÁNG NGHỊ Số, ngày tháng năm - 10 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                         and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_10:=ITEM.v_CHANHANRUT_KN_10;
        end loop;
		-- v_VIENTRUONGRUT_KN_11 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ Số, ngày tháng năm - 11 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_11:=ITEM.v_VIENTRUONGRUT_KN_11;
        end loop;
		-- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM  -- Số, ngày tháng năm - 12 - 
          for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)

                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày tháng năm - 13 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;
		-- v_LYDO_14 - LÝ DO -- Rút kháng nghị hoặc sửa, hủy - 14 - 
		-- v_APDUNGANLE_15 - ÁP DỤNG ÁN LỆ - 15 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1, tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_15:=ITEM.v_APDUNGANLE_15;
        end loop;
		-- v_GHICHU_16 - GHI CHÚ - 16 - 
	END;

	/*5 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC LAO ĐỘNG GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_LAODONG_GDTTT
	(
		v_ARRAY IN OUT T_LAODONG_GDTTT
	) AS
	BEGIN	
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
        FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			--v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ -- Số, ngày tháng năm và tên Tòa án đã giải quyết - 2 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;
		-- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 3 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.NGUYENDON, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(ND.NGUYENDON_ND,NULL,v1.NGUYENDON,ND.NGUYENDON_ND) NGUYENDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
        end loop;
		-- v_BD_NLQ_LD_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VIỆC LAO ĐỘNG Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 4 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BIDON , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQ_LD_4
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id,  DECODE(ND.BIDON_BD,NULL,v1.BIDON,ND.BIDON_BD) BIDON  FROM GDTTT_VUAN V1
                                         LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='BIDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BD_NLQ_LD_4:=ITEM.v_BD_NLQ_LD_4;
        end loop;
		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 5 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QUYENNVLQ , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, ND.QUYENNVLQ  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  QUYENNVLQ
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='QUYENNVLQ' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
        end loop;
		-- v_HDXX_VKS_TKPT_6 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TÒA -- Ghi đầy đủ họ tên - 6 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_6
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 

            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_6:=ITEM.v_HDXX_VKS_TKPT_6;
        end loop;
		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QHPLDN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QHPL_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(Trim(v1.QHPL_TEXT),null,qhpl.TENQHPL,v1.QHPL_TEXT) QHPLDN  
                                        FROM GDTTT_VUAN V1
                                        LEFT JOIN GDTTT_DM_QHPL qhpl on v1.QHPL_DINHNGHIAID=qhpl.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
        end loop;        
		-- v_CHANHANKN_8 - CHÁNH ÁN KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 8 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_8
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_8:=ITEM.v_CHANHANKN_8;
        end loop;
        
        
		-- v_VIENTRUONGKN_9 - VIỆN TRƯỞNG KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 9 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_9
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_9:=ITEM.v_VIENTRUONGKN_9;
        end loop;
        
		-- v_CHANHANRUT_KN_10 - CHÁNH ÁN RÚT KHÁNG NGHỊ Số, ngày tháng năm - 10 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_10:=ITEM.v_CHANHANRUT_KN_10;
        end loop;        
		-- v_VIENTRUONGRUT_KN_11 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ Số, ngày tháng năm - 11 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_11:=ITEM.v_VIENTRUONGRUT_KN_11;
        end loop;        
		-- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM  -- Số, ngày tháng năm - 12 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)

                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Tóm tắt nội dung - 13 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;        
		-- v_LYDO_14 - LÝ DO  -- Rút kháng nghị hoặc sửa, hủy - 14 - 
        
		-- v_VIECLD_15 - VIỆC LAO ĐỘNG - 15 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.isVIECDS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIECLD_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, 'x' as isVIECDS
                                        FROM GDTTT_VUAN V1
                                        INNER join DM_QHPL_TK tk on tk.id = v1.QHPL_THONGKEID and tk.options = 1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                       ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIECLD_15:=ITEM.v_VIECLD_15;
        end loop;        
		-- v_APDUNGANLE_16 - ÁP DỤNG ÁN LỆ - 16 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_16
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1, tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_16:=ITEM.v_APDUNGANLE_16;
        end loop;        
		-- v_GHICHU_17 - GHI CHÚ - 17 - 
	END;

	/*6 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC LAO ĐỘNG PHÚC THẨM*/
	PROCEDURE FILL_LAODONG_PHUCTHAM
	(
		v_ARRAY IN OUT T_LAODONG_PHUCTHAM
	) AS
	BEGIN	
		--v_ARRAY:=T_LAODONG_PHUCTHAM();
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
    FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULY|| CHR(10) ||TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1,
				T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDST_2 - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM Số, ngày tháng năm và tên Toà án đã giải quyết - 2 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY')|| CHR(10) || T3.QTENTOA 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY') || CHR(10) || T2.BTENTOA 
                         )
                        v_BA_QDST_2
			FROM 
				TABLE(v_ARRAY) T1  
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,DM.TEN BTENTOA 
                                        FROM ALD_SOTHAM_BANAN B 
                                        LEFT JOIN DM_TOAAN DM ON B.TOAANID = DM.ID)T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,DM.TEN QTENTOA
                                        FROM ALD_SOTHAM_QUYETDINH Q
                                        LEFT JOIN DM_TOAAN DM ON Q.TOAANID = DM.ID
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QDST_2:=ITEM.v_BA_QDST_2;
		END LOOP;
    -- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 3 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM ALD_DON_DUONGSU 
                    where 
                    --ISPHUCTHAM=1 and 
                    TUCACHTOTUNG_MA ='NGUYENDON' --NGUYÊN ĐƠN
                    )T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
		END LOOP;
    -- v_BD_NLQLD_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VỤ VIỆC LAO ĐỘNG Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 4 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU ||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.DIACHI 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQLD_4
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN (SELECT ID,DONID,TENDUONGSU,NAMSINH,TUCACHTOTUNG_MA,
                      CASE WHEN LOAIDUONGSU =1 THEN TAMTRUCHITIET ELSE NDD_DIACHICHITIET end as DIACHI  
                    FROM ALD_DON_DUONGSU 
                    where 
                    --ISPHUCTHAM=1 and 
                    TUCACHTOTUNG_MA ='BIDON'
                    ) T2 ON T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BD_NLQLD_4:=ITEM.v_BD_NLQLD_4;
		END LOOP;
    -- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 5 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.TENDUONGSU ||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						decode(T2.LOAIDUONGSU,1,T2.TAMTRUCHITIET,T2.NDD_DIACHICHITIET) 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_DON_DUONGSU T2 ON T1.v_VUANID=T2.DONID AND T2.TUCACHTOTUNG_MA='QUYENNVLQ' --AND T2.ISPHUCTHAM=1 --NGƯỜI CÓ QUYỀN LỢI NGHĨA VỤ LIÊN QUAN
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
		END LOOP;
    -- v_NGUOIBV_QLIHP_DS_6 - HỌ TÊN NGƯỜI BẢO VỆ QUYỀN, LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ - 6 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN||'; '||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
						T2.HKTTCHITIET 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBV_QLIHP_DS_6
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_THAMGIATOTUNG T2 ON T2.TUCACHTGTTID='TGTTDS_07' AND T1.v_VUANID=T2.DONID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIBV_QLIHP_DS_6:=ITEM.v_NGUOIBV_QLIHP_DS_6;
		END LOOP;
    -- v_QHPLKHITL_7 - QUAN HỆ PHÁP LUẬT KHI THỤ LÝ - 7 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.TEN v_QHPLKHITL_7
                DECODE(D.QUANHEPHAPLUAT_NAME, NULL, D.TEN,D.QUANHEPHAPLUAT_NAME) v_QHPLKHITL_7
			FROM 
				TABLE(v_ARRAY) T1 
                INNER JOIN (select d1.id,d1.QUANHEPHAPLUAT_NAME,dm.TEN  
                                    From  ALD_DON d1
                                        left join DM_DATAITEM dm on dm.id = d1.QUANHEPHAPLUATID
                                        ) D ON T1.v_VUANID = D.ID --MANHND

				--INNER JOIN DM_DATAITEM T2 ON T1.v_QUANHEPHAPLUATID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QHPLKHITL_7:=ITEM.v_QHPLKHITL_7;
		END LOOP;
   -- v_KC_8 - KHÁNG CÁO Ngày tháng năm - 8 -Tóm tắt nội dung
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy'), CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_KC_8
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_SOTHAM_KHANGCAO T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KC_8:=ITEM.v_KC_8;
		END LOOP;

		-- v_KN_9 - KHÁNG NGHỊ Số, ngày tháng năm - 9 - Tóm tắt nội dung
        --MANHND
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOKN||', '||
					TO_CHAR(T2.NGAYKN,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT)  v_KN_9
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_SOTHAM_KHANGNGHI T2 ON T1.v_VUANID=T2.DONID
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KN_9:=ITEM.v_KN_9;
		END LOOP;

    -- v_ADBPKCTT_10 - ÁP DỤNG BIỆN PHÁP KHẨN CẤP TẠM THỜI Số, ngày tháng năm - 10 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_ADBPKCTT_10
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='ADBPTT'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_ADBPKCTT_10:=ITEM.v_ADBPKCTT_10;
		END LOOP;
    -- v_RUT_KC_11 - RÚT KHÁNG CÁO Ngày tháng năm - 11 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KC_11
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=1 --RÚT KHÁNG CÁO
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KC_11:=ITEM.v_RUT_KC_11;
		END LOOP;

		-- v_RUT_KN_12 - RÚT KHÁNG NGHỊ Số, ngày tháng năm - 12 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(T2.NGAYRUT, CHR(10)) WITHIN GROUP (ORDER BY T1.v_STT) v_RUT_KN_12
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_SOTHAM_RUTKCKN T2 ON T1.v_VUANID=T2.DONID AND T2.ISKCKN=2 -- RÚT KHÁNG NGHỊ
			GROUP BY 
				T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_RUT_KN_12:=ITEM.v_RUT_KN_12;
		END LOOP; 

    -- v_TDC_13 - TẠM ĐÌNH CHỈ Số, ngày tháng năm - 13 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_TDC_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TDC_13:=ITEM.v_TDC_13;
		END LOOP;
    -- v_DC_14 - ĐÌNH CHỈ Số, ngày tháng năm - 14 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQD || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_DC_14
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_DC_14:=ITEM.v_DC_14;
		END LOOP;
    -- v_LYDO_15 - LÝ DO - 15 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        T3.TEN v_LYDO_15
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_QUYETDINH T2 on T1.v_VUANID=T2.DONID
        inner join DM_QD_LOAI T5 on T2.LOAIQDID=T5.ID
        inner join DM_QD_QUYETDINH_LYDO T3 ON T2.LYDOID=T3.ID and T5.MA='DC'
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_15:=ITEM.v_LYDO_15;
		END LOOP;
    -- v_HDXX_VKS_TKPT_16 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TOÀ -- Ghi đầy đủ họ tên - 16 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || NVL(T5.TenCanBoToaAn,'')||NVL(T5.TenKSV,'')||
						' ('||DECODE(T5.MAVAITRO,'THAMPHAN','TPCT','THAMPHANHDXX', 'TPTV','THAMPHANDUKHUYET', 'TPDK','HTND', 'HTND','THUKY', 'TK','THUKYDUKHUYET', 'TKDK','KSV', 'KSV','')||')' 
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_16
			FROM 
				TABLE(v_ARRAY) T1 
				inner join (
        select T2.DONID,T3.HOTEN as TenCanBoToaAn,T4.HOTEN as TenKSV,T2.MAVAITRO from ALD_PHUCTHAM_HDXX T2
				LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
				LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('HTND,KSV',T2.MAVAITRO)>0
        ORDER BY NLSSORT(T2.MAVAITRO, 'NLS_SORT = VIETNAMESE')
        )T5 ON T1.v_VUANID=T5.DONID
      group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_16:=ITEM.v_HDXX_VKS_TKPT_16;
		END LOOP;

    -- v_BA_QDPT_17 - BẢN ÁN, QUYẾT ĐỊNH PHÚC THẨM Số, ngày tháng năm - 17 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.SOQD|| CHR(10) ||TO_CHAR(T3.NGAYQD,'DD/MM/YYYY') 
                    ,T2.SOBANAN|| CHR(10) || TO_CHAR(T2.NGAYTUYENAN,'DD/MM/YYYY')

                        )
                        v_BA_QDPT_17
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN ALD_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                        FROM ALD_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_BA_QDPT_17:=ITEM.v_BA_QDPT_17;
		END LOOP;

		-- v_QD_TA_PT_18 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM  -- Tóm tắt phần quyết định - 18 - 
        FOR ITEM IN (
			SELECT 
				T1.v_STT
                ,DECODE(NVL(T2.ID,0),0
                    ,T3.QTENKQ|| CHR(10)
                    ,T2.BTENKQ|| CHR(10) 
                        )
                        v_QD_TA_PT_18
			FROM 
				TABLE(v_ARRAY) T1 
				LEFT JOIN (SELECT B.ID,B.DONID,B.SOBANAN,B.NGAYTUYENAN,BKQ.TEN BTENKQ 
                                        FROM ALD_PHUCTHAM_BANAN B
                                        LEFT JOIN DM_KETQUA_PHUCTHAM BKQ ON BKQ.ID = B.KETQUAPHUCTHAMID) T2 ON T1.v_VUANID=T2.DONID
                LEFT JOIN (SELECT Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,KQ.TEN QTENKQ 
                                        FROM ALD_PHUCTHAM_QUYETDINH Q 
                                        LEFT JOIN DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                        LEFT JOIN DM_KETQUA_PHUCTHAM KQ ON KQ.ID = Q.KETQUAID
                                                WHERE D.KET_THUC = 1) T3 ON T1.v_VUANID=T3.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_TA_PT_18:=ITEM.v_QD_TA_PT_18;
		END LOOP;

    -- v_LYDO_SH_STSAI_19 - LÝ DO SỬA, HỦY… - Do cấp sơ thẩm sai - 19 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_STSAI_19
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISALD=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do cấp sơ thẩm sai',lower(T4.TEN))>0 --Do cấp sơ thẩm sai
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_STSAI_19:=ITEM.v_LYDO_SH_STSAI_19;
		END LOOP;
    -- v_LYDO_SH_LDK_20 - LÝ DO SỬA, HỦY… - Do có lý do khác - 20 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_LYDO_SH_LDK_20
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISALD=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do có tình tiết mới,lý do khác',lower(T4.TEN))>0 --Lý do khác
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_LYDO_SH_LDK_20:=ITEM.v_LYDO_SH_LDK_20;
		END LOOP;
    -- v_APDUNGANLE_21 - ÁP DỤNG ÁN LỆ - 21 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(T2.APDUNGANLE,1,'X','') v_APDUNGANLE_21
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_APDUNGANLE_21:=ITEM.v_APDUNGANLE_21;
		END LOOP;
    -- v_GQ_TTRG_22 - GIẢI QUYẾT THEO THỦ TỤC RÚT GỌN - 22 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
          T2.SOQD || CHR(10) ||
          TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
          , CHR(10)
        ) within group (order by T1.v_STT)  v_GQ_TTRG_22
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_QUYETDINH T2 ON T1.v_VUANID=T2.DONID
        inner join DM_QD_QUYETDINH T3 on T3.ID=T2.QUYETDINHID and T3.MA='80-DS'
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TTRG_22:=ITEM.v_GQ_TTRG_22;
		END LOOP;
    -- v_VIECLD_23 - VIỆC LAO ĐỘNG - 23 - 
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(T2.LOAIQUANHE,2,'X','') v_VIECLD_23
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_THULY T2 ON T1.v_VUANID=T2.DONID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_VIECLD_23:=ITEM.v_VIECLD_23;
		END LOOP;
    -- v_QD_GDTTT_24 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM Số, ngày tháng năm - 24 - 

    -- v_GHICHU_25 - GHI CHÚ - 25 - 
    FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.GHICHU v_GHICHU_25
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN ALD_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GHICHU_25:=ITEM.v_GHICHU_25;
		END LOOP;
	END;

	/*7 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC LAO ĐỘNG SƠ THẨM*/
	

	/*8 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC KINH DOANH THƯƠNG MẠI GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_KINHTE_GDTTT
	(
		v_ARRAY IN OUT T_KINHTE_GDTTT
	) AS
	BEGIN	
		
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
         FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			--v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ Số, ngày, tháng,năm và tên Toà án đã giải quyết - 2 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;
		-- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 3 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.NGUYENDON, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id,DECODE(ND.NGUYENDON_ND,NULL,v1.NGUYENDON,ND.NGUYENDON_ND) NGUYENDON  FROM GDTTT_VUAN V1
                                         LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
        end loop;
		-- v_BD_NLQ_KDTM_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VIỆC KINH DOANH THƯƠNG MẠI Họ tên, địa chỉ. Họ tên người đại diện, chức vụ, địa chỉ - 4 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BIDON , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQ_KDTM_4
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id,  DECODE(ND.BIDON_BD,NULL,v1.BIDON,ND.BIDON_BD) BIDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='BIDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BD_NLQ_KDTM_4:=ITEM.v_BD_NLQ_KDTM_4;
        end loop;
        
		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, địa chỉ Họ tên người đại diện, chức vụ, địa chỉ - 5 - 
          for Item in(
              select 
                T1.v_STT,
                LISTAGG(v.QUYENNVLQ , CHR(10)
                        ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
              from
                table(v_ARRAY) T1
                INNER JOIN (SELECT v1.id, ND.QUYENNVLQ  FROM GDTTT_VUAN V1
                                             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  QUYENNVLQ
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                        WHERE DS.TUCACHTOTUNG='QUYENNVLQ' 
                                                                        GROUP BY DS.VUANID
                                                                )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
                group by T1.v_STT 
            ) loop
              v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
            end loop;
        
		-- v_HDXX_VKS_TKPT_6 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TÒA -- Ghi đầy đủ họ tên - 6 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_6
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 

            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_6:=ITEM.v_HDXX_VKS_TKPT_6;
        end loop;
        
		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QHPLDN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QHPL_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(Trim(v1.QHPL_TEXT),null,qhpl.TENQHPL,v1.QHPL_TEXT) QHPLDN  
                                        FROM GDTTT_VUAN V1
                                        LEFT JOIN GDTTT_DM_QHPL qhpl on v1.QHPL_DINHNGHIAID=qhpl.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
        end loop;        
		-- v_CHANHANKN_8 - CHÁNH ÁN KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 8 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_8
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_8:=ITEM.v_CHANHANKN_8;
        end loop;
        
		-- v_VIENTRUONGKN_9 - VIỆN TRƯỞNG KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 9 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_9
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_9:=ITEM.v_VIENTRUONGKN_9;
        end loop;   
        
		-- v_CHANHANRUT_KN_10 - CHÁNH ÁN RÚT KHÁNG NGHỊ Số, ngày tháng năm - 10 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                         and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_10:=ITEM.v_CHANHANRUT_KN_10;
        end loop;
		-- v_VIENTRUONGRUT_KN_11 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ Số, ngày tháng năm - 11 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_11:=ITEM.v_VIENTRUONGRUT_KN_11;
        end loop;
		-- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày tháng năm - 12 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)

                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;    
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Tóm tắt nội dung - 13 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;
		-- v_LYDO_14 - LÝ DO  -- Rút kháng nghị hoặc sửa, hủy - 14 - 
		-- v_VIEC_KDTM_15 - VIỆC KINH DOANH THƯƠNG MẠI - 15 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.isVIECDS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIEC_KDTM_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, 'x' as isVIECDS
                                        FROM GDTTT_VUAN V1
                                        INNER join DM_QHPL_TK tk on tk.id = v1.QHPL_THONGKEID and tk.options = 1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                       ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIEC_KDTM_15:=ITEM.v_VIEC_KDTM_15;
        end loop;
		-- v_APDUNGANLE_16 - ÁP DỤNG ÁN LỆ - 16 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_16
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1, tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_16:=ITEM.v_APDUNGANLE_16;
        end loop;
		-- v_GHICHU_17 - GHI CHÚ - 17 - 
	END;
	/*10 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC KINH DOANH THƯƠNG MẠI SƠ THẨM*/
	

	/*11 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC HÔN NHÂN VÀ GIA ĐÌNH GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_HONNHAN_GDTTT
	(
		v_ARRAY IN OUT T_HONNHAN_GDTTT
	) AS
	BEGIN	
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 -
        FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			--v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ Số, ngày, tháng,năm và tên Toà án đã giải quyết - 2 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;
		-- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, năm sinh, địa chỉ - 3 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.NGUYENDON, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(ND.NGUYENDON_ND,NULL,v1.NGUYENDON,ND.NGUYENDON_ND) NGUYENDON  FROM GDTTT_VUAN V1
                                       LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
        end loop;
		-- v_BD_NLQ_HNGD_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VIỆC HÔN NHÂN VÀ GIA ĐÌNH Họ tên, năm sinh, địa chỉ - 4 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BIDON , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQ_HNGD_4
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id,  DECODE(ND.BIDON_BD,NULL,v1.BIDON,ND.BIDON_BD) BIDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='BIDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BD_NLQ_HNGD_4:=ITEM.v_BD_NLQ_HNGD_4;
        end loop;
		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, năm sinh, địa chỉ - 5 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QUYENNVLQ , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, ND.QUYENNVLQ  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  QUYENNVLQ
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='QUYENNVLQ' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
        end loop;
		-- v_HDXX_VKS_TKPT_6 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KiỂM SÁT, THƯ KÝ PHIÊN TÒA -- Ghi đầy đủ họ tên - 6 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_6
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 

            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_6:=ITEM.v_HDXX_VKS_TKPT_6;
        end loop;
		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QHPLDN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QHPL_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(Trim(v1.QHPL_TEXT),null,qhpl.TENQHPL,v1.QHPL_TEXT) QHPLDN  
                                        FROM GDTTT_VUAN V1
                                        LEFT JOIN GDTTT_DM_QHPL qhpl on v1.QHPL_DINHNGHIAID=qhpl.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
        end loop;
        
		-- v_CHANHANKN_8 - CHÁNH ÁN KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 8 -
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_8
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_8:=ITEM.v_CHANHANKN_8;
        end loop;
        
		-- v_VIENTRUONGKN_9 - VIỆN TRƯỞNG KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 9 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_9
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_9:=ITEM.v_VIENTRUONGKN_9;
        end loop;
		-- v_CHANHANRUT_KN_10 - CHÁNH ÁN RÚT KHÁNG NGHỊ Số, ngày tháng năm - 10 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                         and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_10:=ITEM.v_CHANHANRUT_KN_10;
        end loop;
		-- v_VIENTRUONGRUT_KN_11 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ Số, ngày tháng năm - 11 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_11:=ITEM.v_VIENTRUONGRUT_KN_11;
        end loop;
		-- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày tháng năm - 12 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)

                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Tóm tắt nội dung - 13 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;
		-- v_LYDO_14 - LÝ DO -- Rút kháng nghị hoặc sửa, hủy - 14 - 
		-- v_HN_GD_15 - VIỆC HÔN NHÂN VÀ GIA ĐÌNH - 15 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.isVIECDS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HN_GD_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, 'x' as isVIECDS
                                        FROM GDTTT_VUAN V1
                                        INNER join DM_QHPL_TK tk on tk.id = v1.QHPL_THONGKEID and tk.options = 1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                       ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HN_GD_15:=ITEM.v_HN_GD_15;
        end loop;
		-- v_APDUNGANLE_16 - ÁP DỤNG ÁN LỆ - 16 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_16
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1, tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_16:=ITEM.v_APDUNGANLE_16;
        end loop;
		-- v_GHICHU_17 - GHI CHÚ - 17 - 
	END;
	/*13 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC HÔN NHÂN VÀ GIA ĐÌNH SƠ THẨM*/
	
	/*14 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC DÂN SỰ GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_DANSU_GDTTT
	(
		v_ARRAY IN OUT T_DANSU_GDTTT
	) AS
	BEGIN	
--		v_ARRAY:=T_DANSU_GDTTT();
		-- v_TL_1 - THỤ LÝ Số, ngày tháng năm - 1 - 
    FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				--T2.QUANHEPHAPLUATID v_QUANHEPHAPLUATID,
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
			--v_ARRAY(ITEM.v_STT).v_QUANHEPHAPLUATID:=ITEM.v_QUANHEPHAPLUATID;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ -- Số, ngày tháng năm và tên Tòa án đã giải quyết - 2 -
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;
		-- v_ND_NYC_3 - NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU Họ tên, năm sinh, địa chỉ - 3 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.NGUYENDON, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_ND_NYC_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(ND.NGUYENDON_ND,NULL,v1.NGUYENDON,ND.NGUYENDON_ND) NGUYENDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU || DECODE(DS.NAMSINH,NULL,null,'0',null,' NS:'||DS.NAMSINH) ||  DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_ND_NYC_3:=ITEM.v_ND_NYC_3;
        end loop;
		-- v_BD_NLQDS_4 - BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VỤ VIỆC DÂN SỰ Họ tên, năm sinh, địa chỉ - 4 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BIDON , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BD_NLQDS_4
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(ND.BIDON_BD,NULL,v1.BIDON,ND.BIDON_BD) BIDON  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU ||DECODE(DS.NAMSINH,NULL,NULL,'0',null,' NS:'||DS.NAMSINH) || DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='BIDON' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BD_NLQDS_4:=ITEM.v_BD_NLQDS_4;
        end loop;
		-- v_NGUOI_QLNVLQ_5 - NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN Họ tên, năm sinh, địa chỉ - 5 - 
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QUYENNVLQ , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOI_QLNVLQ_5
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, ND.QUYENNVLQ  FROM GDTTT_VUAN V1
                                        INNER JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU ||DECODE(DS.NAMSINH,NULL,NULL,'0',null,' NS:'||DS.NAMSINH) || DECODE(NVL(DS.HUYENID,0),0,'', '- Đc:'|| DS.DIACHI||', '||DC.MA_TEN ), '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  QUYENNVLQ
                                                                    FROM GDTTT_VUAN_DUONGSU DS
                                                                    LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                                    WHERE DS.TUCACHTOTUNG='QUYENNVLQ' 
                                                                    GROUP BY DS.VUANID
                                                            )ND ON ND.VUANID=V1.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOI_QLNVLQ_5:=ITEM.v_NGUOI_QLNVLQ_5;
        end loop;
		-- v_HDXX_VKS_TKPT_6 - HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TÒA -- Ghi đầy đủ họ tên - 6 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_HDXX_VKS_TKPT_6
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 
                                        
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_HDXX_VKS_TKPT_6:=ITEM.v_HDXX_VKS_TKPT_6;
        end loop;
		-- v_QHPL_7 - QUAN HỆ PHÁP LUẬT - 7 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QHPLDN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QHPL_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(Trim(v1.QHPL_TEXT),null,qhpl.TENQHPL,v1.QHPL_TEXT) QHPLDN  
                                        FROM GDTTT_VUAN V1
                                        LEFT JOIN GDTTT_DM_QHPL qhpl on v1.QHPL_DINHNGHIAID=qhpl.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QHPL_7:=ITEM.v_QHPL_7;
        end loop;
		-- v_CHANHANKN_8 - CHÁNH ÁN KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 8 - 
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_8
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_8:=ITEM.v_CHANHANKN_8;
        end loop;
		-- v_VIENTRUONGKN_9 - VIỆN TRƯỞNG KHÁNG NGHỊ Số, ngày tháng năm Tóm tắt nội dung - 9 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_9
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_9:=ITEM.v_VIENTRUONGKN_9;
        end loop;
		-- v_CHANHANRUT_KN_10 - CHÁNH ÁN RÚT KHÁNG NGHỊ Số, ngày tháng năm - 10 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_10:=ITEM.v_CHANHANRUT_KN_10;
        end loop;
		-- v_VIENTRUONGRUT_KN_11 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ Số, ngày tháng năm - 11 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_11:=ITEM.v_VIENTRUONGRUT_KN_11;
        end loop;
		-- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày tháng năm - 12 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)
                                             
                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Tóm tắt nội dung - 13 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;
		-- v_LYDO_14 - LÝ DO -- Rút kháng nghị hoặc sửa, hủy - 14 - 
		-- v_VIECDS_15 - VIỆC DÂN SỰ - 15 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.isVIECDS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIECDS_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, 'x' as isVIECDS
                                        FROM GDTTT_VUAN V1
                                        inner join DM_QHPL_TK tk on tk.id = v1.QHPL_THONGKEID and tk.options = 1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                       ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIECDS_15:=ITEM.v_VIECDS_15;
        end loop;
		-- v_APDUNGANLE_16 - ÁP DỤNG ÁN LỆ - 16 - 
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_16
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1, tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_16:=ITEM.v_APDUNGANLE_16;
        end loop;
		-- v_GHICHU_17 - GHI CHÚ - 17 - 
	END;

/*15 - SỔ THỤ LÝ VÀ KẾT QỦA GIẢI QUYẾT CÁC VỤ VIỆC DÂN SỰ SƠ THẨM*/
	

	/*16 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ SƠ THẨM*/
	PROCEDURE FILL_HINHSU_SOTHAM
	(
		v_ARRAY IN OUT T_HINHSU_SOTHAM
	) AS
	BEGIN	
		-- v_TL_1 - THỤ LÝ HỒ SƠ Số, ngày tháng năm - 1
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOTHULY || CHR(10) || TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
        --------------------------------------------
		-- v_HOTENBICAO_2 - HỌ TÊN BỊ CÁO Năm sinh,nơi cư trú, giới tính, quốc tịch, dân tộc, nghề nghiệp,  -- Công chức, viên chức, đảng viên, tái phạm, tái phạm nguy hiểm, nghiện ma túy (nếu có) - 2
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        substr(
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN ||'; '||
						DECODE(T2.NAMSINH,0,' ',T2.NAMSINH ||'; ') ||
            DECODE(NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET),'','','Nơi cư trú: '||NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET)||'; ') ||
						'Giới tính: '||DECODE(T2.GIOITINH,0,'Nữ',1,'Nam','')||'; '||
						'Quốc tịch: '||DECODE(T4.QUOCTICH,'','',T4.QUOCTICH)||'; '||
						DECODE(T3.DANTOC,'','','Dân tộc: '||T3.DANTOC||'; ')||
						DECODE(T5.NGHENGHIEP,'','','Nghề nghiệp: '||T5.NGHENGHIEP||'; ')||
						DECODE(T2.CHUCVUCHINHQUYENID,1,'Công chức, viên chức: Có; ','')||
						DECODE(T2.CHUCVUDANGID,1,'Đảng viên: Có; ','')||
						DECODE(T2.TAIPHAM,1,'Tái phạm, tái phạm nguy hiểm: Có; ','')||
						DECODE(T2.NGHIENHUT,1,'Nghiện ma túy: Có; ','')
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT)
        ,1,4000)v_HOTENBICAO_2
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
				INNER JOIN (
					SELECT T3.ID BICANID,T4.TEN DANTOC
					FROM AHS_BICANBICAO T3 LEFT JOIN DM_DATAITEM T4 ON T4.ID=T3.DANTOCID AND T4.GROUPID=1--DÂN TỘC
				) T3 ON T2.ID=T3.BICANID
				INNER JOIN (
					SELECT T3.ID BICANID,T4.TEN QUOCTICH
					FROM AHS_BICANBICAO T3 LEFT JOIN DM_DATAITEM T4 ON T4.ID=T3.QUOCTICHID AND T4.GROUPID=2--QUỐC TỊCH
				) T4 ON T2.ID=T4.BICANID
				INNER JOIN (
					SELECT T3.ID BICANID,T4.TEN NGHENGHIEP
					FROM AHS_BICANBICAO T3 LEFT JOIN DM_DATAITEM T4 ON T4.ID=T3.NGHENGHIEPID AND T4.GROUPID=22--NGHỀ NGHIỆP
				) T5 ON T2.ID=T5.BICANID
			GROUP BY
				T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_HOTENBICAO_2:=ITEM.v_HOTENBICAO_2;
		END LOOP;

		-- v_THOIHANTAMGIAM_3 - THỜI HẠN TẠM GIAM -- (Nguyên nhân vi phạm nếu có) - 3
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
                cast(
                '- ' || T2.HOTEN||' '||CAST(T3.NGAYKETTHUC-T3.NGAYBATDAU as varchar(50))||' ngày;'
                as varchar2(4000))
          , CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_THOIHANTAMGIAM_3
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
				INNER JOIN AHS_SOTHAM_BIENPHAPNGANCHAN T3 ON T3.BICANID=T2.ID
        where T3.NGAYKETTHUC-T3.NGAYBATDAU>0
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_THOIHANTAMGIAM_3:=ITEM.v_THOIHANTAMGIAM_3;
		END LOOP;
    -- v_CAOTRANG_4 - CÁO TRẠNG  -- Số, ngày, tháng, năm -- Điều luật, Tội danh, hình phạt theo đề nghị của Kiểm sát viên tại phiên tòa - 4
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        cast(
        T5.SOBANCAOTRANG || CHR(10) ||
        TO_CHAR(T5.NGAYBANCAOTRANG,'dd/MM/yyyy') || CHR(10) ||
        T6.ToiDanh as varchar2(4000)) v_CAOTRANG_4
			FROM 
				TABLE(v_ARRAY) T1
        inner join AHS_VUAN T5 on T1.v_VUANID=T5.ID
        INNER JOIN (
                    select T7.VUANID,
                      LISTAGG(
                                cast(T7.ToiDanh as varchar2(4000))
                                , CHR(10)
                                ) WITHIN GROUP (ORDER BY T7.VUANID) ToiDanh
                    from (
                          select distinct T2.VUANID,
                              'Điều '||T4.DIEU||' '|| NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                          from AHS_BICANBICAO T2
                          INNER JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT T3 ON T3.BICANID=T2.ID
                          inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                          where T2.BICANDAUVU=1
                          )T7
                          group by T7.VUANID
                    )T6 on T6.VUANID=T1.v_VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_CAOTRANG_4:=ITEM.v_CAOTRANG_4;
		END LOOP;
    -- v_NGUOITHAMGIATOTUNG_5 - NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Họ tên, năm sinh, nơi cư trú, giới tính - 5
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN || '; ' ||
						case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||
            nvl2(T2.DIACHICHITIET,T2.DIACHICHITIET || '; ','') ||
            'giới tính: '||DECODE(T2.GIOITINH,0,'Nữ',1,'Nam','')
						AS VARCHAR2(4000)
					)
          ,CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOITHAMGIATOTUNG_5
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 ON T1.v_VUANID=T2.VUANID
        inner join AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
        inner join DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_01,TGTTHS_03,TGTTHS_04,TGTTHS_05,TGTTHS_08',T4.MA)>0
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOITHAMGIATOTUNG_5:=ITEM.v_NGUOITHAMGIATOTUNG_5;
		END LOOP;
    -- v_NGUOIBC_NGUOIBV_QLIHP_DS_6 - NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ  -- Họ tên, địa chỉ hoặc đơn vị hành nghề - 6
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
				LISTAGG(
					CAST(
						'- ' || T2.HOTEN || '; ' ||
            nvl2(T2.DIACHICHITIET,T2.DIACHICHITIET || '; ','')
						AS VARCHAR2(4000)
					)
          ,CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOIBC_NGUOIBV_QLIHP_DS_6
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 ON T1.v_VUANID=T2.VUANID
        inner join AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
        inner join DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_06,TGTTHS_10',T4.MA)>0
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_NGUOIBC_NGUOIBV_QLIHP_DS_6:=ITEM.v_NGUOIBC_NGUOIBV_QLIHP_DS_6;
		END LOOP;
    -- v_GQ_TRAHOSOCHOVKS_7 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Số, ngày, tháng, năm - Viện kiểm sát chấp nhận - 7
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') v_GQ_TRAHOSOCHOVKS_7
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID
        inner join DM_QD_LOAI T3 on T3.ID= T2.LOAIQDID and T3.MA='TRAHS' and T3.ISHINHSU=1
        inner join AHS_SOTHAM_BANAN T4 on T4.VUANID=T1.v_VUANID and T4.TK_ISTRAHS_VKSKHONGNHAN=0
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TRAHOSOCHOVKS_7:=ITEM.v_GQ_TRAHOSOCHOVKS_7;
		END LOOP;
    -- v_GQ_TRAHOSOCHOVKS_8 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Số, ngày, tháng, năm - Viện kiểm sát không chấp nhận - 8
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
        T2.SOQUYETDINH || CHR(10) || TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') v_GQ_TRAHOSOCHOVKS_8
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID
        inner join DM_QD_LOAI T3 on T3.ID= T2.LOAIQDID and T3.MA='TRAHS' and T3.ISHINHSU=1
        inner join AHS_SOTHAM_BANAN T4 on T4.VUANID=T1.v_VUANID and T4.TK_ISTRAHS_VKSKHONGNHAN=1
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TRAHOSOCHOVKS_8:=ITEM.v_GQ_TRAHOSOCHOVKS_8;
		END LOOP;
    -- v_GQ_TA_XMTT_BSCC_9 - GIẢI QUYẾT - TÒA ÁN XÁC MINH, THU THẬP, BỔ SUNG CHỨNG CỨ --  - 9
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				decode(T2.TK_TOAAN_SOVUXM,1,'X','') v_GQ_TA_XMTT_BSCC_9
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TA_XMTT_BSCC_9:=ITEM.v_GQ_TA_XMTT_BSCC_9;
		END LOOP;
    -- v_GQ_TA_DENGHI_BPBAOVE_10 - GIẢI QUYẾT - TÒA ÁN ĐỀ NGHỊ CÁC CƠ QUAN ÁP DỤNG CÁC BIỆN PHÁP BẢO VỆ -- Số, ngày, tháng, năm - 10
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') v_GQ_TA_DENGHI_BPBAOVE_10
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID and T2.TK_APDUNGBAOVE=1
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TA_DENGHI_BPBAOVE_10:=ITEM.v_GQ_TA_DENGHI_BPBAOVE_10;
		END LOOP;
    -- v_GQ_TDC_11 - GIẢI QUYẾT - TẠM ĐÌNH CHỈ -- Số, ngày, tháng, năm - 11
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQUYETDINH || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_GQ_TDC_11
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TDC_11:=ITEM.v_GQ_TDC_11;
		END LOOP;
    -- v_GQ_DC_12 - GIẢI QUYẾT - ĐÌNH CHỈ  -- Số, ngày, tháng, năm - 12
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQUYETDINH || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_GQ_DC_12
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_DC_12:=ITEM.v_GQ_DC_12;
		END LOOP;
    -- v_GQ_CHUYENHS_VA_13 - GIẢI QUYẾT - CHUYỂN HỒ SƠ VỤ ÁN -- Số, ngày, tháng, năm - 13
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOQUYETDINH || CHR(10) ||
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_GQ_CHUYENHS_VA_13
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='CVA'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_CHUYENHS_VA_13:=ITEM.v_GQ_CHUYENHS_VA_13;
		END LOOP;
    -- v_GQ_TAPHUCHOIVA_14 - GIẢI QUYẾT - TÒA ÁN PHỤC HỒI VỤ ÁN  -- Số, ngày, tháng, năm - 14
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') v_GQ_TAPHUCHOIVA_14
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID and T2.TK_PHUCHOIAN_VUAN=1
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GQ_TAPHUCHOIVA_14:=ITEM.v_GQ_TAPHUCHOIVA_14;
		END LOOP;
    -- v_GQ_LYDO_15 - GIẢI QUYẾT - LÝ DO - 15

    -- v_XX_NGUOITIENHANHTOTUNG_16 - XÉT XỬ - NGƯỜI TIẾN HÀNH TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên - 16
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || NVL(T3.HOTEN,'')||NVL(T4.HOTEN,'')||
						' ('||DECODE(T2.MAVAITRO,'HTND','HTND','KSV','KSV','THAMPHAN','TPCT','THAMPHANDUKHUYET','TPDK','THAMPHANHDXX','TPTV','THUKY','TK','THUKYDUKHUYET','TKDK','')||')'
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_NGUOITIENHANHTOTUNG_16
			FROM 
				TABLE(v_ARRAY) T1
        inner join AHS_SOTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
				LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
				LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('HTND,KSV',T2.MAVAITRO)>0
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_NGUOITIENHANHTOTUNG_16:=ITEM.v_XX_NGUOITIENHANHTOTUNG_16;
		END LOOP;
    -- v_XX_TAYCVKS_BXTLCC_17 - XÉT XỬ - TÒA ÁN YÊU CẦU VKS BỔ SUNG TÀI LIỆU, CHỨNG CỨ -- Số, ngày, tháng, năm - 17
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') v_XX_TAYCVKS_BXTLCC_17
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID and T2.TK_YEUCAUVKSBOSUNGTL=1
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_TAYCVKS_BXTLCC_17:=ITEM.v_XX_TAYCVKS_BXTLCC_17;
		END LOOP;
    -- v_XX_BA_QDST_18 - XÉT XỬ - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM  -- Số, ngày, tháng, năm - 18
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					T2.SOBANAN || CHR(10) ||
					TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_BA_QDST_18
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_BA_QDST_18:=ITEM.v_XX_BA_QDST_18;
		END LOOP;
    -- v_XX_QDCUABA_QDST_19 - XÉT XỬ - QUYẾT ĐỊNH CỦA BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM -- Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung -- Miễn trách nhiệm hình sự, miễn hình phạt, giáo dục tại trường giáo dưỡng (nếu có) - 19
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        cast(T6.ToiDanh || '; ' || T10.HinhPhat as varchar2(4000)) v_XX_QDCUABA_QDST_19
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select T11.VUANID,
                      LISTAGG(
                                cast(T11.ToiDanh as varchar2(4000))
                                , CHR(10)
                                ) WITHIN GROUP (ORDER BY T11.VUANID) ToiDanh
                    from (
                          select distinct T2.VUANID,
                              'Điều '||T4.DIEU||' '|| NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                          from AHS_BICANBICAO T2
                          INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T3 ON T3.BICANID=T2.ID
                          inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                          where T2.BICANDAUVU=1
                          )T11
                          group by T11.VUANID
                    )T6 on T6.VUANID=T1.v_VUANID
        inner join (
                     select T9.VUANID,
                        LISTAGG(
                                cast(T7.TENHINHPHAT as varchar2(4000))
                                , '; '
                                ) WITHIN GROUP (ORDER BY T9.VUANID) HinhPhat
                     from AHS_BICANBICAO T9
                     INNER JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET T8 ON T8.BICANID=T9.ID
                     left join DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID and instr('MIENHINHPHAT,GIAODUCTGD,MIENTNHS',T7.MAHINHPHAT)>0
                     where T9.BICANDAUVU=1
                     group by T9.VUANID
                    ) T10 on T10.VUANID=T1.v_VUANID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_QDCUABA_QDST_19:=ITEM.v_XX_QDCUABA_QDST_19;
		END LOOP;
    -- v_XX_KHOITOVATAIPHIENTOA_20 - XÉT XỬ - KHỞI TỐ VỤ ÁN TẠI PHIÊN TÒA -- Số, ngày, tháng, năm - 20
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') v_XX_KHOITOVATAIPHIENTOA_20
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID and T2.TK_KHOITO_VUAN=1
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_KHOITOVATAIPHIENTOA_20:=ITEM.v_XX_KHOITOVATAIPHIENTOA_20;
		END LOOP;
    -- v_XX_THIETHAI_21 - XÉT XỬ - THIỆT HẠI  -- (Mục 3 Chương 18 và Chương 23 BLHS) -- (Tài sản chiếm đoạt hoặc tài sản thiệt hại) - 21
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				REPLACE(TO_CHAR(decode(nvl(T2.TK_TSTHIETHAI,0),0,nvl(T2.TK_TSCHIEMDOAT,0),nvl(T2.TK_TSTHIETHAI,0)),'999,999,999,999,999,999'),',','.') v_XX_THIETHAI_21
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_THIETHAI_21:=ITEM.v_XX_THIETHAI_21;
		END LOOP;
    -- v_XX_ANLQDENBAOLUCGD_22 - XÉT XỬ - ÁN LIÊN QUAN ĐẾN BẠO LỰC GIA ĐÌNH - 22
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				decode(T2.ISBAOLUCGIADINH,1,'X','') v_XX_ANLQDENBAOLUCGD_22
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_ANLQDENBAOLUCGD_22:=ITEM.v_XX_ANLQDENBAOLUCGD_22;
		END LOOP;
    -- v_XX_AD_ALD_ARG_23 - XÉT XỬ - ÁN ĐIỂM, ÁN LƯU ĐỘNG, ÁN RÚT GỌN - 23
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				decode(T2.ISXXLUUDONG,1,'X','') v_XX_AD_ALD_ARG_23
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_AD_ALD_ARG_23:=ITEM.v_XX_AD_ALD_ARG_23;
		END LOOP;
    -- v_PTNTBICAO_Tremocoi_24 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ - Trẻ mồ côi cha hoặc mẹ - 24
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.TREMOCOI,1,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBICAO_Tremocoi_24
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBICAO_Tremocoi_24:=ITEM.v_PTNTBICAO_Tremocoi_24;
		END LOOP;
    -- v_PTNTBICAO_Bomelyhon_25 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ - Bố mẹ ly hôn - 25
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.BOMELYHON,1,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBICAO_Bomelyhon_25
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBICAO_Bomelyhon_25:=ITEM.v_PTNTBICAO_Bomelyhon_25;
		END LOOP;
    -- v_PTNTBICAO_Trebohoc_26 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ - Trẻ bỏ học - 26
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.TREBOHOC,1,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBICAO_Trebohoc_26
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBICAO_Trebohoc_26:=ITEM.v_PTNTBICAO_Trebohoc_26;
		END LOOP;
    -- v_PTNTBICAO_Trelangthang_27 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ - Trẻ lang thang - 27
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.TRELANGTHANG,1,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBICAO_Trelangthang_27
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBICAO_Trelangthang_27:=ITEM.v_PTNTBICAO_Trelangthang_27;
		END LOOP;
    -- v_PTNTBICAO_Coxuigiuc_28 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ - Có người đủ 18 tuổi trở lên xúi giục - 28
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.CONGUOIXUIGIUC,1,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBICAO_Coxuigiuc_28
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBICAO_Coxuigiuc_28:=ITEM.v_PTNTBICAO_Coxuigiuc_28;
		END LOOP;
    -- v_PTNTBIHAI_Tttl16tuoi_29 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Dưới 16 tuổi bị tổn thương nghiêm trọng về tâm lý - 29
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.LOAITREVITHANHNIEN,2,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBIHAI_Tttl16tuoi_29
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 ON T1.v_VUANID=T2.VUANID and T2.LOAITREVITHANHNIEN=2
        inner join AHS_NGUOITHAMGIATOTUNG_TUCACH T4 on T4.NGUOIID=T2.ID
        inner join DM_DATAITEM T3 on T3.ID=T4.TUCACHID and T3.MA='TGTTHS_01'-- Bị Hại
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBIHAI_Tttl16tuoi_29:=ITEM.v_PTNTBIHAI_Tttl16tuoi_29;
		END LOOP;
    -- v_PTNTBIHAI_Tttl18tuoi_30 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Từ đủ 16 đến dưới 18 tuổi bị tổn thương nghiêm trọng về tâm lý - 30
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
          decode(T2.LOAITREVITHANHNIEN,4,'X','')
          ,''
          ) within group (order by T1.v_STT) v_PTNTBIHAI_Tttl18tuoi_30
			FROM 
				TABLE(v_ARRAY) T1
				INNER JOIN AHS_NGUOITHAMGIATOTUNG T2 ON T1.v_VUANID=T2.VUANID and T2.LOAITREVITHANHNIEN=4
        inner join AHS_NGUOITHAMGIATOTUNG_TUCACH T4 on T4.NGUOIID=T2.ID
        inner join DM_DATAITEM T3 on T3.ID=T4.TUCACHID and T3.MA='TGTTHS_01'-- Bị Hại
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_PTNTBIHAI_Tttl18tuoi_30:=ITEM.v_PTNTBIHAI_Tttl18tuoi_30;
		END LOOP;
    -- v_KC_31 - KHÁNG CÁO -- Ngày, tháng, năm - 31
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
                TO_CHAR(T2.NGAYKHANGCAO,'dd/MM/yyyy')
                , CHR(10)
                ) within group (order by T1.v_STT) v_KC_31
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_KHANGCAO T2 ON T1.v_VUANID=T2.VUANID
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KC_31:=ITEM.v_KC_31;
		END LOOP;
    -- v_KN_32 - KHÁNG NGHỊ  -- Số, ngày, tháng, năm - 32
		FOR ITEM IN (
			SELECT 
				T1.v_STT,
        LISTAGG(
                T2.SOKN || CHR(10) ||
                TO_CHAR(T2.NGAYKN,'dd/MM/yyyy')
        ,CHR(10)
        ) within group (order by T1.v_STT) v_KN_32
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_KHANGNGHI T2 ON T1.v_VUANID=T2.VUANID
        GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_KN_32:=ITEM.v_KN_32;
		END LOOP;
    -- v_CHUYENHS_TA_PT_33 - CHUYỂN HỒ SƠ CHO TÒA PHÚC THẨM -- Ngày, tháng, năm - 33
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					TO_CHAR(T2.NGAYGIAO,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT)  v_CHUYENHS_TA_PT_33
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_CHUYEN_NHAN_AN T2 ON T1.v_VUANID=T2.VUANID
			GROUP BY T1.v_STT				
		) LOOP
			v_ARRAY(ITEM.v_STT).v_CHUYENHS_TA_PT_33:=ITEM.v_CHUYENHS_TA_PT_33;
		END LOOP;
    -- v_QD_TA_PT_34 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM -- Số, ngày, tháng, năm -- Tóm tắt phần quyết định - 34

    -- v_APDUNGANLE_35 - ÁP DỤNG ÁN LỆ  -- (Án lệ số) - 35

    -- v_GHICHU_36 - GHI CHÚ - 36
    FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.GHICHU v_GHICHU_36
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_SOTHAM_THULY T2 ON T1.v_THULYID=T2.ID
		) LOOP
			v_ARRAY(ITEM.v_STT).v_GHICHU_36:=ITEM.v_GHICHU_36;
		END LOOP;
	END;

	/*17 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ PHÚC THẨM*/
	PROCEDURE FILL_HINHSU_PHUCTHAM
	(
		v_ARRAY IN OUT T_HINHSU_PHUCTHAM
	) AS
        VV_HOTENBICAO_3 CLOB; VV_HOTEN_5 CLOB; VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 CLOB; VV_KC_7 CLOB; VV_KN_8 CLOB; VV_APDUNGANLE_21 CLOB;
	BEGIN	
		--v_ARRAY:=T_HINHSU_PHUCTHAM();
		-- v_TL_1 - THỤ LÝ HỒ SƠ Số, ngày tháng năm - 1
        FOR ITEM IN (
                SELECT 
                    T1.v_STT, 
                    T2.SOTHULY|| CHR(10) ||TO_CHAR(T2.NGAYTHULY,'DD/MM/YYYY') v_TL_1
                FROM 
                    TABLE(v_ARRAY) T1 
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
            ) LOOP
                v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;
            END LOOP;
        --V_NGAYTHULY
        FOR ITEM IN ( 
                SELECT T1.v_STT, T2.NGAYTHULY  V_NGAYTHULY,T2.SOTHULY V_SOTHULY
                FROM TABLE(v_ARRAY) T1 
                    INNER JOIN AHS_PHUCTHAM_THULY T2 ON T1.v_THULYID=T2.ID
            ) LOOP
                v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
            END LOOP;
            -- v_BA_QDST_2 - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM -- Số, ngày, tháng, năm  -- Tòa án cấp sơ thẩm đã giải quyết - 2
            FOR ITEM IN (
                SELECT T1.v_STT, LISTAGG(cast( T2.SOBANAN || CHR(10) || TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') || CHR(10) || T3.TEN as varchar2(4000)) , CHR(10) ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDST_2
                FROM TABLE(v_ARRAY) T1
                     LEFT JOIN AHS_SOTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
                     LEFT JOIN DM_TOAAN T3 on T3.ID=T2.TOAANID
                GROUP BY T1.v_STT
                ) LOOP
                v_ARRAY(ITEM.v_STT).v_BA_QDST_2:=ITEM.v_BA_QDST_2;
            END LOOP;

        -- v_HOTENBICAO_3 - HỌ TÊN BỊ CÁO Năm sinh, nơi cư trú, nghề nghiệp - 3                
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
            FROM TABLE(v_ARRAY) T1 
            GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
            FOR ITEMS IN (SELECT ('- ' || T2.HOTEN || '; ' || DECODE(T2.NAMSINH,0,' ',T2.NAMSINH ||'; ')
                                  || DECODE(NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET),'','',NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET)||'; ')
                                || DECODE(NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET),'','', 'Nơi cư trú: ' || NVL(T2.KHTTCHITIET,T2.TAMTRUCHITIET)||'; ')
                                || DECODE(T4.TEN,'','',T4.TEN ||'; ') ) AS VV_HOTENBICAO
                FROM AHS_BICANBICAO T2
                    LEFT JOIN DM_DATAITEM T4 ON T4.ID = T2.NGHENGHIEPID AND T4.GROUPID=22--NGHỀ NGHIỆP 
                WHERE T2.VUANID = ITEM.v_VUANID
                )
            LOOP
                VV_HOTENBICAO_3 := VV_HOTENBICAO_3 || ITEMS.VV_HOTENBICAO;
            END LOOP;

            v_ARRAY(ITEM.v_STT).v_HOTENBICAO_3:=VV_HOTENBICAO_3;
            VV_HOTENBICAO_3 := '';
        END LOOP;

    -- v_THOIHANTAMGIAM_4 - THỜI HẠN TẠM GIAM -- (Nguyên nhân vi phạm nếu có) - 4
		for item in
    (
      SELECT 
				T1.v_STT,
        LISTAGG(
                cast(
                '- '||T2.HOTEN||' '||CAST(T3.HIEULUCDEN-T3.HIEULUCTU as varchar(50))||' ngày;'
                as varchar2(4000))
          , CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_THOIHANTAMGIAM_4
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN AHS_BICANBICAO T2 ON T1.v_VUANID=T2.VUANID
				INNER JOIN AHS_PHUCTHAM_QUYETDINH_BICAN T3 ON T3.BICANID=T2.ID
        inner join DM_QD_LOAI T4 on T3.LOAIQDID=T4.ID and T4.MA='BTG'
        where T3.HIEULUCDEN-T3.HIEULUCTU>0
        GROUP BY T1.v_STT
    ) loop
    v_ARRAY(ITEM.v_STT).v_THOIHANTAMGIAM_4:=ITEM.v_THOIHANTAMGIAM_4;
		END LOOP;
        
    -- v_HOTEN_5 - HỌ TÊN --  NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Năm sinh, nơi cư trú - 5       
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
            FROM TABLE(v_ARRAY) T1 
            GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
            FOR ITEMS IN (SELECT ('- '||T2.HOTEN || '; ' ||case when T2.NAMSINH = 0 then ' ' else ' ' || T2.NAMSINH ||'; ' end ||nvl2(T2.DIACHICHITIET,'',T2.DIACHICHITIET || '; ')) AS VV_HOTEN
                FROM AHS_NGUOITHAMGIATOTUNG T2
                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                    INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_01,TGTTHS_03,TGTTHS_04,TGTTHS_05,TGTTHS_08',T4.MA)>0
                WHERE T2.VUANID = ITEM.v_VUANID AND T2.ISPHUCTHAM=1
                )
            LOOP
                VV_HOTEN_5 := VV_HOTEN_5 || ITEMS.VV_HOTEN;
            END LOOP;

			v_ARRAY(ITEM.v_STT).v_HOTEN_5:=VV_HOTEN_5;
            VV_HOTEN_5 := '';
        END LOOP;
        
    -- v_NGUOIBC_NGUOIBV_QLIHP_DS_6 - NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ  -- Họ tên, địa chỉ hoặc đơn vị hành nghề - 6    
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
            FROM TABLE(v_ARRAY) T1 
            GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
            FOR ITEMS IN (SELECT ('- '||T2.HOTEN || '; ' ||nvl2(T2.DIACHICHITIET,T2.DIACHICHITIET || '; ','') ) AS VV_NGUOIBC_NGUOIBV_QLIHP_DS
                FROM AHS_NGUOITHAMGIATOTUNG T2
                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH T3 on T3.NGUOIID=T2.ID
                    INNER JOIN DM_DATAITEM T4 on T4.ID=T3.TUCACHID and INSTR('TGTTHS_06,TGTTHS_10',T4.MA)>0
                WHERE T2.VUANID = ITEM.v_VUANID AND T2.ISPHUCTHAM=1
                )
            LOOP
                VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 || ITEMS.VV_NGUOIBC_NGUOIBV_QLIHP_DS;
            END LOOP;

			v_ARRAY(ITEM.v_STT).v_NGUOIBC_NGUOIBV_QLIHP_DS_6:=VV_NGUOIBC_NGUOIBV_QLIHP_DS_6;
            VV_NGUOIBC_NGUOIBV_QLIHP_DS_6 := '';
        END LOOP;
        
    -- v_KC_7 - KHÁNG CÁO -- Người kháng cáo; ngày, tháng, năm và nội dung kháng cáo - 7
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
            FROM TABLE(v_ARRAY) T1 
            GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
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
        END LOOP;
        
    -- v_KN_8 - KHÁNG NGHỊ -- Số, ngày, tháng, năm và nội dung kháng nghị - 8
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
            FROM TABLE(v_ARRAY) T1 
            GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
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
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
          cast(
            T2.SOQUYETDINH || CHR(10) ||
            TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) ||
            T4.TEN
          as varchar2(4000))
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_TDC_9
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='TDC'
        inner join DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_TDC_9:=ITEM.v_TDC_9;
		END LOOP;
    -- v_QD_DC_RUT_KC_10 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - RÚT KHÁNG CÁO  -- Ngày, tháng, năm -- (Xác định việc rút kháng cáo trước khi mở phiên tòa hay tại phiên tòa) - 10
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) ||
          decode(T4.MA,'RUT_KC_TRUOC_MOPT','Rút kháng cáo trước khi mở phiên tòa','Rút kháng cáo tại phiên tòa')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_RUT_KC_10
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
        inner join DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and instr('RUT_KC_TAI_PHIENTOA,RUT_KC_TRUOC_MOPT',T4.MA)>0
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_DC_RUT_KC_10:=ITEM.v_QD_DC_RUT_KC_10;
		END LOOP;
    -- v_QD_DC_RUT_KN_11 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - RÚT KHÁNG NGHỊ  -- Ngày, tháng, năm -- (Xác định việc rút kháng cáo trước khi mở phiên tòa hay tại phiên tòa) - 11
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY') || CHR(10) || 
          decode(T4.MA,'RUT_KN_TRUOC_MOPT','Rút kháng nghị trước khi mở phiên tòa','Rút kháng nghị tại phiên tòa')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_RUT_KN_11
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
        inner join DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and instr('RUT_KN_TAI_PHIENTOA,RUT_KN_TRUOC_MOPT',T4.MA)>0
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_DC_RUT_KN_11:=ITEM.v_QD_DC_RUT_KN_11;
		END LOOP;
    -- v_QD_DC_LYDOKHAC_12 - QUYẾT ĐỊNH  -- ĐÌNH CHỈ - LÝ DO KHÁC -- Ngày, tháng, năm - 12
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					TO_CHAR(T2.NGAYQD,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_DC_LYDOKHAC_12
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN T2 ON T1.v_VUANID=T2.VUANID 
        inner join DM_QD_LOAI T3 on T3.ID=T2.LOAIQDID and T3.MA='DC'
        inner join DM_QD_QUYETDINH_LYDO T4 on T2.LYDOID=T4.ID and T4.MA='KHAC'
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_QD_DC_LYDOKHAC_12:=ITEM.v_QD_DC_LYDOKHAC_12;
		END LOOP;
    -- v_XX_NGUOITIENHANHTOTUNG_13 - XÉT XỬ - NHỮNG NGƯỜI TIẾN HÀNH --  TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên - 13
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					CAST(
						'- ' || NVL(T3.HOTEN,'')||NVL(T4.HOTEN,'')||
						' ('||DECODE(T2.MAVAITRO,'HTND','HTND','KSV','KSV','THAMPHAN','TPCT','THAMPHANDUKHUYET','TPDK','THAMPHANHDXX','TPTV','THUKY','TK','THUKYDUKHUYET','TKDK','')||')'
						AS VARCHAR2(4000)
					), CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_NGUOITIENHANHTOTUNG_13
			FROM 
				TABLE(v_ARRAY) T1
        inner join AHS_PHUCTHAM_HDXX T2 on T1.v_VUANID=T2.VUANID
				LEFT JOIN DM_CANBO T3 ON T3.ID=T2.CANBOID AND INSTR('THAMPHAN,THAMPHANHDXX,THAMPHANDUKHUYET,THUKY,THUKYDUKHUYET',T2.MAVAITRO)>0
				LEFT JOIN DM_CANBOVKS T4 ON T4.ID=T2.CANBOID AND INSTR('HTND,KSV',T2.MAVAITRO)>0
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_NGUOITIENHANHTOTUNG_13:=ITEM.v_XX_NGUOITIENHANHTOTUNG_13;
		END LOOP;
    -- v_XX_BA_PT_14 - XÉT XỬ - BẢN ÁN PHÚC THẨM  -- Số, ngày, tháng, năm - 14
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				LISTAGG(
					TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY')
					, CHR(10)
				) WITHIN GROUP (ORDER BY T1.v_STT) v_XX_BA_PT_14
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID 
			GROUP BY T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_BA_PT_14:=ITEM.v_XX_BA_PT_14;
		END LOOP;
    -- v_XX_QD_BA_PT_15 - XÉT XỬ - QUYẾT ĐỊNH CỦA BẢN ÁN PHÚC THẨM -- Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung - 15
		FOR ITEM IN (
			SELECT
        T1.v_STT,
        cast(T6.ToiDanh || '; ' || T10.HinhPhat as varchar2(4000)) v_XX_QD_BA_PT_15
			FROM 
				TABLE(v_ARRAY) T1
        INNER JOIN (select T11.VUANID,
                      LISTAGG(
                                cast(T11.ToiDanh as varchar2(4000))
                                , CHR(10)
                                ) WITHIN GROUP (ORDER BY T11.VUANID) ToiDanh
                    from (
                          select distinct T2.VUANID,
                              'Điều '||T4.DIEU||' '|| NVL(T3.TENTOIDANH,T4.TENTOIDANH) ToiDanh
                          from AHS_BICANBICAO T2
                          INNER JOIN AHS_PHUCTHAM_BANAN_DIEU_CT T3 ON T3.BICANID=T2.ID
                          inner join DM_BOLUAT_TOIDANH T4 on t4.ID=T3.TOIDANHID and T4.LOAI=2 and T4.HIEULUC=1
                          where T2.BICANDAUVU=1
                          )T11
                          group by T11.VUANID
                    )T6 on T6.VUANID=T1.v_VUANID
        inner join (
                     select T9.VUANID,
                        LISTAGG(
                                cast(T7.TENHINHPHAT as varchar2(4000))
                                , '; '
                                ) WITHIN GROUP (ORDER BY T9.VUANID) HinhPhat
                     from AHS_BICANBICAO T9
                     INNER JOIN AHS_PHUCTHAM_BANAN_DIEU_CT T8 ON T8.BICANID=T9.ID
                     left join DM_HINHPHAT T7 on T8.HINHPHATID=T7.ID --and instr('MIENHINHPHAT,GIAODUCTGD,MIENTNHS',T7.MAHINHPHAT)>0
                     where T9.BICANDAUVU=1
                     group by T9.VUANID
                    ) T10 on T10.VUANID=T1.v_VUANID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_QD_BA_PT_15:=ITEM.v_XX_QD_BA_PT_15;
		END LOOP;
    -- v_XX_LYDO_SH_STSAI_16 - XÉT XỬ - LÝ DO SỬA, HỦY - Do cấp sơ thẩm sai - 16
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_XX_LYDO_SH_STSAI_16
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISAHS=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do cấp sơ thẩm sai',lower(T4.TEN))>0 --Do cấp sơ thẩm sai
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_LYDO_SH_STSAI_16:=ITEM.v_XX_LYDO_SH_STSAI_16;
		END LOOP;
    -- v_XX_LYDO_SH_TTM_17 - XÉT XỬ - LÝ DO SỬA, HỦY - Do có tình tiết mới - 17
		FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				DECODE(SIGN(COUNT(T4.ID)),1,'X','') v_XX_LYDO_SH_TTM_17
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
				INNER JOIN DM_KETQUA_PHUCTHAM T3 ON T2.KETQUAPHUCTHAMID=T3.ID AND INSTR('02,03,04,05,06,13,14',T3.MA)>0 and T3.ISAHS=1 --SỬA,HỦY
				INNER JOIN DM_KETQUA_PHUCTHAM_LYDO T4 ON T2.LYDOBANANID=T4.ID AND INSTR('do có tình tiết mới',lower(T4.TEN))>0 --Do có tình tiết mới
        group by T1.v_STT
		) LOOP
			v_ARRAY(ITEM.v_STT).v_XX_LYDO_SH_TTM_17:=ITEM.v_XX_LYDO_SH_TTM_17;
		END LOOP;
    -- v_XX_SOBCTACHAPNHANKN_VKS_18 - XÉT XỬ - SỐ BỊ CÁO TÒA ÁN CHẤP NHẬN KHÁNG NGHỊ CỦA VIỆN KIỂM SÁT - 18
		for item in(
      select 
        T1.v_STT,
        replace(to_char(T2.SBC_CHAPNHAN_TOANBO,'999,999,999,999,999,999'),',','.') v_XX_SOBCTACHAPNHANKN_VKS_18
      from TABLE(v_ARRAY) T1
      inner join AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
    ) loop
    v_ARRAY(ITEM.v_STT).v_XX_SOBCTACHAPNHANKN_VKS_18:=ITEM.v_XX_SOBCTACHAPNHANKN_VKS_18;
    end loop;
    -- v_XX_KHOITOVATAIPHIENTOA_19 - XÉT XỬ - KHỞI TỐ VỤ ÁN TẠI PHIÊN TÒA -- Số, ngày, tháng, năm - 19
		for item in(
      select 
        T1.v_STT,
        LISTAGG(
          T2.SOBANAN || CHR(10) ||
          to_char(T2.NGAYBANAN,'dd/MM/yyyy')
          ) within group (order by T1.v_STT) v_XX_KHOITOVATAIPHIENTOA_19
      from TABLE(v_ARRAY) T1
      inner join AHS_PHUCTHAM_BANAN T2 ON T1.v_VUANID=T2.VUANID
      group by T1.v_STT
    ) loop
    v_ARRAY(ITEM.v_STT).v_XX_KHOITOVATAIPHIENTOA_19:=ITEM.v_XX_KHOITOVATAIPHIENTOA_19;
    end loop;
    -- v_QD_GDTTT_20 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM -- Số, ngày, tháng, năm - 20
    
    -- v_APDUNGANLE_21 - ÁP DỤNG ÁN LỆ  -- Số án lệ - 21
        FOR ITEM IN (SELECT T1.v_STT, T1.v_VUANID
        FROM TABLE(v_ARRAY) T1 
        GROUP BY T1.v_STT, T1.v_VUANID
        ) 
        LOOP
            FOR ITEMS IN (SELECT ('- ') AS VV_APDUNGANLE
                FROM AHS_PHUCTHAM_BANAN T2
                WHERE T2.VUANID = ITEM.v_VUANID AND T2.ISANLE = 1
                )
            LOOP
                VV_APDUNGANLE_21 := VV_APDUNGANLE_21 || ITEMS.VV_APDUNGANLE;
            END LOOP;

			v_ARRAY(ITEM.v_STT).v_APDUNGANLE_21:=VV_APDUNGANLE_21;
            VV_APDUNGANLE_21 := '';
        END LOOP;
    -- v_GHICHU_22 - GHI CHÚ - 22
	END;

	/*18 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ GIÁM ĐỐC THẨM, TÁI THẨM*/
	PROCEDURE FILL_HINHSU_GDTTT
	(
		v_ARRAY IN OUT T_HINHSU_GDTTT
	) AS
	BEGIN	
		
		-- v_TL_1 - THỤ LÝ HỒ SƠ Số, ngày tháng năm - 1
        FOR ITEM IN (
			SELECT 
				T1.v_STT, 
				T2.SOTHULYXXGDT || CHR(10) || TO_CHAR(T2.NGAYTHULYXXGDT,'DD/MM/YYYY') v_TL_1,
                T2.NGAYTHULYXXGDT V_NGAYTHULY,T2.SOTHULYXXGDT V_SOTHULY 
			FROM 
				TABLE(v_ARRAY) T1 
				INNER JOIN GDTTT_VUAN T2 ON T1.v_VUANID=T2.ID

		) LOOP
			v_ARRAY(ITEM.v_STT).v_TL_1:=ITEM.v_TL_1;		
            v_ARRAY(ITEM.v_STT).V_NGAYTHULY:=ITEM.V_NGAYTHULY;v_ARRAY(ITEM.v_STT).V_SOTHULY:=ITEM.V_SOTHULY;
		END LOOP;
		-- v_BA_QDBIKN_2 - BẢN ÁN, QUYẾT ĐỊNH BỊ KHÁNG NGHỊ -- Số, ngày, tháng, năm; Điều luật; Tội danh; Hình phạt và Tòa án đã giải quyết - 2
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(
                        CAST(
                            DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) || CHR(10) ||
                            DECODE(v.BAQD_CAPXETXU,4,V.GDT_TEN,2,V.ST_TEN,V.PT_TEN) 
                            AS VARCHAR2(4000)
                        ), CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BA_QDBIKN_2
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT V1.*,txx.Ma_Ten PT_TEN,tst.Ma_Ten ST_TEN,tqd.Ma_Ten GDT_TEN  FROM GDTTT_VUAN V1
                                        left join (select ID, Ma_Ten from DM_TOAAN) txx on V1.TOAPHUCTHAMID=txx.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tst on V1.TOAANSOTHAM=tst.ID
                                        left join (select ID, Ma_Ten from DM_TOAAN) tqd on V1.TOAQDID=tqd.ID) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BA_QDBIKN_2:=ITEM.v_BA_QDBIKN_2;
        end loop;		
        -- v_BICAOBIKN_3 - HỌ TÊN BỊ CÁO BỊ KHÁNG NGHỊ -- Năm sinh, nơi cư trú - 3
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.BICAO, CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_BICAOBIKN_3
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(HSKN.BICAO,NULL,v1.BIDON,HSKN.BICAO) BICAO  FROM GDTTT_VUAN V1
                                         LEFT JOIN (SELECT  DS.VUANID, LISTAGG(DS.TENDUONGSU ||DECODE(NVL(DS.NAMSINH,0),0,null,' NS:'||DS.NAMSINH) ||  DECODE(DS.DIACHI,NUll,'', ' Đc:'|| DS.DIACHI), '; ') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                                            FROM GDTTT_VUAN_DUONGSU DS
                                                            LEFT JOIN DM_HANHCHINH DC ON DS.HUYENID = DC.ID
                                                            WHERE DS.HS_BICANDAUVU = 1 OR DS.HS_ISBICAO =1
                                                            GROUP BY DS.VUANID
                                                        )HSKN ON HSKN.VUANID=V1.ID                    
                                                    ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_BICAOBIKN_3:=ITEM.v_BICAOBIKN_3;
        end loop;        
		-- v_THOIHANTAMGIAM_4 - THỜI HẠN TẠM GIAM - 4
--         for Item in(
--          select 
--            T1.v_STT,
--            LISTAGG(v.HS_MUCAN, CHR(10)
--                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_THOIHANTAMGIAM_4
--          from
--            table(v_ARRAY) T1
--            INNER JOIN (SELECT v1.id, HSKN.HS_MUCAN FROM GDTTT_VUAN V1
--                                         LEFT JOIN (SELECT  KN.VUANID, LISTAGG(DECODE(DS.HS_MUCAN,NULL,null,DS.HS_MUCAN), '<br/>') WITHIN GROUP (ORDER BY DS.HS_MUCAN  DESC)  HS_MUCAN
--                                                            FROM GDTTT_VUAN_DS_KN KN
--                                                            LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID                                                           
--                                                            WHERE DS.HS_MUCAN IS NOT NULL
--                                                            GROUP BY KN.VUANID
--                                                        )HSKN ON HSKN.VUANID=V1.ID                    
--                                                    ) V ON T1.v_VUANID=V.ID 
--            group by T1.v_STT 
--        ) loop
--          v_ARRAY(ITEM.v_STT).v_THOIHANTAMGIAM_4:=ITEM.v_THOIHANTAMGIAM_4;
--        end loop; 
        
		-- v_TAINGOAI_5 - TẠI NGOẠI - 5
--        for Item in(
--          select 
--            T1.v_STT,
--            LISTAGG(v.HS_MUCAN, CHR(10)
--                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_TAINGOAI_5
--          from
--            table(v_ARRAY) T1
--            INNER JOIN (SELECT v1.id, HSKN.HS_MUCAN  FROM GDTTT_VUAN V1
--                                         LEFT JOIN (SELECT  KN.VUANID, LISTAGG(DECODE(NVL(DS.HS_MUCAN,''),'','x',NULL), '<br/>') WITHIN GROUP (ORDER BY DS.HS_MUCAN  DESC)  HS_MUCAN
--                                                            FROM GDTTT_VUAN_DS_KN KN
--                                                            LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID                                                           
--                                                            WHERE DS.HS_MUCAN IS NULL
--                                                            AND (DS.HS_BICANDAUVU = 1 OR DS.HS_ISBICAO = 1)
--                                                            GROUP BY KN.VUANID
--                                                        )HSKN ON HSKN.VUANID=V1.ID                    
--                                                    ) V ON T1.v_VUANID=V.ID 
--            group by T1.v_STT 
--        ) loop
--          v_ARRAY(ITEM.v_STT).v_TAINGOAI_5:=ITEM.v_TAINGOAI_5;
--        end loop; 
        
		-- v_NGUOITHAMGIATOTUNG_6 - HỌ TÊN --  NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Năm sinh, nơi cư trú - 6
        -- v_CHANHANKN_7 - CHÁNH ÁN KHÁNG NGHỊ --  Số, ngày, tháng, năm -- Tóm tắt nội dung - 7
       for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANKN_7
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, decode(NVL(v1.IsVienTruongKN,0),1,'CA TANDTC ',NUll) 
                                        || DECODE(v1.VIENTRUONGKN_NGUOIKY
                                            , 818,decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy'))
                                            ,(decode(NVL(v1.GDQ_SO,''),'','','Số '||v1.GDQ_SO) || decode(v1.GDQ_NGAY,Null,null,' Ngày '||to_char(v1.GDQ_NGAY,'dd/MM/yyyy'))
                                            )
                                        ) inforSoKN  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        ) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANKN_7:=ITEM.v_CHANHANKN_7;
        end loop;
        
        -- v_VIENTRUONGKN_8 - VIỆN TRƯỞNG KHÁNG NGHỊ -- Số, ngày, tháng, năm  -- Tóm tắt nội dung - 8
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforSoKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGKN_8
          from
            table(v_ARRAY) T1
             INNER JOIN (SELECT v1.id, (DECODE(v1.VIENTRUONGKN_NGUOIKY,1,'VKS Tối Cao',4,'VKSCC Hà Nội',5,'VKSCC Đà Nẵng',6,'VKSCC HCM') || decode(NVL(v1.VIENTRUONGKN_SO,''),'','',' số '||v1.VIENTRUONGKN_SO) || decode(v1.VIENTRUONGKN_NGAY,Null,null,' Ngày '||to_char(v1.VIENTRUONGKN_NGAY,'dd/MM/yyyy')))  inforSoKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsVienTruongKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGKN_8:=ITEM.v_VIENTRUONGKN_8;
        end loop;
        
		-- v_CHANHANRUT_KN_9 - CHÁNH ÁN RÚT KHÁNG NGHỊ -- Số, ngày, tháng, năm; - 9
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNCA , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_CHANHANRUT_KN_9
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNCA  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and (NVL(v1.IsVienTruongKN,0) = 0
                                                or (NVL(v1.IsVienTruongKN,0) = 1 and v1.VIENTRUONGKN_NGUOIKY = 818))
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_CHANHANRUT_KN_9:=ITEM.v_CHANHANRUT_KN_9;
        end loop;  
        
		-- v_VIENTRUONGRUT_KN_10 - VIỆN TRƯỞNG RÚT KHÁNG NGHỊ  -- Số, ngày, tháng, năm - 10
      for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.inforRutKNVKS , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_VIENTRUONGRUT_KN_10
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(NVL(v1.SORUTKN,''),'','',' số '||v1.SORUTKN) || decode(v1.NGAYRUTKN,Null,null,' '||to_char(v1.NGAYRUTKN,'dd/MM/yyyy')))  inforRutKNVKS  
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.IsVienTruongKN,0) = 1
                                         and v1.VIENTRUONGKN_NGUOIKY != 818
                                        and NVL(v1.IsRutKN,0) = 1) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_VIENTRUONGRUT_KN_10:=ITEM.v_VIENTRUONGRUT_KN_10;
        end loop;        
		-- v_NGUOITIENHANHTOTUNG_11 - NGƯỜI TIẾN HÀNH --  TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên - 11
		for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.THAMPHAN , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_NGUOITIENHANHTOTUNG_11
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, HDXX.THAMPHAN, DECODE(ttv.hoten,NULL,null,'Thư ký phiên tòa:'||ttv.hoten) TENTHAMTRAVIENXX  FROM GDTTT_VUAN V1
                                        LEFT JOIN (SELECT  HD.VUANID,LISTAGG(DECODE(HD.ISCHUTOA,1,'Thẩm phán CT:','Thẩm phán:')||HD.TENCANBO , '; ') WITHIN GROUP (ORDER BY HD.ISCHUTOA  DESC)  THAMPHAN
                                                                    FROM GDTTT_VUAN_XXGDTT_HOIDONG HD
                                                                    GROUP BY HD.VUANID
                                                            )HDXX ON HDXX.VUANID=V1.ID
                                        LEFT JOIN DM_CANBO ttv on v1.XXGDT_THAMTRAVIENID=ttv.ID
                            ) V ON T1.v_VUANID=V.ID 
                                        
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_NGUOITIENHANHTOTUNG_11:=ITEM.v_NGUOITIENHANHTOTUNG_11;
        end loop;
        -- v_QD_GDTTT_12 - QUYẾT ĐỊNH GIÁM ĐỐC THẨM, TÁI THẨM  -- Số, ngày, tháng, năm - 12
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.ThongTinKQ_XXGDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_GDTTT_12
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, (DECODE(v1.XXGDTTT_SOQD,NULL,null,'Số '||v1.XXGDTTT_SOQD) 
                                            ||  (case when (Length(NVL(v1.XXGDTTT_NGAYQD,''))=0 or (to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                         when Length(NVL(v1.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v1.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                    end)
                                             
                                            ) as ThongTinKQ_XXGDTTT 
                                        FROM GDTTT_VUAN V1
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_GDTTT_12:=ITEM.v_QD_GDTTT_12;
        end loop;
		-- v_QD_HD_GDTTT_13 - QUYẾT ĐỊNH CỦA HỘI ĐỒNG GIÁM ĐỐC THẨM, TÁI THẨM -- Tóm tắt nội dung - 13
        for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_QD_HD_GDTTT_13
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, NVL(kq.Ten,' ') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join DM_DAtaItem kq on kq.ID = v1.XXGDTTT_KETQUAID
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_QD_HD_GDTTT_13:=ITEM.v_QD_HD_GDTTT_13;
        end loop;
		-- v_LYDO_14 - LÝ DO  -- Rút kháng nghị hoặc hủy, sửa - 14
		-- v_APDUNGANLE_15 - ÁP DỤNG ÁN LỆ -- Số án lệ - 15
         for Item in(
          select 
            T1.v_STT,
            LISTAGG(v.QD_HD_GDTTT , CHR(10)
                    ) WITHIN GROUP (ORDER BY T1.v_STT) v_APDUNGANLE_15
          from
            table(v_ARRAY) T1
            INNER JOIN (SELECT v1.id, DECODE(tk_al.GIATRI_TK,1,tk_al.NOIDUNG_TK,'') as QD_HD_GDTTT 
                                        FROM GDTTT_VUAN V1
                                        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v1.ID and tk_al.TYPE_TK = 'ADAL'
                                        WHERE V1.GQD_LOAIKETQUA = 1
                                        and NVL(v1.XXGDTTT_ISKETQUA,0)>0) V ON T1.v_VUANID=V.ID 
            group by T1.v_STT 
        ) loop
          v_ARRAY(ITEM.v_STT).v_APDUNGANLE_15:=ITEM.v_APDUNGANLE_15;
        end loop;
		-- v_GHICHU_16 - GHI CHÚ - 16
	END;

	/*19 - SỔ THEO DÕI SỐ BẢN ÁN, QUYẾT ĐỊNH VỀ HÌNH SỰ*/
	PROCEDURE FILL_HINHSU_BAQD
	(
		v_ARRAY IN OUT T_HINHSU_BAQD
	) AS
	BEGIN	
		v_ARRAY:=T_HINHSU_BAQD();
		-- v_STT_1 - STT - 1 - 
		-- v_SOTLVA_2 - SỐ THỤ LÝ HỒ SƠ VỤ ÁN -- Ngày, tháng, năm - 2 - 
		-- v_TENHOSOVA_3 - TÊN HỒ SƠ VỤ ÁN - 3 - 
		-- v_SOQD_DUAVARAXX_4 - SỐ QUYẾT ĐỊNH ĐƯA VỤ ÁN RA XÉT XỬ  -- Ngày, tháng, năm - 4 - 
		-- v_SOBA_5 - SỐ BẢN ÁN  -- Ngày, tháng, năm - 5 - 
		-- v_SOQD_TDC_6 - SỐ QUYẾT ĐỊNH TẠM ĐÌNH CHỈ  -- Ngày, tháng, năm - 6 - 
		-- v_SOQD_DC_7 - SỐ QUYẾT ĐỊNH ĐÌNH CHỈ  -- Ngày, tháng, năm - 7 - 
		-- v_SOQD_TRAHOSO_DTBS_8 - SỐ QUYẾT ĐỊNH TRẢ HỒ SƠ ĐIỀU TRA BỔ SUNG  -- Ngày, tháng, năm - 8 - 
		-- v_SOQD_CHUYENHS_VA_9 - SỐ QUYẾT ĐỊNH CHUYỂN HỒ SƠ VỤ ÁN  -- Ngày, tháng, năm - 9 - 
		-- v_CACQDKHAC_So_10 - CÁC QUYẾT ĐỊNH KHÁC - Số, ngày, tháng, năm - 10 - 
		-- v_CACQDKHAC_Ten_11 - CÁC QUYẾT ĐỊNH KHÁC - Tên quyết định - 11 - 
		-- v_GHICHU_12 - GHI CHÚ - 12 - 
	END;

	/*20 - SỔ THEO DÕI NGƯỜI BỊ KẾT ÁN PHẠT TÙ ĐANG TẠI NGOẠI*/
	PROCEDURE FILL_HINHSU_TAINGOAI
	(
		v_ARRAY IN OUT T_HINHSU_TAINGOAI
	) AS
	BEGIN	
		v_ARRAY:=T_HINHSU_TAINGOAI();
		-- v_BA_QD_COHLPL_1 - BẢN ÁN, QUYẾT ĐỊNH CÓ HIỆU LỰC PHÁP LUẬT -- Số, ngày, tháng, năm và tên Tòa án đã xét xử - 1 - 
		-- v_NGUOIBI_KETAN_2 - HỌ TÊN NGƯỜI BỊ  -- KẾT ÁN -- Năm sinh, nơi cư trú - 2 - 
		-- v_TOIDANH_3 - TỘI DANH - 3 - 
		-- v_HINHPHAT_4 - HÌNH PHẠT - 4 - 
		-- v_QD_THA_PT_5 - QUYẾT ĐỊNH THI HÀNH ÁN -- PHẠT TÙ -- Số, ngày, tháng, năm - 5 - 
		-- v_DABAT_THA_PT_6 - ĐÃ BẮT THI HÀNH ÁN PHẠT TÙ  -- Ngày, tháng, năm - 6 - 
		-- v_HTDC_THAPT_QDHOAN_7 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - QUYẾT ĐỊNH HOÃN THI HÀNH ÁN -- Số, ngày, tháng năm và thời hạn - 7 - 
		-- v_HTDC_THAPT_QDTDC_8 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - QUYẾT ĐỊNH TẠM ĐÌNH CHỈ THI HÀNH ÁN  -- Số, ngày, tháng, năm và thời hạn - 8 - 
		-- v_HTDC_THAPT_LYDOHOAN_9 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - LÝ DO HOÃN, TẠM ĐÌNH CHỈ - 9 - 
		-- v_HTDC_THAPT_KT_HTDC_10 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - THỜI ĐIỂM KẾT THÚC THỜI HẠN HOÃN, TẠM ĐÌNH CHỈ -- Ngày, tháng, năm - 10 - 
		-- v_HTDC_THAPT_QDTIEPTUC_11 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - QUYẾT ĐỊNH TIẾP TỤC THI HÀNH ÁN -- Số, ngày, tháng, năm - 11 - 
		-- v_HTDC_THAPT_DBSK_HTDC_12 - HOÃN VÀ TẠM ĐÌNH CHỈ THI HÀNH ÁN PHẠT TÙ - ĐÃ BẮT SAU KHI HOÃN, TẠM ĐÌNH CHỈ - 12 - 
		-- v_HETTHOIHIEU_THA_13 - HẾT THỜI HIỆU THI HÀNH ÁN - 13 - 
		-- v_QD_MIEN_CHHPT_14 - QUYẾT ĐỊNH MIỄN CHẤP HÀNH HÌNH PHẠT TÙ -- Số, ngày, tháng, năm  --  - 14 - 
		-- v_TRUYNA_QD_15 - TRUY NÃ - QUYẾT ĐỊNH -- Số, ngày, tháng, năm - 15 - 
		-- v_TRUYNA_CHUACOQD_16 - TRUY NÃ - CHƯA CÓ QUYẾT ĐỊNH - 16 - 
		-- v_GHICHU_17 - GHI CHÚ - 17 - 
	END;

	/*21 - SỔ THỤ LÝ VÀ THEO DÕI VIỆC RA QUYẾT ĐỊNH THI HÀNH ÁN HÌNH SỰ*/
	PROCEDURE FILL_HINHSU_QDTHA
	(
		v_ARRAY IN OUT T_HINHSU_QDTHA
	) AS
	BEGIN	
		v_ARRAY:=T_HINHSU_QDTHA();
		-- v_TL_1 - THỤ LÝ -- Số, ngày, tháng, năm - 1
		-- v_BA_QD_COHLPL_2 - BẢN ÁN, QUYẾT ĐỊNH CÓ HIỆU LỰC PHÁP LUẬT  -- Số, ngày, tháng, năm và tên Tòa án xét xử - 2
		-- v_NGUOIBIKETAN_3 - HỌ VÀ TÊN  -- NGƯỜI BỊ KẾT ÁN  -- Năm sinh, nơi cư trú - 3
		-- v_TOIDANH_4 - TỘI DANH - 4
		-- v_HINHPHAT_5 - HÌNH PHẠT - 5
		-- v_CHETTRUOCKHICOQD_THA_6 - CHẾT TRƯỚC KHI CÓ QUYẾT ĐỊNH THI HÀNH ÁN - 6
		-- v_QD_THA_HINHPHATTU_7 - QUYẾT ĐỊNH THI HÀNH ÁN - HÌNH PHẠT TÙ - Số, ngày, tháng, năm - 7
		-- v_QD_THA_HINHPHATKHAC_8 - QUYẾT ĐỊNH THI HÀNH ÁN - HÌNH PHẠT KHÁC - Số, ngày, tháng, năm - 8
		-- v_QD_THA_TUHINH_9 - QUYẾT ĐỊNH THI HÀNH ÁN - TỬ HÌNH - Số, ngày, tháng, năm - 9
		-- v_DA_THA_TUHINH_10 - ĐÃ THI HÀNH ÁN TỬ HÌNH  -- Ngày, tháng, năm - 10
		-- v_CQTCCONHIEMVU_THA_11 - CƠ QUAN, TỔ CHỨC CÓ NHIỆM VỤ THI HÀNH ÁN - 11
		-- v_QDUYTHAC_THA_So_12 - QUYẾT ĐỊNH ỦY THÁC THI HÀNH ÁN - Số, ngày, tháng, năm - 12
		-- v_QDUYTHAC_THA_TA_NHANYT_13 - QUYẾT ĐỊNH ỦY THÁC THI HÀNH ÁN - Tên Tòa án nhận ủy thác - 13
		-- v_QDUYTHAC_THA_KQYT_14 - QUYẾT ĐỊNH ỦY THÁC THI HÀNH ÁN - Kết quả quỷ thác - 14
		-- v_GHICHU_15 - GHI CHÚ - 15
	END;

	/*22 - SỔ THEO DÕI MIỄN, GIẢM THỜI HẠN CHẤP HÀNH HÌNH PHẠT TÙ VÀ MIỄN, GIẢM ÁN PHÍ TIỀN PHẠT*/
	PROCEDURE FILL_HINHSU_MIENGIAM
	(
		v_ARRAY IN OUT T_HINHSU_MIENGIAM
	) AS
	BEGIN	
		v_ARRAY:=T_HINHSU_MIENGIAM();
		-- v_TL - THỤ LÝ -- Số, ngày, tháng, năm - 
		-- v_BA_QD_COHLPL_1 - BẢN ÁN, QUYẾT ĐỊNH CÓ HIỆU LỰC PHÁP LUẬT -- Số, ngày, tháng, năm và tên Tòa án xét xử - 1 - 
		-- v_NGUOIBKA_NGUOIDGAP_2 - HỌ TÊN NGƯỜI BỊ KẾT ÁN HOẶC NGƯỜI ĐƯỢC GIẢM ÁN PHÍ, TIỀN PHẠT -- Năm sinh, nơi cư trú - 2 - 
		-- v_TOIDANH_3 - TỘI DANH - 3 - 
		-- v_HINHPHATTU_4 - HÌNH PHẠT TÙ - 4 - 
		-- v_QD_THA_PT_5 - QUYẾT ĐỊNH THI HÀNH ÁN PHẠT TÙ  -- Số, ngày, tháng, năm và Tòa án ra quyết định --  - 5 - 
		-- v_NOICHHPT_NOICT_6 - NƠI ĐANG CHẤP HÀNH HÌNH PHẠT TÙ HOẶC NƠI ĐANG CƯ TRÚ - 6 - 
		-- v_QDGIAMTHOIHAN_7 - QUYẾT ĐỊNH GIẢM THỜI HẠN -- Số, ngày, tháng, năm - 7 - 
		-- v_MUCGIAM_8 - MỨC GIẢM - 8 - 
		-- v_QD_MIENCHHPT_9 - QUYẾT ĐỊNH MIỄN CHẤP HÀNH HÌNH PHẠT TÙ -- Số, ngày, tháng, năm - 9 - 
		-- v_XOAANTICH_Duongnhien_10 - XÓA ÁN TÍCH - Đương nhiên - 10 - 
		-- v_XOAANTICH_TheoQD_TA_11 - XÓA ÁN TÍCH - Theo quyết định của Tòa án - 11 - 
		-- v_ANPHI_Nghindong_12 - ÁN PHÍ - Nghìn đồng - 12 - 
		-- v_MIENGIAMANPHI_TP_Mien_13 - MIỄN GIẢM ÁN PHÍ, TIỀN PHẠT - Miễn -- (Nghìn đồng) - 13 - 
		-- v_MIENGIAMANPHI_TP_Giam_14 - MIỄN GIẢM ÁN PHÍ, TIỀN PHẠT - Giảm -- (Nghìn đồng) - 14 - 
		-- v_GHICHU_15 - GHI CHÚ - 15 - 
	END;

	/*23 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT CÁC VỤ ÁN HÌNH SỰ SƠ THẨM*/
	PROCEDURE FILL_HINHSU_SOTHAM_2
	(
		v_ARRAY IN OUT T_HINHSU_SOTHAM_2
	) AS
	BEGIN	
		v_ARRAY:=T_HINHSU_SOTHAM_2();
		-- v_HOTENBICAO_2 - HỌ TÊN BỊ CÁO Năm sinh,nơi cư trú, giới tính, quốc tịch, dân tộc, nghề nghiệp,  -- Công chức, viên chức, đảng viên, tái phạm, tái phạm nguy hiểm, nghiện ma túy (nếu có) - 2
		-- v_THOIHANTAMGIAM_3 - THỜI HẠN TẠM GIAM -- (Vi phạm nếu có) - 3
		-- v_CAOTRANG_4 - CÁO TRẠNG  -- Số, ngày, tháng, năm -- Điều luật, Tội danh, hình phạt theo đề nghị của Kiểm sát viên tại phiên tòa - 4
		-- v_NGUOITHAMGIATOTUNG_5 - NGƯỜI THAM GIA TỐ TỤNG  -- (Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)  -- Họ tên, năm sinh, nơi cư trú, giới tính - 5
		-- v_NGUOIBC_NGUOIBV_QLIHP_DS_6 - NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ  -- Họ tên, địa chỉ hoặc đơn vị hành nghề - 6
		-- v_GQ_TRAHOSOCHOVKS_7 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Số, ngày, tháng, năm - Viện kiểm sát chấp nhận - 7
		-- v_GQ_TRAHOSOCHOVKS_8 - GIẢI QUYẾT - TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT -- Số, ngày, tháng, năm - Viện kiểm sát không chấp nhận - 8
		-- v_GQ_TA_XMTT_BSCC_9 - GIẢI QUYẾT - TÒA ÁN XÁC MINH, THU THẬP, BỔ SUNG CHỨNG CỨ --  - 9
		-- v_GQ_TA_DENGHI_BPBAOVE_10 - GIẢI QUYẾT - TÒA ÁN ĐỀ NGHỊ CÁC CƠ QUAN ÁP DỤNG CÁC BIỆN PHÁP BẢO VỆ -- Số, ngày, tháng, năm - 10
		-- v_GQ_TDC_11 - GIẢI QUYẾT - TẠM ĐÌNH CHỈ -- Số, ngày, tháng, năm - 11
		-- v_GQ_DC_12 - GIẢI QUYẾT - ĐÌNH CHỈ  -- Số, ngày, tháng, năm - 12
		-- v_GQ_CHUYENHS_VA_13 - GIẢI QUYẾT - CHUYỂN HỒ SƠ VỤ ÁN -- Số, ngày, tháng, năm - 13
		-- v_GQ_TAPHUCHOIVA_14 - GIẢI QUYẾT - TÒA ÁN PHỤC HỒI VỤ ÁN  -- Số, ngày, tháng, năm - 14
		-- v_GQ_LYDO_15 - GIẢI QUYẾT - LÝ DO - 15
		-- v_XX_NGUOITIENHANHTOTUNG_16 - XÉT XỬ - NGƯỜI TIẾN HÀNH TỐ TỤNG -- (Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa) -- Ghi đầy đủ họ tên - 16
		-- v_XX_TAYCVKS_BXTLCC_17 - XÉT XỬ - TÒA ÁN YÊU CẦU VKS BỔ SUNG TÀI LIỆU, CHỨNG CỨ -- Số, ngày, tháng, năm - 17
		-- v_XX_BA_QDST_18 - XÉT XỬ - BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM  -- Số, ngày, tháng, năm - 18
		-- v_XX_QDCUABA_QDST_19 - XÉT XỬ - QUYẾT ĐỊNH CỦA BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM -- Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung - 19
		-- v_XX_APDUNGANLE_20 - XÉT XỬ - ÁP DỤNG ÁN LỆ -- Án lệ số - 20
		-- v_XX_KHOITOVATAIPHIENTOA_21 - XÉT XỬ - KHỞI TỐ VỤ ÁN TẠI PHIÊN TÒA -- Số, ngày, tháng, năm - 21
		-- v_XX_THIETHAI_22 - XÉT XỬ - THIỆT HẠI  -- (Mục 3 Chương 18 và Chương 23 BLHS) -- (Tài sản chiếm đoạt hoặc tài sản thiệt hại) - 22
		-- v_XX_ANLQDENBAOLUCGD_23 - XÉT XỬ - ÁN LIÊN QUAN ĐẾN BẠO LỰC GIA ĐÌNH - 23
		-- v_XX_ANDIEM_24 - XÉT XỬ - ÁN ĐIỂM - 24
		-- v_XX_ANLUUDONG_25 - XÉT XỬ - ÁN LƯU ĐỘNG - 25
		-- v_XX_ANRUTGON_26 - XÉT XỬ - ÁN RÚT GỌN - 26
		-- v_PTDDNPBC_CCVC_27 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Công chức, viên chức - 27
		-- v_PTDDNPBC_Dangvien_28 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Đảng viên - 28
		-- v_PTDDNPBC_Taipham_29 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Tái phạm, tái phạm nguy hiểm - 29
		-- v_PTDDNPBC_Nghienmatuy_30 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Nghiện ma túy - 30
		-- v_PTDDNPBC_Dantocthieuso_31 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Dân tộc thiểu số - 31
		-- v_PTDDNPBC_Nu_32 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Nữ - 32
		-- v_PTDDNPBC_Duoi16tuoi_33 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Từ đủ 14 đến dưới 16 tuổi - 33
		-- v_PTDDNPBC_Duoi18tuoi_34 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Từ đủ 16 đến dưới 18 tuổi - 34
		-- v_PTDDNPBC_Duoi30tuoi_35 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Từ đủ 18 đến dưới 30 tuổi - 35
		-- v_PTDDNPBC_Tren75tuoi_36 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Trên 75 tuổi - 36
		-- v_PTDDNPBC_Tremocoi_37 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Trẻ mồ côi cha hoặc mẹ - 37
		-- v_PTDDNPBC_Bomelyhon_38 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Bố mẹ ly hôn - 38
		-- v_PTDDNPBC_Trebohoc_39 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Trẻ bỏ học - 39
		-- v_PTDDNPBC_Trelangthang_40 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Trẻ lang thang - 40
		-- v_PTDDNPBC_Nguoinuocngoai_41 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Người nước ngoài - 41
		-- v_PTDDNPBC_Coxuigiuc_42 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN BỊ CÁO ĐÃ XÉT XỬ - Có người đủ 18 tuổi trở lên xúi giục - 42
		-- v_PTNTBIHAI_Duoi16tuoi_43 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Dưới 16 tuổi - 43
		-- v_PTNTBIHAI_Tttl16tuoi_44 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Dưới 16 tuổi có tổn thương nghiêm trọng về tâm lý - 44
		-- v_PTNTBIHAI_Tttl18tuoi_45 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Từ đủ 16 đến dưới 18 tuổi - 45
		-- v_PTNTBIHAI_TttlnT28tuoi_46 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Từ đủ 16 đến dưới 18 tuổi có tổn thương nghiêm trọng về tâm lý - 46
		-- v_PTNTBIHAI_Duoi30tuoi_47 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Từ đủ 18 tuổi đến dưới 30 tuổi - 47
		-- v_PTNTBIHAI_Nu_48 - PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN NGƯỜI BỊ HẠI - Nữ - 48
		-- v_APDUNGANLE_49 - ÁP DỤNG ÁN LỆ - 49
		-- v_KC_50 - KHÁNG CÁO -- Ngày, tháng, năm - 50
		-- v_KN_51 - KHÁNG NGHỊ  -- Số, ngày, tháng, năm - 51
		-- v_CHUYENHS_TA_PT_52 - CHUYỂN HỒ SƠ CHO TÒA PHÚC THẨM -- Ngày, tháng, năm - 52
		-- v_QD_TA_PT_53 - QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM -- Số, ngày, tháng, năm -- Tóm tắt phần quyết định - 53
		-- v_GHICHU_54 - GHI CHÚ - 54
	END;

	/*24 - SỔ THỤ LÝ VÀ KẾT QUẢ GIẢI QUYẾT YÊU CẦU TUYÊN BỐ PHÁ SẢN*/
	

	/*============================================================================================*/


	PROCEDURE SO_DANSU_PHUCTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_DANSU_PHUCTHAM;
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
		SELECT R_DANSU_PHUCTHAM(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>TL.DONID,
            v_TOAANSOTHAMID=>bast.TOAANID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>TL.QUANHEPHAPLUATID,
			v_TL_1=>NULL,
			v_BA_QD_TA_ST_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQ_DS_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_NGUOIBV_QLIHP_DS_6=>NULL,
			v_QHPL_7=>NULL,
			v_KC_8=>NULL,
			v_KN_9=>NULL,
			v_ADBPKCTT_10=>NULL,
			v_RUT_KC_11=>NULL,
			v_RUT_KN_12=>NULL,
			v_TDC_13=>NULL,
			v_DC_14=>NULL,
			v_LYDO_15=>NULL,
			v_HDXX_VKS_TKPT_16=>NULL,
			v_BA_QDPT_17=>NULL,
			v_QD_TA_PT_18=>NULL,
			v_LYDO_SH_STSAI_19=>NULL,
			v_LYDO_SH_LDK_20=>NULL,
			v_APDUNGANLE_21=>NULL,
			v_GQVA_TTRG_22=>NULL,
			v_VIECDS_23=>NULL,
			v_QD_GDTTT_24=>NULL,
			v_GHICHU_25=>NULL,
            V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM ADS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
      INNER JOIN ADS_SOTHAM_BANAN bast on bast.DONID=TL.DONID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_DANSU_PHUCTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_DANSU_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_DANSU_GDTTT;
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
		--XAC DINH ID THU LY XÉT XỬ GIÁM ĐỐC THẨM AN THEO THAM SO
		SELECT R_DANSU_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQDS_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_HDXX_VKS_TKPT_6=>NULL,
			v_QHPL_7=>NULL,
			v_CHANHANKN_8=>NULL,
			v_VIENTRUONGKN_9=>NULL,
			v_CHANHANRUT_KN_10=>NULL,
			v_VIENTRUONGRUT_KN_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_VIECDS_15=>NULL,
			v_APDUNGANLE_16=>NULL,
			v_GHICHU_17=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
            TL.Loaian = 2  
            AND NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_DANSU_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
        OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;


	PROCEDURE SO_HANHCHINH_PHUCTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HANHCHINH_PHUCTHAM;
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
		SELECT R_HANHCHINH_PHUCTHAM(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDST_2=>NULL,
			v_NGUOIKK_3=>NULL,
			v_NGUOIBIKIEN_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_NGUOIBV_QLIHP_DS_6=>NULL,
			v_QHPL_7=>NULL,
			v_KC_8=>NULL,
			v_KN_9=>NULL,
			v_ADBPKCTT_10=>NULL,
			v_RUT_KC_11=>NULL,
			v_RUT_KN_12=>NULL,
			v_TDC_13=>NULL,
			v_DC_14=>NULL,
			v_LYDO_15=>NULL,
			v_HDXX_VKS_TKPT_16=>NULL,
			v_BA_QDPT_17=>NULL,
			v_QD_TA_PT_18=>NULL,
			v_LYDO_SH_ST_QDKDPL_19=>NULL,
			v_LYDO_SH_TTM_20=>NULL,
			v_APDUNGANLE_21=>NULL,
			v_GQ_TTRG_22=>NULL,
			v_KNGDTTT_23=>NULL,
			v_GHICHU_24=>NULL,
            V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHC_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HANHCHINH_PHUCTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY) O
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HANHCHINH_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HANHCHINH_GDTTT;
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
		--XAC DINH ID THU LY XÉT XỬ GIÁM ĐỐC THẨM AN THEO THAM SO
		SELECT R_HANHCHINH_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_NGUOIKK_3=>NULL,
			v_NGUOIBKK_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_HDXX_VKS_TKPT_6=>NULL,
			v_QHPL_7=>NULL,
			v_CHANHANKN_8=>NULL,
			v_VIENTRUONGKN_9=>NULL,
			v_CHANHANRUT_KN_10=>NULL,
			v_VIENTRUONGRUT_KN_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_APDUNGANLE_15=>NULL,
			v_GHICHU_16=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
            TL.Loaian = 6  --an Hanh chinh
            AND NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HANHCHINH_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_VUANID);
		END LOOP;
		--*/
        OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;


	PROCEDURE SO_LAODONG_PHUCTHAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_LAODONG_PHUCTHAM;
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
		SELECT R_LAODONG_PHUCTHAM(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>TL.DONID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDST_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQLD_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_NGUOIBV_QLIHP_DS_6=>NULL,
			v_QHPLKHITL_7=>NULL,
			v_KC_8=>NULL,
			v_KN_9=>NULL,
			v_ADBPKCTT_10=>NULL,
			v_RUT_KC_11=>NULL,
			v_RUT_KN_12=>NULL,
			v_TDC_13=>NULL,
			v_DC_14=>NULL,
			v_LYDO_15=>NULL,
			v_HDXX_VKS_TKPT_16=>NULL,
			v_BA_QDPT_17=>NULL,
			v_QD_TA_PT_18=>NULL,
			v_LYDO_SH_STSAI_19=>NULL,
			v_LYDO_SH_LDK_20=>NULL,
			v_APDUNGANLE_21=>NULL,
			v_GQ_TTRG_22=>NULL,
			v_VIECLD_23=>NULL,
			v_QD_GDTTT_24=>NULL,
			v_GHICHU_25=>NULL,
            V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM ALD_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_LAODONG_PHUCTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_LAODONG_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_LAODONG_GDTTT;
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
		SELECT R_LAODONG_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQ_LD_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_HDXX_VKS_TKPT_6=>NULL,
			v_QHPL_7=>NULL,
			v_CHANHANKN_8=>NULL,
			v_VIENTRUONGKN_9=>NULL,
			v_CHANHANRUT_KN_10=>NULL,
			v_VIENTRUONGRUT_KN_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_VIECLD_15=>NULL,
			v_APDUNGANLE_16=>NULL,
			v_GHICHU_17=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
            TL.Loaian = 5 --LĐ  
            AND NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_LAODONG_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		 OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;



    PROCEDURE SO_KINHTE_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_KINHTE_GDTTT;
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
		SELECT R_KINHTE_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>NULL,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQ_KDTM_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_HDXX_VKS_TKPT_6=>NULL,
			v_QHPL_7=>NULL,
			v_CHANHANKN_8=>NULL,
			v_VIENTRUONGKN_9=>NULL,
			v_CHANHANRUT_KN_10=>NULL,
			v_VIENTRUONGRUT_KN_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_VIEC_KDTM_15=>NULL,
			v_APDUNGANLE_16=>NULL,
			v_GHICHU_17=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
            TL.Loaian = 4 --KDTM  
            AND NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_KINHTE_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		 OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;


	PROCEDURE SO_HONNHAN_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HONNHAN_GDTTT;
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
		--XAC DINH ID VU AN XÉT XỬ GIÁM ĐỐC THẨM AN THEO THAM SO
		SELECT R_HONNHAN_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_ND_NYC_3=>NULL,
			v_BD_NLQ_HNGD_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_HDXX_VKS_TKPT_6=>NULL,
			v_QHPL_7=>NULL,
			v_CHANHANKN_8=>NULL,
			v_VIENTRUONGKN_9=>NULL,
			v_CHANHANRUT_KN_10=>NULL,
			v_VIENTRUONGRUT_KN_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_HN_GD_15=>NULL,
			v_APDUNGANLE_16=>NULL,
			v_GHICHU_17=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
--            TL.LOAIAN = 3 --HNGD  
--            AND 
            NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HONNHAN_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_VUANID);
		END LOOP;
		--*/
        OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

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
		PKG_GSTP_SOTHULY.FILL_HINHSU_SOTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY) ORDER BY  REGEXP_REPLACE(V_SOTHULY, '[^0-9]'),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_SOTHAM_2
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_SOTHAM_2;
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
		SELECT R_HINHSU_SOTHAM_2(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>NULL,
			v_TOAANID=>NULL,
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
			v_XX_APDUNGANLE_20=>NULL,
			v_XX_KHOITOVATAIPHIENTOA_21=>NULL,
			v_XX_THIETHAI_22=>NULL,
			v_XX_ANLQDENBAOLUCGD_23=>NULL,
			v_XX_ANDIEM_24=>NULL,
			v_XX_ANLUUDONG_25=>NULL,
			v_XX_ANRUTGON_26=>NULL,
			v_PTDDNPBC_CCVC_27=>NULL,
			v_PTDDNPBC_Dangvien_28=>NULL,
			v_PTDDNPBC_Taipham_29=>NULL,
			v_PTDDNPBC_Nghienmatuy_30=>NULL,
			v_PTDDNPBC_Dantocthieuso_31=>NULL,
			v_PTDDNPBC_Nu_32=>NULL,
			v_PTDDNPBC_Duoi16tuoi_33=>NULL,
			v_PTDDNPBC_Duoi18tuoi_34=>NULL,
			v_PTDDNPBC_Duoi30tuoi_35=>NULL,
			v_PTDDNPBC_Tren75tuoi_36=>NULL,
			v_PTDDNPBC_Tremocoi_37=>NULL,
			v_PTDDNPBC_Bomelyhon_38=>NULL,
			v_PTDDNPBC_Trebohoc_39=>NULL,
			v_PTDDNPBC_Trelangthang_40=>NULL,
			v_PTDDNPBC_Nguoinuocngoai_41=>NULL,
			v_PTDDNPBC_Coxuigiuc_42=>NULL,
			v_PTNTBIHAI_Duoi16tuoi_43=>NULL,
			v_PTNTBIHAI_Tttl16tuoi_44=>NULL,
			v_PTNTBIHAI_Tttl18tuoi_45=>NULL,
			v_PTNTBIHAI_Tttlnt18tuoi_46=>NULL,
			v_PTNTBIHAI_Duoi30tuoi_47=>NULL,
			v_PTNTBIHAI_Nu_48=>NULL,
			v_APDUNGANLE_49=>NULL,
			v_KC_50=>NULL,
			v_KN_51=>NULL,
			v_CHUYENHS_TA_PT_52=>NULL,
			v_QD_TA_PT_53=>NULL,
			v_GHICHU_54=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_SOTHAM_2(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
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
		PKG_GSTP_SOTHULY.FILL_HINHSU_PHUCTHAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY) ORDER BY  REGEXP_REPLACE(V_SOTHULY, '[^0-9]'),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_GDTTT
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_GDTTT;
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
		SELECT R_HINHSU_GDTTT(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>NULL,
			v_VUANID=>TL.ID,
			v_TOAANID=>TL.TOAANID,
			v_TL_1=>NULL,
			v_BA_QDBIKN_2=>NULL,
			v_BICAOBIKN_3=>NULL,
			v_THOIHANTAMGIAM_4=>NULL,
			v_TAINGOAI_5=>NULL,
			v_NGUOITHAMGIATOTUNG_6=>NULL,
			v_CHANHANKN_7=>NULL,
			v_VIENTRUONGKN_8=>NULL,
			v_CHANHANRUT_KN_9=>NULL,
			v_VIENTRUONGRUT_KN_10=>NULL,
			v_NGUOITIENHANHTOTUNG_11=>NULL,
			v_QD_GDTTT_12=>NULL,
			v_QD_HD_GDTTT_13=>NULL,
			v_LYDO_14=>NULL,
			v_APDUNGANLE_15=>NULL,
			v_GHICHU_16=>NULL,
            V_NGAYTHULY=>NULL,V_SOTHULY=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM GDTTT_VUAN TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
            TL.LOAIAN = 1 -- An Hinh su
			 AND NGAYTHULYXXGDT BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_GDTTT(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
        OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY)
        ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY;
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_BAQD
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_BAQD;
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
		SELECT R_HINHSU_BAQD(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>NULL,
			v_TOAANID=>NULL,
			v_STT_1=>NULL,
			v_SOTLVA_2=>NULL,
			v_TENHOSOVA_3=>NULL,
			v_SOQD_DUAVARAXX_4=>NULL,
			v_SOBA_5=>NULL,
			v_SOQD_TDC_6=>NULL,
			v_SOQD_DC_7=>NULL,
			v_SOQD_TRAHOSO_DTBS_8=>NULL,
			v_SOQD_CHUYENHS_VA_9=>NULL,
			v_CACQDKHAC_So_10=>NULL,
			v_CACQDKHAC_Ten_11=>NULL,
			v_GHICHU_12=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_BAQD(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_TAINGOAI
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_TAINGOAI;
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
		SELECT R_HINHSU_TAINGOAI(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>NULL,
			v_TOAANID=>NULL,
			v_BA_QD_COHLPL_1=>NULL,
			v_NGUOIBI_KETAN_2=>NULL,
			v_TOIDANH_3=>NULL,
			v_HINHPHAT_4=>NULL,
			v_QD_THA_PT_5=>NULL,
			v_DABAT_THA_PT_6=>NULL,
			v_HTDC_THAPT_QDHOAN_7=>NULL,
			v_HTDC_THAPT_QDTDC_8=>NULL,
			v_HTDC_THAPT_LYDOHOAN_9=>NULL,
			v_HTDC_THAPT_KT_HTDC_10=>NULL,
			v_HTDC_THAPT_QDTIEPTUC_11=>NULL,
			v_HTDC_THAPT_DBSK_HTDC_12=>NULL,
			v_HETTHOIHIEU_THA_13=>NULL,
			v_QD_MIEN_CHHPT_14=>NULL,
			v_TRUYNA_QD_15=>NULL,
			v_TRUYNA_CHUACOQD_16=>NULL,
			v_GHICHU_17=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_TAINGOAI(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_QDTHA
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_QDTHA;
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
		SELECT R_HINHSU_QDTHA(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>NULL,
			v_TOAANID=>NULL,
			v_TL_1=>NULL,
			v_BA_QD_COHLPL_2=>NULL,
			v_NGUOIBIKETAN_3=>NULL,
			v_TOIDANH_4=>NULL,
			v_HINHPHAT_5=>NULL,
			v_CHETTRUOCKHICOQD_THA_6=>NULL,
			v_QD_THA_HINHPHATTU_7=>NULL,
			v_QD_THA_HINHPHATKHAC_8=>NULL,
			v_QD_THA_TUHINH_9=>NULL,
			v_DA_THA_TUHINH_10=>NULL,
			v_CQTCCONHIEMVU_THA_11=>NULL,
			v_QDUYTHAC_THA_So_12=>NULL,
			v_QDUYTHAC_THA_TA_NHANYT_13=>NULL,
			v_QDUYTHAC_THA_KQYT_14=>NULL,
			v_GHICHU_15=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_QDTHA(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

	PROCEDURE SO_HINHSU_MIENGIAM
	(
		 in_TOAANID IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn OUT SYS_REFCURSOR
	) AS
		v_ARRAY T_HINHSU_MIENGIAM;
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
		SELECT R_HINHSU_MIENGIAM(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>NULL,
			v_TOAANID=>NULL,
			v_TL=>NULL,
			v_BA_QD_COHLPL_1=>NULL,
			v_NGUOIBKA_NGUOIDGAP_2=>NULL,
			v_TOIDANH_3=>NULL,
			v_HINHPHATTU_4=>NULL,
			v_QD_THA_PT_5=>NULL,
			v_NOICHHPT_NOICT_6=>NULL,
			v_QDGIAMTHOIHAN_7=>NULL,
			v_MUCGIAM_8=>NULL,
			v_QD_MIENCHHPT_9=>NULL,
			v_XOAANTICH_Duongnhien_10=>NULL,
			v_XOAANTICH_TheoQD_TA_11=>NULL,
			v_ANPHI_Nghindong_12=>NULL,
			v_MIENGIAMANPHI_TP_Mien_13=>NULL,
			v_MIENGIAMANPHI_TP_Giam_14=>NULL,
			v_GHICHU_15=>NULL
		)
		BULK COLLECT INTO v_ARRAY
		FROM AHS_PHUCTHAM_THULY TL INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
		WHERE
			NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY');
		--
		--THONG TIN SO THU LY
		PKG_GSTP_SOTHULY.FILL_HINHSU_MIENGIAM(v_ARRAY);
		/*--
		FOR ITEM IN (SELECT * FROM TABLE(v_ARRAY)) LOOP
			DBMS_OUTPUT.PUT_LINE (ITEM.v_STT||' - '||ITEM.v_THULYID);
		END LOOP;
		--*/
		OPEN curReturn FOR SELECT * FROM TABLE(v_ARRAY);
		--
	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;


END PKG_GSTP_SOTHULY;
