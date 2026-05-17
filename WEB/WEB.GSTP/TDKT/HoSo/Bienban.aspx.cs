using BL.GSTP;
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

namespace WEB.GSTP.TDKT.HoSo
{
    public partial class Bienban : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const string VUTDKT_TANDTC = "1", DONVIKHAC = "0";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                else
                {
                    decimal UserID = Convert.ToDecimal(strUserID);
                    if (Check_Vu_TDKT_TANDTC_Login(UserID))
                    {
                        HdfVuTDKT.Value = VUTDKT_TANDTC;// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
                        BtnLuu.Visible = BtnXoa.Visible = false;
                    }
                    else
                        HdfVuTDKT.Value = DONVIKHAC;
                }
                if (!IsPostBack)
                {
                    LoadDropSoThanhVien();
                    ShowControl();
                    LoadLoaiHinhKT();
                    if (Request["pag"] + "" != "")
                    {
                        int PageIndex = 0;
                        if (int.TryParse(Request["pag"] + "", out PageIndex))
                        {
                            hddPageIndex.Value = PageIndex.ToString();
                        }
                        else
                        {
                            hddPageIndex.Value = "1";
                        }
                    }
                    else
                    {
                        hddPageIndex.Value = "1";
                    }
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadLoaiHinhKT()
        {
            DropLoaiHinh.Items.Clear();
            string GroupName = ENUM_DANHMUC.DM_LOAIHINH_KHENTHUONG;
            DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
            DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (tbl.Rows.Count > 0)
            {
                DropLoaiHinh.DataSource = tbl;
                DropLoaiHinh.DataTextField = "TEN";
                DropLoaiHinh.DataValueField = "ID";
                DropLoaiHinh.DataBind();
            }
            DropLoaiHinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropSoThanhVien()
        {
            for (int i = 1; i <= 20; i++)
            {
                DropSoThanhVien.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
        }
        private void LoadInfo()
        {
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"]);
            TDKT_HO_SO_BIEN_BAN_HOI_DONG ObjBienBan = dt.TDKT_HO_SO_BIEN_BAN_HOI_DONG.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (ObjBienBan != null)
            {

            }
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            if (!CheckDataInput())
            {
                return;
            }
            bool IsNew = false;
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"])
                , DonViID = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"]);
            TDKT_HO_SO_BIEN_BAN_HOI_DONG Obj = dt.TDKT_HO_SO_BIEN_BAN_HOI_DONG.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (Obj == null)
            {
                IsNew = true;
                Obj = new TDKT_HO_SO_BIEN_BAN_HOI_DONG();
                Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYTAO = DateTime.Now;
            }
            else
            {
                Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYSUA = DateTime.Now;
            }
            Obj.HO_SO_ID = HoSoID;
            Obj.LOAI_HINH_KHEN_THUONG = Convert.ToDecimal(DropLoaiHinh.SelectedValue);
            Obj.DATE_BAT_DAU = Convert.ToDateTime(TxtNgayBatDau.Text, cul);
            Obj.DATE_BAT_DAU_GIO = Convert.ToDecimal(TxtBatDau_Gio.Text);
            Obj.DATE_BAT_DAU_PHUT = Convert.ToDecimal(TxtBatDau_Phut.Text);
            Obj.DATE_KET_THUC = Convert.ToDateTime(TxtNgayKetThuc.Text, cul);
            Obj.DATE_KET_THUC_GIO = Convert.ToDecimal(TxtKetThuc_Gio.Text);
            Obj.DATE_KET_THUC_PHUT = Convert.ToDecimal(TxtKetThuc_Phut.Text);
            Obj.DIADIEM = TxtDiaDiem.Text.Trim();
            Obj.CHU_TRI_CUOC_HOP = TxtChuTri.Text.Trim();
            Obj.THU_KY_CUOC_HOP = TxtThuKy.Text.Trim();
            Obj.THU_KY_CUOC_HOP_CV = TxtThuKy_CV.Text.Trim();
            decimal SoThanhVien = Convert.ToDecimal(DropSoThanhVien.SelectedValue);
            Obj.SO_THANH_VIEN_THAM_DU = SoThanhVien;
            Obj.THANH_VIEN_VANG = TxtThanh_Vien_Vang_Mat.Text.Trim();
            Obj.LOAI_DANH_GIA = Convert.ToDecimal(DropKieuBinhChon.SelectedValue);
            if (IsNew)
            {
                dt.TDKT_HO_SO_BIEN_BAN_HOI_DONG.Add(Obj);
            }
            dt.SaveChanges();
            #region Lưu danh sách thành viên tham dự
            decimal BienBanID = Obj.ID, ThuTu = 1;
            string ThanhVien_Ten = "", ThanhVien_ChucVu = "";
            if (SoThanhVien >= 1)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_1.Value);
                ThanhVien_Ten = txtHoTen_1.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_1.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 2)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_2.Value);
                ThanhVien_Ten = txtHoTen_2.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_2.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 3)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_3.Value);
                ThanhVien_Ten = txtHoTen_3.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_3.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 4)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_4.Value);
                ThanhVien_Ten = txtHoTen_4.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_4.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 5)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_5.Value);
                ThanhVien_Ten = txtHoTen_5.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_5.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 6)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_6.Value);
                ThanhVien_Ten = txtHoTen_6.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_6.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 7)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_7.Value);
                ThanhVien_Ten = txtHoTen_7.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_7.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 8)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_8.Value);
                ThanhVien_Ten = txtHoTen_8.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_8.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 9)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_9.Value);
                ThanhVien_Ten = txtHoTen_9.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_9.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 10)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_10.Value);
                ThanhVien_Ten = txtHoTen_10.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_10.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 11)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_11.Value);
                ThanhVien_Ten = txtHoTen_11.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_11.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 12)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_12.Value);
                ThanhVien_Ten = txtHoTen_12.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_12.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 13)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_13.Value);
                ThanhVien_Ten = txtHoTen_13.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_13.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 14)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_14.Value);
                ThanhVien_Ten = txtHoTen_14.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_14.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 15)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_15.Value);
                ThanhVien_Ten = txtHoTen_15.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_15.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 16)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_16.Value);
                ThanhVien_Ten = txtHoTen_16.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_16.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 17)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_17.Value);
                ThanhVien_Ten = txtHoTen_17.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_17.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 18)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_18.Value);
                ThanhVien_Ten = txtHoTen_18.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_18.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 19)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_19.Value);
                ThanhVien_Ten = txtHoTen_19.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_19.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            if (SoThanhVien >= 20)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_20.Value);
                ThanhVien_Ten = txtHoTen_20.Text.Trim();
                ThanhVien_ChucVu = DropChucVu_20.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, ThanhVien_ChucVu);
            }
            #endregion
        }

        protected void BtnXoa_Click(object sender, EventArgs e)
        {
            List<TDKT_HO_SO_BIEN_BAN_THANH_VIEN> lst = dt.TDKT_HO_SO_BIEN_BAN_THANH_VIEN.Where(x => x.BIEN_BAN_ID == 0).ToList();
            if (lst.Count > 0)
            {
                dt.TDKT_HO_SO_BIEN_BAN_THANH_VIEN.RemoveRange(lst);
            }
            TDKT_HO_SO_BIEN_BAN_HOI_DONG BienBan = dt.TDKT_HO_SO_BIEN_BAN_HOI_DONG.Where(x => x.ID == 0).FirstOrDefault();
            if (BienBan != null)
            {
                dt.TDKT_HO_SO_BIEN_BAN_HOI_DONG.Remove(BienBan);
            }
            dt.SaveChanges();
            Lblthongbao.Text = "Xóa thành công!";
        }

        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Danhsach.aspx?dv=" + Request["dv"] + "&pag=" + Request["pag"];
            Response.Redirect(Link);
        }

        protected void DropSoThanhVien_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowControl();
        }
        private void ShowControl()
        {
            int SoThanhVien = Convert.ToInt16(DropSoThanhVien.SelectedValue);
            row_1.Visible = true;
            if (SoThanhVien >= 2)
                row_2.Visible = true;
            else
                row_2.Visible = false;
            if (SoThanhVien >= 3)
                row_3.Visible = true;
            else
                row_3.Visible = false;
            if (SoThanhVien >= 4)
                row_4.Visible = true;
            else
                row_4.Visible = false;
            if (SoThanhVien >= 5)
                row_5.Visible = true;
            else
                row_5.Visible = false;
            if (SoThanhVien >= 6)
                row_6.Visible = true;
            else
                row_6.Visible = false;
            if (SoThanhVien >= 7)
                row_7.Visible = true;
            else
                row_7.Visible = false;
            if (SoThanhVien >= 8)
                row_8.Visible = true;
            else
                row_8.Visible = false;
            if (SoThanhVien >= 9)
                row_9.Visible = true;
            else
                row_9.Visible = false;
            if (SoThanhVien >= 10)
                row_10.Visible = true;
            else
                row_10.Visible = false;

            if (SoThanhVien >= 11)
                row_11.Visible = true;
            else
                row_11.Visible = false;
            if (SoThanhVien >= 12)
                row_12.Visible = true;
            else
                row_12.Visible = false;
            if (SoThanhVien >= 13)
                row_13.Visible = true;
            else
                row_13.Visible = false;
            if (SoThanhVien >= 14)
                row_14.Visible = true;
            else
                row_14.Visible = false;
            if (SoThanhVien >= 15)
                row_15.Visible = true;
            else
                row_15.Visible = false;
            if (SoThanhVien >= 16)
                row_16.Visible = true;
            else
                row_16.Visible = false;

            if (SoThanhVien >= 17)
                row_17.Visible = true;
            else
                row_17.Visible = false;
            if (SoThanhVien >= 18)
                row_18.Visible = true;
            else
                row_18.Visible = false;
            if (SoThanhVien >= 19)
                row_19.Visible = true;
            else
                row_19.Visible = false;
            if (SoThanhVien >= 20)
                row_20.Visible = true;
            else
                row_20.Visible = false;
        }
        private bool CheckDataInput()
        {
            return true;
        }
        private void SaveThanhVienThamDu(decimal BienBanID, decimal ThuTu, string Ten, string ChucVu)
        {
            bool IsNew = false;
            TDKT_HO_SO_BIEN_BAN_THANH_VIEN ObjThanhVien = dt.TDKT_HO_SO_BIEN_BAN_THANH_VIEN.Where(x => x.BIEN_BAN_ID == BienBanID && x.THANH_VIEN_TEN == Ten && x.THANH_VIEN_CHUC_VU == ChucVu).FirstOrDefault();
            if (ObjThanhVien == null)
            {
                IsNew = true;
                ObjThanhVien = new TDKT_HO_SO_BIEN_BAN_THANH_VIEN();
            }
            ObjThanhVien.BIEN_BAN_ID = BienBanID;
            ObjThanhVien.THANH_VIEN_TEN = Ten;
            ObjThanhVien.THANH_VIEN_CHUC_VU = ChucVu;
            if (IsNew)
                dt.TDKT_HO_SO_BIEN_BAN_THANH_VIEN.Add(ObjThanhVien);
            dt.SaveChanges();
        }
        private bool Check_Vu_TDKT_TANDTC_Login(decimal UserID)
        {
            QT_NGUOISUDUNG ObjUser = dt.QT_NGUOISUDUNG.Where(x => x.ID == UserID).FirstOrDefault();
            if (ObjUser != null)
            {
                QT_NHOMNGUOIDUNG NhomVuTDKT = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == ObjUser.NHOMNSDID).FirstOrDefault();
                if (NhomVuTDKT != null)
                {
                    if (NhomVuTDKT.TEN == "Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao")
                    {
                        return true;
                    }
                }
            }
            return false;
        }
    }
}