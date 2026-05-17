using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;

namespace BL.GSTP.BANGSETGET
{
    public class DataExtensions
    {
        //public static decimal InsertOld<T>(T entity)
        //{
        //    List<string> param = new List<string>();
        //    var pros = entity.GetType().GetProperties();
        //    var prosID = pros.Where(x => x.Name == "ID").FirstOrDefault();
        //    string columns = String.Join(",", pros.Where(x => x.Name != "ID").Select(x => x.Name).ToList());
        //    foreach (var pro in pros)
        //    {
        //        if (pro.Name == "ID")
        //            continue;
        //        var value = pro.GetValue(entity)?.ToString();
        //        if (String.IsNullOrEmpty(value))
        //            param.Add("null");
        //        else
        //        {
        //            if (pro.PropertyType == typeof(string))
        //                param.Add("'" + pro.GetValue(entity).ToString() + "'");
        //            else if (pro.PropertyType == typeof(DateTime) || pro.PropertyType == typeof(DateTime?))
        //                param.Add(String.Format("TO_DATE('{0}', 'YYYY/MM/DD HH24:MI:SS')", Convert.ToDateTime(pro.GetValue(entity)).ToString("yyyy/MM/dd HH:mm:ss")));
        //            else
        //                param.Add(pro.GetValue(entity).ToString());
        //        }

        //    }
        //    bool isReturnID = false;
        //    if (pros.Count(x => x.Name == "ID") > 0)
        //        isReturnID = true;
        //    string query = "";
        //    if (isReturnID)
        //    {
        //        query = String.Format("INSERT INTO {0}({1}) VALUES ({2}) RETURNING ID INTO :id_return", entity.GetType().Name, columns, String.Join(",", param));

        //        OracleConnection conn = Cls_Comon.OpenConnection();
        //        using (OracleCommand cmd = conn.CreateCommand())
        //        {
        //            cmd.CommandText = query;
        //            OracleParameter outputParameter = new OracleParameter("id_return", OracleDbType.Decimal);
        //            outputParameter.Direction = ParameterDirection.Output;
        //            cmd.Parameters.Add(outputParameter);
        //            cmd.ExecuteNonQuery();
        //            var id = Convert.ToDecimal(outputParameter.Value?.ToString());
        //            PropertyInfo _propertyInfoID = entity.GetType().GetProperty("ID");
        //            _propertyInfoID.SetValue(entity, id);
        //            cmd.Connection.Close();
        //            return id;
        //        }
        //    }
        //    else
        //    {
        //        query = String.Format("INSERT INTO {0}({1}) VALUES ({2})", entity.GetType().Name, columns, String.Join(",", param));
        //        OracleConnection conn = Cls_Comon.OpenConnection();
        //        using (OracleCommand cmd = conn.CreateCommand())
        //        {
        //            cmd.CommandText = query;
        //            var rs = cmd.ExecuteNonQuery();
        //            cmd.Connection.Close();
        //            return rs;
        //        }
        //    }

