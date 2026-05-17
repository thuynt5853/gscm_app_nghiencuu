using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.GDTTT
{
    public class VT_VANTHU_DEN_BL
    {
        public bool VAN_BAN_DEN_INS_UP(VT_VANBANDEN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_DEN_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_LOAI_VB"].Value = obj.LOAI_VB;
            comm.Parameters["V_SODEN"].Value = obj.SODEN;
            comm.Parameters["V_NGAY_DEN"].Value = obj.NGAY_DEN;
            comm.Parameters["V_NGUOI_GUI_BT"].Value = obj.NGUOI_GUI_BT;
            comm.Parameters["V_DIACHI_GUI_BT"].Value = obj.DIACHI_GUI_BT;
            comm.Parameters["V_NGAY_BT"].Value = obj.NGAY_BT;
            comm.Parameters["V_NOI_NHAN"].Value = obj.NOI_NHAN;
            comm.Parameters["V_NGUOI_NHAN"].Value = obj.NGUOI_NHAN;
            comm.Parameters["V_GHICHU"].Value = obj.GHICHU;
            comm.Parameters["V_SO_VB"].Value = obj.SO_VB;
            comm.Parameters["V_NGAY_VB"].Value = obj.NGAY_VB;
            comm.Parameters["V_NOIDUNG_VB"].Value = obj.NOIDUNG_VB;
            comm.Parameters["V_SOLUONG_DON"].Value = obj.SOLUONG_DON;

            comm.Parameters["V_LOAI_GDTTTT"].Value = obj.LOAI_GDTTTT;
            comm.Parameters["V_BAQD_CHECK_DON"].Value = obj.BAQD_CHECK_DON;
            comm.Parameters["V_LOAI_AN_DON"].Value = obj.LOAI_AN_DON;
            comm.Parameters["V_CAP_XX_DON"].Value = obj.CAP_XX_DON;
            comm.Parameters["V_SO_BAQD_DON"].Value = obj.SO_BAQD_DON;
            comm.Parameters["V_NGAY_BAQD_DON"].Value = obj.NGAY_BAQD_DON;
            comm.Parameters["V_TOAAN_BAQD_DON"].Value = obj.TOAAN_BAQD_DON;

            comm.Parameters["V_BIDON"].Value = obj.BIDON_DON;
            comm.Parameters["V_NGUYENDON"].Value = obj.NGUYENDON_DON;
            comm.Parameters["V_QHPL_DS"].Value = obj.QHPL_DS_DON;
            comm.Parameters["V_QHPL_HS"].Value = obj.QHPL_HS_DON;
            comm.Parameters["V_SOLUONG_GAM"].Value = obj.SOLUONG_GAM;


            comm.Parameters["V_SO_CV"].Value = obj.SO_CV;
            comm.Parameters["V_NGAY_CV"].Value = obj.NGAY_CV;
            comm.Parameters["V_DONVICHUYEN_CV"].Value = obj.DONVICHUYEN_CV;
            comm.Parameters["V_NOIDUNG_CV"].Value = obj.NOIDUNG_CV;

            comm.Parameters["V_DVXULY_ID_DON"].Value = obj.DVXULY_ID_DON;
            comm.Parameters["V_CANBONHAN_ID"].Value = obj.CANBONHAN_ID;
            comm.Parameters["V_NGAY_GIAO_DON"].Value = obj.NGAY_GIAO_DON;

            comm.Parameters["V_SO_HS"].Value = obj.SO_HS;
            comm.Parameters["V_NGAY_HS"].Value = obj.NGAY_HS;
            comm.Parameters["V_DONVICHUYEN_HS"].Value = obj.DONVICHUYEN_HS;

            comm.Parameters["V_GHICHU_HS"].Value = obj.GHICHU_HS;
            comm.Parameters["V_NGUOI_TAO"].Value = obj.NGUOI_TAO;
            comm.Parameters["V_TOAANID"].Value = obj.TOAANID;
            comm.Parameters["V_NGUON_DEN"].Value = obj.NGUON_DEN;

            comm.Parameters["V_MABD"].Value = obj.MABD;
            comm.Parameters["V_NGUOIDUNGDON"].Value = obj.NGUOIDUNGDON;
            comm.Parameters["V_DIACHI_NDD"].Value = obj.DIACHI_NDD;
            comm.Parameters["V_DOMAT_ID"].Value = obj.DOMAT_ID;
            comm.Parameters["V_DO_KHAN_ID"].Value = obj.DO_KHAN_ID;

            comm.Parameters["V_DIACHI_GUI_BT_ID"].Value = obj.DIACHI_GUI_BT_ID;
            comm.Parameters["V_DIACHI_NDD_ID"].Value = obj.DIACHI_NDD_ID;

            comm.Parameters["V_ID_VBDH"].Value = obj.ID_VBDH;
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
        public DataTable PHONG_BAN_LIST(string V_TOAANID, String V_PHONGBAN_ID, String V_LOAI_COMBO)
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("V_TOAANID",V_TOAANID),
                new OracleParameter("V_PHONGBAN_ID",V_PHONGBAN_ID),
                new OracleParameter("V_LOAI_COMBO",V_LOAI_COMBO),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.DM_PHONGBAN_LIST", parameters);
            return tbl;
        }
        public DataTable LANHDAO_LIST(string V_TOAANID, string V_PHONGBANID)
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("V_TOAANID",V_TOAANID),
                new OracleParameter("V_PHONGBANID",V_PHONGBANID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.LANH_DAO_LIST", parameters);
            return tbl;
        }
        public DataTable CANBO_LIST_BY_PHONGBAN(string V_TOAANID, string V_PHONGBANID)
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("V_TOAANID",V_TOAANID),
                new OracleParameter("V_PHONGBANID",V_PHONGBANID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.CANBO_LIST_BY_PHONGBAN", parameters);
            return tbl;
        }
        public void SODEN_RETURN(String V_TOAANID, String V_PHONGBANID, String V_LOAI_VB, ref Int32 V_SODEN_TO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.SODEN_GET", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
            comm.Parameters["V_LOAI_VB"].Value = V_LOAI_VB;
            comm.Parameters["V_SODEN"].Direction = ParameterDirection.Output;
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
                V_SODEN_TO = Convert.ToInt32(comm.Parameters["V_SODEN"].Value);
                conn.Close();
            }
        }
        public DataTable VT_VANBANDEN_SEARCH_APP(String V_TOAANID, String V_NGUON_DEN, String V_NGUOIDUNGDON, String V_LOAI_AN_DON, String V_TOAAN_BAQD_DON, String V_SO_BAQD_DON, String V_NGAY_BAQD_DON, String V_NGUOI_TAO, String V_PHONGBAN_ID, String V_LOAI_VB, String V_NOI_NHAN, String V_NGUOI_NHAN, String V_SODEN_TU, String V_SODEN_DEN,
            String V_ID, String V_LOAI_NGAY, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT, String V_DIACHI_GUI_BT, String V_GHICHU
            , String V_TRANGTHAICHUYEN, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_TOAANID", V_TOAANID),
            new OracleParameter("V_NGUON_DEN", V_NGUON_DEN),
            new OracleParameter("V_NGUOIDUNGDON", V_NGUOIDUNGDON),
            new OracleParameter("V_LOAI_AN_DON", V_LOAI_AN_DON),
            new OracleParameter("V_TOAAN_BAQD_DON", V_TOAAN_BAQD_DON),
            new OracleParameter("V_SO_BAQD_DON", V_SO_BAQD_DON),
            new OracleParameter("V_NGAY_BAQD_DON", V_NGAY_BAQD_DON),
            new OracleParameter("V_NGUOI_TAO", V_NGUOI_TAO),
            new OracleParameter("V_PHONGBAN_ID", V_PHONGBAN_ID),
            new OracleParameter("V_LOAI_VB",V_LOAI_VB),
            new OracleParameter("V_NOI_NHAN",V_NOI_NHAN),
            new OracleParameter("V_NGUOI_NHAN",V_NGUOI_NHAN),
            new OracleParameter("V_SODEN_TU",V_SODEN_TU),
            new OracleParameter("V_SODEN_DEN",V_SODEN_DEN),
            new OracleParameter("V_ID",V_ID),
            new OracleParameter("V_LOAI_NGAY",V_LOAI_NGAY),
            new OracleParameter("V_NGAY_FROM",V_NGAY_FROM),
            new OracleParameter("V_NGAY_TO",V_NGAY_TO),
            new OracleParameter("V_NGUOI_GUI_BT",V_NGUOI_GUI_BT),
            new OracleParameter("V_DIACHI_GUI_BT",V_DIACHI_GUI_BT),
            new OracleParameter("V_GHICHU",V_GHICHU),
            new OracleParameter("V_TRANGTHAICHUYEN",V_TRANGTHAICHUYEN),
            new OracleParameter("PageIndex",PageIndex),
            new OracleParameter("PageSize",PageSize),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VT_VANBANDEN_SEARCH", parameters);
            return tbl;
        }
        public DataTable VT_VANBANDEN_LOAD_BYID(String V_TOAANID, String V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("V_TOAANID",V_TOAANID),
                 new OracleParameter("V_ID",V_ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VBD_LOAD_ID", parameters);
            return tbl;
        }
        public DataTable LOAI_AN_LIST()
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.DM_LOAIAN_LIST", parameters);
            return tbl;
        }
        public void VAN_BAN_DEN_DELETE(string _ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_DEN_DELETE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = _ID;
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
        public DataTable VT_VANBANDEN_BY_ID_VBDH(Decimal V_ID_VBDH)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("V_ID_VBDH",V_ID_VBDH),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VT_VANBANDEN_BY_ID_VBDH", parameters);
            return tbl;
        }
    }
}