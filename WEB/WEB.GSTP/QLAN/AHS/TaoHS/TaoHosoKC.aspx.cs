
using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.TaoHS
{
    public partial class TaoHosoKC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        public decimal QuocTichVN = 0;
        Decimal CurrUserID = 0; 
        String usercurent = "";
        String VuViecTemp = "VuViecIDTemp";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                usercurent = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (CurrUserID > 0)
                {
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    if (!IsPostBack)
                    {
                        LoadCombobox();
                        pnBanan.Visible = true;
                        pnQD.Visible = false;
                        string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                        string strtype = Request["type"] + "";
                        if (strtype != "list")
                        {
                            //Lay thong tin vuanid theo session
                           
                            //cmdQuaylai.Visible = cmdQuaylaiB.Visible = false;
                            //cmdUpdateAndNew.Visible = cmdUpdateAndNewB.Visible = false;
                            //cmdUpdateSelect.Visible = cmdUpdateSelectB.Visible = false;
                        }
                        else
                        {
                            Session[ENUM_LOAIAN.AN_HINHSU] = "0";
                            //Edit du lieu chon tu ds
                            current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                            if ((Session[ENUM_LOAIAN.AN_HINHSU].ToString() == "0") && (strtype != "") && (current_id == ""))
                            {
                                LoadHSVuViecCuoiChuaNhapXong();
                            }
                        }

                        Decimal CurrVuAnID = (String.IsNullOrEmpty(current_id + "")) ? 0 : Convert.ToDecimal(current_id);
                        if (CurrVuAnID > 0)
                        {
                            hddID.Value = CurrVuAnID.ToString();
                            LoadThongTinVuAn(Convert.ToDecimal(current_id));
                        }
                        SetValue_OtherControl();
                        //CheckQuyen();
                        AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == CurrVuAnID).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
                        if (oTLPT.ID > 0)
                        {
                            Cls_Comon.SetButton(cmdUpdateVuAn, false);
                            Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                            Cls_Comon.SetLinkButton(lkThemBiCao, false);
                            Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                            Cls_Comon.SetButton(cmXoa, false);
                            Cls_Comon.SetButton(btnUpdate, false);

                            return;
                        }
                    }


                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) { 
                lstMsgT.Text = ENUM_MESSAGE.SERVER_ERROR;
                // ghi log file
                logger.Error("loi xay ra: " + ex);
            }
        }
        void LoadHSVuViecCuoiChuaNhapXong()
        {
            //Lay thong tin vu viec cuoi cung chua nhap xong (chua co bị can)
            AHS_VUAN_BL objVA = new AHS_VUAN_BL();
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] +"";
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            DataTable tbl = objVA.GetLastHsVuAnNotComlete(ToaAnID, curr_user);
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
        
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdateVuAn, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateVuAnB, oPer.CAPNHAT);
            Cls_Comon.SetLinkButton(lkThemBiCao, oPer.CAPNHAT);
            Cls_Comon.SetLinkButton(lkThemNguoiTGTT, oPer.CAPNHAT);

            
            if (hddID.Value != "" && hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                //  pnMaVuAn.Visible = true;
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                int ma_gd = (int)oT.MAGIAIDOAN;
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.DINHCHI)
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                  
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }
                else if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    

                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                   
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }
                //----------------------
                List<AHS_SOTHAM_BANAN> lstBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == ID).ToList();
                if (lstBA != null && lstBA.Count() > 0)
                    lkThemBiCao.Visible = lkThemNguoiTGTT.Visible = false;
            }
        }
        private void LoadThongTinVuAn(decimal VuAnID)
        {
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                rdbLoaiBAQD.Enabled = false;
                hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //Load thong  tin BA/QD
                AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault() ?? new AHS_SOTHAM_BANAN();
                if (oBA.ID > 0)
                {
                    rdbLoaiBAQD.SelectedValue = "1";
                    txtSobanan.Text = oBA.SOBANAN;
                    txtNgayBA.Text = (((DateTime)oBA.NGAYBANAN) == DateTime.MinValue) ? "" : ((DateTime)oBA.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    pnBanan.Visible = true;
                    pnQD.Visible = false;
                }
                else
                {
                    AHS_SOTHAM_QUYETDINH_VUAN oQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).FirstOrDefault() ?? new AHS_SOTHAM_QUYETDINH_VUAN();
                    if (oQD.ID > 0)
                    {
                        rdbLoaiBAQD.SelectedValue = "0";
                        ddlQuyetdinh.SelectedValue = oQD.QUYETDINHID.ToString();
                        txtSoQD.Text = oQD.SOQUYETDINH;
                        txtNgayQD.Text = (((DateTime)oQD.NGAYQD) == DateTime.MinValue) ? "" : ((DateTime)oQD.NGAYQD).ToString("dd/MM/yyyy", cul);
                        pnBanan.Visible = false;
                        pnQD.Visible = true;
                    }
                }

                ddlToaxxST.SelectedValue = oT.TOAANID.ToString();
                txtTenVuAn.Text = oT.TENVUAN;
                
                //-------------------
                AHS_BICANBICAO_BL objBC = new AHS_BICANBICAO_BL();
                DataTable tbl = objBC.CountBiCaoTheoTinhTrangGiamGiu(VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    Decimal Count = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        if ((row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.TAMGIAM) || (row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.DANGTAMGIAM_VUANKHAC))
                        {
                            Count += Convert.ToDecimal(row["SoBiCao"] + "");
                        }
                    }
                }
                //------------------------------------
                Load_ToiDanhBiCanDauvu(VuAnID);

                //Load drop Duong su và Ban an, QĐ
                LoadComboboxKhangCao(VuAnID);
                LoadComboboxKhangNghi();
                LoadGrid();
                //Load thong tin nhan don
                AHS_CHUYEN_NHAN_AN oCN = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_CHUYEN_NHAN_AN>();
                if (oCN != null)
                {
                    ddlNguoinhanHS.SelectedValue = oCN.NGUOINHANID.ToString();
                    txtNgayNhanHS.Text = (((DateTime)oCN.NGAYNHAN) == DateTime.MinValue) ? "" : ((DateTime)oCN.NGAYNHAN).ToString("dd/MM/yyyy", cul);
                    txtSoButLuc.Text = oCN.SOBUTLUC.ToString();
                }
                ddlThuly.SelectedIndex = Convert.ToInt16(oT.TRUONGHOPTHULY);
                if(oT.TRUONGHOPTHULY == 1) //Nếu thụ lý lại thì ẩn kháng cáo kháng nghị
                {
                    pnKhangCao.Visible = false;
                    btnUpdate.Visible = false;
                    lastPanel.Visible = false;
                    cmdUpdateVuAnB.Visible = false;
                }
                else if(oT.TRUONGHOPTHULY == 0)
                {
                    pnKhangCao.Visible = true;
                    btnUpdate.Visible = true;
                    lastPanel.Visible = true;
                    cmdUpdateVuAnB.Visible = true;
                }
            }
        }

        private void FillYeuCau(decimal ID, decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                        foreach (AHS_SOTHAM_KHANGCAO_YEUCAU obj in lst)
                        {
                            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                                item.Selected = true;
                        }
                    }
                }
            }
            else // Kháng nghị
            {
                List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKN.Items)
                    {
                        item.Selected = false;
                        foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU obj in lst)
                        {
                            if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                            { item.Selected = true; }
                        }
                    }
                }
            }
        }
        void Load_ToiDanhBiCanDauvu(Decimal VuAnID)
        {
            Decimal BiCanDauVuID = 0;
            List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).ToList<AHS_BICANBICAO>();
            if (lst != null && lst.Count > 0)
            {
                BiCanDauVuID = Convert.ToDecimal(lst[0].ID + "");
                hddBiCanDauVuID.Value = lst[0].ID.ToString();

                AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
                DataTable tbl = objBL.GetAllToiDanhByBiCan(BiCanDauVuID, VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptToiDanh.DataSource = tbl;
                    rptToiDanh.DataBind();
                    pnToiDanhChung.Visible = true;
                }
                //else pnToiDanhChung.Visible = false;
            }
            //else pnToiDanhChung.Visible = false;
        }
        protected void rptToiDanh_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            AHS_SOTHAM_THULY oT = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == ID).FirstOrDefault();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                int ma_gd = (String.IsNullOrEmpty(hddMaGiaiDoan.Value)) ? 0 : Convert.ToInt16(hddMaGiaiDoan.Value);
                // if (ma_gd != ENUM_GIAIDOANVUAN.HOSO)
                if (oT != null)
                    lkXoa.Visible = false;
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
            txtTenVuAn.Text = "";

            hddID.Value = "0";

            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            Load_ToiDanhBiCanDauvu(VuAnID);
            uDSBiCao.VuAnID = 0;
            uDSBiCao.LoadGrid();

            uDSNguoiThamGiaToTung.VuAnID = 0;
            uDSNguoiThamGiaToTung.LoadGrid();
        }
        private void LoadCombobox()
        {
            ////--------------------------------------------------           
            //LoadDropByGroupName(dropLoaiToiPham, ENUM_DANHMUC.LOAITOIPHAM, false);
            //LoadDropByGroupName(dropQuyetDinhTruyTo, ENUM_DANHMUC.QUYETDINHCAOTRANG, false);

            ddlToaxxST.Items.Clear();
            
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            ddlToaxxST.DataSource = oBL.DM_TOAAN_GETBY_PARENT("3", Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            //ddlToaxxST.DataSource = oBL.dm
            ddlToaxxST.DataTextField = "arrTEN";
            ddlToaxxST.DataValueField = "ID";
            ddlToaxxST.DataBind();
            ddlToaxxST.Items.Insert(0, new ListItem("--- Chọn Tòa xét xử Sơ Thẩm ---", "0"));
            ddlToaxxST.SelectedValue = "0";
            string current_Donid = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            ddlToaxxST.Items.Remove(ddlToaxxST.Items.FindByValue(current_Donid));

            //---Load ra Quyết định Vụ án
            // Quyết định bắt tạm giam không hiển thị ở quyết định vụ án (ISDUONGSUYEUCAU=1)
            decimal LoaiQD = 0;
            DM_QD_LOAI objLoaiQD = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHINHSU == 1 && x.MA == "DC").FirstOrDefault();
            if (objLoaiQD != null)
            {
                LoaiQD = objLoaiQD.ID;
            }
            ddlQuyetdinh.Items.Clear();
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD && x.ISHINHSU == 1 && x.ISSOTHAM == 1).OrderBy(y => y.TEN).ToList();
            if (lst != null && lst.Count > 0)
            {
                ddlQuyetdinh.DataSource = lst;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }
            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;

            //Load Nguoi nhan HS 
            //
            LoadDrop_TTV_TK();
            //Load ds bi can 
            Load_ListBiCan();

            LoadQD_BAKhangCao();
            // Load yêu cầu
            LoadCheckListYeuCau(KHANGCAO);

            LoadComboboxKhangNghi();

        }
        protected void LoadDrop_TTV_TK()
        {
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.GET_ThuKy_TTVS_CV(ToaAnID.ToString());
            ddlNguoinhanHS.DataSource = tbl;
            ddlNguoinhanHS.DataTextField = "MA_TEN";
            ddlNguoinhanHS.DataValueField = "ID";
            ddlNguoinhanHS.DataBind();
            ddlNguoinhanHS.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        private void LoadCheckListYeuCau(decimal isKhangCao)
        {
            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            if (isKhangCao == KHANGCAO)
            {
                DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    chkYeuCauKC.DataSource = tbl;
                    chkYeuCauKC.DataTextField = "TEN";
                    chkYeuCauKC.DataValueField = "ID";
                    chkYeuCauKC.DataBind();
                }
            }
            else
            {
                DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKNHINHSU);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    chkYeuCauKN.DataSource = tbl;
                    chkYeuCauKN.DataTextField = "TEN";
                    chkYeuCauKN.DataValueField = "ID";
                    chkYeuCauKN.DataBind();
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
        protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        {
            cmdUpdateVuAn_Click(sender, e);
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                //Lưu vào người dùng
                decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                {
                    oNSD.IDAHINHSU = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công!";
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
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
                    oNSD.IDAHINHSU = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công!";

                //Load thong tin BA/QD và bị cao
                LoadComboboxKhangCao(IDVuViec);
                LoadComboboxKhangNghi();
            }
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

        private bool SaveData()
        {
            try
            {
               decimal VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
               
                SaveDataVuAn();
                //Save_BAQD();
                if (VuAnID > 0)
                {
                    
                    //Luu thong tin Bản án Quyết định
                    if (rdbLoaiBAQD.SelectedValue == "1")
                        UpdateBanAn(VuAnID);
                    else
                        UpdateQuyetDinh(VuAnID);
                    //lưu Tội danh cáo trang
                    AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).First() ?? new AHS_SOTHAM_BANAN();
                    if(oBA!=null)
                        InsertToiDanhTuCaoTrangSangBanAnSoTham(oBA.ID);
                    // Lưu thông tin chuyển nhận án
                    Chuyenan_Nhanan(VuAnID);
                    //Lưu thông tin kháng cáo kháng nghị
                    if(ddlThuly.SelectedIndex == 0)
                        UpdateKhangCaoKN(VuAnID);
                }   
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (ddlThuly.SelectedIndex == 0) // Nếu thụ lý mới thì được lưu kháng cáo
            {
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                UpdateKhangCaoKN(IDVuViec);
                dgList.CurrentPageIndex = 0;
                lbthongbao.Text = "Lưu thành công!";
                //Load thong tin vào combo KC KN
                LoadComboboxKhangCao(IDVuViec);
                LoadComboboxKhangNghi();
                ResetControlsKCKN();
                LoadGrid();

            }
        }
        protected void cmXoa_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            string strDonviTao = Session[ENUM_SESSION.SESSION_USERNAME] +"";
            //Kiem tra neu chua Thu ly Phuc tham và Hồ sơ do Tòa cấp cao nhập thi cho xóa Hồ sơ án sơ thẩm
            //myClass.Where(x => (x.MyOtherObject == null) ? false : x.MyOtherObject.Name == "Name").ToList();
            AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == ID).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
            if (oTLPT.ID == 0)
            {
                AHS_VUAN oVa = dt.AHS_VUAN.Where(x => x.ID == ID).First();
                if (oVa != null)
                {

                    //AHS_VUAN oVaN = dt.AHS_VUAN.Where(x => x.ID == ID && x.NGUOITAO == strDonviTao).FirstOrDefault();
                    //if (oVa.NGUOITAO == usercurent)
                    //{
                        XoaHoSo(ID);
                        //Hủy ghim
                        Session[VuViecTemp] = "";
                        decimal IDVuViec = 0;
                        //Lưu vào người dùng
                        decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                        if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                        {
                            oNSD.IDAHINHSU = IDVuViec;
                            dt.SaveChanges();
                        }
                        Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //}
                }
            }
            
        }
        public void XoaHoSo( decimal ID)
        {
            
            // thực hiện việc xóa toàn bộ hồ sơ Sơ thẩm mình tạo khi chưa nhập các thông tin của án Phúc Thẩm
            AHS_VUAN_BL oBL = new AHS_VUAN_BL();
            if (oBL.DELETE_ALLDATA_BY_VUANID(ID + "") == true)
            {
                //Xóa thông tin Giai đoan
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GIAIDOAN_DELETES("1", ID,2);
            }

        }
        public void xoaNTDTT(decimal id)
        {
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.AHS_NGUOITHAMGIATOTUNG.Remove(oND);
                List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == id).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (lst != null && lst.Count > 0)
                { dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.RemoveRange(lst); }
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadGrid();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa thành công!");
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControlsKCKN();
        }
        private void ResetControlsKCKN()
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = true;
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())//
            {
                #region Kháng cáo
                rdbLoaiNguoiKC.SelectedValue = "0";
                //txtNgayvietdonKC.Text = "";
                txtNgaykhangcao.Text = "";
                ddlNguoikhangcao.SelectedIndex = 0;
                rdbLoaiKC.SelectedValue = "0";
                rdbQuahan_KC.SelectedValue = "0";
                LoadQD_BAKhangCao();
                txtNoidungKC.Text = "";
                if (chkYeuCauKC.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        item.Selected = false;
                    }
                }
                hddKCID.Value = "0";

                #endregion
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())
            {
                #region Kháng nghị
                txtSokhangnghi.Text = txtNgaykhangnghi.Text = "";
                rdbCapkhangnghi.SelectedValue = "1";
                rdbLoaiKN.SelectedValue = "0";
                LoadQD_BA_InfoKhangNghi();
                txtNoidungKN.Text = "";
                if (chkYeuCauKN.Items.Count > 0)
                {
                    foreach (ListItem item in chkYeuCauKN.Items)
                    {
                        item.Selected = false;
                    }
                }
                hddKNID.Value = "0";

                #endregion
            }
        }
        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SOTHAM_KCaoKNghi_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int Total = Convert.ToInt32(oDT.Rows.Count), pageSize = 20;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
              
                #endregion
                //dgList.PageSize = pageSize;
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
           
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ID = 0, IsKhangCao = 0;
                string StrPara = "";
                StrPara = e.CommandArgument.ToString();
                if (StrPara.Contains(";#"))
                {
                    string[] arr = StrPara.Split(';');
                    ID = Convert.ToDecimal(arr[0] + "");
                    IsKhangCao = Convert.ToDecimal(arr[1].Replace("#", "") + "");
                }
                switch (e.CommandName)
                {
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        //string StrMsg = "Không được sửa đổi thông tin.";
                        //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(Convert.ToDecimal(hddID.Value), StrMsg);
                        //if (Result != "")
                        //{
                        //    lbthongbao.Text = Result;
                        //    return;
                        //}
                        decimal vvuanid = Convert.ToDecimal(hddID.Value);
                        AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == vvuanid).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
                        if (oTLPT.ID > 0)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        xoa(ID, IsKhangCao);
                        hddKCID.Value = hddKNID.Value = "0";
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void xoa(decimal ID, decimal IsKhangCao)
        {
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                AHS_SOTHAM_KHANGCAO oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHS_SOTHAM_KHANGCAO.Remove(oND);
                    List<AHS_SOTHAM_KHANGCAO_YEUCAU> listKcyc = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                    if (listKcyc != null && listKcyc.Count > 0)
                    {
                        dt.AHS_SOTHAM_KHANGCAO_YEUCAU.RemoveRange(listKcyc);
                    }
                }
            }
            else // Kháng nghị
            {
                AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHS_SOTHAM_KHANGNGHI.Remove(oND);
                    List<AHS_SOTHAM_KHANGNGHI_YEUCAU> listKNyc = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                    if (listKNyc != null && listKNyc.Count > 0)
                    {
                        dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.RemoveRange(listKNyc);
                    }
                }
            }
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControlsKCKN();
            lbthongbao.Text = "Xóa thành công!";
        }
        void UpdateKhangCaoKN(decimal VuAnID)
        {
            decimal ID = 0, IsKhangCao = 0;
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())// Kháng cáo
            {
                IsKhangCao = KHANGCAO;
                if (!CheckValid(IsKhangCao)) return;
                AHS_SOTHAM_KHANGCAO oND;
                if (hddKCID.Value == "" || hddKCID.Value == "0")
                {
                    oND = new AHS_SOTHAM_KHANGCAO();
                    if (rdbQuahan_KC.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }
                }
                else
                {
                    ID = Convert.ToDecimal(hddKCID.Value);
                    oND = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.VUANID = VuAnID;
                oND.NGUOIKCLOAI = Convert.ToDecimal(rdbLoaiNguoiKC.SelectedValue);
                //oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdonKC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdonKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGUOIKCID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oVuAn.TOAANID;
                oND.NOIDUNGKHANGCAO = txtNoidungKC.Text;
               
                if (hddKCID.Value == "" || hddKCID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_KHANGCAO.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                }
                dt.SaveChanges();
                ID = oND.ID;
                hddKCID.Value ="0";
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())// Kháng nghị
            {
                IsKhangCao = KHANGNGHI;
                if (!CheckValid(IsKhangCao)) return;

                AHS_SOTHAM_KHANGNGHI oND;
                if (hddKNID.Value == "" || hddKNID.Value == "0")
                    oND = new AHS_SOTHAM_KHANGNGHI();
                else
                {
                    ID = Convert.ToDecimal(hddKNID.Value);
                    oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.VUANID = VuAnID;
                oND.SOKN = txtSokhangnghi.Text;
                oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                oND.LOAIKN = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                oND.BANANID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oVuAn.TOAANID;
                oND.NOIDUNGKN = txtNoidungKN.Text;
                if (trDVKN.Visible)
                    oND.TOAAN_VKS_KN = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                
                if (hddKNID.Value == "" || hddKNID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_KHANGNGHI.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                }
                dt.SaveChanges();
                ID = oND.ID;
                hddKNID.Value = "0";
            }
            // Lưu thông tin chuyển nhận án
            Chuyenan_Nhanan(VuAnID);
            // Update yêu cầu
            UpdateYeuCau(ID, IsKhangCao);
            rdbLoaiNguoiKC.SelectedValue = "0";
            rdbQuahan_KC.SelectedValue = "0";
        }
        private bool CheckValid(decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                if(!checkHinhPhat())
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập hình phạt!";
                    return false; 
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
                {
                    lstMsgT.Text = lstMsgB.Text = "Ngày kháng cáo chưa nhập hoặc không theo định dạng 'ngày/ tháng/ năm'!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                if (ddlNguoikhangcao.SelectedValue == "0")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn người kháng cáo!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }
                if (rdbLoaiKC.SelectedValue == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn loại kháng cáo. Hãy kiểm tra lại!";
                    return false;
                }
                if (ddlSOQDBA_KC.SelectedValue == "0")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn Số QĐ/BA!";
                    ddlSOQDBA_KC.Focus();
                    return false;
                }
                if (rdbQuahan_KC.SelectedValue == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Mục 'Kháng cáo quá hạn' cần được chọn. Hãy kiểm tra lại!";
                    return false;
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
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng cáo!";
                    return false;
                }
                //if (txtNoidungKC.Text == "")
                //{
                //    lbthongbao.Text = "Bạn chưa nhập nội dung kháng cáo.";
                //    return false;
                //}
                //Kiểm tra ngày kháng cáo
                DateTime dNgayKC = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC > DateTime.Now)
                {
                    lstMsgT.Text = lstMsgB.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại !";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                DateTime dNgayQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (rdbLoaiKC.SelectedValue == "0")//Bản án
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Ngày kháng cáo không được lớn hơn ngày bản án !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }
                }
            }
            else// Kháng nghị
            {
                if (txtSokhangnghi.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập số kháng nghị!";
                    txtSokhangnghi.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
                {
                    lstMsgT.Text = lstMsgB.Text = "Ngày kháng nghị chưa nhập hoặc không hợp lệ!";
                    txtNgaykhangnghi.Focus();
                    return false;
                }
                if (rdbCapkhangnghi.SelectedValue == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn cấp kháng nghị!";
                    return false;
                }
                if (rdbLoaiKN.SelectedValue == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn loại kháng nghị!";
                    return false;
                }
                if (ddlSOQDBAKhangNghi.SelectedValue == "0")
                {
                    lstMsgT.Text = lstMsgB.Text = "Chưa chọn Số QĐ/BA";
                    return false;
                }
                if (txtNoidungKN.Text.Trim().Length > 1000)
                {
                    lstMsgT.Text = lstMsgB.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                    txtNoidungKN.Focus();
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
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng nghị!";
                    return false;
                }
                if (txtNoidungKN.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập nội dung kháng nghị.";
                    return false;
                }
            }
            return true;
        }

        protected bool checkHinhPhat()
        {
            try
            {
                decimal VUANID = Convert.ToDecimal(hddID.Value);
                //Manh Kiem tra neu chua nhap hinh phat cho bi cao thi khong cho chuyen an
                List<AHS_BICANBICAO> LstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VUANID).ToList();
                AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
                for (int i = 0; i < LstBC.Count; i++)
                {
                    try
                    {
                        decimal vcount = 0;
                        decimal vBicaoid = Convert.ToDecimal(LstBC[i].ID);
                        List<AHS_SOTHAM_BANAN_DIEU_CHITIET> tbl = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VUANID && x.BICANID == vBicaoid).ToList();

                        if (tbl.Count > 0)
                        {
                            for (int j = 0; j < tbl.Count; j++)
                            {
                                if (tbl[j].HINHPHATID > 0)
                                    vcount++;
                            }
                            if (vcount == 0)
                            {
                                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập hình phạt cho bị cáo!";
                                return false;
                            }
                        }
                        else
                        {
                            lstMsgT.Text = lstMsgB.Text = "Bạn chưa chưa nhập hình phạt cho bị cáo!";
                            return false;
                        }
                    }
                    catch (Exception ex)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa chưa nhập hình phạt cho bị cáo!";
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = "Lỗi: " + ex.Message;
            }
            return true;
        }
        private void UpdateYeuCau(decimal ID, decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)
            {
                AHS_SOTHAM_KHANGCAO_YEUCAU obj = null;
                // lấy ra tất cả các yêu cầu cũ
                string StrKhangCaoYC = "|";
                if (ID > 0)
                {
                    List<AHS_SOTHAM_KHANGCAO_YEUCAU> lst = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID).ToList<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_KHANGCAO_YEUCAU item in lst)
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
                                obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.KHANGCAOID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGCAO_YEUCAU>();
                                if (obj != null)
                                {
                                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
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
                            obj = new AHS_SOTHAM_KHANGCAO_YEUCAU();
                            obj.KHANGCAOID = ID;
                            obj.YEUCAUID = Convert.ToDecimal(item.Value);
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                            obj.NGAYTAO = DateTime.Now;
                            dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Add(obj);
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
                            obj = dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                            if (obj != null)
                            {
                                dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Remove(obj);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
            else
            {
                AHS_SOTHAM_KHANGNGHI_YEUCAU obj = null;
                // lấy ra tất cả các yêu cầu cũ
                string StrKhangCaoYC = "|";
                if (ID > 0)
                {
                    List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU item in lst)
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
                                obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == ID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                                if (obj != null)
                                {
                                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
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
                            obj = new AHS_SOTHAM_KHANGNGHI_YEUCAU();
                            obj.KHANGNGHIID = ID;
                            obj.YEUCAUID = Convert.ToDecimal(item.Value);
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                            obj.NGAYTAO = DateTime.Now;
                            dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Add(obj);
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
                            obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                            if (obj != null)
                            {
                                dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Remove(obj);
                                dt.SaveChanges();
                            }
                        }
                    }
                }
            }
        }
        private bool CheckValid()
        {
            //KT: yeu cau nhap bi can dau vu
            decimal VuAnID = ((string.IsNullOrEmpty(hddID.Value)) || (hddID.Value == "0")) ? 0 : Convert.ToDecimal(hddID.Value);

            try
            {
                AHS_BICANBICAO obj = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single<AHS_BICANBICAO>();
                if (obj == null)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can đầu vụ cho vụ án!");
                    Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                    return false;
                }
            }
            catch (Exception ex)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can đầu vụ cho vụ án!");
                Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                return false;
            }
            return true;
        }
        void SaveDataVuAn()
        {
            AHS_VUAN oT;
            DateTime date_temp;
            Boolean IsUpdate = false;
            #region "THÔNG TIN vụ án"
            if (hddID.Value == "" || hddID.Value == "0")
                oT = new DAL.GSTP.AHS_VUAN();
            else
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    IsUpdate = true;
            }
            //----------------------------------
            oT.TENVUAN = txtTenVuAn.Text.Trim();

            oT.TRUONGHOPTHULY = ddlThuly.SelectedIndex;
            //--------------------------------
           
            if (!IsUpdate)
            {
                //Luu ID Tòa án xét xử Sơ thẩm
                oT.TOAANID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                string donvitao = ddlToaxxST.SelectedValue;
                oT.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + donvitao + oT.TT.ToString();
                //oT.TENVUAN = oT.MAVUAN;
                oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                oT.GDTAOHS = 2;
                oT.TOAANID_GDTAOHS = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                dt.AHS_VUAN.Add(oT);
                dt.SaveChanges();
                //hddID.Value = oT.ID.ToString();
                Session[VuViecTemp] = oT.ID.ToString();
                hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                // Sơ tham cap tỉnh là 3 cấp huyện là 2
                // Là thụ lý KC/KN mới insert Mã giai đoạn sơ thẩm
                if(ddlThuly.SelectedIndex == 0)
                    GD.GAIDOAN_INSERT_UPDATE("1", oT.ID, 2, Convert.ToDecimal(ddlToaxxST.SelectedValue), 0, 0, 0, 0);
            }
            else
            {
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                dt.SaveChanges();
            }
            hddID.Value = oT.ID.ToString();
            Session[ENUM_LOAIAN.AN_HINHSU] = oT.ID.ToString();
            #endregion
            //Update_TenVuAn(oT);
        }
        void Update_TenVuAn(AHS_VUAN obj)
        {
            AHS_SOTHAM_CAOTRANG_DIEULUAT objTD = null;
            String TenVuAn = "";
            AHS_BICANBICAO objBiCao;
            decimal VuAnID = Convert.ToDecimal(hddID.Value);

            decimal currID = 0, currToiDanhID = 0;
            String tentoidanh = "";
            //-------------------------
            try
            {
                int count_tt = 0;
                Decimal BiCanDauVuID = (hddBiCanDauVuID.Value == "") ? 0 : Convert.ToDecimal(hddBiCanDauVuID.Value);
                objBiCao = dt.AHS_BICANBICAO.Where(x => x.VUANID == obj.ID
                                                     && x.BICANDAUVU == 1).Single<AHS_BICANBICAO>();
                if (objBiCao != null)
                {
                    BiCanDauVuID = objBiCao.ID;
                    TenVuAn = objBiCao.HOTEN;
                }
                try
                {

                    foreach (RepeaterItem item in rptToiDanh.Items)
                    {
                        currID = 0;
                        count_tt++;

                        HiddenField hddCurrID = (HiddenField)item.FindControl("hddCurrID");
                        HiddenField hddLoaiToiPham = (HiddenField)item.FindControl("hddLoaiToiPham");

                        TextBox txtTenToiDanh = (TextBox)item.FindControl("txtTenToiDanh");
                        HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                        HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
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
                            else tentoidanh = txtTenToiDanh.Text.Trim();

                            if (count_tt == 1)
                            {
                                //Update ten vu an
                                TenVuAn += " - " + tentoidanh;
                                obj.TENVUAN = TenVuAn;
                                obj.LOAITOIPHAMID = Convert.ToInt16(hddLoaiToiPham.Value);
                                dt.SaveChanges();
                            }

                            //Update bang SoTham_CaoTrang_DieuLuat                            
                            objTD = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == currID
                                                                            && x.VUANID == VuAnID
                                                                            && x.BICANID == BiCanDauVuID).FirstOrDefault();
                            if (objTD != null)
                            {
                                objTD.TENTOIDANH = tentoidanh;
                                objTD.ISMAIN = (count_tt == 1) ? 1 : 0;
                                dt.SaveChanges();
                            }
                        }
                    }

                }
                catch (Exception ex) { }
                //---------------------------------
                AHS_BICANBICAO_BL objBC = new AHS_BICANBICAO_BL();
                DataTable tbl = objBC.CountBiCaoTheoTinhTrangGiamGiu(VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    obj.SOBICAN = Convert.ToDecimal(tbl.Rows[0]["CountAll"] + "");

                    Decimal Count = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        if ((row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.TAMGIAM) || (row["TinhtrangGiamGiuID"].ToString() == ENUM_TINHTRANGGIAMGIU.DANGTAMGIAM_VUANKHAC))
                        {
                            Count += Convert.ToDecimal(row["SoBiCao"] + "");
                        }
                    }
                    obj.SOBICANTAMGIAM = Count;
                }
                dt.SaveChanges();
                
            }
            catch (Exception ex)
            {
                //obj.TENVUAN = obj.TENKHAC;
                //dt.SaveChanges();
            }
        }
        void UpdateBanAn( decimal VuAnId)
        {
            Boolean IsUpdate = false;
            DateTime date_temp;


            AHS_SOTHAM_BANAN obj = new AHS_SOTHAM_BANAN();
            if (VuAnId > 0)
            {
                obj = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new AHS_SOTHAM_BANAN();
            }
            else
                obj = new AHS_SOTHAM_BANAN();

            obj.VUANID = VuAnId;
            //-----------------------------------------   
            date_temp = (String.IsNullOrEmpty(txtNgayBA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYBANAN = date_temp;

            //-----------------------------------------           
            
            obj.NGAYMOPHIENTOA = null;
            //-----------------------------------------
            Decimal ToaAnID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            obj.TOAANID = ToaAnID;
            obj.SOBANAN = txtSobanan.Text.Trim();
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                // insert toa_gq_id
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                hddBAQDID.Value = obj.ID + "";
            }
            
        }
        void InsertToiDanhTuCaoTrangSangBanAnSoTham(decimal BanAnID)
        {
            Boolean IsUpdate = false;
            AHS_SOTHAM_BANAN_DIEU_CHITIET BaDieuCT;
            AHS_SOTHAM_BANAN_BICAO Ba_BC;
            Decimal BiCaoID = 0;
            decimal VuAnID = Convert.ToDecimal(hddID.Value);

            AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Decimal DieuLuatID = 0, ToiDanhId = 0, HinhPhatID = 0,  LoaiHinhPhat = 0;
                foreach (DataRow row in tbl.Rows)
                {
                    BiCaoID = (string.IsNullOrEmpty(row["BiCanID"] + "")) ? 0 : Convert.ToDecimal(row["BiCanID"] + "");
                    DieuLuatID = (string.IsNullOrEmpty(row["BoLuatID"] + "")) ? 0 : Convert.ToDecimal(row["BoLuatID"] + "");
                    ToiDanhId = (string.IsNullOrEmpty(row["ToiDanhID"] + "")) ? 0 : Convert.ToDecimal(row["ToiDanhID"] + "");
                    //-----------------------------------------------
                    #region Update Vao BanAn_BiCao
                    IsUpdate = false;

                    Ba_BC = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID && x.BICAOID == BiCaoID).SingleOrDefault<AHS_SOTHAM_BANAN_BICAO>();
                    if (Ba_BC != null)
                        IsUpdate = true;
                    else
                        Ba_BC = new AHS_SOTHAM_BANAN_BICAO();

                    Ba_BC.BANANID = BanAnID;
                    Ba_BC.BICAOID = BiCaoID;

                    if (!IsUpdate)
                    {
                        // insert toa_gq_id
                        if (Ba_BC.TOA_GIAIQUYET_ID == null)
                        {
                            Ba_BC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        dt.AHS_SOTHAM_BANAN_BICAO.Add(Ba_BC);
                        dt.SaveChanges();
                    }

                    #endregion
                    //------------------------------------------------
                    #region Update BAnAn_Dieu_ChiTiet  
                    IsUpdate = false;
                    BaDieuCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID
                                                                       && x.BICANID == BiCaoID
                                                                       && x.DIEULUATID == DieuLuatID
                                                                       && x.TOIDANHID == ToiDanhId
                                                                    ).FirstOrDefault<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (BaDieuCT != null)
                        IsUpdate = true;
                    else
                        BaDieuCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();

                    if (!(BaDieuCT.HINHPHATID != 0 && BaDieuCT.LOAIHINHPHAT != 0) || !(BaDieuCT.HINHPHATID != null && BaDieuCT.LOAIHINHPHAT != null)) // Nếu là phải tội danh chính
                    {
                        BaDieuCT.BANANID = BanAnID;
                        BaDieuCT.BICANID = BiCaoID;
                        BaDieuCT.DIEULUATID = DieuLuatID;
                        BaDieuCT.HINHPHATID = HinhPhatID;
                        BaDieuCT.LOAIHINHPHAT = LoaiHinhPhat;
                        BaDieuCT.TOIDANHID = ToiDanhId;
                        BaDieuCT.VUANID = VuAnID;
                        BaDieuCT.ISCHANGE = 0;
                        BaDieuCT.TENTOIDANH = row["TenToiDanh"] + "";
                        BaDieuCT.ISMAIN = String.IsNullOrEmpty(row["IsMain"] + "") ? 0 : Convert.ToInt16(row["IsMain"] + "");
                        switch (Convert.ToInt16(BaDieuCT.LOAIHINHPHAT))
                        {
                            case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                                BaDieuCT.TF_VALUE = 0;
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                                BaDieuCT.SH_VALUE = 0;
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                                BaDieuCT.TG_NGAY = 0;
                                BaDieuCT.TG_THANG = 0;
                                BaDieuCT.TG_NAM = 0;
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                                BaDieuCT.K_VALUE1 = 0;
                                BaDieuCT.K_VALUE2 = "";
                                break;
                        }
                    }

                    //BaDieuCT.BANANID = BanAnID;
                    //BaDieuCT.ISCHANGE = 0;
                    //BaDieuCT.BICANID = BiCaoID;
                    //BaDieuCT.DIEULUATID = DieuLuatID;
                    //BaDieuCT.HINHPHATID = HinhPhatID;
                    //BaDieuCT.LOAIHINHPHAT = LoaiHinhPhat;
                    //BaDieuCT.TOIDANHID = ToiDanhId;

                    //BaDieuCT.VUANID = VuAnID;
                    //switch (Convert.ToInt16(BaDieuCT.LOAIHINHPHAT))
                    //{
                    //    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    //        BaDieuCT.TF_VALUE = 0;
                    //        break;
                    //    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    //        BaDieuCT.SH_VALUE = 0;
                    //        break;
                    //    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    //        BaDieuCT.TG_NGAY = 0;
                    //        BaDieuCT.TG_THANG = 0;
                    //        BaDieuCT.TG_NAM = 0;
                    //        break;
                    //    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    //        BaDieuCT.K_VALUE1 = 0;
                    //        BaDieuCT.K_VALUE2 = "";
                    //        break;
                    //}
                    if (!IsUpdate)
                    {
                        dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(BaDieuCT);
                        dt.SaveChanges();
                    }
                    #endregion
                }
            }
        }
        void UpdateQuyetDinh(decimal VuAnId)
        {
            Boolean IsUpdate = false;
            AHS_SOTHAM_QUYETDINH_VUAN oND = new AHS_SOTHAM_QUYETDINH_VUAN();
            if (VuAnId > 0)
            {
                oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_SOTHAM_QUYETDINH_VUAN>();
                if (oND != null)
                    IsUpdate = true;
                else
                    oND = new AHS_SOTHAM_QUYETDINH_VUAN();
            }
            else
                oND = new AHS_SOTHAM_QUYETDINH_VUAN();

            try
            {
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                if (objQD != null)
                    oND.LOAIQDID = objQD.LOAIID;
            }
            catch (Exception ex) { }
       
            oND.LOAIDONVI = 0;
            oND.DONVIID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            oND.SOQUYETDINH = txtSoQD.Text;
            oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
             
            if (IsUpdate)
            {
                oND.NGAYSUA = DateTime.Now;
                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                oND.NGAYTAO = DateTime.Now;
                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                // insert toa_gq_id
                if (oND.TOA_GIAIQUYET_ID == null)
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_QUYETDINH_VUAN.Add(oND);
                dt.SaveChanges();
            }
            hddBAQDID.Value = oND.ID + "";
        }

        void Chuyenan_Nhanan(decimal VuAnID)
        {
            //Chuyen và nhận án luôn
            Boolean IsUpdate = false;
            AHS_CHUYEN_NHAN_AN oND = new AHS_CHUYEN_NHAN_AN();
          
            if (VuAnID > 0)
            {
                oND = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_CHUYEN_NHAN_AN>();
                if (oND != null)
                    IsUpdate = true;
                else
                    oND = new AHS_CHUYEN_NHAN_AN();
            }
            else
                oND = new AHS_CHUYEN_NHAN_AN();

            oND.VUANID = VuAnID;
            oND.TOACHUYENID = Convert.ToDecimal(ddlToaxxST.SelectedValue);
            oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            oND.TOANHANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            oND.NGAYGIAO = DateTime.Now;
            oND.NGAYNHAN = DateTime.Now;
            oND.NGUOINHANID = Convert.ToDecimal(ddlNguoinhanHS.SelectedValue);
            oND.SOBUTLUC = (string.IsNullOrEmpty(txtSoButLuc.Text.Trim())) ? 0 : Convert.ToDecimal(txtSoButLuc.Text.Trim());
            //-----------------------------
            DM_DATAGROUP oG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();
            AHS_SOTHAM_KHANGCAO oKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SOTHAM_KHANGCAO>();
            AHS_SOTHAM_KHANGNGHI oKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SOTHAM_KHANGNGHI>();
            if (oKC != null && oKN != null)
                oND.TRUONGHOPGIAONHANID = 268; //Do khang cao va kn phuc tham
            else if (oKC != null && oKN == null)
                oND.TRUONGHOPGIAONHANID = 267; //Do khang cao phuc tham
            else if (oKC == null && oKN != null)
                oND.TRUONGHOPGIAONHANID = 269; //do khang nghi  phuc tham
            else if (ddlThuly.SelectedIndex == 1)
                oND.TRUONGHOPGIAONHANID = 998; // ko có kháng cáo kháng nghị //do giám đốc thẩm hủy để xx lại phúc thẩm
            else
                oND.TRUONGHOPGIAONHANID = 0;


           
            oND.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
            oND.NGAYTAO = DateTime.Now;
            if (!IsUpdate)
            {
                if (oND.TOA_GIAIQUYET_ID == null)
                {
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_CHUYEN_NHAN_AN.Add(oND);
            }
            dt.SaveChanges();

            //Nhan an thì update lại Mã giai đoạn
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            oVuAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
            oVuAn.TOAPHUCTHAMID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            
            dt.SaveChanges();

            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
            if (ddlThuly.SelectedIndex == 1)
                GD.GAIDOAN_INSERT_UPDATE_XXLAI_PHUCTHAM("1", VuAnID, 3, Convert.ToDecimal(ddlToaxxST.SelectedValue), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
            else
                GD.GAIDOAN_INSERT_UPDATE("1", VuAnID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[VuViecTemp] = "";
            Response.Redirect("Danhsach.aspx");
        }

        protected void rdbLoaiBAQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoaiBAQD.SelectedValue == "1")
            {
                pnQD.Visible = false;
                pnBanan.Visible = true;
            }
            else
            {
                pnQD.Visible = true;
                pnBanan.Visible = false;
            }
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }

        //-----------------------------------
        void SetValue_OtherControl()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal BiCaoID = (String.IsNullOrEmpty(hddBiCaoID.Value)) ? 0 : Convert.ToDecimal(hddBiCaoID.Value);
            uDSBiCao.VuAnID = VuAnID;
            uDSBiCao.RemoveBiCaoID = BiCaoID;
            //-------------------
            uDSNguoiThamGiaToTung.VuAnID = VuAnID;
        }

        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                string StrMsg = "Không được sửa đổi thông tin.";
                
                // lưu thông tin vụ án
                SaveDataVuAn();

                VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                if (VuAnID > 0)
                {
                    //Luu thong tin Bản án Quyết định
                    if (rdbLoaiBAQD.SelectedValue == "1")
                        UpdateBanAn(VuAnID);
                    else
                        UpdateQuyetDinh(VuAnID);
                    // Lưu thông tin chuyển nhận án
                    Chuyenan_Nhanan(VuAnID);
                    //load thông tin Bản án Quyết định
                    LoadComboboxKhangCao(VuAnID);
                    LoadComboboxKhangNghi();
                    //Goi phần Tạo Bị cáo
                    uDSBiCao.VuAnID = VuAnID;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_bc(" + VuAnID + ")");
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void lkThemNguoiTGTT_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                string StrMsg = "Không được sửa đổi thông tin.";
               
                SaveDataVuAn();

                VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                if (VuAnID > 0)
                {
                    uDSNguoiThamGiaToTung.VuAnID = VuAnID;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_NguoiTGTT(" + VuAnID + ")");
                    //Response.Redirect("thongtinan.aspx?type=list&ID=" + hddID.Value);

                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }
      
        protected void rdBAQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoaiBAQD.SelectedValue == "1")
            {
                pnBanan.Visible = true;
                pnQD.Visible = false;
            }
            else
            {
                pnBanan.Visible = false;
                pnQD.Visible = true;
            }
        }

        protected void cmdLoadDsBiDonKhac_Click(object sender, EventArgs e)
        {
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            uDSBiCao.VuAnID = VuAnID;
            uDSBiCao.LoadGrid();
            
            Load_ToiDanhBiCanDauvu(VuAnID);
        }
        protected void cmdLoadDsNguoiTGTT_Click(object sender, EventArgs e)
        {
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            uDSNguoiThamGiaToTung.VuAnID = VuAnID;
            uDSNguoiThamGiaToTung.LoadGrid();
        }

        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal toidanh_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                decimal vvuanid = Convert.ToDecimal(hddID.Value);
                AHS_PHUCTHAM_THULY oTLPT = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == vvuanid).FirstOrDefault() ?? new AHS_PHUCTHAM_THULY();
                if (oTLPT.ID > 0)
                {
                    lbthongbao.Text = "Bạn không có quyền xóa!";
                    return;
                }
                xoatoidanh_bicandauvu(toidanh_id);
            }
        }
        void xoatoidanh_bicandauvu(decimal toidanhid)
        {
            decimal bicanid = Convert.ToDecimal(hddBiCanDauVuID.Value);
            decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal RootID = 0;
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            RootID = Convert.ToDecimal(tbl.Rows[0]["ArrSapXep"].ToString().Split('/')[1] + "");
            //---------Xoa Hinh phat chi tiet----------
            List < AHS_SOTHAM_BANAN_DIEU_CHITIET > lstHinhPhatCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VuAnID
                                                                                                           && x.BICANID == bicanid
                                                                                                           && x.TOIDANHID == toidanhid
                                                                                                      ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
            if (lstHinhPhatCT != null && lstHinhPhatCT.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET objNC in lstHinhPhatCT)
                    dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(objNC);
            }
            foreach (DataRow row in tbl.Rows)
            {
                //toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID
                                                               && x.BICANID == bicanid
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
            Load_ToiDanhBiCanDauvu(VuAnID);
            lstMsgT.Text = lstMsgB.Text = "Xóa thành công!";
        }
        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // Kháng nghị
            {
                rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }
        }
        protected void ddlThuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlThuly.SelectedIndex == 0)
            {
                pnKhangCao.Visible = true;
                btnUpdate.Visible = true;
                lastPanel.Visible = true;
                cmdUpdateVuAnB.Visible = true;
                //cmdUpdateVuAn.Visible = true;
                //cmdUpdateVuAnThuLylai.Visible = false;
            }
            else
            {
                pnKhangCao.Visible = false;
                btnUpdate.Visible = false;
                lastPanel.Visible = false;
                cmdUpdateVuAnB.Visible = false;
                //cmdUpdateVuAn.Visible = false;
                //cmdUpdateVuAnThuLylai.Visible = true;
            }
        }
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            if (rdbPanelKN.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKC.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
                LoadComboboxKhangCao(Convert.ToDecimal(hddID.Value));
            }
            else if(rdbPanelKN.SelectedValue == KHANGNGHI.ToString()) // Kháng nghị
            {
                rdbPanelKC.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
                LoadComboboxKhangNghi();
            }
        }

        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BAKhangNghi(); } catch (Exception ex) {  }
        }

        private void LoadComboboxKhangNghi()
        {
            LoadQD_BAKhangNghi();
            // Load yêu cầu
            LoadCheckListYeuCau(KHANGNGHI);
        }
        private void LoadQD_BAKhangNghi()
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            if (rdbLoaiKN.SelectedValue == "0")
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, VuAnID);
            else
                LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBAKhangNghi, VuAnID);
            LoadQD_BA_InfoKhangNghi();
        }
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_InfoKhangNghi();
        }
        protected void ddlSOQDBA_KC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadQD_BA_InfoKhangCao();
            }
            catch (Exception ex) {}
        }
        protected void rdbLoaiNguoiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            switch (loai)
            {
                case 0:
                    Load_ListBiCan();
                    break;
                case 1:
                    Load_ListNguoiThamGiaToTung();
                    break;
            }
        }

        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadQD_BAKhangCao();
            }
            catch (Exception ex) {  }
        }
        void Load_ListBiCan()
        {
            ddlNguoikhangcao.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(Convert.ToDecimal(hddID.Value));
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void Load_ListNguoiThamGiaToTung()
        {
            ddlNguoikhangcao.Items.Clear();

            decimal vuanid = 0;
            if (hddID.Value != null)
                vuanid = Convert.ToDecimal(hddID.Value);
            List<AHS_NGUOITHAMGIATOTUNG> lst = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == vuanid).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_NGUOITHAMGIATOTUNG item in lst)
                    ddlNguoikhangcao.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
        }

        private void LoadQD_BAKhangCao()
        {
            int loai = 0;
            ddlSOQDBA_KC.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
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
                    LoadDrop_ST_QuyetDinhVuAn(ddlSOQDBA_KC, VuAnID);
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
            decimal VuAnID = Convert.ToDecimal(hddID.Value); 
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
        void LoadDrop_ST_BanAn(DropDownList drop, Decimal VuAnID)
        {
            try
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
                else
                    drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            catch { }
        }
        void LoadDrop_ST_QuyetDinhVuAn(DropDownList drop, Decimal VuAnID)
        {
            AHS_SOTHAM_BL objBL = new AHS_SOTHAM_BL();
            DataTable tblQD = objBL.AHS_ST_QD_VUAN_GETLIST(VuAnID);
            if (tblQD != null && tblQD.Rows.Count > 0)
            {
                foreach (DataRow row in tblQD.Rows)
                {
                    //temp = row["SOQUYETDINH"].ToString() + " - " + row["TENQD"].ToString();
                    drop.Items.Add(new ListItem(row["SOQUYETDINH"].ToString(), row["ID"].ToString()));
                }
            }
            else
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

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
            decimal VuAnID = Convert.ToDecimal(hddID.Value); 
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

        private void LoadComboboxKhangCao( decimal VuAnID)
        {
            //Load ds bi can 
            Load_ListBiCan(VuAnID);

            LoadQD_BAKhangCao();
            // Load yêu cầu
            LoadCheckListYeuCau(KHANGCAO);
        }
        void Load_ListBiCan(decimal VuAnID)
        {
            ddlNguoikhangcao.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
    }
}  
