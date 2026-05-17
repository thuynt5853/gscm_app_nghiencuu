using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Module.Common
{
    public static class MappingExtensions
    {
        public static string ToIdString(this Enum enumValue)
        {
            return ((int)(object)enumValue).ToString();
        }
        public static string ToHienThiSo(this object item, bool isFloat = false)
        {
            decimal _item = Convert.ToDecimal(item);
            if (isFloat)
                return _item.ToString("###,###,##0.#0");
            return _item.ToString("###,###,##0");
        }
        public static string ToHienThiTien(this object item, bool xBV = false)
        {
            decimal _item = Convert.ToDecimal(item);
            return _item.ToHienThiSo() + " đ";

        }
        public static string ToHienThiBV(this object item)
        {
            decimal _item = Convert.ToDecimal(item);
            return _item.ToHienThiSo();
        }
        /// <summary>
        /// Chuyen date to string with format: dd/MM/yyyy
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public static string ToVNDate(this DateTime? item)
        {
            if (item.HasValue || item != DateTime.MinValue)
                return item.Value.ToString("dd/MM/yyyy");
            return "";
        }
        public static string ToVNDate(this DateTime item)
        {
            if (item == null || item != DateTime.MinValue)
                return item.ToString("dd/MM/yyyy");
            return "";
        }

        public static string ToHienThiPhanTram(this object item, bool x100 = true, bool isRound = true)
        {
            decimal _item = Convert.ToDecimal(item);
            if (x100)
                _item = _item * 100;
            if (isRound)
                return _item.ToHienThiSo() + " %";
            return _item.ToHienThiSo(true) + " %";
        }

        /// <summary>
        /// Chuyen doi ngay thang dang dd/MM/yyyy thanh ngay thang he thong
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public static DateTime? toSysDate(this string dtstr)
        {
            DateTime dt;
            if (DateTime.TryParseExact(dtstr, "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out dt))
                return dt;
            return null;
        }
        public static DateTime? toSysDate2(this string dtstr)
        {
            DateTime dt;
            if (DateTime.TryParseExact(dtstr, "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out dt))
                return dt;
            return DateTime.MinValue;
        }
        public static string toIntString(this Object tt)
        {
            return ((int)tt).ToString();
        }
        public static decimal toNumber(this object item)
        {
            decimal rs;
            String so = item.ToString();
            so = so.Trim().Replace(".", "").Replace(",", "");
            if (!String.IsNullOrEmpty(so) && Decimal.TryParse(so, out rs))
                return rs;
            return 0;
        }
        public static String toNumberString(this object item)
        {
            decimal _item = Convert.ToDecimal(item);
            return _item.ToString("##0");
        }
        private static string[] VietNamChar = new string[]
    {
        "aAeEoOuUiIdDyY",
        "áàạảãâấầậẩẫăắằặẳẵ",
        "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
        "éèẹẻẽêếềệểễ",
        "ÉÈẸẺẼÊẾỀỆỂỄ",
        "óòọỏõôốồộổỗơớờợởỡ",
        "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
        "úùụủũưứừựửữ",
        "ÚÙỤỦŨƯỨỪỰỬỮ",
        "íìịỉĩ",
        "ÍÌỊỈĨ",
        "đ",
        "Đ",
        "ýỳỵỷỹ",
        "ÝỲỴỶỸ"
    };
        public static string toNoSign(this string str)
        {
            //Thay thế và lọc dấu từng char      
            for (int i = 1; i < VietNamChar.Length; i++)
            {
                for (int j = 0; j < VietNamChar[i].Length; j++)
                    str = str.Replace(VietNamChar[i][j], VietNamChar[0][i - 1]);
            }
            return str;
        }
        #region  Object to json
        public static string toStringJson(this Object obj)
        {
            if (obj == null)
                return "";
            try
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(obj);
            }
            catch { }
            return "";


        }
        /// <summary>
        /// Chuyen doi chuoi json thanh dang entity
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="strjson"></param>
        /// <returns></returns>
        public static T toEntity<T>(this string strjson)
        {
            if (string.IsNullOrEmpty(strjson))
                return default(T);
            try
            {
                return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(strjson);
            }
            catch { }
            return default(T);


        }
        /// <summary>
        /// Chuyen doi chuoi json thanh dang list(entity)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="strjson"></param>
        /// <returns></returns>
        public static List<T> toEntities<T>(this string strjson)
        {
            if (string.IsNullOrEmpty(strjson))
                return default(List<T>);
            try
            {
                return Newtonsoft.Json.JsonConvert.DeserializeObject<List<T>>(strjson);
            }
            catch { }
            return default(List<T>);


        }
        #endregion
    }
    public enum ENUM_LOG_THAOTAC
    {
        THEM_MOI,
        CAP_NHAT,
        XOA,
        TIM_KIEM,
        DANG_NHAP,
        DANG_XUAT

    }
}