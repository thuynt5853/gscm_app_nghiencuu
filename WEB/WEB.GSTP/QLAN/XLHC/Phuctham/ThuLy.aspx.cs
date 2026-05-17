using BL.GSTP;
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
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.XLHC.Phuctham
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckShowCommand(ID);
                    LoadCombobox();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    
                    // Load cán bộ
                    LoadDropCanBo();
                    
                    if (dgList.Items.Count == 0)
                    {
                        XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                        if (oT != null)
                        {
                            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                            ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                            LoadThoiHan((decimal)oT.QUANHEPHAPLUATID);
                        }
                        
                        //Số thụ lý mới
                        SetNewSoThuLy();
                    }
                    else
                    {
                        XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
                        DataTable oDT = oBL.XLHC_PHUCTHAM_THULY_GETLIST_V2(ID);
                        if (oDT != null && oDT.Rows.Count > 0)
                            loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                    }

                    CheckQuyen();
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }

        void CheckQuyen()
        {
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            // if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
      
            // MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            // Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            // //Kiểm tra thẩm phán giải quyết đơn             
            //
            // XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            // List<XLHC_PHUCTHAM_THULY> lstCount = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            // if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            // {
            //     lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
            //     Cls_Comon.SetButton(cmdUpdate, false);
            //     return;
            // }
            // List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            // if (lstTP.Count == 0)
            // {
            //     lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
            //     Cls_Comon.SetButton(cmdUpdate, false);
            //     Cls_Comon.SetButton(cmdLammoi, false);
            //     return;
            // }
            // if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            // {
            //     lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
            //     Cls_Comon.SetButton(cmdUpdate, false);
            //     Cls_Comon.SetButton(cmdLammoi, false);
            //     return;
            // }
            // if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            // {
            //     lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
            //     Cls_Comon.SetButton(cmdUpdate, false);
            //     Cls_Comon.SetButton(cmdLammoi, false);
            //     return;
            // }
            
            XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                .FirstOrDefault();
            if (chuyenNhanAn != null)
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
        }
        
        private void SetNewSoThuLy()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Số thụ lý mới
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul,
                    DateTimeStyles.NoCurrentDateDefault);
                txtSoThuly.Text = oSTBL.GET_STL_NEW(DonViID, "XLHC_PT", ngaythuly).ToString();

                txtNgayThongBao.Text = txtNgaythuly.Text;
                txtSoThongBao.Text = txtSoThuly.Text;
            }
        }

        void LoadDropCanBo()
        {
            ddlNguoiKy.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            DataTable tbl = obj.SP_CANBO_THULY_PT(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlNguoiKy.DataSource = tbl;
                ddlNguoiKy.DataValueField = "ID";
                ddlNguoiKy.DataTextField = "HOTEN_DROPDOWN";
                ddlNguoiKy.DataBind();
            }
        }

        private void CheckShowCommand(decimal DonID)
        {
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT != null)
            {
                //Kiểm tra có kháng cáo, kháng nghị hay không?
                XLHC_SOTHAM_BL objST = new XLHC_SOTHAM_BL();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && objST.XLHC_SOTHAM_KCaoKNghi_GETLIST(DonID).Rows.Count == 0)
                {
                    lbthongbao.Text = "Chưa có kháng cáo/ kháng nghị !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
            }
            XLHC_PHUCTHAM_BANAN ba = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có kết quả phiên họp. Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
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
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lbtXoa.Visible = lblSua.Visible = false;
                }
                
                 
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                    .FirstOrDefault();
                if (chuyenNhanAn != null)
                {
                    // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                    // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[9].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();

            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
        }
        private void LoadThoiHan(decimal QHID)
        {
            DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == QHID).FirstOrDefault();
            txtHanThang.Text = oT.SOTHANG == null ? "0" : oT.SOTHANG.ToString();
            txtHanNgay.Text = oT.SONGAY == null ? "0" : oT.SONGAY.ToString();
        }
        private void ResetControls()
        {
            DM_CANBO_BL obj = new DM_CANBO_BL();
            DataTable tbl = obj.SP_CANBO_THULY_PT(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            ddlNguoiKy.SelectedValue = tbl.Rows[0]["ID"] + "";
            
            // txtMaThuLy.Text = "";
            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtNgayThongBao.Text = txtNgaythuly.Text;
            
            XLHC_PHUCTHAM_BL oSTBL = new XLHC_PHUCTHAM_BL();
            txtSoThuly.Text = oSTBL.THULY_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])).ToString();
            txtSoThongBao.Text = txtSoThuly.Text;
            
            txtGhichu.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            txtHanThang.Text = "";
            txtHanNgay.Text = "";
            hddid.Value = "0";
        }
        private bool CheckValid()
        {
            if (Cls_Comon.IsValidDate(txtNgayThongBao.Text) == false)
            {
                lbthongbao.Text = "Ngày thông báo chưa nhập hoặc không hợp lệ!";
                txtNgaythuly.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
            {
                lbthongbao.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ!";
                txtNgaythuly.Focus();
                return false;
            }
            int lengthSoThuLy = txtSoThuly.Text.Trim().Length, lengthGhiChu = txtGhichu.Text.Trim().Length;
            if (lengthSoThuLy == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số thụ lý. Hãy nhập lại!";
                txtSoThuly.Focus();
                return false;
            }
            else if (lengthSoThuLy > 50)
            {
                lbthongbao.Text = "Số thụ lý không nhập quá 50 ký tự. Hãy nhập lại!";
                txtSoThuly.Focus();
                return false;
            }

            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lbthongbao.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            int lengthSoThongBao = txtSoThongBao.Text.Trim().Length;
            if (lengthSoThongBao == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số thông báo. Hãy nhập lại!";
                txtSoThongBao.Focus();
                return false;
            }
            else if (lengthSoThongBao > 50)
            {
                lbthongbao.Text = "Số thông báo không nhập quá 50 ký tự. Hãy nhập lại!";
                txtSoThongBao.Focus();
                return false;
            }
            
            if (txtTuNgay.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
            {
                lbthongbao.Text = "Ngày tháng không hợp lệ!";
                txtTuNgay.Focus();
                return false;
            }
            if (txtDenNgay.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lbthongbao.Text = "Ngày tháng không hợp lệ!";
                txtDenNgay.Focus();
                return false;
            }
            if (lengthGhiChu > 250)
            {
                lbthongbao.Text = "Ghi chú không nhập quá 250 ký tự!";
                txtGhichu.Focus();
                return false;
            }
            
            //----------------------------
            string sothuly = txtSoThuly.Text;
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "XLHC_PT", sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW(DonViID, "XLHC_PT", ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + txtSoThuly.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuly.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuly.Focus();
                        return false;
                    }
                }
            }

            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_PHUCTHAM_BL oPTBL = new XLHC_PHUCTHAM_BL();
                XLHC_PHUCTHAM_THULY oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new XLHC_PHUCTHAM_THULY();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_PHUCTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                //oND.MATHULY = "";
                oND.TRUONGHOPTHULY = Convert.ToDecimal(ddlLoaiThuLy.SelectedValue);

                oND.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SOTHULY = txtSoThuly.Text;
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);

                oND.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgayThongBao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayThongBao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SOTHONGBAO = txtSoThongBao.Text;
                oND.NGUOIKY = Convert.ToDecimal(ddlNguoiKy.SelectedValue);

                oND.THOIHANTUNGAY = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.GHICHU = txtGhichu.Text;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.TT = oPTBL.THULY_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    oND.MATHULY = "P" + ENUM_LOAIVUVIEC.BPXLHC + Session[ENUM_SESSION.SESSION_MADONVI] + oND.TT.ToString();
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }

                    XLHC_PHUCTHAM_THULY phucThamThuLyExist = dt.XLHC_PHUCTHAM_THULY.FirstOrDefault(x => x.DONID == DONID && x.TOAANID == oND.TOAANID);
                    if (phucThamThuLyExist != null)
                    {
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        LoadGrid();
                        lbthongbao.Text = "Đã có thông tin thụ lý. Không thể thêm mới!";
                        ResetControls();

                        return;
                    }
                    else
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_PHUCTHAM_THULY.Add(oND);
                        dt.SaveChanges();
                        //Cập nhật lại trạng thái vụ việc
                        XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("8", DONID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                    }
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Lưu thành công!";
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        public void LoadGrid()
        {
            XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_PHUCTHAM_THULY_GETLIST_V2(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
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
        }
        public void xoa(decimal id)
        {
            XLHC_PHUCTHAM_THULY oND = dt.XLHC_PHUCTHAM_THULY.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.XLHC_PHUCTHAM_THULY.Remove(oND);
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        public void loadedit(decimal ID)
        {
            XLHC_PHUCTHAM_THULY oND = dt.XLHC_PHUCTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                //txtMaThuLy.Text = oND.MATHULY;
                ddlLoaiThuLy.SelectedValue = oND.TRUONGHOPTHULY.ToString();

                if (oND.NGAYTHULY != null) txtNgaythuly.Text = ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                txtSoThuly.Text = oND.SOTHULY;
                
                if (oND.NGAYTHONGBAO != null) txtNgayThongBao.Text = ((DateTime)oND.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
                txtSoThongBao.Text = oND.SOTHONGBAO;

                ddlNguoiKy.SelectedValue = oND.NGUOIKY.ToString();
                
                ddlLoaiQuanhe.SelectedValue = oND.LOAIQUANHE.ToString();
                LoadCombobox();
                ddlQuanhephapluat.SelectedValue = oND.QUANHEPHAPLUATID.ToString();
                LoadThoiHan(Convert.ToDecimal(ddlQuanhephapluat.SelectedValue));
                if (oND.THOIHANTUNGAY != null) txtTuNgay.Text = ((DateTime)oND.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                if (oND.THOIHANDENNGAY != null) txtDenNgay.Text = ((DateTime)oND.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                txtGhichu.Text = oND.GHICHU;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongbao.Text = "";
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
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadCombobox(); }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadThoiHan(Convert.ToDecimal(ddlQuanhephapluat.SelectedValue)); }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        
        protected void ActionCopyNgayThuLy(object sender, EventArgs e)
        {
            txtNgayThongBao.Text = txtNgaythuly.Text;
        }
        
        protected void ActionCopySoThuLy(object sender, EventArgs e)
        {
            txtSoThongBao.Text = txtSoThuly.Text;
        }
    }
}