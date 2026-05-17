using BL.GSTP;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NLog;
using BL.GSTP.BANGSETGET.AHS;

namespace WEB.GSTP
{
    public partial class Trangchu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        public static Logger logger = NLog.LogManager.GetCurrentClassLogger();  
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["MaHeThong"] + "" != "")
                {
                    decimal HeThongID = Convert.ToDecimal(Session["MaHeThong"].ToString()),
                            UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    string strMaCT = Session["MaChuongTrinh"] + "";
                    QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.ID == HeThongID).FirstOrDefault();
                    if (oT != null)
                    {
                        if (oT.MA == "GSTP" && (strMaCT == "" || strMaCT == "0"))
                        {
                            Response.Redirect("GSTP/Danhsachtonghop.aspx");
                        }
                    }
                    #region Nếu User là chánh án hoặc phó chánh án
                    DM_CANBO_BL bl = new DM_CANBO_BL();
                    DataTable tbl = bl.DM_CANBO_GETCA_PCA_BY_USERID(UserID);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        ThongKe.Visible = true;
                        VB_CTTCT_ChuaDang1.Visible = false;
                    }
                    else
                    {
                        VB_CTTCT_ChuaDang1.Visible = true;
                        ThongKe.Visible = false;
                    }

                    QT_MENU_BL qtBL = new QT_MENU_BL();
                    decimal IDNhom = 0;
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] != null && Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" != "")
                    {
                        IDNhom = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
                    }
                    DataTable lst_home = qtBL.Qt_Nhom_ISHome_Get_List(IDNhom);
                    VB_CTTCT_ChuaDang1.Visible = false;


                    decimal canboid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                    DM_CANBO CA_TANDTC = dt.DM_CANBO.Where(x => x.ID == canboid && x.TOAANID == 1 && x.CHUCVUID == 45).FirstOrDefault();

                    if (lst_home != null && lst_home.Rows.Count > 0 && lst_home.Rows[0]["VIEW_TK"] + "" == "1")
                    {
                        if (Session["MA_HDSD"] + "" == "QLA" || Session["MA_HDSD"] + "" == "")
                        {
                            if (CA_TANDTC != null)
                            {
                                ThongKe.Visible = false;//nếu là chánh án tòa án nhân dân tối cao thì ẩn
                            }
                            else
                            {
                                ThongKe.Visible = true;//anhvh vh đóng vào để tập huấn
                            }
                        }
                        else
                        {
                            ThongKe.Visible = false;
                        }
                        // VB_CTTCT_ChuaDang1.Visible = false;
                        if (CA_TANDTC != null)
                        {
                            GDTThongKe_Chanhan.Visible = true;
                            GDTThongKe.Visible = false;
                        }
                        else
                        {
                            GDTThongKe_Chanhan.Visible = false;
                            GDTThongKe.Visible = true;
                        }
                    }
                    else
                    {
                        // VB_CTTCT_ChuaDang1.Visible = true;
                        ThongKe.Visible = false;
                        GDTThongKe.Visible = false;
                        GDTThongKe_Chanhan.Visible = false;
                    }
                    //----------------------
                    if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        H_ThongKe.Visible = false;
                        H_ThongKe_CC.Visible = true;
                    }
                    else if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        H_ThongKe.Visible = true;
                        H_ThongKe_CC.Visible = false;
                    }
                    #endregion
                }
                var checkvalidate = DataExtensions.GetAllWithClause_Order<VALIDATE_TAIKHOAN_LOG>($"USER_ID={Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID])}").FirstOrDefault();
                if (checkvalidate == null)
                {
                    modal.Show();
                }
                else
                {
                    var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
                    if (checkvalidate.NGAY_THAY_DOI_MK == null)
                    {
                        modal.Show();
                    }
                    else if (!string.IsNullOrEmpty(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) && int.Parse(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) > 0)
                    {
                        TimeSpan soGioTime = DateTime.Now - checkvalidate.NGAY_THAY_DOI_MK.Value;
                        var quydoisangngay = int.Parse(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) * 30;
                        if (soGioTime.TotalDays > quydoisangngay)
                        {
                            modal.Show();
                        }
                    }
                }

                //AnhPN 
                #region CheckPassword                
                var OvalidateTK = DataExtensions.GetAllWithClause_Order<VALIDATE_TAIKHOAN_LOG>($"USER_ID={Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID])}").FirstOrDefault();
                if (OvalidateTK != null)
                {
                    var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
                    if (!string.IsNullOrEmpty(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) && int.Parse(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) > 0)
                    {
                        TimeSpan soGioTime = DateTime.Now - OvalidateTK.NGAY_THAY_DOI_MK.Value;
                        var quydoisangngay = int.Parse(OQUANTRI_MATKHAU.THOIGIAN_DOIMATKHAU) * 30;
                        if (soGioTime.TotalDays > quydoisangngay)
                        {
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Mật khẩu đã quá hạn. Vui lòng liên hệ quản trị viên để được hướng dẫn đổi lại mật khẩu để sử dụng !')", true);
                        }
                    }
                }
                #endregion

                var userid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG checknguoisudung = null;
                if (userid > 0)
                    checknguoisudung = dt.QT_NGUOISUDUNG.Where(x => x.ID == userid).FirstOrDefault();
                if (checknguoisudung != null && checknguoisudung.NHOMNSDID != 1)
                {
                    //var checkvalidateTK = DataExtensions.FindById<VALIDATE_TAIKHOAN>(userid);
                    var checkvalidateTK = DataExtensions.GetAllWithClause_Order<VALIDATE_TAIKHOAN_LOG>($"USER_ID={userid}").FirstOrDefault();
                    if (checkvalidateTK != null)
                    {
                        var checknguoidoimk = dt.QT_NGUOISUDUNG.Where(x => x.USERNAME == checkvalidateTK.NGUOI_DOI_MK).FirstOrDefault();
                        if (checknguoidoimk != null && checknguoidoimk.NHOMNSDID == 1)
                        {
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đang đăng nhập tài khoản bằng mật khẩu tự động do quản trị viên cung cấp. Vui lòng đổi lại mật khẩu để đảm bảo tính bảo mật. Xin cảm ơn!')", true);
                        }
                    }
                    //else if (checknguoidoimk == null && checknguoisudung != null)
                    //{
                    //    var NGUOISUA = Convert.ToDecimal(checknguoisudung.NGUOISUA);
                    //    checknguoidoimk = dt.QT_NGUOISUDUNG.Where(x => x.ID == NGUOISUA).FirstOrDefault();
                    //    if (checknguoidoimk != null && checknguoidoimk.NHOMNSDID == 1)
                    //    {
                    //        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bạn đang đăng nhập tài khoản bằng mật khẩu tự động do quản trị viên cung cấp. Vui lòng đổi lại mật khẩu để đảm bảo tính bảo mật. Xin cảm ơn!')", true);
                    //    }
                    //}
                }
            }
            catch (Exception exception)
            {
                //lstErr.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), exception);
            }
        }

        protected void CapNhat_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/ChangePass.aspx");
        }
        protected void btnThoat_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
    }
}
