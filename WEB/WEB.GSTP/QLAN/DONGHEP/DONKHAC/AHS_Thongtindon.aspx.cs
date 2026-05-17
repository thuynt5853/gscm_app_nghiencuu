using BL.GSTP;
using BL.GSTP.AHS;
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

namespace WEB.GSTP.QLAN.DONGHEP.DONKHAC
{
    public partial class AHS_Thongtindon : System.Web.UI.Page
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
                pnTTD.Visible = false;
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;
                LoadCombobox();
                ddlLoaidon_SelectedIndexChanged(sender, e);
                rdbLoaiNguoiKC_SelectedIndexChanged(sender, e);
                rdbLoaiKN_SelectedIndexChanged(sender, e);
                rdbLoaiKC_SelectedIndexChanged(sender, e);
                LoadNguoiBiKhangNghi();
                LoadNguoibiKhangCao();
                lbtDownloadKhangCao.Visible = false;
                lbtDownloadKhangNghi.Visible = false;
                ////ddlNguoiKCHS_SelectedIndexChanged(sender, e);
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
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
                        current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                        if (string.IsNullOrEmpty(current_id))
                        {
                            Response.Redirect("/Trangchu.aspx");
                            Response.End();
                        }
                        decimal IdDon = Convert.ToDecimal(current_id);
                        AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == IdDon).FirstOrDefault();
                        Decimal CurrVuAnID = (String.IsNullOrEmpty(current_id + "")) ? 0 : Convert.ToDecimal(current_id);
                        if (CurrVuAnID > 0)
                        {
                            hddID.Value = CurrVuAnID.ToString();
                            LoadThongTinVuAn(Convert.ToDecimal(current_id));
                        }

                    }
                    #endregion
                }

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    cmdUpdateB.Visible = false;
                    cmdUpdateAndNewB.Visible = false;
                }
            }
        }
        #region Thiều
        private void LoadInfo(decimal ID)
        {
            decimal loaidon = 0;
            if (Request.QueryString["LOAIDON"] != "")
            {
                loaidon = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
            }
            DON_KHAC oD = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 1).FirstOrDefault();
            AHS_VUAN oT = dt.AHS_VUAN.FirstOrDefault(s => s.ID == oD.DONID);


            if (oT != null)
            {
                hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                txtMaVuAn.Text = oT.MAVUAN;
                txtTenVuAn.Text = oT.TENVUAN;
                txtTenVuAnKhac.Text = oT.TENKHAC;
                //----------------------------------
                //if (oT.TRUONGHOPGIAONHAN == 270)
                //{
                //    try
                //    {
                //        List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHAN).ToList();
                //        dropTrangThaiGiaoNhan.Items.Clear();
                //        dropTrangThaiGiaoNhan.DataSource = lstTHGN;
                //        dropTrangThaiGiaoNhan.DataTextField = "TEN";
                //        dropTrangThaiGiaoNhan.DataValueField = "ID";
                //        dropTrangThaiGiaoNhan.DataBind();
                //    }
                //    catch (Exception ex)
                //    {
                //        dropTrangThaiGiaoNhan.Items.Add(new ListItem("Xét xử lại cấp sơ thẩm", "270"));
                //    }
                //}
                //else
                //{
                //    dropTrangThaiGiaoNhan.Items.Add(new ListItem("VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSGiaoHSXuSoTham));
                //}
                //dropTrangThaiGiaoNhan.SelectedValue = oT.TRUONGHOPGIAONHAN + "";
                //txtSoBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                ////txtNgayBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                //if (oT.NGAYBANCAOTRANG != DateTime.MinValue && oT.NGAYBANCAOTRANG != null) txtNgayBanCaoTrang.Text = ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);
                ////txtNgayBanCaoTrang.Text = ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);
                //txtSoButLuc.Text = oT.SOBUTLUC + "";
                //if (oT.NGAYGIAO != DateTime.MinValue && oT.NGAYGIAO != null) txtNgayGiao.Text = ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                ////txtNgayGiao.Text = ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                //dropQuyetDinhTruyTo.SelectedValue = oT.QUYETDINHTRUYTO + "";
                //----------------------------------            
                dropLoaiToiPham.SelectedValue = oT.LOAITOIPHAMID + "";
                txtSoBiCanTamGiam.Text = oT.SOBICANTAMGIAM + "";
                txtSoBiCan.Text = oT.SOBICAN + "";
                //txtNgayXayra.Text = ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
                if (oT.NGAYXAYRA != null) txtNgayXayra.Text = (((DateTime)oT.NGAYXAYRA) == DateTime.MinValue) ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
                if (string.IsNullOrEmpty(oT.GIOXAYRA + ""))
                    dropGio.SelectedValue = "00";
                else
                {
                    int gio = (int)oT.GIOXAYRA;
                    if (gio < 10)
                        dropGio.SelectedValue = "0" + oT.GIOXAYRA.ToString();
                    else dropGio.SelectedValue = oT.GIOXAYRA.ToString();
                }
            }
            ddlLoaidon.SelectedValue = oD.LOAIDON.ToString();
            if (oD.LOAIDON == 7)
            {
                if (oD.LOAIKCKN == 1)
                {
                    rdbPanelKC.SelectedValue = "1";
                    rdbPanelKN.SelectedValue = "1";
                    pnKhangCao.Visible = true;
                    pnKhangNghi.Visible = false;
                    rdbLoaiNguoiKC.SelectedValue = oD.NGUOIKCKNLOAI.ToString();
                    rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    ddlNguoikhangcao.SelectedValue = oD.DUONGSUID.ToString();
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangcao.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    rdbQuahan_KC.SelectedValue = oD.ISQUAHAN.ToString();
                    LoadQD_BAKhangCao();
                    if (!String.IsNullOrEmpty(oD.SOQDBA)) ddlSOQDBA_KC.SelectedValue = oD.SOQDBA.ToString();
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (toaan != null) txtToaAnQD_KC.Text = toaan.TEN;
                    txtNoidungKC.Text = oD.NOIDUNGDON;

                    int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
                    switch (loai)
                    {
                        case 0:
                            Load_ListBiCan();
                            lbNguoiBiKC.Visible = false;
                            plNguoiBiKC.Visible = false;
                            break;
                        case 1:
                            Load_ListNguoiThamGiaToTung();
                            lbNguoiBiKC.Visible = true;
                            plNguoiBiKC.Visible = true;
                            break;
                    }

                    LoadNguoibiKhangCao();
                    try
                    {
                        string[] dsNguoiBiKC = oD.NGUOIBIKCKN.Split(',');

                        dsNguoiBiKC = dsNguoiBiKC.Take(dsNguoiBiKC.Length - 1).ToArray();

                        foreach (string item in dsNguoiBiKC)
                        {
                            lbNguoiBiKC.Items.FindByValue(item).Selected = true;
                        }

                        //lbNguoiBiKC.SelectedValue = oND.NGUOIBIKC.ToString();
                    }
                    catch { }

                    List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == ID).ToList<DON_KHAC_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (ListItem item in chkYeuCauKC.Items)
                        {
                            item.Selected = false;
                            foreach (DON_KHAC_YEUCAU obj in lst)
                            {
                                if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                    item.Selected = true;
                            }
                        }
                    }

                    DON_KHAC_FILE donkhacfile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                    if (donkhacfile != null)
                        lbtDownloadKhangCao.Visible = true;
                    else
                        lbtDownloadKhangCao.Visible = false;
                }
                if (oD.LOAIKCKN == 2)
                {
                    rdbPanelKN.SelectedValue = "2";
                    rdbPanelKC.SelectedValue = "2";
                    pnKhangCao.Visible = false;
                    pnKhangNghi.Visible = true;
                    rdbDonVi.SelectedValue = oD.NGUOIKCKN.ToString();
                    rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    rdbCapkhangnghi.SelectedValue = oD.CAPKHANGNGHI.ToString();
                    LoadQD_BAKhangNghi();
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangnghi.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    if (oD.SOQDBA.ToString() != null) ddlSOQDBAKhangNghi.SelectedValue = oD.SOQDBA.ToString();
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    DM_TOAAN toaan = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (toaan != null) txtToaAnQD_KN.Text = toaan.TEN;
                    txtNoidungKN.Text = oD.NOIDUNGDON;
                    txtSokhangnghi.Text = oD.SOKHANGNGHI;
                    LoadNguoiBiKhangNghi();
                    try
                    {
                        string[] dsNguoiBiKC = oD.NGUOIBIKCKN.Split(',');

                        dsNguoiBiKC = dsNguoiBiKC.Take(dsNguoiBiKC.Length - 1).ToArray();
                        foreach (string item in dsNguoiBiKC)
                        {
                            lbNguoiBiKN.Items.FindByValue(item).Selected = true;
                        }

                        //lbNguoiBiKC.SelectedValue = oND.NGUOIBIKC.ToString();
                    }
                    catch { }

                    List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == ID).ToList<DON_KHAC_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (ListItem item in chkYeuCauKN.Items)
                        {
                            item.Selected = false;
                            foreach (DON_KHAC_YEUCAU obj in lst)
                            {
                                if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                    item.Selected = true;
                            }
                        }
                    }

                    DON_KHAC_FILE donkhacfile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                    if (donkhacfile != null)
                        lbtDownloadKhangNghi.Visible = true;
                    else
                        lbtDownloadKhangNghi.Visible = false;
                }
            }
            //txtGhichu.Text = oD.GHICHU;
            //Load đơn khác
            if (oD.LOAIDON == 8)
            {
                if (oD.ISDUONGSU == 0)
                {
                    pnCaNhanDK.Visible = false;
                    AHS_NGUOITHAMGIATOTUNG oTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == oD.DUONGSUID).FirstOrDefault();
                    ddlNguoidungdon.SelectedValue = oTT.ID + ",0";
                    txtHoTen_DK.Text = oTT.HOTEN;
                    if (oTT.NDD_CMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oTT.NDD_CMND;
                    }
                    ddlTuCachToTung_DK.Visible = true;
                    lbTCTT.Visible = true;
                    AHS_NGUOITHAMGIATOTUNG_TUCACH oTT_TUCACH = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oD.DUONGSUID).FirstOrDefault();
                    if (oTT_TUCACH != null)
                    {
                        ddlTuCachToTung_DK.SelectedValue = oTT_TUCACH.TUCACHID.ToString();
                    }
                    ddlTamtru_Tinh_DK.SelectedValue = "0";
                    ddlTamtru_Huyen_DK.SelectedValue = "0";
                    txtDiaChiCT_DK.Text = oTT.DIACHICHITIET;
                    txtNamsinh_DK.Text = oTT.NAMSINH == 0 ? "" : oTT.NAMSINH.ToString();
                    ddlGioiTinh_DK.SelectedValue = oTT.GIOITINH.ToString();
                    txtEmail_DK.Text = oTT.NDD_EMAIL;
                    txtTel_DK.Text = oTT.NDD_MOBILE;
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
                    pnCaNhanDK.Visible = false;
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
                    if (oTT.NDD_EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oTT.NDD_MOBILE != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oTT.DIACHICHITIET != null)
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
                    pnTGTT.Visible = false;
                    AHS_BICANBICAO oDonDS = dt.AHS_BICANBICAO.Where(x => x.ID == oD.DUONGSUID).FirstOrDefault();
                    ddlNguoidungdon.SelectedValue = oDonDS.ID + ",1";
                    txtHoTen_DK.Text = oDonDS.HOTEN;
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
                    ddlTuCachToTung_DK.Visible = false;
                    lbTCTT.Visible = false;
                    //ddlTuCachToTung_DK.SelectedValue = oDonDS.TUCACHTOTUNG_MA;
                    if (oDonDS.TAMTRU != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oDonDS.TAMTRU.ToString();
                        LoadDrop_Huyen_DK();
                        if (oDonDS.TAMTRU_HUYEN != null)
                        {
                            ddlTamtru_Huyen_DK.SelectedValue = oDonDS.TAMTRU_HUYEN.ToString();
                        }
                    }
                    txtDiaChiCT_DK.Text = oDonDS.TAMTRUCHITIET;
                    txtNamsinh_DK.Text = oDonDS.NAMSINH == 0 ? "" : oDonDS.NAMSINH.ToString();
                    ddlGioiTinh_DK.SelectedValue = oDonDS.GIOITINH.ToString();
                    //txtEmail_DK.Text = oDonDS.EMAIL;
                    //txtTel_DK.Text = oDonDS.DIENTHOAI;
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
                    pnTGTT.Visible = false;
                    if (oDonDS.HOTEN != null)
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
                    if (oDonDS.TAMTRU != null && oDonDS.TAMTRU != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oDonDS.TAMTRU_HUYEN != null && oDonDS.TAMTRU_HUYEN != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
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
                //DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                //lbtDownloadKhangCao.Visible = false;
                //if (oFile != null)
                //{
                //    lbtDownloadKhangCao.Visible = true;
                //}
                //else
                //{
                //    lbtDownloadKhangCao.Visible = false;
                //}
                //List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == ID).ToList<DON_KHAC_YEUCAU>();
                //if (lst != null && lst.Count > 0)
                //{
                //    foreach (ListItem item in chkYeuCauKC.Items)
                //    {
                //        item.Selected = false;
                //        foreach (DON_KHAC_YEUCAU obj in lst)
                //        {
                //            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                //                item.Selected = true;
                //        }
                //    }
                //}
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;
                pnTTD.Visible = false;
            }
            else if (loaidon == 8)
            {
                lbNoidung.Visible = false;
                txtNoidungkhoikien.Visible = false;
                pnKhangCao.Visible = false;
                pnTTD.Visible = true;
            }
        }

        private void LoadThongTinVuAn(decimal VuAnID)
        {
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                txtMaVuAn.Text = oT.MAVUAN;
                txtTenVuAn.Text = oT.TENVUAN;
                txtTenVuAnKhac.Text = oT.TENKHAC;
                //----------------------------------
                //if (oT.TRUONGHOPGIAONHAN == 270)
                //{
                //    try
                //    {
                //        List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHAN).ToList();
                //        dropTrangThaiGiaoNhan.Items.Clear();
                //        dropTrangThaiGiaoNhan.DataSource = lstTHGN;
                //        dropTrangThaiGiaoNhan.DataTextField = "TEN";
                //        dropTrangThaiGiaoNhan.DataValueField = "ID";
                //        dropTrangThaiGiaoNhan.DataBind();
                //    }
                //    catch (Exception ex)
                //    {
                //        dropTrangThaiGiaoNhan.Items.Add(new ListItem("Xét xử lại cấp sơ thẩm", "270"));
                //    }
                //}
                //else
                //{
                //    dropTrangThaiGiaoNhan.Items.Add(new ListItem("VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSGiaoHSXuSoTham));
                //}
                //dropTrangThaiGiaoNhan.SelectedValue = oT.TRUONGHOPGIAONHAN + "";
                //txtSoBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                ////txtNgayBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                //if (oT.NGAYBANCAOTRANG != DateTime.MinValue && oT.NGAYBANCAOTRANG != null) txtNgayBanCaoTrang.Text = ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);
                ////txtNgayBanCaoTrang.Text = ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);
                //txtSoButLuc.Text = oT.SOBUTLUC + "";
                //if (oT.NGAYGIAO != DateTime.MinValue && oT.NGAYGIAO != null) txtNgayGiao.Text = ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                ////txtNgayGiao.Text = ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                //dropQuyetDinhTruyTo.SelectedValue = oT.QUYETDINHTRUYTO + "";
                //----------------------------------            
                dropLoaiToiPham.SelectedValue = oT.LOAITOIPHAMID + "";
                txtSoBiCanTamGiam.Text = oT.SOBICANTAMGIAM + "";
                txtSoBiCan.Text = oT.SOBICAN + "";
                //txtNgayXayra.Text = ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);

                if (oT.NGAYXAYRA != DateTime.MinValue && oT.NGAYXAYRA != null) txtNgayXayra.Text = ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
                if (string.IsNullOrEmpty(oT.GIOXAYRA + ""))
                    dropGio.SelectedValue = "00";
                else
                {
                    int gio = (int)oT.GIOXAYRA;
                    if (gio < 10)
                        dropGio.SelectedValue = "0" + oT.GIOXAYRA.ToString();
                    else dropGio.SelectedValue = oT.GIOXAYRA.ToString();
                }
                //-------------------
                AHS_BICANBICAO_BL objBC = new AHS_BICANBICAO_BL();
                DataTable tbl = objBC.CountBiCaoTheoTinhTrangGiamGiu(VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    txtSoBiCan.Text = tbl.Rows[0]["CountAll"] + "";
                    Decimal Count = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        if ((row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.TAMGIAM) || (row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.DANGTAMGIAM_VUANKHAC))
                        {
                            Count += Convert.ToDecimal(row["SoBiCao"] + "");
                        }
                    }
                    txtSoBiCanTamGiam.Text = Count.ToString();
                }
                //------------------------------------
            }
        }
        #endregion

        private void LoadNguoibiKhangCao()
        {
            lbNguoiBiKC.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.GDTAOHS == null).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            if (listBiCan != null)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    lbNguoiBiKC.DataSource = listBiCan;
                    lbNguoiBiKC.DataTextField = "HOTEN";
                    lbNguoiBiKC.DataValueField = "ID";
                    lbNguoiBiKC.DataBind();
                }
            }
            else
                lbNguoiBiKC.Items.Add(new ListItem("--- Chọn ---", "0"));
            //lbNguoiBiKC.Items[0].Selected = true;
        }

        private void LoadNguoiBiKhangNghi()
        {
            lbNguoiBiKN.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.GDTAOHS == null).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            if (listBiCan != null)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    //ddlNguoiBiKN.DataSource = listBiCan;
                    //ddlNguoiBiKN.DataTextField = "HOTEN";
                    //ddlNguoiBiKN.DataValueField = "ID";
                    //ddlNguoiBiKN.DataBind();
                    lbNguoiBiKN.DataSource = listBiCan;
                    lbNguoiBiKN.DataTextField = "HOTEN";
                    lbNguoiBiKN.DataValueField = "ID";
                    lbNguoiBiKN.DataBind();
                }
            }
            else
                lbNguoiBiKN.Items.Add(new ListItem("--- Chọn ---", "0"));
            //lbNguoiBiKN.Items[0].Selected = true;
        }

        private bool CheckValid()
        {
            //if (dropTrangThaiGiaoNhan.SelectedValue == "0")
            //{
            //    lstMsgB.Text = "Bạn chưa chọn trường hợp giao nhận.";
            //    Cls_Comon.SetFocus(this, this.GetType(), dropTrangThaiGiaoNhan.ClientID);
            //    return false;
            //}
            //if (txtSoBanCaoTrang.Text == "")
            //{
            //    lstMsgB.Text = "Bạn chưa nhập số bản cáo trạng.";
            //    Cls_Comon.SetFocus(this, this.GetType(), txtSoBanCaoTrang.ClientID);
            //    return false;
            //}
            //if (txtSoButLuc.Text == "")
            //{
            //    lstMsgB.Text = "Bạn chưa nhập số bút lục.";
            //    Cls_Comon.SetFocus(this, this.GetType(), txtSoButLuc.ClientID);
            //    return false;
            //}
            //if (txtNgayBanCaoTrang.Text == "")
            //{
            //    lstMsgB.Text = "Bạn chưa nhập ngày bản cáo trạng.";
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayBanCaoTrang.ClientID);
            //    return false;
            //}
            //if (txtNgayGiao.Text == "")
            //{
            //    lstMsgB.Text = "Bạn chưa nhập ngày giao bản cáo trạng.";
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayGiao.ClientID);
            //    return false;
            //}
            if (txtTenVuAn.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập tên vụ án.";
                Cls_Comon.SetFocus(this, this.GetType(), txtTenVuAn.ClientID);
                return false;
            }
            if (dropLoaiToiPham.SelectedValue == "0")
            {
                lstMsgB.Text = "Bạn chưa nhập chọn mức độ nghiêm trọng.";
                Cls_Comon.SetFocus(this, this.GetType(), dropLoaiToiPham.ClientID);
                return false;
            }
            if (ddlLoaidon.SelectedValue == "7")
            {
                if (rdbPanelKC.SelectedValue == "1")
                {
                    if (ddlNguoikhangcao.SelectedValue == "0")
                    {
                        lstMsgB.Text = "Bạn chưa chọn tên người kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlNguoikhangcao.ClientID);
                        return false;
                    }
                    if (rdbLoaiNguoiKC.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbLoaiNguoiKC.ClientID);
                        return false;
                    }
                    if (rdbLoaiKC.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn loại kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbLoaiKC.ClientID);
                        return false;
                    }
                    if (txtNgaykhangcao.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập ngày kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaykhangcao.ClientID);
                        return false;
                    }
                    if (rdbQuahan_KC.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn kháng cáo quá hạn.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbQuahan_KC.ClientID);
                        return false;
                    }
                    if (chkYeuCauKC.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng cáo.";
                        Cls_Comon.SetFocus(this, this.GetType(), chkYeuCauKC.ClientID);
                        return false;
                    }
                    if (rdbLoaiNguoiKC.SelectedValue == "1")
                    {
                        if (lbNguoiBiKC.SelectedValue == "")
                        {
                            lstMsgB.Text = "Bạn chưa chọn người bị kháng cáo.";
                            Cls_Comon.SetFocus(this, this.GetType(), lbNguoiBiKN.ClientID);
                            return false;
                        }
                    }


                    bool isSelected = false;
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        if (item.Selected)
                        {
                            isSelected = true;
                            break;
                        }
                    }
                    if (!isSelected)
                    {
                        lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng cáo!";
                        return false;
                    }
                }
                if (rdbPanelKN.SelectedValue == "2")
                {

                    if (txtSokhangnghi.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập số kháng nghị kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtSokhangnghi.ClientID);
                        return false;
                    }
                    if (rdbLoaiKN.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn loại kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbLoaiKN.ClientID);
                        return false;
                    }
                    if (rdbDonVi.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbDonVi.ClientID);
                        return false;
                    }
                    if (rdbCapkhangnghi.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn cấp kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), rdbCapkhangnghi.ClientID);
                        return false;
                    }

                    if (txtNgaykhangnghi.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập ngày kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaykhangnghi.ClientID);
                        return false;
                    }
                    if (lbNguoiBiKN.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người bị kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), lbNguoiBiKN.ClientID);
                        return false;
                    }
                    if (chkYeuCauKN.SelectedValue == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng nghị.";
                        Cls_Comon.SetFocus(this, this.GetType(), chkYeuCauKN.ClientID);
                        return false;
                    }


                    bool isSelected = false;
                    foreach (ListItem item in chkYeuCauKN.Items)
                    {
                        if (item.Selected)
                        {
                            isSelected = true;
                            break;
                        }
                    }
                    if (!isSelected)
                    {
                        lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng nghị!";
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

        private void ResetControls()
        {
            txtMaVuAn.Text = "";
            //txtNgayBanCaoTrang.Text = txtNgayGiao.Text = txtNgayXayra.Text = "";
            //txtSoButLuc.Text = txtTenVuAn.Text = txtTenVuAnKhac.Text = "";
            hddID.Value = "0";

            ddlNguoikhangcao.SelectedIndex = 0;

            //txtNgayVDKCHS.Text = "";
            txtNgaykhangcao.Text = "";
            txtNgayQDBA_KC.Text = "";
            rdbLoaiKC.SelectedIndex = 0;
            rdbQuahan_KC.SelectedIndex = 0;
            ddlSOQDBA_KC.SelectedIndex = 0;
            chkYeuCauKC.Items.Clear();
            lbtDownloadKhangCao.Enabled = false;
            hddFilePath_KC.Value = "";
            //ddlToaQDBAHS.SelectedValue = "0";
            txtToaAnQD_KC.Text = "";
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


            rdbDonVi.SelectedIndex = 0;
            rdbCapkhangnghi.SelectedIndex = 0;
            rdbLoaiKN.SelectedIndex = 0;
            txtSokhangnghi.Text = "";
            txtNgaykhangnghi.Text = "";
            ddlSOQDBAKhangNghi.SelectedIndex = 0;
            txtNgayQDBA_KN.Text = "";
            txtToaAnQD_KN.Text = "";
            txtNoidungKN.Text = "";
            lbtDownloadKhangNghi.Enabled = false;
            hddFilePath_KN.Value = "";

            LoadNguoiBiKhangNghi();
            LoadNguoibiKhangCao();
            LoadQD_BAKhangCao();
            LoadQD_BAKhangNghi();

            chkYeuCauKN.Items.Clear();
            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkYeuCauKC.DataSource = tbl;
                chkYeuCauKC.DataTextField = "TEN";
                chkYeuCauKC.DataValueField = "ID";
                chkYeuCauKC.DataBind();
            }
            DataTable tbl1 = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKNHINHSU);
            if (tbl1 != null && tbl1.Rows.Count > 0)
            {
                chkYeuCauKN.DataSource = tbl1;
                chkYeuCauKN.DataTextField = "TEN";
                chkYeuCauKN.DataValueField = "ID";
                chkYeuCauKN.DataBind();
            }

            if (chkYeuCauKC.Items.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKC.Items)
                {
                    item.Selected = false;
                }
            }
            if (chkYeuCauKN.Items.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKN.Items)
                {
                    item.Selected = false;
                }
            }
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }

        private void LoadCombobox()
        {
            //Load cán bộ
            //Load đương sự

            dropGio.Items.Clear();
            for (int i = 0; i < 24; i++)
            {
                if (i < 10)
                    dropGio.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
                else
                    dropGio.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            LoadDropByGroupName(dropLoaiToiPham, ENUM_DANHMUC.LOAITOIPHAM, false);
            //LoadDropByGroupName(dropQuyetDinhTruyTo, ENUM_DANHMUC.QUYETDINHCAOTRANG, false);
            ////--------------------------
            //dropTrangThaiGiaoNhan.Items.Clear();
            //dropTrangThaiGiaoNhan.Items.Add(new ListItem("VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSGiaoHSXuSoTham));

            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            AHS_BICANBICAO_BL oBL_DS_TGTT = new AHS_BICANBICAO_BL();
            ddlNguoidungdon.DataSource = oBL_DS_TGTT.AHS_DON_BICANBICAO_THAMGIATOTUNG(Convert.ToDecimal(donid));
            ddlNguoidungdon.DataTextField = "TENDUONGSU";
            ddlNguoidungdon.DataValueField = "ID";
            ddlNguoidungdon.DataBind();
            ddlNguoidungdon.Items.Insert(0, new ListItem("Đương sự mới", "0,0"));

            List<DM_DATAITEM> oTCTT = dt.DM_DATAITEM.Where(x => x.GROUPID == 25).ToList();
            ddlTuCachToTung_DK.DataSource = oTCTT;
            ddlTuCachToTung_DK.DataTextField = "TEN";
            ddlTuCachToTung_DK.DataValueField = "ID";
            ddlTuCachToTung_DK.DataBind();

            //Set mặc định cán bộ loginf

            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();

            //Load QHPL Thống kê.


            //List<DM_TOAAN> oTOAAN = dt.DM_TOAAN.OrderBy(x => x.ARRTHUTU).ToList();
            //ddlToaQDBAHS.DataSource = oTOAAN;
            //ddlToaQDBAHS.DataTextField = "TEN";
            //ddlToaQDBAHS.DataValueField = "ID";
            //ddlToaQDBAHS.DataBind();
            //ddlToaQDBAHS.Items.Insert(0, new ListItem("--Chọn--", "0"));

            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkYeuCauKC.DataSource = tbl;
                chkYeuCauKC.DataTextField = "TEN";
                chkYeuCauKC.DataValueField = "ID";
                chkYeuCauKC.DataBind();
            }
            DataTable tbl1 = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKNHINHSU);
            if (tbl1 != null && tbl1.Rows.Count > 0)
            {
                chkYeuCauKN.DataSource = tbl1;
                chkYeuCauKN.DataTextField = "TEN";
                chkYeuCauKN.DataValueField = "ID";
                chkYeuCauKN.DataBind();
            }

            LoadDropTinh();
        }

        #region Thiều
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                decimal donGhepID = 0;

                if (Request.QueryString["LOAIDON"] != "")
                {
                    donGhepID = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
                }
                decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                decimal ID = Convert.ToDecimal(hddID.Value);
                AHS_VUAN oT;
                DateTime date_temp;
                //Thông tin vụ án
                oT = dt.AHS_VUAN.Where(x => x.ID == DonID).FirstOrDefault();
                DateTime dNgaybancaotrang;
                DateTime dNgaygiao;
                oT.TENVUAN = txtTenVuAn.Text.Trim();
                oT.TENKHAC = txtTenVuAnKhac.Text.Trim();

                date_temp = (String.IsNullOrEmpty(txtNgayXayra.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayXayra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                {
                    oT.NGAYXAYRA = date_temp;
                    oT.THANGXAYRA = Convert.ToDecimal(date_temp.Month);
                    oT.NAMXAYRA = Convert.ToDecimal(date_temp.Year);
                    oT.GIOXAYRA = Convert.ToInt16(dropGio.SelectedValue);
                }
                var loaiDon = ddlLoaidon.SelectedValue;
                if (loaiDon == "7")
                {
                    if (rdbPanelKC.SelectedValue == "1")
                    {
                        DON_KHAC oKC = null;
                        if (donGhepID == 0 || hddID.Value == "" || hddID.Value == "0")
                        {
                            oKC = new DON_KHAC();
                        }
                        else
                        {
                            decimal DONID = 0;
                            if (donGhepID != 0)
                            {
                                DONID = donGhepID;
                            }
                            else
                            {
                                DONID = Convert.ToDecimal(hddID.Value);
                            }
                            oKC = dt.DON_KHAC.Where(x => x.ID == DONID && x.LOAIANID == 1).FirstOrDefault();
                        }
                        oKC.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                        oKC.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                        oKC.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                        oKC.NGUOIKCKNLOAI = Convert.ToDecimal(rdbLoaiNguoiKC.SelectedValue);
                        oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        if (rdbLoaiNguoiKC.SelectedValue == "0")
                        {
                            oKC.ISDUONGSU = 1;
                        }
                        else if (rdbLoaiNguoiKC.SelectedValue == "1")
                        {
                            oKC.ISDUONGSU = 0;
                        }
                        //oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                        oKC.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                        oKC.LOAIKCKN = Convert.ToDecimal(rdbPanelKC.SelectedValue);
                        string listNguoiBiKC = "";
                        if (lbNguoiBiKC.Items.Count > 0)
                        {
                            for (int i = 0; i < lbNguoiBiKC.Items.Count; i++)
                            {
                                if (lbNguoiBiKC.Items[i].Selected)
                                {
                                    listNguoiBiKC = listNguoiBiKC + lbNguoiBiKC.Items[i].Value + ",";
                                }
                            }
                        }
                        oKC.NGUOIBIKCKN = listNguoiBiKC;
                        oKC.SOQDBA = ddlSOQDBA_KC.SelectedValue.ToString();
                        oKC.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                        oKC.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        DM_TOAAN ToaAn = dt.DM_TOAAN.Where(x => x.TEN == txtToaAnQD_KC.Text).FirstOrDefault();
                        if (ToaAn != null)
                        {
                            oKC.TOAANRAQDID = ToaAn.ID;
                        }
                        oKC.NOIDUNGDON = txtNoidungKC.Text;

                        if (donGhepID == 0 || hddID.Value == "" || hddID.Value == "0")
                        {
                            oKC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.DON_KHAC.Add(oKC);
                        }
                        dt.SaveChanges();

                        hddID.Value = oKC.DONID.ToString();

                        DON_KHAC_YEUCAU obj = null;
                        // lấy ra tất cả các yêu cầu cũ
                        string StrKhangCaoYC = "|";
                        if (oKC.ID > 0)
                        {
                            List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == oKC.ID).ToList<DON_KHAC_YEUCAU>();
                            if (lst != null && lst.Count > 0)
                            {
                                foreach (DON_KHAC_YEUCAU item in lst)
                                    StrKhangCaoYC += item.YEUCAUID + "|";
                            }
                        }
                        // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
                        Boolean IsNew = false;
                        decimal yeuCauID = 0;
                        foreach (ListItem item in chkYeuCauKC.Items)
                        {
                            IsNew = false;
                            if (item.Selected)
                            {
                                if (StrKhangCaoYC == "|")
                                    IsNew = true;
                                else
                                {
                                    if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                                    {
                                        yeuCauID = Convert.ToDecimal(item.Value);
                                        obj = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == oKC.ID && x.YEUCAUID == yeuCauID).FirstOrDefault<DON_KHAC_YEUCAU>();
                                        if (obj != null)
                                        {
                                            obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                            obj.NGAYSUA = DateTime.Now;
                                            dt.SaveChanges();
                                        }
                                        StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                                        IsNew = false;
                                    }
                                    else
                                        IsNew = true;
                                }
                                if (IsNew)
                                {
                                    obj = new DON_KHAC_YEUCAU();
                                    obj.DONKHACID = Convert.ToInt32(oKC.ID);
                                    obj.YEUCAUID = Convert.ToInt32(item.Value);
                                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    obj.NGAYTAO = DateTime.Now;
                                    dt.DON_KHAC_YEUCAU.Add(obj);
                                    dt.SaveChanges();
                                }
                            }
                        }
                        // yêu cầu còn lại cần phải xóa
                        if (StrKhangCaoYC != "|")
                        {
                            String[] arr = StrKhangCaoYC.Split('|');
                            foreach (String item in arr)
                            {
                                if (item.Length > 0)
                                {
                                    yeuCauID = Convert.ToDecimal(item);
                                    obj = dt.DON_KHAC_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                                    if (obj != null)
                                    {
                                        dt.DON_KHAC_YEUCAU.Remove(obj);
                                        dt.SaveChanges();
                                    }
                                }
                            }
                        }
                        DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                        DON_KHAC_FILE oKCFileCheck = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oKC.ID).FirstOrDefault();
                        if (oKCFileCheck != null)
                        {
                            oKCFile = oKCFileCheck;
                        }

                        if (hddFilePath_KC.Value != "" && hddFilePath_KC.Value != "0")
                        {
                            string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
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


                    }
                    else if (rdbPanelKN.SelectedValue == "2")
                    {
                        DON_KHAC oKC = null;
                        if (donGhepID == 0 || hddID.Value == "" || hddID.Value == "0")
                        {
                            oKC = new DON_KHAC();
                        }
                        else
                        {
                            decimal DONID = 0;
                            if (donGhepID != 0)
                            {
                                DONID = donGhepID;
                            }
                            else
                            {
                                DONID = Convert.ToDecimal(hddID.Value);
                            }
                            oKC = dt.DON_KHAC.Where(x => x.ID == DONID && x.LOAIANID == 1).FirstOrDefault();
                        }
                        oKC.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                        oKC.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                        oKC.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                        oKC.NGUOIKCKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                        oKC.CAPKHANGNGHI = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                        oKC.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        //oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oKC.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                        oKC.LOAIKCKN = Convert.ToDecimal(rdbPanelKN.SelectedValue);
                        oKC.SOKHANGNGHI = txtSokhangnghi.Text;
                        string listNguoiBiKN = "";
                        if (lbNguoiBiKN.Items.Count > 0)
                        {
                            for (int i = 0; i < lbNguoiBiKN.Items.Count; i++)
                            {
                                if (lbNguoiBiKN.Items[i].Selected)
                                {
                                    listNguoiBiKN = listNguoiBiKN + lbNguoiBiKN.Items[i].Value + ",";
                                }
                            }
                        }
                        oKC.NGUOIBIKCKN = listNguoiBiKN;
                        oKC.SOQDBA = ddlSOQDBAKhangNghi.SelectedValue.ToString();
                        oKC.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        DM_TOAAN ToaAn = dt.DM_TOAAN.Where(x => x.TEN == txtToaAnQD_KN.Text).FirstOrDefault();
                        if (ToaAn != null)
                        {
                            oKC.TOAANRAQDID = ToaAn.ID;
                        }
                        oKC.NOIDUNGDON = txtNoidungKN.Text;

                        if (donGhepID == 0 || hddID.Value == "" || hddID.Value == "0")
                        {
                            oKC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_KHAC.Add(oKC);
                        }
                        dt.SaveChanges();

                        hddID.Value = oKC.DONID.ToString();

                        DON_KHAC_YEUCAU obj = null;
                        // lấy ra tất cả các yêu cầu cũ
                        string StrKhangCaoYC = "|";
                        if (oKC.ID > 0)
                        {
                            List<DON_KHAC_YEUCAU> lst = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == oKC.ID).ToList<DON_KHAC_YEUCAU>();
                            if (lst != null && lst.Count > 0)
                            {
                                foreach (DON_KHAC_YEUCAU item in lst)
                                    StrKhangCaoYC += item.YEUCAUID + "|";
                            }
                        }
                        // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
                        Boolean IsNew = false;
                        decimal yeuCauID = 0;
                        foreach (ListItem item in chkYeuCauKN.Items)
                        {
                            IsNew = false;
                            if (item.Selected)
                            {
                                if (StrKhangCaoYC == "|")
                                    IsNew = true;
                                else
                                {
                                    if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                                    {
                                        yeuCauID = Convert.ToDecimal(item.Value);
                                        obj = dt.DON_KHAC_YEUCAU.Where(x => x.DONKHACID == oKC.ID && x.YEUCAUID == yeuCauID).FirstOrDefault<DON_KHAC_YEUCAU>();
                                        if (obj != null)
                                        {
                                            obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                            obj.NGAYSUA = DateTime.Now;
                                            dt.SaveChanges();
                                        }
                                        StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                                        IsNew = false;
                                    }
                                    else
                                        IsNew = true;
                                }
                                if (IsNew)
                                {
                                    obj = new DON_KHAC_YEUCAU();
                                    obj.DONKHACID = Convert.ToInt32(oKC.ID);
                                    obj.YEUCAUID = Convert.ToInt32(item.Value);
                                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    obj.NGAYTAO = DateTime.Now;
                                    dt.DON_KHAC_YEUCAU.Add(obj);
                                    dt.SaveChanges();
                                }
                            }
                        }
                        // yêu cầu còn lại cần phải xóa
                        if (StrKhangCaoYC != "|")
                        {
                            String[] arr = StrKhangCaoYC.Split('|');
                            foreach (String item in arr)
                            {
                                if (item.Length > 0)
                                {
                                    yeuCauID = Convert.ToDecimal(item);
                                    obj = dt.DON_KHAC_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                                    if (obj != null)
                                    {
                                        dt.DON_KHAC_YEUCAU.Remove(obj);
                                        dt.SaveChanges();
                                    }
                                }
                            }
                        }
                        DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                        DON_KHAC_FILE oKCFileCheck = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oKC.ID).FirstOrDefault();
                        if (oKCFileCheck != null)
                        {
                            oKCFile = oKCFileCheck;
                        }

                        if (hddFilePath_KN.Value != "" && hddFilePath_KN.Value != "0")
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
                    }
                }
                else if (loaiDon == "8")
                {
                    decimal idDuongSuDK = 0;
                    decimal isDuongSuDK = 0;
                    if (ddlNguoidungdon.SelectedValue != "0")
                    {
                        string[] commandArgsAccept = ddlNguoidungdon.SelectedValue.ToString().Split(new char[] { ',' });
                        idDuongSuDK = Convert.ToDecimal(commandArgsAccept[0]);
                        isDuongSuDK = Convert.ToDecimal(commandArgsAccept[1]);
                    }
                    DON_KHAC oDK = null;
                    if (donGhepID == 0)
                    {
                        oDK = new DON_KHAC();
                    }
                    else
                    {
                        oDK = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 1).FirstOrDefault();
                    }
                    oDK.DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    oDK.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                    oDK.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                    oDK.NOIDUNGDON = txtND_DK.Text;
                    decimal IDTCTT = Convert.ToDecimal(ddlTuCachToTung_DK.SelectedValue);
                    DM_DATAITEM TCTT = dt.DM_DATAITEM.Where(x => x.ID == IDTCTT).FirstOrDefault();
                    if (isDuongSuDK == 1)
                    {
                        AHS_BICANBICAO AHS_DuongSu = null;

                        AHS_DuongSu = dt.AHS_BICANBICAO.Where(x => x.ID == idDuongSuDK).FirstOrDefault();
                        decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                        AHS_DuongSu.VUANID = donid;
                        AHS_DuongSu.HOTEN = Cls_Comon.FormatTenRieng(txtHoTen_DK.Text);
                        //if (chkISBVQLNK.Visible)
                        //    ADS_DuongSu.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                        //else
                        //    ADS_DuongSu.ISBVQLNGUOIKHAC = 0;
                        AHS_DuongSu.SOCMND = txtCMND_Dk.Text;
                        AHS_DuongSu.TAMTRU = Convert.ToDecimal(ddlTamtru_Tinh_DK.SelectedValue);
                        AHS_DuongSu.TAMTRU_HUYEN = Convert.ToDecimal(ddlTamtru_Huyen_DK.SelectedValue);
                        AHS_DuongSu.TAMTRUCHITIET = txtDiaChiCT_DK.Text;
                        DateTime dNDNgaysinh;
                        dNDNgaysinh = (String.IsNullOrEmpty(txtNgaysinh_DK.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        AHS_DuongSu.NGAYSINH = dNDNgaysinh;
                        AHS_DuongSu.NAMSINH = txtNamsinh_DK.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh_DK.Text);
                        AHS_DuongSu.GIOITINH = Convert.ToDecimal(ddlGioiTinh_DK.SelectedValue);
                        //if (pnNDTochuc.Visible)
                        //{
                        //    ADS_DuongSu.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                        //    ADS_DuongSu.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                        //}
                        if (idDuongSuDK != 0)
                        {
                            AHS_DuongSu.NGAYSUA = DateTime.Now;
                            AHS_DuongSu.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                        else
                        {
                            AHS_DuongSu.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            AHS_DuongSu.NGAYTAO = DateTime.Now;
                            AHS_DuongSu.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            AHS_DuongSu.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.AHS_BICANBICAO.Add(AHS_DuongSu);
                            dt.SaveChanges();
                        }
                        oDK.ISDUONGSU = 1;
                        oDK.DUONGSUID = AHS_DuongSu.ID;
                    }
                    if (TCTT != null && isDuongSuDK == 0)
                    {
                        AHS_NGUOITHAMGIATOTUNG AHS_TGTT = null;
                        AHS_NGUOITHAMGIATOTUNG_TUCACH AHS_TGTT_TUCACH = null;

                        if (idDuongSuDK == 0)
                        {
                            AHS_TGTT = new AHS_NGUOITHAMGIATOTUNG();
                        }
                        else
                        {
                            AHS_TGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == idDuongSuDK).FirstOrDefault();
                        }
                        decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                        AHS_TGTT.VUANID = donid;
                        AHS_TGTT.HOTEN = Cls_Comon.FormatTenRieng(txtHoTen_DK.Text);
                        //if (ADS_TGTT.ISDAIDIEN == 1)
                        //{
                        //    ADS_TGTT.ISDAIDIEN = 1;
                        //}
                        //else
                        //{
                        //    ADS_TGTT.ISDAIDIEN = 0;
                        //}

                        //////ADS_TGTT. = Convert.ToDecimal(ddlLoaidungdon.SelectedValue);
                        //if (chkISBVQLNK.Visible)
                        //    ADS_TGTT.ISBVQLNGUOIKHAC = chkISBVQLNK.Checked ? 1 : 0;
                        //else
                        //    ADS_TGTT.ISBVQLNGUOIKHAC = 0;
                        AHS_TGTT.NDD_CMND = txtCMND_Dk.Text;
                        AHS_TGTT.DIACHICHITIET = txtDiaChiCT_DK.Text;
                        DateTime dNDNgaysinh;
                        dNDNgaysinh = (String.IsNullOrEmpty(txtNgaysinh_DK.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh_DK.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        AHS_TGTT.NGAYSINH = dNDNgaysinh;
                        AHS_TGTT.NAMSINH = txtNamsinh_DK.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh_DK.Text);
                        AHS_TGTT.GIOITINH = Convert.ToDecimal(ddlGioiTinh_DK.SelectedValue);
                        AHS_TGTT.NDD_EMAIL = txtEmail_DK.Text;
                        AHS_TGTT.NDD_MOBILE = txtTel_DK.Text;
                        AHS_TGTT.ISHOSO = 1;
                        AHS_TGTT.LOAIDT = ddlLoaidungdon.SelectedIndex;
                        //if (pnNDTochuc.Visible)
                        //{
                        //    ADS_TGTT.NDD_DIACHIID = Convert.ToDecimal(ddlNDD_Huyen_NguyenDon.SelectedValue);
                        //    ADS_TGTT.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                        //}
                        //ADS_TGTT.ISSOTHAM = 1;
                        //ADS_TGTT.ISDON = 1;
                        if (idDuongSuDK != 0)
                        {
                            AHS_TGTT.NGAYSUA = DateTime.Now;
                            AHS_TGTT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                        }
                        else
                        {
                            AHS_TGTT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.AHS_NGUOITHAMGIATOTUNG.Add(AHS_TGTT);
                            dt.SaveChanges();
                        }
                        oDK.ISDUONGSU = 0;
                        oDK.DUONGSUID = AHS_TGTT.ID;

                        AHS_TGTT_TUCACH = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == idDuongSuDK).FirstOrDefault();
                        if (AHS_TGTT_TUCACH == null)
                        {
                            AHS_TGTT_TUCACH = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                            AHS_TGTT_TUCACH.TUCACHID = Convert.ToDecimal(ddlTuCachToTung_DK.SelectedValue);
                            AHS_TGTT_TUCACH.NGUOIID = AHS_TGTT.ID;
                            dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(AHS_TGTT_TUCACH);
                            dt.SaveChanges();
                        }
                        else
                        {
                            AHS_TGTT_TUCACH.TUCACHID = Convert.ToDecimal(ddlTuCachToTung_DK.SelectedValue);
                            dt.SaveChanges();
                        }

                    }

                    if (donGhepID == 0)
                    {
                        oDK.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oDK.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.DON_KHAC.Add(oDK);
                        dt.SaveChanges();

                    }
                    else
                    {
                        dt.SaveChanges();
                    }
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
        //            oNSD.IDANHINHSU = IDVuViec;
        //            dt.SaveChanges();
        //        }
        //        Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
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


        protected void ddlLoaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            var loaiDon = ddlLoaidon.SelectedValue;
            if (loaiDon == "7")
            {
                lbNoidung.Text = "Nội dung khởi kiện";
                pnKhangCao.Visible = true;
                pnTTD.Visible = false;
                if (chkYeuCauKC.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                    }
                }
                decimal ID = 0;
                if (Request.QueryString["DONGHEPID"] != "")
                {
                    ID = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
                }
                DON_KHAC oDonKhac = dt.DON_KHAC.Where(x => x.ID == ID).FirstOrDefault();
                DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
                lbtDownloadKhangCao.Visible = false;
                if (oFile != null)
                {
                    if (oDonKhac != null)
                    {
                        if (oDonKhac.LOAIKCKN == 1)
                        {
                            lbtDownloadKhangCao.Visible = true;
                            hddFilePath_KC.Value = oFile.DONKHAC_ID.ToString();
                        }
                        if (oDonKhac.LOAIKCKN == 2)
                        {
                            lbtDownloadKhangNghi.Visible = true;
                            hddFilePath_KN.Value = oFile.DONKHAC_ID.ToString();
                        }
                    }
                }
                else
                {
                    if (oDonKhac != null)
                    {
                        if (oDonKhac.LOAIKCKN == 1)
                        {
                            lbtDownloadKhangCao.Visible = false;
                            hddFilePath_KC.Value = "";
                        }
                        if (oDonKhac.LOAIKCKN == 2)
                        {
                            lbtDownloadKhangNghi.Visible = false;
                            hddFilePath_KN.Value = "";
                        }
                    }


                }
            }
            else if (loaiDon == "8")
            {
                lbNoidung.Text = "Nội dung khởi kiện";
                pnKhangCao.Visible = false;
                pnTTD.Visible = true;
            }
        }
        protected void ddlNguoidungdon_SelectedIndexChanged(object sender, EventArgs e)
        {
            string[] commandArgsAccept = ddlNguoidungdon.SelectedValue.ToString().Split(new char[] { ',' });
            decimal idDuongSu = Convert.ToDecimal(commandArgsAccept[0]);
            decimal isDuongSu = Convert.ToDecimal(commandArgsAccept[1]);
            decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            if (ddlNguoidungdon.SelectedValue == "0,0")
            {
                pnTGTT.Visible = true;
                pnCaNhanDK.Visible = true;
                ddlTuCachToTung_DK.Enabled = true;
                ddlTuCachToTung_DK.Visible = true;
                lbTCTT.Visible = true;
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
                    AHS_BICANBICAO oDS = dt.AHS_BICANBICAO.Where(x => x.VUANID == donid && x.ID == idDuongSu).FirstOrDefault();
                    ddlTuCachToTung_DK.Enabled = false;
                    pnTGTT.Visible = false;
                    if (oDS.HOTEN != null)
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
                    if (oDS.TAMTRU != null && oDS.TAMTRU != 0)
                    {
                        ddlTamtru_Tinh_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Tinh_DK.Enabled = true;
                    }
                    if (oDS.TAMTRU_HUYEN != null && oDS.TAMTRU_HUYEN != 0)
                    {
                        ddlTamtru_Huyen_DK.Enabled = false;
                    }
                    else
                    {
                        ddlTamtru_Huyen_DK.Enabled = true;
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
                    AHS_NGUOITHAMGIATOTUNG oDSTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == donid && x.ID == idDuongSu).FirstOrDefault();
                    ddlTuCachToTung_DK.Enabled = false;
                    pnCaNhanDK.Visible = false;
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
                    if (oDSTT.NDD_EMAIL != null)
                    {
                        txtEmail_DK.Enabled = false;
                    }
                    else
                    {
                        txtEmail_DK.Enabled = true;
                    }
                    if (oDSTT.NDD_MOBILE != null)
                    {
                        txtTel_DK.Enabled = false;
                    }
                    else
                    {
                        txtTel_DK.Enabled = true;
                    }
                    if (oDSTT.DIACHICHITIET != null)
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
                if (chkYeuCauKC.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                    }
                }
                Cls_Comon.SetValueComboBox(ddlTamtru_Tinh_DK, Session[ENUM_SESSION.SESSION_TINH_ID]);
                LoadDrop_Huyen_DK();
                Cls_Comon.SetValueComboBox(ddlTamtru_Huyen_DK, Session[ENUM_SESSION.SESSION_QUAN_ID]);
            }

            else
            {
                if (isDuongSu == 1)
                {
                    AHS_BICANBICAO oDuongSu = dt.AHS_BICANBICAO.Where(x => x.VUANID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtHoTen_DK.Text = oDuongSu.HOTEN;
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
                                    txtNgaysinh_DK.Text = "";
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
                    ddlTuCachToTung_DK.Visible = false;
                    lbTCTT.Visible = false;
                    txtDiaChiCT_DK.Text = oDuongSu.TAMTRUCHITIET;
                    txtEmail_DK.Text = "";
                    txtTel_DK.Text = "";
                    ////txtChiTiet.Text = oDuongSu.DIACHICOQUAN;
                    if (oDuongSu.TAMTRU != null)
                    {
                        ddlTamtru_Tinh_DK.SelectedValue = oDuongSu.TAMTRU.ToString();
                        LoadDrop_Huyen_DK();
                        try
                        {
                            if (oDuongSu.HKTT_HUYEN != null) ddlTamtru_Huyen_DK.SelectedValue = oDuongSu.HKTT_HUYEN.ToString();
                        }
                        catch (Exception ex) { }
                    }
                }
                if (isDuongSu == 0)
                {
                    AHS_NGUOITHAMGIATOTUNG oTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == donid && x.ID == idDuongSu).FirstOrDefault();
                    txtHoTen_DK.Text = oTGTT.HOTEN;

                    if (oTGTT.NDD_CMND == null)
                    {
                        chkBoxCMND_DK.Checked = true;
                        txtCMND_Dk.Text = "";
                    }
                    else
                    {
                        chkBoxCMND_DK.Checked = false;
                        txtCMND_Dk.Text = oTGTT.NDD_CMND;
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
                    AHS_NGUOITHAMGIATOTUNG_TUCACH TCNguoiTGTT = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oTGTT.ID).FirstOrDefault();
                    ddlTuCachToTung_DK.Visible = true;
                    lbTCTT.Visible = true;
                    ddlTuCachToTung_DK.SelectedValue = TCNguoiTGTT.TUCACHID.ToString();
                    txtDiaChiCT_DK.Text = oTGTT.DIACHICHITIET;
                    ////txtChiTiet.Text = oDuongSu.DIACHICOQUAN;
                    txtEmail_DK.Text = oTGTT.NDD_EMAIL;
                    txtTel_DK.Text = oTGTT.NDD_MOBILE;
                    ddlTamtru_Tinh_DK.SelectedValue = "0";
                    ddlTamtru_Tinh_DK.Enabled = false;
                    ddlTamtru_Huyen_DK.Enabled = false;
                    LoadDrop_Huyen_DK();
                    try
                    {
                        ddlTamtru_Huyen_DK.SelectedValue = "0";
                    }
                    catch (Exception ex) { }

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
        //protected void ddlNguoiKCHS_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string[] commandArgsAccept = ddlNguoiKCHS.SelectedValue.ToString().Split(new char[] { ',' });
        //    decimal idDuongSu = Convert.ToDecimal(commandArgsAccept[0]);
        //    decimal isDuongSu = Convert.ToDecimal(commandArgsAccept[1]);
        //    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

        //    if (isDuongSu == 1)
        //    {
        //        rbNguoiKCHS.SelectedValue = "1";
        //    }
        //    if (isDuongSu == 0)
        //    {
        //        rbNguoiKCHS.SelectedValue = "0";
        //    }

        //}
        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbPanelKC.SelectedValue == "1")
            {
                rdbPanelKN.SelectedValue = "1";
                rdbPanelKC.SelectedValue = "1";
                pnKhangNghi.Visible = false;
                pnKhangCao.Visible = true;
            }
            else
            {
                rdbPanelKN.SelectedValue = "2";
                rdbPanelKC.SelectedValue = "2";
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }

        protected void txtNgaykhangcao_TextChanged(object sender, EventArgs e)
        {
            CheckNgayKCQuaHan();
        }
        void CheckNgayKCQuaHan()
        {
            int songay = 15;
            DateTime ngaysosanh = new DateTime();
            DateTime ngaykc = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            Decimal banan_qd_id = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
            int loai_ba_qd = Convert.ToInt16(rdbLoaiKC.SelectedValue);
            //truc tiep
            if (banan_qd_id > 0)
            {
                if (loai_ba_qd == 0)
                {
                    //Khangcao ban an--> NgayQuaHan > NgayBanAn + 15 ngay
                    AHS_SOTHAM_BANAN obj = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                    if (obj != null)
                        ngaysosanh = Convert.ToDateTime(obj.NGAYBANAN);
                }
                else
                {
                    //khang cao quyet dinh
                    //Neu la quyet dinh đinh chi/tạm dinh chi --> songay =7
                    AHS_SOTHAM_QUYETDINH_VUAN obj = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                    if (obj != null)
                    {
                        ngaysosanh = Convert.ToDateTime(obj.NGAYQD);
                        decimal loaiqd_id = Convert.ToDecimal(obj.LOAIQDID);
                        DM_QD_LOAI objLoaiQD = dt.DM_QD_LOAI.Where(x => x.ID == loaiqd_id).FirstOrDefault();
                        if (objLoaiQD != null)
                        {
                            if (objLoaiQD.MA == "TDC" || objLoaiQD.MA == "DC")
                                songay = 7;
                        }
                    }
                }
                if (ngaykc <= (ngaysosanh.AddDays(songay)))
                    rdbQuahan_KC.SelectedValue = "0";
                else
                    rdbQuahan_KC.SelectedValue = "1";
            }
        }
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
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
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_InfoKhangNghi();
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBAKhangNghi.SelectedValue == "0") return;
            decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);

            if (rdbLoaiKN.SelectedValue == "0")
            {
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA_KN.Text = "";
            }
            else
            {
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA_KN.Text = "";
            }

            //-------------------------------
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KN.Text = oToaAn.TEN;
                else txtToaAnQD_KN.Text = "";
            }
            else
                txtToaAnQD_KN.Text = "";
        }
        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BAKhangNghi(); } catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        private void LoadQD_BAKhangNghi()
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (rdbLoaiKN.SelectedValue == "0")
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, VuAnID);
            else if (rdbLoaiKN.SelectedValue == "1")
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBAKhangNghi, VuAnID, 1);
            else
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBAKhangNghi, VuAnID, 2);
            LoadQD_BA_InfoKhangNghi();
        }
        void LoadDrop_ST_BanAn(DropDownList drop, Decimal VuAnID)
        {
            String temp = "";
            List<AHS_SOTHAM_BANAN> lst = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYBANAN).ToList<AHS_SOTHAM_BANAN>();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN item in lst)
                {
                    //temp = item.SOBANAN + "-" + ((DateTime)item.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    temp = item.SOBANAN;
                    drop.Items.Add(new ListItem(temp, item.ID.ToString()));
                }
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadDrop_ST_QuyetDinhVuAn(DropDownList drop, Decimal VuAnID, Decimal loaiKC)
        {
            string temp = "";
            AHS_SOTHAM_BL objBL = new AHS_SOTHAM_BL();
            DataTable tblQD = objBL.AHS_ST_QD_VUAN_GETLIST(VuAnID);
            if (tblQD != null && tblQD.Rows.Count > 0)
            {
                foreach (DataRow row in tblQD.Rows)
                {
                    temp = "Số " + row["SOQUYETDINH"].ToString() + " - " + row["TENQD"].ToString().Split('.')[1];
                    //kiểm tra loại kháng cáo để lấy danh sách quyết định
                    Decimal loaiQĐ = Convert.ToDecimal(row["QUYETDINHID"].ToString());
                    if (loaiKC == 1)
                    {
                        if (loaiQĐ == 77 || loaiQĐ == 78 || loaiQĐ == 205)
                        {
                            drop.Items.Add(new ListItem(temp, row["ID"].ToString()));
                        }
                    }
                    else
                    {
                        if (loaiQĐ != 77 && loaiQĐ != 78 && loaiQĐ != 205)
                        {
                            drop.Items.Add(new ListItem(temp, row["ID"].ToString()));
                        }
                    }
                }
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            objBL = new AHS_SOTHAM_BL();
        }

        protected void ddlSOQDBA_KC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadQD_BA_InfoKhangCao();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        void Load_ListBiCan()
        {
            decimal VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            ddlNguoikhangcao.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        void Load_ListNguoiThamGiaToTung()
        {
            decimal VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            ddlNguoikhangcao.Items.Clear();
            List<AHS_NGUOITHAMGIATOTUNG> lst = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_NGUOITHAMGIATOTUNG item in lst)
                    ddlNguoikhangcao.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
            else
                ddlNguoikhangcao.Items.Add(new ListItem("--- Chọn ---", "0"));
        }

        protected void rdbLoaiNguoiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            switch (loai)
            {
                case 0:
                    Load_ListBiCan();
                    lbNguoiBiKC.Visible = false;
                    plNguoiBiKC.Visible = false;
                    break;
                case 1:
                    Load_ListNguoiThamGiaToTung();
                    lbNguoiBiKC.Visible = true;
                    plNguoiBiKC.Visible = true;
                    break;
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadQD_BAKhangCao();
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        private void LoadQD_BAKhangCao()
        {
            int loai = 0;
            ddlSOQDBA_KC.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            try
            {
                loai = Convert.ToInt16(rdbLoaiKC.SelectedValue);
            }
            catch (Exception ex) { }
            switch (loai)
            {
                case 0:
                    //Khag cao ban an
                    LoadDrop_ST_BanAn(ddlSOQDBA_KC, VuAnID);
                    break;
                case 1:
                    //khang cao quyet dinh
                    LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBA_KC, VuAnID, 1);
                    break;
                case 2:
                    //khang cao quyet dinh khác
                    LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBA_KC, VuAnID, 2);
                    break;
                default:
                    break;
            }
            LoadQD_BA_InfoKhangCao();
        }

        private void LoadQD_BA_InfoKhangCao()
        {
            if (ddlSOQDBA_KC.SelectedValue == "0")
                return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KC.Text = "";
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else
                    txtNgayQDBA_KC.Text = "";
            }
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                    txtToaAnQD_KC.Text = oToaAn.TEN;
                else txtToaAnQD_KC.Text = "";
            }
            else
                txtToaAnQD_KC.Text = "";
        }

        protected void lbtDownloadKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddFilePath_KC.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }

        }
        protected void AsyncFileUpLoadKhangCao_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangCao.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangCao.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangCao.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownloadKhangNghi_Click(object sender, EventArgs e)
        {
            //decimal ID = Convert.ToDecimal(hddid.Value);
            //AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            //if (oND.TENFILE != "")
            //{
            //    var cacheKey = Guid.NewGuid().ToString("N");
            //    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            //}
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
    }
}