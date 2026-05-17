using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Configuration;
using Newtonsoft.Json;
using DAL.GSTP;
using System.Collections.Generic;

namespace BL.GSTP.DLQGC12
{
    public class DLQGC12_BL
    {
        public DataTable GetAHNPaging_Search_DaDongBo_ThuHoi(string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN, string V_TRANGTHAIDONGBO
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
                        new OracleParameter("V_TRANGTHAIDONGBO",V_TRANGTHAIDONGBO),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHN.EXT_SEARCH_ALL_DaDongBo_ThuHoi", parameters);
            return tbl;
        }

        public DataTable GetAllPaging_Search_All(string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH
            , string v_toaan_id, string v_Capxx, string v_ten_vu_an, string v_toidanh
            , string v_ma_vu_an, string v_bi_can, string v_cccd
            , string v_so_qd, string V_TUNGAY, string V_DENNGAY
            , string v_thamphan_id, string v_thuky_id
            , string V_TRANGTHAI_GUI, string V_NGAYGUI_TU, string V_NGAYGUI_DEN, string v_CheckNullKHOBAQD, string v_DONID
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
                new OracleParameter("v_DONID",v_DONID),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG_AHN.EXT_SEARCH_ALL", parameters);
            return tbl;
        }

        public DataTable GetDulieuChon_DaDongBO(string V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DonBoID",V_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.GET_BAQD_DaDongBo_BY_ID", parameters);
            return tbl;
        }

