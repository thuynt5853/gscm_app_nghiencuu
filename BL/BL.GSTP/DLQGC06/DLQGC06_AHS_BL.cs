using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Text;
using System.Configuration;

namespace BL.GSTP.DLQGC06
{
    public class DLQGC06_AHS_BL
    {
        public DataTable GetDulieu_LichSuChuyen(decimal biCanId, decimal vuAnId)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_bicanid",biCanId),
                         new OracleParameter("v_vuanid",vuAnId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_history", parameters);
            return tbl;
        }
        public DataTable c06_ahs_toidanh_hinhphat_getbyid(decimal vBiCanId, decimal toiDanhId, string capxx, string loaiBanAnQd, string ismain)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                         new OracleParameter("v_toidanhId",toiDanhId),
                          new OracleParameter("v_capxx",capxx),
                            new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                              new OracleParameter("v_ismain",ismain),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_toidanh_hinhphat_getbyid", parameters);
            return tbl;
        }
        public DataTable c06_toaan_hinhsu_getbyid(decimal vId)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vId",vId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_toaan_hinhsu_getbyid", parameters);
            return tbl;
        }
        public DataTable c06_ahs_dieuct_getall(decimal vBiCanId, decimal vuanId, string capxx)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("bi_can_id",vBiCanId),
                         new OracleParameter("vu_an_id",vuanId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_dieuct_getall", parameters);
            return tbl;
        }
        public DataTable GetDulieuChon_DaDongBO(string V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("c06_ahs_id",V_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_dadongbo_getbyid", parameters);
            return tbl;
        }
        public bool DeleteC06_TOAAN_HINHSU(decimal id)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"DELETE C06_TOAAN_HINHSU
                                            WHERE ID = :id";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("id", id));
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
        public bool C06_AHS_KhoiPhucBanGhiThuHoi(string id)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"UPDATE C06_TOAAN_HINHSU  set STATUS = 1
                                            WHERE ID = :id";

                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("id", id));
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
        public DataTable C06_AHS_GetDulieuChon_ThuHoiGanNhat(decimal bicanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_BICANID",bicanid),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.getdulieuchon_thuhoigannhat", parameters);
            return tbl;
        }
        public DataTable c06_ahs_dongbo_get_toidanh(decimal vBiCanId, string capxx, string loaiBanAnQd)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                         new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_dongbo_get_toidanh", parameters);
            return tbl;
        }
        public DataTable c06_ahs_hinhphat_getbyid(decimal vBiCanId, string capxx, string loaiBanAnQd, string ismain)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                          new OracleParameter("v_capxx",capxx),
                            new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                              new OracleParameter("v_ismain",ismain),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_hinhphat_getbyid", parameters);
            return tbl;
        }
        //public DataTable c06_ahs_sotham_hinhphat_chinh_getbyid(decimal vBiCanId)

        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                new OracleParameter("vBiCanId",vBiCanId),
        //                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //            };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_AHS_NC.c06_ahs_sotham_hinhphat_chinh_getbyid", parameters);
        //    return tbl;
        //}
        //public DataTable c06_ahs_sotham_hinhphat_boxung_getbyid(decimal vBiCanId)

        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                new OracleParameter("vBiCanId",vBiCanId),
        //                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //            };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_AHS_NC.c06_ahs_sotham_hinhphat_boxung_getbyid", parameters);
        //    return tbl;
        //}
        public DataTable C06_AHS_BICAN_GETBYID(decimal vBiCanId, string capxx, string loaiBanAnQd)

        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                        new OracleParameter("v_capxx",capxx),
                        new OracleParameter("v_loaiba_qd",loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.C06_AHS_BICAN_GETBYID", parameters);
            return tbl;
        }
        public bool C06_AHS_ADD_HISTORY(decimal vAHSID, string vLyDo, string vNoiDung, string vNguoiThuHoi, decimal biCanId, decimal vuAnId, string actionType)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("pkg_ahs_dongbo_c06.c06_ahs_add_history", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["vAHSID"].Value = vAHSID;
            comm.Parameters["vLyDo"].Value = vLyDo;
            comm.Parameters["vNOIDUNG"].Value = vNoiDung;
            comm.Parameters["vNguoiThuHoi"].Value = vNguoiThuHoi;
            comm.Parameters["vBiCanId"].Value = biCanId;
            comm.Parameters["vVuAnId"].Value = vuAnId;
            comm.Parameters["vAction_Type"].Value = actionType;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public bool C06_TOAAN_HINHSU_INSERT(C06_TOAAN_HINHSU_MODEL model)
        {
            string vMaDongBO = GetRandomMaDongBo();
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("pkg_ahs_dongbo_c06.C06_AHS_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["SOBANANORQD"].Value = model.SOBANANORQD;
            comm.Parameters["NGAYRABANAN"].Value = model.NGAYRABANAN;
            comm.Parameters["MADONVIRABANAN"].Value = model.MADONVIRABANAN;
            comm.Parameters["TENDONVIRABANAN"].Value = model.TENDONVIRABANAN;
            comm.Parameters["BQD"].Value = model.BQD;
            comm.Parameters["DSTOIDANH"].Value = model.DSTOIDANH;
            comm.Parameters["MAHINHPHATCHINH"].Value = model.MAHINHPHATCHINH;
            comm.Parameters["TENHINHPHATCHINH"].Value = model.TENHINHPHATCHINH;
            comm.Parameters["THAMSOHINHPHATCHINH"].Value = model.THAMSOHINHPHATCHINH;
            comm.Parameters["DSHINHPHATBOSUNG"].Value = model.DSHINHPHATBOSUNG;
            comm.Parameters["NGAYHIEULUCBA"].Value = model.NGAYHIEULUCBA;
            comm.Parameters["HOTENBICAO"].Value = model.HOTENBICAO;
            comm.Parameters["SOGIAYTOBICAO"].Value = model.SOGIAYTOBICAO;
            comm.Parameters["NGAYSINHBICAO"].Value = model.NGAYSINHBICAO;
            comm.Parameters["MAQUOCTICHBICAO"].Value = model.MAQUOCTICHBICAO;
            comm.Parameters["TENQUOCTICHBICAO"].Value = model.TENQUOCTICHBICAO;
            comm.Parameters["MATHANHPHOTINHBICAO"].Value = model.MATHANHPHOTINHBICAO;
            comm.Parameters["TENTHANHPHOTINHBICAO"].Value = model.TENTHANHPHOTINHBICAO;
            comm.Parameters["MAQUANHUYENBICAO"].Value = model.MAQUANHUYENBICAO;
            comm.Parameters["TENQUANHUYENBICAO"].Value = model.TENQUANHUYENBICAO;
            comm.Parameters["MAPHUONGXABICAO"].Value = model.MAPHUONGXABICAO;
            comm.Parameters["TENPHUONGXABICAO"].Value = model.TENPHUONGXABICAO;
            comm.Parameters["DIACHIBICAO"].Value = model.DIACHIBICAO;
            comm.Parameters["ghichu"].Value = "Thêm mới";
            comm.Parameters["VUANID"].Value = model.VUANID;
            comm.Parameters["BICANID"].Value = model.BICANID;
            comm.Parameters["TAIKHOANGUI"].Value = model.TAIKHOANGUI;
            comm.Parameters["TENVUAN"].Value = model.TENVUAN;
            comm.Parameters["THULY"].Value = model.THULY;
            comm.Parameters["MADONGBOID"].Value = vMaDongBO;
            comm.Parameters["capxx"].Value = model.CAPXX;
            comm.Parameters["toidanh_th"].Value = model.ToiDanhTH;
            comm.Parameters["hinhphat_th"].Value = model.HinhPhatTh;
            comm.Parameters["thamphan"].Value = model.ThamPhan;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public bool C06_TOAAN_HINHSU_INSERT_GUILAI(C06_TOAAN_HINHSU_MODEL model)
        {
            string vMaDongBO = GetRandomMaDongBo();
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("pkg_ahs_dongbo_c06.C06_AHS_INSERT_GUILAI", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["SOBANANORQD"].Value = model.SOBANANORQD;
            comm.Parameters["NGAYRABANAN"].Value = model.NGAYRABANAN;
            comm.Parameters["MADONVIRABANAN"].Value = model.MADONVIRABANAN;
            comm.Parameters["TENDONVIRABANAN"].Value = model.TENDONVIRABANAN;
            comm.Parameters["BQD"].Value = model.BQD;
            comm.Parameters["DSTOIDANH"].Value = model.DSTOIDANH;
            comm.Parameters["MAHINHPHATCHINH"].Value = model.MAHINHPHATCHINH;
            comm.Parameters["TENHINHPHATCHINH"].Value = model.TENHINHPHATCHINH;
            comm.Parameters["THAMSOHINHPHATCHINH"].Value = model.THAMSOHINHPHATCHINH;
            comm.Parameters["DSHINHPHATBOSUNG"].Value = model.DSHINHPHATBOSUNG;
            comm.Parameters["NGAYHIEULUCBA"].Value = model.NGAYHIEULUCBA;
            comm.Parameters["HOTENBICAO"].Value = model.HOTENBICAO;
            comm.Parameters["SOGIAYTOBICAO"].Value = model.SOGIAYTOBICAO;
            comm.Parameters["NGAYSINHBICAO"].Value = model.NGAYSINHBICAO;
            comm.Parameters["MAQUOCTICHBICAO"].Value = model.MAQUOCTICHBICAO;
            comm.Parameters["TENQUOCTICHBICAO"].Value = model.TENQUOCTICHBICAO;
            comm.Parameters["MATHANHPHOTINHBICAO"].Value = model.MATHANHPHOTINHBICAO;
            comm.Parameters["TENTHANHPHOTINHBICAO"].Value = model.TENTHANHPHOTINHBICAO;
            comm.Parameters["MAQUANHUYENBICAO"].Value = model.MAQUANHUYENBICAO;
            comm.Parameters["TENQUANHUYENBICAO"].Value = model.TENQUANHUYENBICAO;
            comm.Parameters["MAPHUONGXABICAO"].Value = model.MAPHUONGXABICAO;
            comm.Parameters["TENPHUONGXABICAO"].Value = model.TENPHUONGXABICAO;
            comm.Parameters["DIACHIBICAO"].Value = model.DIACHIBICAO;
            comm.Parameters["ghichu"].Value = "Thêm mới do gửi lại";
            comm.Parameters["VUANID"].Value = model.VUANID;
            comm.Parameters["BICANID"].Value = model.BICANID;
            comm.Parameters["TAIKHOANGUI"].Value = model.TAIKHOANGUI;
            comm.Parameters["TENVUAN"].Value = model.TENVUAN;
            comm.Parameters["THULY"].Value = model.THULY;
            comm.Parameters["MADONGBOID"].Value = vMaDongBO;
            comm.Parameters["capxx"].Value = model.CAPXX;
            comm.Parameters["nguoiguilai"].Value = model.TAIKHOANGUI;
            comm.Parameters["toidanh_th"].Value = model.ToiDanhTH;
            comm.Parameters["hinhphat_th"].Value = model.HinhPhatTh;
            comm.Parameters["thamphan"].Value = model.ThamPhan;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable C06_AHS_SOTHAM_SEARCH_CHUADONGBO(
             string V_LOAIAN_ID, string v_LOAIBAQD
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.C06_AHS_SEARCH_CHUADONGBO", parameters);
            return tbl;
        }
        public DataTable C06_AHS_SOTHAM_SEARCH_THUHOI(
             string V_LOAIAN_ID
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            , decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.C06_AHS_SEARCH_THUHOI", parameters);
            return tbl;
        }
        public DataTable C06_AHS_SOTHAM_SEARCH_DADONGBO(
             string V_LOAIAN_ID
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            , decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.C06_AHS_SEARCH_DADONGBO", parameters);
            return tbl;
        }

        public DataTable C06_AHS_SOTHAM_HINHPHAT_TH_GETBYID(decimal vBiCanId)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_AHS_NC.C06_AHS_SOTHAM_HINHPHAT_TH_GETBYID", parameters);
            return tbl;
        }
        public DataTable C06_AHS_HINHPHAT_TONGHOP_GETBYID(decimal vBiCanId)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("pkg_ahs_dongbo_c06.c06_ahs_hinhphat_tonghop_getbyid", parameters);
            return tbl;
        }
        public DataTable C06_AHS_SOTHAM_HINHPHAT_BOXUNG_GETBYID(decimal vBiCanId)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId",vBiCanId),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_AHS_NC.C06_AHS_SOTHAM_HINHPHAT_BOXUNG_GETBYID", parameters);
            return tbl;
        }
        public DataTable GetAllPaging_Search_All(
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.EXT_SEARCH_ALL", parameters);
            return tbl;
        }


        public DataTable GetDulieu_LichSuChuyen(string V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DongBoID",V_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.GET_BAQD_LichSuChuyen", parameters);
            return tbl;
        }

        public bool InsertC06_TOAAN_TINHTRANGHONNHAN(C06_TOAAN_TINHTRANGHONNHAN ls)
        {
            OracleCommand cmd = null;
            try
            {

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO C06_TOAAN_TINHTRANGHONNHAN  
                                            (LOAIAN_ID,LOAI_BAQD,MAVUVIEC,TENVUAN,DONID,BAQD_ID,SO_BAN_AN,NGAY_RA_BAN_AN,
                                             NGAY_HIEU_LUC_BA,DON_VI_RA_BAN_AN_ID,DON_VI_RA_BAN_AN_TEN,NGAY_NHAN_NGUYEN_DON,
                                            NGAY_NHAN_BI_DON,HO_TEN_NGUYEN_DON,SO_GIAY_TO_NGUYEN_DON,NGAY_SINH_NGUYEN_DON,
                                            QUOC_TICH_NGUYEN_DON,HO_TEN_BI_DON,SO_GIAY_TO_BI_DON,NGAY_SINH_BI_DON,
                                            QUOC_TICH_BI_DON,TRANG_THAI_TTHN,trangThaiBanGhi,ghiChu,TRANG_THAI_DONGBO,NGAYGUI,
                                            TAIKHOANGUI,CAPXX,KHANGCAOQH,STATUS,NGUYENDON_ID,BIDON_ID,THULY,
                                            trangThaiXacThucNguyenDon,trangThaiXacThucBiDon,maDinhDanhBanAn,GIOI_TINH_NGUYEN_DON,
                                            SO_CMND_NGUYEN_DON,GIOI_TINH_BI_DON,SO_CMND_BI_DON,MADONVINHANBANAN,TENDONVINHANBANAN,
                                            SOGIAYCNKH,loaiViec
                                            )
                           VALUES (:LOAIAN_ID,:LOAI_BAQD,:MAVUVIEC,:TENVUAN,:DONID,:BAQD_ID,:SO_BAN_AN,:NGAY_RA_BAN_AN,
                                             :NGAY_HIEU_LUC_BA,:DON_VI_RA_BAN_AN_ID,:DON_VI_RA_BAN_AN_TEN,:NGAY_NHAN_NGUYEN_DON,
                                            :NGAY_NHAN_BI_DON,:HO_TEN_NGUYEN_DON,:SO_GIAY_TO_NGUYEN_DON,:NGAY_SINH_NGUYEN_DON,
                                            :QUOC_TICH_NGUYEN_DON,:HO_TEN_BI_DON,:SO_GIAY_TO_BI_DON,:NGAY_SINH_BI_DON,
                                            :QUOC_TICH_BI_DON,:TRANG_THAI_TTHN,:trangThaiBanGhi,:ghiChu,:TRANG_THAI_DONGBO,:NGAYGUI,
                                            :TAIKHOANGUI,:CAPXX,:KHANGCAOQH,:STATUS,:NGUYENDON_ID,:BIDON_ID,:THULY,
                                            :trangThaiXacThucNguyenDon,:trangThaiXacThucBiDon,:maDinhDanhBanAn,:GIOI_TINH_NGUYEN_DON,
                                            :SO_CMND_NGUYEN_DON,:GIOI_TINH_BI_DON,:SO_CMND_BI_DON,:MADONVINHANBANAN,:TENDONVINHANBANAN,
                                            :SOGIAYCNKH,:loaiViec
                                            )";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {

                        cmd.Parameters.Add(new OracleParameter("LOAIAN_ID", ls.LOAIAN_ID));
                        cmd.Parameters.Add(new OracleParameter("LOAI_BAQD", ls.LOAI_BAQD));
                        cmd.Parameters.Add(new OracleParameter("MAVUVIEC", ls.MAVUVIEC));
                        cmd.Parameters.Add(new OracleParameter("TENVUAN", ls.TenVuAn));
                        cmd.Parameters.Add(new OracleParameter("DONID", ls.DONID));
                        cmd.Parameters.Add(new OracleParameter("BAQD_ID", ls.BAQD_ID));
                        cmd.Parameters.Add(new OracleParameter("SO_BAN_AN", ls.SO_BAN_AN));
                        cmd.Parameters.Add(new OracleParameter("NGAY_RA_BAN_AN", ls.NGAY_RA_BAN_AN));
                        cmd.Parameters.Add(new OracleParameter("NGAY_HIEU_LUC_BA", ls.NGAY_HIEU_LUC_BA));
                        cmd.Parameters.Add(new OracleParameter("DON_VI_RA_BAN_AN_ID", ls.DON_VI_RA_BAN_AN_ID));
                        cmd.Parameters.Add(new OracleParameter("DON_VI_RA_BAN_AN_TEN", ls.DON_VI_RA_BAN_AN_TEN));
                        cmd.Parameters.Add(new OracleParameter("NGAY_NHAN_NGUYEN_DON", ls.NGAY_NHAN_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("NGAY_NHAN_BI_DON", ls.NGAY_NHAN_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("HO_TEN_NGUYEN_DON", ls.HO_TEN_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("SO_GIAY_TO_NGUYEN_DON", ls.SO_GIAY_TO_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("NGAY_SINH_NGUYEN_DON", ls.NGAY_SINH_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("QUOC_TICH_NGUYEN_DON", ls.QUOC_TICH_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("HO_TEN_BI_DON", ls.HO_TEN_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("SO_GIAY_TO_BI_DON", ls.SO_GIAY_TO_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("NGAY_SINH_BI_DON", ls.NGAY_SINH_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("QUOC_TICH_BI_DON", ls.QUOC_TICH_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("TRANG_THAI_TTHN", ls.TRANG_THAI_TTHN));
                        cmd.Parameters.Add(new OracleParameter("trangThaiBanGhi", ls.trangThaiBanGhi));
                        cmd.Parameters.Add(new OracleParameter("ghiChu", ls.ghiChu));
                        cmd.Parameters.Add(new OracleParameter("TRANG_THAI_DONGBO", ls.TRANG_THAI_DONGBO));
                        cmd.Parameters.Add(new OracleParameter("NGAYGUI", ls.NGAYGUI));
                        cmd.Parameters.Add(new OracleParameter("TAIKHOANGUI", ls.TAIKHOANGUI));
                        cmd.Parameters.Add(new OracleParameter("CAPXX", ls.CAPXX));
                        cmd.Parameters.Add(new OracleParameter("KHANGCAOQH", ls.KHANGCAOQH));
                        cmd.Parameters.Add(new OracleParameter("STATUS", ls.STATUS));
                        cmd.Parameters.Add(new OracleParameter("NGUYENDON_ID", ls.NGUYENDON_ID));
                        cmd.Parameters.Add(new OracleParameter("BIDON_ID", ls.BIDON_ID));
                        cmd.Parameters.Add(new OracleParameter("THULY", ls.THULY));
                        cmd.Parameters.Add(new OracleParameter("trangThaiXacThucNguyenDon", ls.trangThaiXacThucNguyenDon));
                        cmd.Parameters.Add(new OracleParameter("trangThaiXacThucBiDon", ls.trangThaiXacThucBiDon));
                        cmd.Parameters.Add(new OracleParameter("maDinhDanhBanAn", ls.maDinhDanhBanAn));

                        cmd.Parameters.Add(new OracleParameter("GIOI_TINH_NGUYEN_DON", ls.GIOI_TINH_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("SO_CMND_NGUYEN_DON", ls.SO_CMND_NGUYEN_DON));
                        cmd.Parameters.Add(new OracleParameter("GIOI_TINH_BI_DON", ls.GIOI_TINH_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("SO_CMND_BI_DON", ls.SO_CMND_BI_DON));
                        cmd.Parameters.Add(new OracleParameter("MADONVINHANBANAN", ls.maDonViNhanBanAn));
                        cmd.Parameters.Add(new OracleParameter("TENDONVINHANBANAN", ls.tenDonViNhanBanAn));
                        cmd.Parameters.Add(new OracleParameter("SOGIAYCNKH", ls.soGiayCNKH));
                        cmd.Parameters.Add(new OracleParameter("loaiViec", ls.loaiViec));

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

        public bool HistoryDeleteC06_TOAAN_TINHTRANGHONNHAN(string vDongBoID, string vLydo, string vOBJECT, string vTaikhoan)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO C06_TOAAN_TINHTRANGHONNHAN_HISTORY  
                                            (DONGBOID,LYDO_THUHOI,NOIDUNG,NGUOITHUHOI,NGAYTHUHOI)
                           VALUES (:DONGBOID,:LYDO_THUHOI,:NOIDUNG,:NGUOITHUHOI,:NGAYTHUHOI)";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DONGBOID", vDongBoID));
                        cmd.Parameters.Add(new OracleParameter("LYDO_THUHOI", vLydo));
                        cmd.Parameters.Add(new OracleParameter("NOIDUNG", vOBJECT));
                        cmd.Parameters.Add(new OracleParameter("NGUOITHUHOI", vTaikhoan));
                        cmd.Parameters.Add(new OracleParameter("NGAYTHUHOI", DateTime.Now));

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

        public bool HistoryC06_CALL_API037(string vDONID, string vCCCD_CALL, string vHOTEN_CALL, string vTAIKHOAN_CALL, string vKETQUA_API)
        {
            OracleCommand cmd = null;
            try
            {

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO C06_CALL_API037_HISTORY  
                                            (DONID,CCCD_CALL,HOTEN_CALL,TAIKHOAN_CALL,TIME_CALL,KETQUA_API)
                           VALUES (:DONID,:CCCD_CALL,:HOTEN_CALL,:TAIKHOAN_CALL,:TIME_CALL,:KETQUA_API)";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {

                        cmd.Parameters.Add(new OracleParameter("DONID", vDONID));
                        cmd.Parameters.Add(new OracleParameter("CCCD_CALL", vCCCD_CALL));
                        cmd.Parameters.Add(new OracleParameter("HOTEN_CALL", vHOTEN_CALL));
                        cmd.Parameters.Add(new OracleParameter("TAIKHOAN_CALL", vTAIKHOAN_CALL));
                        cmd.Parameters.Add(new OracleParameter("TIME_CALL", DateTime.Now));
                        cmd.Parameters.Add(new OracleParameter("KETQUA_API", vKETQUA_API));

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

        //thu hoi 
        public bool ThuHoi_C06_TOAAN_HINHSU(string vDongBoID, string ghiChu, decimal biCanId, decimal vuAnId, string nguoiThuHoi)
        {

            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("pkg_ahs_dongbo_c06.c06_ahs_thuhoi", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["vID"].Value = Convert.ToDecimal(vDongBoID);
            comm.Parameters["vBICanId"].Value = biCanId;
            comm.Parameters["vVuAnId"].Value = vuAnId;
            comm.Parameters["vGhiChu"].Value = ghiChu;
            comm.Parameters["vNguoiThuHoi"].Value = nguoiThuHoi;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }

        }
        public bool ThuHoi_C06_TOAAN_HINHSU_GUILAI(string vDongBoID, string ghiChu)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"UPDATE C06_TOAAN_HINHSU  set STATUS = 0, TRANGTHAIAHS = 'THU_HOI' 
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
        public string GetRandomMaDongBo()
        {
            using (OracleConnection conn = Cls_Comon.OpenConnection())
            {
                using (OracleCommand cmd = new OracleCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "BEGIN :ret := PKG_DVCQG_DLDCQG.CREATE_MA_DONGBO_RANDOM; END;";
                    cmd.CommandType = CommandType.Text;

                    var returnValue = new OracleParameter("ret", OracleDbType.Varchar2, 255)
                    {
                        Direction = ParameterDirection.ReturnValue
                    };

                    cmd.Parameters.Add(returnValue);

                    cmd.ExecuteNonQuery();

                    return returnValue.Value?.ToString() ?? "NULL";
                }
            }
        }
    }
}