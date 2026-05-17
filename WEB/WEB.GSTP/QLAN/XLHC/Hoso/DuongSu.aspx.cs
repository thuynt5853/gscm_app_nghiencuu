using BL.GSTP;
using BL.GSTP.XLHC;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Hoso
{
    public partial class DuongSu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {

                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);

                    CheckQuyen(ID);
                    //XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                    XLHC_DON_XULY oDXuly = dt.XLHC_DON_XULY.Where(x => x.DONID == ID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                    if (oDXuly != null)
                    {
                        lbthongbao.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    SetTinhHuyenMacDinh();
                    LoadGrid();
                    ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                    ltCCCDND.Text = "<span style='color:red'>(*)</span>";
                    ltCMNDND1.Text = "<span style='color:red'>(*)</span>";
                    ltCCCDND1.Text = "<span style='color:red'>(*)</span>";

                }
            }

            catch (Exception ex)
            {

                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }


        }
        private void CheckQuyen(decimal DONID)
        {
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<XLHC_DON_XULY> lstTL = dt.XLHC_DON_XULY.Where(x => x.DONID == DONID).ToList();
            if (lstTL.Count > 0)
            {
                lbthongbao.Text = "Đã xử lý hồ sơ không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        private void SetTinhHuyenMacDinh()
        {
            //Set defaul value Tinh/Huyen dua theo tai khoan dang nhap
            Cls_Comon.SetValueComboBox(ddlNoiSongTinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDropNoiSongHuyen();
            Cls_Comon.SetValueComboBox(ddlNoiSongHuyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

            Cls_Comon.SetValueComboBox(ddl_NDD_Tinh, Session[ENUM_SESSION.SESSION_TINH_ID]);
            LoadDrop_NDD_Huyen();
            Cls_Comon.SetValueComboBox(ddl_NDD_Huyen, Session[ENUM_SESSION.SESSION_QUAN_ID]);

        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlND_Quoctich.Items.Clear();
            ddlCQ_Quoctich.Items.Clear();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();


            ddlCQ_Quoctich.DataSource = dtQuoctich;
            ddlCQ_Quoctich.DataTextField = "TEN";
            ddlCQ_Quoctich.DataValueField = "ID";
            ddlCQ_Quoctich.DataBind();

            LoadDropTinh();
            LoadDropNoiSongHuyen();
        }
        private void ResetControls()
        {
            chkBoxCMNDND.Checked = false;
            chkBoxCMNDND1.Checked = false;
            ddlLoaiNguyendon.Enabled = true;
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_CCCD.Text = "";
            txtND_HoChieu.Text = "";

            txtND_CMND1.Text = "";
            txtND_CCCD1.Text = "";
            txtND_HoChieu1.Text = "";
            ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            ltCCCDND.Text = "<span style='color:red'>(*)</span>";
            ltCMNDND1.Text = "<span style='color:red'>(*)</span>";
            ltCCCDND1.Text = "<span style='color:red'>(*)</span>";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_TTChitiet.Text = "";
            txtND_NDD_Diachichitiet.Text = "";
            txtND_NDD_Ten.Text = "";
            txtND_NDD_Chucvu.Text = "";
            txtNoiLamViec.Text = "";
            txtEmail.Text = txtDienthoai.Text = txtFax.Text = txtND_NDD_Diachichitiet.Text = "";
            hddid.Value = "0";
            txtND_CCCD.Enabled = txtTennguyendon.Enabled = txtND_Namsinh.Enabled = txtND_Ngaysinh.Enabled = true;
            txtND_CCCD1.Enabled = txtTennguyendon.Enabled = txtND_Namsinh.Enabled = txtND_Ngaysinh.Enabled = true;
            ddlND_Quoctich.Enabled = true;
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                ddlNoiSongHuyen.Items.Clear();
                ddlNoiSongHuyen.Items.Add(new ListItem("-- Chọn --", "0"));
                ddlNoiSongTinh.Enabled = ddlNoiSongHuyen.Enabled = true;
            }
            else
            {
                ddl_NDD_Huyen.Items.Clear();
                ddl_NDD_Huyen.Items.Add(new ListItem("-- Chọn --", "0"));
                ddl_NDD_Tinh.Enabled = ddl_NDD_Huyen.Enabled = true;
            }
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            if (txtTennguyendon.Text.Trim() == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                return false;
            }
            if (txtTennguyendon.Text.Length > 250)
            {
                lbthongbao.Text = "Tên đương sự không được vượt quá 250 ký tự!";
                txtTennguyendon.Focus();
                return false;
            }
            // === NGƯỜI BỊ ĐỀ NGHỊ ===
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text.Trim() == "")
                {
                    lbthongbao.Text = "Chưa nhập năm sinh";
                    return false;
                }

                if (!chkBoxCMNDND.Checked)
                {
                    if (string.IsNullOrEmpty(txtND_CMND.Text) )
                    {
                        lbthongbao.Text = " Số CMND không được bỏ trống. Nếu không có vui lòng tích chọn 'Không có'.";
                        txtND_CMND.Focus();
                        return false;
                    }   if ( string.IsNullOrEmpty(txtND_CCCD.Text))
                    {
                        lbthongbao.Text = " Thẻ căn cước không được bỏ trống . Nếu không có vui lòng tích chọn 'Không có'.";
                        txtND_CMND.Focus();
                        return false;
                    }
                    if (!string.IsNullOrEmpty(txtND_CMND.Text))
                    {
                        // Kiểm tra chỉ cho phép nhập số
                        if (!System.Text.RegularExpressions.Regex.IsMatch(txtND_CMND.Text, @"^\d+$"))
                        {
                            lbthongbao.Text = "Số CMND chỉ được chứa ký tự số!";
                            txtND_CMND.Focus();
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (txtND_CMND.Text.Length < 8)
                        {
                            lbthongbao.Text = "Số CMND chưa đúng định dạng!";
                            txtND_CMND.Focus();
                            return false;
                        }
                    }

                    if (!string.IsNullOrEmpty(txtND_CCCD.Text))
                    {
                        // Kiểm tra chỉ cho phép nhập số
                        if (!System.Text.RegularExpressions.Regex.IsMatch(txtND_CCCD.Text, @"^\d+$"))
                        {
                            lbthongbao.Text = "Số CCCD chỉ được chứa ký tự số!";
                            txtND_CCCD.Focus();
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (txtND_CCCD.Text.Length < 12)
                        {
                            lbthongbao.Text = "Số CCCD chưa đúng định dạng!";
                            txtND_CCCD.Focus();
                            return false;
                        }
                    }
                    if (!string.IsNullOrEmpty(txtND_HoChieu.Text) && txtND_HoChieu.Text.Length < 8)
                    {
                        lbthongbao.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtND_HoChieu.Focus();
                        return false;
                    }
                }
                if (ddlNoiSongHuyen.SelectedValue == "0")
                {
                    lbthongbao.Text = "Chưa chọn nơi sinh sống!";
                    return false;
                }
                if (ddlND_Gioitinh.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn giới tính.";
                    ddlND_Gioitinh.Focus();
                    return false;
                }
                if (ddlND_Quoctich.SelectedValue == "2")
                {
                    //La nguoi VN thi so ho chieu la 8 ky tu
                    if (!string.IsNullOrEmpty(txtND_HoChieu.Text) && txtND_HoChieu.Text.Length != 8)
                    {
                        lbthongbao.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtND_HoChieu.Focus();
                        return false;
                    }
                }
            }

            // === CƠ QUAN ĐỀ NGHỊ ===
            if (ddlLoaiNguyendon.SelectedValue == "2")
            {
                if (txtND_NDD_Ten.Text.Length > 250)
                {
                    lbthongbao.Text = "Tên người đại diện không được vượt quá 250 ký tự!";
                    txtND_NDD_Ten.Focus();
                    return false;
                }
                if (txtND_NDD_Chucvu.Text.Length > 250)
                {
                    lbthongbao.Text = "Tên người đại diện không được vượt quá 250 ký tự!";
                    txtND_NDD_Chucvu.Focus();
                    return false;
                }
                if (ddl_NDD_Huyen.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn địa chỉ huyện!";
                    return false;
                }
                if (!chkBoxCMNDND1.Checked)
                {
                    if (string.IsNullOrEmpty(txtND_CMND1.Text))
                    {
                        lbthongbao.Text = " Số CMND không được bỏ trống. Nếu không có vui lòng tích chọn 'Không có'.";
                        txtND_CMND1.Focus();
                        return false;
                    }
                    if (string.IsNullOrEmpty(txtND_CCCD1.Text))
                    {
                        lbthongbao.Text = " Thẻ căn cước không được bỏ trống . Nếu không có vui lòng tích chọn 'Không có'.";
                        txtND_CMND1.Focus();
                        return false;
                    }
                    if (!string.IsNullOrEmpty(txtND_CMND1.Text))
                    {
                        // Kiểm tra chỉ cho phép nhập số
                        if (!System.Text.RegularExpressions.Regex.IsMatch(txtND_CMND1.Text, @"^\d+$"))
                        {
                            lbthongbao.Text = "Số CMND chỉ được chứa ký tự số!";
                            txtND_CMND1.Focus();
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (txtND_CMND1.Text.Length < 8)
                        {
                            lbthongbao.Text = "Số CMND chưa đúng định dạng!";
                            txtND_CMND1.Focus();
                            return false;
                        }
                    }

                    if (!string.IsNullOrEmpty(txtND_CCCD1.Text))
                    {
                        // Kiểm tra chỉ cho phép nhập số
                        if (!System.Text.RegularExpressions.Regex.IsMatch(txtND_CCCD1.Text, @"^\d+$"))
                        {
                            lbthongbao.Text = "Số CCCD chỉ được chứa ký tự số!";
                            txtND_CCCD1.Focus();
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (txtND_CCCD1.Text.Length < 12)
                        {
                            lbthongbao.Text = "Số CCCD chưa đúng định dạng!";
                            txtND_CCCD1.Focus();
                            return false;
                        }
                    }
                    if (!string.IsNullOrEmpty(txtND_HoChieu1.Text) && txtND_HoChieu1.Text.Length < 8)
                    {
                        lbthongbao.Text = "Số hộ chiếu chưa đúng định dạng!";
                        txtND_HoChieu1.Focus();
                        return false;
                    }
                }  
            }
            // === KIỂM TRA EMAIL, ĐIỆN THOẠI, FAX ===
            if (!string.IsNullOrEmpty(txtEmail.Text))
            {
                var emailPattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";
                if (!System.Text.RegularExpressions.Regex.IsMatch(txtEmail.Text.Trim(), emailPattern))
                {
                    lbthongbao.Text = "Email không hợp lệ!";
                    txtEmail.Focus();
                    return false;
                }
            }

            if (!string.IsNullOrEmpty(txtDienthoai.Text))
            {
                var phonePattern = @"^\+?[0-9]{9,13}$";
                if (!System.Text.RegularExpressions.Regex.IsMatch(txtDienthoai.Text.Trim(), phonePattern))
                {
                    lbthongbao.Text = "Số điện thoại không hợp lệ!";
                    txtDienthoai.Focus();
                    return false;
                }
            }

            if (!string.IsNullOrEmpty(txtFax.Text))
            {
                var faxPattern = @"^[0-9]{6,12}$";
                if (!System.Text.RegularExpressions.Regex.IsMatch(txtFax.Text.Trim(), faxPattern))
                {
                    lbthongbao.Text = "Số Fax không hợp lệ!";
                    txtFax.Focus();
                    return false;
                }
            }

            return true;
        }

 
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {

                txtND_Namsinh.Text = d.Year.ToString();
                ////Tính tuổi 
                //string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                //decimal ID = Convert.ToDecimal(current_id);
                //XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                //DateTime dNgayNhan = (DateTime)oT.NGAYNHANDON;
                //if (dNgayNhan != DateTime.MinValue)
                //{
                //    txtND_Tuoi.Text = (dNgayNhan.Year - d.Year).ToString();
                //}
            }
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            //Cls_Comon.SetFocus(this, this.GetType(), ddlTucachTotung.ClientID);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                XLHC_DUONGSU oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new XLHC_DUONGSU();
                    oND.BICANDAUVU = 0;
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();

                    if (oND.BICANDAUVU != 0)
                    {
                        oND.BICANDAUVU = 1;
                    }
                    else
                    {
                        oND.BICANDAUVU = 0;
                    }
                }
                oND.DONID = DONID;
                oND.HOTEN = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue) == 1 ? Cls_Comon.FormatTenRieng(txtTennguyendon.Text) : Cls_Comon.FormatTenTochuc(txtTennguyendon.Text);
                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    oND.SOCMND = txtND_CMND.Text.Replace(" ", "");
                    oND.SODINHDANHCANHAN = txtND_CCCD.Text.Replace(" ", "");
                    oND.HOCHIEU = txtND_HoChieu.Text.Replace(" ", "");
                }
                else
                {
                    oND.SOCMND = txtND_CMND1.Text.Replace(" ", "");
                    oND.SODINHDANHCANHAN = txtND_CCCD1.Text.Replace(" ", "");
                    oND.HOCHIEU = txtND_HoChieu1.Text.Replace(" ", "");

                }

                oND.LOAIDOITUONG = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);

                if (ddlLoaiNguyendon.SelectedValue == "1")
                    oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                else
                    oND.QUOCTICHID = Convert.ToDecimal(ddlCQ_Quoctich.SelectedValue);
                //oND.HKTTTINHID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
                //oND.HKTTID = Convert.ToDecimal(ddlThuongTruHuyen.SelectedValue);
                //oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.TAMTRUTINHID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
                oND.TAMTRU = Convert.ToDecimal(ddlNoiSongHuyen.SelectedValue);

                if (ddlLoaiNguyendon.SelectedValue == "1")
                    oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                else
                    oND.TAMTRUCHITIET = txtND_NDD_Diachichitiet.Text;

                oND.DIACHICOQUAN = txtNoiLamViec.Text.Trim() + "";

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.FAX = txtFax.Text;
                if (pnNDTochuc.Visible)
                {
                    oND.NGUOIDAIDIEN = Cls_Comon.FormatTenRieng(txtND_NDD_Ten.Text);
                    oND.CHUCVU = txtND_NDD_Chucvu.Text;
                    if (ddl_NDD_Huyen.SelectedValue != "0")
                    {
                        oND.NDD_DIACHIID = Convert.ToDecimal(ddl_NDD_Huyen.SelectedValue);
                    }
                    oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                }

                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    oND.ISCMNDND = (short)(chkBoxCMNDND.Checked ? 1 : 0);
                }
                else
                {
                    oND.ISCMNDND = (short)(chkBoxCMNDND1.Checked ? 1 : 0);
                }

                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //update 14082025
                    if (oND.TOA_GIAIQUYET_ID == 0)
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    dt.XLHC_DUONGSU.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                LoadDropNoiSongHuyen();
                LoadDrop_NDD_Huyen();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        public void LoadGrid()
        {
            XLHC_DON_DUONGSU_BL oBL = new XLHC_DON_DUONGSU_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_DON_DUONGSU_NOTDAIDIEN(ID);

            if (oDT != null && oDT.Rows.Count > 0)
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
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
            SetTinhHuyenMacDinh();
        }
        public void xoa(decimal id)
        {
            XLHC_DUONGSU oND = dt.XLHC_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            decimal DONID = (decimal)oND.DONID;

            XLHC_DON_THAMPHAN oTPThuly = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (oND.BICANDAUVU == 1 && oTPThuly != null)
            {
                lbthongbao.Text = "Đã phân công Thẩm phán giải quyết đơn, không được phép xóa Đương sự đại diện!.";
                return;
            }
            dt.XLHC_DUONGSU.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            XLHC_DUONGSU oND = dt.XLHC_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            txtTennguyendon.Text = oND.HOTEN;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDOITUONG.ToString();
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                txtND_CMND.Text = oND.SOCMND;
                txtND_CCCD.Text = oND.SODINHDANHCANHAN;
                txtND_HoChieu.Text = oND.HOCHIEU;

                chkBoxCMNDND.Checked = (oND.ISCMNDND ?? 0) == 1;
                if (chkBoxCMNDND.Checked)
                {
                    ltCMNDND.Text = "";
                    ltCCCDND.Text = "";
                }
            }
            else
            {

                txtND_CMND1.Text = oND.SOCMND;
                txtND_CCCD1.Text = oND.SODINHDANHCANHAN;
                txtND_HoChieu1.Text = oND.HOCHIEU;

                chkBoxCMNDND1.Checked = (oND.ISCMNDND ?? 0) == 1;
                if (chkBoxCMNDND1.Checked)
                {
                    ltCMNDND1.Text = "";
                    ltCCCDND1.Text = "";
                }
            }
            

            //if (ddlLoaiNguyendon.SelectedValue == "1")
            //{
            //    if (!string.IsNullOrEmpty(oND.SOCMND) || !string.IsNullOrEmpty(oND.SODINHDANHCANHAN))
            //    {
            //        chkBoxCMNDND.Checked = false;
                   
            //    }
            //    else
            //    {
            //        chkBoxCMNDND.Checked = true;
            //        ltCMNDND.Text = "";
            //        ltCCCDND.Text = "";
            //    }
            //}
            //else
            //{
            //    if (!string.IsNullOrEmpty(oND.SOCMND) || !string.IsNullOrEmpty(oND.SODINHDANHCANHAN))
            //    {
            //        chkBoxCMNDND1.Checked = false;
                    
            //    }
            //    else
            //    {
            //        chkBoxCMNDND1.Checked = true;
            //        ltCMNDND1.Text = "";
            //        ltCCCDND1.Text = "";
            //    }
            //}
                
            if (oND.BICANDAUVU != 1)
                ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            if (oND.TAMTRUTINHID != null)
            {
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                try
                {
                    if (oND.TAMTRU != null) ddlNoiSongHuyen.SelectedValue = oND.TAMTRU.ToString();
                }
                catch (Exception ex) { }
            }
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            txtNoiLamViec.Text = oND.DIACHICOQUAN + "";

            if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();

            if (oND.NAMSINH == null)
            {
                txtND_Namsinh.Text = ((DateTime)oND.NGAYSINH).Year.ToString();
                txtND_Namsinh.Enabled = false;
            }
            else
            {
                txtND_Namsinh.Enabled = false;
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            }

            if (ddlLoaiNguyendon.SelectedValue == "1")
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            if (pnNDTochuc.Visible)
            {
                txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                txtND_NDD_Chucvu.Text = oND.CHUCVU;
                if (oND.NDD_DIACHIID != null)
                {
                    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (hc != null)
                    {
                        ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                        LoadDrop_NDD_Huyen();
                        ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                    }
                }
                txtND_NDD_Diachichitiet.Text = oND.TAMTRUCHITIET;
            }

            txtEmail.Text = oND.EMAIL + "";
            txtDienthoai.Text = oND.DIENTHOAI + "";
            txtFax.Text = oND.FAX;
           
            if (oND.BICANDAUVU == 1)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                lbthongbao.Text = "Bạn không được sửa nguyên đơn hoặc bị đơn đại diện!";
                return;
            }
            else
            {
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                
            }
        }
        protected void chkBoxCMNDND_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDND.Checked)
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                ltCCCDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND.Text = "";
                ltCCCDND.Text = "";
            }
            if (!chkBoxCMNDND1.Checked)
            {
                ltCMNDND1.Text = "<span style='color:red'>(*)</span>";
                ltCCCDND1.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND1.Text = "";
                ltCCCDND1.Text = "";
            }

        }
        public void loadedit_dathuly(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            XLHC_DUONGSU oND = dt.XLHC_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (oND.HOTEN != null)
            {
                txtTennguyendon.Text = oND.HOTEN;
                txtTennguyendon.Enabled = false;
            }

            ddlLoaiNguyendon.Enabled = false;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDOITUONG.ToString();
            if (oND.SOCMND != null)
            {
                txtND_CMND.Text = oND.SOCMND;
                txtND_CMND.Enabled = false;
                txtND_CMND1.Text = oND.SOCMND;
                txtND_CMND1.Enabled = false;
            }
            else
            {
                txtND_CMND.Text = null;
                txtND_CMND.Enabled = true;
                txtND_CMND1.Text = oND.SOCMND;
                txtND_CMND1.Enabled = true;
            }

            if (oND.SODINHDANHCANHAN != null)
            {
                txtND_CCCD.Text = oND.SODINHDANHCANHAN;
                txtND_CCCD.Enabled = false;
                txtND_CCCD1.Text = oND.SODINHDANHCANHAN;
                txtND_CCCD1.Enabled = false;
            }
            else
            {
                txtND_CCCD.Text = null;
                txtND_CCCD.Enabled = true;
                txtND_CCCD1.Text = null;
                txtND_CCCD1.Enabled = true;
            }
            if (oND.HOCHIEU != null)
            {
                txtND_HoChieu.Text = oND.HOCHIEU;
                txtND_HoChieu.Enabled = false;
                txtND_HoChieu1.Text = oND.HOCHIEU;
                txtND_HoChieu1.Enabled = false;
            }
            else
            {
                txtND_HoChieu.Text = null;
                txtND_HoChieu.Enabled = true;
                txtND_HoChieu1.Text = null;
                txtND_HoChieu1.Enabled = true;
            }

            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                chkBoxCMNDND.Checked = (oND.ISCMNDND ?? 0) == 1;
                if (chkBoxCMNDND.Checked)
                {
                    ltCMNDND.Text = "";
                    ltCCCDND.Text = "";
                }
            }
            else
            {
                chkBoxCMNDND1.Checked = (oND.ISCMNDND ?? 0) == 1;
                if (chkBoxCMNDND1.Checked)
                {
                    ltCMNDND1.Text = "";
                    ltCCCDND1.Text = "";
                }
            }
            if (oND.BICANDAUVU != 1) {
                ddlND_Quoctich.Enabled = false;
                ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            }
            

            if (oND.TAMTRUTINHID != null && oND.TAMTRUTINHID > 0)
            {
                ddlNoiSongTinh.Enabled = false;
                ddlNoiSongTinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                LoadDropNoiSongHuyen();
                try
                {
                    if (oND.TAMTRU != null && oND.TAMTRU > 0)
                    {
                        ddlNoiSongHuyen.SelectedValue = oND.TAMTRU.ToString();
                        ddlNoiSongHuyen.Enabled = false;
                    }
                    else
                        ddlNoiSongHuyen.Enabled = true;

                }
                catch (Exception ex) { }
            }
            else
                ddlNoiSongTinh.Enabled = true;
            if (oND.TAMTRUCHITIET != null)
            {
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                txtND_TTChitiet.Enabled = false;
            }
            else
            {
                txtND_TTChitiet.Text = null;
                txtND_TTChitiet.Enabled = true;
            }

            if (oND.DIACHICOQUAN != null)
            {
                txtNoiLamViec.Text = oND.DIACHICOQUAN + "";
                txtNoiLamViec.Enabled = false;
            }
            else
            {
                txtNoiLamViec.Text = "";
                txtNoiLamViec.Enabled = true;
            }

            if (oND.NAMSINH != 0)
            {
                txtND_Namsinh.Enabled = false;
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            }
            else
            {
                txtND_Namsinh.Enabled = true;
                txtND_Namsinh.Text = null;
                pnNDTochuc.Visible = true;
            }

            if (oND.NGAYSINH != DateTime.MinValue)
            {
                txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Ngaysinh.Enabled = false;

                if(oND.NAMSINH == null)
                {
                    txtND_Namsinh.Text = ((DateTime)oND.NGAYSINH).Year.ToString();
                    txtND_Namsinh.Enabled = false;
                }
                else
                {
                    txtND_Namsinh.Enabled = false;
                    txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                }
                
            }
            else
            {
                txtND_Ngaysinh.Text = null;
                txtND_Ngaysinh.Enabled = true;
                pnNDTochuc.Visible = true;
            }

            
            //ddlND_Gioitinh.Enabled = false;
            if (oND.GIOITINH != null)
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            if (pnNDTochuc.Visible)
            {

                if (oND.NGUOIDAIDIEN != null)
                {
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Ten.Enabled = false;
                }
                else
                {
                    txtND_NDD_Ten.Text = null;
                    txtND_NDD_Ten.Enabled = true;
                }
                if (oND.CHUCVU != null)
                {
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    txtND_NDD_Chucvu.Enabled = false;
                }
                else
                {
                    txtND_NDD_Chucvu.Text = null;
                    txtND_NDD_Chucvu.Enabled = true;
                }
                //if (oND.NDD_DIACHIID != null)
                //{
                //    DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                //    if (hc != null)
                //    {
                //        ddl_NDD_Tinh.Enabled = false;
                //        ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                //        LoadDrop_NDD_Huyen();
                //        ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                //        ddl_NDD_Huyen.Enabled = false;
                //    }
                //}
                //else
                //{
                //    ddl_NDD_Tinh.Enabled = true;
                //    ddl_NDD_Huyen.Enabled = true;
                //}

                if (pnNDTochuc.Visible)
                {
                    txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
                    txtND_NDD_Chucvu.Text = oND.CHUCVU;
                    if (oND.NDD_DIACHIID != null)
                    {
                        DM_HANHCHINH hc = dt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                        if (hc != null)
                        {
                            ddl_NDD_Tinh.Enabled = false;
                            ddl_NDD_Tinh.SelectedValue = hc.CAPCHAID.ToString();
                            LoadDrop_NDD_Huyen();
                            ddl_NDD_Huyen.Enabled = false;
                            ddl_NDD_Huyen.SelectedValue = hc.ID.ToString();
                        }
                    }
                    txtND_NDD_Diachichitiet.Text = oND.TAMTRUCHITIET;
                }
                else
                {
                    ddl_NDD_Tinh.Enabled = true;
                    ddl_NDD_Huyen.Enabled = true;
                }


                if (oND.NDD_DIACHICHITIET != null)
                {
                    txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
                    txtND_NDD_Diachichitiet.Enabled = false;
                }
                else
                {
                    txtND_NDD_Diachichitiet.Text = null;
                    txtND_NDD_Diachichitiet.Enabled = true;
                }

            }
            if (oND.EMAIL != null)
            {
                txtEmail.Text = oND.EMAIL + "";
                txtEmail.Enabled = false;
            }

            if (oND.DIENTHOAI != null)
            {
                txtDienthoai.Text = oND.DIENTHOAI + "";
                txtDienthoai.Enabled = false;
            }
            if (oND.FAX != null)
            {
                txtFax.Text = oND.FAX;
                txtFax.Enabled = false;
            }

            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            if (oND.BICANDAUVU == 1)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            if (cmdUpdate.Enabled)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }

        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xem":
                    lbthongbao.Text = "";
                    //loadedit(ND_id);
                    loadedit_dathuly(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false /*|| cmdUpdate.Enabled == false*/)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
                    SetTinhHuyenMacDinh();
                    break;
            }

        }
        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (ddlND_Quoctich.SelectedIndex > 0)
            //{
            //    //lblBatbuoc1.Text =
            //    lblBatbuoc2.Text = "";
            //    chkONuocNgoai.Visible = false;
            //}
            //else
            //{
            //    // lblBatbuoc1.Text =
            //    lblBatbuoc2.Text = "(*)";
            //    chkONuocNgoai.Visible = true;
            //}
            if (ddlLoaiNguyendon.SelectedValue == "1")
                Cls_Comon.SetFocus(this, this.GetType(), ddlND_Gioitinh.ClientID);
            else
                Cls_Comon.SetFocus(this, this.GetType(), txtEmail.ClientID);
        }
        private void LoadDropTinh()
        {
            ddlNoiSongTinh.Items.Clear();
            ddl_NDD_Tinh.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                //ddlThuongTruTinh.DataSource = lstTinh;
                //ddlThuongTruTinh.DataTextField = "TEN";
                //ddlThuongTruTinh.DataValueField = "ID";
                //ddlThuongTruTinh.DataBind();

                ddlNoiSongTinh.DataSource = lstTinh;
                ddlNoiSongTinh.DataTextField = "TEN";
                ddlNoiSongTinh.DataValueField = "ID";
                ddlNoiSongTinh.DataBind();

                ddl_NDD_Tinh.DataSource = lstTinh;
                ddl_NDD_Tinh.DataTextField = "TEN";
                ddl_NDD_Tinh.DataValueField = "ID";
                ddl_NDD_Tinh.DataBind();
            }
            //ddlThuongTruTinh.Items.Insert(0,new ListItem("---Chọn---", "0"));
            ddlNoiSongTinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddl_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            //LoadDropThuongTruHuyen();
            LoadDropNoiSongHuyen();
            LoadDrop_NDD_Huyen();
        }
        private void LoadDropNoiSongHuyen()
        {
            ddlNoiSongHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNoiSongHuyen.DataSource = lstHuyen;
                ddlNoiSongHuyen.DataTextField = "TEN";
                ddlNoiSongHuyen.DataValueField = "ID";
                ddlNoiSongHuyen.DataBind();
            }
            ddlNoiSongHuyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDrop_NDD_Huyen()
        {
            ddl_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddl_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddl_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddl_NDD_Huyen.DataSource = lstHuyen;
                ddl_NDD_Huyen.DataTextField = "TEN";
                ddl_NDD_Huyen.DataValueField = "ID";
                ddl_NDD_Huyen.DataBind();
            }
            ddl_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        protected void ddl_NDD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDrop_NDD_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddl_NDD_Huyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlNoiSongTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNoiSongHuyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNoiSongHuyen.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblXem = (LinkButton)e.Item.FindControl("lblXem");
                Cls_Comon.SetLinkButton(lblXem, oPer.CAPNHAT);

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                XLHC_DON_XULY oXL = dt.XLHC_DON_XULY.Where(x => x.DONID == oT.ID).FirstOrDefault();

                /*1. Nếu vụ án đang trong giai đoạn phúc thẩm thì không được xóa
                  2. Đã xử lý đơn thì không được xóa*/
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oXL != null)
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                    Cls_Comon.SetLinkButton(lblXem, true);
                }
                else
                {
                    lblSua.Visible = lbtXoa.Visible = true;
                    lblXem.Visible = false;
                }

                if (rowView.Row["DAIDIEN"].ToString() == "X ")
                {
                    lblSua.Visible = true;
                    lbtXoa.Visible = false;
                    lblXem.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;

                    if (rowView.Row["DAIDIEN"].ToString() == "X ")
                    {
                        lblXem.Visible = true;
                    }
                }

              

            }
        }

        protected bool IsShowDetail(object toagiaiquyetId)
        {
            if (toagiaiquyetId == null || toagiaiquyetId == DBNull.Value)
                return true;

            decimal donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]?.ToString());
            decimal toagqid = Convert.ToDecimal(toagiaiquyetId);
            return donvi_ID != toagqid;
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