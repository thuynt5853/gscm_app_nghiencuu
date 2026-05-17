using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.DONGHEP
{
    public class DONGHEP_BL
    {
        public DataTable Don_GETLIST(decimal vToaanId,string vMavuviec,string vTenvuviec,string vNguoikhoikien,string vCmnd,string vNamsinh,string vNguoibikien,string vNoidungkhoikien,string vmaloaian,decimal pageindex,decimal page_size)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaanId",vToaanId),
                                                                        new OracleParameter("vMavuviec",vMavuviec),
                                                                        new OracleParameter("vTenvuviec",vTenvuviec),
                                                                        new OracleParameter("vNguoikhoikien",vNguoikhoikien),
                                                                        new OracleParameter("vCmnd",vCmnd),
                                                                        new OracleParameter("vNamsinh",vNamsinh),
                                                                        new OracleParameter("vNguoibikien",vNguoibikien),
                                                                        new OracleParameter("vNoidungkhoikien",vNoidungkhoikien),
                                                                        new OracleParameter("vmaloaian",vmaloaian),
                                                                        new OracleParameter("pageindex",pageindex),
                                                                        new OracleParameter("page_size",page_size),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.Don_GETLIST", parameters);
            return tbl;
        }


        public DataTable GetDonGhep(decimal vToaanId, decimal IdDon, decimal LoaiAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaanId",vToaanId),
                                                                        new OracleParameter("IdDon",IdDon),
                                                                        new OracleParameter("LoaiAn",LoaiAn),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.GetDonGhep", parameters);
            return tbl;
        }

        public DataTable GetDonGhepDonKC(decimal vToaanId, decimal IdDon, decimal LoaiAnId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaanId",vToaanId),
                                                                        new OracleParameter("IdDon",IdDon),
                                                                        new OracleParameter("LoaiAnId",LoaiAnId),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.GetDonGhepDonKC", parameters);
            return tbl;
        }

        public DataTable GetDonGhepDonKC_DUONGSUID(decimal vToaanId, decimal IdDon, decimal IdDuongSu, decimal LoaiAnId, decimal pageindex, decimal page_size)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaanId",vToaanId),
                                                                        new OracleParameter("IdDon",IdDon),
                                                                        new OracleParameter("IdDuongSu",IdDuongSu),
                                                                        new OracleParameter("LoaiAnId",LoaiAnId),
                                                                        new OracleParameter("pageindex",pageindex),
                                                                        new OracleParameter("page_size",page_size),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.GetDonGhepDonKC_DUONGSUID", parameters);
            return tbl;
        }

        public DataTable GetDonGhepDonKC_BiAnID(decimal vToaanId, decimal IdDon, decimal IdBiAn, decimal LoaiAnId, decimal pageindex, decimal page_size)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaanId",vToaanId),
                                                                        new OracleParameter("IdDon",IdDon),
                                                                        new OracleParameter("IdBiAn",IdBiAn),
                                                                        new OracleParameter("LoaiAnId",LoaiAnId),
                                                                        new OracleParameter("pageindex",pageindex),
                                                                        new OracleParameter("page_size",page_size),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.GetDonGhepDonKC_BiAnID", parameters);
            return tbl;
        }

        //public DataTable GetDonGhepXuLy(decimal vToaanId, decimal IdDon, decimal LoaiAnId)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                                new OracleParameter("vToaanId",vToaanId),
        //                                                                new OracleParameter("IdDon",IdDon),
        //                                                                new OracleParameter("LoaiAnId",LoaiAnId),
        //                                                                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DON_GHEP.GetDonGhepXuLy", parameters);
        //    return tbl;
        //}
    }
}