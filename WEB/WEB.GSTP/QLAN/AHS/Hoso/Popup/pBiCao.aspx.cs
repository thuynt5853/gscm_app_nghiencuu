using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.QLAN;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;
using Module.Common.C06;
using BL.GSTP.DLQGC06;
using System.Xml;
using System.Text;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using Formatting = Newtonsoft.Json.Formatting;

namespace WEB.GSTP.QLAN.AHS.Hoso.Popup
{
    public partial class pBiCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        public static Decimal VuAnID = 0, CurrUserID = 0, BiCaoID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        public Decimal LoginTinhID = 0, LoginHuyenID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (CurrUserID > 0)
                {
                    CurrentYear = DateTime.Now.Year;
                    VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                    LoginTinhID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_TINH_ID] + "");
                    LoginHuyenID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    //txtBo_HoTen.Text = hdHoTenCha.Value;
                    //txtMe_HoTen.Text = hdHoTenMe.Value;
                    //txtBanDoi_HoTen.Text = hdHoTenVoChong.Value;
                    if (!IsPostBack)
                    {
                        AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();

                        NgayXayRaVuAn = ((String.IsNullOrEmpty(oT.NGAYXAYRA + "")) || (((DateTime)oT.NGAYXAYRA) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);

                        LoadCombobox();
                        BiCaoID = (Request["bID"] != null) ? Convert.ToDecimal(Request["bID"] + "") : 0;
                        hddID.Value = BiCaoID.ToString();

                        lkThemCon.Enabled = false;
                        lkThemCon.CssClass = "buttonpopup_diable them_user_diable";
                        if (BiCaoID > 0)
                        {
                            LoadInfo(BiCaoID);
                            lkThemCon.Enabled = true;
                            lkThemCon.CssClass = "buttonpopup them_user";
                        }
                        if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                            pnHoKhau.Visible = true;
                        else
                            pnHoKhau.Visible = false;
                        LoadGridToiDanh();
                        CheckQuyen();
                    }
                    else
                    {
                        txtBo_HoTen.Text = hdHoTenCha.Value;
                        txtMe_HoTen.Text = hdHoTenMe.Value;
                        txtBanDoi_HoTen.Text = hdHoTenVoChong.Value;
                        //GTEL-DUCPH 29-09-2025 fix nếu có postback thì xử lý spanCCCD theo checkbox Không có
                        if (!chkKhongCoBC.Checked)
                        {
                            spanCCCD.Attributes["class"] = "required";
                        }
                        else
                        {
                            spanCCCD.Attributes["class"] = ""; // hoặc null nếu không muốn class
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }

        void CheckQuyen()
        {
            AHS_SOTHAM_BANAN BA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (BA != null)
            {
                lstMsgT.Text = lstMsgB.Text = "Đã có bản án, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
            }

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Đã có quyết định kết thúc, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
            }
            int MAGIAIDOAN = Convert.ToInt16(hddGiaiDoanVuAn.Value);
            if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lstMsgT.Text = lstMsgB.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
                return;
            }
            else if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgT.Text = lstMsgB.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
                return;
            }
            if (dropDoiTuongPhamToi.SelectedValue == "0")
                CheckBiCanDauVu();
            else
            {
                CheckPhapNhanChinh();
            }
        }
        void CheckBiCanDauVu()
        {
            rdBiCanDauVu.Enabled = false;
            try
            {
                cmdGetToiDanhDauVu.Visible = false;
                AHS_BICANBICAO objBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).FirstOrDefault();

                if (objBC == null)
                {
                    rdBiCanDauVu.SelectedValue = "1";
                }
                else if (objBC.ID == BiCaoID)
                {
                    rdBiCanDauVu.SelectedValue = "1";
                }
                else
                {
                    rdBiCanDauVu.SelectedValue = "0";
                }


                if (objBC != null)
                {
                    hddBiCanDauVuID.Value = objBC.ID.ToString();

                    //KT: Neu chua co toi danh --> cho hien nut "Gan toi danh cua bi can dau vu", da co toi danh --> an di
                    Decimal CurrBiCanID = Convert.ToDecimal(hddID.Value);
                    Decimal BiCanDauVuId = Convert.ToDecimal(hddBiCanDauVuID.Value);

                    AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                    DataTable tbl = objBL.GetAllToiDanhByBiCan(BiCanDauVuId, VuAnID);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        if (CurrBiCanID == 0)
                            cmdGetToiDanhDauVu.Visible = true;
                        else
                        {
                            if (CurrBiCanID == BiCanDauVuId)
                                cmdGetToiDanhDauVu.Visible = false;
                            else
                                cmdGetToiDanhDauVu.Visible = true;
                        }
                    }
                    else
                    {
                        cmdGetToiDanhDauVu.Visible = false;
                        //lbthongbao.Text = "Bị can đầu vụ chưa có tội danh";
                    }
                }
                else
                {
                    cmdGetToiDanhDauVu.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = lbthongbao.Text = "Lỗi kiểm tra quyền truy cập! ";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNext, false);
                Cls_Comon.SetButton(cmdUpdateAndNext2, false);
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdGetToiDanhDauVu, false);
                lkThemCon.Visible = false;
                lkChoiceToiDanh.Visible = false;
                btnChonToiDanhChinh.Visible = false;
                hddShowCommand.Value = "False";
            }
        }
        void CheckPhapNhanChinh()
        {
            pnBiCanDauVu.Visible = false;
            pnPhapNhanChinh.Visible = true;
            AHS_BICANBICAO objBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.PHAPNHANCHINH == 1).FirstOrDefault();
            if (objBC == null)
                rdPhapNhanChinh.SelectedValue = "1";
            else if (objBC.ID == BiCaoID)
                rdPhapNhanChinh.SelectedValue = "1";
            else
                rdPhapNhanChinh.SelectedValue = "0";
            rdPhapNhanChinh.Enabled = false;
        }

        #region from bi cao
        void LoadDrop_LoaiToiPhamHS_ThongKe()
        {
            DM_QHPL_TK_BL objBL = new DM_QHPL_TK_BL();
            DataTable tbl = objBL.GetByStyle(7);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropLoaiToiPham.Items.Clear();
                foreach (DataRow row in tbl.Rows)
                    dropLoaiToiPham.Items.Add(new ListItem(row["Case_Name"] + "", row["ID"] + ""));
            }
        }
        private void LoadCombobox()
        {
            LoadDropTinh_Huyen();
            LoadDropByGroupName(dropDanToc, ENUM_DANHMUC.DANTOC, true);
            LoadDropByGroupName(dropNgheNghiep, ENUM_DANHMUC.NGHENGHIEP, true);

            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            dropQuocTich.SelectedValue = QuocTichVN.ToString();

            LoadDropByGroupName(dropTrinhDoVH, ENUM_DANHMUC.TRINHDOVANHOA, false);
            LoadDropByGroupName(dropTinhTrangGiamGiu, ENUM_DANHMUC.TINHTRANGGIAMGIU, false);

            LoadDropByGroupName(dropTonGiao, ENUM_DANHMUC.TONGIAO, true);
            LoadDrop_LoaiToiPhamHS_ThongKe();
            //--------------------------
            // LoadDrop_MoiQHNhanThan();
            //----------------------------------------Form bien phap ngan chan-
            LoadDropByGroupName(dropBienPhapNganChan, ENUM_DANHMUC.BIENPHAPNGANCHAN, true);
            LoadDropByGroupName(dropDV, ENUM_DANHMUC.LOAIDONVIQDNGANCHAN, true);

            //form toi danh-
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                           && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            // dropBoLuat.Items.Add(new ListItem("--Chọn--", "0"));
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
            LoadDropByGroupName(ddlQuocTich_DD, ENUM_DANHMUC.QUOCTICH, false);
            ddlQuocTich_DD.SelectedValue = QuocTichVN.ToString();
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--Chọn--", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }

        private const decimal ROOT = 0;
        private void LoadDropTinh_Huyen()
        {
            ddlHKTT_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlDC_DangKy_Tinh.Items.Clear();
            ddlDC_HoatDong_Tinh.Items.Clear();
            ddlCuTru_DD_Tinh.Items.Clear();
            ddlHKTT_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlTamTru_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlDC_DangKy_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlDC_HoatDong_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlCuTru_DD_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlHKTT_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlHKTT_Tinh, LoginTinhID);
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlTamTru_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, LoginTinhID);
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlDC_DangKy_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlDC_DangKy_Tinh, LoginTinhID);
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlDC_HoatDong_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlDC_HoatDong_Tinh, LoginTinhID);
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlCuTru_DD_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlCuTru_DD_Tinh, LoginTinhID);
            }

            //----------------------------------------
            LoadDropHuyen();
        }
        void LoadDropHuyen()
        {
            ddlHKTT_Huyen.Items.Clear();
            ddlTamTru_Huyen.Items.Clear();
            ddlDC_DangKy_Huyen.Items.Clear();
            ddlDC_HoatDong_Huyen.Items.Clear();
            ddlCuTru_DD_Huyen.Items.Clear();

            ddlHKTT_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlTamTru_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlDC_DangKy_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlDC_HoatDong_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlCuTru_DD_Huyen.Items.Add(new ListItem("Chọn", "0"));
            Decimal TinhID = Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue);
            if (TinhID > 0)
            {
                List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                if (lstHuyen != null && lstHuyen.Count > 0)
                {
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlHKTT_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, LoginHuyenID);
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlTamTru_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, LoginHuyenID);
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlDC_DangKy_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlDC_DangKy_Huyen, LoginHuyenID);
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlDC_HoatDong_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlDC_HoatDong_Huyen, LoginHuyenID);
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlCuTru_DD_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlCuTru_DD_Huyen, LoginHuyenID);
                }
            }
        }

        private void LoadDropHuyenByTinh(DropDownList drop, Decimal TinhID)
        {
            drop.Items.Clear();
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                drop.Items.Add(new ListItem("Chọn", "0"));
                foreach (DM_HANHCHINH oHC in lstHuyen)
                    drop.Items.Add(new ListItem(oHC.TEN, oHC.ID.ToString()));
            }
            else
                drop.Items.Add(new ListItem("Chọn", "0"));
        }


        protected void ddlHKTT_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlHKTT_Huyen, Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue));
                // GTEL-Phạm Đức 17-09-2025 15h:45 bind Xã vào dropdownlist của Huyện Nơi Sinh
                // GTEL - Ngọc Hải 23-09-2025 10h:30 Sửa lỗi không chọn được Huyện Nơi Sinh khi dữ liệu không khớp
                if (!string.IsNullOrEmpty(hdNoiSinhXaId.Value) && ddlHKTT_Huyen.Items.FindByValue(hdNoiSinhXaId.Value) != null)
                {
                    ddlHKTT_Huyen.SelectedValue = hdNoiSinhXaId.Value;
                }

                Cls_Comon.SetFocus(this, this.GetType(), ddlHKTT_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        
        protected void ddlTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal tamTruTinhId = 0;
                Decimal.TryParse(ddlTamTru_Tinh.SelectedValue, out tamTruTinhId);

                LoadDropHuyenByTinh(ddlTamTru_Huyen, tamTruTinhId);

                // GTEL-Phạm Đức 17-09-2025 15h:45 bind Xã vào dropdownlist của Huyện Tạm trú
                if (!string.IsNullOrEmpty(hdTamTruXaId.Value))
                {
                    var huyenItem = ddlTamTru_Huyen.Items.FindByValue(hdTamTruXaId.Value);
                    if (huyenItem != null)
                    {
                        try { ddlTamTru_Huyen.SelectedValue = hdTamTruXaId.Value; } catch { }
                    }
                }

                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen.ClientID);
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = ex.Message;
            }
        }

        private void LoadInfo(decimal BiCanID)
        {
            hddID.Value = BiCanID.ToString();
            AHS_BICANBICAO obj = null;
            try
            {
                obj = dt.AHS_BICANBICAO.Where(x => x.ID == BiCanID).SingleOrDefault();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                pnCaNhan.Visible = pnNhanThanBC.Visible = obj.LOAIDOITUONG == 0;
                pnPhapNhan.Visible = pnNguoiDaiDien.Visible = obj.LOAIDOITUONG != 0;
                dropLoaiToiPham.SelectedValue = (String.IsNullOrEmpty(obj.LOAITOIPHAMHS_ID + "")) ? "0" : obj.LOAITOIPHAMHS_ID.ToString();
                if (obj.LOAIDOITUONG != null)
                    dropDoiTuongPhamToi.SelectedValue = obj.LOAIDOITUONG + "";
                if (obj.LOAIDOITUONG == 0)
                {
                    txtTen.Text = obj.HOTEN;
                    rdBiCanDauVu.SelectedValue = obj.BICANDAUVU.ToString();
                    txtCMND.Text = obj.SOCMND;
                    dropNgheNghiep.SelectedValue = (String.IsNullOrEmpty(obj.NGHENGHIEPID + "")) ? "0" : obj.NGHENGHIEPID.ToString();
                    dropTrinhDoVH.SelectedValue = obj.TRINHDOVANHOAID.ToString();
                    //----------------------------------------
                    dropQuocTich.SelectedValue = obj.QUOCTICHID.ToString();
                    string Ma_quoctich = dt.DM_DATAITEM.Where(x => x.ID == obj.QUOCTICHID).Single<DM_DATAITEM>().MA;
                    if (Ma_quoctich == ENUM_MAQUOCTICH.VIETNAM)
                        pnHoKhau.Visible = true;
                    else
                        pnHoKhau.Visible = false;

                    //----------------------------------------
                    if (obj.HKTT != null)
                    {
                        Cls_Comon.SetValueComboBox(ddlHKTT_Tinh, obj.HKTT);
                        LoadDropHuyenByTinh(ddlHKTT_Huyen, (decimal)obj.HKTT);
                    }
                    if (obj.HKTT_HUYEN != null)
                        Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, obj.HKTT_HUYEN);
                    txtHKTT_Chitiet.Text = obj.KHTTCHITIET;

                    //----------------------------------------
                    if (obj.TAMTRU != null)
                    {
                        Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, obj.TAMTRU);
                        LoadDropHuyenByTinh(ddlTamTru_Huyen, (decimal)obj.TAMTRU);
                    }
                    if (obj.TAMTRU_HUYEN != null)
                        Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, obj.TAMTRU_HUYEN);
                    txtTamtru_Chitiet.Text = obj.TAMTRUCHITIET;

                    //----------------------------------------
                    if (obj.NGAYSINH != DateTime.MinValue)
                        txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    txtNamSinh.Text = obj.NAMSINH + "";
                    ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();

                    //----------------------------------------
                    txtTenKhac.Text = obj.TENKHAC + "";
                    dropDanToc.SelectedValue = (string.IsNullOrEmpty(obj.DANTOCID + "")) ? "0" : obj.DANTOCID + "";
                    dropTonGiao.SelectedValue = (string.IsNullOrEmpty(obj.TONGIAOID + "")) ? "0" : obj.TONGIAOID + "";
                    rdChuvVuCQ.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUCHINHQUYENID + "")) ? "0" : obj.CHUCVUCHINHQUYENID.ToString();
                    rdChucVuDang.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUDANGID + "")) ? "0" : obj.CHUCVUDANGID.ToString();

                    txtNgayKhoiTo.Text = ((String.IsNullOrEmpty(obj.NGAYTHAMGIA + "")) || (((DateTime)obj.NGAYTHAMGIA) == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);

                    try
                    { dropTinhTrangGiamGiu.SelectedValue = obj.TINHTRANGGIAMGIUID.ToString(); }
                    catch (Exception exx) { }
                    //-----------------------------------------
                    rdTreViThanhNien.SelectedValue = (String.IsNullOrEmpty(obj.ISTREVITHANHNIEN + "")) ? "0" : obj.ISTREVITHANHNIEN.ToString();
                    if (rdTreViThanhNien.SelectedValue == "1")
                    {
                        pnTreViThanhNien.Visible = true;

                        rdTreMoCoi.SelectedValue = obj.TREMOCOI + "";
                        rdTreBoHoc.SelectedValue = obj.TREBOHOC + "";
                        rdTreLangThang.SelectedValue = obj.TRELANGTHANG + "";

                        rdLyHon.SelectedValue = obj.BOMELYHON + "";
                        rdNguoiXuiGiuc.SelectedValue = obj.CONGUOIXUIGIUC + "";
                    }
                    else
                    {
                        pnTreViThanhNien.Visible = false;
                    }
                    if (obj.TUOI > 0)
                        txtTuoi.Text = obj.TUOI + "";
                    rdQuanHeThanThich.SelectedValue = (string.IsNullOrEmpty(obj.IS_THANTHICH_BH + "") ? "0" : obj.IS_THANTHICH_BH.ToString());
                    rdQuanHeQuenBiet.SelectedValue = (string.IsNullOrEmpty(obj.IS_QUENBIET_BH + "") ? "0" : obj.IS_QUENBIET_BH.ToString());
                    //----------------------------------------
                    rdNGhienHut.SelectedValue = obj.NGHIENHUT + "";
                    rdTinhTrangTaiPham.SelectedValue = obj.TAIPHAM + "";
                    //-----------------------------------------
                    txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                    txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();

                    // địa bàn phạm tội
                    ddlDiaBanPT.SelectedValue = (string.IsNullOrEmpty(obj.DIABAN_PHAMTOI + "")) ? "0" : obj.DIABAN_PHAMTOI + "";
                    //tháng 
                    if (obj.THANG_TUOI > 0)
                        txtThang.Text = obj.THANG_TUOI + "";
                    //-----------------------------------------

                    //----------------------
                    LoadDsNhanThanBiCao();

                    //---------- GTEL-Phạm Đức NC: 13-09-2025 9h:00 Lay thong tin CCCD, HC cho chỉnh sửa-------------//
                    txtCCCD.Text = obj.SO_CCCD;
                    txtHoChieu.Text = obj.SO_HOCHIEU;
                    hdTrangThaiXacThuc.Value = obj.XACTHUC_DLDCQG;
                    chkKhongCoBC.Checked = obj.CHK_KHONG_CO == "1";

                    if (hdTrangThaiXacThuc.Value == "2") // Nếu trạng thái là chưa xác thực đã lấy thông tin từ CSDLQG set check box không làm sạch
                    {
                        chkKhongLamSachBC.Checked = true;
                    }

                    if (hdTrangThaiXacThuc.Value == "1")
                    {
                        chkKhongLamSachBC.Checked = false;
                        chkKhongCoBC.Checked = false;
                    }

                    if (hdTrangThaiXacThuc.Value == "1") // Nếu đã xác thực thì không cho sửa Họ Tên và CCCD
                        chkKhongCoBC.Enabled = chkKhongLamSachBC.Enabled = txtCCCD.Enabled = txtTen.Enabled = txtNgaysinh.Enabled = ddlGioitinh.Enabled = false;
                    else
                        chkKhongCoBC.Enabled = chkKhongLamSachBC.Enabled = txtCCCD.Enabled = txtTen.Enabled = txtNgaysinh.Enabled = ddlGioitinh.Enabled = true;

                    if (chkKhongCoBC.Checked)
                    {
                        spanCCCD.Attributes["class"] = spanCCCD.Attributes["class"].Replace("required", "").Trim();
                    }
                    else
                    {
                        string currentClass = spanCCCD.Attributes["class"] ?? "";
                        if (!currentClass.Contains("required"))
                        {
                            spanCCCD.Attributes["class"] = (currentClass + " required").Trim();
                        }
                    }
                }
                else
                {
                    txtTenPhapNhan.Text = obj.HOTEN;
                    txtGiayPhepKD.Text = obj.GIAYPHEPKINHDOANH;
                    //----------------------------------------
                    if (obj.DIACHIDANGKY_TINH != null)
                    {
                        Cls_Comon.SetValueComboBox(ddlDC_DangKy_Tinh, obj.DIACHIDANGKY_TINH);
                        LoadDropHuyenByTinh(ddlDC_DangKy_Huyen, (decimal)obj.DIACHIDANGKY_TINH);
                    }
                    if (obj.DIACHIDANGKY_HUYEN != null)
                        Cls_Comon.SetValueComboBox(ddlDC_DangKy_Huyen, obj.DIACHIDANGKY_HUYEN);
                    txtDC_DangKy_ChiTiet.Text = obj.DIACHIDANGKY_CHITIET;
                    //----------------------------------------
                    if (obj.DIACHIHOATDONG_TINH != null)
                    {
                        Cls_Comon.SetValueComboBox(ddlDC_HoatDong_Tinh, obj.DIACHIHOATDONG_TINH);
                        LoadDropHuyenByTinh(ddlDC_HoatDong_Huyen, (decimal)obj.DIACHIHOATDONG_TINH);
                    }
                    if (obj.DIACHIHOATDONG_HUYEN != null)
                        Cls_Comon.SetValueComboBox(ddlDC_HoatDong_Huyen, obj.DIACHIHOATDONG_HUYEN);
                    txtDC_HoatDong_ChiTiet.Text = obj.DIACHIHOATDONG_CHITIET;

                    txtSDT.Text = obj.SDT;
                    txtFax.Text = obj.FAX;
                    rdVonNhaNuoc.SelectedValue = obj.VONNHANUOC + "";
                    rdVonNuocNgoai.SelectedValue = obj.VONNUOCNGOAI + "";
                    txtTienAn_PhapNhan.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                    txtTienSu_PhapNhan.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();
                    rdTaiPham_PhapNhan.SelectedValue = obj.TAIPHAM + "";

                    //Người đại diện
                    txtTenDaiDien.Text = obj.TENKHAC;
                    txtChucVu.Text = obj.CHUCVU_DAIDIEN;

                    if (obj.NGAYSINH != DateTime.MinValue)
                        txtNgaySinh_DD.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    txtNamSinh_DD.Text = obj.NAMSINH + "";
                    ddlQuocTich_DD.SelectedValue = obj.QUOCTICHID.ToString();
                    ddlGioiTinh_DD.SelectedValue = obj.GIOITINH.ToString();
                    txtCMND_DD.Text = obj.SOCMND;
                    //----------------------------------------
                    if (obj.TAMTRU != null)
                    {
                        Cls_Comon.SetValueComboBox(ddlCuTru_DD_Tinh, obj.TAMTRU);
                        LoadDropHuyenByTinh(ddlCuTru_DD_Huyen, (decimal)obj.TAMTRU);
                    }
                    if (obj.TAMTRU_HUYEN != null)
                        Cls_Comon.SetValueComboBox(ddlCuTru_DD_Huyen, obj.TAMTRU_HUYEN);
                    txtCuTru_DD_ChiTiet.Text = obj.TAMTRUCHITIET;
                    txtSTT_DD.Text = obj.SDT_DAIDIEN;
                }
                LoadBienPhapNCTheoBiCaoID(BiCanID);

            }
        }

        protected void txtNgayKhoiTo_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text))
            {
                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime Dnow = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayKhoiTo > Dnow)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày bị khởi tố không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtNgayKhoiTo.ClientID);
                    return;
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropDanToc.ClientID);
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                DateTime Ngaysinh = DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                if (Ngaysinh != DateTime.MinValue)
                {
                    if (Ngaysinh > now)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaysinh.ClientID);
                        return;
                    }
                    else
                        txtNamSinh.Text = Ngaysinh.Year.ToString();
                }
                if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                {
                    DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (Ngaysinh > NgayKhoiTo)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày bị khởi tố. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaysinh.ClientID);
                        return;
                    }
                    txtNamSinh.Text = Ngaysinh.Year.ToString();
                }

            }
        }
        protected void txtNamSinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                if (!String.IsNullOrEmpty(txtNamSinh.Text))
                {
                    namsinh = Convert.ToInt32(txtNamSinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtNgaysinh.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtNgaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtNamSinh.Text))
            {
                namsinh = Convert.ToInt32(txtNamSinh.Text);
                if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                {
                    DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (namsinh > NgayKhoiTo.Year)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn năm khởi tố. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);
                    }
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtTenKhac.ClientID);
        }

        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdTreViThanhNien.SelectedValue == "1")
            {
                if (string.IsNullOrEmpty(txtNamSinh.Text.Trim()))
                {
                    rdTreViThanhNien.SelectedIndex = -1;
                }
                else
                {
                    pnTreViThanhNien.Visible = true;
                }
            }
            else
            {
                pnTreViThanhNien.Visible = false;
            }
        }

        protected void dropQuocTich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                pnHoKhau.Visible = true;
            else
                pnHoKhau.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), dropDanToc.ClientID);
        }

        #endregion
        private bool CheckValidate()
        {
            string msg = "";
            if (dropDoiTuongPhamToi.SelectedValue != "0")
            {
                if (txtTenPhapNhan.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập tên pháp nhân. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtTenPhapNhan.Focus();
                    return false;
                }
                if (txtGiayPhepKD.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập Giấy phép kinh doanh. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtGiayPhepKD.Focus();
                    return false;
                }
                if (ddlDC_DangKy_Tinh.SelectedValue == "0" || ddlDC_DangKy_Huyen.SelectedValue == "0")
                {
                    msg = "Bạn chưa chọn Địa chỉ đăng ký. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    ddlDC_DangKy_Tinh.Focus();
                    return false;
                }
                if (ddlDC_HoatDong_Tinh.SelectedValue == "0" || ddlDC_HoatDong_Huyen.SelectedValue == "0")
                {
                    msg = "Bạn chưa chọn Địa chỉ hoạt động. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    ddlDC_HoatDong_Tinh.Focus();
                    return false;
                }
                if (txtSDT.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập SĐT đăng ký. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtSDT.Focus();
                    return false;
                }
                if (rdVonNhaNuoc.SelectedValue == "")
                {
                    msg = "Mục 'Có vốn góp nhà nước' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdVonNuocNgoai.SelectedValue == "")
                {
                    msg = "Mục 'Có vốn đầu tư nước ngoài' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdTaiPham_PhapNhan.SelectedValue == "")
                {
                    msg = "Mục 'Tái phạm, tái phạm nguy hiểm' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (txtTenDaiDien.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập tên người đại diện. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtTenDaiDien.Focus();
                    return false;
                }
                if (txtChucVu.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập chức vụ. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtChucVu.Focus();
                    return false;
                }
                if (txtNamSinh_DD.Text == "")
                {
                    msg = "Bạn chưa nhập năm sinh. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtNamSinh_DD.Focus();
                    return false;
                }
                if (txtCMND_DD.Text == "")
                {
                    msg = "Bạn chưa nhập CMND/CCCD/Hộ chiếu. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtCMND_DD.Focus();
                    return false;
                }
            }
            else
            {

                if (txtTen.Text.Trim() == "")
                {
                    msg = "Bạn chưa nhập tên bị can. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtTen.Focus();
                    return false;
                }

                //GTEL-DUCPHAM 22-09-2025 bo check CCCD nếu check chọn vào Checkbox Không Có
                if (!chkKhongCoBC.Checked)
                {
                    if (string.IsNullOrEmpty(txtCCCD.Text))
                    {
                        msg = "Bạn chưa nhập CCCD Bị can. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        txtCCCD.Focus();
                        return false;
                    }
                    //if (string.IsNullOrEmpty(txtCMND.Text))
                    //{
                    //    msg = "Bạn chưa nhập số CMND Bị can. Hãy kiểm tra lại!";
                    //    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    //    txtCMND.Focus();
                    //    return false;
                    //}
                }
                // END GTEL-DUCPHAM 22-09-2025
                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime Dnow = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime NgayKhoiTo = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayKhoiTo != DateTime.MinValue)
                {
                    if (NgayKhoiTo > Dnow)
                    {
                        msg = "Ngày bị khởi tố không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        txtNgayKhoiTo.Focus();
                        return false;
                    }
                }
                if (txtNamSinh.Text == "")
                {
                    msg = "Bạn chưa nhập năm sinh. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtNamSinh.Focus();
                    return false;
                }
                if (dropQuocTich.SelectedValue == QuocTichVN.ToString() && ddlHKTT_Tinh.SelectedValue == "0")
                {
                    msg = "Bạn chưa chọn địa chỉ thường trú. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    ddlHKTT_Tinh.Focus();
                    return false;
                }

                if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                {
                    if (ddlTamTru_Tinh.SelectedValue == "0")
                    {
                        msg = "Bạn chưa chọn nơi sinh sống. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        ddlTamTru_Tinh.Focus();
                        return false;
                    }
                }
                if (rdChucVuDang.SelectedValue == "")
                {
                    msg = "Mục 'Chức vụ đảng' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdChuvVuCQ.SelectedValue == "")
                {
                    msg = "Mục 'Công chức, viên chức' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdNGhienHut.SelectedValue == "")
                {
                    msg = "Mục 'Nghiện hút' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdTinhTrangTaiPham.SelectedValue == "")
                {
                    msg = "Mục 'Tái phạm, tái phạm nguy hiểm' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdTreViThanhNien.SelectedValue == "1")
                {
                    if (rdTreMoCoi.SelectedValue == "")
                    {
                        msg = "Mục 'Trẻ mồ côi cha hoặc mẹ' bắt buộc phải chọn. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        return false;
                    }
                    if (rdTreLangThang.SelectedValue == "")
                    {
                        msg = "Mục 'Trẻ lang thang' bắt buộc phải chọn. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        return false;
                    }
                    if (rdTreBoHoc.SelectedValue == "")
                    {
                        msg = "Mục 'Trẻ bỏ học' bắt buộc phải chọn. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        return false;
                    }
                    if (rdLyHon.SelectedValue == "")
                    {
                        msg = "Mục 'Bố mẹ ly hôn' bắt buộc phải chọn. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        return false;
                    }
                    if (rdNguoiXuiGiuc.SelectedValue == "")
                    {
                        msg = "Mục 'Có người đủ 18 tuổi trở lên xúi giục' bắt buộc phải chọn. Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        return false;
                    }
                }
            }
            if (rdNganChan.SelectedValue == "")
            {
                msg = "Mục 'biện pháp ngăn chặn' bắt buộc phải chọn. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                return false;
            }
            else
            {
                if (rdNganChan.SelectedValue == "1")
                {
                    if (Cls_Comon.IsValidDate(txtNgayBatDau.Text) == false)
                    {
                        msg = "Bạn chưa nhập 'Ngày bắt đầu có hiệu lực' theo định dạng (ngày/tháng/năm). Hãy kiểm tra lại!";
                        Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                        txtNgayBatDau.Focus();
                        return false;
                    }

                    DateTime NgayBatDauHieuLuc = DateTime.Parse(txtNgayBatDau.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                    if (txtNgayKT.Text != "")
                    {
                        if (Cls_Comon.IsValidDate(txtNgayKT.Text) == false)
                        {
                            msg = "Bạn chưa nhập 'Ngày hết hiệu lực hoặc ngày được tha' theo định dạng (ngày/tháng/năm). Hãy kiểm tra lại!";
                            Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                            txtNgayKT.Focus();
                            return false;
                        }
                        DateTime NgayKT = DateTime.Parse(txtNgayKT.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (NgayKT < NgayBatDauHieuLuc)
                        {
                            msg = "'Ngày hết hiệu lực hoặc ngày được tha' không thể nhỏ hơn 'Ngày bắt đầu có hiệu lực'. Hãy kiểm tra lại!";
                            Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                            txtNgayBatDau.Focus();
                            return false;
                        }
                    }
                }
            }

            return true;
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;

            //KT xem đã chọn tội danh chính chưa
            if (!CheckTonTaiTDC())
                return;

            //KT xem bi can da duoc gan toi chua
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }

            Save_BiCan();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;

            //KT xem đã chọn tội danh chính chưa
            if (!CheckTonTaiTDC())
                return;

            //KT xem bi can da duoc gan toi chua
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }

            Save_BiCan();

            lstMsgT.Text = lstMsgB.Text = "Lưu thông tin bị can thành công!";
            Resetcontrol();

        }
        void Resetcontrol()
        {
            txtTen.Text = txtTenKhac.Text = txtCMND.Text = txtCCCD.Text = txtHoChieu.Text = "";
            txtTuoi.Text = "";
            txtCMND.Enabled = txtCCCD.Enabled = txtTen.Enabled = true;
            //GTEL-DUCPH 29-09-2025 10H Thêm bỏ check vào không làm sạch và không chọn
            chkKhongLamSachBC.Checked = chkKhongCoBC.Checked = false;
            hdTrangThaiXacThuc.Value = "0";
            ddlGioitinh.Enabled = true;
            dropQuocTich.Enabled = true;
            txtNamSinh.Enabled = true;
            chkKhongLamSachBC.Enabled = true;
            chkKhongCoBC.Enabled = true;
            //END
            txtThang.Text = "";

            rdBiCanDauVu.SelectedValue = "0";
            txtNgaysinh.Text = txtNamSinh.Text = "";


            txtNgayKhoiTo.Text = "";
            ddlGioitinh.SelectedIndex = dropQuocTich.SelectedIndex = dropDanToc.SelectedIndex = 0;

            //---------------------------
            txtHKTT_Chitiet.Text = txtTamtru_Chitiet.Text = "";
            LoadDropTinh_Huyen();

            //---------------------------
            dropTonGiao.SelectedValue = dropNgheNghiep.SelectedValue = "0";
            dropTrinhDoVH.SelectedIndex = dropTinhTrangGiamGiu.SelectedIndex = 0;
            //---------------------------
            hddID.Value = "0";
            hddPageIndex.Value = "1";

            //---------------------------
            rdChucVuDang.SelectedIndex = rdChuvVuCQ.SelectedIndex = -1;
            rdTinhTrangTaiPham.SelectedIndex = rdNGhienHut.SelectedIndex = -1;
            //---------------------------
            txtTienAn.Text = txtTienSu.Text = "";
            rdTreViThanhNien.SelectedIndex = -1;
            pnTreViThanhNien.Visible = false;
            dropLoaiToiPham.SelectedIndex = 0;
            //--------------------
            ResetControlNhanThan();
            //---------------------------
            rdNganChan.SelectedValue = "0";
            pnBienPhapNganChan.Visible = false;
            txtNgayBatDau.Text = txtNgayKT.Text = "";
            dropBienPhapNganChan.SelectedIndex = dropDV.SelectedIndex = 0;

            //----------------
            txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
            lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            pndata.Visible = false;
            cmdGetToiDanhDauVu.Visible = true;
        }
        void Save_BiCan()
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            Update_BiCao();

            Decimal BiCaoID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            SaveNhanThanBiCan();
            //---------------------------------
            SaveBienPhapNC(BiCaoID);

            //---------------------------
            hddIsReloadParent.Value = "1";
        }
        void SaveNhanThanBiCan()
        {
            //---------------------------------
            if (!String.IsNullOrEmpty(txtBo_HoTen.Text.Trim()))
                Update_NhanThan(ENUM_QH_NHANTHAN.BO, hddNT_Bo, txtBo_HoTen, txtBo_NamSinh, txtBo_Diachi, txtBo_GhiChu);

            if (!String.IsNullOrEmpty(txtMe_HoTen.Text.Trim()))
                Update_NhanThan(ENUM_QH_NHANTHAN.ME, hddNT_Me, txtMe_HoTen, txtMe_NamSinh, txtMe_Diachi, txtMe_GhiChu);

            if (!String.IsNullOrEmpty(txtBanDoi_HoTen.Text.Trim()))
                Update_NhanThan(ENUM_QH_NHANTHAN.VO_CHONG, hddNT_BanDoi, txtBanDoi_HoTen, txtBanDoi_NamSinh, txtBanDoi_Diachi, txtBanDoi_GhiChu);

            if (!String.IsNullOrEmpty(txtCon1_HoTen.Text.Trim()))
                Update_NhanThan(ENUM_QH_NHANTHAN.CON, hddNT_Con1, txtCon1_HoTen, txtCon1_NamSinh, txtCon1_Diachi, txtCon1_GhiChu);

            if (!String.IsNullOrEmpty(txtCon2_HoTen.Text.Trim()))
                Update_NhanThan(ENUM_QH_NHANTHAN.CON, hddNT_Con2, txtCon2_HoTen, txtCon2_NamSinh, txtCon2_Diachi, txtCon2_GhiChu);

        }

        Boolean CheckGanToiChoBiCan()
        {
            try
            {
                Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                                                && x.VUANID == VuAnID
                                                                                                && x.DIEULUATID == boluatid).ToList();
                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex) { return false; }
        }
        void Update_BiCao()
        {
            Decimal VuAnId = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal BiCaoID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            #region Bi cao vu an
            AHS_BICANBICAO obj = new AHS_BICANBICAO();

            if (BiCaoID > 0)
            {
                obj = dt.AHS_BICANBICAO.Where(x => x.ID == BiCaoID).Single<AHS_BICANBICAO>();
                if (obj == null)
                {
                    lbthongbao.Text = "Không tìm thấy bị can/bị cáo!";
                    return;
                }
                // --------- GTEL-Phạm Đức NC 18-09-2025 9h:00 thêm logic insert thông tin lịch sử vào  vao bang AHS_BICANBICAO_HISTORY-------------
                AHS_BICANBICAO_NC_BL ahsBiCanNcBl = new AHS_BICANBICAO_NC_BL();

                // Lấy thêm thông tin BICAN từ bảng AHS_BICANBICAO_C06
                string jsonObject = JsonConvert.SerializeObject(obj, Formatting.Indented); // lưu đạng json 
                string tkSua = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                string nguoiSua = Session[ENUM_SESSION.SESSION_USERTEN] + "";
                ahsBiCanNcBl.AHS_BICAN_HISTORY_INSERT(nguoiSua, tkSua, jsonObject, BiCaoID); // insert vào bảng lịch sử
                // --------- END GTEL-Phạm Đức NC 18-09-2025 9h:00 thêm logic insert thông tin lịch sử vào  vao bang AHS_BICANBICAO_HISTORY-------------
            }

            obj.LOAITOIPHAMHS_ID = Convert.ToDecimal(dropLoaiToiPham.SelectedValue);
            obj.VUANID = VuAnId;
            obj.MABICAN = "";
            obj.LOAIDOITUONG = Convert.ToInt16(dropDoiTuongPhamToi.SelectedValue);

            if (dropDoiTuongPhamToi.SelectedValue == "0")
            {
                obj.BICANDAUVU = Convert.ToInt16(rdBiCanDauVu.SelectedValue);
                obj.PHAPNHANCHINH = 0;

                obj.HOTEN = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
                obj.TENKHAC = Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim());
                obj.SOCMND = txtCMND.Text;
                obj.QUOCTICHID = Convert.ToDecimal(dropQuocTich.SelectedValue);
                obj.DANTOCID = Convert.ToDecimal(dropDanToc.SelectedValue);

                obj.TONGIAOID = Convert.ToDecimal(dropTonGiao.SelectedValue);
                obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);

                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYSINH = date_temp;
                if (date_temp != DateTime.MinValue)
                {
                    obj.THANGSINH = Convert.ToDecimal(date_temp.Month);
                }
                obj.NAMSINH = Convert.ToDecimal(txtNamSinh.Text);

                obj.CHUCVUCHINHQUYENID = Convert.ToDecimal(rdChuvVuCQ.SelectedValue);
                obj.CHUCVUDANGID = Convert.ToDecimal(rdChucVuDang.SelectedValue);

                date_temp = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                    obj.NGAYTHAMGIA = date_temp;
                else
                    obj.NGAYTHAMGIA = null;

                obj.TAMTRU = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
                obj.TAMTRU_HUYEN = Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue);
                obj.TAMTRUCHITIET = txtTamtru_Chitiet.Text;

                obj.HKTT = Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue);
                obj.HKTT_HUYEN = Convert.ToDecimal(ddlHKTT_Huyen.SelectedValue);
                obj.KHTTCHITIET = txtHKTT_Chitiet.Text;

                //-----------------------------------------
                obj.TRINHDOVANHOAID = Convert.ToDecimal(dropTrinhDoVH.SelectedValue);
                obj.TINHTRANGGIAMGIUID = Convert.ToDecimal(dropTinhTrangGiamGiu.SelectedValue);

                //-----------------------------------------
                obj.ISTREVITHANHNIEN = Convert.ToInt16(rdTreViThanhNien.SelectedValue);
                if (obj.ISTREVITHANHNIEN == 0)
                {
                    obj.TREMOCOI = obj.TREBOHOC = obj.TRELANGTHANG = obj.BOMELYHON = obj.CONGUOIXUIGIUC = 0;
                }
                else
                {
                    obj.TREMOCOI = Convert.ToInt16(rdTreMoCoi.SelectedValue);
                    obj.TREBOHOC = Convert.ToInt16(rdTreBoHoc.SelectedValue);
                    obj.TRELANGTHANG = Convert.ToInt16(rdTreLangThang.SelectedValue);
                    obj.BOMELYHON = Convert.ToInt16(rdLyHon.SelectedValue);
                    obj.CONGUOIXUIGIUC = Convert.ToInt16(rdNguoiXuiGiuc.SelectedValue);
                }
                obj.TUOI = (string.IsNullOrEmpty(txtTuoi.Text)) ? 0 : Convert.ToDecimal(txtTuoi.Text);
                //-----------------------------------------
                obj.IS_THANTHICH_BH = Convert.ToDecimal(rdQuanHeThanThich.SelectedValue);
                obj.IS_QUENBIET_BH = Convert.ToDecimal(rdQuanHeQuenBiet.SelectedValue);
                //-----------------------------------------
                obj.NGHIENHUT = Convert.ToInt16(rdNGhienHut.SelectedValue);
                obj.TAIPHAM = Convert.ToInt16(rdTinhTrangTaiPham.SelectedValue);
                //-----------------------------------------
                obj.TIENAN = (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text + "");
                obj.TIENSU = (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text + "");

                obj.NGHENGHIEPID = Convert.ToInt32(dropNgheNghiep.SelectedValue);

                //thêm địa bàn phạm tội
                obj.DIABAN_PHAMTOI = Convert.ToInt32(ddlDiaBanPT.SelectedValue);

                //Thêm tháng tuổi khi phạm tội
                obj.THANG_TUOI = (string.IsNullOrEmpty(txtThang.Text)) ? 0 : Convert.ToDecimal(txtThang.Text);


                // GTEL-HUNGNQ 10-10-2025 chuyển từ store sang entity
                obj.SO_CCCD = txtCCCD.Text;
                obj.SO_HOCHIEU = txtHoChieu.Text;
                obj.CHK_KHONG_CO = chkKhongCoBC.Checked ? "1" : "0";

                //Trạng thái Xac thuc Du lieu quoc gia của duong su
                if (chkKhongLamSachBC.Checked)
                {
                    obj.XACTHUC_DLDCQG = "2"; // ngươi dùng xác nhận không làm sạch được
                }
                else
                {
                    if (hdTrangThaiXacThuc.Value != "1")
                        obj.XACTHUC_DLDCQG = "0";
                    else
                        obj.XACTHUC_DLDCQG = hdTrangThaiXacThuc.Value;
                }
                //END
            }
            else
            {
                obj.BICANDAUVU = 0;
                obj.PHAPNHANCHINH = Convert.ToDecimal(rdPhapNhanChinh.SelectedValue);

                obj.HOTEN = Cls_Comon.FormatTenRieng(txtTenPhapNhan.Text.Trim());
                obj.GIAYPHEPKINHDOANH = txtGiayPhepKD.Text;

                obj.DIACHIDANGKY_TINH = Convert.ToDecimal(ddlDC_DangKy_Tinh.SelectedValue);
                obj.DIACHIDANGKY_HUYEN = Convert.ToDecimal(ddlDC_DangKy_Huyen.SelectedValue);
                obj.DIACHIDANGKY_CHITIET = txtDC_DangKy_ChiTiet.Text;

                obj.DIACHIHOATDONG_TINH = Convert.ToDecimal(ddlDC_HoatDong_Tinh.SelectedValue);
                obj.DIACHIHOATDONG_HUYEN = Convert.ToDecimal(ddlDC_HoatDong_Huyen.SelectedValue);
                obj.DIACHIHOATDONG_CHITIET = txtDC_HoatDong_ChiTiet.Text;

                obj.SDT = txtSDT.Text;
                obj.FAX = txtFax.Text;
                obj.VONNHANUOC = Convert.ToDecimal(rdVonNhaNuoc.SelectedValue);
                obj.VONNUOCNGOAI = Convert.ToDecimal(rdVonNuocNgoai.SelectedValue);
                obj.TIENAN = (string.IsNullOrEmpty(txtTienAn_PhapNhan.Text + "")) ? 0 : Convert.ToInt32(txtTienAn_PhapNhan.Text + "");
                obj.TIENSU = (string.IsNullOrEmpty(txtTienSu_PhapNhan.Text + "")) ? 0 : Convert.ToInt32(txtTienSu_PhapNhan.Text + "");
                obj.TAIPHAM = Convert.ToInt16(rdTaiPham_PhapNhan.SelectedValue);

                //--------------------------------------------------------------
                //Người đại diện
                obj.TENKHAC = Cls_Comon.FormatTenRieng(txtTenDaiDien.Text.Trim());
                obj.CHUCVU_DAIDIEN = txtChucVu.Text;

                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaySinh_DD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaySinh_DD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYSINH = date_temp;
                if (date_temp != DateTime.MinValue)
                {
                    obj.THANGSINH = Convert.ToDecimal(date_temp.Month);
                }
                obj.NAMSINH = Convert.ToDecimal(txtNamSinh_DD.Text);
                obj.QUOCTICHID = Convert.ToDecimal(ddlQuocTich_DD.SelectedValue);
                obj.SOCMND = txtCMND_DD.Text;
                obj.GIOITINH = Convert.ToDecimal(ddlGioiTinh_DD.SelectedValue);

                obj.TAMTRU = Convert.ToDecimal(ddlCuTru_DD_Tinh.SelectedValue);
                obj.TAMTRU_HUYEN = Convert.ToDecimal(ddlCuTru_DD_Huyen.SelectedValue);
                obj.TAMTRUCHITIET = txtCuTru_DD_ChiTiet.Text;

                obj.SDT_DAIDIEN = txtSTT_DD.Text;
                //--------------------------------------------------------------
            }

            if (BiCaoID > 0)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_BICANBICAO.Add(obj);
                dt.SaveChanges();
            }

            //----------------------------------------
            BiCaoID = obj.ID;
            hddID.Value = BiCaoID.ToString();

            //----------------------------------------- 
            //if (obj.BICANDAUVU == 1)
            //{
            //    List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnId && x.BICANDAUVU == 1
            //                                                            && x.ID != BiCaoID
            //                                                        ).ToList<AHS_BICANBICAO>();
            //    if (lstBC != null && lstBC.Count > 0)
            //    {
            //        foreach (AHS_BICANBICAO objBC in lstBC)
            //            objBC.BICANDAUVU = 0;

            //    }
            //    //Update_TenVuAn(VuAnId, obj.HOTEN, BiCaoID);
            //}
            //dt.SaveChanges();

            Update_NewTenToiDanh();

            #endregion

        }
        void Update_NewTenToiDanh()
        {
            int BiCanDauVu = Convert.ToInt16(rdBiCanDauVu.SelectedValue);
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            Decimal currID = 0, currToiDanhID = 0;
            int count_tt = 0;
            String tentoidanh = "";
            AHS_SOTHAM_CAOTRANG_DIEULUAT objTD = null;

            foreach (RepeaterItem item in rpt.Items)
            {
                currID = 0;
                count_tt++;

                HiddenField hddCurrID = (HiddenField)item.FindControl("hddCurrID");
                HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                TextBox txtTenToiDanh = (TextBox)item.FindControl("txtTenToiDanh");
                HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                HiddenField hddLoaiToiPham = (HiddenField)item.FindControl("hddLoaiToiPham");
                if (hddLoai.Value == "2")
                {
                    currToiDanhID = Convert.ToDecimal(hddToiDanhID.Value);
                    currID = Convert.ToDecimal(hddCurrID.Value);

                    if (String.IsNullOrEmpty(txtTenToiDanh.Text.Trim()))
                    {
                        DM_BOLUAT_TOIDANH objDM = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == currToiDanhID).Single<DM_BOLUAT_TOIDANH>();
                        tentoidanh = objDM.TENTOIDANH;
                    }
                    else
                        tentoidanh = txtTenToiDanh.Text.Trim();
                    //
                    if (BiCanDauVu == 1 && count_tt == 1)
                    {
                        //Update ten vu an
                        AHS_VUAN objVA = dt.AHS_VUAN.Where(x => x.ID == VuAnID).Single();
                        objVA.LOAITOIPHAMID = Convert.ToInt16(hddLoaiToiPham.Value);
                        dt.SaveChanges();
                    }

                    objTD = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == currID
                                                                    && x.VUANID == VuAnID
                                                                    && x.BICANID == BiCanID).FirstOrDefault();
                    if (objTD != null)
                    {
                        objTD.TENTOIDANH = tentoidanh;
                        //objTD.ISMAIN = (count_tt == 1) ? 1 : 0;
                    }
                }
            }
            dt.SaveChanges();
        }


        void Update_NhanThan(string QHNhanThan, HiddenField hddNhanThanID, TextBox txtHoTen, TextBox txtNamSinh, TextBox txtDiaChi, TextBox txtGhiChu)
        {
            Boolean IsUpdate = false;
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal MoiQuanHeNhanThanID = 0;
            try
            { MoiQuanHeNhanThanID = dt.DM_DATAITEM.Where(x => x.MA == QHNhanThan).FirstOrDefault().ID; }
            catch (Exception ex) { }

            Decimal NhanThanID = (String.IsNullOrEmpty(hddNhanThanID.Value)) ? 0 : Convert.ToDecimal(hddNhanThanID.Value);
            AHS_BICAN_NHANTHAN obj = null;
            if (NhanThanID == 0)
                obj = new AHS_BICAN_NHANTHAN();
            else
            {
                obj = dt.AHS_BICAN_NHANTHAN.Where(x => x.ID == NhanThanID).Single();
                if (obj != null)
                    IsUpdate = true;
            }

            obj.VUANID = VuAnID;
            obj.BICANID = BiCanID;
            obj.MOIQUANHEID = MoiQuanHeNhanThanID;
            obj.HOTEN = Cls_Comon.FormatTenRieng(txtHoTen.Text.Trim());

            obj.NGAYSINH_NAM = (String.IsNullOrEmpty(txtNamSinh.Text.Trim())) ? 0 : Convert.ToDecimal(txtNamSinh.Text);
            ;
            obj.HKTT_CHITIET = txtDiaChi.Text.Trim();
            obj.GHICHU = txtGhiChu.Text.Trim();
            //-----------------------------------------
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.AHS_BICAN_NHANTHAN.Add(obj);
                dt.SaveChanges();
            }
        }


        #region from toi danh    

        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {
            //Nguoi dung co the chọn bộ luật + nhap diem, khoan , dieu
            // Tu dong search ra luat tuong ung trong DM_BoLuat_ToiDanh 
            // Them vao DB toi danh tim duoc
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgT.Text = lstMsgB.Text = Result;
                cmdThemDieuLuat.Enabled = false;
                return;
            }
            lbthongbao.Text = "";
            Update_BiCao();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            if (BiCanID > 0)
            {
                decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                String Diem = txtDiem.Text.Trim();
                string Khoan = txtKhoan.Text.Trim();
                String Dieu = txtDieu.Text.Trim();

                DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
                int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
                DataTable tbl = objBL.SearchChinhXacTheoDK(luatid, Diem, Khoan, Dieu);
                if (tbl != null && tbl.Rows.Count == 1)
                {
                    foreach (DataRow row in tbl.Rows)
                        SaveToiDanh(row);
                    //-----------------------
                    hddPageIndex.Value = "1";
                    LoadGridToiDanh();
                    txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
                }
                else
                {
                    lbthongbao.Text = "Không có điều luật, tội danh này!";
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), cmdThemDieuLuat.ClientID);
        }

        void SaveToiDanh(DataRow rowToiDanh)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid = Convert.ToDecimal(rowToiDanh["ID"] + "");

            //Lay ds cac cap cha cua toi danh duoc chon
            String ArrSapXep = "";
            String[] arrToiDanh = null;
            ArrSapXep = rowToiDanh["ArrSapXep"] + "";
            arrToiDanh = ArrSapXep.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh(BiCanID, VuAnID, toidanhid);
                    }
                }
                dt.SaveChanges();
            }

            lstMsgT.Text = lstMsgB.Text = "Lưu điều luật áp dụng cho bị can thành công!";
        }
        void InsertToiDanh(Decimal BiCanID, Decimal VuAnID, Decimal toidanhid)
        {
            bool isupdate = false;
            DM_BOLUAT_TOIDANH objTD = null;
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            try
            {
                obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                && x.VUANID == VuAnID
                                                                && x.TOIDANHID == toidanhid
                                                            ).Single<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                if (obj != null)
                    isupdate = true;
                else
                    obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT(); }
            if (!isupdate)
            {
                obj.BICANID = BiCanID;
                obj.CAOTRANGID = 0;
                obj.VUANID = VuAnID;
                obj.DIEULUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
                obj.TOIDANHID = toidanhid;
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                obj.TENTOIDANH = objTD.TENTOIDANH;
                obj.ISMAIN = 0;
                // insert toa_gq_id
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
                dt.SaveChanges();
            }
        }
        public void LoadGridToiDanh()
        {
            lbthongbao.Text = "";
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            Decimal BiCanID = Convert.ToDecimal(hddID.Value);

            if (BiCanID > 0)
            {
                pnToiDanh.Visible = true;
                int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);

                AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();

                DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, luatid, 0, "", pageindex, pagesize);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                    lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion

                    rpt.DataSource = tbl;
                    rpt.DataBind();
                    pndata.Visible = true;
                }
                else
                {
                    pndata.Visible = false;
                    lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
                }
            }
            LoadBtnChonTDC();
            LoadToiDanhChinh();
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                //bool IsShowCommand = Convert.ToBoolean(hddShowCommand.Value);
                //if (IsShowCommand)
                //    lkXoa.Visible = true;
                //else
                //    lkXoa.Visible = false;
                //if (hddShowCommand.Value == "False")
                //{
                //    lkXoa.Visible = false;
                //}

                var thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID);
                if (thuly != null && thuly.Count() > 0)
                    lkXoa.Visible = false;
                else
                    lkXoa.Visible = true;
            }
        }

        protected void cmdGetToiDanhDauVu_Click(object sender, EventArgs e)
        {
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgT.Text = lstMsgB.Text = Result;
                cmdGetToiDanhDauVu.Enabled = false;
                return;
            }
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = null;
            Decimal BiCanDauVuID = 0;

            try
            {
                AHS_BICANBICAO objBCDV = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                if (objBCDV != null)
                {
                    BiCanDauVuID = Convert.ToDecimal(objBCDV.ID);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Không tìm thấy bị can đầu vụ!";
            }

            Update_BiCao();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            if (BiCanID > 0)
            {
                //lay ds toi danh ap dung cua bi can dau vu va them vao cho bị can dang nhap
                List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == BiCanDauVuID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                if (lst != null && lst.Count > 0)
                {
                    Boolean isupdate = false;
                    Decimal toidanhid = 0, boluatid = 0;
                    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT item in lst)
                    {
                        isupdate = false;
                        obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                        try
                        {
                            toidanhid = (Decimal)item.TOIDANHID;
                            boluatid = (Decimal)item.DIEULUATID;
                            obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                            && x.VUANID == VuAnID
                                                                            && x.DIEULUATID == boluatid
                                                                            && x.TOIDANHID == toidanhid
                                                                        ).Single<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                            if (obj != null)
                                isupdate = true;
                            else
                                obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                        }
                        catch (Exception ex) { obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT(); }
                        if (!isupdate)
                        {
                            obj.BICANID = BiCanID;
                            obj.VUANID = VuAnID;
                            obj.DIEULUATID = boluatid;
                            obj.TOIDANHID = toidanhid;
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            obj.TENTOIDANH = item.TENTOIDANH + "";
                            obj.ISMAIN = String.IsNullOrEmpty(item.ISMAIN + "") ? 0 : item.ISMAIN;
                            // insert toa_gq_id
                            if (obj.TOA_GIAIQUYET_ID == null)
                            {
                                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
                        }
                    }
                    dt.SaveChanges();

                    hddPageIndex.Value = "1";
                    LoadGridToiDanh();
                    Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                }
            }
        }
        protected void cmdLoadDsToiDanh_Click(object sender, EventArgs e)
        {
            LoadGridToiDanh();
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                try
                {
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstMsgT.Text = lstMsgB.Text = Result;
                        return;
                    }
                    xoatoidanh(curr_id);
                }
                catch { }
            }
        }
        void xoatoidanh(decimal toidanhid)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value + "")) ? 0 : Convert.ToDecimal(hddID.Value);

            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID
                                                               && x.BICANID == BiCanID
                                                               && x.TOIDANHID == toidanhid
                                                             ).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT obj in lst)
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGridToiDanh();
            lbthongbao.Text = "Xóa thành công!";
            Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
        }
        protected void lkChoiceToiDanh_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValidate())
                    return;
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    lkChoiceToiDanh.Enabled = false;
                    return;
                }
                Save_BiCan();
                decimal BiCaoID = Convert.ToDecimal(hddID.Value);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "popupChonToiDanh(" + VuAnID + "," + BiCaoID + ")");
            }
            catch (EntityDataSourceValidationException e1)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi Entities: " + e1.Message;
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                string strErr = "";
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                    }
                }
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Có lỗi, hãy thử lại: " + strErr;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message + " | " + ex.InnerException.ToString(); }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        #region Form Bien phap ngan chan
        protected void rdNganChan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdNganChan.SelectedValue == "1")
            {
                pnBienPhapNganChan.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), dropBienPhapNganChan.ClientID);
            }
            else
            {
                pnBienPhapNganChan.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropBoLuat.ClientID);
            }
        }
        private void LoadBienPhapNCTheoBiCaoID(decimal BiCaoID)
        {
            AHS_SOTHAM_BIENPHAPNGANCHAN obj = null;
            try
            {
                obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == BiCaoID).Single<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                pnBienPhapNganChan.Visible = true;
                rdNganChan.SelectedValue = "1";
                dropDV.SelectedValue = obj.DONVIRAQD.ToString();
                dropBienPhapNganChan.SelectedValue = obj.BIENPHAPNGANCHANID.ToString();

                if (obj.NGAYBATDAU != DateTime.MinValue)
                    txtNgayBatDau.Text = ((DateTime)obj.NGAYBATDAU).ToString("dd/MM/yyyy", cul);

                if (obj.NGAYKETTHUC != DateTime.MinValue)
                    txtNgayKT.Text = ((DateTime)obj.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);

            }
            else
            {
                pnBienPhapNganChan.Visible = false;
                rdNganChan.SelectedValue = "0";
            }
        }
        void SaveBienPhapNC(Decimal BiCanID)
        {
            Boolean IsUpdate = false;
            AHS_SOTHAM_BIENPHAPNGANCHAN obj = new AHS_SOTHAM_BIENPHAPNGANCHAN();
            try
            {
                if (BiCanID > 0)
                {
                    obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == BiCanID && x.VUANID == VuAnID).Single<AHS_SOTHAM_BIENPHAPNGANCHAN>();
                    IsUpdate = true;
                    if (rdNganChan.SelectedValue == "0")
                    {
                        //Xoa bien phap ngan chan
                        dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Remove(obj);
                        dt.SaveChanges();
                    }
                }
                else
                    obj = new AHS_SOTHAM_BIENPHAPNGANCHAN();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_BIENPHAPNGANCHAN(); }
            // { lbthongbao.Text = ex.Message + " | " + ex.InnerException.ToString(); }

            if (rdNganChan.SelectedValue != "0")
            {
                obj.VUANID = VuAnID;
                obj.BICANID = BiCanID;
                obj.DONVIRAQD = Convert.ToDecimal(dropDV.SelectedValue);
                obj.BIENPHAPNGANCHANID = Convert.ToDecimal(dropBienPhapNganChan.SelectedValue);
                obj.HIEULUC = 1;// Convert.ToInt16(rdHieuLuc.SelectedValue);

                // obj.GHICHU = txtGhiChu.Text.Trim();
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgayBatDau.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBatDau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYBATDAU = date_temp;

                date_temp = (String.IsNullOrEmpty(txtNgayKT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYKETTHUC = date_temp;

                if (IsUpdate)
                {
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                else
                {
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(obj);
                    dt.SaveChanges();
                }
            }
        }

        #endregion

        #region Thong tin nhan than bi cao 
        void LoadDsNhanThanBiCao()
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            DataTable tblOther = null;
            AHS_BICAN_NHANTHAN_BL objBL = new AHS_BICAN_NHANTHAN_BL();
            DataTable tbl = objBL.GetByVuAn_BiAnID(VuAnID, BiCanID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblOther = tbl.Clone();
                Decimal curr_qh_id = 0;
                String MoiQuanHeNT = "";
                int count_index = 0;
                int count_all = 0;
                DataRow[] arr = null;
                DataRow row = null;
                DataView view = new DataView(tbl);
                DataTable tblMoiQH = view.ToTable(true, "MoiQuanHeID", "MaMoiQH");

                foreach (DataRow rowQH in tblMoiQH.Rows)
                {
                    curr_qh_id = Convert.ToDecimal(rowQH["MoiQuanHeID"] + "");
                    MoiQuanHeNT = rowQH["MaMoiQH"] + "";
                    switch (MoiQuanHeNT)
                    {
                        case ENUM_QH_NHANTHAN.BO:
                            arr = tbl.Select("MoiQuanHeID=" + curr_qh_id);
                            row = arr[0];
                            hddNT_Bo.Value = row["ID"].ToString();
                            txtBo_HoTen.Text = row["HoTen"].ToString();
                            txtBo_NamSinh.Text = row["NgaySinh_Nam"].ToString() != "0" ? (row["NgaySinh_Nam"] + "") : "";
                            txtBo_Diachi.Text = row["HKTT_CHITIET"].ToString();
                            txtBo_GhiChu.Text = row["GhiChu"].ToString();
                            break;
                        case ENUM_QH_NHANTHAN.ME:
                            arr = tbl.Select("MoiQuanHeID=" + curr_qh_id);
                            row = arr[0];
                            hddNT_Me.Value = row["ID"].ToString();
                            txtMe_HoTen.Text = row["HoTen"].ToString();
                            txtMe_NamSinh.Text = row["NgaySinh_Nam"].ToString() != "0" ? (row["NgaySinh_Nam"] + "") : "";
                            txtMe_Diachi.Text = row["HKTT_CHITIET"].ToString();
                            txtMe_GhiChu.Text = row["GhiChu"].ToString();
                            break;
                        case ENUM_QH_NHANTHAN.VO_CHONG:
                            arr = tbl.Select("MoiQuanHeID=" + curr_qh_id);
                            row = arr[0];
                            hddNT_BanDoi.Value = row["ID"].ToString();
                            txtBanDoi_HoTen.Text = row["HoTen"].ToString();
                            txtBanDoi_NamSinh.Text = row["NgaySinh_Nam"].ToString() != "0" ? (row["NgaySinh_Nam"] + "") : "";
                            txtBanDoi_Diachi.Text = row["HKTT_CHITIET"].ToString();
                            txtBanDoi_GhiChu.Text = row["GhiChu"].ToString();
                            break;
                        case ENUM_QH_NHANTHAN.CON:
                            arr = tbl.Select("MoiQuanHeID=" + curr_qh_id);
                            if (arr != null && arr.Length > 0)
                            {
                                count_all = arr.Length;
                                foreach (DataRow rowcon in arr)
                                {
                                    count_index++;

                                    if (count_index <= 2)
                                    {
                                        if (count_index == 1)
                                        {
                                            hddNT_Con1.Value = rowcon["ID"].ToString();
                                            txtCon1_HoTen.Text = rowcon["HoTen"].ToString();
                                            txtCon1_NamSinh.Text = rowcon["NgaySinh_Nam"].ToString() != "0" ? (rowcon["NgaySinh_Nam"] + "") : "";
                                            txtCon1_Diachi.Text = rowcon["HKTT_CHITIET"].ToString();
                                            txtCon1_GhiChu.Text = rowcon["GhiChu"].ToString();
                                        }
                                        else
                                        {
                                            hddNT_Con2.Value = rowcon["ID"].ToString();
                                            txtCon2_HoTen.Text = rowcon["HoTen"].ToString();
                                            txtCon2_NamSinh.Text = rowcon["NgaySinh_Nam"].ToString() != "0" ? (rowcon["NgaySinh_Nam"] + "") : "";
                                            txtCon2_Diachi.Text = rowcon["HKTT_CHITIET"].ToString();
                                            txtCon2_GhiChu.Text = rowcon["GhiChu"].ToString();
                                        }
                                    }
                                    else
                                    {
                                        DataRow[] arrtemp = tblOther.Select("ID=" + rowcon["ID"].ToString());
                                        if (arrtemp == null || arrtemp.Length == 0)
                                            tblOther.Rows.Add(rowcon.ItemArray);
                                    }
                                }

                            }
                            break;
                    }
                }
                //---------------------
                if (count_all > 2)
                {
                    rptOtherNT.Visible = true;
                    rptOtherNT.DataSource = tblOther;
                    rptOtherNT.DataBind();
                }
                else
                    rptOtherNT.Visible = false;
            }
        }
        private void ResetControlNhanThan()
        {
            hdHoTenCha.Value = txtBo_HoTen.Text = txtBo_NamSinh.Text = txtBo_GhiChu.Text = txtBo_Diachi.Text = "";
            hdHoTenMe.Value = txtMe_HoTen.Text = txtMe_NamSinh.Text = txtMe_GhiChu.Text = txtMe_Diachi.Text = "";
            hdHoTenVoChong.Value = txtBanDoi_HoTen.Text = txtBanDoi_NamSinh.Text = txtBanDoi_GhiChu.Text = txtBanDoi_Diachi.Text = "";
            txtCon1_HoTen.Text = txtCon1_NamSinh.Text = txtCon1_GhiChu.Text = txtCon1_Diachi.Text = "";
            txtCon2_HoTen.Text = txtCon2_NamSinh.Text = txtCon2_GhiChu.Text = txtCon2_Diachi.Text = "";
            hddNT_BanDoi.Value = hddNT_Bo.Value = hddNT_Con1.Value = hddNT_Con2.Value = hddNT_Me.Value = "";
            rptOtherNT.Visible = false;
        }
        protected void rptOtherNT_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lttMsgNT.Text = "Bạn không có quyền xóa dữ liệu";
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstMsgT.Text = lstMsgB.Text = Result;
                        return;
                    }
                    xoa_nhanthan(curr_id);

                    break;
            }
        }
        public void xoa_nhanthan(decimal id)
        {
            AHS_BICAN_NHANTHAN oT = dt.AHS_BICAN_NHANTHAN.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_BICAN_NHANTHAN.Remove(oT);
            dt.SaveChanges();

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa dữ liệu thành công!");
            LoadDsNhanThanBiCao();
        }
        #endregion
        protected void lkThemCon_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            if (!CheckValidate())
                return;
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstMsgT.Text = lstMsgB.Text = Result;
                lkThemCon.Enabled = false;
                return;
            }
            Save_BiCan();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_nhanthan(" + VuAnID + "," + BiCanID + ")");
        }

        //sự kiện Click Chọn tội danh chính
        protected void btnChonToiDanhChinh_Click(object sender, EventArgs e)
        {
            LoadToiDanhChinh();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "hienPopup();", true);
        }
        protected void LoadToiDanhChinh()
        {
            Decimal BiCanID = Convert.ToDecimal(hddID.Value);
            AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();

            DataTable tbl = objBL.GetToiDanh_To_TDC(BiCanID, VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dgToiDanhChinh.DataSource = tbl;
                dgToiDanhChinh.DataBind();
            }
        }

        protected void btnSaveTDC_OnClick(object sender, EventArgs e)
        {
            Decimal BiCanID = Convert.ToDecimal(hddID.Value);
            Decimal sotham_caotrang_dieuluat_id = 0;
            foreach (RepeaterItem item in dgToiDanhChinh.Items)
            {
                CheckBox chk = item.FindControl("chkLuaChon") as CheckBox;
                if (chk.Checked)
                {
                    HiddenField hd_ID = item.FindControl("hddID_ToiDanh") as HiddenField;
                    sotham_caotrang_dieuluat_id = Convert.ToDecimal(hd_ID?.Value + "");
                }
            }
            if (sotham_caotrang_dieuluat_id > 0)
            {
                var obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == sotham_caotrang_dieuluat_id).FirstOrDefault();
                //obj.IS_TOIDANHCHINH = 1;
                obj.ISMAIN = 1;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();

                //set tội danh chính của các cáo trạng khác là 0
                var lstObj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID != sotham_caotrang_dieuluat_id && x.BICANID == BiCanID && x.VUANID == VuAnID).ToList();
                if (lstObj != null && lstObj.Count != 0)
                {
                    foreach (var itm in lstObj)
                    {
                        if (itm.ISMAIN == 1)
                        {
                            itm.ISMAIN = 0;
                            obj.NGAYSUA = DateTime.Now;
                            obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                    }
                }
            }
            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Chọn tội danh chính thành công!");
            LoadGridToiDanh();
            Cls_Comon.SetFocus(this, this.GetType(), btnChonToiDanhChinh.ClientID);
        }

        protected void dropDoiTuongPhamToi_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckPhapNhanChinh();
            pnBiCanDauVu.Visible = dropDoiTuongPhamToi.SelectedValue == "0" ? true : false;
            pnPhapNhanChinh.Visible = !pnBiCanDauVu.Visible;
            pnCaNhan.Visible = pnNhanThanBC.Visible = dropDoiTuongPhamToi.SelectedValue == "0";
            pnPhapNhan.Visible = pnNguoiDaiDien.Visible = dropDoiTuongPhamToi.SelectedValue != "0";
        }

        protected bool CheckToiDanh(object val)
        {
            return val != null && val.ToString() == "1";
        }

        protected void LoadBtnChonTDC()
        {
            Decimal BiCanID = Convert.ToDecimal(hddID.Value);
            var caotrang_dieuluat_ds = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID && x.VUANID == VuAnID);
            if (caotrang_dieuluat_ds.Count() == 0)
                btnChonToiDanhChinh.Visible = false;
            else
                btnChonToiDanhChinh.Visible = true;
        }

        //------------------Check chọn tội danh chính
        private bool CheckTonTaiTDC()
        {
            Decimal BiCanID = Convert.ToDecimal(hddID.Value);
            int count = 0;
            var caotrang_dieuluat_ds = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID && x.VUANID == VuAnID);
            var dm_toidanh_ds = new List<DM_BOLUAT_TOIDANH>();

            if (caotrang_dieuluat_ds != null && caotrang_dieuluat_ds.Count() > 0)
            {
                var dsToiDanhID = caotrang_dieuluat_ds.Select(o => o.TOIDANHID).ToList();
                dm_toidanh_ds = dt.DM_BOLUAT_TOIDANH.Where(x => dsToiDanhID.Contains(x.ID) && x.KHOAN == null && x.DIEM == null).ToList();
                foreach (var data in caotrang_dieuluat_ds)
                {
                    if (data.ISMAIN == 1)
                        count++;
                }
            }

            //Nếu trong danh sách chỉ có 1 tội danh thì mặc định nó là tội danh chính
            if (dm_toidanh_ds.Count() == 1)
            {
                var firstToiDanh = dm_toidanh_ds.FirstOrDefault();
                if (firstToiDanh != null)
                {
                    var obj = caotrang_dieuluat_ds.FirstOrDefault(x => x.TOIDANHID == firstToiDanh.ID);
                    obj.ISMAIN = 1;
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                    return true;
                }

            }
            if (count == 0)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa chọn tội danh chính cho bị can/ bị cáo!");
                Cls_Comon.SetFocus(this, this.GetType(), btnChonToiDanhChinh.ClientID);
                return false;
            }
            return true;
        }

        #region GTEL-Phạm Đức NC: 13-09-20259h:00 xử lý thêm các logic cho form bị can lấy dữ liệu từ API 037 và fill vào form
        // Thêm kiểm tra thông tin từ CSDLQG và fill thông tin vào form
        protected void btnGet037_Click(object sender, EventArgs e)
        {
            string quocTich = dropQuocTich.SelectedValue;
            if (quocTich == "2")
            {
                string soDinhDanh = txtCCCD.Text.Trim();

                if (string.IsNullOrEmpty(soDinhDanh))
                {
                    string strMsg = "Vui lòng nhập Thẻ căn cước của Bị cáo!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                if (soDinhDanh.Length != 12)
                {
                    string strMsg = "Thẻ căn cước của Bị cáo bao gồm 12 ký tự số!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string HoTen = txtTen.Text.Trim();
                if (string.IsNullOrEmpty(HoTen))
                {
                    string strMsg = "Vui lòng nhập Họ và Tên của Bị cáo!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinh = txtNamSinh.Text.Trim();
                if (string.IsNullOrEmpty(NamSinh))
                {
                    string strMsg = "Vui lòng nhập Năm sinh của Bị cáo!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                string NamSinhFormat = "";

                if (!string.IsNullOrWhiteSpace(NamSinh) && NamSinh.Length == 8)
                {
                    try
                    {
                        DateTime dt = DateTime.ParseExact(NamSinh, "ddMMyyyy", System.Globalization.CultureInfo.InvariantCulture);
                        NamSinhFormat = dt.ToString("yyyyMMdd");
                    }
                    catch (FormatException)
                    {
                        // Handle lỗi nếu không đúng định dạng
                        string strMsg = "Năm sinh không đúng định dạng, Vui long kiểm tra lại!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }
                }
                else
                {
                    NamSinhFormat = NamSinh;
                }


                var client = new CallApi037();
                // Gọi phương thức async theo kiểu đồng bộ (blocking)
                string vMadonvi = Session[ENUM_SESSION.SESSION_MADONVI] + "";
                string vTenTaiKHoan = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                decimal CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                QT_NGUOISUDUNG oTaiK = null;
                DM_CANBO oCanBo = null;
                if (CurrUserID > 0)
                {
                    oTaiK = dt.QT_NGUOISUDUNG.Where(x => x.ID == CurrUserID).First();
                    if (oTaiK != null)
                        oCanBo = dt.DM_CANBO.Where(x => x.ID == oTaiK.CANBOID).FirstOrDefault();
                }
                string vSoCCCDTaiKHoan = null;
                string result = "";
                if (oCanBo != null)
                {
                    if (oCanBo.SOCCCD != null)
                    {
                        vSoCCCDTaiKHoan = oCanBo.SOCCCD.ToString();

                        // Tạm comment để fake dữ liệu chú ý mở ra khi build


                        result = client.SendRequestAsync(vMadonvi, vSoCCCDTaiKHoan, vTenTaiKHoan, soDinhDanh, ConvertToUnsign(HoTen), NamSinhFormat)
                                           .GetAwaiter()
                                           .GetResult();
                    }
                    else
                    {
                        string strMsg = "Cán bộ Tòa án chưa được cập nhật số định danh cá nhân nên không dùng được chức năng Kiểm tra này!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }

                }

                if (result == "Err")
                {

                    string strMsg = "Lỗi hệ thống, đề nghị liên hệ với Quản trị viên!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                //Luu goi API thành công thì lưu
                DLQGC06_BL oBL = new DLQGC06_BL();
                decimal CANBO_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                DM_CANBO canBo = dt.DM_CANBO.Where(x => x.ID == CANBO_ID).FirstOrDefault();
                string vuAnId = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                string username = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var vLichSu = oBL.HistoryC06_CALL_API037(vuAnId, canBo.SOCMND, canBo.HOTEN, username, result);

                // Xử lý kết quả XML
                CongDan037 CongDan = ParseSoapResponse(result);
                //CongDan037 CongDan = ParseSoapResponseFake();
                if (CongDan == null)
                {
                    string strMsg = "Không tồn tại dữ liệu về Bị can! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                else
                {
                    if (CongDan.HoVaTen.Ten == null)
                    {

                        string strMsg = "Không tồn tại dữ liệu về Bị Can! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return;
                    }

                    //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua CCCD và Họ Tên
                    chkKhongLamSachBC.Checked = chkKhongCoBC.Checked = false;
                    txtTen.Enabled = txtCCCD.Enabled = txtNamSinh.Enabled = false;
                    dropQuocTich.Enabled = ddlGioitinh.Enabled = false;
                    hdTrangThaiXacThuc.Value = "1";
                    chkKhongLamSachBC.Checked = false;
                    // GTEL - Ngọc Hải - 20/11/2023 - Disable checkbox "Không có" và "Không làm sạch đươc" sau khi kiểm tra dữ liệu thành công
                    chkKhongCoBC.Enabled = chkKhongLamSachBC.Enabled = false;
                    Session.Remove("CongDan");
                    Session["CongDan"] = CongDan;
                    // bật popup lên
                    string StrMsg = "PopupCenter('/QLAN/AHS/Hoso/Popup/pGetBiCao037.aspx','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                }
            }
            else
            {
                string strMsg = "Chỉ áp dụng với Công dân quốc tịch Việt Nam!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return;
            }
        }
        //Thêm hàm cập nhật thông tin căn cước công dân
        AHS_BICANBICAO_NC_BL bl = new AHS_BICANBICAO_NC_BL();

        private CongDan037 ParseSoapResponse(string xml)
        {
            //Xử lý try catch để fake dữ liệu nếu không gọi được
            try
            {
                CongDan037 citizen = new CongDan037();

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xml);

                XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
                nsmgr.AddNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
                nsmgr.AddNamespace("ns1", "http://www.mic.gov.vn/dancu/1.0");

                // Truy cập chính xác nút <ns1:CongDan>
                XmlNode congDanNode = doc.SelectSingleNode("//soapenv:Envelope/soapenv:Body/ns1:CongdanCollection/ns1:CongDan", nsmgr);

                if (congDanNode == null)
                    return citizen; //

                citizen.SoDinhDanh = congDanNode.SelectSingleNode("ns1:SoDinhDanh", nsmgr)?.InnerText;
                citizen.SoCMND = congDanNode.SelectSingleNode("ns1:SoCMND", nsmgr)?.InnerText;
                citizen.GioiTinh = congDanNode.SelectSingleNode("ns1:GioiTinh", nsmgr)?.InnerText;
                citizen.DanToc = congDanNode.SelectSingleNode("ns1:DanToc", nsmgr)?.InnerText;

                XmlNode ngaySinhNode = congDanNode.SelectSingleNode("ns1:NgayThangNamSinh", nsmgr);
                if (ngaySinhNode != null)
                {
                    citizen.NamSinh = ngaySinhNode.SelectSingleNode("ns1:Nam", nsmgr)?.InnerText;
                    citizen.NgayThangNam = ngaySinhNode.SelectSingleNode("ns1:NgayThangNam", nsmgr)?.InnerText;
                }

                // Trích xuất Họ tên
                XmlNode hoTenNode = congDanNode.SelectSingleNode("ns1:HoVaTen", nsmgr);
                if (hoTenNode != null)
                {
                    citizen.HoVaTen = new HoVaTen
                    {
                        Ho = hoTenNode.SelectSingleNode("ns1:Ho", nsmgr)?.InnerText,
                        ChuDem = hoTenNode.SelectSingleNode("ns1:ChuDem", nsmgr)?.InnerText,
                        Ten = hoTenNode.SelectSingleNode("ns1:Ten", nsmgr)?.InnerText
                    };
                }
                //Nơi đăng ký khai sinh
                XmlNode khaiSinhNode = congDanNode.SelectSingleNode("ns1:NoiDangKyKhaiSinh", nsmgr);
                if (khaiSinhNode != null)
                {
                    citizen.NoiDangKyKhaiSinh = new DiaChi()
                    {
                        MaTinhThanh = khaiSinhNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                        MaPhuongXa = khaiSinhNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                        ChiTiet = khaiSinhNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                    };
                }
                //Dia chi
                //Noi o hien tai
                XmlNode noiOHienTaiNode = congDanNode.SelectSingleNode("ns1:NoiOHienTai", nsmgr);
                if (noiOHienTaiNode != null)
                {
                    citizen.NoiOHienTai = new DiaChi()
                    {
                        MaTinhThanh = noiOHienTaiNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                        MaPhuongXa = noiOHienTaiNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                        ChiTiet = noiOHienTaiNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                    };
                }
                //Que quan
                XmlNode queQuanNode = congDanNode.SelectSingleNode("ns1:QueQuan", nsmgr);
                if (queQuanNode != null)
                {
                    citizen.QueQuan = new DiaChi()
                    {
                        MaTinhThanh = queQuanNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                        MaPhuongXa = queQuanNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                        ChiTiet = queQuanNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                    };
                }
                //Thường trú
                XmlNode thuongTruNode = congDanNode.SelectSingleNode("ns1:ThuongTru", nsmgr);
                if (thuongTruNode != null)
                {
                    citizen.ThuongTru = new DiaChi()
                    {
                        MaTinhThanh = thuongTruNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                        MaPhuongXa = thuongTruNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                        ChiTiet = thuongTruNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                    };
                }
                //Nguoi than
                citizen.Cha = LayThongTinNguoiThan(congDanNode, "ns1:Cha", nsmgr);
                citizen.Me = LayThongTinNguoiThan(congDanNode, "ns1:Me", nsmgr);
                citizen.VoChong = LayThongTinNguoiThan(congDanNode, "ns1:VoChong", nsmgr);
                return citizen;
            }
            catch (Exception ex)
            {
                return new CongDan037();
            }
        }
        private CongDan037 ParseSoapResponseFake()
        {
            CongDan037 citizen = new CongDan037();

            XmlDocument doc = new XmlDocument();
            doc.Load(@"D:\Work\Ducph\Gtel\TANDTC\TTDC_TEST.xml");

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
            nsmgr.AddNamespace("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");
            nsmgr.AddNamespace("ns1", "http://www.mic.gov.vn/dancu/1.0");

            // Truy cập chính xác nút <ns1:CongDan>
            XmlNode congDanNode = doc.SelectSingleNode("//soapenv:Envelope/soapenv:Body/ns1:CongdanCollection/ns1:CongDan", nsmgr);

            if (congDanNode == null)
                return citizen; //

            citizen.SoDinhDanh = congDanNode.SelectSingleNode("ns1:SoDinhDanh", nsmgr)?.InnerText;
            citizen.SoCMND = congDanNode.SelectSingleNode("ns1:SoCMND", nsmgr)?.InnerText;
            citizen.GioiTinh = congDanNode.SelectSingleNode("ns1:GioiTinh", nsmgr)?.InnerText;
            citizen.DanToc = congDanNode.SelectSingleNode("ns1:DanToc", nsmgr)?.InnerText;

            XmlNode ngaySinhNode = congDanNode.SelectSingleNode("ns1:NgayThangNamSinh", nsmgr);
            if (ngaySinhNode != null)
            {
                citizen.NamSinh = ngaySinhNode.SelectSingleNode("ns1:Nam", nsmgr)?.InnerText;
                citizen.NgayThangNam = ngaySinhNode.SelectSingleNode("ns1:NgayThangNam", nsmgr)?.InnerText;
            }

            // Trích xuất Họ tên
            XmlNode hoTenNode = congDanNode.SelectSingleNode("ns1:HoVaTen", nsmgr);
            if (hoTenNode != null)
            {
                citizen.HoVaTen = new HoVaTen
                {
                    Ho = hoTenNode.SelectSingleNode("ns1:Ho", nsmgr)?.InnerText,
                    ChuDem = hoTenNode.SelectSingleNode("ns1:ChuDem", nsmgr)?.InnerText,
                    Ten = hoTenNode.SelectSingleNode("ns1:Ten", nsmgr)?.InnerText
                };
            }
            //Dia chi
            //Noi o hien tai
            XmlNode noiOHienTaiNode = congDanNode.SelectSingleNode("ns1:NoiOHienTai", nsmgr);
            if (noiOHienTaiNode != null)
            {
                citizen.NoiOHienTai = new DiaChi()
                {
                    MaTinhThanh = noiOHienTaiNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = noiOHienTaiNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = noiOHienTaiNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }
            //Que quan
            XmlNode queQuanNode = congDanNode.SelectSingleNode("ns1:QueQuan", nsmgr);
            if (queQuanNode != null)
            {
                citizen.QueQuan = new DiaChi()
                {
                    MaTinhThanh = queQuanNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = queQuanNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = queQuanNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }
            //Thường trú
            XmlNode thuongTruNode = congDanNode.SelectSingleNode("ns1:ThuongTru", nsmgr);
            if (thuongTruNode != null)
            {
                citizen.ThuongTru = new DiaChi()
                {
                    MaTinhThanh = thuongTruNode.SelectSingleNode("ns1:MaTinhThanh", nsmgr)?.InnerText,
                    MaPhuongXa = thuongTruNode.SelectSingleNode("ns1:MaPhuongXa", nsmgr)?.InnerText,
                    ChiTiet = thuongTruNode.SelectSingleNode("ns1:ChiTiet", nsmgr)?.InnerText
                };
            }
            citizen.Cha = LayThongTinNguoiThan(congDanNode, "ns1:Cha", nsmgr);
            citizen.Me = LayThongTinNguoiThan(congDanNode, "ns1:Me", nsmgr);
            citizen.VoChong = LayThongTinNguoiThan(congDanNode, "ns1:VoChong", nsmgr);
            return citizen;
        }
        private NguoiThan LayThongTinNguoiThan(XmlNode node, string path, XmlNamespaceManager nsmgr)
        {
            NguoiThan person = new NguoiThan();
            XmlNode personNode = node.SelectSingleNode(path, nsmgr);
            if (personNode != null)
            {
                person.HoVaTen = new HoVaTen() { Ten = personNode.SelectSingleNode("ns1:HoVaTen", nsmgr).InnerText };
                person.QuocTich = personNode.SelectSingleNode("ns1:QuocTich", nsmgr)?.InnerText;
                person.SoCMND = personNode.SelectSingleNode("ns1:SoCMND", nsmgr)?.InnerText;
            }
            return person;
        }
        // Hàm chuyển tiếng Việt có dấu sang không dấu và viết liền
        public static string ConvertToUnsign(string input)
        {
            if (string.IsNullOrEmpty(input))
                return string.Empty;
            // Xử lý ký tự Đ/đ thủ công
            input = input.Replace("Đ", "D").Replace("đ", "d");
            // Chuẩn hóa thành dạng không dấu
            string normalized = input.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();

            foreach (char c in normalized)
            {
                // Bỏ các dấu thanh (dấu sắc, huyền, hỏi...)
                UnicodeCategory uc = CharUnicodeInfo.GetUnicodeCategory(c);
                if (uc != UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }

            string unsign = sb.ToString().Normalize(NormalizationForm.FormC);

            // Xóa tất cả các ký tự không phải chữ và số (nếu cần)
            unsign = Regex.Replace(unsign, @"[^a-zA-Z0-9]", "");

            return unsign.ToUpper();
        }
        #endregion

        protected void ddlDC_DangKy_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlDC_DangKy_Huyen, Convert.ToDecimal(ddlDC_DangKy_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlDC_DangKy_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlDC_HoatDong_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlDC_HoatDong_Huyen, Convert.ToDecimal(ddlDC_HoatDong_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlDC_HoatDong_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }

        protected void txtNgaySinh_DD_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaySinh_DD.Text))
            {
                DateTime Ngaysinh = DateTime.Parse(this.txtNgaySinh_DD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                if (Ngaysinh != DateTime.MinValue)
                {
                    if (Ngaysinh > now)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaySinh_DD.ClientID);
                        return;
                    }
                    else
                        txtNamSinh_DD.Text = Ngaysinh.Year.ToString();
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtCMND_DD.ClientID);
        }
        protected void txtNamSinh_DD_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtNgaySinh_DD.Text))
            {
                if (!String.IsNullOrEmpty(txtNamSinh_DD.Text))
                {
                    namsinh = Convert.ToInt32(txtNamSinh_DD.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtNgaySinh_DD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaySinh_DD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtNgaySinh_DD.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtNgaySinh_DD.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                    }
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtCMND_DD.ClientID);
        }
        protected void ddlCuTru_DD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlCuTru_DD_Huyen, Convert.ToDecimal(ddlCuTru_DD_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlCuTru_DD_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
    }
}


