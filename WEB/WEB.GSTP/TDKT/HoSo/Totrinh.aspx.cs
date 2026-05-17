using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.HoSo
{
    public partial class Totrinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const string VUTDKT_TANDTC = "1", DONVIKHAC = "0";
        private const decimal LUUTAM = 1, DAGUI = 2, TRALAI = 3, HOANTAT = 4;
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
                    decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"]);
                    TDKT_HO_SO Obj = dt.TDKT_HO_SO.Where(x => x.ID == HoSoID).FirstOrDefault();
                    if (Obj != null)
                    {
                        if (HdfVuTDKT.Value == VUTDKT_TANDTC)
                        {
                            BtnLuu.Visible = BtnXoa.Visible = false;
                        }
                        else
                        {
                            BtnLuu.Visible = BtnXoa.Visible = true;
                            if (Obj.TRANGTHAI == DAGUI || Obj.TRANGTHAI == HOANTAT)
                            {
                                BtnLuu.Visible = BtnXoa.Visible = false;
                            }
                        }
                    }
                    LoadDropDonVi_DeNghi();
                    LoadDropDonVi_CapTren();
                    LoadInfo(HoSoID);
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi_DeNghi()
        {
            decimal DonViID = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"]);
            DM_TOAAN Obj = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
            if (Obj != null)
            {
                DropDonVi_DeNghi.Items.Add(new ListItem(Obj.TEN, DonViID.ToString()));
            }
            else { DropDonVi_DeNghi.Items.Add(new ListItem("--- Chọn ---", "0")); }
        }
        private void LoadDropDonVi_CapTren()
        {
            decimal DonViID = Convert.ToDecimal(DropDonVi_DeNghi.SelectedValue);
            DM_TOAAN Obj = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
            if (Obj != null)
            {
                DM_TOAAN ObjCapTren = dt.DM_TOAAN.Where(x => x.ID == Obj.CAPCHAID).FirstOrDefault();
                if (ObjCapTren != null)
                {
                    DropDonVi_CapTren.Items.Add(new ListItem(ObjCapTren.TEN, ObjCapTren.ID.ToString()));
                    if (ObjCapTren.CAPCHAID > 0)
                    {
                        LoadParentDonVi((decimal)ObjCapTren.CAPCHAID);
                    }
                    DropDonVi_CapTren.SelectedIndex = DropDonVi_CapTren.Items.Count - 1;
                }
                else
                    DropDonVi_CapTren.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
            else { DropDonVi_CapTren.Items.Add(new ListItem("--- Chọn ---", "0")); }
        }
        private void LoadParentDonVi(decimal ParentID)
        {
            DM_TOAAN ObjCapTren = dt.DM_TOAAN.Where(x => x.ID == ParentID).FirstOrDefault();
            if (ObjCapTren != null)
            {
                DropDonVi_CapTren.Items.Add(new ListItem(ObjCapTren.TEN, ObjCapTren.ID.ToString()));
                if (ObjCapTren.CAPCHAID > 0)
                {
                    LoadParentDonVi((decimal)ObjCapTren.CAPCHAID);
                }
            }
        }
        private void LoadInfo(decimal HoSoID)
        {
            TDKT_HO_SO_TO_TRINH Obj = dt.TDKT_HO_SO_TO_TRINH.Where(x => x.HO_SO_ID == HoSoID).FirstOrDefault();
            if (Obj != null)
            {
                DropDonVi_DeNghi.SelectedValue = Obj.DONVIID + "";
                DropDonVi_CapTren.SelectedValue = Obj.DON_VI_CAP_TREN + "";
                TxtSoToTrinh.Text = Obj.SO_TO_TRINH;
                TxtNgayTrinh.Text = Obj.NGAY_TRINH + "" == "" ? "" : ((DateTime)Obj.NGAY_TRINH).ToString("dd/MM/yyyy");
                TxtVeViec.Text = Obj.VE_VIEC;
                TxtNguoiKy.Text = Obj.THU_TRUONG_DON_VI;
                BtnXoa.Visible = true;
            }
            else
                BtnXoa.Visible = false;
        }
        protected void BtnXoa_Click(object sender, EventArgs e)
        {
            decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"])
                    , DonViID = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"]);
            TDKT_HO_SO_TO_TRINH Obj = dt.TDKT_HO_SO_TO_TRINH.Where(x => x.HO_SO_ID == HoSoID && x.DONVIID == DonViID).FirstOrDefault();
            if (Obj != null)
            {
                dt.TDKT_HO_SO_TO_TRINH.Remove(Obj);
                dt.SaveChanges();
            }
            Lblthongbao.Text = "Xóa thành công.";
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckDataInput())
                {
                    return;
                }
                bool IsNew = false;
                decimal HoSoID = Request["hso"] + "" == "" ? 0 : Convert.ToDecimal(Request["hso"])
                    , DonViID = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"]);
                TDKT_HO_SO_TO_TRINH Obj = dt.TDKT_HO_SO_TO_TRINH.Where(x => x.HO_SO_ID == HoSoID && x.DONVIID == DonViID).FirstOrDefault();
                if (Obj == null)
                {
                    IsNew = true;
                    Obj = new TDKT_HO_SO_TO_TRINH();
                    Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    Obj.NGAYTAO = DateTime.Now;
                }
                else
                {
                    Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    Obj.NGAYSUA = DateTime.Now;
                }
                Obj.HO_SO_ID = HoSoID;
                Obj.DONVIID = DonViID;
                Obj.DON_VI_CAP_TREN = Convert.ToDecimal(DropDonVi_CapTren.SelectedValue);
                Obj.SO_TO_TRINH = TxtSoToTrinh.Text.Trim();
                Obj.NGAY_TRINH = TxtNgayTrinh.Text == "" ? DateTime.Now : Convert.ToDateTime(TxtNgayTrinh.Text, cul);
                Obj.VE_VIEC = TxtVeViec.Text.Trim();
                Obj.DANH_SACH_ID = 0;// Đã có ở hồ sơ
                Obj.THU_TRUONG_DON_VI = TxtNguoiKy.Text.Trim();
                if (IsNew)
                    dt.TDKT_HO_SO_TO_TRINH.Add(Obj);
                dt.SaveChanges();
                Lblthongbao.Text = "Lưu thành công.";
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string Link = Cls_Comon.GetRootURL() + "/TDKT/HoSo/Danhsach.aspx?dv=" + Request["dv"] + "&pag=" + Request["pag"];
            Response.Redirect(Link);
        }
        protected void DropDonVi_DeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropDonVi_CapTren();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private bool CheckDataInput()
        {
            int Length = TxtSoToTrinh.Text.Trim().Length;
            if (Length == 0)
            {
                TxtSoToTrinh.Focus();
                Lblthongbao.Text = "Chưa nhập số tờ trình. Hãy nhập lại.";
                return false;
            }
            else if (Length > 100)
            {
                TxtSoToTrinh.Focus();
                Lblthongbao.Text = "Số tờ trình không được quá 100 ký tự. Hãy nhập lại.";
                return false;
            }
            if (TxtNgayTrinh.Text.Trim() != "")
            {
                if (!Cls_Comon.IsValidDate(TxtNgayTrinh.Text))
                {
                    TxtNgayTrinh.Focus();
                    Lblthongbao.Text = "Ngày trình phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
                    return false;
                }
                DateTime NgayTrinh = Convert.ToDateTime(TxtNgayTrinh.Text, cul);
                if (NgayTrinh > DateTime.Now)
                {
                    TxtNgayTrinh.Focus();
                    Lblthongbao.Text = "Ngày trình phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                    return false;
                }
            }
            Length = TxtVeViec.Text.Trim().Length;
            if (Length == 0)
            {
                TxtVeViec.Focus();
                Lblthongbao.Text = "Chưa nhập về việc. Hãy nhập lại.";
                return false;
            }
            else if (Length > 500)
            {
                TxtVeViec.Focus();
                Lblthongbao.Text = "Về việc không được quá 500 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtNguoiKy.Text.Trim().Length;
            if (Length > 250)
            {
                TxtNguoiKy.Focus();
                Lblthongbao.Text = "Người ký không được quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            return true;
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