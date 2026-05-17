using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using DAL.GSTP;
using System.Xml.Serialization;
using System.IO;
using BL.GSTP.AHN;


namespace BL.GSTP
{
    public class AHN_DON_DUONGSU_BL
    {
        public void AHN_DON_YEUTONUOCNGOAI_UPDATE(decimal vDONID)
        {
            try
            {

                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID)                                                                       
                                                                      };
                Cls_Comon.ExcuteProc("AHN_DON_YEUTONUOCNGOAI_UPDATE", parameters);
                return;
            }
            catch(Exception ex) { }
        }

        public DataTable AHN_DON_DUONGSU_GETLIST(decimal vDONID)
        {
       
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_GETLIST", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_THAMGIATOTUNG(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_THAMGIATOTUNG", parameters);
            return tbl;
        }

        public DataTable AHN_THULY_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HNGD.GET_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }

        public DataTable AHN_DUONGSU_KHANGCAO(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HNGD.GET_DUONGSU_KHANGCAO", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_ANPHI(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.AHN_DON_DUONGSU_ANPHI", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHN_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHN_DON_DUONGSU_NOTDAIDIEN(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_NOTDAIDIEN", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_NOTDAIDIEN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_NOTDAIDIEN_CHITIET", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }
        public DataTable AHN_DON_DUONGSU_Getall(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_Getall", parameters);
            return tbl;
        }

        public DataTable AHN_DON_DUONGSU_Getall_BiDon(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_Getall_BiDon", parameters);
            return tbl;
        }
        public DataTable AHN_SOTHAM_DUONGSU_GETBY(decimal vDONID,decimal vIsSoTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsSoTham",vIsSoTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_SOTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsPhucTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsPhucTham",vIsPhucTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public string AHN_DUONGSU_GETNAMEBYKHANGCAO(decimal vKhangCaoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vKhangCaoID",vKhangCaoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string TenNguoiKC = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DUONGSU_GETNAMEBYKHANGCAO", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TenNguoiKC = tbl.Rows[0]["TENDUONGSU"].ToString();
            }
            return TenNguoiKC;
        }
        public DataTable AHN_DON_DUONGSU_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_DON_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }
        public void HistoryDuongSu_AnHonNhan(decimal vDSID, string vHIS_NGUOISUA, string vHIS_TAIKHOANSUA, string vDuongsu)
        {
            OracleCommand cmd = null;
            try
            {

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"INSERT INTO AHN_DON_DUONGSU_HISTORY  
                                            (DUONGSUID,HIS_NGUOISUA,HIS_TAIKHOANSUA,HIS_NGAYSUA,DUONGSU)
                                        VALUES (:DUONGSUID,:HIS_NGUOISUA,:HIS_TAIKHOANSUA,:HIS_NGAYSUA,:DUONGSU)";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DUONGSUID", vDSID));
                        cmd.Parameters.Add(new OracleParameter("HIS_NGUOISUA", vHIS_NGUOISUA));
                        cmd.Parameters.Add(new OracleParameter("HIS_TAIKHOANSUA", vHIS_TAIKHOANSUA));
                        cmd.Parameters.Add(new OracleParameter("HIS_NGAYSUA", DateTime.Now));
                        cmd.Parameters.Add(new OracleParameter("DUONGSU", vDuongsu));

                        int rows = cmd.ExecuteNonQuery();
                        conn.Close();
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
            }
        }

        public void ViewHistoryDuongSu_AnHonNhan(decimal vDSID)
        {
            OracleCommand cmd = null;
            try
            {

                String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
                using (OracleConnection conn = new OracleConnection())
                {
                    conn.ConnectionString = connection_string;
                    conn.Open();

                    string sql = @"SELECT * 
                                           FROM AHN_DON_DUONGSU_HISTORY 
                                           WHERE DUONGSUID = :DUONGSUID";
                    //string json = JsonConvert.SerializeObject(CONTENT_JSON);
                    using (cmd = new OracleCommand(sql, conn))
                    {
                        cmd.Parameters.Add(new OracleParameter("DUONGSUID", vDSID));
                        int rows = cmd.ExecuteNonQuery();
                        conn.Close();
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
            }
        }

        public List<AHN_DON_DUONGSU_HIS> GetHistoryDuongSu(decimal duongSuId)
        {
            var result = new List<AHN_DON_DUONGSU_HIS>();
            string connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;

            using (OracleConnection conn = new OracleConnection(connection_string))
            {
                conn.Open();

                string sql = @"SELECT DUONGSU, HIS_NGUOISUA, HIS_TAIKHOANSUA, HIS_NGAYSUA
                       FROM AHN_DON_DUONGSU_HISTORY
                       WHERE DUONGSUID = :DUONGSUID
                        ORDER BY HIS_NGAYSUA DESC";

                using (OracleCommand cmd = new OracleCommand(sql, conn))
                {
                    cmd.BindByName = true;
                    cmd.Parameters.Add("DUONGSUID", OracleDbType.Varchar2).Value = duongSuId.ToString();

                    using (OracleDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var raw = new AHN_DON_DUONGSU_HIS
                            {
                                DUONGSU_XML = reader.IsDBNull(reader.GetOrdinal("DUONGSU"))
                                              ? null
                                              : reader.GetString(reader.GetOrdinal("DUONGSU")),
                                HIS_NGUOISUA = reader.IsDBNull(reader.GetOrdinal("HIS_NGUOISUA"))
                                              ? null
                                              : reader.GetString(reader.GetOrdinal("HIS_NGUOISUA")),
                                HIS_TAIKHOANSUA = reader.IsDBNull(reader.GetOrdinal("HIS_TAIKHOANSUA"))
                                              ? null
                                              : reader.GetString(reader.GetOrdinal("HIS_TAIKHOANSUA")),
                                HIS_NGAYSUA = reader.IsDBNull(reader.GetOrdinal("HIS_NGAYSUA"))
                                              ? (DateTime?)null
                                              : reader.GetDateTime(reader.GetOrdinal("HIS_NGAYSUA"))
                            };

                            result.Add(raw);
                        }
                    }
                }
            }

            return result;
        }
    }


}