using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;
using System.Globalization;

namespace BL.GSTP
{
    public class GDTTT_DON_BL
    {
        GSTPContext dt = new GSTPContext(); CultureInfo cul = new CultureInfo("vi-VN");
        public bool IN_UP_VANTHU_V_NULL_CC(string V_DON_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_CC.UP_VANTHU_V_NULL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DON_ID"].Value = V_DON_ID;
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
        public bool ARR_DON_ID_UP(string V_DON_ID, string V_DON_ID_CURR)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TP.ARR_DON_ID_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DON_ID"].Value = V_DON_ID;
            comm.Parameters["V_DON_ID_CURR"].Value = V_DON_ID_CURR;
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
        public bool ARR_DONTRUNGID_UP(string V_DONTRUNGID, string V_DON_ID, string V_CD_TA_TRANGTHAI, string V_ISTHULY, string V_CD_LOAI)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TP.ARR_DONTRUNGID_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_CD_LOAI"].Value = V_CD_LOAI;
            comm.Parameters["V_DONTRUNGID"].Value = V_DONTRUNGID;
            comm.Parameters["V_DON_ID"].Value = V_DON_ID;
            comm.Parameters["V_CD_TA_TRANGTHAI"].Value = V_CD_TA_TRANGTHAI;
            comm.Parameters["V_ISTHULY"].Value = V_ISTHULY;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public bool SET_THAMPHAN_THULYLAI(string V_DONTRUNGID, string V_DON_ID, string V_CD_TA_TRANGTHAI, string V_ISTHULY)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TP.SET_THAMPHAN_THULYLAI", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DONTRUNGID"].Value = V_DONTRUNGID;
            comm.Parameters["V_DON_ID"].Value = V_DON_ID;
            comm.Parameters["V_CD_TA_TRANGTHAI"].Value = V_CD_TA_TRANGTHAI;
            comm.Parameters["V_ISTHULY"].Value = V_ISTHULY;
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
        public void GET_KETQUA_GQ(string V_DONTRUNGID, ref string V_GQD_LOAIKETQUA)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand cmd = new OracleCommand("PKG_GDTTT_TP.GET_KETQUA_GQ", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(cmd);
            cmd.Parameters["V_GQD_LOAIKETQUA"].Direction = ParameterDirection.Output;
            cmd.Parameters["V_DONTRUNGID"].Value = V_DONTRUNGID;
            try
            {
                cmd.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                V_GQD_LOAIKETQUA = cmd.Parameters["V_GQD_LOAIKETQUA"].Value + "";
                conn.Close();
            }
        }
        public decimal TLXXGDT_GETMAXTT(decimal v_ToaAnID, decimal vYear, string vLoaian)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vYear", vYear),
                                    new OracleParameter("vLoaian", vLoaian)

                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.TLXXGDT_GETMAXTT", parameters);
                return dbl + 1;
            }
            catch (Exception ex) { return 0; }
        }


        public void SO_THULY_RETURN(String V_TOAANID, String V_LOAI_VB, String V_BAQD_LOAIAN, ref Decimal V_SOTL)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_CC.SO_THU_LY", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_SOTL"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_LOAI_VB"].Value = V_LOAI_VB;
            comm.Parameters["V_BAQD_LOAIAN"].Value = V_BAQD_LOAIAN;
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
                V_SOTL = Convert.ToDecimal(comm.Parameters["V_SOTL"].Value);
                conn.Close();
            }
        }
        public bool INS_UP_TRUNG_CC(string V_DON_TRUNG, string V_DONID_MOI, string V_LOAIAN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_CC.INS_UP_TRUNG", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DON_TRUNG"].Value = V_DON_TRUNG;
            comm.Parameters["V_DONID_MOI"].Value = V_DONID_MOI;
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
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
        public DataTable GDTTT_SUACONGVAN_SEARCH(decimal vToaAnID, string vSoCongVan, string vNgayCongVan)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.SUACONGVAN_SEARCH", parameters);
            return tbl;
        }
        public DataTable GDTTT_QLSOVB_SEARCH(decimal vToaAnID, decimal vPhongbanID, decimal v_ISDONVI, string vUSERID, string vLoaiSO, string vSoVB,
                                         string vNgayVB, string vNgayVB_den, decimal vLoaiAn, decimal PageSize, decimal PageIndex)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                                                        new OracleParameter("vISDONVI", v_ISDONVI),
                                                                        new OracleParameter("vUSERID", vUSERID),
                                                                        new OracleParameter("vLoaiSO",vLoaiSO),
                                                                        new OracleParameter("vSoVB",vSoVB),
                                                                        new OracleParameter("vNgayVB",vNgayVB),
                                                                        new OracleParameter("vNgayVB_den",vNgayVB_den),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP", parameters);
            return tbl;
        }

        public DataTable GDTTT_QLSOVBVAKN_SEARCH(decimal vToaAnID, decimal vPhongbanID, decimal v_ISDONVI, string vUSERID, string vLoaiSO, string vSoVB,
                                         string vNgayVB, string vNgayVB_den, decimal vLoaiAn, decimal PageSize, decimal PageIndex)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                                                        new OracleParameter("vISDONVI", v_ISDONVI),
                                                                        new OracleParameter("vUSERID", vUSERID),
                                                                        new OracleParameter("vLoaiSO",vLoaiSO),
                                                                        new OracleParameter("vSoVB",vSoVB),
                                                                        new OracleParameter("vNgayVB",vNgayVB),
                                                                        new OracleParameter("vNgayVB_den",vNgayVB_den),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.QUANLYSOVB_VUANKN", parameters);
            return tbl;
        }

        public DataTable GDTTT_SUASOVB_SEARCH(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.SUAVANBAN_SEARCH", parameters);
            return tbl;
        }

        public DataTable GDTTT_SUASOVBVAKN_SEARCH(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.SUAVANBANVAKN_SEARCH", parameters);
            return tbl;
        }

        public DataTable GDTTT_SUASOVBVAKN_HCTP_SEARCH(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.SUAVANBANVAKN_HCTP_SEARCH", parameters);
            return tbl;
        }

        public DataTable CHECK_GDTTT_SUASOVB(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.DON_CVCHUYEN_CHECK", parameters);
            return tbl;
        }

        public DataTable CHECK_GDTTT_SUASOVBVAKN(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.VAKN_CVCHUYEN_CHECK", parameters);
            return tbl;
        }

        public DataTable CHECK_GDTTT_SUASOVBVAKN_HCTP(decimal vSOPHATHANH_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vSOPHATHANH_ID",vSOPHATHANH_ID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.VAKN_CHECK_CHUYEN_TPTC", parameters);
            return tbl;
        }

        public bool CHECK_DON_LUUSO(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, decimal vDONID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("vDONID", vDONID)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_DON_LUUSO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public bool CHECK_DON_LUUSO_CANHAN(decimal vToaAnID, decimal vPhongbanID, decimal vUSERID, string vLoaiSO, decimal vDONID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vUSERID", vUSERID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("vDONID", vDONID)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_DON_LUUSO_CANHAN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public bool CHECK_SOVANBAN_CANHAN(decimal vToaAnID, decimal vPhongbanID, decimal vUSERID, string vLoaiSO, string v_SOVB, string v_NGAYVB)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vUSERID", vUSERID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_SOVANBAN_CANHAN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public DataTable GET_THAMPHAN(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, string arrDonid, string v_SOVB, string v_NGAYVB)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("arrDonid",arrDonid),
                                    new OracleParameter("v_SOTOTRINH", v_SOVB),
                                    new OracleParameter("v_NGAYTOTRINH", v_NGAYVB),
                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GET_THAMPHAN", parameters);
            return tbl;
        }

        public DataTable GET_TBTP_SOVANBAN(decimal vToaAnID, decimal vPhongbanID, string vMASO, decimal vThamphanid, string vDonid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("vMASO",vMASO),
                                        new OracleParameter("vThamphanid",vThamphanid),
                                        new OracleParameter("vDonid",vDonid),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GET_TBTP_SOVANBAN", parameters);
            return dbl;

        }

        public DataTable GET_DON_SOVANBAN(decimal vToaAnID, decimal vPhongbanID, string vMASO, string vDonid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("vMASO",vMASO),
                                        new OracleParameter("vDonid",vDonid),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GET_DON_SOVANBAN", parameters);
            return dbl;

        }
        public DataTable Get_SOTOTRINH_DON(decimal vToaAnID, decimal vPhongbanID, string arrDonid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("arrDonid",arrDonid),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_DON", parameters);
            return dbl;
        }
        public DataTable GET_SOTOTRINH_SOVB(decimal vToaAnID, decimal vPhongbanID, string vLoaiso, string vSOVB, decimal vYear)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("vLoaiso",vLoaiso),
                                        new OracleParameter("vSOVB",vSOVB),
                                        new OracleParameter("vYear",vYear),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GET_SOTOTRINH_SOVB", parameters);
            return dbl;

        }

        public bool CHECK_SOVANBAN(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, string v_SOVB, string v_NGAYVB)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_SOVANBAN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public decimal CHECK_TOTRINH(decimal v_ToaAnID, decimal vPhongbanID, decimal vDonid, string vMASO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vDonid", vDonid),
                                    new OracleParameter("vMASO", vMASO),

                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_SOTOTRINH_DON", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal CHECK_TOTRINH_TLL(decimal v_ToaAnID, decimal vPhongbanID, decimal vDonid)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vDonid", vDonid)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_SOTOTRINH_DON_TLL", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal CHECK_SOVB_DON(String V_MASO, decimal v_ToaAnID, decimal vPhongbanID, decimal vDonid)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("V_MASO", V_MASO),
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vDonid", vDonid)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.CHECK_SOVB_DON", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public bool SOPHATHANH_DON_INSERT(decimal v_SOPHATHANH_ID, decimal v_DONID, string V_NGUOITAO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID) ,
                                    new OracleParameter("v_DONID", v_DONID),
                                    new OracleParameter("V_NGUOITAO", V_NGUOITAO)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOPHATHANH_DON_INSERT", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }


        public decimal SOVANBAN_INSERT(decimal v_ToaAnID, decimal v_PhongbanID, decimal v_ISDONVI, string v_ThamphanID,
            string v_MASO, string v_SOVB, string v_NGAYVB, string v_NGUOIKY, string v_CHUCVU, string V_NGUOITAO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_ToaAnID", v_ToaAnID),
                                    new OracleParameter("v_PhongbanID", v_PhongbanID),
                                    new OracleParameter("v_ISDONVI", v_ISDONVI),
                                    new OracleParameter("v_ThamphanID", v_ThamphanID),
                                    new OracleParameter("v_MASO", v_MASO),
                                    new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB),
                                    new OracleParameter("v_NGUOIKY", v_NGUOIKY),
                                    new OracleParameter("v_CHUCVU", v_CHUCVU),
                                    new OracleParameter("V_NGUOITAO", V_NGUOITAO)

                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOVANBAN_INSERT", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }
        public bool SOVANBAN_UPDATE(decimal v_SOPHATHANH_ID,
                    //string v_SOVB, 
                    string v_NGAYVB, string v_NGUOIKY, string v_CHUCVU, string V_NGUOISUA)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID),
                                   // new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB),
                                    new OracleParameter("v_NGUOIKY", v_NGUOIKY),
                                    new OracleParameter("v_CHUCVU", v_CHUCVU),
                                    new OracleParameter("V_NGUOISUA", V_NGUOISUA)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOVANBAN_UPDATE", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool SOVANBANVAKN_UPDATE(decimal v_SOPHATHANH_ID,
                    string v_NGAYVB, string v_NGUOIKY, string v_CHUCVU, string V_NGUOISUA)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB),
                                    new OracleParameter("v_NGUOIKY", v_NGUOIKY),
                                    new OracleParameter("v_CHUCVU", v_CHUCVU),
                                    new OracleParameter("V_NGUOISUA", V_NGUOISUA)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.SOVANBANVAKN_UPDATE", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool DELETE_ALL_SOVANBAN(decimal v_SOPHATHANH_ID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOVANBAN_DEL_ALL", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool DELETE_ALL_SOVANBANVAKN(decimal v_SOPHATHANH_ID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.SOVANBANVAKN_DEL_ALL", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool DELETE_ONE_SOVANBAN(decimal vDON_ID, decimal v_SOPHATHANH_ID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_DON_ID", vDON_ID),
                    new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID)

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOVANBAN_DEL_ONE", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool DELETE_ONE_SOVANBANVAKN(decimal vDON_ID, decimal v_SOPHATHANH_ID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID", vDON_ID),
                    new OracleParameter("v_SOPHATHANH_VUGIAMDOC_ID", v_SOPHATHANH_ID)

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.SOVANBANVAKN_DEL_ONE", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }
        public bool SOVANBAN_XOATHEO_MA(decimal vDON_ID, String V_MASO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_DON_ID", vDON_ID),
                    new OracleParameter("V_MASO", V_MASO)

                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.SOVANBAN_XOATHEO_MA", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public void CHECK_DONTRUNGID_RETURN(Decimal V_ID, ref Decimal V_IS_DONTRUNG)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand cmd = new OracleCommand("PKG_GDTTT_HCTP_APP.CHECK_DONTRUNGID", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(cmd);
            cmd.Parameters["V_ID"].Value = V_ID;
            cmd.Parameters["V_IS_DONTRUNG"].Direction = ParameterDirection.Output;
            try
            {
                cmd.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                V_IS_DONTRUNG = Convert.ToDecimal(cmd.Parameters["V_IS_DONTRUNG"].Value);
                conn.Close();
            }
        }
        public void CHECK_ARR_DON_RETURN(Decimal V_ID, ref Decimal V_IS_DONTRUNG)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand cmd = new OracleCommand("PKG_GDTTT_HCTP_APP.CHECK_DONTRUNGID_ARR", conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(cmd);
            cmd.Parameters["V_ID"].Value = V_ID;
            cmd.Parameters["V_IS_ARR_DON_ID"].Direction = ParameterDirection.Output;
            try
            {
                cmd.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                V_IS_DONTRUNG = Convert.ToDecimal(cmd.Parameters["V_IS_ARR_DON_ID"].Value);
                conn.Close();
            }
        }
        public DataTable GDTTT_DON_SEARCH(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
           String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
           string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.ISTPB3" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,NULL IS_SHOW_DC,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB" +
                     ",ctc.THAMPHANID THAMPHANTCID, tptc.hoten AS THAMPHANTC_TEN, ctc.TRANGTHAICHUYENTP AS TRANGTHAICHUYENTP_TC, to_char(ctc.NGAYCHUYENTP,'dd/MM/yyyy hh24:mi:ss') AS NGAYCHUYENTP" +
                     ",sphTT.SOVB TOTRINH_VAKN, to_char(sphTT.NGAYVB,'dd/MM/yyyy') AS NGAYTOTRINH_VAKN, sphTB.SOVB TBTP_VAKN, to_char(sphTB.NGAYVB,'dd/MM/yyyy') NGAYTBTP_VAKN, chucdanh.MA CHUCDANH "
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }

                SQL += " from GDTTT_DON d ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
           /*
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTralaidon')SoTralaidon on SoTralaidon.donid = d.id   " +
          */
           "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + vToaAnID + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +

            "left join (select ID, HOTEN, CHUCDANHID from DM_CANBO) c on d.THAMPHANID=c.ID " +
            "left join (select ID, MA from DM_DATAITEM) chucdanh on c.CHUCDANHID = chucdanh.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Đã chuyển','Chưa chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc  where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +

            //lấy thông tin TPTC được phân công cho vụ án kháng nghị
            "LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on va.ID = ctc.VUANID and ctc.TRANGTHAI = 2 and NVL(ctc.THAMPHANID, 0) <> 0 " + // ctc.TRANGTHAI = 2 là HCTP đã nhận vụ án kháng nghị
            "LEFT JOIN DM_CANBO tptc ON tptc.id = ctc.THAMPHANID " +
            "LEFT JOIN (SELECT sp.VUANID, spgd.SOVB, spgd.NGAYVB FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 " + //ISDONVI = 1 là sổ của HCTP
            "           WHERE spgd.MASO = 'SoTT') sphTT ON va.ID = sphTT.VUANID " +
            "LEFT JOIN (SELECT sp.VUANID, spgd.SOVB, spgd.NGAYVB FROM SOPHATHANH_VUAN sp JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 " + //ISDONVI = 1 là sổ của HCTP
            "           WHERE spgd.MASO = 'TBTP') sphTB ON va.ID = sphTB.VUANID " +

            " where d.TOAANID=" + vToaAnID + " " +
            " AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {   //Dong de anh Hoàng anh xem lại luong vi de nhu cu Tìm kiem tai HCTP dang sai 
                        //if (vTrangthai == 1)
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI in(1,2,4) OR  DTL_NC.TRANGTHAI in(1,2,4) )";
                        //}
                        //else if (vTrangthai == 3)
                        //{
                        //    SQL += " AND ( d.CD_TRANGTHAI in (3,4) AND tralai.ghichu IS NOT NULL )";//30/09/2024
                        //}
                        //else if (vTrangthai == 2)//da chuyen va da nhan 04/10/2024
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI = 2 OR  DTL_NC.TRANGTHAI=2)";
                        //}
                        //else if (vTrangthai == 0)//chưa chuyển
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI IS NULL OR  DTL_NC.TRANGTHAI IS NULL )";
                        //}

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none"; row["IS_SHOW_DC"] = "none";
                        int rs = 0, rs1=0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        String _date3 = "28/01/2026";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                            rs1 = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date3, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs1 = 0; date1 = date3;rs1 > 0; date1 > date3;rs1 < 0; date1 < date3;
                        }
                        if (rs > 0 && rs1<0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        if (rs1 >0)
                        {
                            row["IS_SHOW_DC"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }

                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        //29/01/2026
                        //if (row["TOAANID"] + "" == "1")
                        //{
                        //    if (row["ISTHULY"] + "" == "1")
                        //    {
                        //        row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                        //    }
                        //}
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                    row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                else
                                    row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                            }
                            if (rs1 < 0)
                            {
                                row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            }
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + (Convert.ToString(row["CHUCDANH"]) == "TPBAC3" ? " (TPB3) " : " (TPTC) ") + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        //thêm thông tin TPTC phân công cho VAKN
                        if (row["THAMPHANTC_TEN"] + "" != "")
                        {
                            string info = "<i>Thẩm phán: </i><b>" + row["THAMPHANTC_TEN"] + " (TPTC) " + "</b>" +
                                "(" + row["TOTRINH_VAKN"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["NGAYTOTRINH_VAKN"])
                                + "<b>;</b> " + row["TBTP_VAKN"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYTBTP_VAKN"])
                                + ")<br/>";
                            row["THAMPHANTC_TEN"] = info;
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

        public DataTable GDTTT_DON_SEARCH_FOR_TOATOICAO(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
           String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
           string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     /*
                      ",(SoCVC.SOVB || SoCVCTK.SOVB ||  SoCVCN.SOVB ||  SoTralaidon.SOVB)  SVB_SOCV  " + 
                      ",(SoCVC.NGAYVB || SoCVCTK.NGAYVB ||  SoCVCN.NGAYVB ||  SoTralaidon.NGAYVB)  SVB_NGAYCV" +
                      ",(SoCVC.NGUOIKY || SoCVCTK.NGUOIKY ||  SoCVCN.NGUOIKY ||  SoTralaidon.NGUOIKY)  SVB_NGUOIKY " +
                      */
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB"
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }

                SQL += " from GDTTT_DON d ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
           /*
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTralaidon')SoTralaidon on SoTralaidon.donid = d.id   " +
          */
           "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + vToaAnID + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +

            "left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +
            " where NOT EXISTS ( SELECT 1    FROM GDTTT_CC_TC_MAPPING x    WHERE d.id = x.DONID) " +
            "AND d.TOAANID=" + vToaAnID + " AND d.TOAANID IN (4,5,6)" +
            // -- lấy những án đang giải quyết
            //" AND d.cd_loai = '0' AND " +
            //      "d.vuviecid IS NOT NULL AND d.vuviecid != '' AND d.vuviecid != '0' AND " +
            //      "d.CD_TRANGTHAI = '2' AND " +
            //      "(" +
            //          "(VA.LOAIAN = '1' AND (VA.GQD_LOAIKETQUA IS NULL OR VA.GQD_LOAIKETQUA = '')) " +
            //          "OR " +
            //          "(VA.LOAIAN != '1' AND (VA.GQD_LOAIKETQUA = '5' OR VA.GQD_LOAIKETQUA IS NULL OR VA.GQD_LOAIKETQUA = ''))" +
            //      ")" + " " +
            // -- / lấy những án đang giải quyết

            " AND ((va.GQD_LOAIKETQUA IS  NULL OR va.GQD_LOAIKETQUA = 5) AND (d.CD_LOAI = 0 or d.CD_LOAI IS NULL) ) " +
            " AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {   //Dong de anh Hoàng anh xem lại luong vi de nhu cu Tìm kiem tai HCTP dang sai 
                        //if (vTrangthai == 1)
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI in(1,2,4) OR  DTL_NC.TRANGTHAI in(1,2,4) )";
                        //}
                        //else if (vTrangthai == 3)
                        //{
                        //    SQL += " AND ( d.CD_TRANGTHAI in (3,4) AND tralai.ghichu IS NOT NULL )";//30/09/2024
                        //}
                        //else if (vTrangthai == 2)//da chuyen va da nhan 04/10/2024
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI = 2 OR  DTL_NC.TRANGTHAI=2)";
                        //}
                        //else if (vTrangthai == 0)//chưa chuyển
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI IS NULL OR  DTL_NC.TRANGTHAI IS NULL )";
                        //}

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none";
                        int rs = 0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                        }
                        if (rs > 0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }



                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        if (row["TOAANID"] + "" == "1")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                            }
                        }
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                {
                                    row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                }
                            }
                            row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

        public DataTable GDTTT_DON_SEARCH_CAPCAO_FROM_TOICAO(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
           String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
           string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                     ",txxCC.MA_TEN MA_TEN_TOA_CAP_CAO" + //Them ten toa Cap cao
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB"
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }

                SQL += " from GDTTT_DON d ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + vToaAnID + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxCC on d.TOAANID = txxCC.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +

            "left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102 )DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +
            " where d.TOAANID IN (4,5,6)" +
            " AND  ((va.GQD_LOAIKETQUA IS NOT NULL AND va.GQD_LOAIKETQUA <> 5 AND ( d.CD_LOAI = 0 or d.CD_LOAI IS NULL)) OR (d.CD_LOAI <> 0 AND d.CD_LOAI IS NOT NULL ))" + // --26/07/2025 Đã có kết quả giải quyết
            " AND NVL(d.CD_TA_TRANGTHAI,0)  IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none";
                        int rs = 0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                        }
                        if (rs > 0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }



                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        if (row["TOAANID"] + "" == "1")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                            }
                        }
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                {
                                    row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                }
                            }
                            row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

        public DataTable GDTTT_DON_GETDONTRUNG(decimal V_LOAIDON, decimal v_toaanid, decimal vCurrDonID, string vNguoiGui, string vSoBAQD, string vNgayBAQD, string vToaXetXu, string vCapXetXu, string vIsBanAn)
        {
            try
            {
                OracleParameter[] pr = new OracleParameter[]
                {
                    new OracleParameter("V_LOAIDON",V_LOAIDON),
                    new OracleParameter("v_toaanid",v_toaanid),
                    new OracleParameter("vCurrDonID",vCurrDonID),
                    new OracleParameter("vNguoiGui",vNguoiGui),
                    new OracleParameter("vSoBAQD",vSoBAQD),
                    new OracleParameter("vNgayBAQD",vNgayBAQD),
                    new OracleParameter("vToaXetXu",vToaXetXu),
                    new OracleParameter("vCapXetXu",vCapXetXu),
                    new OracleParameter("vIsBanAn",vIsBanAn),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TP.DON_GETDONTRUNG", pr);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        //-------------------
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAIXULY"] = "Thụ lý mới";
                                row["TL_SO"] = "<br />" + row["TL_SO"];
                                row["TL_NGAY"] = "<br />" + row["TL_NGAY"];
                            }
                            if (row["ISTHULY"] + "" == "2")
                            {
                                row["TRANGTHAIXULY"] = "Đã thụ lý";
                                row["TL_SO"] = "";
                                row["TL_NGAY"] = "";
                            }
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["TRANGTHAIXULY"] = "Đơn chưa đủ điều kiện";
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public DataTable GDTTT_DON_SEARCH_THU_LY_MOI(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),

                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DON_SEARCH_PCHUYEN_TLM", parameters);
            return tbl;
        }

        public string TLXXGDT_GETMAXTT(decimal currDonViID, int year, decimal vLoaian)
        {
            throw new NotImplementedException();
        }

        public DataTable GDTTT_GUI_COQUAN_CHUYENDON(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),

                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.GUI_COQUAN_CHUYENDON", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_SEARCH_TTRINH_PHANCONG(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DON_SEARCH_TTRINH_PHANCONG", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_TP_GIAI_QUYET(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_APP.DON_SEARCH_TP_GIAI_QUYET", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_DS_TL_MOI(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
           string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_APP.DON_SEARCH_DS_TL_MOI", parameters);
            return tbl;
        }

        public DataTable GDTTT_DON_DS_TL_MOI_THAMPHAN(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
         string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
         decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
         string vDiaChiCT, decimal vTraLoidon, decimal vTrangthai,
         decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy,
         string vSoThuly, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, decimal vThamphanID,
         decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vTraLoidon",vTraLoidon),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),

                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vCVPC_So",vCVPC_So),
                new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_APP.DON_SEARCH_DS_TL_MOI_THAMPHAN", parameters);
            return tbl;
        }
        //public DataTable GDTTT_DON_DS_TL_MOI_CC(String ID_USER, string vArrSelectID)
        //{
        //    //OracleParameter[] parameters = new OracleParameter[] {
        //    //                                                      new OracleParameter("USERID",ID_USER),
        //    //                                                      new OracleParameter("vArrSelectID",vArrSelectID),
        //    //                                                      new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //    //                                                          };
        //    //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_APP.DON_SEARCH_DS_DON_TL_MOI", parameters);
        //    //return tbl;
        //}

        public DataTable GDTTT_DON_TRUNG(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
          string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
          decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
          string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
          decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
          decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
          decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_DS.DON_SEARCH_DS_DON_TRUNG", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_CHUYEN_TOA_AN_KHAC(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
         string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
         decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
         string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
         decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
         decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
         , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
         decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_DS.DS_CHUYEN_TOA_AN_KHAC", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_CHUYEN_NGOAI_TOA(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
        string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
        decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
        string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
        decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
        decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
        , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
        decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_DS.DS_CHUYEN_NGOAI_TOA", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_CHUYEN_CQ_QUOC_HOI(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
        string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
        decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
        string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
        decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
        decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
        , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
        decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DS_KQ_DO_Q_HOI", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_DS_DON_CHUA_DU_DK(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
           string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_DS.DS_DON_CHUA_DU_DK", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_SUA_SEARCH(decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn,
            string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                     new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                     new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                     new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                      new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DON_SUA_SEARCH", parameters);
            return tbl;
        }



        public DataTable GDTTT_DON_GETPCTP(decimal vToaAnID, DateTime? vTuNgay, DateTime? vDenNgay,
          decimal vNoiChuyen, decimal vTrangthai, decimal vIsThuLy, string vNguoiNhap, string varrLoaiAn, decimal vHinhThuc,
          DateTime? vNgayTL, string vSoThuLy, string vSoBAQD)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vTuNgay",vTuNgay),
                                        new OracleParameter("vDenNgay",vDenNgay),
                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                        new OracleParameter("vTrangthai",vTrangthai),
                                        new OracleParameter("vIsThuLy",vIsThuLy),
                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                        new OracleParameter("varrLoaiAn",varrLoaiAn),
                                        new OracleParameter("vHinhThuc",vHinhThuc),
                                        new OracleParameter("vNgayTL",vNgayTL),
                                        new OracleParameter("vSoThuLy",vSoThuLy),
                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_GETCHUAPCTP", parameters);
            return tbl;
        }
        public DataTable GDTTT_CONGVAN_SEARCH(decimal vLoaiVuviec, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, DateTime? vTuNgay, DateTime? vDenNgay, string vSoHieuDon, string vDonViGui, string vSoCongVan, string vNgayCongVan, decimal vTraLoi, string vNguoiNhap)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                      new OracleParameter("vDonViGui",vDonViGui),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                            new OracleParameter("vLoaiVuviec",vLoaiVuviec),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CONGVAN_SEARCH", parameters);
            return tbl;
        }

        public decimal GETNEWTT(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public DataTable GDTTT_DON_YKIEN_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_YKIEN_GETLIST", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_CHECKDONTRUNG(string ToaXetXu, string NgayXetXu, string SoBAQD, string NguoiGui, string isBanAn)
        {
            OracleParameter[] pr = new OracleParameter[]
            {
                new OracleParameter("vToaXetXu",ToaXetXu),
                new OracleParameter("vNgayXetXu",NgayXetXu),
                new OracleParameter("vSoBAQD",SoBAQD),
                new OracleParameter("vNguoiGui",NguoiGui),
                new OracleParameter("vIsBanAn",isBanAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_CHECKDONTRUNG", pr);
        }
        public DataTable GDTTT_DON_GETDONTRUNG_CC(decimal V_LOAIDON, decimal v_toaanid, decimal vCurrDonID, string vNguoiGui, string vSoBAQD, string vNgayBAQD, string vToaXetXu, string vCapXetXu, string vIsBanAn)
        {
            OracleParameter[] pr = new OracleParameter[]
            {
                new OracleParameter("V_LOAIDON",V_LOAIDON),
                new OracleParameter("v_toaanid",v_toaanid),
                new OracleParameter("vCurrDonID",vCurrDonID),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vIsBanAn",vIsBanAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.DON_GETDONTRUNG", pr);
        }
        public DataTable GDTTT_DON_GETCONGVAN(string vTenDonVi, string vToaAn, string vSoCongVan, string vNgayCongVan, decimal vIsDVTrongNganh)
        {
            OracleParameter[] pr = new OracleParameter[]
            {
                new OracleParameter("vTenDonVi",vTenDonVi),
                new OracleParameter("vToaAn",vToaAn),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vIsDVTrongNganh",vIsDVTrongNganh),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_GETCONGVAN", pr);
        }
        public decimal PHANCONGNGAUNHIEN(decimal vToaAnID, DateTime vTuNgay, DateTime vDenNgay, string vNguoiNhap, string varrLoaiAn, decimal vNguoithuchien)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                 new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("varrLoaiAn",varrLoaiAn),
                new OracleParameter("vNguoithuchien",vNguoithuchien)
            };
            return Cls_Comon.ExcuteProcResult("PKG_GDTTT.PHANCONGNGAUNHIEN", prm);
        }

        public DataTable DON_GETTHEOKETQUAID(decimal vToaAnID, decimal vKetQuaID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vKetQuaID",vKetQuaID),
                  new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                  new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_GETTHEOKETQUAID", prm);
        }

        public DataTable DON_GETTHEOKETQUAID_EXPORT(decimal vToaAnID, decimal vKetQuaID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vKetQuaID",vKetQuaID),
                  new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                  new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_CC.DON_GETTHEOKETQUAID", prm);
        }
        public DataTable DON_LICHSUPHANCONG(decimal vToaAnID, string vSoTT, string vNgayTT, string vPC_TuNgay, string vPC_DenNgay, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID, string vLoaiPhanCong)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vSoToTrinh",vSoTT),
                new OracleParameter("vNgayToTrinh",vNgayTT),
                new OracleParameter("vPC_TuNgay",vPC_TuNgay),
                new OracleParameter("vPC_DenNgay",vPC_DenNgay),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vLoaiPhanCong",vLoaiPhanCong),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_LICHSUPHANCONG", prm);
        }

        public bool CHECK_DON_XOA_PHANCONG_NGAUNHIEN(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT.CHECK_DON_XOA_PHANCONG_NGAUNHIEN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_DON_XOA_PHANCONG_CHIDINH(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT.CHECK_DON_XOA_PHANCONG_CHIDINH", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_VAKN_XOA_PHANCONG_CHIDINH(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VAKN_XOA_PHANCONG_CHIDINH", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN(decimal vKetQuaId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vKetQuaId", vKetQuaId)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public DataTable GDTTT_NHANDON_SEARCH(decimal vToaAnID, decimal vToaChuyenID, decimal vLoaiAn, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vMaDon, string vSoCongVan, decimal vTrangthai)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaChuyenID",vToaChuyenID),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vMaDon",vMaDon),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_NHAN_SEARCH", parameters);
            return tbl;
        }
        public DataTable LICHSUDON(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.LICHSUDON", prm);
        }
        public DataTable DANHSACHDONTRUNG(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TP.DANHSACHDONTRUNG", prm);
        }
        public DataTable DANHSACHDON_TLL(decimal vID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TP.DANHSACHDON_TLL", prm);
        }
        public DataTable DANHSACHDON_KEMTHEO(decimal vID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TP.DANHSACHDON_KEMTHE0", prm);
        }
        public DataTable DANHSACHDONTHEOID(string varrID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("varrID",varrID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DANHSACHDONTHEOID", prm);
        }
        public DataTable DANHSACHDONTHEOIDS(string varrID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("varrID",varrID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TP.DANHSACHDONTHEOID", prm);
        }
        //public DataTable DANHSACHDONTHEOVuAnID(Decimal VuAnID)
        //{

        //    OracleParameter[] prm = new OracleParameter[]
        //    {
        //        new OracleParameter("vVuAnID",VuAnID),
        //         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
        //    };
        //    return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DANHSACHDONTHEOVuAnID", prm);
        //}
        public DataTable DonAHS_GetAllNguoiKN(Decimal DonID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                  new OracleParameter("vDonID",DonID)
                 ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DonAHS_GetAllNguoiKN", prm);
        }
        public DataTable DANHSACHDONCHIDAO_ByVuAnID(Decimal VuAnID, Decimal trangthai)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                  new OracleParameter("vVuAnID",VuAnID)
                 ,new OracleParameter("vTrangThaiChuyen",trangthai)
                 ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DON_ANCHIDAO_GETBYVUANID", prm);
        }

        public DataTable GetAllByVuAn_TrangThaiChuyenDon(Decimal VuAnID, Decimal trangthai, Decimal LoaiDon, Decimal vLoaiCVID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vVuAnID",VuAnID)
                ,new OracleParameter("vTrangThaiChuyen",trangthai)
                , new OracleParameter ("vLoaiDon", LoaiDon)
                 , new OracleParameter ("vLoaiCVID", vLoaiCVID)

                ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_DON_GETBYVUANID", prm);
        }

        public DataTable CANBO_GETBYDONVI(decimal donviID, string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("CANBO_GETBYDONVI", parameters);
            return tbl;
        }
        public DataTable CANBO_GETBYDONVI_TP(decimal donviID, string vChucDanh, string v_CANBO_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_CANBO_ID",v_CANBO_ID),
                new OracleParameter("donviID",donviID),
                new OracleParameter("vChucDanh",vChucDanh),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.CANBO_GETBYDONVI", parameters);
            return tbl;
        }

        public DataTable CANBO_GETBYDONVI_HDTP(decimal donviID, decimal vGroupChucDanhID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                         new OracleParameter("vGroupChucDanhID",vGroupChucDanhID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.CANBO_GETBYDONVI_HDTP", parameters);
            return tbl;
        }

        public DataTable CANBO_GETBYDONVI_XX(decimal donviID, string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.CANBO_GETBYDONVI_XX", parameters);
            return tbl;
        }
        public DataTable QHPL_DINHNGHIA_LIST(decimal vPhongbanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.QHPL_DINHNGHIA_LIST", parameters);
            return tbl;
        }
        public DataTable QHPL_DINHNGHIA_LIST(decimal vPhongbanID, decimal loaian)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                                                        new OracleParameter("vLoai",loaian),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QHPL_DINHNGHIA_GetByDK", parameters);
            return tbl;
        }
        public DataTable CANBO_GETBYPHONGBAN(decimal donviID, decimal vPhongbanID, string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("donviID",donviID),
                                                                         new OracleParameter("vPhongbanID",vPhongbanID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CANBO_GETBYPHONGBAN", parameters);
            return tbl;
        }

        ///Lay tat ca can bo (Dang ctac + nghi Ctac) theo donviid
        public DataTable GDTTT_VuAn_GetAllCBTheoPB(decimal vToaAnID, decimal vPhongBanID, string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAn_GetAllCBTheoPB", parameters);
            return tbl;
        }
        public DataTable GDTTT_VUAN_GETALLCBTHEOPB_ALLXX(decimal vToaAnID, decimal vPhongBanID, string vChucDanh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vChucDanh",vChucDanh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.GDTTT_VUAN_GETALLCBTHEOPB", parameters);
            return tbl;
        }
        public DataTable GDTTT_Getall_TTV_TheoTP(decimal vToaAnID, decimal vThamPhanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vThamPhanID",vThamPhanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GDTTT_GETTTT_THEOTP", parameters);
            return tbl;
        }
        public DataTable DM_CANBO_PB_CHUCDANH_THEOTP(decimal vToaAnID, decimal vThamPhanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vThamPhanID",vThamPhanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.DM_CANBO_PB_CHUCDANH", parameters);
            return tbl;
        }
        public DataTable Get_Year_Theo_TP(decimal vToaAnID, decimal vThamPhanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vThamPhanID",vThamPhanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_YEAR_THEO_TP", parameters);
            return tbl;
        }
        public DataTable GDTTT_Tp_Duoc_Phutrach(String vToaAnID, Int32 vThamphan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("vToaAnID",vToaAnID),
            new OracleParameter("vThamphan_id",vThamphan_id),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_PHUTRACH_TP", parameters);
            return tbl;
        }
        public DataTable GDTTT_Tp_Theo_Don_Vi(String vToaAnID, String vPhongBanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_TOAANID",vToaAnID),
                new OracleParameter("V_PHONGBANID",vPhongBanID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
              };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_TP_VU_GDKT", parameters);
            return tbl;
        }
        public DataTable GDTTT_Tp_Duoc_Phutrach_BC(Int32 vThamphan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vThamphan_id",vThamphan_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_PHUTRACH_TP_BC", parameters);
            return tbl;
        }
        public DataTable GDTTT_CanBo_GetTP_HD5(decimal vToaAnID, decimal vPhongBanID, decimal vLoaiAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_CanBo_GetTP_HD5", parameters);
            return tbl;
        }


        public DataTable CANBO_GETBYDONVI_2CHUCVU(decimal vDonViID, decimal vPhongbanID, string vChucVu1, string vChucVu2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonViID",vDonViID),
                                                                         new OracleParameter("vPhongbanID",vPhongbanID),
                                                                         new OracleParameter("vChucVu1",vChucVu1),
                                                                         new OracleParameter("vChucVu2",vChucVu2),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("CANBO_GETBYDONVI_2CHUCVU", parameters);
            return tbl;
        }
        public DataTable CANBO_GETBYDONVI_LANHDAO(decimal vDonViID, decimal vPhongbanID, string vChucVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vDonViID",vDonViID),
                        new OracleParameter("vPhongbanID",vPhongbanID),
                        new OracleParameter("vChucVu",vChucVu),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.CANBO_GETBYDONVI_LANHDAO", parameters);
            return tbl;
        }
        public decimal TL_GETMAXTT(decimal donviID, decimal vYear, decimal vLoaiAn)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_TL_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }
        public bool DON_TLXX_CHECK(decimal donviID, decimal vYear, decimal vLoaiAn, string vTL_SO, decimal vDonID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),
                                                                         new OracleParameter("vTL_SO",vTL_SO),
                                                                          new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_TLXX_CHECK", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public bool DON_TL_CHECK(decimal donviID, decimal vYear, decimal vLoaiAn, string vTL_SO, decimal vDonID, decimal vHinhThucDon)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),
                                                                         new OracleParameter("vTL_SO",vTL_SO),
                                                                         new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                          new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_TL_CHECK", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }

        }
        public bool DON_TL_CHECK_CC(decimal vdonviID, decimal vYear, decimal vLoaiAn, string vTL_SO, decimal vDonID, decimal vHinhThucDon)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),
                                                                         new OracleParameter("vTL_SO",vTL_SO),
                                                                         new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                          new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.DON_TL_CHECK_CC", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public decimal CV_GETMAXTT(decimal donviID, decimal vYear, decimal vNoiChuyen, decimal vTrangthaidon)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                        new OracleParameter("vTrangthaidon",vTrangthaidon),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_CV_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }
        public decimal SOVB_GETMAXTT(decimal donviID, decimal Phongbanid, decimal vYear, string vLOAISO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vPhongbanid",Phongbanid),
                                                                        new OracleParameter("vYear",vYear),
                                                                        new OracleParameter("vLoaiso",vLOAISO),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_APP.QLSOVB_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }
        public bool DON_CV_CHECK(decimal vdonviID, decimal vNoiChuyen, decimal vTrangthaidon, string vSO_CV, decimal vYear)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                        new OracleParameter("vTrangthaidon",vTrangthaidon),
                                                                        new OracleParameter("vSO_CV",vSO_CV),
                                                                        new OracleParameter("vYear",vYear),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_CV_CHECK", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public DataTable GDTTT_DON_KEM_DONTRUNG_SEARCH(decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
           string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vPhancongTTV, decimal vloaian)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                        new OracleParameter("vTrangthai",vTrangthai),
                                                                        new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                        new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                        new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                        new OracleParameter("vArrSelectID",vArrSelectID),
                                                                        new OracleParameter("vIsThuLy",vIsThuLy),
                                                                        new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                        new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                        new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                        new OracleParameter("vSoThuly",vSoThuly),
                                                                        new OracleParameter("vPhancongTTV",vPhancongTTV),
                                                                        new OracleParameter("vloaian",vloaian),

                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DON_GIAIQUYET_SEARCH_ShowAll", parameters);
            return tbl;
        }
        public DataTable GDTTT_GIAIQUYET_SEARCH(string v_Noichuyen, string VTHAMPHANID, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
              string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
              decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
              string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
              decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
              decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
              , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
              , decimal vPhancongTTV, decimal vloaian, decimal vGiaoTHS, int IsGhepVuAn, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
              , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_Noichuyen",v_Noichuyen),
                new OracleParameter("VTHAMPHANID",VTHAMPHANID),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vPhancongTTV",vPhancongTTV),
                new OracleParameter("vloaian",vloaian),
                new OracleParameter("vGiaoTHS",vGiaoTHS),

                new OracleParameter("IsGhepVuAn",IsGhepVuAn),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            //04/10/2024 dung de truyen vao packges
            String sql_input_test =
                "V_NOICHUYEN :=" + v_Noichuyen + " ;" +
                "VTHAMPHANID :=" + VTHAMPHANID + " ;" +
                "VTOAANID :=" + vToaAnID + " ;" +
                "VTOARABAQD :=" + vToaRaBAQD + " ;" +
                "VSOBAQD :=" + vSoBAQD + " ;" +
                "VNGAYBAQD :=" + vNgayBAQD + " ;" +
                "VNGUOIGUI :=" + vNguoiGui + " ;" +
                "VSOCMND :=" + vSoCMND + " ;" +
                "VTUNGAY :=" + vTuNgay + " ;" +
                "VDENNGAY :=" + vDenNgay + " ;" +
                "VHINHTHUCDON :=" + vHinhThucDon + " ;" +
                "VSOHIEUDON :=" + vSoHieuDon + " ;" +
                "VDIACHITINH :=" + vDiaChiTinh + " ;" +
                "VDIACHIHUYEN :=" + vDiaChiHuyen + " ;" +
                "VDIACHICT :=" + vDiaChiCT + " ;" +
                "VSOCONGVAN :=" + vSoCongVan + " ;" +
                "VNGAYCONGVAN :=" + vNgayCongVan + " ;" +
                "VTRALOI :=" + vTraLoi + " ;" +
                "VNGUOINHAP :=" + vNguoiNhap + " ;" +
                "VNOICHUYEN :=" + vNoiChuyen + " ;" +
                "VTRANGTHAI :=" + vTrangthai + " ;" +
                "VCD_DONVIID :=" + vCD_DONVIID + " ;" +
                "VNGAYCHUYENTU :=" + vNgaychuyenTu + " ;" +
                "VNGAYCHUYENDEN :=" + vNgaychuyenDen + " ;" +
                "VARRSELECTID :=" + vArrSelectID + " ;" +
                "VISTHULY :=" + vIsThuLy + " ;" +
                "VPHANLOAIXULY :=" + vPhanloaixuly + " ;" +
                "VNGAYTHULYTU :=" + vNgayThulyTu + " ;" +
                "VNGAYTHULYDEN :=" + vNgayThulyDen + " ;" +
                "VSOTHULY :=" + vSoThuly + " ;" +
                "VPHANCONGTTV :=" + vPhancongTTV + " ;" +
                "VLOAIAN :=" + vloaian + " ;" +
                "VGIAOTHS :=" + vGiaoTHS + " ;" +
                "ISGHEPVUAN :=" + IsGhepVuAn + " ;" +
                "V_ISXINANGIAM :=" + _ISXINANGIAM + " ;" +
                "V_GDT_ISXINANGIAM :=" + _GDT_ISXINANGIAM + " ;" +
                "PAGEINDEX :=" + PageIndex + " ;" +
                "PAGESIZE :=" + PageSize + " ;";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.DON_GIAIQUYET_SEARCHS", parameters);
            return tbl;
        }

        public DataTable GDTTT_GIAIQUYET_SEARCH_TP(string v_user_loign, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
              string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
              decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
              string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
              decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
              decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
              , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
              , decimal vPhancongTTV, decimal vloaian, decimal vGiaoTHS, int IsGhepVuAn, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
              , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("v_user_loign",v_user_loign),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vPhancongTTV",vPhancongTTV),
                new OracleParameter("vloaian",vloaian),
                new OracleParameter("vGiaoTHS",vGiaoTHS),

                new OracleParameter("IsGhepVuAn",IsGhepVuAn),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.DON_GIAIQUYET_SEARCH_TP", parameters);
            return tbl;
        }
        public DataTable VAKN_GIAIQUYET_SEARCH_TP(string v_user_loign, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
              string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
              decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
              string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
              decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
              decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
              , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
              , decimal vPhancongTTV, decimal vloaian, decimal vGiaoTHS, int IsGhepVuAn, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
              , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("v_user_loign",v_user_loign),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vPhancongTTV",vPhancongTTV),
                new OracleParameter("vloaian",vloaian),
                new OracleParameter("vGiaoTHS",vGiaoTHS),

                new OracleParameter("IsGhepVuAn",IsGhepVuAn),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),

                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VAKN_GIAIQUYET_SEARCH_TP", parameters);
            return tbl;
        }

        public DataTable GDTTT_KNTC_SEARCH(decimal vToaAnID, string vDoiTuongBiKNTC, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
      decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
      string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
      decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
      decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vPhanloaixuly
      , decimal vChidao, decimal vTBQuahan, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vDoiTuongBiKNTC",vDoiTuongBiKNTC),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_KNTC_SEARCH", parameters);
            return tbl;
        }
        public decimal UPDATESOLUONGDON(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_UPDATESOLUONGDON", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public DataTable BOSUNGTAILIEU(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.BOSUNGTAILIEU", prm);
        }
        public DataTable YEUCAUBOSUNG(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.YEUCAUBOSUNG", prm);
        }
        public bool GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(GDTTT_DON_YEUCAU_BOSUNG obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT.GDTTT_DON_YEUCAU_BOSUNG_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_DONID"].Value = obj.DONID;
            comm.Parameters["v_LANTHU"].Value = obj.LANTHU;
            comm.Parameters["v_NGUOIKY"].Value = obj.NGUOIKY;
            comm.Parameters["v_SOTHONGBAO"].Value = obj.SOTHONGBAO;
            comm.Parameters["v_NGAYTHONGBAO"].Value = obj.NGAYTHONGBAO;
            comm.Parameters["v_CD_TA_LYDO_ISBAQD"].Value = obj.CD_TA_LYDO_ISBAQD;
            comm.Parameters["v_CD_TA_LYDO_ISXACNHAN"].Value = obj.CD_TA_LYDO_ISXACNHAN;
            comm.Parameters["v_CD_TA_LYDO_ISKHAC"].Value = obj.CD_TA_LYDO_ISKHAC;
            comm.Parameters["v_NOIDUNG"].Value = obj.NOIDUNG;
            comm.Parameters["v_KETQUA"].Value = obj.KETQUA;
            comm.Parameters["v_NOIDUNGKQ"].Value = obj.NOIDUNGKQ;
            comm.Parameters["v_NGAYBOSUNG"].Value = obj.NGAYBOSUNG;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public bool GDTTT_DON_YEUCAU_BOSUNG_DEL(Decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT.GDTTT_DON_YEUCAU_BOSUNG_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable GDTTT_DON_YEUCAU_BOSUNG_GETBYID(Decimal ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.GDTTT_DON_YEUCAU_BOSUNG_GETBYID", prm);
        }

        public decimal YC_GETMAXTT(decimal donviID, decimal vYear, decimal vLoaiAn)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vYear",vYear),
                                                                         new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_YEUCAU_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }

        public decimal YC_GETMAXLANTHU(decimal donID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonID",donID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.DON_YEUCAU_GETMAXLANTHU", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }

        public DataTable CHECK_YEUCAU_LANTHUTRUNG(decimal ID, decimal donID, decimal lanThu)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("vID",ID),
                 new OracleParameter("vdonID",donID),
                 new OracleParameter("vLanThu",lanThu),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CHECK_YEUCAU_LANTHUTRUNG", prm);
        }

        public DataTable CHECK_YEUCAU_SOTHONGBAO_TRUNG(decimal ID, decimal donID, string soTB)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("vID",ID),
                 new OracleParameter("vdonID",donID),
                 new OracleParameter("vSoThongBao",soTB),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CHECK_YEUCAU_SOTHONGBAO_TRUNG", prm);
        }

        public DataTable CHECK_YEUCAU_SOTB_NGAYTB(decimal donID, string soTB, string ngayTB)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("vdonID",donID),
                 new OracleParameter("vSoThongBao",soTB),
                 new OracleParameter("vNgayThongBao",ngayTB),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CHECK_YEUCAU_SOTB_NGAYTB", prm);
        }

        public DataTable CHECK_YEUCAU_NGAYTHONGBAO(decimal ID, decimal donID, string ngayTB, decimal lanThu)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("vID",ID),
                 new OracleParameter("vdonID",donID),
                 new OracleParameter("vNgayTB",ngayTB),
                 new OracleParameter("vLanThu",lanThu),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.CHECK_YEUCAU_NGAYTHONGBAO", prm);
        }

        public DataTable GetThongTinAnQH(decimal VuAnID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vVuAnID",VuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTTT_DON_GetThongTinAnQH", prm);
        }
        public DataTable GetDonDaNhanChuaMapVA()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_GetDonDaNhanChuaMapVA", prm);
        }
        public void Update_Don_TH(decimal VUVIECID)
        {
            GSTPContext dt = new GSTPContext();
            OracleParameter[] prm = new OracleParameter[]
                                    {
                                         new OracleParameter("vuviec_id",VUVIECID),
                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                    };
            Cls_Comon.ExcuteProc("GDTTT_DON_UPDATETH", prm);

            ////--------Lay ds cac muc = cv quoc hoi-----------------------
            //decimal cv_quochoi_id = 1023;
            //String StrCVQH = ";";
            //DM_DATAITEM_BL da = new DM_DATAITEM_BL();
            //DataTable tblDA = da.DM_DATAITEM_GET_ALL_CHILD_BYPARENTID(cv_quochoi_id);
            //foreach (DataRow rDA in tblDA.Rows)
            //    StrCVQH += rDA["ID"] + ";";

            ////-------------------------------
            //Decimal temp = 0, ISANQUOCHOI =0, IsAnChiDao =0, IsThongBaoCV = 0, CountAll =0 ;
            //String ARRNGUOIKHIEUNAI = "";
            //if (VUVIECID > 0)
            //{
            //    GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VUVIECID).Single();
            //    List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VUVIECID).ToList();
            //    if (lstDon != null && lstDon.Count > 0)
            //    {
            //        CountAll = lstDon.Count;
            //        foreach (GDTTT_DON itemDon in lstDon)
            //        {
            //            temp = 0;
            //            if (!string.IsNullOrEmpty(itemDon.NGUOIGUI_HOTEN + ""))
            //                ARRNGUOIKHIEUNAI = (string.IsNullOrEmpty(ARRNGUOIKHIEUNAI + "")) ? "" : ", " + Cls_Comon.FormatTenRieng(itemDon.NGUOIGUI_HOTEN);
            //            //--------------------------------
            //            temp = String.IsNullOrEmpty(itemDon.LOAICONGVAN + "") ? 0 : (Decimal)itemDon.LOAICONGVAN;
            //            if (temp > 0)
            //            {
            //                if (StrCVQH.Contains(";" + temp + ";"))
            //                    ISANQUOCHOI++;
            //            }
            //            //--------------------------
            //            temp = String.IsNullOrEmpty(itemDon.CHIDAO_COKHONG + "") ? 0 : (Decimal)itemDon.CHIDAO_COKHONG;
            //            if (temp > 0)
            //                IsAnChiDao++;
            //            //--------------------------
            //            temp = String.IsNullOrEmpty(itemDon.CV_YEUCAUTHONGBAO + "") ? 0 : (Decimal)itemDon.CV_YEUCAUTHONGBAO;
            //            if (temp > 0)
            //                IsThongBaoCV++;
            //        }
            //    }
            //    decimal Old_IsAnQH = (string.IsNullOrEmpty(objVA.ISANQUOCHOI + "")) ? 0 : (decimal)objVA.ISANQUOCHOI;
            //    objVA.TONGDON = CountAll;
            //    objVA.ARRNGUOIKHIEUNAI = ARRNGUOIKHIEUNAI;
            //    objVA.ISANQUOCHOI = (ISANQUOCHOI > 0) ? 1 : Old_IsAnQH;
            //    objVA.ISANCHIDAO = (IsAnChiDao > 0) ? 1 : 0;
            //    objVA.ISTHONGBAOCV = (IsThongBaoCV > 0) ? 1 : 0;
            //    dt.SaveChanges();
            //}
        }
        public void Update_TH_AnChuyenHS_VKS(decimal VUVIECID)
        {
            GSTPContext dt = new GSTPContext();

            //--------Lay ds cac muc = cv quoc hoi-----------------------
            decimal cv_quochoi_id = 1023;
            String StrCVQH = ";";
            DM_DATAITEM_BL da = new DM_DATAITEM_BL();
            DataTable tblDA = da.DM_DATAITEM_GET_ALL_CHILD_BYPARENTID(cv_quochoi_id);
            foreach (DataRow rDA in tblDA.Rows)
                StrCVQH += rDA["ID"] + ";";

            //-------------------------------
            Decimal temp = 0, ISANQUOCHOI = 0, IsAnChiDao = 0, IsThongBaoCV = 0, CountAll = 0;
            String ARRNGUOIKHIEUNAI = "";
            if (VUVIECID > 0)
            {
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VUVIECID).Single();
                List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VUVIECID).ToList();
                if (lstDon != null && lstDon.Count > 0)
                {
                    CountAll = lstDon.Count;
                    foreach (GDTTT_DON itemDon in lstDon)
                    {
                        temp = 0;
                        if (!string.IsNullOrEmpty(itemDon.NGUOIGUI_HOTEN + ""))
                            ARRNGUOIKHIEUNAI = (string.IsNullOrEmpty(ARRNGUOIKHIEUNAI + "")) ? "" : ", " + Cls_Comon.FormatTenRieng(itemDon.NGUOIGUI_HOTEN);
                        //--------------------------------
                        temp = String.IsNullOrEmpty(itemDon.LOAICONGVAN + "") ? 0 : (Decimal)itemDon.LOAICONGVAN;
                        if (temp > 0)
                        {
                            if (StrCVQH.Contains(";" + temp + ";"))
                                ISANQUOCHOI++;
                        }
                        //--------------------------
                        temp = String.IsNullOrEmpty(itemDon.CHIDAO_COKHONG + "") ? 0 : (Decimal)itemDon.CHIDAO_COKHONG;
                        if (temp > 0)
                            IsAnChiDao++;
                        //--------------------------
                        temp = String.IsNullOrEmpty(itemDon.CV_YEUCAUTHONGBAO + "") ? 0 : (Decimal)itemDon.CV_YEUCAUTHONGBAO;
                        if (temp > 0)
                            IsThongBaoCV++;
                    }
                }
                objVA.TONGDON = CountAll;
                objVA.ARRNGUOIKHIEUNAI = ARRNGUOIKHIEUNAI;
                //objVA.ISANQUOCHOI = (ISANQUOCHOI > 0) ? 1 : Old_IsAnQH;
                //objVA.ISANCHIDAO = (IsAnChiDao > 0) ? 1 : 0;
                objVA.ISTHONGBAOCV = (IsThongBaoCV > 0) ? 1 : 0;
                objVA.ISVIENTRUONGKN = 1;
                dt.SaveChanges();
            }
        }
        public DataTable GDTTT_GIAONHAN_THS(decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
            , decimal vPhancongTTV, decimal vloaian, decimal vGiaoTHS, int IsGhepVuAn, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
            , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vPhancongTTV",vPhancongTTV),
                new OracleParameter("vloaian",vloaian),
                new OracleParameter("vGiaoTHS",vGiaoTHS),
                new OracleParameter("IsGhepVuAn",IsGhepVuAn),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.DON_GDTTT_GIAONHAN_THS", parameters);
            return tbl;
        }
        public bool GDTTT_DON_GIAONHAN_INSERT_UPDAT(GDTTT_DON_GIAONHAN_THS obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_DON_APP.GDTTT_GIAONHAN_THS_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_DONID"].Value = obj.DONID;
            comm.Parameters["v_NGUOICHUYEN_ID"].Value = obj.NGUOICHUYEN_ID;
            comm.Parameters["v_NGUOINHAN_ID"].Value = obj.NGUOINHAN_ID;
            if (obj.NGAYCHUYEN != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYCHUYEN"].Value = obj.NGAYCHUYEN;
            else
                comm.Parameters["v_NGAYCHUYEN"].Value = null;

            if (obj.NGAYNHAN != Convert.ToDateTime("01/01/0001"))
                comm.Parameters["v_NGAYNHAN"].Value = obj.NGAYNHAN;
            else
                comm.Parameters["v_NGAYNHAN"].Value = null;

            comm.Parameters["v_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["v_GHICHU"].Value = obj.GHICHU;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public bool GDTTT_DON_GIAONHAN_DEL(Decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_DON_APP.GDTTT_GIAONHAN_THS_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable GDTTT_DON_GIAONHAN_THS_PRINT(decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
           string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly
           , decimal vPhancongTTV, decimal vloaian, int IsGhepVuAn, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
           , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vPhancongTTV",vPhancongTTV),
                new OracleParameter("vloaian",vloaian),
                new OracleParameter("IsGhepVuAn",IsGhepVuAn),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_INBC.GDTTTT_DON_GIAONHAN_THS_PRINT", parameters);
            return tbl;
        }
        public DataTable Get_DV_tu_LoaianID(String V_LOAIANID, String V_TOAANID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_LOAIANID",V_LOAIANID),
                new OracleParameter("V_TOAANID",V_TOAANID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_LOAD_DONVI", prm);
        }
        public Decimal GDTTT_DON_CC_REIDS()
        {
            //Hàm trả về một giá trị
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_CC.GDTTT_DON_CC_REID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            comm.Parameters.Add("", OracleDbType.Decimal).Direction = ParameterDirection.ReturnValue;
            comm.ExecuteNonQuery();
            try
            {
                return Convert.ToDecimal(comm.Parameters[0].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        public Decimal GDTTT_VUAN_REIDS()
        {
            //Hàm trả về một giá trị
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_CC.GDTTT_VUAN_REID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            comm.Parameters.Add("", OracleDbType.Decimal).Direction = ParameterDirection.ReturnValue;
            comm.ExecuteNonQuery();
            try
            {
                return Convert.ToDecimal(comm.Parameters[0].Value.ToString());
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable GDTTT_DON_SEARCH_GIAY_XAC_NHAN(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay, decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            String sql_input_test =
"V_BC_NGAYDK :=" + V_BC_NGAYDK + " ;" +
"V_BC_Nguoiky :=" + V_BC_Nguoiky + " ;" +
"V_BC_SoCV :=" + V_BC_SoCV + " ;" +
"v_ID_USER :=" + v_ID_USER + " ;" +
"vToaAnID :=" + vToaAnID + " ;" +
"vToaRaBAQD :=" + vToaRaBAQD + " ;" +
"vSoBAQD :=" + vSoBAQD + " ;" +
"vNgayBAQD :=" + vNgayBAQD + " ;" +
"vNguoiGui :=" + vNguoiGui + " ;" +
"vSoCMND :=" + vSoCMND + " ;" +
"vTuNgay :=" + vTuNgay + " ;" +
"vDenNgay :=" + vDenNgay + " ;" +
"vHinhThucDon :=" + vHinhThucDon + " ;" +
"vSoHieuDon :=" + vSoHieuDon + " ;" +
"vDiaChiTinh :=" + vDiaChiTinh + " ;" +
"vDiaChiHuyen :=" + vDiaChiHuyen + " ;" +
"vDiaChiCT :=" + vDiaChiCT + " ;" +
"vSoCongVan :=" + vSoCongVan + " ;" +
"vNgayCongVan :=" + vNgayCongVan + " ;" +
"vTraLoi :=" + vTraLoi + " ;" +
"vNguoiNhap :=" + vNguoiNhap + " ;" +
"vNoiChuyen :=" + vNoiChuyen + " ;" +
"vTrangthai :=" + vTrangthai + " ;" +
"vCD_DONVIID :=" + vCD_DONVIID + " ;" +
"vCD_TA_TRANGTHAI :=" + vCD_TA_TRANGTHAI + " ;" +
"vCD_TENDONVI :=" + vCD_TENDONVI + " ;" +
"vNgaychuyenTu :=" + vNgaychuyenTu + " ;" +
"vNgaychuyenDen :=" + vNgaychuyenDen + " ;" +
"vArrSelectID :=" + vArrSelectID + " ;" +
"vIsThuLy :=" + vIsThuLy + " ;" +
"vPhanloaixuly :=" + vPhanloaixuly + " ;" +
"vNgayThulyTu :=" + vNgayThulyTu + " ;" +
"vNgayThulyDen :=" + vNgayThulyDen + " ;" +
"vSoThuly :=" + vSoThuly + " ;" +
"vChidao :=" + vChidao + " ;" +
"vTraigiam :=" + vTraigiam + " ;" +
"vTBQuahan :=" + vTBQuahan + " ;" +
"vNgayQuahan :=" + vNgayQuahan + " ;" +
"vThamphanID :=" + vThamphanID + " ;" +
"vThamtravienID :=" + vThamtravienID + " ;" +
"vLoaiCVID :=" + vLoaiCVID + " ;" +
"vNgayNhapTu :=" + vNgayNhapTu + " ;" +
"vNgayNhapDen :=" + vNgayNhapDen + " ;" +
"vIsDonGoc :=" + vIsDonGoc + " ;" +
"vIsTuHinh :=" + vIsTuHinh + " ;" +
"vLoaiAn :=" + vLoaiAn + " ;" +
"vCVPC_So :=" + vCVPC_So + " ;" +
"vCVPC_Ngay :=" + vCVPC_Ngay + " ;" +
"vCVPC_TenCQ :=" + vCVPC_TenCQ + " ;" +
"vGuitoiCA_TA :=" + vGuitoiCA_TA + " ;" +
"PageIndex :=" + PageIndex + " ;" +
"PageSize :=" + PageSize + " ;";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DON_SEARCH_GIAYXACNHANCC", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_SEARCH_GIAY_XAC_NHAN_S(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DON_SEARCH_GIAYXACNHANCC_S", parameters);
            return tbl;
        }
        public DataTable GetGiayTrieuTap(decimal vVbToTungID, string strDiadiem, string strDiaDiemToaAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVbToTungID",vVbToTungID),
                new OracleParameter("strDiadiem",strDiadiem),
                new OracleParameter("strDiaDiemToaAn",strDiaDiemToaAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.GIAYTRIEUTAP", parameters);
            return tbl;
        }

        public DataTable GetGiayTrieuTap_AHS(decimal vVbToTungID, string strDiadiem, string strDiaDiemToaAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVbToTungID",vVbToTungID),
                new OracleParameter("strDiadiem",strDiadiem),
                new OracleParameter("strDiaDiemToaAn",strDiaDiemToaAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.GIAYTRIEUTAP_AHS", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_SEARCH_THONG_BAO_YCBSCC(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC.DON_SEARCH_THONG_BAO_YCBSCC", parameters);
            return tbl;
        }

        public DataTable GDTTT_REPORT_TIEU_HO_SO_CC(string vArrSelectID, Decimal v_ID_USER)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vArrSelectID",vArrSelectID), new OracleParameter("v_ID_USER",v_ID_USER),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_CC.REPORT_TIEUHOSO_CC", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_DS_VB_CC(string vArrSelectID, Decimal v_ID_USER)
        {
            OracleParameter[] parameters = new OracleParameter[] {
               new OracleParameter("vArrSelectID",vArrSelectID), new OracleParameter("v_ID_USER",v_ID_USER),
               new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_CC.DON_SEARCH_DS_VB_CC", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_DS_TL_MOI_CC(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
           string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),

                                                                        new OracleParameter("VLOAISOVB",VLOAISOVB),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            String sql_input_test =
           "V_BC_NGAYDK :=" + V_BC_NGAYDK + " ;" +
            "V_BC_Nguoiky :=" + V_BC_Nguoiky + " ;" +
            "V_BC_SoCV :=" + V_BC_SoCV + " ;" +
            "v_ID_USER :=" + v_ID_USER + " ;" +
            "vToaAnID :=" + vToaAnID + " ;" +
            "vToaRaBAQD :=" + vToaRaBAQD + " ;" +
            "vSoBAQD :=" + vSoBAQD + " ;" +
            "vNgayBAQD :=" + vNgayBAQD + " ;" +
            "vNguoiGui :=" + vNguoiGui + " ;" +
            "vSoCMND :=" + vSoCMND + " ;" +
            "vTuNgay :=" + vTuNgay + " ;" +
            "vDenNgay :=" + vDenNgay + " ;" +
            "vHinhThucDon :=" + vHinhThucDon + " ;" +
            "vSoHieuDon :=" + vSoHieuDon + " ;" +
            "vDiaChiTinh :=" + vDiaChiTinh + " ;" +
            "vDiaChiHuyen :=" + vDiaChiHuyen + " ;" +
            "vDiaChiCT :=" + vDiaChiCT + " ;" +
            "VLOAISOVB :=" + VLOAISOVB + " ;" +
            "vSoCongVan :=" + vSoCongVan + " ;" +
            "vNgayCongVan :=" + vNgayCongVan + " ;" +
            "vTraLoi :=" + vTraLoi + " ;" +
            "vNguoiNhap :=" + vNguoiNhap + " ;" +
            "vNoiChuyen :=" + vNoiChuyen + " ;" +
            "vTrangthai :=" + vTrangthai + " ;" +
            "vCD_DONVIID :=" + vCD_DONVIID + " ;" +
            "vCD_TA_TRANGTHAI :=" + vCD_TA_TRANGTHAI + " ;" +
            "vCD_TENDONVI :=" + vCD_TENDONVI + " ;" +
            "vNgaychuyenTu :=" + vNgaychuyenTu + " ;" +
            "vNgaychuyenDen :=" + vNgaychuyenDen + " ;" +
            "vArrSelectID :=" + vArrSelectID + " ;" +
            "vIsThuLy :=" + vIsThuLy + " ;" +
            "vPhanloaixuly :=" + vPhanloaixuly + " ;" +
            "vNgayThulyTu :=" + vNgayThulyTu + " ;" +
            "vNgayThulyDen :=" + vNgayThulyDen + " ;" +
            "vSoThuly :=" + vSoThuly + " ;" +
            "vChidao :=" + vChidao + " ;" +
            "vTraigiam :=" + vTraigiam + " ;" +
            "vTBQuahan :=" + vTBQuahan + " ;" +
            "vNgayQuahan :=" + vNgayQuahan + " ;" +
            "vThamphanID :=" + vThamphanID + " ;" +
            "vThamtravienID :=" + vThamtravienID + " ;" +
            "vLoaiCVID :=" + vLoaiCVID + " ;" +
            "vNgayNhapTu :=" + vNgayNhapTu + " ;" +
            "vNgayNhapDen :=" + vNgayNhapDen + " ;" +
            "vIsDonGoc :=" + vIsDonGoc + " ;" +
            "vIsTuHinh :=" + vIsTuHinh + " ;" +
            "vLoaiAn :=" + vLoaiAn + " ;" +
            "vCVPC_So :=" + vCVPC_So + " ;" +
            "vCVPC_Ngay :=" + vCVPC_Ngay + " ;" +
            "vCVPC_TenCQ :=" + vCVPC_TenCQ + " ;" +
            "vGuitoiCA_TA :=" + vGuitoiCA_TA + " ;" +
            "PageIndex :=" + PageIndex + " ;" +
            "PageSize :=" + PageSize + " ;";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_CC.DON_SEARCH_DS_TL_MOI_CC", parameters);
            return tbl;
        }

        public DataTable GDTTT_DON_PHIEU_RUTHOSO(string vArrSelectID, string txtBC_SoCV, string txtBC_Ngaydk, string txtBC_Nguoiky, Decimal v_ID_USER)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("v_ID_USER",v_ID_USER),
                new OracleParameter("V_BC_SoCV",txtBC_SoCV),
                new OracleParameter("V_BC_NGAYDK",txtBC_Ngaydk),
                new OracleParameter("V_BC_Nguoiky",txtBC_Nguoiky),

                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_CC.REPORT_QDRUT_HOSO_CC", parameters);
            return tbl;
        }

        public bool GDTTT_HCTP_QLSO_UPDATE(GDTTT_HCTP_QLSO obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_HCTP_QUANLYSO.GDTTT_HCTP_QLSO_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_SO"].Value = obj.SO;
            comm.Parameters["v_NGAY"].Value = obj.NGAY;
            comm.Parameters["v_NGUOIKY"].Value = obj.NGUOIKY;
            comm.Parameters["v_DONID"].Value = obj.DONID;
            comm.Parameters["v_SO_TT"].Value = obj.SO_TT;
            comm.Parameters["v_NGAY_TT"].Value = obj.NGAY_TT;
            comm.Parameters["v_LOAI"].Value = obj.LOAI;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["v_NGUOISUA"].Value = obj.NGUOISUA;
            comm.Parameters["v_NGAYSUA"].Value = obj.NGAYSUA;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable GET_GDTTT_HCTP_QLSO(decimal vDonID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_DONID",vDonID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_QUANLYSO.GET_GDTTT_HCTP_QLSO", prm);
        }

        public string GET_CHUC_DANH_BY_THAMPHANID(decimal V_THAMPHANID)
        {
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == V_THAMPHANID).FirstOrDefault();
            if (oCB == null) return string.Empty;

            DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
            if (oItem != null) return oItem.MA;

            return string.Empty;
        }

        #region AnhPN GetMax Số tự động cho một số loại văn bản
        public decimal HoanTHA_GETMAXTT(decimal vToaAnID, decimal vYear, string vLoaian)
        {
            try
            {
                String SQL = "select Max(to_number(regexp_replace(tt.GQD_HOANTHA_SO, '[^0-9]'))) as v_GQD_HOANTHA_SO " +
                "   from(" +
                //"       select" +
                //"           lower(DECODE(INSTR(d.TL_SO, '/')" +
                //"                       , 0, decode(INSTR(d.TL_SO, '0'), 1, regexp_replace(d.TL_SO, '0', '', 1, 1), d.TL_SO), decode(INSTR(d.TL_SO, '0')" +
                //"                       , 1, SUBSTR(regexp_replace(d.TL_SO, '0', '', 1, 1), 1, instr(regexp_replace(d.TL_SO, '0', '', 1, 1), '/') - 1), SUBSTR(d.TL_SO, 1, instr(d.TL_SO, '/') - 1))" +
                //"                        )" +
                //"                   ) as sotlxx" +
                //"           from gdttt_don d" +
                //"         Where d.TOAANID = " + vToaAnID + "" +
                //"           And d.LOAIDON = 4" +
                //"           and d.TL_NGAY between TO_DATE(Cast(("+ vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                //"           and d.BAQD_LOAIAN = " + vLoaian + "" +
                //"        UNION ALL" +
                "        select" +
                "            lower(DECODE(INSTR(v.GQD_HOANTHA_SO, '/')" +
                "                       , 0, decode(INSTR(v.GQD_HOANTHA_SO, '0'), 1, regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), v.GQD_HOANTHA_SO), decode(INSTR(v.GQD_HOANTHA_SO, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GQD_HOANTHA_SO, 1, instr(v.GQD_HOANTHA_SO, '/') - 1))" +
                "                        )" +
                "                   ) as GQD_HOANTHA_SO" +
                "           from gdttt_vuan v" +
                "               where" +
                "                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.GQD_ISHOANTHA = 1" +
                //"                   and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.GQD_HOANTHA_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "   )tt";

                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                //if (tbl != null && tbl.Rows.Count > 0)
                //{
                //    foreach (DataRow row in tbl.Rows)
                //    {
                //        row["v_maxTLxxgdt"] = row["v_maxTLxxgdt"];
                //    }
                //}
                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_GQD_HOANTHA_SO"].ToString()))
                    {
                        So = decimal.Parse(obj["v_GQD_HOANTHA_SO"].ToString());
                    }
                }
                return So + 1;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal SoTraLoi_GETMAXTT(decimal vToaAnID, decimal vYear, string vLoaian, string vLoaiDon)
        {
            try
            {
                string SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                  " from(" +
                  //"     select" +
                  //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                  //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                  //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                  //"                      )" +
                  //"                 ) as sotlxx" +
                  //"         from gdttt_vuan_ketqua_don kqd" +
                  //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                  //"         Where d.TOAANID = " + vToaAnID + "" +
                  //"         And d.LOAIDON = " + vLoaiDon + "" +
                  //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  //"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                  //"      UNION ALL" +
                  "      select" +
                  "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                  "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                  "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                  "                      )" +
                  "                 ) as sotlxx" +
                  "         from gdttt_vuan_ketqua vd" +
                  "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                  "             where v.toaanid = " + vToaAnID + "" +
                  "             and vd.TRANGTHAI = 1" +
                  "             and v.LOAIAN = " + vLoaian + "" +
                  //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                  "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                  "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                  "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  " )tt ";
                if (vToaAnID == 4 || vToaAnID == 5) // cấp cao HN và ĐN
                {
                    if (vLoaiDon == "3" || vLoaiDon == "2" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                        " from(" +
                        "     select" +
                        "         lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_VUAN v" +
                        "         Where v.TOAANID = " + vToaAnID + "" +
                        "         And v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "         and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "         and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "      UNION ALL" +
                        "      select" +
                        "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from gdttt_vuan_ketqua vd" +
                        "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                        "             where v.toaanid = " + vToaAnID + "" +
                        "             and vd.TRANGTHAI = 1" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                        " from(" +
                        //"     select" +
                        //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                        //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from gdttt_vuan_ketqua_don kqd" +
                        //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                        //"         Where d.TOAANID = " + vToaAnID + "" +
                        //"         And d.LOAIDON = " + vLoaiDon + "" +
                        //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        //"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                        //"      UNION ALL" +
                        "      select" +
                        "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from gdttt_vuan_ketqua vd" +
                        "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                        "             where v.toaanid = " + vToaAnID + "" +
                        "             and vd.TRANGTHAI = 1" +
                        "             and v.LOAIAN = " + vLoaian + "" +
                        //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                }
                if (vToaAnID == 6)// cấp cao HCM
                {
                    if (vLoaiDon == "2" || vLoaiDon == "3" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS 
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                            " from(" +
                            "     select" +
                            "         lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from GDTTT_VUAN v" +
                            "         Where v.TOAANID = " + vToaAnID + "" +
                            "           and v.GQD_LOAIKETQUA != 0 " +
                            "           and v.GQD_LOAIKETQUA != 1 " +
                            "           and v.LOAIAN = " + vLoaian + "" +
                            "           and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "           and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            "      UNION ALL" +
                            "      select" +
                            "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from gdttt_vuan_ketqua vd" +
                            "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                            "             where v.toaanid = " + vToaAnID + "" +
                            "             and vd.TRANGTHAI = 1" +
                            "             and v.LOAIAN = " + vLoaian + "" +
                            //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                            //"                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                            "             and vd.GQD_LOAIKETQUA != 0 " +
                            "             and vd.GQD_LOAIKETQUA != 1 " +
                            "             and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "             and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            " )tt ";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                            " from(" +
                            //"     select" +
                            //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                            //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                            //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                            //"                      )" +
                            //"                 ) as sotlxx" +
                            //"         from gdttt_vuan_ketqua_don kqd" +
                            //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                            //"         Where d.TOAANID = " + vToaAnID + "" +
                            //"         And d.LOAIDON = " + vLoaiDon + "" +
                            //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            //"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                            //"      UNION ALL" +
                            "      select" +
                            "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from gdttt_vuan_ketqua vd" +
                            "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                            "             where v.toaanid = " + vToaAnID + "" +
                            "             and vd.TRANGTHAI = 1" +
                            "             and v.LOAIAN = " + vLoaian + "" +
                            //"             --and NVL(v.IsVienTruongKN, 0) = 0" +
                            "             and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                            "             and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "             and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            " )tt ";
                        #endregion
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                //if (tbl != null && tbl.Rows.Count > 0)
                //{
                //    foreach (DataRow row in tbl.Rows)
                //    {
                //        row["v_maxTLxxgdt"] = row["v_maxTLxxgdt"];
                //    }
                //}
                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_maxTLxxgdt"].ToString()))
                    {
                        So = decimal.Parse(obj["v_maxTLxxgdt"].ToString());
                    }
                }
                return So + 1;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal SoTraLoi_AHS_GETMAXTT(decimal vToaAnID, decimal vYear, string vLoaian, string vLoaiDon)
        {
            try
            {
                string SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                  " from(" +
                  //"     select" +
                  //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                  //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                  //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                  //"                      )" +
                  //"                 ) as sotlxx" +
                  //"         from GDTTT_DON_TRALOI kqd" +
                  //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                  //"         Where d.TOAANID = " + vToaAnID + "" +
                  //"         And d.LOAIDON = " + vLoaiDon + "" +
                  //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  //"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                  //"      UNION ALL" +
                  "      select" +
                  "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                  "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                  "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                  "                      )" +
                  "                 ) as sotlxx" +
                  "         from GDTTT_VUAN v " +
                  "             where v.toaanid = " + vToaAnID + "" +
                  "             and v.LOAIAN = " + vLoaian + "" +
                  //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                  "                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                  "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                  "                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  " )tt ";
                if (vToaAnID == 4 || vToaAnID == 5) // cấp cao HN và ĐN
                {
                    if (vLoaiDon == "3" || vLoaiDon == "2" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                        " from(" +
                        //"     select" +
                        //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                        //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from GDTTT_DON_TRALOI kqd" +
                        //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                        //"         Where d.TOAANID = " + vToaAnID + "" +
                        //"         And d.LOAIDON = " + vLoaiDon + "" +
                        //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        ////"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                        //"      UNION ALL" +
                        "      select" +
                        "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_VUAN v " +
                        "             where v.toaanid = " + vToaAnID + "" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        "                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                        " from(" +
                        "     select" +
                        "         lower(DECODE(INSTR(kqd.SO, '/')" +
                        "                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_DON_TRALOI kqd" +
                        "         inner join GDTTT_VUAN v on v.ID = kqd.VUANID" +
                        "         Where v.TOAANID = " + vToaAnID + "";
                        if (vLoaiDon == "0")
                        {
                            SQL += "         And kqd.TYPETB = 3";
                        }
                        else
                        {
                            SQL += "         And kqd.TYPETB = 4";
                        }
                        SQL +=

                        "         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.LOAIAN = " + vLoaian + "" +
                        //"      UNION ALL" +
                        //"      select" +
                        //"          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        //"                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from GDTTT_VUAN v " +
                        //"             where v.toaanid = " + vToaAnID + "" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        ////"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        //"                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        //"                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        //"                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                }
                if (vToaAnID == 6)// cấp cao HCM
                {
                    if (vLoaiDon == "2" || vLoaiDon == "3" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS 
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                            " from(" +
                            //"     select" +
                            //"         lower(DECODE(INSTR(kqd.SO, '/')" +
                            //"                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                            //"                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                            //"                      )" +
                            //"                 ) as sotlxx" +
                            //"         from GDTTT_DON_TRALOI kqd" +
                            //"         inner join GDTTT_DON d on d.ID = kqd.DONID" +
                            //"         Where d.TOAANID = " + vToaAnID + "" +
                            ////"         And d.LOAIDON = " + vLoaiDon + "" +
                            //"         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            //"         and d.BAQD_LOAIAN = " + vLoaian + "" +
                            //"      UNION ALL" +
                            "      select" +
                            "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from GDTTT_VUAN v " +
                            "             where v.toaanid = " + vToaAnID + "" +
                            "             and v.LOAIAN = " + vLoaian + "" +
                            //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                            //"                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                            "                 and v.GQD_LOAIKETQUA != 0 " +
                            "                 and v.GQD_LOAIKETQUA != 1 " +
                            "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            " )tt ";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL = "select Max(to_number(regexp_replace(tt.sotlxx, '[^0-9]'))) as v_maxTLxxgdt  " +
                        " from(" +
                        "     select" +
                        "         lower(DECODE(INSTR(kqd.SO, '/')" +
                        "                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_DON_TRALOI kqd" +
                        "         inner join GDTTT_VUAN v on v.ID = kqd.VUANID" +
                        "         Where v.TOAANID = " + vToaAnID + "";
                        if (vLoaiDon == "0")
                        {
                            SQL += "         And kqd.TYPETB = 3";
                        }
                        else
                        {
                            SQL += "         And kqd.TYPETB = 4";
                        }
                        SQL +=

                        "         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.LOAIAN = " + vLoaian + "" +
                        //"      UNION ALL" +
                        //"      select" +
                        //"          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        //"                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from GDTTT_VUAN v " +
                        //"             where v.toaanid = " + vToaAnID + "" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        ////"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        //"                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        //"                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        //"                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                //if (tbl != null && tbl.Rows.Count > 0)
                //{
                //    foreach (DataRow row in tbl.Rows)
                //    {
                //        row["v_maxTLxxgdt"] = row["v_maxTLxxgdt"];
                //    }
                //}
                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_maxTLxxgdt"].ToString()))
                    {
                        So = decimal.Parse(obj["v_maxTLxxgdt"].ToString());
                    }
                }
                return So + 1;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal ThongTinXetXu_GETMAXTT(decimal vToaAnID, decimal vYear, string vLoaian)
        {
            try
            {
                String SQL = "select Max(to_number(regexp_replace(tt.XXGDTTT_SOQD, '[^0-9]'))) as v_XXGDTTT_SOQD " +
                "   from(" +
                "        select" +
                "            lower(DECODE(INSTR(v.XXGDTTT_SOQD, '/')" +
                "                       , 0, decode(INSTR(v.XXGDTTT_SOQD, '0'), 1, regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), v.XXGDTTT_SOQD), decode(INSTR(v.XXGDTTT_SOQD, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), 1, instr(regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), '/') - 1), SUBSTR(v.XXGDTTT_SOQD, 1, instr(v.XXGDTTT_SOQD, '/') - 1))" +
                "                        )" +
                "                   ) as XXGDTTT_SOQD" +
                "           from gdttt_vuan v" +
                "               where" +
                "                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.TRANGTHAIID = 15" +
                "                   and NVL(v.truonghopthuly, 0) not in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.XXGDTTT_NGAYQD between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "   )tt";

                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_XXGDTTT_SOQD"].ToString()))
                    {
                        So = decimal.Parse(obj["v_XXGDTTT_SOQD"].ToString());
                    }
                }
                return So + 1;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal ThongTinKhieuNai_GETMAXTT(decimal vToaAnID, decimal vYear, string vLoaian)
        {
            try
            {
                String SQL = "select Max(to_number(regexp_replace(tt.GDQ_SO, '[^0-9]'))) as v_GDQ_SO " +
                "   from(" +
                "        select" +
                "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                "                        )" +
                "                   ) as GDQ_SO" +
                "           from gdttt_vuan v" +
                "               where" +
                "                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.THAMQUYENXXGDT = 0" +
                "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "   )tt";
                if (vToaAnID == 5) // CCĐN
                {
                    SQL = "select Max(to_number(regexp_replace(tt.GDQ_SO, '[^0-9]'))) as v_GDQ_SO " +
               "   from(" +
               "        select" +
               "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
               "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
               "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
               "                        )" +
               "                   ) as GDQ_SO" +
               "           from gdttt_vuan v" +
               "               where" +
               "                v.toaanid = " + vToaAnID + "" +
               "                   and v.LOAIAN = " + vLoaian + "" +
               //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
               "                   and v.THAMQUYENXXGDT = 0" +
               "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
               "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
               "   )tt";
                    if (vLoaian != "1")
                    {
                        SQL = "select Max(to_number(regexp_replace(tt.GDQ_SO, '[^0-9]'))) as v_GDQ_SO " +
               "   from(" +
               "        select" +
               "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
               "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
               "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
               "                        )" +
               "                   ) as GDQ_SO" +
               "           from gdttt_vuan v" +
               "               where" +
               "                v.toaanid = " + vToaAnID + "" +
               //"                   and v.LOAIAN = " + vLoaian + "" +
               //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
               "                   and v.THAMQUYENXXGDT = 0" +
               "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
               "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
               "   )tt";
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_GDQ_SO"].ToString()))
                    {
                        So = decimal.Parse(obj["v_GDQ_SO"].ToString());
                    }
                }
                return So + 1;
            }
            catch (Exception ex) { return 0; }
        }
        #endregion

        #region Check Trung So cho văn bản
        public decimal HoanTHA_CheckTrungSo(decimal vToaAnID, decimal vYear, string vLoaian, string vGQD_HOANTHA_SO)
        {
            try
            {
                String SQL =
                "        select" +
                "            lower(DECODE(INSTR(v.GQD_HOANTHA_SO, '/')" +
                "                       , 0, decode(INSTR(v.GQD_HOANTHA_SO, '0'), 1, regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), v.GQD_HOANTHA_SO), decode(INSTR(v.GQD_HOANTHA_SO, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GQD_HOANTHA_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GQD_HOANTHA_SO, 1, instr(v.GQD_HOANTHA_SO, '/') - 1))" +
                "                        )" +
                "                   ) as GQD_HOANTHA_SO" +
                "           from gdttt_vuan v" +
                "               where" +
                "                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.GQD_ISHOANTHA = 1" +
                //"                   and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.GQD_HOANTHA_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "                   and v.GQD_HOANTHA_SO = '" + vGQD_HOANTHA_SO + "' "
                ;

                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_GQD_HOANTHA_SO"].ToString()))
                    {
                        So = decimal.Parse(obj["v_GQD_HOANTHA_SO"].ToString());
                    }
                }
                return So;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal SoTraLoi_CheckTrungSo(decimal vToaAnID, decimal vYear, string vLoaian, string vLoaiDon, string vGDQ_SO)
        {
            try
            {
                string SQL =
                  "      select" +
                  "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                  "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                  "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                  "                      )" +
                  "                 ) as sotlxx" +
                  "         from gdttt_vuan_ketqua vd" +
                  "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                  "             where v.toaanid = " + vToaAnID + "" +
                  "             and vd.TRANGTHAI = 1" +
                  "             and v.LOAIAN = " + vLoaian + "" +
                  //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                  "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                  "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                  "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  "                 and vd.GDQ_SO = '" + vGDQ_SO + "'";
                if (vToaAnID == 4 || vToaAnID == 5) // cấp cao HN và ĐN
                {
                    if (vLoaiDon == "3" || vLoaiDon == "2" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS
                    {
                        #region SQL
                        SQL =
                        "     select" +
                        "         lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_VUAN v" +
                        "         Where v.TOAANID = " + vToaAnID + "" +
                        "         And v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "         and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "         and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.GDQ_SO = '" + vGDQ_SO + "'";
                        //"      UNION ALL" +
                        //"      select" +
                        //"          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                        //"                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from gdttt_vuan_ketqua vd" +
                        //"         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                        //"             where v.toaanid = " + vToaAnID + "" +
                        //"             and vd.TRANGTHAI = 1" +
                        ////"             and v.LOAIAN = " + vLoaian + "" +
                        ////"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        //"                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        //"                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        //"                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        //"                 and vd.GDQ_SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL =
                        "      select" +
                        "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from gdttt_vuan_ketqua vd" +
                        "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                        "             where v.toaanid = " + vToaAnID + "" +
                        "             and vd.TRANGTHAI = 1" +
                        "             and v.LOAIAN = " + vLoaian + "" +
                        //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        " )tt ";
                        #endregion
                    }
                }
                if (vToaAnID == 6)// cấp cao HCM
                {
                    if (vLoaiDon == "2" || vLoaiDon == "3" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS 
                    {
                        #region SQL
                        SQL =
                            "     select" +
                        "         lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_VUAN v" +
                        "         Where v.TOAANID = " + vToaAnID + "" +
                        //"         And v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "         and v.GQD_LOAIKETQUA != 0 " +
                        "         and v.GQD_LOAIKETQUA != 1 " +
                        "         and v.LOAIAN = " + vLoaian + "" +
                        "         and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "         and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.GDQ_SO = '" + vGDQ_SO + "'";
                        //"      select" +
                        //"          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                        //"                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                        //"                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                        //"                      )" +
                        //"                 ) as sotlxx" +
                        //"         from gdttt_vuan_ketqua vd" +
                        //"         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                        //"             where v.toaanid = " + vToaAnID + "" +
                        //"             and vd.TRANGTHAI = 1" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        ////"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        ////"                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        //"                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        //"                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        //"                 and vd.GDQ_SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL =
                            "      select" +
                            "          lower(DECODE(INSTR(vd.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(vd.GDQ_SO, '0'), 1, regexp_replace(vd.GDQ_SO, '0', '', 1, 1), vd.GDQ_SO), decode(INSTR(vd.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(vd.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(vd.GDQ_SO, 1, instr(vd.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from gdttt_vuan_ketqua vd" +
                            "         inner join GDTTT_VUAN v on v.ID = vd.VUANID" +
                            "             where v.toaanid = " + vToaAnID + "" +
                            "             and vd.TRANGTHAI = 1" +
                            "             and v.LOAIAN = " + vLoaian + "" +
                            //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                            "                 and vd.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                            "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "                 and vd.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            "                 and vd.GDQ_SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_maxTLxxgdt"].ToString()))
                    {
                        So = decimal.Parse(obj["v_maxTLxxgdt"].ToString());
                    }
                }
                return So;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal SoTraLoi_AHS_CheckTrungSo(decimal vToaAnID, decimal vYear, string vLoaian, string vLoaiDon, string vGDQ_SO)
        {
            try
            {
                string SQL =
                  "      select" +
                  "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                  "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                  "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                  "                      )" +
                  "                 ) as sotlxx" +
                  "         from GDTTT_VUAN v " +
                  "             where v.toaanid = " + vToaAnID + "" +
                  "             and v.LOAIAN = " + vLoaian + "" +
                  //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                  "                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                  "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                  "                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                  "                 and v.GDQ_SO = '" + vGDQ_SO + "'";
                if (vToaAnID == 4 || vToaAnID == 5) // cấp cao HN và ĐN
                {
                    if (vLoaiDon == "3" || vLoaiDon == "2" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS
                    {
                        #region SQL
                        SQL =
                        "      select" +
                        "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                        "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_VUAN v " +
                        "             where v.toaanid = " + vToaAnID + "" +
                        //"             and v.LOAIAN = " + vLoaian + "" +
                        //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                        "                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                        "                 and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                        "                 and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "                 and v.GDQ_SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL =
                        "     select" +
                        "         lower(DECODE(INSTR(kqd.SO, '/')" +
                        "                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_DON_TRALOI kqd" +
                        "         inner join GDTTT_VUAN v on v.ID = kqd.VUANID" +
                        "         Where v.TOAANID = " + vToaAnID + "";
                        if (vLoaiDon == "0")
                        {
                            SQL += "         And kqd.TYPETB = 3";
                        }
                        else
                        {
                            SQL += "         And kqd.TYPETB = 4";
                        }
                        SQL +=

                        "         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.LOAIAN = " + vLoaian + "" +
                        "         and kqd.SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                }
                if (vToaAnID == 6)// cấp cao HCM
                {
                    if (vLoaiDon == "2" || vLoaiDon == "3" || vLoaiDon == "4")// xử lý khác + xếp đơn + VKS 
                    {
                        #region SQL
                        SQL =
                            "      select" +
                            "          lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                            "                     , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                            "                     , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                            "                      )" +
                            "                 ) as sotlxx" +
                            "         from GDTTT_VUAN v " +
                            "             where v.toaanid = " + vToaAnID + "" +
                            "             and v.LOAIAN = " + vLoaian + "" +
                            //"                 --and NVL(v.IsVienTruongKN, 0) = 0" +
                            //"                 and v.GQD_LOAIKETQUA = " + vLoaiDon + "" +
                            "             and v.GQD_LOAIKETQUA != 0 " +
                            "             and v.GQD_LOAIKETQUA != 1 " +
                            "             and NVL(v.truonghopthuly, 0) not in (8, 10, 1)" +
                            "             and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                            "             and v.GDQ_SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                    else
                    {
                        #region SQL
                        SQL =
                        "     select" +
                        "         lower(DECODE(INSTR(kqd.SO, '/')" +
                        "                     , 0, decode(INSTR(kqd.SO, '0'), 1, regexp_replace(kqd.SO, '0', '', 1, 1), kqd.SO), decode(INSTR(kqd.SO, '0')" +
                        "                     , 1, SUBSTR(regexp_replace(kqd.SO, '0', '', 1, 1), 1, instr(regexp_replace(kqd.SO, '0', '', 1, 1), '/') - 1), SUBSTR(kqd.SO, 1, instr(kqd.SO, '/') - 1))" +
                        "                      )" +
                        "                 ) as sotlxx" +
                        "         from GDTTT_DON_TRALOI kqd" +
                        "         inner join GDTTT_VUAN v on v.ID = kqd.VUANID" +
                        "         Where v.TOAANID = " + vToaAnID + "";
                        if (vLoaiDon == "0")
                        {
                            SQL += "         And kqd.TYPETB = 3";
                        }
                        else
                        {
                            SQL += "         And kqd.TYPETB = 4";
                        }
                        SQL +=

                        "         and kqd.NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                        "         and v.LOAIAN = " + vLoaian + "" +
                        "         and kqd.SO = '" + vGDQ_SO + "'";
                        #endregion
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_maxTLxxgdt"].ToString()))
                    {
                        So = decimal.Parse(obj["v_maxTLxxgdt"].ToString());
                    }
                }
                return So;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal ThongTinXetXu_CheckTrungSo(decimal vToaAnID, decimal vYear, string vLoaian, string vXXGDTTT_SOQD)
        {
            try
            {
                String SQL =
                "        select" +
                "            lower(DECODE(INSTR(v.XXGDTTT_SOQD, '/')" +
                "                       , 0, decode(INSTR(v.XXGDTTT_SOQD, '0'), 1, regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), v.XXGDTTT_SOQD), decode(INSTR(v.XXGDTTT_SOQD, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), 1, instr(regexp_replace(v.XXGDTTT_SOQD, '0', '', 1, 1), '/') - 1), SUBSTR(v.XXGDTTT_SOQD, 1, instr(v.XXGDTTT_SOQD, '/') - 1))" +
                "                        )" +
                "                   ) as XXGDTTT_SOQD" +
                "           from gdttt_vuan v" +
                "               where" +
                //"                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.XXGDTTT_ISKETQUA = 1" +
                "                   and NVL(v.truonghopthuly, 0) not in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.XXGDTTT_NGAYQD between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "                 and v.XXGDTTT_SOQD = '" + vXXGDTTT_SOQD + "'";

                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_XXGDTTT_SOQD"].ToString()))
                    {
                        So = decimal.Parse(obj["v_XXGDTTT_SOQD"].ToString());
                    }
                }
                return So;
            }
            catch (Exception ex) { return 0; }
        }
        public decimal ThongTinKhieuNai_CheckTrungSo(decimal vToaAnID, decimal vYear, string vLoaian, string vGDQ_SO)
        {
            try
            {
                String SQL =
                "        select" +
                "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
                "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
                "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
                "                        )" +
                "                   ) as GDQ_SO" +
                "           from gdttt_vuan v" +
                "               where" +
                "                v.toaanid = " + vToaAnID + "" +
                "                   and v.LOAIAN = " + vLoaian + "" +
                //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
                "                   and v.THAMQUYENXXGDT = 0" +
                "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
                "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
                "                 and v.GDQ_SO = '" + vGDQ_SO + "'";
                if (vToaAnID == 5) // CCĐN
                {
                    SQL =
               "        select" +
               "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
               "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
               "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
               "                        )" +
               "                   ) as GDQ_SO" +
               "           from gdttt_vuan v" +
               "               where" +
               "                v.toaanid = " + vToaAnID + "" +
               "                   and v.LOAIAN = " + vLoaian + "" +
               //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
               "                   and v.THAMQUYENXXGDT = 0" +
               "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
               "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
               "                 and v.GDQ_SO = '" + vGDQ_SO + "'";
                    if (vLoaian != "1")
                    {
                        SQL =
               "        select" +
               "            lower(DECODE(INSTR(v.GDQ_SO, '/')" +
               "                       , 0, decode(INSTR(v.GDQ_SO, '0'), 1, regexp_replace(v.GDQ_SO, '0', '', 1, 1), v.GDQ_SO), decode(INSTR(v.GDQ_SO, '0')" +
               "                       , 1, SUBSTR(regexp_replace(v.GDQ_SO, '0', '', 1, 1), 1, instr(regexp_replace(v.GDQ_SO, '0', '', 1, 1), '/') - 1), SUBSTR(v.GDQ_SO, 1, instr(v.GDQ_SO, '/') - 1))" +
               "                        )" +
               "                   ) as GDQ_SO" +
               "           from gdttt_vuan v" +
               "               where" +
               "                v.toaanid = " + vToaAnID + "" +
               //"                   and v.LOAIAN = " + vLoaian + "" +
               //"                   and NVL(v.IsVienTruongKN, 0) = 0" +
               "                   and v.THAMQUYENXXGDT = 0" +
               "                   and NVL(v.truonghopthuly, 0) in (8, 10)" +//Đơn khiếu nại tư pháp và ho so kn
               "                   and v.GDQ_NGAY between TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-01-01', 'YYYY-MM-DD') and TO_DATE(Cast((" + vYear + ") as varchar2(4)) || '-12-31', 'YYYY-MM-DD')" +
               "                 and v.GDQ_SO = '" + vGDQ_SO + "'";
                    }
                }
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);

                decimal So = 0;
                foreach (DataRow obj in tbl.Rows)
                {
                    if (!string.IsNullOrEmpty(obj["v_GDQ_SO"].ToString()))
                    {
                        So = decimal.Parse(obj["v_GDQ_SO"].ToString());
                    }
                }
                return So;
            }
            catch (Exception ex) { return 0; }
        }
        #endregion

        #region Xoa so thu ly 
        public bool DELETE_SOTHULY_GDTTT_DON(decimal vDON_ID, string vLydo, string vNguoiXoa, string vOBJECT)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vDON_ID", vDON_ID),
                    new OracleParameter("vLydo", vLydo),
                    new OracleParameter("vNguoiXoa",vNguoiXoa),
                    new OracleParameter("in_OBJECT",OracleDbType.Clob, vOBJECT,ParameterDirection.Input)
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.DELETE_SOTHULY_DON", parameters);
                return dbl == 1 ? true : false;
            }
            catch { return false; }

        }
        public bool DELETE_XuLyLai_DONTLM_GDTTT(decimal vDON_ID, string vNguoiXoa)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("vDON_ID", vDON_ID),
                    new OracleParameter("vNguoiXoa",vNguoiXoa),
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_HCTP_APP.DELETE_XULYLAI_DONTLM", parameters);
                return dbl == 1 ? true : false;
            }
            catch { return false; }

        }
        public DataTable DON_SEARCH_TONDON(String VARRSELECTID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VARRSELECTID",VARRSELECTID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_BC_APP.DON_SEARCH_TONDON", parameters);
            return tbl;
        }
        #endregion

        #region NC 13/9 
        public DataTable GDTTT_DON_SEARCH_NC(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
          String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
          string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
          decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
          string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
          decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
          decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
          , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
          decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     /*
                      ",(SoCVC.SOVB || SoCVCTK.SOVB ||  SoCVCN.SOVB ||  SoTralaidon.SOVB)  SVB_SOCV  " + 
                      ",(SoCVC.NGAYVB || SoCVCTK.NGAYVB ||  SoCVCN.NGAYVB ||  SoTralaidon.NGAYVB)  SVB_NGAYCV" +
                      ",(SoCVC.NGUOIKY || SoCVCTK.NGUOIKY ||  SoCVCN.NGUOIKY ||  SoTralaidon.NGUOIKY)  SVB_NGUOIKY " +
                      */
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB, dtp3.IS_TPB3"
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }
                //cuongnp them ngay 15/9
                SQL += " from GDTTT_DON d inner join GDTTT_DON_TPB3 dtp3 on d.ID=dtp3.ID and dtp3.IS_TPB3='1' ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
           /*
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTralaidon')SoTralaidon on SoTralaidon.donid = d.id   " +
          */
           "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + vToaAnID + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +
            //cuongnp

            "left join (select ID,HOTEN from DM_CANBO) c on  dtp3.THAMPHAN=c.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +
            " where d.TOAANID=" + vToaAnID + " " +
            " AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {   //Dong de anh Hoàng anh xem lại luong vi de nhu cu Tìm kiem tai HCTP dang sai 
                        //if (vTrangthai == 1)
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI in(1,2,4) OR  DTL_NC.TRANGTHAI in(1,2,4) )";
                        //}
                        //else if (vTrangthai == 3)
                        //{
                        //    SQL += " AND ( d.CD_TRANGTHAI in (3,4) AND tralai.ghichu IS NOT NULL )";//30/09/2024
                        //}
                        //else if (vTrangthai == 2)//da chuyen va da nhan 04/10/2024
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI = 2 OR  DTL_NC.TRANGTHAI=2)";
                        //}
                        //else if (vTrangthai == 0)//chưa chuyển
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI IS NULL OR  DTL_NC.TRANGTHAI IS NULL )";
                        //}

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none";
                        int rs = 0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                        }
                        if (rs > 0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }



                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        if (row["TOAANID"] + "" == "1")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                            }
                        }
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                {
                                    if (row["IS_TPB3"] + "" == "1")
                                    {
                                        row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> " + row["NOICHUYEN"] + "" + "</i></b> (Số " + row["SVB_SOCV"] + "" + " - " + row["SVB_NGAYCV"] + ")<br/>";
                                    }
                                    else
                                    {
                                        row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                    }
                                }
                            }
                            row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

        public DataTable GDTTT_DON_SEARCH_NC_TC(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
           String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
           string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     /*
                      ",(SoCVC.SOVB || SoCVCTK.SOVB ||  SoCVCN.SOVB ||  SoTralaidon.SOVB)  SVB_SOCV  " + 
                      ",(SoCVC.NGAYVB || SoCVCTK.NGAYVB ||  SoCVCN.NGAYVB ||  SoTralaidon.NGAYVB)  SVB_NGAYCV" +
                      ",(SoCVC.NGUOIKY || SoCVCTK.NGUOIKY ||  SoCVCN.NGUOIKY ||  SoTralaidon.NGUOIKY)  SVB_NGUOIKY " +
                      */
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB, dtp3.IS_TPB3"
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }
                //cuongnp them ngay 15/9
                SQL += " from GDTTT_DON d inner join GDTTT_DON_TPB3 dtp3 on d.ID=dtp3.ID and dtp3.IS_TPB3='0' ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
           /*
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTralaidon')SoTralaidon on SoTralaidon.donid = d.id   " +
          */
           "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + vToaAnID + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +
            //cuongnp

            "left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +
            " where d.TOAANID=" + vToaAnID + " " +
            " AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {   //Dong de anh Hoàng anh xem lại luong vi de nhu cu Tìm kiem tai HCTP dang sai 
                        //if (vTrangthai == 1)
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI in(1,2,4) OR  DTL_NC.TRANGTHAI in(1,2,4) )";
                        //}
                        //else if (vTrangthai == 3)
                        //{
                        //    SQL += " AND ( d.CD_TRANGTHAI in (3,4) AND tralai.ghichu IS NOT NULL )";//30/09/2024
                        //}
                        //else if (vTrangthai == 2)//da chuyen va da nhan 04/10/2024
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI = 2 OR  DTL_NC.TRANGTHAI=2)";
                        //}
                        //else if (vTrangthai == 0)//chưa chuyển
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI IS NULL OR  DTL_NC.TRANGTHAI IS NULL )";
                        //}

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none";
                        int rs = 0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                        }
                        if (rs > 0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }



                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        if (row["TOAANID"] + "" == "1")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                            }
                        }
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                {
                                    if (row["IS_TPB3"] + "" == "1")
                                    {
                                        row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> " + row["NOICHUYEN"] + "" + "</i></b> (Số " + row["SVB_SOCV"] + "" + " - " + row["SVB_NGAYCV"] + ")<br/>";
                                    }
                                    else
                                    {
                                        row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                    }
                                }
                            }
                            row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }
        public DataTable DON_GETTHEOKETQUAID_CHIDINH(decimal vToaAnID, decimal vKetQuaID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID, string vLoaitp)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vKetQuaID",vKetQuaID),
                  new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                  new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vLoaiTP",vLoaitp),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.DON_GETTHEOKETQUAID_CHIDINH", prm);
        }
        public DataTable THAMPHAN_GETBY_NC(decimal toaanID, string vloaiTP, decimal phongbanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vloaitp",vloaiTP),
                                                                         new OracleParameter("vtoaanid",toaanID),
                                                                         new OracleParameter("vphongbanid",phongbanid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.get_ds_thamphan", parameters);
            return tbl;
        }
        public string GET_TPB3(decimal vDonID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_DONID",vDonID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.GET_TPB3", prm).Rows[0]["IS_TPB3"].ToString();
        }
        //tpb3        
        public DataTable GDTTT_DON_GETPTP_TPB3(decimal vToaAnID, DateTime? vTuNgay, DateTime? vDenNgay,
          decimal vNoiChuyen, decimal vTrangthai, decimal vIsThuLy, string vNguoiNhap, string varrLoaiAn, decimal vHinhThuc,
          DateTime? vNgayTL, string vSoThuLy, string vSoBAQD)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vTuNgay",vTuNgay),
                                        new OracleParameter("vDenNgay",vDenNgay),
                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                        new OracleParameter("vTrangthai",vTrangthai),
                                        new OracleParameter("vIsThuLy",vIsThuLy),
                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                        new OracleParameter("varrLoaiAn",varrLoaiAn),
                                        new OracleParameter("vHinhThuc",vHinhThuc),
                                        new OracleParameter("vNgayTL",vNgayTL),
                                        new OracleParameter("vSoThuLy",vSoThuLy),
                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.DON_GETCHUAPCTP", parameters);
            return tbl;
        }

        public decimal GET_TPB3_THAMPHAN(decimal vDonID)
        {
            try
            {
                OracleParameter[] prm = new OracleParameter[]
           {
                new OracleParameter("v_DONID",vDonID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
           };
                return Convert.ToDecimal(Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.GET_TPB3", prm).Rows[0]["THAMPHAN"].ToString());
            }
            catch (Exception e) { return 0; }

        }
        public bool TPB3_INSERT(decimal v_ID, string v_IsTPB3, string isInvalid)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_ID", v_ID),
                                    new OracleParameter("v_IsTPB3", v_IsTPB3),
                                    new OracleParameter("v_isInvalid", isInvalid)

                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_TPB3.TPB3_INSERT", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        //-- Phân công chỉ đinh
        public DataTable GDTTT_DON_GETPCTPNC_CD(decimal vToaAnID, DateTime? vTuNgay, DateTime? vDenNgay,
          decimal vNoiChuyen, decimal vTrangthai, decimal vIsThuLy, string vNguoiNhap, string varrLoaiAn, string loaiTP, string soThuLy, string ngayThuLy, string soBAQD, int vHinhthuc)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                            new OracleParameter("vTuNgay",vTuNgay),
                                        new OracleParameter("vDenNgay",vDenNgay),
                                            new OracleParameter("vNoiChuyen",vNoiChuyen),
                                            new OracleParameter("vTrangthai",vTrangthai),
                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                    new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                new OracleParameter("varrLoaiAn",varrLoaiAn),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.DON_GETCHUAPCTP_CD", parameters);
            return tbl;
        }

        //Phan cong ngau nhien TP bac 3
        public decimal PHANCONGNGAUNHIEN_TPB3(decimal vToaAnID, DateTime vTuNgay, DateTime vDenNgay, string vNguoiNhap, string varrLoaiAn, decimal vNguoithuchien)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                 new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("varrLoaiAn",varrLoaiAn),
                new OracleParameter("vNguoithuchien",vNguoithuchien),
            };
            return Cls_Comon.ExcuteProcResult("PKG_GDTTT_TPB3.PHANCONGNGAUNHIEN_TPB3", prm);
        }
        //Phân công chỉ định
        public decimal PHANCONGCHIDINH(decimal vToaAnID, DateTime vTuNgay, DateTime vDenNgay, string vNguoiNhap, string varrLoaiAn, string vNguoithuchien, decimal vNguoithuchienID,
            string ds, string loaiTP, decimal thamPhanId)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                 new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("varrLoaiAn",varrLoaiAn),
                new OracleParameter("vNguoithuchien",vNguoithuchien),
                new OracleParameter("vNguoithuchienID",vNguoithuchienID),
                new OracleParameter("vDs",ds),
                new OracleParameter("vLoaithamphan",loaiTP),
                new OracleParameter("vThamphan",thamPhanId)
            };
            return Cls_Comon.ExcuteProcResult("PKG_GDTTT_TPB3.PHANCONGCHIDINH", prm);
        }
        public DataTable DON_LICHSUPHANCONG_NC(decimal vToaAnID, string vSoTT, string vNgayTT, string vPC_TuNgay, string vPC_DenNgay, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID, string loaipc)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vSoToTrinh",vSoTT),
                new OracleParameter("vNgayToTrinh",vNgayTT),
                new OracleParameter("vPC_TuNgay",vPC_TuNgay),
                new OracleParameter("vPC_DenNgay",vPC_DenNgay),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vLoaiPhanCong",Convert.ToDecimal(loaipc)),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.DON_LICHSUPHANCONG", prm);
        }
        #endregion

        #region danh sách vụ án kháng nghị
        public bool CHECK_VUAN_KHANGNGHI_LUUSO(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, decimal vVUANID, decimal vDonVi)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("vVUANID", vVUANID),
                                    new OracleParameter("vDonVi", vDonVi)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VUAN_LUUSO", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public bool CHECK_VUAN_SOVANBAN(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, string v_SOVB, string v_NGAYVB)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_VUAN_SOVANBAN", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public decimal SOVANBAN_VUAN_INSERT(decimal v_ToaAnID, decimal v_PhongbanID, decimal v_ISDONVI, string v_ThamphanID,
            string v_MASO, string v_SOVB, string v_NGAYVB, string v_NGUOIKY, string v_CHUCVU, string V_NGUOITAO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_ToaAnID", v_ToaAnID),
                                    new OracleParameter("v_PhongbanID", v_PhongbanID),
                                    new OracleParameter("v_ISDONVI", v_ISDONVI),
                                    new OracleParameter("v_ThamphanID", v_ThamphanID),
                                    new OracleParameter("v_MASO", v_MASO),
                                    new OracleParameter("v_SOVB", v_SOVB),
                                    new OracleParameter("v_NGAYVB", v_NGAYVB),
                                    new OracleParameter("v_NGUOIKY", v_NGUOIKY),
                                    new OracleParameter("v_CHUCVU", v_CHUCVU),
                                    new OracleParameter("V_NGUOITAO", V_NGUOITAO)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.SOVANBAN_VUAN_INSERT", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public bool SOPHATHANH_VUAN_INSERT(decimal v_SOPHATHANH_ID, decimal v_VUANID, string V_NGUOITAO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("v_SOPHATHANH_ID", v_SOPHATHANH_ID) ,
                                    new OracleParameter("v_VUANID", v_VUANID),
                                    new OracleParameter("V_NGUOITAO", V_NGUOITAO)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.SOPHATHANH_VUAN_INSERT", parameters);
                return dbl == 1 ? true : false;
            }
            catch (Exception ex) { return false; }
        }

        public decimal CHECK_TOTRINH_VUAN(decimal v_ToaAnID, decimal vPhongbanID, decimal vVuanID, string vMASO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vVuanID", vVuanID),
                                    new OracleParameter("vMASO", vMASO),
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_SOTOTRINH_VUAN", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public DataTable GET_SOTOTRINH_SOVB_VUAN(decimal vToaAnID, decimal vPhongbanID, string vLoaiso, string vSOVB, decimal vYear)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("vLoaiso",vLoaiso),
                                        new OracleParameter("vSOVB",vSOVB),
                                        new OracleParameter("vYear",vYear),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GET_SOTOTRINH_SOVB_VUAN", parameters);
            return dbl;
        }

        public decimal CHECK_TOTRINH_TLL_VUAN(decimal v_ToaAnID, decimal vPhongbanID, decimal vVuanid)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vVuanid", vVuanid)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_SOTOTRINH_VUAN_TLL", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public DataTable GET_SOVB_VUAN(String vMASO, decimal vToaAnID, decimal vPhongbanID, decimal vVuanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vMASO",vMASO),
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vPhongbanID",vPhongbanID),
                                        new OracleParameter("vVuanID",vVuanID),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GET_SOVB_VUAN", parameters);
            return dbl;
        }

        public DataTable GET_THAMPHAN_VUAN(decimal vToaAnID, decimal vPhongbanID, string vLoaiSO, string arrVuanID, string v_SOVB, string v_NGAYVB)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("vToaAnID", vToaAnID) ,
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vLoaiSO", vLoaiSO),
                                    new OracleParameter("arrVuanID",arrVuanID),
                                    new OracleParameter("v_SOTOTRINH", v_SOVB),
                                    new OracleParameter("v_NGAYTOTRINH", v_NGAYVB),
                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GET_THAMPHAN_VUAN", parameters);
            return tbl;
        }

        public decimal SOVB_GETMAXTT_VUAN(decimal donviID, decimal Phongbanid, decimal vYear, string vLOAISO)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vPhongbanid",Phongbanid),
                                                                        new OracleParameter("vYear",vYear),
                                                                        new OracleParameter("vLoaiso",vLOAISO),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.QLSOVB_GETMAXTT_VUAN", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }

        public decimal CHECK_SOVB_VUAN(String V_MASO, decimal v_ToaAnID, decimal vPhongbanID, decimal vVuanid)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                    new OracleParameter("V_MASO", V_MASO),
                                    new OracleParameter("vToaanid", v_ToaAnID),
                                    new OracleParameter("vPhongbanID", vPhongbanID),
                                    new OracleParameter("vVuanid", vVuanid)
                };

                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.CHECK_SOVB_VUAN", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public decimal GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL()
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public decimal GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL()
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }

        public DataTable GDTTT_VUAN_KHANGNGHI_GETCPC(decimal vToaAnID, DateTime? vTuNgay, DateTime? vDenNgay, decimal vNoiChuyen, decimal vTrangthai, decimal vIsThuLy,
            string vNguoiNhap, string varrLoaiAn, decimal vHinhThuc)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vTuNgay",vTuNgay),
                                        new OracleParameter("vDenNgay",vDenNgay),
                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                        new OracleParameter("vTrangthai",vTrangthai),
                                        new OracleParameter("vIsThuLy",vIsThuLy),
                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                        new OracleParameter("varrLoaiAn",varrLoaiAn),
                                        new OracleParameter("vHinhThuc",vHinhThuc),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.VAKN_GETCHUAPCTP", parameters);
            return tbl;
        }

        public DataTable VAKN_GET_THEO_KETQUA_CHIDINHID(decimal vToaAnID, DateTime? vTuNgay, DateTime? vDenNgay, decimal vNoiChuyen, decimal vTrangthai, decimal vIsThuLy,
            string vNguoiNhap, string varrLoaiAn, decimal vHinhThuc, decimal vKetQuaID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vToaAnID",vToaAnID),
                                        new OracleParameter("vTuNgay",vTuNgay),
                                        new OracleParameter("vDenNgay",vDenNgay),
                                        new OracleParameter("vNoiChuyen",vNoiChuyen),
                                        new OracleParameter("vTrangthai",vTrangthai),
                                        new OracleParameter("vIsThuLy",vIsThuLy),
                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                        new OracleParameter("varrLoaiAn",varrLoaiAn),
                                        new OracleParameter("vHinhThuc",vHinhThuc),
                                        new OracleParameter("vKetQuaID",vKetQuaID),
                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.VAKN_GET_THEO_KETQUA_CHIDINHID", parameters);
            return tbl;
        }

        public decimal INSERT_PHANCONG_CHIDINH_VAKN_TPTC(decimal vToaAnID, DateTime vTuNgay, DateTime vDenNgay, string vNguoiNhap, string varrLoaiAn, string vNguoithuchien, decimal vNguoithuchienID,
            string loaiTP, decimal thamPhanID, List<decimal> lstVuANID)
        {
            decimal vKetQua = 0;
            OracleCommand cmd = null;
            String connection_string = System.Configuration.ConfigurationManager.ConnectionStrings["GSTPConnection"].ConnectionString;

            using (OracleConnection conn = new OracleConnection())
            {
                conn.ConnectionString = connection_string;
                conn.Open();
                OracleTransaction transaction = conn.BeginTransaction();
                try
                {
                    using (cmd = conn.CreateCommand())
                    {
                        cmd.Transaction = transaction;  // Gắn transaction vào command
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "PKG_GDTTT_VUAN_KHANGNGHI.INSERT_GDTTT_PCTP_VAKN_CHIDINH";

                        #region add param
                        var returnParam = new OracleParameter("RETURN_VALUE", OracleDbType.Int32);
                        returnParam.Direction = ParameterDirection.ReturnValue;
                        cmd.Parameters.Add(returnParam);

                        cmd.Parameters.Add("vToaAnID", OracleDbType.Decimal).Value = vToaAnID;
                        cmd.Parameters.Add("vTuNgay", OracleDbType.Date).Value = vTuNgay;
                        cmd.Parameters.Add("vDenNgay", OracleDbType.Date).Value = vDenNgay;
                        cmd.Parameters.Add("varrLoaiAn", OracleDbType.Varchar2).Value = varrLoaiAn;
                        cmd.Parameters.Add("vNguoithuchien", OracleDbType.Varchar2).Value = vNguoithuchien;
                        cmd.Parameters.Add("vNguoithuchienID", OracleDbType.Decimal).Value = vNguoithuchienID;
                        cmd.Parameters.Add("vLoaithamphan", OracleDbType.Varchar2).Value = TYPE_THAMPHAN.TPB3;
                        #endregion

                        cmd.ExecuteNonQuery();
                        vKetQua = ((Oracle.ManagedDataAccess.Types.OracleDecimal)returnParam.Value).ToInt32();
                    }

                    foreach (var item in lstVuANID)
                    {
                        using (cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = transaction;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "PKG_GDTTT_VUAN_KHANGNGHI.INSERT_GDTTT_PCTP_VAKN_CHIDINH_CHITIET";

                            #region add param
                            var returnParam = new OracleParameter("RETURN_VALUE", OracleDbType.Int32);
                            returnParam.Direction = ParameterDirection.ReturnValue;
                            cmd.Parameters.Add(returnParam);

                            cmd.Parameters.Add("vToaAnID", OracleDbType.Decimal).Value = vToaAnID;
                            cmd.Parameters.Add("vChiDinhID", OracleDbType.Decimal).Value = vKetQua;
                            cmd.Parameters.Add("vVuAnID", OracleDbType.Decimal).Value = item;
                            cmd.Parameters.Add("vCanBoID", OracleDbType.Decimal).Value = thamPhanID;
                            #endregion
                            cmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit(); //commit
                }
                catch (Exception ex)
                {
                    transaction.Rollback(); //rollback lại nếu lỗi

                    Console.WriteLine("Lỗi: " + ex.Message);
                    Console.WriteLine("StackTrace: " + ex.StackTrace);
                }
                return vKetQua;
            }
        }

        public decimal PHANCONGNGAUNHIEN_VAKN(decimal vToaAnID, DateTime vTuNgay, DateTime vDenNgay, string vNguoiNhap, string varrLoaiAn, decimal vNguoithuchien)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                 new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("varrLoaiAn",varrLoaiAn),
                new OracleParameter("vNguoithuchien",vNguoithuchien)
            };
            return Cls_Comon.ExcuteProcResult("PKG_GDTTT_VUAN_KHANGNGHI.PHANCONGNGAUNHIEN_VAKN", prm);
        }

        public DataTable GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN(decimal vToaAnID, decimal vKetQuaID, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD, string vNguoiGui, string vNgayThuly, string vSoThuly, decimal vThamphanID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vKetQuaID",vKetQuaID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vNgayThuly",vNgayThuly),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN", prm);
        }

        public DataTable GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD,
            string vSoBAQD, string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay, decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh,
            decimal vDiaChiHuyen, string vDiaChiCT, string VLOAISOVB, string vSoCongVan, string vNgayCongVan, decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly,
            DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So,
            string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vPhongBanID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoCMND",vSoCMND),
                new OracleParameter("vTuNgay",vTuNgay),
                new OracleParameter("vDenNgay",vDenNgay),
                new OracleParameter("vHinhThucDon",vHinhThucDon),
                new OracleParameter("vSoHieuDon",vSoHieuDon),
                new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                new OracleParameter("vDiaChiCT",vDiaChiCT),
                new OracleParameter("VLOAISOVB",VLOAISOVB),
                new OracleParameter("vSoCongVan",vSoCongVan),
                new OracleParameter("vNgayCongVan",vNgayCongVan),
                new OracleParameter("vTraLoi",vTraLoi),
                new OracleParameter("vNguoiNhap",vNguoiNhap),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                new OracleParameter("vArrSelectID",vArrSelectID),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vChidao",vChidao),
                new OracleParameter("vTraigiam",vTraigiam),
                new OracleParameter("vTBQuahan",vTBQuahan),
                new OracleParameter("vNgayQuahan",vNgayQuahan),
                new OracleParameter("vThamphanID",vThamphanID),
                new OracleParameter("vThamtravienID",vThamtravienID),
                new OracleParameter("vLoaiCVID",vLoaiCVID),
                new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                new OracleParameter("vIsDonGoc",vIsDonGoc),
                new OracleParameter("vIsTuHinh",vIsTuHinh),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vCVPC_So",vCVPC_So),
                new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KHANGNGHI.GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG", parameters);
            return tbl;
        }
        #endregion


        public DataTable DS_ThamPhan_TongAN(decimal vToaAnID,decimal vPhongBanId, decimal vNamTL, string vChucDanh)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanId",vPhongBanId),                
                new OracleParameter("vNamTL",vNamTL),
                new OracleParameter("vChucDanh",vChucDanh),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_TPB3.TONGDON_TP3_GETBYDONVI", prm);
        }
    }
}