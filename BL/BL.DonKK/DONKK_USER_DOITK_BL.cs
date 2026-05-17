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
    public class DONKK_USER_DOITK_BL
    {
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        
        public DataTable GetAllPaging(Decimal curr_toaanid,decimal curr_status
		                                , string curr_madangky , string curr_hoten
                                        , string curr_email, string curr_cmnd
	                                    , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("curr_toaanid",curr_toaanid),
                                                                        new OracleParameter("curr_status",curr_status),
																		
                                                                        new OracleParameter("curr_madangky",curr_madangky),
																		 new OracleParameter("curr_hoten",curr_hoten),
																		  new OracleParameter("curr_email",curr_email),
																		   new OracleParameter("curr_cmnd",curr_cmnd),
																		   
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_User_DoiMucDichSD_Search", parameters);
            return tbl;
        }   
      
        
        public DataTable GetInfoDangKyNhanVB(decimal curr_toaanid, decimal curr_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {     new OracleParameter("curr_toaanid",curr_toaanid),
                                                                       new OracleParameter("curr_id",curr_id),                                                                        
                                                                       new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_User_DoiTK_GetInfo", parameters);
            return tbl;
        }
    }
}