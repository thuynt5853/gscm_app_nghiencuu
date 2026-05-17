using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Globalization;
using System.Threading;
using System.Resources;
using System.Configuration;
using System.Reflection;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Manager
{
    public class Database
    {
        public static OracleConnection Connection()
        {            
            OracleConnection conn = new OracleConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ThongKeConnection"].ConnectionString);           
            conn.Open();
            return conn;
        }       
        public static String GetUserName(String Value_Users)
        {
            return Value_Users.Split(';')[0];
        }
        public static String GetUserType(String Value_Users)
        {
            return Value_Users.Split(';')[1];
        }
        public static String GetUserCourt(String Value_Users)
        {
            return Value_Users.Split(';')[2];
        }
        public static String GetUserCourtName(String Value_Users)
        {
            return Value_Users.Split(';')[3];
        }
        public static String GetUserCourtUserType(String Value_Users)
        {
            return Value_Users.Split(';')[4];
        } 
        public static String GetUserPass(String Value_Users)
        {
            return Value_Users.Split(';')[5];
        }         
        public static void FillIndex(DropDownList dropIndex, int max, int selected)
        {
            dropIndex.Items.Clear();
            for (int i = 1; i <= max; i++)
            {
                ListItem item = new ListItem(i.ToString(), i.ToString());
                if (i == selected) item.Selected = true;
                else item.Selected = false;
                dropIndex.Items.Add(item);
            }
        }
        public static List<T> Bind_List_Reader<T>(OracleCommand command) where T : class
        {
            List<T> collection = new List<T>();
            OracleDataReader reader = command.ExecuteReader();
            try
            {
                while (reader.Read())
                {
                    T item = Get_Item_From_Reader<T>(reader);
                    collection.Add(item);
                }
                return collection;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Close();
            }
        }       
        public static List<T> Bind_List_Reader_Add_New<T>(OracleCommand command) where T : class
        {
            List<T> collection = new List<T>();
            OracleDataReader reader = command.ExecuteReader();
            try
            {
                while (reader.Read())
                {
                    T item = Get_Item_From_Reader_Add_New<T>(reader);
                    collection.Add(item);
                }
                return collection;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Close();
            }
        }
        public static void Bind_Drop_Item(OracleCommand command, DropDownList Name_Drop, string Name_Field_Text, string Name_Field_Value)
        {
            OracleDataReader reader = command.ExecuteReader();
            try
            {
                while (reader.Read())
                {
                    ListItem Li = new ListItem(reader[Name_Field_Text].ToString(), reader[Name_Field_Value].ToString());
                    Name_Drop.Items.Add(Li);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Close();
            }
        }
        public static T Bind_Object_Reader<T>(OracleCommand command) where T : class
        {
            OracleDataReader reader = command.ExecuteReader();
            try
            {
                if (reader.Read())
                    return Get_Item_From_Reader<T>(reader);
                else
                    return default(T);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Close();
            }
        }
        private static T Get_Item_From_Reader<T>(OracleDataReader rdr) where T : class
        {
            Type type = typeof(T);
            T item = Activator.CreateInstance<T>();
            PropertyInfo[] properties = type.GetProperties();
            foreach (PropertyInfo property in properties)
            {                
                if (rdr[property.Name].ToString().Trim() != string.Empty)
                {
                    property.SetValue(item, rdr[property.Name], null);
                }
            }
            return item;
        }
        private static T Get_Item_From_Reader_Add_New<T>(OracleDataReader rdr) where T : class
        {
            Type type = typeof(T);
            T item = Activator.CreateInstance<T>();
            PropertyInfo[] properties = type.GetProperties();
            foreach (PropertyInfo property in properties)
            {
                if (rdr[property.Name].ToString().Trim() != string.Empty)
                {
                    property.SetValue(item, rdr[property.Name], null);
                }
               
            }
            return item;
        }     
        public static List<T> Bind_List_Reader_pages<T>(OracleCommand command, ref Int32 Total_pages) where T : class
        {
            List<T> collection = new List<T>();
            OracleDataReader reader = command.ExecuteReader();            
            try
            {
                while (reader.Read())
                {
                    T item = Get_Item_From_Reader<T>(reader);
                    collection.Add(item);
                }
                return collection;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                command.Connection.Close();
                Total_pages = Convert.ToInt32(command.Parameters["v_TotalRecord"].Value);
            }
        }       
        public static string ConverCodeUni(string sInput)
        {
            string FindText = "áàảãạâấầẩẫậăắằẳẵặđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠÂẤẦẨẪẬĂẮẰẲẴẶĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴqwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
            string ReplText = "aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYqwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
            char[] tmp = sInput.ToCharArray();
            int index = -1;
            string[] toreturn = new string[tmp.Length];
            int Length = sInput.Length;
            for (int i = 0; i <= Length - 1; i++)
            {
                if (i >= tmp.Length) break;
                index = FindText.IndexOf(tmp[i]);
                if (index >= 0)
                {
                    toreturn[i] = ReplText.Substring(index, 1);
                }
                else
                {
                    toreturn[i] = "-";
                }
            }

            return String.Join("", toreturn).Replace("--", "-");
        }
        public static DateTime GetFirstDayOfMonth(int iMonth)
        {
            DateTime dtResult = new DateTime(DateTime.Now.Year, iMonth - 1, 1);
            dtResult = dtResult.AddDays((-dtResult.Day) + 1);
            return dtResult;
        }
        public static DateTime GetLastDayOfMonth(DateTime dtInput)
        {
            DateTime dtResult = dtInput;
            dtResult = dtResult.AddMonths(1);
            dtResult = dtResult.AddDays(-(dtResult.Day));
            return dtResult;
        }
    }
}
