using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace BL.GSTP.DLQGC12
{
    public class DLQGC12_AHS_BL
    {

        #region xử lý án hình sự
        public DataTable GetAllPaging_Search_All(string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN,string v_CheckNullKHOBAQD,string v_VUANID
            , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                new OracleParameter("v_BAQD_id",v_BAQD_id),
                new OracleParameter("v_KHANGCAOQH",v_KHANGCAOQH),

                new OracleParameter("v_toaan_id", v_toaan_id),
                new OracleParameter("v_Capxx",v_Capxx),
                new OracleParameter("v_ten_vu_an",v_ten_vu_an),

                new OracleParameter("v_toidanh",v_toidanh),
                new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                new OracleParameter("v_bi_can",v_bi_can),
                new OracleParameter("v_cccd",v_cccd),
                new OracleParameter("v_so_qd",v_so_qd),
                new OracleParameter("V_TUNGAY",V_TUNGAY),
                new OracleParameter("V_DENNGAY",V_DENNGAY),
                new OracleParameter("v_thamphan_id",v_thamphan_id),
                new OracleParameter("v_thuky_id",v_thuky_id),
                new OracleParameter("V_TRANGTHAI_GUI",V_TRANGTHAI_GUI),
                new OracleParameter("V_NGAYGUI_TU",V_NGAYGUI_TU),
                new OracleParameter("V_NGAYGUI_DEN",V_NGAYGUI_DEN),
                new OracleParameter("v_CheckNullKHOBAQD",v_CheckNullKHOBAQD),
                new OracleParameter("v_VUANID",v_VUANID),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.EXT_SEARCH_ALL", parameters);
            return tbl;
        }

        public DataTable GetAllPaging_DaDongBo_ThuHoi(string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN, string V_TRANGTHAIDONGBO
            , decimal PageIndex, decimal PageSize)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                new OracleParameter("v_BAQD_id",v_BAQD_id),
                new OracleParameter("v_KHANGCAOQH",v_KHANGCAOQH),

                new OracleParameter("v_toaan_id", v_toaan_id),
                new OracleParameter("v_Capxx",v_Capxx),
                new OracleParameter("v_ten_vu_an",v_ten_vu_an),

                new OracleParameter("v_toidanh",v_toidanh),
                new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                new OracleParameter("v_bi_can",v_bi_can),
                new OracleParameter("v_cccd",v_cccd),
                new OracleParameter("v_so_qd",v_so_qd),
                new OracleParameter("V_TUNGAY",V_TUNGAY),
                new OracleParameter("V_DENNGAY",V_DENNGAY),
                new OracleParameter("v_thamphan_id",v_thamphan_id),
                new OracleParameter("v_thuky_id",v_thuky_id),
                new OracleParameter("V_TRANGTHAI_GUI",V_TRANGTHAI_GUI),
                new OracleParameter("V_NGAYGUI_TU",V_NGAYGUI_TU),
                new OracleParameter("V_NGAYGUI_DEN",V_NGAYGUI_DEN),
                new OracleParameter("V_TRANGTHAIDONGBO",V_TRANGTHAIDONGBO),

                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.EXT_SEARCH_ALL_DaDongBo_ThuHoi", parameters);
                return tbl;
            }
            catch (Exception ex)
            {

                throw;
            }
            
        }

        public DataTable GET_BICANBICAO_BY_BAQDID(string v_BAQD_id, string v_LOAIBAQD, string v_Capxx)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_BAQD_id",v_BAQD_id),
                new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                new OracleParameter("v_Capxx",v_Capxx),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.GET_BICANBICAO_BY_BAQDID", parameters);
            return tbl;
        }

        public DataTable GET_TOIDANH_BY_BICAO(decimal vBiCaoId, string capxx, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vbicaoid", vBiCaoId),
                         new OracleParameter("v_capxx", capxx),
                        new OracleParameter("v_loaiba_qd", loaiBanAnQd),
                        new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.get_toidanh_by_bicao", parameters);
            return tbl;
        }

        public DataTable GET_HINHPHAT_BY_TOIDANH_BICAO(decimal vbicaoid, decimal toiDanhId, string capxx, string loaiBanAnQd)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vBiCanId", vbicaoid),
                         new OracleParameter("v_toidanhId", toiDanhId),
                          new OracleParameter("v_capxx", capxx),
                            new OracleParameter("v_loaiba_qd", loaiBanAnQd),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.get_hinhphat_by_toidanh_bicao", parameters);
            return tbl;
        }

        public DataTable GET_PAGING_BICANBICAO_BY_BAQDID(string v_BAQD_id, string v_LOAIBAQD, string v_Capxx, string v_trangthai, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_BAQD_id",v_BAQD_id),
                new OracleParameter("v_LOAIBAQD",v_LOAIBAQD),
                new OracleParameter("v_Capxx",v_Capxx),
                new OracleParameter("v_trangthai",v_trangthai),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHS.GET_PAGING_BICANBICAO_BY_BAQDID", parameters);
            return tbl;
        }
        #endregion
    }
}