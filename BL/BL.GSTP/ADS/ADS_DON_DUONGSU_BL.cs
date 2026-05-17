using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class ADS_DON_DUONGSU_BL
    {
        public void ADS_DON_YEUTONUOCNGOAI_UPDATE(decimal vDONID)
        {
            try
            {

                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID)                                                                       
                                                                      };
                Cls_Comon.ExcuteProc("ADS_DON_YEUTONUOCNGOAI_UPDATE", parameters);
                return;
            }
            catch(Exception ex) { }
        }

        public DataTable ADS_DON_DUONGSU_GETLIST(decimal vDONID)
        {
       
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_GETLIST", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_THAMGIATOTUNG(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_THAMGIATOTUNG", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_ANPHI(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.ADS_DON_DUONGSU_ANPHI", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_BIENLAI(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.ADS_DON_DUONGSU_BIENLAI", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_BIENLAI_V2(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_ADS.ADS_DON_DUONGSU_BIENLAI_V2", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable ADS_DON_DSDUONGSU_GETBY(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DSDUONGSU_GETBY", parameters);
            return tbl;
        }
        public DataTable ADS_DON_DUONGSU_NOTDAIDIEN(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_NOTDAIDIEN", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_NOTDAIDIEN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_NOTDAIDIEN_CHITIET", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_Getall(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_GETALL", parameters);
            return tbl;
        }

        public DataTable ADS_DON_DUONGSU_Getall_BiDon(decimal vIDDONCT, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIDDONCT",vIDDONCT),
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_Getall_BiDon", parameters);
            return tbl;
        }
        public DataTable GetAllByVuViecID(decimal vuviecid)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vuviecid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_DUONGSU_GETLIST", parameters);
            return tbl;
        }
        
        public DataTable ADS_SOTHAM_DUONGSU_GETBY(decimal vDONID,decimal vIsSoTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsSoTham",vIsSoTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }

        public DataTable ADS_THULY_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),                                                                        
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS.GET_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }

        public DataTable ADS_DUONGSU_KHANGCAO(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_DS.GET_DUONGSU_KHANGCAO", parameters);
            return tbl;
        }


        public DataTable ADS_PHUCTHAM_DUONGSU_GETBY(decimal vDONID, decimal vIsPhucTham)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vIsPhucTham",vIsPhucTham),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_DUONGSU_GETBY", parameters);
            return tbl;
        }
        public string ADS_DUONGSU_GETNAMEBYKHANGCAO(decimal vKhangCaoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vKhangCaoID",vKhangCaoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string TenNguoiKC = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DUONGSU_GETNAMEBYKHANGCAO", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TenNguoiKC = tbl.Rows[0]["TENDUONGSU"].ToString();
            }
            return TenNguoiKC;
        }
        public DataTable ADS_DON_DUONGSU_NGUYENDON(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_DON_DUONGSU_NGUYENDON", parameters);
            return tbl;
        }
    }
}