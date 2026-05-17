--------------------------------------------------------
--  DDL for Package Body PKG_XLHC_ST_KNKNKN_V2
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_XLHC_ST_KNKNKN_V2" 
AS
-- Package body

-- Thủ tục lấy danh sách kháng cáo / kiến nghị / kháng nghị
--PROCEDURE XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST (
--    vDonID IN NUMBER,
--    curReturn OUT SYS_REFCURSOR 
--) IS
--BEGIN
--    OPEN curReturn FOR
--    WITH 
--    CTE (QUYETDINHID, SO_QUYETDINH, type) AS (
--    SELECT QUYETDINHID, SOQD AS SO_QUYETDINH, '1|' || QUYETDINHID AS TYPE  --3.2
--	    FROM XLHC_SOTHAM_QUYETDINH     
--	    WHERE DONID = vDonID 
--	    
--        UNION ALL  
--               
--        SELECT QUYETDINHID, SOBANAN AS SO_QUYETDINH, '2|' || QUYETDINHID AS TYPE --3.3
--	    FROM XLHC_SOTHAM_BANAN ba 
--	    WHERE DONID = vDonID 
--	             
--	    UNION ALL
--	    
--	    SELECT DM_QUYETDINH_ID AS QUYETDINHID, TO_CHAR(SO_QUYETDINH) AS SO_QUYETDINH, '3|' ||DM_QUYETDINH_ID   AS TYPE --3.4
--	    FROM XLHC_DONXIN_HOAN_MIEN hm
--	    WHERE hm.DONID = vDonID AND hm.ISGIAIQUYET = 1
--    ),
--    kn AS ( 
--        SELECT c.SO_QUYETDINH , qd.TEN , c.QUYETDINHID, c.type
--	    FROM CTE c
--	    JOIN DM_QD_QUYETDINH qd ON c.QUYETDINHID = qd.ID
--    )
--    
--    SELECT
--        d.ID,
--        '1' AS IsKhangCao,
--        'Khiếu nại' AS KCKNName,
--        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
--        COALESCE(s.NGUOITGT, ds.NGUOIBIDENGHI) ||
--	    CASE
--	        WHEN d.GQ_TINHTRANG IN (0, 1) THEN
--	            '<br/>(Kháng cáo quá hạn: ' ||
--	            CASE d.GQ_TINHTRANG
--	                WHEN 0 THEN 'Chờ duyệt'
--	                WHEN 1 THEN 'Đã duyệt'
--	            END || ')'
--	    END AS NguoiKCCapKN,
--
--        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
--        d.NGAYKHANGCAO AS NgayKCKN,
--        d.NGAYQDBA AS NGAYQDBA,
--        d.NGUOITAO,
--        d.NGAYTAO,
--        d.TENFILE,
--        kn.TEN AS tenquyetdinh,
--        kn.SO_QUYETDINH AS SO_QDBA
--    FROM XLHC_SOTHAM_KHANGCAO d
--    LEFT JOIN (
----        SELECT ID, HOTEN AS NGUOITGT FROM XLHC_DON_THAMGIATOTUNG WHERE DONID = vDonID
--		SELECT
--			ID,
--			HOTEN || ' - ' || TUCACH  AS NGUOITGT
--		FROM
--			(
--			SELECT
--				t.ID,
--				t.HOTEN,
--				dt.TEN AS TUCACH
--			FROM
--				XLHC_DON_THAMGIATOTUNG t
--			LEFT JOIN DM_DATAITEM dt ON
--				t.TUCACHTGTTID = dt.MA
--			WHERE
--				t.DONID = vDonID
--		)
--
--    ) s ON s.ID = d.DUONGSUID
--    LEFT JOIN (
--        SELECT ID, HOTEN || ' - ' || 'Người bị đề nghị'  AS NGUOIBIDENGHI FROM XLHC_DUONGSU WHERE DONID = vDonID
--    ) ds ON ds.ID = d.DUONGSUID
--    LEFT JOIN kn ON  (d.TYPE_QD || '|' || d.SOQDBA) = kn.type
--    WHERE d.DONID = vDonID AND d.Type = 1
--
--    UNION ALL
--
--    -- Kiến nghị (Type = 2)
--    SELECT
--        d.ID,
--        '2' AS IsKhangCao,
--        'Kiến nghị' AS KCKNName,
--        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
--        s.TENDUONGSU ||
--		CASE
--		    WHEN d.GQ_TINHTRANG IN (0, 1) THEN '<br/>(Kháng cáo quá hạn: ' ||
--		        CASE d.GQ_TINHTRANG
--		            WHEN 0 THEN 'Chờ duyệt'
--		            WHEN 1 THEN 'Đã duyệt'
--		        END || ')'
--		END AS NguoiKCCapKN,
--        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
--        d.NGAYKHANGCAO AS NgayKCKN,
--       
--        d.NGAYQDBA AS NGAYQDBA,
--        d.NGUOITAO,
--        d.NGAYTAO,
--        d.TENFILE,
--        kn.TEN AS tenquyetdinh,
--        kn.SO_QUYETDINH AS SO_QDBA
--    FROM XLHC_SOTHAM_KHANGCAO d
--    LEFT JOIN (
--        SELECT a.ID, a.CQDN_TEN AS TENDUONGSU
--        FROM XLHC_DON a
--        WHERE a.ID = vDonID
--    ) s ON s.ID = d.DUONGSUID
--    LEFT JOIN kn ON  (d.TYPE_QD || '|' || d.SOQDBA) = kn.type
--    WHERE d.DONID = vDonID AND d.Type = 2
--
--    UNION ALL
--
--    -- Kháng nghị (Type = 3)
--    SELECT
--        d.ID,
--        '3' AS IsKhangCao,
--        'Kháng nghị' AS KCKNName,
--        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
--        (SELECT dv.TEN FROM DM_VKS dv WHERE dv.ID = d.DUONGSUID) ||
--		CASE
--		    WHEN d.GQ_TINHTRANG IN (0, 1) THEN '<br/>(Kháng cáo quá hạn: ' ||
--		        CASE d.GQ_TINHTRANG
--		            WHEN 0 THEN 'Chờ duyệt'
--		            WHEN 1 THEN 'Đã duyệt'
--		        END || ')'
--		END AS NguoiKCCapKN,
--        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
--        d.NGAYKHANGCAO AS NgayKCKN,
-- 
--        d.NGAYQDBA AS NGAYQDBA,
--        d.NGUOITAO,
--        d.NGAYTAO,
--        d.TENFILE,
--        kn.TEN AS tenquyetdinh,
--        kn.SO_QUYETDINH AS SO_QDBA
--    FROM XLHC_SOTHAM_KHANGCAO d
--    LEFT JOIN (
--        SELECT a.ID, a.HOTEN AS TENDUONGSU
--        FROM XLHC_DUONGSU a
--        WHERE a.DONID = vDonID
--    ) s ON s.ID = d.DUONGSUID
--    LEFT JOIN kn ON  (d.TYPE_QD || '|' || d.SOQDBA) = kn.type
--    WHERE d.DONID = vDonID AND d.Type = 3;
--
--END XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST;

