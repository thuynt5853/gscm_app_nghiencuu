using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.ADS;
using BL.GSTP.BANGSETGET.AHS;
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

namespace WEB.GSTP.QLAN.AHS.PhucThamQDK
{
    public partial class NguoiThamgiaTT : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrentYear = 0;
        private String TuCachTT_BiHai_Ma = ENUM_AHS_TUCACHTHAMGIATT.BIHAI;
        private Decimal TuCachTT_BiHai_Id = 0;

        public decimal VuAnID = 0;
        public decimal VuAnIDST = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btn_GXN_BC);
            scriptManager.RegisterPostBackControl(this.btn_GXN_BH);
            try
            {
                if (!IsPostBack)
                {
                    if ((Session["TTBCVISIBLE"] + "") == "1")
                    {
                        lbtTTBC.Text = "[ Đóng ]";
                        pnTTBC.Visible = true;
                    }
                    //--------------------

                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "")
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                    VuAnIDST = _chuyenNhanBl.getDonIdOld(VuAnID);
                    LoadCombobox();
                    LoadNguoiPhanCong();
                    ddlTuCachTGTT_SelectedIndexChanged(sender, e);
                    GetBicao();
                    CheckQuyen();
                    LoadGrid();
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ex.Message;
                logger.Error("loi xay ra: " + ex);
            }
        }

        private void CheckQuyen()
        {
            hddShowCommand.Value = "True";
            decimal DONID = String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable QDKetThuc = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, DONID);

            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            if (QDKetThuc != null && QDKetThuc.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có kêt quả phúc thẩm , Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //Kiểm tra thẩm phán giải quyết đơn
            List<AHS_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {DONID}").ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<AHS_THAMPHANGIAIQUYET> lstTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
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
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                string toaGiaiQuyetID = e.Item.Cells[12].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }

        #region tamnc

        private void LoadNguoiPhanCong()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlNguoiphancong.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_3CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA, ENUM_CHUCVU.TP + "," + ENUM_CHUCVU.TPSC + "," + ENUM_CHUCVU.TPTC + "," + ENUM_CHUCVU.TPCC + "" + ENUM_CHUCVU.TPTATC);
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
        }

        #endregion tamnc

        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlNgheNghiep.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NGHENGHIEP);
            ddlNgheNghiep.DataTextField = "TEN";
            ddlNgheNghiep.DataValueField = "ID";
            ddlNgheNghiep.DataBind();
            ddlNgheNghiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            //---------------------------------
            ddlTuCachTGTT.Items.Clear();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTHS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    // vnpt 4/12/2025 chinh khong lay tu cach bi can
                    if (row["Ma"] + "" == ENUM_AHS_TUCACHTHAMGIATT.BICANDAUVU || row["Ma"] + "" == ENUM_AHS_TUCACHTHAMGIATT.BICAN)
                    {

                    } else
                    {
                        ddlTuCachTGTT.Items.Add(new ListItem(row["Ten"] + "", row["ID"].ToString()));
                        if (row["Ma"] + "" == TuCachTT_BiHai_Ma)
                        {
                            TuCachTT_BiHai_Id = Convert.ToDecimal(row["ID"] + "");
                            hddTuCachTT_BiHai_ID.Value = row["ID"] + "";
                        }
                    }
                    
                }

                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
            }
            else
                ddlTuCachTGTT.Items.Add(new ListItem("--- Chọn ---", "0"));
        }

        private void LoadTGTTFromHoSo()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            AHS_SOTHAM_BL bl = new AHS_SOTHAM_BL();
            AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
            VuAnIDST = _chuyenNhanBl.getDonIdOld(VuAnID);
            DataTable tbl = bl.AHS_NTGTT_GetCheckList(VuAnIDST, "HOSO");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkListTGTT.DataSource = tbl;
                chkListTGTT.DataTextField = "arrTEN";
                chkListTGTT.DataValueField = "ID";
                chkListTGTT.DataBind();

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    cmdChonTGTT.Enabled = false;
                }
                else
                {
                    cmdChonTGTT.Enabled = true;
                }
            }
            else
            {
                lblMsgChon.Text = "Hồ sơ vụ án không có người tham gia tố tụng nào.";
                cmdChonTGTT.Enabled = false;
            }
        }

        private void Clear_value()
        {
            lstDataBC.Value = "0";
            hddid.Value = "0";
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                pnNguoiDD.Visible = false;
                pnCaNhan.Visible = true;
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
                //--------------
                if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123"
                   || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
                {
                    pn_daidien.Visible = true;

                    pn_daidiencho.Visible = true;
                    load_so_dk();
                }
                else
                {
                    pn_daidiencho.Visible = false;
                    pn_daidien.Visible = false;
                }
                if (ddlTuCachTGTT.SelectedValue == "128" || ddlTuCachTGTT.SelectedValue == "129" || ddlTuCachTGTT.SelectedValue == "1160")
                {
                    pn_daidiencho.Visible = true;
                    load_so_dk();
                }
                else
                {
                    pn_daidiencho.Visible = false;
                }

                //----------------
                rdTreViThanhNien.SelectedIndex = -1;
                ddlPLTuoi.SelectedIndex = 0;
                pnTreVTNCo.Enabled = false;
            }
            txtHoten.Text = txtNamsinh.Text = txtNgaysinh.Text = "";
            txtDiaChiChitiet.Text = txtNgaythamgia.Text = "";
            ddlGioitinh.SelectedIndex = 0;
            ddlNgheNghiep.SelectedValue = "0";
            txtNDD_ChucVu.Text = txtNDD_CMND.Text = "";
            txtNDD_Email.Text = txtNDD_HoTen.Text = txtNDD_Mobile.Text = "";
            txt_TEN_VPLS.Text = string.Empty;
            txt_DOAN_LS.Text = string.Empty;
            txt_NDD_MOBILE.Text = string.Empty;

            txt_NGAY_DK.Text = string.Empty;
            ddl_BICAO_ID.ClearSelection();
            Cls_Comon.SetFocus(this, this.GetType(), dropLoaiDoiTuong.ClientID);
        }

        private void ResetControls()
        {
            lstDataBC.Value = "0";
            hddid.Value = "0";
            dropLoaiDoiTuong.SelectedIndex = 0;
            ddlTuCachTGTT.SelectedIndex = 0;
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                pnNguoiDD.Visible = false;
                pnCaNhan.Visible = true;
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
                //--------------
                if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123"
                   || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
                {
                    pn_daidien.Visible = true;

                    pn_daidiencho.Visible = true;
                    load_so_dk();
                }
                else
                {
                    pn_daidiencho.Visible = false;
                    pn_daidien.Visible = false;
                }
                if (ddlTuCachTGTT.SelectedValue == "128" || ddlTuCachTGTT.SelectedValue == "129" || ddlTuCachTGTT.SelectedValue == "1160")
                {
                    pn_daidiencho.Visible = true;
                    load_so_dk();
                }
                else
                {
                    pn_daidiencho.Visible = false;
                }

                //----------------
                rdTreViThanhNien.SelectedIndex = -1;
                ddlPLTuoi.SelectedIndex = 0;
                pnTreVTNCo.Enabled = false;
            }
            txtHoten.Text = txtNamsinh.Text = txtNgaysinh.Text = "";
            txtDiaChiChitiet.Text = txtNgaythamgia.Text = "";
            ddlGioitinh.SelectedIndex = 0;
            ddlNgheNghiep.SelectedValue = "0";
            txtNDD_ChucVu.Text = txtNDD_CMND.Text = "";
            txtNDD_Email.Text = txtNDD_HoTen.Text = txtNDD_Mobile.Text = "";
            txt_TEN_VPLS.Text = string.Empty;
            txt_DOAN_LS.Text = string.Empty;
            txt_NDD_MOBILE.Text = string.Empty;

            txt_NGAY_DK.Text = string.Empty;
            ddl_BICAO_ID.ClearSelection();
            Cls_Comon.SetFocus(this, this.GetType(), dropLoaiDoiTuong.ClientID);
        }

        private void load_so_dk()
        {
            //------------------
            AHS_NGUOITHAMGIATOTUNG_BL oBL = new AHS_NGUOITHAMGIATOTUNG_BL();
            decimal sodk_ = 0;
            oBL.SO_DK_RETURN(ddlTuCachTGTT.SelectedValue, ref sodk_, Session[ENUM_SESSION.SESSION_DONVIID] + "");
            txt_SO_DK.Text = Convert.ToString(sodk_);
            //-------------------
        }

        private bool CheckValid()
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                    if (rdTreViThanhNien.SelectedValue == "")
                    {
                        lbthongbao.Text = "Mục 'Trẻ vị thành niên' bắt buộc phải chọn. Hãy kiểm tra lại.";
                        return false;
                    }
                }
                if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123" || ddlTuCachTGTT.SelectedValue == "1160"
                   || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
                {
                    if (txt_NGAY_DK.Text == "")
                    {
                        lbthongbao.Text = " Ngày đăng ký không được để trống. Hãy hiểm tra lại";
                        return false;
                    }
                }
                if (ddl_BICAO_ID.Items.Count == 0)
                {
                    lbthongbao.Text = "Chưa chọn đại diện cho !";
                    return false;
                }
            }
            return true;
        }

        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            try
            {
                DateTime d = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    txtNamsinh.Text = d.Year.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
            Cls_Comon.SetFocus(this, this.GetType(), txtNamsinh.ClientID);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                SaveData();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                Clear_value();
                lbthongbao.Text = "Lưu thành công!";
                //ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        private void SaveData()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + ""), ID = string.IsNullOrEmpty(hddid.Value) ? 0 : Convert.ToDecimal(hddid.Value);
            Decimal NguoiTGTTID = (String.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);

            bool isNew = false;
            AHS_NGUOITHAMGIATOTUNG oND = null;
            if (NguoiTGTTID > 0)
            {
                oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == NguoiTGTTID).FirstOrDefault();
                if (oND != null)
                    isNew = false;
                else
                {
                    isNew = true;
                    oND = new AHS_NGUOITHAMGIATOTUNG();
                }
            }
            else
            {
                isNew = true;
                oND = new AHS_NGUOITHAMGIATOTUNG();
            }

            oND.VUANID = VuAnID;
            oND.HOTEN = txtHoten.Text.Trim();
            oND.DIACHICHITIET = txtDiaChiChitiet.Text.Trim();

            //------
            oND.NGAYSINH = oND.NGAYTHAMGIA = (DateTime?)null;
            oND.NAMSINH = oND.NGHENGHIEPID = 0;
            oND.GIOITINH = (Decimal?)null;
            oND.NDD_HOTEN = oND.NDD_CMND = oND.NDD_MOBILE = oND.NDD_CHUCVU = oND.NDD_EMAIL = "";
            oND.ISTREVITHANHNIEN = oND.LOAITREVITHANHNIEN = 0;

            oND.LOAIDT = Convert.ToDecimal(dropLoaiDoiTuong.SelectedValue);
            if (oND.LOAIDT == 0)
            {
                //ca nhan---
                oND.NGAYSINH = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtNamsinh.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);
                oND.NGHENGHIEPID = Convert.ToDecimal(ddlNgheNghiep.SelectedValue);
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //TuCach TGTT =  Bị hại
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                    oND.ISTREVITHANHNIEN = Convert.ToDecimal(rdTreViThanhNien.SelectedValue);
                    string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
                    if (isTreViThanhNien == "1")
                        oND.LOAITREVITHANHNIEN = Convert.ToDecimal(ddlPLTuoi.SelectedValue);
                }
            }
            else
            {
                //-------co quan, to chuc
                oND.NDD_HOTEN = txtNDD_HoTen.Text.Trim();
                oND.NDD_CHUCVU = txtNDD_ChucVu.Text.Trim();
                oND.NDD_CMND = txtNDD_CMND.Text.Trim();
                oND.NDD_MOBILE = txtNDD_Mobile.Text.Trim();
                oND.NDD_EMAIL = txtNDD_Email.Text.Trim();
            }

            // Đây là giai đoạn phúc thẩm nên ISPHUCTHAM= 1
            oND.ISPHUCTHAM = 1;
            if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123" || ddlTuCachTGTT.SelectedValue == "1160"
                   || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
            {
                oND.TEN_VPLS = txt_TEN_VPLS.Text;
                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                oND.DOAN_LS = txt_DOAN_LS.Text;
                oND.NDD_MOBILE = txt_NDD_MOBILE.Text;
                oND.SO_DK = Convert.ToDecimal(txt_SO_DK.Text);
                oND.NGAY_DK = (String.IsNullOrEmpty(txt_NGAY_DK.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txt_NGAY_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //cắt chuỗi chức vụ-chức danh
                string cvcd = ddlNguoiphancong.SelectedItem.Text + "   ";
                int vt = cvcd.IndexOf('-');
                cvcd = cvcd.Substring(vt + 1, cvcd.Length - vt - 2);
                oND.CHUCVU_CHUCDANH = cvcd.Trim();
            }
            if (isNew)
            {
                if (oND.TOA_GIAIQUYET_ID == null)
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_NGUOITHAMGIATOTUNG.Add(oND);
            }
            dt.SaveChanges();
            hddid.Value = oND.ID.ToString();
            //----------------
            if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123" || ddlTuCachTGTT.SelectedValue == "1160"
               || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
            {
                AHS_NGUOITHAMGIATOTUNG_BL oBL = new AHS_NGUOITHAMGIATOTUNG_BL();
                String V_CHECK = "";
                oBL.AHS_NGUOI_DAIDIEN_INS_UP(oND.ID, lstDataBC.Value, ref V_CHECK);
                if (V_CHECK == "")
                {
                    lbthongbao.Text = "Không được đại diện cho nhiều tư cách tố tụng khác nhau";
                }
                ddl_BICAO_ID.ClearSelection();
                lstDataBC.Value = "0";
            }
            //--------------------
            try
            {
                UpdateTuCach(oND.ID);
            }
            catch (Exception ex) { }
        }

        private void UpdateTuCach(Decimal NguoiThamGiaID)
        {
            AHS_NGUOITHAMGIATOTUNG_TUCACH obj = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiThamGiaID).FirstOrDefault();
            Boolean IsNew = false;
            if (obj == null)
            {
                IsNew = true;
                obj = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                dt.SaveChanges();
            }
            obj.NGUOIID = NguoiThamGiaID;
            obj.TUCACHID = Convert.ToDecimal(ddlTuCachTGTT.SelectedValue);
            if (IsNew)
                dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(obj);
            dt.SaveChanges();
        }

        public void LoadGrid()
        {
            //lbthongbao.Text = "";
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            int pageindex = Convert.ToInt32(hddPageIndex.Value), page_size = Convert.ToInt32(hddPageSize.Value);
            AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
            VuAnIDST = _chuyenNhanBl.getDonIdOld(VuAnID);
            DataTable tbl = objBL.AHS_NTGTT_GetByVuAnID_PT(VuAnID, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(tbl.Rows[0]["CountAll"].ToString());

                #region "Xác định số lượng trang"

                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"

                dgList.PageSize = page_size;
                dgList.DataSource = tbl;
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
            lbthongbao_export.Text = string.Empty;
            lbthongbao.Text = "";
        }

        public void xoa(decimal id)
        {
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.AHS_NGUOITHAMGIATOTUNG.Remove(oND);
                List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == id).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (lst != null && lst.Count > 0)
                { dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.RemoveRange(lst); }

                List<AHS_NGUOI_DAIDIEN> lst_dd = dt.AHS_NGUOI_DAIDIEN.Where(x => x.NGUOI_TGTT_ID == id).ToList<AHS_NGUOI_DAIDIEN>();
                if (lst_dd != null && lst_dd.Count > 0)
                { dt.AHS_NGUOI_DAIDIEN.RemoveRange(lst_dd); }

                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
        }

        public void loadedit(decimal ID)
        {
            //----------------------------
            hddid.Value = ID.ToString();
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                int loaidoituong = (String.IsNullOrEmpty(oND.LOAIDT + "")) ? 0 : Convert.ToInt16(oND.LOAIDT);
                Cls_Comon.SetValueComboBox(dropLoaiDoiTuong, loaidoituong);
                if (loaidoituong == 0)
                {
                    //ca nhan
                    lblHoTen.Text = "Họ tên";
                    pnCaNhan.Visible = true;
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = false;
                    pnNguoiDD.Visible = false;
                }
                else
                {
                    //coquan, to chuc
                    lblHoTen.Text = "Tên " + ((loaidoituong == 1) ? "cơ quan" : "tổ chức");
                    pnCaNhan.Visible = false;
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = false;
                    pnNguoiDD.Visible = true;
                }

                //--------------------
                txtHoten.Text = oND.HOTEN;
                txtDiaChiChitiet.Text = oND.DIACHICHITIET;
                int gioitinh = (String.IsNullOrEmpty(oND.GIOITINH + "")) ? 0 : Convert.ToInt16(oND.GIOITINH);
                if (gioitinh > 1)
                    ddlGioitinh.SelectedIndex = -1;
                else
                    ddlGioitinh.SelectedValue = gioitinh.ToString();
                txtNgaysinh.Text = string.IsNullOrEmpty(oND.NGAYSINH + "") ? "" : ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlNgheNghiep.SelectedValue = oND.NGHENGHIEPID.ToString();
                txtNgaythamgia.Text = string.IsNullOrEmpty(oND.NGAYTHAMGIA + "") ? "" : ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);

                //--------------------
                txtNDD_ChucVu.Text = oND.NDD_CHUCVU + "";
                txtNDD_CMND.Text = oND.NDD_CMND + "";
                txtNDD_Email.Text = oND.NDD_EMAIL + "";
                txtNDD_HoTen.Text = oND.NDD_HOTEN + "";
                txtNDD_Mobile.Text = oND.NDD_MOBILE + "";

                //--------------------

                if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID + "") != null)
                    ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID + "";

                AHS_NGUOITHAMGIATOTUNG_TUCACH tuCach = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oND.ID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (tuCach != null)
                {
                    TuCachTT_BiHai_Id = Convert.ToDecimal(hddTuCachTT_BiHai_ID.Value);
                    Decimal tucachid = (Decimal)tuCach.TUCACHID;
                    ddlTuCachTGTT.SelectedValue = tucachid + "";
                    if (tucachid == TuCachTT_BiHai_Id && loaidoituong == 0)
                    {
                        pnTreViThanhNien.Visible = true;
                        string isTreVTN = oND.ISTREVITHANHNIEN + "";
                        if (isTreVTN != "")
                        {
                            rdTreViThanhNien.SelectedValue = oND.ISTREVITHANHNIEN.ToString();
                            string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
                            if (isTreViThanhNien == "1")
                            {
                                pnTreVTNCo.Enabled = true;
                                pnTreVTNKhong.Visible = false;
                                ddlPLTuoi.SelectedValue = oND.LOAITREVITHANHNIEN.ToString();
                            }
                            else
                            {
                                pnTreVTNCo.Enabled = false;
                                pnTreVTNKhong.Visible = true;
                            }
                        }
                    }
                    else
                    {
                        rdTreViThanhNien.SelectedValue = "0";
                        pnTreVTNCo.Enabled = false;
                        pnTreVTNKhong.Visible = true;
                        if (tuCach.TUCACHID == 127 || tuCach.TUCACHID == 123 || tuCach.TUCACHID == 1160 || tuCach.TUCACHID == 549 || tuCach.TUCACHID == 130 || tuCach.TUCACHID == 131)
                        {
                            txt_TEN_VPLS.Text = oND.TEN_VPLS;
                            txt_DOAN_LS.Text = oND.DOAN_LS;
                            txt_NDD_MOBILE.Text = oND.NDD_MOBILE;
                            txt_SO_DK.Text = Convert.ToString(oND.SO_DK);
                            txt_NGAY_DK.Text = string.IsNullOrEmpty(oND.NGAY_DK + "") ? "" : ((DateTime)oND.NGAY_DK).ToString("dd/MM/yyyy", cul);
                            //----------

                            GetBicao();
                            AHS_NGUOITHAMGIATOTUNG_BL objBL = new AHS_NGUOITHAMGIATOTUNG_BL();
                            DataTable tbl = objBL.GET_NTGTT_BCBC(ID);
                            if (tbl.Rows.Count > 0)
                            {
                                lstDataBC.Value = tbl.Rows[0]["BICAO_DATA"].ToString();
                                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);
                            }
                        }
                    }
                }
                else
                {
                    pnTreViThanhNien.Visible = false;
                }
                load_check_tucachtt(ID);
            }
        }

        private void LoadTuCach(Decimal NguoiThamGiaID)
        {
            AHS_NGUOITHAMGIATOTUNG_TUCACH obj = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiThamGiaID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
            if (obj != null)
            {
                ddlTuCachTGTT.SelectedValue = obj.TUCACHID.ToString();
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
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(cmdUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(cmdUpdate, false);
                        }
                        lbthongbao.Text = "";
                        pnNew.Visible = true;
                        pnChon.Visible = false;
                        rdbLoai.SelectedValue = "0";
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        lbthongbao_export.Text = string.Empty;
                        lbthongbao.Text = "";
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

        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {
            }
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
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
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        #endregion "Phân trang"

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = lblMsgChon.Text = "";
            if (rdbLoai.SelectedValue == "0")
            {
                pnNew.Visible = true;
                pnChon.Visible = false;
            }
            else
            {
                pnNew.Visible = false;
                pnChon.Visible = true;
                LoadTGTTFromHoSo();
            }
        }

        protected void cmdChonTGTT_Click(object sender, EventArgs e)
        {
            bool flag = false;
            foreach (ListItem oItem in chkListTGTT.Items)
            {
                if (oItem.Selected)
                {
                    flag = true;
                    decimal NID = Convert.ToDecimal(oItem.Value);
                    AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == NID).FirstOrDefault();
                    if (oND != null)
                    {
                        oND.ISPHUCTHAM = 1;
                        dt.SaveChanges();
                        hddid.Value = oND.ID.ToString();

                    }
                }
            }

            if (flag)
            {
                LoadGrid();
                lblMsgChon.Text = "Lưu thành công !";
            }
            else
            {
                lblMsgChon.Text = "Chưa chọn người tham gia tố tụng !";
            }
        }

        protected void ddlTuCachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
                bool ck = true;
                if (ddlTuCachTGTT.SelectedValue == "127" || ddlTuCachTGTT.SelectedValue == "123"
                    || ddlTuCachTGTT.SelectedValue == "549" || ddlTuCachTGTT.SelectedValue == "130" || ddlTuCachTGTT.SelectedValue == "131")
                {
                    pn_daidien.Visible = true;

                    pn_daidiencho.Visible = true;
                    ck = false;
                    GetBicao();
                    load_so_dk();
                }
                else
                {
                    pn_daidiencho.Visible = true;

                    pn_daidien.Visible = false;
                }
                if (ddlTuCachTGTT.SelectedValue == "128" || ddlTuCachTGTT.SelectedValue == "129" || ddlTuCachTGTT.SelectedValue == "1160")
                {
                    pn_daidiencho.Visible = true;
                    GetBicao();
                    load_so_dk();
                }
                else
                {
                    if (ck)
                    {
                        pn_daidiencho.Visible = false;
                    }
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtHoten.ClientID);
            lbthongbao_export.Text = string.Empty;
            lbthongbao.Text = "";
        }

        protected void load_check_tucachtt(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            AHS_NGUOITHAMGIATOTUNG_TUCACH tuCach = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oND.ID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
            //tuCach
            if (oND.LOAIDT == 0)
            {
                bool check = true;
                if (tuCach.TUCACHID == 122)
                    pnTreViThanhNien.Visible = true;
                else
                    pnTreViThanhNien.Visible = false;
                if (tuCach.TUCACHID == 127 || tuCach.TUCACHID == 123
                    || tuCach.TUCACHID == 549 || tuCach.TUCACHID == 130 || tuCach.TUCACHID == 131)
                {
                    pn_daidien.Visible = true;
                    pn_daidiencho.Visible = true;
                    check = false;
                }
                else
                {
                    pn_daidien.Visible = false;
                    pn_daidiencho.Visible = false;
                }
                if (tuCach.TUCACHID == 128 || tuCach.TUCACHID == 129 || tuCach.TUCACHID == 1160)
                {
                    pn_daidiencho.Visible = true;
                }
                else
                {
                    if (check)
                    {
                        pn_daidiencho.Visible = false;
                    }
                }
            }
        }

        public void GetBicao()
        {
            ddl_BICAO_ID.ClearSelection();
            // Load Bị can / bị can
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable tbl = objBL.GetAllBiCan_bihai_PhucTham(VuAnIDST);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddl_BICAO_ID.DataSource = tbl;
                var tenbican = ddl_BICAO_ID.DataTextField = "TenBiCan";
                ddl_BICAO_ID.DataValueField = "BiCanID";
                ddl_BICAO_ID.DataBind();
                ddl_BICAO_ID.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                ddl_BICAO_ID.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }

        protected void dropLoaiDoiTuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loaidoituong = Convert.ToInt16(dropLoaiDoiTuong.SelectedValue);
            if (loaidoituong == 0)
            {
                lblHoTen.Text = "Họ tên";
                //ca nhan
                pnCaNhan.Visible = true;
                pnNguoiDD.Visible = false;
                if (ddlTuCachTGTT.SelectedValue == hddTuCachTT_BiHai_ID.Value)
                {
                    rdTreViThanhNien.SelectedIndex = -1;
                    pnTreViThanhNien.Visible = true;
                }
                else
                    pnTreViThanhNien.Visible = false;
            }
            else
            {
                lblHoTen.Text = "Tên " + ((loaidoituong == 1) ? "cơ quan" : "tổ chức");
                //coquan, to chuc
                pnCaNhan.Visible = false;
                pnNguoiDD.Visible = true;
                rdTreViThanhNien.SelectedIndex = -1;
                pnTreViThanhNien.Visible = false;
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtHoten.ClientID);
        }

        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            string isTreViThanhNien = rdTreViThanhNien.SelectedValue;
            if (isTreViThanhNien == "1")
            {
                pnTreVTNCo.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), ddlPLTuoi.ClientID);
            }
            else
            {
                pnTreVTNCo.Enabled = false;
                Cls_Comon.SetFocus(this, this.GetType(), ddlNgheNghiep.ClientID);
            }
        }

        protected void lbtTTBC_Click(object sender, EventArgs e)
        {
            if (pnTTBC.Visible)
            {
                lbtTTBC.Text = "[ Mở ]";
                pnTTBC.Visible = false;
                Session["TTBCVISIBLE"] = "0";
            }
            else
            {
                lbtTTBC.Text = "[ Đóng ]";
                pnTTBC.Visible = true;
                Session["TTBCVISIBLE"] = "1";
            }
        }

        protected void btn_GXN_BC_Click(object sender, EventArgs e)
        {
            string vArrSelectID = "";
            bool checkTCTGTT = true;
            //int countSelectedID = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    //countSelectedID = countSelectedID + 1;
                    if (vArrSelectID == "")
                        vArrSelectID = chkChon.ToolTip;
                    else
                        vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                    if (Item.Cells[0].Text.Trim() != "127" && Item.Cells[0].Text.Trim() != "123" && Item.Cells[0].Text.Trim() != "549" && Item.Cells[0].Text.Trim() != "130" && Item.Cells[0].Text.Trim() != "131")
                    {
                        checkTCTGTT = false;
                    }
                }
            }
            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
            if (vArrSelectID == "")
            {
                lbthongbao_export.Text = "Phải chọn bản ghi ở danh sách phía dưới để lấy dữ liệu";
                return;
            }
            if (checkTCTGTT)
            {
                //--------------
                AHS_NGUOITHAMGIATOTUNG_BL objBL = new AHS_NGUOITHAMGIATOTUNG_BL();
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = objBL.GET_BC_GIAYXX_BC(vArrSelectID, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=xacnhanbicao.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");
                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section1>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            else
            {
                lbthongbao_export.Text = "kiểm tra lại tư cách tham gia tố tụng";
                return;
            }
        }

        protected void btn_GXN_BH_Click(object sender, EventArgs e)
        {
            //test
            bool checkTCTGTT = true;
            string vArrSelectID = "";
            //int countSelectedID = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    //countSelectedID = countSelectedID + 1;
                    if (vArrSelectID == "")
                        vArrSelectID = chkChon.ToolTip;
                    else
                        vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                    if (Item.Cells[0].Text.Trim() != "127" && Item.Cells[0].Text.Trim() != "123" && Item.Cells[0].Text.Trim() != "549" && Item.Cells[0].Text.Trim() != "130" && Item.Cells[0].Text.Trim() != "131")
                    {
                        checkTCTGTT = false;
                    }
                }
            }
            //-----------------
            bool checkbicao = true;
            foreach (ListItem item in ddl_BICAO_ID.Items)
            {
                if (item.Selected)
                {
                    string text = item.Text;
                    if (text.Contains("bị cáo") == true)
                    {
                        checkbicao = false;
                    }
                }
            }
            if (checkbicao == false)
            {
                lbthongbao_export.Text = "Đại diện là bị cáo không thì có quyền in giấy tham gia tố tụng khác!";
                return;
            }
            else
            {
                lbthongbao_export.Text = null;
            }
            //---------------------------------------------------
            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
            if (vArrSelectID == "")
            {
                lbthongbao_export.Text = "Phải chọn bản ghi ở danh sách phía dưới để lấy dữ liệu";
                return;
            }
            if ((checkTCTGTT))
            {
                //--------------
                AHS_NGUOITHAMGIATOTUNG_BL objBL = new AHS_NGUOITHAMGIATOTUNG_BL();
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = objBL.GET_BC_GIAYXX_BH(vArrSelectID, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=xacnhanbihai.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");
                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section1>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            else
            {
                lbthongbao_export.Text = "kiểm tra lại tư cách tham gia tố tụng";
                return;
            }
        }
    }
}