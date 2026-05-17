using BL.GSTP;
using BL.GSTP.AHN;
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
using BL.GSTP.AHC;

namespace WEB.GSTP.QLAN.AHN.Sotham
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
                    hddDonID.Value = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                    if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");

                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(Convert.ToDecimal(hddDonID.Value));
                    LoadCombobox();
                    LoadNguoiKyInfo();
                    txtHieuLucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();
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
                lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
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
                AHN_DON oT = dt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<AHN_SOTHAM_THULY> lstCount = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
                if (lstCount.Count == 0)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                List<AHN_DON_THAMPHAN> lstTP = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                if (lstTP.Count == 0)
                {
                    lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                AHN_SOTHAM_BANAN banAn = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
                if (banAn != null)
                {
                    lbthongbao.Text = "Vụ việc đã có bản án. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISHNGD == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
                AHN_SOTHAM_QUYETDINH qdKetThuc = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).FirstOrDefault();
                if (qdKetThuc != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định kết thúc sơ thẩm. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                AHN_SOTHAM_KHANGCAO kc = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                AHN_SOTHAM_KHANGNGHI kn = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                if (kc != null)
                {
                    var kcChuaGiaiQuyet = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
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
                    AHN_SOTHAM_KHANGCAO kc2 = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 2).FirstOrDefault();
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
                    var knChuaGiaiQuyet = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
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
                    AHN_SOTHAM_KHANGNGHI kn2 = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 3).FirstOrDefault();
                    if (kn2 != null)
                    {

                        lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
                //AHN_SOTHAM_KHANGCAO kc = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 1).FirstOrDefault();
                //if (kc != null)
                //{
                //    lbthongbao.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddShowCommand.Value = "False";
                //    return;
                //}
                //AHN_SOTHAM_KHANGNGHI kn = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 1).FirstOrDefault();
                //if (kn != null)
                //{
                //    lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddShowCommand.Value = "False";
                //    return;
                //}
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                //check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddShowCommand.Value = "False";
                //    return;
                //}
                //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
                //int counttk = oCBDT.Rows.Count;
                //if (counttk > 0)
                //{
                //    //là thư k
                //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
                //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
                //    //int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
                //    int countItem = dt.AHN_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == ID && s.MAVAITRO == "VTTP_GIAIQUYETSOTHAM");
                //    if (countItem > 0)
                //    {
                //        //được gán 
                //    }
                //    else
                //    {
                //        //không được gán
                //        StrMsg = "Người dùng không được sửa đổi thông tin của vụ việc do không được phân công giải quyết.";
                //        lbthongbao.Text = StrMsg;
                //        Cls_Comon.SetButton(cmdUpdate, false);
                //        Cls_Comon.SetButton(cmdLammoi, false);
                //        hddShowCommand.Value = "False";
                //        return;
                //    }
                //}
            }
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
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "AHN", ngayBD, LoaiQD).ToString();
        }

        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            SetNewSoQD();
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
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
                string toagiaiquyetID = e.Item.Cells[10].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                //Tong dat roi khong duoc xao
                if (rowView["FILEID"] + "" != "")
                {
                    decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                    AHN_FILE oF = dt.AHN_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                    if (oF != null)
                    {
                        if (oF.TENFILE != null)
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                        }
                    }
                }


                if (rowView["IsBanAnST"].ToString() != "0")
                    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                //K: Check chuyen an
                AHN_DON don = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    //K: Quyết định 53-HS vẫn cho sửa
                    AHN_DON_GIAIDOAN checkGD = dt.AHN_DON_GIAIDOAN.Where(x => x.DONID == DONID && x.MAGIAIDOAN == 3).FirstOrDefault();
                    //
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
                            else
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                            }
                        }
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


                decimal QDID = Convert.ToDecimal(rowView["ID"].ToString());
                AHN_SOTHAM_KHANGCAO kc = dt.AHN_SOTHAM_KHANGCAO.Where(x => (x.LOAIKHANGCAO == 2 || x.LOAIKHANGCAO == 1) && x.SOQDBA == QDID).FirstOrDefault();

                AHN_SOTHAM_KHANGNGHI kn = dt.AHN_SOTHAM_KHANGNGHI.Where(x => (x.LOAIKN == 2 || x.LOAIKN == 1) && x.BANANID == QDID).FirstOrDefault();
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

                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddShowCommand.Value = "False";
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}
            }
        }
        private void LoadCombobox()
        {
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHNGD == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            // QHPL Thống kê mặc định selected theo thụ lý
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            AHN_SOTHAM_THULY tl = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
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
            //List<AHN_DON_DUONGSU> lstDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID).OrderBy(x => x.TENDUONGSU).ToList<AHN_DON_DUONGSU>();
            //ddlNguoiYC.DataSource = ddlNguoiBiYC.DataSource = lstDS;
            //ddlNguoiYC.DataTextField = ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            //ddlNguoiYC.DataValueField = ddlNguoiBiYC.DataValueField = "ID";
            //ddlNguoiYC.DataBind(); ddlNguoiBiYC.DataBind();
            //ddlNguoiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            //ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            //Lấy nguyên đơn đã đóng án phí
            AHN_DON_DUONGSU_BL oBL = new AHN_DON_DUONGSU_BL();
            DataTable tb = oBL.AHN_THULY_NGUYENDON(DonID);
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
            DataTable oDT = oBL.AHN_DM_QUYETDINH_VUAN();

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
            LoadHTXX();
            //Load ẩn hiện QHPL   
            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            if (ID > 0)
            {
                DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == ID).FirstOrDefault();
                if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")// Đình chỉ, công nhận thỏa thuận, chuyển vụ án
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
            AHN_SOTHAM_HDXX oND = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<AHN_SOTHAM_HDXX>();
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
                AHN_DON_THAMPHAN oTP = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
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
            hddid.Value = "0";
            lbtDownload.Visible = false;
            SetNewSoQD();
            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            lbxDuongSu.Items.Clear();
            ltDuongsuL.Visible = false;
        }
        private bool CheckValid()
        {
            if ((ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định mở phiên họp"))
                   && string.IsNullOrEmpty(txtNgayMoPhienToa.Text))
            {
                lbthongbao.Text = "Bạn chưa nhập ngày mở phiên toà";
                txtNgayMoPhienToa.Focus();
                return false;
            }

            if ((ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
                && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }

            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn quyết định. Hãy chọn lại!";
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

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên tòa") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên họp") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("tạm đình chỉ"))
            {
                if (pnLyDo.Visible)
                {
                    if (ddlLydo.SelectedValue == "0")
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
                    lbthongbao.Text = "Bạn chưa nhập hiệu lực từ ngày hoặc không hợp lệ !";
                    txtHieuLucTuNgay.Focus();
                    return false;
                }
            }
            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text) && !String.IsNullOrEmpty(txtHieuLucDenNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieuLucDenNgay.Text))
                {
                    DateTime tuNgay = DateTime.Parse(txtHieuLucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime denNgay = DateTime.Parse(txtHieuLucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(tuNgay, denNgay) > 0)
                    {
                        lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                //Kiểm tra ngày quyết định
                DateTime dNgayQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayQD > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày quyết định không được lớn hơn ngày hiện tại !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            decimal DONID = Convert.ToDecimal(hddDonID.Value);
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                DateTime dNgayQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                List<AHN_SOTHAM_THULY> lstGQD = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == DONID).OrderByDescending(y => y.NGAYTHULY).ToList();
                if (lstGQD.Count > 0)
                {

                    AHN_SOTHAM_THULY oDXL = lstGQD[0];
                    if (dNgayQD < oDXL.NGAYTHULY)
                    {
                        lbthongbao.Text = "Ngày quyết định không được trước ngày thụ lý '" + ((DateTime)oDXL.NGAYTHULY).ToString("dd/MM/yyyy") + "' !";
                        txtNgayQD.Focus();
                        return false;
                    }
                }
            }

            //----------------------------
            string so = txtSoQD.Text;
            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "AHN", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    Decimal CurrID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);

                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHN", ngay, LoaiQD).ToString();
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
        private decimal UploadFileID(AHN_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            AHN_DON_BL oBL = new AHN_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            AHN_FILE objFile = new AHN_FILE();
            if (FileID > 0)
                objFile = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
                dt.AHN_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;
                decimal STTQD = 0;
                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }
                AHN_SOTHAM_QUYETDINH oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new AHN_SOTHAM_QUYETDINH();
                    AHN_DON_BL oBL = new AHN_DON_BL();
                    if (!String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, NgayQD.Year, 1);
                    else
                    {
                        Decimal? a = null;
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(a), 1);
                    }
                    //oND.SOQD = STTQD.ToString() + "/" + DateTime.Now.Year.ToString();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
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
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHN_SOTHAM_QUYETDINH.Add(oND);
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
            AHN_DON oDon = dt.AHN_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HONNHAN_GIADINH && s.TRANGTHAI == 1);
            if (obj != null)
            {

                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            AHN_DON oDon = dt.AHN_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HONNHAN_GIADINH && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkkt.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            AHN_DON oDon = dt.AHN_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HONNHAN_GIADINH && s.TRANGTHAI == 1);
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
            AHN_SOTHAM_BL oBL = new AHN_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            DataTable oDT = oBL.AHN_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(ID);

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
            AHN_SOTHAM_QUYETDINH oND = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            {
                lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                return;
            }
            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
            AHN_TONGDAT oTD = dt.AHN_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_SOTHAM_QUYETDINH).FirstOrDefault();
            if (oTD != null)
            {
                lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                return;
            }
            decimal FileID = 0;
            if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

            //Luu thong tin Quyết định Sơ thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 3, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định Sơ thẩm án Hôn nhân", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc

            //Xoa Quyết định Sơ thẩm
            dt.AHN_SOTHAM_QUYETDINH.Remove(oND);
            SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
            dt.SaveChanges();
            if (FileID > 0)
            {
                try
                {
                    AHN_FILE objf = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                    dt.AHN_FILE.Remove(objf);
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
            AHN_SOTHAM_QUYETDINH oND = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
            AHN_TONGDAT oTD = dt.AHN_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_SOTHAM_QUYETDINH).FirstOrDefault();
            if (oTD != null)
            {
                lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                return;
            }
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            LoadLydo();
            LoadHTXX();
            if (pnHinhThucXetXu.Visible == true && oND.HINHTHUCXETXU != null)
            {
                ddlHTXX.SelectedValue = oND.HINHTHUCXETXU.ToString();
            }
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);

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

            if (oND.HIEULUCTU != null) txtHieuLucTuNgay.Text = ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);

            if (oND.HIEULUCDEN != null) txtHieuLucDenNgay.Text = ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (pnDuongSuYC.Visible)
            {
                ddlNguoiYC.SelectedValue = oND.NGUOIYEUCAUID.ToString();
                //ddlNguoiYC_SelectedIndexChanged(new object(), new EventArgs());
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
                AHN_FILE objFile = dt.AHN_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
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
                    var oND = dt.AHN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
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
                    AHN_SOTHAM_QUYETDINH oND1 = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                    AHN_TONGDAT oTD = dt.AHN_TONGDAT.Where(x => x.DONID == oND1.DONID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_SOTHAM_QUYETDINH).FirstOrDefault();
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
                        AHN_SOTHAM_QUYETDINH oND2 = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                        AHN_TONGDAT oTD1 = dt.AHN_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_SOTHAM_QUYETDINH).FirstOrDefault();
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
                        decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbthongbao.Text = Result;
                            return;
                        }
                        AHN_SOTHAM_QUYETDINH oND2 = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                        AHN_TONGDAT oTD1 = dt.AHN_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_SOTHAM_QUYETDINH).FirstOrDefault();
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
            AHN_SOTHAM_QUYETDINH oQD = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oQD.FILEID == null) return;
            decimal FileID = Convert.ToDecimal(oQD.FILEID);
            AHN_FILE oND = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
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

            if ((ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định mở phiên họp")))
            {
                LabeltxtNgayMoPhienToa.Visible = true;
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
                    if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")// Đình chỉ, công nhận thỏa thuận, chuyển vụ án
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
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHN", ngayQD, ID).ToString();
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
        //protected void ddlNguoiYC_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    ddlNguoiBiYC.Items.Clear();
        //    decimal DonID = Convert.ToDecimal(hddDonID.Value),
        //        NguoiYC = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
        //    List<AHN_DON_DUONGSU> lstDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID != NguoiYC).OrderBy(x => x.TENDUONGSU).ToList<AHN_DON_DUONGSU>();
        //    ddlNguoiBiYC.DataSource = lstDS;
        //    ddlNguoiBiYC.DataTextField = "TENDUONGSU";
        //    ddlNguoiBiYC.DataValueField = "ID";
        //    ddlNguoiBiYC.DataBind();
        //    ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        //    Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBiYC.ClientID);
        //}
        //Lanh lấy danh sách nguyên đơn đại diện
        void LoadDropDuongSu()
        {
            AHN_DON_DUONGSU_BL oBL = new AHN_DON_DUONGSU_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable obj = oBL.AHN_DON_DSDUONGSU_GETBY(ID);
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
            List<AHN_DON_DUONGSU> lstDS = dt.AHN_DON_DUONGSU.Where(x => x.DONID == DonID && x.TUCACHTOTUNG_MA == "BIDON").OrderBy(x => x.TENDUONGSU).ToList<AHN_DON_DUONGSU>();
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