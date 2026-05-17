using BL.GSTP;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.THA;
using NLog;
using BL.GSTP.THA;

namespace WEB.GSTP.QLAN.THA.QuyetDinh
{
    public partial class Edit : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, BiAnID = 0;
        Decimal HeThong_VuAnID = 0, HeThong_BiAnID = 0;
        public string NgaySoSanh = "";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + ""))
                    ? 0
                    : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + ""))
                    ? 0
                    : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                THA_THULY thuLy = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                if (CurrUserID > 0)
                {
                    if (!IsPostBack)
                    {
                        if (BiAnID > 0)
                        {
                            pn.Visible = true;
                            LoadDsNguoiKy(donvi);
                            loadTinhTrangBiAn();
                            lkFile.Visible = cmdXoa.Visible = false;

                            hddBiAnID.Value = BiAnID.ToString();
                            CheckQuyen();
                            LoadInfo();
                            loadTinhTrangBiAnView();
                        }
                        else
                        {
                            pn.Visible = false;
                            lbthongbao.Text = "Bạn cần chọn bị án để xử lý!";
                        }

                    }

                    CheckQuyenSuaXoa();
                    //-----------them doan dk cho su kien upload file ------------------
                    txtNgayQD.Attributes.Add("onchange", "return SetNgayTHA();");
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex)
            {
                logger.Error("loi xay ra: " + ex);
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
            }
        }

        void LoadInfo()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + ""))
                ? 0
                : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            decimal VuAnID = 0;
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            bool isOldData = false;
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUANID;
                hddVuAnID.Value = VuAnID.ToString();

                dropBiAn.Items.Clear();
                dropBiAn.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));

                HeThong_BiAnID = (obj.IDBICANHETHONG == null || obj.IDBICANHETHONG == Decimal.MinValue)
                    ? 0
                    : (Decimal)obj.IDBICANHETHONG;
                if (obj.IDVUANHETHONG == 0)
                {
                    THA_BIAN tb = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == obj.IDBICANHETHONG && x.IDVUANHETHONG != 0).FirstOrDefault();
                    HeThong_VuAnID = (Decimal)tb.IDVUANHETHONG;
                }
                else
                {
                    HeThong_VuAnID = (Decimal)obj.IDVUANHETHONG;
                }

                THA_BIAN_QUYETDINH objqd = null;
                try
                {
                    objqd = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                        .Single<THA_BIAN_QUYETDINH>() ?? new THA_BIAN_QUYETDINH();
                    hddCurrentID.Value = objqd.ID.ToString();
                }
                catch (Exception ex)
                {
                }

                cmdXoaQD.Visible = (objqd != null) ? true : false;

                if (objqd != null)
                {
                    if (objqd.IS_OLD_DATA == 1)
                    {
                        isOldData = true;
                    }
                    lkFile.Visible = cmdXoa.Visible = (!String.IsNullOrEmpty(objqd.TENFILE)) ? true : false;
                }

                // Kiểm tra TOA_GIAIQUYET_ID
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!string.IsNullOrEmpty(donviID) && objqd != null && objqd.TOA_GIAIQUYET_ID.HasValue)
                {
                    if (objqd.TOA_GIAIQUYET_ID.ToString() != donviID)
                    {
                        LoadDsNguoiKy(objqd.TOA_GIAIQUYET_ID.Value);
                        cmdSave.Visible = false;
                        cmdXoaQD.Visible = false;
                        cmdQuaylaiB.Visible = false;
                        cmdSave2.Visible = false;
                        cmdQuaylai2.Visible = false;

                        lbthongbao.Text = "Đơn đã chuyển sang tòa khác, không thể chỉnh sửa.";
                    }
                }
            }

            Load_DsHinhPhat();
            LoadQuyetDinhTHA_DaCo(HeThong_VuAnID, HeThong_BiAnID);

            AHS_VUAN ahsVuAN = dt.AHS_VUAN.Where(x => x.ID == HeThong_VuAnID).FirstOrDefault();
            if (isOldData)
            {
                pnHinhPhat.Visible = true;
                pnAnPhi.Visible = false;
                pnAnPhiPT.Visible = false;
            }
            else
            {
                if (ahsVuAN.MAGIAIDOAN == 2)
                {
                    pnAnPhi.Visible = true;
                    pnAnPhiPT.Visible = false;
                    LoadBiAnHinhPhat();
                }
                else
                {
                    pnAnPhi.Visible = false;
                    pnAnPhiPT.Visible = true;
                    LoadDsBiCaoPT();
                }
                pnHinhPhat.Visible = false;
            }
        }

        #region Load danh sách người ký, chức vụ

        void LoadDsNguoiKy(Decimal donvi)
        {
            //Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);
            dropNguoiKy.DataSource = oCBDT;
            dropNguoiKy.DataTextField = "HOTEN";
            dropNguoiKy.DataValueField = "ID";
            dropNguoiKy.DataBind();
            dropNguoiKy.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }

        private void loadTinhTrangBiAn()
        {
            DM_DATAITEM_BL db = new DM_DATAITEM_BL();
            DataTable data = db.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.AHS_TINHTRANGBIAN);
            dropTTBiAn.DataSource = data;
            dropTTBiAn.DataTextField = "TEN";
            dropTTBiAn.DataValueField = "MA";
            dropTTBiAn.DataBind();
            dropTTBiAn.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }

        protected void dropNguoiKy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropNguoiKy.SelectedValue != "0")
            {
                try
                {
                    Decimal CanBoID = Convert.ToDecimal(dropNguoiKy.SelectedValue);
                    decimal ChucVuId = (Decimal)dt.DM_CANBO.Where(x => x.ID == CanBoID).Single<DM_CANBO>().CHUCVUID;

                    txtChucVu.Text = dt.DM_DATAITEM.Where(x => x.ID == ChucVuId).Single<DM_DATAITEM>().TEN;
                }
                catch (Exception ex)
                {
                }
            }
        }

        #endregion

        #region Load danh sách hình phạt

        void Load_DsHinhPhat()
        {
            try
            {
                //---------Load 3 nhom dhp----------------------------
                DM_DATAGROUP objG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.NHOMHINHPHAT)
                    .Single<DM_DATAGROUP>();
                List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == objG.ID).ToList<DM_DATAITEM>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (DM_DATAITEM data in lst)
                    {
                        switch (data.MA + "")
                        {
                            case ENUM_NHOMHINHPHAT.NHOM_HPCHINH:
                                lttNhomHPChinh.Text = data.TEN;
                                LoadHinhPhatTheoNhomHP(data.ID, rptHPChinh);
                                break;
                            case ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG:
                                lttNhomHPBoSung.Text = data.TEN;
                                LoadHinhPhatTheoNhomHP(data.ID, rptHPBoSung);
                                break;
                            case ENUM_NHOMHINHPHAT.NHOM_QDKHAC:
                                lttNhomQDKhac.Text = data.TEN;
                                LoadHinhPhatTheoNhomHP(data.ID, rptQDKhac);
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }

        void LoadBiAnHinhPhat()
        {
            THA_BIAN_BL tHA_BIAN_BL = new THA_BIAN_BL();
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            DataTable dtb = tHA_BIAN_BL.GET_THA_BIAN_QUYETDINH_ANPHAT(BiAnID, VuAnID);

            rpt.DataSource = dtb;
            rpt.DataBind();
        }
        void LoadHinhPhatTheoNhomHP(decimal GroupID, Repeater rptControl)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            DM_HINHPHAT_BL objHP = new DM_HINHPHAT_BL();
            DataTable tbl = objHP.GetByNhomHP(GroupID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptControl.DataSource = tbl;
                rptControl.DataBind();
            }
        }

        #endregion

        protected void rptHP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;

                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);

                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                chkAnTreo.Visible = (Convert.ToDecimal(rv["ISANTREO"] + "") > 0) ? true : false;

                Panel pnCoQuanGiamSat = (Panel)e.Item.FindControl("pnCoQuanGiamSat");
                TextBox txtCoQuanGiamSat = (TextBox)e.Item.FindControl("txtCoQuanGiamSat");
                string noiCuTru = "";
                THA_BIAN biCanDauVu = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
                // noi cu tru bi can
                AHS_BICANBICAO biCan = dt.AHS_BICANBICAO.Where(x => x.MABICAN == biCanDauVu.MABICAN).FirstOrDefault();
                // lay noi cu tru huyen
                DM_HANHCHINH huyenBiCao = dt.DM_HANHCHINH.Where(x => x.ID == biCan.TAMTRU_HUYEN).FirstOrDefault();
                if (huyenBiCao != null)
                {
                    noiCuTru += huyenBiCao.MA_TEN;
                }
                decimal group_id = Convert.ToDecimal(rv["NHOMHINHPHAT"] + "");
                String MaNhom = rv["MaNhomHinhPhat"] + "";

                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                Decimal VuAnId = Convert.ToDecimal(hddVuAnID.Value);
                THA_BIAN_QUYETDINH objCT = null;
                THA_BIAN_QUYETDINH_BS objCTBS = null;
                try
                {
                    if (MaNhom == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG)
                    {
                        chkAnTreo.Checked = false;
                        chk.Visible = false;

                        objCTBS = dt.THA_BIAN_QUYETDINH_BS
                            .Where(x => x.BIANID == BiAnID && x.VUANID == VuAnId && x.HINHPHATID == hinhphat)
                            .FirstOrDefault<THA_BIAN_QUYETDINH_BS>();

                        if (objCTBS != null)
                        {
                            hddGroupChange.Value = group_id.ToString();
                        }
                        else
                        {
                            chkAnTreo.Checked = false;
                            chk.Checked = false;
                        }
                    }
                    else
                    {
                        string TINHTRANG_BIAN = null;
                        chk.Visible = true;
                        objCT = dt.THA_BIAN_QUYETDINH
                            .Where(x => x.BIANID == BiAnID && x.VUANID == VuAnId && x.HPC_HINHPHATID == hinhphat)
                            .FirstOrDefault<THA_BIAN_QUYETDINH>();
                        if (objCT != null)
                        {
                            hddGroupChange.Value = group_id.ToString();

                            if (objCT.ISANTREO == 1)
                            {
                                chkAnTreo.Checked = true;
                            }

                            chk.Checked = true;
                            hddHinhPhatChange.Value = hinhphat.ToString();
                            TINHTRANG_BIAN = objCT.TINHTRANG_BIAN;
                        }
                        else
                        {
                            chkAnTreo.Checked = false;
                            chk.Checked = false;
                        }

                        string valueSelectedDropTTBiAn = dropTTBiAn.SelectedValue == "0" && TINHTRANG_BIAN != null
                            ? TINHTRANG_BIAN
                            : dropTTBiAn.SelectedValue;
                        if (pnCoQuanGiamSat != null && objCT != null && objCT.COQUAN_GIAMSAT?.Trim() != "" &&
                            chkAnTreo.Checked && valueSelectedDropTTBiAn == ENUM_TINHTRANG_BIAN.TAM_GIAM)
                        {
                            pnCoQuanGiamSat.Visible = true;
                            txtCoQuanGiamSat.Text = objCT.COQUAN_GIAMSAT != null && objCT.COQUAN_GIAMSAT.Trim() != ""
                                ? objCT.COQUAN_GIAMSAT
                                : "Uỷ ban nhân dân" + noiCuTru;
                        }
                    }
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Load dữ liệu không thành công";
                }

                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt16(rv["LOAIHINHPHAT"] + "");
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        rdTrueFalse.Visible = true;
                        if (objCTBS != null)
                            rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(objCTBS.TF_VALUE + ""))
                                ? "0"
                                : objCTBS.TF_VALUE.ToString();
                        if (objCT != null)
                            rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(objCT.HPC_TF_VALUE + ""))
                                ? "0"
                                : objCT.HPC_TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCTBS != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCTBS.SH_VALUE + ""))
                                ? "0"
                                : objCTBS.SH_VALUE.ToString();
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.HPC_SH_VALUE + ""))
                                ? "0"
                                : objCT.HPC_SH_VALUE.ToString();

                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCTBS != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCTBS.TG_NAM + "")) ? "0" : objCTBS.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCTBS.TG_THANG + ""))
                                ? "0"
                                : objCTBS.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCTBS.TG_NGAY + ""))
                                ? "0"
                                : objCTBS.TG_NGAY.ToString();
                        }

                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.HPC_TG_NAM + ""))
                                ? "0"
                                : objCT.HPC_TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.HPC_TG_THANG + ""))
                                ? "0"
                                : objCT.HPC_TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.HPC_TG_NGAY + ""))
                                ? "0"
                                : objCT.HPC_TG_NGAY.ToString();
                        }

                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCTBS.K_VALUE1 + ""))
                                ? "0"
                                : objCTBS.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCTBS.K_VALUE2 + ""))
                                ? "0"
                                : objCTBS.K_VALUE2.ToString();
                        }

                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.HPC_K_VALUE1 + ""))
                                ? "0"
                                : objCT.HPC_K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.HPC_K_VALUE2 + ""))
                                ? "0"
                                : objCT.HPC_K_VALUE2.ToString();
                        }

                        break;
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        rdDefaultTrue.Visible = false;
                        if (objCTBS != null)
                            rdDefaultTrue.SelectedValue = "1";
                        if (objCT != null)
                            rdDefaultTrue.SelectedValue = "1";
                        break;
                }
            }
        }

        void LoadQuyetDinhTHA_DaCo(Decimal HeThong_VuAnID, Decimal HeThong_BiAnID)
        {
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            THA_BIAN_QUYETDINH obj = null;
            try
            {
                obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID
                                                       && x.VUANID == VuAnID
                //&& x.TOAANID == ToaAnID
                ).Single<THA_BIAN_QUYETDINH>();
            }
            catch (Exception ex)
            {
            }

            if (obj != null)
            {
                txtNgayQD.Text = obj.QD_NGAY != null ? ((DateTime)obj.QD_NGAY).ToString("dd/MM/yyyy", cul) : "";
                txtNgayTHA.Text = obj.NGAYTHIHANH != null
                    ? ((DateTime)obj.NGAYTHIHANH).ToString("dd/MM/yyyy", cul)
                    : "";

                txtSoQD.Text = obj.QD_SO;
                txtNoiChapHanhAn.Text = obj.NOICHAPHANHAN;

                hddFilePath.Value = obj.TENFILE;
                lkFile.Text = obj.TENFILE;
                txtChucVu.Text = obj.CHUCVU + "";

                dropTTBiAn.SelectedValue = obj.TINHTRANG_BIAN;
                txtTTTuNgay.Text = obj.NGAYBATDAU_TAMGIAM?.ToString("dd/MM/yyyy", cul);
                txtTTDenNgay.Text = obj.NGAYKETTHUC_TAMGIAM?.ToString("dd/MM/yyyy", cul);
                txtNoiTamGiam.Text = obj.NOI_TAMGIAM;
                txtSoQDTruyNa.Text = obj.SOQD_TRUYNA;
                txtNgayQDTruyNa.Text = obj.NGAYQD_TRUYNA?.ToString("dd/MM/yyyy", cul);
                txtSoLenhAPGiai.Text = obj.SOLENH_APGIAI;
                txtNgayLenhApGiai.Text = obj.NGAYLENH_APGIAI?.ToString("dd/MM/yyyy", cul);

                txtSTBTraiGiam.Text = obj.SOTB_TRAIGIAM;
                txtNgayTBTraiGiam.Text = obj.NGAYTB_TRAIGIAM?.ToString("dd/MM/yyyy", cul);
                txtThongTinTraiGiam.Text = obj.THONGTIN_TRAIGIAM;
                txtSoGiayBaoTu.Text = obj.SOGIAY_BAOTU;
                txtNgayGiayBaoTu.Text = obj.NGAYGIAY_BAOTU?.ToString("dd/MM/yyyy", cul);
                txtNoiCapGiay.Text = obj.NOICAP_GIAY;

                try
                {
                    dropNguoiKy.SelectedValue = (String.IsNullOrEmpty(obj.NGUOIKY + "")) ? "0" : obj.NGUOIKY.ToString();
                    dropTTBiAn.SelectedValue = obj.TINHTRANG_BIAN;
                }
                catch (Exception ex)
                {
                    logger.Error("loi xay ra: " + ex);
                    lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                }
            }
            else
            {
                txtNgayQD.Text = "";
                txtNgayTHA.Text = "";

                txtSoQD.Text = "";
                txtNoiChapHanhAn.Text = "";

                hddFilePath.Value = "";
                lkFile.Text = "";
                txtChucVu.Text = "";
                dropNguoiKy.SelectedValue = "0";
            }
        }

        protected void cmdSave_Click(object sender, EventArgs e)
        {
            try
            {
                string valueSelected = dropTTBiAn.SelectedValue;
                if (!CheckValid(valueSelected)) return;
                UPdate_QuyetDinh();
                Decimal BiAnID = Convert.ToDecimal(hddBiAnID.Value);
                Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                THA_BIAN_QUYETDINH tbq = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID).FirstOrDefault();

                // cập nhật với trường hợp QĐ THA với form cũ.
                if (tbq != null && tbq.IS_OLD_DATA == 1)
                {
                    Update_HinhPhatChinh(rptHPChinh, BiAnID);
                    Update_HinhPhatChinh(rptQDKhac, BiAnID);
                    Update_HinhPhatBS(rptHPBoSung, BiAnID);
                }
                else
                {
                    
                    THA_BIAN tb = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();

                    AHS_BICANBICAO ab = dt.AHS_BICANBICAO.Where(x => x.ID == tb.IDBICANHETHONG).FirstOrDefault();
                    AHS_VUAN av = dt.AHS_VUAN.Where(x => x.ID == ab.VUANID).FirstOrDefault();
                    bool checkAnTreo = false;
                    if (av.MAGIAIDOAN == 2)
                    {
                        List<THA_SOTHAM_BANAN_DIEU_CHITIET> tsbdcs = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_DIEU_CHITIET>($"VUANID = {VuAnID} AND BICANID = {BiAnID}");
                        if (tsbdcs != null && tsbdcs.Count > 0)
                        {
                            foreach (THA_SOTHAM_BANAN_DIEU_CHITIET tsbdc in tsbdcs)
                            {
                                if (tsbdc.ISANTREO == 1)
                                {
                                    checkAnTreo = true;
                                    break;
                                }
                            }
                        }
                       
                    }
                    else
                    {
                        List<THA_PHUCTHAM_BANAN_DIEU_CT> tsbdcs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"VUANID = {VuAnID} AND BICANID = {BiAnID}");
                        if (tsbdcs != null && tsbdcs.Count > 0)
                        {
                            foreach (THA_PHUCTHAM_BANAN_DIEU_CT tsbdc in tsbdcs)
                            {
                                if (tsbdc.ISANTREO == 1)
                                {
                                    checkAnTreo = true;
                                    break;
                                }
                            }
                        }
                    }
                    if (checkAnTreo && tbq != null && tbq.TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM)
                    {
                        THA_BIEUMAU_BL thaBieuMauBL = new THA_BIEUMAU_BL();
                        thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiAnID, ENUM_MA_BIEUMAU.THA_TAMGIAM);

                        string maBieuMau = ENUM_MA_BIEUMAU.THA_ANTREO;
                        saveBieuMau(maBieuMau, VuAnID, BiAnID);
                    }
                    
                }
                

                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo",
                    "Cập nhật quyết định thi hành án cho bị án thành công!");
                cmdXoaQD.Visible = true;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lưu không thành công, vui lòng liên hệ với quản trị!";
            }
        }

        protected void cmdXoaQD_Click(object sender, EventArgs e)
        {
            try
            {
                if (CheckQuyenSuaXoa())
                {
                    Xoa_QuyetDinh();
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo",
                        "Xóa quyết định Thi hành án cho bị án thành công!");
                }
            }
            catch (Exception ex)
            {
            }
        }

        void UPdate_QuyetDinh()
        {
            DateTime? date_temp;
            Boolean IsUpdate = false;
            Decimal BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            THA_BIAN_QUYETDINH obj = new THA_BIAN_QUYETDINH();
            THA_VUAN objvuan = dt.THA_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            THA_BIAN objbian = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
            if (BiAnID > 0)
            {
                try
                {
                    obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                        .Single<THA_BIAN_QUYETDINH>();
                    IsUpdate = true;
                }
                catch (Exception ex)
                {
                    obj = new THA_BIAN_QUYETDINH();
                }
            }
            else
                obj = new THA_BIAN_QUYETDINH();

            obj.BIANID = BiAnID;
            obj.VUANID = VuAnID;
            obj.QD_SO = txtSoQD.Text.Trim();

            date_temp = (String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                ? (DateTime?)null
                : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.QD_NGAY = date_temp;
            obj.NGUOIKY = dropNguoiKy.SelectedValue;
            obj.CHUCVU = txtChucVu.Text.Trim();

            obj.NGAYTHIHANH = (String.IsNullOrEmpty(txtNgayTHA.Text?.Trim()))
                ? (DateTime?)null
                : DateTime.Parse(this.txtNgayTHA.Text?.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NOICHAPHANHAN = txtNoiChapHanhAn.Text.Trim();

            // VNPT Biểu mẫu thi hành án
            string valueSelectedDropTTBiAn = dropTTBiAn.SelectedValue;

            if (obj.TINHTRANG_BIAN != valueSelectedDropTTBiAn)
            {
                THA_BIEUMAU_BL thaBieuMauBL = new THA_BIEUMAU_BL();
                thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiAnID, "THA-01,THA-02,THA-03");
            }

            obj.TINHTRANG_BIAN = valueSelectedDropTTBiAn;

            string maBieuMau = "";
            switch (valueSelectedDropTTBiAn)
            {
                case ENUM_TINHTRANG_BIAN.TAI_NGOAI:
                    obj.NGAYBATDAU_TAMGIAM = (String.IsNullOrEmpty(txtTTTuNgay.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtTTTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYKETTHUC_TAMGIAM = (String.IsNullOrEmpty(txtTTDenNgay.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtTTDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NOI_TAMGIAM = txtNoiTamGiam.Text?.Trim();
                    obj.SOQD_TRUYNA = null;
                    obj.NGAYQD_TRUYNA = null;
                    obj.SOLENH_APGIAI = null;
                    obj.NGAYLENH_APGIAI = null;
                    maBieuMau = ENUM_MA_BIEUMAU.THA_TAINGOAI;

                    obj.SOTB_TRAIGIAM = null;
                    obj.NGAYTB_TRAIGIAM = (DateTime?)null;
                    obj.THONGTIN_TRAIGIAM = null;
                    obj.SOGIAY_BAOTU = null;
                    obj.NGAYGIAY_BAOTU = (DateTime?)null;
                    obj.NOICAP_GIAY = null;
                    break;
                case ENUM_TINHTRANG_BIAN.BO_TRON:
                    obj.NGAYBATDAU_TAMGIAM = null;
                    obj.NGAYKETTHUC_TAMGIAM = null;
                    obj.NOI_TAMGIAM = null;
                    obj.SOQD_TRUYNA = txtSoQDTruyNa.Text?.Trim();
                    obj.NGAYQD_TRUYNA = (String.IsNullOrEmpty(txtNgayQDTruyNa.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtNgayQDTruyNa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.SOLENH_APGIAI = txtSoLenhAPGiai.Text?.Trim();
                    obj.NGAYLENH_APGIAI = (String.IsNullOrEmpty(txtNgayLenhApGiai.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtNgayLenhApGiai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    obj.SOTB_TRAIGIAM = null;
                    obj.NGAYTB_TRAIGIAM = (DateTime?)null;
                    obj.THONGTIN_TRAIGIAM = null;
                    obj.SOGIAY_BAOTU = null;
                    obj.NGAYGIAY_BAOTU = (DateTime?)null;
                    obj.NOICAP_GIAY = null;
                    break;
                case ENUM_TINHTRANG_BIAN.TAM_GIAM:
                    obj.NGAYBATDAU_TAMGIAM = null;
                    obj.NGAYKETTHUC_TAMGIAM = null;
                    obj.NOI_TAMGIAM = txtNoiTamGiam.Text?.Trim();
                    ;
                    obj.SOQD_TRUYNA = null;
                    obj.NGAYQD_TRUYNA = null;
                    obj.SOLENH_APGIAI = null;
                    obj.NGAYLENH_APGIAI = null;
                    maBieuMau = ENUM_MA_BIEUMAU.THA_TAMGIAM;

                    obj.SOTB_TRAIGIAM = txtSTBTraiGiam.Text;
                    obj.NGAYTB_TRAIGIAM = (String.IsNullOrEmpty(txtNgayTBTraiGiam.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtNgayTBTraiGiam.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.THONGTIN_TRAIGIAM = txtThongTinTraiGiam.Text;
                    obj.SOGIAY_BAOTU = txtSoGiayBaoTu.Text;
                    obj.NGAYGIAY_BAOTU = (String.IsNullOrEmpty(txtNgayGiayBaoTu.Text?.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(this.txtNgayGiayBaoTu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NOICAP_GIAY = txtNoiCapGiay.Text;

                    break;
            }


            if (maBieuMau != null && maBieuMau != "")
            {
                saveBieuMau(maBieuMau, VuAnID, BiAnID);
            }
            // VNPT Biểu mẫu thi hành án

            UploadFile(obj);
            obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

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
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_BIAN_QUYETDINH.Add(obj);
                dt.SaveChanges();
            }

            hddCurrentID.Value = obj.ID.ToString();
            lkFile.Text = obj.TENFILE;
            lkFile.Visible = cmdXoa.Visible = (!String.IsNullOrEmpty(obj.TENFILE)) ? true : false;
        }

        private void saveBieuMau(String maBieuMau, decimal VuAnID, decimal BiAnID)
        {
            DM_BIEUMAU bIEUMAU = dt.DM_BIEUMAU.Where(x => x.MABM == maBieuMau).FirstOrDefault();
            THA_FILE tHA_FILE = DataExtensions
                .GetAllWithClause<THA_FILE>($"VUANID = {VuAnID} AND BIANID = {BiAnID} AND BIEUMAUID = {bIEUMAU.ID}")
                .FirstOrDefault();
            if (tHA_FILE == null)
            {
                THA_FILE fileBieuMau = new THA_FILE();
                fileBieuMau.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                fileBieuMau.VUANID = VuAnID;
                fileBieuMau.BIEUMAUID = bIEUMAU.ID;
                fileBieuMau.MAGIAIDOAN = 2;
                fileBieuMau.NGAYTAO = DateTime.Now;
                fileBieuMau.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                fileBieuMau.BIANID = BiAnID;
                fileBieuMau.LOAIFILE = 0;
                DataExtensions.Insert<THA_FILE>(fileBieuMau);
            }
        }

        void Update_HinhPhatChinh(Repeater rpt, Decimal BiCanID)
        {
            try
            {
                Decimal QuyetDinhID = String.IsNullOrEmpty(hddCurrentID.Value)
                    ? 0
                    : Convert.ToDecimal(hddCurrentID.Value);
                THA_BIAN_QUYETDINH obj = dt.THA_BIAN_QUYETDINH.Where(x => x.ID == QuyetDinhID)
                    .FirstOrDefault<THA_BIAN_QUYETDINH>();

                if (obj != null)
                {
                    foreach (RepeaterItem itemHP in rpt.Items)
                    {

                        CheckBox chk = (CheckBox)itemHP.FindControl("chk");
                        if (chk.Checked == true)
                        {
                            GetValue(obj, itemHP);
                            dt.SaveChanges();
                        }
                    }

                    lbthongbao.Text = "Lưu hình phạt thành công!";
                }
                else
                {
                    lbthongbao.Text = "Lỗi: Hình phạt chưa được lưu!";
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Thao tác không thành công!";
            }
        }

        void Update_HinhPhatBS(Repeater rpt, Decimal BiCanID)
        {
            bool CheckUpdate = false;

            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            THA_BIAN_QUYETDINH_BS obj;

            foreach (RepeaterItem itemHP in rpt.Items)
            {
                HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);

                obj = dt.THA_BIAN_QUYETDINH_BS
                    .Where(x => x.BIANID == BiCanID && x.VUANID == VuAnID && x.HINHPHATID == hinhphatid)
                    .FirstOrDefault<THA_BIAN_QUYETDINH_BS>();

                if (obj == null)
                {
                    obj = new THA_BIAN_QUYETDINH_BS();
                    CheckUpdate = GetValue_BS(obj, itemHP);
                    if (CheckUpdate == true)
                    {
                        dt.THA_BIAN_QUYETDINH_BS.Add(obj);
                        dt.SaveChanges();
                    }
                }
                else
                {
                    CheckUpdate = GetValue_BS(obj, itemHP);
                    if (CheckUpdate == true)
                        dt.SaveChanges();
                }

                lbthongbao.Text = "Lưu hình phạt thành công!";
            }
        }

        void GetValue(THA_BIAN_QUYETDINH obj, RepeaterItem itemHP)
        {
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);

            string valueSelectedDropTTBiAn = dropTTBiAn.SelectedValue;

            obj.VUANID = VuAnID;
            obj.BIANID = BiAnID;
            obj.HPC_HINHPHATID = hinhphatid;
            obj.HPC_LOAIID = loai_hp;

            if (obj.HPC_HINHPHATID == 5)
            {
                CheckBox chkAnTreo = (CheckBox)itemHP.FindControl("chkAnTreo");
                obj.ISANTREO = (chkAnTreo.Checked) ? 1 : 0;

                // VNPT Biểu mẫu thi hành án
                TextBox txtCoQuanGiamSat = (TextBox)itemHP.FindControl("txtCoQuanGiamSat");
                if (valueSelectedDropTTBiAn == ENUM_TINHTRANG_BIAN.TAM_GIAM && chkAnTreo.Checked)
                {
                    obj.COQUAN_GIAMSAT = txtCoQuanGiamSat.Text?.Trim();
                }
                else
                {
                    obj.COQUAN_GIAMSAT = null;
                }

                if (chkAnTreo.Checked)
                {
                    // xóa biểu mẫu thi hành án
                    THA_BIEUMAU_BL thaBieuMauBL = new THA_BIEUMAU_BL();
                    thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiAnID, "THA-03");

                    string maBieuMau = ENUM_MA_BIEUMAU.THA_ANTREO;
                    saveBieuMau(maBieuMau, VuAnID, BiAnID);
                }
                // VNPT Biểu mẫu thi hành án

            }
            else
            {
                obj.ISANTREO = 0;
            }

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    obj.HPC_TF_VALUE = 1;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    obj.HPC_TF_VALUE = Convert.ToDecimal(rdTrueFalse.SelectedValue);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.HPC_SH_VALUE = String.IsNullOrEmpty(txtSohoc.Text) ? 0 : Convert.ToDecimal(txtSohoc.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.HPC_TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.HPC_TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.HPC_TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.HPC_K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.HPC_K_VALUE2 = txtKhac2.Text.Trim();
                    break;
            }
        }

        bool GetValue_BS(THA_BIAN_QUYETDINH_BS obj, RepeaterItem itemHP)
        {
            bool CheckUpdate = false;

            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;

            obj.VUANID = VuAnID;
            obj.BIANID = BiAnID;

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    obj.TF_VALUE = 1;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    obj.TF_VALUE = String.IsNullOrEmpty(rdTrueFalse.SelectedValue)
                        ? 0
                        : Convert.ToDecimal(rdTrueFalse.SelectedValue);
                    CheckUpdate = (!String.IsNullOrEmpty(rdTrueFalse.SelectedValue)) ? true : false;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = String.IsNullOrEmpty(txtSohoc.Text) ? 0 : Convert.ToDecimal(txtSohoc.Text);
                    CheckUpdate = (!String.IsNullOrEmpty(txtSohoc.Text)) ? true : false;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    CheckUpdate = (obj.TG_NGAY != 0 && obj.TG_THANG != 0 && obj.TG_NAM != 0) ? true : false;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    CheckUpdate = (obj.K_VALUE1 != 0 && !String.IsNullOrEmpty(obj.K_VALUE2)) ? true : false;
                    break;
            }

            return CheckUpdate;
        }

        void CheckQuyen()
        {
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                {
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    if(obj.IS_KHONGTHA == 1)
                    {
                        cmdSave.Visible = cmdSave2.Visible = false;
                        lbthongbao.Text = lttNhomHPBoSung.Text = lttNhomHPChinh.Text =
                        lttNhomQDKhac.Text = "Bị án không phải thi hành án.";
                    }
                }
                    
                else
                {
                    lbthongbao.Text = lttNhomHPBoSung.Text = lttNhomHPChinh.Text =
                        lttNhomQDKhac.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdSave.Visible = cmdSave2.Visible = false;
                    cmdUpdateAnPhi.Visible = rpt.Visible = false;
                }
            }
            catch (Exception ex)
            {
                cmdSave.Visible = cmdSave2.Visible = false;
                cmdUpdateAnPhi.Visible = rpt.Visible = false;
                lbthongbao.Text = lttNhomHPBoSung.Text = lttNhomHPChinh.Text =
                    lttNhomQDKhac.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
            }
        }

        bool CheckQuyenSuaXoa()
        {
            Decimal BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);

            THA_CVDON_THULY cvd_tl = dt.THA_CVDON_THULY.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                .FirstOrDefault();
            if (cvd_tl != null)
            {
                lbthongbao.Text = lbthongbaoA.Text = "Đã có 4.1.Thụ lý công văn/đơn. Không được thay đổi thông tin!";
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = false;
                return false;
            }

            THA_UYTHAC_QUYETDINH qduttha = dt.THA_UYTHAC_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                .FirstOrDefault();
            if (qduttha != null)
            {
                lbthongbao.Text = lbthongbaoA.Text =
                    "Đã có 5.1.Quyết định ủy thác thi hành án. Không được thay đổi thông tin!";
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = false;
                return false;
            }

            THA_CACQDKHAC qdk = dt.THA_CACQDKHAC.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID).FirstOrDefault();
            if (qdk != null)
            {
                lbthongbao.Text = lbthongbaoA.Text = "Đã có 6.Các quyết định khác. Không được thay đổi thông tin!";
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = false;
                return false;
            }

            THA_ANTICH_DON xattld = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                .FirstOrDefault();
            if (xattld != null)
            {
                lbthongbao.Text = lbthongbaoA.Text = "Đã có 7.1.Thụ lý đơn. Không được thay đổi thông tin!";
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = false;
                return false;
            }

            THA_DACXA dxtld = dt.THA_DACXA.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID).FirstOrDefault();
            if (dxtld != null)
            {
                lbthongbao.Text = lbthongbaoA.Text = "Đã có 8.Thụ lý đơn. Không được thay đổi thông tin!";
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = false;
                return false;
            }

            THA_BIAN_BL objBL = new THA_BIAN_BL();
            string result = objBL.CHECK_THA_BIAN_DONGBO(BiAnID, 1);
            if (!string.IsNullOrEmpty(result))
            {
                lbthongbao.Text = lbthongbaoA.Text = result;
                cmdSave.Visible = cmdXoaQD.Visible = cmdSave2.Visible = cmdUpdateAnPhi.Visible = false;
                return false;
            }

            return true;
        }

        #region File

        protected void lkFile_Click(object sender, EventArgs e)
        {
            DowloadFile();
        }

        void DowloadFile()
        {
            try
            {
                Decimal CurrID = Convert.ToDecimal(hddCurrentID.Value);
                THA_BIAN_QUYETDINH oND = dt.THA_BIAN_QUYETDINH.Where(x => x.ID == CurrID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null,
                        absoluteExpiration: DateTime.Now.AddSeconds(30),
                        slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download",
                        "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey +
                        "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", ex.Message);
            }
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath",
                    "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        //protected void AsyncFileUpLoad_UploadedComplete1(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    if (fileupload.HasFile)
        //    {
        //        string strFileName = fileupload.FileName;
        //        string path = Server.MapPath("~/TempUpload/") + strFileName;
        //        fileupload.SaveAs(path);

        //        path = path.Replace("\\", "/");
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //    }
        //}
        void UploadFile(THA_BIAN_QUYETDINH obj)
        {
            //string folder_upload = "/TempUpload";
            //string strPath = Server.MapPath(folder_upload);
            ////strPath = strPath.Replace("\\", "/");
            //if (!System.IO.Directory.Exists(strPath))
            //{
            //    try
            //    {
            //        System.IO.Directory.CreateDirectory(strPath);
            //    }
            //    catch (Exception ex)
            //    {
            //        throw ex;
            //    }
            //}
            //string file_path = "";
            //string filename = "";
            //byte[] buff = null;
            //if (fileupload.HasFile)
            //{
            //    //-----upload file len server
            //    filename = Path.GetFileName(fileupload.PostedFile.FileName);
            //    file_path = strPath + "\\" + filename;
            //    fileupload.PostedFile.SaveAs(file_path);

            //    //----------doc file vua duoc upload len server de lay noi dung-------------
            //    using (FileStream fs = File.OpenRead(file_path))
            //    {
            //        BinaryReader br = new BinaryReader(fs);
            //        FileInfo oF = new FileInfo(file_path);
            //        long numBytes = oF.Length;
            //        buff = br.ReadBytes((int)numBytes);

            //        obj.TENFILE = oF.Name;
            //        obj.NOIDUNG = buff;
            //        obj.KIEUFILE = oF.Extension;
            //    }

            //    //xoa file
            //    File.Delete(file_path);
            //}
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        obj.NOIDUNG = buff;
                        obj.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                        obj.KIEUFILE = oF.Extension;

                    }

                    File.Delete(strFilePath);
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = ex.Message;
                }
            }
        }

        protected void cmdXoa_Click(object sender, ImageClickEventArgs e)
        {
            Decimal CurrID = Convert.ToDecimal(hddCurrentID.Value);
            THA_BIAN_QUYETDINH oND = dt.THA_BIAN_QUYETDINH.Where(x => x.ID == CurrID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                oND.TENFILE = "";
                oND.NOIDUNG = null;
                oND.KIEUFILE = "";
                dt.SaveChanges();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Tệp đính kèm được xóa thành công!");
            }

            hddFilePath.Value = "";
            cmdXoa.Visible = false;
            lkFile.Visible = false;

        }

        #endregion

        void Xoa_QuyetDinh()
        {
            Decimal BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            //Xóa hình phạt bổ sung
            THA_BIAN_QUYETDINH_BS objbs = null;
            try
            {
                objbs = dt.THA_BIAN_QUYETDINH_BS.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                    .Single<THA_BIAN_QUYETDINH_BS>();
            }
            catch (Exception ex)
            {
            }

            if (objbs != null)
            {
                dt.THA_BIAN_QUYETDINH_BS.Remove(objbs);
            }

            //Xóa hình phạt chính
            THA_BIAN_QUYETDINH obj = null;
            THA_FILE tHA_FILE = null;
            try
            {
                obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID)
                    .Single<THA_BIAN_QUYETDINH>();
            }
            catch (Exception ex)
            {
            }

            if (obj != null)
            {
                // xóa biểu mẫu thi hành án
                THA_BIEUMAU_BL thaBieuMauBL = new THA_BIEUMAU_BL();
                thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiAnID, "THA-01,THA-02,THA-03");

                dt.THA_BIAN_QUYETDINH.Remove(obj);
                dt.SaveChanges();
                cmdXoaQD.Visible = false;
                LoadInfo();
            }
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void chk_CheckedChanged(object sender, EventArgs e)
        {
        }

        protected void chkAnTreo_CheckedChanged(object sender, EventArgs e)
        {
            var chk = sender as CheckBox;
            if (chk == null)
                return;
            var repeaterItem = chk.NamingContainer as RepeaterItem;
            if (repeaterItem == null)
                return;

            var pnCoQuanGiamSat = repeaterItem.FindControl("pnCoQuanGiamSat") as Panel;
            var txtCoQuanGiamSat = repeaterItem.FindControl("txtCoQuanGiamSat") as TextBox;
            string valueSelectedDropTTBiAn = dropTTBiAn.SelectedValue;
            THA_BIAN biCanDauVu = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
            // noi cu tru bi can
            AHS_BICANBICAO biCan = dt.AHS_BICANBICAO.Where(x => x.MABICAN == biCanDauVu.MABICAN).FirstOrDefault();
            string noiChapHanh = "";
            // lay noi cu tru huyen
            DM_HANHCHINH huyenBiCao = dt.DM_HANHCHINH.Where(x => x.ID == biCan.TAMTRU_HUYEN).FirstOrDefault();
            if (huyenBiCao != null)
            {
                noiChapHanh += huyenBiCao.MA_TEN;
            }
            THA_BIAN_QUYETDINH objCT = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (pnCoQuanGiamSat != null && chk.Checked && valueSelectedDropTTBiAn == ENUM_TINHTRANG_BIAN.TAM_GIAM)
            {
                pnCoQuanGiamSat.Visible = true;
                if (objCT != null && objCT.COQUAN_GIAMSAT != null && objCT.COQUAN_GIAMSAT.Trim() != "")
                {
                    txtCoQuanGiamSat.Text = objCT.COQUAN_GIAMSAT;
                }
                else
                {
                    txtCoQuanGiamSat.Text = "Uỷ ban nhân dân " + noiChapHanh;
                }
            }
            else
            {
                pnCoQuanGiamSat.Visible = false;
            }
        }

        protected void dropTTBiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadTinhTrangBiAnView();
            //var item =  rptHPChinh.Items;
            //var pnCoQuanGiamSat = rptHPChinh.FindControl("pnCoQuanGiamSat") as Panel;
            string valueSelected = dropTTBiAn.SelectedValue;
            //if (valueSelected != ENUM_TINHTRANG_BIAN.TAM_GIAM && pnCoQuanGiamSat.Visible == true)
            //{
            //    pnCoQuanGiamSat.Visible = false;
            //}

            foreach (RepeaterItem item in rptHPChinh.Items)
            {
                Panel pnCoQuanGiamSat = item.FindControl("pnCoQuanGiamSat") as Panel;
                CheckBox chkAnTreo = item.FindControl("chkAnTreo") as CheckBox;
                var txtCoQuanGiamSat = item.FindControl("txtCoQuanGiamSat") as TextBox;
                if (pnCoQuanGiamSat != null)
                {
                    if (valueSelected != ENUM_TINHTRANG_BIAN.TAM_GIAM && pnCoQuanGiamSat.Visible)
                    {
                        pnCoQuanGiamSat.Visible = false;
                    }
                    else if (valueSelected == ENUM_TINHTRANG_BIAN.TAM_GIAM && chkAnTreo.Checked)
                    {
                        Decimal VuAnId = Convert.ToDecimal(hddVuAnID.Value);

                        THA_BIAN_QUYETDINH objCT = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();

                        THA_BIAN biCanDauVu = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
                        // noi cu tru bi can
                        AHS_BICANBICAO biCan = dt.AHS_BICANBICAO.Where(x => x.MABICAN == biCanDauVu.MABICAN).FirstOrDefault();
                        string noiChapHanh = "";
                        // lay noi cu tru huyen
                        DM_HANHCHINH huyenBiCao = dt.DM_HANHCHINH.Where(x => x.ID == biCan.TAMTRU_HUYEN).FirstOrDefault();
                        if (huyenBiCao != null)
                        {
                            noiChapHanh = huyenBiCao.MA_TEN + "";
                        }
                        pnCoQuanGiamSat.Visible = true;
                        if (objCT != null && objCT.COQUAN_GIAMSAT != null && objCT.COQUAN_GIAMSAT.Trim() != "")
                        {
                            txtCoQuanGiamSat.Text = objCT.COQUAN_GIAMSAT;
                        }
                        else
                        {
                            txtCoQuanGiamSat.Text = "Uỷ ban nhân dân " + noiChapHanh;
                        }
                    }
                }
            }
        }

        private void loadTinhTrangBiAnView()
        {

            string valueSelected = dropTTBiAn.SelectedValue;

            showButtonTaiNgoai(false);
            showButtonBoTron(false);
            pnThongTinGiamGiu.Visible = false;
            requireNgayThiHanh.Visible = false;
            pnRequireNoiTamGiam.Visible = false;

            if (valueSelected == ENUM_TINHTRANG_BIAN.TAI_NGOAI)
            {
                showButtonTaiNgoai(true);
            }
            else if (valueSelected == ENUM_TINHTRANG_BIAN.BO_TRON)
            {
                showButtonBoTron(true);
            }
            else if (valueSelected == ENUM_TINHTRANG_BIAN.TAM_GIAM)
            {
                requireNgayThiHanh.Visible = true;
                pnThongTinGiamGiu.Visible = true;
                pnNoiTamGiam.Visible = true;
                pnRequireNoiTamGiam.Visible = true;
            }
        }

        public void showButtonTaiNgoai(Boolean isShow)
        {
            pnThoiGianTTBian.Visible = isShow;
            pnNoiTamGiam.Visible = isShow;
            pnRequireNoiTamGiam.Visible = isShow;
            requireNgayThiHanh.Visible = false;
        }

        public void showButtonBoTron(Boolean isShow)
        {
            pnQDTruyNa.Visible = isShow;
            pnApGiai.Visible = isShow;
            requireNgayThiHanh.Visible = false;
        }

        private bool CheckValid(string tinhTrang)
        {
            if (!tinhTrang.Equals(ENUM_TINHTRANG_BIAN.BO_TRON) && (txtNoiTamGiam.Text == null || txtNoiTamGiam.Text == ""))
            {
                lbthongbao.Text = "Bạn chưa nhập Nơi tạm giam. Hãy kiểm tra lại !";
                txtNoiTamGiam.Focus();
                return false;
            }

            foreach (RepeaterItem item in rptHPChinh.Items)
            {
                Panel pnCoQuanGiamSat = item.FindControl("pnCoQuanGiamSat") as Panel;
                TextBox txtCoQuanGiamSat = item.FindControl("txtCoQuanGiamSat") as TextBox;
                if (pnCoQuanGiamSat != null)
                {
                    if ((txtCoQuanGiamSat.Text == null || txtCoQuanGiamSat.Text == "") && pnCoQuanGiamSat.Visible)
                    {
                        lbthongbao.Text = "Bạn chưa nhập Cơ quan giám sát, giáo dục. Hãy kiểm tra lại !";
                        txtCoQuanGiamSat.Focus();
                        return false;
                    }
                }
            }

            return true;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "ToiDanh":
                    string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    //if (Result != "")
                    //{
                    //    lttMsgAnPhi.Text = Result;
                    //    return;
                    //}
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popupChonToiDanh(" + curr_id + ")");
                    break;
            }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                //int IsShow = Convert.ToInt16(dv["IsShow"] + "");
                //if (IsShow == 0)
                //{
                //    Panel lnLinkToiDanh = (Panel)e.Item.FindControl("lnLinkToiDanh");
                //    lnLinkToiDanh.Visible = false;
                //}

                // check quyền để hiển disable
                CheckBox chkThamGiaPhienToa = (CheckBox)e.Item.FindControl("chkThamGiaPhienToa");
                TextBox txtAnPhi = (TextBox)e.Item.FindControl("txtAnPhi");
                TextBox txtNgaynhanbanan = (TextBox)e.Item.FindControl("txtNgaynhanbanan");

                DateTime ngaynhan = String.IsNullOrEmpty(dv["NgayNhanBanAn"] + "") ? DateTime.MinValue : Convert.ToDateTime(dv["NgayNhanBanAn"] + "");
                if (ngaynhan == DateTime.MinValue)
                    txtNgaynhanbanan.Text = "";
                else
                    txtNgaynhanbanan.Text = ngaynhan.ToString("dd/MM/yyyy", cul);
                // Tong hop toi danh
                //lblTHtoidanh
                HiddenField hddBiCao = (HiddenField)e.Item.FindControl("hddBiCao");
                decimal vBicaoID = Convert.ToDecimal(hddBiCao.Value);

                THA_TONGHOPHINHPHAT tonghophinhphat = DataExtensions.GetAllWithClause<THA_TONGHOPHINHPHAT>($"VUANID= {VuAnID} AND BICAOID = {vBicaoID}").FirstOrDefault();
                try
                {
                    Label lblTHtoidanh = (Label)e.Item.FindControl("lblTHtoidanh");
                    lblTHtoidanh.Text = tonghophinhphat.Tonghophinhphat_ST(VuAnID, vBicaoID);
                }
                catch (Exception ex) { }


                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!string.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    chkThamGiaPhienToa.Enabled = false;
                    txtAnPhi.Enabled = false;
                    txtNgaynhanbanan.Enabled = false;
                }
            }
        }

        // Update thong tin an phi & Load DSBiCao_AnPhi
        protected void cmdUpdateAnPhi_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = string.Empty;
            THA_SOTHAM_BANAN_BICAO obj = null;
            Boolean IsNew = false;
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            if (rpt.Items.Count > 0)
            {
                foreach (RepeaterItem oItem in rpt.Items)
                {
                    TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgaynhanbanan");
                    if (txtNgaynhanbanan.Text != "")
                    {
                        DateTime NgayNhanBA;
                        if (DateTime.TryParse(txtNgaynhanbanan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanBA))
                        {
                            if (DateTime.Compare(NgayNhanBA, DateTime.Now) > 0)
                            {
                                lbthongbao.Text = "Ngày nhận bản án không được lớn hơn ngày hiện tại.";
                                txtNgaynhanbanan.Focus();
                                return;
                            }
                        }
                        else
                        {
                            lbthongbao.Text = "Ngày nhận bản án không đúng kiểu ngày / tháng / năm.";
                            txtNgaynhanbanan.Focus();
                            return;
                        }
                    }
                }
            }
            foreach (RepeaterItem item in rpt.Items)
            {
                IsNew = false;
                HiddenField hddBiCao = (HiddenField)item.FindControl("hddBiCao");
                CheckBox chkThamGiaPhienToa = (CheckBox)item.FindControl("chkThamGiaPhienToa");
                TextBox txtAnPhi = (TextBox)item.FindControl("txtAnPhi");
                //CheckBox chkDinhChi = (CheckBox)item.FindControl("chkDinhChi");
                TextBox txtNgaynhanbanan = (TextBox)item.FindControl("txtNgaynhanbanan");
                decimal BiCaoId = Convert.ToDecimal(hddBiCao.Value);
                obj = DataExtensions.GetAllWithClause<THA_SOTHAM_BANAN_BICAO>($"BICAOID = {BiCaoId} AND VUANID = {VuAnID}").FirstOrDefault();
                if (obj == null)
                {
                    IsNew = true;
                    obj = new THA_SOTHAM_BANAN_BICAO();
                }

                obj.ISTHAMGIAPHIENTOA = (chkThamGiaPhienToa.Checked) ? 1 : 0;
                //obj.ISDINHCHI = (chkDinhChi.Checked) ? 1 : 0;

                obj.NGAYNHANBANAN = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.BICAOID = BiCaoId;
                obj.ANPHI = (string.IsNullOrEmpty(txtAnPhi.Text + "")) ? 0 : Convert.ToDecimal(txtAnPhi.Text.Replace(".", ""));


                if (IsNew)
                {
                    if (obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    DataExtensions.Insert(obj);
                }
                else
                {
                    DataExtensions.Update(obj);
                }

            }
            lttMsgAnPhi.Text = "Lưu dữ liệu thành công!";

        }
        public void cmdReloadParent_Click(object sender, EventArgs e)
        {
            LoadBiAnHinhPhat();
        }

        public void cmdReloadParentPT_Click(object sender, EventArgs e)
        {
            LoadDsBiCaoPT();
        }

        public void LoadDsBiCaoPT()
        {
            decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            THA_BIAN_BL objBL = new THA_BIAN_BL();
            DataTable tbl = objBL.THA_PT_BANAN_BICAO_GETBYVUANID(BiAnID, VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptPT.DataSource = tbl;
                rptPT.DataBind();
            }
            else
            {
                //  pnAnPhi.Enabled = false;
                lttMsgAnPhi.Text = "Chưa có bị cáo được xét xử phúc thẩm. Đề nghị kiểm tra lại!";
                cmdPTSave2.Enabled = pnAnPhiPT.Enabled = false;
            }
        }

        protected void cmdPTSave_Click(object sender, EventArgs e)
        {
            THA_PHUCTHAM_BANAN_BICAO obj = null;
            Boolean IsNew = false;

            foreach (RepeaterItem item in rptPT.Items)
            {
                IsNew = false;
                HiddenField hddBiCao = (HiddenField)item.FindControl("hddBiCaoPT");
                CheckBox chkThamGiaPhienToa = (CheckBox)item.FindControl("chkThamGiaPhienToaPT");
                TextBox txtAnPhi = (TextBox)item.FindControl("txtAnPhiPT");
                TextBox txtNgaynhanbanan = (TextBox)item.FindControl("txtNgaynhanbananPT");
                decimal BiCaoId = Convert.ToDecimal(hddBiCao.Value);
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);

                obj = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_BICAO>($" BICAOID = {BiCaoId} AND VUANID = {VuAnID}").FirstOrDefault(); 
                    
                if (obj == null)
                {
                    IsNew = true;
                    obj = new THA_PHUCTHAM_BANAN_BICAO();
                }
                obj.ISTHAMGIAPHIENTOA = (chkThamGiaPhienToa.Checked) ? 1 : 0;

                DateTime date_temp = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYNHANBANAN = date_temp;
                obj.BICAOID = Convert.ToDecimal(hddBiCao.Value);
                obj.ANPHI = (string.IsNullOrEmpty(txtAnPhi.Text + "")) ? 0 : Convert.ToDecimal(txtAnPhi.Text.Replace(".", ""));
                if (IsNew)
                {
                    if (obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    DataExtensions.Insert(obj);
                }
                else
                {
                    DataExtensions.Update(obj);
                }

            }
            lttMsgAnPhiPT.Text = "Lưu dữ liệu thành công!";
        }

        protected void rptPT_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;

                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);

                decimal BiCaoId = Convert.ToDecimal(dv["BiCanID"] + "");
                TextBox txtAnPhi = (TextBox)e.Item.FindControl("txtAnPhiPT");
                CheckBox cb = (CheckBox)e.Item.FindControl("chkThamGiaPhienToaPT");
                txtAnPhi.Text = String.IsNullOrEmpty(dv["AnPhi"] + "") ? "" : (Convert.ToDouble(dv["AnPhi"])).ToString("#,#", cul) + "";

                TextBox txtNgaynhanbanan = (TextBox)e.Item.FindControl("txtNgaynhanbananPT");
                DateTime ngaynhan = String.IsNullOrEmpty(dv["NgayNhanBanAn"] + "") ? DateTime.MinValue : Convert.ToDateTime(dv["NgayNhanBanAn"] + "");
                if (ngaynhan == DateTime.MinValue)
                    txtNgaynhanbanan.Text = "";
                else
                    txtNgaynhanbanan.Text = ngaynhan.ToString("dd/MM/yyyy", cul);

                int IsShow = Convert.ToInt16(dv["IsShow"] + "");

                THA_TONGHOPHINHPHAT tonghophinhphat = DataExtensions.GetAllWithClause<THA_TONGHOPHINHPHAT>($"VUANID= {VuAnID} AND BICAOID = {BiCaoId}").FirstOrDefault();
                try
                {
                    Label lblTHtoidanh = (Label)e.Item.FindControl("lblTHtoidanhST");
                    lblTHtoidanh.Text = tonghophinhphat.Tonghophinhphat_ST(VuAnID, BiCaoId);
                }
                catch (Exception ex) { }

                try
                {
                    Label lblTHtoidanhPT = (Label)e.Item.FindControl("lblTHtoidanhPT");
                    if (tonghophinhphat.TONGHOPHINHPHAT != null)
                    {
                        lblTHtoidanhPT.Text = tonghophinhphat.Tonghophinhphat_Sosanh(VuAnID, BiCaoId);
                    }
                    else
                    {
                        lblTHtoidanhPT.Text = tonghophinhphat.Tonghophinhphat_PT(VuAnID, BiCaoId);
                    }
                }

                catch (Exception ex) { }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetIDPT");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    cb.Visible = false;
                    txtAnPhi.Visible = false;
                    txtNgaynhanbanan.Visible = false;
                }


            }
        }
    }
}