using BL.GSTP;
using BL.GSTP.AHC;
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

namespace WEB.GSTP.QLAN.AHC.Phuctham
{
    public partial class Quyetdinhphuctham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        DKKContextContainer dkkt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadNguoiKyInfo();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    txtHieulucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    //Cap so QD tu dong theo loai QD
                    SetNewSoQD();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn             
                    decimal DONID = Convert.ToDecimal(current_id);
                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
                    AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    List<AHC_PHUCTHAM_THULY> lstCount = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                    if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    List<AHC_DON_THAMPHAN> lstTP = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                    if (lstTP.Count == 0)
                    {
                        lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.QHPLTKID != null) ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "AHC_PT", ngayBD, LoaiQD).ToString();
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
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                //Tong dat roi khong duoc xao
                if (rowView["FILEID"] + "" != "")
                {
                    decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                    AHC_FILE oF = dt.AHC_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
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

                // hoangndh: chan sua xoa toa khong co quyen
                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

                //Nếu mà là án đã kết thúc ẩn nút lưu 
                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbtXoa.Visible = false;
                //    lblSua.Visible = false;
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //}
            }
        }
        private void LoadCombobox()
        {
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHANHCHINH == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            LoadQD();
            // Load Người yêu cầu và bị yêu cầu
            LoadDuongSuYC();
        }
        private void LoadDuongSuYC()
        {
            ddlNguoiYC.Items.Clear(); ddlNguoiBiYC.Items.Clear();
            decimal DonID = Session[ENUM_LOAIAN.AN_HANHCHINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
            List<AHC_DON_DUONGSU> lstDS = dt.AHC_DON_DUONGSU.Where(x => x.DONID == DonID).OrderBy(x => x.TENDUONGSU).ToList<AHC_DON_DUONGSU>();
            ddlNguoiYC.DataSource = ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiYC.DataTextField = ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiYC.DataValueField = ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiYC.DataBind(); ddlNguoiBiYC.DataBind();
            ddlNguoiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        }
        private void LoadQD()
        {            
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN
            DM_QUYETDINH_VUAN oBL = new DM_QUYETDINH_VUAN();
            DataTable oDT = oBL.AHC_DM_QUYETDINH_VUAN_PT();

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
                if (oQD.MA == "DC" || oQD.MA == "CNTT")
                {
                    pnQHPL.Visible = true;
                }
                else pnQHPL.Visible = false;
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
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHC_PHUCTHAM_HDXX oND = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<AHC_PHUCTHAM_HDXX>();
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
            txtHieulucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieulucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            hddid.Value = "0";
            lbtDownload.Visible = false;
        }
        private bool CheckValid()
        {
            if ((ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
                    && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }

            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }
            if (pnLyDo.Visible)
            {
                if (ddlLydo.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydo.Focus();
                    return false;
                }
            }
            if (pntxtLydo.Visible)
            {
                if (txtLydo.Text == "" || txtLydo.Text == null)
                {
                    lbthongbao.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtLydo.Focus();
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

            if (!String.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieulucTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy)!";
                    txtHieulucTuNgay.Focus();
                    return false;
                }
            }
            if (!String.IsNullOrEmpty(txtHieulucTuNgay.Text) && !String.IsNullOrEmpty(txtHieulucDenNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieulucDenNgay.Text))
                {
                    DateTime tuNgay = DateTime.Parse(txtHieulucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime denNgay = DateTime.Parse(txtHieulucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(tuNgay, denNgay) > 0)
                    {
                        lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieulucDenNgay.Focus();
                        return false;
                    }
                }
            }

            string so = txtSoQD.Text;
            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "AHC_PT", so, ngay, LoaiQD);
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
        private decimal UploadFileID(AHC_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            AHC_DON_BL oBL = new AHC_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            AHC_FILE objFile = new AHC_FILE();
            if (FileID > 0)
                objFile = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
            {
                // update 130825
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHC_FILE.Add(objFile);
            }

            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;
                decimal STTQD = 0;
                AHC_PHUCTHAM_QUYETDINH oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new AHC_PHUCTHAM_QUYETDINH();
                    AHC_DON_BL oBL = new AHC_DON_BL();
                    STTQD = oBL.GETFILENEWTT((decimal)oDon.TOAANID, (decimal)oDon.MAGIAIDOAN, DateTime.Now.Year, 1);
                    oND.SOQD = STTQD.ToString() + "/" + DateTime.Now.Year.ToString();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                oND.DONID = DONID;
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);

                oND.LYDOID = (pnLyDo.Visible == true) ? Convert.ToDecimal(ddlLydo.SelectedValue) : (Decimal?)null;
                oND.LYDO_NAME = (txtLydo.Visible == true) ? txtLydo.Text : null;

                oND.SOQD = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieulucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);
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
                    // update 130825
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                    dt.AHC_PHUCTHAM_QUYETDINH.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                TamNgungDONKK_USER_DKNHANVB(DONID, ddlQuyetdinh.SelectedItem.Text);
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        private void GetTrangThaiBanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            AHC_DON oDon = dt.AHC_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HANHCHINH && s.TRANGTHAI == 1);
            if (obj != null)
            {

                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            AHC_DON oDon = dt.AHC_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HANHCHINH && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkkt.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            AHC_DON oDon = dt.AHC_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_HANHCHINH && s.TRANGTHAI == 1);
            if (obj != null)
            {

                if (TenQuyetDinh.StartsWith("09-HC.") || TenQuyetDinh.StartsWith("14-HC.") || TenQuyetDinh.StartsWith("15-HC.") || TenQuyetDinh.StartsWith("22-HC."))
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
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            DM_QUYETDINH_VUAN oBL = new DM_QUYETDINH_VUAN();
            DataTable oDT = oBL.DGLIST_QUYETDINH_PT(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH, ID);
            if (oDT != null)
            {
                #region "Xác định số lượng trang"
                int Total = oDT.Rows.Count;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
            AHC_PHUCTHAM_QUYETDINH oND = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
            AHC_TONGDAT oTD = dt.AHC_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHC_PHUCTHAM_QUYETDINH).FirstOrDefault();
            if (oTD != null)
            {
                lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                return;
            }
            decimal FileID = 0;
            if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
            SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
            //Luu thong tin Quyết định Phúc thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 6, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định Phúc thẩm an Hanh chính", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc

            //Anhpn 
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            AHC_PHUCTHAM_BANAN AHC_PHUCTHAM_BANAN = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<AHC_PHUCTHAM_BANAN>();
            if (AHC_PHUCTHAM_BANAN != null)
            {
                lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                return;
            }

            //Xoa Quyết định Phúc thẩm
            dt.AHC_PHUCTHAM_QUYETDINH.Remove(oND);
            dt.SaveChanges();
            if (FileID > 0)
            {
                try
                {
                    AHC_FILE objf = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                    dt.AHC_FILE.Remove(objf);
                    dt.SaveChanges();
                }
                catch (Exception ex) { }
            }
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            AHC_PHUCTHAM_QUYETDINH oND = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            LoadLydo();
            LoadHTXX();
            if(pnHinhThucXetXu.Visible == true && oND.HINHTHUCXETXU != null)
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
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            txtSoQD.Text = oND.SOQD;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieulucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (pnDuongSuYC.Visible)
            {
                ddlNguoiYC.SelectedValue = oND.NGUOIYEUCAUID.ToString();
                ddlNguoiYC_SelectedIndexChanged(new object(), new EventArgs());
                ddlNguoiBiYC.SelectedValue = oND.NGUOIBIYEUCAUID.ToString();
                txtNoiDungYC.Text = oND.GHICHU;
            }
            if ((oND.FILEID + "") != "" && (oND.FILEID + "") != "0")
            {
                AHC_FILE objFile = dt.AHC_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (objFile.TENFILE != null) lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Download":
                        var oND = dt.AHC_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        AHC_PHUCTHAM_QUYETDINH oND1 = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                        AHC_TONGDAT oTD = dt.AHC_TONGDAT.Where(x => x.DONID == oND1.DONID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHC_PHUCTHAM_QUYETDINH).FirstOrDefault();
                        if (oTD != null)
                        {
                            lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                            return;
                        }
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || cmdUpdate.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        AHC_PHUCTHAM_QUYETDINH oND2 = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                        // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                        AHC_TONGDAT oTD1 = dt.AHC_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHC_PHUCTHAM_QUYETDINH).FirstOrDefault();
                        if (oTD1 != null)
                        {
                            lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                            return;
                        }
                        xoa(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
        #endregion
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
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
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddid.Value);
                AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oQD.FILEID == null) return;
                decimal FileID = Convert.ToDecimal(oQD.FILEID);
                AHC_FILE oND = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
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
                    if (oQD.MA == "DC" || oQD.MA == "CNTT")
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
                if (ID == 106 || ID == 107 || ID == 108 ||ID == 109||ID == 110 || ID == 61)
                {
                    // lấy số mới nhất 
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHC_PT", ngayQD, ID).ToString();
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
        }
        protected void ddlNguoiYC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlNguoiBiYC.Items.Clear();
            decimal DonID = Session[ENUM_LOAIAN.AN_HANHCHINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]),
                NguoiYC = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
            List<AHC_DON_DUONGSU> lstDS = dt.AHC_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID != NguoiYC).OrderBy(x => x.TENDUONGSU).ToList<AHC_DON_DUONGSU>();
            ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiBiYC.DataBind();
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBiYC.ClientID);
        }

        protected void ddlLydo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQuyetdinh.Text == "106" && ddlLydo.Text == "481")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "106" && ddlLydo.Text != "481")
            {
                pntxtLydo.Visible = false;
            }
            if (ddlQuyetdinh.Text == "107" && ddlLydo.Text == "482")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "107" && ddlLydo.Text != "482")
            {
                pntxtLydo.Visible = false;
            }
        }

    }
}