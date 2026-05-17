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
    public class DLQGC06_BL
    {
        public DataTable GetAllPaging_Search_All_ThuHoi(
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.EXT_SEARCH_ALL_ThuHoi", parameters);
            return tbl;
        }

        public DataTable GetAllPaging_Search_All_DaDongBO(
             string V_LOAIAN_ID, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an,  string v_toidanh
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.EXT_SEARCH_ALL_DaDongBo", parameters);
            return tbl;
        }

        public DataTable GetAllPaging_Search_All(
            string V_LOAIAN_ID, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            ,string v_toaan_id, string v_Capxx,string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can,string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            ,   string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN
            
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
      
        public DataTable GetDulieuChon_DaDongBO(string V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DonBoID",V_ID),                        
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.GET_BAQD_DaDongBo_BY_ID", parameters);
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

        
        public DataTable GetDulieuChon_ThuHoiGanNhat(string vLoaiAn, string vLoaiBAQD, string vIdBAQD)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_LoaiAn",vLoaiAn),
                        new OracleParameter("v_LoaiBAQD",vLoaiBAQD),
                        new OracleParameter("v_IdBAQD",vIdBAQD),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.GetDulieuChon_ThuHoiGanNhat", parameters);
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


        public bool DeleteC06_TOAAN_TINHTRANGHONNHAN(string vDongBoID)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"DELETE C06_TOAAN_TINHTRANGHONNHAN  
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

        public bool HistoryDeleteC06_TOAAN_TINHTRANGHONNHAN(string vDongBoID, string vLydo, string vOBJECT,string vTaikhoan)
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
        public bool ThuHoi_C06_TOAAN_TINHTRANGHONNHAN(string vDongBoID)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"UPDATE C06_TOAAN_TINHTRANGHONNHAN  set STATUS = 0
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

                    string sql = @"UPDATE C06_TOAAN_TINHTRANGHONNHAN  set STATUS = 1
                                            WHERE ID = :DongBoID";
                    
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