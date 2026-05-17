using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AKT
{
    public partial class DangVanBanTongDat_CongThongTin : System.Web.UI.Page
    {
        /*
           34	Dân sự
           33	Hình sự
           35	Hôn nhân & Gia đình
           150	Kinh doanh thương mại
           49	Hành chính
           36	Lao động
         */
        GSTPContext dt = new GSTPContext();
        private const string CAPXX_ST = "1", CAPXX_PT = "2", CAPXX_GDT = "3", CAPXX_TT = "4", LINHVUC_KDTM = "150";
        private const int TBTHULY_DS = 0, TBTHULY_HC = 1, TBTONGDAT = 2, TBKETQUA_UTTP = 3, TBTIMNGUOIVANGMAT = 4, TBPHASAN = 5;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadToaAn();
                    LoadVuViec();
                    hddPageIndexCT.Value = "1";
                    LoadDanhSach();
                }
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        private void LoadToaAn()
        {
            decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            // Nếu là tòa tối cao thì cho chọn tòa. Không thì chỉ hiện tên tòa login
            DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (toaan != null)
            {
                if (toaan.LOAITOA == "CAPCAO")
                {
                    ddlDonVi.DataSource = dt.DM_TOAAN.Where(x => x.ID == ToaAnID || x.CAPCHAID == ToaAnID).OrderBy(x => x.ARRTHUTU).ToList();
                    ddlDonVi.DataTextField = "TEN";
                }
                else
                {
                    DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                    ddlDonVi.DataSource = oBL.DM_TOAAN_GETBY(ToaAnID);
                    ddlDonVi.DataTextField = "arrTEN";
                }
                ddlDonVi.DataValueField = "ID";
                ddlDonVi.DataBind();
                if (toaan.LOAITOA == "TOICAO")
                {
                    ddlDonVi.Enabled = true;
                }
                else
                {
                    ddlDonVi.Enabled = false;
                    ddlDonVi.SelectedValue = toaan.ID + "";
                }
            }
        }
        private void LoadVuViec()
        {
            decimal DonID = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            if (DonID == 0)
            {
                txtTenVuViec.Enabled = txtSoBAQD.Enabled = true;
            }
            else
            {
                txtTenVuViec.Enabled = txtSoBAQD.Enabled = false;
                decimal GiaiDoan = 0;
                AKT_DON don = dt.AKT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (don != null)
                {
                    txtTenVuViec.Text = don.TENVUVIEC;
                    GiaiDoan = don.MAGIAIDOAN + "" == "" ? 0 : (decimal)don.MAGIAIDOAN;
                }
                if (GiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    AKT_SOTHAM_BANAN ba = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
                    if (ba != null)
                    {
                        txtSoBAQD.Text = ba.SOBANAN;
                    }
                }
                else if (GiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    AKT_PHUCTHAM_BANAN ba = dt.AKT_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
                    if (ba != null)
                    {
                        txtSoBAQD.Text = ba.SOBANAN;
                    }
                }
            }
        }
        private void LoadDanhSach()
        {
            lblMsg.Text = ltlDanhSach.Text = "";
            int Total = 0, PageSize = Convert.ToInt32(hddPageSize.Value), PageIndex = Convert.ToInt16(hddPageIndexCT.Value),
                Loai = Convert.ToInt32(ddlLoai.SelectedValue), TrangThai = Convert.ToInt32(rdoTrangThai.SelectedValue);
            decimal ToaAnID = Convert.ToDecimal(ddlDonVi.SelectedValue),
                DonID = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            string TenVuViec = txtTenVuViec.Text.Trim(), SoBanAn = txtSoBAQD.Text.Trim();
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",ToaAnID),
                new OracleParameter("vDonID",DonID),
                new OracleParameter("vLoai",Loai),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vSoBAQD",SoBanAn),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AKT_TONGDAT_GetVB_CTTDT", prm);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = Convert.ToInt32(tbl.Rows[0]["Total"]);
                if (TrangThai == 1)//Đã đăng
                {
                    ltlDanhSach.Text = "Danh sách văn bản tống đạt đã đăng lên cổng thông tin điện tử.";
                }
                else if (TrangThai == 0)// Chưa đăng
                {
                    ltlDanhSach.Text = "Danh sách văn bản tống đạt chưa đăng lên cổng thông tin điện tử.";
                }
                else
                {
                    ltlDanhSach.Text = "Danh sách văn bản tống đạt bị gỡ xuống.";
                }
            }
            if (TrangThai == 1)//Đã đăng
            {
                BtnGuiCongThongTinDienTu.Visible = false;
                pnDaDangTai.Visible = true; pnChuaDangTai.Visible = false; pnGoXuong.Visible = false;
                dgListDaDangTai.PageSize = PageSize;
                dgListDaDangTai.CurrentPageIndex = 0;
                dgListDaDangTai.DataSource = tbl;
                dgListDaDangTai.DataBind();
            }
            else if (TrangThai == 0)// Chưa đăng
            {
                pnDaDangTai.Visible = false; pnChuaDangTai.Visible = true; pnGoXuong.Visible = false;
                dgListChuaDangTai.PageSize = PageSize;
                dgListChuaDangTai.CurrentPageIndex = 0;
                dgListChuaDangTai.DataSource = tbl;
                dgListChuaDangTai.DataBind();
                if (Total == 0)
                {
                    BtnGuiCongThongTinDienTu.Visible = false;
                }
                else
                {
                    BtnGuiCongThongTinDienTu.Visible = true;
                }
            }
            else
            {
                BtnGuiCongThongTinDienTu.Visible = false;
                pnDaDangTai.Visible = false; pnChuaDangTai.Visible = false; pnGoXuong.Visible = true;
                DgListGoXuong.PageSize = PageSize;
                DgListGoXuong.CurrentPageIndex = 0;
                DgListGoXuong.DataSource = tbl;
                DgListGoXuong.DataBind();
            }
            #region "Xác định số lượng trang"
            hddTotalPageCT.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPageCT.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPageCT, hddPageIndexCT, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            if (Total == 0)
            {
                lstSobanghiT.Text = lstSobanghiB.Text = "";
                lblMsg.Text = "Không có dữ liệu.";
                pnDaDangTai.Visible = pnChuaDangTai.Visible = pnGoXuong.Visible = PhanTrangT.Visible = PhanTrangB.Visible = false;
            }
            else
            {
                PhanTrangT.Visible = PhanTrangB.Visible = true;
            }
        }
        protected void dgListDaDangTai_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Download":
                        AKT_TONGDAT oND = dt.AKT_TONGDAT.Where(x => x.ID == ID).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;
                }
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = (Convert.ToInt32(hddPageIndexCT.Value) - 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = Convert.ToInt32(hddTotalPageCT.Value).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = (Convert.ToInt32(hddPageIndexCT.Value) + 1).ToString();
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndexCT.Value = lbCurrent.Text;
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        #endregion
        protected void BtnGuiCongThongTinDienTu_Click(object sender, EventArgs e)
        {
            try
            {
                decimal TongDatID = 0;
                string prm_key = "dGFuZHRjL3NlcnZpY2UvZ3NvbG90aW9uL2FucHg=",
                    prm_linhVuc = LINHVUC_KDTM, StrLinhVuc = "kinh doanh thương mại", BMKhongThanhCong = "";

                bool IsChecked = false;
                foreach (DataGridItem item in dgListChuaDangTai.Items)
                {
                    CheckBox chkIsSend = (CheckBox)item.FindControl("chkIsSend");
                    if (chkIsSend.Checked)
                    {
                        IsChecked = true;
                        TongDatID = Convert.ToDecimal(item.Cells[0].Text);
                        AKT_TONGDAT tdat = dt.AKT_TONGDAT.Where(x => x.ID == TongDatID).FirstOrDefault();
                        if (tdat != null)
                        {
                            //int prm_type = tdat.LOAI_THONGBAO + "" == "" ? Convert.ToInt32(ddlLoai.SelectedValue) : Convert.ToInt32(tdat.LOAI_THONGBAO);
                            int prm_type = 0;
                            decimal bmID = tdat.BIEUMAUID + "" == "" ? 0 : (decimal)tdat.BIEUMAUID;
                            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.ID == bmID).FirstOrDefault();
                            if (bm != null)
                            {
                                string MaBM = bm.MABM + "", SoVuAn = "",
                                    prm_title = "", prm_toaThuLy = "", prm_soThongBao = "", prm_tenVuAn = "",
                                    prm_nguoiKhoiKien = "", prm_diaChi = "", prm_capXetXu = "", FileName = tdat.TENFILE + tdat.KIEUFILE,
                                    FileNoiDung = "", prm_nguoiBiKien = "", TenToaThuLy = "";
                                if (tdat.NOIDUNGFILE + "" != "")
                                {
                                    FileNoiDung = System.Convert.ToBase64String(tdat.NOIDUNGFILE);
                                }
                                DateTime prm_ngayHieuLuc = DateTime.MinValue;
                                decimal DONID = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + ""),
                                    ToaThuLyID = 0;
                                AKT_DON don = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                                if (don != null)
                                {
                                    prm_tenVuAn = don.TENVUVIEC;
                                    SoVuAn = don.MAVUVIEC + "";
                                }
                                if (bm.GIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM.ToString())// sơ thẩm
                                {
                                    prm_capXetXu = CAPXX_ST;
                                    if (don != null)
                                    {
                                        ToaThuLyID = don.TOAANID + "" == "" ? 0 : (decimal)don.TOAANID;
                                    }
                                    AKT_SOTHAM_THULY ThuLyST = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == DONID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
                                    if (ThuLyST != null)
                                    {
                                        prm_ngayHieuLuc = ThuLyST.NGAYTHULY + "" == "" ? DateTime.MinValue : (DateTime)ThuLyST.NGAYTHULY;
                                        prm_soThongBao = ThuLyST.SOTHONGBAO + "/" + prm_ngayHieuLuc.Year.ToString();
                                    }
                                }
                                else if (bm.GIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
                                {
                                    prm_capXetXu = CAPXX_PT;
                                    if (don != null)
                                    {
                                        ToaThuLyID = don.TOAPHUCTHAMID + "" == "" ? 0 : (decimal)don.TOAPHUCTHAMID;
                                    }
                                    AKT_PHUCTHAM_THULY ThuLyPT = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == DONID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
                                    if (ThuLyPT != null)
                                    {
                                        prm_ngayHieuLuc = ThuLyPT.NGAYTHULY + "" == "" ? DateTime.MinValue : (DateTime)ThuLyPT.NGAYTHULY;
                                        prm_soThongBao = ThuLyPT.SOTHONGBAO + "/" + prm_ngayHieuLuc.Year.ToString();
                                    }
                                }
                                else if (bm.GIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT.ToString())
                                {
                                    prm_capXetXu = CAPXX_GDT;
                                }

                                AKT_DON_DUONGSU NguoiKhoiKien = dt.AKT_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).FirstOrDefault();
                                if (NguoiKhoiKien != null)
                                {
                                    if (NguoiKhoiKien.GIOITINH == 1)
                                    {
                                        prm_nguoiKhoiKien = "Ông " + NguoiKhoiKien.TENDUONGSU;
                                    }
                                    else
                                    {
                                        prm_nguoiKhoiKien = "Bà " + NguoiKhoiKien.TENDUONGSU;
                                    }
                                    decimal HuyenID = NguoiKhoiKien.TAMTRUID + "" == "" ? 0 : (decimal)NguoiKhoiKien.TAMTRUID;
                                    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault();
                                    if (hc != null)
                                    {
                                        prm_diaChi = hc.MA_TEN;
                                    }
                                }

                                AKT_DON_DUONGSU NguoiBiKien = dt.AKT_DON_DUONGSU.Where(x => x.DONID == DONID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).FirstOrDefault();
                                if (NguoiBiKien != null)
                                {
                                    if (NguoiBiKien.GIOITINH == 1)
                                    {
                                        prm_nguoiBiKien = "Ông " + NguoiBiKien.TENDUONGSU;
                                    }
                                    else
                                    {
                                        prm_nguoiBiKien = "Bà " + NguoiBiKien.TENDUONGSU;
                                    }
                                }

                                DM_TOAAN ToaThuLy = dt.DM_TOAAN.Where(x => x.ID == ToaThuLyID).FirstOrDefault();
                                if (ToaThuLy != null)
                                {
                                    prm_toaThuLy = ToaThuLy.MADONGBO;
                                    TenToaThuLy = ToaThuLy.MA_TEN;
                                }
                                prm_title = "Ngày ";
                                string strNgayHieuLuc = prm_ngayHieuLuc + "" == "" ? "" : ((DateTime)prm_ngayHieuLuc).ToString("dd/MM/yyyy");
                                
                                if (MaBM == "30-DS" || MaBM == "65-DS")// Thông báo thụ lý dân sự
                                {
                                    prm_title = "Ngày " + strNgayHieuLuc + ", " + TenToaThuLy + " đã thụ lý vụ án " + StrLinhVuc + " số " + prm_soThongBao + " về việc: " + prm_tenVuAn + ", theo đơn khởi kiện của: " + prm_nguoiKhoiKien + ", địa chỉ: " + prm_diaChi + ".";
                                    prm_type = TBTHULY_DS;
                                }
                                else if (MaBM == "TBKQUTTP") // Thông báo kết quả ủy thác tư pháp
                                {
                                    prm_type = TBKETQUA_UTTP;
                                }
                                else if (MaBM == "TBVM") // Thông báo tìm người vắng mặt 
                                {
                                    prm_title = "Ngày " + strNgayHieuLuc + ", " + TenToaThuLy + " thông báo cho " + prm_nguoiKhoiKien + " về việc: " + prm_tenVuAn + ", địa chỉ: " + prm_diaChi + ".";
                                    prm_type = TBTIMNGUOIVANGMAT;
                                }
                                else // Tống đạt
                                {
                                    prm_type = TBTONGDAT;
                                }
                                #region Kết nối Oracle Soap Webservice
                                WS_CTTDT.UCMServicesMngrClient ucmClient = new WS_CTTDT.UCMServicesMngrClient();
                                WS_CTTDT.thongBaoType param = new WS_CTTDT.thongBaoType();
                                WS_CTTDT.file file = new WS_CTTDT.file();
                                file.fileContent = FileNoiDung;
                                file.fileName = FileName;
                                param.key = prm_key;
                                param.ngayHieuLuc = prm_ngayHieuLuc;
                                param.toaThuLy = prm_toaThuLy;
                                param.linhVuc = prm_linhVuc;
                                param.soThongBao = prm_soThongBao;
                                param.tenVuAn = prm_tenVuAn;
                                param.nguoiKhoiKien = prm_nguoiKhoiKien;
                                param.title = prm_title;
                                param.diaChi = prm_diaChi;
                                param.capXetXu = prm_capXetXu;
                                param.type = prm_type;
                                param.file = file;
                                if (MaBM != "30-DS" || MaBM != "65-DS")// Thông báo thụ lý dân sự không có tham số này
                                {
                                    param.nguoiBiKien = prm_nguoiBiKien;
                                }
                                WS_CTTDT.message result = new WS_CTTDT.message();
                                try
                                {
                                    result = ucmClient.getQuanLyAn(param);
                                    tdat.NGAYDANG_CTTDT = DateTime.Now;
                                    tdat.TRANGTHAI = 1;// Đã đăng lên CTTDT thành công
                                    dt.SaveChanges();
                                }
                                catch
                                {
                                    lblMsg.Text = "Không kết nối được với Service. Hãy thử lại!";
                                    return;
                                }
                                if (result.code != "00")
                                {
                                    if (BMKhongThanhCong == "")
                                    {
                                        BMKhongThanhCong = bm.TENBM;
                                    }
                                    else { BMKhongThanhCong += ", " + bm.TENBM; }
                                }
                                #endregion
                            }
                        }
                    }
                }
                if (IsChecked == false)
                {
                    lblMsg.Text = "Chưa chọn văn bản để đăng lên cổng thông tin điện tử.";
                    return;
                }
                hddPageIndexCT.Value = "1";
                LoadDanhSach();
                if (BMKhongThanhCong == "")
                {
                    lblMsg.Text = "Đăng lên cổng thông tin điện tử thành công!";
                }
                else
                {
                    lblMsg.Text = "Các biểu mẫu đăng không thành công: " + BMKhongThanhCong;
                }
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void ddlLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void BtnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndexCT.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
        protected void rdoTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (rdoTrangThai.SelectedValue == "0")// Chưa đăng
                {
                    BtnGuiCongThongTinDienTu.Visible = true;
                }
                else
                {
                    BtnGuiCongThongTinDienTu.Visible = false;
                }
                hddPageIndexCT.Value = "1";
                LoadDanhSach();
            }
            catch (Exception ex) { lblMsg.Text = ex.Message; }
        }
    }
}