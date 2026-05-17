using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class DM_HANHCHINH_BL
    {
        GSTPContext dt = new GSTPContext();
     
        public string GetTextByID(decimal ID)
        {
            try
            {
                DM_HANHCHINH oT = dt.DM_HANHCHINH.Where(x => x.ID == ID).FirstOrDefault();
                return oT.MA_TEN;
            }
            catch(Exception ex)
            {
                return "";
            }
        }
        public DataTable GetAllByParentID(Decimal ParentID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrCapChaID",ParentID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_HanhChinh_GetAllByParentID", parameters);
            return tbl;
        }
        
    }
}