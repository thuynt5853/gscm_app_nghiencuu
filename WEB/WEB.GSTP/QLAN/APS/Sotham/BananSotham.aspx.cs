using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.QUANTRI;
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

namespace WEB.GSTP.QLAN.APS.Sotham
{
    public partial class BananSotham : System.Web.UI.Page
    {
        DKKContextContainer dkk = new DKKContextContainer();
        GSTPContext dt = new GSTPContext();
        private static CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal DSID = 0;
        private const decimal BANAN = 1, QUYETDINH = 2;
        public decimal VuAnID = 0;
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
            try
            {
                if (!IsPostBack)
                {
                    DSID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_PHASAN] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                    LoadCombobox();
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    hddDonID.Value = Session[ENUM_LOAIAN.AN_PHASAN] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    decimal DONID = Convert.ToDecimal(hddDonID.Value);
                    CheckQuyen(DONID);
                    LoadNguoiKyInfo();
                    LoadBanAnInfo(DONID);
                    LoadAnPhi();
                    APS_DON_THAMPHAN TpGQDon = dt.APS_DON_THAMPHAN.Where(x => x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.DONID == DONID).OrderByDescending(x => x.NGAYNHANPHANCONG).FirstOrDefault();
                    if (TpGQDon != null)
                    {
                        hddNgayPCTPGQD.Value = TpGQDon.NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)TpGQDon.NGAYNHANPHANCONG).ToString("dd/MM/yyyy");
                    }
                    GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
                    txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();
                    LoadGrid();
                    CheckCongbo(DONID);
                }
                LoadFile();
            }
            catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        void SetNewSoQD()
        {
            DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            APS_SOTHAM_BL oSTBL = new APS_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            //txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "ADS", ngay, LoaiQD).ToString();
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN} AND CAPXETXU = 2 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);
                Cls_Comon.SetButton(btnUpdate, false);
                lbthongbaoA.Text = lbthongbaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdAnphi, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdHuyQuyetDinh, oPer.CAPNHAT);
            APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
            #region  Có quyết định ẩn bản án - HIEUVM

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN, ID);
            if (oDT.Rows.Count > 0)
            {
                pnQDVV.Visible = true;
                pnBAST.Visible = false;
                rdbPanelQD.Enabled = false;
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
            }
            else
            {
                rdbPanelQD.Enabled = true;
            }

            //Kiểm tra xem đã thụ lý chưa
            List<APS_SOTHAM_THULY> lstCount = dt.APS_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                return;
            }

            //Kiểm tra đã phân công thẩm phán chưa
            List<APS_DON_THAMPHAN> lstTPGQ = dt.APS_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").ToList();
            if (lstTPGQ.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin hội đồng xét xử !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                return;
            }

            //Kiểm tra đã phân công thẩm phán chủ tọa
            List<APS_SOTHAM_HDXX> lstTPCT = dt.APS_SOTHAM_HDXX.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
            if (lstTPCT.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin hội đồng xét xử !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                return;
            }

            //Kiểm tra xem đã có quyết định đưa vụ việc ra xét xử hay không
            decimal IDLQD = 0;
            DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "MTTPS").FirstOrDefault();
            if (oLQD != null) IDLQD = oLQD.ID;

            List<APS_SOTHAM_QUYETDINH> lstQDXX = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == IDLQD).ToList();
            List<APS_SOTHAM_QUYETDINH> lstQDXX2 = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.QUYETDINHID == 124).ToList();
            if (lstQDXX.Count == 0 && lstQDXX2.Count == 0)
            {
                lstErr.Text = "Chưa cập nhật quyết định mở thủ tục phá sản !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);
            }

            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue != "0")
            {
                Cls_Comon.SetButton(btnUpdate, true);
                hddShowCommand.Value = "True";
            }

            //ADS_SOTHAM_BANAN_ANPHI anphi = dt.ADS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == ID).FirstOrDefault();
            //if (anphi != null)
            //{
            //    Cls_Comon.SetButton(cmdUpdate, false);
            //    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
            //}

            #endregion
            #region anhnt check đã kc/kn bản án/qđ
            APS_SOTHAM_BANAN banAn = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == ID).FirstOrDefault();
            if (banAn != null)
            {
                APS_SOTHAM_KHANGCAO ckc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.LOAIKHANGCAO == 0 && x.SOQDBA == banAn.ID).FirstOrDefault();
                if (ckc != null)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc có đề nghị/kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                APS_SOTHAM_KHANGNGHI ckn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.LOAIKN == 0 && x.BANANID == banAn.ID).FirstOrDefault();
                if (ckn != null)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc có đề nghị/kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }

            }

            List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISPHASAN == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
            List<APS_SOTHAM_QUYETDINH> qdKetThuc = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).ToList();
            if (qdKetThuc != null)
            {
                foreach (var qd in qdKetThuc)
                {
                    APS_SOTHAM_KHANGCAO ckc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && (x.LOAIKHANGCAO == 1 || x.LOAIKHANGCAO == 2) && x.SOQDBA == qd.ID).FirstOrDefault();
                    if (ckc != null)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã đề nghị quyết định. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdAnphi, false);
                        Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                        Cls_Comon.SetButton(cmdXoaAnphi, false);

                        Cls_Comon.SetButton(btnUpdate, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                    APS_SOTHAM_KHANGNGHI ckn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && (x.LOAIKN == 1 || x.LOAIKN == 2) && x.BANANID == qd.ID).FirstOrDefault();
                    if (ckn != null)
                    {
                        lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã kháng nghị quyết định. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdAnphi, false);
                        Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                        Cls_Comon.SetButton(cmdXoaAnphi, false);

                        Cls_Comon.SetButton(btnUpdate, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
            }
            #endregion anhnt check đã kc/kn bản án/qđ
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                return;
            }

            APS_SOTHAM_KHANGCAO kc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            APS_SOTHAM_KHANGNGHI kn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có đề nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                APS_SOTHAM_KHANGCAO kc2 = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 2).FirstOrDefault();
                if (kc2 != null)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có đề nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                APS_SOTHAM_KHANGNGHI kn2 = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET != 3).FirstOrDefault();
                if (kn2 != null)
                {
                    lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdAnphi, false);
                    Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                    Cls_Comon.SetButton(cmdXoaAnphi, false);

                    Cls_Comon.SetButton(btnUpdate, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstErr.Text = lbthongbaoQD.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdAnphi, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
                Cls_Comon.SetButton(cmdXoaAnphi, false);

                Cls_Comon.SetButton(btnUpdate, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        void CheckQuyenBAST(decimal ID)
        {
            APS_SOTHAM_BANAN_ANPHI anphi = dt.APS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == ID).FirstOrDefault();
            if (anphi != null)
            {
                lstErr.Text = "Vụ việc đã có án phí không được xóa";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, false);
            }
            else
            {
                Cls_Comon.SetButton(cmdUpdate, true);
                Cls_Comon.SetButton(cmdHuyQuyetDinh, true);
            }

        }
        #region thông tin quyết định - HIEUVM
        //thông tin quyết định
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN, ID);

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
            List<APS_DON_DUONGSU> lstDS = dt.APS_DON_DUONGSU.Where(x => x.DONID == DonID).OrderBy(x => x.TENDUONGSU).ToList<APS_DON_DUONGSU>();
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
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_SOTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;
            //LoadLydo();

            //Load ẩn hiện QHPL         
            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
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

        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            APS_SOTHAM_HDXX oND = dt.APS_SOTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<APS_SOTHAM_HDXX>();
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
                APS_DON_THAMPHAN oTP = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
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
            //rdCongBoQD.ClearSelection();
            ddlLoaiQD.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            LoadDuongSuYC();
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieuLucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            hddDonID.Value = "0";
            //lbtDownload.Visible = false;
            //SetNewSoQD(DateTime.Now.Year);
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Decimal ID = Convert.ToDecimal(hddDonID.Value);
            List<APS_SOTHAM_QUYETDINH> lstQD = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.QUYETDINHID == 70 || x.QUYETDINHID == 425 || x.LOAIQDID == 3)).ToList();
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
            Decimal DONID = Convert.ToDecimal(hddDonID.Value);
            APS_SOTHAM_QUYETDINH oND = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            //if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            //{
            //    lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
            //    return;
            //}
            if (oND != null)
            {
                if (oND.NOIDUNG == null && oND.QT_FILE_ID != null)
                {
                    QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                    if (qtFileDelete != null)
                    {
                        qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_PHASAN + ".";
                        QT_FILE_BL fileH = new QT_FILE_BL();
                        fileH.DeleteFileLogic(qtFileDelete);
                    }
                }
                decimal FileID = 0;
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

                dt.APS_SOTHAM_QUYETDINH.Remove(oND);

                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DONID} " +
                                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
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
                SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
                dt.SaveChanges();
                if (FileID > 0)
                {
                    try
                    {
                        APS_FILE objf = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                        dt.APS_FILE.Remove(objf);
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
        void check_AnKCKN(Decimal ID)
        {

            APS_SOTHAM_KHANGCAO kc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            APS_SOTHAM_KHANGNGHI kn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có đề nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                APS_SOTHAM_KHANGCAO kc2 = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID).FirstOrDefault();
                if (kc2 != null)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có đề nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                {

                    lttMsgQuyetDinh.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                APS_SOTHAM_KHANGNGHI kn2 = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID).FirstOrDefault();
                if (kn2 != null)
                {

                    lttMsgQuyetDinh.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;

                }
            }

        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");

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
                check_AnKCKN(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");

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
                check_AnKCKN(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                if (!CheckValidQDVV() || !CheckCongbo(DONID)) return;

                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;

                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }
                APS_SOTHAM_QUYETDINH oND;
                decimal STTQD = 0;
                if ((hddID.Value == "" || hddID.Value == "0"))
                {
                    oND = new APS_SOTHAM_QUYETDINH();
                    APS_DON_BL oBL = new APS_DON_BL();

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
                    oND = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
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
                        QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN), "BANANSOTHAM");
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

                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;
                oND.NOIDUNG = txtTomtatnoidungQuyetdinh.Text;

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
                    dt.APS_SOTHAM_QUYETDINH.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                if (oQDT.ISCONGBO == 1 && oND.HIEULUCTU != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
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
                ResetControls();
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
        private decimal UploadFileID(APS_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            APS_DON_BL oBL = new APS_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            APS_FILE objFile = new APS_FILE();
            if (FileID > 0)
                objFile = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
            if (STT != 0) objFile.STT = Convert.ToDecimal(STT);
            if (FileID == 0)
                dt.APS_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private decimal UploadFileIDQD(APS_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            APS_DON_BL oBL = new APS_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            APS_FILE objFile = new APS_FILE();
            if (FileID > 0)
                objFile = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
            if (STT != 0) objFile.STT = Convert.ToDecimal(STT);
            if (FileID == 0)
                dt.APS_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
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
            APS_SOTHAM_QUYETDINH oND = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
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
                    ddlQuyetdinh.Enabled = true;
                    pnCBQD.Visible = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else pnCBQD.Visible = false;
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
                pnCBQD.Visible = false;

            }

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
            var twords = Regex.Matches(txtTomtatnoidungQuyetdinh.Text, @"\w+");
            decimal words = twords.Count;
            wordCountdownQuyetdinh.InnerText = "Số từ còn lại: " + (200 - words).ToString();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.FILEID == ND_id).FirstOrDefault();
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
                        string _pathStore = QT_FILE_BL.ToPathFolderStore(qT_FILE.DATE_CREATED.Value, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)) + "\\BANANSOTHAM";
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
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
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

                APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                APS_SOTHAM_KHANGCAO oTKC = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == DONID).FirstOrDefault();
                APS_SOTHAM_KHANGNGHI oTKN = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == DONID).FirstOrDefault();
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
            }
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            //decimal IDD = Convert.ToDecimal(hddDonID.Value);
            //CheckQuyen(IDD);
            //APS_SOTHAM_QUYETDINH QDST = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == IDD && x.LOAIQDID == 2 && x.LOAIQDID == 61/*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
            //if (QDST == null)
            //{
            //    lbthongbaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
            //    Cls_Comon.SetButton(btnUpdate, false);
            //    return;
            //}
            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                ddlLoaiQD.SelectedValue = oT.LOAIID + "";
                ////Load ẩn hiện QHPL
                //decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                //DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
                //if (oQD != null)
                //{
                //    //HIEUVM CBQD
                //    if (/*oQD.MA == "TDC"*/ oT.LOAIID == 10 || oT.LOAIID == 11 || oT.LOAIID == 3)
                //    {
                //        Cls_Comon.SetButton(btnUpdate, true);
                //        pnCBQD.Visible = true;
                //    }
                //    else pnCBQD.Visible = false;
                //    if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                //    {
                //        pnQHPL.Visible = true;
                //    }
                //    else pnQHPL.Visible = false;

                //}
                //else
                //{
                //    pnQHPL.Visible = false;
                //    pnDuongSuYC.Visible = false;
                //    pnCBQD.Visible = false;
                //}

            }
            //LoadLydo();
            //if (pnQHPL.Visible && pnLyDo.Visible)
            //{
            //    Cls_Comon.SetFocus(this, this.GetType(), ddlLydo.ClientID);
            //}
            //else if (!pnQHPL.Visible && pnLyDo.Visible)
            //{
            //    Cls_Comon.SetFocus(this, this.GetType(), ddlLydo.ClientID);
            //}
            //else
            //{
            //    Cls_Comon.SetFocus(this, this.GetType(), txtSoQD.ClientID);
            //}
        }
        protected void ddlNguoiYC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value),
                NguoiYC = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
            List<APS_DON_DUONGSU> lstDS = dt.APS_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID != NguoiYC).OrderBy(x => x.TENDUONGSU).ToList<APS_DON_DUONGSU>();
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
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            APS_SOTHAM_BL oBL = new APS_SOTHAM_BL();
            DataTable dtAnPhi = oBL.APS_SOTHAM_BANAN_ANPHI_GET(DONID);
            if (dtAnPhi != null && dtAnPhi.Rows.Count > 0)
            {
                hddTGTTRowLastIndex.Value = dtAnPhi.Rows.Count + "";
            }
            dgAnPhi.DataSource = dtAnPhi;
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
        protected void dgAnPhi_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                TextBox txtNgaynhanbanan = (TextBox)e.Item.FindControl("txtNgaynhanbanan");
                if (hddTGTTRowLastIndex.Value == (dgAnPhi.Items.Count + 1) + "")
                {
                    txtNgaynhanbanan.Attributes.Add("onfocus", "myFunctionFocus();");
                }
            }
        }
        private void LoadFile()
        {
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            dgFile.DataSource = dt.APS_SOTHAM_BANAN_FILE.Where(x => x.DONID == ID).ToList();
            dgFile.DataBind();
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                APS_FILE oND = dt.APS_FILE.Where(x => x.DONID == DONID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.URL, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadBanAnInfo(decimal DonID)
        {
            List<APS_SOTHAM_BANAN> lst = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (lst.Count > 0)
            {
                // Chọn sẵn giá trị "1" (Bản án)
                rdbPanelBA.SelectedValue = "1";

                // Khóa không cho người dùng thay đổi
                rdbPanelBA.Enabled = false;
                rdbPanelQD.Enabled = false;

                /*pnZonekythuong.Visible = */
                pnDgFile.Visible = true;
                APS_SOTHAM_BANAN oT = lst[0];
                hddBanAnID.Value = oT.ID.ToString();
                txtSobanan.Text = oT.SOBANAN;
                ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();

                ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
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

                ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
                rdVuAnQuaHan.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISQUAHAN + "")) ? "0" : oT.TK_ISQUAHAN.ToString();
                rdNNChuQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_CHUQUAN + "")) ? "0" : oT.TK_QUAHAN_CHUQUAN.ToString();
                rdNNKhachQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_KHACHQUAN + "")) ? "0" : oT.TK_QUAHAN_KHACHQUAN.ToString();
                rdCongboBA.SelectedValue = (string.IsNullOrEmpty(oT.ISCONGBOBA + "")) ? "0" : oT.ISCONGBOBA.ToString();
                txtTKCamDNNN.Text = oT.TK_SONGUOIBICAM_DNNN + "" == "" ? "" : ((decimal)oT.TK_SONGUOIBICAM_DNNN).ToString("#,0.###", cul);
                txtTKCamHTX.Text = oT.TK_SONGUOIBICAM_HTX + "" == "" ? "" : ((decimal)oT.TK_SONGUOIBICAM_HTX).ToString("#,0.###", cul);

                txtTKTongtaisan.Text = oT.TK_TONGGIATRINGHIAVUTAISAN + "" == "" ? "" : ((decimal)oT.TK_TONGGIATRINGHIAVUTAISAN).ToString("#,0.###", cul);
                txtTKTHuhoi.Text = oT.TK_TONGGIATRITHUHOI + "" == "" ? "" : ((decimal)oT.TK_TONGGIATRITHUHOI).ToString("#,0.###", cul); ;

                rdbIsNiemyet.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISDOANHNGHIEPNIEMYET + "")) ? "0" : oT.TK_ISDOANHNGHIEPNIEMYET.ToString();
                rdbIsDNMoi3nam.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISDOANHNGHIEP3NAM + "")) ? "0" : oT.TK_ISDOANHNGHIEP3NAM.ToString();
                rdbIsQDDCTT.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISDINHCHITHUTUCPHKD + "")) ? "0" : oT.TK_ISDINHCHITHUTUCPHKD.ToString();

                if (oT.TK_ISRUTGON == 1)
                    rdbTBPS.SelectedValue = "0";

                if (oT.TK_ISHNCN_KHONGTHANH == 1)
                    rdbTBPS.SelectedValue = "1";

                if (oT.TK_ISTHEONQHNCN == 1)
                    rdbTBPS.SelectedValue = "2";
                if (oT.TK_ISKHONGXAYDUNGPAPHKD == 1)
                    rdbTBPS.SelectedValue = "3";
                if (oT.TK_ISKHONGTHONGQUA == 1)
                    rdbTBPS.SelectedValue = "4";
                if (oT.TK_ISKHONGTHUCHIEN == 1)
                    rdbTBPS.SelectedValue = "5";
                if (oT.TK_ISTOCHUCTINDUNG == 1)
                    rdbTBPS.SelectedValue = "6";
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
                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (oDon != null)
                {
                    ddlLoaiQuanhe.SelectedValue = oDon.LOAIQUANHE.ToString();
                    ddlQuanhephapluat.SelectedValue = oDon.QUANHEPHAPLUATID.ToString();
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

            if (pnCBQD.Visible)
            {
                if (rdCongBoQD.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                    rdCongBoQD.Focus();
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
                if (pntxtLydo.Visible)
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
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "APS", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "APS", ngay, LoaiQD).ToString();
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
            decimal DONID = Convert.ToDecimal(hddDonID.Value);
            decimal ID = Convert.ToDecimal(hddID.Value);
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN, DONID);
            if (oDT.Rows.Count > 0 && oDT.Rows[0]["ID"].ToString() != ID.ToString())
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Vụ án đã có quyết định. Hãy kiểm tra lại! " + "')", true);
                lbthongbaoQD.Text = "Lỗi: Vụ án đã có quyết định. Hãy kiểm tra lại.!";
                return false;
            }
            return true;
        }
        private bool CheckValid()
        {

            //if (ddlQuanhephapluat.Items.Count == 0)
            //{
            //    lstErr.Text = "Chưa chọn quan hệ pháp luật !";
            //    return false;
            //}
            if (txtNguoiKy.Text == null || txtNguoiKy.Text == "")
            {
                lstErr.Text = "Chưa nhập người ký.";
                txtNguoiKy.Focus();
                return false;
            }
            if (txtSobanan.Text == "")
            {
                lstErr.Text = "Bạn chưa nhập số quyết định !";
                txtSobanan.Focus();
                return false;
            }
            DateTime NgayTPGQD = DateTime.MinValue, NgayMoPhienHop = DateTime.MinValue;
            if (hddNgayPCTPGQD.Value != "")
            {
                NgayTPGQD = DateTime.Parse(hddNgayPCTPGQD.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            }
            if (txtNgaymophientoa.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtNgaymophientoa.Text) == false)
                {
                    lstErr.Text = "Bạn phải nhập ngày mở phiên họp theo mẫu như sau: ngày/tháng/năm !";
                    txtNgaymophientoa.Focus();
                    return false;
                }
                NgayMoPhienHop = DateTime.Parse(txtNgaymophientoa.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayMoPhienHop > DateTime.Now)
                {
                    lstErr.Text = "Ngày mở phiên họp không được lớn hơn ngày hiện tại !";
                    txtNgaymophientoa.Focus();
                    return false;
                }
                if (NgayTPGQD != DateTime.MinValue && NgayMoPhienHop < NgayTPGQD)
                {
                    lstErr.Text = "Ngày mở phiên họp không được nhỏ hơn ngày phân công thẩm phán giải quyết đơn " + hddNgayPCTPGQD.Value + ".";
                    txtNgaymophientoa.Focus();
                    return false;
                }
            }
            if (Cls_Comon.IsValidDate(txtNgaytuyenan.Text) == false)
            {
                lstErr.Text = "Bạn phải nhập ngày quyết định theo mẫu như sau: ngày/tháng/năm !";
                txtNgaytuyenan.Focus();
                return false;
            }

            DateTime dNgayQD = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayQD > DateTime.Now)
            {
                lstErr.Text = "Ngày quyết định không được lớn hơn ngày hiện tại !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (NgayTPGQD != DateTime.MinValue && dNgayQD < NgayTPGQD)
            {
                lstErr.Text = "Ngày quyết định không được nhỏ hơn ngày phân công thẩm phán giải quyết đơn " + hddNgayPCTPGQD.Value + ".";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (NgayMoPhienHop != DateTime.MinValue && dNgayQD < NgayMoPhienHop)
            {
                lstErr.Text = "Ngày quyết định không được nhỏ hơn ngày mở phiên họp !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (txtNgayhieuluc.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtNgayhieuluc.Text) == false)
                {
                    lstErr.Text = "Bạn phải nhập ngày hiệu lực theo mẫu như sau: ngày/tháng/năm !";
                    txtNgayhieuluc.Focus();
                    return false;
                }
                DateTime NgayHieuLuc = DateTime.Parse(txtNgayhieuluc.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayHieuLuc < dNgayQD)
                {
                    lstErr.Text = "Ngày hiệu lực không được nhỏ hơn ngày quyết định !";
                    txtNgayhieuluc.Focus();
                    return false;
                }
            }
            if (rdbTBPS.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn Quyết định tuyên bố phá sản?";
                return false;
            }
            if (rdCongboBA.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn \"Có công bố quyết định ?\"";
                return false;
            }
            if (rdbIsQDDCTT.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn Quyết định đình chỉ thủ tục phục hồi HĐKD do đã thực hiện xong phương án phục hồi HĐKD?";
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn vụ án quá hạn luật định?";
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                if (rdNNChuQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn nguyên nhân chủ quan?";
                    return false;
                }
                if (rdNNKhachQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn nguyên nhân khách quan?";
                    return false;
                }
            }
            if (rdbIsNiemyet.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn doanh nghiệp đã niêm yết trên sàn giao dịch chứng khoán?";
                return false;
            }
            if (rdbIsDNMoi3nam.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn doanh nghiệp mới thành lập trong vòng 3 năm?";
                return false;
            }

            //----------------------------
            string so = txtSobanan.Text;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
            {
                DateTime ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "APS", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "APS", ngayBA).ToString();
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
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLQDVV.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLQDVV.DataTextField = "CASE_NAME";
            ddlQHPLQDVV.DataValueField = "ID";
            ddlQHPLQDVV.DataBind();
            ddlQHPLQDVV.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //Load QHPL Thống kê QD.
            ddlQHPLQDVV.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLQDVV.DataTextField = "CASE_NAME";
            ddlQHPLQDVV.DataValueField = "ID";
            ddlQHPLQDVV.DataBind();
            ddlQHPLQDVV.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISPHASAN == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //QHPL QDVV

            // QHPL Thống kê mặc định selected theo thụ lý
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            APS_SOTHAM_THULY tl = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYTHULY).FirstOrDefault();
            if (tl != null)
            {
                try { ddlQHPLQDVV.SelectedValue = tl.QHPLTKID + ""; } catch { }
            }
            //load người kí - mặc định chủ tọa
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            APS_SOTHAM_HDXX oHD = dt.APS_SOTHAM_HDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN && x.DONID == DONID).FirstOrDefault();
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
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {

            LoadCombobox();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(DONID)) return;

                APS_SOTHAM_BANAN_FILE oTF = new APS_SOTHAM_BANAN_FILE();
                List<APS_SOTHAM_BANAN> lst = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DONID).ToList();
                APS_SOTHAM_BANAN oND;
                if (lst.Count == 0)
                    oND = new APS_SOTHAM_BANAN();
                else
                {
                    oND = lst[0];
                }
                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NOIDUNG = txtTomtatnoidungBanan.Text;

                oND.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);

                oND.TK_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                oND.TK_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                oND.TK_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);
                oND.TK_SONGUOIBICAM_DNNN = (String.IsNullOrEmpty(txtTKCamDNNN.Text + "")) ? 0 : Convert.ToDecimal(txtTKCamDNNN.Text.Replace(".", ""));
                oND.TK_SONGUOIBICAM_HTX = (String.IsNullOrEmpty(txtTKCamHTX.Text + "")) ? 0 : Convert.ToDecimal(txtTKCamHTX.Text.Replace(".", ""));

                oND.ISCONGBOBA = rdCongboBA.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongboBA.SelectedValue);

                oND.TK_TONGGIATRINGHIAVUTAISAN = (String.IsNullOrEmpty(txtTKTongtaisan.Text + "")) ? 0 : Convert.ToDecimal(txtTKTongtaisan.Text.Replace(".", ""));
                oND.TK_TONGGIATRITHUHOI = (String.IsNullOrEmpty(txtTKTHuhoi.Text + "")) ? 0 : Convert.ToDecimal(txtTKTHuhoi.Text.Replace(".", ""));
                oND.NGUOIKY = txtNguoiKy.Text;
                oND.TK_ISDOANHNGHIEPNIEMYET = rdbIsNiemyet.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbIsNiemyet.SelectedValue);
                oND.TK_ISDOANHNGHIEP3NAM = rdbIsDNMoi3nam.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbIsDNMoi3nam.SelectedValue);
                oND.TK_ISDINHCHITHUTUCPHKD = rdbIsQDDCTT.SelectedValue == "" ? 0 : Convert.ToDecimal(rdbIsQDDCTT.SelectedValue);
                try
                {
                    if (hddFilePath.Value != "")
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        QT_FILE_BL fileHelper = new QT_FILE_BL();
                        QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN), "BANANSOTHAM");
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
                        dt.APS_SOTHAM_BANAN_FILE.Add(oTF);
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

                if (rdbTBPS.SelectedValue == "0")
                {
                    oND.TK_ISRUTGON = 1;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "1")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 1;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "2")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 1;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "3")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 1;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "4")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 1;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "5")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 1;
                    oND.TK_ISTOCHUCTINDUNG = 0;
                }
                else if (rdbTBPS.SelectedValue == "6")
                {
                    oND.TK_ISRUTGON = 0;
                    oND.TK_ISHNCN_KHONGTHANH = 0;
                    oND.TK_ISTHEONQHNCN = 0;
                    oND.TK_ISKHONGXAYDUNGPAPHKD = 0;
                    oND.TK_ISKHONGTHONGQUA = 0;
                    oND.TK_ISKHONGTHUCHIEN = 0;
                    oND.TK_ISTOCHUCTINDUNG = 1;
                }
                if (lst.Count == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_SOTHAM_BANAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if(oND.NGAYHIEULUC != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
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

                APS_DON_BL oBL = new APS_DON_BL();

                if (!String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, NgayBA.Year, 1);
                else
                {
                    Decimal? a = null;
                    STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(a), 1);
                }

                UploadFileID(oDon, FileID, "52-DS", STTQD);

                ResetControl();
                TamNgungDONKK_USER_DKNHANVB(DONID);
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
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
            if (obj != null)
            {

                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkk.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
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
            //        APS_SOTHAM_BANAN_FILE oTF = new APS_SOTHAM_BANAN_FILE();
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
            //            dt.APS_SOTHAM_BANAN_FILE.Add(oTF);
            //            dt.SaveChanges();
            //        }
            //        //// Dùng cho tống đạt văn bản
            //        //if (strFilePath.ToLower().Contains("52-ds"))
            //        //{
            //        //    APS_DON don = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //        //    if (don != null)
            //        //    {
            //        //        UploadFileID(don, "52-DS", oTF);
            //        //    }
            //        //}
            //        File.Delete(strFilePath);
            //        //path = path.Replace("\\", "/");
            //        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            //        LoadFile();
            //        lstErr.Text = "lưu thành công";
            //    }
            //    else LsbErrorExtension.Text = "Chỉ lưu file .doc";
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
                APS_SOTHAM_BANAN_FILE oTF = new APS_SOTHAM_BANAN_FILE();

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
                    dt.APS_SOTHAM_BANAN_FILE.Add(oTF);
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
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstErr.Text = Result;
                        return;
                    }
                    APS_SOTHAM_BANAN_FILE oT = dt.APS_SOTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oT.NOIDUNG == null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oT.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_PHASAN + ".";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                    APS_FILE oDsF = dt.APS_FILE.Where(x => x.DONID == oT.DONID && x.TENFILE == oT.TENFILE).FirstOrDefault();
                    if (oDsF != null)
                    {
                        dt.APS_FILE.Remove(oDsF);
                        dt.SaveChanges();
                    }
                    dt.APS_SOTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    var oND = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == DONID).FirstOrDefault();
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
                        string _pathStore = QT_FILE_BL.ToPathFolderStore(qT_FILE.DATE_CREATED.Value, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)) + "\\BANANSOTHAM";
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
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                foreach (DataGridItem oItem in dgAnPhi.Items)
                {
                    string strID = oItem.Cells[0].Text;
                    decimal DSID = Convert.ToDecimal(strID);
                    CheckBox chkMien = (CheckBox)oItem.FindControl("chkMien");
                    TextBox txtAnphi = (TextBox)oItem.FindControl("txtAnphi");
                    CheckBox chkThamgia = (CheckBox)oItem.FindControl("chkThamgia");
                    TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgaynhanbanan");
                    List<APS_SOTHAM_BANAN_ANPHI> lst = dt.APS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DONID && x.DUONGSU == DSID).ToList();
                    if (lst.Count == 0)
                    {
                        APS_SOTHAM_BANAN_ANPHI oT = new APS_SOTHAM_BANAN_ANPHI();
                        oT.DONID = DONID;
                        oT.DUONGSU = DSID;
                        oT.MIENANPHI = chkMien.Checked == true ? 1 : 0;
                        oT.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                        oT.ISTHAMGIA = chkThamgia.Checked == true ? 1 : 0;
                        oT.NGAYNHANAN = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.APS_SOTHAM_BANAN_ANPHI.Add(oT);
                        dt.SaveChanges();
                    }
                    else
                    {
                        APS_SOTHAM_BANAN_ANPHI oT = lst[0];
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
                CheckQuyenBAST(DONID);
                cmdAnphi.Style.Add("margin-bottom", "0px");
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
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
                pnNguyenNhanQuaHan.Visible = true;
            else
                pnNguyenNhanQuaHan.Visible = false;
        }
        protected void cmdHuyQuyetDinh_Click(object sender, EventArgs e)
        {
            // Xóa thông tin bản án
            decimal DonID = Session[ENUM_LOAIAN.AN_PHASAN] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            List<APS_SOTHAM_BANAN> banans = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (banans.Count > 0)
            {
                //Luu thong tin Bản án Sơ thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(banans);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(DonID, 7, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Sơ thẩm án Phá sản", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Bản án Sơ thẩm
                dt.APS_SOTHAM_BANAN.RemoveRange(banans);
            }
            // Xóa thông tin file đính kèm
            List<APS_SOTHAM_BANAN_FILE> files = dt.APS_SOTHAM_BANAN_FILE.Where(x => x.DONID == DonID).ToList();
            if (files.Count > 0)
            {
                foreach (var oND in files)
                {
                    if (oND.NOIDUNG == null && oND.QT_FILE_ID != null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_PHASAN + ".";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                }
                dt.APS_SOTHAM_BANAN_FILE.RemoveRange(files);
            }
            // Xóa điều luật áp dụng, tội danh
            List<APS_SOTHAM_BANAN_DIEULUAT> dieuLuats = dt.APS_SOTHAM_BANAN_DIEULUAT.Where(x => x.DONID == DonID).ToList();
            if (dieuLuats.Count > 0)
            {
                dt.APS_SOTHAM_BANAN_DIEULUAT.RemoveRange(dieuLuats);
            }
            // Xóa thông tin án phí
            List<APS_SOTHAM_BANAN_ANPHI> anPhis = dt.APS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID).ToList();
            if (anPhis.Count > 0)
            {
                dt.APS_SOTHAM_BANAN_ANPHI.RemoveRange(anPhis);
            }
            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "52-DS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            APS_FILE file = dt.APS_FILE.Where(x => x.DONID == DonID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).FirstOrDefault();
            if (file != null)
            {
                dt.APS_FILE.Remove(file);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DonID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
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

            SetTrangThaibanDauDONKK_USER_DKNHANVB(DonID);
            LoadBanAnInfo(DonID);
            dt.SaveChanges();
            ResetControl();
            lstErr.Text = "Xóa quyết định thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        protected void cmdXoaAnphi_Click(object sender, EventArgs e)
        {
            try
            {
                // Xóa thông tin án phí
                decimal DonID = Convert.ToDecimal(hddDonID.Value);
                List<APS_SOTHAM_BANAN_ANPHI> anPhis = dt.APS_SOTHAM_BANAN_ANPHI.Where(x => x.DONID == DonID).ToList();
                if (anPhis.Count > 0)
                {
                    dt.APS_SOTHAM_BANAN_ANPHI.RemoveRange(anPhis);
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
        private void ResetControl()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            LoadBanAnInfo(DonID);
            ddlQuanhephapluat.SelectedIndex = 0;
            lbthongbaoA.Text = "";
            txtSobanan.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            rdbTBPS.ClearSelection();
            rdCongboBA.ClearSelection();
            rdbIsQDDCTT.ClearSelection();
            ddlYeutonuocngoai.SelectedIndex = 0;
            ddlQuyetdinh.Enabled = false;
            rdVuAnQuaHan.ClearSelection();
            rdNNChuQuan.ClearSelection();
            rdNNKhachQuan.ClearSelection();
            txtTKTongtaisan.Text = "";
            txtTKTHuhoi.Text = "";
            //txtNguoiKy.Text = "";
            rdbIsNiemyet.ClearSelection();
            rdbIsDNMoi3nam.ClearSelection();
            txtTKCamDNNN.Text = "";
            txtTKCamHTX.Text = "";
            LoadFile();
            LoadAnPhi();
        }
        private void UploadFileID(APS_DON oDon, string strMaBieumau, APS_SOTHAM_BANAN_FILE fileDinhKem)
        {
            APS_DON_BL oBL = new APS_DON_BL();
            decimal IDBM = 0;
            string strTenBM = "";
            bool isNew = false;
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            APS_FILE objFile = dt.APS_FILE.Where(x => x.DONID == oDon.ID && x.TOAANID == oDon.TOAANID && x.MAGIAIDOAN == oDon.MAGIAIDOAN && x.BIEUMAUID == IDBM).FirstOrDefault();
            if (objFile == null)
            {
                isNew = true;
                objFile = new APS_FILE();
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
            if (isNew)
                dt.APS_FILE.Add(objFile);
            dt.SaveChanges();
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