using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;

namespace BL.GSTP.QLAN
{
    public class STPT_KHANGCAOQUAHAN
    {
        public decimal SOTHULY_GETMAXTT(decimal VTOAANID, decimal VLOAIKHANGCAO, string VNGAYTHULY)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VTOAANID",VTOAANID),
                                                                    new OracleParameter("VLOAIKHANGCAO",VLOAIKHANGCAO),
                                                                    new OracleParameter("VNGAYTHULY",VNGAYTHULY),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.SOTHULY_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }
        public bool SOTHULY_GETMAXTT_CHECK(decimal VTOAANID, decimal VLOAIKHANGCAO, string VSOTHULY, string VNGAYTHULY)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VTOAANID",VTOAANID),
                                                                    new OracleParameter("VLOAIKHANGCAO",VLOAIKHANGCAO),
                                                                    new OracleParameter("VSOTHULY",VSOTHULY),
                                                                    new OracleParameter("VNGAYTHULY",VNGAYTHULY),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.SOTHULY_GETMAXTT_CHECK", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public decimal SOQUYETDINH_GETMAXTT(decimal VTOAANID, string VNGAYQUYETDINH)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VTOAANID",VTOAANID),
                                                                    new OracleParameter("VNGAYQUYETDINH",VNGAYQUYETDINH),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.SOQUYETDINH_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            catch (Exception ex)
            {
                return 1;
            }
        }
        public bool SOQUYETDINH_GETMAXTT_CHECK(decimal VTOAANID, string VSOQUYETDINH, string VNGAYQUYETDINH)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VTOAANID",VTOAANID),
                                                                    new OracleParameter("VSOQUYETDINH",VSOQUYETDINH),
                                                                    new OracleParameter("VNGAYQUYETDINH",VNGAYQUYETDINH),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.SOQUYETDINH_GETMAXTT_CHECK", parameters);
                return tbl.Rows.Count > 0 ? true : false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public DataTable KHANGCAOQUAHAN_HDXX_GETLIST(decimal vDONID, decimal VTHULYID, decimal VLOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VDONID",vDONID),
                                                                    new OracleParameter("VTHULYID",VTHULYID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.KHANGCAOQUAHAN_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable KHANGCAOQUAHAN_HDXX_GETBYID(decimal vDONID, decimal VTHULYID, decimal VLOAIAN, decimal VID_HDXX)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VDONID",vDONID),
                                                                    new OracleParameter("VTHULYID",VTHULYID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VID_HDXX",VID_HDXX),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.KHANGCAOQUAHAN_HDXX_GETBYID", parameters);
            return tbl;
        }
        public DataTable KHANGCAOQUAHAN_THULY_GETLAST(decimal vDONID, decimal VLOAIAN, decimal VKHANGCAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VDONID",vDONID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VKHANGCAOID",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.KHANGCAOQUAHAN_THULY_GETLAST", parameters);
            return tbl;
        }
        public DataTable KHANGCAOQUAHAN_QUYETDINH_GETLAST(decimal vDONID, decimal VTHULYID, decimal VLOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VDONID",vDONID),
                                                                    new OracleParameter("VTHULYID",VTHULYID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN.KHANGCAOQUAHAN_QUYETDINH_GETLAST", parameters);
            return tbl;
        }


        #region In báo cáo
        public DataTable ADS_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.ADS_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHS_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHS_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHC_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHC_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHN_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHN_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AKT_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AKT_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable ALD_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.ALD_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable APS_PT_KCQUAHAN_PRINT(decimal VTHULY_KCQH_ID, decimal VLOAIAN, decimal VDONID, decimal VTOAANID, decimal VKHANGCAOID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("VTHULY_KCQH_ID",VTHULY_KCQH_ID),
                                                                    new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONID",VDONID),
                                                                    new OracleParameter("VTENVUVIEC",VTOAANID),
                                                                    new OracleParameter("VSOBAQD",VKHANGCAOID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.APS_PT_KCQUAHAN_PRINT", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion


        #region Tìm kiếm
        public DataTable ADS_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                            string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                            string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.ADS_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHS_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHS_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHC_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHC_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AHN_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AHN_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable AKT_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.AKT_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable ALD_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.ALD_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable APS_PT_KCQUAHAN(decimal VLOAIAN, decimal VDONVIID, string VMAVUVIEC, string VTENVUVIEC, string VSOBAQD, string VNGAYBAQD, string VNGUOIKC, string VKCTUNGAY, string VKCDENNGAY,
                                    string VSOTL, string VTLTUNGAY, string VTLDENNGAY, decimal VTRANGTHAI, string VTUNGAY, string VDENNGAY, decimal VTHAMPHANIDID, decimal VTHUKYID,
                                    string VCHECKEDLIST, decimal VPAGEINDEX, decimal VPAGESIZE)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",VLOAIAN),
                                                                    new OracleParameter("VDONVIID",VDONVIID),
                                                                    new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                                                                    new OracleParameter("VTENVUVIEC",VTENVUVIEC),
                                                                    new OracleParameter("VSOBAQD",VSOBAQD),
                                                                    new OracleParameter("VNGAYBAQD",VNGAYBAQD),
                                                                    new OracleParameter("VNGUOIKC",VNGUOIKC),
                                                                    new OracleParameter("VKCTUNGAY",VKCTUNGAY),
                                                                    new OracleParameter("VKCDENNGAY",VKCDENNGAY),
                                                                    new OracleParameter("VSOTL",VSOTL),
                                                                    new OracleParameter("VTLTUNGAY",VTLTUNGAY),
                                                                    new OracleParameter("VTLDENNGAY",VTLDENNGAY),
                                                                    new OracleParameter("VTRANGTHAI",VTRANGTHAI),
                                                                    new OracleParameter("VTUNGAY",VTUNGAY),
                                                                    new OracleParameter("VDENNGAY",VDENNGAY),
                                                                    new OracleParameter("VTHAMPHANIDID",VTHAMPHANIDID),
                                                                    new OracleParameter("VTHUKYID",VTHUKYID),
                                                                    new OracleParameter("VCHECKEDLIST",VCHECKEDLIST),
                                                                    new OracleParameter("VPAGEINDEX",VPAGEINDEX),
                                                                    new OracleParameter("VPAGESIZE",VPAGESIZE),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_KHANGCAOQUAHAN_TIMKIEM.APS_PT_KCQUAHAN", parameters);
                return tbl;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion
    }
}