-- Thủ tục lấy danh sách kháng cáo / kiến nghị / kháng nghị
PROCEDURE XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST (
    vDonID IN NUMBER,
    curReturn OUT SYS_REFCURSOR 
) IS
BEGIN
    OPEN curReturn FOR
    WITH 
    CTE (QUYETDINHID, SO_QUYETDINH, type, record_id) AS (
        -- Từ XLHC_SOTHAM_QUYETDINH: sử dụng ID của record làm key
        SELECT QUYETDINHID, SOQD AS SO_QUYETDINH, '1|' || ID AS TYPE, ID AS record_id
        FROM XLHC_SOTHAM_QUYETDINH     
        WHERE DONID = vDonID 

        UNION ALL  

        -- Từ XLHC_SOTHAM_BANAN: sử dụng QUYETDINHID làm key
        SELECT QUYETDINHID, SOBANAN AS SO_QUYETDINH, '2|' || QUYETDINHID AS TYPE, QUYETDINHID AS record_id
        FROM XLHC_SOTHAM_BANAN ba 
        WHERE DONID = vDonID 

        UNION ALL

        -- Từ XLHC_DONXIN_HOAN_MIEN: sử dụng DM_QUYETDINH_ID làm key
        SELECT DM_QUYETDINH_ID AS QUYETDINHID, TO_CHAR(SO_QUYETDINH) AS SO_QUYETDINH, '3|' || DM_QUYETDINH_ID AS TYPE, DM_QUYETDINH_ID AS record_id
        FROM XLHC_DONXIN_HOAN_MIEN hm
        WHERE hm.DONID = vDonID AND hm.ISGIAIQUYET = 1
    ),
    kn AS ( 
        SELECT c.SO_QUYETDINH, qd.TEN, c.QUYETDINHID, c.type, c.record_id
        FROM CTE c
        JOIN DM_QD_QUYETDINH qd ON c.QUYETDINHID = qd.ID
    )

    SELECT
        d.ID,
        '1' AS IsKhangCao,
        'Khiếu nại' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        COALESCE(s.NGUOITGT, ds.NGUOIBIDENGHI) ||
        CASE
            WHEN d.GQ_TINHTRANG IN (0, 1) THEN '<br/>(Kháng cáo quá hạn: ' ||
                CASE d.GQ_TINHTRANG
                    WHEN 0 THEN 'Giải quyết'
                    WHEN 1 THEN 'Chưa giải quyết'
                END || ')'
        END AS NguoiKCCapKN,

        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,
        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT
            ID,
            HOTEN || ' - ' || TUCACH  AS NGUOITGT
        FROM
            (
            SELECT
                t.ID,
                t.HOTEN,
                dt.TEN AS TUCACH
            FROM
                XLHC_DON_THAMGIATOTUNG t
            LEFT JOIN DM_DATAITEM dt ON
                t.TUCACHTGTTID = dt.MA
            WHERE
                t.DONID = vDonID
        )
    ) s ON s.ID = d.DUONGSUID
    LEFT JOIN (
        SELECT ID, HOTEN || ' - ' || 'Người bị đề nghị'  AS NGUOIBIDENGHI FROM XLHC_DUONGSU WHERE DONID = vDonID
    ) ds ON ds.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN: Sử dụng TYPE_QD và SOQDBA để match với type trong CTE
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 1) || '|' || d.SOQDBA) = kn.type
    WHERE d.DONID = vDonID AND d.Type = 1

    UNION ALL

    -- Kiến nghị (Type = 2)
    SELECT
        d.ID,
        '2' AS IsKhangCao,
        'Kiến nghị' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        s.TENDUONGSU ||
        CASE
            WHEN d.GQ_TINHTRANG IN (0, 1) THEN '<br/>(Kháng cáo quá hạn: ' ||
                CASE d.GQ_TINHTRANG
                    WHEN 0 THEN 'Giải quyết'
                    WHEN 1 THEN 'Chưa giải quyết'
                END || ')'
        END AS NguoiKCCapKN,
        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,

        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT a.ID, a.CQDN_TEN AS TENDUONGSU
        FROM XLHC_DON a
        WHERE a.ID = vDonID
    ) s ON s.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN tương tự
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 2) || '|' || d.SOQDBA) = kn.type
    WHERE d.DONID = vDonID AND d.Type = 2

    UNION ALL

    -- Kháng nghị (Type = 3)
    SELECT
        d.ID,
        '3' AS IsKhangCao,
        'Kháng nghị' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        (SELECT dv.TEN FROM DM_VKS dv WHERE dv.ID = d.DUONGSUID) ||
        CASE
            WHEN d.GQ_TINHTRANG IN (0, 1) THEN '<br/>(Kháng cáo quá hạn: ' ||
                CASE d.GQ_TINHTRANG
                    WHEN 0 THEN 'Giải quyết'
                    WHEN 1 THEN 'Chưa giải quyết'
                END || ')'
        END AS NguoiKCCapKN,
        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,

        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT a.ID, a.HOTEN AS TENDUONGSU
        FROM XLHC_DUONGSU a
        WHERE a.DONID = vDonID
    ) s ON s.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN tương tự
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 3) || '|' || d.SOQDBA) = kn.type
    WHERE d.DONID = vDonID AND d.Type = 3;

END XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST;

-- Thủ tục lấy danh sách kháng cáo / kiến nghị / kháng nghị
PROCEDURE XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST_V2 (
    vDonID IN NUMBER,
    curReturn OUT SYS_REFCURSOR 
) IS
BEGIN
    OPEN curReturn FOR
    WITH 
    CTE (QUYETDINHID, SO_QUYETDINH, type, record_id) AS (
        -- Từ XLHC_SOTHAM_QUYETDINH: sử dụng ID của record làm key
        SELECT QUYETDINHID, SOQD AS SO_QUYETDINH, '1|' || QUYETDINHID AS TYPE, ID AS record_id
        FROM XLHC_SOTHAM_QUYETDINH     
        WHERE DONID = vDonID 

        UNION ALL  

        -- Từ XLHC_SOTHAM_BANAN: sử dụng QUYETDINHID làm key
        SELECT QUYETDINHID, SOBANAN AS SO_QUYETDINH, '2|' || QUYETDINHID AS TYPE, QUYETDINHID AS record_id
        FROM XLHC_SOTHAM_BANAN ba 
        WHERE DONID = vDonID 

        UNION ALL

        -- Từ XLHC_DONXIN_HOAN_MIEN: sử dụng DM_QUYETDINH_ID làm key
        SELECT DM_QUYETDINH_ID AS QUYETDINHID, TO_CHAR(SO_QUYETDINH) AS SO_QUYETDINH, '3|' || DM_QUYETDINH_ID AS TYPE, DM_QUYETDINH_ID AS record_id
        FROM XLHC_DONXIN_HOAN_MIEN hm
        WHERE hm.DONID = vDonID AND hm.ISGIAIQUYET = 1
    ),
    kn AS ( 
        SELECT c.SO_QUYETDINH, qd.TEN, c.QUYETDINHID, c.type, c.record_id
        FROM CTE c
        JOIN DM_QD_QUYETDINH qd ON c.QUYETDINHID = qd.ID
    )

    SELECT
        d.ID,
        '1' AS IsKhangCao,
        'Khiếu nại' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        COALESCE(s.NGUOITGT, ds.NGUOIBIDENGHI) ||
		CASE
		    WHEN d.ISQUAHAN = 0 THEN ''
		    WHEN d.GQ_ISCHAPNHAN IN (0, 1, 2) THEN
		        '<br/>(Khiếu nại quá hạn: ' ||
		        CASE d.GQ_ISCHAPNHAN
		            WHEN 0 THEN 'Không chấp nhận'
		            WHEN 1 THEN 'Chấp nhận'
		            WHEN 2 THEN 'Đình chỉ'
		        END || ')'
		    ELSE '<br/>(Khiếu nại quá hạn: Chờ duyệt)'
		END AS NguoiKCCapKN,

        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,
        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT
            ID,
            HOTEN || ' - ' || TUCACH  AS NGUOITGT
        FROM
            (
            SELECT
                t.ID,
                t.HOTEN,
                dt.TEN AS TUCACH
            FROM
                XLHC_DON_THAMGIATOTUNG t
            LEFT JOIN DM_DATAITEM dt ON
                t.TUCACHTGTTID = dt.MA
            WHERE
                t.DONID = vDonID
        )
    ) s ON s.ID = d.DUONGSUID
    LEFT JOIN (
        SELECT ID, HOTEN || ' - ' || 'Người bị đề nghị'  AS NGUOIBIDENGHI FROM XLHC_DUONGSU WHERE DONID = vDonID
    ) ds ON ds.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN: Sử dụng TYPE_QD và SOQDBA để match với type trong CTE
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 1) || '|' || d.SOQDBA) = kn.TYPE
    WHERE d.DONID = vDonID AND d.Type = 1

    UNION ALL

    -- Kiến nghị (Type = 2)
    SELECT
        d.ID,
        '2' AS IsKhangCao,
        'Kiến nghị' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        s.TENDUONGSU ||
		CASE
		    WHEN d.ISQUAHAN = 0 THEN ''
		    WHEN d.GQ_ISCHAPNHAN IN (0, 1, 2) THEN
		        '<br/>(Kiến nghị quá hạn: ' ||
		        CASE d.GQ_ISCHAPNHAN
		            WHEN 0 THEN 'Không chấp nhận'
		            WHEN 1 THEN 'Chấp nhận'
		            WHEN 2 THEN 'Đình chỉ'
		        END || ')'
		    ELSE '<br/>(Kiến nghị quá hạn: Chờ duyệt)'
		END AS NguoiKCCapKN,
        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,

        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT a.ID, a.CQDN_TEN AS TENDUONGSU
        FROM XLHC_DON a
        WHERE a.ID = vDonID
    ) s ON s.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN tương tự
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 2) || '|' || d.SOQDBA) = kn.TYPE
    WHERE d.DONID = vDonID AND d.Type = 2

    UNION ALL

    -- Kháng nghị (Type = 3)
    SELECT
        d.ID,
        '3' AS IsKhangCao,
        'Kháng nghị' AS KCKNName,
        CASE d.HINHTHUCNHAN WHEN 0 THEN 'Trực tiếp' WHEN 1 THEN 'Qua bưu điện' END AS HTNhanDonDonViKN,
        (SELECT dv.TEN FROM DM_VKS dv WHERE dv.ID = d.DUONGSUID) ||
		CASE
		    WHEN d.ISQUAHAN = 0 THEN ''
		    WHEN d.GQ_ISCHAPNHAN IN (0, 1, 2) THEN
		        '<br/>(Kháng nghị quá hạn: ' ||
		        CASE d.GQ_ISCHAPNHAN
		            WHEN 0 THEN 'Không chấp nhận'
		            WHEN 1 THEN 'Chấp nhận'
		            WHEN 2 THEN 'Đình chỉ'
		        END || ')'
		    ELSE '<br/>(Kháng nghị quá hạn: Chờ duyệt)'
		END AS NguoiKCCapKN,
        CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án' ELSE 'Quyết định' END AS LoaiKCKN,
        d.NGAYKHANGCAO AS NgayKCKN,

        d.NGAYQDBA AS NGAYQDBA,
        d.NGUOITAO,
        d.NGAYTAO,
        d.TENFILE,
        kn.TEN AS tenquyetdinh,
        kn.SO_QUYETDINH AS SO_QDBA
    FROM XLHC_SOTHAM_KHANGCAO d
    LEFT JOIN (
        SELECT a.ID, a.HOTEN AS TENDUONGSU
        FROM XLHC_DUONGSU a
        WHERE a.DONID = vDonID
    ) s ON s.ID = d.DUONGSUID
    -- SỬA ĐIỀU KIỆN JOIN tương tự
    LEFT JOIN kn ON  (COALESCE(d.TYPE_QD, 3) || '|' || d.SOQDBA) = kn.TYPE
    WHERE d.DONID = vDonID AND d.Type = 3;

END XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST_V2;

    -- Thủ tục lấy tên người dùng và VKS cùng cấp
    PROCEDURE GETNAME_KHANGNGHI (
        p_user_id IN NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN curReturn FOR
        SELECT 

                dv.ID AS VKSID,
                dv.TEN AS TEN_VKS,
                dv.LOAIVKS
            FROM
                QT_NGUOISUDUNG qn
            LEFT JOIN DM_VKS dv ON dv.TOAANID  = qn.DONVIID
            WHERE qn.ID = p_user_id;
    END GETNAME_KHANGNGHI;

PROCEDURE GETNAME_KHANGNGHI_ADMIN (
        p_donvi_id IN NUMBER,
		curReturn OUT SYS_REFCURSOR
    ) IS
BEGIN
	OPEN curReturn FOR
	SELECT
		dv.ID AS VKSID,
		dv.TEN AS TEN_VKS,
		dv.LOAIVKS
	FROM
		DM_VKS dv 
	WHERE
		dv.TOAANID  = p_donvi_id;
END GETNAME_KHANGNGHI_ADMIN;

PROCEDURE SP_GET_KIENNGHI_QD (
    p_DonID IN NUMBER,
    p_Cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_Cursor FOR
    WITH CTE AS (

    	SELECT xsq.QUYETDINHID, xsq.SOQD AS SO_QUYETDINH, '1|' || xsq.SOQD AS type
        FROM XLHC_SOTHAM_QUYETDINH  xsq
        INNER JOIN DM_QD_QUYETDINH dqq on dqq.ID = xsq.QUYETDINHID
        WHERE DONID = p_DonID AND  dqq.ID = 463

   		UNION ALL

        SELECT QUYETDINHID, SOBANAN AS SO_QUYETDINH, '2|' || SOBANAN AS type
        FROM XLHC_SOTHAM_BANAN 
        WHERE DONID = p_DonID


        UNION ALL

        SELECT DM_QUYETDINH_ID AS QUYETDINHID, TO_CHAR(SO_QUYETDINH) AS SO_QUYETDINH, '3|' || TO_CHAR(SO_QUYETDINH) AS type
        FROM XLHC_DONXIN_HOAN_MIEN
        WHERE DONID = p_DonID AND ISGIAIQUYET = 1
    )
    SELECT c.SO_QUYETDINH, qd.TEN, c.QUYETDINHID, c.type
    FROM CTE c
    JOIN DM_QD_QUYETDINH qd ON c.QUYETDINHID = qd.ID;
END SP_GET_KIENNGHI_QD;


PROCEDURE SP_GET_NGUOITHAMGIA_TT (
    p_donid IN NUMBER,
    p_result OUT SYS_REFCURSOR
)
IS
BEGIN
OPEN p_result FOR
    SELECT 
    	(ntt.HOTEN || ' - ' || tctt.TTCTT) AS HOTEN, 
        ntt.ID AS ID
    FROM XLHC_DON_THAMGIATOTUNG ntt
    INNER JOIN (
        SELECT
            i.ID,
            i.MA,
            i.TEN AS TTCTT,
            (CASE
                WHEN SOCAP = 2 THEN '...'
                WHEN SOCAP = 3 THEN '......'
                ELSE ''
            END || i.TEN) AS MA_TEN
        FROM DM_DATAITEM i
        INNER JOIN DM_DATAGROUP g ON g.ID = i.GROUPID
        WHERE g.MA = 'TUCACHTGTTBPXLHC' AND i.HIEULUC = 1
    ) tctt ON tctt.MA = ntt.TUCACHTGTTID
    WHERE ntt.DONID = p_donid;

END SP_GET_NGUOITHAMGIA_TT;

END PKG_XLHC_ST_KNKNKN_V2;

/
