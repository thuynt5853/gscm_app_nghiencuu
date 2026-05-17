using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.DonKK.DanhMuc
{
    public class DONKK_CHUYENMUC_BL
    {
        //CHuoi connection den DB Donkhoikien
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        public DataTable GetAllByCapChaID(Decimal capcha)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("cap_cha_id", capcha),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_ChuyenMuc_GetByCapCha", parameters);
            return tbl;
        }
        
    }
}