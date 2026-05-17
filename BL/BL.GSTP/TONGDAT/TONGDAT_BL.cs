using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;


namespace BL.GSTP.TONGDAT
{
    public class TONGDAT_BL
    {
        GSTPContext dt = new GSTPContext();
        public void TONGDAT_DELETE_ERROR(string V_DONID, string V_LOAIAN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_TONGDAT.TONGDAT_DELETE_ERROR", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DONID"].Value = V_DONID;
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
            
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch
            {
                tran.Rollback();
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable Get_All_VANBANTONGDAT(string v_toaan_id, string V_LOAIAN_ID, string v_ten_vu_an, string VanBANTD
            , string v_so_qd, string v_ngay_qd, string TrangThaiTD, string vHinhthucTD
            , string v_bi_can, string v_thuky_id, string v_thamphan_id
            , string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN

            , string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY
            , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_VanBANTD", VanBANTD),
                        new OracleParameter("v_So_VB", v_so_qd),
                        new OracleParameter("v_Ngay_VB", v_ngay_qd),
                        new OracleParameter("v_TrangThaiTD",TrangThaiTD),
                        new OracleParameter("v_HinhthucTD",vHinhthucTD),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),

                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),

                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),

                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_VANTHU_TONGDAT.SEARCH_ALL_VANBANTONGDAT", parameters);
            return tbl;
        }

        public DataTable DM_BIEUMAU_TONGDAT_GETALL(decimal loaivuviec)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CURR_LOAIVUVIEC",loaivuviec),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_VANTHU_TONGDAT.DM_BIEUMAU_TONGDAT_GETALL", parameters);
            return tbl;
        }

        public DataTable GET_VANTHU_TONGDAT_GETLIST(decimal vDONID, decimal vToaAnID, decimal vLoaian, decimal vBieuMauID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("vDONID",vDONID),
                                                                      new OracleParameter("vToaAnID",vToaAnID),
                                                                      new OracleParameter("vLoaian",vLoaian),
                                                                      new OracleParameter("vBieuMauID",vBieuMauID),
                                                                      new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_VANTHU_TONGDAT.VANTHU_TONGDAT_GETLIST", parameters);
            return tbl;
        }

        public DataTable FILE_TONGDAT(decimal vTongDatID,decimal vLoaian,decimal VuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vTongDatID",vTongDatID),
                                                                        new OracleParameter("vLoaian",vLoaian),
                                                                        new OracleParameter("vVuAnID",VuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_VANTHU_TONGDAT.ALL_FILE_TONGDAT", parameters);
            return tbl;
        }

        public DataTable TONGDAT_DOITUONG_GETBY(decimal vVuAnID,decimal vLoaian, decimal vToaAnID, decimal vBieuMauID, decimal vIsOnlyNKK)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("vLoaian",vLoaian),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vBieuMauID",vBieuMauID),
                                                                        new OracleParameter("vIsOnlyNKK",vIsOnlyNKK),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_VANTHU_TONGDAT.TONGDAT_DOITUONG_GETBY", parameters);
            return tbl;
        }

        public DataTable GET_BM_TONGDAT(decimal vDonID, decimal vLoaiAn, decimal vMaGiaiDoan)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vLoaiAn", vLoaiAn),
                new OracleParameter("vMaGiaiDoan", vMaGiaiDoan),
                new OracleParameter("vDonID", vDonID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.GET_BM_TONGDAT", parameters);
            return tbl;
        }

        public DataTable GET_LYDO_THUHOI(decimal vLoaiAn, decimal vTongDatID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vLoaiAn", vLoaiAn),
                new OracleParameter("vTongDatID", vTongDatID),
                new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT.GET_LYDO_THUHOI", parameters);
            return tbl;
        }

        public void BAN_AN_ST_INSERT_BIEUMAU_TONGDAT(decimal loaiAn, decimal toaAnID, decimal donID, decimal maGD, decimal loaiFile, string nguoiTao)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vLoaiAn", loaiAn),
                        new OracleParameter("vToaAnID", toaAnID),
                        new OracleParameter("vDonID", donID),
                        new OracleParameter("vMaGiaiDoan", maGD),
                        new OracleParameter("vLoaiFile", loaiFile),
                        new OracleParameter("vNguoiTao", nguoiTao)
                        };
            Cls_Comon.GetTableByProcedurePaging("PKG_STPT_TONGDAT_BIEUMAU.BAN_AN_ST_ADD_BIEUMAU_TONGDAT", parameters);
        }
        public bool TONGDAT_DOITUONG_VNID(decimal V_ID, String V_LOAIAN, String V_NGAYNHANTONGDAT)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_TONGDAT_BIEUMAU.TONGDAT_DOITUONG_VNID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = V_ID;         
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
            comm.Parameters["V_NGAYNHANTONGDAT"].Value = V_NGAYNHANTONGDAT;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
