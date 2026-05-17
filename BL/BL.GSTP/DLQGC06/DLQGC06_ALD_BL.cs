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
    /* GTEL-HUNGNQ 01-10-2025 Đồng bộ C06 cho án Lao Động */
    public class DLQGC06_ALD_BL
    {
        public DataTable GetALDPaging_Search_All_ThuHoi(
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_SEARCH_THUHOI", parameters);
            return tbl;
        }

        public DataTable GetALDPaging_Search_All_DaDongBO(
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_SEARCH_DADONGBO", parameters);
            return tbl;
        }


        public DataTable GeALDPaging_Search_ChuaDongBo(
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_SEARCH_CHUADONGBO", parameters);
            return tbl;
        }

        public bool C06_TOAAN_LAODONG_INSERT(C06_TOAAN_LAODONG item)
        {
            OracleCommand cmd = null;
            try
            {

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO C06_TOAAN_LAODONG(   
                                            SOBANANORQD, NGAYRABANAN, MADONVIRABANAN, TENDONVIRABANAN, BQD, ANPHI, NGAYHIEULUCBA, 
                                            HOTENDUONGSU, SOGIAYTODUONGSU, NGAYSINHDUONGSU, 
                                            MAQUOCTICHDUONGSU, TENQUOCTICHDUONGSU, MATHANHPHOTINHDUONGSU, TENTHANHPHOTINHDUONGSU,   
                                            MAQUANHUYENDUONGSU, TENQUANHUYENDUONGSU, MAPHUONGXADUONGSU, TENPHUONGXADUONGSU, DIACHIDUONGSU,
                                            TRANGTHAIALD, TRANGTHAIJOBSHARE, VUANID, DUONGSUID, NGAYGUI, TAIKHOANGUI,
                                            NGAYDONGBO, TENVUAN, THULY, STATUS, GHICHU, MAQUANHEPHAPLUAT, TENQUANHEPHAPLUAT, MATUCACHTOTUNG, TENTUCACHTOTUNG, LOAIBAQD, CAPXX)
                           VALUES (
                                            :SOBANANORQD, :NGAYRABANAN, :MADONVIRABANAN, :TENDONVIRABANAN, :BQD, :ANPHI, :NGAYHIEULUCBA, 
                                            :HOTENDUONGSU, :SOGIAYTODUONGSU, :NGAYSINHDUONGSU, 
                                                :MAQUOCTICHDUONGSU, :TENQUOCTICHDUONGSU, :MATHANHPHOTINHDUONGSU, :TENTHANHPHOTINHDUONGSU,   
                                                :MAQUANHUYENDUONGSU, :TENQUANHUYENDUONGSU, :MAPHUONGXADUONGSU, :TENPHUONGXADUONGSU, :DIACHIDUONGSU,
                                                :TRANGTHAIALD, :TRANGTHAIJOBSHARE, :VUANID, :DUONGSUID, :NGAYGUI, :TAIKHOANGUI,
                                                :NGAYDONGBO, :TENVUAN, :THULY, :STATUS, :GHICHU, :MAQUANHEPHAPLUAT, :TENQUANHEPHAPLUAT, :MATUCACHTOTUNG, :TENTUCACHTOTUNG, :LOAIBAQD, :CAPXX
                                )";
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("SOBANANORQD", item.SOBANANORQD));
                        cmd.Parameters.Add(new OracleParameter("NGAYRABANAN", item.NGAYRABANAN));
                        cmd.Parameters.Add(new OracleParameter("MADONVIRABANAN", item.MADONVIRABANAN));
                        cmd.Parameters.Add(new OracleParameter("TENDONVIRABANAN", item.TENDONVIRABANAN));
                        cmd.Parameters.Add(new OracleParameter("BQD", item.BQD));
                        cmd.Parameters.Add(new OracleParameter("ANPHI", item.ANPHI));
                        cmd.Parameters.Add(new OracleParameter("NGAYHIEULUCBA", item.NGAYHIEULUCBA));
                        cmd.Parameters.Add(new OracleParameter("HOTENDUONGSU", item.HOTENDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("SOGIAYTODUONGSU", item.SOGIAYTODUONGSU));
                        cmd.Parameters.Add(new OracleParameter("NGAYSINHDUONGSU", item.NGAYSINHDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("MAQUOCTICHDUONGSU", item.MAQUOCTICHDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("TENQUOCTICHDUONGSU", item.TENQUOCTICHDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("MATHANHPHOTINHDUONGSU", item.MATHANHPHOTINHDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("TENTHANHPHOTINHDUONGSU", item.TENTHANHPHOTINHDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("MAQUANHUYENDUONGSU", item.MAQUANHUYENDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("TENQUANHUYENDUONGSU", item.TENQUANHUYENDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("MAPHUONGXADUONGSU", item.MAPHUONGXADUONGSU));
                        cmd.Parameters.Add(new OracleParameter("TENPHUONGXADUONGSU", item.TENPHUONGXADUONGSU));
                        cmd.Parameters.Add(new OracleParameter("DIACHIDUONGSU", item.DIACHIDUONGSU));
                        cmd.Parameters.Add(new OracleParameter("TRANGTHAIALD", item.TRANGTHAIALD));
                        cmd.Parameters.Add(new OracleParameter("TRANGTHAIJOBSHARE", item.TRANGTHAIJOBSHARE));
                        cmd.Parameters.Add(new OracleParameter("VUANID", item.VUANID));
                        cmd.Parameters.Add(new OracleParameter("DUONGSUID", item.DUONGSUID));
                        cmd.Parameters.Add(new OracleParameter("NGAYGUI", item.NGAYGUI));
                        cmd.Parameters.Add(new OracleParameter("TAIKHOANGUI", item.TAIKHOANGUI));
                        cmd.Parameters.Add(new OracleParameter("NGAYDONGBO", item.NGAYDONGBO));
                        cmd.Parameters.Add(new OracleParameter("TENVUAN", item.TENVUAN));
                        cmd.Parameters.Add(new OracleParameter("THULY", item.THULY));
                        cmd.Parameters.Add(new OracleParameter("STATUS", item.STATUS));
                        cmd.Parameters.Add(new OracleParameter("GHICHU", item.GHICHU));
                        cmd.Parameters.Add(new OracleParameter("MAQUANHEPHAPLUAT", item.MAQUANHEPHAPLUAT));
                        cmd.Parameters.Add(new OracleParameter("TENQUANHEPHAPLUAT", item.TENQUANHEPHAPLUAT));
                        cmd.Parameters.Add(new OracleParameter("MATUCACHTOTUNG", item.MATUCACHTOTUNG));
                        cmd.Parameters.Add(new OracleParameter("TENTUCACHTOTUNG", item.TENTUCACHTOTUNG));
                        cmd.Parameters.Add(new OracleParameter("LOAIBAQD", item.LOAIBAQD));
                        cmd.Parameters.Add(new OracleParameter("CAPXX", item.CAPXX));
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

        public DataTable C06_ALD_SEARCH_BY_ID(string vId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_ID",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_SEARCH_BY_ID", parameters);
            return tbl;
        }

        public DataTable C06_ALD_DUONGSU_GETBYID(decimal vduongsuId, string capxx, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_DUONGSU_GETBYID", parameters);
            return tbl;
        }

        public DataTable GETDULIEUCHON_THUHOIGANNHAT(decimal vduongsuId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.getdulieuchon_thuhoigannhat", parameters);
            return tbl;
        }

        public bool ThuHoi_C06_TOAAN_LAODONG(string vDongBoID, string ghiChu, string status)
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
                        sql = @"UPDATE C06_TOAAN_LAODONG  set STATUS = :STATUS, TRANGTHAIALD = 'THU_HOI', GHICHU = :GHICHU
                                            WHERE ID = :DongBoID";
                    }
                    else
                    {
                        sql = @"UPDATE C06_TOAAN_LAODONG  set STATUS = :STATUS, TRANGTHAIALD = 'THU_HOI'
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

                    string sql = @"UPDATE C06_TOAAN_LAODONG  set STATUS = 1
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

        public bool XoaC06_TOAAN_LAODONG(string vDongBoID)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"Delete from C06_TOAAN_LAODONG WHERE ID = :DongBoID";
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

        public bool C06_ALD_ADD_HISTORY(decimal id, string vLyDo, string vNoiDung, string vNguoiThuHoi, decimal vuanid, decimal duongsuid, string actionType)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vLyDo",vLyDo),
                        new OracleParameter("vnoidung",vNoiDung),
                        new OracleParameter("vnguoithuhoi",vNguoiThuHoi),
                        new OracleParameter("vid",id),
                        new OracleParameter("vuanid",vuanid),
                        new OracleParameter("duongsuid",duongsuid),
                        new OracleParameter("actionType",actionType)
                    };
                Cls_Comon.ExcuteProc("DLQGC06_ALD.c06_toaan_laodong_history_insert", parameters);
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_HISTORY_BY_ID", parameters);
            return tbl;
        }

        public DataTable C06_ALD_DUONGSU_CDB_GETBY(decimal vduongsuId, string capxx, string sobananorqd, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_duongsuId",vduongsuId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_sobananorqd",sobananorqd),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.C06_ALD_DUONGSU_CDB_GETBY", parameters);
            return tbl;
        }

        public DataTable C06_ALD_DUONGSU_GUILAI(string vId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_ID",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.c06_ald_duongsu_guilai", parameters);
            return tbl;
        }
    }
}