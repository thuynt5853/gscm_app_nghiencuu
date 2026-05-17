using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Runtime.Caching;

namespace BL.GSTP
{
    public class CANH_BAO_STPT
    {
        public DataTable Hoso_PT_List_vks(String V_SONGAY_QUAHAN, String V_TINH_DENNGAY, String V_LOAIAN, String V_TUNGAY, String V_DENNGAY, String V_TENDUONGSU, String V_CAPXX, String V_DONVIID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_SONGAY_QUAHAN",V_SONGAY_QUAHAN),
                    new OracleParameter("V_TINH_DENNGAY",V_TINH_DENNGAY),
                    new OracleParameter("V_LOAIAN",V_LOAIAN),
                    new OracleParameter("V_TUNGAY",V_TUNGAY),
                    new OracleParameter("V_DENNGAY",V_DENNGAY),
                    new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                    new OracleParameter("V_CAPXX",V_CAPXX),
                    new OracleParameter("V_DONVIID",V_DONVIID),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize", PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST_VKS", parameters);
            return tbl;
        }
        public DataTable Hoso_PT_List_vks_export(String V_SONGAY_QUAHAN, String V_TINH_DENNGAY, String V_LOAIAN, String V_TUNGAY, String V_DENNGAY, String V_TENDUONGSU, String V_CAPXX, String V_DONVIID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_SONGAY_QUAHAN",V_SONGAY_QUAHAN),
                    new OracleParameter("V_TINH_DENNGAY",V_TINH_DENNGAY),
                    new OracleParameter("V_LOAIAN",V_LOAIAN),
                    new OracleParameter("V_TUNGAY",V_TUNGAY),
                    new OracleParameter("V_DENNGAY",V_DENNGAY),
                    new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                    new OracleParameter("V_CAPXX",V_CAPXX),
                    new OracleParameter("V_DONVIID",V_DONVIID),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize", PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST_VKS_EXPORT", parameters);
            return tbl;
        }
        public DataTable GET_CANHBAO_TRAIGIAM(String V_LOAITOA, String V_DONVIID, int PageIndex, int PageSize)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"GETBY_TAMGIAM_10NGAY_{V_LOAITOA}_{V_DONVIID}_{PageIndex}_{PageSize}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_LOAITOA",V_LOAITOA),
                    new OracleParameter("V_DONVIID",V_DONVIID),
                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize", PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                 tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.GETBY_TAMGIAM_10NGAY", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable GET_CANHBAO_HOSO_VKS(String V_DONVIID,String V_CAPXX)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"GETBY_COUNT_VKSS_{V_DONVIID}_{V_CAPXX}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("V_DONVIID",V_DONVIID),
                                    new OracleParameter("V_CAPXX",V_CAPXX),
                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.GETBY_COUNT_VKSS", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable GET_CANHBAO_VUAN_TAMDINHCHI(String V_CAPXX, String V_TOAAN_ID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"CANHBAO_TDC_THOIHAN_{V_TOAAN_ID}_{V_CAPXX}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_CAPXX",V_CAPXX),
                                                                        new OracleParameter("V_DONVIID",V_TOAAN_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APP.CANHBAO_TDC_THOIHAN", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable GET_STPT_LOGIN_CA_SOTHAM(String V_CAPXX, String V_TOAAN_ID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"SOTHAM_CA_{V_TOAAN_ID}_{V_CAPXX}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_CAPXX",V_CAPXX),
                                                                        new OracleParameter("V_DONVIID",V_TOAAN_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                 tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP_CACC_GET.SOTHAM_CA", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable GET_STPT_LOGIN_CA_PHUCTHAM(String V_CAPXX, String V_TOAAN_ID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"PHUCTHAM_CA_{V_TOAAN_ID}_{V_CAPXX}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_CAPXX",V_CAPXX),
                                                                        new OracleParameter("V_DONVIID",V_TOAAN_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_APP_CACC_GET.PHUCTHAM_CA", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable GET_DONKK_TOAKHAC_CHUYENDEN(String v_toa_an_id)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"SOLUONGDONKK_TOAKHAC_{v_toa_an_id}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_toa_an_id",v_toa_an_id),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.SOLUONGDONKK_TOAKHAC", parameters);
                // Lưu cache trong 10 phút
                double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_a"]);
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
    }
}