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
    public class DM_DATAITEM_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable DM_DATAITEM_SEARCH(decimal vGroupID, decimal vParentID, string vtxtSearch, decimal vCurrPageIndex, decimal vPageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupID",vGroupID),
                                                                        new OracleParameter("vParentID",vParentID),
                                                                        new OracleParameter("vtxtSearch",vtxtSearch),
                                                                        new OracleParameter("vCurrPageIndex",vCurrPageIndex),
                                                                        new OracleParameter("vPageSize",vPageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_SEARCH", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_LOAIAN_SEARCH(decimal vGroupID, decimal vParentID, string vtxtSearch, decimal vCurrPageIndex, decimal vPageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupID",vGroupID),
                                                                        new OracleParameter("vParentID",vParentID),
                                                                        new OracleParameter("vtxtSearch",vtxtSearch),
                                                                        new OracleParameter("vCurrPageIndex",vCurrPageIndex),
                                                                        new OracleParameter("vPageSize",vPageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_LOAIAN_SEARCH", parameters);
            return tbl;
        }


        public DataTable DM_DATAITEM_GETBYGROUPNAME_LoaiAn(string vGroupName, int loaian)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("vGroupName",vGroupName),
                                                                       new OracleParameter("vLoaiAn",loaian),
                                                                       new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GetByGroup_LoaiAn", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GETBYGROUPNAME(string vGroupName)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupName",vGroupName),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETBYGROUPNAME", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GETBYPARENTID(Decimal ParentID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_parentid",ParentID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETBYPARENTID", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GETBY2GROUPNAME(string vGroupName1, string vGroupName2)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupName1",vGroupName1),
                                                                        new OracleParameter("vGroupName2",vGroupName2),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETBY2GROUPNAME", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GetByGroupName_And_Key(string vGroupName, string vTextKey)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupName",vGroupName),
                                                                        new OracleParameter("vTextKey",vTextKey),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETBYGNAME_KEY", parameters);
            return tbl;
        }
        public DataTable DM_DATAITEM_GetBy2GroupName_And_Key(string vGroupName1, string vGroupName2, string vTextKey)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vGroupName1",vGroupName1),
                                                                        new OracleParameter("vGroupName2",vGroupName2),
                                                                        new OracleParameter("vTextKey",vTextKey),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETBY2GNAME_KEY", parameters);
            return tbl;
        }
        public string GetTextByID(decimal ID)
        {
            try
            {
                DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
                return oT.TEN;
            }
            catch (Exception ex)
            {
                return "";
            }
        }
        public Decimal GetQuocTichID_VN()
        {
            String Ma = ENUM_MAQUOCTICH.VIETNAM.ToLower();
            Decimal CurrID = 0;
            try
            {
                CurrID = dt.DM_DATAITEM.Where(x => x.MA.ToLower().Trim() == Ma).Single<DM_DATAITEM>().ID;
            }
            catch (Exception ex) { }
            return CurrID;
        }
        public DataTable GetAllQHPL()
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DataItem_GetAllQHPL", parameters);
            return tbl;
        }
        public DataTable GetAllQHPL_KoPhaiHanhChinh(String QHPL_HanhChinh_Name)
        {
            OracleParameter[] parameters = new OracleParameter[] {

                new OracleParameter("QHPL_HanhChinh_Name",QHPL_HanhChinh_Name),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GetQHPLKoPhaiHanhChinh", parameters);
            return tbl;
        }

        public DataTable DM_DATAITEM_GET_ALL_CHILD_BYPARENTID(Decimal ParentID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_parentid",ParentID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_DATAITEM_GETAll_ByPARENTID", parameters);
            return tbl;
        }
    }
}