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
    public partial class Edit : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3, LUUTAM = 1, DAGUI = 2, TRALAI = 3, HOANTAT = 4;
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
                        HdfVuTDKT.Value = VUTDKT_TANDTC;// User đăng nhập thuộc Vụ Thi đua - Khen thưởng Tòa án nhân dân tối cao
                    else
                        HdfVuTDKT.Value = DONVIKHAC;
                }
                if (!IsPostBack)
                {
                    LoadDropDonVi();
                    LoadDanhSach();
                    hddID.Value = Request["hso"] + "" == "" ? "0" : Request["hso"] + "";
                    decimal HoSoID = 0;
                    decimal.TryParse(hddID.Value, out HoSoID);
                    hddID.Value = HoSoID.ToString();
                    LoadInfo(HoSoID);
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi()
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            string LoaiToa = "";
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
            if (ObjTA != null)
            {
                LoaiToa = ObjTA.LOAITOA;
            }
            if (LoaiToa == "TOICAO")
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropToaAn.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            if (Request["dv"] + "" != "")
            {
                try { DropToaAn.SelectedValue = Request["dv"] + ""; } catch { }
            }
        }
        private void LoadDanhSach()
        {
            DropDanhSach.Items.Clear();
            decimal LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue)
                , DonVi = Convert.ToDecimal(DropToaAn.SelectedValue);
            List<TDKT_DANH_SACH> lst = dt.TDKT_DANH_SACH.Where(x => x.LOAI_DE_NGHI == LoaiDeNghi && x.TOAANID == DonVi).ToList();
            if (lst.Count > 0)
            {
                DropDanhSach.DataSource = lst;
                DropDanhSach.DataTextField = "TEN_DANH_SACH";
                DropDanhSach.DataValueField = "ID";
                DropDanhSach.DataBind();
            }
            else DropDanhSach.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        private void LoadInfo(decimal ID)
        {
            try
            {
                TDKT_HO_SO Obj = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
                if (Obj != null)
                {
                    DropToaAn.SelectedValue = Obj.DONVIID.ToString();
                    TxtMa.Text = Obj.MA_HO_SO;
                    TxtTen.Text = Obj.TEN_HO_SO;
                    if (Obj.LOAI_DE_NGHI + "" != "")
                        DropLoaiDeNghi.SelectedValue = Obj.LOAI_DE_NGHI.ToString();
                    LoadDanhSach();
                    if (Obj.DANH_SACH_ID + "" != "")
                        DropDanhSach.SelectedValue = Obj.DANH_SACH_ID.ToString();
                    if (HdfVuTDKT.Value == VUTDKT_TANDTC)
                    {
                        BtnLuu.Visible = BtnLamMoi.Visible = false;
                    }
                    else
                    {
                        BtnLuu.Visible = BtnLamMoi.Visible = true;
                        if (Obj.TRANGTHAI == DAGUI || Obj.TRANGTHAI == HOANTAT)
                        {
                            BtnLuu.Visible = BtnLamMoi.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void ResetData()
        {
            DropToaAn.SelectedIndex = 0;
            TxtMa.Text = "";
            TxtTen.Text = "";
            hddID.Value = "0";
            DropLoaiDeNghi.SelectedIndex = 0;
            DropLoaiDeNghi_SelectedIndexChanged(new object(), new EventArgs());
            Lblthongbao.Text = "";
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateData())
                {
                    return;
                }
                SaveData(LUUTAM);
                Lblthongbao.Text = "Lưu thành công.";
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Danhsach.aspx?dv=" + Request["dv"] + "&pag=" + Request["pag"];
            Response.Redirect(Link);
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
        private void SaveData(decimal TrangThai)
        {
            bool IsNew = false;
            decimal ID = Convert.ToDecimal(hddID.Value);
            TDKT_HO_SO Obj = dt.TDKT_HO_SO.Where(x => x.ID == ID).FirstOrDefault();
            if (Obj == null)
            {
                IsNew = true;
                Obj = new TDKT_HO_SO();
                Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYTAO = DateTime.Now;
            }
            else
            {
                Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYSUA = DateTime.Now;
            }
            Obj.DONVIID = Convert.ToDecimal(DropToaAn.SelectedValue);
            Obj.MA_HO_SO = TxtMa.Text.Trim();
            Obj.TEN_HO_SO = TxtTen.Text.Trim();
            Obj.LOAI_DE_NGHI = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue);
            Obj.DANH_SACH_ID = Convert.ToDecimal(DropDanhSach.SelectedValue);
            Obj.TRANGTHAI = TrangThai;
            Obj.NGAY_GUI_TRINH = (DateTime?)null;
            if (IsNew)
                dt.TDKT_HO_SO.Add(Obj);
            dt.SaveChanges();
        }
        private bool ValidateData()
        {
            decimal Value = Convert.ToDecimal(DropToaAn.SelectedValue);
            if (Value == 0)
            {
                Lblthongbao.Text = "Chưa chọn đơn vị. Hãy chọn lại.";
                DropToaAn.Focus();
                return false;
            }
            int Length = TxtMa.Text.Trim().Length;
            if (Length > 100)
            {
                Lblthongbao.Text = "Mã hồ sơ không quá 100 ký tự. Hãy nhập lại.";
                TxtMa.Focus();
                return false;
            }
            Length = TxtTen.Text.Trim().Length;
            if (Length == 0)
            {
                Lblthongbao.Text = "Tên hồ sơ không được để trống. Hãy nhập lại.";
                TxtTen.Focus();
                return false;
            }
            else if (Length > 500)
            {
                Lblthongbao.Text = "Tên hồ sơ không quá 500 ký tự. Hãy nhập lại.";
                TxtTen.Focus();
                return false;
            }
            Value = Convert.ToDecimal(DropDanhSach.SelectedValue);
            if (Value == 0)
            {
                Lblthongbao.Text = "Chưa chọn danh sách. Hãy chọn lại.";
                DropDanhSach.Focus();
                return false;
            }
            return true;
        }
        private bool IsExistsData(decimal ID)
        {
            TDKT_HO_SO_TO_TRINH Obj = dt.TDKT_HO_SO_TO_TRINH.Where(x => x.HO_SO_ID == ID).FirstOrDefault();
            if (Obj != null)
            {
                Lblthongbao.Text = "Đã có tờ trình trong hồ sơ. Không được xóa.";
                return true;
            }
            return false;
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDanhSach();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void DropLoaiDeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDanhSach();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
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