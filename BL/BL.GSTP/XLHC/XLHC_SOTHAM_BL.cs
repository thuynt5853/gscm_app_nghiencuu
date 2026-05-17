using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class XLHC_SOTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable XLHC_SOTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_THULY_GETLIST", parameters);
            return tbl;
        }

        public DataTable XLHC_SOTHAM_THULY_GETLIST_V2(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_SOTHAM_THULY_GETLIST_V2", parameters);
            return tbl;
        }

        public decimal THULY_GETNEWTT(decimal donviID)
        {

            DateTime vFromDate;
            DateTime vToDate;
            if (DateTime.Now.Month > 11)
            {
                vFromDate = DateTime.Parse("01/12/" + DateTime.Now.Year, cul, DateTimeStyles.NoCurrentDateDefault);
                vToDate = DateTime.Parse("30/11/" + (DateTime.Now.Year + 1), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                vFromDate = DateTime.Parse("01/12/" + (DateTime.Now.Year - 1), cul, DateTimeStyles.NoCurrentDateDefault);
                vToDate = DateTime.Parse("30/11/" + (DateTime.Now.Year), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                          new OracleParameter("vFromDate",vFromDate),
                                                                          new OracleParameter("vToDate",vToDate),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_THULY_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public DataTable XLHC_SOTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }
        
        public DataTable XLHC_SOTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        
        public DataTable XLHC_SOTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_SOTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_BANAN_DIEULUAT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_BANAN_DIEULUAT_GET", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_BANAN_ANPHI_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_BANAN_ANPHI_GET", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_KHANGCAO_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHANGCAO_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_KHANGNGHI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_KCaoKNghi_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KCaoKNghi_GETLIST", parameters);
            return tbl;
        }
        public DataTable XLHC_ST_KCKN_TINHTRANG_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_ST_KCKN_TINHTRANG_GETLIST", parameters);
            return tbl;
        }
        
        public DataTable XLHC_ST_KCKN_TINHTRANG_GETLIST_V2(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_ST_KCKN_TINHTRANG_GETLIST_V2", parameters);
            return tbl;
        }
        public DataTable XLHC_SOTHAM_BANAN_TGTT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_BANAN_TGTT_GET", parameters);
            return tbl;
        }
    
        public DataTable XLHC_DONXIN_HOAN_MIEN_GETLIST(decimal donID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_DONXIN_HOAN_MIEN_GETLIST", parameters);
            return tbl;
        }

        public DataTable XLHC_SOTHAM_KCaoKNghi_GETLIST_V2(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO.XLHC_SOTHAM_KCAOKNGHI_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }


        public DataTable SP_GET_NGUOITHAMGIA_TT(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO.SP_GET_NGUOITHAMGIA_TT", parameters);
            return tbl;
        }


        public DataTable XLHC_SOTHAM_GETNAME_KHANGNGHI(decimal userID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VuserID",userID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO.GETNAME_KHANGNGHI", parameters);
            return tbl;
        }

        public DataTable XLHC_SOTHAM_GETNAME_KHANGNGHI_ADMIN(decimal donviId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VdonviId",donviId),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO.GETNAME_KHANGNGHI_ADMIN", parameters);
            return tbl;
        }



        public DataTable XLHC_DONXIN_HOAN_MIEN_GETLIST_V2(decimal donID, String pVaiTro, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("CurrDonID",donID),
                new OracleParameter("pVaiTro", pVaiTro),
                new OracleParameter("PageIndex", PageIndex),
                new OracleParameter("PageSize", PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.XLHC_DONXIN_HOAN_MIEN_GETLIST_V2", parameters);
            return tbl;
        }
        public DataTable GetList_KienNghiQuyetDinh(decimal vDonID)
        {
                OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("p_DonID", vDonID),
            new OracleParameter("p_Cursor", OracleDbType.RefCursor, ParameterDirection.Output)
        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("XLHC_SOTHAM_KHIEUNAI_KIENNGHI_KHANGCAO.SP_GET_KIENNGHI_QD", parameters);
            return tbl;
        }

        //vnpt
        public DataTable HOANMIEN_SOTHAM_HDXX_GETLIST(decimal vDONID, decimal vLOAIAN, decimal vDONHOANMIEN_ID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID", vDONID),
                new OracleParameter("vLOAIAN", vLOAIAN),
                new OracleParameter("vDONHOANMIEN_ID", vDONHOANMIEN_ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.HOANMIEN_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
    }
}