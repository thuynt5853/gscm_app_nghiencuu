using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class PCTP_BL
    {
        public decimal PCTP_TPGQD_PHANCONGNGAUNHIEN(decimal vToaAnID, DateTime vNgayPhanCong, decimal vChanhAnID, decimal vNguoithuchien, DateTime vFromDate, DateTime vToDate,string vChucDanh)
        {
         
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vNgayPhanCong",vNgayPhanCong),
                new OracleParameter("vChanhAnID",vChanhAnID),
                new OracleParameter("vNguoithuchien",vNguoithuchien),
                new OracleParameter("vFromDate",OracleDbType.Date,vFromDate,ParameterDirection.Input),
                new OracleParameter("vToDate",OracleDbType.Date,vToDate,ParameterDirection.Input),
                new OracleParameter("vChucDanh",vChucDanh )
            };             
            return Cls_Comon.ExcuteProcResult("PKG_PCTP.TPGQD_PHANCONGNGAUNHIEN", prm);
        }

        public DataTable PCTP_TPGQD_CHUAPHANCONG(decimal vToaAnID, DateTime vNgayPhanCong, decimal vChanhAnID, DateTime vFromDate, DateTime vToDate)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vNgayPhanCong",vNgayPhanCong),
                new OracleParameter("vChanhAnID",vChanhAnID),
                new OracleParameter("vFromDate",OracleDbType.Date,vFromDate,ParameterDirection.Input),
                new OracleParameter("vToDate",OracleDbType.Date,vToDate,ParameterDirection.Input),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_PCTP.TPGQD_CHUAPHANCONG", prm);
        }
        public DataTable PCTP_TPGQD_LICHSUPHANCONG(decimal vToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_PCTP.TPGQD_LICHSUPHANCONG", prm);
        }
        public DataTable PCTP_TPGQD_DAPHANCONG(decimal vToaAnID, decimal vKetQuaID )
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("vKetQuaID",vKetQuaID),
                new OracleParameter("vToaAnID",vToaAnID),               
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_PCTP.TPGQD_DAPHANCONG", prm);
        }
        public DataTable PCTP_CANBO_GETBYDONVI(decimal donviID,string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_PCTP.CANBO_GETBYDONVI", parameters);
            return tbl;
        }
     
    }
}