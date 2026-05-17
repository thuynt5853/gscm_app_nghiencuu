using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.ALD
{
    /* GTEL-HUNGNQ 01-10-2025 Đồng Bộ C06 cho án lao động */
    public class ALD_TOAAN_C06
    {
        public int CheckC06_TOAAN_LAODONG(decimal vLoaiBAQD, decimal vBAQDID, string vCapXX)
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
                                           From C06_TOAAN_LAODONG  
                                           WHERE VUANID = :BAQD_ID AND TRANGTHAIALD = 'HIEU_LUC' AND LOAIBAQD = :LOAI_BAQD
                                             AND CAPXX = :CAPXX";

                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("BAQD_ID", vBAQDID));
                        cmd.Parameters.Add(new OracleParameter("LOAI_BAQD", vLoaiBAQD));
                        cmd.Parameters.Add(new OracleParameter("CAPXX", vCapXX));

                        // ExecuteScalar trả về object, bạn cần convert sang int
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count;
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
                return 0;
            }
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