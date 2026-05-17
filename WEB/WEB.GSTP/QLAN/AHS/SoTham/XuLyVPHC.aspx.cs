using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class XuLyVPHC : System.Web.UI.Page
    {
        decimal VuAnID = 0, MaGiaiDoan = 0;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        AHS_XULY_VIPHAMHC obj = new AHS_XULY_VIPHAMHC();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MaGiaiDoan = Convert.ToDecimal(ENUM_GIAIDOANVUAN.SOTHAM);
                VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                hddMaGD.Value = MaGiaiDoan + "";
                hddVuAnID.Value = VuAnID + "";
                AHS_XULY_VIPHAMHC oT = dt.AHS_XULY_VIPHAMHC.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
                if (oT != null)
                {
                    loadinfro();
                }
                AHS_VUAN oDT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                if (oDT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                List<AHS_SOTHAM_THULY> lstCount = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).ToList();
                if (lstCount.Count == 0)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                List<AHS_THAMPHANGIAIQUYET> lstTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                if (lstTP.Count == 0)
                {
                    lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
                //int counttk = oCBDT.Rows.Count;
                //if (counttk > 0)
                //{
                //    //là thư k
                //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
                //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
                //    //int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
                //    int countItem = dt.AHS_THAMPHANGIAIQUYET.Count(s => s.THUKYID == CurrentUserId && s.VUANID == VuAnID && s.MAVAITRO == "VTTP_GIAIQUYETSOTHAM");
                //    if (countItem > 0)
                //    {
                //        //được gán 
                //    }
                //    else
                //    {
                //        //không được gán
                //        StrMsg = "Người dùng không được sửa đổi thông tin của vụ án do không được phân công giải quyết.";
                //        lbthongbao.Text = StrMsg;
                //        Cls_Comon.SetButton(cmdUpdateBottom, false);
                //        return;
                //    }
                //}
            }
        }
        void loadinfro()
        {
            AHS_XULY_VIPHAMHC oT = dt.AHS_XULY_VIPHAMHC.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
            if (oT != null)
            {
                txtTongso_truonghop.Text = (oT.TONGSO) + "";
                //-------
                txtSoTruongHop.Text = (oT.CHINH_PHATTIEN) + "";
                txtPhatcanhcao.Text = (oT.CHINH_CANHCAO) + "";
                txttichthuphuongtien_HP.Text = (oT.CHINH_TICHTHU) + "";
                txtSoTien.Text = ((!string.IsNullOrEmpty(oT.CHINH_SOTIEN + "")) && oT.CHINH_SOTIEN > 0) ? ((Int64)oT.CHINH_SOTIEN).ToString("#,#", cul) : "";
                //-------
                txtTichthubosung.Text = (oT.HINHPHAT_BOSUNG) + "";
                
            }
        }
        private static decimal Get_Number(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return 0;
                else
                    return Convert.ToDecimal(obj);
            }
            catch (Exception ex)
            { return 1; }
        }
        void Save_XuLyVPHC()
        {

            obj.VUANID = Convert.ToDecimal(hddVuAnID.Value);
            obj.MAGIAIDOAN = Convert.ToDecimal(hddMaGD.Value);
            obj.TONGSO = Get_Number(txtTongso_truonghop.Text);
            obj.CHINH_CANHCAO = Get_Number(txtPhatcanhcao.Text);
            obj.CHINH_PHATTIEN = Get_Number(txtSoTruongHop.Text);
            obj.CHINH_SOTIEN = Get_Number((String.IsNullOrEmpty(txtSoTien.Text)) ? 0 : Convert.ToDecimal(txtSoTien.Text.Replace(".", "")));
            obj.CHINH_TICHTHU = Get_Number(txttichthuphuongtien_HP.Text); 

            obj.HINHPHAT_BOSUNG = Get_Number(txtTichthubosung.Text);
        }
        protected void cmdUpdateBottom_Click(object sender, EventArgs e)
        {
            decimal mavuan = Convert.ToDecimal(hddVuAnID.Value);
            decimal MaGiaidoan = Convert.ToDecimal(hddMaGD.Value);
            try
            {
                obj = dt.AHS_XULY_VIPHAMHC.Where(x => x.VUANID == mavuan && x.MAGIAIDOAN == MaGiaidoan).SingleOrDefault();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }

            if (obj != null)
            {
                Save_XuLyVPHC();
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj = new AHS_XULY_VIPHAMHC();
                Save_XuLyVPHC();
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_XULY_VIPHAMHC.Add(obj);
                dt.SaveChanges();
            }
            lbthongbao.Text = "Lưu thành công!";
        }
    }
}
