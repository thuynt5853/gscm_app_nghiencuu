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
    public class DM_QUYETDINH_VUAN_KETTHUC
    {
        #region Load DROPDOWNLIST Quyết định gây kết thúc
        public DataTable DM_QUYETDINH_VUAN_SOTHAM_KETTHUC(string vLOAIAN)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.DM_QUYETDINH_VUAN_SOTHAM_KETTHUC", parameters);
            return tbl;
        }
        public DataTable DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC(string vLOAIAN)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC", parameters);
            return tbl;
        }
  
        public DataTable AHS_DM_QUYETDINH_VUAN_PT()
        {
            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.AHS_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        public DataTable AKT_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.AKT_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
  
        public DataTable ALD_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.ALD_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
 
        public DataTable APS_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.APS_DM_QUYETDINH_VUAN_PT", parameters);
            return tbl;
        }
        #endregion

        #region Load DGLIST Quyết định kết thúc (Page Bản án)
        public DataTable DGLIST_BAQD_QUYETDINH_KETTHUC_ST(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.DGLIST_BAQD_QUYETDINH_KETTHUC_ST", parameters);
            return tbl;
        }

        /* Thêm THULYID và để cơ cấu lại tổ chức dữ liệu phần mềm 
         * Hiện tại mới làm được cho Hình sự*/
        public DataTable DGLIST_BAQD_QUYETDINH_KETTHUC_ST(string vLOAIAN, decimal vDONID, decimal VTHULYID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("VTHULYID",VTHULYID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.DGLIST_BAQD_QUYETDINH_KETTHUC_ST", parameters);
            return tbl;
        }
        public DataTable DGLIST_BAQD_QUYETDINH_KETTHUC_PT(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_DM_QDVUAN_KETTHUC.DGLIST_BAQD_QUYETDINH_KETTHUC_PT", parameters);
            return tbl;
        }
        #endregion


        #region Load Quyết định phúc thẩm kc/kn QĐ TDC và QĐ khác

        public DataTable ADS_DM_QUYETDINH_VUAN_PTQDK()
        {
            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.ADS_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }

        public DataTable AKT_DM_QUYETDINH_VUAN_PTQDK()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AKT_GS.AKT_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
        public DataTable ALD_DM_QUYETDINH_VUAN_PTQDK()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ALD_GS.ALD_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
        public DataTable AHN_DM_QUYETDINH_VUAN_PTQDK()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
        public DataTable AHC_DM_QUYETDINH_VUAN_PTQDK()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHC_GS.AHC_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
        public DataTable APS_DM_QUYETDINH_VUAN_PTQDK()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APS_GS.APS_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
        #endregion Load Quyết định phúc thẩm kc/kn QĐ TDC và QĐ khác
    }
}