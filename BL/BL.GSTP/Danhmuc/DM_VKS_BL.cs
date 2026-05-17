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
    public class DM_VKS_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable DMVKSSEARCH(decimal DonViID, string LoaiVKS, string TextKey, string MaTenDonVi, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("DonviID",DonViID),
                new OracleParameter("LoaiVKS",LoaiVKS),
                new OracleParameter("TextKey",TextKey),
                new OracleParameter("MaTenDonVi",MaTenDonVi),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DMVKSSEARCH", prm);
        }
        public DataTable GetAll_VKS_ToiCao_CapCao()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_VKS_GetAll_CC_TC", prm);
        }

        public DataTable GetAll_VKS_CapCao()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_VKS_GetAll_CC", prm);
        }

        public string GetTextByID(decimal ID)
        {
            try
            {
                DM_HANHCHINH hanhChinh = dt.DM_HANHCHINH.Where(x => x.ID == ID).FirstOrDefault();
                if (hanhChinh != null)
                {
                    return hanhChinh.MA_TEN;
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
    }
}