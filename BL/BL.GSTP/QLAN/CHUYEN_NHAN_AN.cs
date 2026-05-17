using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Data;

namespace BL.GSTP.QLAN
{
      /*1	Hình sự
        2	Dân sự
        3	Hôn nhân và gia đình
        4	Kinh doanh, thương mại
        5	Lao động
        6	Hành chính
        7	Phá sản*/

    public class CHUYEN_NHAN_AN
    {
        // Update DUONGSU_ID, DUONGSU_IDS ở bảng ANPHI khi nhận án (Hệ thống tạo hồ sơ mới khi nhận án và đang không gắn đương sự)
        public void INSERT_ANPHI_DUONGSUID(decimal VLOAIAN, decimal VDONID_OLD, decimal VDONID_NEW)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("VLOAIAN",VLOAIAN),
                        new OracleParameter("VDONID_OLD",VDONID_OLD),
                        new OracleParameter("VDONID_NEW",VDONID_NEW),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            Cls_Comon.GetTableByProcedurePaging("PKG_CHUYEN_NHAN_AN.INSERT_ANPHI_DUONGSUID", parameters);
        }

    }
}