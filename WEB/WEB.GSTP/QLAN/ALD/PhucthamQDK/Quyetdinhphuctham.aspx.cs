using BL.GSTP;
using BL.GSTP.ALD;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.ALD;
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
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ALD.PhucthamQDK
{
    public partial class Quyetdinhphuctham : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private DKKContextContainer dkkt = new DKKContextContainer();
        private CultureInfo cul = new CultureInfo("vi-VN");

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
                    LoadCombobox();
                    LoadNguoiKyInfo();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
                    txtHieulucTuNgay.Text = txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

                    check_Quyen(DONID);
                    LoadGrid();
                    //Kiểm tra thẩm phán giải quyết đơn

                    //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
                    //int counttk = oCBDT.Rows.Count;
                    //if (counttk > 0)
                    //{
                    //    //là thư k
                    //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
                    //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
                    //    //int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
                    //    int countItem = dt.ALD_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == DONID && s.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM");
                    //    if (countItem > 0)
                    //    {
                    //        //được gán
                    //    }
                    //    else
                    //    {
                    //        //không được gán
                    //        string StrMsg = "Người dùng không được sửa đổi thông tin của vụ việc do không được phân công giải quyết.";
                    //        lbthongbao.Text = StrMsg;
                    //        Cls_Comon.SetButton(cmdUpdate, false);
                    //        Cls_Comon.SetButton(cmdLammoi, false);
                    //        return;
                    //    }
                    //}
                }
                LoadFile();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void check_Quyen(decimal DONID)
        {
            ALD_KCKN_PHUCTHAM_BL oBL = new ALD_KCKN_PHUCTHAM_BL();
            DataTable oDT = oBL.ALD_PHUCTHAMKCKNQDK_BANANQUYETDINH_GETLIST(DONID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có kêt quả phúc thẩm , Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowDetail.Value = "False";
                return;
            }
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            List<ALD_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<ALD_KCKNQDK_PHUCTHAM_THULY>("DONID = " + DONID);
            // List<ALD_PHUCTHAM_THULY> lstCount = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            List<ALD_DON_THAMPHAN> lstTP = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
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
            //check vụ án đã kết thúc không cho sửa xóa
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
        }

        private void SetNewSoQD()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DateTime ngayBD;
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
                ngayBD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBD = DateTime.Now;
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "ALD_PT", ngayBD, LoaiQD).ToString();
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
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                //Tong dat roi khong duoc xao
                if (rowView["FILEID"] + "" != "")
                {
                    decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                    ALD_FILE oF = dt.ALD_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
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

                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                }

                if (!Convert.ToBoolean(hddShowDetail.Value))
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
               
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
            ALD_PHUCTHAM_THULY tl = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
            if (tl != null)
            {
                try { ddlQHPLTK.SelectedValue = tl.QHPLTKID + ""; } catch { }
            }
            LoadQD();
            // Load Người yêu cầu và bị yêu cầu
            LoadDuongSuYC();
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
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN
            DM_QUYETDINH_VUAN oBL = new DM_QUYETDINH_VUAN();
            DataTable oDT = oBL.ALD_DM_QUYETDINH_VUAN_PT();
            DataRow[] sortedRows = oDT.Select("", "TEN ASC");
            ListItem it = new ListItem();
            it.Value = "64";
            it.Text = oDT.Select("ID = 64")[0]["TEN"].ToString();
            ddlQuyetdinh.Items.Clear();
            ddlQuyetdinh.Items.Insert(0, it);

            foreach (DataRow row in sortedRows)
            {
                if (row["ID"].ToString() != "64")
                {
                    ListItem items = new ListItem();
                    items.Value = row["ID"].ToString();
                    items.Text = row["TEN"].ToString();
                    ddlQuyetdinh.Items.Add(items);
                }
            }
            //if (oDT != null)
            //{
            //    ddlQuyetdinh.DataSource = oDT;
            //    ddlQuyetdinh.DataTextField = "TEN";
            //    ddlQuyetdinh.DataValueField = "ID";
            //    ddlQuyetdinh.DataBind();
            //}

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

            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử"))
            {
                ltNMPT.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltNMPT.Text = "";
            }
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            ALD_KCKN_PHUCTHAM_BL oBL = new ALD_KCKN_PHUCTHAM_BL();
            DataTable oDT = oBL.ALD_PHUCTHAMKCKNQDK_BANANQUYETDINH_GETLIST(DONID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định sửa chữa"))
                {
                    Cls_Comon.SetButton(cmdUpdate, true);
                    return;
                }
                else
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    return;
                }
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
                    if (ddlQuyetdinh.Text == "149")
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
            }
        }

        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            ALD_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<ALD_KCKNQDK_PHUCTHAM_HDXX>($"DONID ={DonID} AND MAVAITRO ='{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").OrderByDescending(x => x.ID).FirstOrDefault();
            //  ALD_PHUCTHAM_HDXX oND = dt.ALD_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<ALD_PHUCTHAM_HDXX>();
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
            LoadFile();
        }

        private bool CheckValid()
        {
            if ((ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") || ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định mở phiên họp"))
                && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") && Cls_Comon.IsValidDate(txtNgayMoPhienToa.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa chọn ngày mở phiên tòa";
                txtNgayMoPhienToa.Focus();
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
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày quyết định hoặc không hợp lệ !";
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

            //----------------------------
            string so = txtSoQD.Text;
            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "ALD_PT", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    Decimal CurrID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);

                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ALD_PT", ngay, LoaiQD).ToString();
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
            
            // quyennd
            if (objFile.TOA_GIAIQUYET_ID == null)
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            
            if (STT != 0) objFile.STT = oBL.GETFILENEWTT((decimal)objFile.TOAANID, (decimal)objFile.MAGIAIDOAN, DateTime.Now.Year, (decimal)objFile.LOAIFILE);
            if (FileID == 0)
                dt.ALD_FILE.Add(objFile);
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
                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;
                decimal STTQD = 0;
                ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new ALD_KCKNQDK_PHUCTHAM_QUYETDINH();
                    ALD_DON_BL oBL = new ALD_DON_BL();
                    STTQD = oBL.GETFILENEWTT((decimal)oDon.TOAANID, (decimal)oDon.MAGIAIDOAN, DateTime.Now.Year, 1);
                    oND.SOQD = STTQD.ToString() + "/" + DateTime.Now.Year.ToString();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(ID);
                    // oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                oND.DONID = DONID;
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                set_valueLydo(oND);

                oND.SOQD = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieulucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);
                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;
                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
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
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                    // dt.ALD_PHUCTHAM_QUYETDINH.Add(oND);
                    DataExtensions.Insert(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
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

                        #endregion Lưu file

                        File.Delete(strFilePath);
                    }
                }
                catch { }
                TamNgungDONKK_USER_DKNHANVB(DONID, ddlQuyetdinh.SelectedItem.Text);
                // dt.SaveChanges();
                DataExtensions.Update(oND);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                check_Quyen(DONID);
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
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

        private void GetTrangThaiBanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 1);
            if (obj != null)
            {
                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }

        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 3);
            if (obj != null)
            {
                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkkt.SaveChanges();
            }
        }

        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            ALD_DON oDon = dt.ALD_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkkt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG && s.TRANGTHAI == 1);
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
            //lbthongbao.Text = "";
            ALD_KCKN_PHUCTHAM_BL oBL = new ALD_KCKN_PHUCTHAM_BL();
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            DataTable oDT = oBL.ALD_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"

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
            ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(id);
            // ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            decimal FileID = 0;
            if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
            SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
            //Luu thong tin Quyết định Phúc thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG), Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định Phúc thẩm án Lao Động", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc

            //Xoa Quyết định Phúc thẩm
            DataExtensions.Delete(oND);
            // dt.ALD_PHUCTHAM_QUYETDINH.Remove(oND);
            dt.SaveChanges();
            if (FileID > 0)
            {
                try
                {
                    ALD_FILE objf = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                    dt.ALD_FILE.Remove(objf);
                    dt.SaveChanges();
                }
                catch { }
            }
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        public void loadedit(decimal ID)
        {
            cmdUpdate.Enabled = true;
            lbthongbao.Text = "";
            ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(ID);
            //ALD_PHUCTHAM_QUYETDINH oND = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            LoadLydo();
            LoadHTXX();
            ddlHTXX.SelectedValue = oND.HINHTHUCXETXU.ToString();
            get_valueLydo(ID);
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
                ALD_FILE objFile = dt.ALD_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
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
                //  decimal ID = Convert.ToDecimal(hddDonID.Value);
                switch (e.CommandName)
                {
                    case "Download":
                        var oND = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(ND_id);
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;

                    case "Sua":
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
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

        #endregion "Phân trang"

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
            decimal ID = Convert.ToDecimal(hddid.Value);
            ALD_KCKNQDK_PHUCTHAM_QUYETDINH oQD = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(ID);
            // ALD_PHUCTHAM_QUYETDINH oQD = dt.ALD_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oQD.FILEID == null) return;
            decimal FileID = Convert.ToDecimal(oQD.FILEID);
            ALD_FILE oND = dt.ALD_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
                if (ID == 143 || ID == 144 || ID == 145 || ID == 146 || ID == 61)
                {
                    // lấy số mới nhất
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "ALD_PT", ngayQD, ID).ToString();
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
            if (ddlQuyetdinh.Text == "143" && ddlLydo.Text == "90")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "143" && ddlLydo.Text != "90")
            {
                pntxtLydo.Visible = false;
            }
            if (ddlQuyetdinh.Text == "144" && ddlLydo.Text == "98")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "144" && ddlLydo.Text != "98")
            {
                pntxtLydo.Visible = false;
            }
        }

        protected void set_valueLydo(ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND)
        {
            if (ddlQuyetdinh.SelectedValue == "143" && ddlLydo.SelectedValue == "90")
            {
                oND.QUYETDINHID = 143;
                oND.LYDOID = 90;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "144" && ddlLydo.SelectedValue == "98")
            {
                oND.QUYETDINHID = 143;
                oND.LYDOID = 90;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "149")
            {
                oND.QUYETDINHID = 149;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (pnLyDo.Visible)
            {
                oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
            }
        }

        protected void get_valueLydo(decimal ID)
        {
            ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND = DataExtensions.FindById<ALD_KCKNQDK_PHUCTHAM_QUYETDINH>(ID);
            // ALD_KCKNQDK_PHUCTHAM_QUYETDINH oND = dt.ALD_KCKNQDK_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            if (oND.QUYETDINHID == 143 && oND.LYDOID == 90)
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
            else if (oND.QUYETDINHID == 144 && oND.LYDOID == 98)
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
            else if (oND.QUYETDINHID == 149)
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
    }
}