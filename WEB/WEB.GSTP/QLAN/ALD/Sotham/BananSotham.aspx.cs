using BL.GSTP;
using BL.GSTP.ALD;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET.THONGKE;
using BL.GSTP.DLQGC12;
using BL.GSTP.QLAN;
using BL.GSTP.Quantri;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ALD.Sotham
{
    public partial class BananSotham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        DKKContextContainer dkk = new DKKContextContainer();
        private static CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal DSID = 0;
        private const decimal BANAN = 1, QUYETDINH = 2;

        public static bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch
            { return false; }
        }
        public static string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch
            { return ""; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DSID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_LAODONG] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                hddDonID.Value = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_LAODONG] + "";
                if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");

                LoadDrop_Anle();
                LoadCombobox();
                LoadBoLuat();

                CheckQuyen(DONID);
                CheckQuyenSua(DONID);

                LoadNguoiKyInfo();
                LoadBanAnInfo(DONID);
                LoadDieuLuat();
                LoadAnPhi();
                LoadTGTT();
                GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
                SetNewSoQD();
                LoadGrid();
                CheckCongbo(DONID);
            }
            LoadFile();
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
        void SetNewSoQD()
        {
            DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ALD_SOTHAM_BL oSTBL = new ALD_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG} AND CAPXETXU = 2 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                lbthongbaoA.Text = lbthongbaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLuatUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdAnphi, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdTGTT, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdHuyBanAn, oPer.CAPNHAT);

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG, ID);
            if (oDT.Rows.Count > 0)
            {
                pnQDVV.Visible = true;
                pnBAST.Visible = false;
                rdbPanelQD.Enabled = false;
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();

                lstErr.Text = lbthongbaoQD.Text = "Vụ viêc đã có quyết định kết thúc!";
                DisableButtonsQuyetdinh();
            }
            else
            {
                rdbPanelQD.Enabled = true;
            }

            //Kiểm tra xem đã thụ lý chưa
            List<ALD_SOTHAM_THULY> lstCount = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return;
            }
            else
            {
                hddNgayThuLy.Value = lstCount[0].NGAYTHULY + "" == "" ? "" : ((DateTime)lstCount[0].NGAYTHULY).ToString("dd/MM/yyyy");
            }

            //Kiểm tra đã phân công thẩm phán chưa
            List<ALD_DON_THAMPHAN> lstTPGQ = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").ToList();
            if (lstTPGQ.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin hội đồng xét xử !";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return;
            }

            //--Kiểm tra đã phân công thẩm phán chủ tọa
            List<ALD_SOTHAM_HDXX> lstTPCT = dt.ALD_SOTHAM_HDXX.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
            if (lstTPCT.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin hội đồng xét xử !";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return;
            }

            //Kiểm tra xem đã có quyết định đưa vụ việc ra xét xử hay không
            //decimal IDLQD = 0;
            //DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
            //if (oLQD != null) IDLQD = oLQD.ID;
            //List<ALD_SOTHAM_QUYETDINH> lstQDXX = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == IDLQD).ToList();
            //if (lstQDXX.Count == 0)
            //{
            //    lstErr.Text = "Chưa cập nhật quyết định đưa vụ án ra xét xử !";
            //    DisableButtonsBanan();
            //}

            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue == "0")
            {
                DisableButtonsQuyetdinh();
            }

            //GTEL-HUNGQ 07-10-2025 thêm check có dương sự chưa xác thực thì không cho Lưu
            Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == ID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
            if (soDuongSuChuaXacThuc > 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return;
            }

            KHOBAQD_BL ald = new KHOBAQD_BL();
            bool isExist = ald.IsExistKHOBADQ(0, ID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }

            isExist = ald.IsExistKHOBADQ(1, ID, 2, ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            //END GTEL-HUNGQ 07-10-2025

            //check vụ án đã kết thúc không cho sửa xóa
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(cmdLuatUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);
                Cls_Comon.SetButton(cmdTGTT, false);
                Cls_Comon.SetButton(cmdXoaTGTT, false);
                return;
            }
        }
        private bool CheckQuyenSua(decimal ID)
        {
            Cls_Comon.SetButton(btnUpdate, true);
            hddShowCommand.Value = "True";

            ALD_SOTHAM_BANAN ba = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
            if (ba != null)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có bản án. Không được sửa đổi.";
                DisableButtonsQuyetdinh();
            }
            else
            {
                Cls_Comon.SetButton(cmdLuatUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdTGTT, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);
                Cls_Comon.SetButton(cmdXoaTGTT, false);
            }

            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    DisableButtonsBanan();
                    DisableButtonsQuyetdinh();
                    return false;
                }
            }

            List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISLAODONG == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
            List<ALD_SOTHAM_QUYETDINH> qdKetThuc = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).ToList();
            if (ba != null && qdKetThuc != null)
            {
                ALD_SOTHAM_KHANGCAO kc2 = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == ID).FirstOrDefault();
                if (kc2 != null)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                    DisableButtonsBanan();
                    DisableButtonsQuyetdinh();
                    return false;
                }
                ALD_SOTHAM_KHANGNGHI kn2 = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID).FirstOrDefault();
                if (kn2 != null)
                {

                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    DisableButtonsBanan();
                    DisableButtonsQuyetdinh();
                    return false;
                }
            }
            else
            {
                ALD_SOTHAM_KHANGCAO kc = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                ALD_SOTHAM_KHANGNGHI kn = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                if (kc != null)
                {
                    var kcChuaGiaiQuyet = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                    if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                        DisableButtonsBanan();
                        DisableButtonsQuyetdinh();
                        return false;
                    }
                }
                else
                {
                    ALD_SOTHAM_KHANGCAO kc2 = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == ID).FirstOrDefault();
                    if (kc2 != null)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                        DisableButtonsBanan();
                        DisableButtonsQuyetdinh();
                        return false;
                    }
                }
                if (kn != null)
                {
                    var knChuaGiaiQuyet = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                    if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                        DisableButtonsBanan();
                        DisableButtonsQuyetdinh();
                        return false;
                    }
                }
                else
                {
                    ALD_SOTHAM_KHANGNGHI kn2 = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID).FirstOrDefault();
                    if (kn2 != null)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                        DisableButtonsBanan();
                        DisableButtonsQuyetdinh();
                        return false;
                    }
                }

            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstErr.Text = lbthongbaoQD.Text = Result;
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return false;
            }
            #region hieu nếu có tống đạt thì ko được xóa bản án sơ thẩm
            ALD_TONGDAT td = dt.ALD_TONGDAT.Where(x => x.DONID == ID && (x.BIEUMAUID == 230 || x.BIEUMAUID == 261)).FirstOrDefault();
            if (td != null)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã tống đạt không được xóa";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                return false;
            }
            #endregion

            Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == ID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
            if (soDuongSuChuaXacThuc > 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                Cls_Comon.SetButton(cmdUpdate, false);
                return false;
            }

            //GTEL-HUNGQ 07-10-2025 Check neu da chia sẻ dữ liệu không được xóa
            KHOBAQD_BL ald = new KHOBAQD_BL();
            bool isExist = ald.IsExistKHOBADQ(0, ID, 2,ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                Cls_Comon.SetButton(cmdUpdate, false);
                return false;
            }

            isExist = ald.IsExistKHOBADQ(1, ID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
            if (isExist)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                DisableButtonsBanan();
                DisableButtonsQuyetdinh();
                Cls_Comon.SetButton(cmdUpdate, false);
                return false;
            }
            // END GTEL-HUNGNQ 
            return true;
            
        }
        // Hàm tắt các nút
        private void DisableButtonsBanan()
        {
            Cls_Comon.SetButton(cmdUpdate, false);
            Cls_Comon.SetButton(cmdLuatUpdate, false);
            Cls_Comon.SetButton(cmdAnphi, false);
            Cls_Comon.SetButton(cmdTGTT, false);
            Cls_Comon.SetButton(cmdHuyBanAn, false);
            Cls_Comon.SetButton(cmdXoaAnphi, false);
            Cls_Comon.SetButton(cmdXoaTGTT, false);
        }
        private void DisableButtonsQuyetdinh()
        {
            Cls_Comon.SetButton(btnUpdate, false);
            hddShowCommand.Value = "False";
        }


        #region thông tin quyết định - HIEUVM
        //thông tin quyết định
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG, ID);

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
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN_KETTHUC
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_SOTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);

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
        }
        private void LoadLydo()
        {
            if (ddlQuyetdinh.Items.Count > 0 && ddlQuyetdinh.SelectedValue != "0")
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();
                if (lst != null && lst.Count > 0)
                {
                    if (ddlQuyetdinh.Text == "1")
                    {
                        pnLyDo.Visible = false;
                    }
                    else
                    {
                        pnLyDo.Visible = true;
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
                }
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            ALD_SOTHAM_HDXX oND = dt.ALD_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault<ALD_SOTHAM_HDXX>();
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
                ALD_DON_THAMPHAN oTP = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault();
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
        private void ResetControl_Quyetdinh()
        {
            ddlLoaiQD.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            ddlCBBA_AnleQD.SelectedValue = "0";
            rdbVKSThamgia_QD.ClearSelection();
            txtSoQDTraiPLBiHuy_QD.Text = "";
            rdqHoaGiaiThanhQD.ClearSelection();
            LoadDuongSuYC();
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieuLucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            //DonID luôn cố định, reset thì các hàm khác gây lỗi không tìm thấy đơn
            //hddDonID.Value = "0";
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Decimal ID = Convert.ToDecimal(hddDonID.Value);
            List<ALD_SOTHAM_QUYETDINH> lstQD = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.QUYETDINHID == 70 || x.QUYETDINHID == 425 || x.LOAIQDID == 3)).ToList();
            if (lstQD.Count >= 1)
            {
                ddlQuyetdinh.Enabled = true;
                Cls_Comon.SetButton(btnUpdate, false);
            }
            ResetControl_Quyetdinh();
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
            Cls_Comon.SetFocus(this, this.GetType(), ddlQuyetdinh.ClientID);
        }
        public void xoa(decimal id)
        {
            ALD_SOTHAM_QUYETDINH oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            if (oND.NOIDUNG == null && oND.QT_FILE_ID != null)
            {
                QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                if (qtFileDelete != null)
                {
                    qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_LAODONG + ".";
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    fileH.DeleteFileLogic(qtFileDelete);
                }
            }
            TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {id} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
            if (TK != null)
            {
                DataExtensions.Delete(TK);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                    $"  AND CAPXETXU = {2} ");

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
            //if (oND != null)

            if (CheckQuyenSua(Convert.ToDecimal(oND.DONID + "")) == true)
            {
                if (oND != null)
                {
                    decimal FileID = 0;
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

                    dt.ALD_SOTHAM_QUYETDINH.Remove(oND);
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
                    ResetControl_Quyetdinh();
                    lbthongbao.Text = "Xóa thành công!";
                    Page.Response.Redirect(Page.Request.Url.ToString(), true);
                }
            }
            return;
        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelBA.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAST.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAST.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelQD.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAST.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAST.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void btnUpdate_Quyetdinh_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                if (!CheckValidQDVV() || !CheckCongbo(DONID)) return;

                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;

                //GTEL-HUNGQ 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                //Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == DONID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
                //if (soDuongSuChuaXacThuc > 0)
                //{
                //    lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                //    return;
                //}

                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(1, DONID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGQ 22-09-2025

                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }
                ALD_SOTHAM_QUYETDINH oND;
                TK_SOTHAM_QUYETDINH TK = new TK_SOTHAM_QUYETDINH();
                decimal STTQD = 0;
                if ((hddID.Value == "" || hddID.Value == "0"))
                {
                    Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == DONID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
                    if (soDuongSuChuaXacThuc > 0)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                        return;
                    }

                    oND = new ALD_SOTHAM_QUYETDINH();
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
                    TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID= {ID} AND LOAIAN =  {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
                    oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
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
                        QT_FILE_BL fileHelper = new QT_FILE_BL();
                        QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG), "BANANSOTHAM");
                        if (qtFile == null)
                        {
                            lstErr.Text = "Lỗi khi lưu file!";
                            return;
                        }
                        #region Lưu file
                        //byte[] buff = null;
                        //using (FileStream fs = File.OpenRead(strFilePath))
                        //{
                        //BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        //long numBytes = oF.Length;
                        //buff = br.ReadBytes((int)numBytes);
                        //oND.NOIDUNGFILE = buff;
                        oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                        oND.KIEUFILE = oF.Extension;
                        oND.QT_FILE_ID = qtFile.ID;
                        //}
                        #endregion
                        //File.Delete(strFilePath);
                    }
                }
                catch (Exception ex)
                {
                    lstErr.Text = ex.Message;
                    return;
                }
                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();

                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);

                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLQDVV.SelectedValue);
                oND.QUANHEPHAPLUAT = txtQHPLQDVV.Text;

                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;
                oND.NOIDUNG = txtTomtatnoidungQuyetdinh.Text;
                if (pnLyDo.Visible) oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
                if (!ddlQuyetdinh.SelectedItem.Text.Contains("19-VDS") && ddlQuyetdinh.SelectedValue != "4")
                {
                    TK.DONID = DONID;
                    TK.LOAIAN = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    TK.ISVKSTHAMGIA = rdbVKSThamgia_QD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbVKSThamgia_QD.SelectedValue);
                    TK.APDUNGANLE = ddlCBBA_AnleQD.SelectedValue == "0" ? 0 : 1;
                    TK.SOANLE = ddlCBBA_AnleQD.SelectedValue;
                    TK.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                    TK.ISHOAGIAITHANH = rdqHoaGiaiThanhQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdqHoaGiaiThanhQD.SelectedValue);
                    TK.TK_SOQDTRAIPLBIHUY = (String.IsNullOrEmpty(txtSoQDTraiPLBiHuy_QD.Text + "")) ? 0 : Convert.ToDecimal(txtSoQDTraiPLBiHuy_QD.Text);
                }

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
                rFileID = UploadFileIDQD(oDon, FileID, oQDT.MA, STTQD);
                if (rFileID > 0) oND.FILEID = rFileID;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ALD_SOTHAM_QUYETDINH.Add(oND);
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

                if (oQDT.ISCONGBO == 1 && oND.HIEULUCTU != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    temp_congbo.CAPXETXU = 2;
                    temp_congbo.ISBA = 0;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.HIEULUCTU;
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
                ResetControl_Quyetdinh();
                LoadGrid();
                lbthongbao.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
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
                    //byte[] buff = null;
                    //using (FileStream fs = File.OpenRead(strFilePath))
                    //{
                    //BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(strFilePath);
                    //long numBytes = oF.Length;
                    //buff = br.ReadBytes((int)numBytes);
                    //objFile.NOIDUNG = buff;
                    objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                    objFile.KIEUFILE = oF.Extension;
                    //}
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            // quyennd
            if (objFile.TOA_GIAIQUYET_ID == null)
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            if (STT != 0) objFile.STT = Convert.ToDecimal(STT);
            if (FileID == 0)
                dt.ALD_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private decimal UploadFileIDQD(ALD_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
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
            if (hddFilePathQD.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    if (chkKySo.Checked)
                    {
                        string[] arr = hddFilePathQD.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                    }
                    else
                        strFilePath = hddFilePathQD.Value.Replace("/", "\\");
                    //byte[] buff = null;
                    //using (FileStream fs = File.OpenRead(strFilePath))
                    //{
                    //BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(strFilePath);
                    //long numBytes = oF.Length;
                    //buff = br.ReadBytes((int)numBytes);
                    //objFile.NOIDUNG = buff;
                    objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                    objFile.KIEUFILE = oF.Extension;
                    //}
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            // quyennd
            if (objFile.TOA_GIAIQUYET_ID == null)
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
            ddlQuyetdinh.Enabled = false;

            ALD_SOTHAM_QUYETDINH oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            TK_SOTHAM_QUYETDINH TK = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {ID} AND LOAIAN = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)}").FirstOrDefault();
            SetEnable_data_QD(oND);
            CheckQuyenSua(Convert.ToDecimal(oND.DONID + ""));
            hddID.Value = oND.ID.ToString();
            hddDonID.Value = oND.DONID.ToString();
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
                    //ddlQuyetdinh.Enabled = true;
                    pnCBQD.Visible = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else pnCBQD.Visible = false;
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
                pnDuongSuYC.Visible = false;
                pnCBQD.Visible = false;

            }

            if (!ddlQuyetdinh.SelectedItem.Text.Contains("19-VDS") && ddlQuyetdinh.SelectedValue != "4")
            {
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

                if (TK.ISVKSTHAMGIA != null) rdbVKSThamgia_QD.SelectedValue = TK.ISVKSTHAMGIA.ToString();
                if (TK.ISHOAGIAITHANH != null) rdqHoaGiaiThanhQD.SelectedValue = TK.ISHOAGIAITHANH.ToString();
                if (TK.YEUTONUOCNGOAI != null) Convert.ToDecimal(ddlYeutonuocngoai_QD.SelectedValue);
                //TK.TK_SOQDTRAIPLBIHUY = (String.IsNullOrEmpty(txtSoQDTraiPLBiHuy_QD.Text + "")) ? 0 : Convert.ToDecimal(txtSoQDTraiPLBiHuy_QD.Text);
                if (TK.TK_SOQDTRAIPLBIHUY != null) txtSoQDTraiPLBiHuy_QD.Text = TK.TK_SOQDTRAIPLBIHUY.ToString();
            }

            ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.LYDOID != null && pnLyDo.Visible)
                ddlLydo.SelectedValue = oND.LYDOID.ToString();

            if (oND.QHPLTKID != null)
                ddlQHPLQDVV.SelectedValue = oND.QHPLTKID.ToString();
            // công bố quyết định
            if (oND.ISCONGBOQD != null)
                rdCongBoQD.SelectedValue = oND.ISCONGBOQD.ToString();
            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
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

            txtTomtatnoidungQuyetdinh.Text = oND.NOIDUNG;
            txtQHPLQDVV.Text = oND.QUANHEPHAPLUAT;
            var twords = Regex.Matches(txtTomtatnoidungQuyetdinh.Text, @"\w+");
            decimal words = twords.Count;
            wordCountdownQuyetdinh.InnerText = "Số từ còn lại: " + (200 - words).ToString();
        }
        private void SetEnable_data_QD(ALD_SOTHAM_QUYETDINH QD)
        {
            if (QD != null)
            {
                txtQuanhephapluat.Enabled = false;
                ddlQHPLTK.Enabled = false;
                ddlQuyetdinh.Enabled = false;
                if (QD.DIADIEMMOPT != null)
                    txtDiaDiem.Enabled = false;
                else
                    txtDiaDiem.Enabled = true;

                txtSoQD.Enabled = false;
                txtNgayQD.Enabled = false;
                if (QD.HIEULUCTU != null)
                    txtHieuLucTuNgay.Enabled = false;
                else
                    txtHieuLucTuNgay.Enabled = true;

                if (QD.HIEULUCDEN != null)
                    txtHieuLucDenNgay.Enabled = false;
                else
                    txtHieuLucDenNgay.Enabled = true;

                if (QD.NOIDUNG != null)
                    txtTomtatnoidungQuyetdinh.Enabled = false;
                else
                    txtTomtatnoidungQuyetdinh.Enabled = true;

                try
                {
                    //TK_SOTHAM_QUYETDINH tk = DataExtensions.GetAllWithClause<TK_SOTHAM_QUYETDINH>($"QUYETDINHID = {QD.ID} AND LOAIAN =  {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)}").FirstOrDefault();
                    //if (tk != null)
                    //{
                    //    if (tk.TK_ISKHONGCHAPNHAN == 1)
                    //    {
                    //        chkKhongchapnhan_QD.Enabled = false;
                    //        rdLydokhongchapnhan_QD.Enabled = false;
                    //        chkChapnhan_QD.Enabled = false;
                    //        rdLydoChapnhan_QD.Enabled = false;
                    //    }

                    //    if (tk.TK_ISCHAPNHAN == 1)
                    //    {
                    //        chkChapnhan_QD.Enabled = false;
                    //        rdLydoChapnhan_QD.Visible = true;
                    //        rdLydoChapnhan_QD.Enabled = false;
                    //        chkKhongchapnhan_QD.Enabled = false;
                    //        rdLydokhongchapnhan_QD.Enabled = false;
                    //    }

                    //    if (tk.SOCONDUOI7TUOI != null)
                    //        txtSoconduoi7tuoi_QD.Enabled = false;
                    //    else
                    //        txtSoconduoi7tuoi_QD.Enabled = true;

                    //    if (tk.SOCONDUOI18LANU != null)
                    //        txtSoconduoi18tuoi_QD.Enabled = false;
                    //    else
                    //        txtSoconduoi18tuoi_QD.Enabled = true;

                    //    if (tk.TONGSOCONDUOI18TUOI != null)
                    //        txtTongsoconduoi18tuoi_QD.Enabled = false;
                    //    else
                    //        txtTongsoconduoi18tuoi_QD.Enabled = true;
                    //}
                    ddlYeutonuocngoai_QD.Enabled = false;
                    txtSoQDTraiPLBiHuy_QD.Enabled = false;
                    rdqHoaGiaiThanhQD.Enabled = false;
                    btnUpdate.Text = "Cập nhật Quyết định";

                    KHOBAQD_BL oDonBL = new KHOBAQD_BL();
                    bool isExist = oDonBL.IsExistKHOBADQ(1, QD.DONID ?? 0, 2, ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH);
                    if (isExist)
                    {
                        lbthongbaoQD.Text = "Vụ việc đã được chia sẻ dữ liệu. Không được xóa.";
                        DisableButtonsBanan();
                        DisableButtonsQuyetdinh();
                    }
                }
                catch (Exception ex)
                {
                    lbthongbaoQD.Text = ex.Message;
                    return;
                }

                // khong duoc sửa khi da Tong dat nhưng cho phép nhập thêm những trường trống -27 / 11 / 2025 vnpt check
                ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == QD.DONID && x.MAPID == QD.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_QUYETDINH).FirstOrDefault();
                if (oTD != null)
                {
                    if (!string.IsNullOrEmpty(QD.QUANHEPHAPLUAT))
                    {
                        txtQHPLQDVV.Enabled = false;
                    }
                    else
                    {
                        txtQHPLQDVV.Enabled = true;
                    }
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
                    if (!string.IsNullOrEmpty(QD.NOIDUNG))
                    {
                        txtTomtatnoidungQuyetdinh.Enabled = false;
                    }
                    else
                    {
                        txtTomtatnoidungQuyetdinh.Enabled = true;
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
                    var oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.FILEID == ND_id).FirstOrDefault();
                    if (oND.NOIDUNGFILE != null)
                    {
                        if (oND.NOIDUNGFILE.Length != 0 && oND.QT_FILE_ID == null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                    }
                    else
                    {
                        QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                        // Xây dựng path cho file
                        string _pathStore = QT_FILE_BL.ToPathFolderStore(qT_FILE.DATE_CREATED.Value, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)) + "\\BANANSOTHAM";
                        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(qT_FILE.FILE_NAME);
                        string pathRaw = Path.Combine(_pathStore,
                            Cls_Comon.ChuyenTVKhongDau(fileNameWithoutExtension) +
                            qT_FILE.ID +
                            qT_FILE.FILE_TYPE);
                        var pathUrlStyle = pathRaw.Replace("\\", "/");
                        var encodedPath = HttpUtility.UrlEncode(pathUrlStyle);

                        // Đảm bảo HTTPS
                        var authority = Request.Url.GetLeftPart(UriPartial.Authority).Replace("http://", "https://");
                        var appPath = Request.ApplicationPath?.TrimEnd('/') ?? "";
                        string downloadUrl = $"{authority}{appPath}/Quantri/Cauhinh/FileDownload.ashx?p={HttpUtility.UrlEncode(encodedPath)}";

                        // JavaScript redirect
                        string script = $@"window.location.href = '{downloadUrl}';";

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "downloadScript", script, true);
                    }
                    break;
                case "Sua":
                    hddFilePathQD.Value = "";
                    lbthongbao.Text = "";
                    ALD_SOTHAM_QUYETDINH oND1 = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    //ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == oND1.DONID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_QUYETDINH).FirstOrDefault();
                    //if (oTD != null)
                    //{
                    //    lbthongbao.Text = lbthongbaoQD.Text = "Bạn không thể sửa khi đã tống đạt!";
                    //    return;
                    //}
                    loadedit(ND_id);
                    hddID.Value = e.CommandArgument.ToString();
                    //hddDonID.Value = "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false || btnUpdate.Enabled == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    ALD_SOTHAM_QUYETDINH oND2 = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == ND_id).FirstOrDefault();
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    ALD_TONGDAT oTD1 = dt.ALD_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_QUYETDINH).FirstOrDefault();
                    if (oTD1 != null)
                    {
                        lbthongbao.Text = lbthongbaoQD.Text = "Bạn không thể xóa khi đã tống đạt!";
                        return;
                    }
                    //Dữ liệu Quyết định đã được chia sẻ không được xóa
                    KHOBAQD_BL ald = new KHOBAQD_BL();
                    bool isExist = ald.IsExistKHOBADQ(1, DonID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                    if (isExist)
                    {
                        lbthongbao.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
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
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                ALD_SOTHAM_KHANGCAO oTKC = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == DONID).FirstOrDefault();
                ALD_SOTHAM_KHANGNGHI oTKN = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == DONID).FirstOrDefault();
                if (oTKC != null || oTKN != null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
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

                //check quyen thao tac du lieu cua toa dang xu an
                string toagiaiquyetID = rowView.Row["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
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

            CheckQuyenSua(IDD);

            if (btnUpdate.Enabled == true)
            {
                //update 080825: hotfix
                //--Kiểm tra đã phân công thẩm phán chưa
                ALD_DON_THAMPHAN oTP = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == IDD && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP == null)
                {
                    lbthongbaoQD.Text = "Chưa cập nhật thông tin hội đồng xét xử !";
                    Cls_Comon.SetButton(btnUpdate, false);
                    return;
                }
                else if (oT.LOAIID == 2 /*Chuyển vụ án*/ || oT.TEN.Contains("cho Thẩm phán") ||
                    oT.ID == 422 /*19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự*/ ||
                    oT.ID == 423 /*20-VDS. Quyết định đình chỉ giải quyết sơ thẩm việc dân sự*/||
                    oT.ID == 429 /*26-VDS. Quyết định đình chỉ giải quyết phúc thẩm việc dân sự*/)
                {
                    lbthongbaoQD.Text = "";
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else
                {
                    //Kiểm tra xem đã có quyết định đưa vụ việc ra xét xử hay không
                    ALD_SOTHAM_QUYETDINH QDST = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == IDD && x.LOAIQDID == 5 && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
                    if (QDST == null)
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
                    if (/*oQD.MA == "TDC"*/ oT.LOAIID == 10 || oT.LOAIID == 11 || oT.LOAIID == 3)
                    {
                        pnCBQD.Visible = true;
                    }
                    else pnCBQD.Visible = false;
                    if (oQD.MA == "DC" || oQD.MA == "CNTT")
                    {
                        pnCBQD.Visible = false;
                        pnDuongSuYC.Visible = false;
                    }
                    if (oQD.MA == "GQDS")
                    {
                        pnCBQD.Visible = false;
                        pnChiTieuThongKe.Visible = true;
                    }
                    else
                    {
                        pnChiTieuThongKe.Visible = false;
                        pnHoaGiaiThanh.Visible = false;
                    }
                }
                else
                {
                    pnDuongSuYC.Visible = false;
                    pnCBQD.Visible = false;
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
            if (ddlQuyetdinh.SelectedItem.Text.Contains("20-VDS"))
            {
                pnChiTieuThongKe.Visible = true;
                pnHoaGiaiThanh.Visible = false;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("38-DS") || ddlQuyetdinh.SelectedItem.Text.Contains("45-DS"))
            {
                pnChiTieuThongKe.Visible = true;
                pnVKSThamGia.Visible = false;
                pnHoaGiaiThanh.Visible = true;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("46-DS") || ddlQuyetdinh.SelectedItem.Text.Contains("39-DS"))
            {
                pnChiTieuThongKe.Visible = true;
                pnVKSThamGia.Visible = true;
                pnHoaGiaiThanh.Visible = true;
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

        #endregion
        private void LoadAnPhi()
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_SOTHAM_BL oBL = new ALD_SOTHAM_BL();
            dgAnPhi.DataSource = oBL.ALD_SOTHAM_BANAN_ANPHI_GET(DONID);
            dgAnPhi.DataBind();
            foreach (DataGridItem oItem in dgAnPhi.Items)
            {
                CheckBox chkMien = (CheckBox)oItem.FindControl("chkMien");
                TextBox txtAnphi = (TextBox)oItem.FindControl("txtAnphi");
                if (chkMien.Checked)
                {
                    txtAnphi.Text = "";
                    txtAnphi.Enabled = false;
                }
                else
                {
                    txtAnphi.Enabled = true;
                }
            }
        }
        private void LoadTGTT()
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_SOTHAM_BL oBL = new ALD_SOTHAM_BL();
            DataTable dtTGTT = oBL.ALD_SOTHAM_BANAN_TGTT_GET(DONID);
            if (dtTGTT != null && dtTGTT.Rows.Count > 0)
            {
                hddTGTTRowLastIndex.Value = dtTGTT.Rows.Count + "";
            }
            dgTGTT.DataSource = dtTGTT;
            dgTGTT.DataBind();
        }
        protected void dgTGTT_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                TextBox txtNgayTGTT = (TextBox)e.Item.FindControl("txtNgayTGTT");
                if (hddTGTTRowLastIndex.Value == (dgTGTT.Items.Count + 1) + "")
                {
                    txtNgayTGTT.Attributes.Add("onfocus", "myFunctionFocus();");
                }
            }
        }
        private void LoadBoLuat()
        {
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.LOAI == ENUM_LOAIVUVIEC.AN_LAODONG && x.HIEULUC == 1).OrderByDescending(y => y.NGAYBANHANH).ToList();
            if (lst != null && lst.Count > 0)
            {
                pnAnPhi.Visible = true;
                ddlBoLuat.DataSource = lst;
                ddlBoLuat.DataTextField = "TENBOLUAT";
                ddlBoLuat.DataValueField = "ID";
                ddlBoLuat.DataBind();
                LoadDieuKhoan();
            }
            else { pnAnPhi.Visible = false; }
        }
        private void LoadDieuKhoan()
        {
            if (ddlBoLuat.Items.Count > 0)
            {
                decimal IDBL = Convert.ToDecimal(ddlBoLuat.SelectedValue);
                ddlDieukhoan.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == IDBL).ToList();
                ddlDieukhoan.DataTextField = "TENTOIDANH";
                ddlDieukhoan.DataValueField = "ID";
                ddlDieukhoan.DataBind();
            }
        }
        private void LoadFile()
        {
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            dgFile.DataSource = dt.ALD_SOTHAM_BANAN_FILE.Where(x => x.DONID == ID).ToList();
            dgFile.DataBind();

            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            int ma_gd = (int)oT.MAGIAIDOAN;
            foreach (DataGridItem item in dgFile.Items)
            {
                LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                if (hddShowCommand.Value == "False")
                {
                    lbtXoa.Visible = false;
                }
            }
        }
        private void LoadDieuLuat()
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_SOTHAM_BL oBL = new ALD_SOTHAM_BL();
            dgDieuLuat.DataSource = oBL.ALD_SOTHAM_BANAN_DIEULUAT_GET(DONID);
            dgDieuLuat.DataBind();
        }
        private void LoadBanAnInfo(decimal DonID)
        {
            List<ALD_SOTHAM_BANAN> lst = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (lst.Count > 0)
            {
                // Chọn sẵn giá trị "1" (Bản án)
                rdbPanelBA.SelectedValue = "1";

                // Khóa không cho người dùng thay đổi
                rdbPanelBA.Enabled = false;
                rdbPanelQD.Enabled = false;

                /*pnZonekythuong.Visible = */
                pnDgFile.Visible = true;
                ALD_SOTHAM_BANAN oT = lst[0];
                hddBanAnID.Value = oT.ID.ToString();
                txtSobanan.Text = oT.SOBANAN;
                ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                if (oT.QHPLTKID != null)
                    ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();

                //txtQuanhephapluat_name(oT);
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;

                if (oT.NGAYMOPHIENTOA != null)
                {
                    txtNgaymophientoa.Text = ((DateTime)oT.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                }
                if (oT.NGAYTUYENAN != null) txtNgaytuyenan.Text = ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                if (oT.NGAYHIEULUC != null) txtNgayhieuluc.Text = ((DateTime)oT.NGAYHIEULUC).ToString("dd/MM/yyyy", cul);

                if (oT.ISVKSTHAMGIA != null) rdbVKSThamgia.SelectedValue = oT.ISVKSTHAMGIA.ToString();

                ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();

                if ((oT.APDUNGANLE == null || oT.APDUNGANLE == 1) && oT.SOANLE == null)
                {
                    ddlCBBA_Anle.Items.Insert(ddlCBBA_Anle.Items.Count, new ListItem("Hãy chọn số án lệ", "-1"));
                    ddlCBBA_Anle.SelectedValue = "-1";
                }
                else
                {
                    ddlCBBA_Anle.SelectedValue = string.IsNullOrEmpty(oT.SOANLE + "") ? "0" : oT.SOANLE;
                }
                //rdCongboBA.SelectedValue = (string.IsNullOrEmpty(oT.ISCONGBOBA + "")) ? "0" : oT.ISCONGBOBA.ToString();
                rdVuAnQuaHan.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISQUAHAN + "")) ? "0" : oT.TK_ISQUAHAN.ToString();
                rdNNChuQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_CHUQUAN + "")) ? "0" : oT.TK_QUAHAN_CHUQUAN.ToString();
                rdNNKhachQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_KHACHQUAN + "")) ? "0" : oT.TK_QUAHAN_KHACHQUAN.ToString();
                txtSoQDTraiPL.Text = oT.TK_SOQDTRAIPLBIHUY + "";
                if (rdVuAnQuaHan.SelectedValue == "1")
                    pnNguyenNhanQuaHan.Visible = true;
                else
                    pnNguyenNhanQuaHan.Visible = false;

                txtTomtatnoidungBanan.Text = oT.NOIDUNG;
                var twords = Regex.Matches(txtTomtatnoidungBanan.Text, @"\w+");
                decimal words = twords.Count;
                wordCountdownBanan.InnerText = "Số từ còn lại: " + (200 - words).ToString();
                LoadFile();
            }
            else
            {
                /*pnZonekythuong.Visible = */
                pnDgFile.Visible = false;
                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (oDon != null)
                {
                    ddlLoaiQuanhe.SelectedValue = oDon.LOAIQUANHE.ToString();
                    if (oDon.QHPLTKID != null) ddlQHPLTK.SelectedValue = oDon.QHPLTKID.ToString();
                    ddlYeutonuocngoai.SelectedValue = oDon.YEUTONUOCNGOAI.ToString();
                }
                ALD_SOTHAM_THULY tl = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
                if (tl != null)
                {
                    if (tl.QHPLTKID != null)
                    {
                        ddlQHPLTK.SelectedValue = tl.QHPLTKID.ToString();
                        txtQuanhephapluat.Text = tl.QUANHEPHAPLUAT_NAME;
                    }
                    //txtQuanhephapluat_name(tl);
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

            if (pnCBQD.Visible)
            {
                if (rdCongBoQD.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                    rdCongBoQD.Focus();
                    return false;
                }
            }

            if (ddlQHPLQDVV.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn quan hệ pháp luật. Hãy chọn lại!";
                ddlQHPLQDVV.Focus();
                return false;
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
                if (hddNgayNhanPhanCong.Value != "")
                {
                    DateTime NgayNhanPC = DateTime.Parse(hddNgayNhanPhanCong.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayQD < NgayNhanPC)
                    {
                        lbthongbaoQD.Text = "Ngày quyết định phải lớn hơn ngày phân công thẩm phán giải quyết " + hddNgayNhanPhanCong.Value + " !";
                        txtNgayQD.Focus();
                        return false;
                    }
                }

            }


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

            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieuLucTuNgay.Text) == false)
                {
                    lbthongbaoQD.Text = "Bạn chưa nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy) !";
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
                    lbthongbaoQD.Text = "Hiệu lực từ ngày phải nhỏ hơn ngày quyết định !";
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
                        lbthongbaoQD.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
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
            }
            //----------------------------
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
            decimal DONID = Convert.ToDecimal(hddDonID.Value);
            decimal ID = Convert.ToDecimal(hddID.Value);
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG, DONID);
            if (oDT.Rows.Count > 0 && oDT.Rows[0]["ID"].ToString() != ID.ToString())
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Vụ án đã có quyết định. Hãy kiểm tra lại! " + "')", true);
                lbthongbaoQD.Text = "Lỗi: Vụ án đã có quyết định. Hãy kiểm tra lại.!";
                return false;
            }
            //ALD_SOTHAM_QUYETDINH oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            //// khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
            //if (oND != null)
            //{
            //    ALD_TONGDAT oTD = dt.ALD_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_QUYETDINH).FirstOrDefault();
            //    if (oTD != null)
            //    {
            //        lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
            //        return false;
            //    }
            //}
            return true;
        }
        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstErr.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstErr.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNguoiKy.Text == null || txtNguoiKy.Text == "")
            {
                lstErr.Text = "Chưa nhập người ký.";
                txtNguoiKy.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedValue == "0")
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
            if (txtSobanan.Text == "")
            {
                lstErr.Text = "Chưa nhập số bản án";
                txtSobanan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaymophientoa.Text) == false)
            {
                lstErr.Text = "Chưa nhập ngày mở phiên tòa hoặc không hợp lệ !";
                txtNgaymophientoa.Focus();
                return false;
            }
            DateTime dNgayMoPhienToa = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayMoPhienToa > DateTime.Now)
            {
                lstErr.Text = "Ngày mở phiên tòa không được lớn hơn ngày hiện tại !";
                txtNgaymophientoa.Focus();
                return false;
            }
            DateTime NgayThuLy = hddNgayThuLy.Value == "" ? DateTime.MinValue : DateTime.Parse(hddNgayThuLy.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayMoPhienToa < NgayThuLy)
            {
                lstErr.Text = "Ngày mở phiên tòa không được nhỏ hơn ngày thụ lý " + hddNgayThuLy.Value;
                txtNgaymophientoa.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaytuyenan.Text) == false)
            {
                lstErr.Text = "Chưa nhập ngày tuyên án hoặc không hợp lệ !";
                return false;
            }
            DateTime dNgayTA = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayTA > DateTime.Now)
            {
                lstErr.Text = "Ngày tuyên án không được lớn hơn ngày hiện tại !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (dNgayTA < dNgayMoPhienToa)
            {
                lstErr.Text = "Ngày tuyên án phải lớn hơn ngày mở phiên tòa !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (txtNgayhieuluc.Text.Trim() != "")
            {
                if (Cls_Comon.IsValidDate(txtNgayhieuluc.Text) == false)
                {
                    lstErr.Text = "Chưa nhập ngày hiệu lực hoặc không hợp lệ !";
                    return false;
                }
                DateTime dNgayHieuLuc = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayHieuLuc < dNgayTA)
                {
                    lstErr.Text = "Ngày hiệu lực phải lớn hơn ngày tuyên án !";
                    txtNgayhieuluc.Focus();
                    return false;
                }
            }
            if (ddlCBBA_Anle.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lstErr.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return false;
            }
            //if (rdCongboBA.SelectedValue == "")
            //{
            //    lstErr.Text = "Bạn chưa chọn \"Có công bố bản án ?\"";
            //    return false;
            //}
            if (rdbVKSThamgia.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn \"Có VKS tham gia ?\"";
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn \"Vụ án quá hạn luật định ?\"";
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                if (rdNNChuQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn \"Nguyên nhân chủ quan ?\"";
                    return false;
                }
                if (rdNNKhachQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn \"Nguyên nhân khách quan ?\"";
                    return false;
                }
            }

            //----------------------------
            string so = txtSobanan.Text;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
            {
                DateTime ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "ALD", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "ALD", ngayBA).ToString();
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
            return true;
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ALD_FILE oND = dt.ALD_FILE.Where(x => x.DONID == DONID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.URL, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU_LD, ENUM_DANHMUC.QUANHEPL_TRANHCHAP_LD);

            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê BA.
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
            //QHPL QDVV

            // QHPL Thống kê mặc định selected theo thụ lý
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            ALD_SOTHAM_THULY tl = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
            if (tl != null)
            {
                try
                {
                    ddlQHPLTK.SelectedValue = tl.QHPLTKID + "";
                    ddlQHPLQDVV.SelectedValue = tl.QHPLTKID + "";
                    txtQuanhephapluat.Text = tl.QUANHEPHAPLUAT_NAME + "";
                    txtQHPLQDVV.Text = tl.QUANHEPHAPLUAT_NAME + "";
                }
                catch { }
            }
            //load người kí - mặc định chủ tọa
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_SOTHAM_HDXX oHD = dt.ALD_SOTHAM_HDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN && x.DONID == DONID).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault();
            if (oHD != null)
            {
                DM_CANBO oTPCT = dt.DM_CANBO.Where(x => x.ID == oHD.CANBOID).FirstOrDefault();
                //ddlNguoiKy.Items.Add(new ListItem(oTPCT.HOTEN + " - Thẩm phán Chủ Tọa", oTPCT.ID.ToString()));
                txtNguoiKy.Text = txtNguoiKyTTVV.Text = oTPCT.HOTEN + "- Thẩm phán Chủ Tọa";
                if (oTPCT.CHUCVUID != null && oTPCT.CHUCVUID != 0)
                {
                    DM_DATAITEM cv = dt.DM_DATAITEM.Where(x => x.ID == oTPCT.CHUCVUID).FirstOrDefault();
                    txtChucvu.Text = cv.TEN;
                }
            }
            else { txtNguoiKy.Text = ""; }
            LoadQD();
            // Load Người yêu cầu và bị yêu cầuGET_SQD_NEW
            LoadDuongSuYC();
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";

        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {

            LoadCombobox();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(DONID)) return;

                //GTEL-HUNGQ 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                //Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == DONID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
                //if (soDuongSuChuaXacThuc > 0)
                //{
                //    lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                //    return;
                //}

                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(0, DONID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGQ 22-09-2025

                ALD_SOTHAM_BANAN_FILE oTF = new ALD_SOTHAM_BANAN_FILE();
                List<ALD_SOTHAM_BANAN> lst = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == DONID).ToList();
                ALD_SOTHAM_BANAN oND;
                if (lst.Count == 0)
                {
                    Decimal soDuongSuChuaXacThuc = dt.ALD_DON_DUONGSU.Count(x => x.DONID == DONID && x.XACTHUC_DLDCQG == 0 && x.QUOCTICHID == 2);
                    if (soDuongSuChuaXacThuc > 0)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Có đương sự chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách đương sự.";
                        return;
                    }

                    oND = new ALD_SOTHAM_BANAN();
                }
                else
                {
                    oND = lst[0];
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    ALD_TONGDAT oTD2 = dt.ALD_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_BANAN).FirstOrDefault();
                    if (oTD2 != null)
                    {
                        if (oTD2 != null)
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
                            if (!string.IsNullOrEmpty(oND.NGUOIKY))
                            {
                                txtNguoiKy.Enabled = false;
                            }
                            else
                            {
                                txtNguoiKy.Enabled = true;
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
                            if (!string.IsNullOrEmpty(oND.NOIDUNG))
                            {
                                txtTomtatnoidungBanan.Enabled = false;
                            }
                            else
                            {
                                txtTomtatnoidungBanan.Enabled = true;
                            }
                        }
                    }
                }
                oND.DONID = DONID;

                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);

                oND.QUANHEPHAPLUATID = null;
                oND.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                //renameTenvuviec(txtQuanhephapluat.Text, DONID);

                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.ISVKSTHAMGIA = Convert.ToDecimal(rdbVKSThamgia.SelectedValue);

                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                oND.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oND.NGUOIKY = txtNguoiKy.Text;
                oND.NOIDUNG = txtTomtatnoidungBanan.Text;

                oND.APDUNGANLE = ddlCBBA_Anle.SelectedValue == "0" ? 0 : 1;
                oND.SOANLE = ddlCBBA_Anle.SelectedValue;

                oND.ISVKSTHAMGIA = rdbVKSThamgia.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbVKSThamgia.SelectedValue);

                //oND.ISCONGBOBA = rdCongboBA.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongboBA.SelectedValue);
                oND.TK_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                oND.TK_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                oND.TK_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);
                oND.TK_SOQDTRAIPLBIHUY = (String.IsNullOrEmpty(txtSoQDTraiPL.Text + "")) ? 0 : Convert.ToDecimal(txtSoQDTraiPL.Text);
                try
                {
                    if (hddFilePath.Value != "")
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        QT_FILE_BL fileHelper = new QT_FILE_BL();
                        QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG), "BANANSOTHAM");
                        if (qtFile == null)
                        {
                            lstErr.Text = "Lỗi khi lưu file!";
                            return;
                        }
                        #region Lưu file
                        //byte[] buff = null;
                        //using (FileStream fs = File.OpenRead(strFilePath))
                        //{
                        //BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        //long numBytes = oF.Length;
                        //buff = br.ReadBytes((int)numBytes);
                        oTF.DONID = DONID;
                        //oTF.NOIDUNG = buff;
                        oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                        oTF.KIEUFILE = oF.Extension;
                        oTF.NGAYTAO = DateTime.Now;
                        oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oTF.QT_FILE_ID = qtFile.ID;
                        dt.ALD_SOTHAM_BANAN_FILE.Add(oTF);
                        dt.SaveChanges();
                        //}
                        #endregion
                        //File.Delete(strFilePath);
                    }
                }
                catch (Exception ex)
                {
                    lstErr.Text = ex.Message;
                    return;
                }
                if (rdVuAnQuaHan.SelectedValue == "1")
                    pnNguyenNhanQuaHan.Visible = true;
                else
                    pnNguyenNhanQuaHan.Visible = false;
                if (lst.Count == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ALD_SOTHAM_BANAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                ALD_DON oDon = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if(oND.NGAYHIEULUC != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
                    temp_congbo.CAPXETXU = 2;
                    temp_congbo.ISBA = 1;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYHIEULUC;
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

                /* 25.04.2025 Gọi hàm UploadFileID, lưu vào bảng AHN_FILE là có Bản án
                 * File bản án nếu đính kèm sẽ lưu vào bảng AHN_SOTHAM_BANAN_FILE
                 * (Bản án chỉ có 1 nên không cần tạo trường FILEID như Quyết định
                 * 2022 Đã bỏ hoàn toàn và k tống đạt Bản án 
                 * Trước đó bắt buộc có file đính kèm mới được Tống đạt */
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
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, NgayBA.Year, 1);
                else
                {
                    Decimal? a = null;
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(a), 1);
                }

                //UploadFileID(oDon, FileID, "52-DS", STTQD);

                //TamNgungDONKK_USER_DKNHANVB(DONID);
                //---------29/11/2025----  vnpt chỉnh lấy thêm cột FILEID
                var rFileID = UploadFileID(oDon, FileID, "52-DS", STTQD);
                if (rFileID > 0)
                {
                    oND.FILEID = rFileID;
                    dt.SaveChanges();
                }
                TamNgungDONKK_USER_DKNHANVB(DONID);
                ResetControl_Banan();
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
            //if (AsyncFileUpLoad.HasFile && dgFile.Items.Count < 1)
            //{
            //    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
            //    if (extension == ".doc")
            //    {
            //        string strFileName = AsyncFileUpLoad.FileName;
            //        string path = Server.MapPath("~/TempUpload/") + strFileName;
            //        AsyncFileUpLoad.SaveAs(path);
            //        path = path.Replace("\\", "/");
            //        decimal DONID = Convert.ToDecimal(hddDonID.Value);
            //        ALD_SOTHAM_BANAN_FILE oTF = new ALD_SOTHAM_BANAN_FILE();
            //        // Lưu hồ sơ bản án
            //        string strFilePath = "";
            //        //if (chkKySo.Checked)
            //        //{
            //        string[] arr = path.Split('/');
            //        strFilePath = arr[arr.Length - 1];
            //        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
            //        //}
            //        //else
            //        //string strFilePath = path.Replace("/", "\\");
            //        byte[] buff = null;
            //        using (FileStream fs = File.OpenRead(strFilePath))
            //        {
            //            BinaryReader br = new BinaryReader(fs);
            //            FileInfo oF = new FileInfo(strFilePath);
            //            long numBytes = oF.Length;
            //            buff = br.ReadBytes((int)numBytes);
            //            oTF.DONID = DONID;
            //            oTF.NOIDUNG = buff;
            //            oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
            //            oTF.KIEUFILE = oF.Extension;
            //            oTF.NGAYTAO = DateTime.Now;
            //            oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            //            dt.ALD_SOTHAM_BANAN_FILE.Add(oTF);
            //            dt.SaveChanges();
            //        }
            //        // Dùng cho tống đạt văn bản
            //        if (strFilePath.ToLower().Contains("52-ds"))
            //        {
            //            ALD_DON don = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //            if (don != null)
            //            {
            //                UploadFileID(don, "52-DS", oTF);
            //            }
            //        }
            //        File.Delete(strFilePath);
            //        //path = path.Replace("\\", "/");
            //        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            //        LoadFile();
            //        lstErr.Text = "lưu thành công";
            //    }
            //    else LsbErrorExtension.Text = "Only file .doc be supported";
            //}
            try
            {
                if (AsyncFileUpLoad.HasFile && dgFile.Items.Count < 1)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoad.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoad.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lstErr.Text = "chỉ lưu file .doc";
                }
                else lstErr.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lstErr.Text = "Lỗi: " + ex.Message; }
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
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                ALD_SOTHAM_BANAN_FILE oTF = new ALD_SOTHAM_BANAN_FILE();

                byte[] buff = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);
                    oTF.DONID = DONID;
                    oTF.NOIDUNG = buff;
                    oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                    oTF.KIEUFILE = oF.Extension;
                    oTF.NGAYTAO = DateTime.Now;
                    oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.ALD_SOTHAM_BANAN_FILE.Add(oTF);
                    dt.SaveChanges();
                }
                //xoa file
                File.Delete(file_path);
            }
        }
        protected void dgFile_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal DONID = Convert.ToDecimal(hddDonID.Value);
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lstErr.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstErr.Text = Result;
                        return;
                    }
                    ALD_SOTHAM_BANAN_FILE oT = dt.ALD_SOTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oT.NOIDUNG == null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oT.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_LAODONG + ".";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                    ALD_FILE oDsF = dt.ALD_FILE.Where(x => x.DONID == oT.DONID && x.TENFILE == oT.TENFILE).FirstOrDefault();
                    if (oDsF != null)
                    {
                        dt.ALD_FILE.Remove(oDsF);
                        dt.SaveChanges();
                    }
                    dt.ALD_SOTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    var oND = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID).FirstOrDefault();
                    if (oND.NOIDUNGFILE != null)
                    {
                        if (oND.NOIDUNGFILE.Length != 0 && oND.QT_FILE_ID == null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                    }
                    else
                    {
                        QT_FILE qT_FILE = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                        // Xây dựng path cho file
                        string _pathStore = QT_FILE_BL.ToPathFolderStore(qT_FILE.DATE_CREATED.Value, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)) + "\\BANANSOTHAM";
                        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(qT_FILE.FILE_NAME);
                        string pathRaw = Path.Combine(_pathStore,
                            Cls_Comon.ChuyenTVKhongDau(fileNameWithoutExtension) +
                            qT_FILE.ID +
                            qT_FILE.FILE_TYPE);
                        var pathUrlStyle = pathRaw.Replace("\\", "/");
                        var encodedPath = HttpUtility.UrlEncode(pathUrlStyle);

                        // Đảm bảo HTTPS
                        var authority = Request.Url.GetLeftPart(UriPartial.Authority).Replace("http://", "https://");
                        var appPath = Request.ApplicationPath?.TrimEnd('/') ?? "";
                        string downloadUrl = $"{authority}{appPath}/Quantri/Cauhinh/FileDownload.ashx?p={HttpUtility.UrlEncode(encodedPath)}";

                        // JavaScript redirect
                        string script = $@"window.location.href = '{downloadUrl}';";

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "downloadScript", script, true);
                    }
                    break;
            }

        }
        protected void cmdLuatUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlDieukhoan.Items.Count == 0)
                {
                    lstMsgDieuluat.Text = "Bạn chưa chọn điều khoản !";
                    return;
                }
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                decimal DIEUID = Convert.ToDecimal(ddlDieukhoan.SelectedValue);
                if (dt.ALD_SOTHAM_BANAN_DIEULUAT.Where(x => x.DONID == DONID && x.DIEULUATID == DIEUID).ToList().Count > 0)
                {
                    lstMsgDieuluat.Text = "Đã tồn tại điều luật này trong danh sách !";
                    return;
                }

                ALD_SOTHAM_BANAN_DIEULUAT oT = new ALD_SOTHAM_BANAN_DIEULUAT();
                oT.DONID = DONID;
                oT.DIEULUATID = DIEUID;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.ALD_SOTHAM_BANAN_DIEULUAT.Add(oT);
                dt.SaveChanges();
                LoadDieuLuat();
                lstMsgDieuluat.Text = "Lưu thành công!";

            }
            catch (Exception ex)
            {
                lstMsgDieuluat.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void ddlBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDieuKhoan();
        }
        protected void dgDieuLuat_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lstErr.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstErr.Text = Result;
                        return;
                    }
                    ALD_SOTHAM_BANAN_DIEULUAT oT = dt.ALD_SOTHAM_BANAN_DIEULUAT.Where(x => x.ID == ND_id).FirstOrDefault();
                    dt.ALD_SOTHAM_BANAN_DIEULUAT.Remove(oT);
                    dt.SaveChanges();
                    LoadDieuLuat();
                    break;
            }

        }
        protected void cmdAnphi_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgAnPhi.Items.Count > 0)
                {
                    foreach (DataGridItem oItem in dgAnPhi.Items)
                    {
                        TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgaynhanbanan");
                        if (txtNgaynhanbanan.Text != "")
                        {
                            DateTime NgayNhanBA;
                            if (DateTime.TryParse(txtNgaynhanbanan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanBA))
                            {
                                if (DateTime.Compare(NgayNhanBA, DateTime.Now) > 0)
                                {
                                    lstMsgAnphi.Text = "Ngày nhận bản án không được lớn hơn ngày hiện tại.";
                                    txtNgaynhanbanan.Focus();
                                    return;
                                }
                            }
                            else
                            {
                                lstMsgAnphi.Text = "Ngày nhận bản án không đúng kiểu ngày / tháng / năm.";
                                txtNgaynhanbanan.Focus();
                                return;
                            }
                        }
                    }
                }
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                foreach (DataGridItem oItem in dgAnPhi.Items)
                {
                    string strID = oItem.Cells[0].Text;
                    decimal DSID = Convert.ToDecimal(strID);
                    CheckBox chkMien = (CheckBox)oItem.FindControl("chkMien");
                    TextBox txtAnphi = (TextBox)oItem.FindControl("txtAnphi");
                    CheckBox chkThamgia = (CheckBox)oItem.FindControl("chkThamgia");
                    TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgaynhanbanan");
                    List<ALD_SOTHAM_BANAN_ANPHI> lst = dt.ALD_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DONID && x.DUONGSU == DSID).ToList();
                    if (lst.Count == 0)
                    {
                        ALD_SOTHAM_BANAN_ANPHI oT = new ALD_SOTHAM_BANAN_ANPHI();
                        oT.DONID = DONID;
                        oT.DUONGSU = DSID;
                        oT.MIENANPHI = chkMien.Checked == true ? 1 : 0;
                        oT.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                        oT.ISTHAMGIA = chkThamgia.Checked == true ? 1 : 0;
                        oT.NGAYNHANAN = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.ALD_SOTHAM_BANAN_ANPHI.Add(oT);
                        dt.SaveChanges();
                    }
                    else
                    {
                        ALD_SOTHAM_BANAN_ANPHI oT = lst[0];
                        oT.DONID = DONID;
                        oT.DUONGSU = DSID;
                        oT.MIENANPHI = chkMien.Checked == true ? 1 : 0;
                        oT.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                        oT.NGAYNHANAN = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.ISTHAMGIA = chkThamgia.Checked == true ? 1 : 0;
                        oT.NGAYSUA = DateTime.Now;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }

                }
                lstMsgAnphi.Text = "Lưu thành công !";
            }
            catch (Exception ex)
            {
                lstMsgAnphi.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void chkThamgia_CheckChange(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            foreach (DataGridItem Item in dgAnPhi.Items)
            {
                CheckBox chkThamgia = (CheckBox)Item.FindControl("chkThamgia");
                TextBox txtNgaynhanbanan = (TextBox)Item.FindControl("txtNgaynhanbanan");
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {
                    if (chk.Checked)
                    {
                        txtNgaynhanbanan.Text = txtNgaytuyenan.Text;
                    }
                }
            }
        }
        protected void chkMien_CheckChange(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            foreach (DataGridItem Item in dgAnPhi.Items)
            {
                CheckBox chkMien = (CheckBox)Item.FindControl("chkMien");
                TextBox txtAnphi = (TextBox)Item.FindControl("txtAnphi");
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {
                    if (chk.Checked)
                    {
                        txtAnphi.Text = "";
                        txtAnphi.Enabled = false;
                    }
                    else
                    {
                        txtAnphi.Enabled = true;
                    }
                }
            }
        }
        protected void cmdTGTT_Click(object sender, EventArgs e)
        {
            try
            {
                if (dgTGTT.Items.Count > 0)
                {
                    foreach (DataGridItem oItem in dgTGTT.Items)
                    {
                        TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgayTGTT");
                        if (txtNgaynhanbanan.Text != "")
                        {
                            DateTime NgayNhanBA;
                            if (DateTime.TryParse(txtNgaynhanbanan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanBA))
                            {
                                if (DateTime.Compare(NgayNhanBA, DateTime.Now) > 0)
                                {
                                    lblMsgTGTT.Text = "Ngày nhận bản án không được lớn hơn ngày hiện tại.";
                                    txtNgaynhanbanan.Focus();
                                    return;
                                }
                            }
                            else
                            {
                                lblMsgTGTT.Text = "Ngày nhận bản án không đúng kiểu ngày / tháng / năm.";
                                txtNgaynhanbanan.Focus();
                                return;
                            }
                        }
                    }
                }
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                foreach (DataGridItem oItem in dgTGTT.Items)
                {
                    string strID = oItem.Cells[0].Text;
                    decimal DSID = Convert.ToDecimal(strID);
                    CheckBox chkThamgiaTGTT = (CheckBox)oItem.FindControl("chkThamgiaTGTT");
                    TextBox txtNgayTGTT = (TextBox)oItem.FindControl("txtNgayTGTT");
                    List<ALD_SOTHAM_BANAN_TGTT> lst = dt.ALD_SOTHAM_BANAN_TGTT.Where(x => x.DONID == DONID && x.THAMGIATOTUNGID == DSID).ToList();
                    if (lst.Count == 0)
                    {
                        ALD_SOTHAM_BANAN_TGTT oT = new ALD_SOTHAM_BANAN_TGTT();
                        oT.DONID = DONID;
                        oT.THAMGIATOTUNGID = DSID;
                        oT.ISTHAMGIA = chkThamgiaTGTT.Checked == true ? 1 : 0;
                        oT.NGAYNHANBANAN = (String.IsNullOrEmpty(txtNgayTGTT.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayTGTT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dt.ALD_SOTHAM_BANAN_TGTT.Add(oT);
                        dt.SaveChanges();
                    }
                    else
                    {
                        ALD_SOTHAM_BANAN_TGTT oT = lst[0];
                        oT.DONID = DONID;
                        oT.THAMGIATOTUNGID = DSID;
                        oT.ISTHAMGIA = chkThamgiaTGTT.Checked == true ? 1 : 0;
                        oT.NGAYNHANBANAN = (String.IsNullOrEmpty(txtNgayTGTT.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayTGTT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dt.ALD_SOTHAM_BANAN_TGTT.Add(oT);
                        dt.SaveChanges();
                    }
                }
                lblMsgTGTT.Text = "Lưu thành công !";
                cmdTGTT.Style.Add("margin-bottom", "0px");
            }
            catch (Exception ex)
            {
                lblMsgTGTT.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void chkThamgiaTGTT_CheckChange(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            foreach (DataGridItem Item in dgTGTT.Items)
            {
                CheckBox chkThamgiaTGTT = (CheckBox)Item.FindControl("chkThamgiaTGTT");
                TextBox txtNgayTGTT = (TextBox)Item.FindControl("txtNgayTGTT");
                if (Item.Cells[0].Text.Equals(chk.ToolTip))
                {
                    if (chk.Checked)
                    {
                        txtNgayTGTT.Text = txtNgaytuyenan.Text;
                    }
                }
            }
        }
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
                pnNguyenNhanQuaHan.Visible = true;
            else
                pnNguyenNhanQuaHan.Visible = false;
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
            // Xóa thông tin bản án
            decimal DonID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            //reset_TENVUVIEC(DonID);

            List<ALD_SOTHAM_BANAN> banans = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (banans.Count > 0)
            {
                foreach (var oND in banans)
                {
                    // khong duoc xoa khi da Tong dat - 29/11/2025 vnpt check
                    ALD_TONGDAT oTD2 = dt.ALD_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.ALD_SOTHAM_BANAN).FirstOrDefault();
                    if (oTD2 != null)
                    {
                        lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                        return;
                    }
                }
                //GTEL-HUNGQ 07-10-2025 Check neu da chia sẻ dữ liệu không được xóa
                KHOBAQD_BL ald = new KHOBAQD_BL();
                bool isExist = ald.IsExistKHOBADQ(0, DonID, 2,ENUM_LOAIVUVIEC_TEXT.AN_LAODONG);
                if (isExist)
                {
                    lbthongbao.Text = lstErr.Text = "Vụ việc đã được đồng bộ. Phải thu hồi đồng bộ trước khi chỉnh sửa/xóa";
                    return;
                }
                //END GTEL-HUNGQ check

                //Luu thong tin Bản án Sơ thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(banans);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(DonID, 5, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Sơ thẩm án Lao động", "Xóa", json) == false)
                {
                    lbthongbao.Text = lstErr.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Bản án Sơ thẩm
                dt.ALD_SOTHAM_BANAN.RemoveRange(banans);
            }
            // Xóa thông tin file đính kèm
            List<ALD_SOTHAM_BANAN_FILE> files = dt.ALD_SOTHAM_BANAN_FILE.Where(x => x.DONID == DonID).ToList();
            if (files.Count > 0)
            {
                foreach (var oND in files)
                {
                    if (oND.NOIDUNG == null && oND.QT_FILE_ID != null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_LAODONG + ".";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                }
                dt.ALD_SOTHAM_BANAN_FILE.RemoveRange(files);
            }
            // Xóa điều luật áp dụng, tội danh
            List<ALD_SOTHAM_BANAN_DIEULUAT> dieuLuats = dt.ALD_SOTHAM_BANAN_DIEULUAT.Where(x => x.DONID == DonID).ToList();
            if (dieuLuats.Count > 0)
            {
                dt.ALD_SOTHAM_BANAN_DIEULUAT.RemoveRange(dieuLuats);
            }
            // Xóa thông tin án phí
            List<ALD_SOTHAM_BANAN_ANPHI> anPhis = dt.ALD_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID).ToList();
            if (anPhis.Count > 0)
            {
                dt.ALD_SOTHAM_BANAN_ANPHI.RemoveRange(anPhis);
            }
            // Xóa thông tin người tham gia tố tụng
            List<ALD_SOTHAM_BANAN_TGTT> tGTTs = dt.ALD_SOTHAM_BANAN_TGTT.Where(x => x.DONID == DonID).ToList();
            if (tGTTs.Count > 0)
            {
                dt.ALD_SOTHAM_BANAN_TGTT.RemoveRange(tGTTs);
            }
            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "52-DS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            ALD_FILE file = dt.ALD_FILE.Where(x => x.DONID == DonID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).FirstOrDefault();
            if (file != null)
            {
                dt.ALD_FILE.Remove(file);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DonID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
                                                                    $"  AND CAPXETXU = {2} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            LoadBanAnInfo(DonID);
            SetTrangThaibanDauDONKK_USER_DKNHANVB(DonID);
            dt.SaveChanges();
            ResetControl_Banan();
            lstErr.Text = "Xóa bản án thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        protected void cmdXoaAnphi_Click(object sender, EventArgs e)
        {
            try
            {
                // Xóa thông tin án phí
                decimal DonID = Convert.ToDecimal(hddDonID.Value);
                List<ALD_SOTHAM_BANAN_ANPHI> anPhis = dt.ALD_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID).ToList();
                if (anPhis.Count > 0)
                {
                    dt.ALD_SOTHAM_BANAN_ANPHI.RemoveRange(anPhis);
                }
                dt.SaveChanges();
                lstMsgAnphi.Text = "Xóa thành công !";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch
            {
                lstMsgAnphi.Text = "Lỗi: Xóa không thành công !";
            }
        }
        protected void cmdXoaTGTT_Click(object sender, EventArgs e)
        {
            try
            {
                // Xóa thông tin người tham gia tố tụng
                decimal DonID = Convert.ToDecimal(hddDonID.Value);
                List<ALD_SOTHAM_BANAN_TGTT> tGTTs = dt.ALD_SOTHAM_BANAN_TGTT.Where(x => x.DONID == DonID).ToList();
                if (tGTTs.Count > 0)
                {
                    dt.ALD_SOTHAM_BANAN_TGTT.RemoveRange(tGTTs);
                }
                dt.SaveChanges();
                lblMsgTGTT.Text = "Xóa thành công !";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch
            {
                lblMsgTGTT.Text = "Lỗi: Xóa không thành công !";
            }
        }
        private void ResetControl_Banan()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            LoadBanAnInfo(DonID);
            txtQuanhephapluat.Text = getQHPL_NAME_THULY();
            ddlQuanhephapluat.SelectedIndex = 0;
            //ddlQHPLTK.SelectedIndex = 0;
            txtSobanan.Text = "";
            lbthongbaoA.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            ddlCBBA_Anle.SelectedValue = "0";
            //rdCongboBA.ClearSelection();
            rdbVKSThamgia.ClearSelection();
            ddlYeutonuocngoai.SelectedIndex = 0;
            txtSoQDTraiPL.Text = "";
            ddlQuyetdinh.Enabled = false;

            //txtNguoiKy.Text = "";
            rdVuAnQuaHan.ClearSelection();
            rdNNChuQuan.ClearSelection();
            rdNNKhachQuan.ClearSelection();
            LoadFile();
            if (ddlBoLuat.Items.Count > 0)
                ddlBoLuat.SelectedIndex = 0;
            if (ddlDieukhoan.Items.Count > 0)
                ddlDieukhoan.SelectedIndex = 0;
            LoadDieuLuat();
            LoadAnPhi();
            LoadTGTT();
        }
        private void UploadFileID(ALD_DON oDon, string strMaBieumau, ALD_SOTHAM_BANAN_FILE fileDinhKem)
        {
            ALD_DON_BL oBL = new ALD_DON_BL();
            decimal IDBM = 0;
            string strTenBM = "";
            bool isNew = false;
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            ALD_FILE objFile = dt.ALD_FILE.Where(x => x.DONID == oDon.ID && x.TOAANID == oDon.TOAANID && x.MAGIAIDOAN == oDon.MAGIAIDOAN && x.BIEUMAUID == IDBM).FirstOrDefault();
            if (objFile == null)
            {
                isNew = true;
                objFile = new ALD_FILE();
            }
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
            objFile.LOAIFILE = 1;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
            objFile.NOIDUNG = fileDinhKem.NOIDUNG;
            objFile.TENFILE = fileDinhKem.TENFILE;
            objFile.KIEUFILE = fileDinhKem.KIEUFILE;
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objFile.STT = 1;

            // quyennd
            if (objFile.TOA_GIAIQUYET_ID == null)
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            if (isNew)
                dt.ALD_FILE.Add(objFile);
            dt.SaveChanges();
        }
        private string getQHPL_NAME_THULY()
        {
            decimal ID = Session[ENUM_LOAIAN.AN_LAODONG] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
            ALD_SOTHAM_THULY oT = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == ID).FirstOrDefault();
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