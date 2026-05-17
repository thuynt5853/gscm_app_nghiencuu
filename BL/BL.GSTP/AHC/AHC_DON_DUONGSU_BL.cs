using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHC
{
    public class AHC_DON_DUONGSU_BL
    {
        public void AHC_DON_YEUTONUOCNGOAI_UPDATE(decimal vDONID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID)
                                                                      };
                Cls_Comon.ExcuteProc("AHC_DON_YEUTONUOCNGOAI_UPDATE", parameters);
                return;
            }
            catch (Exception ex) { }
        }
       
        public DataTable GetAllByVuViecID(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_GETLIST", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_THAMGIATOTUNG(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_THAMGIATOTUNG", parameters);
            return tbl;
        }

        public DataTable AHC_THULY_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HANHCHINH.GET_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }

        public DataTable AHC_DUONGSU_KHANGCAO(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HANHCHINH.GET_DUONGSU_KHANGCAO", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_ANPHI(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.AHC_DON_DUONGSU_ANPHI", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_GETBY(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHC_DON_DSDUONGSU_GETBY(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable AHC_DON_DUONGSU_NOTDAIDIEN(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_NOTDAIDIEN", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_NOTDAIDIEN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_NOTDAIDIEN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHC_DON_DUONGSU_Getall(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_Getall", parameters);
            return tbl;
        }

        public DataTable AHC_DON_DUONGSU_Getall_BiDon(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_Getall_BiDon", parameters);
            return tbl;
        }

        public DataTable AHC_SOTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsSoTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsSoTham",vIsSoTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_DUONGSU_GETBY", parameters);
            if (tbl != null && tbl.Rows.Count>0)
            {
                String temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = row["TENDUONGSU"] + "";
                    temp += (String.IsNullOrEmpty(row["DIACHIDS"] + "")) ? "" : (" - " + row["DIACHIDS"]);
                    temp += (String.IsNullOrEmpty(row["TENTCTT"] + "")) ? "" : (" - " + row["TENTCTT"]);
                    row["ARRDUONGSU"] = temp;
                }
            }
            return tbl;
        }
        public DataTable AHC_PHUCTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsPhucTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsPhucTham",vIsPhucTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_PHUCTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public string AHC_DUONGSU_GETNAMEBYKHANGCAO(decimal vKhangCaoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vKhangCaoID",vKhangCaoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string TenNguoiKC = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DUONGSU_GETNAMEBYKHANGCAO", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TenNguoiKC = tbl.Rows[0]["TENDUONGSU"].ToString();
            }
            return TenNguoiKC;
        }
        public DataTable AHC_DON_DUONGSU_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_DON_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }
    }
}