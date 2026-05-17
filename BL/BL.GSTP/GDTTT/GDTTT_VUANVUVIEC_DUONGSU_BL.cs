using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_VUANVUVIEC_DUONGSU_BL
    {
        public DataTable GDTTT_VUANVUVIEC_DUONGSU_GETBYVVID(decimal vVuAnVuViec)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnVuViec",vVuAnVuViec),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT.VV_DUONGSU_GETBYVVID", parameters);
            return tbl;
        }
        public DataTable GetByVuAnID(decimal vuanid, string tucachtt)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("vTucachtotung", tucachtt),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VuAnDS_GetByVuAn", parameters);
            return tbl;
        }
        public DataTable GetByDonID(decimal VDONID, string tucachtt)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VDONID",VDONID),
                                                                        new OracleParameter("vTucachtotung", tucachtt),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_VUANDS_GETBYDON", parameters);
            return tbl;
        }
        /// <summary>
        /// lay ds cac duong su cua cac vu an hs
        /// </summary>
        /// <param name="vuanid"></param>
        /// <param name="tucachtt">lay tat ca --> null, BIDON, KHAC</param>
        /// <param name="isDauVu">2:tat ca, 1: la dau vu, 0 : bi can kn</param>
        /// <returns></returns>
        public DataTable AnHS_GetAllDuongSu(decimal vuanid, string tucachtt, int isDauVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("vTucachtotung", tucachtt),
                                                                        new OracleParameter("isDauVu", isDauVu),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DS_ToiDanh_GetAll", parameters);
            return tbl;
        }
        public DataTable AHS_GetAllBy_NguoiKN_BICAO(decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_GetAllBy_NguoiKN_BICAO", parameters);
            return tbl;
        }
        
        public DataTable AnHS_GetAllDuongSu_CC(decimal VDONID, string tucachtt, int isDauVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VDONID",VDONID),
                                                                        new OracleParameter("vTucachtotung", tucachtt),
                                                                        new OracleParameter("isDauVu", isDauVu),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_DS_ToiDanh_GetAll", parameters);
            return tbl;
        }
        public DataTable AnHS_GetAllDuongSu_CC_NOT_KN(decimal VDONID, string tucachtt, int isDauVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VDONID",VDONID),
                                                                        new OracleParameter("vTucachtotung", tucachtt),
                                                                        new OracleParameter("isDauVu", isDauVu),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_DS_TOIDANH_GETALL_KN", parameters);
            return tbl;
        }
        public DataTable AnHS_GetAllByLoaiDuongSu2(decimal vuanid, int IsBiCao, int IsDauVu)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("IsBiCao", IsBiCao),
                                                                        new OracleParameter("IsDauVu", IsDauVu),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_DS_ToiDanh_GetAllByLoai", parameters);
            return tbl;
        }
        public DataTable AHS_GetAllByLoaiDS(decimal vuanid, int loai_duong_su)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("type_ds", loai_duong_su),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_AHS_GetAllByLoaiDS", parameters);
            return tbl;
        }
        public DataTable AHS_GetAllByLoaiDS_DONID(decimal vuanid, int loai_duong_su)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                        new OracleParameter("type_ds", loai_duong_su),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_AHS_GETALLBYLOAIDS", parameters);
            return tbl;
        }
        public DataTable AHS_GetAllByLoaiDS_S(decimal VDONID, int loai_duong_su)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VDONID",VDONID),
                                                                        new OracleParameter("type_ds", loai_duong_su),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GDTTT_AHS_GETALLBYLOAIDS", parameters);
            return tbl;
        }
        public DataTable AnHS_GetAllBiCaoDuocKN(decimal vuanid, Decimal vNguoiKhieuNaiID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                          new OracleParameter("vNguoiKhieuNaiID",vNguoiKhieuNaiID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_AHS_GetAllBiCaoDuocKN", parameters);
            return tbl;
        }

        public DataTable AHS_GetBiCaoKN_ByNguoiKN(decimal vuanid, Decimal vNguoiKhieuNaiID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                          new OracleParameter("vNguoiKhieuNaiID",vNguoiKhieuNaiID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_AHS_GetBiCaoKN_ByNguoiKN", parameters);
            return tbl;
        }
        public DataTable AHS_GetBiCaoKN_ByNguoiKN_CC(decimal vuanid, Decimal vNguoiKhieuNaiID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vuanid),
                                                                          new OracleParameter("vNguoiKhieuNaiID",vNguoiKhieuNaiID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_CC.GDTTT_AHS_GETBICAOKN_BYNGUOIKN", parameters);
            return tbl;
        }

    }
}