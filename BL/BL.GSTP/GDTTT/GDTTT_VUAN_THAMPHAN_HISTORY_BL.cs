using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_VUAN_THAMPHAN_HISTORY_BL
    {
        public bool GDTTT_VUAN_THAMPHAN_HISTORY_Insert_Update(GDTTT_VUAN_PHANCONG_THAMPHAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_DON_APP.VUAN_THAMPHAN_HISTORY_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["V_VUANID"].Value = obj.VUANID;
            comm.Parameters["V_DONID"].Value = obj.DONID;
            comm.Parameters["V_THAMPHAN_ID_OLD"].Value = obj.THAMPHAN_ID_OLD;
            comm.Parameters["V_TUNGAY"].Value = obj.TUNGAY;
            comm.Parameters["V_THAMPHAN_ID_NEW"].Value = obj.THAMPHAN_ID_NEW;
            comm.Parameters["V_DENNGAY"].Value = obj.DENNGAY;
            comm.Parameters["V_LYDO"].Value = obj.LYDO;
            comm.Parameters["V_GIAIDOAN"].Value = obj.GIAIDOAN;
            comm.Parameters["V_NGUOISUA"].Value = obj.CANBOSUA_ID;
            comm.Parameters["v_SOTT"].Value = obj.SOTT;
            comm.Parameters["v_NGAYTOTRINH"].Value = obj.NGAYTT;

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
       
    
        public void GDTTT_VUAN_THAMPHAN_HISTORY_DEL(Decimal _ID)//,ref Int32 _Dele)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_TUHINH_APP.VUAN_THAMPHAN_HISTORY_DEL", conn);
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
        //public DataTable GDTTT_VUAN_THAMPHAN_HISTORY_SEARCH(decimal Loaidon, decimal Nguoinhan, decimal Loaingay, DateTime? tungay, DateTime? denngay, string nguoigui, string diachi,
        //   string soba, DateTime? ngayba, decimal toaxx, decimal PageIndex, decimal PageSize)
        //{
        //    OracleParameter[] parameters = new OracleParameter[]
        //                    {
        //                    new OracleParameter("v_Loaidon",Loaidon),
        //                    new OracleParameter("v_nguoinhan",Nguoinhan),
        //                    new OracleParameter("v_loaingay",Loaingay),
        //                    new OracleParameter("v_tungay",tungay),
        //                    new OracleParameter("v_denngay",denngay),
        //                    new OracleParameter("v_nguoigui",nguoigui),
        //                    new OracleParameter("v_diachi",diachi),
        //                    new OracleParameter("v_soba",soba),
        //                    new OracleParameter("v_ngayba",ngayba),
        //                    new OracleParameter("v_toaxx",toaxx),
        //                    new OracleParameter("PageIndex",PageIndex),
        //                    new OracleParameter("PageSize",PageSize),
        //                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                    };

        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VUAN_PHANCONG_THAMPHAN_SEARCH", parameters);

        //    return tbl;
        //    //
        //}

        public DataTable GDTTT_VUAN_THAMPHAN_HISTORY_SEARCH(decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD,
         string vNgayBAQD, string vNguyendon, string vBidon,
        decimal vLoaiAn, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
         , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vTrangthai, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM,
         decimal vGIAIDOAN, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vPhongBanID",vPhongBanID),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vNguyendon",vNguyendon),
                new OracleParameter("vBidon",vBidon),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vThamphan",vThamphan),
                new OracleParameter("vQHPLID",vQHPLID),
                new OracleParameter("vQHPLDNID",vQHPLDNID),
                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                new OracleParameter("vSoThuly",vSoThuly),
                new OracleParameter("vTrangthai",vTrangthai),
                new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                new OracleParameter("v_GIAIDOAN",vGIAIDOAN),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VUAN_PHANCONG_THAMPHAN_SEARCH", parameters);
            return tbl;
        }
       public DataTable GDTTT_VUAN_THAMPHAN_HISTORY_BYID(decimal vVUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_id",vVUANID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_DON_APP.VUAN_THAMPHAN_HISTORY_BY_ID", parameters);
            return tbl;
        }
        
    }
}