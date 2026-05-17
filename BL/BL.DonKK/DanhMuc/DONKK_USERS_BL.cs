using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.DKK;

namespace BL.DonKK.DanhMuc
{
    public class DONKK_USERS_BL
    {
        //CHuoi connection den DB Donkhoikien
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        public DataTable GetAllPaging(string textsearch, decimal currUsertype,decimal vMucdichSD, decimal vDKThaydoi, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("searchKey", textsearch),
                                                                        new OracleParameter("currUsertype",currUsertype),
                                                                        new OracleParameter("MucdichSD", vMucdichSD),
                                                                        new OracleParameter("DKThaydoi", vDKThaydoi),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_USERS_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable CheckLogin(string email, string pass)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("searchKey", email),
                                                                        new OracleParameter("currUsertype",pass),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_User_CheckLogin", parameters);
            return tbl;
        }

        public DataTable GetByEmail(string email)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("curr_email", email),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_User_GetByEmail", parameters);
            return tbl;
        }

        
        //public DataTable GetNgayCuoiSDHethong(Decimal UserID)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("user_id",UserID)
        //                                                              ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                         };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_GetLastDayUseHT", parameters);
        //    return tbl;
        //}
        public DataTable GetInfo(Decimal UserID)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("User_ID", UserID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_User_GetInfo", parameters);
            return tbl;
        }
        
        public void UpdateLastLogin(Decimal UserID)
        {
            DKKContextContainer dt = new DKKContextContainer();
            DONKK_USERS obj = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            obj.LASTLOGINDATE = DateTime.Now;
            obj.LASTLOGINIP = Cls_Comon.GetLocalIPAddress();
            dt.SaveChanges();
        }
        public DataTable GetAllByToaAnCapCha(decimal toa_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("toa_an_id", toa_an_id),
                
                                                                        new OracleParameter("PageIndex", PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DM_ToanAn_GetLienHe", parameters);
            return tbl;
        }
        public DataTable GetAllToaAnByDK(decimal toa_an_id, string textsearch, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("toa_an_id", toa_an_id),
                                                                        new OracleParameter("textsearch", textsearch),
                                                                        new OracleParameter("PageIndex", PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DM_ToanAn_GetLienHe2", parameters);
            return tbl;
        }
        public Boolean CheckIsUse(decimal curr_user_id, decimal type_check)
        {
            Boolean retval = false;
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("curr_user_id", curr_user_id),
                                                                        new OracleParameter("type_check", type_check),
                                                                        new OracleParameter("curReturn", OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_Users_CheckIsUse", parameters);
            if (tbl != null && tbl.Rows.Count>0)
            {
                int count = Convert.ToInt32(tbl.Rows[0]["CountItem"] + "");
                if (count > 0)
                    retval= true;
                else
                    retval= false;
            }
            return retval;
        }
        
    }
}