using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;


namespace WEB.DONKHOIKIEN.Ajax
{
    public partial class SearchDanhmuc : System.Web.UI.Page
    {
        //-------------------------------------
        [WebMethod]
        public static string[] GetAllToaTraVBTongDatOnline(string textsearch)
        {
            int Soluong = 8;
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_TOAAN_BL obj = new DM_TOAAN_BL();
            DataTable tbl = obj.GetAllToaTraVBTongDatOnline(textsearch, Soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    arr.Add(row["ID"].ToString() + "_" + row["MA_TEN"]);
            }
            return arr.ToArray();
        }
        //-------------------------------------
        [WebMethod]
        public static string[] GetAllToaNhanDKKOnline(string textsearch)
        {
            int Soluong = 8;
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_TOAAN_BL obj = new DM_TOAAN_BL();
            DataTable tbl = obj.GetToaSoTham_NhanDKKOnline(textsearch, Soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    arr.Add(row["ID"].ToString() + "_" + row["MA_TEN"]);
            }
            return arr.ToArray();
        }
        
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchTopToaAn(string textsearch)
        {
            Decimal Soluong = 8;
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_TOAAN_BL obj = new DM_TOAAN_BL();
            DataTable tbl = obj.SearchTop(Soluong, textsearch);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    arr.Add(row["ID"].ToString() + "_" + row["MA_TEN"]);
                }
            }
            return arr.ToArray();
        }        
    }
}