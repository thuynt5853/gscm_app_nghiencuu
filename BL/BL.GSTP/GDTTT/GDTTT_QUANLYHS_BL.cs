using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_QUANLYHS_BL
    {
        
        public DataTable GetAllPaging(Decimal vu_an_id,  decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrVuAnID",vu_an_id),
                                                                        
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QUANLYHS_GetAll", parameters);
            if (tbl != null && tbl.Rows.Count>0)
            {
                String Str = "";
                foreach(DataRow row in tbl.Rows)
                {                   
                    Str = row["TenCanBo"] + "";
                    if (!String.IsNullOrEmpty(row["ChucVu"] + ""))
                        Str += " - " + row["ChucVu"].ToString();
                    if (!String.IsNullOrEmpty(row["ChucDanh"] + ""))
                        Str += " - " + row["ChucDanh"].ToString();

                    row["TenCanBo"] = Str;
                }
            }
            return tbl;
        }

        public DataTable GetByVuAn_LoaiPhieu(Decimal vu_an_id,int CurrLoaiPhieu, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrVuAnID",vu_an_id),
                                                                         new OracleParameter("CurrLoaiPhieu",CurrLoaiPhieu),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QUANLYHS_GETByLoaiPhieu", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String Str = "";
                foreach (DataRow row in tbl.Rows)
                {
                    Str = row["TenCanBo"] + "";
                    if (!String.IsNullOrEmpty(row["ChucVu"] + ""))
                        Str += " - " + row["ChucVu"].ToString();
                    if (!String.IsNullOrEmpty(row["ChucDanh"] + ""))
                        Str += " - " + row["ChucDanh"].ToString();

                    row["TenCanBo"] = Str;
                }
            }
            return tbl;
        }

        public DataTable GetByGroupID(string GroupDK)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vGroupID", GroupDK),
                                                                          new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QUANLYHS_GetByGroupID", parameters);
            return tbl;
        }
    }
}