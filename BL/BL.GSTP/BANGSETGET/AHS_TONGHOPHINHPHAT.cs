using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Module.Common;
using DAL.GSTP;

namespace BL.GSTP.BANGSETGET
{
    public class AHS_TONGHOPHINHPHAT
    {
        public Decimal ID{ get; set; }
	    public Decimal TOAANID_ST{ get; set; }
        public Decimal TOAANID_PT { get; set; }
        public Decimal VUANID{ get; set; }
	    public Decimal BICAOID{ get; set; }
	    public String TENTOIDANH_ST{ get; set; }
        public String TENTOIDANH_PT { get; set; }
        public String HINHPHAT_ST{ get; set; }
	    public String HINHPHAT_PT{ get; set; }
	    public String TONGHOPHINHPHAT{ get; set; }
        public Decimal HP_TANGGIAM { get; set; }
        public DateTime? NGAYSUA{ get; set; }
	    public String NGUOISUA{ get; set; }
	    public DateTime? NGAYTAO{ get; set; }
	    public String NGUOITAO{ get; set; }


        public string Tonghophinhphat_ST(Decimal VVUANID, Decimal VBICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VVUANID",VVUANID),
                new OracleParameter("VBICAOID",VBICAOID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string HinhPhaTongHop = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_ST", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                HinhPhaTongHop = tbl.Rows[0][0].ToString();
            }
            return HinhPhaTongHop;
        }
        public string Tonghophinhphat_PT(Decimal VUANID, Decimal VBICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VVUANID",VUANID),
                new OracleParameter("VBICAOID",VBICAOID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string HinhPhaTongHop = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_PT", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                HinhPhaTongHop = tbl.Rows[0][0].ToString();
            }
            return HinhPhaTongHop;
        }
        public string Tonghophinhphat_Sosanh(Decimal VUANID, Decimal VBICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("VUANID",VUANID),
                new OracleParameter("VBICAOID",VBICAOID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string HinhPhaTongHop = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_SOSANH", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                HinhPhaTongHop = tbl.Rows[0][0].ToString();
            }
            return HinhPhaTongHop;
        }

        public bool Capnhat_Tonghophinhphat_byVuanAndBicanid(Decimal MAGIAIDOAN, Decimal VUANID, Decimal BICANID, decimal DONVIID, String USERNAME)
        {
            try
            {
                if (MAGIAIDOAN == 2)
                {
                    decimal checkValidUpdateorinsert = 0;
                    AHS_TONGHOPHINHPHAT saveTHHP = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID= {VUANID} AND BICAOID = {BICANID}").FirstOrDefault();

                    if (saveTHHP == null)
                    {
                        saveTHHP = new AHS_TONGHOPHINHPHAT();
                        checkValidUpdateorinsert = 1;
                    }

                    saveTHHP.HINHPHAT_ST = saveTHHP.Tonghophinhphat_ST(VUANID, BICANID);
                
                    AHS_SOTHAM_BANAN_DIEU_CHITIET toidanhchinh = DataExtensions.GetAllWithClause<AHS_SOTHAM_BANAN_DIEU_CHITIET>($"BICANID= {BICANID} AND VUANID = {VUANID} AND ISMAIN = 1").FirstOrDefault();
                    string toidanh = "";
                    if (toidanhchinh != null)
                    {
                        toidanh = toidanhchinh.TENTOIDANH;
                    }
                    saveTHHP.TENTOIDANH_ST = toidanh;

                    if (checkValidUpdateorinsert == 1)
                    {
                        saveTHHP.TOAANID_ST = DONVIID;
                        saveTHHP.VUANID = VUANID;
                        saveTHHP.BICAOID = BICANID;


                        saveTHHP.NGAYTAO = DateTime.Now;
                        saveTHHP.NGUOITAO = USERNAME;
                        DataExtensions.Insert(saveTHHP);
                    }
                    else
                    {
                        saveTHHP.NGAYSUA = DateTime.Now;
                        saveTHHP.NGUOISUA = USERNAME;
                        DataExtensions.Update(saveTHHP);
                    }
                }
            
                if (MAGIAIDOAN == 3)
                {
                    decimal checkValidUpdateorinsert = 0;
                    AHS_TONGHOPHINHPHAT saveTHHP = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID= {VUANID} AND BICAOID = {BICANID}").FirstOrDefault();

                    if (saveTHHP == null)
                    {
                        saveTHHP = new AHS_TONGHOPHINHPHAT();
                        checkValidUpdateorinsert = 1;
                    }

                    saveTHHP.HINHPHAT_PT = saveTHHP.Tonghophinhphat_PT(VUANID, BICANID);
                    saveTHHP.TONGHOPHINHPHAT = saveTHHP.Tonghophinhphat_Sosanh(VUANID, BICANID);

                    string toidanh = "";
                    AHS_PHUCTHAM_BANAN_DIEU_CT toidanhchinh = DataExtensions.GetAllWithClause<AHS_PHUCTHAM_BANAN_DIEU_CT>($"BICANID= {BICANID} AND ISMAIN = 1").FirstOrDefault();

                    if (toidanhchinh != null)
                    {
                        toidanh = toidanhchinh.TENTOIDANH;
                    }
                    saveTHHP.TENTOIDANH_PT = toidanh;

                    if (saveTHHP.TONGHOPHINHPHAT.ToLower().Contains("tăng"))
                    {
                        saveTHHP.HP_TANGGIAM = 1; // Tăng
                    }
                    else if (saveTHHP.TONGHOPHINHPHAT.ToLower().Contains("giảm"))
                    {
                        saveTHHP.HP_TANGGIAM = 2; // Giảm
                    }
                    else
                    {
                        saveTHHP.HP_TANGGIAM = 0;
                    }

                    if (checkValidUpdateorinsert == 1)
                    {
                        saveTHHP.TOAANID_PT = DONVIID;
                        saveTHHP.VUANID = VUANID;
                        saveTHHP.BICAOID = BICANID;

                        saveTHHP.NGAYTAO = DateTime.Now;
                        saveTHHP.NGUOITAO = USERNAME;
                        DataExtensions.Insert(saveTHHP);
                    }
                    else
                    {
                        saveTHHP.NGAYSUA = DateTime.Now;
                        saveTHHP.NGUOISUA = USERNAME;
                        DataExtensions.Update(saveTHHP);
                    }

                }

                return true;
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                return false;
            }

        }
    }
}