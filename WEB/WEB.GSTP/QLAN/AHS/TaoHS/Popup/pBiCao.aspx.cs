using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
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

namespace WEB.GSTP.QLAN.AHS.TaoHS.Popup
{
    public partial class pBiCao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        public static Decimal VuAnID = 0, CurrUserID = 0, BiCaoID = 0, BanAnID = 0;
        public decimal NhomHinhPhatBS = 0;
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
                    if (VuAnID == 0)
                        VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    LoginTinhID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_TINH_ID] + "");
                    LoginHuyenID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    NhomHinhPhatBS = dt.DM_DATAITEM.Where(x => x.MA == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG).SingleOrDefault().ID;
                    AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).First() ?? new AHS_SOTHAM_BANAN();
                    BanAnID = oBA.ID;
                    if (!IsPostBack)
                    {
                        AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        hddGiaiDoanVuAn.Value = oT.MAGIAIDOAN.ToString();
                        hddBanAnID.Value = BanAnID.ToString();
                        LoadCombobox();
                        //LoadCap_xx();
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
                        else
                        {
                            ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                            chkBoxCMNDND.Checked = false;

                        }

                        if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                            pnHoKhau.Visible = true;
                        else
                            pnHoKhau.Visible = false;

                        LoadGridToiDanh();

                        try
                        {
                            //NẾU ĐÃ CÓ BỊ CAN ĐẦU VỤ THÌ KHÔNG CHO ĐỔI
                            AHS_BICANBICAO objBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                            if (objBC != null)
                            {
                                rdBiCanDauVu.Enabled = false;
                            }
                            //NẾU ĐANG LÀ BỊ CAN ĐẦU VỤ THÌ CHO THAY ĐỔI
                            if (objBC.ID == BiCaoID)
                            {
                                rdBiCanDauVu.Enabled = true;
                            }
                        }
                        catch (Exception ex)
                        {
                            lstMsgB.Text = ENUM_MESSAGE.SERVER_ERROR;
                            logger.Error("loi xay ra: " + ex);
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            } catch (Exception ex)
            {
                lstMsgB.Text = ENUM_MESSAGE.SERVER_ERROR;
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
        protected void txtSoNgay_pt_TextChanged(object sender, EventArgs e)
        {
            //if (dropBienPhapNganChan.SelectedValue != "0"
            //        && dropBienPhapNganChan.SelectedValue == hddBPNC_TamGiam.Value)
            //{
            if (!string.IsNullOrEmpty(txtNgayBatDau_pt.Text))
            {
                DateTime ngaybatdau = DateTime.Parse(this.txtNgayBatDau_pt.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                int songay = String.IsNullOrEmpty(txtSoNgay_pt.Text.Trim()) ? 0 : Convert.ToInt32(txtSoNgay_pt.Text);
                DateTime ngaykt = ngaybatdau.AddDays(songay);
                txtNgayKT_pt.Text = ngaykt.ToString("dd/MM/yyyy", cul);
            }
            //}
        }
        void CheckQuyen()
        {
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
                    }
                }
                else
                {
                    rdBiCanDauVu.SelectedValue = "1";
                    cmdGetToiDanhDauVu.Visible = false;
                    hddBiCanDauVuID.Value = "0";
                }
            }
            catch
            {
                rdBiCanDauVu.SelectedValue = "1";
                cmdGetToiDanhDauVu.Visible = false;
                hddBiCanDauVuID.Value = "0";
            }
        }

        #region from bi cao
        private void LoadCombobox()
        {
            LoadDropTinh_Huyen();
            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            dropQuocTich.SelectedValue = QuocTichVN.ToString();
            //--------------------------
            // LoadDrop_MoiQHNhanThan();
            //----------------------------------------Form bien phap ngan chan-
            LoadDropByGroupName(dropBienPhapNganChan, ENUM_DANHMUC.BIENPHAPNGANCHAN, true);
            LoadDropByGroupName_PT(dropBienPhapNganChan_pt, ENUM_DANHMUC.BIENPHAPNGANCHAN, true);
            //Với TACC tự động gán là Tạm Giam
            dropBienPhapNganChan.SelectedValue = "140";

            LoadDropByGroupName(dropDV, ENUM_DANHMUC.LOAIDONVIQDNGANCHAN, true);

            LoadDropByGroupName_PT(dropDV_pt, ENUM_DANHMUC.LOAIDONVIQDNGANCHAN, true);
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
            if (GroupName == ENUM_DANHMUC.LOAIDONVIQDNGANCHAN)
            {
                AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (obj != null)
                {
                    DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANID).FirstOrDefault();
                    drop.Items.Add(new ListItem(oT.TEN, oT.ID.ToString()));
                    drop.SelectedValue = oT.ID.ToString();
                }  
            }
        }
        void LoadDropByGroupName_PT(DropDownList drop, string GroupName, Boolean ShowChangeAll)
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
            if (GroupName == ENUM_DANHMUC.LOAIDONVIQDNGANCHAN)
            {
                AHS_VUAN_GIAIDOAN obj = dt.AHS_VUAN_GIAIDOAN.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN==3).FirstOrDefault();
                if (obj != null)
                {
                    DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).FirstOrDefault();
                    drop.Items.Add(new ListItem(oT.TEN, oT.ID.ToString()));
                    drop.SelectedValue = oT.ID.ToString();
                }
            }
        }
        private const decimal ROOT = 0;
        private void LoadDropTinh_Huyen()
        {
            ddlHKTT_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlHKTT_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlTamTru_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
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
            }

            //----------------------------------------
            LoadDropHuyen();
        }
        void LoadDropHuyen()
        {
            ddlHKTT_Huyen.Items.Clear();
            ddlTamTru_Huyen.Items.Clear();

            ddlHKTT_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlTamTru_Huyen.Items.Add(new ListItem("Chọn", "0"));
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
                }
            }
        }
        private void LoadDropHuyenByTinh(DropDownList drop, Decimal TinhID)
        {
            drop.Items.Clear();
            //DM_HANHCHINH_BL bl = new DM_HANHCHINH_BL();
            //DataTable tbl = bl.GetAllByParentID(TinhID);
            //if (tbl != null && tbl.Rows.Count>0)
            //{
            //    drop.DataSource = tbl;
            //    drop.DataTextField = "TEN";
            //    drop.DataValueField = "ID";
            //    drop.DataBind();
            //}
            //else
            //    drop.Items.Add(new ListItem("Chọn", "0"));
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                //drop.DataSource = lstHuyen;
                //drop.DataTextField = "TEN";
                //drop.DataValueField = "ID";
                //drop.DataBind();
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
        //-----------------------------------------
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
                
                txtTen.Text = obj.HOTEN;
                rdBiCanDauVu.SelectedValue = obj.BICANDAUVU.ToString();
                if (obj.LOAIDOITUONG != null) dropDoiTuongPhamToi.SelectedValue = obj.LOAIDOITUONG + "";
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
                #region Thiều
                if (string.IsNullOrEmpty(obj.SOCMND))
                {
                    chkBoxCMNDND.Checked = true;

                    ltCMNDND.Text = "";
                }
                else
                {
                    ltCMNDND.Text = "<span style='color:red'>(*)</span>";
                    chkBoxCMNDND.Checked = false;
                }
                #endregion
                txtND_CMND.Text = obj.SOCMND;
                rdTreViThanhNien.SelectedValue = obj.ISTREVITHANHNIEN.ToString();
                //----------------------------------------
                if (obj.NGAYSINH != DateTime.MinValue)
                    txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamSinh.Text = obj.NAMSINH + "";
                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();

                //-----------------------------------------
                LoadBienPhapNCTheoBiCaoID(BiCanID);
                LoadBienPhapNCTheoBiCaoID_pt(BiCanID);

                //----------------------
                LoadDsNhanThanBiCao();
            }
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
            }
        }


        protected void dropQuocTich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                pnHoKhau.Visible = true;
            else
                pnHoKhau.Visible = false;
          
        }

        #endregion
        private bool CheckValidate()
        {
            string msg = "";
            if (txtTen.Text.Trim() == "")
            {
                msg = "Bạn chưa nhập tên bị can. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                txtTen.Focus();
                return false;
            }
            #region Thiều
            if (!chkBoxCMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtND_CMND.Text))
                {
                    lbthongbao.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước/ Hộ chiếu.";
                    txtND_CMND.Focus();
                    return false;
                }

            }
            #endregion
            String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
            DateTime Dnow = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
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
            txtTen.Text =  "";
            
            rdBiCanDauVu.SelectedValue = "0";
            txtNgaysinh.Text = txtNamSinh.Text = "";
            
            ddlGioitinh.SelectedIndex = dropQuocTich.SelectedIndex =  0;

            //---------------------------
            txtHKTT_Chitiet.Text = "";
            LoadDropTinh_Huyen();

            
            //---------------------------
            hddID.Value = "0";
            hddPageIndex.Value = "1";
            rdTreViThanhNien.ClearSelection();
            //--------------------
            ResetControlNhanThan();
            //---------------------------
            rdNganChan.SelectedValue = "0";
            rdNganChan_pt.SelectedValue = "0";
            pnBienPhapNganChan.Visible = false;
            txtNgayBatDau.Text = txtNgayKT.Text = "";
            txtNgayBatDau_pt.Text = txtNgayKT_pt.Text = "";
            dropBienPhapNganChan.SelectedIndex = dropDV.SelectedIndex = 0;
            dropBienPhapNganChan_pt.SelectedIndex = dropDV_pt.SelectedIndex = 0;
            //----------------
            txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
            pndata.Visible = false;
            cmdGetToiDanhDauVu.Visible = true;
            hddHinhPhatChange.Value = hddGroupChange.Value = "0";
            pnHinhPhat.Visible = false;

            try
            {
                //NẾU ĐÃ CÓ BỊ CAN ĐẦU VỤ THÌ KHÔNG CHO ĐỔI
                AHS_BICANBICAO objBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                if (objBC != null)
                {
                    rdBiCanDauVu.Enabled = false;
                }
                else
                    rdBiCanDauVu.Enabled = true;
            }
            catch (Exception ex)
            {

            }
        }
        void Save_BiCan()
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            Update_BiCao();

            Decimal BiCaoID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            SaveNhanThanBiCan();
            //---------------------------------
            SaveBienPhapNC(BiCaoID);
            SaveBienPhapNC_PT(BiCaoID);

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
        #region Thiều
        protected void chkBoxCMNDND_CheckedChanged(object sender, EventArgs e)
        {

            if (!chkBoxCMNDND.Checked)
            {
                ltCMNDND.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltCMNDND.Text = "";
            }

        }
        #endregion
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
            try
            {
                if (BiCaoID > 0)
                    obj = dt.AHS_BICANBICAO.Where(x => x.ID == BiCaoID).Single<AHS_BICANBICAO>();
                else
                    obj = new AHS_BICANBICAO();
            }
            catch (Exception ex) { obj = new AHS_BICANBICAO(); }
            obj.LOAITOIPHAMHS_ID = 0;
            obj.VUANID = VuAnId;
            obj.MABICAN = "";
            obj.LOAIDOITUONG = Convert.ToInt16(dropDoiTuongPhamToi.SelectedValue);

            obj.BICANDAUVU = Convert.ToInt16(rdBiCanDauVu.SelectedValue);
            obj.HOTEN = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
            obj.SOCMND = txtND_CMND.Text;
            obj.QUOCTICHID = Convert.ToDecimal(dropQuocTich.SelectedValue);
            obj.DANTOCID = 0;

            obj.TONGIAOID = 0;
            obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);

            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYSINH = date_temp;
            if (date_temp != DateTime.MinValue)
            {
                obj.THANGSINH = Convert.ToDecimal(date_temp.Month);
            }
            obj.NAMSINH = Convert.ToDecimal(txtNamSinh.Text);

            obj.CHUCVUCHINHQUYENID = 0;
            obj.CHUCVUDANGID = 0;
            //-----------------------------------------
            obj.TAMTRU = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
            obj.TAMTRU_HUYEN = Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue);
            obj.TAMTRUCHITIET = txtTamtru_Chitiet.Text;

            obj.HKTT = Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue);
            obj.HKTT_HUYEN = Convert.ToDecimal(ddlHKTT_Huyen.SelectedValue);
            obj.KHTTCHITIET = txtHKTT_Chitiet.Text;

            //-----------------------------------------
            obj.ISTREVITHANHNIEN = Convert.ToInt16(rdTreViThanhNien.SelectedValue);
            if (obj.ISTREVITHANHNIEN == 0)
            {
                obj.TREMOCOI = obj.TREBOHOC = obj.TRELANGTHANG = obj.BOMELYHON = obj.CONGUOIXUIGIUC = 0;
            }
            
            //-----------------------------------------
            obj.NGHIENHUT = 0;
            obj.TAIPHAM = 0;
            //-----------------------------------------
            obj.TIENAN =0;
            obj.TIENSU = 0;

            obj.NGHENGHIEPID = 0;
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
            //--Mạnh bỏ do 1 vụ án có nhiêu bị cáo đầu vụ
            //if (obj.BICANDAUVU == 1)
            //{
            //    List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnId && x.BICANDAUVU == 1
            //                                                            && x.ID != BiCaoID
            //                                                        ).ToList<AHS_BICANBICAO>();
            //    if (lstBC != null && lstBC.Count > 0)
            //    {
            //        foreach (AHS_BICANBICAO objBC in lstBC)
            //            objBC.BICANDAUVU = 0;
            //        dt.SaveChanges();
            //    }
            //    //Update_TenVuAn(VuAnId, obj.HOTEN, BiCaoID);
            //}
            Update_NewTenToiDanh();
            #endregion

            //----------------------------------------
            //GanToiDanhBiCanKhac_Tu_BCDauVu(BiCaoID);
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
                        // objVA.TENVUAN = txtTen.Text.Trim() + " - " + tentoidanh;
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


        void Update_NhanThan(string QHNhanThan, HiddenField hddNhanThanID, TextBox txtHoTen, TextBox txtNamSinh, TextBox txtDiaChi, TextBox txtGhiChu)
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
                //DateTime ngaybanhanh = DateTime.MinValue;
                //try
                //{
                //    ngaybanhanh = DateTime.MinValue;
                //}
                //catch (Exception ex) { }
                pnToiDanh.Visible = true;
                int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
                //GetNgayBH();

                AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, luatid, 0, "", pageindex, pagesize);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();

                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";

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
                    rpt.DataSource = null;
                    rpt.DataBind();
                    lblThongBaoHP.Text = "";
                    lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
                }
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                bool IsShowCommand = Convert.ToBoolean(hddShowCommand.Value);
                if (IsShowCommand)
                    lkXoa.Visible = true;
                else
                    lkXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lkXoa.Visible = false;
                }
            }
        }
        String LoadChiTietToiDanh(Decimal ToiDanhID, String ArrSapXep, int level)
        {
            DataRow[] arr = null;
            string[] temp = null;
            String RootId = "";
            String ToiDanhChinh = "", Temp_ToiDanh = "";
            temp = ArrSapXep.Split('/');

            RootId = temp[0] + "";
            string temp_sx = ArrSapXep.Replace("/", ",");
            //-------------------------

            /*select ID, LuatID, Chuong, Diem, Khoan, dieu, TenToiDanh, capChaID, Loai, ArrSapXep
             from DM_BoLuat_ToiDanh
             where Loai > 0 and LuatID in (select Id from DM_BoLuat where HieuLuc = 1 and Loai = '01');
             */
            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == luatid
                                                                      && x.ARRSAPXEP.Contains(RootId + "/")
                                                                    ).OrderByDescending(y => y.LOAI).ToList();
            if (level > 1)
            {
                Decimal curr_id = 0;
                int loai = 0;
                foreach (string item in temp)
                {
                    if (item.Length > 0)
                    {
                        curr_id = Convert.ToDecimal(item);
                        foreach (DM_BOLUAT_TOIDANH itemTD in lst)
                        {
                            loai = (int)itemTD.LOAI;
                            if (curr_id == itemTD.ID)
                            {
                                if (Convert.ToDecimal(item) == ToiDanhID)
                                {
                                    switch (loai)
                                    {
                                        case 2:
                                            ToiDanhChinh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            ToiDanhChinh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            ToiDanhChinh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                else
                                {
                                    if (Temp_ToiDanh.Length > 0)
                                        Temp_ToiDanh += "<br/>";
                                    switch (loai)
                                    {
                                        case 2:
                                            Temp_ToiDanh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            Temp_ToiDanh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            Temp_ToiDanh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                //-------------------------
                                break;
                            }
                        }
                    }
                }
            }
            string strtoidanh = (Temp_ToiDanh.Length > 0) ? "<br/><i>(" + Temp_ToiDanh + ")</i>" : "";
            return (ToiDanhChinh + strtoidanh);
        }

        protected void cmdGetToiDanhDauVu_Click(object sender, EventArgs e)
        {
            string StrMsg = "Không được sửa đổi thông tin.";
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = null;
            Decimal BiCanDauVuID = 0; //(String.IsNullOrEmpty(hddBiCanDauVuID.Value)) ? 0 : Convert.ToDecimal(hddBiCanDauVuID.Value);

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

                    //---------------------------
                    // cmdGetToiDanhDauVu.Visible = false;
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
            string StrMsg = "";
            //if (command == "xoa")
            //{
            //    try
            //    {
            //        string StrMsg = "Không được sửa đổi thông tin.";
            //        xoatoidanh(curr_id);
            //    }
            //    catch { }
            //}
            switch (e.CommandName)
            {
                case "xoa":
                    try
                    {
                        StrMsg = "Không được sửa đổi thông tin.";
                        xoatoidanh(curr_id);

                    }
                    catch { }

                    Capnhat_AHS_TONGHOPHINHPHAT();
                    break;
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(curr_id);

                    Capnhat_AHS_TONGHOPHINHPHAT();
                    //xoatoidanh(curr_id);
                    break;
                case "HinhPhat":
                    Response.Redirect("ChonToiDanh.aspx");
                    break;
                case "view":
                    //Chi hien khung chon hinh phat khi toidanh co CoHinhPhat = 1
                    hddHinhPhatChange.Value = hddGroupChange.Value = "0";
                    LoadHinhPhatTheoToiDanh(curr_id);
                    break;
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
                AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
                if (oTLPT.ID > 0)
                {
                    lstMsgT.Text = lstMsgB.Text = StrMsg;
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
        void GetNgayBH()
        {
            //int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            //DM_BOLUAT_TOIDANH_BL obj = new DM_BOLUAT_TOIDANH_BL();
            //int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            //DataTable tbl = obj.GetByDK(luatid, Loai_bo_luat, "", "", "", 1);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    DataView view = new DataView(tbl);
            //    DataTable distinct_tbl = view.ToTable(true, "NgayBanHanh");
            //    dropNgayBH.Items.Clear();
            //   // dropNgayBH.Items.Add(new ListItem("-- Chọn -", ""));
            //    String NgayBH = "";
            //    foreach (DataRow row in distinct_tbl.Rows)
            //    {
            //        NgayBH = String.IsNullOrEmpty(row["NgayBanHanh"] + "") ? "" : Convert.ToDateTime(row["NgayBanHanh"]).ToString("dd/MM/yyyy", cul);
            //        if (NgayBH.Length > 0)
            //            dropNgayBH.Items.Add(new ListItem(NgayBH, NgayBH));
            //    }
            //}
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
        protected void rdNganChan_pt_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdNganChan_pt.SelectedValue == "1")
            {
                pnBienPhapNganChan_pt.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), dropBienPhapNganChan_pt.ClientID);
            }
            else
            {
                pnBienPhapNganChan_pt.Visible = false;
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

                // txtGhiChu.Text = obj.GHICHU + "";
                //rdHieuLuc.SelectedValue = obj.HIEULUC.ToString();
            }
            else
            {
                pnBienPhapNganChan.Visible = false;
                rdNganChan.SelectedValue = "0";
            }
        }
        private void LoadBienPhapNCTheoBiCaoID_pt(decimal BiCaoID)
        {
            AHS_BIENPHAPNGANCHAN obj = null;
            try
            {
                obj = dt.AHS_BIENPHAPNGANCHAN.Where(x => x.BICANID == BiCaoID && x.CAPXX == 3).Single<AHS_BIENPHAPNGANCHAN>();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                pnBienPhapNganChan_pt.Visible = true;
                rdNganChan_pt.SelectedValue = "1";
                dropDV_pt.SelectedValue = obj.DONVIRAQD.ToString();
                dropBienPhapNganChan_pt.SelectedValue = obj.BIENPHAPNGANCHANID.ToString();

                if (obj.NGAYBATDAU != DateTime.MinValue)
                    txtNgayBatDau_pt.Text = ((DateTime)obj.NGAYBATDAU).ToString("dd/MM/yyyy", cul);

                if (obj.NGAYKETTHUC != DateTime.MinValue)
                    txtNgayKT_pt.Text = ((DateTime)obj.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
                
            }
            else
            {
                pnBienPhapNganChan_pt.Visible = false;
                rdNganChan_pt.SelectedValue = "0";
            }
        }
        void SaveBienPhapNC_PT(Decimal BiCanID)
        {
            Boolean IsUpdate = false;
            AHS_BIENPHAPNGANCHAN obj = new AHS_BIENPHAPNGANCHAN();
            try
            {
                if (BiCanID > 0)
                {
                    obj = dt.AHS_BIENPHAPNGANCHAN.Where(x => x.BICANID == BiCanID && x.VUANID == VuAnID && x.CAPXX==3).Single<AHS_BIENPHAPNGANCHAN>();
                    IsUpdate = true;
                    if (rdNganChan_pt.SelectedValue == "0")
                    {
                        //Xoa bien phap ngan chan
                        dt.AHS_BIENPHAPNGANCHAN.Remove(obj);
                        dt.SaveChanges();
                    }
                }
                else
                    obj = new AHS_BIENPHAPNGANCHAN();
            }
            catch (Exception ex) { obj = new AHS_BIENPHAPNGANCHAN(); }
            // { lbthongbao.Text = ex.Message + " | " + ex.InnerException.ToString(); }

            if (rdNganChan_pt.SelectedValue != "0")
            {
                obj.VUANID = VuAnID;
                obj.BICANID = BiCanID;
                obj.DONVIRAQD = Convert.ToDecimal(dropDV_pt.SelectedValue);
                obj.BIENPHAPNGANCHANID = Convert.ToDecimal(dropBienPhapNganChan_pt.SelectedValue);
                obj.HIEULUC = 1;// Convert.ToInt16(rdHieuLuc.SelectedValue);
                obj.CAPXX = 3;
                // obj.GHICHU = txtGhiChu.Text.Trim();
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgayBatDau_pt.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBatDau_pt.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYBATDAU = date_temp;

                date_temp = (String.IsNullOrEmpty(txtNgayKT_pt.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKT_pt.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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
                    dt.AHS_BIENPHAPNGANCHAN.Add(obj);
                    dt.SaveChanges();
                }
            }
            // lstMsgB.Text = "Lưu dữ liệu thành công!";
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
            // lstMsgB.Text = "Lưu dữ liệu thành công!";
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
                else rptOtherNT.Visible = false;
            }
        }
        private void ResetControlNhanThan()
        {
            txtBo_HoTen.Text = txtBo_NamSinh.Text = txtBo_GhiChu.Text=txtND_CMND.Text = txtBo_Diachi.Text = "";
            txtMe_HoTen.Text = txtMe_NamSinh.Text = txtMe_GhiChu.Text = txtMe_Diachi.Text = "";
            txtBanDoi_HoTen.Text = txtBanDoi_NamSinh.Text = txtBanDoi_GhiChu.Text = txtBanDoi_Diachi.Text = "";
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
                        //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
                        lttMsgNT.Text = "Bạn không có quyền xóa dữ liệu";
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
          
            Save_BiCan();
            //int soluong = Convert.ToInt16(hddSoLuongCon.Value);
            //hddSoLuongCon.Value = (soluong + 1).ToString();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_nhanthan(" + VuAnID + "," + BiCanID + ")");
        }

        private void Capnhat_AHS_TONGHOPHINHPHAT()
        {
            try
            {
                AHS_TONGHOPHINHPHAT saveTHHP = new AHS_TONGHOPHINHPHAT();
                if (!saveTHHP.Capnhat_Tonghophinhphat_byVuanAndBicanid(2, VuAnID, BiCaoID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                {
                    lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                    return;
                }

            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                return;
            }
        }

        #region Load hinh phat theo toi danh
        protected void cmdSaveHinhPhat_Click(object sender, EventArgs e)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);

            DM_BOLUAT_TOIDANH dm = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            Decimal boluatid = (decimal)dm.LUATID;

            Decimal NhomHinhPhatChange = String.IsNullOrEmpty(hddGroupChange.Value) ? 0 : Convert.ToDecimal(hddGroupChange.Value);
            if (NhomHinhPhatChange > 0)
            {
                string manhom = dt.DM_DATAITEM.Where(x => x.ID == NhomHinhPhatChange).Single<DM_DATAITEM>().MA;
                if (manhom == ENUM_NHOMHINHPHAT.NHOM_HPCHINH)
                    Update_HinhPhatChinh(rptHPChinh, ToiDanhID, boluatid);
                else
                    Update_HinhPhatChinh(rptQDKhac, ToiDanhID, boluatid);
            }
            else
            {
                Update_HinhPhatChinh(rptHPChinh, ToiDanhID, boluatid);
                Update_HinhPhatChinh(rptQDKhac, ToiDanhID, boluatid);
            }
            Update_HinhPhatBS(rptHPBoSung, ToiDanhID, boluatid);
            lbthongbao.Text = "";

            try { Update_TongHopHP(); } catch (Exception ex) { }

            Capnhat_AHS_TONGHOPHINHPHAT();

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Cập nhật hình phạt cho bị cáo thành công!");
        }
        AHS_SOTHAM_BANAN_DIEU_CHITIET obj;
        void Update_HinhPhatChinh(Repeater rpt, Decimal ToiDanhID, Decimal boluatid)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal HinhPhatChinh = Convert.ToDecimal(hddHinhPhatChange.Value);
            Boolean IsUpdate = false;
            DM_BOLUAT_TOIDANH tentoidanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
                    CheckBox chk = (CheckBox)itemHP.FindControl("chk");
                    if (hinhphatid == HinhPhatChinh && chk.Checked == true)
                    {
                        try
                        {
                            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> listCheck = null;
                            listCheck = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                                 && x.BANANID == BanAnID
                                                                                 && x.TOIDANHID == ToiDanhID
                                                                                 && x.ISCHANGE == 0
                                                                                 ).ToList();
                            if (listCheck != null && listCheck.Count > 0)
                            {
                                obj = listCheck[0];
                                IsUpdate = true;
                                //foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET item in listCheck)
                                //{
                                //        if (item.HINHPHATID > 0 && item.HINHPHATID == hinhphatid)
                                //        {
                                //            IsUpdate = true;
                                //            obj = item;
                                //            break;
                                //        }
                                //        else
                                //            IsUpdate = false;
                                //}
                            }
                            else
                            {
                                IsUpdate = false;
                                obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                            }
                        }
                        catch (Exception ex)
                        {
                            obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                        }

                        //----------An treo & thoi gian thu thach----------------
                        obj.TGTT_NAM = 0;
                        obj.TGTT_THANG = 0;
                        obj.TGTT_NGAY = 0;
                        try
                        {
                            CheckBox chkAnTreo = (CheckBox)itemHP.FindControl("chkAnTreo");
                            obj.ISANTREO = (chkAnTreo.Checked) ? 1 : 0;

                            if (chkAnTreo.Checked)
                            {
                                TextBox txtTGTT_Nam = (TextBox)itemHP.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)itemHP.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)itemHP.FindControl("txtTGTT_Ngay");
                                obj.TGTT_NAM = String.IsNullOrEmpty(txtTGTT_Nam.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Nam.Text);
                                obj.TGTT_THANG = String.IsNullOrEmpty(txtTGTT_Thang.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Thang.Text);
                                obj.TGTT_NGAY = String.IsNullOrEmpty(txtTGTT_Ngay.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Ngay.Text);
                            }

                        }
                        catch (Exception exx) { }
                        //---------------------------------------
                        obj.ISCHANGE = 0;

                        obj.DIEULUATID = boluatid;
                        obj.TOIDANHID = ToiDanhID;
                        obj.HINHPHATID = hinhphatid;
                        obj.BANANID = BanAnID;
                        obj.BICANID = BiCanID;
                        obj.VUANID = VuAnID;
                        
                        obj.ISMAIN = 0; //Hình phạt chính là 0, hình phạt bổ sung là null
                        obj.TENTOIDANH = tentoidanh.TENTOIDANH;

                        GetValue(obj, itemHP);
                        if (!IsUpdate)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                        dt.SaveChanges();
                    }
                }
                catch (Exception ex) { }
            }
        }
        void Update_HinhPhatBS(Repeater rpt, Decimal ToiDanhID, Decimal boluatid)
        {
            Boolean IsUpdate = false, IsDelete = false, IsEdit = false;
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lstBS = null;
                    IsUpdate = IsDelete = IsEdit = false;

                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);

                    //KT du lieu co duoc sua ko (ko phải la dl mac dinh empty)
                    IsEdit = GetValue_HPBoSung(obj, itemHP);

                    //KT da co hinhphat bo sung nay trong DB?? 
                    try
                    {

                        lstBS = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.ISCHANGE == 1
                                                                            && x.HINHPHATID == hinhphatid
                                                                            ).ToList();
                        if (lstBS != null && lstBS.Count > 0)
                        {
                            IsUpdate = true;
                            obj = lstBS[0];
                            if (!IsEdit)
                            {
                                //DL bi set ve gia tri default & da co trong db -->Xoa dl
                                IsDelete = true;
                                xoa_by_Id(obj.ID);
                            }
                            else
                            {
                                //cho edit
                                IsUpdate = true;
                            }
                        }
                        else
                        {
                            IsDelete = false;
                            IsUpdate = true;
                            //DL da duoc sua <> default_emty--> cho them moi
                            if (IsEdit)
                                IsUpdate = false;
                        }
                    }
                    catch (Exception ex)
                    {
                        IsDelete = false;
                        IsUpdate = true;
                        //DL da duoc sua <> default_emty--> cho them moi
                        if (IsEdit)
                            IsUpdate = false;
                    }

                    if (IsUpdate == false)
                        obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    if (!IsDelete)
                    {
                        obj.ISCHANGE = 1;
                        obj.DIEULUATID = boluatid;
                        obj.TOIDANHID = ToiDanhID;
                        obj.BANANID = BanAnID;
                        obj.BICANID = BiCanID;
                        obj.VUANID = VuAnID;
                        IsEdit = GetValue_HPBoSung(obj, itemHP);

                        if (!IsUpdate)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                        dt.SaveChanges();
                    }
                }
                catch (Exception ex) { }
            }
        }
        void Update_TongHopHP()
        {
            Decimal CurrHinhPhatID = 0, th_HinhPhatID = 0;
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            AHS_SOTHAM_BANAN_DIEU_TONGHOP objTH = null;
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.TongHopToiDanhSoTham(BanAnID, BiCanID);
            int check_default_true = 0;

            int isupdate = 0;

            String MaHinhPhat = "", MaNhomHP = "";
            int MucDo_HinhPhat = 0;
            DM_HINHPHAT objHP = null;
            if (tbl != null && tbl.Rows.Count > 0)
            {
                bool IsMain = false;
                String StrEdit = ",";
                foreach (DataRow row in tbl.Rows)
                {
                    isupdate = 0;
                    IsMain = false;
                    check_default_true = 0;
                    CurrHinhPhatID = Convert.ToDecimal(row["HinhPhatID"] + "");
                    MaHinhPhat = row["MaHinhPhat"] + "";
                    MaNhomHP = row["MaNhomHP"] + "";
                    MucDo_HinhPhat = Convert.ToInt16(row["MUCDO"] + "");
                    //TUCHUNGTHAN, TUHINH                

                    if (MaNhomHP == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG)
                    {
                        IsMain = false;
                        try
                        {
                            objTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                   && x.BICANID == BiCanID
                                                                   && x.HINHPHATID == CurrHinhPhatID).FirstOrDefault();
                            if (objTH == null)
                                objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP();
                            else isupdate = 1;
                        }
                        catch (Exception ex) { objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP(); }
                    }
                    else
                    {
                        IsMain = true;
                        objTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                         && x.BICANID == BiCanID
                                                                         && x.ISMAIN == 1).FirstOrDefault();
                        if (objTH == null)
                            objTH = new AHS_SOTHAM_BANAN_DIEU_TONGHOP();
                        else
                        {
                            th_HinhPhatID = (Decimal)objTH.HINHPHATID;

                            objHP = dt.DM_HINHPHAT.Where(x => x.ID == th_HinhPhatID).FirstOrDefault();
                            if (objHP != null)
                            {
                                if (objHP.MUCDO > MucDo_HinhPhat)
                                    isupdate = 1;
                                else
                                    isupdate = 2; // ko cho update hinh phat chinh
                            }
                        }
                    }
                    objTH.BANANID = BanAnID;
                    objTH.BICANID = BiCanID;
                    objTH.HINHPHATID = CurrHinhPhatID;
                    objTH.ISMAIN = (IsMain) ? 1 : 0; //hinh phat chinh/hp bo sung
                    obj.LOAIHINHPHAT = String.IsNullOrEmpty(row["LOAIHINHPHAT"] + "") ? 0 : Convert.ToDecimal(row["LOAIHINHPHAT"] + "");

                    //---------------------------------
                    objTH.TF_VALUE = String.IsNullOrEmpty(row["TF_VALUE"] + "") ? 0 : ((Convert.ToDecimal(row["TF_VALUE"] + "") > 1) ? 1 : 0);
                    if (objTH.TF_VALUE > 0)
                        check_default_true = 1;

                    //---------------------------------
                    objTH.SH_VALUE = String.IsNullOrEmpty(row["SH_VALUE"] + "") ? 0 : Convert.ToDecimal(row["SH_VALUE"] + "");
                    if (objTH.SH_VALUE > 0)
                        check_default_true = 1;

                    //---------------------------------
                    objTH.TG_NAM = String.IsNullOrEmpty(row["TG_NAM"] + "") ? 0 : Convert.ToDecimal(row["TG_NAM"] + "");
                    objTH.TG_THANG = String.IsNullOrEmpty(row["TG_THANG"] + "") ? 0 : Convert.ToDecimal(row["TG_THANG"] + "");
                    objTH.TG_NGAY = String.IsNullOrEmpty(row["TG_NGAY"] + "") ? 0 : Convert.ToDecimal(row["TG_NGAY"] + "");
                    if (objTH.TG_NAM > 0 || objTH.TG_NGAY > 0 || objTH.TG_THANG > 0)
                        check_default_true = 1;

                    objTH.TGTT_NAM = String.IsNullOrEmpty(row["TGTT_NAM"] + "") ? 0 : Convert.ToDecimal(row["TGTT_NAM"] + "");
                    objTH.TGTT_THANG = String.IsNullOrEmpty(row["TGTT_THANG"] + "") ? 0 : Convert.ToDecimal(row["TGTT_THANG"] + "");
                    objTH.TGTT_NGAY = String.IsNullOrEmpty(row["TGTT_NGAY"] + "") ? 0 : Convert.ToDecimal(row["TGTT_NGAY"] + "");
                    if (objTH.TGTT_NAM > 0 || objTH.TGTT_NGAY > 0 || objTH.TGTT_THANG > 0)
                    {
                        check_default_true = 1;
                        objTH.ISANTREO = 1;
                    }
                    else obj.ISANTREO = 0;

                    //---------------------------------
                    objTH.K_VALUE1 = String.IsNullOrEmpty(row["K_VALUE1"] + "") ? 0 : Convert.ToDecimal(row["K_VALUE1"] + "");
                    if (objTH.K_VALUE1 > 0)
                        check_default_true = 1;

                    objTH.K_VALUE2 = String.IsNullOrEmpty(row["K_VALUE2"] + "") ? "" : row["K_VALUE2"] + "";
                    if (!String.IsNullOrEmpty(objTH.K_VALUE2))
                        check_default_true = 1;

                    //---------------------------------
                    if (isupdate == 0)
                        dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Add(objTH);

                    if (isupdate < 2)
                        dt.SaveChanges();
                    StrEdit += objTH.ID.ToString() + ",";
                }

                //-------------------------------
                if (!String.IsNullOrEmpty(StrEdit))
                {
                    string temp = "";
                    List<AHS_SOTHAM_BANAN_DIEU_TONGHOP> lstTH = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BANANID == BanAnID
                                                                                                         && x.BICANID == BiCanID).ToList();
                    if (lstTH != null && lstTH.Count > 0)
                    {
                        foreach (AHS_SOTHAM_BANAN_DIEU_TONGHOP item in lstTH)
                        {
                            temp = "," + item.ID + ",";
                            if (!StrEdit.Contains(temp))
                            {
                                //Xoa dl 
                                dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Remove(item);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
        }
        void GetValue(AHS_SOTHAM_BANAN_DIEU_CHITIET obj, RepeaterItem itemHP)
        {
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;

            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    obj.TF_VALUE = 1;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    obj.TF_VALUE = Convert.ToDecimal(rdTrueFalse.SelectedValue);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = String.IsNullOrEmpty(txtSohoc.Text) ? 0 : Convert.ToDecimal(txtSohoc.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    break;
            }
        }
        Boolean GetValue_HPBoSung(AHS_SOTHAM_BANAN_DIEU_CHITIET obj, RepeaterItem itemHP)
        {
            Boolean IsEdit = false;
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;
            obj.ISCHANGE = 1;
            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    // RadioButtonList rdDefaultTrue = (RadioButtonList)itemHP.FindControl("rdDefaultTrue");
                    CheckBox chkDefaultTrue = (CheckBox)itemHP.FindControl("chkDefaultTrue");
                    //if (rdDefaultTrue.SelectedValue == "1")
                    if (chkDefaultTrue.Checked)
                    {
                        IsEdit = true;
                        obj.TF_VALUE = 1;
                    }
                    else obj.TF_VALUE = 0;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    //   RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    CheckBox chkTrueFalse = (CheckBox)itemHP.FindControl("chkTrueFalse");
                    obj.TF_VALUE = (chkTrueFalse.Checked) ? 1 : 0;
                    if (chkTrueFalse.Checked)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = String.IsNullOrEmpty(txtSohoc.Text) ? 0 : Convert.ToDecimal(txtSohoc.Text);
                    if (obj.SH_VALUE > 0)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    if ((obj.TG_NAM > 0) || (obj.K_VALUE1 > 0) || (obj.K_VALUE1 > 0))
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    if (obj.K_VALUE1 > 0)
                        IsEdit = true;
                    if (!String.IsNullOrEmpty(obj.K_VALUE2))
                        IsEdit = true;
                    break;
            }
            return IsEdit;
        }
        public void xoa_by_Id(decimal CurrID)
        {
            try
            {
                AHS_SOTHAM_BANAN_DIEU_CHITIET obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.ID == CurrID).FirstOrDefault();
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(obj);
                dt.SaveChanges();
            }
            catch (Exception ex) { }

            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
            lblThongBaoHP.Text = "";
            lbthongbao.Text = "Xóa thành công!";
        }
        public void LoadDsToiDanhByBiCan()
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal loaiboluat = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU);
            DateTime ngaybh = DateTime.MinValue;
            string curr_textsearch = "";// txtTenToiDanh.Text.Trim();
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.GetAllPaging(BiCanID, BanAnID, boluatid, curr_textsearch, pageindex, page_size);
            // AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            // DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, boluatid, 0, "", pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
                rpt.DataSource = null;
                rpt.DataBind();
                lblThongBaoHP.Text = "";
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void rptHP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;
                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                AHS_SOTHAM_BANAN_DIEU_CHITIET objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                if (group_id == NhomHinhPhatBS)
                {
                    chkAnTreo.Checked = false;
                    chk.Visible = false;
                    try
                    {
                        objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.HINHPHATID == hinhphat
                                                                             && x.ISCHANGE == 1
                                                                        ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    }
                    catch (Exception ex) { }
                }
                else
                {
                    chk.Visible = true;
                    try
                    {
                        objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                            && x.BANANID == BanAnID
                                                                            && x.TOIDANHID == ToiDanhID
                                                                            && x.HINHPHATID == hinhphat
                                                                            && x.ISCHANGE == 0
                                                                        ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    }
                    catch (Exception ex) { }
                }
                if (objCT != null)
                {
                    hddGroupChange.Value = group_id.ToString();
                    if (group_id != NhomHinhPhatBS)
                    {
                        //chkAnTreo.Checked = true;
                        chk.Checked = true;
                        hddHinhPhatChange.Value = hinhphat.ToString();

                        int is_antreo = (string.IsNullOrEmpty(objCT.ISANTREO + "")) ? 0 : Convert.ToInt16(objCT.ISANTREO);
                        if (objCT.ISANTREO == 1)
                        {
                            chkAnTreo.Checked = true;
                            try
                            {
                                Panel pnThoiGianThuThach = (Panel)e.Item.FindControl("pnThoiGianThuThach");
                                pnThoiGianThuThach.Visible = true;

                                TextBox txtTGTT_Nam = (TextBox)e.Item.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)e.Item.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)e.Item.FindControl("txtTGTT_Ngay");
                                txtTGTT_Nam.Text = (String.IsNullOrEmpty(objCT.TGTT_NAM + "")) ? "0" : objCT.TGTT_NAM.ToString();
                                txtTGTT_Thang.Text = (String.IsNullOrEmpty(objCT.TGTT_THANG + "")) ? "0" : objCT.TGTT_THANG.ToString();
                                txtTGTT_Ngay.Text = (String.IsNullOrEmpty(objCT.TGTT_NGAY + "")) ? "0" : objCT.TGTT_NGAY.ToString();
                            }
                            catch (Exception ex) { }
                        }
                    }
                }
                else
                {
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        rdTrueFalse.Visible = true;
                        if (objCT != null)
                            rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(objCT.TF_VALUE + "")) ? "0" : objCT.TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : objCT.SH_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        rdDefaultTrue.Visible = false;
                        if (objCT != null)
                            rdDefaultTrue.SelectedValue = "1";
                        break;
                }
            }
        }
        protected void rptHPBoSung_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;

                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                AHS_SOTHAM_BANAN_DIEU_CHITIET objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                chkAnTreo.Checked = false;

                try
                {
                    objCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                        && x.BANANID == BanAnID
                                                                        && x.TOIDANHID == ToiDanhID
                                                                        && x.HINHPHATID == hinhphat
                                                                         && x.ISCHANGE == 1
                                                                    ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (objCT != null)
                    {
                        hddGroupChange.Value = group_id.ToString();
                        if (group_id != NhomHinhPhatBS)
                        {
                            //  chkAnTreo.Checked = true;
                            chk.Checked = true;
                            hddHinhPhatChange.Value = hinhphat.ToString();
                        }
                    }
                    else
                    {
                        objCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                        //chkAnTreo.Checked = false;
                        chk.Checked = false;
                    }
                }
                catch (Exception ex)
                {
                    objCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        CheckBox chkDefaultTrue = (CheckBox)e.Item.FindControl("chkDefaultTrue");
                        chkDefaultTrue.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkDefaultTrue.Checked = (objCT.TF_VALUE == 1) ? true : false;

                        //RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        //rdDefaultTrue.Visible = true;
                        //if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                        //    rdDefaultTrue.SelectedValue = objCT.TF_VALUE.ToString();
                        break;

                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        CheckBox chkTrueFalse = (CheckBox)e.Item.FindControl("chkTrueFalse");
                        chkTrueFalse.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkTrueFalse.Checked = (objCT.TF_VALUE == 1) ? true : false;

                        //RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        //rdTrueFalse.Visible = true;
                        //if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                        //    rdTrueFalse.SelectedValue = objCT.TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : objCT.SH_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                }
            }
        }
        void LoadHinhPhatTheoToiDanh(Decimal ToiDanhID)
        {
            hddCurrToiDanhID.Value = ToiDanhID.ToString();
            DM_BOLUAT_TOIDANH objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).SingleOrDefault();
            if (objTD != null)
            {
                int IsHinhPhat = String.IsNullOrEmpty(objTD.COHINHPHAT + "") ? 0 : Convert.ToInt16(objTD.COHINHPHAT);
                if (IsHinhPhat == 1)
                {
                    pnHinhPhat.Visible = true;
                    lttToiDanh.Text = "Cập nhật hình phạt";// + objTD.TENTOIDANH;

                    //---------Load 3 nhom dhp----------------------------
                    DM_DATAGROUP objG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.NHOMHINHPHAT).SingleOrDefault();
                    List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == objG.ID).ToList<DM_DATAITEM>();
                    if (lst != null && lst.Count > 0)
                    {
                        Decimal GroupID = 0;
                        foreach (DM_DATAITEM data in lst)
                        {
                            GroupID = data.ID;
                            switch (data.MA + "")
                            {
                                case ENUM_NHOMHINHPHAT.NHOM_HPCHINH:
                                    lttNhomHPChinh.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptHPChinh);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG:
                                    lttNhomHPBoSung.Text = data.TEN;
                                    try
                                    {
                                        LoadListHinhPhatBoSung(GroupID);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_QDKHAC:
                                    lttNhomQDKhac.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptQDKhac);
                                    }
                                    catch (Exception ex) { }
                                    break;
                            }
                        }
                    }
                }
                else
                    pnHinhPhat.Visible = false;
            }
        }
        void LoadHinhPhatTheoGroup(decimal GroupID, Repeater rptControl)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();

            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptControl.DataSource = lst;
                rptControl.DataBind();
            }
        }
        void LoadListHinhPhatBoSung(decimal GroupID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptHPBoSung.DataSource = lst;
                rptHPBoSung.DataBind();
            }
        }
        public void xoa(decimal toidanhid)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            BanAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");

            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.TOIDANHID == toidanhid
                                                          && x.BANANID == BanAnID
                                                          && x.BICANID == BiCanID
                                                        ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET obj in lst)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
            lblThongBaoHP.Text = "";
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            Decimal row_hinhphat = 0;
            //------------------------
            Decimal CurrToiDanhId = (string.IsNullOrEmpty(hddCurrToiDanhID.Value)) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
            foreach (RepeaterItem item in rpt.Items)
            {
                HiddenField hddToiDanh = (HiddenField)item.FindControl("hddToiDanhID");
                LinkButton lk = (LinkButton)item.FindControl("lk");
                Image Image = (Image)item.FindControl("Image");
                if (CurrToiDanhId == Convert.ToDecimal(hddToiDanh.Value))
                {
                    lk.Visible = false;
                    Image.Visible = true;
                    Image.ImageUrl = "../../../../../UI/img/check.png";
                    Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
                }
                else
                {
                    Image.Visible = false;
                    lk.Visible = true;
                }
            }
            //-------------------------------
            decimal CurrHinhPhatID = Convert.ToDecimal(hddHinhPhatChange.Value);
            if (CurrHinhPhatID > 0)
            {
                foreach (RepeaterItem item in rptHPChinh.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);

                    Panel pnZoneHinhPhat = (Panel)item.FindControl("pnZoneHinhPhat");

                    Panel pnThoiGianThuThach = (Panel)item.FindControl("pnThoiGianThuThach");
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                        {
                            pnZoneHinhPhat.Enabled = chk.Checked = false;
                        }
                        else
                        {
                            pnZoneHinhPhat.Enabled = true;
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                            try
                            {
                                CheckBox chkAnTreo = (CheckBox)item.FindControl("chkAnTreo");
                                if (chkAnTreo.Checked)
                                {
                                    pnThoiGianThuThach.Visible = true;
                                    TextBox txtTGTT_Nam = (TextBox)item.FindControl("txtTGTT_Nam");
                                    Cls_Comon.SetFocus(this, this.GetType(), txtTGTT_Nam.ClientID);
                                }
                                else
                                    pnThoiGianThuThach.Visible = false;
                            }
                            catch (Exception exx) { }
                        }
                    }
                }
                foreach (RepeaterItem item in rptQDKhac.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                            chk.Checked = false;
                        else
                        {
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                        }
                    }
                }
                Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
            }
        }

        #endregion        
    }
}