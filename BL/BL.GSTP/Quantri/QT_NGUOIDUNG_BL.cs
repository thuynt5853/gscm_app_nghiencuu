using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using System.Runtime.Caching;

namespace BL.GSTP
{
    public class QT_NGUOIDUNG_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable QT_NGUOIDUNG_SEARCH(decimal ChuongtrinhID, string vDonvi,decimal vLoaiUser,string vUserName,string vHoten)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ChuongtrinhID),
                                                                          new OracleParameter("vDonvi",vDonvi),
                                                                           new OracleParameter("vLoaiUser",vLoaiUser),
                                                                            new OracleParameter("vUserName",vUserName),
                                                                             new OracleParameter("vHoten",vHoten),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NGUOIDUNG_SEARCH", parameters);
            return tbl;
        }
        public DataTable CheckLogin(decimal IsDomain, string vUserName, string vUserPass)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("IsDomain",IsDomain),
                                                                          new OracleParameter("user_name",vUserName),
                                                                           new OracleParameter("user_password",vUserPass),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NguoiDung_CheckLogin", parameters);
            return tbl;
        }
        

        public QT_NGUOISUDUNG GetByID(decimal ID)
        {
            return dt.QT_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
        }
        public List<QT_NGUOISUDUNG> GetByUserName(string str)
        {
            return dt.QT_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == str.ToLower()).ToList();
        }
        public bool DeleteByID(decimal ID)
        {
           QT_NGUOISUDUNG oT=  dt.QT_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
            dt.QT_NGUOISUDUNG.Remove(oT);
            dt.SaveChanges();
            return true;
        }
        public bool CheckPermission(string vMenuPath, decimal vUserID)
        {
            vMenuPath = vMenuPath.ToLower();
            if (vMenuPath == "/trangchu.aspx" || vMenuPath == "/permisson.aspx" || vMenuPath== "/changePass.aspx")
                return true;
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vMenuPath",vMenuPath),
                                                                          new OracleParameter("vUserID",vUserID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NGUOIDUNG_MENU_Check", parameters);
                if (tbl.Rows.Count > 0) return true;
                else return false;
            }
            catch(Exception ex)
            {
                return false;
            }
        }
        public DataTable QT_HETHONG_GETBYUSER(decimal vUSERID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"QT_HETHONG_GETBYUSER_{vUSERID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                               new OracleParameter("vUSERID",vUSERID),
                                               new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                tbl = Cls_Comon.GetTableByProcedurePaging("QT_HETHONG_GETBYUSER", parameters);
                // Lưu cache trong 120 phút
               
                //double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_c"]);
                double vTime = 5;
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable QT_CHUONGTRINH_GETBYUSER(decimal vUSERID,decimal vHeThongID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"QT_CHUONGTRINH_GETBYUSER_{vUSERID}_{vHeThongID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            { 
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vUSERID",vUSERID),
                                                                         new OracleParameter("vHeThongID",vHeThongID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                tbl = Cls_Comon.GetTableByProcedurePaging("QT_CHUONGTRINH_GETBYUSER", parameters);
                // Lưu cache trong 120 phút
                //double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_c"]);
                double vTime = 5;
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }

            return tbl;
        }
        public DataTable QT_MENU_GETBYUSER(decimal vUSERID, decimal vChuongtrinhID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vUSERID",vUSERID),
                                                                         new OracleParameter("vChuongtrinhID",vChuongtrinhID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_MENU_GETBYUSER", parameters);
            return tbl;
        }
        public DataTable QT_MENU_GETBYUSER_AN(decimal vUSERID, decimal vChuongtrinhID, decimal vGiaidoan, decimal? giaiDoanHG = 0)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vUSERID",vUSERID),
                                                                         new OracleParameter("vChuongtrinhID",vChuongtrinhID),
                                                                            new OracleParameter("vGiaidoan",vGiaidoan),
                                                                            new OracleParameter("VGIAIDOANHG",giaiDoanHG),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("SP_GS_QT_MENU_GETBYUSER_AN", parameters);
            return tbl;
        }
        public DataTable QT_NGUOIDUNG_GETBYGDTTT(decimal vdonviID, decimal vPhongbanID, decimal vLoaiPhong)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                         new OracleParameter("vPhongbanID",vPhongbanID),
                                                                            new OracleParameter("vLoaiPhong",vLoaiPhong),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NGUOIDUNG_GETBYGDTTT", parameters);
            return tbl;
        }
    }
}