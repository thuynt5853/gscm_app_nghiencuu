using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Globalization;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;
using System.IO;
using VGCA;
using BL.DonKK;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DoiMucDichSDTK : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrentYear = 0;
        public decimal QuocTichVN = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                                        
                    CheckMucDichSD();
                    //Set AuthCode to Session-------------------------
                    Session.Add("AuthCode", WebAuth.GetAuthCode());
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }

        void CheckMucDichSD()
        {
            String Ma_DoiMucDichSD = hddMaDoiMucDichSD.Value;
            int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");

            if (MucDichSD == 2)
            {
                //KT: Neu muon doi muc dich su dung tk : VD: Chi nhan Vb--> cho gui donkk--> show thong bao
                pnThongBao.Visible = true;
                //KT: Neu dang dang ky doi muc dich su dung ma chua duoc duyet thi hien thi thong bao sau
                DONKK_DON_BL obj = new DONKK_DON_BL();
                DataTable table = obj.GetYeuCauThayDoi(UserID);
                if (table.Rows.Count > 0)
                {
                    lttMsgDoiMucDichSD.Text = "Ông(bà) đã đăng ký thay đổi mục đích sử dụng từ <b>Chỉ nhận văn bản tống đạt</b> sang <b>Nộp đơn khởi kiện và nhận văn bản tống đạt</b> " +
                        "</br> <b>Yêu cầu đang được xét duyệt</b>";
                    cmdThaydoi.Visible = false;
                }    
                else
                    lttMsgDoiMucDichSD.Text = LoadThongTinTinhTheoMa(Ma_DoiMucDichSD);
                pnUserLogin.Visible = false;
            }
            pnUserLogin.Visible = true;
            LoadInfo();
        }
        String LoadThongTinTinhTheoMa(string MaThongBao)
        {
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(MaThongBao);
            if (!String.IsNullOrEmpty(NoiDung))
                return NoiDung;
            else
                return "";
        }

        void LoadInfo()
        {
            lttTenLoaiTK.Text = "Thông tin cá nhân";
            DONKK_USERS obj = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            if (obj != null)
            {
                
                //-----------------------------------   
                int mucdichsd = (string.IsNullOrEmpty(obj.MUCDICH_SD + "")) ? 1 : (int)obj.MUCDICH_SD;
                if (mucdichsd == 1)
                    lblLogin_MucDichSD.Text = "Nộp đơn khởi kiện và nhận văn bản tống đạt";
                else
                    lblLogin_MucDichSD.Text = "Chỉ nhận văn bản tống đạt";

                //-----------------------------------
                lblLogin_Email.Text = obj.EMAIL;

                lblLogin_MaSoThue.Text = obj.DN_MASOTHUE;
              
                lblLogin_HoTen.Text = obj.NDD_HOTEN;
                lblLogin_NgaySinh.Text = obj.NDD_NGAYSINH != null ? ((DateTime)obj.NDD_NGAYSINH).ToString("dd/MM/yyyy", cul) : "";
                lblLogin_NoiCongTac.Text = obj.NDD_CQ + "";
                lblLogin_CMND.Text = obj.NDD_CMND;
                //-----------------------------------
                String StrDiaChi = "";
                DM_HANHCHINH objHC = null;
                StrDiaChi = (String.IsNullOrEmpty(obj.TAMTRU_CHITIET + "")) ? "" : obj.TAMTRU_CHITIET;
                decimal huyen_id = string.IsNullOrEmpty(obj.TAMTRU_HUYEN + "") ? 0 : (decimal)obj.TAMTRU_HUYEN;
                decimal tinh_id = string.IsNullOrEmpty(obj.TAMTRU_TINHID + "") ? 0 : (decimal)obj.TAMTRU_TINHID;
                if (huyen_id > 0)
                {
                    objHC = gsdt.DM_HANHCHINH.Where(x => x.ID == obj.TAMTRU_HUYEN).Single();
                    if (objHC != null)
                        StrDiaChi = (String.IsNullOrEmpty(StrDiaChi + "")) ? objHC.MA_TEN : (StrDiaChi + ", " + objHC.MA_TEN);
                }
                else if (tinh_id > 0)
                {
                    objHC = gsdt.DM_HANHCHINH.Where(x => x.ID == obj.TAMTRU_TINHID).Single();
                    if (objHC != null)
                        StrDiaChi = (String.IsNullOrEmpty(StrDiaChi + "")) ? objHC.MA_TEN : (StrDiaChi + ", " + objHC.MA_TEN);
                }
                lblLogin_DiaChi.Text = StrDiaChi;
            }
        }

        protected void cmdInBieuMau_Click(object sender, EventArgs e)
        {
            int status = Convert.ToInt16(hddCheckTK.Value);
            if (status == 0)
            {
                //In bieu mau xac nhan tai khoan
                InBieuMauXN();
            }
            else
            {
                //Update tai khoan = thong tin lay tu chung thu so
                UpdateTaiKhoanCTS();
            }
        }
        void InBieuMauXN()
        {
            Boolean IsUpdate = false;
            DONKK_USER_DOIMUCDICHSD obj = new DONKK_USER_DOIMUCDICHSD();
            obj = dt.DONKK_USER_DOIMUCDICHSD.Where(x => x.USERID == UserID).FirstOrDefault();
            if (obj != null)
            {
                IsUpdate = true;
                obj.MODIFYDATE = DateTime.Now;
            }
            else
            {
                obj = new DONKK_USER_DOIMUCDICHSD();
            }
            obj.USERID = UserID;
            obj.USERTYPE_NEW = 1;
            obj.HOTEN_NEW = Cls_Comon.FormatTenRieng(lblHoTen.Text.Trim());
            obj.CMND_NEW = lblCMND.Text.Trim();
            obj.EMAIL_NEW = lttEmail.Text.Trim();
            obj.MASOTHUE_NEW = lttMaSoThue.Text.Trim();
            obj.NOILAMVIEC_NEW = lttDonVi.Text.Trim();
            obj.DVCAPCTS = lttDonViCapCKSo.Text.Trim();
            obj.STATUS = 0;

            //obj.TOAANNHANID = Convert.ToDecimal(hddToaAnID.Value);
            obj.MADANGKY = Cls_Comon.RandomString(10);
            if (!IsUpdate)
            {
                obj.CREATEDATE = DateTime.Now;
                dt.DONKK_USER_DOIMUCDICHSD.Add(obj);
            }

            dt.SaveChanges();
            decimal CurrDangKyID = obj.ID;
            hddCurrDangKyID.Value = obj.ID.ToString();
            //------------------------------
            Cls_Comon.CallFunctionJS(this, this.GetType(), "show_popup_doimucdichsudungTK()");
           // Response.Redirect("InBC.aspx?type=editmucdichsd&dkID=" + CurrDangKyID);
        }
        void UpdateTaiKhoanCTS()
        {
            DONKK_USERS obj = new DONKK_USERS();
            obj = dt.DONKK_USERS.Where(x => x.ID == UserID).Single<DONKK_USERS>();
            obj.MUCDICH_SD = 1; //nhan vb + guidkk
            obj.NDD_CMND = lblCMND.Text.Trim();
            obj.TAMTRU_CHITIET = obj.DIACHI_CHITIET = String.IsNullOrEmpty(lttDiaChi.Text.Trim()) ? lblLogin_DiaChi.Text.Trim() : lttDiaChi.Text.Trim();
            obj.DONVICAPCTSO = lttDonViCapCKSo.Text;
            obj.NDD_CQ = (String.IsNullOrEmpty(lttDonVi.Text.Trim())) ? lblLogin_NoiCongTac.Text.Trim() : lttDonVi.Text.Trim();

            if (!String.IsNullOrEmpty(lttMaSoThue.Text.Trim()))
            {
                obj.DN_MASOTHUE = lttMaSoThue.Text;
                if (obj.USERTYPE == 1)
                    obj.USERTYPE = 2;
            }
            else obj.USERTYPE = 1;

            obj.LASTLOGINDATE = DateTime.Now;
            obj.LASTLOGINIP = Cls_Comon.GetLocalIPAddress();
            obj.MODIFIEDDATE = DateTime.Now;
            dt.SaveChanges();

            lbthongbao.Text = "<div class='msg_thongbao'>Cập nhật thông tin tài khoản thành công!</div>";
            Response.Redirect("/Personnal/TaikhoanInfo.aspx");
        }
   
        protected void cmdThaydoi_Click(object sender, EventArgs e)
        {
            GuiYC_ThayDoi();
        }
        void GuiYC_ThayDoi()
        {
            DONKK_DON_BL obj = new DONKK_DON_BL();
            obj.UpdateGuiYeuCauThayDoi(UserID);
            lttMsgDoiMucDichSD.Text = "Ông(bà) đã đăng ký thay đổi mục đích sử dụng từ <b>Chỉ nhận văn bản tống đạt</b> sang <b>Nộp đơn khởi kiện và nhận văn bản tống đạt</b> thành công" +
                       "</br> <b>Yêu cầu sẽ được xét duyệt</b>";
            cmdThaydoi.Visible = false;
            //------------------------------
        }
        //void Check_ChuKySo()
        //{
        //    try
        //    {
        //        string authCode = Session["AuthCode"].ToString();
        //        string signature = Signature1.Value;
        //        WebAuth auth = new WebAuth(authCode, signature);
        //        if (auth.Validate())
        //        {
        //            pnThongTinCKSo.Visible = true;
        //            //lttTrangThai.Text = "<div class='ok'></div>";
        //            String CMND = auth.CertificateInfo.UID;
        //            CMND = CMND.Replace("CMND", "");
        //            CMND = CMND.Replace(":", "");                    
        //            lblCMND.Text = CMND;

        //            //--------Xac nhan chu ky so thanh cong----------
        //            string Subject = auth.Certificate.Subject;
        //            string[] arr = Subject.Split(',');
        //            string[] temp = null;
        //            string tinh = "", quoctich = "", masothue;
        //            foreach (string item in arr)
        //            {
        //                if (item.Length > 0)
        //                {
        //                    temp = item.Trim().Split('=');
        //                    switch (temp[0] + "")
        //                    {
        //                        case "L":
        //                            tinh = temp[1] + "";
        //                            lttDiaChi.Text = tinh;
        //                            break;
        //                        case "C":
        //                            quoctich = temp[1] + "";
        //                            lblQuocTich.Text = quoctich;
        //                            break;
        //                        case "MST":
        //                            masothue = temp[1] + "";
        //                            lttMaSoThue.Text = masothue;
        //                            break;
        //                    }
        //                }
        //            }


        //            //-----------------------
        //            String temp_hoten = auth.CertificateInfo.CommonName;
        //            lblHoTen.Text = temp_hoten;

        //            //-----------------------------
        //            string temp_email = auth.CertificateInfo.Email;
        //            lttEmail.Text = temp_email;

        //            string temp_coquan = auth.CertificateInfo.O;
        //            string temp_donvi = auth.CertificateInfo.OU;
        //            lttDonVi.Text = temp_coquan + ((String.IsNullOrEmpty(temp_donvi)) ? "" : (", " + temp_donvi));

        //            //-------------------------------------
        //            Subject = auth.Certificate.Issuer;
        //            arr = Subject.Split(',');
        //            string str1 = "", str2 = "";
        //            foreach (string item in arr)
        //            {
        //                if (item.Length > 0)
        //                {
        //                    temp = item.Trim().Split('=');
        //                    switch (temp[0] + "")
        //                    {
        //                        case "CN":
        //                            str1 = temp[1] + "";
        //                            break;
        //                        case "O":
        //                            str2 = temp[1] + "";
        //                            break;
        //                    }
        //                }
        //            }
        //            lttDonViCapCKSo.Text = str1 + ((String.IsNullOrEmpty(str2)) ? "" : (", " + str2));


        //            cmdCheckChuKySo.Visible = false;
        //            cmdInBieuMau.Visible = true;
        //            pnUserLogin.Visible = true;
        //            LoadInfo();

        //            //-------------------------------
        //            if ((lblHoTen.Text == lblLogin_HoTen.Text) && (lttEmail.Text == lblLogin_Email.Text))
        //            {
        //                hddCheckTK.Value = "1";                       
        //                cmdInBieuMau.Text = "Đổi mục đích sử dụng";
        //            }
        //            else
        //            {
        //                hddCheckTK.Value = "0";
        //                cmdInBieuMau.Text = "In biểu mẫu";
        //            }

        //            if (CheckExistEmail(lttEmail.Text.Trim()))
        //            {
        //                cmdInBieuMau.Visible = false;

        //                lbthongbao.Text = "Địa chỉ email trong Chứng thư số này"
        //                                + " đã được sử dụng bởi một tài khoản khác.";
        //            }
        //            else
        //            {
        //                pnChonToaAn.Visible = true;
        //            }
        //        }
        //        else
        //        {
        //            string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt";
        //            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
        //            pnThongTinCKSo.Visible = false;
        //            // lttThongBao.Text = thongbao;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        // Response.Write("Lỗi: " + ex.Message);
        //        string thongbao = "Thiết bị chứng thư số chưa được tích hợp vào máy tính/VGCA Sign Service chưa được kích hoạt";
        //        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", thongbao);
        //        pnThongTinCKSo.Visible = false;
        //       // lttThongBao.Text = thongbao;
        //    }
        //}
        Boolean CheckExistEmail(string temp_email)
        {
            string email = temp_email.ToLower();
            /*-----KT: Chu ky so da duoc dk hay chua*/
            try
            {
                DONKK_USERS objUser = dt.DONKK_USERS.Where(x => x.EMAIL.ToLower() == email 
                                                             && x.ID != UserID).Single<DONKK_USERS>();
                if (objUser != null)
                {
                    //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Địa chỉ email này đã được dùng đăng ký tài khoản trong hệ thống. Đề nghị kiểm tra lại!");                
                    return true;
                }
                else return false;
            }
            catch (Exception ex) { return false; }
        }
    }
}