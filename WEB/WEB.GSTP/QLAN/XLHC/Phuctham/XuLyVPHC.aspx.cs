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
using NLog;

namespace WEB.GSTP.QLAN.XLHC.Phuctham
{
    public partial class XuLyVPHC : System.Web.UI.Page
    {
        decimal VuAnID = 0, MaGiaiDoan = 0;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        XLHC_XULY_VIPHAMHC obj = new XLHC_XULY_VIPHAMHC();
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    MaGiaiDoan = Convert.ToDecimal(ENUM_GIAIDOANVUAN.PHUCTHAM);
                    VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.BPXLHC] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    hddMaGD.Value = MaGiaiDoan + "";
                    hddVuAnID.Value = VuAnID + "";
                    XLHC_XULY_VIPHAMHC oT = dt.XLHC_XULY_VIPHAMHC.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
                    if (oT != null)
                    {
                        loadinfro();
                    }
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdateBottom, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn 
                    XLHC_DON oVAT = dt.XLHC_DON.Where(x => x.ID == VuAnID).FirstOrDefault();
                    List<XLHC_PHUCTHAM_THULY> lstCount = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == VuAnID).ToList();
                    if (lstCount.Count == 0 || oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oVAT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdUpdateBottom, false);
                        return;
                    }
                    List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
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

                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    decimal DONID = Convert.ToDecimal(current_id);
                    decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                        .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                        .FirstOrDefault();
                    if (chuyenNhanAn != null)
                    {
                        // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                        // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdateBottom, false);
                    }

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc && oT != null && oT.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdateBottom, false);
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }
        void loadinfro()
        {
            XLHC_XULY_VIPHAMHC oT = dt.XLHC_XULY_VIPHAMHC.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == MaGiaiDoan).SingleOrDefault();
            if (oT != null)
            {
                txtTichthubosung.Text = (oT.HINHPHAT_BOSUNG) + "";
                txtTongso_truonghop.Text = (oT.TONGSO) + "";

                txtSoTruongHop.Text = (oT.CHINH_PHATTIEN) + "";
                txtPhatcanhcao.Text = (oT.CHINH_CANHCAO) + "";
                txttichthuphuongtien_HP.Text = (oT.CHINH_TICHTHU) + "";
                txtSoTien.Text = (oT.CHINH_SOTIEN) + "";

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
            obj.CHINH_SOTIEN = Get_Number(txtSoTien.Text);
            obj.CHINH_TICHTHU = Get_Number(txttichthuphuongtien_HP.Text);
            obj.HINHPHAT_BOSUNG = Get_Number(txtTichthubosung.Text);

        }
        protected void cmdUpdateBottom_Click(object sender, EventArgs e)
        {
            decimal mavuan = Convert.ToDecimal(hddVuAnID.Value);
            decimal MaGiaidoan = Convert.ToDecimal(hddMaGD.Value);
            try
            {
                obj = dt.XLHC_XULY_VIPHAMHC.Where(x => x.VUANID == mavuan && x.MAGIAIDOAN == MaGiaidoan).SingleOrDefault();
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
                obj = new XLHC_XULY_VIPHAMHC();
                Save_XuLyVPHC();
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.XLHC_XULY_VIPHAMHC.Add(obj);
                dt.SaveChanges();
            }
            lbthongbao.Text = "Lưu thành công!";
        }

    }
}