        public DataTable GetDulieu_LichSuChuyen(string V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DongBoID",V_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_DLDCQG.GET_BAQD_LichSuChuyen", parameters);
            return tbl;
        }

        public bool Insert_DuLieu_DongBo(Model_DongBoDuLieu_KHOBAQD obj)
        {
            string json = JsonConvert.SerializeObject(obj.DUONGSU);

            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("v_DONID", OracleDbType.Int64) { Value = obj.DONID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LINHVUC", OracleDbType.Varchar2) { Value = obj.LINHVUC, Direction = ParameterDirection.Input },
                    new OracleParameter("v_CAPXX", OracleDbType.Int64) { Value = obj.CAPXX, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIBAQD", OracleDbType.Int64) { Value = obj.LOAIBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_IDBAQD", OracleDbType.Int64) { Value = obj.IDBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_QUANHEPHAPLUATID", OracleDbType.Int64) { Value = obj.QUANHEPHAPLUATID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOBAQD", OracleDbType.Varchar2) { Value = obj.SOBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYBAQD", OracleDbType.Date) { Value = obj.NGAYBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYHIEULUCBAQD", OracleDbType.Date) { Value = obj.NGAYHIEULUCBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MACQ", OracleDbType.Varchar2) { Value = obj.MACQ, Direction = ParameterDirection.Input },
                    new OracleParameter("v_COQUANQD", OracleDbType.Varchar2) { Value = obj.COQUANQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TAIKHOANTAO", OracleDbType.Varchar2) { Value = obj.TAIKHOANTAO, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MAVANBAN", OracleDbType.Varchar2) { Value = obj.MAVANBAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TOAANID", OracleDbType.Varchar2) { Value = obj.TOAANID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_DSBAQDLIENQUAN", OracleDbType.Varchar2) { Value = obj.DSBAQDLIENQUAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOTHULY", OracleDbType.Varchar2) { Value = obj.SOTHULY, Direction = ParameterDirection.Input },
                    new OracleParameter("v_THAMPHAN", OracleDbType.Varchar2) { Value = obj.THAMPHAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQDHN", OracleDbType.Varchar2) { Value = obj.LOAIQDHN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRANGTHAIBAQD", OracleDbType.Int32) { Value = obj.TRANGTHAIBAQD, Direction = ParameterDirection.Input },
    
                    // Tham số CLOB cần đặc biệt chú ý
                    new OracleParameter("P_Json", OracleDbType.Clob) { Value = json, Direction = ParameterDirection.Input }

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.INSERT_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool Insert_DuLieu_DuongSu_DongBo(List<KHOBAQD_DUONGSU> listDuongSu, string v_KHOBAQDID, string TAIKHOANTAO)
        {
            string json = JsonConvert.SerializeObject(listDuongSu);

            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                   new OracleParameter("v_KHOBAQDID", OracleDbType.Int64) { Value = v_KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_TAIKHOANTAO", OracleDbType.Varchar2) { Value = TAIKHOANTAO, Direction = ParameterDirection.Input },
                    // Tham số CLOB cần đặc biệt chú ý
                    new OracleParameter("P_Json", OracleDbType.Clob) { Value = json, Direction = ParameterDirection.Input }

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.INSERT_DULIEU_DUONGSU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public DataTable GetPagingLichSuDuLieuDongBo(string p_KHOBAQDID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_KHOBAQDID",p_KHOBAQDID),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_KHOBAQD.GET_LICH_SU_DULIEU_DONGBO", parameters);
            return tbl;
        }

        public DataTable GetPagingDuongSuDongBo(string p_KHOBAQDID, string p_DONID, string p_LINHVUC, string search, string p_TRANGTHAIDONGBO, string p_capxx, string p_loaibaqd, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_KHOBAQDID",p_KHOBAQDID),
                new OracleParameter("p_DONID",p_DONID),
                new OracleParameter("p_LINHVUC",p_LINHVUC),
                new OracleParameter("p_Search",search),
                new OracleParameter("p_TRANGTHAIDONGBO",p_TRANGTHAIDONGBO),
                new OracleParameter("p_capxx",p_capxx),
                new OracleParameter("p_loaibaqd",p_loaibaqd),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_KHOBAQD.GET_PAGING_DUONGSU_DONGBO", parameters);
            return tbl;
        }

        public bool ThuHoiDuLieuDaDongBo(string KHOBAQDID, string TAIKHOANTAO, string LyDo)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_TAIKHOANTAO", OracleDbType.Varchar2) { Value = TAIKHOANTAO, Direction = ParameterDirection.Input },
                    new OracleParameter("p_LYDO", OracleDbType.Varchar2) { Value = LyDo, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.THUHOI_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool ThuHoiDuLieuDuongsu(string KHOBAQDID, string TAIKHOANTAO, string LyDo, string p_DUONGSUID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_TAIKHOANTAO", OracleDbType.Varchar2) { Value = TAIKHOANTAO, Direction = ParameterDirection.Input },
                    new OracleParameter("p_LYDO", OracleDbType.Varchar2) { Value = LyDo, Direction = ParameterDirection.Input },
                    new OracleParameter("p_DUONGSUID", OracleDbType.Int64) { Value = p_DUONGSUID, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.THUHOI_DULIEU_DUONGSU", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool GuiLaiDuLieuDaDongBo(string KHOBAQDID, Model_DongBoDuLieu_KHOBAQD obj, string TAIKHOANTAO)
        {
            try
            {
                string json = JsonConvert.SerializeObject(obj.DUONGSU);

                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    // Tham số CLOB cần đặc biệt chú ý
                    new OracleParameter("v_DONID", OracleDbType.Int64) { Value = obj.DONID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LINHVUC", OracleDbType.Varchar2) { Value = obj.LINHVUC, Direction = ParameterDirection.Input },
                    new OracleParameter("v_CAPXX", OracleDbType.Int64) { Value = obj.CAPXX, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIBAQD", OracleDbType.Int64) { Value = obj.LOAIBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_IDBAQD", OracleDbType.Int64) { Value = obj.IDBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_QUANHEPHAPLUATID", OracleDbType.Int64) { Value = obj.QUANHEPHAPLUATID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOBAQD", OracleDbType.Varchar2) { Value = obj.SOBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYBAQD", OracleDbType.Date) { Value = obj.NGAYBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_NGAYHIEULUCBAQD", OracleDbType.Date) { Value = obj.NGAYHIEULUCBAQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MACQ", OracleDbType.Varchar2) { Value = obj.MACQ, Direction = ParameterDirection.Input },
                    new OracleParameter("v_COQUANQD", OracleDbType.Varchar2) { Value = obj.COQUANQD, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TAIKHOANTAO", OracleDbType.Varchar2) { Value = obj.TAIKHOANTAO, Direction = ParameterDirection.Input },
                    new OracleParameter("v_MAVANBAN", OracleDbType.Varchar2) { Value = obj.MAVANBAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TOAANID", OracleDbType.Varchar2) { Value = obj.TOAANID, Direction = ParameterDirection.Input },
                    new OracleParameter("v_DSBAQDLIENQUAN", OracleDbType.Varchar2) { Value = obj.DSBAQDLIENQUAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_SOTHULY", OracleDbType.Varchar2) { Value = obj.SOTHULY, Direction = ParameterDirection.Input },
                    new OracleParameter("v_THAMPHAN", OracleDbType.Varchar2) { Value = obj.THAMPHAN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_LOAIQDHN", OracleDbType.Varchar2) { Value = obj.LOAIQDHN, Direction = ParameterDirection.Input },
                    new OracleParameter("v_TRANGTHAIBAQD", OracleDbType.Int32) { Value = obj.TRANGTHAIBAQD, Direction = ParameterDirection.Input },
    
                    // Tham số CLOB cần đặc biệt chú ý
                    new OracleParameter("P_Json", OracleDbType.Clob) { Value = json, Direction = ParameterDirection.Input }
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.GUILAI_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool GuiLaiDuLieuDuongSu(string KHOBAQDID, string TAIKHOANTAO, string DUONGSUID, List<KHOBAQD_DUONGSU> listDuongSu)
        {
            try
            {
                string json = JsonConvert.SerializeObject(listDuongSu);

                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_TAIKHOANTAO", OracleDbType.Varchar2) { Value = TAIKHOANTAO, Direction = ParameterDirection.Input },
                    new OracleParameter("p_KHOBAQDID_NEW", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_DUONGSUID", OracleDbType.Int64) { Value = DUONGSUID, Direction = ParameterDirection.Input },
                    new OracleParameter("P_Json", OracleDbType.Clob) { Value = json, Direction = ParameterDirection.Input }
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.GUILAI_DULIEU_DUONGSU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool HuyChuyenDuLieuDuongSu(string KHOBAQDID, string p_KHOBAQDID_OLD, string DUONGSUID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                    new OracleParameter("p_KHOBAQDID_OLD", OracleDbType.Int64) { Value = p_KHOBAQDID_OLD, Direction = ParameterDirection.Input },
                    new OracleParameter("p_DUONGSUID", OracleDbType.Int64) { Value = DUONGSUID, Direction = ParameterDirection.Input },

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.HUYCHUYEN_DULIEU_DUONGSU", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool HuyChuyenDuLieuDaDongBo(string KHOBAQDID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("p_KHOBAQDID", OracleDbType.Int64) { Value = KHOBAQDID, Direction = ParameterDirection.Input },
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_KHOBAQD.HUYCHUYEN_DULIEU_DONGBO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        /// <summary>
        /// Lấy dữ liệu kho đồng bộ
        /// </summary>
        /// <param name="V_ID"></param>
        /// <returns></returns>

        public string GetRandomMaDongBo()
        {
            using (OracleConnection conn = Cls_Comon.OpenConnection())
            {
                using (OracleCommand cmd = new OracleCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = "BEGIN :ret := PKG_DVCQG_DLDCQG.CREATE_MA_DONGBO_RANDOM; END;";
                    cmd.CommandType = CommandType.Text;

                    var returnValue = new OracleParameter("ret", OracleDbType.Varchar2, 255)
                    {
                        Direction = ParameterDirection.ReturnValue
                    };

                    cmd.Parameters.Add(returnValue);

                    cmd.ExecuteNonQuery();

                    return returnValue.Value?.ToString() ?? "NULL";
                }
            }
        }
    }
}