using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.AHC;
using BL.GSTP.ALD;
using BL.GSTP.APS;
using BL.GSTP.DONCHOXULY;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.DONCHOXULY.Popup
{
    public partial class pGhepDon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (DonID > 0)
                {
                    AddLoaiAn();

                    decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
                    DON_GUINHAN checkLA = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();
                    ddlLoaiAn.SelectedValue = checkLA.LOAIAN.ToString();

                    if (checkLA.LOAIVANBAN == 1)
                    {
                        btnTiepNhan.Visible = true;
                    }
                    else
                    {
                        btnTiepNhan.Visible = false;
                    }
                    btnGhepDon.Visible = false;

                    LoadDropTinh();
                    LoadData();
                    LoadCombobox();
                    //LoadGrid();
                }
                else
                {
                    Response.Redirect("/Login.aspx");
                }
            }
        }

        private void LoadData()
        {
            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();

            //Thông tin vụ việc
            txtNgayNhan.Text = dgn.NGAYDAUBUUDIEN.HasValue ? dgn.NGAYDAUBUUDIEN.Value.ToString("dd/MM/yyyy") : "";
            txtQuanhephapluat.Text = dgn.QHPL;
            txtNDKK.Text = dgn.NOIDUNGKHOIKIEN;

            //Check loại đơn
            if (dgn.LOAIVANBAN == 1) //Đơn khởi kiện
            {
                pnDonKhangCao.Visible = false;
                pnDonKhac.Visible = false;
                pnDataKCKN.Visible = false;

                //Thông tin nguyên đơn
                DON_GUINHAN_DUONGSU nguyenDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.TUCACHTOTUNG.Equals("NGUYENDON")).FirstOrDefault();
                if(nguyenDon != null)
                {
                    if (nguyenDon.LOAIDUONGSU != null || nguyenDon.LOAIDUONGSU != 0)
                    {
                        ddlLoaiNguyendon.SelectedValue = nguyenDon.LOAIDUONGSU.ToString();
                    }
                    txtTennguyendon.Text = nguyenDon.HOTEN;
                    txtND_CMND.Text = nguyenDon.SOCMND;
                    ddlND_Gioitinh.SelectedValue = nguyenDon.GIOITINH.ToString();
                    txtND_Namsinh.Text = nguyenDon.NAMSINH.ToString();
                    if (nguyenDon.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = nguyenDon.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen_NguyenDon();
                        if (nguyenDon.TAMTRUID != null)
                        {
                            ddlTamTru_Huyen_NguyenDon.SelectedValue = nguyenDon.TAMTRUID.ToString();
                        }
                    }
                    txtND_TTChitiet.Text = nguyenDon.TAMTRUCHITIET;
                    txtND_Email.Text = nguyenDon.EMAIL;
                    txtND_Dienthoai.Text = nguyenDon.DIENTHOAI;
                    if (nguyenDon.MASOTHUE != null)
                    {
                        txtND_MaSoThue.Text = nguyenDon.MASOTHUE;
                    }
                    if (nguyenDon.NDD_TAMTRUTINHID != null)
                    {
                        ddlNDD_Tinh_NguyenDon.SelectedValue = nguyenDon.NDD_TAMTRUTINHID.ToString();
                        LoadDropNDD_Huyen_NguyenDon();
                        if (nguyenDon.NDD_TAMTRUHUYENID != null)
                        {
                            ddlNDD_Huyen_NguyenDon.SelectedValue = nguyenDon.NDD_TAMTRUHUYENID.ToString();
                        }
                    }
                    txtND_NDD_Diachichitiet.Text = nguyenDon.NDD_TAMTRUCHITIET;
                    txtND_NDD_Ten.Text = nguyenDon.NDD_NGUOIDAIDIEN;
                    txtND_NDD_Chucvu.Text = nguyenDon.NDD_CHUCVU;
                }

                //Thông tin bị đơn
                DON_GUINHAN_DUONGSU biDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.TUCACHTOTUNG.Equals("BIDON")).FirstOrDefault();
                if(biDon != null)
                {
                    ddlLoaiBidon.SelectedValue = biDon.LOAIDUONGSU.ToString();
                    txtBD_Ten.Text = biDon.HOTEN;
                    txtBD_CMND.Text = biDon.SOCMND;
                    ddlBD_Gioitinh.SelectedValue = biDon.GIOITINH.ToString();
                    txtBD_Namsinh.Text = biDon.NAMSINH.ToString();
                    if (biDon.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = biDon.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen_BiDon();
                        if (biDon.TAMTRUID != null)
                        {
                            ddlTamTru_Huyen_BiDon.SelectedValue = biDon.TAMTRUID.ToString();
                        }
                    }
                    txtBD_Tamtru_Chitiet.Text = biDon.TAMTRUCHITIET;
                    if (biDon.MASOTHUE != null)
                    {
                        txtND_MaSoThue.Text = biDon.MASOTHUE;
                    }
                    if (biDon.NDD_TAMTRUTINHID != null)
                    {
                        ddlNDD_Tinh_BiDon.SelectedValue = biDon.NDD_TAMTRUTINHID.ToString();
                        LoadDropNDD_Huyen_BiDon();
                        if (biDon.TAMTRUID != null)
                        {
                            ddlNDD_Huyen_BiDon.SelectedValue = biDon.TAMTRUID.ToString();
                        }
                    }
                    txtBD_NDD_Diachichitiet.Text = biDon.NDD_TAMTRUCHITIET;
                    txtBD_NDD_ten.Text = biDon.NDD_NGUOIDAIDIEN;
                    txtBD_NDD_Chucvu.Text = biDon.NDD_CHUCVU;
                }
            }
            else if (dgn.LOAIVANBAN == 2) // Đơn kháng cáo
            {
                pnDonKhoiKien.Visible = false;
                pnDonKhac.Visible = false;
                pnDataKCKN.Visible = true;

                //Thông tin đơn kháng cáo
                txtNoiDungKC.Text = dgn.NOIDUNGKHANGCAO;
                txtSoQDBA.Text = dgn.SO_BAQD;
                txtNgayQDBA.Text = dgn.NGAY_BAQD.HasValue ? dgn.NGAY_BAQD.Value.ToString("dd/MM/yyyy") : "";

                //Load data drop down list toà án
                List<DM_TOAAN> lst = dt.DM_TOAAN.OrderBy(x => x.ARRTHUTU).ToList();
                ddlToaRaQDBA.DataSource = lst;
                ddlToaRaQDBA.DataTextField = "TEN";
                ddlToaRaQDBA.DataValueField = "ID";
                ddlToaRaQDBA.DataBind();
                ddlToaRaQDBA.SelectedValue = dgn.TOAAN_BAQD.ToString();

                //DDL loại đơn
                if (ddlLoaiAn.SelectedValue == "3") //AHN
                {
                    ddlLoaidon.Items.Clear();
                    ddlLoaidon.Items.Insert(0, new ListItem("Đơn kháng cáo", "10"));
                }
                else //ADS còn lại
                {
                    ddlLoaidon.Items.Clear();
                    ddlLoaidon.Items.Insert(0, new ListItem("Đơn kháng cáo", "7"));
                }

                DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                if(nguoiKhangCao != null)
                {
                    ddlTenNguoiKC.Items.Insert(0, new ListItem(nguoiKhangCao.HOTEN, nguoiKhangCao.ID.ToString()));
                }
            }
            else //Đơn khác
            {
                pnDonKhangCao.Visible = false;
                pnDonKhoiKien.Visible = false;
                pnDataKCKN.Visible = false;

                //Thông tin đơn khác
                List<DM_DATAITEM> listTT = dt.DM_DATAITEM.Where(x => x.GROUPID == 11 || x.GROUPID == 16)
                    .OrderBy(x => x.TEN)
                    .ToList();
                ddlDK_TCTT.DataSource = listTT;
                ddlDK_TCTT.DataTextField = "TEN";
                ddlDK_TCTT.DataValueField = "ID";
                ddlDK_TCTT.DataBind();
                ddlDK_TCTT.Items.Insert(0, new ListItem("--Chọn--", "0"));

                //DDL loại đơn
                if(ddlLoaiAn.SelectedValue == "3") //AHN
                {
                    ddlLoaidon.Items.Clear();
                    ddlLoaidon.Items.Insert(0, new ListItem("Đơn khác", "11"));
                }
                else //ADS còn lại
                {
                    ddlLoaidon.Items.Clear();
                    ddlLoaidon.Items.Insert(0, new ListItem("Đơn khác", "8"));
                }

                DON_GUINHAN_DUONGSU nguoiDungDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.NGUOIKHANGCAO == 2).FirstOrDefault();
                if(nguoiDungDon != null){
                    ddlDK_NguoiDungDon.SelectedValue = nguoiDungDon.LOAIDUONGSU.ToString();
                    txtDK_HoTen.Text = nguoiDungDon.HOTEN;
                    txtDK_SoCMND.Text = nguoiDungDon.SOCMND;
                    txtDK_NamSinh.Text = nguoiDungDon.NAMSINH.ToString();
                    ddlDK_GioiTinh.SelectedValue = nguoiDungDon.GIOITINH.ToString();
                    if (nguoiDungDon.TAMTRUTINHID != null)
                    {
                        ddlDK_TamTru_Tinh.SelectedValue = nguoiDungDon.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen();
                        if (nguoiDungDon.TAMTRUID != null)
                        {
                            ddlDK_TamTru_Huyen.SelectedValue = nguoiDungDon.TAMTRUID.ToString();
                        }
                    }
                    txtDK_DiaChiChiTiet.Text = nguoiDungDon.TAMTRUCHITIET;
                    txtDK_Email.Text = nguoiDungDon.EMAIL;
                    txtDK_DienThoai.Text = nguoiDungDon.DIENTHOAI;
                    if (nguoiDungDon.MASOTHUE != null)
                    {
                        txtDK_MaSoThue.Text = nguoiDungDon.MASOTHUE;
                    }
                    if (nguoiDungDon.NDD_TAMTRUTINHID != null)
                    {
                        ddlDK_NDD_Tinh.SelectedValue = nguoiDungDon.NDD_TAMTRUTINHID.ToString();
                        LoadDropNDD_Huyen();
                        if (nguoiDungDon.NDD_TAMTRUHUYENID != null)
                        {
                            ddlDK_NDD_Huyen.SelectedValue = nguoiDungDon.NDD_TAMTRUHUYENID.ToString();
                        }
                    }
                    txtDK_NDD_DiaChiChiTiet.Text = nguoiDungDon.NDD_TAMTRUCHITIET;
                    txtDK_NguoiDaiDien.Text = nguoiDungDon.NDD_NGUOIDAIDIEN;
                    txtDK_ChucVu.Text = nguoiDungDon.NDD_CHUCVU;
                    txtDK_NoiDungDon.Text = dgn.NOIDUNGKHANGCAO;
                }
            }

            if (ddlLoaiAn.SelectedValue == "7") //APS
            {
                pnTTThuLy.Visible = false;
                pnTTQDBA.Visible = false;
            }
            else //ADS con lai
            {
                pnTTThuLy.Visible = true;
                pnTTQDBA.Visible = true;
            }
        }

        private void LoadGrid()
        {
            DON_CHO_XU_LY_BL obj = new DON_CHO_XU_LY_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable tbl = new DataTable();

            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();

            if (ddlLoaiAn.SelectedValue == "7")
            {
                tbl = obj.Get_Don_ChoXuLy_GhepDon_APS(Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtNguoiKhoiKien.Text.Trim(), txtSoCMND.Text.Trim(), txtNamSinh.Text.Trim(), txtNguoiBiKien.Text.Trim(), txtNoiDungKhoiKien.Text.Trim(), dgn.LOAIVANBAN, pageindex, page_size);
            }
            else
            {
                tbl = obj.Get_Don_ChoXuLy_GhepDon(Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlLoaiAn.SelectedValue, txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtNguoiKhoiKien.Text.Trim(), txtSoCMND.Text.Trim(), txtNamSinh.Text.Trim(), txtNguoiBiKien.Text.Trim(), txtNoiDungKhoiKien.Text.Trim(), txtSoThuLy.Text.Trim(), txtNgayThuLyTu.Text.Trim(), txtNgayThuLyDen.Text.Trim(), txtDon_SoBAQD.Text.Trim(), txtDon_NgayBAQDTu.Text.Trim(), txtDon_NgayBAQDDen.Text.Trim(), dgn.LOAIVANBAN, pageindex, page_size);
            }
            
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = tbl;
            dgList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideLoading", "hideLoading();", true);
        }

        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbonhandon.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();
            //Set mặc định cán bộ login
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU, ENUM_DANHMUC.QUANHEPL_TRANHCHAP);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();

            //Load QHPL Thống kê.
            //ADS
            if (ddlLoaiAn.SelectedValue == "2")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }
            //AHN
            else if (ddlLoaiAn.SelectedValue == "3")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }
            //AKT
            else if (ddlLoaiAn.SelectedValue == "4")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }
            //ALD
            else if (ddlLoaiAn.SelectedValue == "5")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }
            //AHC
            else if (ddlLoaiAn.SelectedValue == "6")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }
            //APS
            else if (ddlLoaiAn.SelectedValue == "7")
            {
                ddlQHPLTK.Items.Clear();
                ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                ddlQHPLTK.DataTextField = "CASE_NAME";
                ddlQHPLTK.DataValueField = "ID";
                ddlQHPLTK.DataBind();
                ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            }

            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.Items.Clear();
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();
            ddlBD_Quoctich.Items.Clear();
            ddlBD_Quoctich.DataSource = dtQuoctich;
            ddlBD_Quoctich.DataTextField = "TEN";
            ddlBD_Quoctich.DataValueField = "ID";
            ddlBD_Quoctich.DataBind();
        }

        private void LoadListDuongSu(decimal DonID)
        {
            //Load đương sự
            decimal donid = DonID;

            //ADS
            if (ddlLoaiAn.SelectedValue == "2")
            {
                List<ADS_DON_DUONGSU> listND = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<ADS_DON_DUONGSU> listBD = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }
            //AHN
            else if (ddlLoaiAn.SelectedValue == "3")
            {
                List<AHN_DON_DUONGSU> listND = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<AHN_DON_DUONGSU> listBD = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }
            //AKT
            else if (ddlLoaiAn.SelectedValue == "4")
            {
                List<AKT_DON_DUONGSU> listND = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<AKT_DON_DUONGSU> listBD = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }
            //ALC
            else if (ddlLoaiAn.SelectedValue == "5")
            {
                List<ALD_DON_DUONGSU> listND = dt.ALD_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<ALD_DON_DUONGSU> listBD = dt.ALD_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }
            //AHC
            else if (ddlLoaiAn.SelectedValue == "6")
            {
                List<AHC_DON_DUONGSU> listND = dt.AHC_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<AHC_DON_DUONGSU> listBD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }
            //APS
            else if (ddlLoaiAn.SelectedValue == "7")
            {
                List<APS_DON_DUONGSU> listND = dt.APS_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "NGUYENDON").ToList();
                ddlListND.DataSource = listND;
                ddlListND.DataTextField = "TENDUONGSU";
                ddlListND.DataValueField = "ID";
                ddlListND.DataBind();
                ddlListND.Items.Insert(0, new ListItem("Đương sự mới", "0"));

                List<APS_DON_DUONGSU> listBD = dt.APS_DON_DUONGSU.Where(x => x.DONID == donid && x.TUCACHTOTUNG_MA == "BIDON").ToList();
                ddlListBD.DataSource = listBD;
                ddlListBD.DataTextField = "TENDUONGSU";
                ddlListBD.DataValueField = "ID";
                ddlListBD.DataBind();
                ddlListBD.Items.Insert(0, new ListItem("Đương sự mới", "0"));
            }

            //Hiển thị ddl ND BD
            cboListND.Visible = true;
            cboListBD.Visible = true;
        }

        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            if (ddlLoaidon.SelectedIndex != 5 && ddlLoaidon.SelectedIndex != 4)
            {
                if (!chkBoxCMNDND.Checked)
                {
                    if (string.IsNullOrEmpty(txtND_CMND.Text))
                    {
                        lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                        txtND_CMND.Focus();
                        return false;
                    }

                }
                decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
                {
                    lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con. Hãy chọn lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                    return false;
                }
                if (ddlCanbonhandon.Items.Count == 0)
                {
                    lstMsgB.Text = "Bạn chưa chọn người nhận đơn.";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                    return false;
                }
                // Bị đơn
                if (txtTennguyendon.Text == "")
                {
                    lstMsgB.Text = "Bạn chưa nhập tên nguyên đơn.";
                    txtTennguyendon.Focus();
                    return false;
                }
                else if (txtTennguyendon.Text.Length > 250)
                {
                    lstMsgB.Text = "Tên nguyên đơn không nhập quá 250 ký tự.";
                    txtTennguyendon.Focus();
                    return false;
                }
                if (pnNDCanhan.Visible)// cá nhân
                {
                    if (txtND_Ngaysinh.Text != "")
                    {
                        if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
                        {
                            lstMsgB.Text = "Bạn chưa nhập ngày sinh nguyên đơn theo định dạng dd/MM/yyyy. Hãy nhập lại.";
                            txtND_Ngaysinh.Focus();
                            return false;
                        }
                        DateTime NgaySinh_ND = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (NgaySinh_ND > DateTime.Now)
                        {
                            lstMsgB.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày hiện tại. Hãy nhập lại.";
                            txtND_Ngaysinh.Focus();
                            return false;
                        }
                        if (NgaySinh_ND > dNgayNhan)
                        {
                            lstMsgB.Text = "Ngày sinh nguyên đơn không được lớn hơn ngày nhận đơn. Hãy nhập lại.";
                            txtND_Ngaysinh.Focus();
                            return false;
                        }
                    }
                    if (txtND_Namsinh.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập năm sinh nguyên đơn.";
                        txtND_Namsinh.Focus();
                        return false;
                    }
                    else
                    {
                        if (txtND_Namsinh.Text.Trim().Length < 4)
                        {
                            lstMsgB.Text = "Năm sinh của nguyên đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                            return false;
                        }
                        int namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                        if (namsinh == 0)
                        {
                            lstMsgB.Text = "Năm sinh của nguyên đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                            return false;
                        }
                        else if (namsinh > dNgayNhan.Year)
                        {
                            lstMsgB.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                            return false;
                        }
                        else if (namsinh > DateTime.Now.Year)
                        {
                            lstMsgB.Text = "Năm sinh của nguyên đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                            return false;
                        }
                    }
                    if (txtND_NoiLamViec.Text.Trim().Length > 500)
                    {
                        lstMsgB.Text = "Nơi làm việc của nguyên đơn không nhập quá 500 ký tự.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_NoiLamViec.ClientID);
                        return false;
                    }
                }
                int lengthEmail_ND = txtND_Email.Text.Trim().Length;
                if (lengthEmail_ND > 0)
                {
                    if (lengthEmail_ND > 250)
                    {
                        lstMsgB.Text = "Email của nguyên đơn không nhập quá 250 ký tự. Hãy nhập lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);
                        return false;
                    }
                    string email = txtND_Email.Text.Trim();
                    int atpos = email.IndexOf("@");
                    var dotpos = email.LastIndexOf(".");
                    if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail_ND)
                    {
                        lstMsgB.Text = "Địa chỉ email của nguyên đơn chưa đúng.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_Email.ClientID);
                        return false;
                    }
                }
                // Bị đơn
                if (txtBD_Ten.Text == "")
                {
                    lstMsgB.Text = "Bạn chưa nhập tên bị đơn.";
                    txtBD_Ten.Focus();
                    return false;
                }
                else if (txtBD_Ten.Text.Length > 250)
                {
                    lstMsgB.Text = "Tên bị đơn không nhập quá 250 ký tự.";
                    txtBD_Ten.Focus();
                    return false;
                }
                if (pnBD_Canhan.Visible)// Cá nhân
                {
                    if (txtBD_Ngaysinh.Text != "")
                    {
                        if (Cls_Comon.IsValidDate(txtBD_Ngaysinh.Text) == false)
                        {
                            lstMsgB.Text = "Bạn chưa nhập ngày sinh bị đơn theo định dạng dd/MM/yyyy. Hãy nhập lại.";
                            txtBD_Ngaysinh.Focus();
                            return false;
                        }
                        DateTime NgaySinh_BD = DateTime.Parse(txtBD_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (NgaySinh_BD > DateTime.Now)
                        {
                            lstMsgB.Text = "Ngày sinh bị đơn không được lớn hơn ngày hiện tại. Hãy nhập lại.";
                            txtBD_Ngaysinh.Focus();
                            return false;
                        }
                        if (NgaySinh_BD > dNgayNhan)
                        {
                            lstMsgB.Text = "Ngày sinh bị đơn không được lớn hơn ngày nhận đơn. Hãy nhập lại.";
                            txtBD_Ngaysinh.Focus();
                            return false;
                        }
                    }
                    if (txtBD_Namsinh.Text != "")
                    {
                        if (txtBD_Namsinh.Text.Trim().Length < 4)
                        {
                            lstMsgB.Text = "Năm sinh của bị đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                            return false;
                        }
                        int namsinh = Convert.ToInt32(txtBD_Namsinh.Text);
                        if (namsinh == 0)
                        {
                            lstMsgB.Text = "Năm sinh của bị đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                            return false;
                        }
                        else if (namsinh > dNgayNhan.Year)
                        {
                            lstMsgB.Text = "Năm sinh của bị đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
                            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                            return false;
                        }
                        else if (namsinh > DateTime.Now.Year)
                        {
                            lstMsgB.Text = "Năm sinh của bị đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                            Cls_Comon.SetFocus(this, this.GetType(), txtBD_Namsinh.ClientID);
                            return false;
                        }
                    }
                    if (txtBD_NoiLamViec.Text.Trim().Length > 500)
                    {
                        lstMsgB.Text = "Nơi làm việc của bị đơn không nhập quá 500 ký tự.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_NoiLamViec.ClientID);
                        return false;
                    }
                }
                int lengthEmail_BD = txtBD_Email.Text.Trim().Length;
                if (lengthEmail_BD > 0)
                {
                    if (lengthEmail_BD > 250)
                    {
                        lstMsgB.Text = "Email của bị đơn không nhập quá 250 ký tự. Hãy nhập lại.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);
                        return false;
                    }
                    string email = txtBD_Email.Text.Trim();
                    int atpos = email.IndexOf("@");
                    var dotpos = email.LastIndexOf(".");
                    if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail_BD)
                    {
                        lstMsgB.Text = "Địa chỉ email của bị đơn chưa đúng.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtBD_Email.ClientID);
                        return false;
                    }
                }
            }

            return true;
        }

        private bool CheckValidDonKhac()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            //Check phần thông tin đơn khác
            if (ddlDK_TCTT.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn tư cách tham gia tố tụng.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_TCTT.ClientID);
                return false;
            }
            if (txtDK_HoTen.Text == "")
            {
                lstMsgB.Text = "Bạn chưa họ tên người đứng đơn.";
                txtDK_HoTen.Focus();
                return false;
            }
            if (txtDK_NamSinh.Text != "")
            {
                if (txtDK_NamSinh.Text.Trim().Length < 4)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                int namsinh = Convert.ToInt32(txtDK_NamSinh.Text);
                if (namsinh == 0)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                else if (namsinh > dNgayNhan.Year)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                else if (namsinh > DateTime.Now.Year)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
            }
            if (!chkDK_CMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtDK_SoCMND.Text))
                {
                    lstMsgB.Text = "Bạn chưa nhập Số CMND.";
                    txtDK_SoCMND.Focus();
                    return false;
                }
            }
            return true;
        }

        private bool CheckValidKhangCao()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            //Check phần thông tin đơn kháng cáo
            if (txtSoQDBA.Text == "")
            {
                lstMsgB.Text = "Chưa nhập số Quyết định/Bản án.";
                txtSoQDBA.Focus();
                return false;
            }
            if (ddlTenNguoiKC.Items.Count < 0)
            {
                lstMsgB.Text = "Chưa chọn tên người kháng cáo.";
                ddlTenNguoiKC.Focus();
                return false;
            }
            if (txtNgayKC.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày kháng cáo.";
                txtNgayKC.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayKC.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày kháng cáo theo định dạng dd/MM/yyyy.";
                txtNgayKC.Focus();
                return false;
            }
            DateTime dNgayKC = DateTime.Parse(this.txtNgayKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayKC > DateTime.Now)
            {
                lstMsgB.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại.";
                txtNgayKC.Focus();
                return false;
            }

            return true;
        }

        private bool SaveDataGhepDonKhoiKien()
        {
            try
            {
                if (!CheckValid()) return false;

                decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());

                if (hddID_DON.Text == "")
                {
                    lstMsgB.Text = "Chưa ghép đơn! Không thể Lưu";
                    return false;
                }
                else {
                    //Lưu thông tin vụ việc vào bảng DON_CHITIET
                    DON_CHITIET oT = new DON_CHITIET();

                    oT.DONID = Convert.ToDecimal(hddID_DON.Text);
                    oT.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                    oT.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                    oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    if (oT.NGAYVIETDON.ToString() != "")
                    {
                        oT.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    if (oT.NGAYNHANDON.ToString() != "")
                    {
                        oT.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    oT.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.DONGUINHANID = ID_DGN;
                    
                    if (oT.TOA_GIAIQUYET_ID == null)
                        oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.DON_CHITIET.Add(oT);
                    dt.SaveChanges();

                    //Chuyển trạng thái sang đã ghép đơn trong bảng DON_GUINHAN
                    DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();
                    dgn.TRANGTHAI = 3;
                    dt.SaveChanges();

                    //Lưu thông tin nguyên đơn đại diện
                    if (ddlListND.SelectedValue == "0") //Nếu chọn đương sự mới
                    {
                        //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                        if (ddlLoaiAn.SelectedValue == "2")
                        {
                            ADS_DON_DUONGSU ndADS = new ADS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                            //update 14082025
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.ADS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AHN
                        else if (ddlLoaiAn.SelectedValue == "3")
                        {
                            AHN_DON_DUONGSU ndADS = new AHN_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                            
                            // an hn
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.AHN_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AKT
                        else if (ddlLoaiAn.SelectedValue == "4")
                        {
                            AKT_DON_DUONGSU ndADS = new AKT_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                            // insert toa_gq_id
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                            {
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }

                            dt.AKT_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //ALD
                        else if (ddlLoaiAn.SelectedValue == "5")
                        {
                            ALD_DON_DUONGSU ndADS = new ALD_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                            
                            // quyennd
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.ALD_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AHC
                        else if (ddlLoaiAn.SelectedValue == "6")
                        {
                            AHC_DON_DUONGSU ndADS = new AHC_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                            // update 130825
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHC_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //APS
                        else if (ddlLoaiAn.SelectedValue == "7")
                        {
                            APS_DON_DUONGSU ndADS = new APS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtTennguyendon.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                            ndADS.SOCMND = txtND_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                            if (txtND_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtND_Email.Text;
                            ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                            ndADS.FAX = txtND_Fax.Text;
                            if (chkND_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                            ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;

                            dt.APS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                    }
                    else //Nếu chọn đương sự có sẵn
                    {
                        //Chỉ cần thêm nguyên đơn vào bảng DON_DUONGSU_CHITIET
                        DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                        nd.DUONGSUID = Convert.ToDecimal(txtIdNguyenDon.Text);
                        nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                        nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        nd.DONCHITIETID = oT.ID;
                        nd.NGAYTAO = DateTime.Now;
                        nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        
                        if (nd.TOA_GIAIQUYET_ID == null)
                            nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.DON_DUONGSU_CHITIET.Add(nd);
                        dt.SaveChanges();
                    }

                    //Lưu thông tin bị đơn đại diện
                    if (ddlListBD.SelectedValue == "0") //Nếu chọn đương sự mới
                    {
                        //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                        //ADS
                        if (ddlLoaiAn.SelectedValue == "2")
                        {
                            ADS_DON_DUONGSU ndADS = new ADS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                            //update 14082025
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.ADS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AHN
                        else if (ddlLoaiAn.SelectedValue == "3")
                        {
                            AHN_DON_DUONGSU ndADS = new AHN_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                            
                            // an hn
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.AHN_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AKT
                        else if (ddlLoaiAn.SelectedValue == "4")
                        {
                            AKT_DON_DUONGSU ndADS = new AKT_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                            // insert toa_gq_id
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                            {
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }

                            dt.AKT_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //ALD
                        else if (ddlLoaiAn.SelectedValue == "5")
                        {
                            ALD_DON_DUONGSU ndADS = new ALD_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                            
                            // quyennd
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.ALD_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //AHC
                        else if (ddlLoaiAn.SelectedValue == "6")
                        {
                            AHC_DON_DUONGSU ndADS = new AHC_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                            // update 130825
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHC_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                        //APS
                        else if (ddlLoaiAn.SelectedValue == "7")
                        {
                            APS_DON_DUONGSU ndADS = new APS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtBD_Ten.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = "BIDON";
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                            ndADS.SOCMND = txtBD_CMND.Text;
                            ndADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                            if (txtBD_Ngaysinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtBD_Email.Text;
                            ndADS.DIENTHOAI = txtBD_Dienthoai.Text;
                            ndADS.FAX = txtBD_Fax.Text;
                            if (chkBD_ONuocNgoai.Checked)
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 1;
                            }
                            else
                            {
                                ndADS.SINHSONG_NUOCNGOAI = 0;
                            }
                            ndADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                            ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                            ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;

                            dt.APS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm đương sự vào bảng DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                            nd.DUONGSUID = ndADS.ID;
                            nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                            nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            nd.DONCHITIETID = oT.ID;
                            nd.NGAYTAO = DateTime.Now;
                            nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            
                            if (nd.TOA_GIAIQUYET_ID == null)
                                nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(nd);
                            dt.SaveChanges();
                        }
                    }
                    else //Nếu chọn đương sự có sẵn
                    {
                        //Chỉ cần thêm bị đơn vào bảng DON_DUONGSU_CHITIET
                        DON_DUONGSU_CHITIET nd = new DON_DUONGSU_CHITIET();
                        nd.DUONGSUID = Convert.ToDecimal(txtIdBiDon.Text);
                        nd.DONID = Convert.ToDecimal(hddID_DON.Text);
                        nd.LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        nd.DONCHITIETID = oT.ID;
                        nd.NGAYTAO = DateTime.Now;
                        nd.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        
                        // an hn
                        if (nd.TOA_GIAIQUYET_ID == null)
                            nd.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.DON_DUONGSU_CHITIET.Add(nd);
                        dt.SaveChanges();
                    }
                    lstMsgB.Text = "";
                    return true;
                }
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }

        private bool SaveDataTiepNhan()
        {
            try
            {
                if(ddlThuocLoaiAn.SelectedValue == "0")
                {
                    ddlThuocLoaiAn.Focus();
                    lstMsgB.Text = "Chưa chọn đơn thuộc loại án";
                    return false;
                }

                if (!CheckValid()) return false;

                decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());

                //Thêm thông tin vụ việc vào ADS_DON
                //ADS
                if (ddlThuocLoaiAn.SelectedValue == "2")
                {
                    ADS_DON ds = new ADS_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    ADS_DON_BL dsBL = new ADS_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_DANSU + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                    //update 14082025
                    ds.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.ADS_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("2", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    ADS_DON_DUONGSU ndADS = new ADS_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    //update 14082025
                    ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    ADS_DON_DUONGSU bdADS = new ADS_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                    //update 14082025
                    bdADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 2;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }
                //AHN
                else if (ddlThuocLoaiAn.SelectedValue == "3")
                {
                    AHN_DON ds = new AHN_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    AHN_DON_BL dsBL = new AHN_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                    
                    // an hn
                    if (ds.TOA_GIAIQUYET_ID == null)
                        ds.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.AHN_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("3", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    AHN_DON_DUONGSU ndADS = new AHN_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    
                    // an hn
                    if (ndADS.TOA_GIAIQUYET_ID == null)
                        ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.AHN_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    AHN_DON_DUONGSU bdADS = new AHN_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                    
                    // an hn
                    if (bdADS.TOA_GIAIQUYET_ID == null)
                        bdADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.AHN_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 3;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }
                //AKT
                else if (ddlThuocLoaiAn.SelectedValue == "4")
                {
                    AKT_DON ds = new AKT_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    AKT_DON_BL dsBL = new AKT_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                    // insert toa_gq_id
                    if (ds.TOA_GIAIQUYET_ID == null)
                    {
                        ds.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("4", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    AKT_DON_DUONGSU ndADS = new AKT_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    // insert toa_gq_id
                    if (ndADS.TOA_GIAIQUYET_ID == null)
                    {
                        ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }

                    dt.AKT_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    AKT_DON_DUONGSU bdADS = new AKT_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    bdADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    bdADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    bdADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    bdADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                    // insert toa_gq_id
                    if (bdADS.TOA_GIAIQUYET_ID == null)
                    {
                        bdADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }

                    dt.AKT_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 4;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }
                //ALD
                else if (ddlThuocLoaiAn.SelectedValue == "5")
                {
                    ALD_DON ds = new ALD_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    ALD_DON_BL dsBL = new ALD_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_LAODONG + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                    ds.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("5", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    ALD_DON_DUONGSU ndADS = new ALD_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    
                    // quyennd
                    if (ndADS.TOA_GIAIQUYET_ID == null)
                        ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.ALD_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    ALD_DON_DUONGSU bdADS = new ALD_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                    
                    // quyennd
                    if (bdADS.TOA_GIAIQUYET_ID == null)
                        bdADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.ALD_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 5;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }
                //AHC
                else if (ddlThuocLoaiAn.SelectedValue == "6")
                {
                    AHC_DON ds = new AHC_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    AHC_DON_BL dsBL = new AHC_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HANHCHINH + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                    // update 130825
                    ds.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("6", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    AHC_DON_DUONGSU ndADS = new AHC_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                    // update 130825
                    ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    AHC_DON_DUONGSU bdADS = new AHC_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;
                    // update 130825
                    bdADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 6;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }
                //APS
                else if (ddlThuocLoaiAn.SelectedValue == "7")
                {
                    APS_DON ds = new APS_DON();
                    ds.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    ds.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + txtQuanhephapluat.Text;
                    ds.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    ds.LOAIQUANHE = 1;
                    if (txtNgayViet.Text.Trim() != "")
                    {
                        ds.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ds.NGAYNHANDON = DateTime.Now;
                    ds.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    ds.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    if (chkND_ONuocNgoai.Checked || chkBD_ONuocNgoai.Checked)
                    {
                        ds.YEUTONUOCNGOAI = 1;
                    }
                    else
                    {
                        ds.YEUTONUOCNGOAI = 2;
                    }
                    ds.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    ds.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    ds.NGAYTAO = DateTime.Now;
                    ds.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    APS_DON_BL dsBL = new APS_DON_BL();
                    ds.TT = dsBL.GETNEWTT((decimal)ds.TOAANID);
                    ds.MAVUVIEC = ENUM_LOAIVUVIEC.AN_PHASAN + Session[ENUM_SESSION.SESSION_MADONVI] + ds.TT.ToString();
                    ds.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    ds.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    ds.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                    ds.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;

                    dt.APS_DON.Add(ds);
                    dt.SaveChanges();

                    //Thêm thông tin vụ việc vào ADS_DON_GIAIDOAN
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("7", ds.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);

                    //Thêm nguyên đơn vào bảng ADS_DON_DUONGSU
                    APS_DON_DUONGSU ndADS = new APS_DON_DUONGSU();
                    ndADS.DONID = ds.ID;
                    ndADS.TENDUONGSU = txtTennguyendon.Text;
                    ndADS.ISDAIDIEN = 1;
                    ndADS.TUCACHTOTUNG_MA = "NGUYENDON";
                    ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    ndADS.SOCMND = txtND_CMND.Text;
                    ndADS.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
                    ndADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_NguyenDon.SelectedValue);
                    ndADS.TAMTRUCHITIET = txtND_TTChitiet.Text;
                    if (txtND_Ngaysinh.Text.Trim() != "")
                    {
                        ndADS.NGAYSINH = DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    ndADS.NAMSINH = Convert.ToDecimal(txtND_Namsinh.Text);
                    ndADS.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    ndADS.NGAYTAO = DateTime.Now;
                    ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        ndADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        ndADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        ndADS.ISGDT = 1;
                    }
                    ndADS.ISDON = 1;
                    ndADS.EMAIL = txtND_Email.Text;
                    ndADS.DIENTHOAI = txtND_Dienthoai.Text;
                    ndADS.FAX = txtND_Fax.Text;
                    if (chkND_ONuocNgoai.Checked)
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        ndADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    ndADS.DIACHICOQUAN = txtND_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                    ndADS.CHUCVU = txtND_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;

                    dt.APS_DON_DUONGSU.Add(ndADS);
                    dt.SaveChanges();

                    //Thêm bị đơn vào bảng ADS_DON_DUONGSU
                    APS_DON_DUONGSU bdADS = new APS_DON_DUONGSU();
                    bdADS.DONID = ds.ID;
                    bdADS.TENDUONGSU = txtBD_Ten.Text;
                    bdADS.ISDAIDIEN = 1;
                    bdADS.TUCACHTOTUNG_MA = "BIDON";
                    bdADS.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiBidon.SelectedValue);
                    bdADS.SOCMND = txtBD_CMND.Text;
                    bdADS.QUOCTICHID = Convert.ToDecimal(ddlBD_Quoctich.SelectedValue);
                    bdADS.TAMTRUTINHID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
                    bdADS.TAMTRUID = Convert.ToDecimal(ddlTamTru_Huyen_BiDon.SelectedValue);
                    bdADS.TAMTRUCHITIET = txtBD_Tamtru_Chitiet.Text;
                    if (txtBD_Ngaysinh.Text.Trim() != "")
                    {
                        bdADS.NGAYSINH = DateTime.Parse(this.txtBD_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    bdADS.NAMSINH = txtBD_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtBD_Namsinh.Text);
                    bdADS.GIOITINH = Convert.ToDecimal(ddlBD_Gioitinh.SelectedValue);
                    bdADS.NGAYTAO = DateTime.Now;
                    bdADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (hddGIAIDOAN.Text == "2")
                    {
                        bdADS.ISSOTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "3")
                    {
                        bdADS.ISPHUCTHAM = 1;
                    }
                    else if (hddGIAIDOAN.Text == "4")
                    {
                        bdADS.ISGDT = 1;
                    }
                    bdADS.ISDON = 1;
                    bdADS.EMAIL = txtBD_Email.Text;
                    bdADS.DIENTHOAI = txtBD_Dienthoai.Text;
                    bdADS.FAX = txtBD_Fax.Text;
                    if (chkBD_ONuocNgoai.Checked)
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 1;
                    }
                    else
                    {
                        bdADS.SINHSONG_NUOCNGOAI = 0;
                    }
                    bdADS.DIACHICOQUAN = txtBD_NoiLamViec.Text;
                    ndADS.NGUOIDAIDIEN = txtBD_NDD_ten.Text;
                    ndADS.CHUCVU = txtBD_NDD_Chucvu.Text;
                    ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_BiDon.SelectedValue);
                    ndADS.NDD_DIACHICHITIET = txtBD_NDD_Diachichitiet.Text;

                    dt.APS_DON_DUONGSU.Add(bdADS);
                    dt.SaveChanges();

                    //Thêm vào bảng DON_TIEPNHAN
                    DON_TIEPNHAN dtn = new DON_TIEPNHAN();
                    dtn.LOAIAN = 7;
                    dtn.DONID = ndADS.DONID;
                    dtn.DONGUINHANID = ID_DGN;
                    dtn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dtn.NGAYTAO = DateTime.Now;

                    dt.DON_TIEPNHAN.Add(dtn);
                    dt.SaveChanges();
                }

                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }

        private bool SaveDataGhepDonKhac()
        {
            try
            {
                if (!CheckValidDonKhac()) return false;

                if (hddID_DON.Text == "")
                {
                    lstMsgB.Text = "Chưa ghép đơn! Không thể Lưu";
                    return false;
                }
                else
                {
                    decimal ID_TCTGTT = Convert.ToDecimal(ddlDK_TCTT.SelectedValue);
                    DM_DATAITEM checkTCTGTT = dt.DM_DATAITEM.Where(x => x.ID == ID_TCTGTT).FirstOrDefault();

                    decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());

                    //Thêm thông tin dương sự
                    //ADS
                    if (ddlLoaiAn.SelectedValue == "2")
                    {
                        if(checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            ADS_DON_DUONGSU ndADS = new ADS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            //update 14082025
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.ADS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            ADS_DON_THAMGIATOTUNG donTGTT = new ADS_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            //update 14082025
                            donTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.ADS_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                    //AHN
                    else if (ddlLoaiAn.SelectedValue == "3")
                    {
                        if (checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            AHN_DON_DUONGSU ndADS = new AHN_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            // update 110825
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            // an hn
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.AHN_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 11;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // quyennd
                            if (dk.TOA_GIAIQUYET_ID == null)
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            AHN_DON_THAMGIATOTUNG donTGTT = new AHN_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            
                            if (donTGTT.TOA_GIAIQUYET_ID == null)
                                donTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.AHN_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 11;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                    //AKT
                    else if (ddlLoaiAn.SelectedValue == "4")
                    {
                        if (checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            AKT_DON_DUONGSU ndADS = new AKT_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            // insert toa_gq_id
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                            {
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }

                            dt.AKT_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            AKT_DON_THAMGIATOTUNG donTGTT = new AKT_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            // insert toa_gq_id
                            if (donTGTT.TOA_GIAIQUYET_ID == null)
                            {
                                donTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }
                            dt.AKT_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                    //ALD
                    else if (ddlLoaiAn.SelectedValue == "5")
                    {
                        if (checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            ALD_DON_DUONGSU ndADS = new ALD_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            
                            // quyennd
                            if (ndADS.TOA_GIAIQUYET_ID == null)
                                ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.ALD_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            // update 060825
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            ALD_DON_THAMGIATOTUNG donTGTT = new ALD_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            
                            // quyennd
                            if (donTGTT.TOA_GIAIQUYET_ID == null)
                                donTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.ALD_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            // update 060825
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                    //AHC
                    else if (ddlLoaiAn.SelectedValue == "6")
                    {
                        if (checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            AHC_DON_DUONGSU ndADS = new AHC_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            // update 130825
                            ndADS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHC_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            // update 060825
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            AHC_DON_THAMGIATOTUNG donTGTT = new AHC_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;
                            // update 130825
                            donTGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.AHC_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            // update 130825
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                    //APS
                    else if (ddlLoaiAn.SelectedValue == "7")
                    {
                        if (checkTCTGTT.GROUPID == 11) //ADS_DON_DUONGSU
                        {
                            APS_DON_DUONGSU ndADS = new APS_DON_DUONGSU();
                            ndADS.DONID = Convert.ToDecimal(hddID_DON.Text);
                            ndADS.TENDUONGSU = txtDK_HoTen.Text;
                            ndADS.ISDAIDIEN = 0;
                            ndADS.TUCACHTOTUNG_MA = checkTCTGTT.MA;
                            ndADS.LOAIDUONGSU = Convert.ToDecimal(ddlDK_NguoiDungDon.SelectedValue);
                            ndADS.SOCMND = txtDK_SoCMND.Text;
                            ndADS.QUOCTICHID = 2;
                            ndADS.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            ndADS.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            ndADS.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                ndADS.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            ndADS.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            ndADS.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            ndADS.NGAYTAO = DateTime.Now;
                            ndADS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (hddGIAIDOAN.Text == "2")
                            {
                                ndADS.ISSOTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "3")
                            {
                                ndADS.ISPHUCTHAM = 1;
                            }
                            else if (hddGIAIDOAN.Text == "4")
                            {
                                ndADS.ISGDT = 1;
                            }
                            ndADS.ISDON = 1;
                            ndADS.EMAIL = txtDK_Email.Text;
                            ndADS.DIENTHOAI = txtDK_DienThoai.Text;
                            ndADS.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            ndADS.CHUCVU = txtDK_ChucVu.Text;
                            ndADS.NDD_DIACHIID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            ndADS.NDD_DIACHICHITIET = txtDK_NDD_DiaChiChiTiet.Text;

                            dt.APS_DON_DUONGSU.Add(ndADS);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = ndADS.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 1;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                        else //ADS_DON_THAMGIATOTUNG
                        {
                            APS_DON_THAMGIATOTUNG donTGTT = new APS_DON_THAMGIATOTUNG();
                            donTGTT.DONID = Convert.ToDecimal(hddID_DON.Text);
                            donTGTT.HOTEN = txtDK_HoTen.Text;
                            donTGTT.TAMTRUTINHID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                            donTGTT.TAMTRUID = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                            donTGTT.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                            if (txtDK_NgaySinh.Text.Trim() != "")
                            {
                                donTGTT.NGAYSINH = DateTime.Parse(this.txtDK_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            donTGTT.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                            donTGTT.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                            donTGTT.TUCACHTGTTID = checkTCTGTT.MA;
                            donTGTT.NGAYTAO = DateTime.Now;
                            donTGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            donTGTT.EMAIL = txtDK_Email.Text;
                            donTGTT.DIENTHOAI = txtDK_DienThoai.Text;
                            donTGTT.SOCMND = txtDK_SoCMND.Text;
                            donTGTT.NGUOIDAIDIEN = txtDK_NguoiDaiDien.Text;
                            donTGTT.CHUCVU = txtDK_ChucVu.Text;
                            donTGTT.HKTTTINHID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
                            donTGTT.HKTTID = Convert.ToDecimal(ddlDK_NDD_Huyen.SelectedValue);
                            donTGTT.HKTTCHITIET = txtDK_NDD_DiaChiChiTiet.Text;

                            dt.APS_DON_THAMGIATOTUNG.Add(donTGTT);
                            dt.SaveChanges();

                            //Thêm thông tin vụ việc vào bảng DON_KHAC
                            DON_KHAC dk = new DON_KHAC();

                            dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                            dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                            dk.LOAIDON = 8;
                            dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                            if (dk.NGAYVIETDON.ToString() != "")
                            {
                                dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            if (dk.NGAYNHANDON.ToString() != "")
                            {
                                dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            }
                            dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                            dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                            dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                            dk.DUONGSUID = donTGTT.ID;
                            dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                            dk.ISDUONGSU = 0;
                            dk.DONGUINHANID = ID_DGN;
                            
                            // an hn
                            if (dk.TOA_GIAIQUYET_ID == null) 
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            // quyennd
                            if (dk.TOA_GIAIQUYET_ID == null)
                                dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            
                            dt.DON_KHAC.Add(dk);
                            dt.SaveChanges();
                        }
                    }
                }
                lstMsgB.Text = "";
                return true;
            }
            catch(Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }

        private bool SaveDataGhepDonKhangCao()
        {
            try
            {
                if (!CheckValidKhangCao()) return false;

                if (hddID_DON.Text == "")
                {
                    lstMsgB.Text = "Chưa ghép đơn! Không thể Lưu";
                    return false;
                }
                else
                {
                    decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
                    if (ddlLoaiAn.SelectedValue == "3") //AHN
                    {
                        //Thêm thông tin vụ việc vào bảng DON_KHAC
                        DON_KHAC dk = new DON_KHAC();

                        dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                        dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                        dk.LOAIDON = 10;
                        dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                        if (txtNgayViet.Text.Trim() != "")
                        {
                            dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        if (txtNgayNhan.Text.Trim() != "")
                        {
                            dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                        dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                        dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                        string idDS = ddlTenNguoiKC.SelectedValue;
                        string isDS = idDS.Substring(idDS.Length - 1);
                        dk.ISDUONGSU = Convert.ToDecimal(isDS);
                        int ind = idDS.Length - 1;
                        idDS = idDS.Remove(ind);
                        dk.DUONGSUID = Convert.ToDecimal(idDS);
                        dk.NOIDUNGDON = txtNoiDungKC.Text;
                        if (txtNgayVietDonKC.Text.Trim() != "")
                        {
                            dk.NGAYVIETDONKC = DateTime.Parse(this.txtNgayVietDonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.NGAYKHANGCAO = DateTime.Parse(this.txtNgayKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dk.LOAIKHANGCAO = Convert.ToDecimal(rdLoaiKC.SelectedValue);
                        dk.SOQDBA = txtSoQDBA.Text;
                        dk.ISQUAHAN = Convert.ToDecimal(rdNgayKCQuaHan.SelectedValue);
                        if(txtNgayQDBA.Text.Trim() != "")
                        {
                            dk.NGAYQDBA = DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.TOAANRAQDID = Convert.ToDecimal(ddlToaRaQDBA.SelectedValue);
                        dk.DONGUINHANID = ID_DGN;
                        
                        // an hn
                        if (dk.TOA_GIAIQUYET_ID == null) 
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.DON_KHAC.Add(dk);
                        dt.SaveChanges();
                        
                        if (hddFilePath_KC.Value != "")
                        {
                            DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                            string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oKCFile.NOIDUNGFILE = buff;
                                oKCFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oKCFile.KIEUFILE = oF.Extension;
                                oKCFile.DONKHAC_ID = dk.ID;

                                dt.DON_KHAC_FILE.Add(oKCFile);
                                dt.SaveChanges();
                            }
                        }
                    }
                    else //Các án dân sự còn lại
                    {
                        //Thêm thông tin vụ việc vào bảng DON_KHAC
                        DON_KHAC dk = new DON_KHAC();

                        dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                        dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                        dk.LOAIDON = 7;
                        dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                        if (txtNgayViet.Text.Trim() != "")
                        {
                            dk.NGAYVIETDON = DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        if (txtNgayNhan.Text.Trim() != "")
                        {
                            dk.NGAYNHANDON = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                        dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                        dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                        string idDS = ddlTenNguoiKC.SelectedValue;
                        string isDS = idDS.Substring(idDS.Length - 1);
                        dk.ISDUONGSU = Convert.ToDecimal(isDS);
                        int ind = idDS.Length - 1;
                        idDS = idDS.Remove(ind);
                        dk.DUONGSUID = Convert.ToDecimal(idDS);
                        dk.NOIDUNGDON = txtNoiDungKC.Text;
                        if (txtNgayVietDonKC.Text.Trim() != "")
                        {
                            dk.NGAYVIETDONKC = DateTime.Parse(this.txtNgayVietDonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.NGAYKHANGCAO = DateTime.Parse(this.txtNgayKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dk.LOAIKHANGCAO = Convert.ToDecimal(rdLoaiKC.SelectedValue);
                        dk.SOQDBA = txtSoQDBA.Text;
                        dk.ISQUAHAN = Convert.ToDecimal(rdNgayKCQuaHan.SelectedValue);
                        if (txtNgayQDBA.Text.Trim() != "")
                        {
                            dk.NGAYQDBA = DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        dk.TOAANRAQDID = Convert.ToDecimal(ddlToaRaQDBA.SelectedValue);
                        dk.DONGUINHANID = ID_DGN;
                        
                        // an hn
                        if (dk.TOA_GIAIQUYET_ID == null) 
                            dk.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.DON_KHAC.Add(dk);
                        dt.SaveChanges();

                        if (hddFilePath_KC.Value != "")
                        {
                            DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                            string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oKCFile.NOIDUNGFILE = buff;
                                oKCFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oKCFile.KIEUFILE = oF.Extension;
                                oKCFile.DONKHAC_ID = dk.ID;

                                dt.DON_KHAC_FILE.Add(oKCFile);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
                lstMsgB.Text = "";
                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        
        private void AddLoaiAn()
        {
            ddlLoaiAn.Items.Insert(0, new ListItem("Dân sự", "2"));
            ddlLoaiAn.Items.Insert(1, new ListItem("Hôn nhân và gia đình", "3"));
            ddlLoaiAn.Items.Insert(2, new ListItem("Kinh doanh, thương mại", "4"));
            ddlLoaiAn.Items.Insert(3, new ListItem("Lao động", "5"));
            ddlLoaiAn.Items.Insert(4, new ListItem("Hành chính", "6"));
            ddlLoaiAn.Items.Insert(5, new ListItem("Phá sản", "7"));
        }

        #region "Set giá trị tỉnh huyện mặc định cho nguyên đơn, bị đơn"
        private void LoadDropTinh()
        {
            ddlTamTru_Tinh_NguyenDon.Items.Clear();
            ddlTamTru_Tinh_BiDon.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlNDD_Tinh_NguyenDon.DataSource = lstTinh;
                ddlNDD_Tinh_NguyenDon.DataTextField = "TEN";
                ddlNDD_Tinh_NguyenDon.DataValueField = "ID";
                ddlNDD_Tinh_NguyenDon.DataBind();

                ddlNDD_Tinh_BiDon.DataSource = lstTinh;
                ddlNDD_Tinh_BiDon.DataTextField = "TEN";
                ddlNDD_Tinh_BiDon.DataValueField = "ID";
                ddlNDD_Tinh_BiDon.DataBind();

                ddlTamTru_Tinh_NguyenDon.DataSource = lstTinh;
                ddlTamTru_Tinh_NguyenDon.DataTextField = "TEN";
                ddlTamTru_Tinh_NguyenDon.DataValueField = "ID";
                ddlTamTru_Tinh_NguyenDon.DataBind();

                ddlTamTru_Tinh_BiDon.DataSource = lstTinh;
                ddlTamTru_Tinh_BiDon.DataTextField = "TEN";
                ddlTamTru_Tinh_BiDon.DataValueField = "ID";
                ddlTamTru_Tinh_BiDon.DataBind();

                ddlDK_NDD_Tinh.DataSource = lstTinh;
                ddlDK_NDD_Tinh.DataTextField = "TEN";
                ddlDK_NDD_Tinh.DataValueField = "ID";
                ddlDK_NDD_Tinh.DataBind();

                ddlDK_TamTru_Tinh.DataSource = lstTinh;
                ddlDK_TamTru_Tinh.DataTextField = "TEN";
                ddlDK_TamTru_Tinh.DataValueField = "ID";
                ddlDK_TamTru_Tinh.DataBind();
            }

            ddlNDD_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlNDD_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));

            ddlTamTru_Tinh_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));

            ddlDK_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlDK_TamTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));

            LoadDropNDD_Huyen_NguyenDon();
            LoadDropNDD_Huyen_BiDon();

            LoadDropTamTru_Huyen_NguyenDon();
            LoadDropTamTru_Huyen_BiDon();

            LoadDropNDD_Huyen();
            LoadDropTamTru_Huyen();
        }
        private void LoadDropNDD_Huyen_NguyenDon()
        {
            ddlNDD_Huyen_NguyenDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNDD_Tinh_NguyenDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlNDD_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNDD_Huyen_NguyenDon.DataSource = lstHuyen;
                ddlNDD_Huyen_NguyenDon.DataTextField = "TEN";
                ddlNDD_Huyen_NguyenDon.DataValueField = "ID";
                ddlNDD_Huyen_NguyenDon.DataBind();
            }
            ddlNDD_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropNDD_Huyen_BiDon()
        {
            ddlNDD_Huyen_BiDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNDD_Tinh_BiDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlNDD_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNDD_Huyen_BiDon.DataSource = lstHuyen;
                ddlNDD_Huyen_BiDon.DataTextField = "TEN";
                ddlNDD_Huyen_BiDon.DataValueField = "ID";
                ddlNDD_Huyen_BiDon.DataBind();
            }
            ddlNDD_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropNDD_Huyen()
        {
            ddlDK_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlDK_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlDK_NDD_Huyen.DataSource = lstHuyen;
                ddlDK_NDD_Huyen.DataTextField = "TEN";
                ddlDK_NDD_Huyen.DataValueField = "ID";
                ddlDK_NDD_Huyen.DataBind();
            }
            ddlDK_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen_NguyenDon()
        {
            ddlTamTru_Huyen_NguyenDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_NguyenDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_NguyenDon.DataTextField = "TEN";
                ddlTamTru_Huyen_NguyenDon.DataValueField = "ID";
                ddlTamTru_Huyen_NguyenDon.DataBind();
            }
            ddlTamTru_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen_BiDon()
        {
            ddlTamTru_Huyen_BiDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_BiDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_BiDon.DataTextField = "TEN";
                ddlTamTru_Huyen_BiDon.DataValueField = "ID";
                ddlTamTru_Huyen_BiDon.DataBind();
            }
            ddlTamTru_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen()
        {
            ddlDK_TamTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlDK_TamTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlDK_TamTru_Huyen.DataSource = lstHuyen;
                ddlDK_TamTru_Huyen.DataTextField = "TEN";
                ddlDK_TamTru_Huyen.DataValueField = "ID";
                ddlDK_TamTru_Huyen.DataBind();
            }
            ddlDK_TamTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }

        private void LoadDropNoiSongHuyen()
        {
            ddlTamTru_Huyen_NguyenDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_NguyenDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_NguyenDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_NguyenDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_NguyenDon.DataTextField = "TEN";
                ddlTamTru_Huyen_NguyenDon.DataValueField = "ID";
                ddlTamTru_Huyen_NguyenDon.DataBind();
            }
            ddlTamTru_Huyen_NguyenDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropNoiSongHuyenBD()
        {
            ddlTamTru_Huyen_BiDon.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh_BiDon.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen_BiDon.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen_BiDon.DataSource = lstHuyen;
                ddlTamTru_Huyen_BiDon.DataTextField = "TEN";
                ddlTamTru_Huyen_BiDon.DataValueField = "ID";
                ddlTamTru_Huyen_BiDon.DataBind();
            }
            ddlTamTru_Huyen_BiDon.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        #endregion
        
        //EVENT
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        #endregion

        protected void AsyncFileUpLoadKhangCao_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangCao.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangCao.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangCao.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }

        protected void ddlTamTru_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_NguyenDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_NguyenDon.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlTamTru_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen_BiDon.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlDK_TamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_TamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlNDD_Tinh_NguyenDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen_NguyenDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNDD_Huyen_NguyenDon.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlNDD_Tinh_BiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen_BiDon();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNDD_Huyen_BiDon.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlDK_NDD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_NDD_Huyen.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void GhepDon_Click(object sender, EventArgs e)
        {
            btnTiepNhan.Enabled = true;
            btnTiepNhan.CssClass = "buttoninput";

            btnGhepDon.Enabled = true;
            btnGhepDon.CssClass = "disable_btn";

            pnData.Visible = true;

            hdd_Type_Save.Text = "GhepDon";

            int count = 0;

            decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            DON_GUINHAN checkLA = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox checkGD = (CheckBox)item.FindControl("checkGhepDon");
                HiddenField IDVuViec = (HiddenField)item.FindControl("hddIdVuViec");
                decimal ID_DON = Convert.ToDecimal(IDVuViec.Value);
                
                if (checkGD.Checked)
                {
                    btnLuu.Enabled = true;
                    btnLuu.CssClass = "buttoninput";

                    //ADS
                    if (ddlLoaiAn.SelectedValue == "2")
                    {
                        //Load thông tin vụ việc
                        ADS_DON objADS = dt.ADS_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;
                        
                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if (checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo
                            ADS_SOTHAM_BL oBL = new ADS_SOTHAM_BL();
                            DataTable oDT = oBL.ADS_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            ADS_SOTHAM_BANAN banAn = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<ADS_DON_DUONGSU> listDS = dt.ADS_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if(nguoiKhangCao != null)
                                {
                                    if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                    {
                                        checkDS = true;
                                        break;
                                    }
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if(banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy") == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo

                                    //ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();
                                    //ddlTenNguoiKC.DataSource = oDSBL.ADS_SOTHAM_DUONGSU_GETBY(ID_DON, 1);
                                    //ddlTenNguoiKC.DataTextField = "ARRDUONGSU";
                                    //ddlTenNguoiKC.DataValueField = "ID";
                                    //ddlTenNguoiKC.DataBind();

                                    List<ADS_DON_DUONGSU> dsDuongSu = dt.ADS_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<ADS_DON_THAMGIATOTUNG> dsTGTT = dt.ADS_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }
                    //AHN
                    else if (ddlLoaiAn.SelectedValue == "3")
                    {
                        //Load thông tin vụ việc
                        AHN_DON objADS = dt.AHN_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;

                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if (checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo nếu là đơn kháng cáo
                            AHN_SOTHAM_BL oBL = new AHN_SOTHAM_BL();
                            DataTable oDT = oBL.AHN_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            AHN_SOTHAM_BANAN banAn = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<AHN_DON_DUONGSU> listDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkDS = true;
                                    break;
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if(banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo
                                    List<AHN_DON_DUONGSU> dsDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<AHN_DON_THAMGIATOTUNG> dsTGTT = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }
                    //AKT
                    else if (ddlLoaiAn.SelectedValue == "4")
                    {
                        //Load thông tin vụ việc
                        AKT_DON objADS = dt.AKT_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;

                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if(checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo
                            AKT_SOTHAM_BL oBL = new AKT_SOTHAM_BL();
                            DataTable oDT = oBL.AKT_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            AKT_SOTHAM_BANAN banAn = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<AKT_DON_DUONGSU> listDS = dt.AKT_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkDS = true;
                                    break;
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if(banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo
                                    List<AKT_DON_DUONGSU> dsDuongSu = dt.AKT_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<AKT_DON_THAMGIATOTUNG> dsTGTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }
                    //ALD
                    else if (ddlLoaiAn.SelectedValue == "5")
                    {
                        //Load thông tin vụ việc
                        ALD_DON objADS = dt.ALD_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;

                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if (checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo
                            ALD_SOTHAM_BL oBL = new ALD_SOTHAM_BL();
                            DataTable oDT = oBL.ALD_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            ALD_SOTHAM_BANAN banAn = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<ALD_DON_DUONGSU> listDS = dt.ALD_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkDS = true;
                                    break;
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if (banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo
                                    List<ALD_DON_DUONGSU> dsDuongSu = dt.ALD_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<ALD_DON_THAMGIATOTUNG> dsTGTT = dt.ALD_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }
                    //AHC
                    else if (ddlLoaiAn.SelectedValue == "6")
                    {
                        //Load thông tin vụ việc
                        AHC_DON objADS = dt.AHC_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;

                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if(checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo
                            AHC_SOTHAM_BL oBL = new AHC_SOTHAM_BL();
                            DataTable oDT = oBL.AHC_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            AHC_SOTHAM_BANAN banAn = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<AHC_DON_DUONGSU> listDS = dt.AHC_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkDS = true;
                                    break;
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if (banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo
                                    List<AHC_DON_DUONGSU> dsDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<AHC_DON_THAMGIATOTUNG> dsTGTT = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }
                    //APS
                    else if (ddlLoaiAn.SelectedValue == "7")
                    {
                        //Load thông tin vụ việc
                        APS_DON objADS = dt.APS_DON.Where(x => x.ID == ID_DON).FirstOrDefault();

                        hddID_DON.Text = objADS.ID.ToString();
                        hddID_TOAAN.Text = objADS.TOAANID.ToString();
                        hddGIAIDOAN.Text = objADS.MAGIAIDOAN.ToString();
                        ddlHinhthucnhandon.SelectedValue = objADS.HINHTHUCNHANDON.ToString();
                        txtNgayViet.Text = objADS.NGAYVIETDON.HasValue ? objADS.NGAYVIETDON.Value.ToString("dd/MM/yyyy") : "";
                        txtNgayNhan.Text = objADS.NGAYNHANDON.HasValue ? objADS.NGAYNHANDON.Value.ToString("dd/MM/yyyy") : "";
                        txtQuanhephapluat.Text = objADS.QUANHEPHAPLUAT_NAME;
                        ddlQHPLTK.SelectedValue = objADS.QHPLTKID.ToString();
                        txtNDKK.Text = objADS.NOIDUNGKHOIKIEN;

                        if (checkLA.LOAIVANBAN == 1)
                        {
                            //Load thông tin khởi kiện
                            LoadListDuongSu(ID_DON);
                        }
                        else if(checkLA.LOAIVANBAN == 2)
                        {
                            //Load thông tin kháng cáo
                            APS_SOTHAM_BL oBL = new APS_SOTHAM_BL();
                            DataTable oDT = oBL.APS_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                            dgDataKCKN.DataSource = oDT;
                            dgDataKCKN.DataBind();

                            APS_SOTHAM_BANAN banAn = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == ID_DON).FirstOrDefault();
                            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                            List<APS_DON_DUONGSU> listDS = dt.APS_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                            bool checkDS = false;
                            foreach (var itemDS in listDS)
                            {
                                if (itemDS.TENDUONGSU.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkDS = true;
                                    break;
                                }
                            }
                            //Nếu như thông tin kháng cáo trùng với thông tin vụ việc
                            if(banAn != null)
                            {
                                if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYTUYENAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text && checkDS)
                                {
                                    //Load list người kháng cáo
                                    List<APS_DON_DUONGSU> dsDuongSu = dt.APS_DON_DUONGSU.Where(x => x.DONID == ID_DON).ToList();
                                    string ttDS = "";
                                    foreach (var itemDS in dsDuongSu)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 11 && x.MA == itemDS.TUCACHTOTUNG_MA)
                                            .FirstOrDefault();

                                        ttDS = itemDS.TENDUONGSU + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "1";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttDS, ttID));
                                    }

                                    List<APS_DON_THAMGIATOTUNG> dsTGTT = dt.APS_DON_THAMGIATOTUNG.Where(x => x.DONID == ID_DON).ToList();
                                    string ttTGTT = "";
                                    foreach (var itemDS in dsTGTT)
                                    {
                                        DM_DATAITEM tuCach = dt.DM_DATAITEM
                                            .Where(x => x.GROUPID == 16 && x.MA == itemDS.TUCACHTGTTID)
                                            .FirstOrDefault();

                                        ttTGTT = itemDS.HOTEN + " - " + tuCach.TEN;
                                        string ttID = itemDS.ID.ToString() + "0";
                                        ddlTenNguoiKC.Items.Add(new ListItem(ttTGTT, ttID));
                                    }

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";
                                }
                                else
                                {
                                    lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                    btnLuu.Enabled = false;
                                    btnLuu.CssClass = "disable_btn";
                                    break;
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                    }

                    lblMess.Text = "";

                    count++;
                }
                if (count == 0)
                {
                    //Ẩn ddl list đương sự
                    cboListND.Visible = false;
                    cboListBD.Visible = false;

                    //Thông báo
                    lblMess.Text = "Bạn chưa chọn vụ án để ghép!";

                    btnLuu.Enabled = false;
                    btnLuu.CssClass = "disable_btn";
                }
            }
        }

        protected void ddlListND_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal donid = Convert.ToDecimal(hddID_DON.Text);
            decimal idDuongSu = Convert.ToDecimal(ddlListND.SelectedValue);
            if (idDuongSu == 0)
            {
                ddlLoaiNguyendon.SelectedValue = "1";
                txtTennguyendon.Text = "";
                txtND_CMND.Text = "";
                chkBoxCMNDND.Checked = false;
                ddlND_Gioitinh.SelectedValue = "99";
                chkND_ONuocNgoai.Checked = false;
                txtND_Ngaysinh.Text = "";
                txtND_Namsinh.Text = "";
                txtND_TTChitiet.Text = "";
                txtND_NoiLamViec.Text = "";
                txtND_Email.Text = "";
                txtND_Dienthoai.Text = "";
                txtND_Fax.Text = "";
                ddlND_Quoctich.SelectedValue = "2";
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_NguyenDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDropNoiSongHuyen();
                Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_NguyenDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
            }
            else
            {
                //ADS
                if (ddlLoaiAn.SelectedValue == "2")
                {
                    ADS_DON_DUONGSU oDuongSu = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AHN
                else if (ddlLoaiAn.SelectedValue == "3")
                {
                    AHN_DON_DUONGSU oDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AKT
                else if (ddlLoaiAn.SelectedValue == "4")
                {
                    AKT_DON_DUONGSU oDuongSu = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //ALD
                else if (ddlLoaiAn.SelectedValue == "5")
                {
                    ADS_DON_DUONGSU oDuongSu = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AHC
                else if (ddlLoaiAn.SelectedValue == "6")
                {
                    AHC_DON_DUONGSU oDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //APS
                else if (ddlLoaiAn.SelectedValue == "7")
                {
                    APS_DON_DUONGSU oDuongSu = dt.APS_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdNguyenDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiNguyendon.SelectedValue = "1";

                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        chkISBVQLNK.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiNguyendon.SelectedValue = "2";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiNguyendon.SelectedValue = "3";

                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        chkISBVQLNK.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
                    }
                    txtTennguyendon.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtND_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDND.Checked = true;
                    }
                    ddlND_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlND_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlND_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlND_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkND_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkND_ONuocNgoai.Checked = false;
                    }
                    txtND_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtND_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtND_TTChitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtND_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtND_Email.Text = oDuongSu.EMAIL;
                    txtND_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtND_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_NguyenDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyen();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_NguyenDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
            }
        }

        protected void ddlListBD_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal donid = Convert.ToDecimal(hddID_DON.Text);
            decimal idDuongSu = Convert.ToDecimal(ddlListBD.SelectedValue);
            if (idDuongSu == 0)
            {
                ddlLoaiBidon.SelectedValue = "1";
                txtBD_Ten.Text = "";
                txtBD_CMND.Text = "";
                chkBoxCMNDND.Checked = false;
                ddlBD_Gioitinh.SelectedValue = "99";
                chkBD_ONuocNgoai.Checked = false;
                txtBD_Ngaysinh.Text = "";
                txtBD_Namsinh.Text = "";
                txtBD_Tamtru_Chitiet.Text = "";
                txtBD_NoiLamViec.Text = "";
                txtBD_Email.Text = "";
                txtBD_Dienthoai.Text = "";
                txtBD_Fax.Text = "";
                ddlBD_Quoctich.SelectedValue = "2";
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh_BiDon, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDropNoiSongHuyenBD();
                Cls_Comon.SetValueComboBox(ddlTamTru_Huyen_BiDon, Session[ENUM_SESSION.SESSION_QUAN_ID]);
            }
            else
            {
                //ADS
                if (ddlLoaiAn.SelectedValue == "2")
                {
                    ADS_DON_DUONGSU oDuongSu = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AHN
                else if (ddlLoaiAn.SelectedValue == "3")
                {
                    AHN_DON_DUONGSU oDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AKT
                else if (ddlLoaiAn.SelectedValue == "4")
                {
                    AKT_DON_DUONGSU oDuongSu = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //ALD
                else if (ddlLoaiAn.SelectedValue == "5")
                {
                    ALD_DON_DUONGSU oDuongSu = dt.ALD_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //AHC
                else if (ddlLoaiAn.SelectedValue == "6")
                {
                    AHC_DON_DUONGSU oDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                //APS
                else if (ddlLoaiAn.SelectedValue == "7")
                {
                    APS_DON_DUONGSU oDuongSu = dt.APS_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtIdBiDon.Text = oDuongSu.ID.ToString();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaiBidon.SelectedValue = "1";

                        pnBD_Canhan.Visible = true;
                        pnBD_Tochuc.Visible = false;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaiBidon.SelectedValue = "2";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaiBidon.SelectedValue = "3";

                        pnBD_Canhan.Visible = false;
                        pnBD_Tochuc.Visible = true;
                    }
                    txtBD_Ten.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND != null)
                    {
                        txtBD_CMND.Text = oDuongSu.SOCMND;
                    }
                    else
                    {
                        chkBoxCMNDBD.Checked = true;
                    }
                    ddlBD_Quoctich.SelectedValue = oDuongSu.QUOCTICHID.ToString();
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlBD_Gioitinh.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlBD_Gioitinh.SelectedValue = "0";
                    }
                    else
                    {
                        ddlBD_Gioitinh.SelectedValue = "99";
                    }
                    if (oDuongSu.SINHSONG_NUOCNGOAI == 1)
                    {
                        chkBD_ONuocNgoai.Checked = true;
                    }
                    else
                    {
                        chkBD_ONuocNgoai.Checked = false;
                    }
                    txtBD_Ngaysinh.Text = oDuongSu.NGAYSINH.HasValue ? oDuongSu.NGAYSINH.Value.ToString("dd/MM/yyyy") : "";
                    txtBD_Namsinh.Text = oDuongSu.NAMSINH.ToString();
                    txtBD_Tamtru_Chitiet.Text = oDuongSu.TAMTRUCHITIET;
                    txtBD_NoiLamViec.Text = oDuongSu.DIACHICOQUAN;
                    txtBD_Email.Text = oDuongSu.EMAIL;
                    txtBD_Dienthoai.Text = oDuongSu.DIENTHOAI;
                    txtBD_Fax.Text = oDuongSu.FAX;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamTru_Tinh_BiDon.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDropNoiSongHuyenBD();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamTru_Huyen_BiDon.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
            }
        }

        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                chkISBVQLNK.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                chkISBVQLNK.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), chkISBVQLNK.ClientID);
            }
        }

        protected void ddlLoaiBidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBidon.SelectedValue == "1")
            {
                pnBD_Canhan.Visible = true;
                pnBD_Tochuc.Visible = false;
            }
            else
            {
                pnBD_Canhan.Visible = false;
                pnBD_Tochuc.Visible = true;
            }
        }

        protected void ddlDK_NguoiDungDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlDK_NguoiDungDon.SelectedValue == "1")
            {
                pnDK_CaNhan.Visible = true;
                pnDK_ToChuc.Visible = false;
            }
            else
            {
                pnDK_CaNhan.Visible = false;
                pnDK_ToChuc.Visible = true;
            }
        }

        protected void Luu_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
                DON_GUINHAN checkLA = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();
                if (checkLA.TRANGTHAI != 5)
                {
                    //Đơn khởi kiện
                    if (checkLA.LOAIVANBAN == 1)
                    {
                        if (hdd_Type_Save.Text == "GhepDon")
                        {
                            if (SaveDataGhepDonKhoiKien())
                            {
                                //Cập nhận trạng thái DON_GUINHAN
                                checkLA.TRANGTHAI = 3;
                                dt.SaveChanges();

                                DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                                ls.THAOTAC = 1;
                                ls.NGAYTAO = DateTime.Now;
                                ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                ls.ID_VBDH = checkLA.ID_VBDH;

                                dt.DON_GUINHAN_LICHSU.Add(ls);
                                dt.SaveChanges();

                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                            }
                        }
                        else
                        {
                            if (SaveDataTiepNhan())
                            {
                                //Cập nhận trạng thái DON_GUINHAN
                                checkLA.TRANGTHAI = 2;
                                dt.SaveChanges();

                                DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                                ls.THAOTAC = 3;
                                ls.NGAYTAO = DateTime.Now;
                                ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                ls.ID_VBDH = checkLA.ID_VBDH;

                                dt.DON_GUINHAN_LICHSU.Add(ls);
                                dt.SaveChanges();

                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                            }
                        }
                    }
                    //Đơn kháng cáo
                    else if (checkLA.LOAIVANBAN == 2)
                    {
                        if (SaveDataGhepDonKhangCao())
                        {
                            //Cập nhận trạng thái DON_GUINHAN
                            checkLA.TRANGTHAI = 3;
                            dt.SaveChanges();

                            DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                            ls.THAOTAC = 1;
                            ls.NGAYTAO = DateTime.Now;
                            ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            ls.ID_VBDH = checkLA.ID_VBDH;

                            dt.DON_GUINHAN_LICHSU.Add(ls);
                            dt.SaveChanges();

                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                        }
                    }
                    //Đơn khác
                    else
                    {
                        if (SaveDataGhepDonKhac())
                        {
                            //Cập nhận trạng thái DON_GUINHAN
                            checkLA.TRANGTHAI = 3;
                            dt.SaveChanges();

                            DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                            ls.THAOTAC = 1;
                            ls.NGAYTAO = DateTime.Now;
                            ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            ls.ID_VBDH = checkLA.ID_VBDH;

                            dt.DON_GUINHAN_LICHSU.Add(ls);
                            dt.SaveChanges();

                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                        }
                    }
                }
                else
                {
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đơn đã được thu hồi, không thể tiếp tục xử lý!')", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Có lỗi xảy ra không thể lưu!');window.close(); window.opener.location.reload(); ", true);
            }
        }

        protected void TiepNhan_Click(object sender, EventArgs e) {
            LoadData();

            btnTiepNhan.Enabled = false;
            btnTiepNhan.CssClass = "disable_btn";

            btnGhepDon.Enabled = true;
            btnGhepDon.CssClass = "buttoninput";

            cboListND.Visible = false;
            cboListBD.Visible = false;

            pnData.Visible = false;

            hdd_Type_Save.Text = "TiepNhan";

            pnlThuocLoaiAn.Visible = true;
        }

        protected void TimKiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid();
            
            btnGhepDon.Visible = true;

            pnData.Visible = true;

            btnTiepNhan.Enabled = true;
            btnTiepNhan.CssClass = "buttoninput";

            pnlThuocLoaiAn.Visible = false;
        }

        protected void checkGhepDon_CheckedChanged(object sender, EventArgs e)
        {
            int count = 0;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox checkGD = (CheckBox)item.FindControl("checkGhepDon");
                HiddenField IDVuViec = (HiddenField)item.FindControl("hddIdVuViec");
                decimal ID_DON = Convert.ToDecimal(IDVuViec.Value);

                if (checkGD.Checked)
                {
                    count++;
                    if(count == 1)
                    {
                        checkGD.Checked = true;
                        lblMess.Text = "";
                    }
                    else
                    {
                        checkGD.Checked = false;
                        lblMess.Text = "Chỉ được chọn một vụ việc để ghép đơn!";
                        break;
                    }
                }
            }
        }
        
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadData();
            if(ddlLoaiAn.SelectedValue == "7")
            {
                pnTTThuLy.Visible = false;
                pnTTQDBA.Visible = false;
            }
            else
            {
                pnTTThuLy.Visible = true;
                pnTTQDBA.Visible = true;
            }
        }
    }
}