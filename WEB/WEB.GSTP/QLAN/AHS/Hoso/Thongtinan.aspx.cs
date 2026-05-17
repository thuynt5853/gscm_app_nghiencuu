using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.AHS.Hoso
{
    public partial class Thongtinan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        Decimal CurrUserID = 0;
        String VuViecTemp = "VuViecIDTemp";

        private void SetDonGhep()
        {
            string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (CurrUserID > 0)
                {
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    if (!IsPostBack)
                    {
                        SetDonGhep();
                        LoadCombobox();
                        string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                        string strtype = Request["type"] + "";
                        if (strtype != "list")
                        {
                            //Lay thong tin vuanid theo session
                            pnThuLy.Visible = false;
                            cmdQuaylai.Visible = cmdQuaylaiB.Visible = false;
                            cmdUpdateAndNew.Visible = cmdUpdateAndNewB.Visible = false;
                            cmdUpdateSelect.Visible = cmdUpdateSelectB.Visible = false;
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
                            else
                                pnThuLy.Visible = false;
                        }

                        Decimal CurrVuAnID = (String.IsNullOrEmpty(current_id + "")) ? 0 : Convert.ToDecimal(current_id);
                        if (CurrVuAnID > 0)
                        {
                            hddID.Value = CurrVuAnID.ToString();
                            LoadThongTinVuAn(Convert.ToDecimal(current_id));
                        }
                        CheckQuyen();
                    }
                    txtNgayBanCaoTrang.Attributes.Add("onblur", "Set_Date_NgayGiaoHS();");
                    SetValue_OtherControl();
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) { lstMsgT.Text = ex.Message; }
        }
        void LoadHSVuViecCuoiChuaNhapXong()
        {
            //Lay thong tin vu viec cuoi cung chua nhap xong (chua co bị can)
            AHS_VUAN_BL objVA = new AHS_VUAN_BL();
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
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
                pnThuLy.Visible = true;
                //SetNew_SoThuLy();// DateTime.Now);
                string current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                if (!String.IsNullOrEmpty(Session[VuViecTemp] + ""))
                {
                    current_id = Session[VuViecTemp].ToString();
                    hddID.Value = Session[VuViecTemp].ToString();

                    LoadThongTinVuAn(Convert.ToDecimal(current_id));
                }
            }
        }
        //void SetNew_SoThuLy(DateTime date)
        //{
        //    decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
        //    DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? date : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    try
        //    {
        //        AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
        //        decimal STT = obj.GETNEWTT(ToaAnID, NgayThuLy);
        //        txtSoThuLy.Text = STT.ToString();
        //    }
        //    catch { txtSoThuLy.Text = "1"; }
        //}

        void SetNew_SoThuLy()
        {
            try
            {
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
                if (String.IsNullOrEmpty(txtNgayThuLy.Text))
                    txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");

                DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //Số thụ lý mới
                txtSoThuLy.Text = oSTBL.GET_STL_NEW_HS(DonViID, "AHS", CheckThanhNien(), ngaythuly).ToString();
            }
            catch
            {
                
            }
        }
        private decimal CheckThanhNien()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.ISTHANHNIEN == 0)
            {
                return 2;
            }
            else
            {

                AHS_BICANBICAO dtBiCao = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                AHS_NGUOITHAMGIATOTUNG dtTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                if (dtBiCao != null || dtTGTT != null)
                {
                    return 1;
                }
                return 0;
            }
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdateVuAn, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateVuAnB, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateSelectB, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
            Cls_Comon.SetLinkButton(lkThemBiCao, oPer.CAPNHAT);
            Cls_Comon.SetLinkButton(lkThemNguoiTGTT, oPer.CAPNHAT);

            pnMaVuAn.Visible = false;
            if (hddID.Value != "" && hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                //  pnMaVuAn.Visible = true;
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                int ma_gd = (int)oT.MAGIAIDOAN;

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.DINHCHI && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }
                else if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM_QDK || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);

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
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;
                }

                //21/01/2026 check vụ án đã có bản án thì thông báo không cho sửa
                bool daCoBanAn = dt.AHS_SOTHAM_BANAN.Any(x => x.VUANID == ID);
                if (daCoBanAn)
                {
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc đã có bản án, không được sửa đổi!";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);

                    Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                    return;

                }
                if ((oT.TOA_GIAIQUYET_ID != null && oT.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])))
                {
                    //chỉ xem chi tiết
                    lstMsgT.Text = lstMsgB.Text = "Vụ việc được chuyển từ tòa cũ sau sát nhập không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateVuAn, false);
                    Cls_Comon.SetButton(cmdUpdateVuAnB, false);
                    Cls_Comon.SetButton(cmdUpdateSelect, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateSelectB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);

                    //Cls_Comon.SetLinkButton(lkThemBiCao, false);
                    //Cls_Comon.SetLinkButton(lkThemNguoiTGTT, false);
                }
                //----------------------
                //List<AHS_SOTHAM_BANAN> lstBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == ID).ToList();
                //if (lstBA != null && lstBA.Count() > 0)
                //    lkThemBiCao.Visible = lkThemNguoiTGTT.Visible = false;
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

                // check quyền để hiển thị nút thêm cho 2 bảng
                if (oT.TOA_GIAIQUYET_ID != null && oT.TOA_GIAIQUYET_ID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID]?.ToString())
                {
                    lkThemBiCao.Visible = false;
                    lkThemNguoiTGTT.Visible = false;
                }
                //----------------------------------
                if (oT.TRUONGHOPGIAONHAN == 270)
                {
                    try
                    {
                        List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.ID == oT.TRUONGHOPGIAONHAN).ToList();
                        dropTrangThaiGiaoNhan.Items.Clear();
                        dropTrangThaiGiaoNhan.DataSource = lstTHGN;
                        dropTrangThaiGiaoNhan.DataTextField = "TEN";
                        dropTrangThaiGiaoNhan.DataValueField = "ID";
                        dropTrangThaiGiaoNhan.DataBind();
                    }
                    catch (Exception ex) {
                        dropTrangThaiGiaoNhan.Items.Add(new ListItem("Xét xử lại cấp sơ thẩm", "270"));
                    }
                }
                else
                {
                    dropTrangThaiGiaoNhan.Items.Add(new ListItem("VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSGiaoHSXuSoTham));
                }

                dropTrangThaiGiaoNhan.SelectedValue = oT.TRUONGHOPGIAONHAN + "";

                txtSoBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                //txtNgayBanCaoTrang.Text = oT.SOBANCAOTRANG + "";
                //txtNgayBanCaoTrang.Text = (((DateTime)oT.NGAYBANCAOTRANG) == DateTime.MinValue) ? "" : ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);

                txtNgayBanCaoTrang.Text = oT.NGAYBANCAOTRANG + "" == "" ? "" : ((DateTime)oT.NGAYBANCAOTRANG).ToString("dd/MM/yyyy", cul);


                txtSoButLuc.Text = oT.SOBUTLUC + "";
                //txtNgayGiao.Text = (((DateTime)oT.NGAYGIAO) == DateTime.MinValue) ? "" : ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                txtNgayGiao.Text = oT.NGAYGIAO + "" == "" ? "" : ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                dropQuyetDinhTruyTo.SelectedValue = oT.QUYETDINHTRUYTO + "";
                //----------------------------------            
                dropLoaiToiPham.SelectedValue = oT.LOAITOIPHAMID + "";
                txtSoBiCanTamGiam.Text = oT.SOBICANTAMGIAM + "";
                txtSoBiCan.Text = oT.SOBICAN + "";
                txtNgayXayra.Text = oT.NGAYXAYRA + "" == "" ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);
                //txtNgayXayra.Text = (((DateTime)oT.NGAYXAYRA) == DateTime.MinValue) ? "" : ((DateTime)oT.NGAYXAYRA).ToString("dd/MM/yyyy", cul);


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
                Load_ToiDanhBiCanDauvu(VuAnID);
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
                else pnToiDanhChung.Visible = false;
            }
            else pnToiDanhChung.Visible = false;
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

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lkXoa.Visible = false;
                }

                int ma_gd = (String.IsNullOrEmpty(hddMaGiaiDoan.Value)) ? 0 : Convert.ToInt16(hddMaGiaiDoan.Value);
                // if (ma_gd != ENUM_GIAIDOANVUAN.HOSO)
                if (oT != null)
                    lkXoa.Visible = false;
                HiddenField hdBcID = (HiddenField)e.Item.FindControl("hdBcID");
                decimal bcID = Convert.ToDecimal(hdBcID.Value);
                AHS_BICANBICAO bc = dt.AHS_BICANBICAO.Where(x => x.ID == bcID).FirstOrDefault();
                if (bc.GDTAOHS == 1 || bc.GDTAOHS == 2) lkXoa.Visible = false;
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
            txtMaVuAn.Text = "";
            txtNgayBanCaoTrang.Text = txtNgayGiao.Text = txtNgayXayra.Text = "";
            txtSoBanCaoTrang.Text = txtSoBiCan.Text = txtSoBiCanTamGiam.Text = "";
            txtSoButLuc.Text = txtTenVuAn.Text = txtTenVuAnKhac.Text = "";

            pnlNoidung.Visible = false;
            ddlNoidung.SelectedIndex = 0;
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
            dropGio.Items.Clear();
            for (int i = 0; i < 24; i++)
            {
                if (i < 10)
                    dropGio.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
                else
                    dropGio.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
            ////--------------------------
            dropTrangThaiGiaoNhan.Items.Clear();
            dropTrangThaiGiaoNhan.Items.Add(new ListItem("VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSGiaoHSXuSoTham));
            //dropTrangThaiGiaoNhan.Items.Add(new ListItem("Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSChapNhanDieuTraBoSung));
            //dropTrangThaiGiaoNhan.Items.Add(new ListItem("Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung", ENUM_AHS_TRANGTHAIGIAONHAN_HS.VKSKoChapNhanDieuTraBoSung));

            //--------------------------------------------------           
            LoadDropByGroupName(dropLoaiToiPham, ENUM_DANHMUC.LOAITOIPHAM, false);
            LoadDropByGroupName(dropQuyetDinhTruyTo, ENUM_DANHMUC.QUYETDINHCAOTRANG, false);

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
                if (IDVuViec > 0)
                {
                    lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công!";
                    string para = (string.IsNullOrEmpty(Request["type"] + "")) ? "" : "&type=" + (Request["type"].ToString());
                    Response.Redirect("thongtinan.aspx?ID=" + IDVuViec + para);
                    //Hien ds Bi can + nut them bị can
                }
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công! Bạn hãy nhập thông tin vụ án tiếp theo !";
                txtSoBanCaoTrang.Focus();
            }
        }

        private bool SaveData()
        {
            try
            {
                if (!CheckValid())
                    return false;

                SaveDataVuAn();
                if (pnThuLy.Visible)
                {
                    if (rdThuLy.SelectedValue == "1")
                    {
                        if (!Save_ThuLy())
                        {
                            return false;
                        }
                    }
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
            if(rdThuLy.SelectedValue == "1")
            {
                if (!Regex.IsMatch(txtSoThuLy.Text, @"^\d"))
                {
                    lstMsgB.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                    return false;
                }
            }
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
            oT.TENKHAC = txtTenVuAnKhac.Text.Trim();
            oT.TRUONGHOPGIAONHAN = Convert.ToDecimal(dropTrangThaiGiaoNhan.SelectedValue);
            oT.SOBANCAOTRANG = txtSoBanCaoTrang.Text.Trim();
            oT.NGAYBANCAOTRANG = (String.IsNullOrEmpty(txtNgayBanCaoTrang.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanCaoTrang.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.SOBUTLUC = (string.IsNullOrEmpty(txtSoButLuc.Text.Trim())) ? 0 : Convert.ToDecimal(txtSoButLuc.Text.Trim());
            oT.NGAYGIAO = (String.IsNullOrEmpty(txtNgayGiao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.QUYETDINHTRUYTO = Convert.ToDecimal(dropQuyetDinhTruyTo.SelectedValue);
            //----------------------------------           
            oT.LOAITOIPHAMID = Convert.ToDecimal(dropLoaiToiPham.SelectedValue);
            //--------------------------------
            oT.SOBICANTAMGIAM = (string.IsNullOrEmpty(txtSoBiCanTamGiam.Text + "")) ? 0 : Convert.ToDecimal(txtSoBiCanTamGiam.Text);
            oT.SOBICAN = (string.IsNullOrEmpty(txtSoBiCan.Text + "")) ? 0 : Convert.ToDecimal(txtSoBiCan.Text);
            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayXayra.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayXayra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (date_temp != DateTime.MinValue)
            {
                oT.NGAYXAYRA = date_temp;
                oT.THANGXAYRA = Convert.ToDecimal(date_temp.Month);
                oT.NAMXAYRA = Convert.ToDecimal(date_temp.Year);
                oT.GIOXAYRA = Convert.ToInt16(dropGio.SelectedValue);
            }
            if (!IsUpdate)
            {
                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                ///oT.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                //oT.TENVUAN = oT.MAVUAN;
                oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHS_VUAN.Add(oT);
                dt.SaveChanges();
                //Sinh ma vu viec
                oT.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + "." + Session[ENUM_SESSION.SESSION_MADONVI] + "." + oT.ID.ToString();
                dt.SaveChanges();
                //hddID.Value = oT.ID.ToString();
                Session[VuViecTemp] = oT.ID.ToString();
                hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("1", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
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
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[VuViecTemp] = "";
            Response.Redirect("Danhsach.aspx");
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
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    lkThemBiCao.Enabled = false;
                    return;
                }
                SaveDataVuAn();
                if (pnThuLy.Visible)
                {
                    if (rdThuLy.SelectedValue == "1")
                    {
                        if(!Save_ThuLy())
                        {
                            return;
                        }
                    }
                }
                
                if (VuAnID > 0)
                {
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
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    lkThemNguoiTGTT.Enabled = false;
                    return;
                }
                SaveDataVuAn();
                if (pnThuLy.Visible)
                {
                    if (rdThuLy.SelectedValue == "1")
                    {
                        if (!Save_ThuLy())
                        {
                            return;
                        }
                    }
                }
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
        #region form them thu ly
        void LoadComponent_FormThuLy()
        {
            LoadDropByGroupName(ddTruongHopTL, ENUM_DANHMUC.TRUONGHOPTHULYAN, false);
        }
        void LoadDropNoidung()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NOIDUNGTHULYXXL);

            ddlNoidung.Items.Clear();
            ddlNoidung.DataSource = tbl;
            ddlNoidung.DataTextField = "TEN";
            ddlNoidung.DataValueField = "ID";
            ddlNoidung.DataBind();
            ddlNoidung.Items.Insert(0, new ListItem("--------Chọn--------", "0"));
        }
        void Check_ThuLy()
        {
            decimal VuAnID = (String.IsNullOrEmpty(hddID.Value + "")) ? 0 : Convert.ToDecimal(hddID.Value);
            AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
            DataTable tbl = obj.GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
                rdThuLy.SelectedValue = "1";
        }
        protected void rdThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdThuLy.SelectedValue == "1")
            {
                pnEditThuLy.Visible = true;
                LoadComponent_FormThuLy();
                LoadDropNoidung();
            }
            else pnEditThuLy.Visible = false;
        }
        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            try
            {
                txtTuNgay.Text = txtNgayThuLy.Text;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]), LoaiToiPhamID = 0;
                DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                // số thụ lý
                SetNew_SoThuLy();
                //----------------------------------
                AHS_VUAN vuan = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                if (vuan != null)
                    LoaiToiPhamID = vuan.LOAITOIPHAMID + "" == "" ? 0 : (decimal)vuan.LOAITOIPHAMID;

                DM_DATAITEM dmLoaiToiPham = dt.DM_DATAITEM.Where(x => x.ID == LoaiToiPhamID && x.HIEULUC == 1).FirstOrDefault<DM_DATAITEM>();
                if (dmLoaiToiPham != null)
                {
                    if (NgayThuLy != DateTime.MinValue)
                    {
                        txtDenNgay.Enabled = false;
                        switch (dmLoaiToiPham.MA)
                        {
                            case ENUM_AHS_LOAITOIPHAM.IT_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddDays(30)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddDays(45)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.RAT_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddMonths(2)).ToString("dd/MM/yyyy", cul);
                                break;
                            case ENUM_AHS_LOAITOIPHAM.DACBIET_NGHIEMTRONG:
                                txtDenNgay.Text = (NgayThuLy.AddMonths(3)).ToString("dd/MM/yyyy", cul);
                                break;
                            default:
                                //chưa xac dinh--> cho phep thay doi
                                txtDenNgay.Enabled = true;
                                break;
                        }
                    }
                    else
                    {
                        //chưa xac dinh--> cho phep thay doi
                        txtDenNgay.Enabled = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lstMsgB.Text = ex.Message;
            }
        }
        protected void ddTruongHopTL_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddTruongHopTL.SelectedValue == "233")
            {
                // Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung
                pnTTCaoTrang.Visible = true;
            }
            else
                pnTTCaoTrang.Visible = false;
            if (ddTruongHopTL.SelectedValue == "236" || ddTruongHopTL.SelectedValue == "1777")
            {
                pnlNoidung.Visible = true;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else
            {
                pnlNoidung.Visible = false;
            }
        }
        protected void ddlNoidung_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNoidung.SelectedValue == "2244")// Nội dung khác
            {
                pnlGhichu.Visible = true;
                txtGhichu.Text = "";
            }
            else
            {
                pnlGhichu.Visible = false;
                txtGhichu.Text = "";
            }
        }
        protected bool Save_ThuLy()
        {
            if (!CheckValidate_ThuLy())
            {
                return false;
            }
            else
            {
                ThemThuLyHS();
                return true;
            }

        }
        void ThemThuLyHS()
        {
            Decimal VuAnId = Convert.ToDecimal(hddID.Value);
            Boolean IsNew = false;
            AHS_SOTHAM_THULY obj = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnId).FirstOrDefault<AHS_SOTHAM_THULY>();
            if (obj == null)
            {
                obj = new AHS_SOTHAM_THULY();
                IsNew = true;
            }

            obj.VUANID = VuAnId;
            obj.TRUONGHOPTHULY = Convert.ToDecimal(ddTruongHopTL.SelectedValue);
            obj.SOTHULY = txtSoThuLy.Text.Trim();

            if (ddTruongHopTL.SelectedValue == "236" || ddTruongHopTL.SelectedValue == "1777")//Thụ lý xx lại
            {
                pnlNoidung.Visible = true;
                if (ddlNoidung.SelectedIndex > 0)
                {
                    obj.NOIDUNGTLXXLAI = Convert.ToDecimal(ddlNoidung.SelectedValue);
                    if (ddlNoidung.SelectedValue == "2244")
                    {
                        pnlGhichu.Visible = true;
                        obj.GHICHUKHAC = txtGhichu.Text.Trim();
                    }
                    else
                    {
                        pnlGhichu.Visible = false;
                        obj.GHICHUKHAC = "";
                    }
                }
                else
                {
                    obj.NOIDUNGTLXXLAI = null;
                    obj.GHICHUKHAC = "";
                }
            }
            else
            {
                pnlNoidung.Visible = false;
                obj.NOIDUNGTLXXLAI = null;
                obj.GHICHUKHAC = "";
            }

            //-----------------------------------------
            obj.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.THOIHANTUNGAY = obj.NGAYTHULY;
            obj.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //-----------------------------------------
            if (ddTruongHopTL.SelectedValue == "233")// Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung
            {
                obj.SOBANCAOTRANG = txtThuLy_SoCaoTrang.Text;
                obj.NGAYBANCAOTRANG = txtThuLy_NgayCaoTrang.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuLy_NgayCaoTrang.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            }
            if (IsNew)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                // update insert toa_gq
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHS_SOTHAM_THULY.Add(obj);
                // update giai đoạn vụ án
                AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnId).FirstOrDefault<AHS_VUAN>();
                if (objAn != null)
                {
                    objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    objAn.NGAYSUA = DateTime.Now;
                    objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
            }
            dt.SaveChanges();
            lstMsgB.Text = "Lưu dữ liệu thành công!";
        }
        private bool CheckValidate_ThuLy()
        {
            if (ddTruongHopTL.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn 'Trường hợp thụ lý'. Hãy kiểm tra lại!";
                ddTruongHopTL.Focus();
                return false;
            }
            else if (ddTruongHopTL.SelectedValue == "233")
            {
                int lenghtSoBanCaoTrang = txtSoBanCaoTrang.Text.Trim().Length;
                if (lenghtSoBanCaoTrang == 0)
                {
                    lstMsgB.Text = "Bạn chưa nhập số bản cáo trạng. Hãy kiểm tra lại!";
                    txtSoBanCaoTrang.Focus();
                    return false;
                }
                else if (lenghtSoBanCaoTrang > 250)
                {
                    lstMsgB.Text = "Số bản cáo trạng không quá 250 ký tự. Hãy kiểm tra lại!";
                    txtSoBanCaoTrang.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgayBanCaoTrang.Text) == false)
                {
                    lstMsgB.Text = "Bạn phải nhập ngày bản cáo trạng theo định dạng (dd/MM/yyyy)!";
                    txtNgayBanCaoTrang.Focus();
                    return false;
                }
            }
            if (Cls_Comon.IsValidDate(txtNgayThuLy.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy)!";
                txtNgayThuLy.Focus();
                return false;
            }
            DateTime NgayThuLy = DateTime.Parse(txtNgayThuLy.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (DateTime.Compare(DateTime.Now, NgayThuLy) < 0)
            {
                lstMsgB.Text = "Ngày thụ lý phải nhỏ hơn ngày hiện tại!";
                txtNgayThuLy.Focus();
                return false;
            }
            if(txtSoThuLy.Text.Length == 0)
            {
                lstMsgB.Text = "Bạn chưa nhập số thụ lý!";
                txtSoThuLy.Focus();
                return false;
            }
            string sothuly = txtSoThuLy.Text;
            if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS", CheckThanhNien(), sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS", CheckThanhNien(), ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        strMsg = "Số thụ lý " + txtSoThuLy.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuLy.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuLy.Focus();
                        return false;
                    }
                }
            }

            return true;
        }
        #endregion

        protected void cmdLoadDsBiDonKhac_Click(object sender, EventArgs e)
        {
            uDSBiCao.LoadGrid();
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            Load_ToiDanhBiCanDauvu(VuAnID);

            AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == VuAnID).Single();
            int loaitoipham = (String.IsNullOrEmpty(obj.LOAITOIPHAMID + "")) ? 0 : (int)obj.LOAITOIPHAMID;
            if (loaitoipham > 0)
                dropLoaiToiPham.SelectedValue = loaitoipham.ToString();
        }
        protected void cmdLoadDsNguoiTGTT_Click(object sender, EventArgs e)
        {
            uDSNguoiThamGiaToTung.LoadGrid();
        }

        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal toidanh_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lstMsgT.Text = lstMsgB.Text = Result;
                    return;
                }
                try
                {
                    xoatoidanh_bicandauvu(toidanh_id);
                }
                catch { }
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

            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
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

    }
}
