using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_KCKNQDK_PHUCTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable AHS_KCKNQDK_PHUCTHAM_HDXX_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVuAnID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PHUCTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_BICAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PT_QD_BICAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PT_QD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PHUCTHAM_BANAN_CHITIET(decimal vVUANID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVUANID",vVUANID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PHUCTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHS_PT_KCQUAHAN(decimal DonViID, string MaVuAn, string TenVuAn, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuAn",MaVuAn),
                new OracleParameter("vTenVuAn",TenVuAn),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PT_KCQUAHAN", parameter);
            return tbl;
        }
        public DataTable AHS_RUTKN(decimal DonViID, string MaVuAn, string TenVuAn, string SoQD_BA, string TenBiCanBiCao, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuAn",MaVuAn),
                new OracleParameter("vTenVuAn",TenVuAn),
                new OracleParameter("vSoQD_BA",SoQD_BA),
                new OracleParameter("vTenBiCanBiCao",TenBiCanBiCao),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_RUTKN", parameter);
            return tbl;
        }
        public DataTable AHS_PT_KCKN_TinhTrang_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS2.AHS_PT_KCKN_TinhTrang_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_BAQD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_PT_BAQD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_VUAN_KHONGKETTHUC_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_PT_QD_VUAN_GETLIST", parameters);
            return tbl;
        }
        #region thụ lý
        public DataTable GetByVuAnID(decimal vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PHUCTHAM_THULY_GetByVuAn", parameters);
            return tbl;
        }
        public decimal GETNEWTT(decimal ToaAnID, DateTime NgayThuLy)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayThuLy.Year;
            int Month_TL = NgayThuLy.Month;
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
                                                                        new OracleParameter("toa_an_id",ToaAnID),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PHUCTHAM_THULY_GETMAXTT", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["CountAll"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["CountAll"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public Boolean CheckExistSoThuLy(decimal thulyid, string sothuly, DateTime NgayThuLy)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayThuLy.Year;
            int Month_TL = NgayThuLy.Month;
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
                                                                        new OracleParameter("thulyid",thulyid),
                                                                           new OracleParameter("so_thu_ly",sothuly),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PT_ThuLy_CheckExistSoThuLy", parameters);
            if (tbl != null && tbl.Rows.Count > 0) return true;
            else return false;
        }
        #endregion thụ lý
        #region bị can bị cáo
        public DataTable GetAllByVuAnIDTDC(decimal vuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vu_an_id",vuAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_BiCan_GetAllByVuAn", parameters);
            return tbl;
        }
        public DataTable GetAllBiCanPhucTham(decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuan_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_PT_BiCao_GetAll", parameters);
            return tbl;
        }
        public DataTable Get_congthuc(decimal VUAN_ID, string HIEULUCTUNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VVUAN_ID",VUAN_ID),
                                                                        new OracleParameter("VHIEULUCTUNGAY",HIEULUCTUNGAY),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS2.GET_CT_TAMGIAM", parameters);
            return tbl;
        }
        public DataTable GetAllBiCan_bihai_PhucTham(decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuan_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_EXT.AHS_PT_BiCao_GetAll", parameters);
            return tbl;
        }
        #endregion bị can bị cáo

        #region anhnt
        public decimal GET_STL_NEW_HS(decimal donviID, string loaian, decimal isThanhNien, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",isThanhNien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_STL_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public decimal CheckSoTLTheoLoaiAn(decimal donviID, string loaian, decimal isThanhNien, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",isThanhNien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_CheckSoThuLy", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return Convert.ToDecimal(tbl.Rows[0][0]);
            else return 0;
        }
        public DataTable AHS_GETKCSOTHAM_XULY(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_GETKCSOTHAM_XULY", parameters);
            return tbl;
        }
        public DataTable AHS_GETKNSOTHAM_XULY(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_GETKNSOTHAM_XULY", parameters);
            return tbl;
        }
        public DataTable DGLIST_QUYETDINH_BICAN_PTDC(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.DGLIST_QUYETDINH_BICAN_PTDC", parameters);
            return tbl;
        }
        public DataTable AHS_DM_QUYETDINH_VUAN_PTTDC()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_DM_QUYETDINH_VUAN_PTTDC", parameters);
            return tbl;
        }

        public DataTable DGLIST_QUYETDINH_PTTDC(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.DGLIST_QUYETDINH_PTTDC", parameters);
            return tbl;
        }
        public DataTable AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC()
        {
            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC", parameters);
            return tbl;
        }
        public DataTable DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC", parameters);
            return tbl;
        }
        public decimal GetVuAnDangXuLyPTTDC (decimal vuAnStID,decimal toaAnId)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("V_VUANID", vuAnStID),
                    new OracleParameter("V_TOAANID", toaAnId)
                };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_STPT_AHS_GS2.GET_VUANID_DANG_XULY_TDC", parameters);
                return dbl;
            }
            catch (Exception ex) { return 0; }
        }
        public DataTable AHS_NTGTT_GetByVuAnID_PT(decimal vu_an_id, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS2.AHS_NTGTT_GetByVuAnID", parameters);
            return tbl;
        }
        #endregion
    }
}