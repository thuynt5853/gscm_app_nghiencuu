using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Drawing.Printing;
using System.Linq;

namespace BL.GSTP.HOAGIAI
{
    public class HOAGIAI_BL
    {
        private GSTPContext dt = new GSTPContext();

        public DataTable GETLIST_THONGBAO(decimal V_HGDON, decimal V_LOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_HGDON",V_HGDON),
                                                                        new OracleParameter("V_LOAIAN",V_LOAIAN),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_THONGBAO", parameters);
            return tbl;
        }
        public DataTable GETLIST_THONGBAO_KETQUA(decimal V_HGDON, decimal V_LOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_HGDON",V_HGDON),
                                                                        new OracleParameter("V_LOAIAN",V_LOAIAN),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_THONGBAO_KETQUA", parameters);
            return tbl;
        }

        public DataTable GETLIST_GIAONHANDON(decimal V_HGDON, decimal V_LOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_HGDON",V_HGDON),
                                                                        new OracleParameter("V_LOAIAN",V_LOAIAN),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_GIAONHANDON", parameters);
            return tbl;
        }

        public DataTable GetAllPhanCongThamPhan(decimal V_HGDON, decimal? PageIndex = 1, decimal? PageSize = 10)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_HGDON",V_HGDON),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_PHANCONGTHAMPHAN", parameters);
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_PHANCONGTHAMPHAN", parameters);
            return tbl;
        }

        public bool CheckThuLy(decimal vuViecId, decimal loaiAnId)
        {
            if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
            {
                ADS_SOTHAM_THULY thuLy = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == vuViecId).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
            {
                AHC_SOTHAM_THULY thuLy = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuViecId).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
            {
                AKT_SOTHAM_THULY thuLy = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == vuViecId).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
            {
                ALD_SOTHAM_THULY thuLy = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == vuViecId).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
            {
                AHN_SOTHAM_THULY thuLy = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == vuViecId).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            return true;
        }
        public bool CheckPCTPQGD(decimal vuViecId, decimal loaiAnId)
        {
            if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
            {
                ADS_DON_THAMPHAN thuLy = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == vuViecId && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
            {
                AHC_DON_THAMPHAN thuLy = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vuViecId && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
            {
                AKT_DON_THAMPHAN thuLy = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == vuViecId && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
            {
                ALD_DON_THAMPHAN thuLy = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == vuViecId && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            else if (loaiAnId == Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
            {
                AHN_DON_THAMPHAN thuLy = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == vuViecId && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).FirstOrDefault();
                if (thuLy != null)
                    return false;
            }
            return true;
        }

        public bool UpdateTrangThaiHoaGiai(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal trangThai)
        {
            try
            {
                switch (V_LOAIANID.ToString())
                {
                    case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                        ADS_DON adsDon = new ADS_DON() { ID = V_MAVUVIEC, HOAGIAI_TRANGTHAI = (decimal)trangThai };
                        return DataExtensions.UpdateNotNull<ADS_DON>(adsDon);

                    case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                        AHN_DON ahnDon = new AHN_DON() { ID = V_MAVUVIEC, HOAGIAI_TRANGTHAI = (decimal)trangThai };
                        return DataExtensions.UpdateNotNull<AHN_DON>(ahnDon);

                    case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                        AKT_DON aktDon = new AKT_DON() { ID = V_MAVUVIEC, HOAGIAI_TRANGTHAI = (decimal)trangThai };
                        return DataExtensions.UpdateNotNull<AKT_DON>(aktDon);

                    case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                        ALD_DON aldDon = new ALD_DON() { ID = V_MAVUVIEC, HOAGIAI_TRANGTHAI = (decimal)trangThai };
                        return DataExtensions.UpdateNotNull<ALD_DON>(aldDon);

                    case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                        AHC_DON ahcDon = new AHC_DON() { ID = V_MAVUVIEC, HOAGIAI_TRANGTHAI = (decimal)trangThai };
                        return DataExtensions.UpdateNotNull<AHC_DON>(ahcDon);

                    default:
                        throw new Exception("Không tồn tại");
                }
            }
            catch
            {
                return false;
            }
        }

        public decimal? GetTrangThaiHoaGiaiHienTai(decimal V_MAVUVIEC, decimal V_LOAIANID)
        {
            try
            {
                switch (V_LOAIANID.ToString())
                {
                    case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                        ADS_DON adsDon = DataExtensions.FindById<ADS_DON>(V_MAVUVIEC);
                        if (adsDon != null)
                            return adsDon.HOAGIAI_TRANGTHAI;
                        return null;

                    case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                        AHN_DON ahnDon = DataExtensions.FindById<AHN_DON>(V_MAVUVIEC);
                        if (ahnDon != null)
                            return ahnDon.HOAGIAI_TRANGTHAI;
                        return null;

                    case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                        AKT_DON aktDon = DataExtensions.FindById<AKT_DON>(V_MAVUVIEC);
                        if (aktDon != null)
                            return aktDon.HOAGIAI_TRANGTHAI;
                        return null;

                    case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                        ALD_DON aldDon = DataExtensions.FindById<ALD_DON>(V_MAVUVIEC);
                        if (aldDon != null)
                            return aldDon.HOAGIAI_TRANGTHAI;
                        return null;

                    case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                        AHC_DON ahcDon = DataExtensions.FindById<AHC_DON>(V_MAVUVIEC);
                        if (ahcDon != null)
                            return ahcDon.HOAGIAI_TRANGTHAI;
                        return null;

                    default:
                        throw new Exception("Không tồn tại");
                }
            }
            catch
            {
                return null;
            }
        }

        public DataTable GetAllGhiNhanKetQuaHoaGiai(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal? PageIndex = 1, decimal? PageSize = 10)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_GHINHANKETQUAHOAGIAI", parameters);
            return tbl;
        }

        public DataTable GetAllHoaGiaiQuyetDinh(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal? PageIndex = 1, decimal? PageSize = 10)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_HOAGIAIQUYETDINH", parameters);
            return tbl;
        }

        public DataTable GetAllDeNghiKienNghi(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal? PageIndex = 1, decimal? PageSize = 10)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_DENGHIKIENNGHI", parameters);
            return tbl;
        }
        public DataTable GetAllKetQuaDeNghiKienNghi(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal? PageIndex = 1, decimal? PageSize = 10)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_KETQUA_DENGHIKIENNGHI", parameters);
            return tbl;
        }

        public DataTable GetDuongSuThongBao(decimal V_MAVUVIEC, decimal V_LOAIANID, decimal V_THONGBAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("V_THONGBAOID",V_THONGBAOID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_DUONGSU_THONGBAO", parameters);
            return tbl;
        }
        public DataTable GetDuongSu(decimal V_MAVUVIEC, decimal V_LOAIANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_DUONGSU", parameters);
            return tbl;
        }
        public DataTable GETLIST_THONGBAO_DUONGSU(decimal V_MAVUVIEC, decimal V_LOAIANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("VTHONGBAOID",V_MAVUVIEC),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_THONGBAO_DUONGSU", parameters);
            return tbl;
        }
        public DataTable GETLIST_VU_VIEC_KQDNKN(decimal V_TOALOGIN, decimal V_LOAIANID, string V_MAVUVIEC, string V_TENVUVIEC, DateTime? V_TUNGAY, DateTime? V_DENNGAY, decimal V_TINHTRANG, decimal Page_Index, decimal Page_Size)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_TOALOGIN",V_TOALOGIN),
                                                                        new OracleParameter("V_LOAIANID",V_LOAIANID),
                                                                        new OracleParameter("V_MAVUVIEC",V_MAVUVIEC),
                                                                        new OracleParameter("V_TENVUVIEC",V_TENVUVIEC),
                                                                        new OracleParameter("V_TUNGAY",V_TUNGAY?.ToString("dd/MM/yyyy")),
                                                                        new OracleParameter("V_DENNGAY",V_DENNGAY?.ToString("dd/MM/yyyy")),
                                                                        new OracleParameter("V_TINHTRANG",V_TINHTRANG),
                                                                        new OracleParameter("Page_Index",Page_Index),
                                                                        new OracleParameter("Page_Size",Page_Size),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GS_HOAGIAI.GETLIST_VU_VIEC_KQDNKN", parameters);
            return tbl;
        }
    }
}