        //}
        public static decimal Insert<T>(T entity)
        {
            var pros = entity.GetType().GetProperties();
            string columns = String.Join(",", pros.Where(x => x.Name != "ID").Select(x => x.Name).ToList());
            string columnsParams = String.Join(",", pros.Where(x => x.Name != "ID").Select(x => ":" + x.Name).ToList());
            bool isReturnID = false;
            if (pros.Count(x => x.Name == "ID") > 0)
                isReturnID = true;
            string query = "";
            if (isReturnID)
            {
                query = String.Format("INSERT INTO {0}({1}) VALUES ({2}) RETURNING ID INTO :id_return", entity.GetType().Name, columns, columnsParams);
                OracleConnection conn = Cls_Comon.OpenConnection();
                try
                {
                    using (OracleCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        foreach (var pro in pros)
                        {
                            if (pro.Name == "ID")
                                continue;
                            cmd.Parameters.Add(pro.Name, pro.GetValue(entity));
                        }
                        OracleParameter outputParameter = new OracleParameter("id_return", OracleDbType.Decimal);
                        outputParameter.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(outputParameter);
                        cmd.CommandText = query;
                        cmd.ExecuteNonQuery();
                        var id = Convert.ToDecimal(outputParameter.Value?.ToString());
                        PropertyInfo _propertyInfoID = entity.GetType().GetProperty("ID");
                        _propertyInfoID.SetValue(entity, id);
                        cmd.Connection.Close();
                        conn.Close(); conn.Dispose();
                        return id;
                    }
                }
                catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
                {
                    foreach (var validationErrors in dbEx.EntityValidationErrors)
                    {
                        foreach (var validationError in validationErrors.ValidationErrors)
                        {
                            string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                            conn.Close(); conn.Dispose();
                        }
                    }
                    return 0;
                }
                //catch (Exception ex)
                //{
                //    conn.Close(); conn.Dispose();
                //    return 0;
                //}
                
              
            }
            else
            {
                query = String.Format("INSERT INTO {0}({1}) VALUES ({2})", entity.GetType().Name, columns, columnsParams);
                OracleConnection conn = Cls_Comon.OpenConnection();
                try
                {
                    using (OracleCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        foreach (var pro in pros)
                        {
                            if (pro.Name == "ID")
                                continue;
                            cmd.Parameters.Add(pro.Name, pro.GetValue(entity));
                        }
                        cmd.CommandText = query;
                        var rs = cmd.ExecuteNonQuery();
                        cmd.Connection.Close();
                        conn.Close(); conn.Dispose();
                        return rs;
                    }
                }
                catch (Exception ex)
                {
                    conn.Close(); conn.Dispose();
                    return 0;
                }
               
            }

        }
        public static bool Update<T>(T entity)
        {
            List<string> param = new List<string>();
            var pros = entity.GetType().GetProperties();
            var prosID = pros.Where(x => x.Name == "ID").FirstOrDefault();
            if (prosID == null)
                return false;
            decimal id = Convert.ToDecimal(prosID.GetValue(entity));
            string columns = String.Join(",", pros.Where(x => x.Name != "ID").Select(x => x.Name + "=:" + x.Name).ToList());
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    foreach (var pro in pros)
                    {
                        if (pro.Name == "ID")
                            continue;
                        cmd.Parameters.Add(pro.Name, pro.GetValue(entity));
                    }
                    cmd.CommandText = String.Format("UPDATE {0} SET {1} WHERE ID = {2}", entity.GetType().Name, columns, id);
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    return true;
                }
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return false;
            }
            
        }
        public static bool UpdateNotNull<T>(T entity)
        {
            List<string> param = new List<string>();
            var pros = entity.GetType().GetProperties();
            var prosID = pros.Where(x => x.Name == "ID").FirstOrDefault();
            if (prosID == null)
                return false;
            decimal id = Convert.ToDecimal(prosID.GetValue(entity));
            string columns = String.Join(",", pros.Where(x => x.Name != "ID" && x.GetValue(entity) != null).Select(x => x.Name + "=:" + x.Name).ToList());
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    foreach (var pro in pros)
                    {
                        if (pro.Name == "ID")
                            continue;
                        if (pro.GetValue(entity) == null)
                            continue;
                        cmd.Parameters.Add(pro.Name, pro.GetValue(entity));
                    }
                    cmd.CommandText = String.Format("UPDATE {0} SET {1} WHERE ID = {2}", entity.GetType().Name, columns, id);
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    return true;
                }
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return false;
            }
            
        }
        public static bool Delete<T>(T entity)
        {
            List<string> param = new List<string>();
            var pros = entity.GetType().GetProperties();
            var prosID = pros.Where(x => x.Name == "ID").FirstOrDefault();
            if (prosID == null)
                return false;
            decimal id = Convert.ToDecimal(prosID.GetValue(entity));
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = String.Format("DELETE {0} WHERE ID = {1}", entity.GetType().Name, id);
                    var rs = cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    conn.Close(); conn.Dispose();
                    return rs == 1 ? true : false;
                }
            }
            catch (Exception ex)
            {
              
                conn.Close(); conn.Dispose();
                return false;
            }
        }
        public static bool DeleteById<T>(decimal ID)
        {
            List<string> param = new List<string>();
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = String.Format("DELETE {0} WHERE ID = {1}", nameof(T), ID);
                    var rs = cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    conn.Close(); conn.Dispose();
                    return rs == 1 ? true : false;
                }
            }
            catch (Exception ex)
            {
              
                conn.Close(); conn.Dispose();
                return false;
            }
        }
        public static bool DeleteByClause(string Sql)
        {
            List<string> param = new List<string>();
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = Sql;
                    var rs = cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    conn.Close(); conn.Dispose();
                    return rs == 1 ? true : false;
                }
            }
            catch (Exception ex)
            {

                conn.Close(); conn.Dispose();
                return false;
            }
        }
        public static bool DeletePcHgv<T>(T entity)
        {
            List<string> param = new List<string>();
            var pros = entity.GetType().GetProperties();
            var prosID = pros.Where(x => x.Name == "ID").FirstOrDefault();
            if (prosID == null)
                return false;
            decimal id = Convert.ToDecimal(prosID.GetValue(entity));
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                using (OracleCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = String.Format("UPDATE {0} SET HOAGIAIVIENID = null,TOAANHGV=null, NGAYCHIDINH=NULL, LYDOCHIDINH=NULL  WHERE ID = {1}", entity.GetType().Name, id);
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                    return true;
                }
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return false;
            }
                    

        }
        public static List<T> GetAll<T>() where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0}", typeof(T).Name), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }
            
        }
        public static List<T> GetAllByDonId<T>(decimal donId) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE DONID = {1}", typeof(T).Name, donId), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }
            
        }
        public static List<dynamic> GetAllByDonId(string tableName, decimal donId)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(
                    $"SELECT * FROM {tableName} WHERE DONID = {donId}", conn);
                adapter.Fill(tb);

                var list = new List<dynamic>();
                foreach (DataRow row in tb.Rows)
                {
                    IDictionary<string, object> expando = new System.Dynamic.ExpandoObject();
                    foreach (DataColumn col in tb.Columns)
                    {
                        expando[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                    }
                    list.Add(expando);
                }
                return list;
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }
        }
        public static List<dynamic> GetAllByclause(string tableName, string clause)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(
                    $"SELECT * FROM {tableName} WHERE {clause}", conn);
                adapter.Fill(tb);

                var list = new List<dynamic>();
                foreach (DataRow row in tb.Rows)
                {
                    IDictionary<string, object> expando = new System.Dynamic.ExpandoObject();
                    foreach (DataColumn col in tb.Columns)
                    {
                        expando[col.ColumnName] = row[col] == DBNull.Value ? null : row[col];
                    }
                    list.Add(expando);
                }
                return list;
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }
        }
        public static List<T> GetAllByVuAnId<T>(decimal VuAnId) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE VUANID = {1}", typeof(T).Name, VuAnId), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }

        }
        public static List<T> GetAllWithClause<T>(string clause) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE {1}", typeof(T).Name, clause), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }
           
        }
        public static List<T> GetAllWithClause_Order<T>(string clause) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE {1} ORDER BY NGAY_THAY_DOI_MK DESC FETCH FIRST 1 ROWS ONLY", typeof(T).Name, clause), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb);
            }
            catch (Exception ex)
            {
                conn.Close(); conn.Dispose();
                return null;
            }

        }
        public static T FindById<T>(decimal id) where T : new()
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            try
            {
                DataTable tb = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(String.Format("SELECT * FROM {0} WHERE ID = {1}", typeof(T).Name, id), conn);
                adapter.Fill(tb);
                adapter.Dispose();
                conn.Close(); conn.Dispose();
                return CreateListFromTable<T>(tb).FirstOrDefault();
            }
            //catch (Exception ex)
            //{
            //    conn.Close(); conn.Dispose();
            //    return default(T);
            //}
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        var a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                conn.Close(); conn.Dispose();
                return default(T);
            }
        }
        public static List<T> CreateListFromTable<T>(DataTable tbl) where T : new()
        {
            // define return list
            List<T> lst = new List<T>();

            // go through each row
            foreach (DataRow r in tbl.Rows)
            {
                // add to the list
                lst.Add(CreateItemFromRow<T>(r));
            }

            // return the list
            return lst;
        }    
        public static List<T> DataTableToList<T>(DataTable dataTable) where T : new()
        {
            var list = new List<T>();

            foreach (DataRow row in dataTable.Rows)
            {
                T item = new T();
                foreach (var prop in typeof(T).GetProperties())
                {
                    if (dataTable.Columns.Contains(prop.Name) && row[prop.Name] != DBNull.Value)
                    {
                        prop.SetValue(item, Convert.ChangeType(row[prop.Name], prop.PropertyType), null);
                    }
                }
                list.Add(item);
            }

            return list;
        }
        // function that creates an object from the given data row
        public static T CreateItemFromRow<T>(DataRow row) where T : new()
        {
            // create a new object
            T item = new T();

            // set the item
            SetItemFromRow(item, row);

            // return 
            return item;
        }
        public static void SetItemFromRow<T>(T item, DataRow row) where T : new()
        {
            //int i = 0;
            //// go through each column
            //foreach (DataColumn c in row.Table.Columns)
            //{
            //    // find the property for the column
            //    PropertyInfo p = item.GetType().GetProperty(c.ColumnName);

            //    // if exists, set the value
            //    if (p != null && row[c] != DBNull.Value)
            //    {
            //        p.SetValue(item, row[c], null);
            //    }
            //}
            //AnhPN --Sửa lại để tránh phân biệt hoa thường về sau
            foreach (DataColumn c in row.Table.Columns)
            {
                PropertyInfo p = item.GetType().GetProperty(
                    c.ColumnName,
                    BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);

                if (p != null && row[c] != DBNull.Value)
                {
                    var value = Convert.ChangeType(
                        row[c],
                        Nullable.GetUnderlyingType(p.PropertyType) ?? p.PropertyType
                    );

                    p.SetValue(item, value, null);
                }
            }
        }
    }
}