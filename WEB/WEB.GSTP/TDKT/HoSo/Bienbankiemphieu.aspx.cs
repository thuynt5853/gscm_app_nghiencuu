using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
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
    public partial class Bienbankiemphieu : System.Web.UI.Page
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
                    LoadInfo();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
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
            BtnXoa.Visible = false;
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"])
                , BienBanID = 0;
            TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU ObjBienBan = dt.TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (ObjBienBan != null)
            {
                TxtVeViec.Text = ObjBienBan.VE_VIEC;
                TxtTong_Ca_Nhan_DK.Text = ObjBienBan.TONG_SO_NGUOI.ToString();
                TxtCa_Nhan_Co_Mat.Text = ObjBienBan.NGUOI_CO_MAT.ToString();
                TxtCa_Nhan_Vang_Mat.Text = ObjBienBan.NGUOI_VANG_MAT.ToString();
                TxtNgay.Text = ObjBienBan.NGAY_LAP_BIEN_BAN + "" == "" ? "" : ((DateTime)ObjBienBan.NGAY_LAP_BIEN_BAN).ToString("dd/MM/yyyy");
                DropSoThanhVien.SelectedValue = ObjBienBan.SO_THANH_VIEN_KIEM_PHIEU.ToString();
                TxtSoPhieu_Phat_Ra.Text = ObjBienBan.SO_PHIEU_PHAT.ToString();
                TxtSoPhieu_Thu_Ve.Text = ObjBienBan.SO_PHIEU_THU.ToString();
                TxtSoPhieu_Thu_Ve_Hop_Le.Text = ObjBienBan.SO_PHIEU_THU_HOP_LE.ToString();
                TxtSoPhieu_Thu_Ve_Khong_Hop_Le.Text = ObjBienBan.SO_PHIEU_THU_KHONG_HOP_LE.ToString();
                BtnXoa.Visible = true;
                if (HdfVuTDKT.Value == VUTDKT_TANDTC)
                {
                    BtnXoa.Visible = false;
                }
                BienBanID = ObjBienBan.ID;
            }
            #region Load danh sách thành viên ban kiểm phiếu
            ShowControl();
            List<TDKT_HO_SO_BIEN_BAN_KP_TV> lst = dt.TDKT_HO_SO_BIEN_BAN_KP_TV.Where(x => x.BIEN_BAN_ID == BienBanID).ToList();
            for (int i = 1; i <= lst.Count; i++)
            {

                if (i >= 1)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[0];
                    txtHoTen_1.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_1.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_1.Text = "";
                    DropVaiTro_1.SelectedIndex = 0;
                }
                if (i >= 2)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[1];
                    txtHoTen_2.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_2.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_2.Text = "";
                    DropVaiTro_2.SelectedIndex = 0;
                }
                if (i >= 3)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[2];
                    txtHoTen_3.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_3.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_3.Text = "";
                    DropVaiTro_3.SelectedIndex = 0;
                }
                if (i >= 4)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[3];
                    txtHoTen_4.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_4.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_4.Text = "";
                    DropVaiTro_4.SelectedIndex = 0;
                }
                if (i >= 5)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[4];
                    txtHoTen_5.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_5.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_5.Text = "";
                    DropVaiTro_5.SelectedIndex = 0;
                }
                if (i >= 6)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[5];
                    txtHoTen_6.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_6.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_6.Text = "";
                    DropVaiTro_6.SelectedIndex = 0;
                }
                if (i >= 7)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[6];
                    txtHoTen_7.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_7.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_7.Text = "";
                    DropVaiTro_7.SelectedIndex = 0;
                }
                if (i >= 8)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[7];
                    txtHoTen_8.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_8.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_8.Text = "";
                    DropVaiTro_8.SelectedIndex = 0;
                }
                if (i >= 9)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[8];
                    txtHoTen_9.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_9.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_9.Text = "";
                    DropVaiTro_9.SelectedIndex = 0;
                }
                if (i >= 10)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[9];
                    txtHoTen_10.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_10.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_10.Text = "";
                    DropVaiTro_10.SelectedIndex = 0;
                }
                if (i >= 11)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[10];
                    txtHoTen_11.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_11.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_11.Text = "";
                    DropVaiTro_11.SelectedIndex = 0;
                }
                if (i >= 12)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[11];
                    txtHoTen_12.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_12.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_12.Text = "";
                    DropVaiTro_12.SelectedIndex = 0;
                }
                if (i >= 13)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[12];
                    txtHoTen_13.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_13.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_13.Text = "";
                    DropVaiTro_13.SelectedIndex = 0;
                }
                if (i >= 14)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[13];
                    txtHoTen_14.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_14.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_14.Text = "";
                    DropVaiTro_14.SelectedIndex = 0;
                }
                if (i >= 15)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[14];
                    txtHoTen_15.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_15.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_15.Text = "";
                    DropVaiTro_15.SelectedIndex = 0;
                }
                if (i >= 16)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[15];
                    txtHoTen_16.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_16.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_16.Text = "";
                    DropVaiTro_16.SelectedIndex = 0;
                }
                if (i >= 17)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[16];
                    txtHoTen_17.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_17.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_17.Text = "";
                    DropVaiTro_17.SelectedIndex = 0;
                }
                if (i >= 18)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[17];
                    txtHoTen_18.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_18.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_18.Text = "";
                    DropVaiTro_18.SelectedIndex = 0;
                }
                if (i >= 19)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[18];
                    txtHoTen_19.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_19.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_19.Text = "";
                    DropVaiTro_19.SelectedIndex = 0;
                }
                if (i >= 20)
                {
                    TDKT_HO_SO_BIEN_BAN_KP_TV item = lst[19];
                    txtHoTen_20.Text = item.THANH_VIEN_TEN;
                    DropVaiTro_20.SelectedValue = item.VAI_TRO;
                }
                else
                {
                    txtHoTen_20.Text = "";
                    DropVaiTro_20.SelectedIndex = 0;
                }
            }
            #endregion
            #region Load Chi tiết kiểm phiếu
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_HO_SO_ID",HoSoID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_DANH_SACH_DOI_TUONG_GET_PHIEU_BAU", parameters);
            dgList.DataSource = tbl;
            dgList.DataBind();
            #endregion
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            if (!CheckDataInput())
            {
                return;
            }
            bool IsNew = false;
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"])
                , DonViID = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"])
                , BienBanID = 0;
            #region Lưu biên bản kiểm phiếu
            TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU Obj = dt.TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (Obj == null)
            {
                IsNew = true;
                Obj = new TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU();
                Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYTAO = DateTime.Now;
            }
            else
            {
                Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYSUA = DateTime.Now;
            }
            Obj.HO_SO_ID = HoSoID;
            Obj.VE_VIEC = TxtVeViec.Text.Trim();
            Obj.SO_THANH_VIEN_KIEM_PHIEU = Convert.ToDecimal(DropSoThanhVien.SelectedValue);
            Obj.NGAY_LAP_BIEN_BAN = Convert.ToDateTime(TxtNgay.Text, cul);
            Obj.TONG_SO_NGUOI = Convert.ToDecimal(TxtTong_Ca_Nhan_DK.Text);
            Obj.NGUOI_CO_MAT = Convert.ToDecimal(TxtCa_Nhan_Co_Mat.Text);
            Obj.NGUOI_VANG_MAT = Convert.ToDecimal(TxtCa_Nhan_Vang_Mat.Text);
            Obj.SO_PHIEU_PHAT = Convert.ToDecimal(TxtSoPhieu_Phat_Ra.Text);
            Obj.SO_PHIEU_THU = Convert.ToDecimal(TxtSoPhieu_Thu_Ve.Text);
            Obj.SO_PHIEU_THU_HOP_LE = Convert.ToDecimal(TxtSoPhieu_Thu_Ve_Hop_Le.Text);
            Obj.SO_PHIEU_THU_KHONG_HOP_LE = Convert.ToDecimal(TxtSoPhieu_Thu_Ve_Khong_Hop_Le.Text);
            if (IsNew)
            {
                dt.TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU.Add(Obj);
            }
            dt.SaveChanges();
            BienBanID = Obj.ID;
            #endregion
            #region Lưu danh sách thành viên tham dự
            decimal ThuTu = 1, SoThanhVien = (decimal)Obj.SO_THANH_VIEN_KIEM_PHIEU;
            string ThanhVien_Ten = "", VaiTro = "";
            if (SoThanhVien >= 1)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_1.Value);
                ThanhVien_Ten = txtHoTen_1.Text.Trim();
                VaiTro = DropVaiTro_1.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 2)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_2.Value);
                ThanhVien_Ten = txtHoTen_2.Text.Trim();
                VaiTro = DropVaiTro_2.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 3)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_3.Value);
                ThanhVien_Ten = txtHoTen_3.Text.Trim();
                VaiTro = DropVaiTro_3.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 4)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_4.Value);
                ThanhVien_Ten = txtHoTen_4.Text.Trim();
                VaiTro = DropVaiTro_4.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 5)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_5.Value);
                ThanhVien_Ten = txtHoTen_5.Text.Trim();
                VaiTro = DropVaiTro_5.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 6)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_6.Value);
                ThanhVien_Ten = txtHoTen_6.Text.Trim();
                VaiTro = DropVaiTro_6.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 7)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_7.Value);
                ThanhVien_Ten = txtHoTen_7.Text.Trim();
                VaiTro = DropVaiTro_7.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 8)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_8.Value);
                ThanhVien_Ten = txtHoTen_8.Text.Trim();
                VaiTro = DropVaiTro_8.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 9)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_9.Value);
                ThanhVien_Ten = txtHoTen_9.Text.Trim();
                VaiTro = DropVaiTro_9.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 10)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_10.Value);
                ThanhVien_Ten = txtHoTen_10.Text.Trim();
                VaiTro = DropVaiTro_10.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 11)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_11.Value);
                ThanhVien_Ten = txtHoTen_11.Text.Trim();
                VaiTro = DropVaiTro_11.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 12)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_12.Value);
                ThanhVien_Ten = txtHoTen_12.Text.Trim();
                VaiTro = DropVaiTro_12.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 13)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_13.Value);
                ThanhVien_Ten = txtHoTen_13.Text.Trim();
                VaiTro = DropVaiTro_13.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 14)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_14.Value);
                ThanhVien_Ten = txtHoTen_14.Text.Trim();
                VaiTro = DropVaiTro_14.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 15)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_15.Value);
                ThanhVien_Ten = txtHoTen_15.Text.Trim();
                VaiTro = DropVaiTro_15.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 16)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_16.Value);
                ThanhVien_Ten = txtHoTen_16.Text.Trim();
                VaiTro = DropVaiTro_16.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 17)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_17.Value);
                ThanhVien_Ten = txtHoTen_17.Text.Trim();
                VaiTro = DropVaiTro_17.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 18)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_18.Value);
                ThanhVien_Ten = txtHoTen_18.Text.Trim();
                VaiTro = DropVaiTro_18.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 19)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_19.Value);
                ThanhVien_Ten = txtHoTen_19.Text.Trim();
                VaiTro = DropVaiTro_19.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            if (SoThanhVien >= 20)
            {
                ThuTu = Convert.ToDecimal(HddThuTu_20.Value);
                ThanhVien_Ten = txtHoTen_20.Text.Trim();
                VaiTro = DropVaiTro_20.SelectedValue;
                if (ThanhVien_Ten != "")
                    SaveThanhVienThamDu(BienBanID, ThuTu, ThanhVien_Ten, VaiTro);
            }
            #endregion
            #region Lưu chi tiết phiếu
            foreach (DataGridItem item in dgList.Items)
            {
                IsNew = false;
                decimal DoiTuongID = Convert.ToDecimal(item.Cells[0].Text);
                TextBox TxtSoPhieu_Binh_Xet = (TextBox)item.FindControl("TxtSoPhieu_Binh_Xet");
                TextBox TxtTyLe = (TextBox)item.FindControl("TxtTyLe");
                TDKT_HO_SO_KIEM_PHIEU ObjKP = dt.TDKT_HO_SO_KIEM_PHIEU.Where(x => x.BIEN_BAN_ID == BienBanID && x.DOI_TUONG_ID == DoiTuongID).FirstOrDefault();
                if (ObjKP == null)
                {
                    IsNew = true;
                    ObjKP = new TDKT_HO_SO_KIEM_PHIEU();
                }
                ObjKP.BIEN_BAN_ID = BienBanID;
                ObjKP.DOI_TUONG_ID = DoiTuongID;
                ObjKP.SO_PHIEU_BINH_XET = TxtSoPhieu_Binh_Xet.Text == "" ? 0 : Convert.ToDecimal(TxtSoPhieu_Binh_Xet.Text);
                ObjKP.TY_LE = Obj.SO_PHIEU_THU == 0 ? 0 : (ObjKP.SO_PHIEU_BINH_XET / Obj.SO_PHIEU_THU) * 100;
                if (IsNew)
                {
                    dt.TDKT_HO_SO_KIEM_PHIEU.Add(ObjKP);
                }
                dt.SaveChanges();
            }
            #endregion
            Lblthongbao.Text = "Lưu thành công.";
        }
        protected void BtnXoa_Click(object sender, EventArgs e)
        {
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"]);
            TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU BienBan = dt.TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (BienBan != null)
            {
                decimal BienBanID = (Decimal)BienBan.ID;
                List<TDKT_HO_SO_BIEN_BAN_KP_TV> lst = dt.TDKT_HO_SO_BIEN_BAN_KP_TV.Where(x => x.BIEN_BAN_ID == BienBanID).ToList();
                if (lst.Count > 0)
                {
                    dt.TDKT_HO_SO_BIEN_BAN_KP_TV.RemoveRange(lst);
                }
                List<TDKT_HO_SO_KIEM_PHIEU> lstKP = dt.TDKT_HO_SO_KIEM_PHIEU.Where(x => x.BIEN_BAN_ID == BienBanID).ToList();
                if (lstKP.Count > 0)
                {
                    dt.TDKT_HO_SO_KIEM_PHIEU.RemoveRange(lstKP);
                }
                dt.TDKT_HO_SO_BIEN_BAN_KIEM_PHIEU.Remove(BienBan);
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
        private void SaveThanhVienThamDu(decimal BienBanID, decimal ThuTu, string Ten, string VaiTro)
        {
            bool IsNew = false;
            TDKT_HO_SO_BIEN_BAN_KP_TV ObjThanhVien = dt.TDKT_HO_SO_BIEN_BAN_KP_TV.Where(x => x.BIEN_BAN_ID == BienBanID && x.THANH_VIEN_TEN == Ten && x.THANH_VIEN_CHUC_VU == VaiTro).FirstOrDefault();
            if (ObjThanhVien == null)
            {
                IsNew = true;
                ObjThanhVien = new TDKT_HO_SO_BIEN_BAN_KP_TV();
            }
            ObjThanhVien.BIEN_BAN_ID = BienBanID;
            ObjThanhVien.THANH_VIEN_TEN = Ten;
            ObjThanhVien.VAI_TRO = VaiTro;
            if (IsNew)
                dt.TDKT_HO_SO_BIEN_BAN_KP_TV.Add(ObjThanhVien);
            dt.SaveChanges();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView r = (DataRowView)e.Item.DataItem;
                TextBox TxtSoPhieu_Binh_Xet = (TextBox)e.Item.FindControl("TxtSoPhieu_Binh_Xet");
                TxtSoPhieu_Binh_Xet.Text = Convert.ToDecimal(r["SO_PHIEU_BINH_XET"]).ToString("#,0.##");
            }
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