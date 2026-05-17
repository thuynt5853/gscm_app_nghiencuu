using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC12
{
    public class KHOBAQD_BL
    {
        public bool IsExistKHOBADQ(decimal vLoaiBAQD, decimal vDONID, decimal vCapXX,string vLINHVUC)
        {
            OracleCommand cmd = null;
            try
            {
                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"Select Count(*)  
                                           From KHOBAQD  
                                           WHERE DONID = :DONID AND STATUS = 1 AND LOAIBAQD = :LOAI_BAQD AND CAPXX = :CAPXX AND LINHVUC = :LINHVUC AND TRANGTHAIBAQD != 5";

                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DONID", vDONID));
                        cmd.Parameters.Add(new OracleParameter("LOAI_BAQD", vLoaiBAQD));
                        cmd.Parameters.Add(new OracleParameter("CAPXX", vCapXX));
                        cmd.Parameters.Add(new OracleParameter("LINHVUC", vLINHVUC));

                        // ExecuteScalar trả về object, bạn cần convert sang int
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count>0;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi: " + ex.Message);
                Console.WriteLine("StackTrace: " + ex.StackTrace);

                // Kiểm tra nếu cmd khác null mới in các tham số
                if (cmd != null)
                {
                    foreach (OracleParameter p in cmd.Parameters)
                    {
                        Console.WriteLine($"Param {p.ParameterName} = {p.Value}, Type = {p.OracleDbType}");
                    }
                }
                return false;
            }
        }

        public DataTable ADS_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.ADS_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ADS.ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHC.AHC_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHC_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHC.AHC_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }


        public DataTable AKT_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AKT.AKT_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AKT_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AKT.AKT_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }

        public DataTable ALD_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.ALD_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable ALD_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_ALD.ALD_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }
    }
}