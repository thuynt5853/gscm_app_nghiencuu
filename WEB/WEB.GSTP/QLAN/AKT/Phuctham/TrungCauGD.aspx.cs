using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AKT;
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

namespace WEB.GSTP.QLAN.AKT.PhucTham
{
    public partial class TrungCauGD : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        AKT_TRUNGCAU_GIAMDINH obj = new AKT_TRUNGCAU_GIAMDINH();
        private Decimal MaGiaiDoan = 0, VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                MaGiaiDoan = Convert.ToDecimal(ENUM_GIAIDOANVUAN.PHUCTHAM);
                VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                hddMaGiaiDoan.Value = MaGiaiDoan + "";
                hddVuAnID.Value = VuAnID + "";
                AKT_TRUNGCAU_GIAMDINH oT = dt.AKT_TRUNGCAU_GIAMDINH.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
                if (oT != null)
                {
                    LoadInfo();
                }
                else
                {
                    loadPanelso2.Visible = false;
                    loadPanelso3.Visible = false;
                }

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdateBottom, oPer.CAPNHAT);
                //Kiểm tra thẩm phán giải quyết đơn 
                AKT_DON oVAT = dt.AKT_DON.Where(x => x.ID == VuAnID).FirstOrDefault();
                List<AKT_PHUCTHAM_THULY> lstCount = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == VuAnID).ToList();
                if (lstCount.Count == 0 || oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                List<AKT_DON_THAMPHAN> lstTP = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                if (lstTP.Count == 0)
                {
                    lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                if (oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }
                if (oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
                    return;
                }


                //Nếu mà là án đã kết thúc ẩn nút lưu 
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc == true && oT != null && oT.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                {
                    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdateBottom, false);
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
                //    int countItem = dt.AKT_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == VuAnID && s.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM");
                //    if (countItem > 0)
                //    {
                //        //được gán 
                //    }
                //    else
                //    {
                //        //không được gán
                //        string StrMsg = "Người dùng không được sửa đổi thông tin của vụ việc do không được phân công giải quyết.";
                //        lbthongbao.Text = StrMsg;
                //        Cls_Comon.SetButton(cmdUpdateBottom, false);
                //        return;
                //    }
                //}
            }
        }

        public void LoadInfo()
        {
            AKT_TRUNGCAU_GIAMDINH oT = dt.AKT_TRUNGCAU_GIAMDINH.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
            if (oT != null)
            {
                rdduongsu_yeucau.SelectedValue = oT.ISDUONGSUYEUCAU + "";
                rdtoaan_giamdinh.SelectedValue = oT.ISTOATUTRUNGCAU + "";
                if (rdtoaan_giamdinh.SelectedValue == "1" || rdduongsu_yeucau.SelectedValue == "1")
                {
                    txtthoigiangiamdinh.Text = (oT.SODAPUNGTHOIGIAN) + "";
                    txtgiamdinhlai.Text = (oT.SOKETLUANGIAMDINHLAI) + "";
                    txtgiamdinhbosung.Text = (oT.SOKETLUANBOSUNG) + "";
                    //------------------------------------------------
                    txtxaydung.Text = (oT.XAYDUNG) + "";
                    txtmatuy.Text = (oT.MATUY) + "";
                    txtnganhang.Text = (oT.NGANHANG) + "";
                    txtphapy_tamthan.Text = (oT.PHAPYTAMTHAN) + "";
                    txttaichinh.Text = (oT.TAICHINH) + "";
                    txtphapy.Text = (oT.PHAPY) + "";
                    txtKithuathinhsu.Text = (oT.KYTHUATHINHSU) + "";
                    txttruyenthong.Text = (oT.THONGTINTT) + "";
                    txtlinhvuckhac.Text = (oT.KHAC) + "";
                }
                else
                {
                    loadPanelso2.Visible = false;
                    loadPanelso3.Visible = false;
                }
            }
        }

        protected void rdtoaan_giamdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdtoaan_giamdinh.SelectedValue == "1" || rdduongsu_yeucau.SelectedValue == "1")
            {
                loadPanelso2.Visible = true;
                loadPanelso3.Visible = true;
            }
            else
            {
                loadPanelso2.Visible = false;
                loadPanelso3.Visible = false;
            }
        }

        private bool validate()
        {

            return true;
        }
        protected void rdduongsu_yeucau_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (rdduongsu_yeucau.SelectedValue == "1" || rdtoaan_giamdinh.SelectedValue == "1")
            {
                loadPanelso2.Visible = true;
                loadPanelso3.Visible = true;
            }
            else
            {
                loadPanelso3.Visible = false;
                loadPanelso2.Visible = false;
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

        private void save_trungcau_giamdinh()
        {
            decimal YeuCau = Convert.ToDecimal(obj.ISDUONGSUYEUCAU);
            decimal TrungCau = Convert.ToDecimal(obj.ISTOATUTRUNGCAU);
            TrungCau = Convert.ToDecimal(rdtoaan_giamdinh.SelectedValue);
            YeuCau = Convert.ToDecimal(rdduongsu_yeucau.SelectedValue);
            obj.ISDUONGSUYEUCAU = Convert.ToDecimal(rdduongsu_yeucau.SelectedValue);
            obj.ISTOATUTRUNGCAU = Convert.ToDecimal(rdtoaan_giamdinh.SelectedValue);
            obj.VUANID = Convert.ToDecimal(hddVuAnID.Value);
            obj.MAGIAIDOAN = Convert.ToDecimal(hddMaGiaiDoan.Value);
            //------rd--------
            if (TrungCau > 0 || YeuCau > 0)
            {
                obj.SODAPUNGTHOIGIAN = Get_Number(txtthoigiangiamdinh.Text);
                obj.SOKETLUANGIAMDINHLAI = Get_Number(txtgiamdinhlai.Text);
                obj.SOKETLUANBOSUNG = Get_Number(txtgiamdinhbosung.Text);

                obj.XAYDUNG = Get_Number(txtxaydung.Text);
                obj.MATUY = Get_Number(txtmatuy.Text);
                obj.NGANHANG = Get_Number(txtnganhang.Text);
                obj.PHAPYTAMTHAN = Get_Number(txtphapy_tamthan.Text);
                obj.TAICHINH = Get_Number(txttaichinh.Text);
                obj.PHAPY = Get_Number(txtphapy.Text);
                obj.KYTHUATHINHSU = Get_Number(txtKithuathinhsu.Text);
                obj.THONGTINTT = Get_Number(txttruyenthong.Text);
                obj.KHAC = Get_Number(txtlinhvuckhac.Text);
            }
            else
            {
                loadPanelso2.Visible = false;
                obj.SODAPUNGTHOIGIAN = Get_Number(txtthoigiangiamdinh.Text);
                obj.SOKETLUANGIAMDINHLAI = Get_Number(txtgiamdinhlai.Text);
                obj.SOKETLUANBOSUNG = Get_Number(txtgiamdinhbosung.Text);

                obj.XAYDUNG = Get_Number(txtxaydung.Text);
                obj.MATUY = Get_Number(txtmatuy.Text);
                obj.NGANHANG = Get_Number(txtnganhang.Text);
                obj.PHAPYTAMTHAN = Get_Number(txtphapy_tamthan.Text);
                obj.TAICHINH = Get_Number(txttaichinh.Text);
                obj.PHAPY = Get_Number(txtphapy.Text);
                obj.KYTHUATHINHSU = Get_Number(txtKithuathinhsu.Text);
                obj.THONGTINTT = Get_Number(txttruyenthong.Text);
                obj.KHAC = Get_Number(txtlinhvuckhac.Text);
            }
        }
        protected void cmdUpdateBottom_Click(object sender, EventArgs e)
        {

            decimal mavuan = Convert.ToDecimal(hddVuAnID.Value);
            decimal MaGiaidoan = Convert.ToDecimal(hddMaGiaiDoan.Value);
            try
            {
                obj = dt.AKT_TRUNGCAU_GIAMDINH.Where(x => x.VUANID == mavuan && x.MAGIAIDOAN == MaGiaidoan).SingleOrDefault();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }

            if (obj != null)
            {
                save_trungcau_giamdinh();
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj = new AKT_TRUNGCAU_GIAMDINH();
                save_trungcau_giamdinh();
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                // insert toa_gq_id
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AKT_TRUNGCAU_GIAMDINH.Add(obj);
                dt.SaveChanges();
            }
            lbthongbao.Text = "Lưu thành công!";

        }
    }
}