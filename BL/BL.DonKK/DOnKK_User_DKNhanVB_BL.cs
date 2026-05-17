using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.DKK;

namespace BL.DonKK
{
    public class DOnKK_User_DKNhanVB_BL
    {
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        
        public DataTable GetAllPaging(Decimal UserID, string vu_viec, decimal toa_an_id , string tucach_ttt,string vhoten,int trangthai, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("user_id",UserID),
                                                                        new OracleParameter("vu_viec",vu_viec),
                                                                        new OracleParameter("toa_an_id",toa_an_id),
                                                                        new OracleParameter("tucach_ttt",tucach_ttt),
                                                                        new OracleParameter("vhoten",vhoten),
                                                                         new OracleParameter("trang_thai",trangthai),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_DKNhanVB_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetListDKByToaAn(Decimal toa_an_id, string tucach_ttt
                                    , string tenduongsu, string cmnd, string madangky
                                    ,  string textsearch, int trang_thai 
                                    , DateTime? tu_ngay, DateTime? den_ngay,string quanHePhapLuat, string vemail, string sodienthoai
                                    , decimal PageIndex, decimal PageSize)
        {
            if (tu_ngay == DateTime.MinValue) tu_ngay = null;
            if (den_ngay == DateTime.MinValue) den_ngay = null;
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("toa_an_id",toa_an_id),
                                                                        new OracleParameter("ma_tu_cach_tt",tucach_ttt),

                                                                        new OracleParameter("curr_tenduongsu",tenduongsu),
                                                                        new OracleParameter("curr_cmnd",cmnd),
                                                                        new OracleParameter("curr_madangky",madangky),
                                                                        
                                                                        new OracleParameter("trang_thai",trang_thai),
                                                                        new OracleParameter("textsearch",textsearch),

                                                                        new OracleParameter("tu_ngay",tu_ngay),
                                                                        new OracleParameter("den_ngay",den_ngay),

                                                                        new OracleParameter("quanHePhapLuat",quanHePhapLuat),
                                                                        new OracleParameter("vemail",vemail),
                                                                        new OracleParameter("sodienthoai",sodienthoai),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
         
            
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_DKNhanVB_GetAllByToaAn", parameters);
            return tbl;
        }

        public DataTable GetInfoDangKyNhanVB(string group_dk)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("group_dk",group_dk),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_DKNhanVB_GetInfo", parameters);
            return tbl;
        }

        public DataTable GetTop(Decimal UserID, int soluong)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("user_id",UserID),
                                                                        new OracleParameter("soluong",soluong),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_DKNhanVB_GetTop", parameters);
            return tbl;
        }
        public DataTable GetList_data_Gui_DKK(string V_MAVUVIEC, Decimal V_CHECK_CHILD, string V_DONVI_LOGIN, string V_CAP_XET_XU, string V_TENNGUOIGUI,string V_MOBILE,string V_EMAIL, string V_TOA_AN_ID, string V_TRANG_THAI, string V_TUNGAY, string V_DENNGAY, decimal Page_Index, decimal Page_Size)
        {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                new OracleParameter("V_CHECK_CHILD",V_CHECK_CHILD),
                new OracleParameter("V_DONVI_LOGIN",V_DONVI_LOGIN),
                new OracleParameter("V_CAP_XET_XU",V_CAP_XET_XU),
                new OracleParameter("V_TENNGUOIGUI",V_TENNGUOIGUI),
                new OracleParameter("V_MOBILE",V_MOBILE),
                new OracleParameter("V_EMAIL",V_EMAIL),
                new OracleParameter("V_TOA_AN_ID",V_TOA_AN_ID),
                new OracleParameter("V_TRANG_THAI",V_TRANG_THAI),
                new OracleParameter("V_TUNGAY",V_TUNGAY),
                new OracleParameter("V_DENNGAY",V_DENNGAY),
                new OracleParameter("Page_Index",Page_Index),
                new OracleParameter("Page_Size", Page_Size),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK.GETBY_GUI_DKK", parameters);
            return tbl;
        }
        public void DKK_DELETE(string V_ID_DKK,ref String _V_MESS)
        {
            OracleConnection conn = Cls_Comon.OpenConnection(CurrConnectionString);
            OracleCommand comm = new OracleCommand("PKG_DKK_DELETE.DELETE_DONKHOIKIEN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_MESS"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ID_DKK"].Value = V_ID_DKK;
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
                _V_MESS = Convert.ToString(comm.Parameters["V_MESS"].Value.ToString());
                conn.Close();
            }
        }

    }
}