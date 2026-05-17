--------------------------------------------------------
--  DDL for Package Body PKG_GS_CONGBO_LOCAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GS_CONGBO_LOCAN" AS
--Select VUVIECID,LOAIANID,COUNT(VUVIECID) from BAQD_CONGBO
--GROUP BY VUVIECID,LOAIANID
--HAVING  COUNT(VUVIECID) > 1;
  PROCEDURE TONGHOP_CBBA AS
  BEGIN
    HINHSU_CBBA();
    DANSU_CBBA();
    HNGD_CBBA();
    KINHTE_CBBA();
    LAODONG_CBBA();
    HANHCHINH_CBBA();
    PHASAN_CBBA();
    XLHC_CBBA();
    NULL;
  END TONGHOP_CBBA;
-- Hình sự
PROCEDURE HINHSU_CBBA AS
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUAN,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from AHS_VUAN don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.VUANID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
        -- Quyết định
        Select qd.ID,qd.VUANID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
            -- lấy ds quyết định
            -- Sơ thẩm
            select DISTINCT st_qd.ID,st_qd.VUANID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
            from AHS_SOTHAM_QUYETDINH_VUAN st_qd
            UNION 
            -- Phúc thẩm
            select DISTINCT pt_qd.ID,pt_qd.VUANID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
            from AHS_PHUCTHAM_QUYETDINH_VUAN pt_qd
            -- End lấy ds quyết định
        ) qd
        inner join (
            select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
            from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISHNGD = 1
        ) dm_qd on dm_qd.ID = qd.QUYETDINHID
        where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
        -- End quyết định
        UNION 
        --Bản án
        Select ba.*,1 ISBA from (
            --sơ thẩm
            select st_ba.ID,st_ba.VUANID,
                st_ba.NGAYBANAN NGAYHIEULUC,2 CAPXETXU
            from AHS_SOTHAM_BANAN st_ba
            UNION
            --Phúc thẩm
            select pt_ba.ID,pt_ba.VUANID,pt_ba.NGAYBANAN NGAYHIEULUC ,3 CAPXETXU
            from AHS_PHUCTHAM_BANAN pt_ba
        ) ba
        where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
        --End bản án
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.VUANID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
            --lấy những kháng cáo không có hủy kháng cáo
            Select st_kc.VUANID,st_kc.NGAYKHANGCAO NGAYKCKN from AHS_SOTHAM_KHANGCAO st_kc
            left join AHS_SOTHAM_RUTKHANGCAO st_rkc
            ON st_kc.ID = st_rkc.KHANGCAOID and st_rkc.TINHTRANG = 2
            where st_rkc.KHANGCAOID is null
            UNION
            --Lấy những kháng nghị không có ở hủy kháng nghị
            Select st_kn.VUANID,st_kn.NGAYKN NGAYKCKN  from AHS_SOTHAM_KHANGNGHI st_kn
            left join AHS_SOTHAM_RUTKHANGNGHI st_rkn
            ON st_kn.ID = st_rkn.KHANGNGHIID and st_rkn.TINHTRANG = 2
            where st_rkn.KHANGNGHIID is null
    ) kc_kn
    on kc_kn.VUANID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.VUANID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = 1 
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (1,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = 1
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = 1
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END HINHSU_CBBA;
-- end Hình sự
-- Dân sự
PROCEDURE DANSU_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 2;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 2;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from ADS_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from ADS_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from ADS_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISDANSU = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from ADS_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from ADS_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from ADS_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from ADS_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join ADS_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END DANSU_CBBA;
-- End dân sự

-- Hôn nhân gia đình
PROCEDURE HNGD_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 3;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 3;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from AHN_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from AHN_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from AHN_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISDANSU = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from AHN_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from AHN_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from AHN_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from AHN_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join AHN_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END HNGD_CBBA;
-- End Hôn nhân gia đình
-- Kinh tế
PROCEDURE KINHTE_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 4;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 4;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from AKT_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from AKT_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from AKT_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISKDTM = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from AKT_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from AKT_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from AKT_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from AKT_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join AKT_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END KINHTE_CBBA;
-- End Kinh tế

-- Lao động
PROCEDURE LAODONG_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 5;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 5;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from ALD_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from ALD_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from ALD_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISLAODONG = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from ALD_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from ALD_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from ALD_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from ALD_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join ALD_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END LAODONG_CBBA;
-- End Lao động

-- Hành chính
PROCEDURE HANHCHINH_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 6;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 6;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from AHC_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from AHC_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from AHC_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISHANHCHINH = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from AHC_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from AHC_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from AHC_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from AHC_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join AHC_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END HANHCHINH_CBBA;
-- End Hành chính

-- Phá sản
PROCEDURE PHASAN_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 6;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 6;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from APS_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			-- Quyết định
			Select qd.ID,qd.DONID,qd.NGAYHIEULUC,qd.CAPXETXU,0 ISBA from (
				-- lấy ds quyết định
				-- Sơ thẩm
				select DISTINCT st_qd.ID,st_qd.DONID,st_qd.NGAYQD NGAYHIEULUC,2 CAPXETXU,st_qd.QUYETDINHID
				from APS_SOTHAM_QUYETDINH st_qd
				UNION 
				-- Phúc thẩm
				select DISTINCT pt_qd.ID,pt_qd.DONID,pt_qd.NGAYQD NGAYHIEULUC,3 CAPXETXU,pt_qd.QUYETDINHID
				from APS_PHUCTHAM_QUYETDINH pt_qd
				-- End lấy ds quyết định
			) qd
			inner join (
				select dm_qd.ID,dm_qd.THOIHANDUOCCONGBO
				from DM_QD_QUYETDINH dm_qd WHERE dm_qd.ISCONGBO = 1 AND dm_qd.ISPHASAN = 1
			) dm_qd on dm_qd.ID = qd.QUYETDINHID
			where (CURRENT_DATE - qd.NGAYHIEULUC >= nvl(dm_qd.THOIHANDUOCCONGBO,11) or qd.CAPXETXU = 3)
			-- End quyết định
			UNION 
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from APS_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from APS_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from APS_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from APS_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join APS_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END PHASAN_CBBA;
-- End Phá sản

-- Xử lý hành chính
PROCEDURE XLHC_CBBA AS
	VarLOAIANID NUMBER NOT NULL := 8;
    VarDSQD DS_NUMBER :=DS_NUMBER();
    V_QDBA_STPT_TABLE GS_LOCAN_CBBA_EXT;
    V_VA_LOCKCKN_TABLE GS_LOCAN_CBBA_EXT;
----------------------------------------------------------------------------------------------------
BEGIN
	VarLOAIANID := 8;
    V_QDBA_STPT_TABLE := GS_LOCAN_CBBA_EXT();
    V_VA_LOCKCKN_TABLE := GS_LOCAN_CBBA_EXT();
    --Danh sach quyet dinh se cong bo
    Select GS_LOCAN_CBBA_T(ba_qd.ID,ba_qd.NGAYHIEULUC,ba_qd.ISBA,ba_qd.CAPXETXU,ba_qd.ROW_NUM,don.MAVUVIEC,don.ID) bulk collect into V_VA_LOCKCKN_TABLE from XLHC_DON don
    inner join (
    Select baqd_rn.* from (
            Select baqd.*,ROW_NUMBER() OVER (PARTITION BY baqd.DONID ORDER BY baqd.NGAYHIEULUC DESC) ROW_NUM from (
			--Bản án
			Select ba.*,1 ISBA from (
				--sơ thẩm
				select st_ba.ID,st_ba.DONID,
			st_ba.NGAYTUYENAN NGAYHIEULUC,2 CAPXETXU
				from XLHC_SOTHAM_BANAN st_ba
				UNION
				--Phúc thẩm
				select pt_ba.ID,pt_ba.DONID,pt_ba.NGAYTUYENAN NGAYHIEULUC ,3 CAPXETXU
				from XLHC_PHUCTHAM_BANAN pt_ba
			) ba
			where (CURRENT_DATE - ba.NGAYHIEULUC >= 31 or ba.CAPXETXU = 3)
    ) baqd
    ) baqd_rn where baqd_rn.ROW_NUM = 1 
    ) ba_qd on don.ID = ba_qd.DONID
    --Láy các kháng cáo Kháng nghị của vụ án id
    left join (
		Select kc_kn.DONID,kc_kn.NGAYKCKN from (
			--Lấy kháng cáo
			Select st_kc.ID,st_kc.DONID,st_kc.NGAYKHANGCAO NGAYKCKN,1 ISKCKN from XLHC_SOTHAM_KHANGCAO st_kc
			UNION
			-- lấy kháng nghị
			Select st_kn.ID,st_kn.DONID,st_kn.NGAYKN NGAYKCKN,2 ISKCKN from XLHC_SOTHAM_KHANGNGHI st_kn
			--End
		) kc_kn
		left join XLHC_SOTHAM_RUTKCKN rut_kckn
		ON 
		-- so sánh kiểu là kc hay kn
		rut_kckn.ISKCKN = kc_kn.ISKCKN 
		--so sánh id kc kn
		and rut_kckn.IDKCKN = kc_kn.ID 
		-- rút toàn bộ
		and rut_kckn.TRANGTHAI = 2
		-- không có rút toàn bộ kckn mới lấy
		where rut_kckn.ID is null
    ) kc_kn
    on kc_kn.DONID = don.ID AND kc_kn.NGAYKCKN >= ba_qd.NGAYHIEULUC
    where 
    kc_kn.DONID is null
    and don.MAGIAIDOAN = ba_qd.CAPXETXU;
    -- Thêm bản ghi chưa có vào CSDL
    FOR r IN (
        Select data.* from TABLE(V_VA_LOCKCKN_TABLE) data
        left join BAQD_CONGBO ba_qd_cb 
        ON 
        ba_qd_cb.MAVUAN = data.MAVUAN 
        and ba_qd_cb.VUVIECID = data.VUVIECID
        and ba_qd_cb.LOAIANID = VarLOAIANID
        --and data.ID = ba_qd_cb.BAQDID
        --and data.ISBA = ba_qd_cb.ISBA
        where ba_qd_cb.ID is null
    )
    LOOP
        INsert into BAQD_CONGBO(baqd_congbo.loaianid,baqd_congbo.capxetxu,ISBA,BAQDID,NGAYHIEULUC,MAVUAN,VUVIECID,NGAYTAO) VALUES
        (VarLOAIANID,r.CAPXETXU,r.ISBA,r.ID,r.NGAYHIEULUC,r.MAVUAN,r.VUVIECID,CURRENT_DATE);
    END LOOP;
    commit;
    --End thêm bản ghi chưa có vào CSDL
    --Cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    FOR r IN (
        Select ba_qd_cb.ID BAQDCB_ID,LOCKCKN.* from TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
        inner join BAQD_CONGBO ba_qd_cb 
        on ba_qd_cb.VUVIECID = LOCKCKN.VUVIECID 
        and (ba_qd_cb.TRANGTHAI != 2 or ba_qd_cb.TRANGTHAI is null) 
        and ba_qd_cb.LOAIANID = VarLOAIANID
        and (ba_qd_cb.BAQDID != LOCKCKN.ID or ba_qd_cb.CAPXETXU != LOCKCKN.CAPXETXU or ba_qd_cb.NGAYHIEULUC != LOCKCKN.NGAYHIEULUC)
        --where LOCKCKN.MAVUAN = '0112103138'
    )
    LOOP
        UPDATE BAQD_CONGBO SET CAPXETXU = r.CAPXETXU,ISBA=r.ISBA,BAQDID= r.ID,NGAYHIEULUC = r.NGAYHIEULUC,NGAYSUA = CURRENT_DATE Where ID = r.BAQDCB_ID;
    END LOOP;
    --end cập nhật những bản ghi đã có nhưng dữ liệu thay đổi
    -- Xóa những bản ghi không còn đủ điều kiện công bố
    Delete BAQD_CONGBO baqd_cb where baqd_cb.ID in (
        Select cb.ID from BAQD_CONGBO cb 
        left join TABLE(V_VA_LOCKCKN_TABLE) LOCKCKN 
            ON LOCKCKN.VUVIECID = cb.VUVIECID AND cb.MAVUAN = LOCKCKN.MAVUAN
        Where LOCKCKN.ID is null
        and (cb.TRANGTHAI != 2 or cb.TRANGTHAI is null)
        and cb.LOAIANID = VarLOAIANID
        --and cb.MAVUAN = '0112103138'
    );
    -- end xóa những bản ghi không còn đủ điều kiện công bố
END XLHC_CBBA;
-- End Xử lý hành chính

END PKG_GS_CONGBO_LOCAN;

/
