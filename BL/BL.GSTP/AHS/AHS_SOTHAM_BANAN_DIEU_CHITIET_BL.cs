using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_SOTHAM_BANAN_DIEU_CHITIET_BL
    {
        public DataTable GetAllPaging(decimal bi_can_id, decimal ban_an_id, decimal bo_luat_id
                                     , string curr_textsearch
                                    , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("bo_luat_id",bo_luat_id)
                                                                        , new OracleParameter("curr_textsearch",curr_textsearch)

                                                                        
                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnST_DieuCT_GetAll", parameters);
            return tbl;
        }
        
        public DataTable GetHinhPhat(decimal ban_an_id, decimal bi_can_id, decimal toi_danh_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("toi_danh_id",toi_danh_id)
                                                                        ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnST_GetHinhPhat", parameters);
            return tbl;
        }
        public DataTable TongHopToiDanhSoTham(decimal ban_an_id, decimal bi_can_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("CurrBanAnID",ban_an_id)
                                                                      , new OracleParameter("CurrBiCanID", bi_can_id)
                                                                      ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_TongHopToiDanhSoTham", parameters);
            return tbl;
        }
        
        public DataTable GetAllHinhPhatByDK(decimal ban_an_id, decimal bi_can_id, decimal toi_danh_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("toi_danh_id",toi_danh_id)
                                                                        ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnST_GetFullHinhPhat", parameters);
            return tbl;
        }
        public DataTable GetByDK(decimal ban_an_id, decimal nhom_hp, decimal bi_can_id, decimal toi_danh_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                           new OracleParameter("ban_an_id",ban_an_id)
                                                                           , new OracleParameter("nhom_hp",nhom_hp)
                                                                        , new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("toi_danh_id",toi_danh_id)
                                                                        ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnST_DieuCT_GetByDK", parameters);
            return tbl;
        }

        /// <summary>
        /// Lay tat ca hinh phat theo bananID
        /// </summary>
        /// <param name="ban_an_id"></param>
        /// <param name="loai">=0-->all, =1-->lay loai=2,1, = 2-->loai = 1,4</param>
        /// <returns></returns>
        public DataTable GetByBanAnID(decimal ban_an_id, decimal loai)
        {
            //loai = 0--> lay tat
            //; =1--> lay loai=2,3
            //; =2-->lay loai=1,4
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("ban_an_id",ban_an_id)
                                                                    , new OracleParameter("loai",loai)
                                                                    , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_STHP_GetHPTheoAnID_LoaiHP", parameters);
            return tbl;
        }
        public DataTable GetTHHinhPhatCoHieuLucTHA(decimal vuanid, decimal bicaoid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("vu_an_id",vuanid)
                                                                    , new OracleParameter("bi_cao_id",bicaoid)
                                                                    , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_BA_GetTHHinhPhatTHA", parameters);
            return tbl;
        }
        public DataTable GET_TONG_SO_TOI(String VBANANID, String VBICANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("VBANANID",VBANANID)
                                                                    , new OracleParameter("VBICANID",VBICANID)
                                                                    , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.GET_TONG_SO_TOI", parameters);
            return tbl;
        }

        public DataTable GetToiDanh_To_TDC(decimal bi_can_id, decimal ban_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BANANST_DIEUCT_TO_ISMAIN", parameters);
            return tbl;
        }
    }
}