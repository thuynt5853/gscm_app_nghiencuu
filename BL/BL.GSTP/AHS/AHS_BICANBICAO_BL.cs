using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_BICANBICAO_BL
    {
        public DataTable GetAllByVuAnID(decimal vuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vu_an_id",vuAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BiCan_GetAllByVuAn", parameters);
            return tbl;
        }
        public DataTable GetAllPaging(Decimal vu_an_id,string textsearch, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("textsearch", textsearch),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BICANBICAO_GetByVuAnID", parameters);
            return tbl;
        }

        public DataTable GetAllByVuAnId_ThuLyPT(decimal VuAnId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vu_an_id",VuAnId),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BICANBICAO_GETBYVUANID_THULYPT", parameters);
            return tbl;
        }

        public DataTable GetAllByVuAn_RemoveBiCaoID(Decimal vu_an_id,Decimal curr_bicao_id,  decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curr_bicao_id",curr_bicao_id),                                                                        
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BICAO_GetAll_RemoveCurrID", parameters);
            return tbl;
        }
        
        public DataTable AHS_BICANBICAO_GetListByVuAn(decimal vuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVuAnID",vuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BICANBICAO_GetListByVuAn", parameters);
            return tbl;
        }
       
        
        public DataTable GetToiDanh_BiCanDauVu(decimal vuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vu_an_id",vuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BiCan_GetToiDanhBiCanDauVu", parameters);
            return tbl;
        }
        
        public DataTable CountBiCaoTheoTinhTrangGiamGiu(decimal vuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vu_an_id",vuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BICAO_CountBCByTinhTrang", parameters);
            return tbl;
        }
        public string AHS_BICANBICAO_GetNameByKhangCao(decimal vKhangCaoID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vKhangCaoID",vKhangCaoID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string TenNguoiKC = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BCBC_GetNameByKhangCao", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                TenNguoiKC = tbl.Rows[0]["HOTEN"].ToString();
            }
            return TenNguoiKC;
        }
        public DataTable GetAllBiCan_bihai_Sotham(decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuan_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TOANCAU_STPT_EXT.AHS_ST_BICAO_GETALL", parameters);
            return tbl;
        }
        public DataTable AHS_DON_BICANBICAO_THAMGIATOTUNG(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_DON_BICANBICAO_THAMGIATOTUNG", parameters);
            return tbl;
        }
    }

}