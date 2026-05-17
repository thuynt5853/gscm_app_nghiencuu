using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.DKK;
using DAL.GSTP;
namespace BL.DonKK
{
    public class DONKK_DON_DUONGSU_BL
    {
        Decimal QLAn_DuongSuID = 0;
        GSTPContext gsdt = new GSTPContext();
        DKKContextContainer dt = new DKKContextContainer();
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;

        //--------------------------------
        
        //public DataTable GetDuongSuByDK(decimal DonKKID, String MaLoaiVuViec, string matucachtotung)
        //{

        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                                new OracleParameter("vDonKKID", DonKKID)
        //                                                                , new OracleParameter("vMaLoaiVuViec", MaLoaiVuViec)
        //                                                                , new OracleParameter("vMaTuCachToTung", matucachtotung)
        //                                                                , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_DS_GetByDK", parameters);
        //    return tbl;
        //}
        public DataTable GetDuongSuByUser(Decimal UserID, decimal DonKKID, String MaLoaiVuViec, string matucachtotung)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                         new OracleParameter("vCurrUserID", UserID)
                                                                       , new OracleParameter("vDonKKID", DonKKID)                                                                        
                                                                       , new OracleParameter("vMaTuCachToTung", matucachtotung)
                                                                       , new OracleParameter("vMaLoaiVuViec", MaLoaiVuViec)
                                                                       , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_DS_GetDSByCurrUser", parameters);
            return tbl;
        }
        public DataTable GetByDonKKID(decimal DonKKID, String MaLoaiVuViec)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonKKID", DonKKID)
                                                                        , new OracleParameter("vMaLoaiVuViec", MaLoaiVuViec)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_DON_DUONGSU_GETBY", parameters);
            return tbl;
        }

        /// <summary>
        /// lay ds cac duong su khac (ko bao gom : nguyendon, bidon, uyquyen)
        /// </summary>
        /// <param name="DonKKID"></param>
        /// <param name="MaLoaiVuViec"></param>
        /// <returns></returns>
        public DataTable GetDuongSuKhac(Decimal UserID, decimal DonKKID, String MaLoaiVuViec)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                         new OracleParameter("vCurrUserID", UserID)
                                                                       , new OracleParameter("vDonKKID", DonKKID)
                                                                       , new OracleParameter("vMaLoaiVuViec", MaLoaiVuViec)
                                                                       , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_DS_GetDSKhac", parameters);
            return tbl;
        }

        public void Update_YeuToNuocNgoai(decimal DonKKID, Decimal QuocTichVN)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonKKID",DonKKID)
                                                                        ,  new OracleParameter("vVietNamID",QuocTichVN)
                                                                      };
                Cls_Comon.ExcuteProc(CurrConnectionString, "DONKK_YEUTONUOCNGOAI_UPDATE", parameters);
                return;
            }
            catch (Exception ex) { }
        }

        public DataTable GetAllDuongSuByDonKK(decimal DonKKID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("DonKK_ID", DonKKID)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_DS_GetAllByDonKK_ID", parameters);
            return tbl;
        }
        
      
    }
}