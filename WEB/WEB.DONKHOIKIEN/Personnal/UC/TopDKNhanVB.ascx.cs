using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DAL.DKK;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;
using BL.DonKK;
using Module.Common;
using System.Globalization;


namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class TopDKNhanVB : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        public string CurrEmail = "", CurrUserName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDanhSach();
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadDanhSach()
        {
            int soluong = Convert.ToInt16(hddSoLuong.Value);
            DataTable tbl = null;
            DOnKK_User_DKNhanVB_BL objBL = new DOnKK_User_DKNhanVB_BL();
            tbl = objBL.GetTop(UserID, soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                lttMsg.Text = "Chưa có văn bản, thông báo mới nào";
            }
        }
                
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;

                int trangthai = Convert.ToInt16(rv["TrangThai"] + "");
                ImageButton cmdLock = (ImageButton)e.Item.FindControl("cmdLock");
                ImageButton cmdUnlock = (ImageButton)e.Item.FindControl("cmdUnlock");
                //0:chưa dc duoc duyet, 1: da duyet, 2:ngung nhan vb tong dat
                switch (trangthai)
                {
                    case 0:
                        cmdUnlock.Visible = false;
                        cmdLock.Visible = false;
                        break;
                    case 1:
                        cmdUnlock.Visible = false;
                        cmdLock.Visible = true;
                        break;
                    case 2:
                        cmdUnlock.Visible = true;
                        cmdLock.Visible = false;
                        break;
                }
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
            DONKK_USER_DKNHANVB oND = dt.DONKK_USER_DKNHANVB.Where(x => x.ID == CurrID).Single<DONKK_USER_DKNHANVB>();
            if (oND != null)
            {
                switch (e.CommandName)
                {
                    case "Khoa":
                        lttMsg.Text = "";
                        Khoa(oND);
                        break;

                    case "KichHoat":
                        lttMsg.Text = "";
                        KichHoat(oND);
                        break;
                }
                GhiLog(e.CommandName.ToLower(), oND);
            }
        }
        void GhiLog(string Key, DONKK_USER_DKNHANVB obj)
        {
            CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String Detail_Action = CurrUserName + " - {0} đăng ký nhận văn bản, thông báo mới từ Tòa án.<br/>";
            String KeyLog = "";
            switch (Key)
            {
                case "xoa":
                    KeyLog = ENUM_HD_NGUOIDUNG_DKK.XOADKNHANVB;
                    Detail_Action = String.Format(Detail_Action, "Xóa");
                    break;
                case "khoa":
                    KeyLog = ENUM_HD_NGUOIDUNG_DKK.LOCKDKNHANVB;
                    Detail_Action = String.Format(Detail_Action, "Khóa");
                    break;
                case "kichhoat":
                    KeyLog = ENUM_HD_NGUOIDUNG_DKK.UNLOCKDKNHANVB;
                    Detail_Action = String.Format(Detail_Action, "Kích hoạt ");
                    break;
                case "nhanvb":
                    KeyLog = ENUM_HD_NGUOIDUNG_DKK.NHANVB;
                    Detail_Action = String.Format(Detail_Action, "Nhận");
                    break;
            }
            String temp = "Vụ việc:<br/>";
            temp += "+ Lĩnh vực: ";
            switch (obj.MALOAIVUVIEC)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    temp += "Dân sự";
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    temp += "Hành chính";
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    temp += "Hôn nhân & Gia đình";
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    temp += "Kinh doanh & Thương mại";
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    temp += "Lao động";
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    temp += "Phá sản";
                    break;
            }
            temp += "+ Mã vụ việc:" + obj.MAVUVIEC + "<br/>";
            temp += "+ Tên vụ việc:" + obj.TENVUVIEC;

            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }

        void Khoa(DONKK_USER_DKNHANVB oND)
        {
            oND.TRANGTHAI = 2;
            dt.SaveChanges();

            //----------send mail------------------------
            string ThoiGian = DateTime.Now.ToString("dd/MM/yyyy", cul);
            string MaThongBao = "XNNgungNhanVBTongDat";
            String NoiDung = "";
            string TieuDe = "Thông báo xác nhận đăng ký ngừng nhận văn bản, thông báo từ Tòa án";
            DAL.GSTP.DM_TRANGTINH obj = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == MaThongBao).SingleOrDefault();
            if (obj != null)
            {
                NoiDung = obj.NOIDUNG;
                TieuDe = obj.TENTRANG;
            }
            if (!string.IsNullOrEmpty(NoiDung))
            {
                //Hệ thống tự động xác nhận ngừng nhận văn bản tống đạt của vụ việc {0} tới người dùng {1} tại thời điểm:{2}. Cám ơn!

                String TenVuViec = oND.TENVUVIEC;
                NoiDung = String.Format(NoiDung, TenVuViec, CurrUserName, ThoiGian);
            }
            Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);

            //----------------------------------
            lttMsg.Text = "<div class='msg_thongbao'>Đăng ký ngừng nhận văn bản,thông báo từ Tòa án của vụ việc này thành công!</div>";
            
            LoadDanhSach();
        }
        void KichHoat(DONKK_USER_DKNHANVB oND)
        {
            oND.TRANGTHAI = 1;
            dt.SaveChanges();

            decimal donkk_id = (String.IsNullOrEmpty(oND.DONKKID + "")) ? 0 : Convert.ToDecimal(oND.DONKKID);
            if (oND.DONKKID > 0)
            {
                DONKK_DON objDon = dt.DONKK_DON.Where(x => x.ID == donkk_id).Single<DONKK_DON>();
                objDon.STOPVB = 0;
                dt.SaveChanges();

                //------------------------------
                decimal DuongsuID = (String.IsNullOrEmpty(oND.DUONGSUID + "")) ? 0 : Convert.ToDecimal(oND.DUONGSUID);
                List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.DUONGSUID == DuongsuID && x.DONKKID == donkk_id).ToList<DONKK_DON_DUONGSU>();
                foreach (DONKK_DON_DUONGSU item in lstDS)
                    item.STOPVB = 0;
                dt.SaveChanges();
            }

            //----------send mail------------------------
            string ThoiGian = DateTime.Now.ToString("dd/MM/yyyy", cul);
            string MaThongBao = "XNDangKyNhanVBTongDat";
            String NoiDung = "", TieuDe = "";
            DAL.GSTP.DM_TRANGTINH obj = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == MaThongBao).SingleOrDefault();
            if (obj != null)
            {
                NoiDung = obj.NOIDUNG;
                TieuDe = obj.TENTRANG;
            }
            if (!string.IsNullOrEmpty(NoiDung))
            {
                //Hệ thống tự động xác nhận đăng ký nhận văn bản tống đạt của vụ việc {0} tới người dùng {1} tại thời điểm:{2}. Cám ơn!

                String TenVuViec = oND.TENVUVIEC;
                NoiDung = String.Format(NoiDung, TenVuViec, CurrUserName, ThoiGian);
            }
            Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);

            //---------------------------------
            lttMsg.Text = "<div class='msg_thongbao'>Đăng ký nhận văn bản,thông báo từ Tòa án của vụ việc này đã được gửi thành công!</div>";
            
            LoadDanhSach();
        }
    }
}