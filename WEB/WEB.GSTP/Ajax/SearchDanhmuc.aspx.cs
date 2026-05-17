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


namespace WEB.GSTP.Ajax
{
    public partial class SearchDanhmuc : System.Web.UI.Page
    {
        [WebMethod]
        public static string getBMBAOCAO(string d, string l, string g)
        {
            List<string> arr = new List<string>();
            decimal vDonID, LoaiAn, vGiaiDoan;
            string str = "";
            ADS_DON_BL oBL = new ADS_DON_BL();
            vDonID = Convert.ToDecimal(d);
            LoaiAn = Convert.ToDecimal(l);
            vGiaiDoan = Convert.ToDecimal(g);
            DataTable oDT = oBL.ADS_FILE_GETBYDON(vDonID, LoaiAn, vGiaiDoan);
            DataView dv = oDT.DefaultView;
            dv.Sort = "THUTU asc";
            oDT = dv.ToTable();

            //foreach (DataRow r in oDT.Rows)
            //{
            //    str += "<li><a href=\"javascript:;\" onclick=\"popup_BM('" + r["MABM"] + "', '" + r["DUONGDAN"] + "')\"> " + r["MABM"] + " - " + r["TENBM"] + "</a></li>";
            //}

            //Khai them
            foreach (DataRow r in oDT.Rows)
            {
                if (r["MABM"] + "" == "65-DS" || r["MABM"] + "" == "35-HC")
                {
                    str += "<li><a href=\"javascript:;\" onclick=\"DownLoadBM()\"> " + r["MABM"] + " - " + r["TENBM"] + "</a></li>";
                }
                else
                {
                    str += "<li><a href=\"javascript:;\" onclick=\"popup_BM('" + r["MABM"] + "', '" + r["DUONGDAN"] + "')\"> " + r["MABM"] + " - " + r["TENBM"] + "</a></li>";
                    if (r["MABM"] + "" == "49-DS")
                    {
                        str += "<li><a href=\"javascript:;\" onclick=\"popup_BM('" + "49-DS1" + "', '" + r["DUONGDAN"] + "')\"> " + r["MABM"] + " - Quyết định hoãn phiên tòa (mới)" + "</a></li>";
                    }
                    if (r["MABM"] + "" == "47-DS")
                    {
                        str += "<li><a href=\"javascript:;\" onclick=\"popup_BM('" + "47-DS1" + "', '" + r["DUONGDAN"] + "')\"> " + r["MABM"] + " - Giấy triệu tập đương sự" + "</a></li>";
                    }
                    if (r["MABM"] + "" == "77-DS")
                    {
                        str += "<li><a href=\"javascript:;\" onclick=\"popup_BM('" + "77-DS1" + "', '" + r["DUONGDAN"] + "')\"> " + r["MABM"] + " - Giấy triệu tập đương sự" + "</a></li>";
                    }
                }
                
            }
            //

            return str;
        }

        [WebMethod]
        public static string[] GetCoQuan(string q)
        {
            GSTPContext dt = new GSTPContext();
            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_COQUANNGOAI> lst;
            if (q == " ")
                lst = dt.DM_COQUANNGOAI.OrderBy(y => y.TENCOQUAN).Take(20).ToList();
            else
                lst = dt.DM_COQUANNGOAI.Where(x => x.TENCOQUAN.ToLower().Contains(q)).OrderBy(y => y.TENCOQUAN).Take(7).ToList();

            foreach (DM_COQUANNGOAI it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.TENCOQUAN);
            }
            return arr.ToArray();
        }

