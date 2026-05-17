using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.THA;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxThemes;
using System.IO;
using System.Web.UI;
using BL.GSTP.BANGSETGET;
using BL.GSTP.ALD;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.Quantri;
using Module.Common.C06;
using BL.GSTP.DLQGC06;
using System.Xml;
using System.Text;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class ThongTinVA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        Decimal CurrUserID = 0;
        String VuViecTemp = "VuViecIDTemp";
        public string keyDonID = "";
        private const decimal ROOT = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                scriptManager.RegisterPostBackControl(this.ddlTamTru_Tinh);

                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (CurrUserID > 0)
                {
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    if (!IsPostBack)
                    {
                        keyDonID = "THIHANHAN.IDVUANTHA" + Session[ENUM_SESSION.SESSION_USERID].ToString();
                        Session[keyDonID] = "";
                        lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                        lbSoBanAn.Text = "Số bản án sơ thẩm";
                        //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                        lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
                        LoadCombobox();
                        pnGDXX.Visible = false;
                        decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                        //check chọn item loại án thuộc hệ thống hay ngoài hệ thống	
                        SeletedItemLoai(current_idBiAn);
                        decimal current_idVuAn = 0;
                        THA_BIAN oBiAn = null;
                        if (current_idBiAn > 0)
                            oBiAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
                        //kiểm tra xem đây có phải là vụ án được ủy thác hay ko, nếu có thì gán lại tội danh thông qua ủy thác detail
                        if (oBiAn.UYTHAC_DETAIL_ID != null && oBiAn.UYTHAC_DETAIL_ID != 0)
                        {
                            THA_UYTHAC_DETAIL obUyThacDetails = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == oBiAn.UYTHAC_DETAIL_ID).First();
                            THA_UYTHAC_QUYETDINH obUyThacQD = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == obUyThacDetails.QD_UYTHACTHA_ID).First();
                            if (obUyThacQD != null) current_idBiAn = (decimal)obUyThacQD.BIANID;
                        }
                        current_idVuAn = (decimal)dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault().VUANID;
                        //AHS_SOTHAM_CAOTRANG_DIEULUAT oCT_DL = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == current_idBiAn && x.ISMAIN==1).FirstOrDefault() ?? new AHS_SOTHAM_CAOTRANG_DIEULUAT();
                        THA_SOTHAM_CAOTRANG_DIEULUAT obTHADieuLuat = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == current_idBiAn && x.VUANID == current_idVuAn && x.ISMAIN == 1).FirstOrDefault() ?? new THA_SOTHAM_CAOTRANG_DIEULUAT(); ;
                        string current_id = "";
                        if (oBiAn != null)
                        {
                            current_id = oBiAn.VUANID.ToString();
                            string toiDanh = obTHADieuLuat.TENTOIDANH == null ? "" : obTHADieuLuat.TENTOIDANH;
                            txtTenBiAnToiDanh.Text = oBiAn.HOTEN + " - " + toiDanh;
                            lkFile.Visible = cmdXoa.Visible = false;
                        }
                        else
                        {
                            current_id = Request.QueryString["ID"];
                        }

                        if (current_id != null)
                        {
                            string strtype = Request["type"] + "";
                            if (strtype != "list")
                            {
                                //Lay thong tin vuanid theo session
                                /*                                cmdQuaylai.Visible = cmdQuaylaiB.Visible = false;
                                                                cmdUpdateAndNew.Visible = cmdUpdateAndNewB.Visible = false;*/
                            }
                            else
                            {
                                Session[ENUM_LOAIAN.AN_THA] = "0";
                                //Edit du lieu chon tu ds
                                current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                                if ((Session[ENUM_LOAIAN.AN_THA].ToString() == "0") && (strtype != "") && (current_id == ""))
                                {
                                    LoadHSVuViecCuoiChuaNhapXong();
                                }
                            }

                            Decimal CurrVuAnID = (String.IsNullOrEmpty(current_id + "")) ? 0 : Convert.ToDecimal(current_id);
                            if (CurrVuAnID > 0)
                            {
                                hddID.Value = CurrVuAnID.ToString();
                                if (oBiAn.UYTHAC_DETAIL_ID != null && oBiAn.UYTHAC_DETAIL_ID != 0)
                                {
                                    current_id = current_idVuAn.ToString();
                                }
                                LoadThongTinVuAn(Convert.ToDecimal(current_id));
                            }
                            //CheckQuyen();
                            // Kiểm tra TOA_GIAIQUYET_ID
                            string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                            THA_VUAN_BL tvBL = new THA_VUAN_BL();
                            decimal idVuanHethong = 0;
                            if (oBiAn.IDVUANHETHONG != null && oBiAn.IDVUANHETHONG != 0)
                            {
                                idVuanHethong = (decimal)oBiAn.IDVUANHETHONG;
                            }
                            else
                            {
                                THA_BIAN thaBiAnUyThac = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == oBiAn.IDBICANHETHONG && x.IDVUANHETHONG != 0 && x.IDVUANHETHONG != null).FirstOrDefault();
                                idVuanHethong = thaBiAnUyThac != null ? (decimal)thaBiAnUyThac.IDVUANHETHONG : 0;
                            }

                            DataTable dtBanGiao = tvBL.THA_GETCHITIET_BANGIAO(idVuanHethong, Convert.ToDecimal(donviID), "AN_HINHSU");
                            THI_HANH_AN_BANGIAO_MAPPING banGiao = DataExtensions.GetAllWithClause<THI_HANH_AN_BANGIAO_MAPPING>($"VUVIECLOAI='THA' AND TOAANNHANID={donviID} AND VUVIECID={oBiAn.VUANID}").FirstOrDefault();

                            if (dtBanGiao.Rows.Count > 0 || banGiao != null)
                            {
                                string toa_GQ_ID = oBiAn.TOA_GIAIQUYET_ID.ToString();

                                if (toa_GQ_ID != donviID)
                                {
                                    cmdUpdateVuAn.Visible = false;
                                    cmdQuaylai.Visible = false;
                                }
                            }
                        }
                        SetValue_OtherControl();

                        //check có quyết định THA thì ẩn nút lưu
                        THA_BIAN_QUYETDINH data = dt.THA_BIAN_QUYETDINH.FirstOrDefault(x => x.BIANID == current_idBiAn);
                        if (data != null)
                        {
                            lstMsgT.Text = "Bị án đã có quyết định thi hành án. Không được thay đổi thông tin!";
                            cmdUpdateVuAn.Visible = cmdQuaylai.Visible = false;
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) { lstMsgT.Text = ex.Message; }
        }

        void SeletedItemLoai(decimal current_idBiAn)
        {
            THA_BIAN obBian = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            THA_UYTHAC_DETAIL objDe = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == obBian.UYTHAC_DETAIL_ID).FirstOrDefault();
            if (objDe != null)
            {
                dropLoaiLuaChon.SelectedValue = "0";
            }
            else
            {
                dropLoaiLuaChon.SelectedValue = "1";
            }
        }
        void LoadHSVuViecCuoiChuaNhapXong()
        {
            //Lay thong tin vu viec cuoi cung chua nhap xong (chua co bị can)
            THA_VUAN_BL objVA = new THA_VUAN_BL();
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            DataTable tbl = objVA.GetLastThaVuAnNotComlete(ToaAnID, curr_user);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                decimal LastID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                hddID.Value = LastID.ToString();
                LoadThongTinVuAn(LastID);
                //txtTenVuAn.Text = "(Đang cập nhật)";
                //lstMsgT.Text = "Vụ án này chưa được cập nhật xong thông tin hồ sơ. Đề nghị bạn tiếp tục cập nhật đầy đủ thông tin! ";
            }
            else
            {
                string current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                if (!String.IsNullOrEmpty(Session[VuViecTemp] + ""))
                {
                    current_id = Session[VuViecTemp].ToString();
                    hddID.Value = Session[VuViecTemp].ToString();

                    LoadThongTinVuAn(Convert.ToDecimal(current_id));
                }
            }
        }
        public void LoadThongTinVuAn(decimal VuAnID)
        {

            THA_VUAN oT = dt.THA_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                //hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //txtMaVuAn.Text = oT.MAVUAN;
                txtTenVuAn.Text = oT.BA_TENVUAN;
                //dropLoaiLuaChon.SelectedValue = oT.ISHETHONG.ToString();
                //----------------------------------
                if (oT.BA_NGAYVUAN == DateTime.MinValue || oT.BA_NGAYVUAN + "" == "")
                {
                    txtNgayXayra.Text = "";
                }
                else
                {
                    txtNgayXayra.Text = ((DateTime)oT.BA_NGAYVUAN).ToString("dd/MM/yyyy", cul);
                }
                Decimal ToaAnId = 0;
                Decimal ToaAnIdST = 0;
                if (oT.BA_PT_TOAANID != null && oT.BA_PT_TOAANID != 0)
                {
                    ddlGDXX.SelectedValue = "2";
                    pnGDXX.Visible = true;
                    lbNgayBanAn.Text = "Ngày bản án phúc thẩm";
                    lbSoBanAn.Text = "Số bản án phúc thẩm";
                    //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án phúc thẩm";
                    lbToaAn.Text = "Tòa án ra bản án phúc thẩm";
                    txtNgayBanAn.Text = oT.BA_PT_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_PT_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    txtSoBanAn.Text = oT.BA_PT_SO;
                    //txtNgayAnCoHieuLuc.Text = oT.BA_PT_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_PT_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    txtNgayBAST.Text = oT.BA_ST_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    txtSoBAST.Text = oT.BA_ST_SO;
                    //txtNgayAnCoHieuLucST.Text = oT.BA_ST_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    ToaAnId = (Decimal)oT.BA_PT_TOAANID;
                    ToaAnIdST = (Decimal)oT.BA_ST_TOAANID;
                    dropTinhChatVuAn.SelectedValue = oT.BA_TINHCHAT.ToString();
                    try
                    {
                        String ToaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>().TEN;
                        txtToaAn.Text = ToaAn;
                        hddToaAnID.Value = ToaAnId.ToString();
                    }
                    catch (Exception ex) { }
                    try
                    {
                        String ToaAnST = dt.DM_TOAAN.Where(x => x.ID == ToaAnIdST).Single<DM_TOAAN>().TEN;
                        txtToaAnST.Text = ToaAnST;
                        hddToaAnIDST.Value = ToaAnIdST.ToString();
                    }
                    catch (Exception ex) { }
                    //------------------------------------
                }
                else
                {
                    ddlGDXX.SelectedValue = "1";
                    pnGDXX.Visible = false;
                    lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                    lbSoBanAn.Text = "Số bản án sơ thẩm";
                    //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                    lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
                    if (oT.BA_ST_TOAANID != null)
                    {
                        txtNgayBanAn.Text = oT.BA_ST_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                        txtSoBanAn.Text = oT.BA_ST_SO;
                        //txtNgayAnCoHieuLuc.Text = oT.BA_ST_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                        ToaAnId = (Decimal)oT.BA_ST_TOAANID;
                    }
                    dropTinhChatVuAn.SelectedValue = oT.BA_TINHCHAT.ToString();
                    try
                    {
                        String ToaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>().TEN;
                        txtToaAn.Text = ToaAn;
                        hddToaAnID.Value = ToaAnId.ToString();
                    }
                    catch (Exception ex) { }
                }
                decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                THA_BIAN biAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
                // load thong tin co the thay doi
                if (biAn != null)
                {
                    /*if(hs_bican != null)
                    {
                        txtNgaySinh.Text = hs_bican.NGAYSINH?.ToString("dd/MM/yyyy", cul);
                        txtNamSinh.Text = hs_bican.NAMSINH.ToString();
                        txtSoCCCD.Text = hs_bican.SOCMND;
                        txtNgayCapCCCD.Text = hs_bican.NGAYTHAMGIA + "" == "" ? "" : ((DateTime)hs_bican.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
                        if (lstNhanThan != null && lstNhanThan.Count > 0)
                        {
                            string MoiQuanHeNhanThan = "";
                            
                            foreach (AHS_BICAN_NHANTHAN item in lstNhanThan)
                            {
                                try { MoiQuanHeNhanThan = dt.DM_DATAITEM.Where(x => x.ID == item.MOIQUANHEID).FirstOrDefault().MA; } catch (Exception ex) { }
                                if (MoiQuanHeNhanThan.Equals(ENUM_QH_NHANTHAN.BO))
                                {
                                    txtHoTenBo.Text = item.HOTEN;
                                } else if (MoiQuanHeNhanThan.Equals(ENUM_QH_NHANTHAN.ME))
                                {
                                    txtHoTenMe.Text = item.HOTEN;
                                }
                            }
                        }
                    }*/
                    hdTrangThaiXacThucND.Value = biAn.XACTHUC_DLDCQG?.ToString() ?? "0";
                    HienThiTrangThaiXacThuc();

                    if (biAn.XACTHUC_DLDCQG == 3)
                    {
                        chkKhongLamSachND.Checked = true;
                    }
                    if (biAn.XACTHUC_DLDCQG == 0)
                    {
                        chkKhongCo.Checked = true;
                    }

                    txtNgaySinh.Text = biAn.NGAYSINH?.ToString("dd/MM/yyyy", cul);
                    txtNamSinh.Text = biAn.NAMSINH?.ToString();
                    txtSoCCCD.Text = biAn.SOCCCD;
                    if (string.IsNullOrEmpty(biAn.SOCCCD))
                        chkKhongCo.Checked = true;
                    txtSoCMND.Text = biAn.SOCMND;
                    txtNgayCapCCCD.Text = biAn.NGAYTHAMGIA + "" == "" ? "" : ((DateTime)biAn.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
                    txtHoTenBo.Text = biAn.HOTENBO;
                    txtHoTenMe.Text = biAn.HOTENME;

                    ddlTamTru_Tinh.SelectedValue = biAn.TAMTRU.ToString();
                    // Bind districts (huyện) for the selected province (tỉnh) before selecting a specific district
                    LoadDropTamTru_Huyen();
                    DM_HANHCHINH Huyen_TamTru = dt.DM_HANHCHINH.Where(x => x.ID == biAn.TAMTRU_HUYEN).FirstOrDefault<DM_HANHCHINH>();
                    if (Huyen_TamTru != null)
                    {
                        var targetValue = Huyen_TamTru.ID.ToString();
                        if (ddlTamTru_Huyen.Items.FindByValue(targetValue) != null)
                            ddlTamTru_Huyen.SelectedValue = targetValue;
                    }
                    txtTamtru_Chitiet.Text = biAn.TAMTRUCHITIET;
                    ddlThuongTru_Tinh.SelectedValue = biAn.HKTT.ToString();
                    // Bind temporary residence districts before selecting
                    LoadDropThuongTru_Huyen();
                    DM_HANHCHINH Huyen_HKTT = dt.DM_HANHCHINH.Where(x => x.ID == biAn.HKTT_HUYEN).FirstOrDefault<DM_HANHCHINH>();
                    if (Huyen_HKTT != null)
                    {
                        var targetTamTru = Huyen_HKTT.ID.ToString();
                        if (ddlThuongTru_Huyen.Items.FindByValue(targetTamTru) != null)
                            ddlThuongTru_Huyen.SelectedValue = targetTamTru;
                    }
                    txtDiachichitiet_CQDN.Text = biAn.KHTTCHITIET;
                    if (biAn.QT_FILE_ID != null)
                    {
                        QT_FILE qtFile = DataExtensions.FindById<QT_FILE>(biAn.QT_FILE_ID.Value);
                        lkFile.Text = hddFilePath.Value = qtFile.FILE_NAME;
                        lkFile.Visible = cmdXoa.Visible = biAn.QT_FILE_ID != null;
                    }
                }
                Load_ToiDanhBiCanDauvu(VuAnID);
                ReadOnlyThongTinVuAn();

            }
        }
        private void ReadOnlyThongTinVuAn()
        {
            txtTenVuAn.ReadOnly = true;
            txtTenBiAnToiDanh.ReadOnly = true;
            txtNgayXayra.ReadOnly = true;
            txtNgayBanAn.ReadOnly = true;
            txtSoBanAn.ReadOnly = true;
            txtToaAn.ReadOnly = true;
            txtNgayBAST.ReadOnly = true;
            txtSoBAST.ReadOnly = true;
            txtToaAnST.ReadOnly = true;
        }
        void LoadDropLoai()
        {

            dropLoaiLuaChon.Enabled = false;
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            // dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "0"));
            dropLoaiLuaChon.Items.Add(new ListItem("Được uỷ thác THA", "0"));
            //dropLoaiLuaChon.SelectedValue = "0";
            //kiểm tra nếu có ủy thác THA thì gợi ý là thụ lý mới do có ủy thác THA
            //decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            //THA_BIAN obBian = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            //THA_UYTHAC_DETAIL objDe = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == obBian.UYTHAC_DETAIL_ID).FirstOrDefault();
            //if (objDe != null)
            //{
            //    dropLoaiLuaChon.SelectedValue = "0";
            //}
            //else
            //{
            //    dropLoaiLuaChon.SelectedValue = "1";
            //}
            //if (Request["type"] == "list")
            //{
            //    dropLoaiLuaChon.Enabled = false;
            //}
            //else
            //{
            //    dropLoaiLuaChon.Enabled = true;
            //}
        }


        void Load_ToiDanhBiCanDauvu(Decimal VuAnID)
        {
            Decimal BiCanDauVuID = 0;
            decimal biCaoID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            List<THA_BIAN> lst = dt.THA_BIAN.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).ToList<THA_BIAN>();
            if (lst != null && lst.Count > 0)
            {
                BiCanDauVuID = Convert.ToDecimal(lst[0].ID + "");
                hddBiCanDauVuID.Value = lst[0].ID.ToString();

                THA_VUAN_BL objBL = new THA_VUAN_BL();
                DataTable tbl = objBL.GetAllToiDanhByBiCan(biCaoID, VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptToiDanh.DataSource = tbl;
                    rptToiDanh.DataBind();
                    pnToiDanhChung.Visible = true;
                }
                else pnToiDanhChung.Visible = false;
            }
            else pnToiDanhChung.Visible = false;
        }
        protected void rptToiDanh_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                decimal ma_gd = (String.IsNullOrEmpty(hddMaGiaiDoan.Value)) ? 0 : Convert.ToDecimal(hddMaGiaiDoan.Value);
                // Kiểm tra TOA_GIAIQUYET_ID
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();



                if (toaGiaiQuyetID != donviID)
                {
                    cmdUpdateVuAn.Visible = false;
                    cmdXoa.Visible = false;

                    lkXoa.Visible = false;
                }
            }
        }
        String LoadChiTietToiDanh(Decimal luatid, Decimal ToiDanhID, String ArrSapXep, int level)
        {
            string[] temp = null;
            String RootId = "";
            String ToiDanhChinh = "", Temp_ToiDanh = "";
            temp = ArrSapXep.Split('/');

            RootId = temp[0] + "";
            string temp_sx = ArrSapXep.Replace("/", ",");

            //-------------------------
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
        private void ResetControls()
        {
            hddFilePath.Value = "";
            txtHoTenBo.Text = "";
            txtHoTenMe.Text = "";
            txtNgaySinh.Text = "";
            txtNamSinh.Text = "";
            txtSoCCCD.Text = "";
            txtSoCMND.Text = "";
            txtNgayCapCCCD.Text = "";
            txtDiachichitiet_CQDN.Text = "";
            txtTamtru_Chitiet.Text = "";
            ddlTamTru_Tinh.SelectedIndex = 0;
            ddlTamTru_Huyen.SelectedIndex = 0;
            ddlThuongTru_Tinh.SelectedIndex = 0;
            ddlThuongTru_Huyen.SelectedIndex = 0;
            lkFile.Text = "";
            lkFile.Visible = cmdXoa.Visible = false;
        }
        private void ResetControls_BIAN_DA_DONGBO()
        {
            hddFilePath.Value = "";
            txtHoTenBo.Text = "";
            txtHoTenMe.Text = "";
            txtSoCMND.Text = "";
            txtNgayCapCCCD.Text = "";
            txtDiachichitiet_CQDN.Text = "";
            txtTamtru_Chitiet.Text = "";
            ddlTamTru_Tinh.SelectedIndex = 0;
            ddlTamTru_Huyen.SelectedIndex = 0;
            ddlThuongTru_Tinh.SelectedIndex = 0;
            ddlThuongTru_Huyen.SelectedIndex = 0;
            lkFile.Text = "";
            lkFile.Visible = cmdXoa.Visible = false;
        }
        private void LoadCombobox()
        {
            LoadDropLoai();
            LoadDropTinh();
        }
        protected void lkFile_Click(object sender, EventArgs e)
        {
            DowloadFile();
        }

        void DowloadFile()
        {
            try
            {
                decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                THA_BIAN oND = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
                if (oND.QT_FILE_ID != null)
                {
                    QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                    var cacheKey = Guid.NewGuid().ToString("N");
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    byte[] file = fileH.GetNoiDungFile_Minio_THA(qtFileGet, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                    if (file == null)
                    {
                        lstMsgT.Text = "Không tìm thấy file đính kèm!";
                        return;
                    }
                    string fileName = qtFileGet.FILE_NAME;
                    Context.Cache.Insert(key: cacheKey, value: file, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + qtFileGet.FILE_NAME + "&Extension=" + qtFileGet.FILE_TYPE + "';", true);
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = ex.Message;
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", ex.Message);
            }
        }

        private void LoadDropTinh()
        {
            ddlThuongTru_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlThuongTru_Tinh.Items.Clear();
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlThuongTru_Tinh.DataSource = lstTinh;
                ddlThuongTru_Tinh.DataTextField = "TEN";
                ddlThuongTru_Tinh.DataValueField = "ID";
                ddlThuongTru_Tinh.DataBind();

                ddlTamTru_Tinh.DataSource = lstTinh;
                ddlTamTru_Tinh.DataTextField = "TEN";
                ddlTamTru_Tinh.DataValueField = "ID";
                ddlTamTru_Tinh.DataBind();
            }
            ddlThuongTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlTamTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            LoadDropThuongTru_Huyen();
            LoadDropTamTru_Huyen();
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
        protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                //Lưu vào người dùng
                decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                {
                    oNSD.IDTHA = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_THA] = IDVuViec;
                lstMsgT.Text = "Lưu thông tin vụ án thành công!";
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
        {
            if (!CheckValid()) return;
            decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            decimal CurrID = Convert.ToDecimal(hddID.Value);
            THA_BIAN biAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            biAn.HOTENBO = (String.IsNullOrEmpty(txtHoTenBo.Text.Trim())) ? "" : this.txtHoTenBo.Text.Trim();
            biAn.HOTENME = (String.IsNullOrEmpty(txtHoTenMe.Text.Trim())) ? "" : this.txtHoTenMe.Text.Trim();
            biAn.SOCCCD = (String.IsNullOrEmpty(txtSoCCCD.Text.Trim())) ? "" : this.txtSoCCCD.Text.Trim();
            biAn.SOCMND = (String.IsNullOrEmpty(txtSoCMND.Text.Trim())) ? "" : this.txtSoCMND.Text.Trim();
            biAn.HKTT = Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue);
            biAn.HKTT_HUYEN = Convert.ToDecimal(ddlThuongTru_Huyen.SelectedValue);
            biAn.TAMTRU = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
            biAn.TAMTRU_HUYEN = Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue);
            biAn.KHTTCHITIET = (String.IsNullOrEmpty(txtDiachichitiet_CQDN.Text.Trim())) ? "" : this.txtDiachichitiet_CQDN.Text.Trim();
            biAn.TAMTRUCHITIET = (String.IsNullOrEmpty(txtTamtru_Chitiet.Text.Trim())) ? "" : this.txtTamtru_Chitiet.Text.Trim();
            // validate truong ngay
            biAn.NGAYSINH = (String.IsNullOrEmpty(txtNgaySinh.Text?.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //nếu chưa xác thực thì mới thay đổi được năm sinh
            if (!(biAn.XACTHUC_DLDCQG == 1))
            {
                biAn.NAMSINH = (String.IsNullOrEmpty(txtNamSinh.Text?.Trim())) ? (decimal?)null : Convert.ToDecimal(this.txtNamSinh.Text.Trim());
            }
            biAn.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgayCapCCCD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayCapCCCD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            UploadFile(biAn);

            biAn.NGAYSUA = DateTime.Now;
            biAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            if (chkKhongLamSachND.Checked)
            {
                biAn.XACTHUC_DLDCQG = 3;
                hdTrangThaiXacThucND.Value = "3";
            }
            else if (chkKhongCo.Checked && string.IsNullOrWhiteSpace(txtSoCCCD.Text))
            {
                biAn.XACTHUC_DLDCQG = 3;
                hdTrangThaiXacThucND.Value = "3";

            }
            else
            {
                if (hdTrangThaiXacThucND.Value != "1")
                    biAn.XACTHUC_DLDCQG = 0;
                else
                    biAn.XACTHUC_DLDCQG = Convert.ToInt16(hdTrangThaiXacThucND.Value);
            }
            dt.SaveChanges();
            HienThiTrangThaiXacThuc();
            lkFile.Visible = cmdXoa.Visible = biAn.QT_FILE_ID != null;
            lstMsgT.Text = "Lưu thành công";
            LoadThongTinVuAn(CurrID);
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công! Bạn hãy nhập thông tin vụ án tiếp theo !";
            }
        }

        // auto fill nam sinh
        protected void txtNgaySinh_TextChanged(object sender, EventArgs e)
        {
            DateTime? d;
            d = (String.IsNullOrEmpty(txtNgaySinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != null)
            {
                txtNamSinh.Text = d?.Year.ToString();
            }
            txtNamSinh.Focus();
        }

        private bool SaveData()
        {
            try
            {
                if (!CheckValid())
                    return false;

                if (!SaveDataVuAn())
                {
                    return false;
                }

                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        private bool CheckValid()
        {
            //KT: yeu cau nhap bi can dau vu
            decimal VuAnID = ((string.IsNullOrEmpty(hddID.Value)) || (hddID.Value == "0")) ? 0 : Convert.ToDecimal(hddID.Value);

            try
            {
                THA_BIAN obj = dt.THA_BIAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (obj == null)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can cho vụ án!");
                    Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                    return false;
                }
            }
            catch (Exception ex)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can cho vụ án!");
                Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                return false;
            }
            return true;
        }

        private bool SetSessionDataVuAn()
        {

            decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oBiAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            decimal current_id = 0;
            string IDvuan = hddID.Value;
            if (oBiAn != null)
            {
                current_id = Convert.ToDecimal(oBiAn.VUANID);
            }
            else if (IDvuan != null)
            {
                current_id = Convert.ToDecimal(IDvuan);
            }
            else
            {
                current_id = Convert.ToDecimal(Request.QueryString["ID"]);
            }

            if (ddlGDXX.SelectedValue == "1")
            {
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                //DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => ( x.ID == 0 || x.ID != current_id) && x.BA_ST_SO == SoBA && x.BA_ST_NGAYBANAN == NgayBA && x.BA_ST_TOAANID == ToaAnRaBA).FirstOrDefault();
                if (oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    if (oBAST.TOAANID == Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = SoBA;
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = NgayBA;
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_chon_bian_BA()");
                    }
                    else
                    {
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                        lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở " + oTA.TEN + " . Vui lòng kiểm tra lại !";
                        return false;
                    }
                }
                else
                {
                    SetSessionDataVuAn_CheckBanAn();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_bc()");
                }
            }
            else if (ddlGDXX.SelectedValue == "2")
            {
                string SoBAST = txtSoBAST.Text.ToString();
                DateTime NgayBAST = (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBAST = Convert.ToDecimal(hddToaAnIDST.Value);
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_PHUCTHAM_BANAN oBAPT = dt.AHS_PHUCTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBAST && x.NGAYBANAN == NgayBAST && x.TOAANID == ToaAnRaBAST).FirstOrDefault();

                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => (x.ID == 0 || x.ID != current_id) && x.BA_PT_SO == SoBA && x.BA_PT_NGAYBANAN == NgayBA && x.BA_PT_TOAANID == ToaAnRaBA && x.BA_ST_SO == SoBAST && x.BA_ST_NGAYBANAN == NgayBAST && x.BA_ST_TOAANID == ToaAnRaBAST).FirstOrDefault();
                if (oBAPT != null && oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    if (oBAST.TOAANID == Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = SoBAST;
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = NgayBAST;
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_chon_bian_BA()");
                    }
                    else
                    {
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                        lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở " + oTA.TEN + " . Vui lòng kiểm tra lại !";
                        return false;
                    }
                }
                else
                {
                    SetSessionDataVuAn_CheckBanAn();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_bc()");
                }

            }
            return true;
        }

        void SetSessionDataVuAn_CheckBanAn()
        {
            THA_VUAN oT;
            DateTime date_temp;
            Boolean IsUpdate = false;
            #region "THÔNG TIN vụ án"
            if (hddID.Value == "" || hddID.Value == "0")
                Session[ENUM_THA_VUAN.SESSION_IDVUANTHA] = 0;
            else
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                oT = dt.THA_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    IsUpdate = true;
                    Session[ENUM_THA_VUAN.SESSION_IDVUANTHA] = ID;
                }
            }
            decimal IDtoaraBA = Convert.ToDecimal(hddToaAnID.Value);
            Session[ENUM_THA_VUAN.SESSION_DDLGDXX] = ddlGDXX.SelectedValue;
            if (ddlGDXX.SelectedValue == "2")
            {
                Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = txtSoBAST.Text;
                Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = (String.IsNullOrEmpty(this.txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLucST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLucST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Session[ENUM_THA_VUAN.SESSION_BA_ST_TOAANID] = Convert.ToDecimal(hddToaAnIDST.Value);

                Session[ENUM_THA_VUAN.SESSION_BA_PT_SO] = txtSoBanAn.Text;
                Session[ENUM_THA_VUAN.SESSION_BA_PT_NGAYBANAN] = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_PT_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Session[ENUM_THA_VUAN.SESSION_BA_PT_TOAANID] = Convert.ToDecimal(hddToaAnID.Value);
            }
            else if (ddlGDXX.SelectedValue == "1")
            {
                Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = txtSoBanAn.Text;
                Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Session[ENUM_THA_VUAN.SESSION_BA_ST_TOAANID] = Convert.ToDecimal(hddToaAnID.Value);
            }
            Session[ENUM_THA_VUAN.SESSION_BA_TENVUAN] = txtTenVuAn.Text.Trim();
            Session[ENUM_THA_VUAN.SESSION_BA_TINHCHAT] = Convert.ToDecimal(dropTinhChatVuAn.SelectedValue);

            Session[ENUM_THA_VUAN.SESSION_ISHETHONG] = Convert.ToDecimal(dropLoaiLuaChon.SelectedValue);
            Session[ENUM_THA_VUAN.SESSION_IDVUANHETHONG] = 0;
            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayXayra.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayXayra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Session[ENUM_THA_VUAN.SESSION_NGAYXAYRA] = date_temp;
            #endregion
        }

        private bool SaveDataVuAn()
        {
            decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oBiAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            decimal current_id = 0;
            string IDvuan = hddID.Value;
            if (oBiAn != null)
            {
                current_id = Convert.ToDecimal(oBiAn.VUANID);
            }
            else if (IDvuan != null)
            {
                current_id = Convert.ToDecimal(IDvuan);
            }
            else
            {
                current_id = Convert.ToDecimal(Request.QueryString["ID"]);
            }

            if (ddlGDXX.SelectedValue == "1")
            {
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                //DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => ( x.ID == 0 || x.ID != current_id) && x.BA_ST_SO == SoBA && x.BA_ST_NGAYBANAN == NgayBA && x.BA_ST_TOAANID == ToaAnRaBA).FirstOrDefault();
                if (oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    if (oBAST.TOAANID == Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = SoBA;
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = NgayBA;
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_chon_bian_BA()");
                    }
                    else
                    {
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                        lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở " + oTA.TEN + " . Vui lòng kiểm tra lại !";
                        return false;
                    }
                }
                else
                {
                    lstMsgT.Text = lstMsgB.Text = "";
                    SaveDataVuAn_CheckBanAn();
                }
            }
            else if (ddlGDXX.SelectedValue == "2")
            {
                string SoBAST = txtSoBAST.Text.ToString();
                DateTime NgayBAST = (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBAST = Convert.ToDecimal(hddToaAnIDST.Value);
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_PHUCTHAM_BANAN oBAPT = dt.AHS_PHUCTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBAST && x.NGAYBANAN == NgayBAST && x.TOAANID == ToaAnRaBAST).FirstOrDefault();

                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => (x.ID == 0 || x.ID != current_id) && x.BA_PT_SO == SoBA && x.BA_PT_NGAYBANAN == NgayBA && x.BA_PT_TOAANID == ToaAnRaBA && x.BA_ST_SO == SoBAST && x.BA_ST_NGAYBANAN == NgayBAST && x.BA_ST_TOAANID == ToaAnRaBAST).FirstOrDefault();
                if (oBAPT != null && oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    if (oBAST.TOAANID == Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_SO] = SoBAST;
                        Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN] = NgayBAST;
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_chon_bian_BA()");
                    }
                    else
                    {
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                        lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở " + oTA.TEN + " . Vui lòng kiểm tra lại !";
                        return false;
                    }
                }
                else
                {
                    lstMsgT.Text = lstMsgB.Text = "";
                    SaveDataVuAn_CheckBanAn();
                }

            }
            return true;
        }

        void SaveDataVuAn_CheckBanAn()
        {
            THA_VUAN oT;
            DateTime date_temp;
            Boolean IsUpdate = false;
            #region "THÔNG TIN vụ án"
            if (hddID.Value == "" || hddID.Value == "0")
                oT = new THA_VUAN();
            else
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                oT = dt.THA_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    IsUpdate = true;
            }
            decimal IDtoaraBA = Convert.ToDecimal(hddToaAnID.Value);
            if (ddlGDXX.SelectedValue == "2")
            {
                oT.BA_ST_SO = txtSoBAST.Text;
                oT.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLucST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLucST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_ST_TOAANID = Convert.ToDecimal(hddToaAnIDST.Value);

                oT.BA_PT_SO = txtSoBanAn.Text;
                oT.BA_PT_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_PT_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_PT_TOAANID = Convert.ToDecimal(hddToaAnID.Value);
            }
            else if (ddlGDXX.SelectedValue == "1")
            {
                oT.BA_ST_SO = txtSoBanAn.Text;
                oT.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_ST_TOAANID = Convert.ToDecimal(hddToaAnID.Value);
            }
            //----------------------------------
            oT.BA_TENVUAN = txtTenVuAn.Text.Trim();
            oT.BA_TINHCHAT = Convert.ToDecimal(dropTinhChatVuAn.SelectedValue);

            oT.ISHETHONG = Convert.ToDecimal(dropLoaiLuaChon.SelectedValue);
            oT.IDVUANHETHONG = 0;
            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayXayra.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayXayra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (date_temp != DateTime.MinValue)
            {
                oT.BA_NGAYVUAN = date_temp;
                oT.BA_THANG = Convert.ToDecimal(date_temp.Month);
                oT.BA_NAM = Convert.ToDecimal(date_temp.Year);
                //oT.GIOXAYRA = Convert.ToDecimal(dropGio.SelectedValue);
            }
            if (!IsUpdate)
            {
                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                THA_VUAN_BL dsBL = new THA_VUAN_BL();
                oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                oT.BA_MAVUAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBL.GETNEWTT((decimal)oT.TOAANID).ToString();
                //oT.TENVUAN = oT.MAVUAN;
                //oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_VUAN.Add(oT);
                dt.SaveChanges();
                //hddID.Value = oT.ID.ToString();
                Session[VuViecTemp] = oT.ID.ToString();
            }
            else
            {
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }

            hddID.Value = oT.ID.ToString();

            #endregion
            //Update_TenVuAn(oT);
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[VuViecTemp] = "";
            Decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            THA_BIAN biAn = dt.THA_BIAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            biAn.HOTENBO = "";
            biAn.HOTENME = "";
            biAn.SOCMND = "";
            biAn.TAMTRU = 0;
            biAn.TAMTRU_HUYEN = 0;
            biAn.HKTT = 0;
            biAn.HKTT_HUYEN = 0;
            biAn.KHTTCHITIET = "";
            biAn.TAMTRUCHITIET = "";
            biAn.NGAYTHAMGIA = (DateTime?)null;
            // validate truong ngay
            if (biAn.XACTHUC_DLDCQG != 1)
            {
                biAn.NGAYSINH = (DateTime?)null;
                biAn.NAMSINH = null;
                biAn.SOCCCD = null;
            }

            // xoa file MinIO
            if (biAn.QT_FILE_ID != null)
            {
                QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(biAn.QT_FILE_ID.Value);
                if (qtFileDelete != null)
                {
                    qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    fileH.DeleteFileLogic(qtFileDelete);
                    biAn.QT_FILE_ID = null;
                }
            }

            biAn.NGAYSUA = DateTime.Now;
            biAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            dt.SaveChanges();
            lstMsgT.Text = "Xóa thành công";
            ResetControls_BIAN_DA_DONGBO();
        }

        //protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    LoadCombobox();
        //}

        ////-----------------------------------
        void SetValue_OtherControl()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal BiCaoID = (String.IsNullOrEmpty(hddBiCaoID.Value)) ? 0 : Convert.ToDecimal(hddBiCaoID.Value);
            uDSBiCan.VuAnID = VuAnID;
            uDSBiCan.RemoveBiCaoID = BiCaoID;
            //-------------------
        }
        protected void ddlGDXX_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGDXX.SelectedValue == "1")
            {
                pnGDXX.Visible = false;
                lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                lbSoBanAn.Text = "Số bản án sơ thẩm";
                //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
            }
            if (ddlGDXX.SelectedValue == "2")
            {
                pnGDXX.Visible = true;
                lbNgayBanAn.Text = "Ngày bản án phúc thẩm";
                lbSoBanAn.Text = "Số bản án phúc thẩm";
                //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án phúc thẩm";
                lbToaAn.Text = "Tòa án ra bản án phúc thẩm";
            }
        }
        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            try
            {
                SetSessionDataVuAn();
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal toidanh_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                try
                {
                    xoatoidanh_bicandauvu(toidanh_id);
                }
                catch { }
            }
        }
        void xoatoidanh_bicandauvu(decimal toidanhid)
        {
            //decimal bicanid = Convert.ToDecimal(hddBiCanDauVuID.Value);
            decimal bicanid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal RootID = 0;
            List<THA_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            RootID = Convert.ToDecimal(tbl.Rows[0]["ArrSapXep"].ToString().Split('/')[1] + "");

            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID
                                                               && x.BICANID == bicanid
                                                               && x.TOIDANHID == toidanhid
                                                             ).ToList<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (THA_SOTHAM_CAOTRANG_DIEULUAT obj in lst)
                            dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            Load_ToiDanhBiCanDauvu(VuAnID);
            lstMsgT.Text = "Xóa thành công!";
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
        protected void cmdXoa_Click(object sender, ImageClickEventArgs e)
        {
            Decimal CurrID = Convert.ToDecimal(hddID.Value);
            decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oND = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            if (oND.QT_FILE_ID != null)
            {
                QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                if (qtFileDelete != null)
                {
                    qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                    QT_FILE_BL fileH = new QT_FILE_BL();
                    fileH.DeleteFileLogic(qtFileDelete);
                }
                oND.QT_FILE_ID = null;
                dt.SaveChanges();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Tệp đính kèm được xóa thành công!");
            }

            hddFilePath.Value = "";
            cmdXoa.Visible = false;
            lkFile.Visible = false;
            LoadThongTinVuAn(CurrID);

        }
        void UploadFile(THA_BIAN obj)
        {
            if (hddFilePath.Value != "")
            {
                string strFilePath = hddFilePath.Value.Replace("/", "\\");
                QT_FILE_BL fileHelper = new QT_FILE_BL();
                QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                if (qtFile == null)
                {
                    lstMsgT.Text = "Lỗi khi lưu file!";
                    return;
                }

                // Cập nhật QT_FILE_ID trực tiếp trên entity được track
                obj.QT_FILE_ID = qtFile.ID;

                /*                    File.Delete(strFilePath);*/
            }
        }



        protected void cmdLoadDsBiDonKhac_Click(object sender, EventArgs e)
        {
            hddVuAnID.Value = hddID.Value = Session[ENUM_THA_VUAN.SESSION_IDVUANTHA].ToString();
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            uDSBiCan.LoadGrid();
            Load_ToiDanhBiCanDauvu(VuAnID);
        }
        protected void cmdLoadSessionBiAn_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }

        private void LoadDropThuongTru_Huyen()
        {
            ddlThuongTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlThuongTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlThuongTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlThuongTru_Huyen.DataSource = lstHuyen;
                ddlThuongTru_Huyen.DataTextField = "TEN";
                ddlThuongTru_Huyen.DataValueField = "ID";
                ddlThuongTru_Huyen.DataBind();
            }
            ddlThuongTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen()
        {
            ddlTamTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlTamTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlTamTru_Huyen.DataSource = lstHuyen;
                ddlTamTru_Huyen.DataTextField = "TEN";
                ddlTamTru_Huyen.DataValueField = "ID";
                ddlTamTru_Huyen.DataBind();
            }
            ddlTamTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        protected void ddlThuongTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropThuongTru_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlThuongTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen();

                // fill giá trị từ Get037 về dropdownlist xã/huyện
                if (!string.IsNullOrEmpty(hidTamTru_Huyen.Value))
                {
                    var item = ddlTamTru_Huyen.Items.FindByValue(hidTamTru_Huyen.Value);
                    if (item != null)
                    {
                        ddlTamTru_Huyen.SelectedValue = hidTamTru_Huyen.Value;
                    }
                }

                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = ex.Message; }
        }


        protected void btnGet037ND_Click(object sender, EventArgs e)
        {

            string soDinhDanh = txtSoCCCD.Text.Trim();
            if (string.IsNullOrEmpty(soDinhDanh) )
            {
                string strMsg = "Vui lòng nhập Thẻ căn cước của Nguyên đơn!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return;
            }

            string NamSinh = txtNamSinh.Text.Trim();
            if (string.IsNullOrEmpty(NamSinh))
            {
                string strMsg = "Vui lòng nhập Năm sinh của Nguyên đơn!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return;
            }

            string HoTen = txtTenBiAnToiDanh.Text.Split('-')[0].Trim();
            if (string.IsNullOrEmpty(HoTen))
            {
                string strMsg = "Vui lòng nhập Họ và Tên của Nguyên đơn!";
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
            string don_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            string username = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var vLichSu = oBL.HistoryC06_CALL_API037(don_id, canBo.SOCMND, canBo.HOTEN, username, result);

            // Xử lý kết quả XML
            CongDan037 CongDan = ParseSoapResponse(result);
            if (CongDan == null)
            {
                string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return;
            }
            else
            {
                if (CongDan.HoVaTen.Ten == null)
                {
                    string strMsg = "Không tồn tại dữ liệu về Đương sự! Đề nghị kiểm tra lại Họ tên, CCCD, Năm sinh";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }

                //Nếu tồn tại dữ liệu thì khóa truong thong tin khong cho sua
                hdTrangThaiXacThucND.Value = "1";
                HienThiTrangThaiXacThucKhiKiemTra();
                Session.Remove("CongDan");
                Session["CongDan"] = CongDan;
                string StrMsg = "PopupCenter('/QLAN/THA/Hoso/Popup/pGetDuongSu037.aspx?caller=DuongSuND','Thông tin công dân từ hệ thống Cơ sở dữ liệu quốc gia về dân cư',850,700);";
                ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }

        }

        private CongDan037 ParseSoapResponse(string xml)
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

            return citizen;
        }

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
                UnicodeCategory uc = CharUnicodeInfo.GetUnicodeCategory(c);
                if (uc != UnicodeCategory.NonSpacingMark)
                {
                    sb.Append(c);
                }
            }

            string unsign = sb.ToString().Normalize(NormalizationForm.FormC);

            // Xóa tất cả ký tự không phải chữ và số
            unsign = Regex.Replace(unsign, @"[^a-zA-Z0-9]", "");

            return unsign.ToUpper();
        }

        private void HienThiTrangThaiXacThuc()
        {
            string trangThai = hdTrangThaiXacThucND.Value;

            switch (trangThai)
            {
                case "1":
                    lblTrangThaiXacThuc.Text = "Đã xác thực";
                    txtSoCCCD.ReadOnly = true;
                    txtSoCCCD.Enabled = false;
                    txtNamSinh.ReadOnly = true;
                    txtNamSinh.Enabled = false;
                    chkKhongCo.Enabled = false;
                    chkKhongCo.Checked = false; //bỏ check ô không có
                    chkKhongLamSachND.Enabled = false;
                    chkKhongLamSachND.Checked = false; //bỏ check ô Không thể làm sạch
                    btnKiemTra.Enabled = false;
                    Cls_Comon.SetButton(btnKiemTra, false);
                    break;

                case "0":
                    lblTrangThaiXacThuc.Text = "Chưa xác thực";
                    break;

                case "3":
                    lblTrangThaiXacThuc.Text = "Không thể làm sạch";
                    break;

                default:
                    lblTrangThaiXacThuc.Text = "Chưa xác thực";
                    break;
            }
        }

        private void HienThiTrangThaiXacThucKhiKiemTra()
        {
            string trangThai = hdTrangThaiXacThucND.Value;

            switch (trangThai)
            {
                case "1":
                    lblTrangThaiXacThuc.Text = "Đã xác thực";
                    txtSoCCCD.ReadOnly = true;
                    txtSoCCCD.Enabled = false;
                    txtNamSinh.ReadOnly = true;
                    txtNamSinh.Enabled = false;
                    chkKhongCo.Enabled = false;
                    chkKhongCo.Checked = false; //bỏ check ô không có
                    chkKhongLamSachND.Enabled = false;
                    chkKhongLamSachND.Checked = false; //bỏ check ô Không thể làm sạch
                    break;

                case "0":
                    lblTrangThaiXacThuc.Text = "Chưa xác thực";
                    break;

                case "3":
                    lblTrangThaiXacThuc.Text = "Không thể làm sạch";
                    break;

                default:
                    lblTrangThaiXacThuc.Text = "Chưa xác thực";
                    break;
            }
        }
    }
}