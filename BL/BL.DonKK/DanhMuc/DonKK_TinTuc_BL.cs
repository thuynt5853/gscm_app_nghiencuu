using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.DonKK.DanhMuc
{
    public class DonKK_TinTuc_BL
    {
        //CHuoi connection den DB Donkhoikien
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        public DataTable SearchTopByLoai( int soluong, int TrangThai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("SoLuong", soluong),
                                                                        new OracleParameter("Trang_Thai", TrangThai),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_TinTuc_GetTop", parameters);
            return tbl;
        }
        
        public DataTable GetTopByGroupCM(int soluong, string ma_chuyen_muc)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("SoLuong", soluong),
                                                                        new OracleParameter("ma_chuyen_muc", ma_chuyen_muc),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_TinTuc_GetTopByGroup", parameters);
            return tbl;
        }
        public DataTable GetTopByGroupCMID(int soluong, Decimal cmID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("SoLuong", soluong),
                                                                        new OracleParameter("vChuyenmucID", cmID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_TINTUC_GETTOPBYCM", parameters);
            return tbl;
        }
        public DataRow GetInfo(Decimal curr_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("curr_id", curr_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_TinTuc_GetInfo", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return tbl.Rows[0];
            else
                return null;
        }
        public DataTable GetAllPaging(string tukhoa, decimal chuyenmucID, decimal trangthai, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("TuKhoa",tukhoa),
                                                                        new OracleParameter("chuyenmuc_vID", chuyenmucID),
                                                                        new OracleParameter("TrangThai", trangthai),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_TINTUC_GetAllPaging", parameters);
            return tbl;
        }
    }
}