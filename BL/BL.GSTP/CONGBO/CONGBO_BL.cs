using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using DocumentFormat.OpenXml.Vml;
using DocumentFormat.OpenXml.Wordprocessing;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Text;

namespace BL.GSTP
{
    public class CONGBO_BL
    {
        public DataTable GetAllPaging_Search_All(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an,
                                                 string v_bi_can, string v_Capxx, string v_toaan_id, string v_TINHTRANG_THULY, string v_SOTHULY,
                                                 string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY,
                                                 string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id,
                                                 string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI, string V_LOAIAN_ID,
                                                 string V_TRANGTHAI_CONGBO, decimal PageIndex, decimal PageSize)
        {
            v_ten_vu_an = v_ten_vu_an.Normalize(NormalizationForm.FormC);
            v_toidanh = v_toidanh.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            decimal? trangthaiCB = null;
            try
            {
                trangthaiCB = Convert.ToDecimal(V_TRANGTHAI_CONGBO);
            }
            catch { }
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("V_TRANGTHAI_CONGBO",trangthaiCB),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_CONGBO_DS.HS_DS_EXT_SEARCH_ALL_CONGBO", parameters);
            return tbl;
        }
        public DataTable Get_BAQD_CONGBO_LICHSU_LIST(decimal BAQD_CONGBO_ID, decimal PageIndex, decimal PageSize)
        {
            Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
            Decimal MaxIndex = PageIndex * PageSize;

            try
            {
                String SQL = " select tt.*, " +
                             " DECODE (tt.HANHDONG,   " +
                             "         'ADD_FILE_GOC', 'Thêm tệp gốc'," +
                             "         'ADD_FILE_DA_MA_HOA', 'Thêm tệp đã mã hóa'," +
                             "         'ADD_FILE_DONG_DAU', 'Thêm tệp đã đóng dấu'," +
                             "         'UPDATE_FILE_GOC', 'Cập nhật tệp gốc'," +
                             "         'UPDATE_FILE_DA_MA_HOA', 'Cập nhật tệp đã mã hóa'," +
                             "         'UPDATE_FILE_DONG_DAU', 'Cập nhật tệp đã đóng dấu'," +
                             "         'DELETE_FILE_GOC', 'Xóa tệp gốc'," +
                             "         'DELETE_FILE_DA_MA_HOA', 'Xóa tệp đã mã hóa'," +
                             "         'DELETE_FILE_DONG_DAU', 'Xóa tệp đã đóng dấu'," +
                             "         'KHONGCONGBO', 'Chuyển trạng thái thành không công bố'," +
                             "         'UPDATE_KHONGCONGBO', 'Cập nhật lý do không công bố'," +
                             "         'DELETE_KHONGCONGBO', 'Xóa trạng thái không công bố'," +
                             "         'CONGBO', 'Trạng thái được chuyển thành công bố'," +
                             "         'INSERT_CONGBO','BA/QĐ đủ điều kiện công bố'," +
                             "         '') HANHDONG_MOTA " +
                             "from (       SELECT  ROW_NUMBER() OVER (ORDER BY ls.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll,ls.*    " +
                             "             FROM     (  SELECT * " +
                             "                         FROM BAQD_CONGBO_LICHSU " +
                             "                         WHERE BAQD_CONGBO_ID = " + BAQD_CONGBO_ID + "  " +
                             "                         UNION   " +
                             "                         Select 0 ID,cb.ID BAQD_CONGBO_ID,'INSERT_CONGBO' HANHDONG, null FILESERVER_ID_OLD,null FILESERVER_ID_NEW,'Hệ thống' NGUOITAO,nvl(cb.NGAYTAO,to_date('01/01/2000 00:00:00' ,'mm/dd/yyyy hh24:mi:ss')) NGAYTAO  " +
                             "                         from BAQD_CONGBO cb  " +
                             "                         where ID = " + BAQD_CONGBO_ID + " AND ROWNUM = 1    ) ls " +
                             "                      )tt " +
                             "where tt.stt>= " + MinIndex + " and tt.stt<= " + MaxIndex + " ";
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public Decimal DBLINK_GET_TOAANID_CONGBO(decimal TOAANID)
        {
            try
            {
                // ================= BƯỚC 1: LẤY MADONGBO =================
                string sqlMadongbo = " SELECT NVL(MADONGBO,'') MADONGBO " +
                                     " FROM DM_TOAAN " +
                                     " WHERE ID = " + TOAANID;

                DataTable dtMadongbo = Cls_Comon.GetTableToSQL(sqlMadongbo);

                if (dtMadongbo.Rows.Count == 0)
                {
                    return 0;
                }

                string madongbo = dtMadongbo.Rows[0]["MADONGBO"].ToString();

                if (string.IsNullOrEmpty(madongbo))
                {
                    return 0;
                }

                // ================= BƯỚC 2: LẤY ID QUA DBLINK =================
                string sqlToaanCongbo = " SELECT V.ID TOAANID_CONGBO " +
                                        " FROM ROOM_COURTS@DBLINK_CBBA.TOAAN.GOV.VN V " +
                                        " WHERE V.MADONGBO = '" + madongbo.Replace("'", "''") + "'";

                DataTable dtResult = Cls_Comon.GetTableToSQL(sqlToaanCongbo);

                if (dtResult.Rows.Count == 0)
                {
                    // tương đương NO_DATA_FOUND → RETURN NULL
                    return 0;
                }

                return Convert.ToDecimal(dtResult.Rows[0]["TOAANID_CONGBO"].ToString());
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return 0;
            }
        }
        public DataTable DBLINK_GET_LIST_TC_CRIMINALS_LIST_FRONT_END()
        {
            try
            {
                String V_TIMES = "NULL";
                String SQL = "SELECT CR.ID, CR.CHAPTER_ID, CR.CRIMINAL_ID, CR.CRIMINAL_ID||'. '|| CR.CRIMINAL_NAME||' ('||TCR.TIME_NAME||')' CRIMINAL_NAME , CR.YOUTH, CR.DEATH " +
                             "  FROM TC_CRIMINALS@DBLINK_CBBA.TOAAN.GOV.VN CR " +
                             "  INNER JOIN TC_CHAPTERS@DBLINK_CBBA.TOAAN.GOV.VN CH ON CR.CHAPTER_ID=CH.ID " +
                             "  LEFT JOIN TC_TIME_CRIMINALS@DBLINK_CBBA.TOAAN.GOV.VN TCR ON TCR.ID=CH.TIMES " +
                             "WHERE ((CH.TIMES= " + V_TIMES + " AND " + V_TIMES + " IS NOT NULL) OR ( " + V_TIMES + " IS NULL)) " +
                             "ORDER BY CR.CRIMINAL_ID DESC";
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public DataTable DBLINK_GET_LIST_TC_CASES_LIST_FULL(String V_STYLES)
        {
            try
            {
                String SQL = " SELECT TC.ID, TC.CASE_ID, ( lpad('--------',2*(level-1))|| TC.CASE_NAME) CASE_NAME, TC.STYLES, TC.OPTIONS, TC.DESCRIPTIONS, TC.PARENT_ID, TC.ORDERS, TC.ENABLE " +
                             " FROM  TC_CASES@DBLINK_CBBA.TOAAN.GOV.VN TC " +
                             " start with TC.PARENT_ID=0 AND TC.STYLES = " + V_STYLES + " AND TC.ENABLE=1 " +
                             " CONNECT BY PRIOR TC.ID=TC.PARENT_ID AND TC.ENABLE=1 " +
                             " ORDER SIBLINGS by ORDERS ";
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public DataTable DBLINK_GET_LIST_ANLE()
        {
            try
            {
                String SQL = "SELECT V.* FROM PUBLIC_DATA_AN_LE@DBLINK_CBBA.TOAAN.GOV.VN V order by v.SO_ANLE";
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public DataTable Get_Thongtin_Banan_Quyetdinh(BAQD_CONGBO BAQD_Congbo)
        {
            try
            {
                /* BAQD_Congbo.LOAIANID     1: AHS; 2: ADS; 3: AHN; 4: AKT; 5: ALD; 6: AHC; 7: APS;
                 * BAQD_Congbo.ISBA         1: Bản án; 0: Quyết định
                 * BAQD_Congbo.CAPXETXU     2: sơ thẩm; 3: phúc thẩm 4: giám đốc thẩm, tái thẩm;
                */

                String LOAIAN = "";
                switch (Convert.ToInt16(BAQD_Congbo.LOAIANID))
                {
                    case 1: LOAIAN = "AHS"; break;
                    case 2: LOAIAN = "ADS"; break;
                    case 3: LOAIAN = "AHN"; break;
                    case 4: LOAIAN = "AKT"; break;
                    case 5: LOAIAN = "ALD"; break;
                    case 6: LOAIAN = "AHC"; break;
                    case 7: LOAIAN = "APS"; break;
                    case 8: LOAIAN = "XLHC"; break;
                }

                String SELECT = "";
                String LEFTJOIN = "";
                String WHERE = "";
                if (BAQD_Congbo.LOAIANID == 1 && (BAQD_Congbo.CAPXETXU == 2 || BAQD_Congbo.CAPXETXU == 3))
                {
                    if (BAQD_Congbo.ISBA == 1)
                    {
                        if (BAQD_Congbo.CAPXETXU == 2)
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYBANAN NGAYBAQD, NULL HIEULUCTU, BCDV.TOIDANHID QHPLTKID,  " +
                                     "        BAQDKT.ISANLE APDUNGANLE, BAQDKT.SOANLE SOANLE " +
                                     " FROM BAQD_CONGBO BAQDCB ";

                            LEFTJOIN = " INNER JOIN AHS_SOTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN (SELECT BC.VUANID, C.TOIDANHID" +
                                       "                       FROM  AHS_BICANBICAO BC " +
                                       "                       INNER JOIN (SELECT CD.TOIDANHID,CD.BICANID FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE CD.ISMAIN = 1" +
                                       "                       ) C ON BC.ID = C.BICANID" +
                                       "             WHERE BC.BICANDAUVU = 1" +
                                       "             ) BCDV on BAQDCB.VUVIECID = BCDV.VUANID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYBANAN NGAYBAQD, NULL HIEULUCTU, TLPT.TOIDANHCHINH_VUAN QHPLTKID,  " +
                                     "        BAQDKT.ISANLE APDUNGANLE, BAQDKT.SOANLE SOANLE " +
                                     " FROM BAQD_CONGBO BAQDCB ";

                            LEFTJOIN = " INNER JOIN AHS_PHUCTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN AHS_PHUCTHAM_THULY TLPT ON BAQDCB.VUVIECID = TLPT.VUANID ";
                        }
                    }

                    if (BAQD_Congbo.ISBA == 0)
                    {
                        if (BAQD_Congbo.CAPXETXU == 2)
                        {

                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOQUYETDINH SOBAQD, BAQDKT.NGAYQD NGAYBAQD, BAQDKT.HIEULUCTU, BCDV.TOIDANHID QHPLTKID,  " +
                                     "        TKQD.APDUNGANLE APDUNGANLE, TKQD.SOANLE SOANLE " +
                                     " FROM BAQD_CONGBO BAQDCB ";

                            LEFTJOIN = " INNER JOIN AHS_SOTHAM_QUYETDINH_VUAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN (SELECT BC.VUANID, C.TOIDANHID" +
                                       "                       FROM  AHS_BICANBICAO BC " +
                                       "                       INNER JOIN (SELECT CD.TOIDANHID,CD.BICANID FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE CD.ISMAIN = 1" +
                                       "                       ) C ON BC.ID = C.BICANID" +
                                       "             WHERE BC.BICANDAUVU = 1" +
                                       "             ) BCDV on BAQDCB.VUVIECID = BCDV.VUANID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1  AND DMQD.ISSOTHAM = 1 " +
                                       " LEFT JOIN TK_SOTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {

                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOQUYETDINH SOBAQD, BAQDKT.NGAYQD NGAYBAQD, BAQDKT.HIEULUCTU, TLPT.TOIDANHCHINH_VUAN QHPLTKID,  " +
                                     "        TKQD.APDUNGANLE APDUNGANLE, TKQD.SOANLE SOANLE " +
                                     " FROM BAQD_CONGBO BAQDCB ";

                            LEFTJOIN = " INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN AHS_PHUCTHAM_THULY TLPT ON BAQDCB.VUVIECID = TLPT.VUANID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1  AND DMQD.ISPHUCTHAM = 1 " +
                                       " LEFT JOIN TK_PHUCTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID ";
                        }
                    }
                }
                else if (BAQD_Congbo.LOAIANID == 8 && (BAQD_Congbo.CAPXETXU == 2 || BAQD_Congbo.CAPXETXU == 3))
                {
                    if (BAQD_Congbo.ISBA == 1)
                    {
                        SELECT = " SELECT BAQDCB.*, " +
                                    "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYTUYENAN NGAYBAQD, BAQDKT.NGAYHIEULUC HIEULUCTU, XLDON.QUANHEPHAPLUATID QHPLTKID,  " +
                                    "        NVL(BAQDKT.APDUNGANLE,0) APDUNGANLE, BAQDKT.SOANLE SOANLE" +
                                    " FROM BAQD_CONGBO BAQDCB ";


                        if (BAQD_Congbo.CAPXETXU == 2)
                        {
                            LEFTJOIN = " INNER JOIN XLHC_SOTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN XLHC_DON XLDON ON XLDON.ID = BAQDCB.VUVIECID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {
                            LEFTJOIN = " INNER JOIN XLHC_PHUCTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN XLHC_DON XLDON ON XLDON.ID = BAQDCB.VUVIECID ";
                        }
                    }

                    if (BAQD_Congbo.ISBA == 0)
                    {
                        SELECT = " SELECT BAQDCB.*, " +
                                 "        BAQDKT.SOQD SOBAQD, BAQDKT.NGAYQD NGAYBAQD, BAQDKT.HIEULUCTU,  XLDON.QUANHEPHAPLUATID QHPLTKID,  " +
                                 "        TKQD.APDUNGANLE APDUNGANLE, TKQD.SOANLE SOANLE" +
                                 " FROM BAQD_CONGBO BAQDCB ";

                        if (BAQD_Congbo.CAPXETXU == 2)
                        {
                            LEFTJOIN = " INNER JOIN XLHC_SOTHAM_QUYETDINH BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1 AND DMQD.ISSOTHAM = 1 " +
                                       " LEFT JOIN TK_SOTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID " +
                                       " INNER JOIN XLHC_DON XLDON ON XLDON.ID = BAQDCB.VUVIECID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {
                            LEFTJOIN = " INNER JOIN XLHC_PHUCTHAM_QUYETDINH BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1  AND DMQD.ISPHUCTHAM = 1 " +
                                       " LEFT JOIN TK_PHUCTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID " +
                                       " INNER JOIN XLHC_DON XLDON ON XLDON.ID = BAQDCB.VUVIECID ";
                        }
                    }
                }
                else if (BAQD_Congbo.LOAIANID != 1 && (BAQD_Congbo.CAPXETXU == 2 || BAQD_Congbo.CAPXETXU == 3))
                {
                    if (BAQD_Congbo.ISBA == 1)
                    {
                        if (BAQD_Congbo.LOAIANID == 6 && BAQD_Congbo.CAPXETXU == 2)
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYTUYENAN NGAYBAQD, BAQDKT.NGAYHIEULUC HIEULUCTU, BAQDKT.QHPLTKID,  " +
                                     "        NVL(BAQDKT.TK_ISANLE,0) APDUNGANLE, BAQDKT.SOANLE SOANLE" +
                                     " FROM BAQD_CONGBO BAQDCB ";
                        }
                        else if (BAQD_Congbo.LOAIANID == 3 && BAQD_Congbo.CAPXETXU == 2)
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYTUYENAN NGAYBAQD, BAQDKT.NGAYHIEULUC HIEULUCTU, BAQDKT.QHPLTKID,  " +
                                     "        NVL(BAQDKT.TK_APDUNGANLE,0) APDUNGANLE, BAQDKT.SOANLE SOANLE" +
                                     " FROM BAQD_CONGBO BAQDCB ";
                        }
                        else if (BAQD_Congbo.LOAIANID == 4 && BAQD_Congbo.CAPXETXU == 2)
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYTUYENAN NGAYBAQD, BAQDKT.NGAYHIEULUC HIEULUCTU, BAQDKT.QHPLTKID,  " +
                                     "        NVL(BAQDKT.TK_APDUNGANLE,0) APDUNGANLE, BAQDKT.SOANLE SOANLE" +
                                     " FROM BAQD_CONGBO BAQDCB ";
                        }
                        else
                        {
                            SELECT = " SELECT BAQDCB.*, " +
                                     "        BAQDKT.SOBANAN SOBAQD, BAQDKT.NGAYTUYENAN NGAYBAQD, BAQDKT.NGAYHIEULUC HIEULUCTU, BAQDKT.QHPLTKID,  " +
                                     "        NVL(BAQDKT.APDUNGANLE,0) APDUNGANLE, BAQDKT.SOANLE SOANLE" +
                                     " FROM BAQD_CONGBO BAQDCB ";
                        }

                        if (BAQD_Congbo.CAPXETXU == 2)
                        {
                            LEFTJOIN = " INNER JOIN " + LOAIAN + "_SOTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {
                            LEFTJOIN = " INNER JOIN " + LOAIAN + "_PHUCTHAM_BANAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID ";
                        }
                    }

                    if (BAQD_Congbo.ISBA == 0)
                    {
                        SELECT = " SELECT BAQDCB.*, " +
                                 "        BAQDKT.SOQD SOBAQD, BAQDKT.NGAYQD NGAYBAQD, BAQDKT.HIEULUCTU, BAQDKT.QHPLTKID,  " +
                                 "        TKQD.APDUNGANLE APDUNGANLE, TKQD.SOANLE SOANLE" +
                                 " FROM BAQD_CONGBO BAQDCB ";

                        if (BAQD_Congbo.CAPXETXU == 2)
                        {
                            LEFTJOIN = " INNER JOIN " + LOAIAN + "_SOTHAM_QUYETDINH BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1 AND DMQD.ISSOTHAM = 1 " +
                                       " LEFT JOIN TK_SOTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID ";
                        }
                        else if (BAQD_Congbo.CAPXETXU == 3)
                        {
                            LEFTJOIN = " INNER JOIN " + LOAIAN + "_PHUCTHAM_QUYETDINH BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                                       " INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = BAQDKT.QUYETDINHID AND DMQD.KET_THUC = 1  AND DMQD.ISPHUCTHAM = 1 " +
                                       " LEFT JOIN TK_PHUCTHAM_QUYETDINH TKQD ON TKQD.QUYETDINHID = BAQDCB.BAQDID AND TKQD.LOAIAN = BAQDCB.LOAIANID ";
                        }
                    }
                }
                else if (BAQD_Congbo.CAPXETXU == 4 || BAQD_Congbo.CAPXETXU == 6)
                {
                    SELECT = " SELECT BAQDCB.*, " +
                             "        BAQDKT.XXGDTTT_SOQD SOBAQD, BAQDKT.XXGDTTT_NGAYQD NGAYBAQD, BAQDKT.XXGDTTT_NGAYQD HIEULUCTU, BAQDKT.QHPL_THONGKEID QHPLTKID,  " +
                             "        TKQD.GIATRI_TK APDUNGANLE, TKQD.NOIDUNG_TK SOANLE" +
                             " FROM BAQD_CONGBO BAQDCB";

                    LEFTJOIN = " INNER JOIN GDTTT_VUAN BAQDKT ON BAQDKT.ID = BAQDCB.BAQDID " +
                               " LEFT JOIN GDTTT_VUAN_THONGKE TKQD ON TKQD.VUANID = BAQDCB.BAQDID AND TKQD.TYPE_TK LIKE 'ADAL' ";
                }


                WHERE = " WHERE BAQDCB.ID = " + BAQD_Congbo.ID + " ";

                if (BAQD_Congbo.CAPXETXU == 4)
                {
                    WHERE += " AND BAQDKT.LOAI_GDTTTT = 1 ";
                }
                else if (BAQD_Congbo.CAPXETXU == 6)
                {
                    WHERE += " AND BAQDKT.LOAI_GDTTTT = 2 ";
                }

                DataTable tbl = Cls_Comon.GetTableToSQL(SELECT + LEFTJOIN + WHERE);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

        public DataTable GET_NGAYHIEULUC_BANAN_HINHSU_SOTHAM(decimal BANANID)
        {
            try
            {
                String SQL = @"
                                SELECT 
                                    CASE 
                                        WHEN EXISTS (
                                            SELECT 1 
                                            FROM AHS_SOTHAM_BANAN_BICAO 
                                            WHERE NGAYHIEULUCBANAN IS NULL AND BANANID = " + BANANID + @"
                                        )
                                        THEN NULL 
                                        ELSE (
                                            SELECT MAX(NGAYHIEULUCBANAN)
                                            FROM AHS_SOTHAM_BANAN_BICAO
                                            WHERE BANANID = " + BANANID + @"
                                        )
                                    END AS NGAYHIEULUCBANAN
                                FROM DUAL";

                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
    }

}
