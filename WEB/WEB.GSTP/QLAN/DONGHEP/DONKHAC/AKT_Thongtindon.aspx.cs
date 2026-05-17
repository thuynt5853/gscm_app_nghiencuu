using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using BL.GSTP.AKT;
using DAL.GSTP;
using Module.Common;
using System.Data;
using System.Globalization;
using System.IO;

namespace WEB.GSTP.QLAN.DONGHEP.DONKHAC
{
    public partial class AKT_Thongtindon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["DONGHEPID"] != "")
                {
                    cmdUpdateAndNewB.Visible = false;
                }
                txtGhichu.Visible = false;
                pnTTD.Visible = false;
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;

                txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                LoadCombobox();
                ddlLoaidon_SelectedIndexChanged(sender, e);
                LoadQD_BAKhangCao("1");
                LoadQD_BAKhangNghi("1");
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                LoadLoaiDon(false);
                string strDonID = Session["DS_THEMDSK"] + "";
                if (strtype == "new")
                {
                    if (strDonID != "")
                    {
                        hddID.Value = Session["DS_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["DS_THEMDSK"]);
                        LoadInfo(ID);
                    }
                }
                else if (strtype == "list")
                {
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);

                    }
                }
                else
                {
                    #region Thiều
                    string DonghepId = Request["DONGHEPID"] + "";
                    if (!string.IsNullOrEmpty(DonghepId))
                    {
                        hddID.Value = DonghepId.ToString();
                        decimal ID = Convert.ToDecimal(DonghepId);
                        LoadInfo(ID);

                    }
                    else
                    {
                        current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                        if (string.IsNullOrEmpty(current_id))
                        {
                            Response.Redirect("/Trangchu.aspx");
                            Response.End();
                        }
                        decimal IdDon = Convert.ToDecimal(current_id);
                        AKT_DON oT = dt.AKT_DON.Where(x => x.ID == IdDon).FirstOrDefault();
                        txtQuanhephapluat_name(oT);
                        if (oT.QHPLTKID != null)
                            ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                    }
                    ddlQHPLTK.Enabled = false;
                    txtQuanhephapluat.Enabled = false;
                    #endregion
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
                ddlHinhthucnhandon.Focus();
            }
        }
        void LoadLoaiDon(bool blnTructuyen)
        {
            ddlHinhthucnhandon.Items.Clear();
            if (blnTructuyen)
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tuyến", "3"));
            else
            {
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tiếp", "1"));
                ddlHinhthucnhandon.Items.Add(new ListItem("Qua bưu điện", "2"));
            }
        }
        #region Thiều
        private void LoadInfo(decimal ID)
        {
            decimal loaidon = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
            DON_KHAC oD = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 4).FirstOrDefault();
            AKT_DON AKT = dt.AKT_DON.FirstOrDefault(s => s.ID == oD.DONID);
            txtMaVuViec.Text = AKT.MAVUVIEC;
            txtTenVuViec.Text = AKT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            if (oD.HINHTHUCNHAN == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            ddlHinhthucnhandon.SelectedValue = oD.HINHTHUCNHAN.ToString();
            if (oD.NGAYVIETDON != DateTime.MinValue && oD.NGAYVIETDON != null) txtNgayViet.Text = ((DateTime)oD.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oD.NGAYNHANDON != DateTime.MinValue && oD.NGAYNHANDON != null) txtNgayNhan.Text = ((DateTime)oD.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
            ddlLoaiQuanhe.SelectedValue = AKT.LOAIQUANHE.ToString();
            AKT_DON AKToD = dt.AKT_DON.Where(x => x.ID == oD.DONID).FirstOrDefault();
            txtQuanhephapluat_name(AKToD);
            if (AKT.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = AKT.QHPLTKID.ToString();

            if (ddlCanbonhandon.Items.FindByValue(oD.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oD.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oD.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oD.THAMPHANKYNHANDON + "";

            //ddlYeutonuocngoai.SelectedValue = oD.YEUTONUOCNGOAI.ToString();

            ddlLoaidon.SelectedValue = oD.LOAIDON.ToString();
            if (oD.LOAIDON == 7)
            {
                if (oD.LOAIKCKN == 1)
                {
                    pnKhangCao.Visible = true;
                    pnKhangNghi.Visible = false;
                    rdbPanelKC.SelectedValue = "1";
                    rdbPanelKN.SelectedValue = "1";
                    rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    LoadQD_BAKhangCao(oD.LOAIKHANGCAO.ToString());
                    ddlNguoiKC.SelectedValue = oD.DUONGSUID.ToString() + "," + oD.ISDUONGSU;
                    if (oD.NGAYVIETDONKC != DateTime.MinValue && oD.NGAYVIETDONKC != null) txtNgayVDKC.Text = ((DateTime)oD.NGAYVIETDONKC).ToString("dd/MM/yyyy", cul);
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgayKC.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    if (!String.IsNullOrEmpty(oD.SOQDBA)) { ddlQDBA.SelectedValue = oD.SOQDBA.ToString(); }
                    RdKCQH.SelectedValue = oD.ISQUAHAN.ToString();
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaQDBA.Text = oToaAn.TEN; } else { txtToaQDBA.Text = ""; }
                    //if (oD.TOAANRAQDID != null)
                    //{
                    //    txtToaQDBA.Text = oD.TOAANRAQDID.ToString();
                    //}
                    txtNDKC.Text = oD.NOIDUNGDON;
                }
                if (oD.LOAIKCKN == 2)
                {
                    rdbPanelKN.SelectedValue = "2";
                    rdbPanelKC.SelectedValue = "2";
                    pnKhangCao.Visible = false;
                    pnKhangNghi.Visible = true;
                    rdbLoaiKN.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    LoadQD_BAKhangNghi(oD.LOAIKHANGCAO.ToString());
                    rdbDonVi.SelectedValue = oD.NGUOIKCKN.ToString();
                    txtSokhangnghi.Text = oD.SOKHANGNGHI.ToString();

                    rdbCapkhangnghi.Items.Clear();
                    if (rdbDonVi.SelectedValue == "0")//Chánh án
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "1";
                    }
                    else//Viện kiểm sát
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "0";
                    }
                    if (rdbCapkhangnghi.SelectedValue == "0")
                    {
                        ddlDonViKN.Items.Clear();
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                        if (lstVKS.Count > 0)
                        {
                            ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                        }
                        trDVKN.Visible = true;
                    }
                    else
                    {
                        trDVKN.Visible = true;
                        LoadDVKN();
                    }

                    rdbCapkhangnghi.SelectedValue = oD.CAPKHANGNGHI.ToString();
                    ddlDonViKN.SelectedValue = oD.DONVIKHANGNGHI.ToString();
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangnghi.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    if (oD.SOQDBA.ToString() != "") { ddlQDBA.SelectedValue = oD.SOQDBA.ToString(); }
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KN.Text = oToaAn.TEN; } else { txtToaAnQD_KN.Text = ""; }
                    //if (oD.TOAANRAQDID != null)
                    //{
                    //    txtToaQDBA.Text = oD.TOAANRAQDID.ToString();
                    //}
                    txtNoidungKN.Text = oD.NOIDUNGDON;
                }


            }
            //txtGhichu.Text = oD.GHICHU;
            //Load đơn khác
            if (oD.LOAIDON == 8)
            {
                if (oD.ISDUONGSU == 0)
                {
                    AKT_DON_THAMGIATOTUNG oTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.ID == oD.DUONGSUID).FirstOrDefault();
                    ddlNguoidungdon.SelectedValue = oTT.ID + ",0";
                    txtHoTen_DK.Text = oTT.HOTEN;
                    if (oTT.SOCMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oTT.SOCMND;
                    }
                    ddlTuCachToTung_DK.SelectedValue = oTT.TUCACHTGTTID;
                    if (oTT.TAMTRUTINHID != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oTT.TAMTRUTINHID.ToString();
                        LoadDrop_Huyen_DK();
                        if (oTT.TAMTRUID != null)
                        {
                            ddlTamtru_Huyen_DK.SelectedValue = oTT.TAMTRUID.ToString();
                        }
                    }
                    txtDiaChiCT_DK.Text = oTT.TAMTRUCHITIET;
                    txtNamsinh_DK.Text = oTT.NAMSINH == 0 ? "" : oTT.NAMSINH.ToString();
                    ddlGioiTinh_DK.SelectedValue = oTT.GIOITINH.ToString();
                    txtEmail_DK.Text = oTT.EMAIL;
                    txtTel_DK.Text = oTT.DIENTHOAI;
                    txtND_DK.Text = oD.NOIDUNGDON;
                    if (oTT.NGAYSINH == null)
                    {
                        if (txtNamsinh_DK.Text.Length == 4)
                        {
                            string NgaySinhstr = "";
                            if (txtNgaysinh_DK.Text == "")
                            {
                                NgaySinhstr = "";
                            }
                            else
                            {
                                if (Cls_Comon.IsValidDate(txtNgaysinh_DK.Text))
                                {
                                    string[] arr = txtNgaysinh_DK.Text.Split('/');
                                    NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtNamsinh_DK.Text;
                                    txtNgaysinh_DK.Text = NgaySinhstr;
                                }
                            }
                            txtNgaysinh_DK.Text = NgaySinhstr;
                        }
                    }
                    else
                    {
                        if (oTT.NGAYSINH != DateTime.MinValue && oTT.NGAYSINH != null) txtNgaysinh_DK.Text = ((DateTime)oTT.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    }
                    //txtND_DK.Text = oD.NOIDUNGDON;
                    ddlGioiTinh_DK.SelectedValue = oTT.GIOITINH.ToString();
                    ddlTuCachToTung_DK.Enabled = false;
                    if (oTT.HOTEN != null)
                    {
                        txtHoTen_DK.Enabled = false;
                    }
                    else
                    {
                        txtHoTen_DK.Enabled = true;
                    }
                    ddlLoaidungdon.Enabled = false;
                    txtCMND_Dk.Enabled = false;
                    chkBoxCMND_DK.Enabled = false;
                    if (oTT.NGAYSINH != null && oTT.NGAYSINH != DateTime.MinValue)
                    {
                        txtNgaysinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNgaysinh_DK.Enabled = true;
                    }
                    if (oTT.NAMSINH != null && oTT.NAMSINH != 0)
                    {
                        txtNamsinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNamsinh_DK.Enabled = true;
                    }
                    if (oTT.GIOITINH != null)
                    {
                        ddlGioiTinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlGioiTinh_DK.Enabled = true;
                    }
                    if (oTT.TAMTRUTINHID != null && oTT.TAMTRUTINHID != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oTT.TAMTRUID != null && oTT.TAMTRUID != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
                    }
                    if (oTT.EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oTT.DIENTHOAI != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oTT.TAMTRUCHITIET != null)
                    {
                        txtDiaChiCT_DK.Enabled = false;
                    }
                    else
                    {
                        txtDiaChiCT_DK.Enabled = true;
                    }
                }
                if (oD.ISDUONGSU == 1)
                {
                    AKT_DON_DUONGSU oDonDS = dt.AKT_DON_DUONGSU.Where(x => x.ID == oD.DUONGSUID).FirstOrDefault();
                    ddlNguoidungdon.SelectedValue = oDonDS.ID + ",1";
                    txtHoTen_DK.Text = oDonDS.TENDUONGSU;
                    if (oDonDS.SOCMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oDonDS.SOCMND;
                    }
                    ddlTuCachToTung_DK.SelectedValue = oDonDS.TUCACHTOTUNG_MA;
                    if (oDonDS.TAMTRUTINHID != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oDonDS.TAMTRUTINHID.ToString();
                        LoadDrop_Huyen_DK();
                        if (oDonDS.TAMTRUID != null)
                        {
                            ddlTamtru_Huyen_DK.SelectedValue = oDonDS.TAMTRUID.ToString();
                        }
                    }
                    txtDiaChiCT_DK.Text = oDonDS.TAMTRUCHITIET;
                    txtNamsinh_DK.Text = oDonDS.NAMSINH == 0 ? "" : oDonDS.NAMSINH.ToString();
                    ddlGioiTinh_DK.SelectedValue = oDonDS.GIOITINH.ToString();
                    txtEmail_DK.Text = oDonDS.EMAIL;
                    txtTel_DK.Text = oDonDS.DIENTHOAI;
                    ddlLoaidungdon.SelectedValue = oDonDS.LOAIDUONGSU.ToString();
                    if (oDonDS.NGAYSINH == null)
                    {
                        if (txtNamsinh_DK.Text.Length == 4)
                        {
                            string NgaySinhstr = "";
                            if (txtNgaysinh_DK.Text == "")
                            {
                                NgaySinhstr = "";
                            }
                            else
                            {
                                if (Cls_Comon.IsValidDate(txtNgaysinh_DK.Text))
                                {
                                    string[] arr = txtNgaysinh_DK.Text.Split('/');
                                    NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtNamsinh_DK.Text;
                                    txtNgaysinh_DK.Text = NgaySinhstr;
                                }
                            }
                            txtNgaysinh_DK.Text = NgaySinhstr;
                        }
                    }
                    else
                    {
                        if (oDonDS.NGAYSINH != DateTime.MinValue && oDonDS.NGAYSINH != null) txtNgaysinh_DK.Text = ((DateTime)oDonDS.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    }
                    txtND_DK.Text = oD.NOIDUNGDON;
                    ddlGioiTinh_DK.SelectedValue = oDonDS.GIOITINH.ToString();
                    ddlTuCachToTung_DK.Enabled = false;
                    if (oDonDS.TENDUONGSU != null)
                    {
                        txtHoTen_DK.Enabled = false;
                    }
                    else
                    {
                        txtHoTen_DK.Enabled = true;
                    }
                    if (oDonDS.LOAIDUONGSU != null)
                    {
                        ddlLoaidungdon.Enabled = false;
                    }
                    else
                    {
                        ddlLoaidungdon.Enabled = true;
                    }
                    txtCMND_Dk.Enabled = false;
                    chkBoxCMND_DK.Enabled = false;
                    if (oDonDS.NGAYSINH != null && oDonDS.NGAYSINH != DateTime.MinValue)
                    {
                        txtNgaysinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNgaysinh_DK.Enabled = true;
                    }
                    if (oDonDS.NAMSINH != null && oDonDS.NAMSINH != 0)
                    {
                        txtNamsinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNamsinh_DK.Enabled = true;
                    }
                    if (oDonDS.GIOITINH != null)
                    {
                        ddlGioiTinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlGioiTinh_DK.Enabled = true;
                    }
                    if (oDonDS.TAMTRUTINHID != null && oDonDS.TAMTRUTINHID != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oDonDS.TAMTRUID != null && oDonDS.TAMTRUID != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
                    }
                    if (oDonDS.EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oDonDS.DIENTHOAI != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oDonDS.TAMTRUCHITIET != null)
                    {
                        txtDiaChiCT_DK.Enabled = false;
                    }
                    else
                    {
                        txtDiaChiCT_DK.Enabled = true;
                    }
                }
            }

            if (loaidon == 7)
            {
                DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                DON_KHAC DonKhac = dt.DON_KHAC.Where(x => x.ID == ID).FirstOrDefault();

                if (DonKhac.LOAIKCKN == 1)
                {
                    lbtDownload.Visible = false;
                    if (oFile != null)
                    {
                        lbtDownload.Visible = true;
                        hddFileID.Value = oFile.DONKHAC_ID.ToString();
                    }
                    else
                    {
                        lbtDownload.Visible = false;
                        hddFileID.Value = "0";
                    }
                }
                if (DonKhac.LOAIKCKN == 2)
                {
                    lbtDownloadKhangNghi.Visible = false;
                    if (oFile != null)
                    {
                        lbtDownloadKhangNghi.Visible = true;
                        hddFileID.Value = oFile.DONKHAC_ID.ToString();
                    }
                    else
                    {
                        lbtDownload.Visible = false;
                        hddFileID.Value = "0";
                    }
                }

                lbNoidung.Text = "Nội dung khởi kiện";
                pnTTD.Visible = false;
            }
            else if (loaidon == 8)
            {
                lbNoidung.Text = "Nội dung khởi kiện";
                pnKhangCao.Visible = false;
                pnTTD.Visible = true;
            }
        }

        #endregion 
        private bool CheckValid()
        {
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }

            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            if (ddlLoaidon.SelectedValue == "7")
            {
                if (rdbPanelKC.SelectedValue == "1")
                {
                    if (ddlNguoiKC.SelectedValue == "0")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiKC.ClientID);
                        return false;
                    }
                    if (rdbLoaiKC.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn loại kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbLoaiKC.ClientID);
                        return false;
                    }
                    //if (ddlQDBA.SelectedValue == "")
                    //{
                    //    lstMsgB.Text = "Bạn chưa chọn bản án quyết định.";
                    //    Cls_Comon.SetFocus(this, this.GetType(), ddlQDBA.ClientID);
                    //    return false;
                    //}
                    if (txtNgayKC.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập ngày kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgayKC.ClientID);
                        return false;
                    }
                    if (RdKCQH.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn kháng cáo quá hạn.";
                        Cls_Comon.SetFocus(this, this.GetType(), RdKCQH.ClientID);
                        return false;
                    }
                }
                if (rdbPanelKN.SelectedValue == "2")
                {
                    if (rdbDonVi.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbDonVi.ClientID);
                        return false;
                    }
                    if (rdbCapkhangnghi.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn cấp kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbDonVi.ClientID);
                        return false;
                    }
                    if (txtSokhangnghi.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn số kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
                        return false;
                    }
                    if (txtNgaykhangnghi.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn ngày kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaykhangnghi.ClientID);
                        return false;
                    }
                    if (rdbLoaiKN.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn loại kháng nghị kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbLoaiKN.ClientID);
                        return false;
                    }
                    if (ddlSOQDBAKhangNghi.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn số QĐ/BA.";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlSOQDBAKhangNghi.ClientID);
                        return false;
                    }
                    if (ddlDonViKN.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn đơn vị kháng nghị";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlDonViKN.ClientID);
                        return false;
                    }
                    if (txtNoidungKN.Text.Trim().Length > 1000)
                    {
                        lstMsgB.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                        Cls_Comon.SetFocus(this, this.GetType(), txtNoidungKN.ClientID);
                        return false;
                    }
                }
            }
            else if (ddlLoaidon.SelectedValue == "8")
            {
                if (ddlNguoidungdon.SelectedValue == "")
                {
                    lstMsgB.Text = "Bạn chưa chọn người đứng đơn";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlNguoidungdon.ClientID);
                    return false;
                }
                if (txtHoTen_DK.Text == "")
                {
                    lstMsgB.Text = "Bạn chưa nhập họ tên";
                    Cls_Comon.SetFocus(this, this.GetType(), txtHoTen_DK.ClientID);
                    return false;
                }
                if (ddlTuCachToTung_DK.SelectedValue == "")
                {
                    lstMsgB.Text = "Bạn chưa chọn tư cách tham gia tố tụng";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlTuCachToTung_DK.ClientID);
                    return false;
                }
                if (!chkBoxCMND_DK.Checked)
                {
                    if (string.IsNullOrEmpty(txtCMND_Dk.Text))
                    {
                        lstMsgB.Text = "Bạn chưa nhập Số CMND/ Thẻ căn cước.";
                        txtCMND_Dk.Focus();
                        return false;
                    }

                }
                //if (txtNamsinh_DK.Text == "")
                //{
                //    lstMsgB.Text = "Bạn chưa nhập năm sinh đương sự.";
                //    txtNamsinh_DK.Focus();
                //    return false;
                //}

            }
            return true;
        }

        #region Thiều

        #endregion
        private void ResetControls()
        {

            ddlQuanhephapluat.SelectedIndex = 0;
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            txtNgayViet.Text = "";
            ddlNguoiKC.SelectedValue = "0";
            hddFilePath.Value = "";
            txtNgayVDKC.Text = "";
            txtNgayKC.Text = "";
            txtNgayQDBA.Text = "";
            rdbLoaiKC.SelectedValue = "1";
            RdKCQH.SelectedValue = "0";
            txtNDKC.Text = "";
            txtToaQDBA.Text = "";
            ddlLoaidungdon.SelectedValue = "1";
            ddlNguoidungdon.SelectedValue = "0,0";
            ddlTuCachToTung_DK.SelectedIndex = 0;
            txtHoTen_DK.Text = "";
            txtCMND_Dk.Text = "";
            chkBoxCMND_DK.Checked = false;
            ddlGioiTinh_DK.SelectedValue = "0";
            txtNamsinh_DK.Text = "";
            txtNgaysinh_DK.Text = "";
            txtDiaChiCT_DK.Text = "";
            txtEmail_DK.Text = "";
            txtTel_DK.Text = "";
            txtND_DK.Text = "";
            ddlTuCachToTung_DK.Enabled = true;
            txtHoTen_DK.Enabled = true;
            ddlLoaidungdon.Enabled = true;
            txtCMND_Dk.Enabled = true;
            chkBoxCMND_DK.Enabled = true;
            txtNgaysinh_DK.Enabled = true;
            txtNamsinh_DK.Enabled = true;
            ddlGioiTinh_DK.Enabled = true;
            ddlTamtru_Tinh_DK.Enabled = true;
            ddlTamtru_Huyen_DK.Enabled = true;
            txtDiaChiCT_DK.Enabled = true;
            txtEmail_DK.Enabled = true;
            txtTel_DK.Enabled = true;

            rdbPanelKC.SelectedValue = "1";
            rdbPanelKN.SelectedValue = "1";
            txtToaAnQD_KN.Text = "";
            txtSokhangnghi.Text = "";
            txtNgaykhangnghi.Text = "";
            txtNoidungKN.Text = "";
            hddFilePath_KN.Value = "";
            if (ddlLoaidon.SelectedValue == "7")
            {
                pnKhangNghi.Visible = false;
                pnKhangCao.Visible = true;
                pnTTD.Visible = false;
            }
            else if (ddlLoaidon.SelectedValue == "8")
            {
                pnKhangNghi.Visible = false;
                pnKhangCao.Visible = false;
                pnTTD.Visible = true;
            }

            LoadQD_BAKhangCao("1");
            LoadQD_BAKhangNghi("1");
            LoadLoaiDon(false);
        }
        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbonhandon.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();

            //Load đương sự
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);

            AKT_DON_DUONGSU_BL oBL_DS_TGTT = new AKT_DON_DUONGSU_BL();
            ddlNguoidungdon.DataSource = oBL_DS_TGTT.AKT_DON_DUONGSU_THAMGIATOTUNG(Convert.ToDecimal(donid));
            ddlNguoidungdon.DataTextField = "TENDUONGSU";
            ddlNguoidungdon.DataValueField = "ID";
            ddlNguoidungdon.DataBind();
            ddlNguoidungdon.Items.Insert(0, new ListItem("Đương sự mới", "0,0"));

            ddlNguoiKC.Items.Clear();
            //Load đương sự
            ddlNguoiKC.DataSource = oBL_DS_TGTT.AKT_DON_DUONGSU_THAMGIATOTUNG(Convert.ToDecimal(donid));
            ddlNguoiKC.DataTextField = "TENDUONGSU";
            ddlNguoiKC.DataValueField = "ID";
            ddlNguoiKC.DataBind();
            ddlNguoiKC.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            //Load_ListNguoiThamGiaToTung();

            List<DM_DATAITEM> oTCTT = dt.DM_DATAITEM.Where(x => x.GROUPID == 11 || x.GROUPID == 16).ToList();
            ddlTuCachToTung_DK.DataSource = oTCTT;
            ddlTuCachToTung_DK.DataTextField = "TEN";
            ddlTuCachToTung_DK.DataValueField = "MA";
            ddlTuCachToTung_DK.DataBind();

            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU, ENUM_DANHMUC.QUANHEPL_TRANHCHAP);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //Load quốc tịch
            //DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            //ddlND_Quoctich.Items.Clear();
            //ddlND_Quoctich.DataSource = dtQuoctich;
            //ddlND_Quoctich.DataTextField = "TEN";
            //ddlND_Quoctich.DataValueField = "ID";
            //ddlND_Quoctich.DataBind();
            //ddlBD_Quoctich.Items.Clear();
            //ddlBD_Quoctich.DataSource = dtQuoctich;
            //ddlBD_Quoctich.DataTextField = "TEN";
            //ddlBD_Quoctich.DataValueField = "ID";
            //ddlBD_Quoctich.DataBind();

            //List<DM_TOAAN> oTOAAN = dt.DM_TOAAN.OrderBy(x => x.ARRTHUTU).ToList();
            //ddlToaQDBA.DataSource = oTOAAN;
            //ddlToaQDBA.DataTextField = "TEN";
            //ddlToaQDBA.DataValueField = "ID";
            //ddlToaQDBA.DataBind();
            //ddlToaQDBA.Items.Insert(0, new ListItem("--Chọn--", "0"));

            LoadDropTinh();
        }
        #region Thiều
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                decimal ID = Convert.ToDecimal(hddID.Value);
                decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                var loaiDon = ddlLoaidon.SelectedValue;
                if (loaiDon == "7")
                {
                    string loaiKN = rdbPanelKN.SelectedValue;
                    string loaiKC = rdbPanelKC.SelectedValue;
                    DON_KHAC oKC = null;
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oKC = new DON_KHAC();
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                    }
                    else
                    {
                        oKC = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 4).FirstOrDefault();
                    }
                    DateTime dNgayNhanKC;
                    DateTime dNgayGhiTrenDon;
                    dNgayNhanKC = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    dNgayGhiTrenDon = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oKC.NGAYVIETDON = dNgayGhiTrenDon;
                    oKC.NGAYNHANDON = dNgayNhanKC;
                    oKC.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    oKC.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    oKC.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    oKC.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                    oKC.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI);
                    oKC.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);

                    string tenToaRaQD = "";
                    if (loaiKC == "1")
                    {
                        tenToaRaQD = txtToaQDBA.Text.ToString();
                        string[] commandArgsAccept = ddlNguoiKC.SelectedValue.ToString().Split(new char[] { ',' });
                        decimal idDuongSu = Convert.ToDecimal(commandArgsAccept[0]);
                        decimal isDuongSu = Convert.ToDecimal(commandArgsAccept[1]);
                        oKC.DUONGSUID = idDuongSu;
                        oKC.ISDUONGSU = isDuongSu;
                        oKC.SOQDBA = ddlQDBA.SelectedValue;

                        DateTime dNgayVietKC;
                        DateTime dNgayKC;
                        DateTime dNgayQDBA;
                        dNgayVietKC = (String.IsNullOrEmpty(txtNgayVDKC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVDKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dNgayKC = (String.IsNullOrEmpty(txtNgayKC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dNgayQDBA = (String.IsNullOrEmpty(txtNgayQDBA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.NGAYQDBA = dNgayQDBA;
                        oKC.NGAYKHANGCAO = dNgayKC;
                        oKC.NGAYVIETDONKC = dNgayVietKC;
                        oKC.ISQUAHAN = Convert.ToDecimal(RdKCQH.SelectedValue);
                        oKC.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                        oKC.NOIDUNGDON = txtNDKC.Text;
                        oKC.LOAIKCKN = Convert.ToDecimal(loaiKC);
                    }
                    if (loaiKN == "2")
                    {
                        oKC.NGUOIKCKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                        tenToaRaQD = txtToaAnQD_KN.Text.ToString();
                        oKC.CAPKHANGNGHI = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                        oKC.DONVIKHANGNGHI = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                        oKC.SOQDBA = ddlSOQDBAKhangNghi.SelectedValue;
                        oKC.SOKHANGNGHI = txtSokhangnghi.Text.ToString();
                        DateTime dNgayQDBAKN;
                        DateTime dNgayKN;
                        dNgayKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        dNgayQDBAKN = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.NGAYQDBA = dNgayQDBAKN;
                        oKC.NGAYKHANGCAO = dNgayKN;
                        oKC.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                        oKC.NOIDUNGDON = txtNoidungKN.Text;
                        oKC.LOAIKCKN = Convert.ToDecimal(loaiKN);
                    }

                    DM_TOAAN ToaAnRaQĐ = dt.DM_TOAAN.Where(x => x.TEN == tenToaRaQD).FirstOrDefault<DM_TOAAN>();
                    if (ToaAnRaQĐ != null)
                        oKC.TOAANRAQDID = ToaAnRaQĐ.ID;

                    oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);


                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        if (oKC.TOA_GIAIQUYET_ID == null)
                        {
                            oKC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        dt.DON_KHAC.Add(oKC);
                        dt.SaveChanges();

                    }
                    else
                    {
                        dt.SaveChanges();
                    }

                    DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                    DON_KHAC_FILE oKCFileCheck = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oKC.ID).FirstOrDefault();
                    if (oKCFileCheck != null)
                    {
                        oKCFile = oKCFileCheck;
                    }

                    if (hddFilePath.Value != "" && loaiKC == "1")
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oKCFile.NOIDUNGFILE = buff;
                            oKCFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oKCFile.KIEUFILE = oF.Extension;
                            oKCFile.DONKHAC_ID = oKC.ID;
                            if (oKCFileCheck != null)
                            {
                                dt.SaveChanges();
                            }
                            else
                            {
                                dt.DON_KHAC_FILE.Add(oKCFile);
                                dt.SaveChanges();
                            }
                        }
                    }

                    if (hddFilePath_KN.Value != "" && loaiKN == "2")
                    {
                        string strFilePath = hddFilePath_KN.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oKCFile.NOIDUNGFILE = buff;
                            oKCFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oKCFile.KIEUFILE = oF.Extension;
                            oKCFile.DONKHAC_ID = oKC.ID;
                            if (oKCFileCheck != null)
                            {
                                dt.SaveChanges();
                            }
                            else
                            {
                                dt.DON_KHAC_FILE.Add(oKCFile);
                                dt.SaveChanges();
                            }
                        }
                    }

                    AKT_DON oDS = dt.AKT_DON.Where(x => x.ID == oKC.DONID).FirstOrDefault();
                    oDS.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    dt.SaveChanges();

                    hddFileID.Value = oKC.ID.ToString();
                    hddID.Value = oKC.ID.ToString();
                }
                else if (loaiDon == "8")
                {
                    string[] commandArgsAccept = ddlNguoidungdon.SelectedValue.ToString().Split(new char[] { ',' });
                    decimal idDuongSuDK = Convert.ToDecimal(commandArgsAccept[0]);
                    decimal isDuongSuDK = Convert.ToDecimal(commandArgsAccept[1]);
                    DON_KHAC oDK = null;
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oDK = new DON_KHAC();
                    }
                    else
                    {
                        oDK = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 4).FirstOrDefault();
                    }
                    DateTime dNgayNhanKC;
                    DateTime dNgayGhiTrenDon;
                    dNgayNhanKC = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    dNgayGhiTrenDon = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oDK.NGAYVIETDON = dNgayGhiTrenDon;
                    oDK.NGAYNHANDON = dNgayNhanKC;
                    oDK.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    oDK.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    oDK.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                    oDK.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI);
                    oDK.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    oDK.NOIDUNGDON = txtND_DK.Text;
                    string IDTCTT = ddlTuCachToTung_DK.SelectedValue.ToString();
                    DM_DATAITEM TCTT = dt.DM_DATAITEM.Where(x => x.MA == IDTCTT).FirstOrDefault();
                    if (TCTT != null && TCTT.GROUPID == 11)
                    {
                        AKT_DON_DUONGSU AKT_DuongSu = null;

                        if (idDuongSuDK == 0)
                        {
                            AKT_DuongSu = new AKT_DON_DUONGSU();
                        }
                        else
                        {
                            AKT_DuongSu = dt.AKT_DON_DUONGSU.Where(x => x.ID == idDuongSuDK).FirstOrDefault();
                        }
                        decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                        AKT_DuongSu.DONID = donid;
                        AKT_DuongSu.TENDUONGSU = Cls_Comon.FormatTenRieng(txtHoTen_DK.Text);
                        if (AKT_DuongSu.ISDAIDIEN == 1)
                        {
                            AKT_DuongSu.ISDAIDIEN = 1;
                        }
                        else
                        {
                            AKT_DuongSu.ISDAIDIEN = 0;
                        }
                        AKT_DuongSu.TUCACHTOTUNG_MA = TCTT.MA;
                        AKT_DuongSu.LOAIDUONGSU = Convert.ToDecimal(ddlLoaidungdon.SelectedValue);
                        //if (chkISBVQLNK.Visible)
                        //    AKT_DuongSu.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                        //else
                        //    AKT_DuongSu.ISBVQLNGUOIKHAC = 0;
                        AKT_DuongSu.SOCMND = txtCMND_Dk.Text;
                        AKT_DuongSu.TAMTRUTINHID = Convert.ToDecimal(ddlTamtru_Tinh_DK.SelectedValue);
                        AKT_DuongSu.TAMTRUID = Convert.ToDecimal(ddlTamtru_Huyen_DK.SelectedValue);
                        AKT_DuongSu.TAMTRUCHITIET = txtDiaChiCT_DK.Text;
                        DateTime dNDNgaysinh;
                        dNDNgaysinh = (String.IsNullOrEmpty(txtNgaysinh_DK.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        AKT_DuongSu.NGAYSINH = dNDNgaysinh;
                        AKT_DuongSu.NAMSINH = txtNamsinh_DK.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh_DK.Text);
                        AKT_DuongSu.GIOITINH = Convert.ToDecimal(ddlGioiTinh_DK.SelectedValue);
                        AKT_DuongSu.EMAIL = txtEmail_DK.Text;
                        AKT_DuongSu.DIENTHOAI = txtTel_DK.Text;
                        //if (pnNDTochuc.Visible)
                        //{
                        //    AKT_DuongSu.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                        //    AKT_DuongSu.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                        //}
                        AKT_DuongSu.ISSOTHAM = 1;
                        AKT_DuongSu.ISDON = 1;
                        if (idDuongSuDK != 0)
                        {
                            AKT_DuongSu.NGAYSUA = DateTime.Now;
                            AKT_DuongSu.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                        else
                        {
                            AKT_DuongSu.NGAYTAO = DateTime.Now;
                            AKT_DuongSu.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            // insert toa_gq_id
                            if (AKT_DuongSu.TOA_GIAIQUYET_ID == null)
                            {
                                AKT_DuongSu.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }
                            dt.AKT_DON_DUONGSU.Add(AKT_DuongSu);
                            dt.SaveChanges();
                        }
                        oDK.ISDUONGSU = 1;
                        oDK.DUONGSUID = AKT_DuongSu.ID;
                    }
                    if (TCTT != null && TCTT.GROUPID == 16)
                    {
                        AKT_DON_THAMGIATOTUNG AKT_TGTT = null;

                        if (idDuongSuDK == 0)
                        {
                            AKT_TGTT = new AKT_DON_THAMGIATOTUNG();
                        }
                        else
                        {
                            AKT_TGTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.ID == idDuongSuDK).FirstOrDefault();
                        }
                        decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                        AKT_TGTT.DONID = donid;
                        AKT_TGTT.HOTEN = Cls_Comon.FormatTenRieng(txtHoTen_DK.Text);
                        //if (AKT_TGTT.ISDAIDIEN == 1)
                        //{
                        //    AKT_TGTT.ISDAIDIEN = 1;
                        //}
                        //else
                        //{
                        //    AKT_TGTT.ISDAIDIEN = 0;
                        //}
                        AKT_TGTT.TUCACHTGTTID = TCTT.MA;
                        //////AKT_TGTT. = Convert.ToDecimal(ddlLoaidungdon.SelectedValue);
                        //if (chkISBVQLNK.Visible)
                        //    AKT_TGTT.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                        //else
                        //    AKT_TGTT.ISBVQLNGUOIKHAC = 0;
                        AKT_TGTT.SOCMND = txtCMND_Dk.Text;
                        AKT_TGTT.TAMTRUTINHID = Convert.ToDecimal(ddlTamtru_Tinh_DK.SelectedValue);
                        AKT_TGTT.TAMTRUID = Convert.ToDecimal(ddlTamtru_Huyen_DK.SelectedValue);
                        AKT_TGTT.TAMTRUCHITIET = txtDiaChiCT_DK.Text;
                        DateTime dNDNgaysinh;
                        dNDNgaysinh = (String.IsNullOrEmpty(txtNgaysinh_DK.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        AKT_TGTT.NGAYSINH = dNDNgaysinh;
                        AKT_TGTT.NAMSINH = txtNamsinh_DK.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh_DK.Text);
                        AKT_TGTT.GIOITINH = Convert.ToDecimal(ddlGioiTinh_DK.SelectedValue);
                        AKT_TGTT.EMAIL = txtEmail_DK.Text;
                        AKT_TGTT.DIENTHOAI = txtTel_DK.Text;
                        //if (pnNDTochuc.Visible)
                        //{
                        //    AKT_TGTT.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                        //    AKT_TGTT.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                        //}
                        //AKT_TGTT.ISSOTHAM = 1;
                        //AKT_TGTT.ISDON = 1;
                        if (idDuongSuDK != 0)
                        {
                            AKT_TGTT.NGAYSUA = DateTime.Now;
                            AKT_TGTT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                        else
                        {
                            AKT_TGTT.NGAYTAO = DateTime.Now;
                            AKT_TGTT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            // insert toa_gq_id
                            if (AKT_TGTT.TOA_GIAIQUYET_ID == null)
                            {
                                AKT_TGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            }
                            dt.AKT_DON_THAMGIATOTUNG.Add(AKT_TGTT);
                            dt.SaveChanges();
                        }
                        oDK.ISDUONGSU = 0;
                        oDK.DUONGSUID = AKT_TGTT.ID;
                    }

                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oDK.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        // insert toa_gq_id
                        if (oDK.TOA_GIAIQUYET_ID == null)
                        {
                            oDK.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        dt.DON_KHAC.Add(oDK);
                        dt.SaveChanges();

                    }
                    else
                    {
                        dt.SaveChanges();
                    }

                    hddID.Value = oDK.ID.ToString();

                    AKT_DON oDS = dt.AKT_DON.Where(x => x.ID == oDK.DONID).FirstOrDefault();
                    oDS.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    dt.SaveChanges();
                }
                else
                {
                    ddlLoaidon.SelectedValue = "7";
                    pnKhangCao.Visible = true;

                }

                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        #endregion
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lstMsgB.Text = "Lưu thông tin đơn thành công !";
                //Session["DS_THEMDSK"] = hddID.Value;

            }
        }
        //protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        //{
        //    if (SaveData())
        //    {
        //        decimal IDVuViec = Convert.ToDecimal(hddID.Value);
        //        //Lưu vào người dùng
        //        decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
        //        QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
        //        if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
        //        {
        //            oNSD.IDANDANSU = IDVuViec;
        //            dt.SaveChanges();
        //        }
        //        Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = IDVuViec;
        //        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //        //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");

        //    }
        //}
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                //Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
            }
        }
        #region Thiều
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        #endregion
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";
            Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);

        }
        private void LoadDropTinh()
        {
            ddlTamtru_Tinh_DK.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlTamtru_Tinh_DK.DataSource = lstTinh;
                ddlTamtru_Tinh_DK.DataTextField = "TEN";
                ddlTamtru_Tinh_DK.DataValueField = "ID";
                ddlTamtru_Tinh_DK.DataBind();
            }

            ddlTamtru_Tinh_DK.Items.Insert(0, new ListItem("---Chọn---", "0"));


            LoadDrop_Huyen_DK();

        }
        private void SetValueComboBox(DropDownList ddl, object value)
        {
            ddl.ClearSelection();
            string str = value + "";
            if (str == "") return;
            if (ddl.Items.FindByValue(str) != null)
                ddl.SelectedValue = str;
        }

        private void LoadDrop_Huyen_DK()
        {
            ddlTamtru_Huyen_DK.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamtru_Tinh_DK.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamtru_Huyen_DK.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamtru_Huyen_DK.DataSource = lstHuyen;
                ddlTamtru_Huyen_DK.DataTextField = "TEN";
                ddlTamtru_Huyen_DK.DataValueField = "ID";
                ddlTamtru_Huyen_DK.DataBind();
            }
            ddlTamtru_Huyen_DK.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }

        protected void ddlTamTru_Tinh_DK_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDrop_Huyen_DK();
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamtru_Huyen_DK.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        private int TinhTuoi(DateTime NgaySinh, DateTime NgayNhanDon)
        {
            try
            {
                int nam = NgayNhanDon.Year - NgaySinh.Year;
                if (nam > 0)
                {
                    int thang = NgayNhanDon.Month - NgaySinh.Month;
                    if (thang == 0)
                    {
                        int ngay = NgayNhanDon.Day - NgaySinh.Day;
                        if (ngay <= 0)
                        { nam = nam - 1; }
                    }
                    else if (thang < 0)
                    {
                        nam = nam - 1;
                    }
                }
                return nam;
            }
            catch { return 0; }
        }

        private void txtQuanhephapluat_name(AKT_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null)
                    txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }

        protected void ddlLoaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            var loaiDon = ddlLoaidon.SelectedValue;
            if (loaiDon == "7")
            {
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;
                lbGhiChu.Visible = false;
                txtGhichu.Visible = false;
                pnKhangCao.Visible = true;
                pnTTD.Visible = false;
                decimal ID = 0;
                if (Request.QueryString["DONGHEPID"] != "")
                {
                    ID = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
                }
                DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                lbtDownload.Visible = false;
                if (oFile != null)
                {
                    lbtDownload.Visible = true;
                    hddFileID.Value = oFile.DONKHAC_ID.ToString();
                }
                else
                {
                    lbtDownload.Visible = false;
                    hddFileID.Value = "0";
                }
            }
            else if (loaiDon == "8")
            {
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;
                lbGhiChu.Visible = false;
                txtGhichu.Visible = false;
                pnKhangCao.Visible = false;
                pnTTD.Visible = true;
            }
        }

        protected void ddlNguoidungdon_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] commandArgsAccept = ddlNguoidungdon.SelectedValue.ToString().Split(new char[] { ',' });
            decimal idDuongSu = Convert.ToDecimal(commandArgsAccept[0]);
            decimal isDuongSu = Convert.ToDecimal(commandArgsAccept[1]);
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            if (ddlNguoidungdon.SelectedValue == "0,0")
            {
                ddlTuCachToTung_DK.Enabled = true;
                txtHoTen_DK.Enabled = true;
                ddlLoaidungdon.Enabled = true;
                txtCMND_Dk.Enabled = true;
                chkBoxCMND_DK.Enabled = true;
                txtNgaysinh_DK.Enabled = true;
                txtNamsinh_DK.Enabled = true;
                ddlGioiTinh_DK.Enabled = true;
                ddlTamtru_Tinh_DK.Enabled = true;
                ddlTamtru_Huyen_DK.Enabled = true;
                txtDiaChiCT_DK.Enabled = true;
                txtEmail_DK.Enabled = true;
                txtTel_DK.Enabled = true;
            }
            else
            {
                if (isDuongSu == 1)
                {
                    AKT_DON_DUONGSU oDS = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    ddlTuCachToTung_DK.Enabled = false;
                    if (oDS.TENDUONGSU != null)
                    {
                        txtHoTen_DK.Enabled = false;
                    }
                    else
                    {
                        txtHoTen_DK.Enabled = true;
                    }
                    if (oDS.LOAIDUONGSU != null)
                    {
                        ddlLoaidungdon.Enabled = false;
                    }
                    else
                    {
                        ddlLoaidungdon.Enabled = true;
                    }
                    txtCMND_Dk.Enabled = false;
                    chkBoxCMND_DK.Enabled = false;
                    if (oDS.NGAYSINH != null && oDS.NGAYSINH != DateTime.MinValue)
                    {
                        txtNgaysinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNgaysinh_DK.Enabled = true;
                    }
                    if (oDS.NAMSINH != null && oDS.NAMSINH != 0)
                    {
                        txtNamsinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNamsinh_DK.Enabled = true;
                    }
                    if (oDS.GIOITINH != null)
                    {
                        ddlGioiTinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlGioiTinh_DK.Enabled = true;
                    }
                    if (oDS.TAMTRUTINHID != null && oDS.TAMTRUTINHID != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oDS.TAMTRUID != null && oDS.TAMTRUID != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
                    }
                    if (oDS.EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oDS.DIENTHOAI != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oDS.TAMTRUCHITIET != null)
                    {
                        txtDiaChiCT_DK.Enabled = false;
                    }
                    else
                    {
                        txtDiaChiCT_DK.Enabled = true;
                    }
                }
                if (isDuongSu == 0)
                {
                    AKT_DON_THAMGIATOTUNG oDSTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    ddlTuCachToTung_DK.Enabled = false;
                    if (oDSTT.HOTEN != null)
                    {
                        txtHoTen_DK.Enabled = false;
                    }
                    else
                    {
                        txtHoTen_DK.Enabled = true;
                    }
                    ddlLoaidungdon.Enabled = false;
                    txtCMND_Dk.Enabled = false;
                    chkBoxCMND_DK.Enabled = false;
                    if (oDSTT.NGAYSINH != null && oDSTT.NGAYSINH != DateTime.MinValue)
                    {
                        txtNgaysinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNgaysinh_DK.Enabled = true;
                    }
                    if (oDSTT.NAMSINH != null && oDSTT.NAMSINH != 0)
                    {
                        txtNamsinh_DK.Enabled = false;
                    }
                    else
                    {
                        txtNamsinh_DK.Enabled = true;
                    }
                    if (oDSTT.GIOITINH != null)
                    {
                        ddlGioiTinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlGioiTinh_DK.Enabled = true;
                    }
                    if (oDSTT.TAMTRUTINHID != null && oDSTT.TAMTRUTINHID != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oDSTT.TAMTRUID != null && oDSTT.TAMTRUID != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
                    }
                    if (oDSTT.EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oDSTT.DIENTHOAI != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oDSTT.TAMTRUCHITIET != null)
                    {
                        txtDiaChiCT_DK.Enabled = false;
                    }
                    else
                    {
                        txtDiaChiCT_DK.Enabled = true;
                    }
                }

            }
            if (idDuongSu == 0)
            {
                ddlLoaidungdon.SelectedValue = "1";
                ddlTuCachToTung_DK.SelectedIndex = 0;
                txtHoTen_DK.Text = "";
                txtCMND_Dk.Text = "";
                chkBoxCMND_DK.Checked = false;
                ddlGioiTinh_DK.SelectedValue = "0";
                //chkND_ONuocNgoai.Checked = false;
                txtNamsinh_DK.Text = "";
                txtNgaysinh_DK.Text = "";
                txtDiaChiCT_DK.Text = "";
                txtEmail_DK.Text = "";
                txtTel_DK.Text = "";
                txtND_DK.Text = "";
                Cls_Comon.SetValueComboBox(ddlTamtru_Tinh_DK, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDrop_Huyen_DK();
                Cls_Comon.SetValueComboBox(ddlTamtru_Huyen_DK, Session[ENUM_SESSION.SESSION_QUAN_ID]);
            }

            else
            {
                if (isDuongSu == 1)
                {
                    AKT_DON_DUONGSU oDuongSu = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    if (oDuongSu.LOAIDUONGSU == 1)
                    {
                        ddlLoaidungdon.SelectedValue = "1";
                    }
                    else if (oDuongSu.LOAIDUONGSU == 2)
                    {
                        ddlLoaidungdon.SelectedValue = "2";
                    }
                    else if (oDuongSu.LOAIDUONGSU == 3)
                    {
                        ddlLoaidungdon.SelectedValue = "3";
                    }
                    txtHoTen_DK.Text = oDuongSu.TENDUONGSU;
                    if (oDuongSu.SOCMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oDuongSu.SOCMND;
                    }
                    if (oDuongSu.GIOITINH == 1)
                    {
                        ddlGioiTinh_DK.SelectedValue = "1";
                    }
                    else if (oDuongSu.GIOITINH == 0)
                    {
                        ddlGioiTinh_DK.SelectedValue = "0";
                    }
                    if (oDuongSu.NAMSINH == 0)
                    {
                        txtNamsinh_DK.Text = "";
                        txtNgaysinh_DK.Text = "";
                    }
                    else
                    {
                        txtNamsinh_DK.Text = oDuongSu.NAMSINH.ToString();
                        if (oDuongSu.NGAYSINH == null)
                        {
                            if (txtNamsinh_DK.Text.Length == 4)
                            {
                                string NgaySinhstr = "";
                                if (txtNgaysinh_DK.Text == "")
                                {
                                    NgaySinhstr = "01/01/" + txtNamsinh_DK.Text;
                                    txtNgaysinh_DK.Text = NgaySinhstr;
                                }
                                else
                                {
                                    if (Cls_Comon.IsValidDate(txtNgaysinh_DK.Text))
                                    {
                                        string[] arr = txtNgaysinh_DK.Text.Split('/');
                                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtNamsinh_DK.Text;
                                        txtNgaysinh_DK.Text = NgaySinhstr;
                                    }
                                }

                            }
                            else
                            {
                                txtNgaysinh_DK.Text = "";
                            }
                        }
                        else
                        {
                            if (oDuongSu.NGAYSINH != DateTime.MinValue)
                            {
                                txtNgaysinh_DK.Text = ((DateTime)oDuongSu.NGAYSINH).ToString("dd/MM/yyyy", cul);
                            }
                            else
                            {
                                txtNgaysinh_DK.Text = "";
                            }
                        }
                    }
                    ddlTuCachToTung_DK.SelectedValue = oDuongSu.TUCACHTOTUNG_MA;
                    txtDiaChiCT_DK.Text = oDuongSu.TAMTRUCHITIET;
                    ////txtChiTiet.Text = oDuongSu.DIACHICOQUAN;
                    txtEmail_DK.Text = oDuongSu.EMAIL;
                    txtTel_DK.Text = oDuongSu.DIENTHOAI;
                    if (oDuongSu.TAMTRUTINHID != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oDuongSu.TAMTRUTINHID.ToString();
                        LoadDrop_Huyen_DK();
                        try
                        {
                            if (oDuongSu.TAMTRUID != null) ddlTamtru_Huyen_DK.SelectedValue = oDuongSu.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                if (isDuongSu == 0)
                {
                    AKT_DON_THAMGIATOTUNG oTGTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtHoTen_DK.Text = oTGTT.HOTEN;
                    if (oTGTT.SOCMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oTGTT.SOCMND;
                    }
                    if (oTGTT.GIOITINH == 1)
                    {
                        ddlGioiTinh_DK.SelectedValue = "1";
                    }
                    else if (oTGTT.GIOITINH == 0)
                    {
                        ddlGioiTinh_DK.SelectedValue = "0";
                    }
                    if (oTGTT.NAMSINH == 0)
                    {
                        txtNamsinh_DK.Text = "";
                        txtNgaysinh_DK.Text = "";
                    }
                    else
                    {
                        txtNamsinh_DK.Text = oTGTT.NAMSINH.ToString();
                        if (oTGTT.NGAYSINH == null)
                        {
                            if (txtNamsinh_DK.Text.Length == 4)
                            {
                                string NgaySinhstr = "";
                                if (txtNgaysinh_DK.Text == "")
                                {
                                    NgaySinhstr = "01/01/" + txtNamsinh_DK.Text;
                                    txtNgaysinh_DK.Text = NgaySinhstr;
                                }
                                else
                                {
                                    if (Cls_Comon.IsValidDate(txtNgaysinh_DK.Text))
                                    {
                                        string[] arr = txtNgaysinh_DK.Text.Split('/');
                                        NgaySinhstr = arr[0] + "/" + arr[1] + "/" + txtNamsinh_DK.Text;
                                        txtNgaysinh_DK.Text = NgaySinhstr;
                                    }
                                }

                            }
                            else
                            {
                                txtNgaysinh_DK.Text = "";
                            }
                        }
                        else
                        {
                            if (oTGTT.NGAYSINH != DateTime.MinValue)
                            {
                                txtNgaysinh_DK.Text = ((DateTime)oTGTT.NGAYSINH).ToString("dd/MM/yyyy", cul);
                            }
                            else
                            {
                                txtNgaysinh_DK.Text = "";
                            }
                        }
                    }
                    ddlTuCachToTung_DK.SelectedValue = oTGTT.TUCACHTGTTID;
                    txtDiaChiCT_DK.Text = oTGTT.TAMTRUCHITIET;
                    ////txtChiTiet.Text = oDuongSu.DIACHICOQUAN;
                    txtEmail_DK.Text = oTGTT.EMAIL;
                    txtTel_DK.Text = oTGTT.DIENTHOAI;
                    if (oTGTT.TAMTRUTINHID != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oTGTT.TAMTRUTINHID.ToString();
                        LoadDrop_Huyen_DK();
                        try
                        {
                            if (oTGTT.TAMTRUID != null) ddlTamtru_Huyen_DK.SelectedValue = oTGTT.TAMTRUID.ToString();
                        }
                        catch (Exception ex) { }
                    }

                }
            }
        }
        public void chkBoxCMND_DK_CheckedChanged(object sender, EventArgs e)
        {
            if (chkBoxCMND_DK.Checked == true)
            {
                txtCMND_Dk.Enabled = false;
            }
            else
            {
                txtCMND_Dk.Enabled = true;
            }
        }
        protected void ddlNguoiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
            int idDuongSu = Convert.ToInt32(ddlNguoiKC.SelectedValue);
            if (idDuongSu == 0)
            {
                txtNgayVDKC.Text = "";
                txtNgayKC.Text = "";
                txtNgayQDBA.Text = "";
                rdbLoaiKC.SelectedValue = "0";
                RdKCQH.SelectedValue = "0";
                RdKCQH.SelectedValue = "";
                ddlQDBA.SelectedValue = "0";
                txtNDKC.Text = "";
                txtToaQDBA.Text = "";
            }

        }

        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            //lstMsgB.Text = "";
            //if (rdbPanelKC.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            //{
            //    rdbPanelKN.SelectedValue = KHANGCAO.ToString();
            //    pnKhangCao.Visible = true;
            //    hddShowKhangCao.Value = "1";
            //    pnKhangNghi.Visible = false;
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayvietdonKC.ClientID);
            //}
            //else // Kháng nghị
            //{
            //    rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
            //    pnKhangCao.Visible = false; hddShowKhangCao.Value = "0";
            //    pnKhangNghi.Visible = true;
            //    Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
            //}
            if (rdbPanelKC.SelectedValue == "1")
            {
                rdbPanelKN.SelectedValue = "1";
                pnKhangNghi.Visible = false;
                pnKhangCao.Visible = true;
            }
            else
            {
                rdbPanelKN.SelectedValue = "2";
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                txtNgayQDBA.Text = "";
                string loaikc = "";
                LoadQD_BAKhangCao(loaikc);
                Cls_Comon.SetFocus(this, this.GetType(), ddlQDBA.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        private void LoadQD_BAKhangCao(string loaikc)
        {
            ddlQDBA.Items.Clear();
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            if (rdbLoaiKC.SelectedValue == "0" || loaikc == "0")
            {
                LoadDrop_ST_BanAn(ddlQDBA, DonID);
            }
            else if (rdbLoaiKC.SelectedValue == "1" || loaikc == "1")
            {
                LoadDrop_ST_QuyetDinh(ddlQDBA, DonID, 1);
            }
            else if (rdbLoaiKC.SelectedValue == "2" || loaikc == "2")
            {
                LoadDrop_ST_QuyetDinh(ddlQDBA, DonID, 2);
            }
            LoadQD_BA_InfoKhangCao();
        }
        void LoadDrop_ST_BanAn(DropDownList drop, Decimal DonID)
        {
            String temp = "";
            List<AKT_SOTHAM_BANAN> lst = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DonID).OrderByDescending(y => y.NGAYTUYENAN).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AKT_SOTHAM_BANAN item in lst)
                {
                    temp = item.SOBANAN + "-" + ((DateTime)item.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                    drop.Items.Add(new ListItem(temp, item.ID.ToString()));
                }
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadDrop_ST_QuyetDinh(DropDownList drop, Decimal DonID, Decimal loaiKC)
        {
            String temp = "";
            AKT_SOTHAM_BL objBL = new AKT_SOTHAM_BL();
            DataTable tblQD = objBL.AKT_SOTHAM_QUYETDINH_GETLIST(DonID);
            if (tblQD != null && tblQD.Rows.Count > 0)
            {
                foreach (DataRow row in tblQD.Rows)
                {
                    //kiểm tra loại kháng cáo để lấy danh sách quyết định
                    Decimal loaiQĐ = Convert.ToDecimal(row["QUYETDINHID"].ToString());
                    if (loaiKC == 1)
                    {
                        //19-VDS, 20-VDS, 26-VDS, 45-DS, 46-DS, 32-VDS
                        if (loaiQĐ == 422 || loaiQĐ == 423 || loaiQĐ == 429 || loaiQĐ == 62 || loaiQĐ == 63 || loaiQĐ == 435)
                        {
                            temp = row["SOQD"].ToString() + " - " + row["TENQD"].ToString();
                            drop.Items.Add(new ListItem(temp, row["ID"].ToString()));
                        }
                    }
                    else
                    {
                        if (loaiQĐ != 422 && loaiQĐ != 423 && loaiQĐ != 429 && loaiQĐ != 62 && loaiQĐ != 63 && loaiQĐ != 435)
                        {
                            temp = row["SOQD"].ToString() + " - " + row["TENQD"].ToString();
                            drop.Items.Add(new ListItem(temp, row["ID"].ToString()));
                        }
                    }
                }
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            objBL = new AKT_SOTHAM_BL();
        }
        private void LoadQD_BA_InfoKhangCao()
        {
            if (ddlQDBA.SelectedValue == "0") return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlQDBA.SelectedValue);
                AKT_SOTHAM_BANAN oT = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA.Text = ""; }
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlQDBA.SelectedValue);
                AKT_SOTHAM_QUYETDINH oT = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA.Text = ""; }
            }
            decimal DonIDID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == DonIDID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaQDBA.Text = oToaAn.TEN; }
                else { txtToaQDBA.Text = ""; }
            }
            else
            {
                txtToaQDBA.Text = "";
            }
        }
        //protected void rdbMienAnphi_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (rdbMienAnphi.SelectedValue == "1")//Miễn phí
        //    {
        //        txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = false;
        //    }
        //    else
        //    {
        //        txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = true;
        //    }
        //}
        protected void ddlQDBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNgayQDBA.Text = "";
            try { LoadQD_BA_InfoKhangCao(); } catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        //protected void txtNgayKC_TextChanged(object sender, EventArgs e)
        //{
        //    //DateTime ngaykc = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim()))? DateTime.MinValue: Convert.ToDateTime(txtNgaykhangcao.Text.Trim());
        //    //if (rdbHinhThucNhanDon.SelectedIndex != -1)
        //    //{
        //    //    int hinhthuc_nhandon = Convert.ToInt16(rdbHinhThucNhanDon.SelectedValue);
        //    //    if (hinhthuc_nhandon == 0)
        //    //    {
        //    //        //CheckNgayKCQuaHan();
        //    //    }
        //    //    else
        //    //    {
        //    //        //buu dien
        //    //    }
        //    //}
        //    //CheckNgayKCQuaHan();
        //}
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            //lbthongbao.Text = "";
            //if (rdbPanelKN.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            //{
            //    rdbPanelKC.SelectedValue = KHANGCAO.ToString();
            //    pnKhangCao.Visible = true; hddShowKhangCao.Value = "1";
            //    pnKhangNghi.Visible = false;
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayvietdonKC.ClientID);
            //}
            //else // Kháng nghị
            //{
            //    rdbPanelKC.SelectedValue = KHANGNGHI.ToString();
            //    pnKhangCao.Visible = false; hddShowKhangCao.Value = "0";
            //    pnKhangNghi.Visible = true;
            //    Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
            //}
            if (rdbPanelKN.SelectedValue == "1")
            {
                rdbPanelKC.SelectedValue = "1";
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else
            {
                rdbPanelKC.SelectedValue = "2";
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }
        protected void rdbDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            rdbCapkhangnghi.Items.Clear();
            if (rdbDonVi.SelectedValue == "0")//Chánh án
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "1";
            }
            else//Viện kiểm sát
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "0";
            }
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                ddlDonViKN.Items.Clear();
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                }
                trDVKN.Visible = true;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }
        private void LoadDVKN()
        {
            ddlDonViKN.Items.Clear();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (rdbDonVi.SelectedValue == "0")//Tòa án
            {
                DM_TOAAN oTAP1 = dt.DM_TOAAN.Where(x => x.ID == oTA.CAPCHAID).FirstOrDefault();
                ddlDonViKN.Items.Add(new ListItem(oTAP1.TEN, oTAP1.ID.ToString()));
                if (oTAP1.CAPCHAID != 0)
                {
                    DM_TOAAN oTAP2 = dt.DM_TOAAN.Where(x => x.ID == oTAP1.CAPCHAID).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oTAP2.TEN, oTAP2.ID.ToString()));
                    if (oTAP2.CAPCHAID != 0)
                    {
                        DM_TOAAN oTAP3 = dt.DM_TOAAN.Where(x => x.ID == oTAP2.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oTAP3.TEN, oTAP3.ID.ToString()));
                    }
                }
            }
            else//Viện kiểm sát
            {
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    decimal IDVKS1 = (decimal)lstVKS[0].CAPCHAID;
                    DM_VKS oVKS1 = dt.DM_VKS.Where(x => x.ID == IDVKS1).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oVKS1.TEN, oVKS1.ID.ToString()));
                    if (oVKS1.CAPCHAID != 0)
                    {
                        DM_VKS oVKS2 = dt.DM_VKS.Where(x => x.ID == oVKS1.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oVKS2.TEN, oVKS2.ID.ToString()));
                        if (oVKS2.CAPCHAID != 0)
                        {
                            DM_VKS oVKS3 = dt.DM_VKS.Where(x => x.ID == oVKS2.CAPCHAID).FirstOrDefault();
                            ddlDonViKN.Items.Add(new ListItem(oVKS3.TEN, oVKS3.ID.ToString()));
                        }
                    }
                }
            }
        }
        protected void rdbCapkhangnghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                trDVKN.Visible = false;
            }
            else
            {
                trDVKN.Visible = true;
                //LoadDVKN();
            }
        }
        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                txtToaAnQD_KN.Text = "";
                txtToaQDBA.Text = "";
                txtNgayQDBA.Text = "";
                txtNgayQDBA_KN.Text = "";
                LoadQD_BAKhangNghi("");
                Cls_Comon.SetFocus(this, this.GetType(), ddlSOQDBAKhangNghi.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        private void LoadQD_BAKhangNghi(string LoaiKN)
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            if (rdbLoaiKN.SelectedValue == "0" || LoaiKN == "0")
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, DonID);
            else if (rdbLoaiKN.SelectedValue == "1" || LoaiKN == "1")
                LoadDrop_ST_QuyetDinh(ddlSOQDBAKhangNghi, DonID, 1);
            else if (rdbLoaiKN.SelectedValue == "2" || LoaiKN == "2")
                LoadDrop_ST_QuyetDinh(ddlSOQDBAKhangNghi, DonID, 2);
            LoadQD_BA_InfoKhangNghi();
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBAKhangNghi.Items.Count == 0) return;
            if (rdbLoaiKN.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AKT_SOTHAM_BANAN oT = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KN.Text = "";
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AKT_SOTHAM_QUYETDINH oT = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KN.Text = "";
            }
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KN.Text = oToaAn.TEN;
                else txtToaAnQD_KN.Text = "";
            }
            else
                txtToaAnQD_KN.Text = "";
        }
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNgayQDBA_KN.Text = "";
            LoadQD_BA_InfoKhangNghi();
        }
        protected void AsyncFileUpLoadKhangNghi_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangNghi.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangNghi.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangNghi.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KN.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownloadKhangNghi_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddFileID.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddFileID.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
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
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
    }
}