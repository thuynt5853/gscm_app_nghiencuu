using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
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

namespace WEB.GSTP.QLAN.AHS.Hoso
{
    public partial class BiCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        public Decimal VuAnID = 0, BiCanID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        public DataTable tblToiDanh = null;
        public Decimal LoginTinhID = 0, LoginHuyenID = 0;
        Decimal CurrUserID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                CurrentYear = DateTime.Now.Year;
                if (CurrUserID > 0)
                {
                    VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    LoginTinhID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_TINH_ID] + "");
                    LoginHuyenID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                    if (!IsPostBack)
                    {
                        BiCanID = (Request["bID"] != null) ? Convert.ToDecimal(Request["bID"] + "") : 0;
                        hddID.Value = BiCanID.ToString();

                        AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        //NgayXayRaVuAn = ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
                        NgayXayRaVuAn = ((String.IsNullOrEmpty(oT.NGAYXAYRA + "")) || (((DateTime)oT.NGAYXAYRA) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);

                        hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();

                        LoadCombobox();
                        CheckQuyen();
                        if (BiCanID > 0)
                        {
                            LoadInfo(BiCanID);
                        }

                        AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                        tblToiDanh = objBL.AHS_GetAllToiDanh();
                        LoadGridToiDanh();
                    }
                    //rdTreViThanhNien.Attributes.Add("onchange", "return validate_rd_vithanhnien();");
                    // chkGetToiDanhDauVu.Attributes.Add("onclick", "return validate_bican();");
                }
                else Response.Redirect("/Login.aspx");
            } catch(Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }
        protected void txtSoNgay_TextChanged(object sender, EventArgs e)
        {
            //if (dropBienPhapNganChan.SelectedValue != "0"
            //        && dropBienPhapNganChan.SelectedValue == hddBPNC_TamGiam.Value)
            //{
            if (!string.IsNullOrEmpty(txtNgayBatDau.Text))
            {
                DateTime ngaybatdau = DateTime.Parse(this.txtNgayBatDau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                int songay = String.IsNullOrEmpty(txtSoNgay.Text.Trim()) ? 0 : Convert.ToInt32(txtSoNgay.Text);
                DateTime ngaykt = ngaybatdau.AddDays(songay);
                txtNgayKT.Text = ngaykt.ToString("dd/MM/yyyy", cul);
            }
            //}
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdate2, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateAndNext, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateAndNext2, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdThemDieuLuat, oPer.CAPNHAT);
            Cls_Comon.SetLinkButton(lkChoiceToiDanh, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdGetToiDanhDauVu, oPer.CAPNHAT);
            //-----------------------------------
            int MAGIAIDOAN = (String.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt16(hddGiaiDoanVuAn.Value);
            if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lstMsgT.Text = lstMsgB.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                cmdUpdate.Visible = cmdUpdate2.Visible = false;
                cmdUpdateAndNext.Visible = cmdUpdateAndNext2.Visible = false;
                lkChoiceToiDanh.Visible = false;
                cmdThemDieuLuat.Visible = false;
                cmdGetToiDanhDauVu.Visible = false;
                pnFormThemNT.Enabled = pnFormThemTD.Visible = false;
                hddShowCommand.Value = "False";
                return;
            }
            else if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                cmdUpdate.Visible = cmdUpdate2.Visible = cmdUpdateAndNext.Visible = cmdUpdateAndNext2.Visible = false;
                lkChoiceToiDanh.Visible = false;
                cmdThemDieuLuat.Visible = false;
                cmdGetToiDanhDauVu.Visible = false;
                pnFormThemNT.Enabled = pnFormThemTD.Visible = false;
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
                pnFormThemNT.Enabled = pnFormThemTD.Visible = false;
                hddShowCommand.Value = "False";
                return;
            }
            AHS_BICANBICAO ObjBiCao = dt.AHS_BICANBICAO.Where(x => x.ID == BiCanID).FirstOrDefault();
            if(ObjBiCao != null)
            {
                if(ObjBiCao.GDTAOHS == 1)
                {
                    lstMsgT.Text = lstMsgB.Text = "Bị án đã tồn tại ở thi hành án, không được sửa đổi !";
                    cmdUpdate.Visible = cmdUpdate2.Visible = false;
                    cmdUpdateAndNext.Visible = cmdUpdateAndNext2.Visible = false;
                    lkChoiceToiDanh.Visible = false;
                    cmdThemDieuLuat.Visible = false;
                    cmdGetToiDanhDauVu.Visible = false;
                    pnFormThemNT.Enabled = pnFormThemTD.Visible = false;
                    hddShowCommand.Value = "False";
                    return;
                }
            }

            //----------------------------------------------
            CheckBiCanDauVu();
        }
        void CheckBiCanDauVu()
        {
            rdBiCanDauVu.Enabled = false;
            try
            {
                cmdGetToiDanhDauVu.Visible = false;
                AHS_BICANBICAO objBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                if (objBC != null)
                {
                    hddBiCanDauVuID.Value = objBC.ID.ToString();
                    rdBiCanDauVu.SelectedValue = "0";

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
                    rdBiCanDauVu.SelectedValue = "1";
                    cmdGetToiDanhDauVu.Visible = false;
                    hddBiCanDauVuID.Value = "0";
                }
            }
            catch (Exception ex)
            {
                rdBiCanDauVu.SelectedValue = "1";
                cmdGetToiDanhDauVu.Visible = false;
                hddBiCanDauVuID.Value = "0";
            }
        }
        #region Su dung chung
        void LoadDrop_LoaiToiPhamHS_ThongKe()
        {
            DM_QHPL_TK_BL objBL = new DM_QHPL_TK_BL();
            DataTable tbl = objBL.GetByStyle(7);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropLoaiToiPham.Items.Clear();
                foreach (DataRow row in tbl.Rows)
                {
                    dropLoaiToiPham.Items.Add(new ListItem(row["Case_Name"] + "", row["ID"] + ""));
                }
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

            //----------Form bien phap ngan chan----------------------
            LoadDropByGroupName(dropBienPhapNganChan, ENUM_DANHMUC.BIENPHAPNGANCHAN, false);
            LoadDropByGroupName(dropDV, ENUM_DANHMUC.LOAIDONVIQDNGANCHAN, false);

            //---------form toi danh----------
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                           && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            // dropBoLuat.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        //------------------------------
        private const decimal ROOT = 0;
        private void LoadDropTinh_Huyen()
        {
            ddlHKTT_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlHKTT_Tinh.Items.Add(new ListItem("---Chọn Tỉnh/TP---", "0"));
            ddlTamTru_Tinh.Items.Add(new ListItem("---Chọn Tỉnh/TP---", "0"));
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlTamTru_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, LoginTinhID);
                 //-----------------
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlHKTT_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlHKTT_Tinh, LoginTinhID);
            }

            //----------------------------
            ddlHKTT_Huyen.Items.Clear();
            ddlTamTru_Huyen.Items.Clear();

            ddlHKTT_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
            ddlTamTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
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
                    Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, LoginTinhID);
                    //------------
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlTamTru_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, LoginTinhID);
                }
            }
        }
        private void LoadDropHuyenByTinh(DropDownList drop, Decimal TinhID)
        {
            drop.Items.Clear();
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                drop.DataSource = lstHuyen;
                drop.DataTextField = "TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }
            else
                drop.Items.Add(new ListItem("---Chọn---", "0"));
        }
        protected void ddlHKTT_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlHKTT_Huyen, Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlHKTT_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlTamTru_Huyen, Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        //-----------------------------
        #endregion

        #region from bi cao
        private void LoadInfo(decimal BiCanID)
        {
            hddID.Value = BiCanID.ToString();
            AHS_BICANBICAO obj = null;
            try
            {
                obj = dt.AHS_BICANBICAO.Where(x => x.ID == BiCanID).SingleOrDefault();
            }
            catch { obj = null; }

            if (obj != null)
            {
                txtTen.Text = obj.HOTEN;
                if (obj.LOAIDOITUONG != null) dropDoiTuongPhamToi.SelectedValue = obj.LOAIDOITUONG + "";
                rdBiCanDauVu.SelectedValue = obj.BICANDAUVU.ToString();
                txtCMND.Text = obj.SOCMND;
                dropNgheNghiep.SelectedValue = (String.IsNullOrEmpty(obj.NGHENGHIEPID + "")) ? "0" : obj.NGHENGHIEPID.ToString();
                dropTrinhDoVH.SelectedValue = obj.TRINHDOVANHOAID.ToString();
                //-------------------------------------
                dropQuocTich.SelectedValue = obj.QUOCTICHID.ToString();
                if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                    pnHoKhau.Visible = true;
                else
                    pnHoKhau.Visible = false;

                //-------------------------------------
                if (obj.HKTT != null)
                {
                    ddlHKTT_Tinh.SelectedValue = obj.HKTT + "";
                    LoadDropHuyenByTinh(ddlHKTT_Huyen, (decimal)obj.HKTT);
                }
                if (obj.HKTT_HUYEN != null)
                    Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, obj.HKTT_HUYEN);
                txtHKTT_Chitiet.Text = obj.KHTTCHITIET;

                //-------------------------------------
                if (obj.TAMTRU != null)
                {
                    ddlTamTru_Tinh.SelectedValue = obj.TAMTRU + "";
                    LoadDropHuyenByTinh(ddlTamTru_Huyen, (decimal)obj.TAMTRU);
                }
                if (obj.TAMTRU_HUYEN != null)
                    Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, obj.TAMTRU_HUYEN);
                txtTamtru_Chitiet.Text = obj.TAMTRUCHITIET;

                //------------------------------------------
                if (obj.NGAYSINH != DateTime.MinValue)
                {
                    txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                }
                txtNamSinh.Text = obj.NAMSINH + "";
                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();
                //-------------------------------------
                txtTenKhac.Text = obj.TENKHAC + "";
                dropDanToc.SelectedValue = (string.IsNullOrEmpty(obj.DANTOCID + "")) ? "0" : obj.DANTOCID + "";
                dropTonGiao.SelectedValue = (string.IsNullOrEmpty(obj.TONGIAOID + "")) ? "0" : obj.TONGIAOID + "";
                rdChuvVuCQ.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUCHINHQUYENID + "")) ? "0" : obj.CHUCVUCHINHQUYENID.ToString();
                rdChucVuDang.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUDANGID + "")) ? "0" : obj.CHUCVUDANGID.ToString();

                try { dropTinhTrangGiamGiu.SelectedValue = obj.TINHTRANGGIAMGIUID.ToString(); } catch (Exception exx) { }
                //------------------------------------------------
                txtNgayKhoiTo.Text = ((String.IsNullOrEmpty(obj.NGAYTHAMGIA + "")) || (((DateTime)obj.NGAYTHAMGIA) == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);

                //--------------------------------------
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
                    //txtTuoi.Text = "";
                    pnTreViThanhNien.Visible = false;
                }
                if (obj.TUOI > 0)
                    txtTuoi.Text = obj.TUOI + "";

                rdNGhienHut.SelectedValue = obj.NGHIENHUT + "";
                rdTinhTrangTaiPham.SelectedValue = obj.TAIPHAM + "";

                //--------------------------------------
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();
                //----------------------------
                dropLoaiToiPham.SelectedValue = (String.IsNullOrEmpty(obj.LOAITOIPHAMHS_ID + "")) ? "0" : obj.LOAITOIPHAMHS_ID.ToString();
                //-----------------------------
                LoadBienPhapNCTheoBiCanID(BiCanID);
                //----------------------
                LoadDsNhanThanBiCao();
            }
        }


        protected void txtNgayKhoiTo_TextChanged(object sender, EventArgs e)
        {
            //if (Cls_Comon.IsValidDate(txtNgayKhoiTo.Text) == false)
            //{
            //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa nhập ngày bị khởi tố theo định dạng dd/MM/yyyy. Hãy kiểm tra lại!");
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayKhoiTo.ClientID);
            //    return;
            //}
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

                //if (txtNamSinh.Text != "")
                //{
                //    TinhTuoiBiCan();
                //}
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropDanToc.ClientID);
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            //if (Cls_Comon.IsValidDate(txtNgayKhoiTo.Text) == false)
            //{
            //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa nhập ngày bị khởi tố theo định dạng dd/MM/yyyy. Hãy kiểm tra lại!");
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayKhoiTo.ClientID);
            //    return;
            //}
            /*-----------------------------------------*/
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

                //if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                //    TinhTuoiBiCan();
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
                //if (namsinh > DateTime.Now.Year)
                //{
                //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!");
                //    Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);
                //}
                if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                {
                    DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (namsinh > NgayKhoiTo.Year)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn năm khởi tố. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);
                    }
                    //TinhTuoiBiCan();
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtTenKhac.ClientID);
        }


        void TinhTuoiBiCan()
        {
            DateTime ngaysinh, ngaykhoito;
            ngaysinh = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (String.IsNullOrEmpty(txtNgaysinh.Text.Trim()) && (!String.IsNullOrEmpty(txtNamSinh.Text)))
            {
                string temp_ngaysinh = "01/01" + "/" + txtNamSinh.Text.Trim(); // theo luat: neu ko co ngay sinh, chi co nam sinh --> default = 1/1/nam sinh
                ngaysinh = DateTime.Parse(temp_ngaysinh, cul, DateTimeStyles.NoCurrentDateDefault);
            }
            ngaykhoito = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            int nam = ngaykhoito.Year - ngaysinh.Year;
            int thang = ngaykhoito.Month - ngaysinh.Month;
            if (thang < 0)
                nam = nam - 1;
            else
            {
                if (thang == 0)
                {
                    int ngay = ngaykhoito.Day - ngaysinh.Day;
                    if (ngay <= 0)
                        nam = nam - 1;
                }
            }

            txtTuoi.Text = nam.ToString();

            if (nam >= 0)
            {
                if (nam > 18)
                {
                    rdTreViThanhNien.Enabled = pnTreViThanhNien.Visible = false;
                    rdTreViThanhNien.SelectedValue = "0";
                }
                else
                {
                    if (nam < 18)
                    {
                        rdTreViThanhNien.SelectedValue = "1";
                        rdTreViThanhNien.Enabled = false;
                        pnTreViThanhNien.Visible = true;
                    }
                    else if (nam == 18)
                    {
                        rdTreViThanhNien.SelectedValue = "0";
                        rdTreViThanhNien.Enabled = true;
                        pnTreViThanhNien.Visible = false;
                    }
                }
            }
            else
            {
                rdTreViThanhNien.SelectedValue = "1";
                rdTreViThanhNien.Enabled = false;
                pnTreViThanhNien.Visible = true;
                txtTuoi.Text = "0";
            }
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

        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                lstMsgT.Text = lstMsgB.Text = "Bị can chưa được gán tội danh. Hãy kiểm tra lại!";
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }
            SaveBiCan();
            Resetcontrol();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                lstMsgT.Text = lstMsgB.Text = "Bị can chưa được gán tội danh. Hãy kiểm tra lại!";
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }
            SaveBiCan();
            txtSoNgay.Text = string.Empty;
            //Response.Redirect("DsBiCao.aspx");
        }

        void SaveBiCan()
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            Update_BiCao();

            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            SaveNhanThanBiCan();
            //---------------------------------

            SaveBienPhapNC(BiCanID);
            lstMsgT.Text = lstMsgB.Text = "Lưu thông tin bị can thành công!";
        }
        void SaveNhanThanBiCan()
        {
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
        void Update_NhanThan(string QHNhanThan, HiddenField hddNhanThanID
            , TextBox txtHoTen, TextBox txtNamSinh, TextBox txtDiaChi, TextBox txtGhiChu)
        {
            Boolean IsUpdate = false;
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal MoiQuanHeNhanThanID = 0;
            try { MoiQuanHeNhanThanID = dt.DM_DATAITEM.Where(x => x.MA == QHNhanThan).FirstOrDefault().ID; } catch (Exception ex) { }

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

            obj.NGAYSINH_NAM = (String.IsNullOrEmpty(txtNamSinh.Text.Trim())) ? 0 : Convert.ToDecimal(txtNamSinh.Text); ;
            obj.HKTT_CHITIET = txtDiaChi.Text;
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

        Boolean CheckGanToiChoBiCan()
        {
            try
            {
                Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                if (BiCanID == 0)
                    BiCanID = Convert.ToDecimal(hddID.Value);
                if (BiCanID > 0)
                {
                    Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                    List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                                                    && x.VUANID == VuAnID
                                                                                                    && x.DIEULUATID == boluatid).ToList();
                    if (lst != null && lst.Count > 0)
                        return true;
                    else
                        return false;
                }
                else return false;
            }
            catch (Exception ex) { return false; }
        }
        void Update_BiCao()
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            #region Bi cao vu an
            AHS_BICANBICAO obj = new AHS_BICANBICAO();

            if (BiCanID > 0)
            {
                obj = dt.AHS_BICANBICAO.Where(x => x.ID == BiCanID).Single<AHS_BICANBICAO>();
                if (obj == null)
                {
                    lbthongbao.Text = "Không tìm thấy bị can/bị cáo!";
                    return;
                }
            }

            obj.VUANID = VuAnID;
            obj.MABICAN = "";
            obj.LOAIDOITUONG = Convert.ToInt16(dropDoiTuongPhamToi.SelectedValue);

            obj.BICANDAUVU = Convert.ToInt16(rdBiCanDauVu.SelectedValue);
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

            obj.TRINHDOVANHOAID = Convert.ToDecimal(dropTrinhDoVH.SelectedValue);
            obj.TINHTRANGGIAMGIUID = Convert.ToDecimal(dropTinhTrangGiamGiu.SelectedValue);
            
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

            //--------------------------------
            obj.NGHIENHUT = Convert.ToInt16(rdNGhienHut.SelectedValue);
            obj.TAIPHAM = Convert.ToInt16(rdTinhTrangTaiPham.SelectedValue);

            //--------------------------------
            obj.TIENAN = (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text + "");
            obj.TIENSU = (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text + "");
            obj.NGHENGHIEPID = Convert.ToInt32(dropNgheNghiep.SelectedValue);

            //----------------------
            obj.LOAITOIPHAMHS_ID = Convert.ToDecimal(dropLoaiToiPham.SelectedValue);
            if (BiCanID > 0)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if(obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_BICANBICAO.Add(obj);
                dt.SaveChanges();
            }

            //----------------------------------
            BiCanID = obj.ID;
            hddID.Value = BiCanID.ToString();
            if (obj.BICANDAUVU == 1)
            {
                hddBiCanDauVuID.Value = BiCanID.ToString();
                List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID
                                                                        && x.BICANDAUVU == 1
                                                                        && x.ID != BiCanID).ToList<AHS_BICANBICAO>();
                if (lstBC != null && lstBC.Count > 0)
                {
                    foreach (AHS_BICANBICAO objBC in lstBC)
                        objBC.BICANDAUVU = 0;
                    dt.SaveChanges();
                }
                //--------Update ten vu an theo TenBiCanDauVu----------
                //Update_TenVuAn(VuAnID, obj.HOTEN, obj.ID);

            }
            Update_NewTenToiDanh();
            #endregion

            //-------------------------
            //GanToiDanhBiCanKhac_Tu_BCDauVu(BiCanID);
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
                        //xoa trang txtTenToiDanh --> lay ten trong DM_BoLuat_toiDanh
                        DM_BOLUAT_TOIDANH objDM = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == currToiDanhID).Single<DM_BOLUAT_TOIDANH>();
                        tentoidanh = objDM.TENTOIDANH;
                    }
                    else
                        tentoidanh = txtTenToiDanh.Text.Trim();

                    if (BiCanDauVu == 1 && count_tt == 1)
                    {
                        //Update ten vu an
                        AHS_VUAN objVA = dt.AHS_VUAN.Where(x => x.ID == VuAnID).Single();
                        objVA.TENVUAN = txtTen.Text.Trim() + " - " + tentoidanh;
                        objVA.LOAITOIPHAMID = Convert.ToInt16(hddLoaiToiPham.Value);
                        dt.SaveChanges();
                    }

                    //Update bang SoTham_CaoTrang_DieuLuat
                    objTD = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == currID
                                                                    && x.VUANID == VuAnID
                                                                    && x.BICANID == BiCanID).FirstOrDefault();
                    if (objTD != null)
                    {
                        objTD.TENTOIDANH = tentoidanh;
                        objTD.ISMAIN = (count_tt == 1) ? 1 : 0;
                    }
                }
            }
            dt.SaveChanges();
        }

        #region from toi danh 

        protected void cmdGetToiDanhDauVu_Click(object sender, EventArgs e)
        {
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = null;
            Decimal BiCanDauVuID = 0;// (String.IsNullOrEmpty(hddBiCanDauVuID.Value)) ? 0 : Convert.ToDecimal(hddBiCanDauVuID.Value);

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
                //lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
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
                            obj.TENTOIDANH = item.TENTOIDANH + "";
                            obj.ISMAIN = String.IsNullOrEmpty(item.ISMAIN + "") ? 0 : item.ISMAIN;

                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            //insert toa_gq_id
                            if(obj.TOA_GIAIQUYET_ID == null)
                            {
                                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
                        }
                    }
                    dt.SaveChanges();

                    //---------------------------
                    //cmdGetToiDanhDauVu.Visible = false;
                    hddPageIndex.Value = "1";
                    LoadGridToiDanh();
                    Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                }
            }
        }
        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {
            //Nguoi dung co the chọn bộ luật + nhap diem, khoan , dieu
            // Tu dong search ra luat tuong ung trong DM_BoLuat_ToiDanh 
            // Them vao DB toi danh tim duoc
            lstMsgT.Text = lstMsgB.Text = lbthongbao.Text = "";
            Update_BiCao();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            if (BiCanID > 0)
            {

                decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                String Diem = txtDiem.Text.Trim();
                string Khoan = txtKhoan.Text.Trim();
                String Dieu = txtDieu.Text.Trim();
                //string Chuong = txtChuong.Text.Trim();

                DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
                int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
                DataTable tbl = objBL.SearchChinhXacTheoDK(luatid, Diem, Khoan, Dieu);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                        SaveToiDanh(row);
                    //-------------------------------
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
        protected void lkChoiceToiDanh_Click(object sender, EventArgs e)
        {
            try
            {
                SaveBiCan();
                Cls_Comon.CallFunctionJS(this, this.GetType(), "popupChonToiDanh()");
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        void SaveToiDanh(DataRow rowToiDanh)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value + "")) ? 0 : Convert.ToDecimal(hddID.Value);

            String ArrSapXep = "";
            String[] arrToiDanh = null;
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid = Convert.ToDecimal(rowToiDanh["ID"] + "");
            //Lay ds cac cap cha cua toi danh duoc chon

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
                        InsertToiDanh(BiCanID, toidanhid);
                    }
                }
                dt.SaveChanges();
            }

            lstMsgT.Text = lstMsgB.Text = "Lưu điều luật áp dụng cho bị can thành công!";
        }
        void InsertToiDanh(Decimal BiCanID, Decimal toidanhid)
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

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                obj.TENTOIDANH = objTD.TENTOIDANH;
                obj.ISMAIN = 0;

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                // insert toa_gq_id
                if(obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
            }
        }

        public void LoadGridToiDanh()
        {
            lbthongbao.Text = "";
            //string textsearch = txtTenToiDanh.Text.Trim();
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value + "")) ? 0 : Convert.ToDecimal(hddID.Value);
            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, luatid, 0, "", pageindex, pagesize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                //lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    return;
                }
                try
                {
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
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                if (hddShowCommand.Value == "False")
                {
                    lkXoa.Visible = false;
                }
            }
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
                pnBienPhapNganChan.Visible = false;
        }
        private void LoadBienPhapNCTheoBiCanID(decimal BiCanID)
        {
            AHS_SOTHAM_BIENPHAPNGANCHAN obj = null;
            try
            {
                obj = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.BICANID == BiCanID).Single<AHS_SOTHAM_BIENPHAPNGANCHAN>();
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
            catch (Exception ex) {
                obj = new AHS_SOTHAM_BIENPHAPNGANCHAN();
                logger.Error("loi xay ra: " + ex);
            }

            if (rdNganChan.SelectedValue != "0")
            {
                obj.VUANID = VuAnID;
                obj.BICANID = BiCanID;
                obj.DONVIRAQD = Convert.ToDecimal(dropDV.SelectedValue);
                obj.BIENPHAPNGANCHANID = Convert.ToDecimal(dropBienPhapNganChan.SelectedValue);
                obj.HIEULUC = 1;// Convert.ToInt16(rdHieuLuc.SelectedValue);

                //obj.GHICHU = txtGhiChu.Text.Trim();
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
                    if(obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Add(obj);
                    dt.SaveChanges();
                }
            }
            // lstMsgB.Text = "Lưu dữ liệu thành công!";
        }

        #endregion
        protected void cmdLoadDsToiDanh_Click(object sender, EventArgs e)
        {
            LoadGridToiDanh();
        }
        #region Thong tin nhan than bi cao 


        //---------------------------
        void Resetcontrol()
        {
            txtTen.Text = txtTenKhac.Text = txtCMND.Text = "";
            txtTuoi.Text = "";

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
            txtSoNgay.Text = string.Empty;

            //----------------
            txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
            lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            pndata.Visible = false;
            cmdGetToiDanhDauVu.Visible = true;
        }

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
                else rptOtherNT.Visible = false;
            }
        }

        private void ResetControlNhanThan()
        {
            txtBo_HoTen.Text = txtBo_NamSinh.Text = txtBo_GhiChu.Text = txtBo_Diachi.Text = "";
            txtMe_HoTen.Text = txtMe_NamSinh.Text = txtMe_GhiChu.Text = txtMe_Diachi.Text = "";
            txtBanDoi_HoTen.Text = txtBanDoi_NamSinh.Text = txtBanDoi_GhiChu.Text = txtBanDoi_Diachi.Text = "";
            txtCon1_HoTen.Text = txtCon1_NamSinh.Text = txtCon1_GhiChu.Text = txtCon1_Diachi.Text = "";
            txtCon2_HoTen.Text = txtCon2_NamSinh.Text = txtCon2_GhiChu.Text = txtCon2_Diachi.Text = "";

            lttMsgNhanThan.Text = "";
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
                        //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
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

        protected void rptOtherNT_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                if (hddShowCommand.Value == "False")
                {
                    lbtXoa.Visible = false;
                }
            }
        }

        public void xoa_nhanthan(decimal id)
        {
            AHS_BICAN_NHANTHAN oT = dt.AHS_BICAN_NHANTHAN.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_BICAN_NHANTHAN.Remove(oT);
            dt.SaveChanges();
            lttMsgNT.Text = "Xóa dữ liệu thành công!";
            LoadDsNhanThanBiCao();
            // Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa dữ liệu thành công!");
            // LoadDsNhanThanBiCao();
        }
        #endregion
        protected void lkThemCon_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            SaveBiCan();

            //int soluong = Convert.ToInt16(hddSoLuongCon.Value);
            //hddSoLuongCon.Value = (soluong + 1).ToString();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_nhanthan(" + VuAnID + "," + BiCanID + ")");
        }
    }
}

