using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Module.Common;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;
using System.Globalization;
using System.Configuration;

namespace BL.GSTP
{
    /// <summary>
    /// Optimized GDTTT_DON search using CTE paginate-first pattern (optC).
    /// Reduces buffer gets from ~4.6B to ~10K by:
    /// 1. Paginating FIRST on GDTTT_DON alone (30 rows)
    /// 2. Consolidating 7 SOPHATHANH scans into 1 CTE with pivot
    /// 3. Consolidating 5 KETQUA_DON scans into 1 CTE with pivot
    /// 4. Consolidating 3 DUONGSU LISTAGG scans into 1 CTE
    ///
    /// Reference: rewrite_gmjh84nq2bkd8_optC.sql
    /// </summary>
    public class GdtttDonSearchOptimized
    {
        /// <summary>
        /// Optimized search method using paginate-first CTE pattern.
        /// Key improvement: All expensive JOINs run on only 30 rows instead of ~11K.
        /// </summary>
        public DataTable GDTTT_DON_SEARCH(
            decimal V_GET_LIS_ID,
            String V_NDBD_VALUE, String V_NDBD_TEXT,
            String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB,
            String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM,
            String V_NGAY_TO, String V_NGUOI_GUI_BT,
            String v_ID_USER,
            decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND,
            DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon,
            decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
            string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI,
            DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen,
            string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly,
            DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly,
            decimal vChidao, decimal vTraigiam, decimal vTBQuahan,
            DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID,
            DateTime? vNgayNhapTu, DateTime? vNgayNhapDen,
            decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn,
            string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ,
            decimal vGuitoiCA_TA, decimal vLOAI_GDTTT,
            decimal PageIndex, decimal PageSize
        )
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;

                StringBuilder sql = new StringBuilder();
                var parameters = new List<OracleParameter>();

                /* ============================================================
                 * LAYER 0: Paginate-first CTE (optC optimization)
                 * Only materialize ID, VUVIECID for pagination.
                 * All downstream CTEs filter by these IDs (30 rows max).
                 * ============================================================ */

