using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
namespace BL.GSTP
{
    public class QT_TUPHAP_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable QT_Donvi_THADS(decimal vGet_chil, decimal vDonvi_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("vGet_chil",vGet_chil),
                                                                        new OracleParameter("vdonviID",vDonvi_id),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_DONVI_DS", parameters);
            return tbl;
        }
        public DataTable QT_Donvi_THADS_BC(String v_capxx,string _object_select)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("v_capxx",v_capxx),
                                                                        new OracleParameter("v_object_select",_object_select)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_REPORT.GET_DONVI_BC", parameters);
            return tbl;
        }
        public DataTable QT_Donvi_THADS_TINH(String _CAPCHAID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("V_CAPCHAID",_CAPCHAID)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_REPORT.GET_DONVI_TINH", parameters);
            return tbl;
        }
        public static MenuPermission GetMenuPer_THADS(string vMenuPath, decimal vUserID)
        {

            vMenuPath = vMenuPath.ToLower();
            try
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vMenuPath",vMenuPath),
                                                                          new OracleParameter("vUserID",vUserID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_NGUOIDUNG_MENU_CHECK", parameters);
                if (tbl.Rows.Count > 0)
                {
                    MenuPermission oT = new MenuPermission();
                    DataRow r = tbl.Rows[0];
                    oT.MENUID = Convert.ToDecimal(r["MENUID"]);
                    oT.XEM = (r["XEM"] + "") == "1" ? true : false;
                    oT.TAOMOI = (r["TAOMOI"] + "") == "1" ? true : false;
                    oT.CAPNHAT = (r["CAPNHAT"] + "") == "1" ? true : false;
                    oT.XOA = (r["XOA"] + "") == "1" ? true : false;
                    return oT;
                }
                else return new MenuPermission(); ;
            }
            catch (Exception ex)
            {
                return new MenuPermission();
            }
        }
        public DataTable QT_CHUONGTRINH_GETBYUSER_THADS(decimal vUSERID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vUSERID",vUSERID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_CHUONGTRINH_GETBYUSER", parameters);
            return tbl;
        }
        public DataTable QT_NHOMNGUOIDUNG_MENU_GETBY_THADS(decimal NhomID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("vNhomID",NhomID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_NHOMNGUOIDUNG_MENU_GETBY", parameters);
            return tbl;
        }
        public DataTable QT_NHOMNGUOIDUNG_SEARCHBY_THADS(string LOAITOA, string strSearch)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vLOAITOA",LOAITOA),
                                                                          new OracleParameter("tennhom",strSearch),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_NHOMNGUOIDUNG_SEARCHBY", parameters);
            return tbl;
        }
        public bool DeleteByID_THADS(decimal ID)
        {
            TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
            dt.TUPHAP_NGUOISUDUNG.Remove(oT);
            dt.SaveChanges();
            return true;
        }
        public TUPHAP_NGUOISUDUNG GetByID_THADS(decimal ID)
        {
            return dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
        }
        public List<TUPHAP_NGUOISUDUNG> GetByUserName_THADS(string str)
        {
            return dt.TUPHAP_NGUOISUDUNG.Where(x => x.USERNAME.ToLower() == str.ToLower()).ToList();
        }
        public DataTable QT_NGUOIDUNG_SEARCH_THADS(decimal ChuongtrinhID, string vDonvi, decimal vLoaiUser, string vUserName, string vHoten)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ChuongtrinhID),
                                                                          new OracleParameter("vDonvi",vDonvi),
                                                                           new OracleParameter("vLoaiUser",vLoaiUser),
                                                                            new OracleParameter("vUserName",vUserName),
                                                                             new OracleParameter("vHoten",vHoten),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_NGUOIDUNG_SEARCH", parameters);
            return tbl;
        }
        public DataTable QT_NGUOIDUNG_SEARCH_THADS_CLIENT(decimal ChuongtrinhID, string vDonvi, decimal vLoaiUser, string vUserName, string vHoten)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ChuongtrinhID),
                                                                          new OracleParameter("vDonvi",vDonvi),
                                                                           new OracleParameter("vLoaiUser",vLoaiUser),
                                                                            new OracleParameter("vUserName",vUserName),
                                                                             new OracleParameter("vHoten",vHoten),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.QT_NGUOIDUNG_SEARCH_CLIENT", parameters);
            return tbl;
        }
        public DataTable DM_TOAAN_GETBY_THADS(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_donvi",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.DM_TOAAN_GETBY", parameters);
            return tbl;
        }
        public DataTable CheckLogin(string vUserName, string vUserPass)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_USER_NAME",vUserName),
                                                                        new OracleParameter("V_PASSWORD",vUserPass),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.TUPHAP_NGUOIDUNG_CHECKLOGIN", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GETBYGROUPNAME_THADS(string vGroupName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupName",vGroupName),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.DM_DATAITEM_GETBYGROUPNAME", parameters);
            return tbl;
        }
        public DataTable UserInfor_his(decimal vGet_chil, String V_DONVI_THA_ID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("vGet_chil",vGet_chil),
                                                                        new OracleParameter("V_DONVI_THA_ID",V_DONVI_THA_ID),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QUANTRI.TUPHAP_INFOR_HIS_DS", parameters);
            return tbl;
        }
    }
}