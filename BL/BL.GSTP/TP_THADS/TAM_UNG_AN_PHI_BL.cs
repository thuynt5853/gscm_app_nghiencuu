using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class TAM_UNG_AN_PHI_BL
    {
        public DataTable GetAll_AnPhi_Search(String V_TRANG_THAI,String V_FILE_THA, String V_GET_CHIL, String V_LOAI_AN, String V_TT_TRUCTUYEN, string _DATE_FROM, string _DATE_TO, string _STATUS, string _USERNAME, string _DONVITHA_ID, string vTuKhoaBasic, decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("V_TRANG_THAI",V_TRANG_THAI),
                new OracleParameter("V_FILE_THA",V_FILE_THA),
                new OracleParameter("V_GET_CHIL",V_GET_CHIL),
                new OracleParameter("V_LOAI_AN",V_LOAI_AN),
                new OracleParameter("V_TT_TRUCTUYEN",V_TT_TRUCTUYEN),
                new OracleParameter("V_DATE_FROM",_DATE_FROM),
                new OracleParameter("V_DATE_TO",_DATE_TO),
                new OracleParameter("V_STATUS",_STATUS),
                new OracleParameter("V_USERNAME",_USERNAME),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID),
                new OracleParameter("vTuKhoaBasic",vTuKhoaBasic),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI.TC_DANHSACH_ANPHI", parameters);
            return tbl;
        }

        public DataTable GetAll_AnPhi_QLTA(String V_FILE_THA, String V_GET_CHIL, String V_LOAI_AN, String V_TT_TRUCTUYEN, string _DATE_FROM, string _DATE_TO, string _STATUS, string _USERNAME, string _DONVITHA_ID, string vTuKhoaBasic, decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_FILE_THA",V_FILE_THA),
                new OracleParameter("V_GET_CHIL",V_GET_CHIL),
                new OracleParameter("V_LOAI_AN",V_LOAI_AN),
                new OracleParameter("V_TT_TRUCTUYEN",V_TT_TRUCTUYEN),
                new OracleParameter("V_DATE_FROM",_DATE_FROM),
                new OracleParameter("V_DATE_TO",_DATE_TO),
                new OracleParameter("V_STATUS",_STATUS),
                new OracleParameter("V_USERNAME",_USERNAME),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID),
                new OracleParameter("vTuKhoaBasic",vTuKhoaBasic),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI.TC_DANHSACH_ANPHI_QLTA", parameters);
            return tbl;
        }

        public DataTable Get_DONID_AnPhi(string V_MA_THONGBAO, string _MALOAIVUVIEC, string _USERNAME, decimal V_DONID, string V_DS_ID, string V_DS_IDS)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                  new OracleParameter("V_MA_THONGBAO",V_MA_THONGBAO),
                 new OracleParameter("V_MALOAIVUVIEC",_MALOAIVUVIEC),
                 new OracleParameter("V_USERNAME",_USERNAME),
                new OracleParameter("V_DONID",V_DONID),
                new OracleParameter("V_DS_ID",V_DS_ID),
                new OracleParameter("V_DS_IDS",V_DS_IDS)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI.LOAD_EDIT", parameters);
            return tbl;
        }
        public DataTable GetAll_AnPhi_Search_DS(String V_GET_CHIL, String V_LOAI_AN, String V_TT_TRUCTUYEN, string _DATE_FROM, string _DATE_TO, string _STATUS, string _USERNAME, string _DONVITHA_ID, string vTuKhoaBasic, decimal PageIndex, decimal PageSize)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_GET_CHIL",V_GET_CHIL),
                new OracleParameter("V_LOAI_AN",V_LOAI_AN),
                new OracleParameter("V_TT_TRUCTUYEN",V_TT_TRUCTUYEN),
                new OracleParameter("V_DATE_FROM",_DATE_FROM),
                new OracleParameter("V_DATE_TO",_DATE_TO),
                new OracleParameter("V_STATUS",_STATUS),
                new OracleParameter("V_USERNAME",_USERNAME),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID),
                new OracleParameter("vTuKhoaBasic",vTuKhoaBasic),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI.TC_DANHSACH_ANPHI_IN_DS", parameters);
            return tbl;
        }
        public DataTable Get_ThongBaoSoLuong(string _USERNAME, string _DONVITHA_ID)
        {

            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_USERNAME",_USERNAME),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID)

            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI_GET.GET_SOLUONG", parameters);
            return tbl;
        }
        public DataTable GetAll_report(String V_TT_TRUCTUYEN, string v_Names, Decimal _OPTIONS, string _DATE_FROM, string _DATE_TO, string _DONVITHA_ID, string _CAP_THA)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_TT_TRUCTUYEN",V_TT_TRUCTUYEN),
                new OracleParameter("v_Names",v_Names),
                new OracleParameter("V_OPTIONS",_OPTIONS),
                new OracleParameter("V_DATE_FROM",_DATE_FROM),
                new OracleParameter("V_DATE_TO",_DATE_TO),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID),
                new OracleParameter("V_CAP_THA",_CAP_THA)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_REPORT.GET_REPORT_THADS", parameters);
            return tbl;
        }
        public DataTable GetThongTinBaoCaoSuDungBienLaiAnPhi(String V_TT_TRUCTUYEN, string v_Names, Decimal _OPTIONS, string _DATE_FROM, string _DATE_TO, string _DONVITHA_ID, string _CAP_THA)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_TT_TRUCTUYEN",V_TT_TRUCTUYEN),
                new OracleParameter("v_Names",v_Names),
                new OracleParameter("V_OPTIONS",_OPTIONS),
                new OracleParameter("V_DATE_FROM",_DATE_FROM),
                new OracleParameter("V_DATE_TO",_DATE_TO),
                new OracleParameter("V_DONVITHA_ID",_DONVITHA_ID),
                new OracleParameter("V_CAP_THA",_CAP_THA)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_REPORT.GET_BAOCAO_BIENLAIANPHI", parameters);
            return tbl;
        }
        public DataTable Create_Sobienlai_app(decimal V_DONVITHA_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_DONVITHA_ID",V_DONVITHA_ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI.CREATE_SOBIENLAI_APP", parameters);
            return tbl;
        }
        public bool GET_SOLUONG_JOB(String V_USERNAME,String V_DONVITHA_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_JOB.GET_SOLUONG_JOB_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USERNAME"].Value = V_USERNAME;
            comm.Parameters["V_DONVITHA_ID"].Value = V_DONVITHA_ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}