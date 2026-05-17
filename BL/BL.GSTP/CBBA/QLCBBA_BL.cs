using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.CBBA
{
    public class QLCBBA_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        //lấy dữ liệu vào menu Quản lý CBBA
        public DataTable GetQLCBBA(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai,List<string> lstTrangThai, int PageIndex, int PageSize)
        {

            DataTable dt = new DataTable();
            if (vLoaian == 0 || vLoaian == 1)
            {
                var dt_AHS = GetQLCBBA_AHS(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHS != null && dt_AHS.Rows.Count > 0)
                {
                    dt.Merge(dt_AHS);
                }
            }

            if (vLoaian == 0 || vLoaian == 2)
            {

                var dt_ADS = GetQLCBBA_ADS(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_ADS != null && dt_ADS.Rows.Count > 0)
                {
                    dt.Merge(dt_ADS);
                }
            }

            if (vLoaian == 0 || vLoaian == 6)
            {
                var dt_AHC = GetQLCBBA_AHC(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHC != null && dt_AHC.Rows.Count > 0)
                {
                    dt.Merge(dt_AHC);
                }
            }

            if (vLoaian == 0 || vLoaian == 3)
            {
                var dt_AHN = GetQLCBBA_AHN(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AHN != null && dt_AHN.Rows.Count > 0)
                {
                    dt.Merge(dt_AHN);
                }
            }

            if (vLoaian == 0 || vLoaian == 4)
            {
                var dt_AKT = GetQLCBBA_AKT(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_AKT != null && dt_AKT.Rows.Count > 0)
                {
                    dt.Merge(dt_AKT);
                }
            }

            if (vLoaian == 0 || vLoaian == 5)
            {
                var dt_ALD = GetQLCBBA_ALD(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_ALD != null && dt_ALD.Rows.Count > 0)
                {
                    dt.Merge(dt_ALD);
                }
            }

            if (vLoaian == 0 || vLoaian == 7)
            {
                var dt_APS = GetQLCBBA_APS(MaVuViec, TenVuViec, vLoaian, vSoBA, vNgayBA, DonViID, TuNgay, DenNgay, TrangThai, PageIndex, PageSize);
                if (dt_APS != null && dt_APS.Rows.Count > 0)
                {
                    dt.Merge(dt_APS);
                }
            }

            if (dt.Rows.Count > 0)
            {
                dt.Rows[0]["CountAll"] = dt.Rows.Count;
                if (dt.Columns.Contains("STT"))
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        var ISCONGBOBA = "" + row["ISCONGBOBA"];

                        if (lstTrangThai.Count > 0)
                        {
                            if (!lstTrangThai.Contains(ISCONGBOBA))
                            {
                                row.Delete();
                            }
                        }
                    }
                    dt.AcceptChanges();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dt.Rows[i]["CountAll"] = dt.Rows.Count;
                        dt.Rows[i]["STT"] = i + 1;

                        var TRANGTHAI = "" + dt.Rows[i]["ISCONGBOBA"];
                    }
                }
                dt.AcceptChanges();
                var pagecur = PageIndex - 1;
                if (pagecur <= 0)
                {
                    pagecur = 0;
                }
                if (dt.Rows.Count > 0)
                {
                    dt = dt.AsEnumerable().Skip(pagecur * PageSize).Take(PageSize).CopyToDataTable();
                }
                else
                {
                    dt = new DataTable();
                }
            }
            return dt;
        }

        private DataTable GetQLCBBA_APS(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
           {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_APS", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_ALD(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
           {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_ALD", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_AKT(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
             };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_AKT", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_AHN(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
           {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_AHN", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_AHC(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
           {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_AHC", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_ADS(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
           {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_ADS", parameter);
            return tbl;
        }

        private DataTable GetQLCBBA_AHS(string MaVuViec, string TenVuViec, decimal vLoaian, string vSoBA, string vNgayBA, decimal DonViID, string TuNgay, string DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoBA",vSoBA),
                new OracleParameter("vNgayBA",vNgayBA),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
             };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLHS_STPT.GETQUANLYCBBA_AHS", parameter);
            return tbl;
        }
    }
}