                if (PageSize > 0)
                {
                    // Normal paginated mode
                    parameters.Add(new OracleParameter(":vToaAnID", OracleDbType.Decimal) { Value = vToaAnID });
                    sql.AppendLine(@"
WITH don_page AS (
    SELECT /*+ MATERIALIZE */ ID, VUVIECID, STT
    FROM (
        SELECT d.ID,
               d.VUVIECID,
               ROW_NUMBER() OVER (ORDER BY d.NGAYTAO DESC) STT
        FROM   GDTTT_DON d
        WHERE  d.TOAANID = :vToaAnID
        AND    NVL(d.CD_TA_TRANGTHAI, 0) IN (0, 1)");
                }
                else if (V_GET_LIS_ID == 1)
                {
                    // List IDs mode - no pagination, just get IDs
                    parameters.Add(new OracleParameter(":vToaAnID", OracleDbType.Decimal) { Value = vToaAnID });
                    sql.AppendLine(@"
SELECT RTRIM(XMLAGG(XMLELEMENT(E, d.ID, ',').EXTRACT('//text()') ORDER BY d.ID).GetClobVal(), ',') AS LIST_ID
FROM   GDTTT_DON d
WHERE  d.TOAANID = :vToaAnID
AND    NVL(d.CD_TA_TRANGTHAI, 0) IN (0, 1)");
                }
                else if (V_GET_LIS_ID == 2)
                {
                    // Count mode — preserves original inflated count from ALL LEFT JOINs.
                    // Uses CTE + dd_map rewrite: O(N) HASH JOIN instead of O(N²) MERGE JOIN.
                    // v2.3: ALL original JOINs included for exact count parity.
                    parameters.Add(new OracleParameter(":vToaAnID", OracleDbType.Decimal) { Value = vToaAnID });
                    sql.AppendLine(@"
WITH base AS (
    SELECT /*+ MATERIALIZE */
           d.ID, d.ARR_DON_ID, d.VUVIECID, d.CD_TA_DONVIID,
           d.LOAIDON, d.DONVICHUYEN_HSKN, d.NGUOIGUI_HUYENID,
           d.CV_HUYENID, d.CD_TK_DONVIID, d.BAQD_CAPXETXU,
           d.BAQD_TOAANID, d.BAQD_TOAANID_ST, d.BAQD_TOAANID_PT,
           d.CANBO_ID_GIAIQUYET_KN, d.THAMPHANID, d.NGUOITAO,
           d.NGUOIKHANGNGHI, d.BAQD_LOAIAN
    FROM   GDTTT_DON d
    WHERE  d.TOAANID = :vToaAnID
    AND    NVL(d.CD_TA_TRANGTHAI, 0) IN (0, 1)");
                }

                /* ============================================================
                 * Resolve ThamphanID with PCA/CA role check
                 * Original uses EF LINQ; we use a single SQL lookup
                 * ============================================================ */
                decimal resolvedThamphanID = ResolveThamphanID(vThamphanID, v_ID_USER);

                /* ============================================================
                 * Build dynamic WHERE clauses for don_page CTE
                 * All filters go HERE (before any joins) for optC pattern
                 * ============================================================ */
                StringBuilder whereClause = BuildWhereClause(
                    parameters,
                    vIsThuLy, vLoaiAn, vSoBAQD, vNgayBAQD, vToaRaBAQD,
                    vNguoiGui, vSoCMND, vTuNgay, vDenNgay, vHinhThucDon,
                    vSoHieuDon, vDiaChiTinh, vDiaChiHuyen, vCD_TENDONVI,
                    vNoiChuyen, vLoaiSoVB, vSoVanBan, vNgayVanBan, vCVPC_So,
                    vCVPC_Ngay, vCVPC_TenCQ, vTraLoi, vNguoiNhap, vTrangthai,
                    vCD_DONVIID, vCD_TA_TRANGTHAI, vNgaychuyenTu, vNgaychuyenDen,
                    vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam,
                    vTBQuahan, vNgayQuahan, vThamphanID, vToaAnID,
                    // Additional filters
                    vNgayNhapTu, vNgayNhapDen, vIsDonGoc, vIsTuHinh,
                    vThamtravienID, vLoaiCVID, vGuitoiCA_TA, vLOAI_GDTTT,
                    V_NDBD_TEXT, V_NDBD_VALUE, V_DONVI_CHUYEN_ID, V_TRANGTHAICHUYEN,
                    V_LOAI_VB, V_SODEN_TU, V_SODEN_DEN, V_NGAY_FROM, V_NGAY_TO,
                    V_NGUOI_GUI_BT, vArrSelectID, v_ID_USER,
                    vPhanloaixuly, resolvedThamphanID
                );

                if (PageSize > 0)
                {
                    sql.AppendLine(whereClause.ToString());
                    sql.AppendLine("    )");  // close inner subquery
                    parameters.Add(new OracleParameter(":minIndex", OracleDbType.Decimal) { Value = MinIndex });
                    parameters.Add(new OracleParameter(":maxIndex", OracleDbType.Decimal) { Value = MaxIndex });
                    sql.AppendLine("    WHERE STT BETWEEN :minIndex AND :maxIndex");
                    sql.AppendLine("),");  // close don_page

                    /* ============================================================
                     * v2.3: total_inflated CTE — COUNT(*) with ALL original JOINs.
                     * Matches the original's 1:N-inflated TotalItem exactly.
                     * Only does COUNT — no column data fetched (fast).
                     * Independent of don_page; Oracle can parallelize.
                     * ============================================================ */
                    sql.AppendLine(@"
total_inflated AS (
    SELECT /*+ MATERIALIZE */ COUNT(*) cnt
    FROM   GDTTT_DON d
    /* --- Replicate ALL original LEFT JOINs (join-key only for speed) --- */
    /* SOPHATHANH 1:N (7 joins, same subquery pattern as original) */
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoGXN') sph ON sph.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoGXN_DV') gxndv ON gxndv.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO IN ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon')) SoCVC ON SoCVC.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTT') SoTT ON SoTT.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTTXX') SoTTXX ON SoTTXX.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTT_TLL') SoTT_TLL ON SoTT_TLL.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM QUANLY_SOPHATHANH so LEFT JOIN SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'TBTP' AND so.TRANGTHAI = 1) QLS ON QLS.DONID = d.ID
    /* tralai — FIRST_VALUE deduplication (1:1, included for parity) */
    LEFT JOIN (SELECT v.DONID FROM GDTTT_DON_CHUYEN_HISTORY v INNER JOIN (SELECT TT.DONID, TT.ID FROM (SELECT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM GDTTT_DON_CHUYEN_HISTORY) TT GROUP BY TT.DONID, TT.ID) t ON t.ID = v.ID WHERE v.PHONGBANCHUYENID = 1) tralai ON tralai.DONID = d.ID
    /* Dimension JOINs (1:1 via PK, included for exact count parity) */
    LEFT JOIN DM_LOAIDON LAD ON LAD.LOAIDON_ID = d.LOAIDON AND LAD.TOAAN_ID = :vToaAnID
    LEFT JOIN GDTTT_VUAN va ON va.ID = d.VUVIECID
    LEFT JOIN DM_VKS KS ON KS.ID = d.DONVICHUYEN_HSKN
    LEFT JOIN (SELECT v.ID FROM GDTTT_VUAN v WHERE v.GQD_LOAIKETQUA = 1 AND (TRIM(v.XXGDTTT_SOQD) IS NOT NULL OR LENGTH(NVL(v.XXGDTTT_NGAYQD,'')) > 0)) kq ON kq.ID = d.VUVIECID
    /* DON_TRALOI 1:N */
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_TRALOI WHERE TYPETB = 3) TLD ON TLD.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_TRALOI WHERE TYPETB = 4) KN ON KN.DONID = d.ID
    /* VUAN_KETQUA_DON 1:N */
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 0 AND TRANGTHAI = 1) TLD_DS ON TLD_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 1 AND TRANGTHAI = 1) KN_DS ON KN_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 3 AND TRANGTHAI = 1) XLK_DS ON XLK_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 2 AND TRANGTHAI = 1) XD_DS ON XD_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 2 AND TRANGTHAI = 1) VKSGQ_DS ON VKSGQ_DS.DONID = d.ID
    /* THA (1:1 via PK) */
    LEFT JOIN GDTTT_VUAN THA ON THA.ID = d.VUVIECID
    LEFT JOIN DM_LOAIAN LA ON LA.ID = d.BAQD_LOAIAN
    LEFT JOIN DM_HANHCHINH h ON h.ID = d.NGUOIGUI_HUYENID
    LEFT JOIN DM_HANHCHINH hv ON hv.ID = d.CV_HUYENID
    LEFT JOIN DM_TOAAN tk ON tk.ID = d.CD_TK_DONVIID
    LEFT JOIN DM_TOAAN txx ON txx.ID = DECODE(d.BAQD_CAPXETXU, 2, d.BAQD_TOAANID_ST, 3, d.BAQD_TOAANID_PT, d.BAQD_TOAANID)
    LEFT JOIN DM_TOAAN txxPT ON txxPT.ID = d.BAQD_TOAANID_PT
    LEFT JOIN DM_TOAAN txxST ON txxST.ID = d.BAQD_TOAANID_ST
    LEFT JOIN DM_PHONGBAN pb ON pb.ID = d.CD_TA_DONVIID
    LEFT JOIN DM_CANBO gqkn ON gqkn.ID = d.CANBO_ID_GIAIQUYET_KN
    LEFT JOIN DM_CANBO c ON c.ID = d.THAMPHANID
    LEFT JOIN DM_DATAITEM chucdanh ON chucdanh.ID = c.CHUCDANHID
    LEFT JOIN QT_NGUOISUDUNG nsd ON nsd.USERNAME = d.NGUOITAO
    LEFT JOIN DM_DATAITEM i ON i.ID = d.NGUOIKHANGNGHI
    /* VT + VBD (vt is 1:N) */
    LEFT JOIN VT_CHUYEN_NHAN vt ON vt.GDTTT_DON_ID = d.ID
    LEFT JOIN VT_VANBANDEN vbd ON vbd.ID = vt.VANBANDEN_ID
    LEFT JOIN DM_TOAAN pbvt ON pbvt.ID = vt.DONVI_CHUYEN_ID
    LEFT JOIN DM_TOAAN TA_cnt ON TA_cnt.ID = vbd.TOAAN_BAQD_DON
    /* DUONGSU (GROUP BY = 1:1) */
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cc.TUCACHTOTUNG = 'NGUYENDON' AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7) GROUP BY cc.DONID) nds ON nds.DONID = d.ID
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cc.TUCACHTOTUNG = 'BIDON' AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7) GROUP BY cc.DONID) bds ON bds.DONID = d.ID
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cd.BAQD_LOAIAN = 1 AND cc.TUCACHTOTUNG = 'BIDON' GROUP BY cc.DONID) bcs ON bcs.DONID = d.ID
    /* Self-join TTC (1:1) */
    LEFT JOIN GDTTT_DON TTC ON TTC.ID = d.ID
    /* DON_CHUYEN / HISTORY 1:N */
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_CHUYEN WHERE PHONGBANNHANID = 102) DC ON DC.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_CHUYEN_HISTORY WHERE PHONGBANNHANID = 102) DC_HIS ON DC_HIS.DONID = d.ID
    LEFT JOIN (SELECT DONID, PHONGBANNHANID FROM GDTTT_DON_CHUYEN) DTL_NC ON DTL_NC.DONID = d.ID AND DTL_NC.PHONGBANNHANID = d.CD_TA_DONVIID
    /* VUAN_CHITIET_CHUYEN 1:N (ctc depends on va) */
    LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc ON va.ID = ctc.VUANID AND ctc.TRANGTHAI = 2 AND NVL(ctc.THAMPHANID, 0) <> 0
    LEFT JOIN DM_CANBO tptc ON tptc.ID = ctc.THAMPHANID
    /* SOPHATHANH_VUAN (depends on va) */
    LEFT JOIN (SELECT sp.VUANID FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 WHERE spgd.MASO = 'SoTT') sphTT ON va.ID = sphTT.VUANID
    LEFT JOIN (SELECT sp.VUANID FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 WHERE spgd.MASO = 'TBTP') sphTB ON va.ID = sphTB.VUANID
    WHERE  d.TOAANID = :vToaAnID
    AND    NVL(d.CD_TA_TRANGTHAI, 0) IN (0, 1)");
                    sql.AppendLine(whereClause.ToString());
                    sql.AppendLine("),");

                    /* ============================================================
                     * LAYER 2: Consolidated CTEs (optC optimization)
                     * Each CTE replaces multiple LEFT JOINs from original.
                     * All filtered by don_page IDs (30 rows).
                     * ============================================================ */

                    // LAYER 2a: sph_all - consolidates 7 SOPHATHANH LEFT JOINs
                    sql.AppendLine(@"
sph_all AS (
    SELECT sd.DONID,
           so.MASO,
           so.SOVB,
           so.NGAYVB,
           so.NGUOIKY
    FROM   QUANLY_SOPHATHANH so
    JOIN   SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID
    WHERE  sd.DONID IN (SELECT ID FROM don_page)
    AND    so.MASO IN (
               'SoGXN', 'SoGXN_DV',
               'SoCVC', 'SoCVCN', 'SoCVCTK', 'SoTralaidon',
               'SoTT', 'SoTTXX', 'SoTT_TLL'
           )
),
qls AS (
    SELECT sd.DONID, so.SOVB, so.NGAYVB
    FROM   QUANLY_SOPHATHANH so
    JOIN   SOPHATHANH_DON sd ON so.ID = sd.SOPHATHANH_ID
    WHERE  sd.DONID IN (SELECT ID FROM don_page)
    AND    so.MASO      = 'TBTP'
    AND    so.TRANGTHAI = 1
),");

                    // LAYER 2b: kqd_all - consolidates 5 KETQUA_DON LEFT JOINs
                    sql.AppendLine(@"
kqd_all AS (
    SELECT TK.DONID,
           TK.LOAI,
           TK.SO,
           TK.NGAY,
           TK.NOIDUNGKHANGNGHI
    FROM   GDTTT_VUAN_KETQUA_DON TK
    WHERE  TK.DONID      IN (SELECT ID FROM don_page)
    AND    TK.TRANGTHAI  = 1
    AND    TK.LOAI       IN (0, 1, 2, 3)
),");

                    // LAYER 2c: traloi_all - consolidates 2 TRALOI LEFT JOINs
                    sql.AppendLine(@"
traloi_all AS (
    SELECT TK.DONID,
           TK.TYPETB,
           TK.SO,
           TK.NGAY,
           TK.NOIDUNGKHANGNGHI
    FROM   GDTTT_DON_TRALOI TK
    WHERE  TK.DONID  IN (SELECT ID FROM don_page)
    AND    TK.TYPETB IN (3, 4)
),");

                    // LAYER 2d: tralai - last return note per DON
                    sql.AppendLine(@"
tralai AS (
    SELECT v.DONID, v.GHICHU
    FROM   GDTTT_DON_CHUYEN_HISTORY v
    INNER JOIN (
        SELECT DONID,
               MAX(ID) KEEP (DENSE_RANK LAST ORDER BY NGAYTRA) AS ID
        FROM   GDTTT_DON_CHUYEN_HISTORY
        WHERE  DONID IN (SELECT ID FROM don_page)
        GROUP BY DONID
    ) t ON t.ID = v.ID
    WHERE  v.PHONGBANCHUYENID = 1
),");

                    // LAYER 2e: duongsu_all - consolidates 3 LISTAGG subqueries
                    sql.AppendLine(@"
duongsu_all AS (
    SELECT cc.DONID,
           cc.TUCACHTOTUNG,
           cd.BAQD_LOAIAN,
           UPPER(LISTAGG(CAST(cc.TENDUONGSU AS VARCHAR2(500)), ',')
                 WITHIN GROUP (ORDER BY cc.TENDUONGSU)) AS TENDUONGSU
    FROM   GDTTT_DON_DUONGSU_CC cc
    INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID
    WHERE  cc.DONID IN (SELECT ID FROM don_page)
    AND    (   (cc.TUCACHTOTUNG = 'NGUYENDON' AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7))
            OR (cc.TUCACHTOTUNG = 'BIDON'     AND cd.BAQD_LOAIAN IN (1,2,3,4,5,6,7))
           )
    GROUP BY cc.DONID, cc.TUCACHTOTUNG, cd.BAQD_LOAIAN
),");

                    // LAYER 2f: chuyen_all - consolidates DON_CHUYEN accesses
                    sql.AppendLine(@"
chuyen_all AS (
    SELECT tc.DONID,
           tc.PHONGBANNHANID,
           tc.TRANGTHAI,
           tc.NGAYCHUYEN
    FROM   GDTTT_DON_CHUYEN tc
    WHERE  tc.DONID IN (SELECT ID FROM don_page)
),");

                    // LAYER 2g: vuan master
                    sql.AppendLine(@"
vuan AS (
    SELECT va.ID, va.LOAIAN, va.GQD_LOAIKETQUA, va.GDQ_SO, va.GDQ_NGAY,
           va.XXGDTTT_SOQD, va.XXGDTTT_NGAYQD, va.GQD_NgayPhatHanhCV,
           va.SOTHULYXXGDT, va.NGAYTHULYXXGDT, va.IsVienTruongKN,
           va.GQD_ISHOANTHA, va.GQD_HOANTHA_SO, va.GQD_HOANTHA_NGAY,
           va.XXGDTTT_KETQUAID
    FROM   GDTTT_VUAN va
    WHERE  va.ID IN (SELECT VUVIECID FROM don_page WHERE VUVIECID IS NOT NULL)
),");

                    /* ============================================================
                     * N+1 ELIMINATION CTEs - Replace per-row queries
                     * These CTEs eliminate ~90 extra round trips per page
                     * ============================================================ */

                    // ycbs_all - YCBS notification (replaces lines 1170-1177 of original)
                    sql.AppendLine(@"
ycbs_all AS (
    SELECT y.DONID,
           'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO
           || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') AS YCBS
    FROM GDTTT_DON_YEUCAU_BOSUNG y
    WHERE y.DONID IN (SELECT ID FROM don_page)
    AND y.LANTHU = (SELECT MAX(LANTHU)
                    FROM GDTTT_DON_YEUCAU_BOSUNG
                    WHERE DONID = y.DONID)
),");

                    // thoihieu_all - Statute of limitations calculation (replaces lines 1190-1214 of original)
                    sql.AppendLine(@"
thoihieu_all AS (
    SELECT d.ID AS DONID,
           CASE
             WHEN PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) <= 60
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) > 0
               AND d.BAQD_CAPXETXU = 2
             THEN '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
             WHEN PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) <= 30
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) > 0
               AND d.BAQD_CAPXETXU != 2
             THEN '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
             WHEN PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 0
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 60
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) > 0
               AND d.BAQD_CAPXETXU = 2
             THEN '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
             WHEN PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 0
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 30
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) > 0
               AND d.BAQD_CAPXETXU != 2
             THEN '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
             WHEN PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 0
               AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,DECODE(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,DECODE(d.ISTH_ANGIAM,1,1,DECODE(d.ISTH_KEUOAN,1,1,0))) < 0
             THEN '(Hết thời hiệu giải quyết) '
             ELSE ''
           END AS THOIHIEU
    FROM GDTTT_DON d
    WHERE d.ID IN (SELECT ID FROM don_page)
),");

                    /* Task 5: Missing CTEs for KN case assignment and VAKN books */

                    // ctc_all - KN case assignment (replaces original lines 75-79)
                    sql.AppendLine(@"
ctc_all AS (
    SELECT ctc.VUANID AS VUAN_ID,
           ctc.THAMPHANID,
           ctc.TRANGTHAICHUYENTP,
           ctc.NGAYCHUYENTP,
           tptc.HOTEN AS THAMPHANTC_TEN
    FROM GDTTT_VUAN_CHITIET_CHUYEN ctc
    LEFT JOIN DM_CANBO tptc ON tptc.ID = ctc.THAMPHANID
    WHERE ctc.VUANID IN (SELECT VUVIECID FROM don_page WHERE VUVIECID IS NOT NULL)
    AND ctc.TRANGTHAI = 2
    AND NVL(ctc.THAMPHANID, 0) <> 0
),");

                    // sph_vakn - SOPHATHANH for VAKN books (replaces original lines 80-83)
                    sql.AppendLine(@"
sph_vakn AS (
    SELECT sp.VUANID AS VUAN_ID,
           spgd.MASO,
           spgd.SOVB,
           spgd.NGAYVB
    FROM SOPHATHANH_VUAN sp
    JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1
    WHERE sp.VUANID IN (SELECT VUVIECID FROM don_page WHERE VUVIECID IS NOT NULL)
    AND spgd.MASO IN ('SoTT', 'TBTP')
)");

                    /* ============================================================
                     * MAIN QUERY: Join back to GDTTT_DON by PK (30 rows only)
                     * All expensive operations now run on 30 rows, not ~11K
                     * ============================================================ */
                    sql.AppendLine(@"
SELECT a.*, a.TotalItem CountAll
FROM (
    SELECT");
                    BuildSelectClause(sql, vToaAnID);
                    sql.AppendLine(@"
    /* Join back to GDTTT_DON base table via PK, driven by don_page (30 rows) */
    FROM don_page dp
    JOIN GDTTT_DON d ON d.ID = dp.ID");

                    BuildLeftJoins(sql, vToaAnID);
                    BuildGroupBy(sql);
                    sql.AppendLine(") a");
                    sql.AppendLine("ORDER BY a.STT");
                }

                // Handle non-paginated modes
                else if (V_GET_LIS_ID == 1)
                {
                    sql.AppendLine(whereClause.ToString());
                }
                else if (V_GET_LIS_ID == 2)
                {
                    // Append dynamic WHERE to base CTE, then close CTE and add
                    // dd_map + all 1:N LEFT JOINs to preserve original inflated count.
                    sql.AppendLine(whereClause.ToString());
                    sql.AppendLine(@"
),
dd_map AS (
    /* DD self-JOIN rewrite: OR → UNION with equi-joins (index-friendly).
     * UNION (not UNION ALL) deduplicates DD rows matching multiple legs.
     * Leg A: self-match (every base row matches itself)
     * Leg B: DD with status (2,3) pointing to base row via ARR_DON_ID
     * Leg C: DD with status (2,3) sharing same ARR_DON_ID as base row */
    SELECT D_ID, DD_ID FROM (
        SELECT ID AS D_ID, ID AS DD_ID FROM base
        UNION
        SELECT b.ID, dd.ID
        FROM   base b
        JOIN   GDTTT_DON dd ON dd.ARR_DON_ID = b.ID
        WHERE  dd.CD_TA_TRANGTHAI IN (2, 3)
        UNION
        SELECT b.ID, dd.ID
        FROM   base b
        JOIN   GDTTT_DON dd ON dd.ARR_DON_ID = b.ARR_DON_ID
        WHERE  b.ARR_DON_ID > 0
        AND    dd.CD_TA_TRANGTHAI IN (2, 3)
    )
)
SELECT COUNT(*) TONG_SODON
FROM (
    SELECT d.ID
    FROM   base d
    /* DD self-JOIN (CTE, equi-join) */
    LEFT JOIN dd_map ON dd_map.D_ID = d.ID
    /* SOPHATHANH 1:N JOINs (join key only) */
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoGXN') sph ON sph.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoGXN_DV') gxndv ON gxndv.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO IN ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon')) SoCVC ON SoCVC.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTT') SoTT ON SoTT.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTTXX') SoTTXX ON SoTTXX.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'SoTT_TLL') SoTT_TLL ON SoTT_TLL.DONID = d.ID
    LEFT JOIN (SELECT sd.DONID FROM SOPHATHANH_DON sd JOIN QUANLY_SOPHATHANH so ON so.ID = sd.SOPHATHANH_ID WHERE so.MASO = 'TBTP' AND so.TRANGTHAI = 1) QLS ON QLS.DONID = d.ID
    /* DON_TRALOI 1:N JOINs */
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_TRALOI WHERE TYPETB = 3) TLD ON TLD.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_TRALOI WHERE TYPETB = 4) KN ON KN.DONID = d.ID
    /* VUAN_KETQUA_DON 1:N JOINs */
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 0 AND TRANGTHAI = 1) TLD_DS ON TLD_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 1 AND TRANGTHAI = 1) KN_DS ON KN_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 3 AND TRANGTHAI = 1) XLK_DS ON XLK_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 2 AND TRANGTHAI = 1) XD_DS ON XD_DS.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_VUAN_KETQUA_DON WHERE LOAI = 2 AND TRANGTHAI = 1) VKSGQ_DS ON VKSGQ_DS.DONID = d.ID
    /* VT_CHUYEN_NHAN (1:N) */
    LEFT JOIN VT_CHUYEN_NHAN vt ON vt.GDTTT_DON_ID = d.ID
    /* DON_CHUYEN / DON_CHUYEN_HISTORY 1:N JOINs */
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_CHUYEN WHERE PHONGBANNHANID = 102) DC ON DC.DONID = d.ID
    LEFT JOIN (SELECT DONID FROM GDTTT_DON_CHUYEN_HISTORY WHERE PHONGBANNHANID = 102) DC_HIS ON DC_HIS.DONID = d.ID
    LEFT JOIN (SELECT DONID, PHONGBANNHANID FROM GDTTT_DON_CHUYEN) DTL_NC ON DTL_NC.DONID = d.ID AND DTL_NC.PHONGBANNHANID = d.CD_TA_DONVIID
    /* VUAN-dependent JOINs (va.ID replaced with d.VUVIECID) */
    LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc ON d.VUVIECID = ctc.VUANID AND ctc.TRANGTHAI = 2 AND NVL(ctc.THAMPHANID, 0) <> 0
    LEFT JOIN (SELECT sp.VUANID FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 WHERE spgd.MASO = 'SoTT') sphTT ON d.VUVIECID = sphTT.VUANID
    LEFT JOIN (SELECT sp.VUANID FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 WHERE spgd.MASO = 'TBTP') sphTB ON d.VUVIECID = sphTB.VUANID
    /* v2.3: Missing JOINs from original — included for exact count parity */
    /* tralai (1:1 via FIRST_VALUE dedup) */
    LEFT JOIN (SELECT v.DONID FROM GDTTT_DON_CHUYEN_HISTORY v INNER JOIN (SELECT TT.DONID, TT.ID FROM (SELECT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM GDTTT_DON_CHUYEN_HISTORY) TT GROUP BY TT.DONID, TT.ID) t ON t.ID = v.ID WHERE v.PHONGBANCHUYENID = 1) tralai ON tralai.DONID = d.ID
    /* Dimension JOINs (1:1 via PK, included for exact parity) */
    LEFT JOIN DM_LOAIDON LAD ON LAD.LOAIDON_ID = d.LOAIDON AND LAD.TOAAN_ID = :vToaAnID
    LEFT JOIN GDTTT_VUAN va ON va.ID = d.VUVIECID
    LEFT JOIN DM_VKS KS ON KS.ID = d.DONVICHUYEN_HSKN
    LEFT JOIN (SELECT v.ID FROM GDTTT_VUAN v WHERE v.GQD_LOAIKETQUA = 1 AND (TRIM(v.XXGDTTT_SOQD) IS NOT NULL OR LENGTH(NVL(v.XXGDTTT_NGAYQD,'')) > 0)) kq ON kq.ID = d.VUVIECID
    LEFT JOIN GDTTT_VUAN THA ON THA.ID = d.VUVIECID
    LEFT JOIN DM_LOAIAN LA ON LA.ID = d.BAQD_LOAIAN
    LEFT JOIN DM_HANHCHINH h ON h.ID = d.NGUOIGUI_HUYENID
    LEFT JOIN DM_HANHCHINH hv ON hv.ID = d.CV_HUYENID
    LEFT JOIN DM_TOAAN tk ON tk.ID = d.CD_TK_DONVIID
    LEFT JOIN DM_TOAAN txx ON txx.ID = DECODE(d.BAQD_CAPXETXU, 2, d.BAQD_TOAANID_ST, 3, d.BAQD_TOAANID_PT, d.BAQD_TOAANID)
    LEFT JOIN DM_TOAAN txxPT ON txxPT.ID = d.BAQD_TOAANID_PT
    LEFT JOIN DM_TOAAN txxST ON txxST.ID = d.BAQD_TOAANID_ST
    LEFT JOIN DM_PHONGBAN pb ON pb.ID = d.CD_TA_DONVIID
    LEFT JOIN DM_CANBO gqkn ON gqkn.ID = d.CANBO_ID_GIAIQUYET_KN
    LEFT JOIN DM_CANBO c ON c.ID = d.THAMPHANID
    LEFT JOIN DM_DATAITEM chucdanh ON chucdanh.ID = c.CHUCDANHID
    LEFT JOIN QT_NGUOISUDUNG nsd ON nsd.USERNAME = d.NGUOITAO
    LEFT JOIN DM_DATAITEM i ON i.ID = d.NGUOIKHANGNGHI
    LEFT JOIN VT_VANBANDEN vbd ON vbd.ID = vt.VANBANDEN_ID
    LEFT JOIN DM_TOAAN pbvt ON pbvt.ID = vt.DONVI_CHUYEN_ID
    LEFT JOIN DM_TOAAN TA_cnt ON TA_cnt.ID = vbd.TOAAN_BAQD_DON
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cc.TUCACHTOTUNG = 'NGUYENDON' AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7) GROUP BY cc.DONID) nds ON nds.DONID = d.ID
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cc.TUCACHTOTUNG = 'BIDON' AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7) GROUP BY cc.DONID) bds ON bds.DONID = d.ID
    LEFT JOIN (SELECT cc.DONID FROM GDTTT_DON_DUONGSU_CC cc INNER JOIN GDTTT_DON cd ON cd.ID = cc.DONID WHERE cd.BAQD_LOAIAN = 1 AND cc.TUCACHTOTUNG = 'BIDON' GROUP BY cc.DONID) bcs ON bcs.DONID = d.ID
    LEFT JOIN GDTTT_DON TTC ON TTC.ID = d.ID
    LEFT JOIN DM_CANBO tptc ON tptc.ID = ctc.THAMPHANID
) a");
                }

                DataTable tbl = ExecuteQuery(sql.ToString(), parameters);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    PostProcessResults(tbl, vToaAnID, v_ID_USER);
                }
                return tbl;
            }
            catch (Exception ex)
            {
                LogError("GDTTT_DON_SEARCH", ex);
                DataTable errTbl = new DataTable();
                errTbl.Columns.Add("SQL", typeof(string));
                DataRow _row = errTbl.NewRow();
                _row["SQL"] = ex.Message;
                errTbl.Rows.Add(_row);
                return errTbl;
            }
        }

        /// <summary>
        /// Builds dynamic WHERE clause for don_page CTE.
        /// All filters applied BEFORE pagination (optC key optimization).
        /// All user inputs use bind parameters for security and cursor sharing.
        /// </summary>
        private StringBuilder BuildWhereClause(
            List<OracleParameter> parameters,
            decimal vIsThuLy, decimal vLoaiAn, string vSoBAQD, string vNgayBAQD,
            decimal vToaRaBAQD, string vNguoiGui, string vSoCMND,
            DateTime? vTuNgay, DateTime? vDenNgay, decimal vHinhThucDon,
            string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vCD_TENDONVI, decimal vNoiChuyen, string vLoaiSoVB,
            string vSoVanBan, string vNgayVanBan, string vCVPC_So,
            string vCVPC_Ngay, string vCVPC_TenCQ, decimal vTraLoi,
            string vNguoiNhap, decimal vTrangthai, decimal vCD_DONVIID,
            decimal vCD_TA_TRANGTHAI, DateTime? vNgaychuyenTu,
            DateTime? vNgaychuyenDen, DateTime? vNgayThulyTu,
            DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao,
            decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan,
            decimal vThamphanID, decimal vToaAnID,
            // Additional filters from original
            DateTime? vNgayNhapTu, DateTime? vNgayNhapDen,
            decimal vIsDonGoc, decimal vIsTuHinh,
            decimal vThamtravienID, decimal vLoaiCVID,
            decimal vGuitoiCA_TA, decimal vLOAI_GDTTT,
            string V_NDBD_TEXT, string V_NDBD_VALUE,
            string V_DONVI_CHUYEN_ID, string V_TRANGTHAICHUYEN,
            string V_LOAI_VB, string V_SODEN_TU, string V_SODEN_DEN,
            string V_NGAY_FROM, string V_NGAY_TO, string V_NGUOI_GUI_BT,
            string vArrSelectID, string v_ID_USER,
            decimal vPhanloaixuly, decimal resolvedThamphanID
        )
        {
            StringBuilder where = new StringBuilder();

            // vIsThuLy filters
            if (vIsThuLy != -1)
            {
                if (vIsThuLy == 1)
                {
                    if (vToaAnID == 1)
                        where.Append(" AND d.ISTHULY=1 AND d.LOAIDON != 4");
                    else
                        where.Append(" AND d.ISTHULY=1");
                }
                else if (vIsThuLy == 2)
                    where.Append(" AND (d.ISTHULY=2)");
                else if (vIsThuLy == 3)
                    where.Append(" AND (d.ISTHULY=1 and d.ARR_DON_ID>0)");
                else if (vIsThuLy == 4)
                    where.Append(" AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)");
                else if (vIsThuLy == 5)
                    where.Append(" AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)");
                else if (vIsThuLy == 6)
                    where.Append(" AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)");
            }

            // vLoaiAn filter
            if (vLoaiAn != 0)
            {
                if (vLoaiAn == 55)
                    where.Append(" AND (d.BAQD_LOAIAN IS NULL)");
                else
                {
                    where.Append(" AND (d.BAQD_LOAIAN = :vLoaiAn)");
                    parameters.Add(new OracleParameter(":vLoaiAn", OracleDbType.Decimal) { Value = vLoaiAn });
                }
            }

            // BAQD number/date filters (complex OR conditions)
            if (!string.IsNullOrEmpty(vSoBAQD) && !string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD == 0)
            {
                parameters.Add(new OracleParameter(":vSoBAQD", OracleDbType.Varchar2) { Value = vSoBAQD });
                parameters.Add(new OracleParameter(":vNgayBAQD", OracleDbType.Varchar2) { Value = vNgayBAQD });
                where.Append(@" AND (
        (LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')=:vNgayBAQD
        OR (LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=:vNgayBAQD
        OR (LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=:vNgayBAQD
        OR (LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')=:vNgayBAQD
    )");
            }
            else if (!string.IsNullOrEmpty(vSoBAQD) && string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD == 0)
            {
                parameters.Add(new OracleParameter(":vSoBAQD", OracleDbType.Varchar2) { Value = vSoBAQD });
                where.Append(@" AND (
        LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)
        OR LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)
        OR LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)
        OR LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)
    )");
            }
            else if (string.IsNullOrEmpty(vSoBAQD) && !string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD == 0)
            {
                parameters.Add(new OracleParameter(":vNgayBAQD", OracleDbType.Varchar2) { Value = vNgayBAQD });
                where.Append(@" AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')=:vNgayBAQD
        OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=:vNgayBAQD
        OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=:vNgayBAQD
        OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')=:vNgayBAQD)");
            }
            else if (!string.IsNullOrEmpty(vSoBAQD) && !string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD != 0)
            {
                parameters.Add(new OracleParameter(":vSoBAQD", OracleDbType.Varchar2) { Value = vSoBAQD });
                parameters.Add(new OracleParameter(":vNgayBAQD", OracleDbType.Varchar2) { Value = vNgayBAQD });
                parameters.Add(new OracleParameter(":vToaRaBAQD", OracleDbType.Decimal) { Value = vToaRaBAQD });
                where.Append(@" AND (
        (d.BAQD_TOAANID = :vToaRaBAQD AND (LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')=:vNgayBAQD)
        OR (d.BAQD_TOAANID_PT = :vToaRaBAQD AND (LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=:vNgayBAQD)
        OR (d.BAQD_TOAANID_ST = :vToaRaBAQD AND (LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=:vNgayBAQD)
        OR ((LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)) AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')=:vNgayBAQD)
    )");
            }
            else if (!string.IsNullOrEmpty(vSoBAQD) && string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD != 0)
            {
                parameters.Add(new OracleParameter(":vSoBAQD", OracleDbType.Varchar2) { Value = vSoBAQD });
                parameters.Add(new OracleParameter(":vToaRaBAQD", OracleDbType.Decimal) { Value = vToaRaBAQD });
                where.Append(@" AND (
        (d.BAQD_TOAANID = :vToaRaBAQD AND (LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO) LIKE LOWER(:vSoBAQD)))
        OR (d.BAQD_TOAANID_PT = :vToaRaBAQD AND (LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_PT) LIKE LOWER(:vSoBAQD)))
        OR (d.BAQD_TOAANID_ST = :vToaRaBAQD AND (LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.BAQD_SO_ST) LIKE LOWER(:vSoBAQD)))
        OR (LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD)||'/%' OR LOWER(D.KN_SOQD) LIKE LOWER(:vSoBAQD))
    )");
            }
            else if (string.IsNullOrEmpty(vSoBAQD) && !string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD != 0)
            {
                parameters.Add(new OracleParameter(":vNgayBAQD", OracleDbType.Varchar2) { Value = vNgayBAQD });
                parameters.Add(new OracleParameter(":vToaRaBAQD", OracleDbType.Decimal) { Value = vToaRaBAQD });
                where.Append(@" AND (
        (d.BAQD_TOAANID = :vToaRaBAQD AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')=:vNgayBAQD)
        OR (d.BAQD_TOAANID_PT = :vToaRaBAQD AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')=:vNgayBAQD)
        OR (d.BAQD_TOAANID_ST = :vToaRaBAQD AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')=:vNgayBAQD)
        OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')=:vNgayBAQD)
    )");
            }
            else if (string.IsNullOrEmpty(vSoBAQD) && string.IsNullOrEmpty(vNgayBAQD) && vToaRaBAQD != 0)
            {
                parameters.Add(new OracleParameter(":vToaRaBAQD", OracleDbType.Decimal) { Value = vToaRaBAQD });
                where.Append(" AND (d.BAQD_TOAANID = :vToaRaBAQD Or d.BAQD_TOAANID_PT = :vToaRaBAQD Or d.BAQD_TOAANID_ST = :vToaRaBAQD)");
            }

            // vNguoiGui filter - uses EXISTS for LOAIDON=4 (KS.TEN lookup)
            if (!string.IsNullOrEmpty(vNguoiGui))
            {
                string escaped = vNguoiGui.Replace("'", "`");
                parameters.Add(new OracleParameter(":vNguoiGui", OracleDbType.Varchar2) { Value = escaped });
                if (vToaAnID == 6)
                {
                    where.Append(@" AND (
            (d.LOAIDON = 4 AND EXISTS(SELECT 1 FROM DM_VKS ks WHERE ks.ID=d.DONVICHUYEN_HSKN AND REPLACE(LOWER(ks.TEN),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%'))
            OR (d.LOAIDON = 6 AND REPLACE(LOWER(d.CV_TENDONVI),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%')
            OR (d.LOAIDON NOT IN (4,6) AND REPLACE(LOWER(d.NGUOIGUI_HOTEN),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%')
        )");
                }
                else
                {
                    where.Append(@" AND (
            (d.LOAIDON = 4 AND EXISTS(SELECT 1 FROM DM_VKS ks WHERE ks.ID=d.DONVICHUYEN_HSKN AND REPLACE(LOWER(ks.TEN),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%'))
            OR (d.LOAIDON = 6 AND REPLACE(LOWER(d.CV_TENDONVI),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%')
            OR (d.LOAIDON NOT IN (4,6) AND REPLACE(LOWER(d.DONGKHIEUNAI),'''','`') LIKE '%' || LOWER(:vNguoiGui) || '%')
        )");
                }
            }

            // vSoCMND filter
            if (!string.IsNullOrEmpty(vSoCMND))
            {
                parameters.Add(new OracleParameter(":vSoCMND", OracleDbType.Varchar2) { Value = vSoCMND });
                where.Append(" AND (D.NGUOIGUI_CMND LIKE '%'||:vSoCMND||'%')");
            }

            // Date range filters
            if (vTuNgay.HasValue)
            {
                parameters.Add(new OracleParameter(":vTuNgay", OracleDbType.Date) { Value = vTuNgay.Value });
                where.Append(" AND (D.NGAYNHANDON >= :vTuNgay)");
            }

            if (vDenNgay.HasValue)
            {
                parameters.Add(new OracleParameter(":vDenNgay", OracleDbType.Date) { Value = vDenNgay.Value });
                where.Append(" AND (D.NGAYNHANDON <= :vDenNgay)");
            }

            // vHinhThucDon filter
            if (vHinhThucDon != 0)
            {
                parameters.Add(new OracleParameter(":vHinhThucDon", OracleDbType.Decimal) { Value = vHinhThucDon });
                where.Append(" AND (D.LOAIDON = :vHinhThucDon)");
            }

            // vSoHieuDon filter
            if (!string.IsNullOrEmpty(vSoHieuDon))
            {
                parameters.Add(new OracleParameter(":vSoHieuDon", OracleDbType.Varchar2) { Value = vSoHieuDon });
                where.Append(" AND (D.MADON = :vSoHieuDon OR D.SOHIEUDON = :vSoHieuDon)");
            }

            // vDiaChiTinh filter
            if (vDiaChiTinh != 0)
            {
                parameters.Add(new OracleParameter(":vDiaChiTinh", OracleDbType.Decimal) { Value = vDiaChiTinh });
                where.Append(" AND (D.NGUOIGUI_TINHID = :vDiaChiTinh)");
            }

            // vDiaChiHuyen filter
            if (vDiaChiHuyen != 0)
            {
                parameters.Add(new OracleParameter(":vDiaChiHuyen", OracleDbType.Decimal) { Value = vDiaChiHuyen });
                where.Append(" AND (D.NGUOIGUI_HUYENID = :vDiaChiHuyen)");
            }

            // vCD_TENDONVI filter (when vNoiChuyen == 2, search CD_NTA_TENDONVI)
            if (vNoiChuyen == 2 && !string.IsNullOrEmpty(vCD_TENDONVI))
            {
                parameters.Add(new OracleParameter(":vCD_TENDONVI", OracleDbType.Varchar2) { Value = vCD_TENDONVI });
                where.Append(" AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace(:vCD_TENDONVI,' ' )) || '%')");
            }

            // vNoiChuyen filter
            if (vNoiChuyen != -1)
            {
                if (vNoiChuyen != -2)
                {
                    parameters.Add(new OracleParameter(":vNoiChuyen", OracleDbType.Decimal) { Value = vNoiChuyen });
                    where.Append(" AND (d.CD_LOAI = :vNoiChuyen)");
                }
                else if (vNoiChuyen == -2)
                    where.Append(" AND (d.CD_LOAI IN(1,2))");
            }

            // vNoiChuyen == 1 + vCD_DONVIID (chuyển TK)
            if (vNoiChuyen == 1 && vCD_DONVIID != 0)
            {
                if (vCD_DONVIID > 0)
                {
                    parameters.Add(new OracleParameter(":vCD_DONVIID_TK", OracleDbType.Decimal) { Value = vCD_DONVIID });
                    where.Append(" AND (d.CD_TK_DONVIID=:vCD_DONVIID_TK)");
                }
                else if (vCD_DONVIID == -1)
                {
                    where.Append(" AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))");
                }
            }

            // vTrangthai filter
            if (vTrangthai != -1)
            {
                if (vTrangthai == 1)
                    where.Append(" AND d.CD_TRANGTHAI in(1,2)");
                else if (vTrangthai == 3)
                    where.Append(" AND d.CD_TRANGTHAI in(3,4)");
                else if (vTrangthai == 2)
                    where.Append(" AND d.CD_TRANGTHAI = 2");
                else if (vTrangthai == 0)
                    where.Append(" AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)");
            }

            // vCD_DONVIID filter
            if (vNoiChuyen == 0 && vCD_DONVIID > 0)
            {
                parameters.Add(new OracleParameter(":vCD_DONVIID", OracleDbType.Decimal) { Value = vCD_DONVIID });
                where.Append(" AND (d.CD_TA_DONVIID = :vCD_DONVIID)");
            }

            // vCD_TA_TRANGTHAI filter
            if (vNoiChuyen == 0 && vCD_TA_TRANGTHAI != -1)
            {
                if (vCD_TA_TRANGTHAI >= 0)
                {
                    parameters.Add(new OracleParameter(":vCD_TA_TRANGTHAI", OracleDbType.Decimal) { Value = vCD_TA_TRANGTHAI });
                    where.Append(" AND (d.CD_TA_TRANGTHAI = :vCD_TA_TRANGTHAI)");
                }
                if (vCD_TA_TRANGTHAI == 3)
                    where.Append(" AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))");
                if (vCD_TA_TRANGTHAI == 4)
                    where.Append(" AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))");
            }

            // === ADDITIONAL FILTERS FROM ORIGINAL ===

            // vNgayNhapTu/Den filters (original lines 565-572)
            if (vNgayNhapTu.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgayNhapTu", OracleDbType.Date) { Value = vNgayNhapTu.Value });
                where.Append(" AND (d.NGAYTAO >= :vNgayNhapTu)");
            }
            if (vNgayNhapDen.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgayNhapDen", OracleDbType.Date) { Value = vNgayNhapDen.Value });
                where.Append(" AND (d.NGAYTAO <= :vNgayNhapDen)");
            }

            // vIsTuHinh filter (original lines 573-591)
            if (vIsTuHinh != 0)
            {
                if (vIsTuHinh == 1)
                    where.Append(" AND (NVL(d.ISANTUHINH,0)=0)");
                else if (vIsTuHinh == 2)
                    where.Append(" AND (NVL(d.ISANTUHINH,0)=1)");
                else if (vIsTuHinh == 3)
                    where.Append(" AND (NVL(d.ISANTUHINH,0)=1 AND NVL(d.ISTH_ANGIAM,0)=1)");
                else if (vIsTuHinh == 4)
                    where.Append(" AND (NVL(d.ISANTUHINH,0)=1 AND NVL(d.ISTH_KEUOAN,0)=1)");
            }

            // vThamtravienID filter
            if (vThamtravienID != 0)
            {
                parameters.Add(new OracleParameter(":vThamtravienID", OracleDbType.Decimal) { Value = vThamtravienID });
                where.Append(" AND (d.GQ_THAMTRAVIENID = :vThamtravienID)");
            }

            // vLoaiCVID filter
            if (vLoaiCVID != 0)
            {
                if (vLoaiCVID == -1)
                    where.Append(" AND (d.LOAICONGVAN NOT IN (SELECT ID FROM DM_DATAITEM WHERE ID=1023 OR CAPCHAID=1023))");
                else
                {
                    parameters.Add(new OracleParameter(":vLoaiCVID", OracleDbType.Decimal) { Value = vLoaiCVID });
                    where.Append(" AND (d.LOAICONGVAN = :vLoaiCVID OR d.LOAICONGVAN IN (SELECT ID FROM DM_DATAITEM WHERE CAPCHAID = :vLoaiCVID))");
                }
            }

            // vGuitoiCA_TA filter (original line 607-616: only ==1 fires; ==0 is dead code inside !=0 guard)
            if (vGuitoiCA_TA == 1)
            {
                where.Append(" AND (d.CD_TK_NOIGUI=1)");
            }

            // vLOAI_GDTTT: NOT a WHERE filter in original. Used only in SELECT/PostProcess.

            // V_NDBD_TEXT filter as EXISTS subquery (original lines 618-632)
            if (!string.IsNullOrEmpty(V_NDBD_TEXT))
            {
                parameters.Add(new OracleParameter(":V_NDBD_TEXT", OracleDbType.Varchar2) { Value = V_NDBD_TEXT });
                if (V_NDBD_VALUE == "0")
                {
                    where.Append(@" AND EXISTS(SELECT 1 FROM GDTTT_DON_DUONGSU_CC cc
            INNER JOIN GDTTT_DON cd ON cd.ID=cc.DONID
            WHERE cc.DONID=d.ID AND cc.TUCACHTOTUNG='NGUYENDON'
            AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7)
            AND UPPER(cc.TENDUONGSU) LIKE '%'||UPPER(TRIM(:V_NDBD_TEXT))||'%')");
                }
                else if (V_NDBD_VALUE == "1")
                {
                    where.Append(@" AND EXISTS(SELECT 1 FROM GDTTT_DON_DUONGSU_CC cc
            INNER JOIN GDTTT_DON cd ON cd.ID=cc.DONID
            WHERE cc.DONID=d.ID AND cc.TUCACHTOTUNG='BIDON'
            AND cd.BAQD_LOAIAN IN (2,3,4,5,6,7)
            AND UPPER(cc.TENDUONGSU) LIKE '%'||UPPER(TRIM(:V_NDBD_TEXT))||'%')");
                }
                else if (V_NDBD_VALUE == "2")
                {
                    where.Append(@" AND EXISTS(SELECT 1 FROM GDTTT_DON_DUONGSU_CC cc
            INNER JOIN GDTTT_DON cd ON cd.ID=cc.DONID
            WHERE cc.DONID=d.ID AND cc.TUCACHTOTUNG='BIDON'
            AND cd.BAQD_LOAIAN=1
            AND UPPER(cc.TENDUONGSU) LIKE '%'||UPPER(TRIM(:V_NDBD_TEXT))||'%')");
                }
            }

            // VT_CHUYEN_NHAN filters (original lines 633-716)
            if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
            {
                parameters.Add(new OracleParameter(":V_DONVI_CHUYEN_ID", OracleDbType.Varchar2) { Value = V_DONVI_CHUYEN_ID });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID)");
            }
            if (!string.IsNullOrEmpty(V_TRANGTHAICHUYEN))
            {
                if (V_TRANGTHAICHUYEN == "3")
                {
                    where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=3");
                    if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                        where.Append(" AND DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                    where.Append(")");
                }
                if (V_TRANGTHAICHUYEN == "4")
                {
                    where.Append(" AND NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=3");
                    if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                        where.Append(" AND DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                    where.Append(")");
                }
            }
            if (!string.IsNullOrEmpty(V_LOAI_VB))
            {
                parameters.Add(new OracleParameter(":V_LOAI_VB", OracleDbType.Varchar2) { Value = V_LOAI_VB });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd ON vbd.ID=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB = :V_LOAI_VB");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // vArrSelectID filter
            if (!string.IsNullOrEmpty(vArrSelectID))
            {
                parameters.Add(new OracleParameter(":vArrSelectID", OracleDbType.Varchar2) { Value = "," + vArrSelectID + "," });
                where.Append(" AND (:vArrSelectID LIKE '%,' || CAST(d.ID AS VARCHAR2(10)) || ',%')");
            }

            // vChidao filter (sentinel=-1: no filter, 0=có ý kiến, 1=không có, >1=specific leader)
            if (vChidao != -1)
            {
                if (vChidao == 0)
                    where.Append(" AND (NVL(d.CHIDAO_COKHONG,0)>0)");
                else if (vChidao == 1)
                    where.Append(" AND (NVL(d.CHIDAO_COKHONG,0)=0)");
                else if (vChidao > 1)
                {
                    parameters.Add(new OracleParameter(":vChidao", OracleDbType.Decimal) { Value = vChidao });
                    where.Append(" AND (d.CHIDAO_LANHDAOID=:vChidao)");
                }
            }

            // vTraigiam filter (sentinel=-1: no filter, passes value directly)
            if (vTraigiam != -1)
            {
                parameters.Add(new OracleParameter(":vTraigiam", OracleDbType.Decimal) { Value = vTraigiam });
                where.Append(" AND (NVL(d.CV_ISTRAIGIAM,0)=:vTraigiam)");
            }

            // vTBQuahan filter (original uses TB1_NGAY comparison with vNgayQuahan)
            if (vTBQuahan != 0 && vNgayQuahan.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgayQuahan", OracleDbType.Date) { Value = vNgayQuahan.Value });
                where.Append(" AND (d.TB1_NGAY<(:vNgayQuahan - 30))");
            }

            // vPhanloaixuly filter
            if (vPhanloaixuly != 0)
            {
                parameters.Add(new OracleParameter(":vPhanloaixuly", OracleDbType.Decimal) { Value = vPhanloaixuly });
                where.Append(" AND (d.PHANLOAIXULY=:vPhanloaixuly)");
            }

            // vSoVanBan filter (with vLoaiSoVB)
            if (!string.IsNullOrEmpty(vSoVanBan))
            {
                parameters.Add(new OracleParameter(":vSoVanBan", OracleDbType.Varchar2) { Value = vSoVanBan });
                if (vLoaiSoVB == "YCBS")
                {
                    where.Append(" AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b where b.SOTHONGBAO = :vSoVanBan AND b.DONID = D.id)");
                }
                else
                {
                    parameters.Add(new OracleParameter(":vLoaiSoVB_SVB", OracleDbType.Varchar2) { Value = vLoaiSoVB });
                    where.Append(" AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = :vLoaiSoVB_SVB AND so.SOVB=:vSoVanBan AND sd.donid = D.id)");
                }
            }

            // vNgayVanBan filter (with vLoaiSoVB)
            if (!string.IsNullOrEmpty(vNgayVanBan))
            {
                parameters.Add(new OracleParameter(":vNgayVanBan", OracleDbType.Varchar2) { Value = vNgayVanBan });
                if (vLoaiSoVB == "YCBS")
                {
                    where.Append(" AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = :vNgayVanBan AND b.DONID = D.id)");
                }
                else
                {
                    parameters.Add(new OracleParameter(":vLoaiSoVB_NVB", OracleDbType.Varchar2) { Value = vLoaiSoVB });
                    where.Append(" AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = :vLoaiSoVB_NVB AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') =:vNgayVanBan AND sd.donid = D.id)");
                }
            }

            // vCVPC_So filter
            if (!string.IsNullOrEmpty(vCVPC_So))
            {
                parameters.Add(new OracleParameter(":vCVPC_So", OracleDbType.Varchar2) { Value = vCVPC_So });
                where.Append(" AND (LOWER(D.CV_SO) LIKE '%' || LOWER(:vCVPC_So) || '%')");
            }

            // vCVPC_Ngay filter
            if (!string.IsNullOrEmpty(vCVPC_Ngay))
            {
                parameters.Add(new OracleParameter(":vCVPC_Ngay", OracleDbType.Varchar2) { Value = vCVPC_Ngay });
                where.Append(" AND (to_char(d.CV_NGAY,'dd/MM/yyyy')=:vCVPC_Ngay)");
            }

            // vCVPC_TenCQ filter
            if (!string.IsNullOrEmpty(vCVPC_TenCQ))
            {
                parameters.Add(new OracleParameter(":vCVPC_TenCQ", OracleDbType.Varchar2) { Value = vCVPC_TenCQ });
                where.Append(" AND (lower(d.CV_TENDONVI) like '%' || LOWER(:vCVPC_TenCQ) || '%')");
            }

            // vTraLoi filter
            if (vTraLoi != 0)
            {
                parameters.Add(new OracleParameter(":vTraLoi", OracleDbType.Decimal) { Value = vTraLoi });
                where.Append(" AND (d.TRALOIDON=:vTraLoi)");
            }

            // vNguoiNhap filter
            if (!string.IsNullOrEmpty(vNguoiNhap))
            {
                parameters.Add(new OracleParameter(":vNguoiNhap", OracleDbType.Varchar2) { Value = vNguoiNhap });
                where.Append(" AND (LOWER(:vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') )");
            }

            // vNgaychuyenTu filter
            if (vNgaychuyenTu.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgaychuyenTu", OracleDbType.Date) { Value = vNgaychuyenTu.Value });
                where.Append(" AND (:vNgaychuyenTu <= d.CD_NGAYXULY)");
            }

            // vNgaychuyenDen filter
            if (vNgaychuyenDen.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgaychuyenDen", OracleDbType.Date) { Value = vNgaychuyenDen.Value });
                where.Append(" AND (d.CD_NGAYXULY <= :vNgaychuyenDen)");
            }

            // vNgayThulyTu filter
            if (vNgayThulyTu.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgayThulyTu", OracleDbType.Date) { Value = vNgayThulyTu.Value });
                where.Append(" AND (:vNgayThulyTu <= d.TL_NGAY)");
            }

            // vNgayThulyDen filter
            if (vNgayThulyDen.HasValue)
            {
                parameters.Add(new OracleParameter(":vNgayThulyDen", OracleDbType.Date) { Value = vNgayThulyDen.Value });
                where.Append(" AND (d.TL_NGAY <= :vNgayThulyDen)");
            }

            // vSoThuly filter
            if (!string.IsNullOrEmpty(vSoThuly))
            {
                parameters.Add(new OracleParameter(":vSoThuly", OracleDbType.Varchar2) { Value = vSoThuly });
                where.Append(" AND (lower(d.TL_SO) like '%' || LOWER(:vSoThuly) || '%') AND d.ISTHULY=1");
            }

            // V_SODEN_TU filter
            if (!string.IsNullOrEmpty(V_SODEN_TU))
            {
                parameters.Add(new OracleParameter(":V_SODEN_TU", OracleDbType.Varchar2) { Value = V_SODEN_TU });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=TO_NUMBER(:V_SODEN_TU)");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // V_SODEN_DEN filter
            if (!string.IsNullOrEmpty(V_SODEN_DEN))
            {
                parameters.Add(new OracleParameter(":V_SODEN_DEN", OracleDbType.Varchar2) { Value = V_SODEN_DEN });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=TO_NUMBER(:V_SODEN_DEN)");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // V_NGAY_FROM filter
            if (!string.IsNullOrEmpty(V_NGAY_FROM))
            {
                parameters.Add(new OracleParameter(":V_NGAY_FROM", OracleDbType.Varchar2) { Value = V_NGAY_FROM });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE(:V_NGAY_FROM || ' 00:00:00','dd/MM/yyyy HH24:MI:SS')");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // V_NGAY_TO filter
            if (!string.IsNullOrEmpty(V_NGAY_TO))
            {
                parameters.Add(new OracleParameter(":V_NGAY_TO", OracleDbType.Varchar2) { Value = V_NGAY_TO });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE(:V_NGAY_TO || ' 23:59:59','dd/MM/yyyy HH24:MI:SS')");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // V_NGUOI_GUI_BT filter
            if (!string.IsNullOrEmpty(V_NGUOI_GUI_BT))
            {
                parameters.Add(new OracleParameter(":V_NGUOI_GUI_BT", OracleDbType.Varchar2) { Value = V_NGUOI_GUI_BT });
                where.Append(" AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||:V_NGUOI_GUI_BT||'%'");
                if (!string.IsNullOrEmpty(V_DONVI_CHUYEN_ID))
                    where.Append(" AND cn.DONVI_CHUYEN_ID = :V_DONVI_CHUYEN_ID");
                where.Append(")");
            }

            // ThamphanID filter (resolved by caller, 0 = no filter)
            if (resolvedThamphanID != 0)
            {
                parameters.Add(new OracleParameter(":vThamphanID", OracleDbType.Decimal) { Value = resolvedThamphanID });
                where.Append(" AND (d.THAMPHANID=:vThamphanID)");
            }

            return where;
        }

        /// <summary>
        /// Builds the SELECT clause with all columns.
        /// Includes optC fixes: DC DECODE with 2 values (not 4).
        /// </summary>
        private void BuildSelectClause(StringBuilder sql, decimal vToaAnID)
        {
            sql.AppendLine(@"
        dp.STT,
        (SELECT cnt FROM total_inflated) AS TotalItem,
        d.ID,
        d.MADON,
        d.LOAIDON,
        NULL                                          MADON_CC,
        d.SOHIEUDON,
        d.NGUOIGUI_HOTEN,
        d.SOTHUTUDON,
        d.ISTPB3,
        d.NGAYNHANDON                                 NGAYNHANDONS,
        NULL                                          NGAYNHANDON,
        d.BAQD_NGAYBA,
        NULL                                          NgayBA_PT,
        d.BAQD_LOAIQDBA,
        NULL                                          BAQD_LOAIQDBA_NAME,
        d.NGUOITAO                                    NguoiNhap,
        d.CV_TENDONVI,
        MAX(d.DONGKHIEUNAI)                              DONGKHIEUNAI,
        KS.TEN,
        NULL                                          DONGKHIEUNAI_CC,
        d.ISNOTGDTTT,
        d.NGUOISUA,
        d.NGAYSUA,
        d.NGAYTAO                                     NgayNhap,
        D.TL_NGAY,
        D.TL_SO,
        d.CD_SOCV,
        d.CD_NGAYCV,
        d.CD_NGUOIKY,
        d.ISSHOWFULL,
        LAD.LOAIDON_TEN_VT                            HinhThuc,
        NULL                                          LBL_HINHTHUC_CC,
        d.NGUOIGUI_HUYENID,
        d.NGUOIGUI_DIACHI,
        h.MA_TEN                                      MA_TEN_H,
        hv.MA_TEN                                     MA_TEN_HV,
        NULL                                          DIACHIGUI,
        d.CV_SO,
        d.CV_NGAY,
        d.NGAYGHITRENDON,
        d.SO_HSKN,
        d.NGAY_HSKN,
        NULL                                          NGAYGHITRENDON_CC,
        d.KN_SOQD,
        d.BAQD_CAPXETXU,
        d.BAQD_SO_PT,
        d.BAQD_SO_ST,
        d.BAQD_SO,
        d.BAQD_SO                                     BAQD,
        NULL                                          BAQD_CC,
        d.KN_NGAY,
        d.BAQD_NGAYBA_ST,
        d.BAQD_NGAYBA_PT,
        NULL                                          BAQD_NGAYBA_CC,
        i.TEN                                         TEN_I,
        txx.MA_TEN                                    TOAXX,
        txxST.MA_TEN                                  MA_TEN_XXST,
        txxPT.MA_TEN                                  MA_TEN_XXPT,
        NULL                                          Infor_ST,
        NULL                                          Infor_PT,
        d.NGUOIKHANGNGHI,
        d.CD_TRANGTHAI,
        MAX(tralai.GHICHU)                               GHICHU_TRALAI,
        MAX(d.GHICHU)                                    GHICHU,
        d.DUNGDONLA,
        d.NGUOIGUI_GIOITINH,
        d.CD_TA_LYDO_ISBAQD,
        d.CD_TA_LYDO_ISXACNHAN,
        d.CD_TA_LYDO_ISKHAC,
        d.CV_DIACHI                                   CVDIACHI,
        MAX(d.CD_TA_LYDO_KHAC)                           CD_TA_LYDO_KHAC,
        d.CHIDAO_COKHONG,
        MAX(d.CHIDAO_NOIDUNG)                            CHIDAO_NOIDUNG,
        d.CD_LOAI,
        D.VUVIECID,
        pb.TENPHONGBAN,
        d.CD_TA_DONVIID,
        gqkn.HOTEN,
        gqkn.CHUCVU,
        tk.MA_TEN                                     MA_TEN_TK,
        d.CD_NTA_TENDONVI,
        NULL                                          NOICHUYEN,
        D.TOAANID,
        D.ISTHULY,

        /* TTC (TRANGTHAICHUYEN) - inline compute, no self-join */
        DECODE(d.CD_TRANGTHAI,
            0, 'Chưa chuyển',
            1, 'Đã chuyển',
            2, 'Đã nhận',
            3, 'Bị trả lại',
            'Chưa chuyển')                            TRANGTHAICHUYEN,

        /* DC (PHONGBANNHANID=102) - BUG FIX: use 2-value DECODE (optC fix)
         * Original: DECODE(tc.TRANGTHAI, 1, 'Đã chuyển', 'Chưa chuyển')
         * Bug: _final/_optC accidentally used 4-value DC_HIS decode
         * Fixed: restored to original 2-value logic */
        CASE WHEN dc_102.DONID IS NOT NULL THEN
            '<i><b> <span  style=""color: #0e7eee;"">'
            || DECODE(dc_102.TRANGTHAI, 1, 'Đã chuyển', 'Chưa chuyển')
            || '</span>'
            || '<span >: Thẩm phán</b></i> </span><br />'
        END                                           TRANGTHAICHUYEN_TP_DC,

        /* DC_HIS (PHONGBANNHANID=102) - 4-value decode is correct here */
        dc_his.TRANGTHAICHUYEN_TP                     TRANGTHAICHUYEN_TP_HIS,

        /* DC.TRANGTHAICHUYEN_TP (same bug fix as TRANGTHAICHUYEN_TP_DC) */
        CASE WHEN dc_102.DONID IS NOT NULL THEN
            '<i><b> <span  style=""color: #0e7eee;"">'
            || DECODE(dc_102.TRANGTHAI, 1, 'Đã chuyển', 'Chưa chuyển')
            || '</span>'
            || '<span >: Thẩm phán</b></i> </span><br />'
        END                                           TRANGTHAICHUYEN_TP,

        /* DC.NGAYCHUYEN */
        CASE WHEN dc_102.DONID IS NOT NULL THEN
            '<br/><i>Ngày chuyển : '
            || TO_CHAR(dc_102.NGAYCHUYEN, 'dd/MM/yyyy hh24:mi:ss')
            || '</i><br/>'
        END                                           NGAYCHUYEN_DC,

        /* DTL_NC.NGAYCHUYEN */
        CASE WHEN dc_ta.DONID IS NOT NULL THEN
            '<br/><i>Ngày chuyển : '
            || TO_CHAR(dc_ta.NGAYCHUYEN, 'dd/MM/yyyy hh24:mi:ss')
            || '</i><br/>'
        END                                           NGAYCHUYEN,

        d.BAQD_LOAIAN,
        d.CD_TRALAI_LYDOID,
        MAX(d.CD_TRALAI_YEUCAU)                          CD_TRALAI_YEUCAU,
        MAX(d.NOIDUNGTOMTAT)                             NOIDUNGTOMTAT,
        MAX(d.CD_TRALAI_LYDOKHAC)                        CD_TRALAI_LYDOKHAC,
        d.TB1_SO,
        d.TB1_NGAY,
        d.TB2_SO,
        d.TB2_NGAY,
        MAX(nsd.GHICHU)                                  BIDANH,

        /* SoTT pivot (CD_SOTOTRINH, CD_NGAYTOTRINH) */
        MAX(CASE WHEN sp.MASO = 'SoTT' THEN sp.SOVB END)    CD_SOTOTRINH,
        MAX(CASE WHEN sp.MASO = 'SoTT' THEN sp.NGAYVB END)  CD_NGAYTOTRINH,

        c.HOTEN                                       TENTHAMPHAN,
        qls.SOVB                                      SOVB,
        qls.NGAYVB                                    NGAYVB,
        NULL                                          THAMPHAN_SONGAY,
        NULL                                          TOTRINH_SONGAY,
        d.THAMPHANID,
        1                                             SODON,
        NULL                                          TONG_SODON,
        NULL                                          ARR_DON_IDS,
        d.ARR_DON_ID,
        d.CD_TA_TRANGTHAI,
        va.SOTHULYXXGDT,
        va.NGAYTHULYXXGDT,
        va.IsVienTruongKN,
        NULL                                          IsShowNB,
        NULL                                          IsShowTK,
        NULL                                          GIAIQUYET,
        d.DONTRUNGID,
        NULL                                          IsShowDDK,
        NULL                                          IsShowCDDK,
        'Thụ lý mới'                                  lb_thuly,
        NULL                                          IsShowTLMOI,
        NULL                                          IsShowTLMOI_TRUNG_TP,
        NULL                                          IsShowDATL,
        NULL                                          IsThulyXX,
        NULL                                          arrCongvan,
        NULL                                          arrDonID,
        NULL                                          arrTTTL,
        NULL                                          arrTTTL_TL,
        d.PHANLOAIXULY,
        va.GQD_LOAIKETQUA,
        va.LOAIAN,

        /* KQGQ_HINHSU_EX = TLD.TLDKN || KN.TLDKN || kq.KQXXGDT */
        MAX(
            CASE WHEN tld.DONID IS NOT NULL THEN
                'Trả lời đơn '
                || DECODE(tld.SO, NULL, NULL, 'số ' || tld.SO)
                || DECODE(tld.NGAY, NULL, NULL, ' - ' || TO_CHAR(tld.NGAY, 'dd/MM/yyyy'))
            END
            || CASE WHEN kn.DONID IS NOT NULL THEN
                'Kháng nghị '
                || DECODE(kn.SO, NULL, NULL, 'số ' || kn.SO)
                || DECODE(kn.NGAY, NULL, NULL, ' - ' || TO_CHAR(kn.NGAY, 'dd/MM/yyyy'))
                || CASE WHEN kn.NOIDUNGKHANGNGHI IS NOT NULL
                        THEN '<br/> Nội dung kháng nghị: ' || kn.NOIDUNGKHANGNGHI
                   END
            END
            || kq.KQXXGDT
        )                                              KQGQ_HINHSU_EX,

        /* KQGQ_DANSU_EX = XLK_DS || XD_DS || VKSGQ_DS || TLD_DS || KN_DS */
        (
            MAX(CASE WHEN kqd.LOAI = 3 THEN
                'Xử lý khác'
                || DECODE(kqd.SO, NULL, NULL, 'số ' || kqd.SO)
                || DECODE(kqd.NGAY, NULL, NULL, ' - ' || TO_CHAR(kqd.NGAY, 'dd/MM/yyyy'))
            END)
            || MAX(CASE WHEN kqd.LOAI = 2 THEN
                'Xếp đơn'
                || DECODE(kqd.SO, NULL, NULL, 'số ' || kqd.SO)
                || DECODE(kqd.NGAY, NULL, NULL, ' - ' || TO_CHAR(kqd.NGAY, 'dd/MM/yyyy'))
            END)
            || MAX(CASE WHEN kqd.LOAI = 2 THEN
                'VKS đang GQ'
                || DECODE(kqd.SO, NULL, NULL, 'số ' || kqd.SO)
                || DECODE(kqd.NGAY, NULL, NULL, ' - ' || TO_CHAR(kqd.NGAY, 'dd/MM/yyyy'))
            END)
            || MAX(CASE WHEN kqd.LOAI = 0 THEN
                'Trả lời đơn '
                || DECODE(kqd.SO, NULL, NULL, 'số ' || kqd.SO)
                || DECODE(kqd.NGAY, NULL, NULL, ' - ' || TO_CHAR(kqd.NGAY, 'dd/MM/yyyy'))
            END)
            || MAX(CASE WHEN kqd.LOAI = 1 THEN
                'Kháng nghị '
                || DECODE(kqd.SO, NULL, NULL, 'số ' || kqd.SO)
                || DECODE(kqd.NGAY, NULL, NULL, ' - ' || TO_CHAR(kqd.NGAY, 'dd/MM/yyyy'))
                || CASE WHEN kqd.NOIDUNGKHANGNGHI IS NOT NULL
                        THEN '<br/> Nội dung kháng nghị: ' || kqd.NOIDUNGKHANGNGHI
                   END
            END)
            || MAX(kq.KQXXGDT)
        )                                             KQGQ_DANSU_EX,

        va.GDQ_SO,
        va.GDQ_NGAY,
        va.GQD_NgayPhatHanhCV,
        MAX(kq.KQXXGDT)                                  KQXXGDT,
        NULL                                          KQGQNoiBo,
       -- MAX(d.CV_TRALOI_NOIDUNG)                         CV_TRALOI_NOIDUNG,
        NULL                                               CV_TRALOI_NOIDUNG,
        LA.LOAI_AN_TEN                                BAQD_LOAIAN_NAME,
        NULL                                          BAQD_CAPXETXU_NAME,
        vt.VANBANDEN_ID,
        vt.CANBO_NHAN_ID,
        vt.TRANG_THAI_XLY,
        NULL                                          TRANG_THAI_XLY_NAME,
        vbd.LOAI_VB,
        MAX(vbd.NGUOIDUNGDON)                        NGUOIDUNGDON,
        MAX(vbd.NGUOI_GUI_BT)                        NGUOI_GUI_BT,
        MAX(vbd.NGUOI_GUI_BT)                        NGUOI_GUI_BT_S,
        MAX(vbd.DIACHI_NDD)                          DIACHI_NDD,
        MAX(vbd.DIACHI_GUI_BT)                       DIACHI_GUI_BT,
        vbd.NGAY_DEN                                  NGAY_DEN_S,
        vbd.NGAY_BT                                   NGAY_BT_S,
        NULL                                          NGAY_DEN,
        NULL                                          NGAY_BT,
        vbd.SO_BAQD_DON,
        vbd.NGAY_BAQD_DON,
        TA.MA_TEN                                     MA_TEN_TA,
        vbd.SO_VB,
        vbd.NGAY_VB,
        vbd.SO_CV,
        vbd.NGAY_CV,
        MAX(vbd.DONVICHUYEN_CV)                      DONVICHUYEN_CV,
        NULL                                          THONGTIN_VBD,
        pbvt.TEN                                      TEN_PBVT,
        vbd.SODEN,
        MAX(vbd.NGUON_DEN)                           NGUON_DEN_S,
        NULL                                          NGUON_DEN,
        NULL                                          DONVITIEPNHAN,
        d.LOAI_GDTTTT,
        d.NGUOIGUI_DIENTHOAI,
        NULL                                          TRANGTHAILOAI_GDTTTT,
        ycbs.YCBS,

        /* THA (HOAN_THA) */
        DECODE(va.GQD_ISHOANTHA,
            0, NULL,
            1, '<b>Hoãn thi hành án </b> Số: '
               || va.GQD_HOANTHA_SO || ' - '
               || TO_CHAR(va.GQD_HOANTHA_NGAY, 'dd/MM/yyyy')
        )                                             HOAN_THA,

        /* sph pivot: SoGXN */
        MAX(CASE WHEN sp.MASO = 'SoGXN' THEN sp.SOVB END)    GXNSO,
        MAX(CASE WHEN sp.MASO = 'SoGXN' THEN sp.NGAYVB END)  GXNNGAY,

        /* sph pivot: SoGXN_DV */
        MAX(CASE WHEN sp.MASO = 'SoGXN_DV' THEN sp.SOVB END)  GXNSODV,
        MAX(CASE WHEN sp.MASO = 'SoGXN_DV' THEN sp.NGAYVB END) GXNNGAYDV,

        NULL                                          LOAIGDTT,
        NULL                                          IsGXN,
        NULL                                          IsGXNDV,
        thieu.THOIHIEU,

        /* sph pivot: SoCVC/SoCVCN/SoCVCTK/SoTralaidon */
        MAX(CASE WHEN sp.MASO IN ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon') THEN sp.SOVB END)    SVB_SOCV,
        MAX(CASE WHEN sp.MASO IN ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon') THEN sp.NGAYVB END)  SVB_NGAYCV,
        MAX(CASE WHEN sp.MASO IN ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon') THEN sp.NGUOIKY END) SVB_NGUOIKY,

        NULL                                          IS_SHOW_TP,
        NULL                                          IS_SHOW_DC,

        /* sph pivot: SoTT_TLL */
        MAX(CASE WHEN sp.MASO = 'SoTT_TLL' THEN sp.SOVB END)    TLL_SOVB,
        MAX(CASE WHEN sp.MASO = 'SoTT_TLL' THEN sp.NGAYVB END)  TLL_NGAYVB,

        /* sph pivot: SoTTXX */
        MAX(CASE WHEN sp.MASO = 'SoTTXX' THEN sp.SOVB END)    TXX_SOVB,
        MAX(CASE WHEN sp.MASO = 'SoTTXX' THEN sp.NGAYVB END)  TXX_NGAYVB,

        /* Task 5: KN case assignment (ctc_all) */
        ctc.THAMPHANID                                THAMPHANTCID,
        ctc.THAMPHANTC_TEN,
        ctc.TRANGTHAICHUYENTP                         TRANGTHAICHUYENTP_TC,
        TO_CHAR(ctc.NGAYCHUYENTP, 'dd/MM/yyyy hh24:mi:ss') NGAYCHUYENTP,

        /* Task 5: VAKN books (sph_vakn) */
        svTT.SOVB                                     TOTRINH_VAKN,
        TO_CHAR(svTT.NGAYVB, 'dd/MM/yyyy')            NGAYTOTRINH_VAKN,
        svTB.SOVB                                     TBTP_VAKN,
        TO_CHAR(svTB.NGAYVB, 'dd/MM/yyyy')            NGAYTBTP_VAKN,

        /* Task 5: CHUCDANH */
        chucdanh.MA                                   CHUCDANH");
        }

        /// <summary>
        /// Builds all LEFT JOINs for the main query.
        /// Joins to dimension tables and CTEs (all filtered by don_page).
        /// </summary>
        private void BuildLeftJoins(StringBuilder sql, decimal vToaAnID)
        {
            sql.AppendLine(@"
    /* Dimension tables (direct joins, small lookup tables) */
    LEFT JOIN DM_VKS          KS    ON KS.ID    = d.DONVICHUYEN_HSKN
    LEFT JOIN DM_LOAIDON      LAD   ON LAD.LOAIDON_ID = d.LOAIDON
                                    AND LAD.TOAAN_ID   = :vToaAnID
    LEFT JOIN DM_HANHCHINH    h     ON h.ID     = d.NGUOIGUI_HUYENID
    LEFT JOIN DM_HANHCHINH    hv    ON hv.ID    = d.CV_HUYENID
    LEFT JOIN DM_TOAAN        tk    ON tk.ID    = d.CD_TK_DONVIID
    LEFT JOIN DM_TOAAN        txx   ON txx.ID   = DECODE(d.BAQD_CAPXETXU,
                                          2, d.BAQD_TOAANID_ST,
                                          3, d.BAQD_TOAANID_PT,
                                          d.BAQD_TOAANID)
    LEFT JOIN DM_TOAAN        txxPT ON txxPT.ID = d.BAQD_TOAANID_PT
    LEFT JOIN DM_TOAAN        txxST ON txxST.ID = d.BAQD_TOAANID_ST
    LEFT JOIN DM_PHONGBAN     pb    ON pb.ID    = d.CD_TA_DONVIID
    LEFT JOIN DM_DATAITEM     i     ON i.ID     = d.NGUOIKHANGNGHI
    LEFT JOIN DM_CANBO        c     ON c.ID     = d.THAMPHANID
    LEFT JOIN DM_DATAITEM     chucdanh ON chucdanh.ID = c.CHUCDANHID
    LEFT JOIN QT_NGUOISUDUNG  nsd   ON nsd.USERNAME = d.NGUOITAO

    LEFT JOIN (
        SELECT cb.ID, cb.HOTEN, cv.TEN AS CHUCVU
        FROM   DM_CANBO cb
        LEFT JOIN DM_DATAITEM cv ON cv.ID = cb.CHUCVUID
    ) gqkn ON gqkn.ID = d.CANBO_ID_GIAIQUYET_KN

    /* CTE joins (already filtered to 30 page DONIDs) */
    LEFT JOIN vuan            va    ON va.ID     = d.VUVIECID
    LEFT JOIN sph_all         sp    ON sp.DONID  = d.ID
    LEFT JOIN kqd_all         kqd   ON kqd.DONID = d.ID
    LEFT JOIN tralai                 ON tralai.DONID = d.ID
    LEFT JOIN traloi_all      tld   ON tld.DONID = d.ID AND tld.TYPETB = 3
    LEFT JOIN traloi_all      kn    ON kn.DONID  = d.ID AND kn.TYPETB  = 4
    LEFT JOIN qls             qls   ON qls.DONID = d.ID

    /* KQXXGDT (computed from vuan CTE) */
    LEFT JOIN (
        SELECT v.ID,
               '<br/>KQXXGDT: '
               || ('Số ' || v.XXGDTTT_SOQD
                   || CASE
                        WHEN LENGTH(NVL(v.XXGDTTT_NGAYQD, '')) = 0
                          OR TO_CHAR(v.XXGDTTT_NGAYQD, 'dd/MM/yyyy') = '01/01/0001'
                        THEN ''
                        WHEN LENGTH(NVL(v.XXGDTTT_NGAYQD, '')) > 0
                        THEN ' - ' || TO_CHAR(v.XXGDTTT_NGAYQD, 'dd/MM/yyyy')
                      END
                   || '<br/> ND: ' || CHR(10) || NVL(k.TEN, ' ')
               ) AS KQXXGDT
        FROM   vuan v
        LEFT JOIN DM_DATAITEM k ON k.ID = v.XXGDTTT_KETQUAID
        WHERE  v.GQD_LOAIKETQUA = 1
        AND    (TRIM(v.XXGDTTT_SOQD) IS NOT NULL
                OR LENGTH(NVL(v.XXGDTTT_NGAYQD, '')) > 0)
    ) kq ON kq.ID = d.VUVIECID

    /* DM_LOAIAN */
    LEFT JOIN (
        SELECT ID, LOAI_AN_TEN FROM DM_LOAIAN ORDER BY THUTU
    ) LA ON LA.ID = d.BAQD_LOAIAN

    /* DON_CHUYEN: DC (PHONGBANNHANID=102) */
    LEFT JOIN chuyen_all      dc_102 ON dc_102.DONID = d.ID
                                     AND dc_102.PHONGBANNHANID = 102

    /* DON_CHUYEN: DTL_NC (PHONGBANNHANID = d.CD_TA_DONVIID) */
    LEFT JOIN chuyen_all      dc_ta  ON dc_ta.DONID = d.ID
                                     AND dc_ta.PHONGBANNHANID = d.CD_TA_DONVIID

    /* DON_CHUYEN_HISTORY (DC_HIS, PHONGBANNHANID=102) */
    LEFT JOIN (
        SELECT tc.DONID,
               '<i><b> <span  style=""color: #0e7eee;"">'
               || DECODE(tc.TRANGTHAI,
                      1, 'Chưa nhận',
                      2, 'Đã nhận',
                      3, 'Trả lại',
                      4, 'Đã chuyển')
               || '</span>'
               || '<span >: Thẩm phán</b></i> </span><br />'  TRANGTHAICHUYEN_TP,
               '<br/><i>Ngày chuyển: '
               || TO_CHAR(tc.NGAYCHUYEN, 'dd/MM/yyyy hh24:mi:ss')
               || '</i><br/>'                                   NGAYCHUYEN
        FROM   GDTTT_DON_CHUYEN_HISTORY tc
        WHERE  tc.DONID IN (SELECT ID FROM don_page)
        AND    tc.PHONGBANNHANID = 102
    ) dc_his ON dc_his.DONID = d.ID

    /* Duongsu (pivoted from duongsu_all CTE) */
    LEFT JOIN duongsu_all     nds   ON nds.DONID = d.ID
                                    AND nds.TUCACHTOTUNG = 'NGUYENDON'
                                    AND nds.BAQD_LOAIAN IN (2,3,4,5,6,7)
    LEFT JOIN duongsu_all     bds   ON bds.DONID = d.ID
                                    AND bds.TUCACHTOTUNG = 'BIDON'
                                    AND bds.BAQD_LOAIAN IN (2,3,4,5,6,7)
    LEFT JOIN duongsu_all     bcs   ON bcs.DONID = d.ID
                                    AND bcs.TUCACHTOTUNG = 'BIDON'
                                    AND bcs.BAQD_LOAIAN = 1

    /* VT + VBD */
    LEFT JOIN VT_CHUYEN_NHAN  vt    ON vt.GDTTT_DON_ID = d.ID
    LEFT JOIN VT_VANBANDEN    vbd   ON vbd.ID = vt.VANBANDEN_ID
    LEFT JOIN DM_TOAAN        pbvt  ON pbvt.ID = vt.DONVI_CHUYEN_ID
    LEFT JOIN DM_TOAAN        TA    ON TA.ID   = vbd.TOAAN_BAQD_DON

    /* N+1 elimination CTEs */
    LEFT JOIN ycbs_all        ycbs  ON ycbs.DONID = d.ID
    LEFT JOIN thoihieu_all    thieu ON thieu.DONID = d.ID

    /* Task 5: KN case assignment and VAKN books */
    LEFT JOIN ctc_all         ctc   ON ctc.VUAN_ID = d.VUVIECID
    LEFT JOIN sph_vakn        svTT  ON svTT.VUAN_ID = d.VUVIECID AND svTT.MASO = 'SoTT'
    LEFT JOIN sph_vakn        svTB  ON svTB.VUAN_ID = d.VUVIECID AND svTB.MASO = 'TBTP'");
        }

        /// <summary>
        /// Builds the GROUP BY clause (required for pivot MAX() aggregates).
        /// </summary>
        private void BuildGroupBy(StringBuilder sql)
        {
            sql.AppendLine(@"
    /* GROUP BY: needed because sph_all and kqd_all produce multiple
     * rows per DONID (different MASO/LOAI). MAX(CASE WHEN ...) pivots
     * collapse them back to one row per DON.
     */
    GROUP BY
        dp.STT,
        d.ID, d.MADON, d.LOAIDON, d.SOHIEUDON, d.NGUOIGUI_HOTEN,
        d.SOTHUTUDON, d.NGAYNHANDON, d.BAQD_NGAYBA,
        d.BAQD_LOAIQDBA, d.NGUOITAO, d.CV_TENDONVI,
        d.ISNOTGDTTT, d.NGUOISUA, d.NGAYSUA, d.NGAYTAO,
        d.TL_NGAY, d.TL_SO, d.CD_SOCV, d.CD_NGAYCV, d.CD_NGUOIKY,
        d.ISSHOWFULL, d.NGUOIGUI_HUYENID, d.NGUOIGUI_DIACHI,
        d.CV_SO, d.CV_NGAY, d.NGAYGHITRENDON, d.SO_HSKN, d.NGAY_HSKN,
        d.KN_SOQD, d.BAQD_CAPXETXU, d.BAQD_SO_PT, d.BAQD_SO_ST, d.BAQD_SO,
        d.KN_NGAY, d.BAQD_NGAYBA_ST, d.BAQD_NGAYBA_PT,
        d.NGUOIKHANGNGHI, d.CD_TRANGTHAI, d.DUNGDONLA,
        d.NGUOIGUI_GIOITINH, d.CD_TA_LYDO_ISBAQD, d.CD_TA_LYDO_ISXACNHAN,
        d.CD_TA_LYDO_ISKHAC, d.CV_DIACHI,
        d.CHIDAO_COKHONG, d.CD_LOAI, d.VUVIECID,
        d.CD_TA_DONVIID, d.CD_NTA_TENDONVI, d.TOAANID, d.ISTHULY,
        d.BAQD_LOAIAN, d.CD_TRALAI_LYDOID, d.TB1_SO, d.TB1_NGAY,
        d.TB2_SO, d.TB2_NGAY, d.THAMPHANID, d.ARR_DON_ID,
        d.CD_TA_TRANGTHAI, d.DONTRUNGID, d.PHANLOAIXULY,
        d.LOAI_GDTTTT, d.NGUOIGUI_DIENTHOAI, d.ISTPB3,
        /* 1:1 dimension joins */
        KS.TEN, LAD.LOAIDON_TEN_VT, h.MA_TEN, hv.MA_TEN,
        i.TEN, txx.MA_TEN, txxST.MA_TEN, txxPT.MA_TEN,
        pb.TENPHONGBAN, gqkn.HOTEN, gqkn.CHUCVU,
        tk.MA_TEN, c.HOTEN, chucdanh.MA,
        /* vuan */
        va.ID, va.LOAIAN, va.GQD_LOAIKETQUA, va.GDQ_SO, va.GDQ_NGAY,
        va.GQD_NgayPhatHanhCV, va.SOTHULYXXGDT, va.NGAYTHULYXXGDT,
        va.IsVienTruongKN, va.GQD_ISHOANTHA, va.GQD_HOANTHA_SO,
        va.GQD_HOANTHA_NGAY,
        LA.LOAI_AN_TEN,
        /* chuyen */
        dc_102.DONID, dc_102.TRANGTHAI, dc_102.NGAYCHUYEN,
        dc_his.TRANGTHAICHUYEN_TP,
        dc_ta.DONID, dc_ta.NGAYCHUYEN,
        /* qls */
        qls.SOVB, qls.NGAYVB,
        /* vt/vbd */
        vt.VANBANDEN_ID, vt.CANBO_NHAN_ID, vt.TRANG_THAI_XLY,
        vbd.LOAI_VB,
        vbd.NGAY_DEN, vbd.NGAY_BT,
        vbd.SO_BAQD_DON, vbd.NGAY_BAQD_DON, TA.MA_TEN,
        vbd.SO_VB, vbd.NGAY_VB, vbd.SO_CV, vbd.NGAY_CV,
        pbvt.TEN, vbd.SODEN, vbd.TOAAN_BAQD_DON,
        /* N+1 CTEs (1:1 per DONID) */
        ycbs.YCBS, thieu.THOIHIEU,
        /* ctc / sph_vakn */
        ctc.THAMPHANID, ctc.THAMPHANTC_TEN, ctc.TRANGTHAICHUYENTP, ctc.NGAYCHUYENTP,
        svTT.SOVB, svTT.NGAYVB,
        svTB.SOVB, svTB.NGAYVB");
        }

        /// <summary>
        /// Post-processes query results for UI display.
        /// Formats dates, builds display strings, sets visibility flags.
        /// N+1 queries eliminated - YCBS, THOIHIEU from CTEs; ARR_DON per-row with bind params.
        /// Ported from gdttt_search.txt lines 731-1515.
        /// </summary>
        private void PostProcessResults(DataTable tbl, decimal vToaAnID, string v_ID_USER)
        {
            if (tbl == null || tbl.Rows.Count == 0) return;

            System.Globalization.CultureInfo cul =
                System.Globalization.CultureInfo.GetCultureInfo("vi-VN");
            System.Globalization.DateTimeStyles dts = System.Globalization.DateTimeStyles.NoCurrentDateDefault;

            foreach (DataRow row in tbl.Rows)
            {
                row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                row["IS_SHOW_TP"] = "none";
                row["IS_SHOW_DC"] = "none";
                int rs = 0, rs1 = 0;
                String _date1 = String.Format("{0:dd/MM/yyyy}", row["NgayNhap"]);
                String _date2 = "10/06/2024";
                String _date3 = "28/01/2026";
                if (row["NgayNhap"] + "" != "")
                {
                    rs = DateTime.Compare(
                        DateTime.Parse(_date1, cul, dts),
                        DateTime.Parse(_date2, cul, dts));
                    rs1 = DateTime.Compare(
                        DateTime.Parse(_date1, cul, dts),
                        DateTime.Parse(_date3, cul, dts));
                }
                if (rs > 0 && rs1 < 0)
                {
                    row["IS_SHOW_TP"] = "block";
                }
                if (rs1 > 0)
                {
                    row["IS_SHOW_DC"] = "block";
                }

                // MADON_CC, LBL_HINHTHUC_CC
                row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                String n_dd = "<i>Người gửi:</i>";
                if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                {
                    n_dd = "<i>Người đứng đơn:</i>";
                }
                row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";

                if (row["LOAIDON"] + "" == "4")
                {
                    row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                    row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                    row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";
                    row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                    row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];
                }
                else
                {
                    if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                    {
                        row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                        row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                    }
                }

                if (row["LOAIDON"] + "" == "5")
                {
                    row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                    row["LBL_HINHTHUC_CC"] = "Ngày VB";
                    row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                }

                if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                {
                    row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                    row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                }

                // DONGKHIEUNAI_CC
                if (row["DONGKHIEUNAI"] + "" == "")
                {
                    if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                    {
                        row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                    }
                    if (row["LOAIDON"] + "" == "4")
                    {
                        row["DONGKHIEUNAI"] = row["TEN"] + "";
                    }
                    else
                    {
                        row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                    }
                }
                String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                row["DONGKHIEUNAI_CC"] = n_dd + dkn;

                // NGAYNHANDON date formatting
                row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                {
                    row["NGAYNHANDON"] = "";
                }
                row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                {
                    row["NgayBA_PT"] = "";
                }
                if (row["BAQD_LOAIQDBA"] + "" == "")
                {
                    row["BAQD_LOAIQDBA"] = "0";
                }
                if (row["BAQD_CAPXETXU"] + "" == "")
                {
                    row["BAQD_CAPXETXU"] = "0";
                }

                // DIACHIGUI logic
                if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                {
                    row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                }
                else
                {
                    if (row["NGUOIGUI_HUYENID"] + "" == "981")
                    {
                        row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                    }
                    if (row["NGUOIGUI_HUYENID"] + "" != "981")
                    {
                        if (row["NGUOIGUI_DIACHI"] + "" == "")
                        {
                            row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                        }
                        if (row["NGUOIGUI_DIACHI"] + "" != "")
                        {
                            row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                        }
                    }
                }
                if (row["CVDIACHI"] + "" != "")
                {
                    row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                }

                // BAQD formatting
                String lbl_BAQD_CC = "QĐ: ";
                String lbl_baqd = "QĐ: ";
                row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                if (row["BAQD_LOAIQDBA"] + "" == "1")
                {
                    row["BAQD_SO"] = row["KN_SOQD"] + "";
                    row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                    row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                    row["BAQD_NGAYBA"] = row["KN_NGAY"];
                    row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                    row["TOAXX"] = row["TEN_I"];
                }
                if (row["TOAANID"] + "" == "1")
                {
                    row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                }
                else
                {
                    if (row["BAQD_LOAIQDBA"] + "" == "1")
                    {
                        row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                    }
                    {
                        row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                    }
                }
                if (row["BAQD_LOAIQDBA"] + "" != "1")
                {
                    if (row["BAQD_LOAIQDBA"] + "" == "0")
                    {
                        lbl_baqd = "BA/QĐ: ";
                        lbl_BAQD_CC = "BA: ";
                    }
                    row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                    row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                    if (row["BAQD_CAPXETXU"] + "" == "2")
                    {
                        row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                        row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                        row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                        row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                        row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                        row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";
                    }
                    if (row["BAQD_CAPXETXU"] + "" == "3")
                    {
                        row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                        row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                        row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                        row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                        row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                        row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                    }
                }
                row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                if (row["LOAIDON"] + "" == "5")
                {
                    row["BAQD_CC"] = "";
                    row["BAQD_NGAYBA_CC"] = "";
                }

                // Infor_ST / Infor_PT
                if (row["BAQD_SO_ST"] + "" != "")
                {
                    row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                    if (row["BAQD_NGAYBA_ST"] + "" != "")
                    {
                        row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                    }
                    row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                }
                if (row["BAQD_SO_PT"] + "" != "")
                {
                    row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                    if (row["BAQD_NGAYBA_PT"] + "" != "")
                    {
                        row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                    }
                    row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                }

                // GHICHU with tralai reason
                if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                {
                    row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                }

                // NOICHUYEN / GIAIQUYET
                row["IsShowNB"] = "none";
                row["IsShowTK"] = "block";
                if (row["CD_LOAI"] + "" == "0")
                {
                    if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                    {
                        if (row["CHUCVU"] + "" != "")
                            row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                        else
                            row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                    }
                    else
                    {
                        row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                    }
                    row["IsShowNB"] = "block";
                    row["IsShowTK"] = "none";
                }
                if (row["CD_LOAI"] + "" == "1")
                {
                    row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                }
                if (row["CD_LOAI"] + "" == "2")
                {
                    row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                }
                row["GIAIQUYET"] = "Chuyển đơn";
                if (row["CD_LOAI"] + "" == "3")
                {
                    row["NOICHUYEN"] = "Trả lại đơn";
                    row["GIAIQUYET"] = "Trả lại đơn";
                }
                if (row["CD_LOAI"] + "" == "4")
                {
                    row["NOICHUYEN"] = "Không chuyển";
                    row["GIAIQUYET"] = "Xếp đơn";
                }

                // lb_thuly
                if (row["LOAIDON"] + "" == "4")
                    row["lb_thuly"] = "Thụ lý xét xử";
                else
                    row["lb_thuly"] = "Thụ lý mới";

                // IsShowTLMOI
                row["IsShowTLMOI"] = "none";
                if (row["ISTHULY"] + "" == "1")
                {
                    if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                    {
                        if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                            row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                        else
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                    }
                    if (rs1 < 0)
                    {
                        row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                    }
                    row["IsShowTLMOI"] = "block";
                }
                if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                {
                    row["IsShowTLMOI"] = "block";
                }

                // IsShowTLMOI_TRUNG_TP
                row["IsShowTLMOI_TRUNG_TP"] = "none";
                if (row["IsShowTLMOI"] + "" == "block")
                {
                    if (row["ARR_DON_ID"] + "" != "")
                    {
                        if (Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                        {
                            row["IsShowTLMOI_TRUNG_TP"] = "block";
                            row["IsShowTLMOI"] = "none";
                        }
                    }
                }

                // IsShowDATL
                row["IsShowDATL"] = "none";
                if (row["ISTHULY"] + "" == "2")
                {
                    row["IsShowDATL"] = "block";
                }

                if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                {
                    row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                }

                // THAMPHAN_SONGAY
                if (row["TENTHAMPHAN"] + "" != "")
                {
                    row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + (Convert.ToString(row["CHUCDANH"]) == "TPBAC3" ? " (TPB3) " : " (TPTC) ") + "</b>" +
                        "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                        + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                        + ")<br/>";
                }
                // VAKN assignment info
                if (row["THAMPHANTC_TEN"] + "" != "")
                {
                    string info = "<i>Thẩm phán: </i><b>" + row["THAMPHANTC_TEN"] + " (TPTC) " + "</b>" +
                        "(" + row["TOTRINH_VAKN"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["NGAYTOTRINH_VAKN"])
                        + "<b>;</b> " + row["TBTP_VAKN"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYTBTP_VAKN"])
                        + ")<br/>";
                    row["THAMPHANTC_TEN"] = info;
                }
                row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);

                // IsShowDDK / IsShowCDDK
                row["IsShowDDK"] = "none";
                row["IsShowCDDK"] = "none";
                if (row["CD_TA_TRANGTHAI"] + "" == "0")
                {
                    row["IsShowDDK"] = "block";
                }
                if (row["CD_TA_TRANGTHAI"] + "" == "1")
                {
                    row["IsShowCDDK"] = "block";
                }

                // IsThulyXX
                row["IsThulyXX"] = "none";
                if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                {
                    row["IsThulyXX"] = "block";
                }

                // arrCongvan
                row["arrCongvan"] = "";
                if (row["LOAIDON"] + "" != "1")
                {
                    row["arrCongvan"] = row["CV_TENDONVI"] + "";
                    if (row["CV_SO"] + "" != "")
                    {
                        row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                    }
                    if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                    {
                        row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                    }
                }

                // TRANG_THAI_XLY_NAME
                if (row["TRANG_THAI_XLY"] + "" == "4")
                {
                    row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                }

                // NGUOI_GUI_BT formatting
                row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                {
                    row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                    row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                }

                // NGAY_DEN / NGAY_BT
                if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                {
                    row["NGAY_DEN"] = "";
                }
                if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                {
                    row["NGAY_BT"] = "";
                }

                // THONGTIN_VBD
                if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                {
                    String V_NGAY_BAQD_DON = "";
                    if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                    {
                        V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                    }
                    row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                }
                if (row["LOAI_VB"] + "" == "5")
                {
                    String V_NGAY_VB = "";
                    if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                    {
                        V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                    }
                    row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                }
                if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                {
                    String V_NGAY_CV = "";
                    if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                    {
                        V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                    }
                    row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                }

                // DONVITIEPNHAN
                if (row["TEN_PBVT"] + "" != "")
                {
                    row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                }

                // NGUON_DEN
                if (row["NGUON_DEN_S"] + "" == "1")
                {
                    row["NGUON_DEN"] = "Bưu điện";
                }
                if (row["NGUON_DEN_S"] + "" == "2")
                {
                    row["NGUON_DEN"] = "Tiếp công dân";
                }
                if (row["NGUON_DEN_S"] + "" == "3")
                {
                    row["NGUON_DEN"] = "Trực tiếp";
                }

                // TRANGTHAILOAI_GDTTTT / LOAIGDTT
                if (row["LOAI_GDTTTT"] + "" == "1")
                {
                    row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                    row["LOAIGDTT"] = "Giám đốc thẩm";
                }
                if (row["LOAI_GDTTTT"] + "" == "2")
                {
                    row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                    row["LOAIGDTT"] = "Tái thẩm";
                }
                if (row["LOAI_GDTTTT"] + "" == "3")
                {
                    row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                }

                // === YCBS - now from ycbs_all CTE, no inner SQL needed ===

                // IsGXN / IsGXNDV
                row["IsGXN"] = "block";
                if (row["GXNSO"] + "" == "")
                {
                    row["IsGXN"] = "none";
                }
                row["IsGXNDV"] = "block";
                if (row["GXNSODV"] + "" == "")
                {
                    row["IsGXNDV"] = "none";
                }

                // === THOIHIEU - now from thoihieu_all CTE, no inner SQL needed ===

                // === ARR_DON_IDS/TONG_SODON/arrDonID - per-row queries (bind params) ===
                string donId = row["ID"] + "";
                if (!string.IsNullOrEmpty(donId))
                {
                    // ARR_DON_IDS
                    var arrParms = new List<OracleParameter> {
                        new OracleParameter(":pDonId1", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) },
                        new OracleParameter(":pDonId2", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) }
                    };
                    DataTable tblArrs = ExecuteQuery(
                        "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID) ARR_DON_IDS " +
                        "FROM GDTTT_DON cv " +
                        "WHERE CV.ID = :pDonId1 OR (cv.CD_TA_TRANGTHAI IN (2,3) AND CV.ARR_DON_ID = :pDonId2) " +
                        "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)", arrParms);
                    if (tblArrs?.Rows.Count > 0)
                        row["ARR_DON_IDS"] = tblArrs.Rows[0]["ARR_DON_IDS"];

                    // TONG_SODON
                    var cntParms = new List<OracleParameter> {
                        new OracleParameter(":pDonId1", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) },
                        new OracleParameter(":pDonId2", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) },
                        new OracleParameter(":pDonId3", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) }
                    };
                    DataTable tblTong = ExecuteQuery(
                        "SELECT COUNT(*) TONG_SODON FROM GDTTT_DON cv " +
                        "WHERE CV.ID = :pDonId1 OR (cv.CD_TA_TRANGTHAI IN (2,3) AND " +
                        "(CV.ARR_DON_ID = :pDonId2 OR CV.ARR_DON_ID IN " +
                        "(SELECT ARR_DON_ID FROM GDTTT_DON WHERE ID = :pDonId3 AND ARR_DON_ID > 0)))", cntParms);
                    if (tblTong?.Rows.Count > 0)
                        row["TONG_SODON"] = tblTong.Rows[0]["TONG_SODON"];

                    // arrDonID
                    var listParms = new List<OracleParameter> {
                        new OracleParameter(":pDonId1", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) },
                        new OracleParameter(":pDonId2", OracleDbType.Decimal) { Value = Convert.ToDecimal(donId) }
                    };
                    DataTable tblArr = ExecuteQuery(
                        "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                        "FROM GDTTT_DON cv " +
                        "WHERE CV.ID = :pDonId1 OR (cv.CD_TA_TRANGTHAI IN (2,3) AND CV.ARR_DON_ID = :pDonId2)", listParms);
                    if (tblArr?.Rows.Count > 0)
                        row["arrDonID"] = tblArr.Rows[0]["arrDonID"];
                }
                if (row["TONG_SODON"] + "" == "")
                    row["TONG_SODON"] = "1";

                // KQGQNoiBo logic (lines 1249-1513 of original)
                if (row["CD_LOAI"] + "" == "0" && row["VUVIECID"] + "" != "" && row["VUVIECID"] + "" != "0")
                {
                    if (row["LOAIAN"] + "" == "1") // hinh su
                    {
                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                        {
                            if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                            {
                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                row["KQGQNoiBo"] += "</b>";
                            }
                            else
                            {
                                row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                            }
                        }
                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                        {
                            if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                            {
                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                row["KQGQNoiBo"] += "</b>";
                            }
                            else
                            {
                                row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                            }
                        }
                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                        {
                            row["KQGQNoiBo"] = "Xếp đơn <b>";
                            if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                            if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                            row["KQGQNoiBo"] += "</b>";
                        }
                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                        {
                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                            if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                            if (row["GQD_NgayPhatHanhCV"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                            row["KQGQNoiBo"] += "</b>";
                        }
                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                        {
                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                            if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                            if (row["GQD_NgayPhatHanhCV"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                            row["KQGQNoiBo"] += "</b>";
                        }
                        if (row["GQD_LOAIKETQUA"] + "" == "")
                        {
                            if (row["CD_TRANGTHAI"] + "" == "2")
                            {
                                row["KQGQNoiBo"] = "Đang giải quyết";
                            }
                        }
                    }
                    else // dan su mo rong
                    {
                        if (row["GQD_LOAIKETQUA"] + "" != "")
                        {
                            if (row["KQGQ_DANSU_EX"] + "" == "")
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                        if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                        if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                        if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                        if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = "Kháng nghị <b>";
                                        if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                        if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                    if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                    if (row["GDQ_NGAY"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "") row["KQGQNoiBo"] += " số " + row["GDQ_SO"];
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "") row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "5")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                        row["KQGQNoiBo"] += "</b>";
                                        row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                        row["KQGQNoiBo"] += "</b>";
                                        row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "5")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (row["CD_TRANGTHAI"] + "" == "2")
                            {
                                row["KQGQNoiBo"] = "Đang giải quyết";
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Resolves ThamphanID with PCA/CA role check.
        /// If user has PCA or CA role and selected their own CANBOID, returns 0 (no filter).
        /// Otherwise returns vThamphanID as-is.
        /// Replaces original EF LINQ: dt.QT_NGUOISUDUNG/DM_CANBO/DM_DATAITEM lookups.
        /// </summary>
        private decimal ResolveThamphanID(decimal vThamphanID, string v_ID_USER)
        {
            if (vThamphanID == 0) return 0;
            try
            {
                string sql = @"SELECT di.MA, nsd.CANBOID
                    FROM QT_NGUOISUDUNG nsd
                    JOIN DM_CANBO cb ON cb.ID = nsd.CANBOID
                    LEFT JOIN DM_DATAITEM di ON di.ID = cb.CHUCVUID
                    WHERE nsd.ID = :vUserID";
                var parms = new List<OracleParameter> {
                    new OracleParameter(":vUserID", OracleDbType.Decimal) { Value = Convert.ToDecimal(v_ID_USER) }
                };
                DataTable tbl = ExecuteQuery(sql, parms);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string ma = Convert.ToString(tbl.Rows[0]["MA"]);
                    decimal canboId = Convert.ToDecimal(tbl.Rows[0]["CANBOID"]);
                    if ((ma == "PCA" || ma == "CA") && canboId == vThamphanID)
                        return 0; // self-selection by PCA/CA: show all
                }
            }
            catch { /* fallback to using vThamphanID as-is */ }
            return vThamphanID;
        }


        private DataTable ExecuteQuery(string sql, List<OracleParameter> parameters = null)
        {
            if (parameters == null || parameters.Count == 0)
                return Cls_Comon.GetTableToSQL(sql);

            // Cls_Comon.GetTableToSQL(string) does not support OracleParameter[].
            // Use OracleCommand directly for parameterized queries.
            // TODO: verify connection string name matches your Web.config entry
            var connSetting = ConfigurationManager.ConnectionStrings["GSTPConnection"];
            if (connSetting == null)
                throw new InvalidOperationException("Connection string 'OracleDbContext' not found in Web.config. Check the name matches your configuration.");
            string connStr = connSetting.ConnectionString;
            using (var conn = new OracleConnection(connStr))
            {
                conn.Open();
                using (var cmd = new OracleCommand(sql, conn))
                {
                    cmd.BindByName = true;
                    cmd.Parameters.AddRange(parameters.ToArray());
                    using (var adapter = new OracleDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        private void LogError(string method, Exception ex)
        {
            // Implement error logging
            Console.WriteLine($"Error in {method}: {ex.Message}");
        }
    }
}
