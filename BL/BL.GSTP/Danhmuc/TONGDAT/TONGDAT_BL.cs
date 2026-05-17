using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc.TONGDAT
{
    public class TONGDAT_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable TONGDAT_UTTP_DI_GETLIST(decimal vIdDoiTuong, string vLoaiAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vIdDoiTuong",vIdDoiTuong),
                                                                        new OracleParameter("vLoaiAn",vLoaiAn),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TONGDAT_UTTP_DI_GETLIST", parameters);
            return tbl;
        }
    }
}