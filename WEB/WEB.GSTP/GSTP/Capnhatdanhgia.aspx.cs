using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class Capnhatdanhgia : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadData();
                    if (Request["dga"] != null && Request["dga"].ToString() == "0")
                    {
                        pnUBHDXX.Visible = true;
                    }
                    else
                    {
                        pnUBHDXX.Visible = false;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            string LoaiAn = string.IsNullOrEmpty(Request["loa"] + "") ? "" : Request["loa"].ToString(),
                MaVaiTro = string.IsNullOrEmpty(Request["vtr"] + "") ? "" : Request["vtr"].ToString();
            decimal VuAnID = string.IsNullOrEmpty(Request["vua"] + "") ? 0 : Convert.ToDecimal(Request["vua"].ToString()),
                ToaAnID = string.IsNullOrEmpty(Request["toa"] + "") ? 0 : Convert.ToDecimal(Request["toa"].ToString()),
                ThamPhanID = string.IsNullOrEmpty(Request["thp"] + "") ? 0 : Convert.ToDecimal(Request["thp"].ToString());

            if (LoaiAn == ENUM_LOAIAN.AN_DANSU)
            {
                ADS_DON dADS = dt.ADS_DON.Where(x => x.ID == VuAnID).FirstOrDefault<ADS_DON>();
                if (dADS != null)
                {
                    lblTenVuAn.Text = dADS.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_HINHSU)
            {
                AHS_VUAN dAHS = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                if (dAHS != null)
                {
                    lblTenVuAn.Text = dAHS.TENVUAN;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_HANHCHINH)
            {
                AHC_DON dAHC = dt.AHC_DON.Where(x => x.ID == VuAnID).FirstOrDefault<AHC_DON>();
                if (dAHC != null)
                {
                    lblTenVuAn.Text = dAHC.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_HONNHAN_GIADINH)
            {
                AHN_DON dAHN = dt.AHN_DON.Where(x => x.ID == VuAnID).FirstOrDefault<AHN_DON>();
                if (dAHN != null)
                {
                    lblTenVuAn.Text = dAHN.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI)
            {
                AKT_DON dAKT = dt.AKT_DON.Where(x => x.ID == VuAnID).FirstOrDefault<AKT_DON>();
                if (dAKT != null)
                {
                    lblTenVuAn.Text = dAKT.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_LAODONG)
            {
                ALD_DON dALD = dt.ALD_DON.Where(x => x.ID == VuAnID).FirstOrDefault<ALD_DON>();
                if (dALD != null)
                {
                    lblTenVuAn.Text = dALD.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.AN_PHASAN)
            {
                APS_DON dAPS = dt.APS_DON.Where(x => x.ID == VuAnID).FirstOrDefault<APS_DON>();
                if (dAPS != null)
                {
                    lblTenVuAn.Text = dAPS.TENVUVIEC;
                }
            }
            if (LoaiAn == ENUM_LOAIAN.BPXLHC)
            {
                XLHC_DON dXLHC = dt.XLHC_DON.Where(x => x.ID == VuAnID).FirstOrDefault<XLHC_DON>();
                if (dXLHC != null)
                {
                    lblTenVuAn.Text = dXLHC.TENVUVIEC;
                }
            }
            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault<DM_TOAAN>();
            if (toaAn != null)
            {
                lblTenToaAn.Text = toaAn.TEN;
            }
            DM_CANBO cBo = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault<DM_CANBO>();
            if (cBo != null)
            {
                lblThamPhan.Text = cBo.HOTEN;
            }
            if (MaVaiTro != "")
            {
                if (MaVaiTro == "THAMPHAN")
                {
                    lblVaiTro.Text = "Chủ tọa";
                }
                else
                {
                    lblVaiTro.Text = "Thành phần HĐXX";
                }
            }
            else
            {
                lblVaiTro.Text = "";
            }
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            string link = "";
            if (Request["ds"] != null)
            {
                link = "DanhsachAnHuy.aspx?tt=1";
            }
            else
            {
                link = Cls_Comon.GetRootURL() + "GSTP/DanhGiaAnHuy/Danhsach.aspx?tt=1";
            }
            Response.Redirect(link);
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            rdbTuDanhGia.SelectedValue = rdbUBDanhGia.SelectedValue = "0";
            txtLyDoTuDG.Text = txtLyDoUBDanhGia.Text = "";
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            string link = "";
            if (Request["dga"] != null)
            {
                link = "DanhsachAnHuy.aspx";
            }
            else
            {
                link = Cls_Comon.GetRootURL() + "/GSTP/DanhGiaAnHuy/Danhsach.aspx";
            }
            Response.Redirect(link);
        }
    }
}