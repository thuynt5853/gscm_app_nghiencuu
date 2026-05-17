using BL.GSTP;
using BL.GSTP.APS;
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

namespace WEB.GSTP.QLAN.APS.Phuctham
{
    public partial class NguoiThamgiaTT : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btn_GXN_NBC);
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadNguoiPhanCong();
                    LoadTGTTFromDonKK();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdChonTGTT, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn
                    decimal DONID = Convert.ToDecimal(current_id);
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    List<APS_PHUCTHAM_THULY> lstCount = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                    if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    List<APS_DON_THAMPHAN> lstTP = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                    if (lstTP.Count == 0)
                    {
                        lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    load_so_dk("PT");
                }

                #region Thiều

                GetDuongSu();

                #endregion Thiều

                ddlTuCachTGTT_SelectedIndexChanged(sender, e);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        #region Thiều

        public void GetDuongSu(string strlstId = "")
        {
            pnDuongSuDON_GHEP.Controls.Clear();
            if (string.IsNullOrEmpty(strlstId))
            {
                decimal donId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                var lstDuongSu = (from a in dt.APS_DON_DUONGSU.Where(s => s.DONID == donId)
                                  join d in dt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU,
                                      TUCACHTOTUNG = d.TEN,
                                      TUCACHTOTUNG_MA = d.MA
                                  });
                foreach (var item in lstDuongSu)
                {
                    CheckBox checkBox = new CheckBox();
                    checkBox.Text = item.TENDUONGSU + " (" + item.TUCACHTOTUNG + ")";
                    checkBox.ToolTip = item.ID.ToString();
                    checkBox.Checked = false;
                    checkBox.InputAttributes.Add("TCTT", item.TUCACHTOTUNG_MA);
                    checkBox.CssClass = "clcheckbox";
                    pnDuongSuDON_GHEP.Controls.Add(checkBox);
                }
            }
            else
            {
                lstDataDuongSu.Value = strlstId;
                List<decimal> lstId = strlstId.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => Convert.ToDecimal(s)).ToList();
                decimal donId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                var lstDuongSu = (from a in dt.APS_DON_DUONGSU.Where(s => s.DONID == donId)
                                  join d in dt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU,
                                      TUCACHTOTUNG = d.TEN,
                                      TUCACHTOTUNG_MA = d.MA
                                  });
                foreach (var item in lstDuongSu)
                {
                    CheckBox checkBox = new CheckBox();
                    checkBox.Text = item.TENDUONGSU + " (" + item.TUCACHTOTUNG + ")";
                    checkBox.ToolTip = item.ID.ToString();
                    if (lstId.Contains(item.ID))
                    {
                        checkBox.Checked = true;
                    }
                    else
                    {
                        checkBox.Checked = false;
                    }
                    checkBox.InputAttributes.Add("TCTT", item.TUCACHTOTUNG_MA);
                    checkBox.CssClass = "clcheckbox";
                    pnDuongSuDON_GHEP.Controls.Add(checkBox);
                }
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "loadeventchange();");
        }

        #endregion Thiều

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
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }

        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlTucachTGTT.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            ddlTucachTGTT.DataTextField = "TEN";
            ddlTucachTGTT.DataValueField = "MA";
            ddlTucachTGTT.DataBind();
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

        private void LoadTGTTFromDonKK()
        {
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            APS_DON_BL oBL = new APS_DON_BL();
            chkListTGTT.DataSource = oBL.APS_DON_TGTT_GETLIST(DONID);
            chkListTGTT.DataTextField = "arrTEN";
            chkListTGTT.DataValueField = "ID";
            chkListTGTT.DataBind();
        }

        private void ResetControls()
        {
            #region Thiều

            GetDuongSu();
            lstDataDuongSu.Value = "";

            #endregion Thiều
            if (ddlTucachTGTT.SelectedValue == "TGTTDS_02" || ddlTucachTGTT.SelectedValue == "TGTTDS_07" || ddlTucachTGTT.SelectedValue == "TGTTDS_18")
            {
                pnItemDs.Visible = true;
                pn_daidien.Visible = true;
            }
            else
            {
                pnItemDs.Visible = false;

                pn_daidien.Visible = false;
            }

            lbthongbao.Text = "";
            txtHoten.Text = "";
            //txtNDD_Hoten.Text = "";
            txtBD_CMND.Text = "";
            txtBD_CCCD.Text = "";
            txtBD_HoChieu.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtNgaythamgia.Text = "";
            txtDienThoai.Text = txtFax.Text = txtEmail.Text = "";
            hddid.Value = "0";

            //--------------------------

            txt_TEN_VPLS.Text = "";
            txt_DOAN_LS.Text = "";
            //txt_SO_DK.Text = "";
            load_so_dk("PT");
            txt_DIA_CHI.Text = "";
            txt_NGAY_DK.Text = "";
        }

        private bool CheckValid()
        {
            if (ddlTucachTGTT.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tư cách tham gia tố tụng. Hãy nhập lại!";
                ddlTucachTGTT.Focus();
                return false;
            }
            if (!chkBoxCMNDBD.Checked)
            {
                if (string.IsNullOrEmpty(txtBD_CMND.Text) && string.IsNullOrEmpty(txtBD_CCCD.Text) && string.IsNullOrEmpty(txtBD_HoChieu.Text))
                {
                    lbthongbao.Text = "Bạn cần nhập 1 trong 3 nội dung Số CMND/ Thẻ căn cước/ Hộ chiếu. Nếu không có vui lòng tích chọn 'Không có'.";
                    txtBD_CMND.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtBD_CMND.Text) && txtBD_CMND.Text.Length < 8)
                {
                    lbthongbao.Text = "Số CMND chưa đúng định dạng!";
                    txtBD_CMND.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtBD_CCCD.Text) && txtBD_CCCD.Text.Length < 12)
                {
                    lbthongbao.Text = "Số CCCD chưa đúng định dạng!";
                    txtBD_CCCD.Focus();
                    return false;
                }
                if (!string.IsNullOrEmpty(txtBD_HoChieu.Text) && txtBD_HoChieu.Text.Length < 8)
                {
                    lbthongbao.Text = "Số hộ chiếu chưa đúng định dạng!";
                    txtBD_HoChieu.Focus();
                    return false;
                }
            }
            if (txtHoten.Text.Trim() == "")
            {
                lbthongbao.Text = "Chưa nhập họ tên người tham gia tố tụng.";
                txtHoten.Focus();
                return false;
            }
            else if (txtHoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Họ tên người tham gia tố tụng không quá 250 ký tự.";
                txtHoten.Focus();
                return false;
            }
            if (txtNgaythamgia.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgaythamgia.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy).";
                txtNgaythamgia.Focus();
                return false;
            }
            if (txtND_TTChitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_TTChitiet.Focus();
                return false;
            }
            if (txtND_HKTT_Chitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_HKTT_Chitiet.Focus();
                return false;
            }
            if (txtND_Ngaysinh.Text.Trim() != "" && Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).";
                txtND_Ngaysinh.Focus();
                return false;
            }
            if (ddlTucachTGTT.SelectedValue == "TGTTDS_02" || ddlTucachTGTT.SelectedValue == "TGTTDS_07" || ddlTucachTGTT.SelectedValue == "TGTTDS_18")
            {
                if (txt_NGAY_DK.Text == "")
                {
                    lbthongbao.Text = " Ngày đăng ký không được để trống. Hãy hiểm tra lại";
                    return false;
                }
            }
            if (ddlNguoiphancong.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn người phân công !";
                return false;
            }
            //if (txtNDD_Hoten.Text.Trim().Length > 250)
            //{
            //    lbthongbao.Text = "Người đại diện không nhập quá 250 ký tự. Hãy nhập lại!";
            //    txtNDD_Hoten.Focus();
            //    return false;
            //}
            return true;
        }

        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            try
            {
                DateTime d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    txtND_Namsinh.Text = d.Year.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                APS_PHUCTHAM_THAMGIATOTUNG oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new APS_PHUCTHAM_THAMGIATOTUNG();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.APS_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                }

                #region Thiều

                if (lstDataDuongSu.Value == ",")
                {
                    lstDataDuongSu.Value = "";
                }
                List<decimal> lstDuongsuId = lstDataDuongSu.Value.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => Convert.ToDecimal(s)).ToList();
                var data = (from s in dt.APS_DON_DUONGSU
                            join d in dt.DM_DATAITEM on s.TUCACHTOTUNG_MA equals d.MA
                            where lstDuongsuId.Contains(s.ID)
                            select new
                            {
                                TENDUONGSU = s.TENDUONGSU + " (" + d.TEN + ")",
                            });

                oND.DUONGSUID = lstDataDuongSu.Value;

                #endregion Thiều

                oND.DONID = DONID;
                oND.SOCMND = txtBD_CMND.Text;
                oND.SO_CCCD = txtBD_CCCD.Text;
                oND.SO_HO_CHIEU = txtBD_HoChieu.Text;
                oND.HOTEN = txtHoten.Text;
                oND.TUCACHTGTTID = ddlTucachTGTT.SelectedValue;
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.NGAYSINH = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                //oND.NGUOIDAIDIEN = txtNDD_Hoten.Text;
                oND.DIENTHOAI = txtDienThoai.Text;
                oND.FAX = txtFax.Text;
                oND.EMAIL = txtEmail.Text;
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //------------------------------

                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                oND.DIACHI = txt_DIA_CHI.Text;
                oND.TEN_VPLS = txt_TEN_VPLS.Text;
                oND.DOAN_LS = txt_DOAN_LS.Text;
                oND.SO_DK = Convert.ToDecimal(txt_SO_DK.Text);
                oND.NGAY_DK = (String.IsNullOrEmpty(txt_NGAY_DK.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txt_NGAY_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //căt chuỗi chức vụ
                string cvcd = ddlNguoiphancong.SelectedItem.Text + "   ";
                int vt = cvcd.IndexOf('-');
                cvcd = cvcd.Substring(vt + 1, cvcd.Length - vt - 2);
                oND.CHUCVU_CHUCDANH = cvcd.Trim();

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_PHUCTHAM_THAMGIATOTUNG.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "setValidateCMND()");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        public void LoadGrid()
        {
            lbthongbao.Text = "";
            APS_PHUCTHAM_BL oBL = new APS_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.APS_PHUCTHAM_TGTT_GETLIST(ID);

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
            ResetControls();
        }

        public void xoa(decimal id)
        {
            APS_PHUCTHAM_THAMGIATOTUNG oND = dt.APS_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
                APS_PHUCTHAM_HDXX APS_PHUCTHAM_HDXX = dt.APS_PHUCTHAM_HDXX.Where(x => x.ID == DONID).FirstOrDefault<APS_PHUCTHAM_HDXX>();
                if (APS_PHUCTHAM_HDXX != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin người tiến hành tố tụng.";
                    return;
                }
                APS_PHUCTHAM_QUYETDINH APS_PHUCTHAM_QUYETDINH = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == DONID).FirstOrDefault<APS_PHUCTHAM_QUYETDINH>();
                if (APS_PHUCTHAM_QUYETDINH != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại quyết định vụ việc.";
                    return;
                }
                APS_PHUCTHAM_BANAN APS_PHUCTHAM_BANAN = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<APS_PHUCTHAM_BANAN>();
                if (APS_PHUCTHAM_BANAN != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                    return;
                }
                dt.APS_PHUCTHAM_THAMGIATOTUNG.Remove(oND);
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
        }

        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            APS_PHUCTHAM_THAMGIATOTUNG oND = dt.APS_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                txtHoten.Text = oND.HOTEN;
                ddlTucachTGTT.SelectedValue = oND.TUCACHTGTTID.ToString();
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
                if (oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                txtDienThoai.Text = oND.DIENTHOAI + "";
                txtFax.Text = oND.FAX + "";
                //if (string.IsNullOrEmpty(oND.SOCMND))
                //{
                //    chkBoxCMNDBD.Checked = true;
                //}
                //else
                //{
                //    chkBoxCMNDBD.Checked = false;
                //}
                if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID + "") != null)
                    ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID + "";

                if (ddlTucachTGTT.SelectedValue == "TGTTDS_02" || ddlTucachTGTT.SelectedValue == "TGTTDS_07" || ddlTucachTGTT.SelectedValue == "TGTTDS_18")
                {
                    pnItemDs.Visible = true;
                    pn_daidien.Visible = true;

                    txt_TEN_VPLS.Text = oND.TEN_VPLS;
                    txt_DOAN_LS.Text = oND.DOAN_LS;
                    txt_DIA_CHI.Text = oND.DIACHI;
                    txt_SO_DK.Text = Convert.ToString(oND.SO_DK);
                    txtBD_CMND.Text = oND.SOCMND;
                    txtBD_CCCD.Text = oND.SO_CCCD;
                    txtBD_HoChieu.Text = oND.SO_HO_CHIEU;
                    if (oND.NGAY_DK != null) txt_NGAY_DK.Text = ((DateTime)oND.NGAY_DK).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    pnItemDs.Visible = false;

                    pn_daidien.Visible = false;
                }

                txtBD_CMND.Text = oND.SOCMND;
                txtBD_CCCD.Text = oND.SO_CCCD;
                txtBD_HoChieu.Text = oND.SO_HO_CHIEU;
                txtEmail.Text = oND.EMAIL + "";

                #region Thiều

                GetDuongSu(oND.DUONGSUID);

                #endregion Thiều

                //txtNDD_Hoten.Text = oND.NGUOIDAIDIEN;
                if (oND.NGAYTHAMGIA != null) txtNgaythamgia.Text = ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
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
                        pnNew.Visible = true;
                        pnChon.Visible = false;
                        rdbLoai.SelectedValue = "0";
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

        #endregion "Phân trang"

        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoai.SelectedValue == "0")
            {
                pnNew.Visible = true;
                pnChon.Visible = false;
            }
            else
            {
                pnNew.Visible = false;
                pnChon.Visible = true;
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
                    if (dt.APS_PHUCTHAM_THAMGIATOTUNG.Where(x => x.NTGTT_DONKK_ID == NID).ToList().Count == 0)
                    {
                        APS_DON_THAMGIATOTUNG oD = dt.APS_DON_THAMGIATOTUNG.Where(x => x.ID == NID).FirstOrDefault();
                        APS_PHUCTHAM_THAMGIATOTUNG oS = new APS_PHUCTHAM_THAMGIATOTUNG();
                        oS.DONID = oD.DONID;
                        oS.HOTEN = oD.HOTEN;
                        oS.TUCACHTGTTID = oD.TUCACHTGTTID;
                        oS.TAMTRUCHITIET = oD.TAMTRUCHITIET;
                        oS.HKTTCHITIET = oD.HKTTCHITIET;
                        oS.NGAYSINH = oD.NGAYSINH;
                        oS.THANGSINH = oD.THANGSINH;
                        oS.NAMSINH = oD.NAMSINH;
                        oS.GIOITINH = oD.GIOITINH;
                        oS.NGUOIDAIDIEN = oD.NGUOIDAIDIEN;
                        oS.CHUCVU = oD.CHUCVU;
                        oS.EMAIL = oD.EMAIL;
                        oS.FAX = oD.FAX;
                        oS.DIENTHOAI = oD.DIENTHOAI;
                        oS.NGAYTHAMGIA = oD.NGAYTHAMGIA;
                        oS.NGAYKETTHUC = oD.NGAYKETTHUC;

                        //--------------------
                        oS.TEN_VPLS = oD.TEN_VPLS;
                        oS.DOAN_LS = oD.DOAN_LS;
                        oS.SO_DK = oD.SO_DK;
                        oS.NGAY_DK = oD.NGAY_DK;

                        oS.NGAYTAO = DateTime.Now;
                        oS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oS.NTGTT_DONKK_ID = oD.ID;
                        dt.APS_PHUCTHAM_THAMGIATOTUNG.Add(oS);
                        dt.SaveChanges();
                    }
                }
            }
            if (flag)
            {
                lblMsgChon.Text = "Lưu thành công !";
                LoadGrid();
            }
            else
            {
                lblMsgChon.Text = "Chưa chọn người tham gia tố tụng !";
            }
        }

        #region tamnc

        protected void ddlTuCachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool ck = true;

            if (ddlTucachTGTT.SelectedValue == "TGTTDS_02" || ddlTucachTGTT.SelectedValue == "TGTTDS_07" || ddlTucachTGTT.SelectedValue == "TGTTDS_18")
            {
                pnItemDs.Visible = true;
                pn_daidien.Visible = true;
                ck = false;
            }
            else
            {
                pnItemDs.Visible = false;
                pn_daidien.Visible = false;
            }
            if (ddlTucachTGTT.SelectedValue == "TGTTDS_01")
            {
                pnItemDs.Visible = true;
            }
            else
            {
                if (ck)
                {
                    pnItemDs.Visible = false;
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtHoten.ClientID);
            lbthongbao_export.Text = string.Empty;
            lbthongbao.Text = "";
        }

        private void load_so_dk(string v_ptst)
        {
            //------------------
            APS_NGUOITHAMGIATOTUNG_BL oBL = new APS_NGUOITHAMGIATOTUNG_BL();
            decimal sodk_ = 0;
            oBL.SO_DK_RETURN(v_ptst, ref sodk_, Session[ENUM_SESSION.SESSION_DONVIID] + "");
            txt_SO_DK.Text = Convert.ToString(sodk_);
            //-------------------
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

        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        protected void btn_GXN_NBC_Click(object sender, EventArgs e)
        {
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
                    if (Item.Cells[0].Text.Trim() != "TGTTDS_02" && Item.Cells[0].Text.Trim() != "TGTTDS_07" && Item.Cells[0].Text.Trim() != "TGTTDS_18")
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
                APS_NGUOITHAMGIATOTUNG_BL objBL = new APS_NGUOITHAMGIATOTUNG_BL();
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = objBL.GET_BC_GIAYXX_NBC("PT", vArrSelectID, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
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

        #endregion tamnc
    }
}