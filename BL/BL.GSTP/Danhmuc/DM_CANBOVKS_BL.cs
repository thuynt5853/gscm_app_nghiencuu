using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_CANBOVKS_BL
    {
        public DataTable DM_CANBOVKS_GETBYDONVI(decimal vdonviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBOVKS_GETBYDONVI", parameters);
            return tbl;
        }
        public DataTable DM_CANBOVKS_GETBYDONVI_LOAI(decimal vdonviID, string ma_loai_chucdanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                        new OracleParameter("ma_loai",ma_loai_chucdanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBOVKS_GETBYDONVI_LOAI", parameters);
            return tbl;
        }
        
        public DataTable DM_CANBOVKS_SEARCH(decimal VKSID,  string GroupChucVuName, string KeySearch, int curPageIndex, int pageSize)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("VKSID",VKSID),
                new OracleParameter("GroupChucVuName",GroupChucVuName),
                new OracleParameter("KeySearch",KeySearch),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBOVKS_SEARCH", parameters);
            return tbl;
        }
    }
}