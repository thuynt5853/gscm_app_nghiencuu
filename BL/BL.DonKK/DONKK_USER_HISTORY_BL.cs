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
    public class DONKK_USER_HISTORY_BL
    {

        DKKContextContainer dt = new DKKContextContainer();
        public String CurrConnectionString = ENUM_CONNECTION.DonKhoiKien;
        public void WriteLog(Decimal UserID, string action, string Detail_Action)
        {
            DONKK_USER_HISTORY obj = new DONKK_USER_HISTORY();
            obj.USERID = UserID;
            obj.ACTION = action;
            obj.CREATEDATE = DateTime.Now;
            obj.DETAIL_ACTION = Detail_Action;
            obj.IP = Cls_Comon.GetLocalIPAddress();
            dt.DONKK_USER_HISTORY.Add(obj);
            dt.SaveChanges();
        }
        public DataTable GetAll(string textsearch,  String ma_action
                            , DateTime? tu_ngay, DateTime? den_ngay
                            , decimal PageIndex, decimal PageSize)
        {
            if (tu_ngay == DateTime.MinValue) tu_ngay = null;
            if (den_ngay == DateTime.MinValue) den_ngay = null;
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("textsearch",textsearch),
                                                                            new OracleParameter("ma_action",ma_action),
                                                                            new OracleParameter("tu_ngay",tu_ngay),
                                                                            new OracleParameter("den_ngay",den_ngay),
                                                                            new OracleParameter("PageIndex",PageIndex),
                                                                            new OracleParameter("PageSize", PageSize),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                          };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DKK_History_GetAll", parameters);
            return tbl;
        }
    }
}