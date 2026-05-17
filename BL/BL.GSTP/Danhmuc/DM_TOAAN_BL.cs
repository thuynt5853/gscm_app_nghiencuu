using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class DM_TOAAN_BL
    {
        GSTPContext dt = new GSTPContext();
        public String CurrConnectionString = ENUM_CONNECTION.GSTP;
        public DataTable DM_TOAAN_GETBY(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_donvi",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBY", parameters);
            return tbl;
        }
        public DataTable DM_TOAAN_GETBY_CAPXX(string vCapXX)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vCapXX",vCapXX),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBY_CAPXX", parameters);
            return tbl;
        }
        public DataTable DMTOAANSEARCH(decimal DonViID, string LoaiToaAn, string TextKey, string MaTenDonVi, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("DonviID",DonViID),
                new OracleParameter("LoaiToaAn",LoaiToaAn),
                new OracleParameter("TextKey",TextKey),
                new OracleParameter("MaTenDonVi",MaTenDonVi),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DMTOAANSEARCH", prm);
        }
        public DataTable DM_TOAAN_GETBY_PARENT(string V_CAPXX, string V_DONVIID, string V_LOAITOA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CAPXX",V_CAPXX),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("V_LOAITOA",V_LOAITOA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_TOAAN_GETBY_PARENT", prm);
        }
        public DataTable DM_TOAAN_GETBY_PARENT_HC(string V_CAPXX, string V_DONVIID, string V_LOAITOA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CAPXX",V_CAPXX),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("V_LOAITOA",V_LOAITOA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_TOAAN_GETBY_PARENT_HC", prm);
        }
        public DataTable DM_TOAAN_GETBY_PAREN_CHECK(string _CANBOID, string V_CAPXX, string V_DONVIID, string V_LOAITOA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CANBOID",_CANBOID),
                new OracleParameter("V_CAPXX",V_CAPXX),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("V_LOAITOA",V_LOAITOA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_TOAAN_GETBY_PARENT_CHECK", prm);
        }
        public DataTable SearchTop(decimal SoLuong, string Textsearch)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("SoLuong",SoLuong),
                new OracleParameter("TextKey",Textsearch),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_ToaAn_SearchTop", prm);
        }
        public DataTable GetAllToaCapHuyen(decimal SoLuong, string Textsearch)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("SoLuong",SoLuong),
                new OracleParameter("textsearch",Textsearch),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_ToaAn_GetAllToaCapHuyen", prm);
        }


        public string GetTextByID(decimal ID)
        {
            try
            {
                DM_TOAAN dmToaAn = dt.DM_TOAAN.Where(x => x.ID == ID).FirstOrDefault();
                if (dmToaAn != null)
                {
                    return dmToaAn.MA_TEN;
                }
                else
                {
                    return "";
                }
            }
            catch
            {
                return "";
            }
        }
        public DataTable DM_TOAAN_GETBYLOAIDONVI(string loaiDonVi)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("LOAIDONVI",loaiDonVi),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBYLOAIDONVI", parameters);
            return tbl;
        }
        public DataTable GetAllToaAnByCap(string textsearch, int soluong, int socap)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("so_luong",soluong),
                                                                        new OracleParameter("so_cap",socap),
                                                                        new OracleParameter("textsearch",textsearch),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_ToaAn_GetAllToaTheoCap", parameters);
            return tbl;
        }
        public DataTable GetAllToaSoTham(string textsearch, int soluong)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("so_luong",soluong),
                                                                        
                                                                        new OracleParameter("textsearch",textsearch),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_ToaAn_GetAllToaSoTham", parameters);
            return tbl;
        }
        public DataTable GetByCapChaID(Decimal CapChaID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vCapChaID",CapChaID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.DM_TOAAN_GETBYCAPCHAID", parameters);
            return tbl;
        }

        
        public DataTable GetAllToaTraVBTongDatOnline(string textsearch, int socap)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("so_cap",socap),
                                                                        new OracleParameter("textsearch",textsearch),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GetAllToaTraVBTongDatOnline", parameters);
            return tbl;
        }
        public DataTable GetToaSoTham_NhanDKKOnline(string textsearch, int socap)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("so_cap",socap),
                                                                        new OracleParameter("textsearch",textsearch),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GetToaSoTham_NhanDKKOnline", parameters);
            return tbl;
        }
        public DataTable DM_TOAAN_GETBYNOTCUR(decimal donviID,decimal vCurrID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_donvi",donviID),
                                                                         new OracleParameter("vCurrID",vCurrID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBYNOTCUR", parameters);
            return tbl;
        }
        public DataTable DM_TOAAN_GETBYNOTCUR_ST()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.DM_TOAAN_GETBYNOTCUR_ST", parameters);
            return tbl;
        }
        public DataTable DM_PHONGBANID_GET(String _TOAANID, String _PHONGBANID)
        {
            OracleParameter[] parameters = new OracleParameter[] 
            {
            new OracleParameter("V_TOAANID",_TOAANID),
            new OracleParameter("V_PHONGBANID",_PHONGBANID),
            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.PHONGBANID_GET", parameters);
            return tbl;
        }
        public DataTable DM_PCA_BYTOAAN(decimal _CANBOID, decimal V_DONVIID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CANBOID",_CANBOID),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_PCA_BYTOAAN", prm);
        }
        public DataTable DM_TOAAN_DIABAN(decimal _CANBOID, decimal V_DONVIID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CANBOID",_CANBOID),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.DM_TOAAN_DIABAN", prm);
        }
        public DataTable PCA_AND_DIABAN(decimal _CANBOID, decimal V_DONVIID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_CANBOID",_CANBOID),
                new OracleParameter("V_DONVIID",V_DONVIID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_STPT.PCA_AND_DIABAN", prm);
        }

        public DataTable QT_Donvi_TA_BC(String v_capxx, string _object_select)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("v_capxx",v_capxx),
                                                                        new OracleParameter("v_object_select",_object_select)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONVI_REPORT.GET_DONVI_BC", parameters);
            return tbl;
        }
        public DataTable QT_Donvi_TA_TINH(String _CAPCHAID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("V_CAPCHAID",_CAPCHAID)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONVI_REPORT.GET_DONVI_TINH", parameters);
            return tbl;
        }
        public DataTable GetDonVi_By_CapChaID_BCCC(Decimal vToaanID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vID",vToaanID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.DM_TOAAN_GET_DonViBYCC", parameters);
            return tbl;
        }
        public DataTable GET_Donvi_TA_TINH(String _CAPCHAID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("V_CAPCHAID",_CAPCHAID)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_DONVI_TINH", parameters);
            return tbl;
        }
        public DataTable GET_Donvi_TA_HUYEN(String _CAPCHAID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("V_CAPCHAID",_CAPCHAID)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_GET.GET_DONVI_HUYEN", parameters);
            return tbl;
        }
        public DataTable DM_TOAAN_GET_GDTT(decimal vAdmin, decimal donviID, String vloaitoa)
        {
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vAdmin",vAdmin),
                                                                        new OracleParameter("vdonviID",donviID),
                                                                         new OracleParameter("vloaitoa",vloaitoa),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_NHAP_TACH_DONVI.DM_TOAAN_GET_GDTTT", parameters);
            return tbl;
        }
    }
}