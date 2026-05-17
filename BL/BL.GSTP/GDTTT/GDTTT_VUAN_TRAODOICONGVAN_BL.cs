using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

using System.Globalization;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_VUAN_TRAODOICONGVAN_BL
    {
        public DataTable Search(decimal vToaAnID, decimal vPhongBanID
                                 , decimal vToaAnChuyenCV_ID, string vSoCV, DateTime? vNgayCV
                                 , string vSoThuLy, DateTime? vNgayThuLy
                                 , decimal vThamtravien, decimal IsToTrinh
                                 , decimal is_kq, DateTime? tungay, DateTime? denngay, string Noidung
                                 , decimal PageIndex, decimal PageSize)
        {
            if (vNgayCV == DateTime.MinValue) vNgayCV = null;
            if (vNgayThuLy == DateTime.MinValue) vNgayThuLy = null;
            if (tungay == DateTime.MinValue) tungay = null;
            if (denngay == DateTime.MinValue) denngay = null;

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                        new OracleParameter("vToaAnChuyenCV_ID",vToaAnChuyenCV_ID),
                                                                        new OracleParameter("vSoCV",vSoCV),
                                                                        new OracleParameter("vNgayCV",vNgayCV),
                                                                        new OracleParameter("vSoThuLy",vSoThuLy),
                                                                        new OracleParameter("vNgayThuLy",vNgayThuLy),
                                                                        new OracleParameter("vThamtravien",vThamtravien),
                                                                        new OracleParameter("IsToTrinh",IsToTrinh),

                                                                        new OracleParameter("IsKQ",is_kq),
                                                                        new OracleParameter("tungay",tungay),
                                                                        new OracleParameter("denngay",denngay),
                                                                        new OracleParameter("vNoidung",Noidung),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                   };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAn_TraoDoiCV_Search", parameters);
            return tbl;
        }
        public DataTable SearchChuaGQ(decimal vToaAnID, decimal vPhongBanID
                             , decimal vToaAnChuyenCV_ID, string vSoCV, DateTime? vNgayCV
                             , string vSoThuLy, DateTime? vNgayThuLy
                             , decimal vThamtravien, decimal IsToTrinh
                             , DateTime? denngay
                             , decimal PageIndex, decimal PageSize)
        {
            if (vNgayCV == DateTime.MinValue) vNgayCV = null;
            if (vNgayThuLy == DateTime.MinValue) vNgayThuLy = null;
            if (denngay == DateTime.MinValue) denngay = null;

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vPhongBanID",vPhongBanID),
                                                                        new OracleParameter("vToaAnChuyenCV_ID",vToaAnChuyenCV_ID),
                                                                        new OracleParameter("vSoCV",vSoCV),
                                                                        new OracleParameter("vNgayCV",vNgayCV),
                                                                        new OracleParameter("vSoThuLy",vSoThuLy),
                                                                        new OracleParameter("vNgayThuLy",vNgayThuLy),
                                                                        new OracleParameter("vThamtravien",vThamtravien),
                                                                        new OracleParameter("IsToTrinh",IsToTrinh),
                                                                        
                                                                        new OracleParameter("denngay",denngay),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                   };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_TraoDoiCV_SearchChuaGQ", parameters);
            return tbl;
        }
        
        public decimal GetLastSo(DateTime Ngay)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = Ngay.Year;
            int Month_TL = Ngay.Month;
            if (Month_TL == 12)
            {
                tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_TRAODOICV_GetLasSo", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["LastSoPhieu"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["LastSoPhieu"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }

        public DataTable ToTrinhCV_GetAll(decimal congvan_id)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vCongVanID",congvan_id),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_TraoDoiCV_TOTRINH_GetAll", prm);
        }
        public decimal GetMaxSoCV_GiaiQuyet(decimal vPhongBanID, DateTime NgayLapToTrinh)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayLapToTrinh.Year;
            int Month_TL = NgayLapToTrinh.Month;
            if (Month_TL == 12)
            {
                tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vPhongbanid",vPhongBanID),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_TraoDoiCV_GetMaxCV_GQ", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["CountAll"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["CountAll"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }


    }
}