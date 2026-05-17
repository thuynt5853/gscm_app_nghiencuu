using DAL.GSTP;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

namespace Module.Common
{
    public static class Cls_Comon
    {
        #region Execute Non Query for Store Procedure
        public static int ExecuteProcNonQuery(string procName, List<OracleParameter> lstParam)
        {
            using (var conn = OpenConnection())
            {
                conn.Open();
                using (var transaction = conn.BeginTransaction(IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        using (var cmd = new OracleCommand(procName, conn))
                        {
                            cmd.Transaction = transaction; // gán transaction
                            cmd.CommandType = CommandType.StoredProcedure;
                            // timeout sau 60 giây nếu thủ tục không trả về
                            cmd.CommandTimeout = 60;

                            if (lstParam != null && lstParam.Count > 0)
                            {
                                foreach (var param in lstParam)
                                    cmd.Parameters.Add(param);
                            }

                            int result = cmd.ExecuteNonQuery();
                            transaction.Commit();
                            return result;
                        }
                    }
                    catch
                    {
                        try { transaction.Rollback(); } catch { }
                        return 0;
                    }
                }
            }


            //OracleConnection conn = OpenConnection();
            //OracleTransaction transaction = conn.BeginTransaction(IsolationLevel.ReadCommitted);
            //try
            //{
            //    using (var cmd = new OracleCommand(procName, conn))
            //    {
            //        cmd.Transaction = transaction;
            //        cmd.CommandType = CommandType.StoredProcedure;
            //        if (lstParam.Count > 0)
            //            foreach (var param in lstParam)
            //            {
            //                cmd.Parameters.Add(param);
            //            }
            //        var result = cmd.ExecuteNonQuery();
            //        transaction.Commit();
            //        return result;
            //    }
            //}
            //catch (Exception ex)
            //{
            //    transaction.Rollback();
            //    return 0;
            //}
            //finally
            //{
            //    conn.Close();
            //}
        }
        #endregion

        #region Execute Store Procedure return DataSet
        public static DataSet ExecuteProcDataSet(string procName, List<OracleParameter> lstParam)
        {
            var ds = new DataSet();

            using (var conn = OpenConnection())  // conn sẽ tự Dispose
            {
                try
                {
                    using (var cmd = new OracleCommand(procName, conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        // timeout sau 60 giây nếu thủ tục không trả về
                        cmd.CommandTimeout = 60;

                        if (lstParam != null && lstParam.Count > 0)
                        {
                            foreach (var param in lstParam)
                                cmd.Parameters.Add(param);
                        }

                        using (var dtAdapter = new OracleDataAdapter(cmd))
                        {
                            dtAdapter.Fill(ds);
                        }
                    }

                    return ds;
                }
                catch (Exception ex)
                {
                     //log.Error($"{procName} ERROR: {ex.Message}", ex);
                    return null;
                }
            } // khi ra khỏi using, conn và cmd, adapter đều được giải phóng
            //var ds = new DataSet();
            //OracleConnection conn = OpenConnection();
            //try
            //{
            //    using (var cmd = new OracleCommand(procName, conn))
            //    {
            //        cmd.CommandType = CommandType.StoredProcedure;
            //        if (lstParam.Count > 0)
            //            foreach (var param in lstParam)
            //            {
            //                cmd.Parameters.Add(param);
            //            }
            //        var dtAdapter = new OracleDataAdapter(cmd);
            //        dtAdapter.Fill(ds);
            //        return ds;
            //    }
            //}
            //catch (Exception ex)
            //{
            //    //log.Error(procName + " ERROR: " + ex.Message);
            //    return null;
            //}
            //finally
            //{
            //    conn.Close();
            //}
        }
        #endregion
        public static string GetLocalIPAddress()
        {
            string hostName = Dns.GetHostName(); // Retrive the Name of HOST  
            string myIP = Dns.GetHostByName(hostName).AddressList[0].ToString();
            return myIP;
        }
        //private string GetIP()
        //{
        //    string strHostName = "";
        //    strHostName = System.Net.Dns.GetHostName();

        //    IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(strHostName);

        //    IPAddress[] addr = ipEntry.AddressList;

        //    return addr[addr.Length - 1].ToString();

        //}
        public static MenuPermission GetMenuPer(string vMenuPath, decimal vUserID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vMenuPath",vMenuPath),
                                                                          new OracleParameter("vUserID",vUserID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = GetTableByProcedurePaging("QT_NGUOIDUNG_MENU_Check", parameters);
                if (tbl.Rows.Count > 0)
                {
                    MenuPermission oT = new MenuPermission();
                    DataRow r = tbl.Rows[0];
                    oT.MENUID = Convert.ToDecimal(r["MENUID"]);
                    oT.XEM = (r["XEM"] + "") == "1" ? true : false;
                    oT.TAOMOI = (r["TAOMOI"] + "") == "1" ? true : false;
                    oT.CAPNHAT = (r["CAPNHAT"] + "") == "1" ? true : false;
                    oT.XOA = (r["XOA"] + "") == "1" ? true : false;
                    oT.DULIEU = (r["DULIEU"] + "") == "1" ? true : false;
                    oT.ISXINANGIAM = (r["ISXINANGIAM"] + "") == "1" ? true : false;
                    oT.GDT_ISXINANGIAM = (r["GDT_ISXINANGIAM"] + "") == "1" ? true : false;
                    oT.ISTHANHNIEN = Convert.ToDecimal(r["ISTHANHNIEN"]);
                    return oT;
                }
                else return new MenuPermission(); ;
            }
            catch (Exception ex)
            {
                return new MenuPermission();
            }
        }
        /// <summary>
        /// ThuognNX
        /// Chuyển chuỗi kiểu số sang int, nếu chuỗi rỗng trả về 0
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static int GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return 0;
                else
                    return Convert.ToInt32(obj);
            }
            catch (Exception ex)
            { return 1; }
        }
        public static string toFullNumber(object obj, bool isThang)
        {
            string str = obj + "";
            if (isThang)
            {
                if (str == "1" || str == "2")
                    return "0" + str;
                else
                    return str;
            }
            else
            {
                if (str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "6" || str == "7" || str == "8" || str == "9")
                    return "0" + str;
                else
                    return str;
            }
        }
        /// <summary>
        /// ThuognNX
        /// Chuyển chuỗi kiểu ngày tháng sang Datetime, nếu null  trả về DateTime.Min
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static DateTime GetDateTime(string obj)
        {
            if ((obj + "") == "")
                return DateTime.MinValue;
            else
                return Convert.ToDateTime(obj);
        }

