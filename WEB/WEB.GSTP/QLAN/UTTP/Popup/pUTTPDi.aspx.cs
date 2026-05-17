using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.UTTP.Popup
{
    public partial class pUTTPDi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[ENUM_SESSION.SESSION_DONVIID] == null)
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                var donvi = dt.DM_TOAAN.FirstOrDefault(s => s.ID == donviId);
                if (donvi.LOAITOA == "CAPHUYEN")
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                //kiểm tra cập nhật hay sửa
                string strIsEdit = Request.QueryString["IsEdit"];
                string strData= Request.QueryString["Data"];
                int IsEdit = int.Parse(strIsEdit);
                if (IsEdit==0)
                {
                    string stridDoiTuong = strData.Substring(0, strData.Length - 2);
                    decimal idDoiTuong = Convert.ToDecimal(stridDoiTuong);
                    string loaiAn = strData.Substring(strData.Length - 2);
                    hddLoaiAn.Value = loaiAn;
                    //cập nhật
                    LoadUpdate(idDoiTuong, loaiAn);
                }
                else
                {
                    //sửa
                    decimal Id = Convert.ToDecimal(strData);
                    LoadEdit(Id);
                }
            }
        }

        //private void LoadDataDonVi()
        //{
        //    string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
        //    if (strDonViID != "")
        //    {
        //        decimal DonViID = Convert.ToDecimal(strDonViID);
        //        DM_TOAAN_BL oBL = new DM_TOAAN_BL();
        //        ddllDonViUT.DataSource = oBL.DM_TOAAN_GETBY(DonViID);
        //        ddllDonViUT.DataTextField = "arrTEN";
        //        ddllDonViUT.DataValueField = "ID";
        //        ddllDonViUT.DataBind();
        //        ddllDonViUT.Items.Insert(0, new ListItem("---Tất cả---", "0"));
        //    }


        //}

        //private void LoadDataQuocGiaUT()
        //{
        //    var dataQuocGiaUT = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
        //    ddllQuocGiaUT.DataSource = dataQuocGiaUT;
        //    ddllQuocGiaUT.DataTextField = "TEN";
        //    ddllQuocGiaUT.DataValueField = "ID";
        //    ddllQuocGiaUT.DataBind();
        //    ddllQuocGiaUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));
        //}

        private bool valid()
        {
            if (string.IsNullOrEmpty(txtDonviUT.Text))
            {
                lbthongBaoUpdate.Text = "Vui lòng nhập đơn vị UT";
                return false;
            }

            if (string.IsNullOrEmpty(txttCoQuanUT.Text))
            {
                lbthongBaoUpdate.Text = "Vui lòng nhập cơ quan UT";
                return false;
            }
            if (string.IsNullOrEmpty(txtQuocGiaUT.Text))
            {
                lbthongBaoUpdate.Text = "Vui lòng nhập quốc gia UT";
                return false;
            }
            //txttNgayChuyenKQUTVeToaCapDuoi
            if (string.IsNullOrEmpty(txttNgayNhanUTTPTuToaCapDuoi.Text))
            {
                lbthongBaoUpdate.Text = "Vui lòng nhập ngày nhận";
                return false;
            }
            if (!checkNgayNhan())
            {
                return false;
            }
            if (!CheckNgayChuyenUTTP())
            {
                return false;
            }
            if (!CheckNgayNhanDuocketQua())
            {
                return false;
            }
            //CheckNgayChuyenKetQuaVeToaCapDuoi
            if (!CheckNgayChuyenKetQuaVeToaCapDuoi())
            {
                return false;
            }
            return true;
        }

        #region Thieu
        protected void txttNgayNhanUTTPTuToaCapDuoi_SelectedIndexChanged(object sender, EventArgs e)
        {
            checkNgayNhan();
        }
        protected void txttNgayChuyenUTTP_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckNgayChuyenUTTP();
        }
        //txttNgayNhanDuocketQua_SelectedIndexChanged
        protected void txttNgayNhanDuocketQua_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckNgayNhanDuocketQua();
        }
        //txttNgayChuyenKQUTVeToaCapDuoi_SelectedIndexChanged
        protected void txttNgayChuyenKQUTVeToaCapDuoi_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckNgayChuyenKetQuaVeToaCapDuoi();
        }
        #endregion
        public bool checkNgayNhan()
        {
            lbthongBaoUpdate.Text = "";
            if (!string.IsNullOrEmpty(txttNgayNhanUTTPTuToaCapDuoi.Text))
            {
                DateTime dateNow = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
                DateTime dtNgayNhanUTTPTuToaCapDuoi;
                bool isparse = DateTime.TryParse(txttNgayNhanUTTPTuToaCapDuoi.Text, cul, DateTimeStyles.None, out dtNgayNhanUTTPTuToaCapDuoi);
                if (isparse)
                {
                    if (dtNgayNhanUTTPTuToaCapDuoi <dateNow)
                    {
                        lbthongBaoUpdate.Text = "Ngày nhận UTTP không được nhỏ hơn ngày hiện tại";
                        txttNgayNhanUTTPTuToaCapDuoi.Focus();
                        return false;
                    }
                }
                else
                {
                    lbthongBaoUpdate.Text = "Ngày nhận UTTP không đúng định dạng dd/MM/yyyy";
                    return false;
                }
            }
            return true;
        }    
        public bool CheckNgayChuyenUTTP()
        {
            lbthongBaoUpdate.Text = "";
            if (!string.IsNullOrEmpty(txttNgayChuyenUTTP.Text))
            {
                if (string.IsNullOrEmpty(txttNgayNhanUTTPTuToaCapDuoi.Text))
                {
                    lbthongBaoUpdate.Text = "Vui lòng nhập ngày nhận UTTP cấp dưới";
                    return false;
                }
                DateTime dttxttNgayChuyenUTTP;
                bool isparse = DateTime.TryParse(txttNgayChuyenUTTP.Text, cul, DateTimeStyles.None, out dttxttNgayChuyenUTTP);
                if (isparse)
                {
                    DateTime dtNgayNhanUTTPTuToaCapDuoi;
                    isparse = DateTime.TryParse(txttNgayNhanUTTPTuToaCapDuoi.Text, cul, DateTimeStyles.None, out dtNgayNhanUTTPTuToaCapDuoi);
                    if (isparse)
                    {
                        if (dttxttNgayChuyenUTTP < dtNgayNhanUTTPTuToaCapDuoi)
                        {
                            lbthongBaoUpdate.Text = "Ngày chuyển UTTP phải lớn hơn hoặc bằng ngày nhận UTTP của tòa cấp dưới";
                            txttNgayChuyenUTTP.Focus();
                            return false;
                        }
                    }
                    else
                    {
                        lbthongBaoUpdate.Text = "Ngày nhận UTTP không đúng định dạng dd/MM/yyyy";
                        return false;
                    }

                }
                else
                {
                    lbthongBaoUpdate.Text = "Ngày chuyển UTTP không đúng định dạng dd/MM/yyyy";
                    return false;
                }
            }

            return true;
        }
        //txttNgayNhanDuocketQua_SelectedIndexChanged
        public bool CheckNgayNhanDuocketQua()
        {
            lbthongBaoUpdate.Text = "";
            if (!string.IsNullOrEmpty(txttNgayNhanDuocketQua.Text))
            {
                if (string.IsNullOrEmpty(txttNgayChuyenUTTP.Text))
                {
                    lbthongBaoUpdate.Text = "Vui lòng nhập ngày chuyển UTTP";
                    return false;
                }
                DateTime dttxttNgayNhanDuocketQua;
                bool isparse = DateTime.TryParse(txttNgayNhanDuocketQua.Text, cul, DateTimeStyles.None, out dttxttNgayNhanDuocketQua);
                if (isparse)
                {
                    DateTime dttxttNgayChuyenUTTP;
                    isparse = DateTime.TryParse(txttNgayChuyenUTTP.Text, cul, DateTimeStyles.None, out dttxttNgayChuyenUTTP);
                    if (isparse)
                    {
                        if (dttxttNgayNhanDuocketQua < dttxttNgayChuyenUTTP)
                        {
                            lbthongBaoUpdate.Text = "Ngày nhận được kết quả phải lớn hơn hoặc bằng ngày chuyển UTTP";
                            txttNgayNhanDuocketQua.Focus();
                            return false;
                        }
                    }
                    else
                    {
                        lbthongBaoUpdate.Text = "Ngày chuyển UTTP không đúng định dạng dd/MM/yyyy";
                        return false;
                    }

                }
                else
                {
                    lbthongBaoUpdate.Text = "Ngày nhận được kết quả không đúng định dạng dd/MM/yyyy";
                    return false;
                }
            }

            return true;
        }
        //CheckNgayChuyenKetQuaVeToaCapDuoi
        public bool CheckNgayChuyenKetQuaVeToaCapDuoi()
        {
            lbthongBaoUpdate.Text = "";
            if (!string.IsNullOrEmpty(txttNgayChuyenKQUTVeToaCapDuoi.Text))
            {
                if (string.IsNullOrEmpty(txttNgayNhanDuocketQua.Text))
                {
                    lbthongBaoUpdate.Text = "Vui lòng nhập ngày nhận được kết quả";
                    return false;
                }
                DateTime dttxttNgayChuyenKQUTVeToaCapDuoi;
                bool isparse = DateTime.TryParse(txttNgayChuyenKQUTVeToaCapDuoi.Text, cul, DateTimeStyles.None, out dttxttNgayChuyenKQUTVeToaCapDuoi);
                if (isparse)
                {
                    DateTime dttxttNgayNhanDuocketQua;
                    isparse = DateTime.TryParse(txttNgayNhanDuocketQua.Text, cul, DateTimeStyles.None, out dttxttNgayNhanDuocketQua);
                    if (isparse)
                    {
                        if (dttxttNgayChuyenKQUTVeToaCapDuoi < dttxttNgayNhanDuocketQua)
                        {
                            lbthongBaoUpdate.Text = "Ngày chuyển kết quả UT về tòa cấp dưới phải lớn hơn hoặc bằng ngày nhận được kết quả";
                            txttNgayChuyenKQUTVeToaCapDuoi.Focus();
                            return false;
                        }
                    }
                    else
                    {
                        lbthongBaoUpdate.Text = "Ngày nhận được kết quả không đúng định dạng dd/MM/yyyy";
                        return false;
                    }

                }
                else
                {
                    lbthongBaoUpdate.Text = "Ngày chuyển kết quả về tòa cấp dưới không đúng định dạng dd/MM/yyyy";
                    return false;
                }
            }

            return true;
        }
        private void ResetControls()
        {
            txttNgayNhanUTTPTuToaCapDuoi.Text = "";
            //ddllKetQuaUT.SelectedIndex = 0;
            txtQuocGiaUT.Text = "";
            txttNoiDung.Text = "";
            txttNgayChuyenUTTP.Text = "";
            txttNgayNhanDuocketQua.Text = "";
            txttNgayChuyenKQUTVeToaCapDuoi.Text = "";
            txttGhiChu.Text = "";
            dhhIdDoiTuongTongDat.Value = "";

        }


        private void LoadUpdate(decimal Id, string LoaiAn)
        {
            if (ENUM_LOAIVUVIEC.AN_DANSU == LoaiAn)
            {
                var data = (from c in dt.ADS_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.ADS_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value= data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value= data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
            //hành chính
            if (ENUM_LOAIVUVIEC.AN_HANHCHINH == LoaiAn)
            {
                var data = (from c in dt.AHC_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.AHC_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }

            //hôn nhân gia đình
            if (ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH == LoaiAn)
            {
                var data = (from c in dt.AHN_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.AHN_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }

            //hôn nhân gia đình
            if (ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI == LoaiAn)
            {
                var data = (from c in dt.AKT_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.AKT_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
            if (ENUM_LOAIVUVIEC.AN_LAODONG == LoaiAn)
            {
                var data = (from c in dt.ALD_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.ALD_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
            if (ENUM_LOAIVUVIEC.AN_PHASAN == LoaiAn)
            {
                var data = (from c in dt.APS_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.APS_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
            if (ENUM_LOAIVUVIEC.AN_HINHSU == LoaiAn)
            {
                var data = (from c in dt.AHS_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.AHS_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
            if (ENUM_LOAIVUVIEC.BPXLHC == LoaiAn)
            {
                var data = (from c in dt.XLHC_TONGDAT
                            join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                            from p in ps.DefaultIfEmpty()
                            join d in dt.XLHC_TONGDAT_DOITUONG on c.ID equals d.TONGDATID.Value into ds
                            from d in ds.DefaultIfEmpty()
                            where d.ID == Id
                            select new { TEN = p.TENBM, ID = p.ID, DONVIUT = c.TOAANID, COQUANUT = d.COQUAN, QUOCGIAUT = d.QUOCGIA, KETQUAUT = d.KETQUAUTTP, NOIDUNGUT = d.NOIDUNG }).FirstOrDefault();
                if (data == null)
                {
                    lbthongBaoUpdate.Text = "Văn bản tống đạt không tồn tại";
                    return;
                }
                txtDonviUT.Text = data.DONVIUT.HasValue ? dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN : "";
                txtDonviUT.Enabled = false;
                hddDonviUT.Value = data.DONVIUT.HasValue ? data.DONVIUT.Value.ToString() : "0";
                txttCoQuanUT.Text = data.COQUANUT;
                txttCoQuanUT.Enabled = false;
                txtQuocGiaUT.Text = data.QUOCGIAUT.HasValue ? dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN : "";
                hddQuocGiaUT.Value = data.QUOCGIAUT.HasValue ? data.QUOCGIAUT.Value.ToString() : "0";
                txtQuocGiaUT.Enabled = false;
                txttVanBanUT.Text = data.TEN;
                txttVanBanUT.Enabled = false;
                dhhBieuMauID.Value = data.ID + "";
                dhhIdDoiTuongTongDat.Value = Id + "";
                txttNoiDung.Text = data.NOIDUNGUT;

            }
        }

        //lbLuu_Click
        protected void lbLuu_Click(object sender, EventArgs e)
        {
            if (valid())
            {
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    UYTHACTUPHAPDI obj = new UYTHACTUPHAPDI();
                    obj.DONVIUT = Convert.ToDecimal(hddDonviUT.Value);
                    obj.NGAYNHANUTTPCAPDUOI = txttNgayNhanUTTPTuToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTPTuToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.COQUANUT = txttCoQuanUT.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(hddQuocGiaUT.Value);
                    obj.BIEUMAUID = Convert.ToDecimal(dhhBieuMauID.Value);
                    obj.NOIDUNG = txttNoiDung.Text;
                    obj.NGAYCHUYENUTTP = txttNgayChuyenUTTP.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYNHANDUOCKETQUA = txttNgayNhanDuocketQua.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanDuocketQua.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaUT.SelectedValue);
                    obj.NGAYCHUYENKQUTVETOACAPDUOI = txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.IDDOITUONGTONGDAT = Convert.ToDecimal(dhhIdDoiTuongTongDat.Value);
                    obj.LOAIVUAN = hddLoaiAn.Value;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYTAO = DateTime.Now;
                    dt.UYTHACTUPHAPDIs.Add(obj);
                    dt.SaveChanges();
                    lbthongBaoUpdate.Text = "Lưu thành công";
                }
                else
                { //sua
                  //lấy ra thông tin theo cái id vần sửa
                    decimal _id = Convert.ToDecimal(hddid.Value);
                    var obj = dt.UYTHACTUPHAPDIs.Where(x => x.ID == _id).FirstOrDefault();
                    if (obj == null) return;

                    obj.DONVIUT = Convert.ToDecimal(hddDonviUT.Value);
                    obj.NGAYNHANUTTPCAPDUOI = txttNgayNhanUTTPTuToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTPTuToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.COQUANUT = txttCoQuanUT.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(hddQuocGiaUT.Value);
                    obj.BIEUMAUID = Convert.ToDecimal(dhhBieuMauID.Value);
                    obj.NOIDUNG = txttNoiDung.Text;
                    obj.NGAYCHUYENUTTP = txttNgayChuyenUTTP.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYNHANDUOCKETQUA = txttNgayNhanDuocketQua.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanDuocketQua.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaUT.SelectedValue);
                    obj.NGAYCHUYENKQUTVETOACAPDUOI = txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.IDDOITUONGTONGDAT = Convert.ToDecimal(dhhIdDoiTuongTongDat.Value);
                    obj.LOAIVUAN = hddLoaiAn.Value;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    hddid.Value = _id + "";
                    lbthongBaoUpdate.Text = "Cập nhật thành công!";



                }
                
            }
        }
        //lbLuuAndQuayLai_Click
        protected void lbLuuAndQuayLai_Click(object sender, EventArgs e)
        {
            if (valid())
            {
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    UYTHACTUPHAPDI obj = new UYTHACTUPHAPDI();
                    obj.DONVIUT = Convert.ToDecimal(hddDonviUT.Value);
                    obj.NGAYNHANUTTPCAPDUOI = txttNgayNhanUTTPTuToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTPTuToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.COQUANUT = txttCoQuanUT.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(hddQuocGiaUT.Value);
                    obj.BIEUMAUID = Convert.ToDecimal(dhhBieuMauID.Value);
                    obj.NOIDUNG = txttNoiDung.Text;
                    obj.NGAYCHUYENUTTP = txttNgayChuyenUTTP.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYNHANDUOCKETQUA = txttNgayNhanDuocketQua.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanDuocketQua.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaUT.SelectedValue);
                    obj.NGAYCHUYENKQUTVETOACAPDUOI = txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.IDDOITUONGTONGDAT = Convert.ToDecimal(dhhIdDoiTuongTongDat.Value);
                    obj.LOAIVUAN = hddLoaiAn.Value;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYTAO = DateTime.Now;
                    dt.UYTHACTUPHAPDIs.Add(obj);
                    int _id=dt.SaveChanges();
                    hddid.Value = obj.ID + "";
                    lbthongBaoUpdate.Text = "Lưu thành công";
                }
                else
                { //sua
                  //lấy ra thông tin theo cái id vần sửa
                    decimal _id = Convert.ToDecimal(hddid.Value);
                    var obj = dt.UYTHACTUPHAPDIs.Where(x => x.ID == _id).FirstOrDefault();
                    if (obj == null) return;

                    obj.DONVIUT = Convert.ToDecimal(hddDonviUT.Value);
                    obj.NGAYNHANUTTPCAPDUOI = txttNgayNhanUTTPTuToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanUTTPTuToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.COQUANUT = txttCoQuanUT.Text;
                    obj.QUOCGIAUT = Convert.ToDecimal(hddQuocGiaUT.Value);
                    obj.BIEUMAUID = Convert.ToDecimal(dhhBieuMauID.Value);
                    obj.NOIDUNG = txttNoiDung.Text;
                    obj.NGAYCHUYENUTTP = txttNgayChuyenUTTP.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenUTTP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYNHANDUOCKETQUA = txttNgayNhanDuocketQua.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayNhanDuocketQua.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //obj.KETQUAUT = Convert.ToDecimal(ddllKetQuaUT.SelectedValue);
                    obj.NGAYCHUYENKQUTVETOACAPDUOI = txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim() == "" ? (DateTime?)null : DateTime.Parse(txttNgayChuyenKQUTVeToaCapDuoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.GHICHU = txttGhiChu.Text;
                    obj.IDDOITUONGTONGDAT = Convert.ToDecimal(dhhIdDoiTuongTongDat.Value);
                    obj.LOAIVUAN = hddLoaiAn.Value;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    obj.NGAYSUA = DateTime.Now;
                    dt.SaveChanges();
                    hddid.Value = _id + "";
                    lbthongBaoUpdate.Text = "Lưu thành công!";



                }
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            }
        }
        protected void btnQuayLai_Click(object sender, EventArgs e)
        {
            hddid.Value = "";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        private void LoadEdit(decimal ID)
        {
            
            var data = dt.UYTHACTUPHAPDIs.FirstOrDefault(s => s.ID == ID);
            hddid.Value = ID + "";
            hddDonviUT.Value = data.DONVIUT.Value.ToString();
            txtDonviUT.Text = dt.DM_TOAAN.FirstOrDefault(s => s.ID == data.DONVIUT.Value).MA_TEN;
            txttNgayNhanUTTPTuToaCapDuoi.Text = data.NGAYNHANUTTPCAPDUOI.HasValue ? data.NGAYNHANUTTPCAPDUOI.Value.ToString("dd/MM/yyyy") : "";
            txttCoQuanUT.Text = data.COQUANUT;
            txttNoiDung.Text = data.NOIDUNG;
            hddLoaiAn.Value = data.LOAIVUAN;
            txttNgayChuyenUTTP.Text = data.NGAYCHUYENUTTP.HasValue ? data.NGAYCHUYENUTTP.Value.ToString("dd/MM/yyyy") : "";
            txttNgayNhanDuocketQua.Text = data.NGAYNHANDUOCKETQUA.HasValue ? data.NGAYNHANDUOCKETQUA.Value.ToString("dd/MM/yyyy") : "";
            //ddllKetQuaUT.SelectedValue = data.KETQUAUT.Value.ToString();
            txttNgayChuyenKQUTVeToaCapDuoi.Text = data.NGAYCHUYENKQUTVETOACAPDUOI.HasValue ? data.NGAYCHUYENKQUTVETOACAPDUOI.Value.ToString("dd/MM/yyyy") : "";
            txttGhiChu.Text = data.GHICHU;
            dhhIdDoiTuongTongDat.Value = data.IDDOITUONGTONGDAT + "";
            txtQuocGiaUT.Text = dt.DM_DATAITEM.FirstOrDefault(s => s.ID == data.QUOCGIAUT.Value).TEN;
            hddQuocGiaUT.Value = data.QUOCGIAUT.Value.ToString();
            txtQuocGiaUT.Enabled = false;
            txttCoQuanUT.Enabled = false;
            txttNoiDung.Enabled = false;
            txtDonviUT.Enabled = false;
            var datat = (from c in dt.UYTHACTUPHAPDIs
                         join p in dt.DM_BIEUMAU on c.BIEUMAUID equals p.ID into ps
                         from p in ps.DefaultIfEmpty()

                         where c.ID == ID
                         select new { TEN = p.TENBM, ID = p.ID }).FirstOrDefault();
            txttVanBanUT.Text = datat.TEN;
            dhhBieuMauID.Value = datat.ID + "";
            txttVanBanUT.Enabled = false;
            
        }
    }
}