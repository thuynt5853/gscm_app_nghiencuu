using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.QLAN;
using BL.GSTP.Danhmuc;
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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.ADS.Sotham
{
    public partial class QuyetdinhVuviec : System.Web.UI.Page
    {
        DKKContextContainer dkkt = new DKKContextContainer();
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                 if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    hddDonID.Value = Session[ENUM_LOAIAN.AN_DANSU] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_DANSU] + "";
                    if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");

                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(Convert.ToDecimal(hddDonID.Value));
                    LoadCombobox();
                    txtHieuLucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();
                    LoadNguoiKyInfo();
                    decimal ID = Convert.ToDecimal(hddDonID.Value);
                    CheckQuyen(ID);
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

            //Nếu mà là án đã kết thúc ẩn nút lưu 
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc == true)
            {
                lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
            //Check quyết định sửa chữa, bổ sung bản án
            if (ddlQuyetdinh.SelectedItem.Text.Contains("53-DS"))
            {
                lbthongbao.Text = "";
            }
            else
            {
                ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();

                ADS_SOTHAM_BANAN banAn = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
                if (banAn != null)
                {
                    lbthongbao.Text = "Vụ việc đã có bản án. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISDANSU == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
                ADS_SOTHAM_QUYETDINH qdKetThuc = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).FirstOrDefault();
                if (qdKetThuc != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định kết thúc sơ thẩm. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                ADS_SOTHAM_KHANGCAO kc = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                ADS_SOTHAM_KHANGNGHI kn = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                if (kc != null)
                {
                    var kcChuaGiaiQuyet = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                    if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                    {
                        lbthongbao.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
                else
                {
                    ADS_SOTHAM_KHANGCAO kc2 = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 2).FirstOrDefault();
                    if (kc2 != null)
                    {

                        lbthongbao.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
                if (kn != null)
                {
                    var knChuaGiaiQuyet = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                    if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                    {
                        lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
                else
                {
                    ADS_SOTHAM_KHANGNGHI kn2 = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 3).FirstOrDefault();
                    if (kn2 != null)
                    {
                        lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }

                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<ADS_SOTHAM_THULY> lstCount = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
                if (lstCount.Count == 0)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<ADS_DON_THAMPHAN> lstTP = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                if (lstTP.Count == 0)
                {
                    lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                else
                {
                    hddNgayNhanPhanCong.Value = lstTP[0].NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)lstTP[0].NGAYNHANPHANCONG).ToString("dd/MM/yyyy");
                }



                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                //check vụ án đã kết thúc không cho sửa xóa
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    return;
                //}

            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                decimal QDID = Convert.ToDecimal(rowView["ID"].ToString());
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string toagiaiquyetID = e.Item.Cells[10].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ADS_DON don = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if (rowView["FILEID"] + "" != "")
                {
                    decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                    ADS_FILE oF = dt.ADS_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                    if (oF != null)
                    {
                        if (oF.TENFILE != null)
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                        }
                    }
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }

                if (rowView["IsBanAnST"].ToString() != "0")
                    lbtXoa.Visible = false;
                if (don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    //K: Quyết định 53-HS vẫn cho sửa
                    ADS_DON_GIAIDOAN checkGD = dt.ADS_DON_GIAIDOAN.Where(x => x.DONID == DONID && x.MAGIAIDOAN == 3).FirstOrDefault();
                    if (checkGD != null)
                    {
                        if (rowView["TenQD"].Equals("53-DS. Quyết định sửa chữa, bổ sung bản án"))
                        {
                            //K: Check quyết định có phải được thêm sau khi chuyển án không
                            string ngayTao = rowView["NGAYTAO"].ToString();
                            DateTime ngayQD = new DateTime();
                            ngayQD = Convert.ToDateTime(ngayTao);
                            if (ngayQD > checkGD.NGAYTAO)
                            {
                                lblSua.Text = "Sửa";
                                lbtXoa.Visible = true;
                            }
                        }
                    }
                    else
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }
                else
                {
                    if (rowView["TenQD"].Equals("53-DS. Quyết định sửa chữa, bổ sung bản án"))
                    {

                        lblSua.Text = "Sửa";
                        lbtXoa.Visible = true;
                    }
                }

                ADS_SOTHAM_KHANGCAO kc = dt.ADS_SOTHAM_KHANGCAO.Where(x => (x.LOAIKHANGCAO == 2 || x.LOAIKHANGCAO == 1) && x.SOQDBA == QDID).FirstOrDefault();

                ADS_SOTHAM_KHANGNGHI kn = dt.ADS_SOTHAM_KHANGNGHI.Where(x => (x.LOAIKN == 2 || x.LOAIKN == 1) && x.BANANID == QDID).FirstOrDefault();
                if (kc != null || kn != null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (rowView["READONLY"].ToString() == "1")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (!Convert.ToBoolean(hddShowCommand.Value))
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
             
            }
        }
        private void LoadCombobox()
        {
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISDANSU == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            // QHPL Thống kê mặc định selected theo thụ lý
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            ADS_SOTHAM_THULY tl = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
            if (tl != null)
            {
                try { ddlQHPLTK.SelectedValue = tl.QHPLTKID + ""; } catch { }
            }
            LoadQD();
            // Load Người yêu cầu và bị yêu cầu
            LoadDuongSuYC();
            LoadDuongSuBiYC();
        }
        private void LoadDuongSuYC()
        {
            ddlNguoiYC.Items.Clear(); ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            //Lấy nguyên đơn đã đóng án phí
            ADS_DON_DUONGSU_BL oBL = new ADS_DON_DUONGSU_BL();
            DataTable tb = oBL.ADS_THULY_NGUYENDON(DonID);
            ddlNguoiYC.DataSource = tb;
            ddlNguoiYC.DataTextField = "TENDUONGSU";
            ddlNguoiYC.DataValueField = "ID";
            ddlNguoiYC.DataBind();
            ddlNguoiYC.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN
            DM_QUYETDINH_VUAN oBL = new DM_QUYETDINH_VUAN();
            DataTable oDT = oBL.ADS_DM_QUYETDINH_VUAN();

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;

            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            LoadLydo();
            LoadHTXX();
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
            if ((ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định mở phiên họp")))
            {
                LabeltxtNgayMoPhienToa.Visible = true;
            }
        }
        private void LoadHTXX()
        {
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
            {
                pnHinhThucXetXu.Visible = true;
            }
            else
            {
                pnHinhThucXetXu.Visible = false;
            }
            ddlHTXX.SelectedIndex = 0;
        }
        private void LoadLydo()
        {
            if (ddlQuyetdinh.Items.Count > 0)
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();
                if (lst != null && lst.Count > 0)
                {
                    pnLyDo.Visible = true;
                    pntxtLydo.Visible = false;

                    ddlLydo.DataSource = lst;
                    ddlLydo.DataTextField = "TEN";
                    ddlLydo.DataValueField = "ID";
                    ddlLydo.DataBind();
                    ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }
                else
                {
                    pnLyDo.Visible = false;
                    pntxtLydo.Visible = false;
                }
                
                if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên tòa") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên họp"))
                {
                    pnLyDo.Visible = false;
                    pntxtLydo.Visible = true;
                }
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            ADS_SOTHAM_HDXX oND = dt.ADS_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<ADS_SOTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());

                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                ADS_DON_THAMPHAN oTP = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                        hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKy.Text = txtChucvu.Text = "";
            }
        }
        private void ResetControls()
        {
            txtLydo.Text = null;

            ddlLoaiQD.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            LoadDuongSuYC();
            LoadDuongSuBiYC();
            txtHieuLucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieuLucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            txtGio.Text = "";
            hddid.Value = "0";
            lbtDownload.Visible = false;
            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            lbxDuongSu.Items.Clear();
            ltDuongsuL.Visible = false;
        }
        private bool CheckValid()
        {
            if ((ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định mở phiên họp"))
                    && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }
            if ((ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định mở phiên họp"))
                    && string.IsNullOrEmpty(txtNgayMoPhienToa.Text))
            {
                lbthongbao.Text = "Bạn chưa nhập ngày mở phiên toà";
                txtNgayMoPhienToa.Focus();
                return false;
            }

            TimeSpan gio;
            if (!string.IsNullOrEmpty(txtGio.Text.Trim())
                && !TimeSpan.TryParseExact(txtGio.Text, "hh\\:mm", cul, out gio))
            {
                lbthongbao.Text = "Giờ không hợp lệ!";
                txtGio.Focus();
                return false;
            }


            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tên quyết định. Hãy chọn lại!";
                ddlQuyetdinh.Focus();
                return false;
            }

            if (pnQHPL.Visible)
            {
                if (ddlQHPLTK.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn quan hệ pháp luật. Hãy chọn lại!";
                    ddlQHPLTK.Focus();
                    return false;
                }
            }
            
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tạm đình chỉ") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tiếp tục giải quyết vụ án"))
            {
                int lengthSQD = txtSoQD.Text.Trim().Length;
                if (lengthSQD == 0)
                {
                    lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                    txtSoQD.Focus();
                    return false;
                }
                if (lengthSQD > 20)
                {
                    lbthongbao.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                    txtSoQD.Focus();
                    return false;
                }

                if (String.IsNullOrEmpty(txtNgayQD.Text))
                {
                    lbthongbao.Text = "Bạn chưa nhập ngày quyết định !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên tòa") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên họp") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("tạm đình chỉ"))
            {
                if(pnLyDo.Visible)
                {
                    if(ddlLydo.SelectedValue == "0")
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                }
                else
                {
                    int lengthSQD = txtLydo.Text.Trim().Length;
                    if (lengthSQD == 0)
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                    if (String.IsNullOrEmpty(txtLydo.Text))
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do !";
                        return false;
                    }
                }
            }
            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
            {
                bool hasSelected = lbxDuongSu.Items.Cast<ListItem>().Any(i => i.Selected);

                if (!hasSelected)
                {
                    lbthongbao.Text = "Bạn chưa chọn đương sự";
                    lbxDuongSu.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbao.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
                    txtNgayQD.Focus();
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

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                string so = txtSoQD.Text;

                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "ADS", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ADS", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
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
            return true;
        }
        private decimal UploadFileID(ADS_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            ADS_DON_BL oBL = new ADS_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            ADS_FILE objFile = new ADS_FILE();
            if (FileID > 0)
                objFile = dt.ADS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
            if (STT != 0) objFile.STT = oBL.GETFILENEWTT((decimal)objFile.TOAANID, (decimal)objFile.MAGIAIDOAN, DateTime.Now.Year, (decimal)objFile.LOAIFILE);
            if (FileID == 0)
                dt.ADS_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        void SetNewSoQD()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DateTime ngayBD;
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
                ngayBD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBD = DateTime.Now;
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "ADS", ngayBD, LoaiQD).ToString();
        }

        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            SetNewSoQD();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;

                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }

                ADS_SOTHAM_QUYETDINH oND;
                decimal STTQD = 0;
                if ((hddid.Value == "" || hddid.Value == "0"))
                {
                    oND = new ADS_SOTHAM_QUYETDINH();
                    ADS_DON_BL oBL = new ADS_DON_BL();
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    STTQD = oSTBL.GET_SQD_NEW(DonViID, "ADS", NgayQD, LoaiQD);
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
                if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
                {
                    var dsselected = lbxDuongSu.Items.Cast<ListItem>()
                               .Where(x => x.Selected)
                               .Select(x => x.Value);

                    oND.DUONGSU_IDS = string.Join(",", dsselected);
                }
                else
                {
                    oND.DUONGSU_IDS = "";
                }

                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                oND.GIOHEN = String.IsNullOrEmpty(txtGio.Text.Trim()) ? null : txtGio.Text;

                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);

                oND.LYDOID = (pnLyDo.Visible == true) ? Convert.ToDecimal(ddlLydo.SelectedValue) : (Decimal?)null;
                oND.LYDO_NAME = (txtLydo.Visible == true) ? txtLydo.Text : null;

                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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

                decimal rFileID = 0;
                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                rFileID = UploadFileID(oDon, FileID, oQDT.MA, STTQD);
                if (rFileID > 0) oND.FILEID = rFileID;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    //update 14082025
                    if (oND.TOA_GIAIQUYET_ID == null) oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_SOTHAM_QUYETDINH.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                TamNgungDONKK_USER_DKNHANVB(DONID, ddlQuyetdinh.SelectedItem.Text);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        private void GetTrangThaiBanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ADS_DON oDon = dt.ADS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_DANSU && s.TRANGTHAI == 1);
            if (obj != null)
            {

               ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ADS_DON oDon = dt.ADS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_DANSU && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkkt.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            ADS_DON oDon = dt.ADS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_DANSU && s.TRANGTHAI == 1);
            if (obj != null)
            {

                if (TenQuyetDinh.StartsWith("09-HC.") || TenQuyetDinh.StartsWith("45-DS.") || TenQuyetDinh.StartsWith("46-DS.") || TenQuyetDinh.StartsWith("38-DS.") || TenQuyetDinh.StartsWith("39-DS."))
                {
                    //chuyển trang trạng thái tạm dừng
                    obj.TRANGTHAI = 3;
                    dkkt.SaveChanges();
                }
                else
                {
                    obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                    dkkt.SaveChanges();
                }
            }
        }

        public void LoadGrid()
        {
            ADS_SOTHAM_BL oBL = new ADS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            DataTable oDT = oBL.ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(ID);

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
            pnHinhThucXetXu.Visible = false;
            ResetControls();
        }
        public void xoa(decimal id)
        {
            ADS_SOTHAM_QUYETDINH oND = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            {
                lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                return;
            }
            decimal FileID = 0;
            if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

            //Luu thong tin truoc khi xoa cac quyet dinh vu viec
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 2, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định vụ việc Sơ thẩm Dân sự", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công Quyết định!";
                return;
            }//Ket thuc 
            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
            ADS_TONGDAT oTD = dt.ADS_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == id && x.MAP_TABLE == ENUM_MAP_TABLE.ADS_SOTHAM_QUYETDINH).FirstOrDefault();
            if (oTD != null)
            {
                lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                return;
            }
            //Xoa cac quyet dinh vu viec
            dt.ADS_SOTHAM_QUYETDINH.Remove(oND);
            SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
            dt.SaveChanges();
            if (FileID > 0)
            {
                try
                {
                    ADS_FILE objf = dt.ADS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                    dt.ADS_FILE.Remove(objf);
                    dt.SaveChanges();
                }
                catch (Exception ex) { }
            }
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            ADS_SOTHAM_QUYETDINH oND = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
            if (oQD != null)
            {
                if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                {
                    pnQHPL.Visible = true;
                }
                else pnQHPL.Visible = false;
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
            LoadLydo();
            LoadHTXX();
            if (pnHinhThucXetXu.Visible == true && oND.HINHTHUCXETXU != null)
            {
                ddlHTXX.SelectedValue = oND.HINHTHUCXETXU.ToString();
            }

            if (oND.LYDOID != null && oND.LYDOID != 0)
            {
                pnLyDo.Visible = true;
                ddlLydo.SelectedValue = oND.LYDOID.ToString();
            }
            if (!string.IsNullOrEmpty(oND.LYDO_NAME + ""))
            {
                pntxtLydo.Visible = true;
                txtLydo.Text = oND.LYDO_NAME;
            }

            if (oND.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = oND.QHPLTKID.ToString();
            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            if (oND.GIOHEN != null) txtGio.Text = oND.GIOHEN;

            if (oND.HIEULUCTU != null) txtHieuLucTuNgay.Text = ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            if (oND.HIEULUCDEN != null) txtHieuLucDenNgay.Text = ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (pnDuongSuYC.Visible)
            {
                ddlNguoiYC.SelectedValue = oND.NGUOIYEUCAUID.ToString();
                ddlNguoiBiYC.SelectedValue = oND.NGUOIBIYEUCAUID.ToString();
                txtNoiDungYC.Text = oND.GHICHU;
            }

            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
            {
                LoadDropDuongSu();
                ltDuongsuL.Visible = true;
                pnHieulucngay.Visible = false;
            }
            else
            {
                lbxDuongSu.Items.Clear();
                ltDuongsuL.Visible = false;
                pnHieulucngay.Visible = true;
            }
            if (!string.IsNullOrEmpty(oND.DUONGSU_IDS))
            {
                string[] dsDuongSu = oND.DUONGSU_IDS.Split(',');
                foreach (string item in dsDuongSu)
                {
                    lbxDuongSu.Items.FindByValue(item).Selected = true;
                }
            }


            if ((oND.FILEID + "") != "" && (oND.FILEID + "") != "0")
            {
                ADS_FILE objFile = dt.ADS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (objFile.TENFILE != null) lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.ADS_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "Sua":
                    //K: Cho phép sửa ở trường hợp text = sửa
                    lbthongbao.Text = "";
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    if (lblSua.Text == "Sửa")
                    {
                        Cls_Comon.SetButton(cmdUpdate, true);
                        Cls_Comon.SetButton(cmdLammoi, true);
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    ADS_SOTHAM_QUYETDINH oND1 = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                    ADS_TONGDAT oTD = dt.ADS_TONGDAT.Where(x => x.DONID == oND1.DONID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ADS_SOTHAM_QUYETDINH).FirstOrDefault();
                    if (oTD != null)
                    {
                        lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                        return;
                    }
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    HiddenField tenQD = (HiddenField)e.Item.FindControl("hdTenQD");
                    if (tenQD.Value.Equals("53-DS. Quyết định sửa chữa, bổ sung bản án"))
                    {
                        ADS_SOTHAM_QUYETDINH oND2 = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                        ADS_TONGDAT oTD1 = dt.ADS_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ADS_SOTHAM_QUYETDINH).FirstOrDefault();
                        if (oTD1 != null)
                        {
                            lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                            return;
                        }
                        xoa(ND_id);
                    }
                    else
                    {
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || cmdUpdate.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbthongbao.Text = Result;
                            return;
                        }
                        ADS_SOTHAM_QUYETDINH oND2 = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                        ADS_TONGDAT oTD1 = dt.ADS_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ADS_SOTHAM_QUYETDINH).FirstOrDefault();
                        if (oTD1 != null)
                        {
                            lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                            return;
                        }
                        xoa(ND_id);
                    }
                    break;
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
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            ADS_SOTHAM_QUYETDINH oQD = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oQD.FILEID == null) return;
            decimal FileID = Convert.ToDecimal(oQD.FILEID);
            ADS_FILE oND = dt.ADS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
            Cls_Comon.SetFocus(this, this.GetType(), ddlQuyetdinh.ClientID);
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tạm đình chỉ") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tiếp tục giải quyết vụ án"))
            {
                ltSoQD.Text = ltNgayQD.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltSoQD.Text = ltNgayQD.Text = "";
            }

            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tạm đình chỉ") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tiếp tục giải quyết vụ án"))
            {
                ltSoQD.Text = ltNgayQD.Text = "<span style='color:red'>(*)</span>";
            }
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            //Check quyết định sửa chữa, bổ sung bản án
            decimal IDD = Convert.ToDecimal(hddDonID.Value);
            CheckQuyen(IDD);

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
                    if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                    {
                        pnQHPL.Visible = true;
                    }
                    else pnQHPL.Visible = false;
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
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ADS", ngayQD, ID).ToString();
                    txtSoQD.Text = STTNew;
                }
            }
            LoadLydo();
            LoadHTXX();
            if (pnQHPL.Visible && pnLyDo.Visible)
            {
                Cls_Comon.SetFocus(this, this.GetType(), ddlLydo.ClientID);
            }
            else if (!pnQHPL.Visible && pnLyDo.Visible)
            {
                Cls_Comon.SetFocus(this, this.GetType(), ddlLydo.ClientID);
            }
            else if (pnQHPL.Visible && !pnLyDo.Visible)
            {
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
            }
            else
            {
                Cls_Comon.SetFocus(this, this.GetType(), txtSoQD.ClientID);
            }

            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
            {
                LoadDropDuongSu();
                ltDuongsuL.Visible = true;
                txtHieuLucTuNgay.Text = txtHieuLucDenNgay.Text = "";
                pnHieulucngay.Visible = false;
            }
            else
            {
                ltDuongsuL.Visible = false;
                pnHieulucngay.Visible = true;
            }
        }

        //Lanh lấy danh sách nguyên đơn đại diện
        void LoadDropDuongSu()
        {
            ADS_DON_DUONGSU_BL oBL = new ADS_DON_DUONGSU_BL();
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable obj = oBL.ADS_SOTHAM_DUONGSU_GETBY(ID, 0);
            lbxDuongSu.Items.Clear();
            if (obj != null)
            {
                lbxDuongSu.DataSource = obj;
                lbxDuongSu.DataTextField = "TENDUONGSU";
                lbxDuongSu.DataValueField = "ID";
                lbxDuongSu.DataBind();
            }
            else
                lbxDuongSu.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        protected void LoadDuongSuBiYC()
        {
            ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            //Lấy tất cả bị đơn
            List<ADS_DON_DUONGSU> lstDS = dt.ADS_DON_DUONGSU.Where(x => x.DONID == DonID && x.TUCACHTOTUNG_MA == "BIDON").OrderBy(x => x.TENDUONGSU).ToList<ADS_DON_DUONGSU>();
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

    }
}