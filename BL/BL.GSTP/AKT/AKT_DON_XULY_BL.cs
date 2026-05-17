using BL.GSTP.BANGSETGET;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class AKT_DON_XULY_BL
    {
        public DataTable GetByDonID(decimal donID, int PageIndex, int PageSize)
        {       
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),                                                                        
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AKT_DON_XULY_GETBYDONID", parameters);
            return tbl;
        }
        public DataTable GetTinhTrangVuViec(decimal vu_viec_id)
        {
            string ma_loai = ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_viec_id",vu_viec_id),
                                                                        new OracleParameter("ma_loai_vu_viec",ma_loai),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AKT_Don_GetTinhTrang", parameters);
            return tbl;
        }

        public DataTable CHECK_AKT_DON_DUONGSU_ANPHI(decimal? DONID, decimal? DONCHITIETID, decimal ISDONCHITIET)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID", DONID),
                new OracleParameter("vDONCHITIETID", DONCHITIETID),
                new OracleParameter("vISDONCHITIET", ISDONCHITIET),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.CHECK_AKT_DON_DUONGSU_ANPHI", prm);
        }
        
        public DataTable CHECK_AKT_DON_DUONGSU_ANPHI_V2(decimal? DONID, decimal? DONCHITIETID, decimal ISDONCHITIET)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID", DONID),
                new OracleParameter("vDONCHITIETID", DONCHITIETID),
                new OracleParameter("vISDONCHITIET", ISDONCHITIET),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_DUONGSU_ANPHI.CHECK_AKT_DON_DUONGSU_ANPHI_V2", prm);
        }


        public DataTable AKT_GETALL_DON_YCBS(decimal donID, decimal donYCBS_ID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("DonYCBS_ID",donYCBS_ID),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_YCBS.AKT_DON_YCBS_GETBYDONID", parameters);
            return tbl;
        }

        public bool DON_YCBS_INUP(DON_YEUCAU_BOSUNG obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_YCBS.INSERT_DON_YCBS_GETBYDONID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["vID"].Value = obj.ID;
            comm.Parameters["vDONID"].Value = obj.DONID;
            comm.Parameters["vLOAIAN"].Value = obj.LOAIAN;
            comm.Parameters["vDON_XULYID"].Value = obj.DON_XULYID;
            comm.Parameters["vLOAIGIAIQUYET"].Value = obj.LOAIGIAIQUYET;
            comm.Parameters["vNGAYGQ_YC"].Value = obj.NGAYGQ_YC;
            comm.Parameters["vLYDO"].Value = obj.LYDO;
            comm.Parameters["vCDTN_TOAANID"].Value = obj.CDTN_TOAANID;
            comm.Parameters["vCDTN_NGAYNHAN"].Value = obj.CDTN_NGAYNHAN;
            comm.Parameters["vCDNN_TENCQ"].Value = obj.CDNN_TENCQ;
            comm.Parameters["vTRADON_CANCUID"].Value = obj.TRADON_CANCUID;
            comm.Parameters["vNGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["vNGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["vNGAYSUA"].Value = obj.NGAYSUA;
            comm.Parameters["vNGUOISUA"].Value = obj.NGUOISUA;
            comm.Parameters["vCDNN_NGAYCHUYEN"].Value = obj.CDNN_NGAYCHUYEN;
            comm.Parameters["vTRADON_LYDOID"].Value = obj.TRADON_LYDOID;
            comm.Parameters["vTRADON_NGAYTRA"].Value = obj.TRADON_NGAYTRA;
            comm.Parameters["vYCBS_NGAYYEUCAU"].Value = obj.YCBS_NGAYYEUCAU;
            comm.Parameters["vYCBS_NOIDUNG"].Value = obj.YCBS_NOIDUNG;
            comm.Parameters["vCDTN_NGAYCHUYEN"].Value = obj.CDTN_NGAYCHUYEN;
            comm.Parameters["vSOTHONGBAO"].Value = obj.SOTHONGBAO;
            comm.Parameters["vFILEID"].Value = obj.FILEID;
            comm.Parameters["vYCBS_THOIHAN"].Value = obj.YCBS_THOIHAN;
            comm.Parameters["vTOAANID"].Value = obj.TOAANID;
            comm.Parameters["vNGAYTHONGBAO"].Value = obj.NGAYTHONGBAO;
            comm.Parameters["vDON_CHITIETID"].Value = obj.DON_CHITIETID;
            comm.Parameters["vSOHIEU"].Value = obj.SOHIEU;
            comm.Parameters["vNGAYBOSUNG"].Value = obj.NGAYBOSUNG;
            comm.Parameters["vDON_XULY_YCBS_ID"].Value = obj.DON_XULY_YCBS_ID;
            comm.Parameters["vSTB_PHU"].Value = obj.STB_PHU;
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


    }
}