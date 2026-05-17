using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_DON_TRALOI_BL
    {
        public DataTable AHS_DSGiaiQuyetDon(decimal vVuAnID, decimal vType)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("v_Type",vType),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_AHS_GQD", parameters);
            return tbl;
        }
        public DataTable GetAllTBTinhThe(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DonQH_GetThongBaoTT", parameters);
            return tbl;
        }

        public DataTable GetAllTB_TheoLoai(decimal vVuAnID, decimal loaiTB)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                          new OracleParameter("vLoai",loaiTB),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DonQH_GetThongBaoByLoai", parameters);
            return tbl;
        }

        public DataTable GetThongBao(decimal vVuAnID, decimal loaiTB)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                          new OracleParameter("vLoai",loaiTB),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DonQH_GetThongBao", parameters);
            return tbl;
        }
    }
    public class GDTTT_CACVU_CAUHINH_BL
    {
        public DataTable GetLanhDaoNhanBCTheoTTV(decimal PhongBanID, Decimal ThamTraVienID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongBanID",PhongBanID),
                                                                        new OracleParameter("vThamTraVienID",ThamTraVienID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuConfig_GetLanhDao", parameters);
            return tbl;
        }

        public DataTable GDTTT_PCCanBoHistory_GetByVuAn(decimal VuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",VuAnID),                                                                        
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_PCCanBoHistory_GetByVuAn", parameters);
            return tbl;
        }
        
    }
}