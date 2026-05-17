using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_DON_XULY_BL
    {
        public DataTable GetByDonID(decimal donID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_XULY_GETBYDONID", parameters);
            return tbl;
        }
        public DataTable GetTinhTrangVuViec(decimal vu_viec_id)
        {
            string ma_loai = ENUM_LOAIAN.AN_PHASAN;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_viec_id",vu_viec_id),
                                                                        new OracleParameter("ma_loai_vu_viec",ma_loai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_Don_GetTinhTrang", parameters);
            return tbl;
        }
        public DataTable CHECK_APS_DON_DUONGSU_ANPHI(decimal? DONID, decimal? DONCHITIETID, decimal ISDONCHITIET)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID", DONID),
                new OracleParameter("vDONCHITIETID", DONCHITIETID),
                new OracleParameter("vISDONCHITIET", ISDONCHITIET),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.CHECK_APS_DON_DUONGSU_ANPHI", prm);
        }

        public DataTable CHECK_APS_DON_DUONGSU_ANPHI_V2(decimal? DONID, decimal? DONCHITIETID, decimal ISDONCHITIET)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID", DONID),
                new OracleParameter("vDONCHITIETID", DONCHITIETID),
                new OracleParameter("vISDONCHITIET", ISDONCHITIET),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.CHECK_APS_DON_DUONGSU_ANPHI_V2", prm);
        }
        
        public bool DEL_DON_YCBS_GETBYDONID(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_YCBS.DEL_DON_YCBS_GETBYDONID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["vID"].Value = ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        
        public DataTable GET_DON_YCBS_GETBYDONID(decimal ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID", ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT_YCBS.GET_DON_YCBS_GETBYDONID", prm);
        }
        
        public DataTable APS_GETALL_DON_YCBS(decimal donID, decimal donYCBS_ID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("CurrDonID",donID),
                new OracleParameter("DonYCBS_ID",donYCBS_ID),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_YCBS.APS_DON_YCBS_GETBYDONID", parameters);
            return tbl;
        }
    }
}