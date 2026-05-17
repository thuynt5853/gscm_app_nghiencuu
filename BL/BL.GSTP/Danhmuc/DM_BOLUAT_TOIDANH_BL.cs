using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_BOLUAT_TOIDANH_BL
    {
        /// <summary>
        /// Search
        /// </summary>
        /// <param name="luatid"></param>
        /// <param name="loai_td">loai_td = 1: chuong, =2:dieu,=3:khoan, =4:diem</param>
        /// <param name="ten_toi_danh"></param>
        /// <param name="chuong"></param>
        /// <param name="diem"></param>
        /// <param name="khoan"></param>
        /// <param name="dieu"></param>
        /// <param name="hieuluc"></param>
        /// <param name="PageIndex"></param>
        /// <param name="PageSize"></param>
        /// <returns></returns>
        public DataTable SearchDM(decimal luatid, decimal loai_td,decimal capchaid, string ten_toi_danh
                                  , int hieuluc, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("curr_boluat_id",luatid),
                                                                      new OracleParameter("loai_td",loai_td),
                                                                      new OracleParameter("cao_cha_id",capchaid),
                                                                      new OracleParameter("ten_toi_danh",ten_toi_danh),
                                                                      new OracleParameter("curr_trangthai",hieuluc),
                                                                      new OracleParameter("PageIndex",PageIndex),
                                                                      new OracleParameter("PageSize",PageSize),
                                                                      new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_SearchByDK", parameters);
            return tbl;
        }

        public DataTable SearchChinhXacTheoDK(decimal luatid, string diem, string khoan, string dieu)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("CurrBoLuatID",luatid),
                                                                       new OracleParameter("curr_diem",diem),
                                                                       new OracleParameter("curr_khoan",khoan),
                                                                       new OracleParameter("curr_dieu",dieu),
                                                                      new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_Search", parameters);
            return tbl;
        }

        public DataTable GetAllByParentID(decimal ParentID)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("CurrID",ParentID),
                                                                      new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BLTD_GetByParentID", parameters);
            return tbl;
        }
        
        public DataTable GetAllByLuatID_Paging(int luatid, string ten_toi_danh,string chuong, string diem, string khoan, string dieu, int hieuluc, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {     new OracleParameter("curr_luatid",luatid),
                                                                       new OracleParameter("ten_toi_danh",ten_toi_danh),
                                                                       new OracleParameter("str_chuong",chuong),
                                                                       new OracleParameter("str_diem",diem),
                                                                       new OracleParameter("str_khoan",khoan),
                                                                       new OracleParameter("str_dieu",dieu),
                                                                       new OracleParameter("curr_trangthai",hieuluc),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetAllByLuatID_NoChuong_Paging(int luatid, string ten_toi_danh, string diem, string khoan, string dieu, int hieuluc, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {     new OracleParameter("curr_luatid",luatid),
                                                                       new OracleParameter("ten_toi_danh",ten_toi_danh),
                                                                       new OracleParameter("str_diem",diem),
                                                                       new OracleParameter("str_khoan",khoan),
                                                                       new OracleParameter("str_dieu",dieu),
                                                                       new OracleParameter("curr_trangthai",hieuluc),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BLTD_GetAllPaging_NoChuong", parameters);
            return tbl;
        }


        public DataTable GetByDK(Decimal luatid, int loai_bo_luat, string curr_diem, string curr_khoan, string curr_dieu, int hieuluc)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("curr_luatid",luatid),
                                                                      new OracleParameter("loai_bo_luat",loai_bo_luat),
                                                                       new OracleParameter("curr_diem",curr_diem),
                                                                       new OracleParameter("curr_khoan",curr_khoan),
                                                                       new OracleParameter("curr_dieu",curr_dieu),
                                                                        new OracleParameter("curr_trangthai",hieuluc),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_GetByDK", parameters);
            return tbl;
        }
        public int GetMaxTT(Decimal luatid, int loai_bo_luat, decimal capchaid)
        {
            int MaxTT = 0;
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("curr_luatid",luatid),
                                                                      new OracleParameter("curr_loai",loai_bo_luat),
                                                                       new OracleParameter("cap_cha_id", capchaid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_GetMaxTT", parameters);
            if (tbl != null && tbl.Rows.Count>0)
            {
                DataRow row = tbl.Rows[0];
                MaxTT = (string.IsNullOrEmpty(row["MaxTT"] + "")) ? 0 : Convert.ToInt32(row["MaxTT"] + "");
            }
            return MaxTT;
        }
        

        public DataTable GetByDK2(Decimal luatid, int loai_bo_luat,string curr_chuong, string curr_diem, string curr_khoan, string curr_dieu, int hieuluc)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("curr_luatid",luatid),
                                                                      new OracleParameter("loai_bo_luat",loai_bo_luat),
                                                                         new OracleParameter("curr_chuong",curr_chuong),
                                                                       new OracleParameter("curr_diem",curr_diem),
                                                                       new OracleParameter("curr_khoan",curr_khoan),
                                                                       new OracleParameter("curr_dieu",curr_dieu),
                                                                        new OracleParameter("curr_trangthai",hieuluc),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_GetByDK2", parameters);
            return tbl;
        }
        public DataTable SearchTopByLuatID(int luatid, string textsearch, int soluong)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("SoLuong", soluong),
                                                                        new OracleParameter("TextSearch", textsearch),
                                                                        new OracleParameter("CurrLuatID",luatid),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_ToiDanh_SearchTop", parameters);
            return tbl;
        }
        public DataTable GetAllDieuLuatByBoLuat(string LoaiBoLuat)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vLoaiBoLuat",LoaiBoLuat),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GETALLDIEULUATBYBOLUAT", parameters);
            return tbl;
        }
        public DataTable GetDanhSachTOIDANHTK()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("SP_GS_GETDANHSACH_TOIDANHTK", parameters);
            return tbl;
        }
    }
}