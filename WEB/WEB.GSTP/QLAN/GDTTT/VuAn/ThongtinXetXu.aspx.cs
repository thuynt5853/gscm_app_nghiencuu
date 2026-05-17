using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.BANGSETGET.GDTTT;
using BL.GSTP.GDTTT;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class ThongtinXetXu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    if (Request["ID"] != null)
                    {
                        hddVuAnID.Value = Request["ID"] + "";

                        Load_Type_DHXX();
                        LoadThongTinVuAn();
                        LoadDropKetQuaXX();
                        LoadDS_XXGDTTT();
                        LoadDSHoiDongTP_DaChon();
                        check_luu_ketqua();
                        Check_visible_Button();
                        //Load an le
                        LoadAnLe();
                        CheckCongbo();
                    }
                }
            }
            else
                Response.Redirect("/Login.aspx");
            ////////////////
        }
        void Load_Type_DHXX()
        {
            rdChonHD.Items.Clear();
            if (CurrDonViID == 1)
            {
                rdChonHD.Items.Add(new ListItem("Hội đồng TT", "1"));
                rdChonHD.Items.Add(new ListItem("Hội đồng 5", "2"));
                rdChonHD.SelectedValue = "2";
            }
            else
            {
                rdChonHD.Items.Add(new ListItem("Hội đồng TT", "1"));
                rdChonHD.Items.Add(new ListItem("Hội đồng 3", "2"));
                rdChonHD.SelectedValue = "2";
            }
        }
        public void check_luu_ketqua()
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Int32 obj_xx = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == CurrVuAnID && x.ISHOAN == 0).Count<GDTTT_VUAN_XETXUGDTTT>();
            if (obj_xx > 0)
            {
                cmdUpdateKQ.Enabled = false;
                cmdUpdateKQ.CssClass = "buttonprintdisable";
            }
            else
            {
                cmdUpdateKQ.Enabled = true;
                cmdUpdateKQ.CssClass = "buttoninput";
            }
        }
        void Check_visible_Button()
        {
            //Kiem tra vu an da có ket qua chưa
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Int32 obj_xx = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == CurrVuAnID && x.ISHOAN == 0).Count<GDTTT_VUAN_XETXUGDTTT>();
            if (obj_xx > 0)
            {
                //Đóng them ket qua 
                cmdUpdateKQ.Enabled = false;
                cmdUpdateKQ.CssClass = "buttonprintdisable";
                //Đóng thêm Hội đồng xét xử 
                cmdUpdateLichXX.Enabled = cmdXoa_LichXX.Enabled = false;
                cmdUpdateLichXX.CssClass = cmdXoa_LichXX.CssClass = "buttonprintdisable";
                //Đóng Thụ lý xét xử Giam doc tham
                cmdUpdateTLXX.Enabled = cmdXoaTLXX.Enabled = false;
                cmdUpdateTLXX.CssClass = cmdXoaTLXX.CssClass = "buttonprintdisable";
            }
            else
            {  //Mơ thêm mơi kêt quả
                cmdUpdateKQ.Enabled = true;
                cmdUpdateKQ.CssClass = "buttoninput";
                //Kiểm tra xem có hoãn phiên tòa không
                Int32 obj_hoanxx = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == CurrVuAnID && x.ISHOAN == 1).Count<GDTTT_VUAN_XETXUGDTTT>();
                if (obj_hoanxx > 0)
                {
                    cmdUpdateLichXX.Enabled = true;
                    cmdUpdateLichXX.CssClass = "buttoninput";
                    //Đóng Xóa Hội đồng xét xử 
                    cmdXoa_LichXX.Enabled = false;
                    cmdXoa_LichXX.CssClass = "buttonprintdisable";
                    //Đóng Thụ lý xét xử Giam doc tham
                    cmdUpdateTLXX.Enabled = cmdXoaTLXX.Enabled = false;
                    cmdUpdateTLXX.CssClass = cmdXoaTLXX.CssClass = "buttonprintdisable";
                }
                else
                {
                    //Chưa có kết quả xét xử
                    //Chưa có Lịch phiên tòa thì cho xóa Thụ lý xét xử Giam doc tham
                    GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).FirstOrDefault();
                    if (oVA.NGAYLICHGDT != null && oVA.NGAYLICHGDT != DateTime.MinValue)
                    {
                        cmdXoaTLXX.Enabled = false;
                        cmdXoaTLXX.CssClass = "buttonprintdisable";
                        //mo nut cap nhat ket qua Thu ly xet xu 
                        cmdUpdateTLXX.Enabled = true;
                        cmdUpdateTLXX.CssClass = "buttoninput";
                        //Mo nut cap nhat, xoa Lich xet xu
                        cmdUpdateLichXX.Enabled = cmdXoa_LichXX.Enabled = true;
                        cmdUpdateLichXX.CssClass = cmdXoa_LichXX.CssClass = "buttoninput";
                    }
                    else
                    {
                        //Đóng thêm Hội đồng xét xử 
                        cmdUpdateLichXX.Enabled = cmdXoa_LichXX.Enabled = true;
                        cmdUpdateLichXX.CssClass = cmdXoa_LichXX.CssClass = "buttoninput";
                        //Đóng Thụ lý xét xử Giam doc tham
                        cmdUpdateTLXX.Enabled = cmdXoaTLXX.Enabled = true;
                        cmdUpdateTLXX.CssClass = cmdXoaTLXX.CssClass = "buttoninput";
                    }

                }
                //Kiem tra xem có thông tin Lịch xé xử chưa

            }


        }
        void LoadDrop()
        {
            LoadDropNGuoiKy_VKS();
            LoadAllChuToa();
            LoadDropLanhDao();
            LoadDropTTV();
            LoadDropDaiDienVuGDKT();
        }
        void LoadDropKetQuaXX()
        {
            String GroupName = ENUM_DANHMUC.KETLUANGDTTT;
            int LoaiAn = (string.IsNullOrEmpty(hddLoaiAn.Value + "")) ? 0 : Convert.ToInt16(hddLoaiAn.Value);
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            ddlKetquaXX.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME_LoaiAn(GroupName, LoaiAn);
            ddlKetquaXX.DataTextField = "MA_TEN";
            ddlKetquaXX.DataValueField = "ID";
            ddlKetquaXX.DataBind();
            ddlKetquaXX.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadAnLe()
        {
            GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
            DataTable tbl = TK_BL.GDKTTT_VUAN_GET_ALL_ANLE();
            dropAnLe.DataSource = tbl;
            dropAnLe.DataTextField = "SO_ANLE";
            dropAnLe.DataValueField = "SO_ANLE";
            dropAnLe.DataBind();
            dropAnLe.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        void LoadThongTinVuAn()
        {
            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    lttVuAn.Text = oT.TENVUAN;
                else
                {
                    lttVuAn.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        lttVuAn.Text = lttVuAn.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                hddLoaiAn.Value = oT.LOAIAN + "";
                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);


                if (oT.SO_QDGDT != null)
                {
                    txtVuAn_SoBanAn.Text = oT.SO_QDGDT;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYQD + "") || (oT.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }

                else if (oT.SOANPHUCTHAM != null)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                }

                else if (oT.SOANSOTHAM != null)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANSOTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUSOTHAM + "") || (oT.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                }

                if (oT.LOAIAN == 1)
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = true;
                    pnNguyendo.Visible = pnBidon.Visible = false;
                    txtVuAn_NguyenDon.Text = oT.NGUYENDON;
                    txtVuAn_BiDon.Text = oT.BIDON;
                }
                else
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = false;
                    pnNguyendo.Visible = pnBidon.Visible = true;
                    //----------------------------------
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                }


                LoadThongTin_VA_XXGDTTT(oT);
                //-----------------------------
                try
                {
                    Load_TTV_LanhDao(oT);
                }
                catch (Exception ex) { }
            }
            else
                dropTTV_GDT.Enabled = txtNgayphancong_GDT.Enabled = txtNgayPhanCong_LDV.Enabled = dropLanhDao.Enabled = true;
        }

        void Load_TTV_LanhDao(GDTTT_VUAN obj)
        {
            String temp_str = "";
            decimal temp_id = 0;
            #region ---------thong tin TTV/LD-----------------
            string temp_ttv = "";
            #region Thông tin TTV/lanh dao
            DM_CANBO objCB = null;
            //----------------------------
            int soluongcot = 6;
            string str_ttv = "", str_ld = "", str_tp = "";

            temp_id = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_ttv = "<td>Thẩm tra viên</td>";
                str_ttv += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }
            //-----------------
            temp_id = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_ld = "<td>Lãnh đạo vụ</td>";
                str_ld += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }
            //-------------------------------
            temp_id = (string.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : (decimal)obj.THAMPHANID;
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                temp_str = objCB.HOTEN;
                str_tp = "<td>Thẩm phán</td>";
                str_tp += "<td><b>" + temp_str + "</b></td>";
                soluongcot = soluongcot - 2;
            }

            //-----------------------------------------------------
            temp_ttv = "<tr>";
            temp_ttv += str_ttv + str_ld + str_tp;
            if (soluongcot > 0)
                temp_ttv += "<td colspan='" + soluongcot + "'></td>";
            temp_ttv += "</tr>";
            #endregion
            lttOther.Text = temp_ttv;
            #endregion
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }

        void LoadThongTin_VA_XXGDTTT(GDTTT_VUAN oVA)
        {
            int IsVienTruongKN = string.IsNullOrEmpty(oVA.ISVIENTRUONGKN + "") ? 0 : (int)oVA.ISVIENTRUONGKN;
            if (IsVienTruongKN == 1)
            {
                pnHoSoVKS.Visible = true;
                hddShowHoSoVKS.Value = "1";
                txtVKS_So.Text = oVA.VIENTRUONGKN_SO + "";
                txtVKS_Ngay.Text = (String.IsNullOrEmpty(oVA.VIENTRUONGKN_NGAY + "") || (oVA.VIENTRUONGKN_NGAY == DateTime.MinValue)) ? "" : ((DateTime)oVA.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul);
                Cls_Comon.SetValueComboBox(dropVKS_NguoiKy, oVA.VIENTRUONGKN_NGUOIKY);
                pnlKN.Visible = true;
                txtSoButLucKN.Text = oVA.XXGDTTT_SOBUTLUCKN;
                txtNoidungKN.Text = oVA.XXGDTTT_NOIDUNGKN;
            }
            else
            {
                hddShowHoSoVKS.Value = "0";
                pnHoSoVKS.Visible = false;
                pnlKN.Visible = false;
            }

            //----Thong tin thu ly xet xu GDT----------

            txtSoThuLy.Text = oVA.SOTHULYXXGDT + "";
            txtGhiChuKN.Text = oVA.XXGDTTT_GHICHUKN;
            txtNgayThuLy.Text = (String.IsNullOrEmpty(oVA.NGAYTHULYXXGDT + "") || (oVA.NGAYTHULYXXGDT == DateTime.MinValue)) ? "" : ((DateTime)oVA.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul);
            txtNgayVKSTraHS.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYVKSTRAHS + "") || (oVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);
            txtSobutlucVKSTraHS.Text = oVA.XXGDTTT_SOBUTLUCVKSTRAHS;

            if (String.IsNullOrEmpty(oVA.XXGDT_NGAYPHANCONGTTV + "") || (oVA.XXGDT_NGAYPHANCONGTTV == DateTime.MinValue))
            {
                txtNgayphancong_GDT.Enabled = true;
                dropTTV_GDT.Enabled = true;
            }
            else
            {
                txtNgayphancong_GDT.Enabled = false;
                dropTTV_GDT.Enabled = false;
            }



            if (String.IsNullOrEmpty(oVA.XXGDT_NGAYPHANCONGLD + "") || (oVA.XXGDT_NGAYPHANCONGLD == DateTime.MinValue))
                txtNgayPhanCong_LDV.Enabled = true;
            else
                txtNgayPhanCong_LDV.Enabled = false;

            if (oVA.XXGDT_LANHDAOVUID > 0)
                dropLanhDao.Enabled = false;
            else
                dropLanhDao.Enabled = true;
            txtNgayphancong_GDT.Text = (String.IsNullOrEmpty(oVA.XXGDT_NGAYPHANCONGTTV + "") || (oVA.XXGDT_NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDT_NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
            dropTTV_GDT.SelectedValue = String.IsNullOrEmpty(oVA.XXGDT_THAMTRAVIENID + "") ? oVA.THAMTRAVIENID.ToString() : oVA.XXGDT_THAMTRAVIENID.ToString();
            txtNgayPhanCong_LDV.Text = (String.IsNullOrEmpty(oVA.XXGDT_NGAYPHANCONGLD + "") || (oVA.XXGDT_NGAYPHANCONGLD == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDT_NGAYPHANCONGLD).ToString("dd/MM/yyyy", cul);
            dropLanhDao.SelectedValue = String.IsNullOrEmpty(oVA.XXGDT_LANHDAOVUID + "") ? oVA.LANHDAOVUID.ToString() : oVA.XXGDT_LANHDAOVUID.ToString();
            //-----Load thong tin qua han luat định--------------
            // GDKTT_VUAN_TK objTK = new GDKTT_VUAN_TK();
            GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
            DataTable tbl = TK_BL.GDKTTT_VUAN_TK_GETBYID("QHLD", oVA.ID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropQuahan.SelectedValue = Convert.ToString(tbl.Rows[0]["GIATRI_TK"]);
                if (dropQuahan.SelectedValue == "1")
                    pnNDquahan.Visible = true;
                else
                    pnNDquahan.Visible = false;

                ddlChuQuan.SelectedValue = Convert.ToString(tbl.Rows[0]["NOIDUNG_TK"]);
            }
            else
            {
                dropQuahan.SelectedValue = "-1";
                pnNDquahan.Visible = false;
                ddlChuQuan.SelectedValue = "0";

            }
            hdd_quahanluatdinh.Value = dropQuahan.SelectedValue;

            //Kiem tra nếu có Lich ngay mo phien tòa thì không cho xóa Thông tin thụ lý XXGDT
            if (oVA.NGAYLICHGDT != null && oVA.NGAYLICHGDT != DateTime.MinValue)
            {
                cmdXoaTLXX.Enabled = false;
                cmdXoaTLXX.CssClass = "buttonprintdisable";
            }
            else
            {
                cmdXoaTLXX.Enabled = true;
                cmdXoaTLXX.CssClass = "buttoninput";
            }
            txtNgayLichGDT.Text = (String.IsNullOrEmpty(oVA.NGAYLICHGDT + "") || (oVA.NGAYLICHGDT == DateTime.MinValue)) ? "" : ((DateTime)oVA.NGAYLICHGDT).ToString("dd/MM/yyyy", cul);


            //----Ket qua XX GDTTT-----------------------
            //txtSoQD.Text = oVA.XXGDTTT_SOQD + "";
            //txtNgayQD.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYQD + "") || (oVA.XXGDTTT_NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYQD).ToString("dd/MM/yyyy", cul);
            //if (!string.IsNullOrEmpty(oVA.XXGDTTT_SOQD + ""))
            //    txtSoQD.Enabled = false;
            //if (!string.IsNullOrEmpty(oVA.XXGDTTT_NGAYQD + ""))
            //    txtNgayQD.Enabled = false;
            //txtHoan_NgayMoPT.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYVKSTRAHS + "") || (oVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);
        }
        void LoadDSHoiDongTP_DaChon()
        {
            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            Literal li_tp = new Literal();
            try
            {
                int temp = 1;
                List<GDTTT_VUAN_XXGDTT_HOIDONG> lst = dt.GDTTT_VUAN_XXGDTT_HOIDONG.Where(x => x.VUANID == VuAnID).ToList();
                if (lst != null && lst.Count > 0)
                {
                    temp = Convert.ToInt16(lst[0].TYPEHD);
                    rdChonHD.SelectedValue = temp.ToString();
                    foreach (GDTTT_VUAN_XXGDTT_HOIDONG objHD in lst)
                    {
                        temp = String.IsNullOrEmpty(objHD.ISCHUTOA + "") ? 0 : (int)objHD.ISCHUTOA;
                        if (temp == 1)
                            Cls_Comon.SetValueComboBox(dropChuToa, objHD.CANBOID);
                    }
                }
                LoadDropThamPhan_TheoHD();
                LoadDaiDienVuGDKT(VuAnID);
            }
            catch (Exception ex) { }
        }
        void LoadDaiDienVuGDKT(decimal VuAnID)
        {
            // Lấy danh sách Chủ tọa đã lưu
            //var lst = dt.GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT.Where(x => x.VUANID == VuAnID).ToList();
            var lst = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT>(VuAnID).ToList();
            if (lst == null || lst.Count == 0)
                return;

            // Convert ra list CANBOID để so sánh nhanh
            var dsDaiDienId = lst
                .Select(x => x.DAIDIEN_VUGDKT_ID.ToString())
                .ToList();

            // Pre-select ListBox
            foreach (ListItem item in lstVuGDKT.Items)
            {
                item.Selected = dsDaiDienId.Contains(item.Value);
            }
        }

        void Load_DaChon_Dual_Listbox(Int32 _Loai_hd)
        {
            Int32 LoginDonViID = Convert.ToInt32(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            Int32 loaian = Convert.ToInt32(hddLoaiAn.Value);
            //////////////////////////////////
            GDTTT_APP_BL oBL = new GDTTT_APP_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            if (_Loai_hd == 5) //hội đồng 5
            {
                tbl = oBL.Get_Select_TP_5(Convert.ToInt32(Request["ID"] + ""), _Loai_hd, LoginDonViID, PBID, loaian);
            }
            else //hội đồng toàn thể
            {
                tbl = oBL.Get_Select_TP(Convert.ToInt32(Request["ID"] + ""), _Loai_hd, LoginDonViID, PBID, loaian);
            }
            li_Report_summ.Text = "";
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                li_Report_summ.Text = row["TEXT_REPORT"] + "";
            }
            String script_ = "var get_TP = $('.get_TP').bootstrapDualListbox({ " +
                           "nonSelectedListLabel: 'Danh sách Thẩm phán', " +
                           "selectedListLabel: 'Danh sách Thẩm phán giải quyết'," +
                           "preserveSelectionOnMove: 'moved'," +
                           "moveOnSelect: true" +
                           "});";
            Cls_Comon.CallFunctionJS(this, this.GetType(), script_);
        }
        protected void cmdUpdateTLXX_Click(object sender, EventArgs e)
        {
            //Kiểm tra xem bị cáo đã có tội danh chính chưa và toi danh vụ an phải la tội danh của bị cáo


            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            //Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            //GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (CheckToidanhChinhBicao(CurrDonID))
            {
                if (CurrDonID > 0)
                {
                    try
                    {
                        obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single<GDTTT_VUAN>();
                        if (obj != null)
                            IsUpdate = true;
                        else
                            obj = new GDTTT_VUAN();
                    }
                    catch (Exception ex) { obj = new GDTTT_VUAN(); }
                }
                else
                    obj = new GDTTT_VUAN();
                if (IsUpdate)
                {
                    obj.SOTHULYXXGDT = txtSoThuLy.Text.Trim();
                    int IsVienTruongKN = string.IsNullOrEmpty(obj.ISVIENTRUONGKN + "") ? 0 : (int)obj.ISVIENTRUONGKN;
                    if (IsVienTruongKN == 1)
                    {
                        obj.XXGDTTT_SOBUTLUCKN = txtSoButLucKN.Text.Trim();
                        obj.XXGDTTT_NOIDUNGKN = txtNoidungKN.Text.Trim();
                    }
                    obj.XXGDTTT_GHICHUKN = txtGhiChuKN.Text.Trim();
                    obj.XXGDTTT_SOBUTLUCVKSTRAHS = txtSobutlucVKSTraHS.Text.Trim();
                    DateTime date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYTHULYXXGDT = date_temp;

                    date_temp = (String.IsNullOrEmpty(txtNgayLichGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayLichGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYLICHGDT = date_temp;

                    date_temp = (String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVKSTraHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.XXGDTTT_NGAYVKSTRAHS = date_temp;

                    date_temp = (String.IsNullOrEmpty(txtNgayphancong_GDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong_GDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.XXGDT_NGAYPHANCONGTTV = date_temp;
                    obj.XXGDT_THAMTRAVIENID = Convert.ToDecimal(dropTTV_GDT.SelectedValue);

                    date_temp = (String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.XXGDT_NGAYPHANCONGLD = date_temp;
                    obj.XXGDT_LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);


                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = UserName;
                    obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                    //QUA HAN LUAT DINH KHONG
                    GDKTT_VUAN_TK objTK = new GDKTT_VUAN_TK();
                    objTK.VUANID = obj.ID;
                    objTK.LOAITK = "QHLD";
                    objTK.GIATRI_TK = Convert.ToDecimal(dropQuahan.SelectedValue);
                    objTK.NOIDUNG_TK = ddlChuQuan.SelectedValue;
                    objTK.NGUOITAO = UserName;
                    objTK.NGAYTAO = DateTime.Now;
                    objTK.NGUOISUA = UserName;
                    objTK.NGAYSUA = DateTime.Now;
                    GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                    TK_BL.GDKTTT_VUAN_TK_INS_UPD(objTK, "QHLD");
                    hdd_quahanluatdinh.Value = dropQuahan.SelectedValue;


                    //-----------------------
                    dt.SaveChanges();
                    //lttMsgTLXX.ForeColor = System.Drawing.Color.Blue;
                    //lttMsgTLXX.Text = "Cập nhật dữ liệu thành công!";
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật dữ liệu thành công!')", true);
                }
                else
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Vụ án không tồn tại. Bạn hãy kiểm tra lại!')", true);

                //lttMsgTLXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";
                LoadDSHoiDongTP_DaChon();
            }
        }
        protected void cmdXoa_TLXX_Click(object sender, EventArgs e)
        {
            //xoa Thông tin thụ lý xét xử GĐT,TT
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.SOTHULYXXGDT = "";
                obj.XXGDTTT_SOBUTLUCKN = "";
                obj.XXGDTTT_NOIDUNGKN = "";
                obj.XXGDTTT_GHICHUKN = "";
                obj.NGAYTHULYXXGDT = null;
                obj.NGAYLICHGDT = null;
                obj.XXGDTTT_NGAYVKSTRAHS = null;
                obj.XXGDTTT_SOBUTLUCVKSTRAHS = "";

                obj.XXGDT_THAMTRAVIENID = null;
                obj.XXGDT_NGAYPHANCONGTTV = null;
                obj.XXGDT_NGAYPHANCONGLD = null;
                obj.XXGDT_LANHDAOVUID = null;
                dropTTV_GDT.Enabled = txtNgayphancong_GDT.Enabled = txtNgayPhanCong_LDV.Enabled = dropLanhDao.Enabled = true;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI;

                dt.SaveChanges();
                //---xoa thong tin qua han luat dinh--
                GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                TK_BL.GDKTTT_VUAN_TK_DEL("QHLD", obj.ID);
                //---------------------
                txtSoThuLy.Text = txtSoButLucKN.Text = txtNoidungKN.Text = txtGhiChuKN.Text = txtNgayThuLy.Text = txtNgayLichGDT.Text = txtNgayVKSTraHS.Text = txtSobutlucVKSTraHS.Text = txtNgayphancong_GDT.Text = txtNgayPhanCong_LDV.Text = "";
                dropTTV_GDT.SelectedIndex = dropLanhDao.SelectedIndex = 0;
                dropQuahan.SelectedValue = "-1";
                ddlChuQuan.SelectedValue = "0";
                pnNDquahan.Visible = false;
                //---------------------
                //lttMsg.ForeColor = System.Drawing.Color.Blue;
                //lttMsg.Text = "Xóa dữ liệu thành công!";
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Xóa dữ liệu thành công!')", true);
            }
            LoadDSHoiDongTP_DaChon();
        }
        protected void dropQuahan_SelectedIndexChanged(object sender, EventArgs e)
        {
            int isQuahan = Convert.ToInt16(dropQuahan.SelectedValue);
            if (isQuahan > 0)
            {
                pnNDquahan.Visible = true;
            }
            else
            {
                pnNDquahan.Visible = false;
                ddlChuQuan.SelectedValue = "0";
            }
            LoadDSHoiDongTP_DaChon();
        }
        protected void ddlChuQuan_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDSHoiDongTP_DaChon();
        }
        //------------------------------
        protected void cmdUpdateLichXX_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CheckToidanhChinhBicao(CurrDonID))
            {
                if (CurrDonID > 0)
                {
                    try
                    {
                        obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single<GDTTT_VUAN>();
                        if (obj != null)
                            IsUpdate = true;
                        else
                            obj = new GDTTT_VUAN();
                    }
                    catch (Exception ex) { obj = new GDTTT_VUAN(); }
                }
                else
                    obj = new GDTTT_VUAN();
                if (IsUpdate)
                {
                    DateTime date_temp = (String.IsNullOrEmpty(txtNgayLichGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayLichGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYLICHGDT = date_temp;
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = UserName;
                    obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;
                    dt.SaveChanges();
                    //-----------------------
                    Update_HDTP();
                    //-----------------------
                    //lttMsgLichXX.ForeColor = System.Drawing.Color.Blue;
                    //lttMsgLichXX.Text = "Cập nhật dữ liệu thành công!";
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật dữ liệu thành công!')", true);
                }
                else
                {
                    //lttMsgLichXX.ForeColor = System.Drawing.Color.Red;
                    //lttMsgLichXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Vụ án không tồn tại. Bạn hãy kiểm tra lại!')", true);
                }

                //Load an hien Button
                Check_visible_Button();
            }
        }
        void Update_HDTP()
        {
            String[] hdd_thamphan_ = hdd_thamphan.Value.Split(',');
            String[] hdd_thamphanName_ = hdd_thamphan_name.Value.Split(',');

            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            XoaHDTP(CurrVuAnID);
            //---------------------
            if (dropChuToa.SelectedValue != "0")
                UpdateTP(Convert.ToDecimal(dropChuToa.SelectedValue), dropChuToa.SelectedItem.Text, 1);
            //-----------------------          
                UpdateDaiDienGDKT(CurrVuAnID);
            //-----------------------
            for (int i = 0; i < hdd_thamphan_.Length; i++)
            {
                if (hdd_thamphan_[i] != "0")
                {
                    UpdateTP(Convert.ToDecimal(hdd_thamphan_[i]), hdd_thamphanName_[i], 0);
                }
            }
            LoadDSHoiDongTP_DaChon();
        }
        void UpdateDaiDienGDKT(decimal VuAnID)
        {
            if (lstVuGDKT == null || lstVuGDKT.Items == null)
                return;
            // 1. Lấy danh sách đại diện được chọn
            var dsDaiDien = lstVuGDKT.Items
                .Cast<ListItem>()
                .Where(i => i.Selected)
                .Select(i => Convert.ToDecimal(i.Value))
                .ToList();

            // 2. Nếu không chọn gì thì không xử lý
            if (dsDaiDien.Count == 0)
                return;

            // XÓA dữ liệu cũ
            DataExtensions.DeleteByClause("DELETE FROM GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT WHERE VUANID = "+ VuAnID + "");

            //INSERT dữ liệu mới
            for (int i = 0; i < dsDaiDien.Count(); i++)
            {
                GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT ODaiDienGDKT = new GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT();
                ODaiDienGDKT.VUANID = VuAnID;
                ODaiDienGDKT.DAIDIEN_VUGDKT_ID = dsDaiDien[i];
                ODaiDienGDKT.NGAYTAO = DateTime.Now;
                ODaiDienGDKT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] +"";
                DataExtensions.Insert<GDTTT_VUAN_XXGDTT_DAIDIEN_VUGDKT>(ODaiDienGDKT);
            }
        }

        void UpdateTP(Decimal ThamPhanID, String TenThamPhan, int IsChuToa)
        {
            Boolean IsNew = true;
            GDTTT_VUAN_XXGDTT_HOIDONG obj = null;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            try
            {
                obj = dt.GDTTT_VUAN_XXGDTT_HOIDONG.Where(x => x.VUANID == CurrVuAnID
                                                           && x.CANBOID == ThamPhanID).Single();
                if (obj != null)
                    IsNew = false;
            }
            catch (Exception ex) { obj = new GDTTT_VUAN_XXGDTT_HOIDONG(); }

            obj.VUANID = CurrVuAnID;
            obj.TYPEHD = Convert.ToInt16(rdChonHD.SelectedValue);
            obj.CANBOID = ThamPhanID;
            obj.TENCANBO = TenThamPhan;
            if (IsNew)
            {
                obj.ISCHUTOA = IsChuToa;
                obj.NGAYTAO = DateTime.Now;
                dt.GDTTT_VUAN_XXGDTT_HOIDONG.Add(obj);
            }
            dt.SaveChanges();
        }

        protected void cmdXoa_LichXX_Click(object sender, EventArgs e)
        {
            //xoa lich xét xử GĐT,TT
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                DateTime date_temp = (String.IsNullOrEmpty(txtNgayLichGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayLichGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYLICHGDT = null;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                dt.SaveChanges();

                //---------------------------------
                XoaHDTP(CurrVuAnID);
                //---------------------
                txtNgayLichGDT.Text = "";
                //---------------------
                //lttMsg.ForeColor = System.Drawing.Color.Blue;
                //lttMsg.Text = "Xóa dữ liệu thành công!";
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Xóa dữ liệu thành công!')", true);
                dropChuToa.SelectedValue = "0";
                //LoadDSHoiDongTP_DaChon();
                LoadDropThamPhan_TheoHD();
                Check_visible_Button();
            }
        }
        void XoaHDTP(Decimal CurrVuAnID)
        {
            List<GDTTT_VUAN_XXGDTT_HOIDONG> lst = dt.GDTTT_VUAN_XXGDTT_HOIDONG.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_XXGDTT_HOIDONG objHD in lst)
                    dt.GDTTT_VUAN_XXGDTT_HOIDONG.Remove(objHD);
                dt.SaveChanges();
            }
        }

        //------------------------------
        protected void cmdUpdateVKS_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();

            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();

            if (IsUpdate)
            {
                obj.VIENTRUONGKN_SO = txtVKS_So.Text;
                DateTime date_temp = (String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.VIENTRUONGKN_NGAY = date_temp;
                //Chanh an TANDTC thi tham quyen xx là Tòa án cap cao
                if (dropVKS_NguoiKy.SelectedValue == "818"
                    || dropVKS_NguoiKy.SelectedValue == "819"
                    || dropVKS_NguoiKy.SelectedValue == "820"
                    || dropVKS_NguoiKy.SelectedValue == "821")
                    obj.VIENTRUONGKN_NGUOIKY = CurrDonViID;
                else
                    obj.VIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
                dt.SaveChanges();

                //lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                //lttMsgHSKN_VKS.Text = "Cập nhật dữ liệu thành công!";
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật dữ liệu thành công!')", true);
            }
            LoadDSHoiDongTP_DaChon();
        }
        protected void cmdXoa_VKS_Click(object sender, EventArgs e)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.VIENTRUONGKN_SO = "";
                obj.VIENTRUONGKN_NGAY = null;
                obj.VIENTRUONGKN_NGUOIKY = 0;
                dt.SaveChanges();
                //---------------------
                txtVKS_So.Text = txtVKS_Ngay.Text = "";
                dropVKS_NguoiKy.SelectedValue = "0";
                //---------------------
                //lttMsg.ForeColor = System.Drawing.Color.Blue;
                //lttMsg.Text = "Xóa dữ liệu thành công!";

                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Xóa dữ liệu thành công!')", true);
            }
            LoadDSHoiDongTP_DaChon();
        }
        //------------------------------

        protected void cmdUpdateKQ_Click(object sender, EventArgs e)
        {
          
            //Kiem tra xem Bi cao đã có tội danh chính chưa và Tội danh của vụ án có trung khớp với Tội danh chính của bị cáo
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CheckToidanhChinhBicao(CurrVuAnID))
            {

                if (CurrVuAnID > 0)
                {
                    //Kiem tra neu chua có QHPL thong ke thì không cho thụ lý
                    GDTTT_VUAN ckObj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (ckObj.QHPL_THONGKEID == null || ckObj.QHPL_THONGKEID == 0)
                    {
                        //lttMsgLichXX.ForeColor = System.Drawing.Color.Blue;
                        //lttMsgLichXX.Text = "Bạn cần tạo cập nhật Quan hệ pháp luật thống kê trước khi thụ lý xét xử GĐT!";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn cần cập nhật Quan hệ pháp luật thống kê!')", true);
                        //Load hoi dong xet xu
                        LoadDSHoiDongTP_DaChon();
                        return;
                    }

                    try
                    {
                        obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                        if (obj != null)
                            IsUpdate = true;
                        else
                            obj = new GDTTT_VUAN();
                    }
                    catch (Exception ex) { obj = new GDTTT_VUAN(); }
                }
                else
                    obj = new GDTTT_VUAN();

                if (IsUpdate)
                {

                    //Kiểm tra vụ án có quá hạn luật định hay không khi nhập kết quả lần đầu tính cả hoãn phiên tòa
                    //Nếu đã có hoãn hoặc kết quả thì không bắt cảnh báo
                    Int32 obj_xx;
                    obj_xx = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == CurrVuAnID).Count<GDTTT_VUAN_XETXUGDTTT>();
                    GDKTTT_VUAN_TK_BL objTK = new GDKTTT_VUAN_TK_BL();
                    DataTable vTK = objTK.GDKTTT_VUAN_TK_GETBYID("QHLD", obj.ID);
                    DateTime NgayThuly = (DateTime)((String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
                    DateTime vNgayQh = NgayThuly.AddMonths(4);

                    if (vNgayQh <= DateTime.Now && obj_xx == 0 && hdd_quahanluatdinh.Value == "-1")
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Vu án đã qua hạn giải quyết, bạn cần xác nhận có quá hạn luật định hay không?')", true);
                        txtSoThuLy.Focus();
                        LoadDSHoiDongTP_DaChon();
                        return;

                    }


                    obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;
                    dt.SaveChanges();
                    Update_XetXuGDT();
                    Update_VuAn_KQXX();

                    //lttMsg.ForeColor = System.Drawing.Color.Blue;
                    //lttMsg.Text = "Cập nhật dữ liệu thành công!";

                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật dữ liệu thành công!')", true);

                    hddVuAnID.Value = obj.ID.ToString();

                    LoadDS_XXGDTTT();
                    //-------------------------
                    //rdHoan.SelectedValue = "0;";
                    txtHoan_NgayMoPT.Text = "";
                    txtLyDoHoan.Text = "";
                    txtSoQD.Text = txtNgayQD.Text = txtNgayPhatHanh.Text = "";
                    ddlKetquaXX.SelectedValue = "0";
                    hddXetXuID.Value = "0";

                    rdAD_AnLe.SelectedValue = "0";
                    pnAnLe.Visible = false;
                    dropAnLe.SelectedValue = "0";
                    try
                    {
                        rdHoan.SelectedIndex = 0;
                        pnKQ.Visible = true;
                        lttBatBuoc.Visible = true;
                        //pnHoan.Visible = false;
                        lttLydo.Text = "Ghi chú";
                        pnNgayPH.Visible = true;
                    }
                    catch (Exception ex) { }
                }
                else
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Vụ án không tồn tại. Bạn hãy kiểm tra lại!')", true);

                //lttMsg.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";
                LoadDSHoiDongTP_DaChon();
            }
        }
        void Update_XetXuGDT()
        {
            Boolean IsUpdate = false;
            Decimal VuAnID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");

            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

            GDTTT_VUAN_XETXUGDTTT objXX = new GDTTT_VUAN_XETXUGDTTT();
            Decimal CurrXetXuID = (hddXetXuID.Value == "") ? 0 : Convert.ToDecimal(hddXetXuID.Value);
            if (CurrXetXuID > 0)
            {
                try
                {
                    objXX = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.ID == CurrXetXuID).Single<GDTTT_VUAN_XETXUGDTTT>();
                    if (objXX != null)
                        IsUpdate = true;
                    else
                        objXX = new GDTTT_VUAN_XETXUGDTTT();
                }
                catch (Exception ex) { objXX = new GDTTT_VUAN_XETXUGDTTT(); }
            }
            else
                objXX = new GDTTT_VUAN_XETXUGDTTT();

            DateTime date_temp = DateTime.MinValue;
            objXX.NGAYTAO = DateTime.Now;
            objXX.NGUOITAO = UserID;
            objXX.VUANID = VuAnID;
            date_temp = (String.IsNullOrEmpty(txtHoan_NgayMoPT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtHoan_NgayMoPT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            objXX.NGAYMOPT = date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgayPhatHanh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayPhatHanh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            objXX.NGAYPH = date_temp;

            //----------------------------
            objXX.KETQUAID = 0;
            objXX.LYDOHOAN = txtLyDoHoan.Text.Trim();

            objXX.ISHOAN = Convert.ToInt16(rdHoan.SelectedValue);
            if (rdHoan.SelectedValue == "0")
                objXX.KETQUAID = Convert.ToDecimal(ddlKetquaXX.SelectedValue);


            //-----------------------
            if (!IsUpdate)
                dt.GDTTT_VUAN_XETXUGDTTT.Add(objXX);
            dt.SaveChanges();
        }

        protected void rdAD_AnLe_SelectedIndexChanged(object sender, EventArgs e)
        {
            int isAD_AnLe = Convert.ToInt16(rdAD_AnLe.SelectedValue);
            if (isAD_AnLe != 0)
            {
                pnAnLe.Visible = true;
            }
            else
            {
                pnAnLe.Visible = false;
                dropAnLe.SelectedValue = "0";
            }
            LoadDSHoiDongTP_DaChon();
        }
        protected void dropAnLe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDSHoiDongTP_DaChon();
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/GDTTT/VuAn/Xetxu.aspx");
        }

        protected void txtVKS_Ngay_TextChanged(object sender, EventArgs e)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));

            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
            Decimal SoCV = objBL.XXGDTTT_GetLastSoQD(PhongBanID, Ngay, 1);
            txtVKS_So.Text = SoCV + "";
            LoadDSHoiDongTP_DaChon();
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DateTime NgayThuLyGDT = (DateTime)((String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));


            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            GDTTT_VUAN oVuan = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single<GDTTT_VUAN>();
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string vLoaian = oVuan.LOAIAN + "";
            decimal vYear = Convert.ToDateTime(NgayThuLyGDT).Year;
            txtSoThuLy.Text = oBL.TLXXGDT_GETMAXTT(CurrDonViID, vYear, vLoaian) + "";



            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
            //Decimal SoCV = objBL.XXGDTTT_GetLastSoQD(PhongBanID, NgayThuLyGDT, 2);
            //txtSoThuLy.Text = SoCV + "";
            LoadDSHoiDongTP_DaChon();

            if (string.IsNullOrEmpty(txtNgayphancong_GDT.Text.Trim()))
                txtNgayphancong_GDT.Text = txtNgayThuLy.Text;
            if (string.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                txtNgayPhanCong_LDV.Text = txtNgayphancong_GDT.Text;
            //kiem tra có qua han luat dinh khong
            //NgayThuLyGDT


        }
        //protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        //{
        //    Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
        //    DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));

        //    GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
        //    /*Loai =1: VIENTRUONGKN , 2: THU LY XXGDTTT, 3: KET QUA XXGDTTT*/
        //    Decimal SoCV = objBL.XXGDTTT_GetLastSoQD(PhongBanID, Ngay, 3);
        //    txtSoQD.Text = SoCV + "";
        //}


        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            if (oVA != null && oVA.LOAIAN != null)
            {
                decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                decimal so_ = 0;
                //string loai = rdbLoai.SelectedValue;
                so_ = oBL.ThongTinXetXu_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString());
                txtSoQD.Text = Convert.ToString(so_);
                //Loai lại hội đồng xét xử
                LoadDSHoiDongTP_DaChon();
            }
        }

        protected void rdHoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            int ishoantha = Convert.ToInt16(rdHoan.SelectedValue);
            if (ishoantha == 1)
            {
                lttBatBuoc.Visible = false;
                //pnHoan.Visible = true;
                lttLydo.Text = "Lý do *";
                pnNgayPH.Visible = false;
                pnKQ.Visible = false;
                if (!rpt.Visible)
                {
                    if (txtNgayLichGDT.Text != "")
                        txtHoan_NgayMoPT.Text = txtNgayLichGDT.Text;
                }
            }
            else
            {
                lttBatBuoc.Visible = true;
                pnKQ.Visible = true;
                //pnHoan.Visible = false;
                lttLydo.Text = "Ghi chú";
                pnNgayPH.Visible = true;
            }
            LoadDSHoiDongTP_DaChon();
        }
        protected void rdChonHD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamPhan_TheoHD();
        }
        void LoadDropThamPhan_TheoHD()
        {
            int chon = Convert.ToInt16(rdChonHD.SelectedValue);
            if (chon != 1)
            {
                //HĐ5
                Load_DaChon_Dual_Listbox(5);
            }
            else
            {
                Load_DaChon_Dual_Listbox(1);
            }
        }
        void LoadAllChuToa()
        {
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal v_chucdanh = 0;
            if (LoginDonViID == 1)
            {
                v_chucdanh = 486;
            }
            else
            {
                v_chucdanh = 507;
            }
            List<DM_CANBO> lst = dt.DM_CANBO.Where(x => x.HIEULUC == 1
                                                                         && x.CHUCDANHID == v_chucdanh
                                                                         && x.TOAANID == LoginDonViID).ToList();
            dropChuToa.DataSource = lst;
            dropChuToa.DataTextField = "HOTEN";
            dropChuToa.DataValueField = "ID";
            dropChuToa.DataBind();
            dropChuToa.Items.Insert(0, new ListItem("-----Chọn------", "0"));
        }
        void LoadDS_XXGDTTT()
        {
            Decimal VuAnID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN_XETXU_BL objBL = new GDTTT_VUAN_XETXU_BL();
            DataTable tbl = objBL.XetXuGDTTT_GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = cmdPrinDS.Visible = cmdLamMoi.Visible = true;


            }
            else
            {
                //txtSoQD.Enabled = txtNgayQD.Enabled = true;
                rpt.Visible = cmdPrinDS.Visible = cmdLamMoi.Visible = false;
                if (!string.IsNullOrEmpty(txtNgayLichGDT.Text))
                    txtHoan_NgayMoPT.Text = txtNgayLichGDT.Text;
            }
            Check_visible_Button();
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal currID = Convert.ToDecimal(e.CommandArgument.ToString());
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            List<GDTTT_VUAN_XETXUGDTTT> lscheck = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == CurrVuAnID && x.ISHOAN == 0 && x.ID != currID).ToList();
            switch (e.CommandName)
            {
                case "Sua":
                    if (lscheck.Count > 0)
                    {
                        //lttMsg.Text = "Bạn không được sửa khi đã có kết quả xét xử!";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn không được sửa khi đã có kết quả xét xử!')", true);
                        return;
                    }
                    hddXetXuID.Value = currID.ToString();
                    lttMsg.Text = "";
                    LoadInfoLanXX(currID);
                    LoadDSHoiDongTP_DaChon();
                    cmdUpdateKQ.Enabled = true;
                    cmdUpdateKQ.CssClass = "buttoninput";
                    if (!CheckCongbo())
                    {
                        return;
                    }
                    break;
                case "Xoa":
                    if(!CheckCongbo())
                    {
                        return;
                    }    
                    if (lscheck.Count > 0)
                    {
                        //lttMsg.Text = "Bạn không được xóa khi đã có kết quả xét xử!";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn không được xóa khi đã có kết quả xét xử!')", true);
                        return;
                    }
                    XoaLanXX(currID);
                    LoadDS_XXGDTTT();
                    LoadDSHoiDongTP_DaChon();
                    lttMsg.Text = "Xóa thành công!";
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Xóa thành công!')", true);
                    check_luu_ketqua();
                    Check_visible_Button();
                    break;
            }
        }

        void XoaLanXX(Decimal currID)
        {
            GDTTT_VUAN_XETXUGDTTT obj = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.ID == currID).FirstOrDefault();
            dt.GDTTT_VUAN_XETXUGDTTT.Remove(obj);
            dt.SaveChanges();

            //-------------------------
            Update_VuAn_KQXX();
        }
        void Update_VuAn_KQXX()
        {
            GDTTT_VUAN_XETXUGDTTT obj = null;
            int ISHOAN = 0;
            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            List<GDTTT_VUAN_XETXUGDTTT> lscheck = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == VuAnID && x.ISHOAN == 0).ToList();
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            List<GDTTT_VUAN_XETXUGDTTT> lst = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYMOPT).OrderByDescending(z => z.NGAYTAO).ToList();
            if (lst != null && lst.Count > 0)
            {
                obj = lst[0];
                ISHOAN = (String.IsNullOrEmpty(obj.ISHOAN + "")) ? 0 : (int)obj.ISHOAN;
                oVA.XXGDTTT_ISHOANPT = ISHOAN;
                oVA.XXGDTTT_KETQUAID = (String.IsNullOrEmpty(obj.KETQUAID + "")) ? 0 : obj.KETQUAID;
                if (ISHOAN == 1)
                {
                    //oVA.XXGDTTT_NGAYQD = null;
                    //oVA.XXGDTTT_SOQD = "";
                    oVA.XXGDTTT_LYDOHOAN = obj.LYDOHOAN;
                    oVA.XXGDTTT_NGAYHOAN = obj.NGAYMOPT;
                    oVA.NGAYXUGIAMDOCTHAM = null;
                    oVA.XXGDTTT_ISKETQUA = 0;
                    //Khi chua co ket qua thi xoa thong ke ap dung an le 
                    if (oVA.XXGDTTT_ISKETQUA == 0)
                    {
                        //Xoa thông kê ap dung an le
                        GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                        TK_BL.GDKTTT_VUAN_TK_DEL("ADAL", oVA.ID);
                    }
                }
                else
                {
                    oVA.XXGDTTT_LYDOHOAN = "";
                    oVA.XXGDTTT_NGAYHOAN = null;
                    oVA.NGAYXUGIAMDOCTHAM = obj.NGAYMOPT;
                    oVA.XXGDTTT_ISKETQUA = 1;
                    oVA.XXGDTTT_SOQD = txtSoQD.Text.Trim();
                    oVA.XXGDTTT_NGAYQD = (DateTime)((String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
                    //Cap nhat co ap dung an le không
                    GDKTT_VUAN_TK objTK = new GDKTT_VUAN_TK();
                    objTK.VUANID = oVA.ID;
                    objTK.GIATRI_TK = Convert.ToDecimal(rdAD_AnLe.SelectedValue);
                    objTK.NOIDUNG_TK = Convert.ToString(dropAnLe.SelectedValue);
                    objTK.GHICHU = null;
                    objTK.NGUOITAO = UserName;
                    objTK.NGAYTAO = DateTime.Now;
                    objTK.NGUOISUA = UserName;
                    objTK.NGAYSUA = DateTime.Now;
                    GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                    TK_BL.GDKTTT_VUAN_TK_INS_UPD(objTK, "ADAL");
                }
            }
            else
            {
                oVA.XXGDTTT_ISKETQUA = 0;
                oVA.NGAYXUGIAMDOCTHAM = null;
                oVA.XXGDTTT_NGAYQD = null;
                oVA.XXGDTTT_SOQD = "";
                oVA.XXGDTTT_KETQUAID = 0;
                oVA.XXGDTTT_ISHOANPT = 0;
                oVA.XXGDTTT_NGAYHOAN = null;

                //Cap nhat co ap dung an le không
                if (oVA.XXGDTTT_KETQUAID == 0)
                {
                    // Nếu sửa lại thành Hoãn thì xóa Áp dụng án lệ nếu đã lưu
                    //Xoa thông kê ap dung an le
                    GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                    TK_BL.GDKTTT_VUAN_TK_DEL("ADAL", oVA.ID);
                }
            }
            dt.SaveChanges();

            if (rdHoan.SelectedValue == "0")
            {
                decimal capxetxu = oVA.LOAI_GDTTTT == 1 ? 4 : 6;

                bool isnew = false;
                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {obj.VUANID} " +
                                                                        $"  AND LOAIANID = {oVA.LOAIAN} " +
                                                                        $"  AND CAPXETXU = {capxetxu} ");

                BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                if (temp_congbo == null)
                {
                    isnew = true;
                    temp_congbo = new BAQD_CONGBO();
                }

                temp_congbo.LOAIANID = Convert.ToDecimal(oVA.LOAIAN);
                temp_congbo.CAPXETXU = capxetxu;
                temp_congbo.ISBA = 0;
                temp_congbo.BAQDID = oVA.ID;
                temp_congbo.NGAYHIEULUC = oVA.XXGDTTT_NGAYQD;
                temp_congbo.MAVUAN = oVA.ID.ToString();
                temp_congbo.VUVIECID = oVA.ID;

                if (isnew)
                {
                    temp_congbo.NGAYTAO = DateTime.Now;
                    temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Insert(temp_congbo);
                }
                else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                {
                    temp_congbo.NGAYSUA = DateTime.Now;
                    temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(temp_congbo);
                }
            }
            else
            {
                decimal capxetxu = 0;
                if (oVA.LOAI_GDTTTT == 1)
                {
                    capxetxu = 4;
                }
                else if (oVA.LOAI_GDTTTT == 2)
                {
                    capxetxu = 6;
                }

                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {obj.VUANID} " +
                                                                        $"  AND LOAIANID = {oVA.LOAIAN} " +
                                                                        $"  AND CAPXETXU = {capxetxu} ");

                BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                if (temp_congbo != null)
                {
                    temp_congbo.BAQDID = 0;
                    temp_congbo.NGAYHIEULUC = null;
                    temp_congbo.NGAYSUA = DateTime.Now;
                    temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(temp_congbo);
                }
            }    

        }
        void LoadInfoLanXX(Decimal currID)
        {
            hddXetXuID.Value = currID.ToString();
            try
            {
                GDTTT_VUAN_XETXUGDTTT obj = dt.GDTTT_VUAN_XETXUGDTTT.Where(x => x.ID == currID).Single();
                if (obj != null)
                {
                    rdHoan.SelectedValue = (string.IsNullOrEmpty(obj.ISHOAN + "")) ? "0" : obj.ISHOAN.ToString();
                    if (rdHoan.SelectedValue == "1")
                    {
                        //txtSoQD.Visible = txtNgayQD.Visible = false;
                        //pnHoan.Visible = true;
                        lttLydo.Text = "Lý do *";
                        pnNgayPH.Visible = false;
                        pnKQ.Visible = false;

                    }
                    else
                    {
                        lttLydo.Text = "Ghi chú";
                        pnNgayPH.Visible = true;
                        pnKQ.Visible = true;

                        Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
                        GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        if (oVA != null)
                        {
                            txtSoQD.Text = oVA.XXGDTTT_SOQD + "";
                            txtNgayQD.Text = (String.IsNullOrEmpty(oVA.XXGDTTT_NGAYQD + "") || (oVA.XXGDTTT_NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oVA.XXGDTTT_NGAYQD).ToString("dd/MM/yyyy", cul);
                        }
                        Cls_Comon.SetValueComboBox(ddlKetquaXX, obj.KETQUAID);

                        GDKTTT_VUAN_TK_BL TK_BL = new GDKTTT_VUAN_TK_BL();
                        DataTable tbl = TK_BL.GDKTTT_VUAN_TK_GETBYID("ADAL", VuAnID);
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            if (Convert.ToDecimal(tbl.Rows[0]["GIATRI_TK"]) == 1)
                            {   //Ap dung An Le
                                rdAD_AnLe.SelectedValue = "1";
                                pnAnLe.Visible = true;
                                LoadAnLe();
                                dropAnLe.SelectedValue = tbl.Rows[0]["NOIDUNG_TK"] + "";
                            }
                            else
                            {
                                rdAD_AnLe.SelectedValue = "0";
                                pnAnLe.Visible = false;
                                dropAnLe.SelectedValue = "0";
                            }
                        }
                        else
                        {
                            rdAD_AnLe.SelectedValue = "0";
                            pnAnLe.Visible = false;
                            dropAnLe.SelectedValue = "0";
                        }

                    }
                    if (obj.NGAYMOPT != null)
                        txtHoan_NgayMoPT.Text = (String.IsNullOrEmpty(obj.NGAYMOPT + "") || obj.NGAYMOPT == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYMOPT).ToString("dd/MM/yyyy", cul);
                    if (obj.NGAYPH != null)
                        txtNgayPhatHanh.Text = (String.IsNullOrEmpty(obj.NGAYPH + "") || (obj.NGAYPH == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPH).ToString("dd/MM/yyyy", cul);
                }
                txtLyDoHoan.Text = obj.LYDOHOAN + "";

                lttLydo.Text = "Ghi chú";

            }
            catch (Exception ex) { }
        }

        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ddlKetquaXX.SelectedIndex = rdHoan.SelectedIndex = -1;
            txtLyDoHoan.Text = "";
            //pnHoan.Visible = false;
            lttLydo.Text = "Ghi chú";
            pnNgayPH.Visible = true;
            txtHoan_NgayMoPT.Text = txtSoQD.Text = txtNgayQD.Text = txtNgayPhatHanh.Text = "";


            LoadDSHoiDongTP_DaChon();
            check_luu_ketqua();
            Check_visible_Button();
        }
        //-----------------------------------
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_ToiCao_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();

                ListItemCollection liCol = dropVKS_NguoiKy.Items;
                for (int i = 0; i < tbl.Rows.Count; i++)
                {
                    string v_loaivks = tbl.Rows[i]["LOAIVKS"] + "";
                    string v_TOAANID = tbl.Rows[i]["TOAANID"] + "";

                    if (v_loaivks == "CAPCAO" && v_TOAANID != CurrDonViID.ToString())
                    {
                        string v_index = tbl.Rows[i]["ID"] + "";
                        for (int j = 0; j < liCol.Count; j++)
                        {
                            ListItem li = liCol[j];
                            if (li.Value == v_index)
                                dropVKS_NguoiKy.Items.Remove(li);
                        }
                    }
                    else if (v_loaivks == "CAPTINH" && v_TOAANID != CurrDonViID.ToString())
                    {

                        string v_index = tbl.Rows[i]["ID"] + "";
                        for (int j = 0; j < liCol.Count; j++)
                        {
                            ListItem li = liCol[j];
                            if (li.Value == v_index)
                                dropVKS_NguoiKy.Items.Remove(li);
                        }

                    }
                }
            }
            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void txtNgayPhanCongTTV_TextChanged(object sender, EventArgs e)
        {
            LoadDSHoiDongTP_DaChon();
            if (string.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                txtNgayPhanCong_LDV.Text = txtNgayphancong_GDT.Text;

        }

        protected void dropTTV_GDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV_GDT.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV_GDT.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
            LoadDSHoiDongTP_DaChon();
        }

        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV_GDT.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV_GDT.DataSource = tbl;
                dropTTV_GDT.DataValueField = "CanBoID";
                dropTTV_GDT.DataTextField = "TenCanBo";
                dropTTV_GDT.DataBind();
                dropTTV_GDT.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV_GDT.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropDaiDienVuGDKT()
        {
            lstVuGDKT.Items.Clear();

            DM_CANBO_BL obj = new DM_CANBO_BL();
            decimal phongBanID = String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")
                ? 0
                : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);

            DataTable tblChuToa = obj.DM_CANBO_GetAllVuTruong_PVT(phongBanID);

            if (tblChuToa != null && tblChuToa.Rows.Count > 0)
            {
                lstVuGDKT.DataSource = tblChuToa;
                lstVuGDKT.DataValueField = "ID";       // ID cán bộ
                lstVuGDKT.DataTextField = "MA_TEN";    // Mã + Tên
                lstVuGDKT.DataBind();
            }
        }

        bool CheckToidanhChinhBicao(decimal Vuanid)
        {
            

            var oVa = dt.GDTTT_VUAN.FirstOrDefault(x => x.ID == Vuanid);
            if (oVa.LOAIAN == 1)
            {
                var lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH
                        .Where(x => x.VUANID == Vuanid)
                        .ToList();

                if (oVa == null)
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Không tìm thấy vụ án!')", true);
                    return false; // Không tìm thấy vụ án
                }

                // 1. Có bị cáo nào không có tội danh chính
                var bicaoKhongCoToidanhChinh = lst
                    .GroupBy(x => x.DUONGSUID)
                    .Any(g => !g.Any(x => x.ISMAIN == 1));

                if (bicaoKhongCoToidanhChinh)
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bị cáo chưa có tội danh chính!')", true);
                    return false;
                }


                // 2. Có tội danh chính trùng tội danh vụ án không
                bool coToiDanhChinhTrung = lst
                    .Any(x => x.ISMAIN == 1 && x.TOIDANHID == oVa.QHPL_THONGKEID);

                if (!coToiDanhChinhTrung)
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Tội danh của vụ án phải là tội danh chính của bị cáo!')", true);
                    return false;
                }
            }


            return true;
        }
        bool CheckCongbo()
        {
            try
            {
                if (Request["type"].ToString() != null)
                {
                    return true;
                }
            }
            catch
            {

            }

            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            decimal v_CAPXETXU = 0;
            if (oT.LOAI_GDTTTT == 1)
            {
                v_CAPXETXU = 4;
            }
            else if (oT.LOAI_GDTTTT == 2)
            {
                v_CAPXETXU = 6;
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {VuAnID} AND LOAIANID = {oT.LOAIAN} AND CAPXETXU = {v_CAPXETXU}  AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdateVKS, false);
                Cls_Comon.SetButton(cmdUpdateTLXX, false);
                Cls_Comon.SetButton(cmdUpdateLichXX, false);
                Cls_Comon.SetButton(cmdUpdateKQ, false);
                Cls_Comon.SetButton(cmdXoa_VKS, false);
                Cls_Comon.SetButton(cmdXoaTLXX, false);
                Cls_Comon.SetButton(cmdXoa_LichXX, false);
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đã có thông tin về công bố! Không được cập nhật thông tin!')", true);
                return false;
            }

            return true;
        }
    }
}