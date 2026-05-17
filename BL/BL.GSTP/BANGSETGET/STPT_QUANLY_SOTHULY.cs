using System;
using System.Globalization;
using System.Web.UI;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Module.Common;
using System.Web.Script.Serialization;

using Oracle.ManagedDataAccess.Client;

namespace BL.GSTP.BANGSETGET.SYSTEM_LOG
{
    public class STPT_QUANLY_SOTHULY
    {
        public Decimal ID { get; set; }
        public Decimal MAGIAIDOAN { get; set; }
        public Decimal LOAIAN { get; set; }
        public Decimal TOAAN_ID { get; set; }
        public DateTime? NGAYTHULY { get; set; }
        public String SOTHULY { get; set; }
        public Decimal LYDOID { get; set; }
        public String LYDO { get; set; }
        
        public String TAIKHOANXOA { get; set; }
        public String NGUOIXOA { get; set; }

        public DateTime? NGAYXOA { get; set; }
        public Decimal ACTIVE { get; set; }
        public Decimal DONID { get; set; }

        public bool insert_STPT_QUANLY_SOTHULY(decimal in_MAGIAIDOAN, decimal in_LOAIAN, decimal in_TOAAN_ID, string in_NGAYTHULY, string in_SOTHULY,
                                                decimal in_LYDOID, string in_LYDO, string in_TAIKHOANXOA, string in_NGUOIXOA, decimal in_Active, decimal in_donid)
        {
             CultureInfo cul = new CultureInfo("vi-VN");
            /* Lưu số thụ lý bị xóa
               Trường hợp nếu số đã tồn tại thì chỉ update các trường trước */
            try
            {
                //string in_Ngaythuly = Convert.ToDateTime(in_NGAYTHULY).Date.ToString("dd/MM/yyyy");
                STPT_QUANLY_SOTHULY obj = DataExtensions.GetAllWithClause<STPT_QUANLY_SOTHULY>($"LOAIAN = {in_LOAIAN} AND SOTHULY = '{in_SOTHULY}' AND NGAYTHULY LIKE to_date('{in_NGAYTHULY}','dd/mm/yyyy') AND TOAAN_ID = {in_TOAAN_ID} AND ACTIVE = {in_Active}").FirstOrDefault();
                if (obj == null)
                {
                    STPT_QUANLY_SOTHULY insert = new STPT_QUANLY_SOTHULY();
                    insert.DONID = in_donid;
                    insert.MAGIAIDOAN = in_MAGIAIDOAN;
                    insert.LOAIAN = in_LOAIAN;
                    insert.TOAAN_ID = in_TOAAN_ID;
                    insert.NGAYTHULY = DateTime.Parse(in_NGAYTHULY.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    insert.SOTHULY = in_SOTHULY;
                    insert.LYDOID = in_LYDOID;
                    insert.LYDO = in_LYDO;
                    insert.TAIKHOANXOA = in_TAIKHOANXOA;
                    insert.NGUOIXOA = in_NGUOIXOA;
                    insert.NGAYXOA = DateTime.Now;
                    insert.ACTIVE = in_Active;

                    DataExtensions.Insert(insert);

                    return true;
                }
                else
                {
                    obj.MAGIAIDOAN = in_MAGIAIDOAN;
                    obj.DONID = in_donid;
                    obj.LOAIAN = in_LOAIAN;
                    obj.TOAAN_ID = in_TOAAN_ID;
                    obj.NGAYTHULY = DateTime.Parse(in_NGAYTHULY.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.SOTHULY = in_SOTHULY;
                    obj.LYDOID = in_LYDOID;
                    obj.LYDO = in_LYDO;
                    obj.TAIKHOANXOA = in_TAIKHOANXOA;
                    obj.NGUOIXOA = in_NGUOIXOA;
                    obj.NGAYXOA = DateTime.Now;
                    obj.ACTIVE = in_Active;

                    DataExtensions.Update(obj);

                    return true;
                }
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string error = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                return false;
            }
        }

        public bool update_STPT_QUANLY_SOTHULY(decimal in_MAGIAIDOAN, decimal in_LOAIAN, decimal in_TOAAN_ID, string in_NGAYTHULY, string in_SOTHULY)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            /* Khi lưu số có trong danh sách quản lý */
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                            new OracleParameter("in_MAGIAIDOAN",in_MAGIAIDOAN),
                            new OracleParameter("in_LOAIAN",in_LOAIAN),
                            new OracleParameter("in_TOAAN_ID",in_TOAAN_ID),
                            new OracleParameter("in_NGAYTHULY",in_NGAYTHULY),
                            new OracleParameter("in_SOTHULY",in_SOTHULY),
                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                            };

                DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QUANLY_SOTHULY.UPDATE_STPT_QUANLY_SOTHULY_THEOSOTHULYVANAM", parameters);

                return dbl.Rows[0]["RESULT_QUERY"].ToString() == "1" ? true : false;
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string error = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                return false;
            }
        }


        /*Lấy danh sách số thụ lý trống (đã xóa nhưng được sử dụng lại) theo ngày hoặc tất cả số thụ lý theo ngày nếu không có thụ lý trống*/
        public DataTable get_STPT_QUANLY_SOTHULY(decimal in_MAGIAIDOAN, decimal in_LOAIAN, decimal in_TOAAN_ID, string in_NGAYTHULY)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                            new OracleParameter("in_MAGIAIDOAN",in_MAGIAIDOAN),
                            new OracleParameter("in_LOAIAN",in_LOAIAN),
                            new OracleParameter("in_TOAAN_ID",in_TOAAN_ID),
                            new OracleParameter("in_NGAYTHULY",in_NGAYTHULY),
                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                            };

                if(in_MAGIAIDOAN == 2)
                {
                    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QUANLY_SOTHULY.GET_STPT_QUANLY_SOTHULY_THEONGAY_SOTHAM", parameters);
                    return tbl;
                }
                else if(in_MAGIAIDOAN == 3)
                {
                    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QUANLY_SOTHULY.GET_STPT_QUANLY_SOTHULY_THEONGAY_PHUCTHAM", parameters);
                    return tbl;
                }
                else
                {
                    return null;
                }

            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string error = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                return null;
            }
        }

        public string get_LATEST_DATE_IN_SOTHULY(decimal in_MAGIAIDOAN, decimal in_LOAIAN, decimal in_TOAAN_ID, string in_NGAYTHULY)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("in_MAGIAIDOAN", in_MAGIAIDOAN),
                new OracleParameter("in_LOAIAN", in_LOAIAN),
                new OracleParameter("in_TOAAN_ID", in_TOAAN_ID),
                new OracleParameter("in_NGAYTHULY", in_NGAYTHULY),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };

                DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QUANLY_SOTHULY.GET_LATEST_DATE_IN_SOTHULY", parameters);

                return ((DateTime)dbl.Rows[0]["RESULT_QUERY"]).ToString("dd/MM/yyyy", cul);

            }
            catch (Exception ex) { return "01/01/1900"; }

        }
    }

}