using BL.GSTP.BANGSETGET;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC06
{
    /* GTEL-HUNGNQ 01-10-2025 Đồng bộ C06 cho án dân sự */
    public class DLQGC06_ADS_BL
    {
        public DataTable GetADSPaging_Search_All_ThuHoi(
             string V_LOAIAN_ID, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            , decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                        new OracleParameter("v_BAQD_id",v_BAQD_id),
                        new OracleParameter("v_KHANGCAOQH",v_KHANGCAOQH),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_cccd",v_cccd),
                        new OracleParameter("v_so_qd",v_so_qd),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("V_TRANGTHAI_GUI",V_TRANGTHAI_GUI),
                        new OracleParameter("V_NGAYGUI_TU",V_NGAYGUI_TU),
                        new OracleParameter("V_NGAYGUI_DEN",V_NGAYGUI_DEN),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_SEARCH_THUHOI", parameters);
            return tbl;
        }

        public DataTable GetADSPaging_Search_All_DaDongBO(
             string V_LOAIAN_ID, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            , decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                        new OracleParameter("v_BAQD_id",v_BAQD_id),
                        new OracleParameter("v_KHANGCAOQH",v_KHANGCAOQH),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_cccd",v_cccd),
                        new OracleParameter("v_so_qd",v_so_qd),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("V_TRANGTHAI_GUI",V_TRANGTHAI_GUI),
                        new OracleParameter("V_NGAYGUI_TU",V_NGAYGUI_TU),
                        new OracleParameter("V_NGAYGUI_DEN",V_NGAYGUI_DEN),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_SEARCH_DADONGBO", parameters);
            return tbl;
        }


        public DataTable GeADSPaging_Search_ChuaDongBo(
            string V_LOAIAN_ID, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            , decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                new OracleParameter("v_BAQD_id",v_BAQD_id),
                new OracleParameter("v_KHANGCAOQH",v_KHANGCAOQH),
                new OracleParameter("v_toaan_id", v_toaan_id),
                new OracleParameter("v_Capxx",v_Capxx),
                new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                new OracleParameter("v_toidanh",v_toidanh),
                new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                new OracleParameter("v_bi_can",v_bi_can),
                new OracleParameter("v_cccd",v_cccd),
                new OracleParameter("v_so_qd",v_so_qd),
                new OracleParameter("V_TUNGAY",V_TUNGAY),
                new OracleParameter("V_DENNGAY",V_DENNGAY),
                new OracleParameter("v_thamphan_id",v_thamphan_id),
                new OracleParameter("v_thuky_id",v_thuky_id),
                new OracleParameter("V_TRANGTHAI_GUI",V_TRANGTHAI_GUI),
                new OracleParameter("V_NGAYGUI_TU",V_NGAYGUI_TU),
                new OracleParameter("V_NGAYGUI_DEN",V_NGAYGUI_DEN),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_SEARCH_CHUADONGBO", parameters);
            return tbl;
        }

        public bool C06_TOAAN_DANSU_INSERT(C06_TOAAN_DANSU item)
        {
            OracleCommand cmd = null;
            try
            {
                var result = DataExtensions.Insert(item);
                return result > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);

                // Kiểm tra nếu cmd khác null mới in các tham số
                if (cmd != null)
                {
                    foreach (OracleParameter p in cmd.Parameters)
                    {
                        Console.WriteLine($"Param {p.ParameterName} = {p.Value}, Type = {p.OracleDbType}");
                    }
                }
                return false;
            }
        }

        public DataTable C06_ADS_SEARCH_BY_ID(string vId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_ID",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_SEARCH_BY_ID", parameters);
            return tbl;
        }

        public DataTable GETDULIEUCHON_THUHOIGANNHAT(decimal vduongsuId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.getdulieuchon_thuhoigannhat", parameters);
            return tbl;
        }

        public DataTable C06_ADS_DUONGSU_CDB_GETBY(decimal vduongsuId, string capxx, string sobananorqd, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_sobananorqd",sobananorqd),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_DUONGSU_CDB_GETBY", parameters);
            return tbl;
        }

        public DataTable C06_ADS_DUONGSU_GUILAI(string vId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_Id",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_DUONGSU_GUILAI", parameters);
            return tbl;
        }

        public DataTable C06_ADS_DUONGSU_GANNHAT(decimal vduongsuId, string capxx, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_DUONGSU_GANNHAT", parameters);
            return tbl;
        }

        public bool ThuHoi_C06_TOAAN_DANSU(string vDongBoID, string ghiChu, string status)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"";
                    if (!string.IsNullOrEmpty(ghiChu))
                    {
                        sql = @"UPDATE C06_TOAAN_DANSU  set STATUS = :STATUS, TRANGTHAIADS = 'THU_HOI', GHICHU = :GHICHU 
                                            WHERE ID = :DongBoID";
                    }
                    else
                    {
                        sql = @"UPDATE C06_TOAAN_DANSU  set STATUS = :STATUS, TRANGTHAIADS = 'THU_HOI'
                                            WHERE ID = :DongBoID";
                    }

                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("STATUS", status));
                        if (!string.IsNullOrEmpty(ghiChu))
                        {
                            cmd.Parameters.Add(new OracleParameter("GHICHU", ghiChu));
                        }
                        cmd.Parameters.Add(new OracleParameter("DongBoID", vDongBoID));
                        int rows = cmd.ExecuteNonQuery();
                        conn.Close();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);

                // Kiểm tra nếu cmd khác null mới in các tham số
                if (cmd != null)
                {
                    foreach (OracleParameter p in cmd.Parameters)
                    {
                        Console.WriteLine($"Param {p.ParameterName} = {p.Value}, Type = {p.OracleDbType}");
                    }
                }
                return false;
            }
        }

        public bool C06_KhoiPhucBanGhiThuHoi(string vDongBoID)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"UPDATE C06_TOAAN_DANSU  set STATUS = 1
                                            WHERE ID = :DongBoID";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DongBoID", vDongBoID));
                        int rows = cmd.ExecuteNonQuery();
                        conn.Close();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);

                // Kiểm tra nếu cmd khác null mới in các tham số
                if (cmd != null)
                {
                    foreach (OracleParameter p in cmd.Parameters)
                    {
                        Console.WriteLine($"Param {p.ParameterName} = {p.Value}, Type = {p.OracleDbType}");
                    }
                }
                return false;
            }
        }

        public bool XoaC06_TOAAN_DANSU(string vDongBoID)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"Delete from C06_TOAAN_DANSU WHERE ID = :DongBoID";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DongBoID", vDongBoID));
                        int rows = cmd.ExecuteNonQuery();
                        conn.Close();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);

                // Kiểm tra nếu cmd khác null mới in các tham số
                if (cmd != null)
                {
                    foreach (OracleParameter p in cmd.Parameters)
                    {
                        Console.WriteLine($"Param {p.ParameterName} = {p.Value}, Type = {p.OracleDbType}");
                    }
                }
                return false;
            }
        }

        public bool C06_ADS_ADD_HISTORY(decimal vAKTID, string vLyDo, string vNoiDung, string vNguoiThuHoi, decimal vuanid, decimal duongsuid, string actionType)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vLyDo",vLyDo),
                        new OracleParameter("vnoidung",vNoiDung),
                        new OracleParameter("vnguoithuhoi",vNguoiThuHoi),
                        new OracleParameter("vid",vAKTID),
                        new OracleParameter("vuanid",vuanid),
                        new OracleParameter("duongsuid",duongsuid),
                        new OracleParameter("actionType",actionType)
                    };
                Cls_Comon.ExcuteProc("DLQGC06_ADS.c06_toaan_dansu_history_insert", parameters);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);
                return false;
            }
        }

        public DataTable GetDulieu_LichSuChuyen(string vId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_ID",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.C06_ADS_HISTORY_BY_ID", parameters);
            return tbl;
        }
    }
}