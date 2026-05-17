using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class Ketqua : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        GDTTT_VUAN_KETQUA_BL oVAKQ = new GDTTT_VUAN_KETQUA_BL();
        GDTTT_VUAN_KETQUA_DON_BL obl = new GDTTT_VUAN_KETQUA_DON_BL();
        String temp_folder_upload = "~/TempUpload/";
        Decimal LoaiNguoiKhangNghiID = 1143;//ChanhAn
        Decimal CurrentUserID = 0, CurrDonViID=0;
        public String IsShowCol = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    LoadDropDonThuLyMoi(null);
                    if (Request["vid"] != null)
                    {
                        LoadInfoVuAn();
                    }

                }
            }
        }
        void LoadDropThamQuyenXX()
        {
            //Thẩm quyền xét xử
            ddlThamquyenXX.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                ddlThamquyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.ID == CurrDonViID) && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            }
            else
                ddlThamquyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.LOAITOA == "CAPCAO") && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            ddlThamquyenXX.DataTextField = "TEN";
            ddlThamquyenXX.DataValueField = "ID";
            ddlThamquyenXX.DataBind();
            ddlThamquyenXX.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadDropNguoiKy(DropDownList drop, DataTable tbl)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (tbl == null)
                tbl = objBL.DM_CANBO_GETBYDONVI_2CHUCVU(donviID, ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadDropNguoiKyTP(DropDownList drop, DataTable tbl)//anhpn
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (tbl == null)
            {
                if (donviID == 1)
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHANTOICAO);
                    DataTable tpb3 = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN_BAC3); //lấy thêm TP bậc 3
                    tbl.Merge(tpb3);
                    tbl.AcceptChanges();
                }
                else
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                }
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadDropNguoiKyXuLyDon(DropDownList drop, DataTable tbl)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (tbl == null)
            {
                if (donviID == 1)
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHANTOICAO);
                    DataTable tpb3 = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN_BAC3); //lấy thêm TP bậc 3
                    tbl.Merge(tpb3);
                    tbl.AcceptChanges();
                }
                else
                {
                    tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU(donviID, "XULYDON");
                }
            }
            //tbl = objBL.DM_CANBO_GETBYDONVI_2CHUCVU(donviID, "041", "042");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void LoadInfoVuAn()
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                LoadThongTinVuAn(VuAnID, oT);

                if (oT.GQD_LOAIKETQUA != null)
                {
                    cmdXoa.Visible = true;
                    rdbLoai.SelectedValue = oT.GQD_LOAIKETQUA.ToString();
                    lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";
                    pnXuLyKhac.Visible = false;
                    switch (oT.GQD_LOAIKETQUA.ToString())
                    {
                        case "0":
                            pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
                            pnTLD.Visible = true;
                            //txtTLD_So.Text = oT.GDQ_SO + "";
                            //txtTLD_NguoiKy.Text = oT.GDQ_NGUOIKY + "";
                            //if (oT.GDQ_NGAY != null) txtTLD_Ngay.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            rdbLoai.Items[4].Enabled = false;
                            break;
                        case "1":
                            LoadDropThamQuyenXX();
                            pnQDKN.Visible = true;
                            pnVKS_GQ.Visible = pnTLD.Visible = pnXepDon.Visible = false;
                            //txtSoQD.Text = oT.GDQ_SO + "";
                            //txtKN_NguoiKy.Text = oT.GDQ_NGUOIKY + "";
                            //txtKN_Noidung.Text = oT.XXGDTTT_NOIDUNGKN + "";
                            //if (oT.GDQ_NGAY != null) txtNgayQD.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            //if (oT.THAMQUYENXXGDT != null) ddlThamquyenXX.SelectedValue = oT.THAMQUYENXXGDT + "";
                            rdbLoai.Items[4].Enabled = false;
                            break;
                        case "2":
                            pnQDKN.Visible = pnVKS_GQ.Visible = pnTLD.Visible = false;
                            pnXepDon.Visible = true;
                            //txtNguoiDuyetXepDon.Text = oT.GDQ_NGUOIKY + "";
                            //txtSoXepDon.Text = oT.GDQ_SO + "";
                            //txtNgayXepDon.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            rdbLoai.Items[4].Enabled = false;
                            break;
                        case "3":
                            pnXuLyKhac.Visible = true;
                            pnVKS_GQ.Visible = pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = false;
                            lbl_GQD_NgayCV.Text = "Ngày xử lý";
                            //txtNoiDung_xlk.Text = oT.GQD_KETQUA;
                            //txtKN_NguoiKy_xlk.Text = oT.GDQ_NGUOIKY + "";
                            //txt_xlk_so.Text = oT.GDQ_SO + "";
                            rdbLoai.Items[4].Enabled = false;
                            break;
                        case "4":
                            pnTLD.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
                            pnVKS_GQ.Visible = true;
                            //txtTB_So.Text = oT.GDQ_SO + "";
                            //txtTB_NguoiKy.Text = oT.GDQ_NGUOIKY + "";
                            //if (oT.GDQ_NGAY != null) txtTB_Ngay.Text = ((DateTime)oT.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                            break;
                    }
                    if (!string.IsNullOrEmpty(txtTLD_NguoiKy.Text))
                    {
                        dropTLD_NguoiKy_td.Visible = false;
                        txtTLD_NguoiKy_td.Visible = true;
                    }
                    else
                    {
                        dropTLD_NguoiKy_td.Visible = true;
                        txtTLD_NguoiKy_td.Visible = false;
                        LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
                    }
                    if (!string.IsNullOrEmpty(txtKN_NguoiKy.Text))
                    {
                        dropKN_NguoiKy_td.Visible = false;
                        txtKN_NguoiKy_td.Visible = true;
                    }
                    else
                    {
                        dropKN_NguoiKy_td.Visible = true;
                        txtKN_NguoiKy_td.Visible = false;
                        LoadDropNguoiKyTP(dropKN_NguoiKy, null);
                    }

                    if (!string.IsNullOrEmpty(txtNguoiDuyetXepDon.Text))
                    {
                        dropNguoiDuyetXepDon_td.Visible = false;
                        txtNguoiDuyetXepDon_td.Visible = true;
                    }
                    else
                    {
                        dropNguoiDuyetXepDon_td.Visible = true;
                        txtNguoiDuyetXepDon_td.Visible = false;
                        LoadDropNguoiKyXuLyDon(dropNguoiDuyetXepDon, null);
                    }

                    if (!string.IsNullOrEmpty(txtKN_NguoiKy_xlk.Text))
                    {
                        DropKN_NguoiKy_xlk_td.Visible = false;
                        txtKN_NguoiKy_xlk_td.Visible = true;
                    }
                    else
                    {
                        DropKN_NguoiKy_xlk_td.Visible = true;
                        txtKN_NguoiKy_xlk_td.Visible = false;
                        LoadDropNguoiKyXuLyDon(DropKN_NguoiKy_xlk, null);
                    }
                    if (!string.IsNullOrEmpty(txtTB_NguoiKy.Text))
                    {
                        DropTB_NguoiKy_td.Visible = false;
                        txtTB_NguoiKy_td.Visible = true;
                    }
                    else
                    {
                        DropTB_NguoiKy_td.Visible = true;
                        txtTB_NguoiKy_td.Visible = false;
                        LoadDropNguoiKyXuLyDon(DropTB_NguoiKy, null);
                    }
                    LoadDSTraLoiDon_ADS();
                    txtGhichu.Text = oT.GQD_GHICHU + "";
                }
                else
                {
                    txtTLD_NguoiKy_td.Visible = false;
                    txtKN_NguoiKy_td.Visible = false;
                    txtNguoiDuyetXepDon_td.Visible = false;
                    txtKN_NguoiKy_xlk_td.Visible = false;
                    txtTB_NguoiKy_td.Visible = false;
                }
                LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
                LoadDropNguoiKyTP(dropKN_NguoiKy, null);
                LoadDropNguoiKyXuLyDon(dropNguoiDuyetXepDon, null);
                LoadDropNguoiKyXuLyDon(DropKN_NguoiKy_xlk, null);
                LoadDropNguoiKyXuLyDon(DropTB_NguoiKy, null);
                cmdXoa.Visible = false;
                LoadDSTraloidon(oT.ID);
                //--------------------------------
                lbtDownload.Visible = (String.IsNullOrEmpty(oT.KQ_TENFILE + "")) ? false : true;
                //--------------------------------
                int is_anqh = (string.IsNullOrEmpty(oT.ISANQUOCHOI + "")) ? 0 : (int)oT.ISANQUOCHOI;
                if (is_anqh > 0)                    
                    pnThongBaoAQH.Visible = true;
                else
                    pnThongBaoAQH.Visible = false;
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = "Lỗi: " + ex.Message;
                //lbthongbao.ForeColor = System.Drawing.Color.Red;
            }
        }
        void LoadThongTinVuAn(Decimal VuAnID, GDTTT_VUAN oT)
        {
            if (oT != null)
            {
                // txtGQD_SoCV.Text = oT.GQD_SOCV;
                //txtGQD_NgayCV.Text = (String.IsNullOrEmpty(oT.GQD_NGAYPHATHANHCV + "") || (oT.GQD_NGAYPHATHANHCV == DateTime.MinValue)) ? "" : ((DateTime)oT.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);

                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;

                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0 && String.IsNullOrEmpty(oT.QHPL_TEXT + ""))
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                    else
                    {
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oT.QHPL_TEXT;
                    }

                }
                if (!string.IsNullOrEmpty(oT.GQD_ISHOANTHA + "") && ((int)oT.GQD_ISHOANTHA == 1))
                {
                    LoadDropNguoiKy(dropHTA_NguoiKy, null);
                    pnHoanTHA.Visible = true;
                    rdHoanTHA.SelectedValue = "1";
                    txtHTA_So.Text = oT.GQD_HOANTHA_SO + "";
                    if (oT.GQD_HOANTHA_NGAY != null)
                        txtHTA_Ngay.Text = ((DateTime)oT.GQD_HOANTHA_NGAY).ToString("dd/MM/yyyy", cul);
                    Cls_Comon.SetValueComboBox(dropHTA_NguoiKy, oT.GQD_HOANTHA_NGUOIKYID);
                    cmdXoaHoanTHA.Visible = true;
                }
                else pnHoanTHA.Visible = cmdXoaHoanTHA.Visible = false;

                //------------------------

                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                if (oT.LOAIAN == 1)
                    txtVuan_Loaian.Text = "Hình sự";
                else if (oT.LOAIAN == 2)
                    txtVuan_Loaian.Text = "Dân sự";
                else if (oT.LOAIAN == 3)
                    txtVuan_Loaian.Text = "Hôn nhân - Gia đình";
                else if (oT.LOAIAN == 4)
                    txtVuan_Loaian.Text = "Kinh doanh, thương mại";
                else if (oT.LOAIAN == 5)
                    txtVuan_Loaian.Text = "Lao động";
                else if (oT.LOAIAN == 6)
                    txtVuan_Loaian.Text = "Hành chính";
                else if (oT.LOAIAN == 7)
                    txtVuan_Loaian.Text = "Phá sản";

                if (oT.LOAI_GDTTTT == 2)
                    txtVuan_LoaiGDTT.Text = "Tái thẩm";
                else
                    txtVuan_LoaiGDTT.Text = "Giám đốc thẩm";

                if (oT.BAQD_CAPXETXU == 2)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANSOTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUSOTHAM + "") || (oT.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                }
                else if (oT.BAQD_CAPXETXU == 3)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    txtVuAn_SoBanAn.Text = oT.SO_QDGDT;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYQD + "") || (oT.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                //----------------------------------
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);

                txtVuan_NguoiGui.Text = oT.NGUOIKHIEUNAI;
                if (oT.ISHOSO == 1)
                    txtVuan_TrangthaiHS.Text = "Có hồ sơ";
                else
                    txtVuan_TrangthaiHS.Text = "";
                txtVuan_Ghichu.Text = oT.GHICHU;
            }
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
        private void LoadDSTraloidon(decimal VuAnID)
        {
            int is_visible = 0;
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            // DataTable tbl = oBL.TRALOIDON_DANHSACH(VuAnID);
            GDTTT_DON_TRALOI_BL objBL = new GDTTT_DON_TRALOI_BL();
            DataTable tbl = objBL.GetAllTB_TheoLoai(VuAnID, 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
                is_visible++;
            }
            else rpt.Visible = false;

            //---------------------------------
            /* List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID
                                                                      && x.DUONGSUID == 0
                                                                      && x.TYPETB == ENUM_LOAITHONGBAO_QH.TBKQTRALOI).ToList();
             if (lst != null && lst.Count > 0)
             {
                 rptTB.DataSource = lst;
                 rptTB.DataBind();
                 rptTB.Visible = true;
                 rptTB.Visible = true;
                 is_visible++;
             }
             else
                 rptTB.Visible = false;*/
            if (is_visible > 0)
                pnThongBaoAQH.Visible = true;
            else
                pnThongBaoAQH.Visible = false;
        }
        void LoadDSTraLoiDon_ADS()
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            //Lay ra Khang nghị
            DataTable tblKN = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 1, 1);
            if (tblKN != null && tblKN.Rows.Count > 0)
            {
                rptKhangNghi.DataSource = tblKN;
                rptKhangNghi.DataBind();
                rptKhangNghi.Visible = true;
                rptKhangNghi.Visible = true;
            }
            else//trường hợp có kết quả nhưng không có đơn
            {
                tblKN = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 1, null);
                if (tblKN != null && tblKN.Rows.Count > 0)
                {
                    rptKhangNghi.DataSource = tblKN;
                    rptKhangNghi.DataBind();
                    rptKhangNghi.Visible = true;
                    rptKhangNghi.Visible = true;
                }
                else
                {
                    rptKhangNghi.Visible = false;
                }
            }    

            //Lay ra tra loi don
            DataTable tbl = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 0, 1);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptTraLoiDon.DataSource = tbl;
                rptTraLoiDon.DataBind();
                rptTraLoiDon.Visible = true;
                rptTraLoiDon.Visible = true;
            }
            else
            {
                tbl = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 0, null);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptTraLoiDon.DataSource = tbl;
                    rptTraLoiDon.DataBind();
                    rptTraLoiDon.Visible = true;
                    rptTraLoiDon.Visible = true;
                }
                else
                    rptTraLoiDon.Visible = false;
            }    

            //Xep don
            DataTable tblXd = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 2, 1);
            if (tblXd != null && tblXd.Rows.Count > 0)
            {
                rptXepDon.DataSource = tblXd;
                rptXepDon.DataBind();
                rptXepDon.Visible = true;
                rptXepDon.Visible = true;
            }
            else
            {
                tblXd = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 2, null);
                if (tblXd != null && tblXd.Rows.Count > 0)
                {
                    rptXepDon.DataSource = tblXd;
                    rptXepDon.DataBind();
                    rptXepDon.Visible = true;
                    rptXepDon.Visible = true;
                }
                else
                    rptXepDon.Visible = false;
            }    

            //Xu ly khac
            DataTable tblXlk = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 3, 1);
            if (tblXlk != null && tblXlk.Rows.Count > 0)
            {
                rptXuLyKhac.DataSource = tblXlk;
                rptXuLyKhac.DataBind();
                rptXuLyKhac.Visible = true;
                rptXuLyKhac.Visible = true;
            }
            else
            {
                tblXlk = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 3, null);
                if (tblXlk != null && tblXlk.Rows.Count > 0)
                {
                    rptXuLyKhac.DataSource = tblXlk;
                    rptXuLyKhac.DataBind();
                    rptXuLyKhac.Visible = true;
                    rptXuLyKhac.Visible = true;
                }
                else
                    rptXuLyKhac.Visible = false;
            }

            //VKS 
            DataTable tblVKS = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 4, 1);
            if (tblVKS != null && tblVKS.Rows.Count > 0)
            {
                rptVKS.DataSource = tblVKS;
                rptVKS.DataBind();
                rptVKS.Visible = true;
                rptVKS.Visible = true;
            }
            else
            {
                tblVKS = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 4, null);
                if (tblVKS != null && tblVKS.Rows.Count > 0)
                {
                    rptVKS.DataSource = tblVKS;
                    rptVKS.DataBind();
                    rptVKS.Visible = true;
                    rptVKS.Visible = true;
                }
                else
                    rptVKS.Visible = false;
            }    
        }
        protected void cmdXoaHoanTHA_Click(object sender, EventArgs e)
        {
            string strvid = Request["vid"] + "";
            decimal VuAnID = Convert.ToDecimal(strvid);
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            oVA.GQD_HOANTHA_SO = "";
            oVA.GQD_HOANTHA_NGAY = (DateTime?)null;
            oVA.GQD_HOANTHA_NGUOIKYID = 0;
            oVA.GQD_HOANTHA_TENNGUOIKY = "";
            oVA.GQD_ISHOANTHA = 0;
            dt.SaveChanges();

            rdHoanTHA.SelectedValue = "0";
            pnHoanTHA.Visible = false;
            cmdXoaHoanTHA.Visible = false; ;

            lttMsgHoanTHA.ForeColor = System.Drawing.Color.Blue;
            lttMsgHoanTHA.Text = "Xóa dữ liệu thành công !";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }

        protected void cmdUpdateHoanTHA_Click(object sender, EventArgs e)
        {
            try
            {
                string strvid = Request["vid"] + "";
                decimal VuAnID = Convert.ToDecimal(strvid);
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                oVA.GQD_HOANTHA_SO = "";
                oVA.GQD_HOANTHA_NGAY = (DateTime?)null;
                oVA.GQD_HOANTHA_NGUOIKYID = 0;
                oVA.GQD_HOANTHA_TENNGUOIKY = "";
                oVA.GQD_ISHOANTHA = 0;
                int ishoantha = Convert.ToInt16(rdHoanTHA.SelectedValue);
                if (ishoantha == 1)
                {
                    oVA.GQD_ISHOANTHA = 1;
                    //Update them thong tin Hoan thi hanh an
                    oVA.GQD_HOANTHA_SO = txtHTA_So.Text.Trim();
                    oVA.GQD_HOANTHA_NGAY = (String.IsNullOrEmpty(txtHTA_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHTA_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GQD_HOANTHA_NGUOIKYID = Convert.ToDecimal(dropHTA_NguoiKy.SelectedValue);
                    oVA.GQD_HOANTHA_TENNGUOIKY = dropHTA_NguoiKy.SelectedItem.Text;
                }

                //-----------------------------------              
                dt.SaveChanges();

                if (ishoantha == 1)
                    cmdXoaHoanTHA.Visible = true;
                else
                    cmdXoaHoanTHA.Visible = false;
                lttMsgHoanTHA.ForeColor = System.Drawing.Color.Blue;
                lttMsgHoanTHA.Text = "Cập nhật thành công !";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lttMsgHoanTHA.ForeColor = System.Drawing.Color.Red;
                lttMsgHoanTHA.Text = "Lỗi:" + ex.Message;
            }
        }
        protected void cmdUpdateThongBaoAnQH_Click(object sender, EventArgs e)
        {
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            Update_ThongBaoTL(oVA);
            lbthongbao.ForeColor = System.Drawing.Color.Blue;
            lbthongbao.Text = "Cập nhật thành công !";
            cmdXoa.Visible = true;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdDeleteThongBaoAnQH_Click(object sender, EventArgs e)
        {
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == ENUM_LOAITHONGBAO_QH.TBKQTRALOI).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_DON_TRALOI item in lst)
                    dt.GDTTT_DON_TRALOI.Remove(item);
                dt.SaveChanges();
            }
            lbthongbao.ForeColor = System.Drawing.Color.Blue;
            lbthongbao.Text = "Xoá thành công !";
            cmdXoa.Visible = true;
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                #region Update thong tin KQGQDon                
                // oVA.GQD_SOCV = txtGQD_SoCV.Text;
                oVA.GQD_NGAYPHATHANHCV = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //-----------------------------                
                oVA.NGUOIKHANGNGHI = 0;
                oVA.THAMQUYENXXGDT = 0;
                oVA.GQD_GHICHU = txtGhichu.Text;

                //-----------------------------------
                string loai = rdbLoai.SelectedValue;
                oVA.GQD_LOAIKETQUA = Convert.ToDecimal(loai);
                string ngay_temp = "";

                switch (loai)
                {
                    case "0":
                        oVA.GDQ_SO = txtTLD_So.Text;
                        ngay_temp = txtTLD_Ngay.Text.Trim();
                        oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oVA.GDQ_NGUOIKY = txtTLD_NguoiKy.Text.Trim();
                        oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                        rdbLoai.Items[4].Enabled = false;
                        break;
                    case "1":
                        ngay_temp = txtNgayQD.Text.Trim();
                        oVA.GDQ_SO = txtSoQD.Text;
                        oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oVA.GDQ_NGUOIKY = txtKN_NguoiKy.Text.Trim();
                        oVA.NGUOIKHANGNGHI = LoaiNguoiKhangNghiID; //Convert.ToDecimal(ddlNguoiKN.SelectedValue);
                        oVA.THAMQUYENXXGDT = Convert.ToDecimal(ddlThamquyenXX.SelectedValue);
                        oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                        rdbLoai.Items[4].Enabled = false;
                        break;
                    case "2":
                        ngay_temp = txtNgayXepDon.Text.Trim();
                        oVA.GDQ_NGUOIKY = txtNguoiDuyetXepDon.Text.Trim();
                        oVA.GDQ_SO = txtSoXepDon.Text;
                        oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayXepDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                        rdbLoai.Items[4].Enabled = false;
                        break;
                    case "3":
                        oVA.GDQ_NGUOIKY = txtKN_NguoiKy_xlk.Text.Trim();
                        oVA.GQD_KETQUA = txtNoiDung_xlk.Text;
                        oVA.GDQ_SO = txt_xlk_so.Text;
                        oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        rdbLoai.Items[4].Enabled = false;
                        break;
                    case "4":
                        oVA.GDQ_SO = txtTB_So.Text;
                        ngay_temp = txtTB_Ngay.Text.Trim();
                        oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTB_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oVA.GDQ_NGUOIKY = txtTB_NguoiKy.Text.Trim();
                        oVA.GQD_KETQUA = "số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                        rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                        break;
                }

                //-----------------------------
                //UpdateFile(oVA);
                #endregion


                if (!string.IsNullOrEmpty(dropDon.SelectedValue))
                {
                    var checkBangVuAnKQD = obl.GDTTT_VUAN_KETQUA_DON_GETBYVUANID(VuAnID);
                    if (checkBangVuAnKQD != null && checkBangVuAnKQD.Rows.Count > 0)
                    {
                        Decimal DonID = Convert.ToDecimal(dropDon.SelectedValue);
                        var oVAKQDs = DataExtensions.GetAllByDonId<GDTTT_VUAN_KETQUA_DON>(DonID);
                        if (oVAKQDs.Count > 0)
                        {
                            var oVAKQD = oVAKQDs.Where(o => o.TRANGTHAI == 1).ToArray().FirstOrDefault();
                            if (oVAKQD != null)
                            {
                                oVAKQD.TRANGTHAI = 0;
                                DataExtensions.Update<GDTTT_VUAN_KETQUA_DON>(oVAKQD);

                                var oVAKQ = DataExtensions.FindById<GDTTT_VUAN_KETQUA>(oVAKQD.VUAN_KETQUA_ID);
                                if (oVAKQ != null)
                                {
                                    oVAKQ.TRANGTHAI = 0;
                                    DataExtensions.Update<GDTTT_VUAN_KETQUA>(oVAKQ);
                                }
                            }

                        }
                    }
                    //cập nhật bảng GDTTT_VUAN_KETQUA
                    Update_VUAN_KETQUA();
                }

                LoadDropDonThuLyMoi(null);
                //-----------------------------------
                oVA.QUATRINH_GHICHU = txtGhichu.Text;
                if (loai != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT.ToString())
                {
                    switch (loai)
                    {
                        case "0":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
                            break;
                        case "1":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
                            break;
                        case "2":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                            break;
                        case "3":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                            break;
                        case "4":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON_VKS_DANGGIAIQUYET;
                            break;
                    }
                }

                dt.SaveChanges();
                ClearForm();
                LoadDSTraLoiDon_ADS();
                if (rdbLoai.SelectedValue == "4")
                {
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                }
                else
                {
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;
                }
                Update_ThongBaoTL(oVA);
                lbthongbao.ForeColor = System.Drawing.Color.Blue;
                lbthongbao.Text = "Cập nhật thành công !";
                cmdXoa.Visible = true;
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi:" + ex.Message;
            }
        }

        void Update_VUAN_KETQUA()//anhpn
        {
            decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            //GDTTT_VUAN_KETQUA oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            GDTTT_VUAN_KETQUA oVA = new GDTTT_VUAN_KETQUA();
            //List<GDTTT_VUAN_KETQUA> lst = new List<GDTTT_VUAN_KETQUA>();
            //var obj = oVAKQ.GDTTT_VUAN_KETQUA_GETBYVUANID(VuAnID);
            var obj = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_KETQUA>(VuAnID);
            //oVA.ID = Convert.ToDecimal(Request["vid"] + obj.Rows.Count);

            #region Update thong tin KQGQDon                
            oVA.GQD_NGAYPHATHANHCV = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oVA.NGUOIKHANGNGHI = 0;
            oVA.THAMQUYENXXGDT = 0;
            oVA.GQD_GHICHU = txtGhichu.Text;
            oVA.VUANID = VuAnID;
            oVA.TOAAN_ID = donviID;
            oVA.TRANGTHAI = 1;
            oVA.NGAYTAO = DateTime.Now;
            oVA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            //-----------------------------------
            string loai = rdbLoai.SelectedValue;
            oVA.GQD_LOAIKETQUA = Convert.ToDecimal(loai);
            string ngay_temp = "";

            switch (loai)
            {
                case "0":
                    oVA.GDQ_SO = txtTLD_So.Text;
                    ngay_temp = txtTLD_Ngay.Text.Trim();
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GDQ_NGUOIKY = txtTLD_NguoiKy.Text.Trim();
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                    break;
                case "1":
                    ngay_temp = txtNgayQD.Text.Trim();
                    oVA.GDQ_SO = txtSoQD.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GDQ_NGUOIKY = txtKN_NguoiKy.Text.Trim();
                    oVA.NGUOIKHANGNGHI = LoaiNguoiKhangNghiID;
                    oVA.NOIDUNGKHANGNGHI = txtKN_Noidung.Text.Trim();
                    oVA.THAMQUYENXXGDT = Convert.ToDecimal(ddlThamquyenXX.SelectedValue);
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                    break;
                case "2":
                    ngay_temp = txtNgayXepDon.Text.Trim();
                    oVA.GDQ_NGUOIKY = txtNguoiDuyetXepDon.Text.Trim();
                    oVA.GDQ_SO = txtSoXepDon.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtNgayXepDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                    break;
                case "3":
                    oVA.GDQ_NGUOIKY = txtKN_NguoiKy_xlk.Text.Trim();
                    oVA.GQD_KETQUA = txtNoiDung_xlk.Text;
                    oVA.GDQ_SO = txt_xlk_so.Text;
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[4].Enabled = false;
                    break;
                case "4":
                    oVA.GDQ_SO = txtTB_So.Text;
                    ngay_temp = txtTB_Ngay.Text.Trim();
                    oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTB_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oVA.GDQ_NGUOIKY = txtTB_NguoiKy.Text.Trim();
                    oVA.GQD_KETQUA = "số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
                    break;
            }
            #endregion
            oVA.QUATRINH_GHICHU = txtGhichu.Text;
            decimal result = 0;
            if (obj != null)
            {
                obj = obj.Where(o => o.TRANGTHAI == 1).ToList();
                if (obj.Count == 0)
                {
                    result = DataExtensions.Insert<GDTTT_VUAN_KETQUA>(oVA);
                }
                else
                {
                    if (lstDataUS.Value != null && lstDataUS.Value != "")
                    {
                        var lstDons = lstDataUS.Value.Split(',').ToArray();
                        //var checkVuAn_KetQua_Don = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(Convert.ToDecimal(lstDons.FirstOrDefault()));
                        var checkVuAn_KetQua_Don = DataExtensions.GetAllByDonId<GDTTT_VUAN_KETQUA_DON>(Convert.ToDecimal(lstDons.FirstOrDefault()));
                        if (checkVuAn_KetQua_Don != null)
                        {
                            checkVuAn_KetQua_Don = checkVuAn_KetQua_Don.Where(o => o.TRANGTHAI == 1).ToList();
                            if (checkVuAn_KetQua_Don.Count > 0)
                            {
                                //oVA.ID = decimal.Parse(row["ID"].ToString());
                                //result = decimal.Parse(row["ID"].ToString());
                                DataExtensions.Update<GDTTT_VUAN_KETQUA>(oVA);
                            }
                            else
                            {
                                result = DataExtensions.Insert<GDTTT_VUAN_KETQUA>(oVA);
                            }
                        }
                    }
                    else
                    {
                        Decimal DonID = Convert.ToDecimal(dropDon.SelectedValue);
                        //var checkVuAn_KetQua_Don = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(DonID);
                        var checkVuAn_KetQua_Don = DataExtensions.GetAllByDonId<GDTTT_VUAN_KETQUA_DON>(Convert.ToDecimal(DonID));
                        if (checkVuAn_KetQua_Don != null)
                        {
                            checkVuAn_KetQua_Don = checkVuAn_KetQua_Don.Where(o => o.TRANGTHAI == 1).ToList();
                            if (checkVuAn_KetQua_Don.Count > 0)
                            {
                                //oVA.ID = decimal.Parse(row["ID"].ToString());
                                //result = decimal.Parse(row["ID"].ToString());
                                //oVAKQ.GDTTT_VUAN_KETQUA_INS_UPD(oVA);
                                DataExtensions.Update<GDTTT_VUAN_KETQUA>(oVA);
                            }
                            else
                            {
                                result = DataExtensions.Insert<GDTTT_VUAN_KETQUA>(oVA);
                            }
                        }
                    }
                }
            }
            //oVAKQ.GDTTT_VUAN_KETQUA_INSERT(oVA);

            // kiểm tra xem ngày tạo lớn nhất thì update trạng thái cập nhật vào bảng vụ án
            List<GDTTT_VUAN_KETQUA> lst = new List<GDTTT_VUAN_KETQUA>();
            //var checktrangthai = oVAKQ.GDTTT_VUAN_KETQUA_GETBYID(VuAnID);
            lst = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_KETQUA>(VuAnID);
            if (lst != null && lst.Count > 0)
            {
                lst = lst.Where(o => o.TRANGTHAI == 1).OrderByDescending(o => o.NGAYTAO).ToList();
                for (int i = 0; i < lst.Count(); i++)
                {
                    if (i == 0)
                    {
                        lst[i].CAPNHATVUAN = 1;
                        var VUANID = lst[i].VUANID;
                        //oVAKQ.GDTTT_VUAN_KETQUA_CAPNHATVUAN(lst[i].ID, lst[i].CAPNHATVUAN);
                        DataExtensions.Update<GDTTT_VUAN_KETQUA>(lst[i]);

                        GDTTT_VUAN updateVA = dt.GDTTT_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();
                        switch (lst[i].GQD_LOAIKETQUA.ToString())
                        {
                            case "0":
                                updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
                                break;
                            case "1":
                                updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
                                break;
                            case "2":
                                updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                                break;
                            case "3":
                                updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                                break;
                            case "4":
                                updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON_VKS_DANGGIAIQUYET;
                                break;
                        }
                        dt.SaveChanges();
                    }
                    else
                    {
                        lst[i].CAPNHATVUAN = 0;
                        //oVAKQ.GDTTT_VUAN_KETQUA_CAPNHATVUAN(lst[i].ID, lst[i].CAPNHATVUAN);
                        DataExtensions.Update<GDTTT_VUAN_KETQUA>(lst[i]);
                    }
                }
            }
            // cập nhật bảng vụ án kết quả đơn
            Update_VUAN_KETQUA_DON(result);
        }

        void Update_VUAN_KETQUA_DON(Decimal VUAN_KETQUA_ID)//anhpn
        {
            decimal cKQ = 0;
            string loai = rdbLoai.SelectedValue;
            if (lstDataUS.Value != null && lstDataUS.Value != "")
            {
                var lstDons = lstDataUS.Value.Split(',').ToArray();
                foreach (var ChonDon in lstDons)
                {
                    Decimal DonID = Convert.ToDecimal(ChonDon);
                    //Tra loi doi thi moi update cả 2
                    //if (loai == "0" || loai == "1")
                    //{
                    if (DonID > 0)
                    {
                        Update_KQTLDon_ADS(DonID, VUAN_KETQUA_ID);
                    }
                    else
                    {
                        decimal CurrDonID = 0;
                        //Tao kq giai quyet don cho tat ca nguoi khieu nai (chua co kq giai quyet don) 
                        foreach (ListItem item in dropDon.Items)
                        {
                            CurrDonID = Convert.ToDecimal(item.Value);
                            if (CurrDonID != 0)
                            {
                                try
                                {
                                    var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(CurrDonID);
                                    if (obj != null && obj.Rows.Count == 0)
                                    {
                                        Update_KQTLDon_ADS(CurrDonID, VUAN_KETQUA_ID);
                                        cKQ += 1;
                                    }
                                }
                                catch (Exception ex) { }
                            }
                        }
                        // kiem tra nếu đã có kết quả cho người khiếu nại thì không tạo tất cả cho đơn trùng này nữa hoặc sửa kết quả cho tất cả
                        //if (cKQ == 0)
                        //{
                        //    Update_KQTLDon_ADS(0, VUAN_KETQUA_ID);
                        //}
                    }
                    //}
                }

            }
            else
            {
                Decimal DonID = Convert.ToDecimal(dropDon.SelectedValue);
                if (DonID > 0)
                {
                    Update_KQTLDon_ADS(DonID, VUAN_KETQUA_ID);
                }
                else
                {
                    decimal CurrDonID = 0;
                    //Tao kq giai quyet don cho tat ca nguoi khieu nai (chua co kq giai quyet don) 
                    foreach (ListItem item in dropDon.Items)
                    {
                        CurrDonID = Convert.ToDecimal(item.Value);
                        if (CurrDonID != 0)
                        {
                            try
                            {
                                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(CurrDonID);
                                if (obj != null && obj.Rows.Count == 0)
                                {
                                    Update_KQTLDon_ADS(CurrDonID, VUAN_KETQUA_ID);
                                    cKQ += 1;
                                }
                            }
                            catch (Exception ex) { }
                        }
                    }
                    // kiem tra nếu đã có kết quả cho người khiếu nại thì không tạo tất cả cho đơn trùng này nữa hoặc sửa kết quả cho tất cả
                    //if (cKQ == 0)
                    //{
                    //    Update_KQTLDon_ADS(0, VUAN_KETQUA_ID);
                    //}
                }
            }
        }

        void Update_ThongBaoTL(GDTTT_VUAN oVA)
        {
            // if (oVA.ISANQUOCHOI==1)
            // {
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            //if (rdbLoai.SelectedValue == "0")
            //{
            Decimal CurrDSID = 0, ThongBaoID = 0;
            string temp = "";
            int LoaiTLD = 2; //0:Nguoi khiếu nại/1:Đương su/2:Co quan chuyen don/3:Khac

            foreach (RepeaterItem item in rpt.Items)
            {
                HiddenField hddThongBaoID = (HiddenField)item.FindControl("hddThongBaoID");
                HiddenField hddDonID = (HiddenField)item.FindControl("hddDonID");

                Literal lttHoTen = (Literal)item.FindControl("lttHoTen");
                Literal lttAddress = (Literal)item.FindControl("lttAddress");
                TextBox txtSo = (TextBox)item.FindControl("txtSo");
                TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                TextBox txtGhiChu = (TextBox)item.FindControl("txtGhiChu");

                ThongBaoID = Convert.ToDecimal(hddThongBaoID.Value);
                temp = "," + ThongBaoID.ToString() + ",";

                //----------------------------
                if ((!String.IsNullOrEmpty(txtSo.Text.Trim())) || (!String.IsNullOrEmpty(txtNgay.Text.Trim())))
                {
                    #region Insert hoac update
                    bool isupdate = false;
                    GDTTT_DON_TRALOI objEdit = null;
                    try
                    {
                        if (ThongBaoID > 0)
                        {
                            objEdit = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongBaoID).Single();
                            if (objEdit != null)
                                isupdate = true;
                            else objEdit = new GDTTT_DON_TRALOI();
                        }
                        else objEdit = new GDTTT_DON_TRALOI();
                    }
                    catch (Exception ex) { objEdit = new GDTTT_DON_TRALOI(); }

                    objEdit.VUANID = VuAnID;
                    objEdit.DONID = (String.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value);
                    objEdit.DUONGSUID = CurrDSID;
                    objEdit.NGUOINHAN = lttHoTen.Text;
                    objEdit.DIACHINHAN = lttAddress.Text;
                    objEdit.TYPETB = ENUM_LOAITHONGBAO_QH.TBKQTRALOI;
                    objEdit.SO = txtSo.Text.Trim();
                    objEdit.NGAY = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    objEdit.LOAI = LoaiTLD;
                    //objEdit.LOAI " 0:Nguoi khiếu nại/1:Đương su/2:Co quan chuyen don/3:Khac

                    objEdit.GHICHU = txtGhiChu.Text;
                    if (!isupdate)
                        dt.GDTTT_DON_TRALOI.Add(objEdit);
                    try
                    {
                        dt.SaveChanges();
                    }
                    catch (EntityDataSourceValidationException e)
                    {
                        lbthongbao.Text = "Lỗi Entities: " + e.Message;
                    }
                    catch (System.Data.Entity.Validation.DbEntityValidationException ex)
                    {
                        string strErr = "";
                        foreach (var eve in ex.EntityValidationErrors)
                        {
                            foreach (var ve in eve.ValidationErrors)
                            {
                                strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                            }
                        }
                        lbthongbao.Text = "Có lỗi, hãy thử lại: " + strErr;
                    }
                    #endregion
                }
                else
                {
                    #region  Delete
                    if (ThongBaoID > 0)
                    {
                        GDTTT_DON_TRALOI obj = dt.GDTTT_DON_TRALOI.Where(x => x.ID == ThongBaoID).Single();
                        if (obj != null)
                        {
                            dt.GDTTT_DON_TRALOI.Remove(obj);
                            dt.SaveChanges();
                        }
                    }
                    #endregion
                }
            }
            //}
            //else
            //{
            //    #region xoa thong bao tl kq
            //    List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == ENUM_LOAITHONGBAO_QH.TBKQTRALOI).ToList();
            //    if (lst != null && lst.Count > 0)
            //    {
            //        foreach (GDTTT_DON_TRALOI item in lst)
            //            dt.GDTTT_DON_TRALOI.Remove(item);
            //        dt.SaveChanges();
            //    }
            //    #endregion  
            //}
            // }
        }
        void Update_KQTLDon_ADS(Decimal DonID, Decimal VUAN_KETQUA_ID) //anhpn
        {
            //bool IsUpdate = false;
            decimal loai = Convert.ToDecimal(rdbLoai.SelectedValue);
            //decimal v_TYPETB = (int)ENUM_LOAITHONGBAO_QH.TRALOIDON_ADS;
            //if (loai == 1)
            //    v_TYPETB = 4;
            //else
            //    v_TYPETB = 3;
            decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            //List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == v_TYPETB
            //                                                                    && x.DONID == DonID).ToList();
            //if (lst != null && lst.Count > 0)
            //{
            //    oTL = lst[0];
            //    IsUpdate = true;
            //}
            //else oTL = new GDTTT_DON_TRALOI();
            GDTTT_VUAN_KETQUA_DON oTL = new GDTTT_VUAN_KETQUA_DON();
            List<GDTTT_VUAN_KETQUA_DON> lst = new List<GDTTT_VUAN_KETQUA_DON>();
            //var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(DonID);
            var obj = DataExtensions.GetAllByDonId<GDTTT_VUAN_KETQUA_DON>(DonID);
            if (obj != null && obj.Count > 0)
            {
                lst = obj.Where(o => o.TRANGTHAI == 1).ToList();
            }
            if (lst != null && lst.Count > 0)
            {
                oTL = lst[0];
                //IsUpdate = true;
            }
            else oTL = new GDTTT_VUAN_KETQUA_DON();

            oTL.VUAN_KETQUA_ID = VUAN_KETQUA_ID;
            oTL.TYPETB = loai;
            oTL.DONID = DonID;
            oTL.LOAI = loai; //nguoi khieu nai
            oTL.TRANGTHAI = 1;
            oTL.NGAYTAO = DateTime.Now;
            oTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            if (loai == 1)//KN
            {
                oTL.SO = txtSoQD.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.THAMQUYENXXGDT = ddlThamquyenXX.SelectedItem + "";
                oTL.NGUOIKY = txtKN_NguoiKy.Text.Trim();
                oTL.NOIDUNGKHANGNGHI = txtKN_Noidung.Text.Trim();
            }
            if (loai == 0)//TLD
            {
                oTL.SO = txtTLD_So.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = txtTLD_NguoiKy.Text.Trim();
            }
            if (loai == 2)//XD
            {
                oTL.SO = txtSoXepDon.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtNgayXepDon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = txtNguoiDuyetXepDon.Text.Trim();
            }
            if (loai == 3)//XLK
            {
                oTL.SO = txt_xlk_so.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = txtKN_NguoiKy_xlk.Text.Trim();
            }
            if (loai == 4)//VKS
            {
                oTL.SO = txtTB_So.Text;
                oTL.NGAY = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oTL.NGUOIKY = txtTB_NguoiKy.Text.Trim();
            }
            oTL.NGAYPHATHANH = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oTL.GHICHU = txtGhichu.Text.Trim();
            try
            {
                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();
                if (oDon.LOAIDON == 6 || oDon.LOAIDON == 9)
                {
                    oTL.NGUOINHAN = oDon.CV_TENDONVI;
                    oTL.DIACHINHAN = oDon.CV_DIACHI;
                }
                else
                {
                    oTL.NGUOINHAN = oDon.NGUOIGUI_HOTEN;
                    oTL.DIACHINHAN = oDon.NGUOIGUI_DIACHI;
                }
                
            }
            catch (Exception ex)
            {
                if (DonID == 0)
                    oTL.NGUOINHAN = "Tất cả";
            }
            //if (!IsUpdate)
            //{
            //    dt.GDTTT_DON_TRALOI.Add(oTL);
            //}
            //dt.SaveChanges();
            obl.GDTTT_VUAN_KETQUA_DON_INS_UPD(oTL);
        }
        //public void GetDon()
        //{
        //    dropDon.ClearSelection();
        //    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();
        //    DataTable tbl = oNDBL.QT_NGUOIDUNG_GETBYGDTTT(ToaAnID, 0, 0);
        //    if (tbl != null && tbl.Rows.Count > 0)
        //    {
        //        dropDon.DataSource = tbl;
        //        dropDon.DataTextField = "USERNAME";
        //        dropDon.DataValueField = "USERNAME";
        //        dropDon.DataBind();
        //    }
        //}
        void LoadDropDonThuLyMoi(string donid)
        {
            /* CD_TRANGTHAI   when 1 then  'Da chuyen'
                            when 2 then  'Da nhan' 
                            when 3 then  'Bi tra lai' 
                            else 'Chua chuyen'                            
            ISTHULY when 1: 'thu ly moi', 2:'da thu ly'*/
            dropDon.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                    && x.CD_TRANGTHAI == 2
                                                    && x.ISTHULY == 1).ToList();
            var DonID = Convert.ToDecimal(donid);
            if (!string.IsNullOrEmpty(donid))
            {
                lst = dt.GDTTT_DON.Where(x => x.ID == DonID
                                                    && x.CD_TRANGTHAI == 2
                                                    && x.ISTHULY == 1).ToList();
            }
            var checkcodon = false;
            if (lst != null && lst.Count > 0)
            {
                String temp = "";
                ListItem item = new ListItem();
                foreach (GDTTT_DON obj in lst)
                {
                    temp = (String.IsNullOrEmpty(obj.TL_SO + "")) ? "" : "Số TL " + obj.TL_SO;
                    temp += (String.IsNullOrEmpty(obj.TL_NGAY + "") || (obj.TL_NGAY == DateTime.MinValue)) ? "" : " Ngày TL " + ((DateTime)obj.TL_NGAY).ToString("dd/MM/yyyy", cul);

                    //--------------------------
                    item = new ListItem();
                    if (obj.LOAIDON == 6 || obj.LOAIDON == 9)
                    {
                        item.Text = obj.CV_TENDONVI + (String.IsNullOrEmpty(temp) ? "" : " (" + temp + ")");
                    }
                    else
                    {
                        item.Text = obj.NGUOIGUI_HOTEN + (String.IsNullOrEmpty(temp) ? "" : " (" + temp + ")");
                    }
                    
                    item.Value = obj.ID.ToString();
                    //- Nếu đơn này chưa có kết quả thì hiển thị ra--
                    //List<GDTTT_DON_TRALOI> lstKQTLD = dt.GDTTT_DON_TRALOI.Where(x => x.DONID == obj.ID).ToList();
                    //if (lstKQTLD.Count == 0 || donid != null)
                    //    dropDon.Items.Add(item);
                    var lstKQTLD = obl.GDTTT_VUAN_KETQUA_DON_GETBYDONID(obj.ID);
                    if ((lstKQTLD != null && lstKQTLD.Rows.Count == 0) || donid != null)
                    {
                        dropDon.Items.Add(item);
                        checkcodon = true;
                    }
                }
                if (checkcodon == true)
                {
                    dropDon.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
        }
        //protected void cmdXoa_Click(object sender, EventArgs e)
        //{
        //    string strvid = Request["vid"] + "";
        //    decimal VuAnID = Convert.ToDecimal(strvid);
        //    decimal trangthai_id = 0;
        //    int count_totrinh = 0;
        //    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
        //    if (oVA != null)
        //    {
        //        trangthai_id = (decimal)oVA.TRANGTHAIID;
        //        oVA.GQD_LOAIKETQUA = null;
        //        oVA.GQD_KETQUA = "";
        //        oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
        //        oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
        //        oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
        //        //-------------------
        //        if (trangthai_id != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
        //        {
        //            count_totrinh = (string.IsNullOrEmpty(oVA.ISTOTRINH + "")) ? 0 : (int)oVA.ISTOTRINH;
        //            if (count_totrinh > 0)
        //            {
        //                try
        //                {
        //                    List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTRINH).ToList();
        //                    if (lstTT != null && lstTT.Count > 0)
        //                    {
        //                        GDTTT_TOTRINH objToTrinh = lstTT[0];
        //                        oVA.TRANGTHAIID = objToTrinh.TINHTRANGID;
        //                    }
        //                    else
        //                        SetTrangThai(oVA);
        //                }
        //                catch (Exception ex)
        //                {
        //                    SetTrangThai(oVA);
        //                }
        //            }
        //            else SetTrangThai(oVA);
        //        }

        //        //------------------------------
        //        dt.SaveChanges();
        //        Xoa_ThongBaoTraLoiCV(VuAnID);
        //        //------------------------------

        //        ClearForm();
        //        lbthongbao.ForeColor = System.Drawing.Color.Blue;
        //        lbthongbao.Text = "Xóa kết quả giải quyết đơn thành công!";
        //        cmdXoa.Visible = false;
        //        Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        //    }
        //}
        protected void cmdXoa_Click(object sender, EventArgs e)//anhpn
        {
            XoaKQGiaiQuyetDon();
            LoadDropDonThuLyMoi(null);
            ClearForm();
        }
        void XoaKQGiaiQuyetDon()//anhpn
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            decimal trangthai_id = 0;
            int count_totrinh = 0;
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVA != null)
            {
                trangthai_id = (decimal)oVA.TRANGTHAIID;
                //-------------------
                if (trangthai_id != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
                {
                    oVA.GQD_LOAIKETQUA = null;
                    oVA.GQD_KETQUA = "";
                    oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                    oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                    oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                    count_totrinh = (string.IsNullOrEmpty(oVA.ISTOTRINH + "")) ? 0 : (int)oVA.ISTOTRINH;
                    if (count_totrinh > 0)
                    {
                        try
                        {
                            List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTRINH).ToList();
                            if (lstTT != null && lstTT.Count > 0)
                            {
                                GDTTT_TOTRINH objToTrinh = lstTT[0];
                                oVA.TRANGTHAIID = objToTrinh.TINHTRANGID;
                            }
                            else
                                SetTrangThai(oVA);
                        }
                        catch (Exception ex)
                        {
                            SetTrangThai(oVA);
                        }
                    }
                    else SetTrangThai(oVA);

                    //------------------------------
                    dt.SaveChanges();
                    XoaBangVuAnTraLoi();
                    XoaToanBoTraLoiDon();
                    Xoa_ThongBaoTraLoiCV(VuAnID);
                    //------------------------------
                    ClearForm();
                    LoadDSTraLoiDon_ADS();
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Xóa kết quả giải quyết đơn thành công!";
                    cmdXoa.Visible = false;
                    //rdbLoai.Enabled = true;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                }
                else
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Blue;
                    lbthongbao.Text = "Vụ án đang ở giai đoạn 'Thụ lý xét xử GDTTT'. Không được phép xóa kết quả giải quyết đơn!";
                }
            }
        }
        void Xoa_ThongBaoTraLoiCV(decimal VuAnID)
        {
            try
            {
                List<GDTTT_DON_TRALOI> lst = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == 2).ToList();
                if (lst != null && lst.Count > 0)
                {
                    foreach (GDTTT_DON_TRALOI it in lst)
                        dt.GDTTT_DON_TRALOI.Remove(it);
                    dt.SaveChanges();
                }
                LoadDSTraloidon(VuAnID);
            }
            catch (Exception ex) { }
        }
        void XoaBangVuAnTraLoi() //anhpn
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            var lst = oVAKQ.GDTTT_VUAN_KETQUA_GETBYID(VuAnID);
            if (lst != null && lst.Rows.Count > 0)
            {
                foreach (DataRow row in lst.Rows)
                {
                    oVAKQ.GDTTT_VUAN_KETQUA_UP_TT(Convert.ToDecimal(row["ID"]), 0);
                }
            }
        }
        void XoaToanBoTraLoiDon() //anhpn
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            var lst = obl.GDTTT_VUAN_KETQUA_DON_GETBYVUANID(VuAnID);
            if (lst != null && lst.Rows.Count > 0)
            {
                foreach (DataRow row in lst.Rows)
                {
                    obl.GDTTT_VUAN_KETQUA_DON_UP_TT(Convert.ToDecimal(row["ID"]), 0);
                    oVAKQ.GDTTT_VUAN_KETQUA_UP_TT(Convert.ToDecimal(row["VUAN_KETQUA_ID"]), 0);
                }
            }
            LoadDSTraLoiDon_ADS();
        }
        void XoaTraLoiDon(Decimal CurrID) //anhpn
        {
            decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
            var lst = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
            if (lst != null && lst.Rows.Count > 0)
            {
                foreach (DataRow row in lst.Rows)
                {
                    obl.GDTTT_VUAN_KETQUA_DON_UP_TT(Convert.ToDecimal(row["ID"]), 0);

                    //Kiểm tra nếu còn kết quả trả lời gắn với vụ án thì ko cập nhật trạng thái 
                    //ngược lại thì cập nhật lại trạng thái bảng GDTTT_VUAN_KETQUA = 0
                    //var checkKetQuaDon = obl.GDTTT_VUAN_KETQUA_DON_GETBYVUANID(VuAnID);
                    //if (checkKetQuaDon != null && checkKetQuaDon.Rows.Count == 0)
                    //{
                    // cập nhật trạng thái bảng GDTTT_VUAN_KETQUA
                    var ID = Convert.ToDecimal(row["VUAN_KETQUA_ID"]);
                    oVAKQ.GDTTT_VUAN_KETQUA_UP_TT(ID, 0);
                    //}
                }
            }
            var Ckn = obl.GDTTT_VUAN_KETQUA_DON_GETBYVUANID(VuAnID);
            if (Ckn != null && Ckn.Rows.Count == 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                oVA.GQD_LOAIKETQUA = null;
                oVA.GQD_KETQUA = "";
                oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                dt.SaveChanges();
            }
            ////Kiem tra kết quả này có phải KN không, nếu là KhangNghi thì cần kiểm tra để cập nhật lại Trạng thái Vụ án.
            //var Ckn = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 4);
            //// Nếu vẫn còn kết quả KN khác thì không cho xóa
            //if (Ckn != null && Ckn.Rows.Count > 0)
            //{
            //    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            //    oVA.GQD_LOAIKETQUA = null;
            //    oVA.GQD_KETQUA = "";
            //    oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
            //    oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
            //    oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;

            //    // cập nhật lại trạng thái Vụ an khi còn kết quả trả lời đơn 
            //    //List<GDTTT_DON_TRALOI> CTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 0).ToList();
            //    //List<GDTTT_DON_TRALOI> CXD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 2).ToList();
            //    //List<GDTTT_DON_TRALOI> CXLK = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID & x.TYPETB == 3).ToList();
            //    var CTLD = obl.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(VuAnID, 3);
            //    if (CTLD != null && CTLD.Rows.Count > 0)
            //    {
            //        oVA.TRANGTHAIID = 13;
            //        oVA.GQD_LOAIKETQUA = 0;
            //        oVA.GQD_KETQUA = "Trả lời đơn";
            //    }
            //    dt.SaveChanges();
            //}
            var list = obl.GDTTT_VUAN_KETQUA_DON_GETBYVUANID(VuAnID);
            if (list != null && list.Rows.Count > 0)
            {
                ClearForm();
                lbthongbao.ForeColor = System.Drawing.Color.Blue;
                lbthongbao.Text = "Xóa trả lời đơn thành công!";
            }
            else
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                Decimal trangthai_id = (decimal)oVA.TRANGTHAIID;
                oVA.GQD_LOAIKETQUA = null;
                oVA.GQD_KETQUA = "";
                oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                oVA.NGUOIKHANGNGHI = oVA.THAMQUYENXXGDT = 0;
                oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                //-------------------
                if (trangthai_id != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
                {
                    Decimal count_totrinh = (string.IsNullOrEmpty(oVA.ISTOTRINH + "")) ? 0 : (int)oVA.ISTOTRINH;
                    if (count_totrinh > 0)
                    {
                        try
                        {
                            List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTRINH).ToList();
                            if (lstTT != null && lstTT.Count > 0)
                            {
                                GDTTT_TOTRINH objToTrinh = lstTT[0];
                                oVA.TRANGTHAIID = objToTrinh.TINHTRANGID;
                            }
                            else
                                SetTrangThai(oVA);
                        }
                        catch (Exception ex)
                        {
                            SetTrangThai(oVA);
                        }
                    }
                    else SetTrangThai(oVA);
                }

                //------------------------------
                dt.SaveChanges();
                Xoa_ThongBaoTraLoiCV(VuAnID);
                //------------------------------
                ClearForm();
                lbthongbao.ForeColor = System.Drawing.Color.Blue;
                lbthongbao.Text = "Xóa kết quả giải quyết đơn thành công!";
                cmdXoa.Visible = false;
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }

            #region update loai vao bang GDTTT_VUAN
            // kiểm tra xem ngày tạo lớn nhất thì update trạng thái cập nhật vào bảng vụ án
            List<GDTTT_VUAN_KETQUA> lstVUAN_KETQUA = new List<GDTTT_VUAN_KETQUA>();
            var checktrangthai = oVAKQ.GDTTT_VUAN_KETQUA_GETBYVUANID(VuAnID);
            if (checktrangthai != null && checktrangthai.Rows.Count > 0)
            {
                foreach (DataRow row in checktrangthai.Rows)
                {
                    GDTTT_VUAN_KETQUA input = new GDTTT_VUAN_KETQUA();
                    input.ID = Convert.ToDecimal(row["ID"]);
                    input.VUANID = Convert.ToDecimal(row["VUANID"]);
                    input.TRANGTHAI = Convert.ToInt16(row["TRANGTHAI"]);
                    if (!row.IsNull("NOIDUNGKHANGNGHI"))
                    {
                        input.NOIDUNGKHANGNGHI = (row["NOIDUNGKHANGNGHI"].ToString());
                    }
                    input.TOAAN_ID = Convert.ToDecimal(row["TOAAN_ID"]);
                    input.CAPNHATVUAN = Convert.ToDecimal(row["CAPNHATVUAN"]);
                    if (!row.IsNull("NGUOIKHANGNGHI"))
                    {
                        input.NGUOIKHANGNGHI = Convert.ToDecimal(row["NGUOIKHANGNGHI"]);
                    }
                    if (!row.IsNull("GQD_LOAIKETQUA"))
                    {
                        input.GQD_LOAIKETQUA = Convert.ToDecimal(row["GQD_LOAIKETQUA"]);
                    }
                    if (!row.IsNull("GQD_KETQUA"))
                    {
                        input.GQD_KETQUA = Convert.ToString(row["GQD_KETQUA"]);
                    }
                    if (!row.IsNull("GDQ_SO"))
                    {
                        input.GDQ_SO = (row["GDQ_SO"].ToString());
                    }
                    if (!row.IsNull("GDQ_NGAY"))
                    {
                        input.GDQ_NGAY = Convert.ToDateTime(row["GDQ_NGAY"]);
                    }
                    if (!row.IsNull("GDQ_NGUOIKY"))
                    {
                        input.GDQ_NGUOIKY = (row["GDQ_NGUOIKY"].ToString());
                    }
                    if (!row.IsNull("THAMQUYENXXGDT"))
                    {
                        input.THAMQUYENXXGDT = Convert.ToDecimal(row["THAMQUYENXXGDT"]);
                    }
                    if (!row.IsNull("QUATRINH_GHICHU"))
                    {
                        input.QUATRINH_GHICHU = (row["QUATRINH_GHICHU"].ToString());
                    }
                    if (!row.IsNull("GQD_GHICHU"))
                    {
                        input.GQD_GHICHU = (row["GQD_GHICHU"].ToString());
                    }
                    if (!row.IsNull("GQD_ISHOANTHA"))
                    {
                        input.GQD_ISHOANTHA = Convert.ToDecimal(row["GQD_ISHOANTHA"]);
                    }
                    if (!row.IsNull("GQD_HOANTHA_NGUOIKYID"))
                    {
                        input.GQD_HOANTHA_NGUOIKYID = Convert.ToDecimal(row["GQD_HOANTHA_NGUOIKYID"]);
                    }
                    if (!row.IsNull("GQD_HOANTHA_NGAY"))
                    {
                        input.GQD_HOANTHA_NGAY = DateTime.Parse(row["GQD_HOANTHA_NGAY"].ToString());
                    }
                    if (!row.IsNull("GQD_HOANTHA_SO"))
                    {
                        input.GQD_HOANTHA_SO = (row["GQD_HOANTHA_SO"].ToString());
                    }
                    if (!row.IsNull("GQD_NGAYPHATHANHCV"))
                    {
                        input.GQD_NGAYPHATHANHCV = DateTime.Parse(row["GQD_NGAYPHATHANHCV"].ToString());
                    }
                    if (!row.IsNull("NGAYTAO"))
                    {
                        input.NGAYTAO = DateTime.Parse(row["NGAYTAO"].ToString());
                    }
                    lstVUAN_KETQUA.Add(input);
                }
            }
            if (lstVUAN_KETQUA != null && lstVUAN_KETQUA.Count > 0)
            {
                lstVUAN_KETQUA = lstVUAN_KETQUA.OrderByDescending(o => o.NGAYTAO).ToList();
                for (int i = 0; i < lstVUAN_KETQUA.Count(); i++)
                {
                    if (i == 0)
                    {
                        lstVUAN_KETQUA[i].CAPNHATVUAN = 1;
                        var VUANID = lstVUAN_KETQUA[i].VUANID;
                        oVAKQ.GDTTT_VUAN_KETQUA_CAPNHATVUAN(lstVUAN_KETQUA[i].ID, lstVUAN_KETQUA[i].CAPNHATVUAN);

                        GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                        oVA.GQD_LOAIKETQUA = lstVUAN_KETQUA[i].GQD_LOAIKETQUA;
                        if (oVA.GQD_LOAIKETQUA.Value == 0)
                        {
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
                        }
                        else if (oVA.GQD_LOAIKETQUA.Value == 1)
                        {
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
                        }
                        else if (oVA.GQD_LOAIKETQUA.Value == 2)
                        {
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                        }
                        else if (oVA.GQD_LOAIKETQUA.Value == 3)
                        {
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                        }
                        else if (oVA.GQD_LOAIKETQUA.Value == 4)
                        {
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON_VKS_DANGGIAIQUYET;
                        }
                        oVA.GQD_KETQUA = lstVUAN_KETQUA[i].GQD_KETQUA;
                        oVA.GDQ_SO = lstVUAN_KETQUA[i].GDQ_SO;
                        oVA.GDQ_NGUOIKY = lstVUAN_KETQUA[i].GDQ_NGUOIKY;
                        oVA.GQD_GHICHU = lstVUAN_KETQUA[i].GQD_GHICHU;
                        oVA.NGUOIKHANGNGHI = lstVUAN_KETQUA[i].NGUOIKHANGNGHI;
                        oVA.THAMQUYENXXGDT = lstVUAN_KETQUA[i].THAMQUYENXXGDT;
                        oVA.GDQ_NGAY = lstVUAN_KETQUA[i].GDQ_NGAY;
                        oVA.GQD_NGAYPHATHANHCV = lstVUAN_KETQUA[i].GQD_NGAYPHATHANHCV;
                        dt.SaveChanges();

                        //GDTTT_VUAN updateVA = dt.GDTTT_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();
                        //switch (lstVUAN_KETQUA[i].GQD_LOAIKETQUA.ToString())
                        //{
                        //    case "0":
                        //        updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON;
                        //        break;
                        //    case "1":
                        //        updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;
                        //        break;
                        //    case "2":
                        //        updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                        //        break;
                        //    case "3":
                        //        updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                        //        break;
                        //    case "4":
                        //        updateVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON_VKS_DANGGIAIQUYET;
                        //        break;
                        //}
                        //dt.SaveChanges();
                    }
                    else
                    {
                        lstVUAN_KETQUA[i].CAPNHATVUAN = 0;
                        oVAKQ.GDTTT_VUAN_KETQUA_CAPNHATVUAN(lstVUAN_KETQUA[i].ID, lstVUAN_KETQUA[i].CAPNHATVUAN);
                    }
                }
            }
            #endregion
            LoadDSTraLoiDon_ADS();
        }
        GDTTT_VUAN SetTrangThai(GDTTT_VUAN oVA)
        {
            oVA.ISTOTRINH = 0;
            decimal THAMTRAVIENID = (string.IsNullOrEmpty(oVA.THAMTRAVIENID + "")) ? 0 : (decimal)oVA.THAMTRAVIENID;
            if (THAMTRAVIENID > 0)
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
            else
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
            return oVA;
        }
        void ClearForm()
        {
            //rdbLoai.SelectedValue = "0";
            pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
            pnTLD.Visible = true;
            if (rdbLoai.SelectedValue == "0")
            {
                pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                pnTLD.Visible = true;
                rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;
                rdbLoai.Items[4].Enabled = false;
            }
            else if (rdbLoai.SelectedValue == "1")
            {
                pnVKS_GQ.Visible = pnTLD.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                pnQDKN.Visible = true;
                rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;
                rdbLoai.Items[4].Enabled = false;
            }
            else if (rdbLoai.SelectedValue == "2")
            {
                pnVKS_GQ.Visible = pnTLD.Visible = pnQDKN.Visible = pnXuLyKhac.Visible = false;
                pnXepDon.Visible = true;
                rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;
                rdbLoai.Items[4].Enabled = false;
            }
            else if (rdbLoai.SelectedValue == "3")
            {
                pnVKS_GQ.Visible = pnTLD.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
                pnXuLyKhac.Visible = true;
                rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;
                rdbLoai.Items[4].Enabled = false;
            }
            else if (rdbLoai.SelectedValue == "4")
            {
                pnXuLyKhac.Visible = pnTLD.Visible = pnQDKN.Visible = pnXepDon.Visible = false;
                pnVKS_GQ.Visible = true;
                rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = false;
            }

            txtGQD_NgayCV.Text = txtTLD_So.Text = txtTLD_Ngay.Text = txtTLD_NguoiKy.Text = txtKN_Noidung.Text = "";

            txtSoQD.Text = txtNgayQD.Text = txtKN_NguoiKy.Text = "";
            txtTB_So.Text = txtTB_Ngay.Text = txtTB_NguoiKy.Text = "";
            try
            {
                ddlThamquyenXX.SelectedIndex = 0;
            }
            catch (Exception exx) { }
            txtTLD_NguoiKy_td.Visible = false;
            txtKN_NguoiKy_td.Visible = false;
            txtNguoiDuyetXepDon_td.Visible = false;
            txtKN_NguoiKy_xlk_td.Visible = false;
            txtTB_NguoiKy_td.Visible = false;

            dropTLD_NguoiKy_td.Visible = true;
            dropKN_NguoiKy_td.Visible = true;
            dropNguoiDuyetXepDon_td.Visible = true;
            DropKN_NguoiKy_xlk_td.Visible = true;
            DropTB_NguoiKy_td.Visible = true;

            LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
            LoadDropNguoiKyTP(dropKN_NguoiKy, null);
            LoadDropNguoiKyXuLyDon(dropNguoiDuyetXepDon, null);
            LoadDropNguoiKyXuLyDon(DropKN_NguoiKy_xlk, null);
            LoadDropNguoiKyXuLyDon(DropTB_NguoiKy, null);

            txtSoXepDon.Text = txtNgayXepDon.Text = txtNguoiDuyetXepDon.Text = "";
            txtGQD_NgayCV.Text = txtGhichu.Text = "";
        }
        void UpdateFile(GDTTT_VUAN obj)
        {
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    if (chkKySo.Checked)
                    {
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath(temp_folder_upload) + strFilePath;
                    }
                    else
                        strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        obj.KQ_NOIDUNGFILE = buff;
                        obj.KQ_TENFILE = oF.Name;
                        obj.KQ_KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { }
            }
        }

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            string loai = rdbLoai.SelectedValue;
            lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";
            pnXuLyKhac.Visible = false;
            switch (loai)
            {
                case "0"://trả lời đơn
                    pnQDKN.Visible = pnXepDon.Visible = pnVKS_GQ.Visible = false;
                    pnTLD.Visible = true;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtTLD_Ngay.Text = string.Empty;
                    //txtTLD_So.Text = string.Empty;

                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "1":// kháng nghị
                    LoadDropThamQuyenXX();
                    pnQDKN.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = pnVKS_GQ.Visible = false;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtNgayQD.Text = string.Empty;
                    //txtSoQD.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "2":// xếp đơn
                    pnXepDon.Visible = true;
                    pnQDKN.Visible = pnTLD.Visible = pnVKS_GQ.Visible = false;

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtNgayXepDon.Text = string.Empty;
                    //txtSoXepDon.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "3":// xử lý khác
                    pnXuLyKhac.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = pnVKS_GQ.Visible = false;
                    lbl_GQD_NgayCV.Text = "Ngày xử lý";

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txt_xlk_so.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa VKS
                    #region xóa VKS
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTB_Ngay.Text = string.Empty;
                    txtTB_So.Text = string.Empty;
                    #endregion
                    break;
                case "4": //VKS
                    pnXuLyKhac.Visible = pnTLD.Visible = pnXepDon.Visible = pnQDKN.Visible = false;
                    pnVKS_GQ.Visible = true;
                    lbl_GQD_NgayCV.Text = "Ngày phát hành của Vụ";

                    //txtGQD_NgayCV.Text = string.Empty;
                    //txtTB_Ngay.Text = string.Empty;
                    //txtTB_So.Text = string.Empty;

                    //xóa trả lời đơn
                    #region xóa trả lời đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtTLD_Ngay.Text = string.Empty;
                    txtTLD_So.Text = string.Empty;
                    #endregion
                    //xóa kháng nghị
                    #region xóa kháng nghị
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayQD.Text = string.Empty;
                    txtSoQD.Text = string.Empty;
                    #endregion
                    //xóa xếp đơn
                    #region xóa xếp đơn
                    txtGQD_NgayCV.Text = string.Empty;
                    txtNgayXepDon.Text = string.Empty;
                    txtSoXepDon.Text = string.Empty;
                    #endregion
                    //xóa xử lý khác
                    #region xóa xử lý khác
                    txtGQD_NgayCV.Text = string.Empty;
                    txt_xlk_so.Text = string.Empty;
                    #endregion
                    break;
            }
        }
        //-----------------------------
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
                {
                    string strFileName = Cls_Comon.ChuyenTenFileUpload(AsyncFileUpLoad.FileName);
                    string path = Server.MapPath(temp_folder_upload) + strFileName;
                    AsyncFileUpLoad.SaveAs(path);
                    path = path.Replace("\\", "/");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                }
            }
            catch (Exception ex) { }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oND = dt.GDTTT_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.KQ_TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.KQ_NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.KQ_TENFILE + "&Extension=" + oND.KQ_KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void txtHTA_Ngay_TextChanged(object sender, EventArgs e)
        {
            try
            {
                string strvid = Request["vid"] + "";
                decimal VuAnID = Convert.ToDecimal(strvid);
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                if (oVA.LOAIAN != null)
                {
                    decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                    decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal so_ = 0;
                    lbthongbao.Text = "";
                    //string loai = rdbLoai.SelectedValue;
                    so_ = oBL.HoanTHA_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtHTA_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString());
                    txtHTA_So.Text = Convert.ToString(so_);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtTLD_Ngay_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtTLD_So.Text = Convert.ToString(so_);
                    }
                }

            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtSoQD.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtNgayXepDon_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtNgayXepDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtSoXepDon.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtGQD_NgayCV_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txt_xlk_so.Text = Convert.ToString(so_);
                    }
                }

            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        protected void txtTB_Ngay_TextChanged(object sender, EventArgs e)
        {
            //SetNgayCV(txtTLD_So, txtTLD_Ngay);
            try
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (CurrDonViID != 1)
                {
                    string strvid = Request["vid"] + "";
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                    string loaiso = rdbLoai.SelectedValue;

                    if (oVA.LOAIAN != null)
                    {

                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal so_ = 0;
                        lbthongbao.Text = "";
                        //string loai = rdbLoai.SelectedValue;
                        so_ = oBL.SoTraLoi_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtTB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString(), loaiso);
                        txtTB_So.Text = Convert.ToString(so_);
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        //protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        //{
        //    SetNgayCV(txtSoQD, txtNgayQD);
        //}
        void SetNgayCV(TextBox control_so, TextBox control_ngay)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime ngay = (DateTime)((String.IsNullOrEmpty(control_ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(control_ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastGQD_SoCV(PhongBanID, ngay);
            control_so.Text = SoCV + "";
        }
        protected void rptKhangNghi_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_KQKN(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_KQKN(Decimal CurrID) //anhpnrow["ID"]
        {
            try
            {
                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
                if (obj != null && obj.Rows.Count > 0)
                {
                    foreach (DataRow item in obj.Rows)
                    {
                        txtSoQD.Text = txtTLD_So.Text = item["SO"] + "";
                        String ngay_temp = (String.IsNullOrEmpty(item["NGAY"] + "")) ? "" : ((DateTime)item["NGAY"]).ToString("dd/MM/yyyy", cul);
                        txtNgayQD.Text = txtTLD_Ngay.Text = ngay_temp;

                        ngay_temp = (String.IsNullOrEmpty(item["NGAYPHATHANH"] + "")) ? "" : ((DateTime)item["NGAYPHATHANH"]).ToString("dd/MM/yyyy", cul);
                        txtGQD_NgayCV.Text = ngay_temp;
                        txtGhichu.Text = item["GHICHU"] + "";
                        txtKN_Noidung.Text = item["NOIDUNGKHANGNGHI"] + "";
                        txtKN_NguoiKy.Text = item["NGUOIKY"] + "";
                        if (!string.IsNullOrEmpty(txtKN_NguoiKy.Text))
                        {
                            txtKN_NguoiKy_td.Visible = true;
                            dropKN_NguoiKy_td.Visible = false;
                        }
                        else
                        {
                            txtKN_NguoiKy_td.Visible = false;
                            dropKN_NguoiKy_td.Visible = true;
                            LoadDropNguoiKyTP(dropKN_NguoiKy, null);
                        }
                        LoadDropDonThuLyMoi(item["DONID"] + "");
                        Cls_Comon.SetValueComboBox(dropDon, item["DONID"]);
                        rdbLoai.SelectedValue = "1";

                        LoadDropThamQuyenXX();
                        var objVAKQ = oVAKQ.GDTTT_VUAN_KETQUA_GETBYID(decimal.Parse((item["VUAN_KETQUA_ID"]).ToString()));
                        if (objVAKQ != null && objVAKQ.Rows.Count > 0)
                        {
                            foreach (DataRow itemVAKQ in objVAKQ.Rows)
                            {
                                if (!string.IsNullOrEmpty(itemVAKQ["THAMQUYENXXGDT"] + "")) ddlThamquyenXX.SelectedValue = itemVAKQ["THAMQUYENXXGDT"] + "";
                            }
                        }

                        if (item["NGUOIKY"].ToString() == "Tòa án nhân dân tối cao")
                            Cls_Comon.SetValueComboBox(ddlThamquyenXX, 1);
                        else if (item["NGUOIKY"].ToString() == "Tòa án nhân dân cấp cao tại Hà Nội")
                            Cls_Comon.SetValueComboBox(ddlThamquyenXX, 4);
                        else if (item["NGUOIKY"].ToString() == "Tòa án nhân dân cấp cao tại Đà Nẵng")
                            Cls_Comon.SetValueComboBox(ddlThamquyenXX, 5);
                        else if (item["NGUOIKY"].ToString() == "Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh")
                            Cls_Comon.SetValueComboBox(ddlThamquyenXX, 6);
                    }

                    pnQDKN.Visible = true;
                    //pnDon.Visible = true;
                    pnTLD.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = pnVKS_GQ.Visible = false;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void rptTraLoiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_TraLoiDon(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_TraLoiDon(Decimal CurrID) //anhpn
        {
            try
            {
                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
                if (obj != null && obj.Rows.Count > 0)
                {
                    foreach (DataRow item in obj.Rows)
                    {
                        txtSoQD.Text = txtTLD_So.Text = item["SO"] + "";
                        String ngay_temp = (String.IsNullOrEmpty(item["NGAY"] + "")) ? "" : ((DateTime)item["NGAY"]).ToString("dd/MM/yyyy", cul);
                        txtNgayQD.Text = txtTLD_Ngay.Text = ngay_temp;

                        ngay_temp = (String.IsNullOrEmpty(item["NGAYPHATHANH"] + "")) ? "" : ((DateTime)item["NGAYPHATHANH"]).ToString("dd/MM/yyyy", cul);
                        txtGQD_NgayCV.Text = ngay_temp;
                        txtGhichu.Text = item["GHICHU"] + "";
                        txtTLD_NguoiKy.Text = item["NGUOIKY"] + "";
                        if (!string.IsNullOrEmpty(txtTLD_NguoiKy.Text))
                        {
                            txtTLD_NguoiKy_td.Visible = true;
                            dropTLD_NguoiKy_td.Visible = false;
                        }
                        else
                        {
                            txtTLD_NguoiKy_td.Visible = false;
                            dropTLD_NguoiKy_td.Visible = true;
                            LoadDropNguoiKyTP(dropTLD_NguoiKy, null);
                        }
                        LoadDropDonThuLyMoi(item["DONID"] + "");
                        Cls_Comon.SetValueComboBox(dropDon, item["DONID"]);
                        //rdbLoai.SelectedValue = "0";
                        rdbLoai.SelectedValue = item["LOAI"] + "";

                    }

                    pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                    pnTLD.Visible = true;
                    pnDon.Visible = true;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void rptXepDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_XepDon(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_XepDon(Decimal CurrID) //anhpn
        {
            try
            {
                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
                if (obj != null && obj.Rows.Count > 0)
                {
                    foreach (DataRow item in obj.Rows)
                    {
                        txtSoXepDon.Text = txtTLD_So.Text = item["SO"] + "";
                        String ngay_temp = (String.IsNullOrEmpty(item["NGAY"] + "")) ? "" : ((DateTime)item["NGAY"]).ToString("dd/MM/yyyy", cul);
                        txtNgayXepDon.Text = txtTLD_Ngay.Text = ngay_temp;

                        ngay_temp = (String.IsNullOrEmpty(item["NGAYPHATHANH"] + "")) ? "" : ((DateTime)item["NGAYPHATHANH"]).ToString("dd/MM/yyyy", cul);
                        txtGQD_NgayCV.Text = ngay_temp;
                        txtGhichu.Text = item["GHICHU"] + "";
                        txtNguoiDuyetXepDon.Text = item["NGUOIKY"] + "";
                        if (!string.IsNullOrEmpty(txtNguoiDuyetXepDon.Text))
                        {
                            txtNguoiDuyetXepDon_td.Visible = true;
                            dropNguoiDuyetXepDon_td.Visible = false;
                        }
                        else
                        {
                            txtNguoiDuyetXepDon_td.Visible = false;
                            dropNguoiDuyetXepDon_td.Visible = true;
                            LoadDropNguoiKyXuLyDon(dropNguoiDuyetXepDon, null);
                        }
                        LoadDropDonThuLyMoi(item["DONID"] + "");
                        Cls_Comon.SetValueComboBox(dropDon, item["DONID"]);
                        //rdbLoai.SelectedValue = "0";
                        rdbLoai.SelectedValue = item["LOAI"] + "";

                    }

                    pnVKS_GQ.Visible = pnQDKN.Visible = pnTLD.Visible = pnXuLyKhac.Visible = false;
                    pnXepDon.Visible = true;
                    pnDon.Visible = true;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void rptXuLyKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_XuLyKhac(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_XuLyKhac(Decimal CurrID) //anhpn
        {
            try
            {
                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
                if (obj != null && obj.Rows.Count > 0)
                {
                    foreach (DataRow item in obj.Rows)
                    {
                        txt_xlk_so.Text = txtTLD_So.Text = item["SO"] + "";
                        String ngay_temp = (String.IsNullOrEmpty(item["NGAY"] + "")) ? "" : ((DateTime)item["NGAY"]).ToString("dd/MM/yyyy", cul);
                        txtNgayQD.Text = txtTLD_Ngay.Text = ngay_temp;

                        ngay_temp = (String.IsNullOrEmpty(item["NGAYPHATHANH"] + "")) ? "" : ((DateTime)item["NGAYPHATHANH"]).ToString("dd/MM/yyyy", cul);
                        txtGQD_NgayCV.Text = ngay_temp;
                        txtGhichu.Text = item["GHICHU"] + "";
                        var objVAKQ = oVAKQ.GDTTT_VUAN_KETQUA_GETBYID(decimal.Parse((item["VUAN_KETQUA_ID"]).ToString()));
                        if (objVAKQ != null && objVAKQ.Rows.Count > 0)
                        {
                            foreach (DataRow itemVAKQ in objVAKQ.Rows)
                            {
                                txtNoiDung_xlk.Text = itemVAKQ["GQD_KETQUA"] + "";
                            }
                        }
                        txtKN_NguoiKy_xlk.Text = item["NGUOIKY"] + "";
                        if (!string.IsNullOrEmpty(txtKN_NguoiKy_xlk.Text))
                        {
                            txtKN_NguoiKy_xlk_td.Visible = true;
                            DropKN_NguoiKy_xlk_td.Visible = false;
                        }
                        else
                        {
                            txtKN_NguoiKy_xlk_td.Visible = false;
                            DropKN_NguoiKy_xlk_td.Visible = true;
                            LoadDropNguoiKyXuLyDon(DropKN_NguoiKy_xlk, null);
                        }
                        LoadDropDonThuLyMoi(item["DONID"] + "");
                        Cls_Comon.SetValueComboBox(dropDon, item["DONID"]);
                        //rdbLoai.SelectedValue = "0";
                        rdbLoai.SelectedValue = item["LOAI"] + "";

                    }

                    pnVKS_GQ.Visible = pnQDKN.Visible = pnXepDon.Visible = pnTLD.Visible = false;
                    pnXuLyKhac.Visible = true;
                    pnDon.Visible = true;
                    rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void rptVKS_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    Load_VKS(curr_id);
                    break;
                case "Xoa":
                    XoaTraLoiDon(curr_id);
                    LoadDropDonThuLyMoi(null);
                    break;
            }
        }
        void Load_VKS(Decimal CurrID) //anhpn
        {
            try
            {
                var obj = obl.GDTTT_VUAN_KETQUA_DON_GETBYID(CurrID);
                if (obj != null && obj.Rows.Count > 0)
                {
                    foreach (DataRow item in obj.Rows)
                    {
                        txtTB_So.Text = txtTLD_So.Text = item["SO"] + "";
                        String ngay_temp = (String.IsNullOrEmpty(item["NGAY"] + "")) ? "" : ((DateTime)item["NGAY"]).ToString("dd/MM/yyyy", cul);
                        txtTB_Ngay.Text = txtTLD_Ngay.Text = ngay_temp;

                        ngay_temp = (String.IsNullOrEmpty(item["NGAYPHATHANH"] + "")) ? "" : ((DateTime)item["NGAYPHATHANH"]).ToString("dd/MM/yyyy", cul);
                        txtGQD_NgayCV.Text = ngay_temp;
                        txtGhichu.Text = item["GHICHU"] + "";
                        txtTB_NguoiKy.Text = item["NGUOIKY"] + "";
                        if (!string.IsNullOrEmpty(txtTB_NguoiKy.Text))
                        {
                            txtTB_NguoiKy_td.Visible = true;
                            DropTB_NguoiKy_td.Visible = false;
                        }
                        else
                        {
                            txtTB_NguoiKy_td.Visible = false;
                            DropTB_NguoiKy_td.Visible = true;
                            LoadDropNguoiKyXuLyDon(DropTB_NguoiKy, null);
                        }
                        LoadDropDonThuLyMoi(item["DONID"] + "");
                        Cls_Comon.SetValueComboBox(dropDon, item["DONID"]);
                        //rdbLoai.SelectedValue = "0";
                        rdbLoai.SelectedValue = item["LOAI"] + "";

                    }

                    pnTLD.Visible = pnQDKN.Visible = pnXepDon.Visible = pnXuLyKhac.Visible = false;
                    pnVKS_GQ.Visible = true;
                    pnDon.Visible = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void rdHoanTHA_SelectedIndexChanged(object sender, EventArgs e)
        {
            int ishoantha = Convert.ToInt16(rdHoanTHA.SelectedValue);
            if (ishoantha == 1)
            {
                LoadDropNguoiKy(dropHTA_NguoiKy, null);
                pnHoanTHA.Visible = true;
            }
            else
                pnHoanTHA.Visible = false;
        }
        protected void dropTLD_NguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtTLD_NguoiKy.Text = dropTLD_NguoiKy.SelectedItem.Text;
        }
        protected void dropKN_NguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtKN_NguoiKy.Text = dropKN_NguoiKy.SelectedItem.Text;
        }
        protected void dropNguoiDuyetXepDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNguoiDuyetXepDon.Text = dropNguoiDuyetXepDon.SelectedItem.Text;
        }
        protected void dropKN_NguoiKy_xlk_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtKN_NguoiKy_xlk.Text = DropKN_NguoiKy_xlk.SelectedItem.Text;
        }
        protected void dropTB_NguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtTB_NguoiKy.Text = DropTB_NguoiKy.SelectedItem.Text;
        }
    }
}
