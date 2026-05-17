using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_SOTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable AHS_NguoiTGTT_GetAllPaging(decimal vu_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_NguoiTGTT_GetByVuAnID", parameters);
            return tbl;
        }
        public DataTable AHS_NTGTT_GetByVuAnID(decimal vu_an_id,string GiaiDoan, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("GiaiDoan",GiaiDoan),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_NTGTT_GetByVuAnID", parameters);
            return tbl;
        }
        public DataTable AHS_NTGTT_GetByVuAnID_PT(decimal vu_an_id, string GiaiDoan, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("GiaiDoan",GiaiDoan),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_EXT.AHS_NTGTT_GetByVuAnID", parameters);
            return tbl;
        }
        public DataTable AHS_NTGTT_GetCheckList(decimal VuAnID,string GiaiDoanVuAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVuAnID",VuAnID),
                new OracleParameter("GiaiDoan",GiaiDoanVuAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_NTGTT_GetCheckList", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_HDXX_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVuAnID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_ST_QD_BICAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_QD_BICAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_ST_QD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_QD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_BANAN_CHITIET(decimal vVUANID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVUANID",vVUANID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_KHANGCAO_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_KHANGCAO_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_KCaoKNghi_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_KCaoKNghi_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_SoTham_GetAllKCByVuAn(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_GetAllKCByVuAn", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_GetAllKNByVuAn(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_GetAllKNByVuAn", parameters);
            return tbl;
        }
        public DataTable AHS_ST_KCKN_TinhTrang_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_KCKN_TinhTrang_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_SOTHAM_KHANGNGHI_GETLIST(decimal vVuAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }

        public decimal CheckSoTLTheoLoaiAn(decimal donviID, string loaian, decimal isThanhNien, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",isThanhNien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoThuLy", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return Convert.ToDecimal(tbl.Rows[0][0]);
            else return 0;
        }
        public decimal GET_STL_NEW_HS(decimal donviID, string loaian, decimal isThanhNien, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",isThanhNien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STL_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public DataTable GetAllBiCan_bihai_sotham(decimal vVuAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAM_GetAllBiCanBiCao", parameters);
            return tbl;
        }

        public DataTable AHS_ST_BAQD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_ST_BAQD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST", parameters);
            return tbl;
        }

    }
}