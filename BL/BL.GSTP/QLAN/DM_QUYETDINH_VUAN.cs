using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;

namespace BL.GSTP.QLAN
{
    public class DM_QUYETDINH_VUAN
    {
        #region Load Quyết định Sơ thẩm
        public DataTable ADS_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.ADS_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable AHC_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHC_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable AHN_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHN_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable AHS_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHS_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable AKT_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AKT_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable ALD_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.ALD_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        public DataTable APS_DM_QUYETDINH_VUAN()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.APS_DM_QUYETDINH_VUAN", parameters);
            return tbl;
        }
        #endregion

        #region Load Quyết định Phúc thẩm
        public DataTable ADS_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.ADS_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable AHC_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHC_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable AHN_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHN_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable AHS_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AHS_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable AKT_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.AKT_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable ALD_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.ALD_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable APS_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.APS_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        #endregion


        // Load  DGLIST Quyết định kết thúc (Page Bản án)
        public DataTable DGLIST_QUYETDINH_PT(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.DGLIST_QUYETDINH_PT", parameters);
            return tbl;
        }

        // Load  DGLIST Quyết định kết thúc (Page Bản án)
        public DataTable DGLIST_QUYETDINH_BICAN_PT(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN.DGLIST_QUYETDINH_BICAN_PT", parameters);
            return tbl;
        }
    }
}