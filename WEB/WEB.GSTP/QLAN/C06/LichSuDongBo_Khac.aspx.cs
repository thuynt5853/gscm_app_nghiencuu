using BL.GSTP.DLQGC06;
using DAL.GSTP;
using System;
using System.Globalization;
using System.Data;
using Module.Common;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace WEB.GSTP.QLAN.C06
{
    public partial class LichSuDongBo_Khac : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strVID = Request["vid"] + "";
                string sLoaiAn = Request["vloaian"] + "";
                string bicanId = Request["bId"] + "";
                string vuAnId = Request["vaId"] + "";
                switch (sLoaiAn)
                {
                    case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                        DLQGC06_AHS_BL ahsBl = new DLQGC06_AHS_BL();
                        if (string.IsNullOrEmpty(bicanId)) bicanId = "0";
                        if (string.IsNullOrEmpty(vuAnId)) vuAnId = "0";
                        DataTable hsTbl = ahsBl.GetDulieu_LichSuChuyen(Convert.ToDecimal(bicanId), Convert.ToDecimal(vuAnId));
                        List<C06_TOAAN_HINHSU_HISTORY> data = getListItem(hsTbl);
                        ahsHis.DataSource = data;
                        ahsHis.DataBind();
                        adsDgList.Visible = false;
                        ahsHis.Visible = true;

                        break;
                    case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                        DLQGC06_ADS_BL oBL = new DLQGC06_ADS_BL();
                        DataTable tbl = oBL.GetDulieu_LichSuChuyen(strVID);
                        if (tbl.Rows.Count > 0)
                        {

                            adsDgList.DataSource = tbl;
                            adsDgList.DataBind();
                            adsDgList.Visible = true;
                            ahsHis.Visible = false;
                        }
                        break;
                    case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                        DLQGC06_AHC_BL ahcBL = new DLQGC06_AHC_BL();
                        var tblHC = ahcBL.GetDulieu_LichSuChuyen(strVID);
                        if (tblHC.Rows.Count > 0)
                        {
                            adsDgList.DataSource = tblHC;
                            adsDgList.DataBind();
                            adsDgList.Visible = true;
                            ahsHis.Visible = false;
                        }
                        break;
                    case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                        DLQGC06_ALD_BL aldBL = new DLQGC06_ALD_BL();
                        var tblLD = aldBL.GetDulieu_LichSuChuyen(strVID);
                        if (tblLD.Rows.Count > 0)
                        {
                            adsDgList.DataSource = tblLD;
                            adsDgList.DataBind();
                            adsDgList.Visible = true;
                            ahsHis.Visible = false;
                        }
                        break;
                    case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                        DLQGC06_AKT_BL aldKT = new DLQGC06_AKT_BL();
                        var tblKT = aldKT.GetDulieu_LichSuChuyen(strVID);
                        if (tblKT.Rows.Count > 0)
                        {
                            adsDgList.DataSource = tblKT;
                            adsDgList.DataBind();
                            adsDgList.Visible = true;
                            ahsHis.Visible = false;
                        }
                        break;
                    default: return;
                }


            }
        }
        private List<C06_TOAAN_HINHSU_HISTORY> getListItem(DataTable tbl)
        {
            var data = new List<C06_TOAAN_HINHSU_HISTORY>();
            int i = 1;
            foreach (DataRow row in tbl.Rows)
            {
                var model = JsonConvert.DeserializeObject<C06_TOAAN_HINHSU_MODEL>(row["NOIDUNG"].ToString());
                var item = new C06_TOAAN_HINHSU_HISTORY()
                {
                    STT = i.ToString(),
                    LOAI_AN_TEN = "Hình Sự",
                    MavuAn = row["MAVUAN"].ToString(),
                    TenVuAn = row["tenvuan"].ToString(),
                    CAPXX = model.CAPXX == "SO_THAM" ? "Sơ thẩm" : "Phúc thẩm",
                    THULY = model.THULY,
                    THAMPHAN = model.ThamPhan,
                    BICAN_TEN = model.HOTENBICAO,
                    BICAN_NGAYSINH = model.NGAYSINHBICAO,
                    BICAN_SO_CCCD = model.SOGIAYTOBICAO,
                    BANAN_SO_BAN_AN = model.SOBANANORQD,
                    BANAN_NGAY_BA = model.NGAYRABANAN,
                    TENTOIDANH = model.ToiDanhTH,
                    TENHINHPHAT = model.HinhPhatTh,
                    BICAN_NGAYHIEULUC = model.NGAYHIEULUCBA,
                    GHICHU = row["GHICHU"].ToString(),
                    LOAI_HANH_DONG = row["LOAI_HANH_DONG"].ToString(),
                    trangThaiBanGhi = model.TRANGTHAIAHS == "HIEU_LUC" ? "Hiệu lực" : "Thu hồi" ,
                    NGUOITHUCHIEN = row["NGUOITHUCHIEN"].ToString(),
                    NGAYTHUCHIEN = row["NGAYTHUCHIEN"].ToString()
                };
                data.Add(item);
                i++;
            }
            return data;
        }


    }
}