using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class XLHC_DON_DUONGSU_BL
    {
        public void XLHC_DON_YEUTONUOCNGOAI_UPDATE(decimal vDONID)
        {
            try
            {

                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID)
                                                                      };
                Cls_Comon.ExcuteProc("XLHC_DON_YEUTONUOCNGOAI_UPDATE", parameters);
                return;
            }
            catch (Exception ex) { }
        }
        public DataTable XLHC_DON_DUONGSU_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_DUONGSU_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_DON_DUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_DUONGSU_GETBY", parameters);
            return tbl;

        }
        public DataTable XLHC_DON_DUONGSU_NOTDAIDIEN(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DON_DUONGSU_NOTDAIDIEN", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsSoTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsSoTham",vIsSoTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable XLHC_PHUCTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsPhucTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsPhucTham",vIsPhucTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_PHUCTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public string XLHC_DUONGSU_GETNAMEBYKHANGCAO(decimal vKhangCaoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vKhangCaoID",vKhangCaoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string TenNguoiKC = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DUONGSU_GETNAMEBYKHANGCAO", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TenNguoiKC = tbl.Rows[0]["TENDUONGSU"].ToString();
            }
            return TenNguoiKC;
        }


        /// <summary>
        /// Lấy thông tin đương sự dựa vào ID đơn và loại bị can đầu vụ
        /// </summary>
        /// <param name="DonID">ID đơn hành chính</param>
        /// <param name="BiCanDauVu">Trạng thái bị can đầu vụ (1: là bị can đầu vụ, 0: không phải bị can đầu vụ)</param>
        /// <returns>DataTable chứa thông tin đương sự</returns>
        public DataTable XLHC_DUONGSU_GET_BY_DONID_BICANDAUVU(Decimal DonID, int BiCanDauVu)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
            new OracleParameter("VDONID", DonID),
            new OracleParameter("VBICANDAUVU", BiCanDauVu),
            new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.GET_BY_DONID_BICANDAUVU", parameters);
            return tbl;
        }
        /// <summary>
        /// Lưu thông tin đương sự vào cơ sở dữ liệu
        /// </summary>
        /// <param name="parameters">Dictionary chứa các tham số</param>
        /// <returns>Kết quả thao tác: > 0 thành công, 0 thất bại</returns>
        public int XLHC_DUONGSU_SAVE(Dictionary<string, object> paramDict)
        {
            try
            {
                // Chuyển Dictionary thành mảng OracleParameter
                List<OracleParameter> paramList = new List<OracleParameter>();

                foreach (KeyValuePair<string, object> param in paramDict)
                {
                    // Bỏ ký tự @ ở đầu tên tham số nếu có
                    string paramName = param.Key.StartsWith("@") ? param.Key.Substring(1) : param.Key;

                    if (param.Value == DBNull.Value || param.Value == null)
                    {
                        paramList.Add(new OracleParameter(paramName, DBNull.Value));
                    }
                    else
                    {
                        // Xác định loại dữ liệu Oracle tương ứng
                        if (param.Value is DateTime)
                        {
                            paramList.Add(new OracleParameter(paramName, OracleDbType.Date, param.Value, ParameterDirection.Input));
                        }
                        else if (param.Value is Decimal || param.Value is int)
                        {
                            paramList.Add(new OracleParameter(paramName, OracleDbType.Decimal, param.Value, ParameterDirection.Input));
                        }
                        else
                        {
                            paramList.Add(new OracleParameter(paramName, param.Value));
                        }
                    }
                }

                // Thêm tham số trả về
                paramList.Add(new OracleParameter("VRESULT", OracleDbType.Int32, ParameterDirection.Output));

                // Gọi stored procedure
                Cls_Comon.GetTableByProcedurePaging("PKG_STPT.SAVE_DUONGSU", paramList.ToArray());

                // Lấy kết quả trả v
                OracleParameter resultParam = paramList.Find(p => p.ParameterName == "VRESULT");
                return Convert.ToInt32(resultParam.Value.ToString());
            }
            catch (Exception ex)
            {
                // Xử lý lỗi, có thể ghi log ở đây
                System.Diagnostics.Debug.WriteLine("Lỗi khi lưu thông tin XLHC_DUONGSU: " + ex.Message);
                return 0;
            }
        }
    }
}