        /// <summary>
        /// ThuongNX
        /// Convert Datetime
        /// </summary>
        /// <param name="strValue">dd/MM/yyyy</param>
        /// <returns></returns>
        public static DateTime toDate(string strValue)
        {
            try
            {
                if (CheckDate())
                {
                    return Convert.ToDateTime(strValue);
                }
                else
                {
                    string[] arr = strValue.Split('/');
                    return Convert.ToDateTime(arr[1] + "/" + arr[0] + "/" + arr[2]);
                }
            }
            catch (Exception ex)
            {
                return DateTime.MinValue;
            }
        }

        public static bool CheckDate()
        {
            DateTime d;
            try
            {
                d = Convert.ToDateTime("22/12/2014");
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public static bool CheckValidDate(string strValue)
        {
            DateTime d;
            try
            {
                d = Convert.ToDateTime(strValue);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public static bool IsValidDate(string strValue)
        {
            DateTime d;
            CultureInfo cul = new CultureInfo("vi-VN");
            try
            {
                d = Convert.ToDateTime(strValue, cul);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public static string CatXau(string str, int length)
        {
            if (str.Length > length)
            {
                if (str.Substring(length, 1) == " ")
                {
                    //Hết 1 từ
                    str = str.Substring(0, length);
                }
                else
                {
                    //Cắt giữa từ
                    str = str.Substring(0, length);
                    str = str.Substring(0, str.LastIndexOf(' '));
                }
                while (str.Substring(str.Length - 1, 1) == " ") str = str.Substring(0, str.Length - 1);
                str += "...";

            }

            return str;

        }

        /// <summary>
        /// ThuongNX
        /// </summary>
        /// <param name="strValue">Chuỗi truyền vào</param>
        /// <returns>0: Nếu giá trị lỗi hoặc không hợp lệ/</returns>
        public static int IntValid(string strValue)
        {
            try
            {
                int Value = Convert.ToInt32(strValue);
                return Value;
            }
            catch (Exception ex)
            {
                return 0;
            }

        }

        public static string MD5Encrypt(string strValue)
        {
            byte[] data, output;
            UTF8Encoding encoder = new UTF8Encoding();
            MD5CryptoServiceProvider hasher = new MD5CryptoServiceProvider();

            data = encoder.GetBytes(strValue);
            output = hasher.ComputeHash(data);

            return BitConverter.ToString(output).Replace("-", "").ToLower();
        }

        /// <summary>
        /// Tính số lượng trang
        /// </summary>
        /// <returns></returns>
        public static Int64 GetTotalPage(Int64 TotalItem, Int16 PageSize)
        {
            Int64 phan_du = TotalItem % PageSize;
            Int64 phan_nguyen = TotalItem / PageSize;
            if (phan_du > 0)
                return (phan_nguyen + 1);
            else
            {
                if (phan_nguyen > 0)
                    return phan_nguyen;
                else
                    return (phan_nguyen + 1);
            }
        }
        public static void SetButton(Button btn, bool flag)
        {
            if (flag)
            {
                btn.Enabled = true;
                btn.CssClass = "buttoninput";
            }
            else
            {
                btn.Enabled = false;
                btn.CssClass = "buttondisable";
            }
        }
        public static void SetLinkButton(LinkButton btn, bool flag)
        {
            if (flag)
            {
                btn.Visible = true;
                // btn.CssClass = "buttoninput";
            }
            else
            {
                btn.Visible = false;
                //btn.CssClass = "buttondisable";
            }
        }
        public static void SetLinkButton(ImageButton btn, bool flag)
        {
            if (flag)
            {
                btn.Visible = true;
                // btn.CssClass = "buttoninput";
            }
            else
            {
                btn.Visible = false;
                //btn.CssClass = "buttondisable";
            }
        }
        /// <summary>
        /// ThuongNX Thiết lập ẩn hiện các button phân trang
        /// </summary>
        /// <param name="hddTotalPage"></param>
        /// <param name="hddPageIndex"></param>
        /// <param name="lbTFirst"></param>
        /// <param name="lbBFirst"></param>
        /// <param name="lbTLast"></param>
        /// <param name="lbBLast"></param>
        /// <param name="lbTNext"></param>
        /// <param name="lbBNext"></param>
        /// <param name="lbTBack"></param>
        /// <param name="lbBBack"></param>
        /// <param name="lbTStep1"></param>
        /// <param name="lbBStep1"></param>
        /// <param name="lbTStep2"></param>
        /// <param name="lbBStep2"></param>
        /// <param name="lbTStep3"></param>
        /// <param name="lbBStep3"></param>
        /// <param name="lbTStep4"></param>
        /// <param name="lbBStep4"></param>
        /// <param name="lbTStep5"></param>
        /// <param name="lbBStep5"></param>
        /// <param name="lbTStep6"></param>
        /// <param name="lbBStep6"></param>
        /// <returns></returns>
        public static bool SetPageButton(HiddenField hddTotalPage, HiddenField hddPageIndex, LinkButton lbTFirst, LinkButton lbBFirst, LinkButton lbTLast, LinkButton lbBLast,
                                      LinkButton lbTNext, LinkButton lbBNext, LinkButton lbTBack, LinkButton lbBBack,
                                      Label lbTStep1, Label lbBStep1, LinkButton lbTStep2, LinkButton lbBStep2,
                                      LinkButton lbTStep3, LinkButton lbBStep3, LinkButton lbTStep4, LinkButton lbBStep4,
                                      LinkButton lbTStep5, LinkButton lbBStep5, Label lbTStep6, Label lbBStep6)
        {
            int total_page = Convert.ToInt32(hddTotalPage.Value);
            int current_page = Convert.ToInt32(hddPageIndex.Value);
            lbTLast.Text = lbBLast.Text = total_page.ToString();
            lbTStep1.Visible = lbBStep1.Visible = lbTStep6.Visible = lbBStep6.Visible = false;
            lbTLast.Visible = lbBLast.Visible = lbTBack.Visible = lbBBack.Visible = lbTNext.Visible = lbBNext.Visible = false;
            lbTStep2.Visible = lbTStep3.Visible = lbTStep4.Visible = lbTStep5.Visible = false;
            lbBStep2.Visible = lbBStep3.Visible = lbBStep4.Visible = lbBStep5.Visible = false;
            lbTFirst.CssClass = lbBFirst.CssClass = lbTLast.CssClass = lbBLast.CssClass = lbTStep2.CssClass = lbBStep2.CssClass = lbTStep3.CssClass = lbBStep3.CssClass = lbTStep4.CssClass = lbBStep4.CssClass = lbTStep5.CssClass = lbBStep5.CssClass = lbTStep6.CssClass = lbBStep6.CssClass = "so";
            if (current_page == 1)
            {
                lbTFirst.CssClass = lbBFirst.CssClass = "active";
                lbTFirst.Visible = lbBFirst.Visible = true;
                lbTNext.Visible = lbBNext.Visible = true;
            }
            else if (current_page == total_page)
            {
                lbTLast.CssClass = lbBLast.CssClass = "active";
                lbTLast.Visible = lbBLast.Visible = true;
                lbTBack.Visible = lbBBack.Visible = true;
            }
            if (total_page == 1)
            {
                lbTFirst.CssClass = lbBFirst.CssClass = "active";
                lbTLast.Visible = lbBLast.Visible = false;
                lbTBack.Visible = lbBBack.Visible = false;
                lbTNext.Visible = lbBNext.Visible = false;
                return true;
            }
            else if (total_page < 7)
            {
                lbTStep2.Text = lbBStep2.Text = "2";
                lbTStep3.Text = lbBStep3.Text = "3";
                lbTStep4.Text = lbBStep4.Text = "4";
                lbTStep5.Text = lbBStep5.Text = "5";
                lbTLast.Visible = lbBLast.Visible = true;
                if (current_page > 1 && current_page < total_page)
                {
                    lbTNext.Visible = lbBNext.Visible = lbTBack.Visible = lbBBack.Visible = true;
                }

                if (total_page == 3)
                {
                    lbTStep2.Visible = lbBStep2.Visible = true;
                    if (current_page == 2) lbTStep2.CssClass = lbBStep2.CssClass = "active";
                }
                else if (total_page == 4)
                {
                    lbTStep2.Visible = lbBStep2.Visible = lbTStep3.Visible = lbBStep3.Visible = true;
                    if (current_page == 2) lbTStep2.CssClass = lbBStep2.CssClass = "active";
                    if (current_page == 3) lbTStep3.CssClass = lbBStep3.CssClass = "active";
                }
                else if (total_page == 5)
                {
                    lbTStep2.Visible = lbBStep2.Visible = lbTStep3.Visible = lbBStep3.Visible = lbTStep4.Visible = lbBStep4.Visible = true;
                    if (current_page == 2) lbTStep2.CssClass = lbBStep2.CssClass = "active";
                    if (current_page == 3) lbTStep3.CssClass = lbBStep3.CssClass = "active";
                    if (current_page == 4) lbTStep4.CssClass = lbBStep4.CssClass = "active";
                }
                else if (total_page == 6)
                {
                    lbTStep2.Visible = lbBStep2.Visible = lbTStep3.Visible = lbBStep3.Visible = lbTStep4.Visible = lbBStep4.Visible = lbTStep5.Visible = lbBStep5.Visible = true;
                    if (current_page == 2) lbTStep2.CssClass = lbBStep2.CssClass = "active";
                    if (current_page == 3) lbTStep3.CssClass = lbBStep3.CssClass = "active";
                    if (current_page == 4) lbTStep4.CssClass = lbBStep4.CssClass = "active";
                    if (current_page == 5) lbTStep5.CssClass = lbBStep5.CssClass = "active";
                }
            }
            else
            {
                lbTLast.Visible = lbBLast.Visible = true;
                lbTStep2.Visible = lbBStep2.Visible = lbTStep3.Visible = lbBStep3.Visible = true;
                lbTStep4.Visible = lbBStep4.Visible = lbTStep5.Visible = lbBStep5.Visible = true;
                if (current_page > 1 && current_page < total_page)
                {
                    lbTNext.Visible = lbBNext.Visible = lbTBack.Visible = lbBBack.Visible = true;
                }
                if (current_page > 4)
                {
                    lbTStep1.Visible = lbBStep1.Visible = true;
                }
                if (current_page < total_page - 3)
                {
                    lbTStep6.Visible = lbBStep6.Visible = true;
                }
                if (current_page <= 4)
                {
                    lbTStep2.Text = lbBStep2.Text = "2";
                    lbTStep3.Text = lbBStep3.Text = "3";
                    lbTStep4.Text = lbBStep4.Text = "4";
                    lbTStep5.Text = lbBStep5.Text = "5";
                    if (current_page == 2)
                        lbTStep2.CssClass = lbBStep2.CssClass = "active";
                    else if (current_page == 3)
                        lbTStep3.CssClass = lbBStep3.CssClass = "active";
                    if (current_page == 4)
                        lbTStep4.CssClass = lbBStep4.CssClass = "active";
                }
                if (current_page >= total_page - 3)
                {
                    lbTStep2.Text = lbBStep2.Text = (total_page - 4).ToString();
                    lbTStep3.Text = lbBStep3.Text = (total_page - 3).ToString();
                    lbTStep4.Text = lbBStep4.Text = (total_page - 2).ToString();
                    lbTStep5.Text = lbBStep5.Text = (total_page - 1).ToString();
                    if (current_page == total_page - 3)
                        lbTStep3.CssClass = lbBStep3.CssClass = "active";
                    else if (current_page == total_page - 2)
                        lbTStep4.CssClass = lbBStep4.CssClass = "active";
                    if (current_page == total_page - 1)
                        lbTStep5.CssClass = lbBStep5.CssClass = "active";
                }
                if (current_page > 4 && current_page < total_page - 3)
                {
                    lbTStep2.Text = lbBStep2.Text = (current_page - 2).ToString();
                    lbTStep3.Text = lbBStep3.Text = (current_page - 1).ToString();
                    lbTStep4.Text = lbBStep4.Text = (current_page).ToString();
                    lbTStep5.Text = lbBStep5.Text = (current_page + 1).ToString();
                    lbTStep4.CssClass = lbBStep4.CssClass = "active";
                }
            }

            return true;
        }
        /// <summary>
        /// Tính số lượng trang
        /// </summary>
        /// <returns></returns>
        public static int GetTotalPage(int intCount, int intPageSize)
        {
            int phan_du = intCount % intPageSize;
            int phan_nguyen = intCount / intPageSize;
            if (phan_du > 0)
                return (phan_nguyen + 1);
            else
            {
                if (phan_nguyen > 0)
                    return phan_nguyen;
                else
                    return (phan_nguyen + 1);
            }
        }

        /// <summary>
        /// Convert danh sách file đính kèm từ dạng chuỗi sang table
        /// </summary>
        /// <param name="DSFile"></param>
        /// <returns></returns>
        public static DataTable ConvertDSFileToTable(string DSFile)
        {
            DataTable retVal = null;

            if (!string.IsNullOrEmpty(DSFile))
            {
                string[] arrFile = DSFile.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                if (arrFile.Length > 0)
                {
                    //Co file
                    retVal = new DataTable();
                    retVal.Columns.Add("FileName", Type.GetType("System.String"));

                    for (int i = 0; i < arrFile.Length; i++)
                    {
                        DataRow dr = retVal.NewRow();
                        dr["FileName"] = arrFile[i];

                        retVal.Rows.Add(dr);
                    }
                }
            }

            return retVal;
        }
        public static string GetRootURL()
        {
            //if (ConfigurationManager.AppSettings["IsHTTPS"] == "true")
            //    return "https://" + HttpContext.Current.Request.Url.Authority.ToString();
            //else
            //    return "http://" + HttpContext.Current.Request.Url.Authority.ToString();

            //Uri path = HttpContext.Current.Request.Url;
            //string strHttps = "http://";
            //if (path.ToString().ToLower().Contains("https:"))
            //    strHttps = "https://";
            //return strHttps + HttpContext.Current.Request.Url.Authority.ToString();

            var request = HttpContext.Current.Request;

            string scheme = request.Headers["X-Forwarded-Proto"];
            if (string.IsNullOrEmpty(scheme))
                scheme = request.Url.Scheme;

            return $"{scheme}://{request.Url.Authority}";
        }
        public static string GetRootURL_HTTPS()
        {
            return "https://" + HttpContext.Current.Request.Url.Authority.ToString();
        }

        public static string GetRootURL_HTTPS_CONFIG()
        {
            if (HttpContext.Current == null || HttpContext.Current.Request == null)
                return ConfigurationManager.AppSettings["RootScheme"] ?? "https://";

            string scheme = ConfigurationManager.AppSettings["RootScheme"] ?? "https://";
            return scheme + HttpContext.Current.Request.Url.Authority;
            //return "https://" + HttpContext.Current.Request.Url.Authority.ToString();
        }

        public static OracleConnection OpenConnection()
        {
            String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;
            OracleConnection conn = new OracleConnection();
            conn.ConnectionString = connection_string;
            conn.Open();
            return conn;
        }
        public static OracleConnection OpenConnection_baocao()
        {
            String connection_string = ConfigurationManager.ConnectionStrings["GSTPConnection_baocao"].ConnectionString;
            OracleConnection conn = new OracleConnection();
            conn.ConnectionString = connection_string;
            conn.Open();
            return conn;
        }
        public static OracleConnection OpenConnection(string connection_string_name)
        {
            String connection_string = ConfigurationManager.ConnectionStrings[connection_string_name].ConnectionString;
            OracleConnection conn = new OracleConnection();
            conn.ConnectionString = connection_string;
            conn.Open();
            return conn;
        }
        public static OracleConnection OpenConnection_baocao(string connection_string_name)
        {
            String connection_string = ConfigurationManager.ConnectionStrings[connection_string_name].ConnectionString;
            OracleConnection conn = new OracleConnection();
            conn.ConnectionString = connection_string;
            conn.Open();
            return conn;
        }

        public static DataTable GetTableToSQL(string SQL)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }
        public static OracleConnection OpenConnection_GDTTT()
        {
            return OracleDbConnection.Instance.getConnection();
        }
        public static DataTable GetTableToSQL_GDTTT(string SQL)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection_GDTTT();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            //conn.Close();
            //conn.Dispose();
            return tbl;
        }
        public static List<decimal> GetDecimalValuesFromSQL(string SQL)
        {
            List<decimal> decimalValues = new List<decimal>();

            // Mở kết nối đến cơ sở dữ liệu
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;

            // Đọc dữ liệu từ câu truy vấn SQL
            OracleDataReader reader = cmd.ExecuteReader();

            // Lặp qua các hàng kết quả
            while (reader.Read())
            {
                // Giả sử câu truy vấn trả về một cột duy nhất có kiểu dữ liệu là số
                if (reader[0] != DBNull.Value) // Kiểm tra nếu giá trị không phải DBNull
                {
                    decimalValues.Add(Convert.ToDecimal(reader[0])); // Chuyển đổi giá trị thành decimal và thêm vào danh sách
                }
            }

            // Đóng kết nối và giải phóng tài nguyên
            reader.Close();
            //conn.Close();
            //conn.Dispose();

            return decimalValues;
        }
        public static DataTable GetTableToSQL(string connection_string_name, string SQL)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection(connection_string_name);
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            //conn.Close();
            //conn.Dispose();

            return tbl;
        }
        public static DataTable GetTableToSQL(string SQL, List<OracleParameter> parameters)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            parameters.ForEach(v =>
            {
                cmd.Parameters.Add(v.ParameterName, v.Value);
            });
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }
        public static void ExcuteSQL_NoResult(string SQL)
        {
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
        }
        public static DataTable ExcuteSQL(string SQL)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();

            return tbl;
        }
        public static DataTable ExcuteSQL(string connection_string_name, string SQL)
        {
            DataTable tbl = new DataTable();

            OracleConnection conn = OpenConnection(connection_string_name);
            OracleCommand cmd = new OracleCommand(SQL, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();

            return tbl;
        }
        public static void ExcuteProc(string procedure_name)
        {
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
        }
        public static void ExcuteProc(string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddRange(parameters);
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
        }
        public static decimal ExcuteProcResult(string procedure_name, OracleParameter[] parameters)
        {
            OracleParameter result = new OracleParameter("result", OracleDbType.Decimal);
            result.Direction = ParameterDirection.ReturnValue;
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add(result);
            cmd.Parameters.AddRange(parameters);
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
            if (cmd.Parameters[0].Value != null) return Convert.ToDecimal(cmd.Parameters[0].Value.ToString());
            else return 0;
        }
        public static string ExcuteProcResultString(string procedure_name, OracleParameter[] parameters)
        {
            OracleParameter result = new OracleParameter("result", OracleDbType.Varchar2, 255);
            result.Direction = ParameterDirection.ReturnValue;
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add(result);
            cmd.Parameters.AddRange(parameters);
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
            OracleString output = (OracleString)cmd.Parameters[0].Value;
            if (!output.IsNull) return cmd.Parameters[0].Value.ToString();
            else return null;
        }
        public static void ExcuteProc_With_Connection(string connection_string_name, string sql)
        {
            OracleConnection conn = OpenConnection(connection_string_name);
            OracleCommand cmd = new OracleCommand(sql, conn);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();
        }
        public static void ExcuteProc(string connection_string_name, string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection(connection_string_name);
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddRange(parameters);
            cmd.ExecuteNonQuery();
            conn.Close();
            conn.Dispose();

        }
        public static DataTable GetTableByProcedurePaging(string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddRange(parameters);

            String str = cmd.ToString();

            DataTable tbl = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }
        public static DataTable GetTableByProcedurePaging_baocao(string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection_baocao();
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddRange(parameters);

            String str = cmd.ToString();

            DataTable tbl = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }
        public static DataTable GetTableByProcedurePaging(string connectionstring_name, string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection(connectionstring_name);
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddRange(parameters);

            DataTable tbl = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }
        public static DataTable GetTableByProcedurePaging_baocao(string connectionstring_name, string procedure_name, OracleParameter[] parameters)
        {
            OracleConnection conn = OpenConnection_baocao(connectionstring_name);
            OracleCommand cmd = new OracleCommand(procedure_name, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            cmd.Parameters.AddRange(parameters);

            DataTable tbl = new DataTable();
            OracleDataAdapter da = new OracleDataAdapter(cmd);
            da.Fill(tbl);
            conn.Close();
            conn.Dispose();
            return tbl;
        }

        public static string UploadFile(FileUpload fUpload, String strFolderName)
        {
            string fPath = String.Empty;
            try
            {
                //String strFolderName = "UploadFile";
                string strPath = HttpContext.Current.Server.MapPath("/") + strFolderName;
                if (!Directory.Exists(strPath))
                {
                    try
                    {
                        Directory.CreateDirectory(strPath);
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
                FileInfo objInfo = new FileInfo(fUpload.PostedFile.FileName);
                fPath = HttpContext.Current.Server.MapPath("/") + strFolderName + "\\" + Guid.NewGuid().ToString() + "" + objInfo.Extension;
                FileInfo fInfo = new FileInfo(fPath);
                if (fInfo.Exists)
                {
                    fInfo.Delete();
                }
                fUpload.SaveAs(fPath);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return fPath;
        }
        public static string UploadFile2(FileUpload fUpload, String strFolderName)
        {
            string fPath = String.Empty;
            try
            {
                //String strFolderName = "UploadFile";
                string strPath = HttpContext.Current.Server.MapPath("/") + strFolderName;
                if (!Directory.Exists(strPath))
                {
                    try
                    {
                        Directory.CreateDirectory(strPath);
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
                FileInfo objInfo = new FileInfo(fUpload.PostedFile.FileName);
                fPath = HttpContext.Current.Server.MapPath(strFolderName) + "\\" + Guid.NewGuid().ToString() + "" + objInfo.Extension;
                FileInfo fInfo = new FileInfo(fPath);
                if (fInfo.Exists)
                {
                    fInfo.Delete();
                }
                fUpload.SaveAs(fPath);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return fPath;
        }


        /// <summary>
        ///  Show messagebox bang js, Dung trong cac form sd updatepanel.
        ///  Su dung như sau: Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        /// </summary>
        /// <param name="control"></param>
        /// <param name="type"></param>
        /// <param name="title"></param>
        /// <param name="message"></param>
        public static void ShowMessage(System.Web.UI.Control control, Type type, String title, String message)
        {
            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, title, "alert('" + message + "');", true);
        }
        public static void ShowMessageZone(System.Web.UI.Control control, Type type, String zone_mesage_name, String message)
        {
            string StrMsg = "document.getElementById('" + zone_mesage_name + "').style.display = 'block';";
            StrMsg += "document.getElementById('" + zone_mesage_name + "').innerText = '" + message + "';";

            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, "Thông báo", StrMsg, true);
        }

        public static void ShowMessageAndRedirect(System.Web.UI.Control control, Type type, String strkey, String message, String strLink)
        {
            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, strkey, "alert('" + message + "');window.location ='" + strLink + "';", true);
        }
        public static void SetFocus(System.Web.UI.Control control, Type type, String ControlClientID)
        {
            //System.Web.UI.ScriptManager.RegisterStartupScript(control, type, Guid.NewGuid().ToString(), "Setfocus('" + strConvtrolid + "');", true);
            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, Guid.NewGuid().ToString(), "document.getElementById('" + ControlClientID + "').focus();", true);

        }
        /// <summary>
        ///  Show messagebox bang js, Dung trong cac form sd updatepanel.
        ///  Su dung như sau: Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        /// </summary>
        /// <param name="control"></param>
        /// <param name="type"></param>
        /// <param name="message"></param>
        public static void ShowMsgAnClosePopup(System.Web.UI.Control control, Type type, String message)
        {
            string StrMsg = "alert('" + message + "');window.close();";
            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, "Thông báo", StrMsg, true);
        }

        public static void CallFunctionJS(System.Web.UI.Control control, Type type, String function_name)
        {
            System.Web.UI.ScriptManager.RegisterStartupScript(control, type, "", function_name, true);
        }

        //-----------------------------
        public static string ShowMessage(String message)
        {
            StringBuilder Str = new StringBuilder();
            Str.Append("<script>");
            Str.Append("alert('" + message + "');");
            Str.Append("</script>");
            return Str.ToString();
        }
        public static string ShowMessage(String message, string link_redirect)
        {
            StringBuilder Str = new StringBuilder();
            Str.Append("<script type='text/javascript'>");
            Str.Append("alert('" + message + "');");
            Str.Append("window.location.href='" + link_redirect + "';");
            Str.Append("</script>");
            return Str.ToString();
        }
        public static String GetFolderUploadPath()
        {
            return ConfigurationManager.AppSettings["FolderUploadTemplate"];
        }
        public static String GetFolderTemplate()
        {
            return ConfigurationManager.AppSettings["FolderTemplate"];
        }
        public static String GetSettingByKey(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
        public static String GetFolderTaiLieu()
        {
            return ConfigurationManager.AppSettings["FolderTaiLieu"];
        }

        public static string ChuyenTVKhongDau(string strVietNamese)
        {
            string FindText = "áàảãạ âấầẩẫậ ăắằẳẵặ ẽẹẻéè êếềểễệ íìỉĩị óòỏõọ ôốồổỗộ ơớờởỡợ úùủũụ ưứửữựừ ýỳỷỹỵ ÁÀẢÃẠ ÂẤẦẨẪẬ ĂẮẰẲẴẶ ÉÈẺẼẸ ẾỀỂỄỆÊ ÍÌỈĨỊ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ƯỨỪỬỮỰ ÝỲỶỸỴ đĐ";
            string ReplText = "aaaaa aaaaaa aaaaaa eeeee eeeeee iiiii ooooo oooooo oooooo uuuuu uuuuuu yyyyy AAAAA AAAAAA AAAAAA EEEEE EEEEEE IIIII OOOOO OOOOOO OOOOOO UUUUU UUUUUU YYYYY dD";
            //strArr = "\\|/|?|%|=|!|<|>|&|#|@|*|.|:|(|)|;|'|^|\"";
            //REPLACE SPACE
            FindText = FindText.Replace(" ", "");
            ReplText = ReplText.Replace(" ", "");

            int index = -1, index2;
            while ((index = strVietNamese.IndexOfAny(FindText.ToCharArray())) != -1)
            {
                index2 = FindText.IndexOf(strVietNamese[index]);
                strVietNamese = strVietNamese.Replace(strVietNamese[index], ReplText[index2]);
            }
            strVietNamese = strVietNamese.Replace("̉", "");
            strVietNamese = strVietNamese.Replace("̃", "");
            strVietNamese = strVietNamese.Replace("̀", "");
            strVietNamese = strVietNamese.Replace("́", "");
            strVietNamese = strVietNamese.Replace("\\", " ");
            strVietNamese = strVietNamese.Replace("/", " ");
            strVietNamese = strVietNamese.Replace(".", " ");
            strVietNamese = strVietNamese.Replace(";", " ");
            strVietNamese = strVietNamese.Replace("'", " ");
            strVietNamese = strVietNamese.Replace("\"", " ");
            strVietNamese = strVietNamese.Replace(":", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(" ", "_");
            return strVietNamese.ToLower();
        }
        public static string mf_sConvertVietnameseToEn(string strVietNamese)
        {
            string FindText = "áàảãạ âấầẩẫậ ăắằẳẵặ ẽẹẻéè êếềểễệ íìỉĩị óòỏõọ ôốồổỗộ ơớờởỡợ úùủũụ ưứửữựừ ýỳỷỹỵ ÁÀẢÃẠ ÂẤẦẨẪẬ ĂẮẰẲẴẶ ÉÈẺẼẸ ẾỀỂỄỆÊ ÍÌỈĨỊ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ƯỨỪỬỮỰ ÝỲỶỸỴ đĐ";
            string ReplText = "aaaaa aaaaaa aaaaaa eeeee eeeeee iiiii ooooo oooooo oooooo uuuuu uuuuuu yyyyy AAAAA AAAAAA AAAAAA EEEEE EEEEEE IIIII OOOOO OOOOOO OOOOOO UUUUU UUUUUU YYYYY dD";
            //strArr = "\\|/|?|%|=|!|<|>|&|#|@|*|.|:|(|)|;|'|^|\"";
            //REPLACE SPACE
            FindText = FindText.Replace(" ", "");
            ReplText = ReplText.Replace(" ", "");

            int index = -1, index2;
            while ((index = strVietNamese.IndexOfAny(FindText.ToCharArray())) != -1)
            {
                index2 = FindText.IndexOf(strVietNamese[index]);
                strVietNamese = strVietNamese.Replace(strVietNamese[index], ReplText[index2]);
            }
            strVietNamese = strVietNamese.Replace("̉", "");
            strVietNamese = strVietNamese.Replace("̃", "");
            strVietNamese = strVietNamese.Replace("̀", "");
            strVietNamese = strVietNamese.Replace("́", "");
            strVietNamese = strVietNamese.Replace("\\", " ");
            strVietNamese = strVietNamese.Replace("/", " ");
            strVietNamese = strVietNamese.Replace(".", " ");
            strVietNamese = strVietNamese.Replace(";", " ");
            strVietNamese = strVietNamese.Replace("'", " ");
            strVietNamese = strVietNamese.Replace("\"", " ");
            strVietNamese = strVietNamese.Replace(":", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(" ", " ");
            return strVietNamese;
        }
        public static string ChuyenTenFileUpload(string strVietNamese)
        {
            string FindText = "áàảãạ âấầẩẫậ ăắằẳẵặ ẽẹẻéè êếềểễệ íìỉĩị óòỏõọ ôốồổỗộ ơớờởỡợ úùủũụ ưứửữựừ ýỳỷỹỵ ÁÀẢÃẠ ÂẤẦẨẪẬ ĂẮẰẲẴẶ ÉÈẺẼẸ ẾỀỂỄỆÊ ÍÌỈĨỊ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ƯỨỪỬỮỰ ÝỲỶỸỴ đĐ";
            string ReplText = "aaaaa aaaaaa aaaaaa eeeee eeeeee iiiii ooooo oooooo oooooo uuuuu uuuuuu yyyyy AAAAA AAAAAA AAAAAA EEEEE EEEEEE IIIII OOOOO OOOOOO OOOOOO UUUUU UUUUUU YYYYY dD";
            //strArr = "\\|/|?|%|=|!|<|>|&|#|@|*|.|:|(|)|;|'|^|\"";
            //REPLACE SPACE
            FindText = FindText.Replace(" ", "");
            ReplText = ReplText.Replace(" ", "");

            int index = -1, index2;
            while ((index = strVietNamese.IndexOfAny(FindText.ToCharArray())) != -1)
            {
                index2 = FindText.IndexOf(strVietNamese[index]);
                strVietNamese = strVietNamese.Replace(strVietNamese[index], ReplText[index2]);
            }
            strVietNamese = strVietNamese.Replace("\\", " ");
            strVietNamese = strVietNamese.Replace("/", " ");
            strVietNamese = strVietNamese.Replace(";", " ");
            strVietNamese = strVietNamese.Replace("'", " ");
            strVietNamese = strVietNamese.Replace("\"", " ");
            strVietNamese = strVietNamese.Replace(":", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(",", " ");
            strVietNamese = strVietNamese.Replace(" ", "_");
            return strVietNamese.ToLower();
        }
        public static string ConvertExportReportName(string strVietNamese)
        {
            string FindText = "áàảãạ âấầẩẫậ ăắằẳẵặ ẽẹẻéè êếềểễệ íìỉĩị óòỏõọ ôốồổỗộ ơớờởỡợ úùủũụ ưứửữựừ ýỳỷỹỵ ÁÀẢÃẠ ÂẤẦẨẪẬ ĂẮẰẲẴẶ ÉÈẺẼẸ ẾỀỂỄỆÊ ÍÌỈĨỊ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ƯỨỪỬỮỰ ÝỲỶỸỴ đĐ";
            string ReplText = "aaaaa aaaaaa aaaaaa eeeee eeeeee iiiii ooooo oooooo oooooo uuuuu uuuuuu yyyyy AAAAA AAAAAA AAAAAA EEEEE EEEEEE IIIII OOOOO OOOOOO OOOOOO UUUUU UUUUUU YYYYY dD";
            //strArr = "\\|/|?|%|=|!|<|>|&|#|@|*|.|:|(|)|;|'|^|\"";
            //REPLACE SPACE
            FindText = FindText.Replace(" ", "");
            ReplText = ReplText.Replace(" ", "");

            int index = -1, index2;
            while ((index = strVietNamese.IndexOfAny(FindText.ToCharArray())) != -1)
            {
                index2 = FindText.IndexOf(strVietNamese[index]);
                strVietNamese = strVietNamese.Replace(strVietNamese[index], ReplText[index2]);
            }
            String temp = "";
            temp = strVietNamese.Replace("\\", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace("/", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace(".", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace(";", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace("'", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace("\"", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace(":", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace(",", " ");
            strVietNamese = temp;
            temp = strVietNamese.Replace("%", "Phan tram");
            strVietNamese = temp;
            return strVietNamese.ToLower();
        }

        public static string GetContentType(string strExtension)
        {
            Dictionary<string, string> contentTypes = new Dictionary<string, string>
                               {
                                   {"doc", "application/msword"},
                                   {"dot", "application/msword"},
                                   {"gif", "image/gif"},
                                   {"jpe", "image/jpeg"},
                                   {"jpeg", "image/jpeg"},
                                   {"jpg", "image/jpeg"},
                                   {"jps", "image/x-jps"},
                                   {"word", "application/msword"},
                                   {"docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"},
                                   {"xla", "application/excel"},
                                   {"xlb", "application/excel"},
                                   {"xlc", "application/excel"},
                                   {"xld", "application/excel"},
                                   {"xlk", "application/excel"},
                                   {"xll", "application/excel"},
                                   {"xlm", "application/excel"},
                                   {"xls", "application/excel"},
                                   {"xlt", "application/excel"},
                                   {"xlv", "application/excel"},
                                    {"pdf", "application/pdf"},
                                      {"zip", "application/zip"},
                                         {"rar", "application/rar"}
                               };
            strExtension = strExtension.Replace(".", "");
            string contentType;
            contentTypes.TryGetValue(strExtension.ToLower(), out contentType);
            if (String.IsNullOrEmpty(contentType))
            {
                contentType = "application/octet-stream";
            }
            return contentType;
        }

        //--------------------------------
        public static string Randomnumber()
        {
            const byte LENGTH = 6;

            // chuỗi để lấy các kí tự sẽ sử dụng cho captcha
            const string chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            // Lưu chuỗi captcha trong quá trình tạo
            StringBuilder strCaptcha = new StringBuilder();

            Random rand = new Random();

            for (int i = 0; i < LENGTH; i++)
            {
                // Lấy kí tự ngẫu nhiên từ mảng chars
                string str = chars[rand.Next(chars.Length)].ToString();
                strCaptcha.Append(str);
            }
            string str1 = strCaptcha.ToString();
            return str1;
        }

        public static string RandomString(int length)
        {
            Random random = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
              .Select(s => s[random.Next(s.Length)]).ToArray());
        }
        //----------------------------
        public static bool SendEmail(string toEmail, string subject, string content)
        {
            try
            {
                string strHost = "smtp.gmail.com";
                string strPort = "587";
                string strSSL = "true";
                string strFrom = "test.@gmail.com";
                string strPass = "password";
                GSTPContext dt = new GSTPContext();
                DM_CONFIG obj = new DM_CONFIG();
                obj = dt.DM_CONFIG.Where(x => x.CONFIGCODE == "sendmail").Single<DM_CONFIG>();
                if (obj != null)
                {
                    strHost = obj.HOST;
                    strPort = obj.POST;
                    strSSL = obj.SSL;
                    strFrom = obj.EMAIL;
                    strPass = obj.PASS;
                }
                SmtpClient smtp = new SmtpClient();
                //ĐỊA CHỈ SMTP Server
                smtp.Host = strHost;
                //Cổng SMTP
                smtp.Port = Convert.ToInt32(strPort);
                //SMTP yêu cầu mã hóa dữ liệu theo SSL
                smtp.EnableSsl = Convert.ToBoolean(strSSL);
                //UserName và Password của mail
                smtp.Credentials = new NetworkCredential(strFrom, strPass);
                //Tham số lần lượt là địa chỉ người gửi, người nhận, tiêu đề và nội dung thư
                System.Net.Mail.MailMessage oMsg = new System.Net.Mail.MailMessage
                {
                    BodyEncoding = System.Text.Encoding.UTF8,
                    IsBodyHtml = true,
                    From = new MailAddress(strFrom)
                };
                oMsg.To.Add(toEmail);
                oMsg.Subject = subject;
                oMsg.Body = content;

                ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                smtp.Send(oMsg);
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public static String FormatTenRieng(string text_string)
        {
            string temp = "";
            string temp_char = "";
            string retval = "";
            string[] arr = null;
            if (text_string.Contains(" "))
            {
                arr = text_string.ToLower().Trim().Split(' ');
                foreach (String str in arr)
                {
                    temp = temp_char = "";
                    if (str.Length > 0)
                    {
                        temp_char = str.Substring(0, 1).ToUpper();
                        temp = temp_char + str.Substring(1, str.Length - 1);

                        retval += " " + temp;
                    }
                }
            }
            else
            {
                temp = temp_char = "";
                if (text_string.Length > 0)
                {
                    temp_char = text_string.ToLower().Substring(0, 1).ToUpper();
                    retval = temp_char + text_string.Substring(1, text_string.Length - 1);
                }
            }
            return retval.Trim();
        }
        public static String FormatTenTochuc(string text_string)
        {
            string temp = "";

            temp = text_string;
            if (!string.IsNullOrEmpty(temp)) // Kiểm tra chuỗi không rỗng
            {
                temp = char.ToUpper(temp[0]) + temp.Substring(1);
            }

            return temp;
        }
        public static string NumberToTextVN(decimal total)
        {
            try
            {
                string rs = "";
                total = Math.Round(total, 0);
                string[] ch = { "không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín" };
                string[] rch = { "lẻ", "mốt", "", "", "", "lăm" };
                string[] u = { "", "mươi", "trăm", "ngàn", "", "", "triệu", "", "", "tỷ", "", "", "ngàn", "", "", "triệu" };
                string nstr = total.ToString();

                int[] n = new int[nstr.Length];
                int len = n.Length;
                for (int i = 0; i < len; i++)
                {
                    n[len - 1 - i] = Convert.ToInt32(nstr.Substring(i, 1));
                }

                for (int i = len - 1; i >= 0; i--)
                {
                    if (i % 3 == 2)// số 0 ở hàng trăm
                    {
                        if (n[i] == 0 && n[i - 1] == 0 && n[i - 2] == 0) continue;//nếu cả 3 số là 0 thì bỏ qua không đọc
                    }
                    else if (i % 3 == 1) // số ở hàng chục
                    {
                        if (n[i] == 0)
                        {
                            if (n[i - 1] == 0) { continue; }// nếu hàng chục và hàng đơn vị đều là 0 thì bỏ qua.
                            else
                            {
                                rs += " " + rch[n[i]]; continue;// hàng chục là 0 thì bỏ qua, đọc số hàng đơn vị
                            }
                        }
                        if (n[i] == 1)//nếu số hàng chục là 1 thì đọc là mười
                        {
                            rs += " mười"; continue;
                        }
                    }
                    else if (i != len - 1)// số ở hàng đơn vị (không phải là số đầu tiên)
                    {
                        if (n[i] == 0)// số hàng đơn vị là 0 thì chỉ đọc đơn vị
                        {
                            if (i + 2 <= len - 1 && n[i + 2] == 0 && n[i + 1] == 0) continue;
                            rs += " " + (i % 3 == 0 ? u[i] : u[i % 3]);
                            continue;
                        }
                        if (n[i] == 1)// nếu là 1 thì tùy vào số hàng chục mà đọc: 0,1: một / còn lại: mốt
                        {
                            rs += " " + ((n[i + 1] == 1 || n[i + 1] == 0) ? ch[n[i]] : rch[n[i]]);
                            rs += " " + (i % 3 == 0 ? u[i] : u[i % 3]);
                            continue;
                        }
                        if (n[i] == 5) // cách đọc số 5
                        {
                            if (n[i + 1] != 0) //nếu số hàng chục khác 0 thì đọc số 5 là lăm
                            {
                                rs += " " + rch[n[i]];// đọc số 
                                rs += " " + (i % 3 == 0 ? u[i] : u[i % 3]);// đọc đơn vị
                                continue;
                            }
                        }
                    }

                    rs += (rs == "" ? " " : ", ") + ch[n[i]];// đọc số
                    rs += " " + (i % 3 == 0 ? u[i] : u[i % 3]);// đọc đơn vị
                }
                if (rs[rs.Length - 1] != ' ')
                    rs += " đồng chẵn";
                else
                    rs += "đồng chẵn";

                if (rs.Length > 2)
                {
                    string rs1 = rs.Substring(0, 2);
                    rs1 = rs1.ToUpper();
                    rs = rs.Substring(2);
                    rs = rs1 + rs;
                }
                return rs.Trim().Replace("lẻ,", "lẻ").Replace("mươi,", "mươi").Replace("trăm,", "trăm").Replace("mười,", "mười").Trim();
            }
            catch
            {
                return "";
            }

        }
        public static void SetValueComboBox(DropDownList ddl, object value)
        {
            if (String.IsNullOrEmpty(value + "")) return;
            if (ddl.Items.FindByValue(value + "") != null)
                ddl.SelectedValue = value + "";
        }
        public static byte[] Get_Blob_File(OracleCommand command, String _Comlumn)
        {
            byte[] c = new byte[0];
            OracleDataReader reader = command.ExecuteReader(System.Data.CommandBehavior.Default);
            try
            {
                while (reader.Read())
                {
                    //Obtain OracleLob directly from OracleDataReader
                    OracleBlob myLob = reader.GetOracleBlob(reader.GetOrdinal(_Comlumn));
                    if (!myLob.IsNull)
                    {
                        byte[] b = new byte[myLob.Length];
                        //Read data from database
                        myLob.Read(b, 0, (int)myLob.Length);
                        c = b;
                    }
                }
                return c;
            }
            finally
            {
                reader.Close();
                command.Connection.Close();
            }
        }
        public static decimal NextValSeq(string seqName)
        {
            string sql = "SELECT " + seqName + " .nextval id FROM dual";
            DataTable dt = GetTableToSQL(sql);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                decimal result = decimal.Parse(dt.Rows[i]["ID"].ToString());
                return result;
            }
            return 0;
        }

        public static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }
        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (System.Reflection.PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        if (dr[column.ColumnName] != DBNull.Value)
                        {
                            pro.SetValue(obj, dr[column.ColumnName], null);
                        }
                        else
                        {
                            pro.SetValue(obj, null, null);
                        }
                    else
                        continue;
                }
            }
            return obj;
        }
        public static string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
        public static string GenerateSecretPass(int length = 32)
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            char[] chars = new char[length];
            byte[] randomBytes = new byte[length];

            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomBytes);
            }

            for (int i = 0; i < length; i++)
            {
                chars[i] = validChars[randomBytes[i] % validChars.Length];
            }

            return new string(chars);
        }

        // VNPT Nguyễn Đăng Huy Hoàng 15:42:00 14/11/2025
        // hàm xử lý tên file gửi thông báo tống đạt
        public static string BuildFilename(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return string.Empty;

            // Trim
            input = input.Trim();

            // Thay khoảng trắng bằng "_"
            string replaced = input.Replace(" ", "_");

            // Thêm .pdf
            return replaced + ".pdf";
        }
    }
}