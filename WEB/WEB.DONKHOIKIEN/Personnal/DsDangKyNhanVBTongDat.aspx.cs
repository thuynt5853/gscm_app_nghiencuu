using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;
using System.Data;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DsDangKyNhanVBTongDat : System.Web.UI.Page
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
                    CurrEmail = dt.DONKK_USERS.Where(x => x.ID == UserID).SingleOrDefault().EMAIL;
                    CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    LoadDanhSach();
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }

        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDanhSach();
        }
        //------------------------
        #region Load DS
        public void LoadDanhSach()
        {
            string hoTen = txtHoten.Text;
            string tucachtt = ddlTuCachToTung.SelectedValue;
            string vuviec = txtVuViec.Text.Trim();
            int trangthai = Convert.ToInt16(dropTrangThai.SelectedValue);
            int toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToInt32(hddToaAnID.Value);
            if (String.IsNullOrEmpty(txtToaAn.Text.Trim()))
            {
                toa_an_id = 0;
                hddToaAnID.Value = "";
            }
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable tbl = null;
            DOnKK_User_DKNhanVB_BL oBL = new DOnKK_User_DKNhanVB_BL();
            tbl = oBL.GetAllPaging(UserID, vuviec, toa_an_id, tucachtt, hoTen, trangthai, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = int.Parse(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = true;
            }
            else
                pnPagingTop.Visible = pnPagingBottom.Visible = rpt.Visible = false;
        }


        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadDanhSach();
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                decimal Id = Convert.ToDecimal(rv["ID"]);
                int trangthai = Convert.ToInt16(rv["TrangThai"] + "");
                //LinkButton cmdLock = (LinkButton)e.Item.FindControl("cmdLock");
                LinkButton cmdUnlock = (LinkButton)e.Item.FindControl("cmdUnlock");
                //LinkButton lbtDangKi = (LinkButton)e.Item.FindControl("lbtDangKi");
                //0:chưa dc duoc duyet, 1: da duyet, 2:ngung nhan vb tong dat
                switch (trangthai)
                {
                    case 0:
                        cmdUnlock.Visible = false;
                        //cmdLock.Visible = false;
                        //lbtDangKi.Visible = false;
                        break;
                    case 1:
                        cmdUnlock.Visible = false;
                        //cmdLock.Visible = true;
                        //lbtDangKi.Visible = false;
                        break;
                    case 2:
                        cmdUnlock.Visible = false;
                        //cmdLock.Visible = false;
                        string strIdDangky = Session["DANGKY"] == null ? "" : Session["DANGKY"].ToString();
                        if (strIdDangky == ",")
                        {
                            strIdDangky = "";
                        }
                        if (strIdDangky.Contains("," + Id + ","))
                        {
                            //hiển thị nút đăng kí
                            //lbtDangKi.Visible = true;
                            cmdUnlock.Visible = false;
                        }
                        else
                        {
                            //ẩn nút đăng kí
                            //lbtDangKi.Visible = false;
                        }

                        break;
                    case 3:
                        cmdUnlock.Visible = false;
                        //cmdLock.Visible = false;
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
                    //case "Khoa":
                    //    lttMsg.Text = "";
                    //    Khoa(oND);

                    //    break;

                    case "KichHoat":
                        lttMsg.Text = "";
                        KichHoat(oND);
                        break;
                        //case "DangKi":
                        //    lttMsg.Text = "";

                        //    DangKi(oND);
                        //    break;
                }
                GhiLog(e.CommandName.ToLower(), oND);
            }
        }

        //void DangKi(DONKK_USER_DKNHANVB oND)
        //{
        //    //DONKK_USER_DKNHANVB obj = new DONKK_USER_DKNHANVB();
        //    //obj.GROUPDK = Guid.NewGuid().ToString();
        //    //obj.TOAANID = oND.TOAANID;
        //    //obj.DONKKID = oND.DONKKID;
        //    //obj.DUONGSUID = oND.DUONGSUID;

        //    //obj.VUVIECID = oND.VUVIECID;
        //    //obj.TENVUVIEC = oND.TENVUVIEC;
        //    //obj.MAVUVIEC = oND.MAVUVIEC;

        //    //obj.TUCACHTOTUNG_MA = oND.TUCACHTOTUNG_MA;
        //    //obj.TUCACHTOTUNG_ID = oND.TUCACHTOTUNG_ID;

        //    //obj.USERID = oND.USERID;
        //    //obj.CMND = oND.CMND;
        //    //obj.TENDUONGSU = oND.TENDUONGSU;

        //    //obj.MALOAIVUVIEC = oND.MALOAIVUVIEC;
        //    //obj.NGAYTAO = DateTime.Now;

        //    //int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
        //    //if (MucDichSD == 1)
        //    //    obj.TRANGTHAI = 1;
        //    //else
        //    //    obj.TRANGTHAI = 0;

        //    //obj.MADANGKY = Cls_Comon.Randomnumber();
        //    //dt.DONKK_USER_DKNHANVB.Add(obj);
        //    //dt.SaveChanges();

        //    //string temp = "";
        //    //string ListVuViecDKNhanVB = "";
        //    ////---------------------
        //    //#region Lay thong tin vu viec dk de ghi log            
        //    //temp += "- Vụ việc:";
        //    //temp += "+ Lĩnh vực: ";
        //    //switch (obj.MALOAIVUVIEC)
        //    //{
        //    //    case ENUM_LOAIAN.AN_DANSU:
        //    //        temp += "Dân sự";
        //    //        break;
        //    //    case ENUM_LOAIAN.AN_HANHCHINH:
        //    //        temp += "Hành chính";
        //    //        break;
        //    //    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
        //    //        temp += "Hôn nhân & Gia đình";
        //    //        break;
        //    //    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
        //    //        temp += "Kinh doanh & Thương mại";
        //    //        break;
        //    //    case ENUM_LOAIAN.AN_LAODONG:
        //    //        temp += "Lao động";
        //    //        break;
        //    //    case ENUM_LOAIAN.AN_PHASAN:
        //    //        temp += "Phá sản";
        //    //        break;
        //    //}
        //    //temp += "+ Mã vụ việc:" + obj.MALOAIVUVIEC + ",";
        //    //temp += "+ Tên vụ việc:" + obj.TENVUVIEC + ",";
        //    ////--------------
        //    //ListVuViecDKNhanVB += (String.IsNullOrEmpty(ListVuViecDKNhanVB)) ? temp : ("<br/>" + temp);
        //    //#endregion

        //    ////---------------------
        //    //try
        //    //{
        //    //    SendMail(obj.TENVUVIEC);
        //    //}
        //    //catch (Exception ex) { }
        //    //try
        //    //{
        //    //    GhiLog(ListVuViecDKNhanVB);
        //    //}
        //    //catch (Exception ex) { }
        //    string link = "/Personnal/DangKyNhanVB.aspx?ID="+oND.ID;
        //    Response.Redirect(link);
        //}
        void GhiLog(String ListMaVuViecDKNhanVB)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String Detail_Action = CurrUserName + " - Đăng ký nhận văn bản, thông báo mới từ Tòa án.<br/>";
            Detail_Action += "Gồm: " + ListMaVuViecDKNhanVB;

            String KeyLog = ENUM_HD_NGUOIDUNG_DKK.DKNHANVB;

            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }
        void SendMail(String tenvuviec)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            string CurrEmail = dt.DONKK_USERS.Where(x => x.ID == UserID).SingleOrDefault().EMAIL;

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
                //Hệ thống tự động xác nhận ngừng nhận văn bản, thông báo từ Tòa án của vụ việc {0} tới người dùng {1} tại thời điểm:{2}. Cám ơn!
                NoiDung = String.Format(NoiDung, tenvuviec, CurrUserName, ThoiGian);
            }
            Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);
        }

        void GhiLog(string Key, DONKK_USER_DKNHANVB obj)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
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

        //void Khoa(DONKK_USER_DKNHANVB oND)
        //{
        //    oND.NGAYDUNGGD = DateTime.Now;
        //    oND.LOAITACDONG = 1;
        //    oND.TRANGTHAI = 2;
        //    dt.SaveChanges();
        //    string strIdDangky = Session["DANGKY"] == null ? "" : Session["DANGKY"].ToString();
        //    if (!string.IsNullOrEmpty(strIdDangky))
        //    {
        //        if (!strIdDangky.Contains(","+ oND.ID + ","))
        //        {
        //            strIdDangky += oND.ID + ",";
        //            Session["DANGKY"] = strIdDangky;
        //        }
        //    }
        //    else
        //    {
        //        //rỗng
        //        strIdDangky += ","+oND.ID + ",";
        //        Session["DANGKY"] = strIdDangky;
        //    }

        //    //----------send mail------------------------
        //    string ThoiGian = DateTime.Now.ToString("dd/MM/yyyy", cul);
        //    string MaThongBao = "XNNgungNhanVBTongDat";
        //    String NoiDung = "";
        //    string TieuDe = "Thông báo xác nhận đăng ký ngừng nhận văn bản, thông báo từ Tòa án";
        //    DAL.GSTP.DM_TRANGTINH obj = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == MaThongBao).SingleOrDefault();
        //    if (obj != null)
        //    {
        //        NoiDung = obj.NOIDUNG;
        //        TieuDe = obj.TENTRANG;
        //    }
        //    if (!string.IsNullOrEmpty(NoiDung))
        //    {
        //        //Hệ thống tự động xác nhận ngừng nhận văn bản tống đạt của vụ việc {0} tới người dùng {1} tại thời điểm:{2}. Cám ơn!

        //        String TenVuViec = oND.TENVUVIEC;
        //        NoiDung = String.Format(NoiDung, TenVuViec, CurrUserName, ThoiGian);
        //    }
        //    Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);

        //    //----------------------------------
        //    lttMsg.Text = "<div class='msg_thongbao'>Đăng ký ngừng nhận văn bản,thông báo từ Tòa án của vụ việc này thành công!</div>";
        //    hddPageIndex.Value = "1";
        //    LoadDanhSach();
        //}
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

            hddPageIndex.Value = "1";
            LoadDanhSach();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDanhSach();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDanhSach();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDanhSach();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDanhSach();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDanhSach();
        }

        #endregion

        #endregion

        protected void cmdStop_Click(object sender, EventArgs e)
        {
            //Update trang thai cua toan bo Dang ky nhan vb = khoa
            List<DONKK_USER_DKNHANVB> lst = dt.DONKK_USER_DKNHANVB.Where(x => x.USERID == UserID).ToList<DONKK_USER_DKNHANVB>();
            if (lst != null && lst.Count > 0)
            {
                foreach (DONKK_USER_DKNHANVB obj in lst)
                    obj.TRANGTHAI = 2;
            }
            //------------------------------
            try
            {
                List<DONKK_DON> lstDon = dt.DONKK_DON.Where(x => x.NGUOITAO == UserID).ToList<DONKK_DON>();
                foreach (DONKK_DON item in lstDon)
                    item.STOPVB = 1;
                dt.SaveChanges();
            }
            catch (Exception ex) { }
            //------------------------------
            try
            {
                List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.ISDAIDIEN == 1
                                                                             && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList<DONKK_DON_DUONGSU>();
                foreach (DONKK_DON_DUONGSU item in lstDS)
                    item.STOPVB = 1;
                dt.SaveChanges();
            }
            catch (Exception ex) { }
            hddPageIndex.Value = "1";
            LoadDanhSach();
            lttMsg.Text = "<div class='msg_thongbao'>Trạng thái 'Ngừng nhận tất cả văn bản, thông báo' đã được kích hoạt!</div>";
        }
    }
}