        [WebMethod]
        public static string[] GetDMHanhchinh(string q)
        {
            GSTPContext dt = new GSTPContext();
            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_HANHCHINH> lst;
            if (q == " ")
                lst = dt.DM_HANHCHINH.Where(x => x.LOAI == 1).OrderBy(y => y.ARRTHUTU).Take(20).ToList();
            else
                lst = dt.DM_HANHCHINH.Where(x => x.MA_TEN.ToLower().Contains(q) || x.MA == q).OrderBy(y => y.ARRTHUTU).Take(7).ToList();

            foreach (DM_HANHCHINH it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.MA_TEN);
            }
            return arr.ToArray();
        }
        [WebMethod]
        public static string[] GetDMHuyen(string q)
        {
            GSTPContext dt = new GSTPContext();
            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_HANHCHINH> lst;
            if (q == " ")
                lst = dt.DM_HANHCHINH.Where(x => x.LOAI == 1).OrderBy(y => y.ARRTHUTU).Take(20).ToList();
            else
                lst = dt.DM_HANHCHINH.Where(x => (x.MA_TEN.ToLower().Contains(q) || x.MA == q)).OrderBy(y => y.ARRTHUTU).Take(50).ToList();

            foreach (DM_HANHCHINH it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.MA_TEN);
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        [WebMethod]
        //public static string[] GetDMToaAn(string q, string checkUyQuyen)
        public static string[] GetDMToaAn(string q)
        {
            Decimal ToaAnID = Convert.ToDecimal(HttpContext.Current.Session[ENUM_SESSION.SESSION_DONVIID]);
            GSTPContext dt = new GSTPContext();
            DM_TOAAN objToaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            DM_TOAAN objToaAnCha = dt.DM_TOAAN.Where(x => x.ID == objToaAn.CAPCHAID).FirstOrDefault();

            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_TOAAN> lst;

            if (q == " ")
            {
                lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1).OrderBy(y => y.ARRTHUTU).Take(20).ToList();
            }
            else
            {
                lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && (x.MA_TEN.ToLower().Contains(q) || x.MA == q)).OrderBy(y => y.ARRTHUTU).Take(20).ToList();
            }


            foreach (DM_TOAAN it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.MA_TEN);
            }
            return arr.ToArray();
        }
        [WebMethod]
        public static string[] GetDMToaAn_ByDonVi(string DonVi, string q)
        {
            GSTPContext dt = new GSTPContext();
            decimal dvID = DonVi + "" == "" ? 0 : Convert.ToDecimal(DonVi);
            string arrSapXep = "0", arrSapXepEx = "";
            DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == dvID).FirstOrDefault();
            if (toaan != null)
            {
                arrSapXep = toaan.ARRSAPXEP;
            }
            arrSapXepEx += arrSapXep + "/";
            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_TOAAN> lst;
            if (q == " ")
            {
                lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && (x.ARRSAPXEP.Contains(arrSapXepEx) || x.ARRSAPXEP == arrSapXep)).OrderBy(y => y.ARRTHUTU).Take(20).ToList();
            }
            else
            {
                lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && (x.ARRSAPXEP.Contains(arrSapXepEx) || x.ARRSAPXEP == arrSapXep) && (x.MA_TEN.ToLower().Contains(q) || x.MA == q)).OrderBy(y => y.ARRTHUTU).Take(7).ToList();
            }

            foreach (DM_TOAAN it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.MA_TEN);
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchTopToaAn(string textsearch)
        {
            Decimal Soluong = 12;
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
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchBoLuat_AnDanSu(string textsearch)
        {
            int Soluong = 8;
            int loai = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_DANSU);
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_BOLUAT_BL obj = new DM_BOLUAT_BL();
            DataTable tbl = obj.SearchTopByLoai(Soluong, textsearch, loai);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    arr.Add(row["ID"].ToString() + "_" + row["TENBOLUAT"]);
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchToiDanhTheoLuatID(string textsearch, int luatid)
        {
            int Soluong = 8;
            // string textsearch = "";
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_BOLUAT_TOIDANH_BL obj = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = obj.SearchTopByLuatID(luatid, textsearch, Soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    arr.Add(row["ID"].ToString() + "_" + row["TENTOIDANH"]);
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchTopVKS(string textsearch, int toaanid)
        {
            Decimal Soluong = 8;
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            AHS_VUAN_BL obj = new AHS_VUAN_BL();
            DataTable tbl = obj.SearchTopByToaAn(Soluong, textsearch, toaanid);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                }
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        [WebMethod]
        public static string[] SearchTopCanBoByDonVi(decimal DonViID, string textsearch)
        {
            List<string> arr = new List<string>();
            textsearch = textsearch.ToLower();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            DataTable tbl = obj.DM_CANBO_GETBYDONVI_SEARCHTOP(DonViID, textsearch);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    arr.Add(row["ID"].ToString() + "_" + row["HOTEN"]);
                }
            }
            return arr.ToArray();
        }
        //-------------------------------------------------
        [WebMethod]
        public static string[] GetAllQuanHePhapLuat(string q, string LoaiVuViec)
        {
            List<string> arr = new List<string>();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = null;
            switch (LoaiVuViec)
            {
                case ENUM_LOAIVUVIEC.AN_DANSU:
                    tbl = oBL.DM_DATAITEM_GetBy2GroupName_And_Key(ENUM_DANHMUC.QUANHEPL_TRANHCHAP, ENUM_DANHMUC.QUANHEPL_YEUCAU, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                    tbl = oBL.DM_DATAITEM_GetByGroupName_And_Key(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                    tbl = oBL.DM_DATAITEM_GetBy2GroupName_And_Key(ENUM_DANHMUC.QUANHEPL_TRANHCHAP_HNGD, ENUM_DANHMUC.QUANHEPL_YEUCAU_HNGD, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                    tbl = oBL.DM_DATAITEM_GetBy2GroupName_And_Key(ENUM_DANHMUC.QUANHEPL_TRANHCHAP_KDTM, ENUM_DANHMUC.QUANHEPL_YEUCAU_KDTM, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_LAODONG:
                    tbl = oBL.DM_DATAITEM_GetBy2GroupName_And_Key(ENUM_DANHMUC.QUANHEPL_TRANHCHAP_LD, ENUM_DANHMUC.QUANHEPL_YEUCAU_LD, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_PHASAN:
                    tbl = oBL.DM_DATAITEM_GetByGroupName_And_Key(ENUM_DANHMUC.QUANHEPL_YEUCAUPS, q);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
                case ENUM_LOAIVUVIEC.AN_HINHSU:
                    DM_BOLUAT_TOIDANH_BL bltdbl = new DM_BOLUAT_TOIDANH_BL();
                    tbl = bltdbl.GetAllDieuLuatByBoLuat(ENUM_LOAIVUVIEC.AN_HINHSU);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        foreach (DataRow row in tbl.Rows)
                            arr.Add(row["ID"].ToString() + "_" + row["TEN"]);
                    }
                    break;
            }
            return arr.ToArray();
        }
        //-------------------------------------------------

        [WebMethod]
        public static string[] GetCanBoVKSByToaAn(string q, decimal ToaAnID)
        {
            GSTPContext dt = new GSTPContext();
            List<string> arr = new List<string>();
            q = q.ToLower();
            List<DM_CANBOVKS> lst = new List<DM_CANBOVKS>();
            DM_VKS vks = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).FirstOrDefault<DM_VKS>();
            if (vks != null)
            {
                if (q == " ")
                    lst = dt.DM_CANBOVKS.Where(x => x.HIEULUC == 1 && x.VSKID == vks.ID).OrderBy(x => x.HOTEN).Take(20).ToList();
                else
                    lst = dt.DM_CANBOVKS.Where(x => x.HIEULUC == 1 && x.VSKID == vks.ID && x.HOTEN.ToLower().Contains(q)).OrderBy(x => x.HOTEN).Take(7).ToList();
            }
            foreach (DM_CANBOVKS it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.HOTEN);
            }
            return arr.ToArray();
        }
        [WebMethod]
        public static string[] GDTGetCongVan(string q, string strToaAnID)
        {
            GSTPContext dt = new GSTPContext();
            List<string> arr = new List<string>();
            q = q.ToLower();
            decimal ToaAnID = 0;
            if (strToaAnID != "" && strToaAnID != "0") ToaAnID = Convert.ToDecimal(strToaAnID);
            List<GDTTT_DON> lst;
            if (ToaAnID != 0)
                lst = dt.GDTTT_DON.Where(x => x.CV_TOAANID == ToaAnID && x.CV_SO.ToLower().Contains(q)).OrderBy(x => x.CV_NGAY).Take(7).ToList();
            else
                lst = dt.GDTTT_DON.Where(x => x.CV_SO.ToLower().Contains(q)).OrderBy(x => x.CV_NGAY).Take(7).ToList();

            foreach (GDTTT_DON it in lst)
            {
                arr.Add(it.ID.ToString() + "_" + it.CV_SO + ", ngày" + (it.CV_NGAY == null ? "" : Convert.ToDateTime(it.CV_NGAY).ToString("dd/MM/yyyy")) + ", " + it.CV_TENDONVI);
            }
            return arr.ToArray();
        }

    }
}