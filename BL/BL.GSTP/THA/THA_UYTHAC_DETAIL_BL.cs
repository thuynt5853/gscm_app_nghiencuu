using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;

namespace BL.GSTP.THA
{
    public class THA_UYTHAC_DETAIL_BL
    {
        public DataTable GetAllByBiAnID(decimal BiAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrBiAnID", BiAn),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_UYTHAC_DETAIL_GETALL", parameters);
            return tbl;
        }
        //public DataTable GetAllNhanUyThacByToaAn(Decimal CurrToaAnID, int trangthai)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                               new OracleParameter("CurrToaAnID", CurrToaAnID),
        //                                                               new OracleParameter("CurrTrangThai", trangthai),                                                                       
        //                                                               new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                         };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_NhanUyThac_GetAll", parameters);
        //    return tbl;
        //}
        public DataTable GetAllNhanUyThacByToaAn(Decimal CurrToaAnID, decimal trangthai, string TenBiAn, string TenVuAn, string NgayUyThac, Decimal ToaAnUyThacID,
            string SoQD, string NgayQD, string NgayQDFrom, string NgayQDTo,int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("CurrToaAnID", CurrToaAnID),
                                                                       new OracleParameter("CurrTrangThai", trangthai),
                                                                       new OracleParameter("v_TenBiAn",TenBiAn),
                                                                       new OracleParameter("v_TenVuAn",TenVuAn),
                                                                       new OracleParameter("v_NgayUyThac",NgayUyThac),
                                                                       new OracleParameter("v_ToaAnUyThacID",ToaAnUyThacID),
                                                                       new OracleParameter("v_SoQD",SoQD),
                                                                       new OracleParameter("v_NgayQD",NgayQD),
                                                                       new OracleParameter("v_NgayQDFrom",NgayQDFrom),
                                                                       new OracleParameter("v_NgayQDTo",NgayQDTo),
                                                                       new OracleParameter("Page_Index",PageIndex),
                                                                       new OracleParameter("Page_Size",PageSize),
                                                                       new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )

                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_NHANUYTHAC_GETALL", parameters);
            return tbl;
        }
        public DataTable GetInfo(Decimal CurrID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("CurrDetailUyThacID", CurrID),
                                                                       new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_UyThacDetail_GetInfo", parameters);
            return tbl;
        }

    }
}