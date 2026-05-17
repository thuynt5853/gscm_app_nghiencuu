using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_QD_LOAI_BL
    {
        public DataTable Search(string textsearch, int IsHieuLuc, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("textsearch",textsearch), 
                new OracleParameter("vHieuLuc",IsHieuLuc),
                new OracleParameter("PageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_QD_LOAI_Search", prm);
        }
    }

    public class DM_QD_QUYETDINH_BL
    {
        public DataTable DM_QD_QUYETDINH_SEARCH(decimal LoaiQdID, string TextKey, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("LoaiQdID",LoaiQdID),
                new OracleParameter("TextKey",TextKey),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_QD_QUYETDINH_SEARCH", prm);
        }
        public DataTable DM_QD_QUYETDINH_LYDO_SEARCH(decimal QdID, string TextKey, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("QdID",QdID),
                new OracleParameter("TextKey",TextKey),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_QD_QUYETDINH_LYDO_SEARCH", prm);
        }
        public DataTable DM_QD_QUYETDINH_GETByLOAIQD(decimal LoaiQD, string LoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vLOAIQD",LoaiQD),
                new OracleParameter("vLOAIAN",LoaiAn),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_QD_QUYETDINH_GETByLOAIQD", prm);
        }
    }
}