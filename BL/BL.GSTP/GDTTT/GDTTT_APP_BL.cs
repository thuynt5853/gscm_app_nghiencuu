using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using System.Runtime.Caching;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_APP_BL
    {
        public DataTable Permi_Add_BC(string vMenuPath, decimal vUserID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_CHUNG_{vMenuPath}_{vUserID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] parameters = new OracleParameter[]
                                           {
                                            new OracleParameter("vMenuPath",vMenuPath),
                                            new OracleParameter("vUserID",vUserID),
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                           };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.PERMI_MENU_BAOCAO", parameters);
                // Lưu cache trong 120 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_C"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_CHUNG_S(decimal vToaAnID, decimal vPhongBanID, decimal vLanhdaoVu, decimal vThamTraVien, int LoaiAnDB)
        { 
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_CHUNG_{vToaAnID}_{vPhongBanID}_{vLanhdaoVu}_{vThamTraVien}_{LoaiAnDB}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] prm = new OracleParameter[]
                                    {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                        new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                                        new OracleParameter("vThamTraVien",vThamTraVien),
                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP.THONGKE_CHUNG", prm);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable DieuLuat_ToiDanh_Thongke()
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_BOLUAT_TOIDANH", parameters);
            return tbl;
        }
        public DataTable Get_Select_TP_5(Int32 v_VuAnID, Int32 Loai_hd, Int32 vToaAnID, Int32 vPhongBanID, Int32 vLoaiAn)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("v_VuAnID",v_VuAnID),
                 new OracleParameter("v_Loai_hd",Loai_hd),
                 new OracleParameter("vPhongBanID",vPhongBanID),
                 new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vLoaiAn",vLoaiAn),
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_SELECT_TP5", parameters);
            return tbl;
        }
        public DataTable Get_Select_TP(Int32 v_VuAnID,Int32 Loai_hd, Int32 vToaAnID, Int32 vPhongBanID, Int32 vLoaiAn)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"GET_SELECT_TP_{v_VuAnID}_{Loai_hd}_{vToaAnID}_{vPhongBanID}_{vLoaiAn}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                                        {
                                             new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                             new OracleParameter("v_VuAnID",v_VuAnID),
                                             new OracleParameter("v_Loai_hd",Loai_hd),
                                              new OracleParameter("vPhongBanID",vPhongBanID),
                                             new OracleParameter("vToaAnID",vToaAnID),
                                             new OracleParameter("vLoaiAn",vLoaiAn),
                                        };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_SELECT_TP", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_TONGHOP_S(decimal vToaAnID, decimal vPhongBanID, decimal vLanhdaoVu, decimal vThamTraVien, int LoaiAnDB)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_TONGHOP_{vToaAnID}_{vPhongBanID}_{vLanhdaoVu}_{vThamTraVien}_{LoaiAnDB}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] prm = new OracleParameter[]
                                    {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                        new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                                        new OracleParameter("vThamTraVien",vThamTraVien),
                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
                tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_GDTTT_APP.THONGKE_TONGHOP", prm);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_ANQUOCHOI_THOIHIEU(decimal vToaAnID, decimal vPhongBanID, decimal vLoaiAn, decimal vLanhdaoVu, decimal vThamTraVien, decimal vAnQuocHoi, decimal vAnThoiHieu)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_ANQUOCHOI_THOIHIEU_{vToaAnID}_{vPhongBanID}_{vLoaiAn}_{vLanhdaoVu}_{vThamTraVien}_{vAnQuocHoi}_{vAnThoiHieu}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] prm = new OracleParameter[]
                                    {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                        new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                                        new OracleParameter("vThamTraVien",vThamTraVien),
                                        new OracleParameter("vAnQuocHoi",vAnQuocHoi),
                                        new OracleParameter("vAnThoiHieu",vAnThoiHieu),
                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.THONGKE_ANQUOCHOI_THOIHIEU", prm);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_THEO_THAMPHAN(Decimal vToaAnID, Decimal vThamphanID, DateTime? vTuNgay, DateTime? vDenNgay, int LoaiAnDB,String vYears)
        {
            if (vTuNgay == DateTime.MinValue) vTuNgay = null;
            if (vDenNgay == DateTime.MinValue) vDenNgay = null;
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_THEO_THAMPHAN_{vToaAnID}_{vThamphanID}_{vTuNgay}_{vDenNgay}_{LoaiAnDB}_{vYears}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vThamphanID",vThamphanID),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                                                        new OracleParameter("vYears",vYears),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP.THONGKE_THEO_THAMPHAN", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable THONGKE_THEO_THAMPHAN_GET(String VTHAMPHANID_PCA, Decimal VTOAANID, Decimal VTHAMPHANID, DateTime? VTUNGAY, DateTime? VDENNGAY, int VLOAIANDB, String VYEARS)
        {
            if (VTUNGAY == DateTime.MinValue) VTUNGAY = null;
            if (VDENNGAY == DateTime.MinValue) VDENNGAY = null;

            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_THEO_THAMPHAN_GET_{VTHAMPHANID_PCA}_{VTOAANID}_{VTHAMPHANID}_{VTUNGAY}_{VDENNGAY}_{VLOAIANDB}_{VYEARS}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                                            new OracleParameter("VTHAMPHANID_PCA",VTHAMPHANID_PCA),
                                            new OracleParameter("VTOAANID",VTOAANID),
                                            new OracleParameter("VTHAMPHANID",VTHAMPHANID),
                                            new OracleParameter("VTUNGAY",VTUNGAY),
                                            new OracleParameter("VDENNGAY",VDENNGAY),
                                            new OracleParameter("VLOAIANDB",VLOAIANDB),
                                            new OracleParameter("VYEARS",VYEARS)
                                             };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP_CACC_GET.THONGKE_THEO_THAMPHAN_GET", parameters);

                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        //dang làm giở
        public DataTable THONGKE_TONGHOP_STPT(decimal vToaAnID, decimal vPhongBanID, decimal vLanhdaoVu, decimal vThamTraVien, int LoaiAnDB)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"THONGKE_TONGHOP_{vToaAnID}_{vPhongBanID}_{vLanhdaoVu}_{vThamTraVien}_{LoaiAnDB}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] prm = new OracleParameter[]
                                    {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                        new OracleParameter("vLanhdaoVu",vLanhdaoVu),
                                        new OracleParameter("vThamTraVien",vThamTraVien),
                                        new OracleParameter("LoaiAnDB",LoaiAnDB),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };

                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP.THONGKE_TONGHOP", prm);

                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }       
        public DataTable THONGKE_THEO_HCTP_GET(
                            Decimal VTOAANID,
                            String VstrUsername,
                            String strNhomID,
                            String VTUNGAY,
                            String VDENNGAY)
                                {
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_HCTP_CREATE_DATA_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                                    {
                                new OracleParameter("VTOAANID", VTOAANID),
                                new OracleParameter("VstrUsername", VstrUsername),
                                new OracleParameter("VstrNhomID", strNhomID),
                                new OracleParameter("VTUNGAY", VTUNGAY),
                                new OracleParameter("VDENNGAY", VDENNGAY),
                                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
                                    };

                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP.TK_HCTP_CREATE_DATA", parameters);

                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
                
        public DataTable THONGKE_THEO_HCTP_CC_GET(
                           Decimal VTOAANID,
                           String VstrUsername,
                           String strNhomID,
                           String VTUNGAY,
                           String VDENNGAY)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_HCTP_CREATE_DATA_CC_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                            {
                                                new OracleParameter("VTOAANID", VTOAANID),
                                                new OracleParameter("VstrUsername", VstrUsername),
                                                new OracleParameter("VstrNhomID", strNhomID),
                                                new OracleParameter("VTUNGAY", VTUNGAY),
                                                new OracleParameter("VDENNGAY", VDENNGAY),
                                                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
                            };

                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_CC_HCTP.TK_HCTP_CREATE_DATA", parameters);

                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable THONGKE_THEO_HCTP_EXPORT(Decimal VTOAANID, String VstrUsername, String strNhomID, String VTUNGAY, String VDENNGAY)
        { 
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_HCTP_EXPORT_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] parameters = new OracleParameter[]
                                                {
                                                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                new OracleParameter("VTOAANID",VTOAANID),
                                                new OracleParameter("VstrUsername",VstrUsername),
                                                new OracleParameter("VstrNhomID",strNhomID),
                                                new OracleParameter("VTUNGAY",VTUNGAY),
                                                new OracleParameter("VDENNGAY",VDENNGAY)                    
                                                };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP.TK_HCTP_EXPORT", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_THEO_HCTP_CC_EXPORT(Decimal VTOAANID, String VstrUsername, String strNhomID, String VTUNGAY, String VDENNGAY)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_HCTP_CC_EXPORT_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                    {
                    new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                    new OracleParameter("VTOAANID",VTOAANID),
                    new OracleParameter("VstrUsername",VstrUsername),
                    new OracleParameter("VstrNhomID",strNhomID),
                    new OracleParameter("VTUNGAY",VTUNGAY),
                    new OracleParameter("VDENNGAY",VDENNGAY)
                    };
                 tbl = Cls_Comon.GetTableByProcedurePaging("PKG_CC_HCTP.TK_HCTP_EXPORT", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable THONGKE_NGUOIDUNG_HCTP_GET(Decimal VTOAANID, String VstrUsername, String strNhomID, String VTUNGAY, String VDENNGAY)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_NGUOIDUNG_CREATE_DATA_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                    {
                    new OracleParameter("VTOAANID",VTOAANID),
                    new OracleParameter("VstrUsername",VstrUsername),
                    new OracleParameter("VstrNhomID",strNhomID),
                    new OracleParameter("VTUNGAY",VTUNGAY),
                    new OracleParameter("VDENNGAY",VDENNGAY),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                    };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP.TK_NGUOIDUNG_CREATE_DATA", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable THONGKE_NGUOIDUNG_HCTP_CC_GET(Decimal VTOAANID, String VstrUsername, String strNhomID, String VTUNGAY, String VDENNGAY)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"TK_NGUOIDUNG_CREATE_DATA_CC_{VTOAANID}_{VstrUsername}_{strNhomID}_{VTUNGAY}_{VDENNGAY}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[]
                                        {
                                            new OracleParameter("VTOAANID",VTOAANID),
                                            new OracleParameter("VstrUsername",VstrUsername),
                                            new OracleParameter("VstrNhomID",strNhomID),
                                            new OracleParameter("VTUNGAY",VTUNGAY),
                                            new OracleParameter("VDENNGAY",VDENNGAY),
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                        };
                 tbl = Cls_Comon.GetTableByProcedurePaging("PKG_CC_HCTP.TK_NGUOIDUNG_CREATE_DATA", parameters);
                // Lưu cache trong 60 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_b"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
    }
}