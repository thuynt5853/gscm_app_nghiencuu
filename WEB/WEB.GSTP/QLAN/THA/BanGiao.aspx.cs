using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.BANGIAOAN;
using BL.GSTP.QLHS;
using BL.GSTP.THA;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA
{
    public partial class BanGiao : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    //LoadDropdownLoadAn();
                    //LoadCombobox();
                    //LoadDropThamphan();
                    LoadDropTinhTrangGQ();
                    LoadDropLoai();
                    //LoadDropTrangThaiGiaiQuyet();
                    //LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdHuyChuyen, false);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        void LoadDropLoai()
        {
            dropLoaiLuaChon.Items.Clear();
            //dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            dropLoaiLuaChon.Items.Add(new ListItem("Bị án được uỷ thác THA", "2"));
            //dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "2"));
        }
        void LoadDropTinhTrangGQ()
        {
            dropTinhTrangGQ.Items.Clear();
            dropTinhTrangGQ.Items.Add(new ListItem("--Tất cả--", "0"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Chưa giải quyết", "1"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã thụ lý", "2"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã giải quyết", "6"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ thi hành án", "3"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ ủy thác thi hành án", "4"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có GQ đơn/CV yêu cầu thi hành án", "5"));

        }
        //private void LoadDropdownLoadAn()
        //{
        //    ddlLoaiAn.Items.Clear();
        //    ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
        //    ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIAN.AN_HINHSU));
        //    ddlLoaiAn.Items.Add(new ListItem("HN & GĐ", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
        //    ddlLoaiAn.Items.Add(new ListItem("KD, TM", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
        //    ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
        //    ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
        //    ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));
        //    ddlLoaiAn.Items.Add(new ListItem("BP XLHC", ENUM_LOAIAN.BPXLHC));
        //    ddlLoaiAn.SelectedIndex = 0;
        //}

        // Kiểm tra cấp xét xử để hiện thị combobox tương ứng
        //private void LoadCombobox()
        //{
        //    List<string> fullCapAns = new List<string>
        //    {
        //        ENUM_LOAIAN.AN_HINHSU,
        //        ENUM_LOAIAN.AN_HONNHAN_GIADINH,
        //        ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI,
        //        ENUM_LOAIAN.AN_LAODONG,
        //        ENUM_LOAIAN.AN_HANHCHINH,
        //        ENUM_LOAIAN.AN_DANSU
        //    };

        //    dropCapxx.Items.Clear();

        //    var loaiAnId = ddlLoaiAn.SelectedValue;

        //    if (fullCapAns.Contains(loaiAnId))
        //    {
        //        // Cấp xét xử là cấp huyện
        //        if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
        //        {
        //            dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
        //        }

        //        // Cấp xét xử là cấp tỉnh
        //        else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
        //        {
        //            dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
        //            dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
        //            dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
        //        }

        //        // Cấp xét xử là cấp cao
        //        else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
        //        {
        //            dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
        //        }

        //        // Hiển thị thị tất cả nếu không thoả mãn điều kiện
        //        else
        //        {
        //            //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
        //            dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
        //            //dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
        //        }
        //    }
        //    else
        //    {
        //        dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
        //    }

        //    dropCapxx.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
        //}

        //private void LoadDropThamphan()
        //{
        //    Boolean IsLoadAll = true;
        //    ddlThamphan.Items.Clear();
        //    Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
        //    // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
        //    // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
        //    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
        //    if (oCB != null)
        //    {
        //        // Kiểm tra chức danh có là thẩm phán hay không
        //        if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
        //        {
        //            DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
        //            if (oCD.MA.Contains("TP"))
        //            {
        //                ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
        //                IsLoadAll = false;
        //            }
        //        }
        //        // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
        //        if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
        //        {
        //            DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
        //            if (oCD.MA.Contains("CA"))
        //            {
        //                IsLoadAll = true;
        //            }
        //        }
        //    }
        //    if (IsLoadAll)
        //    {
        //        DM_CANBO_BL objBL = new DM_CANBO_BL();
        //        decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //        // decimal LoginDonViID = 0;
        //        DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
        //        ddlThamphan.DataSource = tbl;
        //        ddlThamphan.DataTextField = "HOTEN";
        //        ddlThamphan.DataValueField = "ID";
        //        ddlThamphan.DataBind();
        //        ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
        //    }
        //}

        //private void LoadDropTrangThaiGiaiQuyet()
        //{
        //    ddlTrangThaiGiaiQuyet.Items.Clear();

        //    var trangThaiNhan = rdbTrangthai.SelectedValue;

        //    if (trangThaiNhan == "1")
        //    {
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("-- Tất cả --", ""));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("+ Chưa giải quyết xong", "1"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Chưa phân công Thẩm phán", "2"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã phân công Thẩm phán", "3"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã lên lịch xét xử", "4"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đang hoãn", "5"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đang tạm đình chỉ", "6"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("+ Đã giải quyết xong", "7"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã xét xử", "8"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đình chỉ", "9"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Công nhận thỏa thuận của đương sự", "10"));
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Chuyển vụ án", "11"));
        //    }
        //    else
        //    {
        //        ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("Chưa giải quyết xong", "1"));
        //    }
        //}

        protected void dropLoaiLuaChon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dropTinhTrangGQ.SelectedIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        // Hiện thị nội dung danh sách
        private void LoadGrid()
        {
            lbthongbao.Text = "";

            //if (ddlLoaiAn.SelectedValue == "-1")
            //{
            //    return;
            //}

            string mavuan = txtMaVuAn.Text.Trim();
            string tenvuan = txtTenVuAn.Text.Trim();
            string mabian = txtMaBiAn.Text.Trim();
            string tenbian = txtTenBiAn.Text.Trim();
            string sobanan = txtSoBanAn.Text.Trim();

            DateTime ngaybanan = (string.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            int loai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
            int tinhtrangGQ = Convert.ToInt32(dropTinhTrangGQ.SelectedValue);
            int trangthaiGQ = Convert.ToInt32(ddlTrangThaiGiaiQuyet.SelectedValue);
            //Id đơn vị
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            // Khởi tạo
            THA_BANGIAO_MAPPING_BL oBL = new THA_BANGIAO_MAPPING_BL();
            string current_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal ID = Convert.ToDecimal(current_id);

            DataTable oDT = oBL.THA_DS_BANGIAO(loai,rdbTrangthai.SelectedValue, vDonViID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, trangthaiGQ, txtCMND.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim());

            #region "Xác định số lượng trang"

            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            #endregion "Xác định số lượng trang"
            foreach (DataRow row in oDT.Rows)
            {
                if (row["NGAYBANAN"] != DBNull.Value && !string.IsNullOrWhiteSpace(row["NGAYBANAN"].ToString()))
                {
                    row["NGAYBANAN"] = DateTime.Parse(row["NGAYBANAN"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault)
                                            .ToString("dd/MM/yyyy");
                }
                else
                {
                    row["NGAYBANAN"] = "";
                }
                
                if (row["VUANID"] == DBNull.Value || string.IsNullOrWhiteSpace(row["VUANID"].ToString()))
                {
                    row["VUANID"] = row["IDVUANHETHONG"].ToString();
                }
            }

            dgList.DataSource = oDT;
            dgList.DataBind();

            Cls_Comon.SetButton(cmdNhanan, false);
            Cls_Comon.SetButton(cmdHuyChuyen, false);
        }

        // Xử lý tìm kiếm khi click tìm kiếm
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        // Xử lý nhận án khi click nhận án
        protected void cmdNhanan_Click(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = "";
                int loai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
                List<BANGIAOAN_INPUT> data = new List<BANGIAOAN_INPUT>();
                //fill data
                foreach (DataGridItem Item in dgList.Items)
                {

                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");

                    // Kiểm tra trang thái chọn
                    if (chkChon.Checked)
                    {
                        // Lấy thông tin các cột tương ứng
                        BANGIAOAN_INPUT input = new BANGIAOAN_INPUT();
                        input.VuViecId = Item.Cells[0].Text;
                        input.VuViecLoai = loai != 1 ? "THA" : "AHS";
                        input.VuViecMa = Item.Cells[1].Text;
                        input.VuViecTen = Item.Cells[2].Text;

                        /*if (hddTHGiaoNhan.Value != null)
                        {
                            input.TruongHopGiaoNhan = hddTHGiaoNhan.Value;
                        }
                        else
                        {
                            input.TruongHopGiaoNhan = "Không có thẩm quyền giải quyết";
                        }*/

                        //input.LyDoId = hddLydo.Value;
                        //input.isEnableToaAnTen = true;
                        //decimal IDVUAN = Convert.ToDecimal(input.VuViecId);
                        //if (ddlLoaiAn.SelectedValue == "0")
                        //{
                        //    ADS_DON_XULY donXuLy = dt.ADS_DON_XULY.Where(x => x.DONID == IDVUAN).FirstOrDefault();
                        //    decimal idToaNhan = donXuLy.CDTN_TOAANID ?? 0;
                        //    DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == idToaNhan).FirstOrDefault();
                        //    if (toaAn != null)
                        //    {
                        //        input.ToaAnNhanId = toaAn.ID.ToString();
                        //        input.ToaAnNhanTen = toaAn.MA_TEN;
                        //    }
                        //}

                        // Thêm thông tin
                        decimal toaanST = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        var toaan = dt.DM_TOAAN.Where(x => x.ID == toaanST).FirstOrDefault<DM_TOAAN>();
                        txtTOAANGIAO.Text = toaan != null ? toaan.TEN : "";
                        txtTOAANGIAO.ToolTip = toaan != null ? toaan.TEN : "";
                        txtNGUOIGIAO.Text = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                        txtNGUOIGIAO.ToolTip = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                        //txtNGUOIKY.Text = Session[ENUM_SESSION.SESSION_USERTEN].ToString();
                        //txtNGUOIKY.ToolTip = Session[ENUM_SESSION.SESSION_USERTEN].ToString();
                        data.Add(input);
                    }
                }

                //rptCapNhat.DataSource = data;
                //rptCapNhat.DataBind();

                //ViewState["Items"] = data;
                dgItems.DataSource = data;
                dgItems.DataBind();

                pnDanhsach.Visible = false;
                pnCapnhat.Visible = true;

                LoadFormConfirm();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        // Set trang thái hiện thị button tương ứng khi vụ việc được chọn
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanan, false);
            Cls_Comon.SetButton(cmdHuyChuyen, false);
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
            var listchkChon = new List<bool>();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    listchkChon.Add(chkChon.Checked);
                }
            }
            if (listchkChon.Count > 0)
            {
                if (rdbTrangthai.SelectedValue != "1")
                    Cls_Comon.SetButton(cmdNhanan, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
        }

        public void LoadFormConfirm()
        {
            try
            {
                // Clear previous error messages
                lbthongbaoNA.Text = "";
                // Toà án giao
                if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                {
                    hddToaAnGiaoId.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                }

                // Người giao
                if (Session[ENUM_SESSION.SESSION_USERNAME] != null)
                {
                    hddNguoiGiaoId.Value = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                }

                //Ngày giao
                tbFNgayGiao.Text = DateTime.Now.ToString("dd/MM/yyyy");

                // Toà án nhận
                LoadDropToaAnNhan();

                // Quyết định chuyển
                cbFQuyetDinhChuyen.Checked = true;

                //Ngày quyết định
                tbFNgayQuyetDinh.Text = DateTime.Now.ToString("dd/MM/yyyy");

                // Ghi chú
                //tbFGhiChu.Text = "";

                // Lý do
                LoadDropLyDo();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        public void LoadDropToaAnNhan()
        {
            BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL tachNhapMappingBL = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();

            // LoadDrop Toà án nhận
            // Lấy danh sách những toà cùng cấp
            decimal currentToaAnId = 0;
            if (decimal.TryParse(Session[ENUM_SESSION.SESSION_DONVIID].ToString(), out currentToaAnId))
            {
                DataTable dtNewToaAns = tachNhapMappingBL.GETS_BY_TOAANTID(currentToaAnId);
                if (dtNewToaAns != null && dtNewToaAns.Rows != null && dtNewToaAns.Rows.Count > 0)
                {
                    dropToaAnNhan.Items.Clear();
                    dropToaAnNhan.DataSource = null;
                    dropToaAnNhan.DataBind();
                    dropToaAnNhan.Items.Add(new ListItem("--- Chọn tòa án ---", "0"));
                    var firstToaAnNhan = "";

                    foreach (DataRow row in dtNewToaAns.Rows)
                    {
                        // Kiểm tra không trùng thì thêm
                        if (dropToaAnNhan.Items.FindByValue(row["TOTOAANID"].ToString()) == null && row["TOTOAANID"].ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                        {
                            ListItem listItem = new ListItem();

                            listItem.Value = row["TOTOAANID"].ToString();
                            listItem.Text = row["TOTOAANTEN"].ToString();
                            if (string.IsNullOrWhiteSpace(firstToaAnNhan))
                            {
                                firstToaAnNhan = listItem.Value;
                            }
                            dropToaAnNhan.Items.Add(listItem);
                        }
                    }

                    // Gán thông tin toà đầu tiên cho toà nhận
                    decimal toaAnNhanId;
                    if (decimal.TryParse(firstToaAnNhan, out toaAnNhanId) && dropToaAnNhan.Items.FindByValue(toaAnNhanId.ToString()) != null)
                    {
                        dropToaAnNhan.SelectedValue = toaAnNhanId.ToString();
                    }
                }
            }
        }

        public void LoadDropLyDo()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtLyDo = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOBANGIAOAN);

            // Load dữ liệu Lý do
            dropLyDo.Items.Clear();
            if (dtLyDo != null && dtLyDo.Rows.Count > 0)
            {
                foreach (DataRow row in dtLyDo.Rows)
                    dropLyDo.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
            }

            // Đặt lý do mặc định
            if (!string.IsNullOrEmpty(hddLyDoMa.Value))
            {
                dropLyDo.SelectedValue = ENUM_LYDOBANGIAOAN_MA.SAPNHAP;
            }
        }

        protected void cbFQuyetDinhChuyen_CheckedChanged(object sender, EventArgs e)
        {
            // Kiểm tra trạng thái quyết định chuyển
            if (cbFQuyetDinhChuyen.Checked)
            {
                tbFSoQuyetDinh.Enabled = true;
                tbFNgayQuyetDinh.Enabled = true;
            }
            else
            {
                tbFSoQuyetDinh.Enabled = false;
                tbFNgayQuyetDinh.Enabled = false;
            }
        }

        // Validation form bàn giao
        private bool ValidateBanGiaoForm()
        {
            // Kiểm tra Ngày chuyển (bắt buộc)
            if (string.IsNullOrWhiteSpace(tbFNgayGiao.Text))
            {
                lbthongbaoNA.Text = "Bạn hãy nhập ngày chuyển!";
                return false;
            }

            // Kiểm tra định dạng ngày chuyển
            DateTime ngayGiao;
            if (!DateTime.TryParseExact(tbFNgayGiao.Text.Trim(), "dd/MM/yyyy", cul, DateTimeStyles.None, out ngayGiao))
            {
                lbthongbaoNA.Text = "Ngày chuyển không đúng định dạng (dd/MM/yyyy)!";
                return false;
            }

            // Kiểm tra ngày chuyển không được trong quá khứ
            if (ngayGiao.Date < DateTime.Now.Date)
            {
                lbthongbaoNA.Text = "Ngày chuyển không được trong quá khứ!";
                return false;
            }

            // Kiểm tra Tòa án nhận (bắt buộc)
            if (dropToaAnNhan.SelectedValue == "0" || string.IsNullOrWhiteSpace(dropToaAnNhan.SelectedValue))
            {
                lbthongbaoNA.Text = "Bạn hãy chọn tòa án nhận!";
                return false;
            }

            // Kiểm tra Lý do chuyển (bắt buộc)
            if (string.IsNullOrWhiteSpace(dropLyDo.SelectedValue))
            {
                lbthongbaoNA.Text = "Bạn hãy chọn lý do chuyển!";
                return false;
            }

            // Kiểm tra Quyết định chuyển
            if (cbFQuyetDinhChuyen.Checked)
            {
                // Nếu có quyết định chuyển thì phải nhập số quyết định và ngày quyết định
                if (string.IsNullOrWhiteSpace(tbFSoQuyetDinh.Text))
                {
                    lbthongbaoNA.Text = "Bạn hãy nhập số quyết định!";
                    return false;
                }

                if (string.IsNullOrWhiteSpace(tbFNgayQuyetDinh.Text))
                {
                    lbthongbaoNA.Text = "Bạn hãy nhập ngày quyết định!";
                    return false;
                }

                // Kiểm tra định dạng ngày quyết định
                DateTime ngayQuyetDinh;
                if (!DateTime.TryParseExact(tbFNgayQuyetDinh.Text.Trim(), "dd/MM/yyyy", cul, DateTimeStyles.None, out ngayQuyetDinh))
                {
                    lbthongbaoNA.Text = "Ngày quyết định không đúng định dạng (dd/MM/yyyy)!";
                    return false;
                }

                // Kiểm tra ngày quyết định không được trong quá khứ
                if (ngayQuyetDinh.Date < DateTime.Now.Date)
                {
                    lbthongbaoNA.Text = "Ngày quyết định không được trong quá khứ!";
                    return false;
                }
            }

            return true;
        }

        // Lưu bàn giao
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            try
            {
                // Kiểm tra validation trước khi lưu
                if (!ValidateBanGiaoForm())
                {
                    return;
                }
                foreach (DataGridItem Item in dgItems.Items)
                {
                    THI_HANH_AN_BANGIAO_MAPPING vuAn = new THI_HANH_AN_BANGIAO_MAPPING();
                    vuAn.TOAANGIAOID = Convert.ToDecimal(hddToaAnGiaoId.Value);
                    vuAn.TOAANNHANID = Convert.ToDecimal(dropToaAnNhan.SelectedValue);
                    vuAn.VUVIECID = Item.Cells[0].Text;
                    vuAn.VUVIECLOAI = Item.Cells[1].Text;
                    vuAn.VUVIECMA = Item.Cells[2].Text;
                    vuAn.VUVIECTEN = Item.Cells[3].Text;
                    vuAn.NGUOIGIAOID = hddNguoiGiaoId.Value;
                    vuAn.LYDOMA = dropLyDo.SelectedValue;
                    vuAn.NGAYGIAO = (string.IsNullOrEmpty(tbFNgayGiao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(tbFNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    vuAn.ISQUYETDINHCHUYEN = cbFQuyetDinhChuyen.Checked ? 1 : 0;
                    vuAn.SOQUYETDINH = tbFSoQuyetDinh.Text;
                    vuAn.NGAYQUYETDINH = (string.IsNullOrEmpty(tbFNgayQuyetDinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(tbFNgayQuyetDinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    vuAn.TRANGTHAI = ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_CHONHAN;
                    vuAn.NGUOIKY = txtNGUOIKY.Text;
                    vuAn.GHICHU = "";

                    // Add
                    THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();
                    bl.ADD(vuAn);
                }

                LoadGrid();
                lbthongbao.Text = "Bàn giao thành công!";
                pnDanhsach.Visible = true;
                pnCapnhat.Visible = false;

                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
            catch (Exception ex)
            {
                LoadGrid();
                lbthongbao.Text = "Bàn giao thất bại! " + ex.Message;
                pnDanhsach.Visible = true;
                pnCapnhat.Visible = false;

                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
        }


        // Quay lại
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            lbthongbaoNA.Text = "";
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
        }
        protected bool IsDisabledStatus(object status)
        {
            if (status == null) return false;

            string statusValue = status.ToString();
            return statusValue == ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_DANHAN;
        }

        protected bool IsRbTrangthai()
        {
            return rdbTrangthai.SelectedValue == "1";
        }

        protected string GetStatusStr(object status)
        {
            if (status == null) return string.Empty;
            string statusValue = string.Empty;
            switch (status.ToString())
            {
                case ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_DANHAN:
                    statusValue = "Đã nhận";
                    break;
                case ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_CHONHAN:
                    statusValue = "Chờ nhận";
                    break;
                case ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_TUCHOI:
                    statusValue = "Từ chối";
                    break;
            }
            return statusValue;
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;

                    //Literal lstNgaythuly = (Literal)e.Item.FindControl("lstNgaythuly");
                    //Literal lstNoiDung = (Literal)e.Item.FindControl("lstNoiDung");
                    // HiddenField hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
                    //HiddenField hddTHGiaoNhan = (HiddenField)e.Item.FindControl("hddTHGiaoNhan");
                    CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                    string strID = e.Item.Cells[0].Text, strNoiDung = "";
                    decimal ID = Convert.ToDecimal(strID), MaGiaiDoan = 0;
                    //hddTHGiaoNhan.Value = strNoiDung;
                    //lstNoiDung.Text = "<b>- Lý do:</b> " + strNoiDung + "<br/>" + rv["v_NOIDUNG"];
                    //if (rdbTrangthai.SelectedValue == "1" && rv["v_NOIDUNG"].ToString().Contains("- Lý do:"))
                    //{
                    //    lstNoiDung.Text = rv["v_NOIDUNG"].ToString();
                    //}

                    LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                    if (rdbTrangthai.SelectedValue == "1")
                        lbtHuyChuyen.Visible = true;
                    else
                        lbtHuyChuyen.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Lỗi: " + ex.Message;
                }
            }
        }

        //protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadCombobox();
        //    }
        //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
        //}

        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTinhTrangGQ();

                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        
        protected void rdbTrangthaiGQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        /// <summary>
        /// DataBound event của DataGrid - Xử lý null values an toàn
        /// </summary>
        protected void dgItems_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    // Xử lý dữ liệu của từng row để đảm bảo không có lỗi null
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                }
            }
            catch (Exception ex)
            {
                // Không throw exception để tránh crash trang
            }
        }

        // Click nút huỷ chuyển
        protected void cmdHuyChuyen_Click(object sender, EventArgs e)
        {
            try
            {
                List<decimal?> lstDonID = new List<decimal?>();
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        var DonID = Convert.ToDecimal(chkChon.ToolTip);
                        lstDonID.Add(DonID);
                    }
                }

                if (lstDonID.Count > 0)
                    HuyBanGiaoAn(lstDonID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                var chuyenAnId = Convert.ToDecimal(e.CommandArgument.ToString());
                List<decimal?> lstChuyenAnID = new List<decimal?>();
                lstChuyenAnID.Add(chuyenAnId);
                switch (e.CommandName)
                {
                    case "HuyChuyen":
                        HuyBanGiaoAn(lstChuyenAnID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void HuyBanGiaoAn(List<decimal?> lstChuyenAnID)
        {
            string nd = "";
            try
            {
                for (int i = 0; i < lstChuyenAnID.Count; i++)
                {
                    string Msg_Ex = "Không được phép hủy chuyển án.";
                    var ChuyenAnId = Convert.ToDecimal(lstChuyenAnID[i]);
                    THA_BANGIAO_MAPPING_BL oBL = new THA_BANGIAO_MAPPING_BL();
                    oBL.DELETE(ChuyenAnId);
                }
                nd = "Hủy chuyển thành công.";
            }
            catch (Exception ex)
            {
                nd = ex.Message.ToString();
            }
            LoadGrid();
            lbthongbao.Text = nd;
        }

        // Function huỷ chuyển án
        private void HuyChuyen(List<decimal> lstChuyenAnID)
        {
            ADS_CHUYEN_NHAN_AN_BL Bl = new ADS_CHUYEN_NHAN_AN_BL();
            string nd = "";
            for (int i = 0; i < lstChuyenAnID.Count; i++)
            {
                string Msg_Ex = "Không được phép hủy chuyển án.";
                var ChuyenAnId = lstChuyenAnID[i];
                ADS_CHUYEN_NHAN_AN oChuyenAn = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenAnId).FirstOrDefault();
                ADS_DON_XULY dxl = dt.ADS_DON_XULY.Where(x => x.DONID == oChuyenAn.VUANID).FirstOrDefault();
                if (oChuyenAn != null)
                {
                    decimal DonID = oChuyenAn.VUANID.Value;
                    // string rs = Bl.Check_NhanAn(DonID, Msg_Ex, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (oChuyenAn.TRANGTHAI != 1) // Án chưa nhận
                    {
                        dt.ADS_CHUYEN_NHAN_AN.Remove(oChuyenAn);
                        dt.SaveChanges();
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        //10092021 insert quản lý hồ sơ trạng thái kháng nghị kháng cáo
                        new QLHS_BL().DeleteHoSoLuTruCoChuyenAn(DonID, ENUM_LOAIVUVIEC_NUMBER.AN_DANSU);

                        //manhnd 10/12/2021 cap nhat lai MAGIAIDON sau khi huy chuyen
                        ADS_DON_GIAIDOAN oGD = dt.ADS_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAANID == oChuyenAn.TOACHUYENID).FirstOrDefault();
                        ADS_DON oDon = dt.ADS_DON.Where(X => X.ID == DonID).FirstOrDefault();
                        oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                        dt.SaveChanges();
                    }
                    else
                    {
                        string Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == oChuyenAn.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Msg_Ex;
                        lbthongbao.Text = Result;
                        return;
                    }
                }
                if (dxl.LOAIGIAIQUYET == 1)
                {
                    nd = "Hủy chuyển đơn thành công.";
                }
                else
                {
                    nd = "Hủy chuyển án thành công.";
                }
            }
            LoadGrid();
            lbthongbao.Text = nd;
        }

        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var hddVuViecIdCurrent = e.Item.FindControl("hddVuViecId") as HiddenField;
            var hddLyDoMa = e.Item.FindControl("hddLyDoMa") as HiddenField;
            var hddToaAnNhanId = e.Item.FindControl("hddToaAnNhanId") as HiddenField;

            #region DropDown Lý do
            DropDownList lyDoSelectList = e.Item.FindControl("dropLyDo") as DropDownList;
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtLyDo = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOBANGIAOAN);

            // Load dữ liệu Lý do
            lyDoSelectList.Items.Clear();
            if (dtLyDo != null && dtLyDo.Rows.Count > 0)
            {
                foreach (DataRow row in dtLyDo.Rows)
                    lyDoSelectList.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
            }

            // Chọn lý do hiện tại
            if (!string.IsNullOrEmpty(hddLyDoMa.Value))
            {
                lyDoSelectList.SelectedValue = hddLyDoMa.Value;
            }
            #endregion

            #region DropDown Toà án nhận

            // Lấy dữ liệu từ BL
            BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();

            // Lấy danh sách những toà cùng cấp
            decimal currentToaAnId = 0;
            if (decimal.TryParse(Session[ENUM_SESSION.SESSION_DONVIID].ToString(), out currentToaAnId))
            {
                DropDownList dropToaAnNhan = e.Item.FindControl("dropToaAnNhan") as DropDownList;

                DataTable dtNewToaAns = bl.GETS_BY_TOAANTID(currentToaAnId);
                if (dtNewToaAns != null && dtNewToaAns.Rows != null && dtNewToaAns.Rows.Count > 0)
                {
                    dropToaAnNhan.Items.Clear();
                    dropToaAnNhan.DataSource = null;
                    dropToaAnNhan.DataBind();
                    dropToaAnNhan.Items.Add(new ListItem("--- Chọn tòa án ---", "0"));

                    foreach (DataRow row in dtNewToaAns.Rows)
                    {
                        // Kiểm tra không trùng thì thêm
                        if (dropToaAnNhan.Items.FindByValue(row["TOTOAANID"].ToString()) == null)
                        {
                            ListItem listItem = new ListItem();

                            listItem.Value = row["TOTOAANID"].ToString();
                            listItem.Text = row["TOTOAANTEN"].ToString();

                            dropToaAnNhan.Items.Add(listItem);
                        }
                    }

                    if (!string.IsNullOrEmpty(hddToaAnNhanId.Value))
                    {
                        dropToaAnNhan.SelectedValue = hddToaAnNhanId.Value;
                    }
                }
            }
            #endregion
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        #endregion "Phân trang"
    }
}