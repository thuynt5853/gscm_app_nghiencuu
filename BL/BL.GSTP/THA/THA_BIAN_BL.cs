using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace BL.GSTP.THA
{
    public class THA_BIAN_BL
    {
        public DataTable GetAnHSTrongHeThong(Decimal toaan_ID, string ma_bi_an, string ten_bi_an, string ma_vu_an, string ten_vu_an, string so_ban_an, DateTime? ngaybanan,decimal trangthai, int? TRANGTHAIGQ, string socmnd, string tungay, string denngay, decimal PageIndex, decimal PageSize)
        {
            if (ngaybanan == DateTime.MinValue) ngaybanan = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("toa_an_id",toaan_ID),
                                                                        new OracleParameter("ma_bi_an",ma_bi_an),
                                                                        new OracleParameter("ten_bi_an",ten_bi_an),
                                                                        new OracleParameter("ma_vu_an",ma_vu_an),
                                                                        new OracleParameter("ten_vu_an",ten_vu_an),
                                                                        new OracleParameter("so_ban_an",so_ban_an),
                                                                        new OracleParameter("ngay_ban_an",ngaybanan),
                                                                        new OracleParameter("P_TRANGTHAI",trangthai),
                                                                        new OracleParameter("TRANGTHAIGQ",TRANGTHAIGQ),
                                                                        new OracleParameter("SOCMND",socmnd),
                                                                        new OracleParameter("V_TUNGAY",tungay),
                                                                        new OracleParameter("V_DENNGAY",denngay),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_BiAn_GetAnHSTrongHT_Paging", parameters);
            return tbl;
        }

        public DataTable GetAnHSNgoaiHeThong(Decimal toaan_ID, string ma_bi_an, string ten_bi_an, string ma_vu_an, string ten_vu_an, string so_ban_an, DateTime? ngaybanan, decimal trangthai, int? TRANGTHAIGQ, string socmnd, string tungay, string denngay, decimal PageIndex, decimal PageSize)
        {
            if (ngaybanan == DateTime.MinValue) ngaybanan = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("toa_an_id",toaan_ID),
                                                                        new OracleParameter("ma_bi_an",ma_bi_an),
                                                                        new OracleParameter("ten_bi_an",ten_bi_an),
                                                                        new OracleParameter("ma_vu_an",ma_vu_an),
                                                                        new OracleParameter("ten_vu_an",ten_vu_an),
                                                                        new OracleParameter("so_ban_an",so_ban_an),
                                                                        new OracleParameter("ngay_ban_an",ngaybanan),
                                                                        new OracleParameter("P_TRANGTHAI",trangthai),
                                                                        new OracleParameter("TRANGTHAIGQ",TRANGTHAIGQ),
                                                                        new OracleParameter("SOCMND",socmnd),
                                                                        new OracleParameter("V_TUNGAY",tungay),
                                                                        new OracleParameter("V_DENNGAY",denngay),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_BiAn_GetAnNgoaiHT", parameters);
            return tbl;
        }

        public DataTable GetAnHSTrongHeThongChonBiAn(Decimal toaan_ID, string ma_bi_an, string ten_bi_an, string ma_vu_an, string ten_vu_an, string so_ban_an, DateTime? ngaybanan, decimal PageIndex, decimal PageSize)
        {
            if (ngaybanan == DateTime.MinValue) ngaybanan = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("toa_an_id",toaan_ID),
                                                                        new OracleParameter("ma_bi_an",ma_bi_an),
                                                                        new OracleParameter("ten_bi_an",ten_bi_an),

                                                                        new OracleParameter("ma_vu_an",ma_vu_an),
                                                                        new OracleParameter("ten_vu_an",ten_vu_an),
                                                                        new OracleParameter("so_ban_an",so_ban_an),
                                                                        new OracleParameter("ngay_ban_an",ngaybanan),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA.GetBiAnTrongTHA", parameters);
            return tbl;
        }

        public DataTable GetAnHSNgoaiHeThongChonBiAn(Decimal toaan_ID, string ma_bi_an, string ten_bi_an, string ma_vu_an, string ten_vu_an, string so_ban_an, DateTime? ngaybanan, decimal PageIndex, decimal PageSize)
        {
            if (ngaybanan == DateTime.MinValue) ngaybanan = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("toa_an_id",toaan_ID),
                                                                        new OracleParameter("ma_bi_an",ma_bi_an),
                                                                        new OracleParameter("ten_bi_an",ten_bi_an),

                                                                        new OracleParameter("ma_vu_an",ma_vu_an),
                                                                        new OracleParameter("ten_vu_an",ten_vu_an),
                                                                        new OracleParameter("so_ban_an",so_ban_an),
                                                                        new OracleParameter("ngay_ban_an",ngaybanan),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA.GetBiAnNgoaiTHA", parameters);
            return tbl;
        }

        public DataTable GetByVuAn_Paging(string textsearch, decimal vuan_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("textsearch",textsearch),
                                                                        new OracleParameter("vuan_id",vuan_id),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_BIAN_GetByVuAnPaging", parameters);
            return tbl;
        }
        public DataRow GetInfo(decimal bian_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_bian_id",bian_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_BIAN_GetInfo", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return tbl.Rows[0];
            else return null;
        }

        public DataTable GetAllByVuAn_RemoveBiCaoID(Decimal vu_an_id, Decimal curr_bicao_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curr_bicao_id",curr_bicao_id),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_BICAO_GetAll_RemoveCurrID", parameters);
            return tbl;
        }

        public decimal GETNEWTT(decimal ToaAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_BiAn_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }

        public DataTable GET_THA_BIAN_QUYETDINH_ANPHAT(decimal bianID, decimal vuanId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("p_bian_id", bianID),
                                                                        new OracleParameter("p_vuan_id", vuanId),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.GET_THA_BIAN_QUYETDINH_ANPHAT", parameters);
            return tbl;
        }

        public DataTable THA_PT_BANAN_BICAO_GETBYVUANID(decimal bi_an_id, decimal vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("bi_an_id",bi_an_id),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_PT_BANAN_BICAO_GETBYVUANID", parameters);
            return tbl;
        }

        /// <summary>
        /// v_QDID: 1: Quyết định thi hành án, 2: Quyết định xóa án tích, 939: Quyết định tạm đình chỉ chấp hành phạt tù, 2638: Quyết định tha tù trước thời hạn có điều kiện, 938: Quyết định hoãn thi hành hình phạt tù
        /// </summary>
        /// <param name="vID"></param>
        /// <param name="v_QDID"></param>
        /// <returns></returns>
        public string CHECK_THA_BIAN_DONGBO(decimal v_THA_BIAN_ID, decimal v_QDID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_THA_BIAN_ID", OracleDbType.Int64) { Value = v_THA_BIAN_ID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_QDID", OracleDbType.Int64) { Value = v_QDID, Direction = ParameterDirection.Input },
                };
                string dbl = Cls_Comon.ExcuteProcResultString("PKG_DVCQG_DLDCQG_THA.CHECK_THA_BIAN_DONGBO", parameters);
                return dbl;
            }
            catch (Exception ex) { return string.Empty; }
        }

        public bool CHECK_THA_BIAN_BICAO_DONGBO(decimal v_BICAO_ID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_BICAO_ID", OracleDbType.Int64) { Value = v_BICAO_ID, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.CHECK_THA_BIAN_BICAO_DONGBO", parameters);
                return dbl >= 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_THA_BIAN_DONGBO_BY_VUANID(decimal v_VUANID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_VUANID", OracleDbType.Int64) { Value = v_VUANID, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_DVCQG_DLDCQG_THA.CHECK_THA_BIAN_DONGBO_BY_VUANID", parameters);
                return dbl >= 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
    }
}