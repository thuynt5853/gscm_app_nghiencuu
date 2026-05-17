using BL.GSTP;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;


namespace WEB.GSTP.Quantri.Cauhinh
{
    public partial class CauHinhMatKhau : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadInfo();

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
      
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            var OQuanTri = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
            OQuanTri.DO_DAI_TOI_THIEU = txtDoDaiToiThieu.Text;
            OQuanTri.CHU_HOA = chkPhaiCoChuHoa.Checked ? 1 : 0; 
            OQuanTri.CHU_THUONG = txtPhaiCoChuThuong.Checked ? 1 : 0; 
            OQuanTri.CO_SO = chkPhaiCoSo.Checked ? 1 : 0; 
            OQuanTri.CO_KY_TU_DAC_BIET = chkPhaiCoKyTuDacBiet.Checked ? 1 : 0;
            OQuanTri.CHUA_TEN_TAI_KHOAN = chkKhongChuaTenTaiKhoan.Checked ? 1 : 0;
            OQuanTri.CHUA_TEN_NGUOISD = chkKhongChuaHoTen.Checked ? 1 : 0;
            OQuanTri.CHUA_SDT = chkKhongChuaSoDienThoai.Checked ? 1 : 0;
            OQuanTri.CHUA_NAMSINH = chkKhongChuaNamSinh.Checked ? 1 : 0;
            OQuanTri.KHONG_TRUNG_MK_CU = chkTrungMatKhau.Checked ? 1 : 0;
            OQuanTri.SOLAN_NHAPSAI = txtSoLanDangNhapSai.Text;
            OQuanTri.THOIGIAN_DOIMATKHAU = txtThoiGianYeuCauThayDoiMK.Text;

            DataExtensions.Update<QUANTRI_MATKHAU>(OQuanTri);

            //------------------------           
            LoadInfo();
            lbthongbao.Text = "Cập nhật thành công!";
        }
        
        public void LoadInfo()
        {
            QUANTRI_MATKHAU OQuanTri = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
            if (OQuanTri == null) return;
            {

                txtDoDaiToiThieu.Text = OQuanTri.DO_DAI_TOI_THIEU;
                //OQuanTri.CHU_HOA = chkPhaiCoChuHoa.Checked ? 1 : 0;
                if (OQuanTri.CHU_HOA == 1)
                    chkPhaiCoChuHoa.Checked = true;
                else
                    chkPhaiCoChuHoa.Checked = false;
                //OQuanTri.CHU_THUONG = txtPhaiCoChuThuong.Checked ? 1 : 0;
                if (OQuanTri.CHU_THUONG == 1)
                    txtPhaiCoChuThuong.Checked = true;
                else
                    txtPhaiCoChuThuong.Checked = false;
                //OQuanTri.CO_SO = chkPhaiCoSo.Checked ? 1 : 0;
                if (OQuanTri.CO_SO == 1)
                    chkPhaiCoSo.Checked = true;
                else
                    chkPhaiCoSo.Checked = false;
                //OQuanTri.CO_KY_TU_DAC_BIET = chkPhaiCoKyTuDacBiet.Checked ? 1 : 0;
                if (OQuanTri.CO_KY_TU_DAC_BIET == 1)
                    chkPhaiCoKyTuDacBiet.Checked = true;
                else
                    chkPhaiCoKyTuDacBiet.Checked = false;
                //OQuanTri.CHUA_TEN_TAI_KHOAN = chkKhongChuaTenTaiKhoan.Checked ? 1 : 0;
                if (OQuanTri.CHUA_TEN_TAI_KHOAN == 1)
                    chkKhongChuaTenTaiKhoan.Checked = true;
                else
                    chkKhongChuaTenTaiKhoan.Checked = false;
                //OQuanTri.CHUA_TEN_NGUOISD = chkKhongChuaHoTen.Checked ? 1 : 0;
                if (OQuanTri.CHUA_TEN_NGUOISD == 1)
                    chkKhongChuaHoTen.Checked = true;
                else
                    chkKhongChuaHoTen.Checked = false;
                //OQuanTri.CHUA_SDT = chkKhongChuaSoDienThoai.Checked ? 1 : 0;
                if (OQuanTri.CHUA_SDT == 1)
                    chkKhongChuaSoDienThoai.Checked = true;
                else
                    chkKhongChuaSoDienThoai.Checked = false;
                //OQuanTri.CHUA_NAMSINH = chkKhongChuaNamSinh.Checked ? 1 : 0;
                if (OQuanTri.CHUA_NAMSINH == 1)
                    chkKhongChuaNamSinh.Checked = true;
                else
                    chkKhongChuaNamSinh.Checked = false;
                //OQuanTri.KHONG_TRUNG_MK_CU = chkTrungMatKhau.Checked ? 1 : 0;
                if (OQuanTri.KHONG_TRUNG_MK_CU == 1)
                    chkTrungMatKhau.Checked = true;
                else
                    chkTrungMatKhau.Checked = false;

                txtSoLanDangNhapSai.Text = OQuanTri.SOLAN_NHAPSAI;
                txtThoiGianYeuCauThayDoiMK.Text = OQuanTri.THOIGIAN_DOIMATKHAU;
            }
        }
        //public void LoadGrid()
        //{
        //    lbthongbao.Text = "";
        //    int page_size = 10;
        //    int pageindex = Convert.ToInt32(hddPageIndex.Value);
        //    DataTable tbl = null;
        //    DM_CONFIG_BL objBL = new DM_CONFIG_BL();
        //    tbl = objBL.GetAllPaging(pageindex, page_size);
        //    if (tbl != null && tbl.Rows.Count > 0)
        //    {
        //        int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

        //        #region "Xác định số lượng trang"
        //        hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
        //        lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
        //        Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
        //                     lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
        //        #endregion

        //        rpt.DataSource = tbl;
        //        rpt.DataBind();
        //        pndata.Visible = true;
        //    }
        //    else
        //    {
        //        pndata.Visible = false;
        //        lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
        //    }
           
        //}
    }
}