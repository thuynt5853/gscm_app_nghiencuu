using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.TP_THADS
{
    public class TUPHAP_ANPHI_BL
    {
        public byte[] File_Attach_Anphi_Return(String V_LOAI_AN,Decimal V_ANPHI_ID, ref String _FILE_NAME) //get data blob
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI.GET_ANPHI_FILE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_ANPHI_ID"].Value = V_ANPHI_ID;
            comm.Parameters["V_FILE_NAME"].Direction = ParameterDirection.Output;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Cls_Comon.Get_Blob_File(comm, "FILE_DATA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _FILE_NAME = Convert.ToString(comm.Parameters["V_FILE_NAME"].Value);//get name file
                conn.Close();
            }
        }
        public byte[] Get_Thongbao_Ap_File_Return(String V_LOAI_AN, Decimal V_FILEID, ref String V_TENFILE) //get data blob
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI.GET_THONGBAO_AP_FILE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_FILEID"].Value = V_FILEID;
            comm.Parameters["V_TENFILE"].Direction = ParameterDirection.Output;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Cls_Comon.Get_Blob_File(comm, "NOIDUNG");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                V_TENFILE = Convert.ToString(comm.Parameters["V_TENFILE"].Value);//get name file
                conn.Close();
            }
        }      
        public bool ANPHI_FILE_UPD(string V_LOAIAN, decimal V_ANPHI_ID, string V_FILE_NAME, byte[] V_FILE_DATA, string V_FILE_TYLE, string V_ACTION)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI.ANPHI_FILE_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
            comm.Parameters["V_ANPHI_ID"].Value = V_ANPHI_ID;
            comm.Parameters["V_FILE_NAME"].Value = V_FILE_NAME;
            comm.Parameters["V_FILE_DATA"].Value = V_FILE_DATA;
            comm.Parameters["V_FILE_TYLE"].Value = V_FILE_TYLE;
            comm.Parameters["V_ACTION"].Value = V_ACTION;
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
        public bool ANPHI_FILE_UPD_XOA(string V_LOAIAN, decimal V_ANPHI_ID,string V_ACTION,ref Decimal V_COUNT_TL)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI.ANPHI_FILE_UPD_XOA", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
            comm.Parameters["V_ANPHI_ID"].Value = V_ANPHI_ID;           
            comm.Parameters["V_ACTION"].Value = V_ACTION;
            comm.Parameters["V_COUNT_TL"].Direction = ParameterDirection.Output;
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
                V_COUNT_TL = Convert.ToDecimal(comm.Parameters["V_COUNT_TL"].Value);
                conn.Close();
            }
        }
        public byte[] File_Attach_Return(String V_MA_THONGBAO, ref String _FILE_NAME) //get data blob
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.GET_FILE_ATTACH", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_MA_THONGBAO"].Value = V_MA_THONGBAO;
            comm.Parameters["V_FILE_NAME"].Direction = ParameterDirection.Output;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Cls_Comon.Get_Blob_File(comm, "FILE_ATTACH");//FILE_ATTACH: paramerter column of table attach 
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _FILE_NAME = Convert.ToString(comm.Parameters["V_FILE_NAME"].Value);//get name file
                conn.Close();
            }
        }
        public DataTable GET_URL_DVC_THANHTOAN(String DVCQG_TT_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_DVCQG_TT_ID",DVCQG_TT_ID),
                new OracleParameter("ITEMS_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI_DVCQG.GET_URL_DVC_THANHTOAN", parameters);
            return tbl;
        }
    }
}