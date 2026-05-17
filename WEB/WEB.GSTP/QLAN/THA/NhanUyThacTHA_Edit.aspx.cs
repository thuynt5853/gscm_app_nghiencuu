using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using BL.GSTP.THA;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.THA;

namespace WEB.GSTP.QLAN.THA
{
    public partial class NhanUyThacTHA_Edit : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        THA_UYTHAC_DETAIL obj = new THA_UYTHAC_DETAIL();
        private const decimal ROOT = 0;
        Decimal CurrUserID = 0, VuAnID = 0, BiAnID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                if (CurrUserID > 0)
                {
                    if (!IsPostBack)
                    {
                       // LoadInfoUyThac();
                        LoadDropNguoiKy();
                        LoadInfoUyThacNew();
                        txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (NullReferenceException ex) { lbthongbao.Text = ex.Message; }
        }
        //----------------------------------
        //void LoadInfoUyThac()
        //{
        //    if (Request["uID"] != null)
        //    {
        //        Decimal DetailUyThacID = Convert.ToDecimal(Request["uID"] + "");
        //        THA_UYTHAC_DETAIL_BL obj = new THA_UYTHAC_DETAIL_BL();
        //        DataTable tbl = obj.GetInfo(DetailUyThacID);
        //        if (tbl != null && tbl.Rows.Count>0)
        //        {
        //            DataRow row = tbl.Rows[0];
                   
        //            lttMaVuAn.Text = row["BA_MaVuAn"] + "";
        //            lttTenVuAn.Text = row["BA_TenVuAn"] + "";

        //            lttMaBiAn.Text = row["MaBiCan"] + "";
        //            lttTenBiAn.Text = row["TenBiCan"] + "";

        //            lttQDUyThac.Text = row["SoQD"].ToString() +" - "+ row["TenQD"].ToString();
        //            lttToaUyThac.Text = row["TenToaAnUyThac"] + "";
        //            lttNguoiNhapUyThac.Text = row["TenNguoiNhap"] + "";
        //            //
        //            lttNgayUyThac.Text =String.IsNullOrEmpty( row["NgayUyThac"] + "")? "": (Convert.ToDateTime(row["NgayUyThac"].ToString())).ToString("dd/MM/yyyy", cul);
        //        }
        //    }
        //}
        void LoadInfoUyThacNew()
        {
            if (Request["uID"] != null)
            {
                Decimal DetailUyThacID = Convert.ToDecimal(Request["uID"] + "");
                THA_UYTHAC_DETAIL_BL obj = new THA_UYTHAC_DETAIL_BL();
                DataTable tbl = obj.GetInfo(DetailUyThacID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dgList.DataSource = tbl;
                    dgList.DataBind();
                }
            }
        }
        //---------------------
        void LoadDropNguoiKy()
        {
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = obj.GetAllChanhAn_PhoCA(donvi);
            dropNguoiKy.DataSource = tbl;
            dropNguoiKy.DataTextField = "HOTEN";
            dropNguoiKy.DataValueField = "ID";
            dropNguoiKy.DataBind();
            dropNguoiKy.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Chọn---", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }

        //----------------------------------
        protected void rdTruongHopUT_SelectedIndexChanged(object sender, EventArgs e)
        {
            //pnLyDo.Visible = pnKhac.Visible = false;
            //if (rdTruongHopUT.SelectedValue == "0")
            //{
            //    pnLyDo.Visible = true;
            //    dropLyDo.SelectedValue = "0";
            //    hddLoaiUyThac.Value = "0";
            //}
            //else
            //{ pnLyDo.Visible = false; hddLoaiUyThac.Value = "1"; }
        }
        //-----------------------------------------
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResetControls();          
        }
        public void ResetControls()
        {
            //txtToaAnUyThac.Text = txtUy_thac.Text = "";
            //txtQD_SoQD.Text = txtQD_NgayQD.Text = "";

            //rdTruongHopUT.SelectedValue = "0";
            //hddLoaiUyThac.Value = "0";
            //pnLyDo.Visible = true;
            //dropLyDo.SelectedValue = "0";

            //txtNgayNhan.Text = txtNgayUyThac.Text = "";
            //txtGhichu.Text = "";

            //dropLyDo.SelectedValue = dropNguoiNhap.SelectedValue = "0";

            //HddID.Value = "0";
            //lbthongbao.Text = "";
        }

        //--------------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                //BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                //Decimal QuyetDinhTHA_ID = Convert.ToDecimal(dropQuyetDinhUyThacTHA.SelectedValue);
                //THA_UYTHAC_DETAIL obj = dt.THA_UYTHAC_DETAIL.Where(x => x.BIANID == BiAnID && x.QD_UYTHACTHA_ID == QuyetDinhTHA_ID).FirstOrDefault();
                //if (obj != null)
                //{
                //    LayDuLieuUpdate(obj);
                //    obj.NGAYSUA = DateTime.Now;
                //    obj.NGUOISUA = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //}
                //else
                //{
                //    obj = new THA_UYTHAC_DETAIL();
                //    LayDuLieuUpdate(obj);
                //    obj.NGAYTAO = DateTime.Now;
                //    obj.NGUOITAO = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                //    dt.THA_UYTHAC_DETAIL.Add(obj);
                //}
                //dt.SaveChanges();
                //ResetControls();
                //lbthongbao.Text = "Lưu thành công!";
                if (Request["uID"] != null)
                {
                    Decimal DetailUyThacID = Convert.ToDecimal(Request["uID"] + "");
                    //Nhan Uy Thac THA thi them THA va BIAN ngoai hệ thong
                    ThemVA_UyThac(DetailUyThacID);
                    //----------Chon bi an can cap nhat thong tin----------
                    //Lưu vào người dùng
                    decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    oNSD.IDTHA = Convert.ToDecimal(BiAnID);//luu thong tin id bi an de ghim
                    dt.SaveChanges();

                    Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                    Session["trangthai"] = "DaNhan";
                    Response.Redirect("/QLAN/THA/NhanUyThacTHA.aspx",false);
                }
            }
            catch (Exception exc)
            {
                lbthongbao.Text = exc.Message;
            }
        }
        public void LayDuLieuUpdate(THA_UYTHAC_DETAIL obj)
        {
            //obj.BIANID = BiAnID;
            //obj.QD_UYTHACTHA_ID = Convert.ToDecimal(dropQuyetDinhUyThacTHA.SelectedValue);

            //obj.LOAIUYTHAC = Convert.ToDecimal(rdTruongHopUT.SelectedValue);
            //if (obj.LOAIUYTHAC == 0)
            //    obj.LYDOID = Convert.ToDecimal(dropLyDo.SelectedValue);
            //else
            //    obj.LYDOID = 0;

            ////------------------  
            //obj.NGAYUYTHAC = (String.IsNullOrEmpty(txtNgayUyThac.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayUyThac.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //obj.NGAYNHANUYTHAC = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            ////-------------------
            //obj.NGUOINHAP = String.IsNullOrEmpty(dropNguoiNhap.SelectedValue) ? 0 : Convert.ToDecimal(dropNguoiNhap.SelectedValue);
        }
        void ThemVA_UyThac(decimal DetailUyThacID)
        {
            THA_UYTHAC_DETAIL  oTT_UYTHAC = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == DetailUyThacID).FirstOrDefault();
            if (oTT_UYTHAC != null)
            {//Nếu chua nhận mới thêm THA
                decimal vTRANGTHAI = (String.IsNullOrEmpty(oTT_UYTHAC.TRANGTHAI + "")) ? 0 : Convert.ToDecimal(oTT_UYTHAC.TRANGTHAI + "");
                if (vTRANGTHAI == 0)
                {
                    //Thong tin Uy thac THA
                    THA_UYTHAC_QUYETDINH oUyThac_QD = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == oTT_UYTHAC.QD_UYTHACTHA_ID).FirstOrDefault();
                    //Thong tin Bi An THA cua Don vi uy thac di
                    THA_BIAN oTHABiAn = dt.THA_BIAN.Where(x => x.ID == oUyThac_QD.BIANID).FirstOrDefault();
                    //Thông tin THA cua Don vi Uy Thac di
                    THA_VUAN oTHAVuAn = dt.THA_VUAN.Where(x => x.ID == oUyThac_QD.VUANID).FirstOrDefault();
                    //Thêm mới Thi hành án khi nhận THA tu Don vi Uy Thac THA
                    THA_VUAN oTHAVuAn_UyThac = new THA_VUAN();
                    THA_VUAN_BL dsBL = new THA_VUAN_BL();
                    oTHAVuAn_UyThac.TT = dsBL.GETNEWTT((decimal)oUyThac_QD.TOAANNHANUYTHACID);
                    oTHAVuAn_UyThac.BA_MAVUAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBL.GETNEWTT((decimal)oUyThac_QD.TOAANNHANUYTHACID).ToString();
                    oTHAVuAn_UyThac.TOAANID = oUyThac_QD.TOAANNHANUYTHACID; //Đơn vị nhận Ủy thác thi hành án
                    oTHAVuAn_UyThac.ISHETHONG = 0; //Ngoai Hẹ thống do Nhận Uy Thac THA tu don vi khac den
                    oTHAVuAn_UyThac.BA_TENVUAN = oTHAVuAn.BA_TENVUAN + "";
                    oTHAVuAn_UyThac.BA_NGAYVUAN = oTHAVuAn.BA_NGAYVUAN;
                    oTHAVuAn_UyThac.BA_THANG = oTHAVuAn.BA_THANG;
                    oTHAVuAn_UyThac.BA_NAM = oTHAVuAn.BA_NAM;
                    oTHAVuAn_UyThac.BA_ST_SO = oTHAVuAn.BA_ST_SO;
                    oTHAVuAn_UyThac.BA_ST_NGAYBANAN = oTHAVuAn.BA_ST_NGAYBANAN;
                    oTHAVuAn_UyThac.BA_ST_NGAYHIEULUC = oTHAVuAn.BA_ST_NGAYHIEULUC;
                    oTHAVuAn_UyThac.BA_ST_TOAANID = oTHAVuAn.BA_ST_TOAANID;
                    oTHAVuAn_UyThac.BA_PT_SO = oTHAVuAn.BA_PT_SO;
                    oTHAVuAn_UyThac.BA_PT_NGAYBANAN = oTHAVuAn.BA_PT_NGAYBANAN;
                    oTHAVuAn_UyThac.BA_PT_NGAYHIEULUC = oTHAVuAn.BA_PT_NGAYHIEULUC;
                    oTHAVuAn_UyThac.BA_PT_TOAANID = oTHAVuAn.BA_PT_TOAANID;
                    oTHAVuAn_UyThac.BA_TINHCHAT = oTHAVuAn.BA_TINHCHAT;
                    oTHAVuAn_UyThac.NGUOITAO = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    oTHAVuAn_UyThac.NGAYTAO = DateTime.Now;
                    oTHAVuAn_UyThac.NGUOISUA = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    oTHAVuAn_UyThac.NGAYSUA = DateTime.Now;
                    oTHAVuAn_UyThac.BA_PT_NGAYHIEULUC = oTHAVuAn.BA_PT_NGAYHIEULUC;
                    oTHAVuAn_UyThac.IDVUANHETHONG = 0;
                    oTHAVuAn_UyThac.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.THA_VUAN.Add(oTHAVuAn_UyThac);
                    dt.SaveChanges();

                    //Thêm mới Bị án khi nhận THA tu don vi Uy Thac 
                    THA_BIAN oTHABiAn_UyThac = new THA_BIAN();
                    THA_BIAN_BL dsBLBiAn = new THA_BIAN_BL();
                    oTHABiAn_UyThac.TT = Convert.ToDecimal(dsBLBiAn.GETNEWTT((decimal)oUyThac_QD.TOAANNHANUYTHACID).ToString());
                    //oTHABiAn_UyThac.MABICAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBLBiAn.GETNEWTT((decimal)oUyThac_QD.TOAANNHANUYTHACID).ToString();
                    oTHABiAn_UyThac.HOTEN = oTHABiAn.HOTEN;
                    oTHABiAn_UyThac.TENKHAC = oTHABiAn.TENKHAC;
                    oTHABiAn_UyThac.NGAYSINH = oTHABiAn.NGAYSINH;
                    oTHABiAn_UyThac.THANGSINH = oTHABiAn.THANGSINH;
                    oTHABiAn_UyThac.NAMSINH = oTHABiAn.NAMSINH;
                    oTHABiAn_UyThac.NGAYTHAMGIA = oTHABiAn.NGAYTHAMGIA;
                    oTHABiAn_UyThac.SOCMND = oTHABiAn.SOCMND;
                    oTHABiAn_UyThac.TAMTRU = oTHABiAn.TAMTRU;
                    oTHABiAn_UyThac.TAMTRUCHITIET = oTHABiAn.TAMTRUCHITIET;
                    oTHABiAn_UyThac.HKTT = oTHABiAn.HKTT;
                    oTHABiAn_UyThac.KHTTCHITIET = oTHABiAn.KHTTCHITIET;
                    oTHABiAn_UyThac.TRINHDOVANHOAID = oTHABiAn.TRINHDOVANHOAID;
                    oTHABiAn_UyThac.NGHENGHIEPID = oTHABiAn.NGHENGHIEPID;
                    oTHABiAn_UyThac.DANTOCID = oTHABiAn.DANTOCID;
                    oTHABiAn_UyThac.QUOCTICHID = oTHABiAn.QUOCTICHID;
                    oTHABiAn_UyThac.GIOITINH = oTHABiAn.GIOITINH;
                    oTHABiAn_UyThac.TONGIAOID = oTHABiAn.TONGIAOID;
                    oTHABiAn_UyThac.HOTENBO = oTHABiAn.HOTENBO;
                    oTHABiAn_UyThac.NAMSINHBO = oTHABiAn.NAMSINHBO;
                    oTHABiAn_UyThac.HOTENME = oTHABiAn.HOTENME;
                    oTHABiAn_UyThac.NAMSINHME = oTHABiAn.NAMSINHME;
                    oTHABiAn_UyThac.NGHIENHUT = oTHABiAn.NGHIENHUT;
                    oTHABiAn_UyThac.TAIPHAM = oTHABiAn.TAIPHAM;
                    oTHABiAn_UyThac.TIENAN = oTHABiAn.TIENAN;
                    oTHABiAn_UyThac.TIENSU = oTHABiAn.TIENSU;
                    oTHABiAn_UyThac.TREMOCOI = oTHABiAn.TREMOCOI;
                    oTHABiAn_UyThac.BOMELYHON = oTHABiAn.BOMELYHON;
                    oTHABiAn_UyThac.TREBOHOC = oTHABiAn.TREBOHOC;
                    oTHABiAn_UyThac.TRELANGTHANG = oTHABiAn.TRELANGTHANG;
                    oTHABiAn_UyThac.CONGUOIXUIGIUC = oTHABiAn.CONGUOIXUIGIUC;
                    oTHABiAn_UyThac.CHUCVUDANGID = oTHABiAn.CHUCVUDANGID;
                    oTHABiAn_UyThac.CHUCVUCHINHQUYENID = oTHABiAn.CHUCVUCHINHQUYENID;
                    oTHABiAn_UyThac.TINHTRANGGIAMGIUID = oTHABiAn.TINHTRANGGIAMGIUID;
                    oTHABiAn_UyThac.NGUOITAO = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    oTHABiAn_UyThac.NGAYTAO = DateTime.Now;
                    oTHABiAn_UyThac.NGUOISUA = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    oTHABiAn_UyThac.NGAYSUA = DateTime.Now;
                    oTHABiAn_UyThac.ISTREVITHANHNIEN = oTHABiAn.ISTREVITHANHNIEN;
                    oTHABiAn_UyThac.LOAIDOITUONG = oTHABiAn.LOAIDOITUONG;
                    oTHABiAn_UyThac.BICANDAUVU = oTHABiAn.BICANDAUVU;
                    oTHABiAn_UyThac.VUANID = oTHAVuAn_UyThac.ID; //THA_VUAN.ID mới
                    oTHABiAn_UyThac.TOIDANH = oTHABiAn.TOIDANH;
                    oTHABiAn_UyThac.HKTT_HUYEN = oTHABiAn.HKTT_HUYEN;
                    oTHABiAn_UyThac.TAMTRU_HUYEN = oTHABiAn.TAMTRU_HUYEN;
                    oTHABiAn_UyThac.IDBICANHETHONG = oTHABiAn.IDBICANHETHONG;
                    //oTHABiAn_UyThac.IDVUANHETHONG = oTHAVuAn.IDVUANHETHONG;
                    oTHABiAn_UyThac.IDVUANHETHONG = 0;
                    oTHABiAn_UyThac.TOIDANHID = oTHABiAn.TOIDANHID;
                    oTHABiAn_UyThac.UYTHAC_DETAIL_ID = oTT_UYTHAC.ID; //để phân biệt Bị án lấy từ đâu
                    oTHABiAn_UyThac.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.THA_BIAN.Add(oTHABiAn_UyThac);
                    dt.SaveChanges();

                    BiAnID = oTHABiAn_UyThac.ID;

                    // VNPT - Lưu Quang Huy - Thêm thông tin bản án vào THA - 23/09/2025 15h55
                    // Sơ thẩm
                    List<THA_SOTHAM_BANAN_BICAO> asbbs = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_BICAO>($"BICAOID = {oTHABiAn.ID} AND VUANID = {oTHAVuAn.ID}");
                    if (asbbs != null && asbbs.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_BICAO asbb in asbbs)
                        {
                            THA_SOTHAM_BANAN_BICAO tsbb = new THA_SOTHAM_BANAN_BICAO();
                            tsbb.BANANID = asbb.BANANID;
                            tsbb.VUANID = oTHAVuAn_UyThac.ID;
                            tsbb.BICAOID = oTHABiAn_UyThac.ID;
                            tsbb.ISTHAMGIAPHIENTOA = asbb.ISTHAMGIAPHIENTOA;
                            tsbb.ANPHI = asbb.ANPHI;
                            tsbb.ISDINHCHI = asbb.ISDINHCHI;
                            tsbb.NGAYNHANBANAN = asbb.NGAYNHANBANAN;
                            tsbb.TOA_GIAIQUYET_ID = asbb.TOA_GIAIQUYET_ID;
                            DataExtensions.Insert<THA_SOTHAM_BANAN_BICAO>(tsbb);
                        }
                    }
                    List<THA_SOTHAM_BANAN_DIEU_TONGHOP> asbdts = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_DIEU_TONGHOP>($"BICANID = {oTHABiAn.ID} AND VUANID = {oTHAVuAn.ID}");
                    if (asbdts != null && asbdts.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_DIEU_TONGHOP asbdt in asbdts)
                        {
                            THA_SOTHAM_BANAN_DIEU_TONGHOP tsbdt = new THA_SOTHAM_BANAN_DIEU_TONGHOP();
                            tsbdt.BANANID = asbdt.BANANID;
                            tsbdt.BICANID = oTHABiAn_UyThac.ID;
                            tsbdt.VUANID = oTHAVuAn_UyThac.ID;
                            tsbdt.HINHPHATID = asbdt.HINHPHATID;
                            tsbdt.LOAIHINHPHAT = asbdt.LOAIHINHPHAT;
                            tsbdt.TF_VALUE = asbdt.TF_VALUE;
                            tsbdt.SH_VALUE = asbdt.SH_VALUE;

                            tsbdt.TG_NAM = asbdt.TG_NAM;
                            tsbdt.TG_THANG = asbdt.TG_THANG;
                            tsbdt.TG_NGAY = asbdt.TG_NGAY;
                            tsbdt.K_VALUE1 = asbdt.K_VALUE1;

                            tsbdt.K_VALUE2 = asbdt.K_VALUE2;
                            tsbdt.ISANTREO = asbdt.ISANTREO;
                            tsbdt.TGTT_NAM = asbdt.TGTT_NAM;
                            tsbdt.TGTT_THANG = asbdt.TGTT_THANG;

                            tsbdt.TGTT_NGAY = asbdt.TGTT_NGAY;
                            tsbdt.TENTOIDANH = asbdt.TENTOIDANH;
                            tsbdt.ISMAIN = asbdt.ISMAIN;
                            DataExtensions.Insert<THA_SOTHAM_BANAN_DIEU_TONGHOP>(tsbdt);
                        }
                    }

                    List<THA_SOTHAM_BANAN_DIEU_CHITIET> asbdcs = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_DIEU_CHITIET>($"BICANID = {oTHABiAn.ID} AND VUANID = {oTHAVuAn.ID}");
                    if (asbdcs != null && asbdcs.Count > 0)
                    {
                        foreach (THA_SOTHAM_BANAN_DIEU_CHITIET asbdc in asbdcs)
                        {
                            THA_SOTHAM_BANAN_DIEU_CHITIET tsbdc = new THA_SOTHAM_BANAN_DIEU_CHITIET();
                            tsbdc.BANANID = asbdc.BANANID;
                            tsbdc.BICANID = oTHABiAn_UyThac.ID;
                            tsbdc.VUANID = oTHAVuAn_UyThac.ID;
                            tsbdc.DIEULUATID = asbdc.DIEULUATID;
                            tsbdc.HINHPHATID = asbdc.HINHPHATID;
                            tsbdc.LOAIHINHPHAT = asbdc.LOAIHINHPHAT;
                            tsbdc.TF_VALUE = asbdc.TF_VALUE;
                            tsbdc.SH_VALUE = asbdc.SH_VALUE;
                            tsbdc.TG_NAM = asbdc.TG_NAM;
                            tsbdc.TG_THANG = asbdc.TG_THANG;
                            tsbdc.TG_NGAY = asbdc.TG_NGAY;
                            tsbdc.K_VALUE1 = asbdc.K_VALUE1;
                            tsbdc.K_VALUE2 = asbdc.K_VALUE2;
                            tsbdc.ISANTREO = asbdc.ISANTREO;
                            tsbdc.TOIDANHID = asbdc.TOIDANHID;
                            tsbdc.ISCHANGE = asbdc.ISCHANGE;
                            tsbdc.TGTT_NAM = asbdc.TGTT_NAM;
                            tsbdc.TGTT_THANG = asbdc.TGTT_THANG;
                            tsbdc.TGTT_NGAY = asbdc.TGTT_NGAY;
                            tsbdc.TENTOIDANH = asbdc.TENTOIDANH;
                            tsbdc.ISMAIN = asbdc.ISMAIN;
                            DataExtensions.Insert<THA_SOTHAM_BANAN_DIEU_CHITIET>(tsbdc);
                        }
                    }

                    List<THA_TONGHOPHINHPHAT> ats = DataExtensions.GetAllWithClause<THA_TONGHOPHINHPHAT>($"VUANID = {oTHAVuAn.ID} AND BICAOID = {oTHABiAn.ID}");
                    if (ats != null && ats.Count > 0)
                    {
                        foreach (THA_TONGHOPHINHPHAT at in ats)
                        {
                            THA_TONGHOPHINHPHAT tt = new THA_TONGHOPHINHPHAT();
                            tt.TOAANID_ST = at.TOAANID_ST;
                            tt.TOAANID_PT = at.TOAANID_PT;
                            tt.VUANID = oTHAVuAn_UyThac.ID;
                            tt.BICAOID = oTHABiAn_UyThac.ID;
                            tt.TENTOIDANH_ST = at.TENTOIDANH_ST;
                            tt.TENTOIDANH_PT = at.TENTOIDANH_PT;
                            tt.HINHPHAT_ST = at.HINHPHAT_ST;
                            tt.HINHPHAT_PT = at.HINHPHAT_PT;
                            tt.TONGHOPHINHPHAT = at.TONGHOPHINHPHAT;
                            tt.HP_TANGGIAM = at.HP_TANGGIAM;
                            tt.NGAYSUA = at.NGAYSUA;
                            tt.NGUOISUA = at.NGUOISUA;
                            tt.NGAYTAO = at.NGAYTAO;
                            tt.NGUOITAO = at.NGUOITAO;
                            DataExtensions.Insert<THA_TONGHOPHINHPHAT>(tt);
                        }
                    }

                    // phúc thẩm
                    List<THA_PHUCTHAM_BANAN_BICAO> apbbs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_BICAO>($"VUANID = {oTHAVuAn.ID} AND BICAOID = {oTHABiAn.ID}");
                    if (apbbs != null && apbbs.Count > 0)
                    {
                        foreach (THA_PHUCTHAM_BANAN_BICAO apbb in apbbs)
                        {
                            THA_PHUCTHAM_BANAN_BICAO tpbb = new THA_PHUCTHAM_BANAN_BICAO();
                            tpbb.BANANID = apbb.BANANID;
                            tpbb.VUANID = oTHAVuAn_UyThac.ID;
                            tpbb.BICAOID = oTHABiAn_UyThac.ID;
                            tpbb.ISTHAMGIAPHIENTOA = apbb.ISTHAMGIAPHIENTOA;
                            tpbb.ANPHI = apbb.ANPHI;
                            tpbb.ISDINHCHI = apbb.ISDINHCHI;
                            tpbb.NGAYNHANBANAN = apbb.NGAYNHANBANAN;
                            tpbb.TOA_GIAIQUYET_ID = apbb.TOA_GIAIQUYET_ID;
                            DataExtensions.Insert<THA_PHUCTHAM_BANAN_BICAO>(tpbb);
                        }
                    }

                    List<THA_PHUCTHAM_BANAN_DIEU_CT> apbdcs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"VUANID = {oTHAVuAn.ID} AND BICANID = {oTHABiAn.ID}");
                    if (apbdcs != null && apbdcs.Count > 0)
                    {
                        foreach (THA_PHUCTHAM_BANAN_DIEU_CT apbdc in apbdcs)
                        {
                            THA_PHUCTHAM_BANAN_DIEU_CT tpbdc = new THA_PHUCTHAM_BANAN_DIEU_CT();
                            tpbdc.BANANID = apbdc.BANANID;
                            tpbdc.BICANID = oTHABiAn_UyThac.ID;
                            tpbdc.VUANID = oTHABiAn_UyThac.ID;
                            tpbdc.DIEULUATID = apbdc.DIEULUATID;
                            tpbdc.HINHPHATID = apbdc.HINHPHATID;
                            tpbdc.LOAIHINHPHAT = apbdc.LOAIHINHPHAT;
                            tpbdc.TF_VALUE = apbdc.TF_VALUE;
                            tpbdc.SH_VALUE = apbdc.SH_VALUE;
                            tpbdc.TG_NAM = apbdc.TG_NAM;
                            tpbdc.TG_THANG = apbdc.TG_THANG;
                            tpbdc.TG_NGAY = apbdc.TG_NGAY;
                            tpbdc.K_VALUE1 = apbdc.K_VALUE1;
                            tpbdc.K_VALUE2 = apbdc.K_VALUE2;
                            tpbdc.ISANTREO = apbdc.ISANTREO;
                            tpbdc.TOIDANHID = apbdc.TOIDANHID;
                            tpbdc.ISCHANGE = apbdc.ISCHANGE;
                            tpbdc.TGTT_NAM = apbdc.TGTT_NAM;
                            tpbdc.TGTT_THANG = apbdc.TGTT_THANG;
                            tpbdc.TGTT_NGAY = apbdc.TGTT_NGAY;
                            tpbdc.TENTOIDANH = apbdc.TENTOIDANH;
                            tpbdc.ISMAIN = apbdc.ISMAIN;
                            DataExtensions.Insert<THA_PHUCTHAM_BANAN_DIEU_CT>(tpbdc);
                        }
                    }
                    // VNPT - Lưu Quang Huy - Thêm thông tin bản án vào THA - 23/09/2025 15h55

                    List<THA_SOTHAM_CAOTRANG_DIEULUAT> tscds = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == oTHABiAn.ID && x.VUANID == oTHAVuAn.ID).ToList();
                    foreach (THA_SOTHAM_CAOTRANG_DIEULUAT tscd in tscds)
                    {
                        THA_SOTHAM_CAOTRANG_DIEULUAT tscd_uythac = new THA_SOTHAM_CAOTRANG_DIEULUAT();
                        tscd_uythac.BICANID = oTHABiAn_UyThac.ID;
                        tscd_uythac.VUANID = oTHAVuAn_UyThac.ID;
                        tscd_uythac.CAOTRANGID = tscd.CAOTRANGID;
                        tscd_uythac.DIEULUATID = tscd.DIEULUATID;
                        tscd_uythac.NGUOITAO = tscd.NGUOITAO;
                        tscd_uythac.NGUOISUA = tscd.NGUOISUA;
                        tscd_uythac.NGAYTAO = tscd.NGAYTAO;
                        tscd_uythac.NGAYSUA = tscd.NGAYSUA;
                        tscd_uythac.TOIDANHID = tscd.TOIDANHID;
                        tscd_uythac.TENTOIDANH = tscd.TENTOIDANH;
                        tscd_uythac.ISMAIN = tscd.ISMAIN;
                        tscd_uythac.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Add(tscd_uythac);
                    }
                    dt.SaveChanges();

                    //Đổi trạng thái khi nhận THA
                    oTT_UYTHAC.TRANGTHAI = 1;
                    oTT_UYTHAC.NGAYNHANUYTHAC = DateTime.Now;
                    oTT_UYTHAC.GHICHU = txtGhichu.Text;
                    //Cập nhật người ký
                    Decimal idNguoiKy = Convert.ToDecimal(dropNguoiKy.SelectedValue);
                    oTT_UYTHAC.NGUOIKY = idNguoiKy;
                    dt.SaveChanges();
                }
            }

        }
    }
}