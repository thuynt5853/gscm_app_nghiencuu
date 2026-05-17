using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class VBTB_TOTUNG_BL
    {
        public DataTable VBTB_TOTUNG_GETLIST(decimal vDONID, string vLOAIAN, decimal vGIAIDOANVUAN,decimal ddlTenVBTB,string tendoituong, decimal doituongid, string txtSoVBTB,string txtNgay,string txtsNoiDung,decimal loaihieuluc,string txtHieuLucTuNgay,string txtHieuLucDenNgay,string txtNguoiKy, string txtChucvu)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vLOAIAN",vLOAIAN),
                                                                        new OracleParameter("vGIAIDOANVUAN",vGIAIDOANVUAN),
                                                                        new OracleParameter("ddlTenVBTB",ddlTenVBTB),
                                                                        new OracleParameter("tendoituong",tendoituong),
                                                                        new OracleParameter("doituongid",doituongid),
                                                                        new OracleParameter("txtSoVBTB",txtSoVBTB),
                                                                        new OracleParameter("txtNgay",txtNgay),
                                                                        new OracleParameter("txtsNoiDung",txtsNoiDung),
                                                                        new OracleParameter("loaihieuluc",loaihieuluc),
                                                                        new OracleParameter("txtTuNgay",txtHieuLucTuNgay),
                                                                        new OracleParameter("txtDenNgay",txtHieuLucDenNgay),
                                                                        new OracleParameter("txtNguoiKy",txtNguoiKy),
                                                                        new OracleParameter("txtChucvu",txtChucvu),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("VBTB_TOTUNG_GETLIST", parameters);
            return tbl;
        }
    }
}