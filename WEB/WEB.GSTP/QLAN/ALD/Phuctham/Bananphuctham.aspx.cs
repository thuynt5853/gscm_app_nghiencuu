using BL.GSTP;
using BL.GSTP.ALD;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.THONGKE;
using BL.GSTP.Danhmuc;
using BL.GSTP.DLQGC12;
using BL.GSTP.QLAN;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ALD.Phuctham
{
    public partial class Bananphuctham : System.Web.UI.Page
    {
        DKKContextContainer dkk = new DKKContextContainer();
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal BANAN = 1, QUYETDINH = 2;
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        public string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";

                    hddDonID.Value = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_LAODONG] + "";
                    if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
                    decimal DONID = Convert.ToDecimal(hddDonID.Value);

                    LoadDrop_Anle();
                    LoadDropQuanhephapluat();
                    LoadDropKetQuaPhucTham();
                    LoadDropLyDoBanAn();
                    LoadBanAnInfo(DONID);
                    LoadNguoiKyInfo();
                    LoadGrid();
                    CheckQuyen();
                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
                    CheckCongbo(DONID);
                }
            }
            catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        private void LoadDrop_Anle()
        {
            try
            {
                CONGBO_BL TK_BL = new CONGBO_BL();
                DataTable tbl = TK_BL.DBLINK_GET_LIST_ANLE();
                ddlCBBA_Anle.DataSource = ddlCBBA_AnleQD.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = ddlCBBA_AnleQD.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = ddlCBBA_AnleQD.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_AnleQD.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
                ddlCBBA_AnleQD.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
            catch (Exception)
            {
                // GTEL-DUCPH  NC: 13-09-2025 Fake rỗng
                DataTable tbl = new DataTable();
                tbl.Columns.Add("TEN", typeof(string));
                tbl.Columns.Add("SO_ANLE", typeof(string));
                ddlCBBA_Anle.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG} AND CAPXETXU = 3 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                lbthongbao.Text = lbthongbaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        void CheckQuyen()
        {
            decimal DONID = Convert.ToDecimal(hddDonID.Value);

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            #region  Có quyết định ẩn bản án - HIEUVM
            List<ALD_PHUCTHAM_QUYETDINH> lstQD = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3 || x.QUYETDINHID == 212 || x.QUYETDINHID == 213)).ToList();
            if (lstQD.Count >= 1)
            {
                pnQDVV.Visible = true;
                pnBAPT.Visible = false;
                rdbPanelQD.Enabled = false;
                pnCBQD.Visible = false;
                pnChiTieuThongKe.Visible = false;
                pnNgayMoPhienToa.Visible = true;
                pnQDDinhChiPT.Visible = false;
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                Cls_Comon.SetButton(btnUpdate, false);
            }
            else
            {
                rdbPanelQD.Enabled = true;
                pnCBQD.Visible = false;
            }
            List<ALD_PHUCTHAM_BANAN> lstBA = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).ToList();
            if (lstBA.Count >= 1)
            {
                pnBAPT.Visible = true;
                rdbPanelBA.Enabled = false;
                rdbPanelQD.Enabled = false;
                rdbPanelBA.SelectedValue = BANAN.ToString();
            }
            else
            {
                rdbPanelBA.Enabled = true;
            }
            #endregion

            //Kiểm tra thẩm phán giải quyết đơn   
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            List<ALD_PHUCTHAM_THULY> lstCount = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            List<ALD_DON_THAMPHAN> lstTP = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            List<ALD_PHUCTHAM_HDXX> lstTPCT = dt.ALD_PHUCTHAM_HDXX.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
            if (lstTPCT.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            //check vụ án đã kết thúc không cho sửa xóa
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }

            #region hieu nếu có tống đạt thì ko được xóa bản án sơ thẩm
            ALD_TONGDAT td = dt.ALD_TONGDAT.Where(x => x.DONID == DONID && ( x.BIEUMAUID == 261)).FirstOrDefault();// vnpt -- xoá check biểu mẫu sơ thẩm đã tống đạt trên phúc thẩm
            if (td != null)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã tống đạt không được xóa";
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(btnUpdate, false);
            }
            #endregion

            ALD_PHUCTHAM_QUYETDINH oQD = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.LOAIQDID == 5
                                                                            && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/
                                                                            ).FirstOrDefault();
            if (oQD == null)
            {
                lstErr.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                Cls_Comon.SetButton(cmdUpdate, false);
            }

            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue != "0")
            {
                Cls_Comon.SetButton(btnUpdate, true);
                hddShowCommand.Value = "True";
            }


            //GTEL-HUNGQ 22-10-2025 Check neu da chia sẻ dữ liệu không được xóa
            KHOBAQD_BL ald = new KHOBAQD_BL();
            bool isExist = ald.IsExistKHOBADQ(0, DONID, 3,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }

            isExist = ald.IsExistKHOBADQ(1, DONID, 3,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }
            //END
        }
        private void LoadFile()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            dgFile.CurrentPageIndex = 0;
            List<ALD_PHUCTHAM_BANAN_FILE> lst = dt.ALD_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == DonID).ToList();
            if (lst != null && lst.Count > 0)
            {
                dgFile.DataSource = lst;
                dgFile.DataBind();
                dgFile.Visible = true;
            }
            else
            {
                dgFile.DataSource = null;
                dgFile.DataBind();
                dgFile.Visible = false;
            }
        }
        private void LoadBanAnInfo(decimal DonID)
        {
            ALD_PHUCTHAM_BANAN oT = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault<ALD_PHUCTHAM_BANAN>();
            if (oT != null)
            {
                pnDgFile.Visible = true;
                //ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                hddBanAnID.Value = oT.ID.ToString();
                txtQuanhephapluat_name(oT);
                if (oT.QHPLTKID != null)
                    ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                txtSobanan.Text = oT.SOBANAN;
                txtNgaymophientoa.Text = string.IsNullOrEmpty(oT.NGAYMOPHIENTOA + "") ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)oT.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                txtNgaytuyenan.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                txtNgayhieuluc.Text = string.IsNullOrEmpty(oT.NGAYHIEULUC + "") ? "" : ((DateTime)oT.NGAYHIEULUC).ToString("dd/MM/yyyy", cul);

                if (oT.ISVKSTHAMGIA != null) rdbVKSThamgia.SelectedValue = oT.ISVKSTHAMGIA.ToString();

                rdCongboBA.SelectedValue = (string.IsNullOrEmpty(oT.ISCONGBOBA + "")) ? "0" : oT.ISCONGBOBA.ToString();
                ddlKetQuaPhucTham.SelectedValue = oT.KETQUAPHUCTHAMID.ToString();
                LoadDropLyDoBanAn();
                ddlLyDoBanAn.SelectedValue = oT.LYDOBANANID.ToString();

                if ((oT.APDUNGANLE == null || oT.APDUNGANLE == 1) && oT.SOANLE == null)
                {
                    ddlCBBA_Anle.Items.Insert(ddlCBBA_Anle.Items.Count, new ListItem("Hãy chọn số án lệ", "-1"));
                    ddlCBBA_Anle.SelectedValue = "-1";
                }
                else
                {
                    ddlCBBA_Anle.SelectedValue = string.IsNullOrEmpty(oT.SOANLE + "") ? "0" : oT.SOANLE;
                }
                ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
                rdVuAnQuaHan.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISQUAHAN + "")) ? "0" : oT.TK_ISQUAHAN.ToString();
                rdNNChuQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_CHUQUAN + "")) ? "0" : oT.TK_QUAHAN_CHUQUAN.ToString();
                rdNNKhachQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_KHACHQUAN + "")) ? "0" : oT.TK_QUAHAN_KHACHQUAN.ToString();

                rdVKSCoKN.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISVKSCOKN_KDCN + "")) ? "0" : oT.TK_ISVKSCOKN_KDCN.ToString();
                rdVKSRutKN.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISVKSRUTKN_DSKR + "")) ? "0" : oT.TK_ISVKSRUTKN_DSKR.ToString();

                if (rdVuAnQuaHan.SelectedValue == "1")
                    pnNguyenNhanQuaHan.Visible = true;
                else
                    pnNguyenNhanQuaHan.Visible = false;

                //Load File
                LoadFile();
            }
            else
            {
                pnDgFile.Visible = false;
                ALD_PHUCTHAM_THULY tlpt = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
                if (tlpt != null)
                {
                    if (tlpt.QHPLTKID != null)
                        ddlQHPLTK.SelectedValue = tlpt.QHPLTKID.ToString();
                    txtQuanhephapluat_name(tlpt);

                }
                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (oDon != null)
                {
                    //ddlLoaiQuanhe.SelectedValue = oDon.LOAIQUANHE.ToString();
                    if (oDon.QHPLTKID != null) ddlQHPLTK.SelectedValue = oDon.QHPLTKID.ToString();
                    ddlYeutonuocngoai.SelectedValue = oDon.YEUTONUOCNGOAI.ToString();
                }
                txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            }
        }
        private bool CheckValidQDVV()
        {
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tên quyết định. Hãy chọn lại!";
                ddlQuyetdinh.Focus();
                return false;
            }

            //if (rdCongBoQD.SelectedValue == "")
            //{
            //    lbthongbao.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
            //    rdCongBoQD.Focus();
            //    return false;
            //}

            if (ddlQuyetdinh.SelectedItem.Text == "72-DS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án")
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0")
                {
                    lbthongbaoQD.Text = "Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!";
                    ddlKetquaQuyetdinh.Focus();
                    return false;
                }
                if (ddlLydoQuyetdinh.SelectedValue == "0" && ddlKetquaQuyetdinh.SelectedValue != "101")
                {
                    lbthongbaoQD.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydoQuyetdinh.Focus();
                    return false;
                }
            }

            if (pnQHPL.Visible)
            {
                if (ddlQHPLQDVV.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn quan hệ pháp luật. Hãy chọn lại!";
                    ddlQHPLQDVV.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieuLucTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn chưa nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy) !";
                    txtHieuLucTuNgay.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtHieuLucTuNgay.Text))
            {
                DateTime tuNgay = DateTime.Parse(txtHieuLucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (tuNgay < NgayQD)
                {
                    lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn ngày quyết định !";
                    txtHieuLucTuNgay.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text) && !String.IsNullOrEmpty(txtHieuLucDenNgay.Text))
            {
                if (txtHieuLucDenNgay.Text != "")
                {
                    DateTime tuNgay = DateTime.Parse(txtHieuLucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                    DateTime denNgay = DateTime.Parse(txtHieuLucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (tuNgay > denNgay)
                    {
                        lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
                }
            }

            if (QDDinhChiPT.SelectedValue != "1")
            {
                if (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text))
                {
                    lbthongbaoQD.Text = "Bạn chưa nhập ngày mở quyết định !";
                    txtNgayMoPhienToaQD.Focus();
                    return false;
                }
                else
                {
                    if (Cls_Comon.IsValidDate(txtNgayMoPhienToaQD.Text) == false)
                    {
                        lbthongbaoQD.Text = "Bạn chưa nhập ngày mở phiên toà theo định dạng (dd/MM/yyyy) !";
                        txtNgayMoPhienToaQD.Focus();
                        return false;
                    }

                    DateTime NgayQD = DateTime.Parse(txtNgayMoPhienToaQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                    if (NgayQD > DateTime.Now)
                    {
                        lbthongbaoQD.Text = "ngày mở phiên toà phải nhỏ hơn ngày hiện tại !";
                        txtNgayMoPhienToaQD.Focus();
                        return false;
                    }
                    if (hddNgayNhanPhanCong.Value != "")
                    {
                        DateTime NgayNhanPC = DateTime.Parse(hddNgayNhanPhanCong.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (NgayQD < NgayNhanPC)
                        {
                            lbthongbaoQD.Text = "ngày mở phiên toà phải lớn hơn ngày phân công thẩm phán giải quyết " + hddNgayNhanPhanCong.Value + " !";
                            txtNgayMoPhienToaQD.Focus();
                            return false;
                        }
                    }
                }
            }

            int lengthSQD = txtSoQD.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbthongbaoQD.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSQD > 20)
            {
                lbthongbaoQD.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                txtSoQD.Focus();
                return false;
            }

            if (String.IsNullOrEmpty(txtNgayQD.Text))
            {
                lbthongbaoQD.Text = "Bạn chưa nhập ngày quyết định !";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbaoQD.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbthongbaoQD.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.Contains("27-VDS"))
            {
                if (ddlKetquaQuyetdinh.SelectedIndex == 0)
                {
                    lbthongbaoQD.Text = "Chưa chọn kết quả quyết định phúc thẩm !";
                    return false;
                }
                if (ddlLydoQuyetdinh.SelectedIndex == 0)
                {
                    lbthongbaoQD.Text = "Chưa chọn lý do quyết định phúc thẩm !";
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.Contains("26-VDS") || ddlQuyetdinh.SelectedItem.Text.Contains("69-DS") || ddlQuyetdinh.SelectedItem.Text.Contains("70-DS"))
            {
                if (ddlLydo.SelectedIndex == 0)
                {
                    lbthongbaoQD.Text = "Chưa chọn lý do phúc thẩm !";
                    return false;
                }

            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("đình chỉ"))
            {
                if (pnLyDo.Visible)
                {
                    if (ddlLydo.SelectedValue == "0")
                    {
                        lbthongbaoQD.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                }
                else if (txtLydo.Visible)
                {
                    if (String.IsNullOrEmpty(txtLydo.Text))
                    {
                        lbthongbaoQD.Text = "Bạn chưa nhập Lý do !";
                        return false;
                    }
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                string so = txtSoQD.Text;

                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "ALD", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ALD", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value);
                    if (CheckID != CurrID)
                    {
                        strMsg = "Số Quyết định " + txtSoQD.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoQD.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoQD.Focus();
                        return false;
                    }
                }
            }
            if (ddlCBBA_AnleQD.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lbthongbaoQD.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return false;
            }
            return true;
        }
        private bool CheckValid()
        {
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstErr.Text = "Chưa chọn quan hệ pháp luật dùng cho thống kê!";
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lstErr.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con, bạn hãy chọn lại !";
                return false;
            }

            string so = txtSobanan.Text;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
            {
                DateTime ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "ALD_PT", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "ALD_PT", ngayBA).ToString();
                    if (CheckID != CurrBanAnId)
                    {
                        strMsg = "Số bản án " + txtSobanan.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSobanan.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSobanan.Focus();
                        return false;
                    }
                }
            }
            if (ddlCBBA_Anle.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lstErr.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return false;
            }
            return true;
        }
        private void LoadDropQuanhephapluat()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU_LD, ENUM_DANHMUC.QUANHEPL_TRANHCHAP_LD);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));

            //Load QHPL Thống kê QD.
            ddlQHPLQDVV.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLQDVV.DataTextField = "CASE_NAME";
            ddlQHPLQDVV.DataValueField = "ID";
            ddlQHPLQDVV.DataBind();
            ddlQHPLQDVV.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISLAODONG == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            LoadQD();
            LoadDuongSuYC();
        }
        private void LoadDropKetQuaPhucTham()
        {
            ddlKetQuaPhucTham.Items.Clear();
            ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISALD == 1 && x.ISBANAN == 1).OrderBy(y => y.THUTU).ToList();
            ddlKetQuaPhucTham.DataTextField = "TEN";
            ddlKetQuaPhucTham.DataValueField = "ID";
            ddlKetQuaPhucTham.DataBind();
            ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropLyDoBanAn()
        {
            ddlLyDoBanAn.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLyDoBanAn.DataSource = dtTable;
                ddlLyDoBanAn.DataTextField = "TEN";
                ddlLyDoBanAn.DataValueField = "ID";
                ddlLyDoBanAn.DataBind();
            }
            ddlLyDoBanAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {

            LoadDropQuanhephapluat();
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            //if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP_LD)
            //    ddlLoaiQuanhe.SelectedValue = "1";
            //else
            //    ddlLoaiQuanhe.SelectedValue = "2";
        }
        protected void ddlKetQuaPhucTham_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadDropLyDoBanAn(); } catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(DONID)) return;

                bool isNew = false;
                ALD_PHUCTHAM_BANAN_FILE oTF = new ALD_PHUCTHAM_BANAN_FILE();
                ALD_PHUCTHAM_BANAN oND = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<ALD_PHUCTHAM_BANAN>();
                if (oND == null)
                {
                    oND = new ALD_PHUCTHAM_BANAN();
                    isNew = true;
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                }
                else
                {
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    ALD_TONGDAT oTD1 = dt.ALD_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_PHUCTHAM_BANAN).FirstOrDefault();
                    if (oTD1 != null)
                    {
                        if (!string.IsNullOrEmpty(oND.QUANHEPHAPLUAT_NAME))
                        {
                            txtQuanhephapluat.Enabled = false;
                        }
                        else
                        {
                            txtQuanhephapluat.Enabled = true;
                        }
                        if (oND.QHPLTKID != null)
                        {
                            ddlQHPLTK.Enabled = false;
                        }
                        else
                        {
                            ddlQHPLTK.Enabled = true;
                        }
                        if (!string.IsNullOrEmpty(oND.SOBANAN))
                        {
                            txtSobanan.Enabled = false;
                        }
                        else
                        {
                            txtSobanan.Enabled = true;
                        }
                        if (oND.NGAYMOPHIENTOA != null)
                        {
                            txtNgaymophientoa.Enabled = false;
                        }
                        else
                        {
                            txtNgaymophientoa.Enabled = true;
                        }
                        if (oND.ISCONGBOBA != null)
                        {
                            rdCongboBA.Enabled = false;
                        }
                        else
                        {
                            rdCongboBA.Enabled = true;
                        }
                        if (oND.NGAYTUYENAN != null)
                        {
                            txtNgaytuyenan.Enabled = false;
                        }
                        else
                        {
                            txtNgaytuyenan.Enabled = true;
                        }
                        if (oND.NGAYHIEULUC != null)
                        {
                            txtNgayhieuluc.Enabled = false;
                        }
                        else
                        {
                            txtNgayhieuluc.Enabled = true;
                        }
                        if (oND.KETQUAPHUCTHAMID != null)
                        {
                            ddlKetQuaPhucTham.Enabled = false;
                        }
                        else
                        {
                            ddlKetQuaPhucTham.Enabled = true;
                        }
                        if (oND.LYDOBANANID != null)
                        {
                            ddlLyDoBanAn.Enabled = false;
                        }
                        else
                        {
                            ddlLyDoBanAn.Enabled = true;
                        }
                    }
                }

                //GTEL-HUNGNQ 07-10-2025 Dữ liệu Bản án đã được chia sẻ không được xóa
                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(0, DONID, 3, ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lstErr.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGNQ


                //oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);

                oND.QUANHEPHAPLUATID = null;
                oND.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                //renameTenvuviec(txtQuanhephapluat.Text, DONID);

                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.KETQUAPHUCTHAMID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
                oND.LYDOBANANID = Convert.ToDecimal(ddlLyDoBanAn.SelectedValue);
                oND.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oND.ISCONGBOBA = rdCongboBA.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongboBA.SelectedValue);

                oND.ISVKSTHAMGIA = rdbVKSThamgia.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbVKSThamgia.SelectedValue);
                oND.APDUNGANLE = ddlCBBA_Anle.SelectedValue == "0" ? 0 : 1;
                oND.SOANLE = ddlCBBA_Anle.SelectedValue;
                oND.TK_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                oND.TK_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                oND.TK_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);

                oND.TK_ISVKSCOKN_KDCN = rdVKSCoKN.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSCoKN.SelectedValue);
                oND.TK_ISVKSRUTKN_DSKR = rdVKSRutKN.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSRutKN.SelectedValue);
                //luu file
                    try
                    {
                        if (hddFilePath.Value != "")
                        {
                            string strFilePath = hddFilePath.Value.Replace("/", "\\");
                            #region Lưu file
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oTF.BANANID = DONID;
                                oTF.NOIDUNG = buff;
                                oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                                oTF.KIEUFILE = oF.Extension;
                                oTF.NGAYTAO = DateTime.Now;
                                oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                dt.ALD_PHUCTHAM_BANAN_FILE.Add(oTF);
                                dt.SaveChanges();
                            }
                            #endregion
                            File.Delete(strFilePath);
                        }

                    }
                    catch (Exception ex) { }

                    if (isNew)
                {
                    oND.DONID = DONID;
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ALD_PHUCTHAM_BANAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                //    LoadBanAnInfo(DONID);

                //    TamNgungDONKK_USER_DKNHANVB(DONID);
                //    dt.SaveChanges();


                //    //End
                //    LoadBanAnInfo(DONID);
                //    lstErr.Text = "Lưu thành công!";
                //    Page.Response.Redirect(Page.Request.Url.ToString(), true);
                //}
                DateTime NgayBA;
                if (!String.IsNullOrEmpty(txtNgaytuyenan.Text)) { NgayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayBA = Convert.ToDateTime(a);
                }
                decimal FileID = 0;
                decimal STTQD = 0;

                ALD_DON_BL oBL = new ALD_DON_BL();

                if (!String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.PHUCTHAM, NgayBA.Year, 1);
                else
                {
                    Decimal? a = null;
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.PHUCTHAM, Convert.ToDecimal(a), 1);
                }
                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                //---------29/11/2025----  vnpt chỉnh lấy thêm cột FILEID
                if (isNew)
                {
                    FileID = 0;
                }
                else
                {
                    FileID = oND.FILEID ?? 0;
                }
                var rFileID = UploadFileID(oDon, FileID, "75-DS", STTQD);
                if (rFileID > 0)
                {
                    oND.FILEID = rFileID;
                    dt.SaveChanges();
                }

                if(oND.NGAYTUYENAN != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }
                     
                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    temp_congbo.CAPXETXU = 3;
                    temp_congbo.ISBA = 1;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYTUYENAN;
                    temp_congbo.MAVUAN = oDon.MAVUVIEC;
                    temp_congbo.VUVIECID = oND.DONID.Value;

                    if (isnew)
                    {
                        temp_congbo.NGAYTAO = DateTime.Now;
                        temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(temp_congbo);
                    }
                    else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                    {
                        temp_congbo.NGAYSUA = DateTime.Now;
                        temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(temp_congbo);
                    }
                }    

                TamNgungDONKK_USER_DKNHANVB(DONID);
                dt.SaveChanges();
                LoadBanAnInfo(DONID);
                lstErr.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lstErr.Text = "Lỗi: " + ex.Message;
            }
        }

        private void GetTrangThaiBanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 1);
            if (obj != null)
            {

                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkk.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 1);
            if (obj != null)
            {

                obj.TRANGTHAI = 3;
                dkk.SaveChanges();
            }
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile && dgFile.Items.Count < 1)
            {
                string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                {
                    string strFileName = AsyncFileUpLoad.FileName;
                    string path = Server.MapPath("~/TempUpload/") + strFileName;
                    AsyncFileUpLoad.SaveAs(path);

                    try
                    {
                        decimal DONID = Convert.ToDecimal(hddID.Value);
                        string strFilePath = path;
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            string strFN = oF.Name.ToLower();
                            //if (dt.ALD_PHUCTHAM_BANAN_FILE.Where(x => x.TENFILE.ToLower() == strFN).ToList().Count == 0)
                            //{
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            ALD_PHUCTHAM_BANAN_FILE oTF = new ALD_PHUCTHAM_BANAN_FILE();
                            oTF.BANANID = DONID;
                            oTF.NOIDUNG = buff;
                            oTF.TENFILE = oF.Name;
                            oTF.KIEUFILE = oF.Extension;
                            oTF.NGAYTAO = DateTime.Now;
                            oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.ALD_PHUCTHAM_BANAN_FILE.Add(oTF);
                            dt.SaveChanges();
                            //}
                        }
                        File.Delete(strFilePath);

                    }
                    catch (Exception ex) { lstErr.Text = ex.Message; }
                }
            }
        }

        protected void cmdThemFileTL_Click(object sender, EventArgs e)
        {
            SaveFile_KySo();
            LoadFile();
        }
        protected void cmd_load_form_Click(object sender, EventArgs e)
        {
            LoadFile();
            Load_CheckBox();
        }
        protected void Load_CheckBox()
        {
            //if (chkKySo.Checked == true)
            //{
            //    zonekythuong.Style.Add("Display", "none");
            //    zonekyso.Style.Add("Display", "block");
            //}
            //else
            //{
            //    zonekythuong.Style.Add("Display", "block");
            //    zonekyso.Style.Add("Display", "none");
            //}
        }
        void SaveFile_KySo()
        {
            string folder_upload = "/TempUpload/";
            string file_kyso = hddFilePath.Value;
            if (!String.IsNullOrEmpty(hddFilePath.Value))
            {
                String[] arr = file_kyso.Split('/');
                string file_name = arr[arr.Length - 1] + "";

                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                decimal DONID = Convert.ToDecimal(hddID.Value);
                ALD_PHUCTHAM_BANAN_FILE oTF = new ALD_PHUCTHAM_BANAN_FILE();

                byte[] buff = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    string strFN = oF.Name.ToLower();

                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);
                    oTF.BANANID = DONID;
                    oTF.NOIDUNG = buff;
                    oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                    oTF.KIEUFILE = oF.Extension;
                    oTF.NGAYTAO = DateTime.Now;
                    oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ALD_PHUCTHAM_BANAN_FILE.Add(oTF);
                    dt.SaveChanges();
                }
                //xoa file
                File.Delete(file_path);
            }
        }
        protected void dgFile_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lstErr.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    ALD_PHUCTHAM_BANAN_FILE oT = dt.ALD_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    dt.ALD_PHUCTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    ALD_PHUCTHAM_BANAN_FILE oND = dt.ALD_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
            }
        }
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                pnNguyenNhanQuaHan.Visible = true;

            }
            else
            {
                pnNguyenNhanQuaHan.Visible = false;

            }

        }
        protected void txtNgaymophientoa_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaymophientoa.Text))
            {
                if (String.IsNullOrEmpty(txtNgaytuyenan.Text))
                {
                    txtNgaytuyenan.Text = txtNgaymophientoa.Text;
                }
                if (String.IsNullOrEmpty(txtNgayhieuluc.Text))
                {
                    txtNgayhieuluc.Text = txtNgaymophientoa.Text;
                }
            }
        }

        protected void cmdHuyBanAn_Click(object sender, EventArgs e)
        {
            decimal DONID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            //reset_TENVUVIEC(DONID);

            // Xóa thông tin bản án
            ALD_PHUCTHAM_BANAN banan = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (banan != null)
            {
                // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                ALD_TONGDAT oTD2 = dt.ALD_TONGDAT.Where(x => x.DONID == banan.DONID && x.MAPID == banan.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_PHUCTHAM_BANAN).FirstOrDefault();
                if (oTD2 != null)
                {
                    lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                    return;
                }
                //GTEL-HUNGNQ 07-10-2025 Dữ liệu Bản án đã được chia sẻ không được xóa
                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(0, DONID, 3,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lstErr.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGNQ

                //Luu thong tin Bản án Phúc thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(banan);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(DONID, 5, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Phúc thẩm án Lao động", "Xóa", json) == false)
                {
                    return;
                }//Ket thuc
                 //Xoa Bản án Phúc thẩm
                dt.ALD_PHUCTHAM_BANAN.Remove(banan);
            }
            // Xóa thông tin file đính kèm
            List<ALD_PHUCTHAM_BANAN_FILE> files = dt.ALD_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == DONID).ToList();
            if (files.Count > 0)
            {
                dt.ALD_PHUCTHAM_BANAN_FILE.RemoveRange(files);
            }
            // Xóa thông tin người tham gia tố tụng
            List<ALD_PHUCTHAM_BANAN_TGTT> tGTTs = dt.ALD_PHUCTHAM_BANAN_TGTT.Where(x => x.DONID == DONID).ToList();
            if (tGTTs.Count > 0)
            {
                dt.ALD_PHUCTHAM_BANAN_TGTT.RemoveRange(tGTTs);
            }

            /* 25.04.2025 Bổ sung Xóa AHN_FILE khi xóa Bản án
             * AHN_FILE phục vụ mục đích lưu trữ các file theo giai đoạn vụ việc/vụ án
             */
            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "75-DS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            ALD_FILE file = dt.ALD_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).FirstOrDefault();
            if (file != null)
            {
                dt.ALD_FILE.Remove(file);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DONID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                    $"  AND CAPXETXU = {3} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            LoadBanAnInfo(DONID);

            SetTrangThaibanDauDONKK_USER_DKNHANVB(DONID);
            dt.SaveChanges();
            ResetControl();
            lstErr.Text = "Xóa bản án thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        private void ResetControl()
        {
            decimal DONID = Convert.ToDecimal(hddID.Value);
            LoadBanAnInfo(DONID);
            txtQuanhephapluat.Text = getQHPL_NAME_THULY();
            ddlQuanhephapluat.SelectedIndex = 0;
            //ddlLoaiQuanhe.SelectedIndex = 0;
            ddlQHPLTK.SelectedIndex = 0;
            txtSobanan.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            ddlKetQuaPhucTham.SelectedIndex = 0;
            ddlLyDoBanAn.SelectedIndex = 0;
            ddlYeutonuocngoai.SelectedIndex = 0;
            ddlCBBA_Anle.SelectedValue = "0";
            rdbVKSThamgia.ClearSelection();
            rdVKSCoKN.ClearSelection();
            rdVKSRutKN.ClearSelection();
            rdVuAnQuaHan.ClearSelection();
            rdNNChuQuan.ClearSelection();
            rdNNKhachQuan.ClearSelection();
            if (pnKetquaPhuctham.Visible == true)
            {
                ddlKetquaQuyetdinh.SelectedIndex = 0;
                if (pnLyDoKetquaPhuctham.Visible == true)
                {
                    ddlLydoQuyetdinh.SelectedIndex = 0;
                }
            }
            lstErr.Text = "";
            LoadFile();
        }

        private decimal getcurrentid()
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
            return Convert.ToDecimal(current_id);
        }
        private string getQHPL_NAME_THULY()
        {
            decimal ID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
            ALD_PHUCTHAM_THULY oT = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == ID).FirstOrDefault();
            if (oT.QUANHEPHAPLUAT_NAME != null && oT.QUANHEPHAPLUAT_NAME != "")
            {
                return oT.QUANHEPHAPLUAT_NAME.ToString();
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) return obj.TEN.ToString();
                return "";
            }
            else
            {
                return "";
            }
        }
        private void txtQuanhephapluat_name(ALD_PHUCTHAM_BANAN oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
            {
                ALD_PHUCTHAM_BANAN oTT = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == oT.DONID).FirstOrDefault();
                if (oTT.QUANHEPHAPLUAT_NAME != null)
                {
                    txtQuanhephapluat.Text = oTT.QUANHEPHAPLUAT_NAME;
                }
                else if (oTT.QUANHEPHAPLUATID != null)
                {
                    decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                    DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                    if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
                }
                else
                    txtQuanhephapluat.Text = null;
            }
        }
        private void txtQuanhephapluat_name(ALD_PHUCTHAM_THULY oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
            {
                ALD_DON oTT = dt.ALD_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
                if (oTT.QUANHEPHAPLUAT_NAME != null)
                {
                    txtQuanhephapluat.Text = oTT.QUANHEPHAPLUAT_NAME;
                }
                else if (oTT.QUANHEPHAPLUATID != null)
                {
                    decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                    DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                    if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
                }
                else
                    txtQuanhephapluat.Text = null;
            }
        }
        private void txtQuanhephapluat_name(ALD_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }

        #region thông tin quyết định - HIEUVM
        //thông tin quyết định
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PT(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG, ID);
            if (oDT != null)
            {

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        private void LoadDuongSuYC()
        {
            ddlNguoiYC.Items.Clear(); ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            List<ALD_DON_DUONGSU> lstDS = dt.ALD_DON_DUONGSU.Where(x => x.DONID == DonID).OrderBy(x => x.TENDUONGSU).ToList<ALD_DON_DUONGSU>();
            ddlNguoiYC.DataSource = ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiYC.DataTextField = ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiYC.DataValueField = ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiYC.DataBind(); ddlNguoiBiYC.DataBind();
            ddlNguoiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        }
        private void LoadQD()
        {
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;

            LoadLydo();

            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            //Load ẩn hiện QHPL         
            if (ID > 0)
            {
                DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == ID).FirstOrDefault();
                if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                {
                    pnQHPL.Visible = true;
                }
                else pnQHPL.Visible = false;
            }
        }
        private void LoadLydo()
        {
            if (ddlQuyetdinh.Items.Count > 0)
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();
                if (lst != null && lst.Count > 0)
                {
                    if (ddlQuyetdinh.Text == "1")
                    {
                        pnLyDo.Visible = false;
                        pntxtLydo.Visible = true;
                        lbtxtLydo.InnerText = "Lý do";
                    }
                    else
                    {
                        pnLyDo.Visible = true;
                        pntxtLydo.Visible = false;
                        lbtxtLydo.InnerText = "";
                    }

                    ddlLydo.Items.Clear();
                    foreach (DM_QD_QUYETDINH_LYDO item in lst)
                    {
                        ddlLydo.Items.Insert(0, new ListItem(item.TEN, item.ID.ToString()));
                    }

                    //ddlLydo.DataSource = lst;
                    //ddlLydo.DataTextField = "TEN";
                    //ddlLydo.DataValueField = "ID";
                    //ddlLydo.DataBind();
                    ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }
                else
                {
                    pnLyDo.Visible = false;
                    pntxtLydo.Visible = false;
                }
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            ALD_PHUCTHAM_HDXX oND = dt.ALD_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<ALD_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());

                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKyTTVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                ALD_DON_THAMPHAN oTP = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKyTTVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                        hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKyTTVV.Text = txtChucvu.Text = "";
            }
        }
        private void ResetControls()
        {
            txtLydo.Text = null;

            rdCongBoQD.ClearSelection();
            ddlYeutonuocngoaiQD.ClearSelection();
            ddlCBBA_AnleQD.SelectedValue = "0";
            rdbVKSThamgiaQD.ClearSelection();
            rdqHoaGiaiThanhQD.ClearSelection();
            rdVKSCoKNQD.ClearSelection();
            rdVKSRutKNQD.ClearSelection();

            pnChiTieuThongKe.Visible = false;
            ddlLoaiQD.SelectedIndex = 0;
            ddlQuyetdinh.SelectedIndex = 0;
            LoadDuongSuYC();
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieuLucDenNgay.Text = hddFilePath.Value = lbthongbaoQD.Text = "";
            hddDonID.Value = "0";
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            rdbPanelBA_SelectedIndexChanged(new object(), new EventArgs());
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Decimal ID = Convert.ToDecimal(hddDonID.Value);
            List<ALD_PHUCTHAM_QUYETDINH> lstQD = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3)).ToList();
            if (lstQD.Count >= 1)
            {
                Cls_Comon.SetButton(btnUpdate, false);
            }
            ResetControls();
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
            Cls_Comon.SetFocus(this, this.GetType(), ddlQuyetdinh.ClientID);
        }
        public void xoa(decimal id)
        {
            ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {id} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
            if (TK != null)
            {
                DataExtensions.Delete(TK);
            }
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                        $"  AND CAPXETXU = {3} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            //if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            //{
            //    lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
            //    return;
            //}
            if (oND != null)
            {
                decimal FileID = 0;
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

                dt.ALD_PHUCTHAM_QUYETDINH.Remove(oND);
                SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
                dt.SaveChanges();
                if (FileID > 0)
                {
                    try
                    {
                        ALD_FILE objf = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                        dt.ALD_FILE.Remove(objf);
                        dt.SaveChanges();
                    }
                    catch (Exception ex) { }
                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            return;
        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelBA.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                pnChiTieuThongKe.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                pnChiTieuThongKe.Visible = false;
                pnNgayMoPhienToa.Visible = true;
                pnQHPL.Visible = false;
                pnDuongSuYC.Visible = false;
                pnHieuLuc.Visible = true;
                pnNKCV.Visible = true;
                pnQDDinhChiPT.Visible = false;
                pnFile.Visible = true;
                pnSoNgay.Visible = true;
                if (ddlQuyetdinh.SelectedItem.Text.Contains("27-VDS") || ddlQuyetdinh.SelectedItem.Text.Contains("26-VDS") || ddlQuyetdinh.SelectedItem.Text.Contains("71-DS"))
                {
                    pnChiTieuThongKe.Visible = true;
                }
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbaoQD.Text = "";
            if (rdbPanelQD.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                pnChiTieuThongKe.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                pnChiTieuThongKe.Visible = false;

                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }

        protected void rdCongboQD_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                if (!CheckValidQDVV() || !CheckCongbo(DONID)) return;

                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;

                //GTEL-HUNGNQ 07-10-2025 Dữ liệu Bản án đã được chia sẻ không được xóa
                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(1, DONID, 3,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lstErr.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGNQ

                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }
                ALD_PHUCTHAM_QUYETDINH oND;
                TK_PHUCTHAM_QUYETDINH TK = new TK_PHUCTHAM_QUYETDINH();
                decimal STTQD = 0;
                if ((hddID.Value == "" || hddID.Value == "0"))
                {
                    oND = new ALD_PHUCTHAM_QUYETDINH();
                    ALD_DON_BL oBL = new ALD_DON_BL();

                    if (!String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, NgayQD.Year, 1);
                    else
                    {
                        Decimal? a = null;
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(a), 1);
                    }
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID= {ID} AND LOAIAN =  {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
                    oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                try
                {
                    if (hddFilePathQD.Value != "")
                    {
                        string strFilePath = hddFilePathQD.Value.Replace("/", "\\");
                        #region Lưu file
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        #endregion
                        File.Delete(strFilePath);
                    }
                }
                catch { }

                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);

                if (!ddlQuyetdinh.SelectedItem.Text.Contains("72-DS"))
                {

                    TK.DONID = DONID;
                    TK.LOAIAN = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    TK.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoaiQD.SelectedValue);
                    //TK.APDUNGANLE = rdbAnleQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbAnleQD.SelectedValue);
                    TK.APDUNGANLE = ddlCBBA_AnleQD.SelectedValue == "0" ? 0 : 1;
                    TK.SOANLE = ddlCBBA_AnleQD.SelectedValue;
                    TK.ISVKSTHAMGIA = rdbVKSThamgiaQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbVKSThamgiaQD.SelectedValue);
                    TK.TK_ISVKSCOKN_KDCN = rdVKSCoKNQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSCoKNQD.SelectedValue);
                    TK.TK_ISVKSRUTKN_DSKR = rdVKSRutKNQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSRutKNQD.SelectedValue);
                    TK.ISTHAMPHAN_HD = QDDinhChiPT.SelectedValue == "" ? 0 : Convert.ToDecimal(QDDinhChiPT.SelectedValue);

                    if (ddlQuyetdinh.SelectedItem.Text.Contains("69-DS"))
                    {
                        TK.ISHOAGIAITHANH = rdqHoaGiaiThanhQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdqHoaGiaiThanhQD.SelectedValue);
                        TK.ISVKSTHAMGIA = null;
                    }
                    if (ddlQuyetdinh.SelectedItem.Text.Contains("70-DS"))
                    {
                        TK.ISHOAGIAITHANH = rdqHoaGiaiThanhQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdqHoaGiaiThanhQD.SelectedValue);
                        TK.ISVKSTHAMGIA = rdbVKSThamgiaQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbVKSThamgiaQD.SelectedValue);
                    }

                }
                if (TK.ISTHAMPHAN_HD == 1 || TK.ISTHAMPHAN_HD == 2)
                {
                    oND.QHPLTKID = Convert.ToDecimal(ddlQHPLQDVV.SelectedValue);
                    oND.SOQD = txtSoQD.Text.Trim();
                    oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (TK.ISTHAMPHAN_HD == 2)
                    {
                        oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                    }
                }
                else
                {
                    oND.QHPLTKID = Convert.ToDecimal(ddlQHPLQDVV.SelectedValue);
                    oND.SOQD = txtSoQD.Text.Trim();
                    oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                }


                set_valueLydo(oND);
                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);


                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;
                if (pnDuongSuYC.Visible)
                {
                    oND.NGUOIYEUCAUID = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
                    oND.NGUOIBIYEUCAUID = Convert.ToDecimal(ddlNguoiBiYC.SelectedValue);
                    oND.GHICHU = txtNoiDungYC.Text.Trim();
                }
                else
                {
                    oND.NGUOIYEUCAUID = oND.NGUOIBIYEUCAUID = 0;
                    oND.NGUOIYEUCAUID = oND.NGUOIBIYEUCAUID = 0;
                    oND.GHICHU = "";
                }

                oND.LYDOKETQUAID = pnLyDoKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlLydoQuyetdinh.SelectedValue) : 0;
                oND.KETQUAID = pnKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue) : 0;
                //hoangndh -vnpt 160725
                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                decimal rFileID = 0;
                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                rFileID = UploadFileID(oDon, FileID, oQDT.MA, STTQD);
                if (rFileID > 0) oND.FILEID = rFileID;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ALD_PHUCTHAM_QUYETDINH.Add(oND);
                    dt.SaveChanges();
                    TK.NGAYTAO = DateTime.Now;
                    TK.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    TK.QUYETDINHID = oND.ID;
                    DataExtensions.Insert(TK);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                    TK.QUYETDINHID = oND.ID;
                    TK.NGAYSUA = DateTime.Now;
                    TK.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(TK);
                }

                if (oQDT.ISCONGBO == 1 && oND.NGAYQD != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    temp_congbo.CAPXETXU = 3;
                    temp_congbo.ISBA = 0;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYQD;
                    temp_congbo.MAVUAN = oDon.MAVUVIEC;
                    temp_congbo.VUVIECID = oND.DONID.Value;
                    
                    if (isnew)
                    {
                        temp_congbo.NGAYTAO = DateTime.Now;
                        temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(temp_congbo);
                    }
                    else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                    {
                        temp_congbo.NGAYSUA = DateTime.Now;
                        temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(temp_congbo);
                    }
                }

                TamNgungDONKK_USER_DKNHANVB(DONID, ddlQuyetdinh.SelectedItem.Text);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbaoQD.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbthongbaoQD.Text = lbthongbaoQD.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void AsyncFileUpLoad_UploadedCompleteQD(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoadQD.HasFile && dgFile.Items.Count < 1)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoadQD.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoadQD.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePathQD.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lbthongbao.Text = "chỉ lưu file .doc";
                }
                else lbthongbao.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private decimal UploadFileID(ALD_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            ALD_DON_BL oBL = new ALD_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            ALD_FILE objFile = new ALD_FILE();
            if (FileID > 0)
                objFile = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
            objFile.LOAIFILE = 1;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    if (chkKySo.Checked)
                    {
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
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
                        objFile.NOIDUNG = buff;
                        objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                        objFile.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (STT != 0) objFile.STT = Convert.ToDecimal(STT);
            if (FileID == 0)
                dt.ALD_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 1);
            if (obj != null)
            {

                if (TenQuyetDinh.StartsWith("09-HC.") || TenQuyetDinh.StartsWith("45-DS.") || TenQuyetDinh.StartsWith("46-DS.") || TenQuyetDinh.StartsWith("38-DS.") || TenQuyetDinh.StartsWith("39-DS."))
                {
                    //chuyển trang trạng thái tạm dừng
                    obj.TRANGTHAI = 3;
                    dkk.SaveChanges();
                }
                else
                {
                    obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                    dkk.SaveChanges();
                }
            }
        }
        public void loadedit(decimal ID)
        {
            //ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID && (x.LOAIQDID == 15 || x.LOAIQDID == 3 || x.LOAIQDID == 10 || x.QUYETDINHID == 422 || x.QUYETDINHID == 423 || x.QUYETDINHID == 212 || x.QUYETDINHID == 213)).FirstOrDefault();
            ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            TK_PHUCTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_PHUCTHAM_QUYETDINH>($"QUYETDINHID = {ID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
            SetEnable_data_QD(oND);
            hddID.Value = oND.ID.ToString();
            decimal IDQD = Convert.ToDecimal(oND.QUYETDINHID);
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
            if (oQD != null)
            {
                if (/*oQD.MA == "TDC" || */oND.LOAIQDID == 10 || oND.LOAIQDID == 11 || oND.LOAIQDID == 3)
                {
                    ddlQuyetdinh.Enabled = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                }

                //if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                //{
                //    pnQHPL.Visible = true;
                //}
                //else pnQHPL.Visible = false;
                //if (oQD.ISDUONGSUYEUCAU == 1)
                //{
                //    pnDuongSuYC.Visible = true;
                //}
                //else
                //{
                //    pnDuongSuYC.Visible = false;
                //}
            }
            else
            {
                pnQHPL.Visible = false;
                pnDuongSuYC.Visible = false;

            }

            LoadLydo();
            get_valueLydo(ID);

            if (ddlQuyetdinh.SelectedItem.Text.Contains("72-DS") || ddlQuyetdinh.SelectedItem.Text.Contains("27-VDS"))
            {
                if (oND.KETQUAID != 0)
                {
                    pnKetquaPhuctham.Visible = true;
                    // pnChiTieuThongKe.Visible = true;
                    LoadDropKetQuaQuyetdinhPhuctham();
                    if (oND.KETQUAID != 0 && oND.KETQUAID != null)
                    {
                        ddlKetquaQuyetdinh.SelectedValue = oND.KETQUAID.ToString();
                    }
                    LoadDropLyDoQuyetdinh();
                    if (oND.LYDOKETQUAID != 0 && oND.LYDOKETQUAID != null)
                    {
                        pnLyDoKetquaPhuctham.Visible = true;
                        ddlLydoQuyetdinh.SelectedValue = oND.LYDOKETQUAID.ToString();
                    }
                }
            }
            else
            {
                if (pnKetquaPhuctham.Visible == true)
                {
                    ddlKetquaQuyetdinh.SelectedIndex = 0;
                    if (pnLyDoKetquaPhuctham.Visible == true)
                    {
                        ddlLydoQuyetdinh.SelectedIndex = 0;
                    }
                }
                pnKetquaPhuctham.Visible = false;
                pnLyDoKetquaPhuctham.Visible = false;
            }
            if (oND.QHPLTKID != null) ddlQHPLTK.SelectedValue = ddlQHPLQDVV.SelectedValue = oND.QHPLTKID.ToString();
            if (oND.ISCONGBOQD != null) rdCongBoQD.SelectedValue = oND.ISCONGBOQD.ToString();

            if ((TK.APDUNGANLE == 0 || TK.APDUNGANLE == null || TK.APDUNGANLE == 1) && TK.SOANLE == null)
            {
                ddlCBBA_AnleQD.Items.Insert(ddlCBBA_Anle.Items.Count, new ListItem("Hãy chọn số án lệ", "-1"));
                ddlCBBA_AnleQD.SelectedValue = "-1";
            }
            else
            {
                if (TK.SOANLE == "khong" || TK.SOANLE == null)
                {
                    ddlCBBA_AnleQD.SelectedValue = "0";
                }
                else
                {
                    ddlCBBA_AnleQD.SelectedValue = TK.SOANLE;
                }
            }

            if (TK.TK_ISVKSCOKN_KDCN != null) rdVKSCoKNQD.SelectedValue = TK.TK_ISVKSCOKN_KDCN.ToString();
            if (TK.TK_ISVKSRUTKN_DSKR != null) rdVKSRutKNQD.SelectedValue = TK.TK_ISVKSRUTKN_DSKR.ToString();
            if (TK.ISVKSTHAMGIA != null) rdbVKSThamgiaQD.SelectedValue = TK.ISVKSTHAMGIA.ToString();
            if (TK.ISHOAGIAITHANH != null) rdqHoaGiaiThanhQD.SelectedValue = TK.ISHOAGIAITHANH.ToString();
            if (TK.YEUTONUOCNGOAI != null) ddlYeutonuocngoaiQD.SelectedValue = TK.YEUTONUOCNGOAI.ToString();
            ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());

            if (TK.ISTHAMPHAN_HD == 1 || TK.ISTHAMPHAN_HD == 2)
            {
                QDDinhChiPT.Enabled = false;
                QDDinhChiPT.SelectedValue = TK.ISTHAMPHAN_HD.ToString();

                rdQDDinhChi_SelectedIndexChanged(new object(), new EventArgs());

            }
            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

            txtDiaDiem.Text = oND.DIADIEMMOPT + "";

            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

            if (oND.NGAYMOPT != null) txtNgayMoPhienToaQD.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);

            if (oND.HIEULUCTU != null) txtHieuLucTuNgay.Text = ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            if (oND.HIEULUCDEN != null) txtHieuLucDenNgay.Text = ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (pnDuongSuYC.Visible)
            {
                ddlNguoiYC.SelectedValue = oND.NGUOIYEUCAUID.ToString();
                ddlNguoiYC_SelectedIndexChanged(new object(), new EventArgs());
                ddlNguoiBiYC.SelectedValue = oND.NGUOIBIYEUCAUID.ToString();
                txtNoiDungYC.Text = oND.GHICHU;
            }
        }
        private void SetEnable_data_QD(ALD_PHUCTHAM_QUYETDINH QD)
        {
            if (QD != null)
            {
                // khong duoc sửa khi da Tong dat nhưng cho phép nhập thêm những trường trống -27 / 11 / 2025 vnpt check
                ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == QD.DONID && x.MAPID == QD.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_PHUCTHAM_BANAN).FirstOrDefault();
                if (oTD != null)
                {
                    if (QD.QHPLTKID != null)
                    {
                        ddlQHPLQDVV.Enabled = false;
                    }
                    else
                    {
                        ddlQHPLQDVV.Enabled = true;
                    }
                    if (QD.QUYETDINHID != null)
                    {
                        ddlQuyetdinh.Enabled = false;
                    }
                    else
                    {
                        ddlQuyetdinh.Enabled = true;
                    }
                    if (QD.NGAYMOPT != null)
                    {
                        txtNgayMoPhienToaQD.Enabled = false;
                    }
                    else
                    {
                        txtNgayMoPhienToaQD.Enabled = true;
                    }
                    if (!string.IsNullOrEmpty(QD.DIADIEMMOPT))
                    {
                        txtDiaDiem.Enabled = false;
                    }
                    else
                    {
                        txtDiaDiem.Enabled = true;
                    }
                    if (QD.LYDOID != null)
                    {
                        ddlLydo.Enabled = false;
                    }
                    else
                    {
                        ddlLydo.Enabled = true;
                    }
                    if (!string.IsNullOrEmpty(QD.SOQD))
                    {
                        txtSoQD.Enabled = false;
                    }
                    else
                    {
                        txtSoQD.Enabled = true;
                    }
                    if (QD.NGAYQD != null)
                    {
                        txtNgayQD.Enabled = false;
                    }
                    else
                    {
                        txtNgayQD.Enabled = true;
                    }
                    if (QD.HIEULUCTU != null)
                    {
                        txtHieuLucTuNgay.Enabled = false;
                    }
                    else
                    {
                        txtHieuLucTuNgay.Enabled = true;
                    }
                    if (QD.HIEULUCDEN != null)
                    {
                        txtHieuLucDenNgay.Enabled = false;
                    }
                    else
                    {
                        txtHieuLucDenNgay.Enabled = true;
                    }
                }

                btnUpdate.Text = "Cập nhật Quyết định";
            }
            else
            {
                btnUpdate.Text = "Lưu Quyết định";
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "Sua":
                    hddFilePathQD.Value = "";
                    lbthongbao.Text = "";
                    //loadedit(ND_id);
                    //hddID.Value = e.CommandArgument.ToString();
                    //hddDonID.Value = "";
                    //ALD_PHUCTHAM_QUYETDINH oND3 = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    //// khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    //ALD_TONGDAT oTD2 = dt.ALD_TONGDAT.Where(x => x.DONID == oND3.DONID && x.MAPID == oND3.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_PHUCTHAM_QUYETDINH).FirstOrDefault();
                    //if (oTD2 != null)
                    //{
                    //    lbthongbao.Text = Label2.Text = "Bạn không thể sửa khi đã tống đạt!";
                    //    return;
                    //}
                    loadedit(ND_id);
                    hddID.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    ALD_PHUCTHAM_QUYETDINH oND2 = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    ALD_TONGDAT oTD1 = dt.ALD_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_PHUCTHAM_QUYETDINH).FirstOrDefault();
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    if (oTD1 != null)
                    {
                        lbthongbao.Text = Label2.Text = "Bạn không thể xóa khi đã tống đạt!";
                        return;
                    }
                    //Dữ liệu Bản án đã được chia sẻ không được xóa
                    KHOBAQD_BL ald = new KHOBAQD_BL();
                    bool isExist = ald.IsExistKHOBADQ(1, ID, 3,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                    if (isExist)
                    {
                        lbthongbao.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                        return;
                    }
                    bool isCongbo = CheckCongbo(ID);
                    if (!isCongbo)
                    {
                        lbthongbao.Text = "Vụ việc đã có thông tin công bố. Không được xóa.";
                        return;
                    }
                    xoa(ND_id);
                    break;
            }
        }
        protected void rdCongboBA_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ALD_PHUCTHAM_QUYETDINH oT = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == DONID).FirstOrDefault();
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
                // hoangndh: ẩn nút sửa xóa khi bàn giao tòa PT mới
                string toagiaiquyetID = rowView.Row["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

            }
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            //Check quyết định sửa chữa, bổ sung bản án
            decimal IDD = Convert.ToDecimal(hddDonID.Value);

            CheckQuyen();

            if (btnUpdate.Enabled == true)
            {
                if (oT.LOAIID == 2 /*Chuyển vụ án*/ || oT.TEN.Contains("cho Thẩm phán") || oT.ID == 422 /*19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự*/
                    || oT.ID == 423 || oT.ID == 429 || oT.ID == 145)
                {
                    lbthongbaoQD.Text = "";
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else
                {
                    ALD_PHUCTHAM_QUYETDINH oQD = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.DONID == IDD && x.LOAIQDID == 5 && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).FirstOrDefault();
                    if (oQD == null)
                    {
                        lbthongbaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                }
            }

            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                ddlLoaiQD.SelectedValue = oT.LOAIID + "";
                //Load ẩn hiện QHPL
                decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oQD != null)
                {
                    if (oQD.MA == "DC" || oQD.MA == "KHAC")
                    {
                        pnQHPL.Visible = true;
                        pnCBQD.Visible = false;
                        pnQDDinhChiPT.Visible = false;
                    }


                    if (oQD.ISDUONGSUYEUCAU == 1)
                    {
                        pnDuongSuYC.Visible = true;
                    }
                    else
                    {
                        pnDuongSuYC.Visible = false;
                    }
                }
                else
                {
                    pnQHPL.Visible = false;
                    pnDuongSuYC.Visible = false;
                }
                //Load số quyêt định với các loại QD Dan Su sau
                if (ID == 62 || ID == 63 || ID == 67 || ID == 68 || ID == 41 || ID == 42 || ID == 45 || ID == 147 || ID == 4 || ID == 61)
                {
                    // lấy số mới nhất 
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD;
                    if (txtNgayQD.Text != "")
                        ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        ngayQD = DateTime.Now;

                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ALD", ngayQD, ID).ToString();
                    txtSoQD.Text = STTNew;
                }
            }
            LoadLydo();
            LoadQuyetDinh();

        }
        protected void ddlNguoiYC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value),
                NguoiYC = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
            List<ALD_DON_DUONGSU> lstDS = dt.ALD_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID != NguoiYC).OrderBy(x => x.TENDUONGSU).ToList<ALD_DON_DUONGSU>();
            ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiBiYC.DataBind();
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBiYC.ClientID);
        }


        protected void ddlLydo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQuyetdinh.Text == "42" && ddlLydo.Text == "67")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "42" && ddlLydo.Text != "67")
            {
                pntxtLydo.Visible = false;
            }
            if (ddlQuyetdinh.Text == "45" && ddlLydo.Text == "74")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "45" && ddlLydo.Text != "74")
            {
                pntxtLydo.Visible = false;
            }
        }
        protected void set_valueLydo(ALD_PHUCTHAM_QUYETDINH oND)
        {
            if (ddlQuyetdinh.SelectedValue == "42" && ddlLydo.SelectedValue == "67")
            {
                oND.QUYETDINHID = 42;
                oND.LYDOID = 67;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "45" && ddlLydo.SelectedValue == "74")
            {
                oND.QUYETDINHID = 45;
                oND.LYDOID = 74;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "1")
            {
                oND.QUYETDINHID = 1;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (pnLyDo.Visible)
            {
                oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
            }
        }
        protected void get_valueLydo(decimal ID)
        {
            ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            if (oND.QUYETDINHID == 42 && oND.LYDOID == 67)
            {
                pntxtLydo.Visible = true;
                lbtxtLydo.InnerText = "";

                if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                }

                if (oND.LYDO_NAME != null)
                {
                    txtLydo.Text = oND.LYDO_NAME;
                }
            }
            else if (oND.QUYETDINHID == 45 && oND.LYDOID == 74)
            {
                pntxtLydo.Visible = true;
                lbtxtLydo.InnerText = "";

                if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                }

                if (oND.LYDO_NAME != null)
                {
                    txtLydo.Text = oND.LYDO_NAME;
                }
            }
            else if (oND.QUYETDINHID == 1)
            {
                lbtxtLydo.InnerText = "Lý do";
                pntxtLydo.Visible = true;

                if (oND.LYDO_NAME != null)
                {
                    txtLydo.Text = oND.LYDO_NAME;
                }
                else if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                    txtLydo.Text = ddlLydo.SelectedItem.Text;
                }
            }
            else if (oND.LYDOID != null && pnLyDo.Visible)
            {
                lbtxtLydo.InnerText = "";
                ddlLydo.SelectedValue = oND.LYDOID.ToString();
            }
        }


        #endregion

        #region Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án
        protected void ddlKetquaQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0" || ddlKetquaQuyetdinh.SelectedValue == "101")
                {
                    ddlLydoQuyetdinh.Items.Clear();
                    pnLyDoKetquaPhuctham.Visible = false;
                }
                else
                {
                    pnLyDoKetquaPhuctham.Visible = true;
                    LoadDropLyDoQuyetdinh();
                }
            }
            catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        private void LoadDropKetQuaQuyetdinhPhuctham()
        {
            if (ddlQuyetdinh.SelectedItem.Text.Contains("72-DS"))
            {
                ddlKetquaQuyetdinh.Items.Clear();
                ddlKetquaQuyetdinh.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISALD == 1 && x.ISQUYETDINH == 1).OrderBy(y => y.THUTU).ToList();
                ddlKetquaQuyetdinh.DataTextField = "TEN";
                ddlKetquaQuyetdinh.DataValueField = "ID";
                ddlKetquaQuyetdinh.DataBind();
                ddlKetquaQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("27-VDS"))
            {
                ddlKetquaQuyetdinh.Items.Clear();
                ddlKetquaQuyetdinh.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISALD == 1 && x.ISBANAN == 1 && x.MA != "13" && x.MA != "14" && x.MA != "18").OrderBy(y => y.THUTU).ToList();
                ddlKetquaQuyetdinh.DataTextField = "TEN";
                ddlKetquaQuyetdinh.DataValueField = "ID";
                ddlKetquaQuyetdinh.DataBind();
                ddlKetquaQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadDropLyDoQuyetdinh()
        {
            ddlLydoQuyetdinh.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLydoQuyetdinh.DataSource = dtTable;
                ddlLydoQuyetdinh.DataTextField = "TEN";
                ddlLydoQuyetdinh.DataValueField = "ID";
                ddlLydoQuyetdinh.DataBind();
            }
            ddlLydoQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        #endregion
        protected void rdQDDinhChi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (QDDinhChiPT.SelectedValue == "1" || QDDinhChiPT.SelectedValue == "2")
            {
                QDDinhChi.Visible = true;
            }
            if (QDDinhChiPT.SelectedValue == "2")
            {
                pnNgayMoPhienToa.Visible = true;
            }
            else
            {
                pnNgayMoPhienToa.Visible = false;
            }

        }

        private void LoadQuyetDinh()
        {

            if (ddlQuyetdinh.SelectedItem.Text == "72-DS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án")
            {
                pnKetquaPhuctham.Visible = true;
                pnNgayMoPhienToa.Visible = true;
                pnChiTieuThongKe.Visible = false;
                LoadDropKetQuaQuyetdinhPhuctham();
            }
            else
            {
                pnKetquaPhuctham.Visible = false;
                pnLyDoKetquaPhuctham.Visible = false;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("71-DS"))
            {
                //pnLyDo.Visible = true;
                pnHoaGiaiThanh.Visible = false;
                pnChiTieuThongKe.Visible = true;

            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("69-DS") || ddlQuyetdinh.SelectedItem.Text.Contains("70-DS"))
            {
                pnHoaGiaiThanh.Visible = true;
                pnChiTieuThongKe.Visible = true;
                pnDuongSuYC.Visible = false;
                pnNgayMoPhienToa.Visible = true;
                pnVKSThamGia.Visible = true;
                if (ddlQuyetdinh.SelectedItem.Text.Contains("69-DS"))
                {
                    pnVKSThamGia.Visible = false;
                }
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("26-VDS"))
            {
                pnQDDinhChiPT.Visible = true;
                QDDinhChi.Visible = false;
                pnChiTieuThongKe.Visible = true;
                pnCBQD.Visible = false;
                pnDuongSuYC.Visible = false;
                pnHoaGiaiThanh.Visible = false;

            }
            else
            {
                QDDinhChi.Visible = true;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("27-VDS"))
            {
                pnKetquaPhuctham.Visible = true;
                LoadDropKetQuaQuyetdinhPhuctham();
                pnLyDoKetquaPhuctham.Visible = true;
                LoadDropLyDoQuyetdinh();
                pnChiTieuThongKe.Visible = true;
                pnHoaGiaiThanh.Visible = false;
                pnQHPL.Visible = false;
                pnQDDinhChiPT.Visible = false;
                pnCBQD.Visible = false;
                pnNgayMoPhienToa.Visible = true;
            }
        }


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
        #endregion
    }
}