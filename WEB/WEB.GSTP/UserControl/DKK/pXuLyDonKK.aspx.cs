
using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHC;
using BL.GSTP.APS;
using BL.GSTP.ALD;
using BL.GSTP.DONGHEP;

namespace WEB.GSTP.UserControl.DKK
{
    public partial class pXuLyDonKK : System.Web.UI.Page
    {
        Decimal DonKKID = 0;
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        int HinhThucNhanDon_TrucTuyen = 3;
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                
                if (Request["dkkID"] != null)
                {
                    DonKKID = Convert.ToDecimal(Request["dkkID"] + "");

                    if (!IsPostBack)
                    {
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        cmdXuLy.CommandArgument = "LUU";
                        cmdXuLy.Text = "Lưu";
                        LoadDrop();
                        LoadThongTinDonKK(DonKKID);
                    }
                }
            }
            else Response.Redirect("/login.aspx");
        }

        #region Drop Quan he phap luat
        void LoadDrop()
        {
            // Load Quan hệ pháp luật
            DM_DATAITEM_BL dataitemBL = new DM_DATAITEM_BL();
            DataTable tblQHPL = dataitemBL.GetAllQHPL();
            dropQHPL.Items.Clear();
            dropQHPL.Items.Add(new ListItem("Chọn", "0"));
            if (tblQHPL != null && tblQHPL.Rows.Count > 0)
            {
                foreach (DataRow row in tblQHPL.Rows)
                    dropQHPL.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
            //----------------
            dropQHPLThongKe.Items.Clear();
            dropQHPLThongKe.Items.Add(new ListItem("Chọn", "0"));

        }
        void LoadDropQHPLThongKe()
        {
            if (dropQHPL.SelectedValue != "0")
            {
                List<DM_QHPL_TK> lstTK = null;
                string loai_an = hddLoaiAn.Value;
                switch (loai_an)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                    //-----------------------------------------
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                    //-----------------------------------------
                    case ENUM_LOAIAN.AN_LAODONG:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        lstTK = gsdt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                        break;
                }
                //----------------
                dropQHPLThongKe.Items.Clear();
                dropQHPLThongKe.Items.Add(new ListItem("Chọn", "0"));
                if (lstTK != null && lstTK.Count > 0)
                {
                    foreach (DM_QHPL_TK itemTK in lstTK)
                        dropQHPLThongKe.Items.Add(new ListItem(itemTK.CASE_NAME + "", itemTK.ID + ""));
                }
            }
        }


        //protected void dropLinhVuc_SelectedIndexChanged1(object sender, EventArgs e)
        //{
        //    string[] arr = null;
        //    switch (dropLinhVuc.SelectedValue)
        //    {
        //        case ENUM_LOAIAN.AN_DANSU:
        //            arr = new string[] { "QUANHEPL_YEUCAU", "QUANHEPL_TRANHCHAP" };
        //            LoadDropByGroupName(dropQHPL, arr, true);
        //            break;
        //        case ENUM_LOAIAN.AN_HANHCHINH:
        //            LoadDropByGroupName(dropQHPL, ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC, true);
        //            break;
        //        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
        //            arr = new string[] { "AN_HONNHAN_GIADINH", "QUANHEPL_YEUCAU_HNGD" };
        //            LoadDropByGroupName(dropQHPL, arr, true);
        //            break;
        //        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
        //            arr = new string[] { "QUANHEPL_YEUCAU_KDTM", "QUANHEPL_TRANHCHAP_KDTM" };
        //            LoadDropByGroupName(dropQHPL, arr, true);
        //            break;
        //        case ENUM_LOAIAN.AN_LAODONG:
        //            arr = new string[]{ "QUANHEPL_TRANHCHAP_LD", "QUANHEPL_YEUCAU_LD" };
        //            LoadDropByGroupName(dropQHPL, arr, true);
        //            break;
        //        case ENUM_LOAIAN.AN_PHASAN:
        //            LoadDropByGroupName(dropQHPL, ENUM_DANHMUC.QUANHEPL_YEUCAUPS, true);
        //            break;
        //    }
        //    ChangeQuanHePL();
        //}
        //void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        //{
        //    drop.Items.Clear();
        //    DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        //    DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
        //    if (ShowChangeAll)
        //        drop.Items.Add(new ListItem("------- chọn --------", "0"));
        //    foreach (DataRow row in tbl.Rows)
        //    {
        //        drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        //    }
        //}
        //void LoadDropByGroupName(DropDownList drop, string[] ListGroupName, Boolean ShowChangeAll)
        //{
        //    drop.Items.Clear();
        //    DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        //    DataTable tbl = null;
        //    if (ShowChangeAll)
        //        drop.Items.Add(new ListItem("------- chọn --------", "0"));
        //    foreach (String GroupName in ListGroupName)
        //    {
        //        tbl = oBL.DM_DATAITEM_GETBYGROUPNAME("ENUM_DANHMUC."+ GroupName);
        //        foreach (DataRow row in tbl.Rows)
        //            drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        //    }            
        //}
        protected void dropQHPL_SelectedIndexChanged1(object sender, EventArgs e)
        {
            ChangeQuanHePL();
        }
        void ChangeQuanHePL()
        {
            int LoaiQuanHe = 0;
            Decimal QHPL_id = Convert.ToDecimal(dropQHPL.SelectedValue);
            if (QHPL_id > 0)
            {
                decimal group_id = gsdt.DM_DATAITEM.Where(x => x.ID == QHPL_id).Single<DM_DATAITEM>().GROUPID;
                DM_DATAGROUP objGroup = gsdt.DM_DATAGROUP.Where(x => x.ID == group_id).Single<DM_DATAGROUP>();
                if (objGroup != null)
                {
                    string ma_loai_an = "";
                    string temp = objGroup.MA;
                    string ten_loai_an = "";
                    switch (temp)
                    {
                        case ENUM_DANHMUC.QUANHEPL_YEUCAU:
                            ma_loai_an = ENUM_LOAIAN.AN_DANSU;
                            ten_loai_an = "Dân sự";
                            LoaiQuanHe = 2;
                            break;
                        case ENUM_DANHMUC.QUANHEPL_TRANHCHAP:
                            ma_loai_an = ENUM_LOAIAN.AN_DANSU;
                            LoaiQuanHe = 1;
                            ten_loai_an = "Dân sự";
                            break;
                        //-----------------------------------------
                        case ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC:
                            ma_loai_an = ENUM_LOAIAN.AN_HANHCHINH;
                            LoaiQuanHe = 1;
                            ten_loai_an = "Hành chính";
                            break;
                        //-----------------------------------------
                        case ENUM_DANHMUC.QUANHEPL_TRANHCHAP_HNGD:
                            ma_loai_an = ENUM_LOAIAN.AN_HONNHAN_GIADINH;
                            ma_loai_an = ENUM_LOAIAN.AN_HONNHAN_GIADINH;
                            LoaiQuanHe = 1;
                            ten_loai_an = "Hôn nhân & gia đình";
                            break;
                        case ENUM_DANHMUC.QUANHEPL_YEUCAU_HNGD:
                            ma_loai_an = ENUM_LOAIAN.AN_HONNHAN_GIADINH;
                            LoaiQuanHe = 2;
                            ten_loai_an = "Hôn nhân & gia đình";
                            break;
                        //-----------------------------------------
                        case ENUM_DANHMUC.QUANHEPL_YEUCAU_KDTM:
                            ma_loai_an = ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI;
                            LoaiQuanHe = 2;
                            ten_loai_an = "Kinh doanh & Thương mại";
                            break;
                        case ENUM_DANHMUC.QUANHEPL_TRANHCHAP_KDTM:
                            ma_loai_an = ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI;
                            LoaiQuanHe = 1;
                            ten_loai_an = "Kinh doanh & Thương mại";
                            break;
                        //-----------------------------------------   
                        case ENUM_DANHMUC.QUANHEPL_TRANHCHAP_LD:
                            ma_loai_an = ENUM_LOAIAN.AN_LAODONG;
                            ten_loai_an = "Lao động";
                            LoaiQuanHe = 1;
                            break;
                        case ENUM_DANHMUC.QUANHEPL_YEUCAU_LD:
                            ma_loai_an = ENUM_LOAIAN.AN_LAODONG;
                            LoaiQuanHe = 2;
                            ten_loai_an = "Lao động";
                            break;
                        //-----------------------------------------
                        case ENUM_DANHMUC.QUANHEPL_YEUCAUPS:
                            ma_loai_an = ENUM_LOAIAN.AN_PHASAN;
                            ten_loai_an = "Phá sản";
                            LoaiQuanHe = 1;
                            break;
                    }
                    hddLoaiAn.Value = ma_loai_an;
                    hddLoaiQuanHe.Value = LoaiQuanHe.ToString();
                    //--------------------
                    LoadDropQHPLThongKe();
                    lttLinhVuc.Text = ten_loai_an;
                    //dropLinhVuc.SelectedValue = ma_loai_an;
                }
            }
        }
        #endregion

        #region Load thong tin don kk
        void LoadThongTinDonKK(Decimal DonKKID)
        {
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == DonKKID).Single<DONKK_DON>();
            if (obj != null)
            {
                decimal VuViecID = Convert.ToDecimal(obj.VUANID);
                lblNoidungdon.Text = obj.NOIDUNG;
                try
                {
                    string maloaivv = obj.MALOAIVUAN;
                    string ten_loai_an = "";
                    switch (maloaivv)
                    {
                        case ENUM_LOAIAN.AN_DANSU:
                            ten_loai_an = "Dân sự";
                            break;
                        case ENUM_LOAIAN.AN_HANHCHINH:
                            ten_loai_an = "Hành chính";
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            ten_loai_an = "Hôn nhân & gia đình";
                            break;
                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            ten_loai_an = "Kinh doanh & Thương mại";
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            ten_loai_an = "Lao động";
                            break;
                        case ENUM_LOAIAN.AN_PHASAN:
                            ten_loai_an = "Phá sản";
                            break;
                    }
                    lttLinhVuc.Text = ten_loai_an;
                    hddLoaiAn.Value = maloaivv;
                }
                catch (Exception ex) { }

                decimal QHPL_ID = (String.IsNullOrEmpty(obj.QUANHEPHAPLUATID + "")) ? 0 : (decimal)obj.QUANHEPHAPLUATID;
                if (obj.QUANHEPHAPLUATID > 0)
                {
                    try
                    {
                        dropQHPL.SelectedValue = QHPL_ID.ToString();
                        ChangeQuanHePL();
                    }
                    catch (Exception ex) { }
                }
                if (obj.MALOAIVUAN == ENUM_LOAIAN.AN_HANHCHINH)
                {
                    pnQDHanhChinh.Visible = true;
                    string temp = "";
                    string StrNoiDung = "";
                    try
                    {
                        temp = gsdt.DM_DATAITEM.Where(x => x.ID == obj.LOAIQDHANHCHINHID).Single<DM_DATAITEM>().TEN;
                    }
                    catch (Exception ex) { }

                    lblNoidungdon.Text += "</br>Người khởi kiện cam đoan không đồng thời khiếu nại " + (String.IsNullOrEmpty(temp) ? "......" : temp) + " đến người có thẩm quyền giải quyết khiếu nại.";

                    string date_temp = (String.IsNullOrEmpty(obj.NGAYQD + "") || Convert.ToDateTime(obj.NGAYQD) == DateTime.MinValue) ? "" : Convert.ToDateTime(obj.NGAYQD).ToString("dd/MM/yyyy", cul);

                    StrNoiDung = "<b>Quyết định bị kiện</b>: " + (String.IsNullOrEmpty(temp) ? "......" : temp);
                    StrNoiDung += " <b>số</b>: " + (String.IsNullOrEmpty(obj.SOQD + "") ? "......" : obj.SOQD.ToString());
                    StrNoiDung += " <b>ngày: </b>" + date_temp;
                    StrNoiDung += " <b>của: </b> " + (String.IsNullOrEmpty(obj.QDHC_CUA + "") ? "......" : obj.QDHC_CUA + "");
                    StrNoiDung += " <b>về: </b> " + (String.IsNullOrEmpty(obj.TENQD + "") ? "......" : obj.TENQD);

                    StrNoiDung += "</br>";
                    StrNoiDung += "<b>Hành vi hành chính bị kiện: </b>" + (String.IsNullOrEmpty(obj.HANHVIHC + "") ? "......" : obj.HANHVIHC + "");

                    temp = "</br>";
                    temp += "<b>Tóm tắt nội dung quyết định:";
                    //temp += " hành chính, quyết định kỷ luật buộc thôi việc,";
                    //temp += " quyết định giải quyết khiếu nại về quyết định xử lý vụ việc cạnh tranh,";
                    //temp += " nội dung giải quyết khiếu nại về danh sách cử tri";
                    //temp += " hoặc tóm tắt diễn biến của hành vi hành chính";
                    temp += ": </b>";
                    StrNoiDung += (String.IsNullOrEmpty(obj.TOMTATHANHVIHCBIKIEN + "") ? "" : (temp + obj.TOMTATHANHVIHCBIKIEN + ""));

                    if (!String.IsNullOrEmpty(obj.NOIDUNGQUYETDINH))
                    {
                        StrNoiDung += "</br>";
                        StrNoiDung += "<b>Nội dung quyết định giải quyết khiếu nại (nếu có): </b>";
                        StrNoiDung += "</br>";
                        StrNoiDung += obj.NOIDUNGQUYETDINH + "";
                    }

                    lttQDHanhChinh.Text = StrNoiDung;
                    lttThongTinThem.Text = "";
                }
                else
                {
                    pnQDHanhChinh.Visible = false;
                    if (!String.IsNullOrEmpty(obj.THONGTINTHEM + ""))
                    {
                        lttThongTinThem.Text = "<div class='fullwidth'><b>Các thông tin khác mà người khởi kiện xét thấy cần thiết cho việc giải quyết vụ án: </b></br>";
                        lttThongTinThem.Text += obj.THONGTINTHEM + "</div>";
                    }
                    else lttThongTinThem.Text = "";
                }

                try
                {
                    DM_DATAITEM objQHPL = gsdt.DM_DATAITEM.Where(x => x.ID == obj.QUANHEPHAPLUATID).FirstOrDefault();

                    if (obj.MALOAIVUAN == ENUM_LOAIAN.AN_HONNHAN_GIADINH)
                    {
                        //Kiểm tra ẩn/hiện lý do ly hôn                   
                        if (objQHPL.MA.ToUpper() == "TCHNGD01")
                        {
                            AHN_DON objAHN = gsdt.AHN_DON.Where(x => x.ID == VuViecID).Single<AHN_DON>();
                            if (objAHN != null)
                            {
                                trLydoLyhon.Visible = true;
                                lbSoConChuaThanhNien.Text = objAHN.SOCONCHUATHANHNIEN == null ? "" : objAHN.SOCONCHUATHANHNIEN.ToString();
                                Decimal LyDoLyHonID = Convert.ToDecimal(objAHN.LYDOLYHONID);
                                lblLyDoLyHon.Text = gsdt.DM_DATAITEM.Where(x => x.ID == LyDoLyHonID).FirstOrDefault().TEN + "";
                            }
                        }
                    }
                }
                catch (Exception ex) { }
                //-------------------

                try
                {
                    Decimal ToaAnId = Convert.ToDecimal(obj.TOAANID);
                    DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>();
                    if (objTA != null)
                        lttToaAn.Text = objTA.TEN;
                }
                catch (Exception ex) { }

                //-------------------------
                DateTime ngayTao = (DateTime)obj.NGAYTAO;
                lttNgayGuiDon.Text = ngayTao.ToString("dd/MM/yyyy", cul);
                //-----------------------------
                Load_DuongSu(obj);
                LoadFileTheoDon(DonKKID, obj.MALOAIVUAN);
            }
        }
        void Load_DuongSu(DONKK_DON obj)
        {
            decimal VuViecID = Convert.ToDecimal(obj.VUANID);
            DonKKID = Convert.ToDecimal(Request["dkkID"] + "");
            string MaLoaiVuViec = obj.MALOAIVUAN;
            DataTable tblDS = null;
            string temp = "";
            try
            {
                DONKK_DON_DUONGSU_BL objDS = new DONKK_DON_DUONGSU_BL();
                tblDS = objDS.GetAllDuongSuByDonKK(DonKKID);
                if (tblDS != null && tblDS.Rows.Count > 0)
                {
                    tblDS.Columns.Add("DienThoai_Fax", typeof(string));
                    tblDS.Columns.Add("HoKhauTamTru", typeof(string));
                    temp = "";
                    foreach (DataRow row in tblDS.Rows)
                    {
                        temp = "";
                        temp = (string.IsNullOrEmpty(row["DienThoai"] + "")) ? "" : row["DienThoai"].ToString();
                        temp += (string.IsNullOrEmpty(row["Fax"] + "")) ? "" : ((temp.Length > 0) ? "/" + row["Fax"].ToString() : row["Fax"].ToString());
                        row["DienThoai_Fax"] = temp;

                        ////-------------------------
                        temp = "";
                        temp = (string.IsNullOrEmpty(row["TamTruChiTiet"] + "")) ? "" : row["TamTruChiTiet"].ToString();
                        temp += (string.IsNullOrEmpty(row["TamTru_Huyen"] + "")) ? "" : ((temp.Length > 0) ? ", " + row["TamTru_Huyen"].ToString() : row["TamTru_Huyen"].ToString());
                        row["HoKhauTamTru"] = temp;
                    }

                    //-----------------------
                    DataTable tblDSKhac = tblDS.Clone();

                    int count_all = 0;
                    //------------------------
                    #region Lay ds Nguyen don
                    String TuCachTT = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                    DataRow[] arr = tblDS.Select("TuCachToTung_Ma='" + TuCachTT + "'", "IsDaiDien DESC");
                    tblDSKhac = FillData(tblDSKhac, arr);
                    if (tblDSKhac != null && tblDSKhac.Rows.Count > 0)
                    {
                        count_all = tblDSKhac.Rows.Count;
                        lttcount_ND.Text = "<div class='count_duongsu'>Tổng số người khởi kiện:<span>" + count_all.ToString() + "</span></div>";

                        rptNguyenDon.DataSource = tblDSKhac;
                        rptNguyenDon.DataBind();
                        pnNguyenDon.Visible = true;
                    }
                    else pnNguyenDon.Visible = false;
                    #endregion

                    //----------------------
                    tblDSKhac.Rows.Clear();
                    #region Lay ds Bi don
                    TuCachTT = ENUM_DANSU_TUCACHTOTUNG.BIDON;
                    arr = tblDS.Select("TuCachToTung_Ma='" + TuCachTT + "'", "IsDaiDien DESC");
                    tblDSKhac = FillData(tblDSKhac, arr);
                    if (tblDSKhac != null && tblDSKhac.Rows.Count > 0)
                    {
                        count_all = tblDSKhac.Rows.Count;
                        lttcount_BD.Text = "<div class='count_duongsu'>Tổng số người bị kiện:<span>" + count_all.ToString() + "</span></div>";

                        rptBiDon.DataSource = tblDSKhac;
                        rptBiDon.DataBind();
                        pnBiDon.Visible = true;
                    }
                    else
                        pnBiDon.Visible = false;
                    #endregion

                    //-------------cac loai khac--------------------
                    #region Lay ds cac loai khac

                    tblDSKhac.Rows.Clear();
                    foreach (DataRow row in tblDS.Rows)
                    {
                        temp = row["TuCachToTung_Ma"] + "";
                        if ((temp != ENUM_DANSU_TUCACHTOTUNG.NGUYENDON) && (temp != ENUM_DANSU_TUCACHTOTUNG.BIDON))
                            tblDSKhac.ImportRow(row);
                    }
                    if (tblDSKhac != null && tblDSKhac.Rows.Count > 0)
                    {
                        rptDuongSuKhac.DataSource = tblDSKhac;
                        rptDuongSuKhac.DataBind();
                        pnDuongSu.Visible = true;
                    }
                    else pnDuongSu.Visible = false;
                    #endregion
                }
            }
            catch (Exception ex) { }
        }

        DataTable FillData(DataTable tbl, DataRow[] arr)
        {
            if (arr != null && arr.Length > 0)
            {
                foreach (DataRow row in arr)
                    tbl.ImportRow(row);
            }

            return tbl;
        }
        #region File
        void LoadFileTheoDon(Decimal CurrDonID, string MaLoaiVuViec)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == CurrDonID
                                                                       && x.LOAIDON == MaLoaiVuViec
                                                                     ).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                rptFile.DataSource = lst;
                rptFile.DataBind();
                rptFile.Visible = true;
            }
            else rptFile.Visible = false;
        }

        protected void rptFile_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "dowload":
                    DowloadFile(Convert.ToDecimal(e.CommandArgument));
                    break;
            }
        }
        void DowloadFile(Decimal FileID)
        {
            try
            {
                DONKK_DON_TAILIEU oND = dt.DONKK_DON_TAILIEU.Where(x => x.ID == FileID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                }
            }
            catch (Exception ex)
            {
                // lttThongBao.Text = ex.Message;
            }
        }
        #endregion

        #endregion
        //---------------------------------
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }


        protected void cmdTimKiemDon_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            //LoadGrid();
        }
        //btnTimKiem_Click
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Chitiet":
                    string Donid = e.Item.Cells[0].Text;
                    string LoaiAnId=e.Item.Cells[1].Text;
                    string link = "";
                    if (LoaiAnId == "2")
                    {
                        //dân sự
                        link = "/QLAN/ADS/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_DANSU] = Donid;
                    }
                    else if (LoaiAnId == "3")
                    {
                        //hôn nhân gia đình
                        link = "/QLAN/AHN/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = Donid;
                    }
                    else if (LoaiAnId == "4")
                    {
                        //kinh doanh thương mại
                        link = "/QLAN/AKT/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = Donid;
                    }
                    else if (LoaiAnId == "5")
                    {
                        //lạo động
                        link = "/QLAN/ALD/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_LAODONG] = Donid;
                    }
                    else if (LoaiAnId == "6")
                    {
                        //hành chính
                        link = "/QLAN/AHC/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_HANHCHINH] = Donid;
                    }
                    else if (LoaiAnId == "7")
                    {
                        //phá sản
                        link = "/QLAN/APS/Hoso/Thongtindon.aspx?ChiTiet=1";
                        Session[ENUM_LOAIAN.AN_PHASAN] = Donid;
                    }
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "openInNewTab('" + link + "')");
                    break;
                
            }

        }
        private void LoadGrid()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int page_size = 10,
                pageindex = Convert.ToInt32(hddPageIndex.Value);
            DONGHEP_BL oBL = new DONGHEP_BL();
            DataTable oDT = oBL.Don_GETLIST(vDonViID, txtMaVuViec.Text, txtTenVuViec.Text, txtNguoiKhoiKien.Text, txtCMNDCCCD.Text, txtNamSinh.Text, txtNguoiBiKien.Text, txtNoiDungKhoiKien.Text,hddLoaiAn.Value, pageindex, page_size);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                var count_all = Convert.ToInt32(oDT.Rows.Count);
                if (dgList.CurrentPageIndex > (Convert.ToInt32(hddTotalPage.Value) - 1))
                {
                    dgList.CurrentPageIndex = 0;
                }
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.Visible = true;
                phantrang1.Visible = true;
                phantrang2.Visible = true;
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                dgList.Visible = false ;
                phantrang1.Visible = false;
                phantrang2.Visible = false;
            }
            
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            cmdXuLy.CommandArgument = "GHEP";
            cmdXuLy.Text = "Ghép đơn";
            bool IsCheck = false;
            CheckBox checkboxCurrent = (CheckBox)sender;
            foreach (DataGridItem item in dgList.Items)
            {

                CheckBox checkBox = (CheckBox)item.FindControl("chkChon");
                if (checkboxCurrent != checkBox)
                {
                    checkBox.Checked = false;
                }
                if (checkBox.Checked)
                {
                    IsCheck = true;
                }
            }
            if (!IsCheck)
            {
                cmdXuLy.CommandArgument = "LUU";
                cmdXuLy.Text = "Lưu";
            }
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion

        #region Xu ly don kk
        protected void cmdXuLy_Click(object sender, EventArgs e)
        {
            Button cmdXuLy = (Button)sender;
            string agument = cmdXuLy.CommandArgument;
            if (agument=="LUU")
            {
                Decimal DonKKID = Convert.ToDecimal(Request["dkkID"] + "");
                DONKK_DON objDon = dt.DONKK_DON.Where(x => x.ID == DonKKID).Single<DONKK_DON>();
                Update_QuanLyAn_GSTP(DonKKID, objDon);
                //------------------------------
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            }
            else
            {
                //ghép đơn
                
                Decimal DonKKID = Convert.ToDecimal(Request["dkkID"] + "");
                DONKK_DON objDon = dt.DONKK_DON.Where(x => x.ID == DonKKID).Single<DONKK_DON>();
                
                foreach (DataGridItem itemdg in dgList.Items)
                {
                    
                    CheckBox checkBox = (CheckBox)itemdg.FindControl("chkChon");
                    if (checkBox.Checked)
                    {
                        decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        decimal DonId = Convert.ToDecimal(itemdg.Cells[0].Text);
                        decimal LoaiAn= Convert.ToDecimal(itemdg.Cells[1].Text);
                        int count = gsdt.DON_CHITIET.Count(s => s.DONKKID == objDon.ID && s.DONID == DonId && s.LOAIANID == LoaiAn);
                        if (count>0)
                        {
                            lbthongbao.Text = "<div class='red'>Đơn đã được ghép với vụ án này</div>";
                            return;
                        }
                        //lấy thông tin đơn mới nyaf lưu vào bảng DON_CHITIET
                        DON_CHITIET obj = new DON_CHITIET();
                        obj.DONID = DonId;
                        obj.LOAIANID = LoaiAn;
                        obj.TOAANID = vDonViID;
                        obj.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                        obj.NGAYVIETDON = DateTime.Now;
                        obj.NGAYNHANDON = DateTime.Now;
                        obj.CANBONHANDONID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                        obj.THAMPHANKYNHANDON = 0;
                        obj.YEUTONUOCNGOAI = objDon.YEUTONUOCNGOAI;
                        obj.LOAIDON = 1;
                        obj.USERTT_EMAIL = "";
                        obj.USERTT_ID = objDon.NGUOITAO;
                        obj.USERTT_NGAYTAO = objDon.NGAYTAO;
                        obj.USERTT_NGAYGUI = objDon.NGAYGUI;
                        //obj.USERTTNGAYBOSUNG=
                        obj.NGUOITAO= Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        obj.NGAYTAO = DateTime.Now;
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        obj.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                        obj.DONKKID = objDon.ID;
                        gsdt.DON_CHITIET.Add(obj);
                        gsdt.SaveChanges();
                        //lưu đương sự
                        List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID).ToList<DONKK_DON_DUONGSU>();
                        if (lst != null && lst.Count > 0)
                        {
                            foreach (DONKK_DON_DUONGSU item in lst)
                            {

                                //DON_CHITIET_DUONGSU oND = new DON_CHITIET_DUONGSU();
                                //oND.LOAIANID = objDon.LOAIANID;
                                //oND.DONID = obj.ID;
                                //oND.TENDUONGSU = item.TENDUONGSU;
                                //oND.ISDAIDIEN = item.ISDAIDIEN;
                                //oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                                //oND.LOAIDUONGSU = item.LOAIDUONGSU;
                                //oND.SOCMND = item.SOCMND;
                                //oND.QUOCTICHID = item.QUOCTICHID;

                                ////-----------------------------------
                                //oND.TAMTRUID = item.TAMTRUID;
                                //oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
                                //oND.TAMTRUTINHID = item.TAMTRUTINHID;
                                ////-----------------------------------
                                //oND.HKTTID = item.HKTTID;
                                //oND.HKTTCHITIET = item.HKTTCHITIET;
                                //oND.HKTTTINHID = item.HKTTTINHID;
                                ////-----------------------------------
                                //oND.NGAYSINH = item.NGAYSINH;
                                //oND.NAMSINH = item.NAMSINH;
                                //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);

                                ////-----------------------------------
                                //oND.GIOITINH = item.GIOITINH;
                                //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

                                //oND.EMAIL = item.EMAIL;
                                //oND.DIENTHOAI = item.DIENTHOAI;
                                //oND.FAX = item.FAX;

                                ////-------Nguoi dai dien cua to chuc------------------
                                //oND.NDD_DIACHIID = item.NDD_DIACHIID;
                                //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                                //oND.CHUCVU = item.CHUCVU;
                                //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

                                ////-------------------------
                                //oND.ISSOTHAM = 1;
                                //oND.ISDON = 1;

                                ////-----------------
                                ////ngay phan loai dkk, nguoi phan loai dkk
                                //oND.NGAYSUA = DateTime.Now;
                                //oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                                //try
                                //{
                                //    //Ngay tao dkk, nguoi tao donkk
                                //    oND.NGAYTAO = item.NGAYTAO;
                                //    oND.NGUOITAO = item.NGUOITAO;
                                //}
                                //catch (Exception ex) { }

                                //gsdt.DON_CHITIET_DUONGSU.Add(oND);

                                //Thêm mới đương sự
                                ADS_DON_DUONGSU oND = new ADS_DON_DUONGSU();
                                oND.DONID = DonId;
                                oND.TENDUONGSU = item.TENDUONGSU;
                                oND.ISDAIDIEN = item.ISDAIDIEN;
                                oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
                                oND.LOAIDUONGSU = item.LOAIDUONGSU;
                                oND.ISDAIDIEN = 0;
                                oND.ISBVQLNGUOIKHAC = 0;
                                oND.SOCMND = item.SOCMND;
                                oND.QUOCTICHID = item.QUOCTICHID;
                                oND.TAMTRUTINHID = item.TAMTRUTINHID;
                                oND.TAMTRUID = item.TAMTRUID;
                                oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
                                oND.DIACHICOQUAN = item.DIACHICOQUAN;
                                oND.NGAYSINH = item.NGAYSINH;
                                oND.NAMSINH = item.NAMSINH;
                                oND.GIOITINH = item.GIOITINH;
                                oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;
                                oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;
                                oND.CHUCVU = item.CHUCVU;
                                oND.EMAIL = item.EMAIL;
                                oND.DIENTHOAI = item.DIENTHOAI;
                                oND.FAX = item.FAX;
                                oND.NDD_DIACHIID = item.NDD_DIACHIID;
                                oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
                                oND.ISSOTHAM = 1;
                                oND.ISDON = 1;
                                oND.NGAYTAO = DateTime.Now;
                                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                gsdt.ADS_DON_DUONGSU.Add(oND);
                                gsdt.SaveChanges();

                                //Thêm mới đơn đương sự chi tiết
                                DON_DUONGSU_CHITIET oDuongSu_ChiTiet = new DON_DUONGSU_CHITIET();
                                oDuongSu_ChiTiet.DUONGSUID = oND.ID;
                                oDuongSu_ChiTiet.DONID = DonId;
                                oDuongSu_ChiTiet.DONCHITIETID = obj.ID;
                                oDuongSu_ChiTiet.LOAIAN = 2;
                                oDuongSu_ChiTiet.NGAYTAO = DateTime.Now;
                                oDuongSu_ChiTiet.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                
                                // quyennd
                                if (oDuongSu_ChiTiet.TOA_GIAIQUYET_ID == null) 
                                    oDuongSu_ChiTiet.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                
                                gsdt.DON_DUONGSU_CHITIET.Add(oDuongSu_ChiTiet);
                                gsdt.SaveChanges();
                            }
                        }
                        break;
                    }
                }
                gsdt.SaveChanges();
                lbthongbao.Text = "<div class='red'>Ghép đơn thành công</div>";
                LoadGrid();
                cmdXuLy.CommandArgument = "LUU";
                cmdXuLy.Text = "Lưu";
            }
        }
        void Update_QuanLyAn_GSTP(Decimal DonKKID, DONKK_DON objDon)
        {
            String MaLoaiVuViec = hddLoaiAn.Value;
            Decimal QLAn_VuAnID = 0;
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    QLAn_VuAnID = Update_AnDanSu(DonKKID, objDon);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    QLAn_VuAnID = Update_AHC(DonKKID, objDon);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    QLAn_VuAnID = Update_AHN(DonKKID, objDon);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    QLAn_VuAnID = Update_AKT(DonKKID, objDon);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    QLAn_VuAnID = Update_ALD(DonKKID, objDon);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    QLAn_VuAnID = Update_APS(DonKKID, objDon);
                    break;
            }

            //---------Update VuAnID trong bang DonKK_Don------------- 
            try
            {
                objDon.VUANID = QLAn_VuAnID;
                objDon.MAVUVIEC = hddGSTP_MaVuViec.Value;
                objDon.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);

                objDon.MALOAIVUAN = hddLoaiAn.Value;
                objDon.TRANGTHAI = 1;

                objDon.NGAYSUA = DateTime.Now;
                dt.SaveChanges();
            }
            catch (Exception ex) { }
        }

        #region  Update  quan ly an
        Boolean CheckValid()
        {
            return true;
        }
        private Decimal Update_AnDanSu(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                Decimal LoaiQuanHe = Convert.ToDecimal(hddLoaiQuanHe.Value);
                if (CheckValid())
                {
                    ADS_DON_BL dsBL = new ADS_DON_BL();
                    ADS_DON oT;
                    #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                    oT = new ADS_DON();

                    oT.TENVUVIEC = GetTenVuViec(DonKKID);

                    oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                    oT.NGAYVIETDON = DateTime.Now;
                    oT.NGAYNHANDON = DateTime.Now;
                    oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                    oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                    oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);

                    oT.CANBONHANDONID = 0;
                    oT.THAMPHANKYNHANDON = 0;
                    oT.LOAIDON = 1;

                    oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                    oT.TOAANID = objDon.TOAANID;
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = 0;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_DANSU + "." + oT.TT.ToString();

                    //ngay phan loai dkk, nguoi phan loai dkk
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        oT.NGAYTAO = objDon.NGAYTAO;
                        oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                    }
                    catch (Exception ex) { }

                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    gsdt.ADS_DON.Add(oT);
                    gsdt.SaveChanges();
                    hddVuAnID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("2", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    #endregion
                    //-----------------------------
                    VuAnID = oT.ID;
                    hddGSTP_MaVuViec.Value = oT.MAVUVIEC;

                    
                    //Lưu duong su
                    Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_DANSU);

                    string lstIdDuongSu = "";
                    string lstNameDuongSu = "";
                    var lstDuongSu = (from a in gsdt.ADS_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                      join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                      where a.TUCACHTOTUNG_MA == "NGUYENDON"
                                      select new
                                      {
                                          ID = a.ID,
                                          TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                      });
                    foreach (var item in lstDuongSu)
                    {
                        lstIdDuongSu += item.ID + ",";
                    }
                    lstNameDuongSu=string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                    lstIdDuongSu = "," + lstIdDuongSu;

                    //-----------------------------
                    //Lưu người tham gia tố tụng
                    Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_DANSU, lstIdDuongSu, lstNameDuongSu);


                    ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
                    oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                    Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_DANSU);
                    return VuAnID;
                }
                else return 0;
            }
            catch (Exception ex)
            {
                //  //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }
        private Decimal Update_AHC(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                if (CheckValid())
                {
                    AHC_DON oT;
                    #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                    if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                    {
                        oT = new AHC_DON();
                    }
                    else
                    {
                        decimal ID = Convert.ToDecimal(hddVuAnID.Value);
                        oT = gsdt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                    }
                    oT.TENVUVIEC = GetTenVuViec(DonKKID);

                    oT.LOAIQDHANHCHINHID = Convert.ToDecimal(objDon.LOAIQDHANHCHINHID);
                    oT.SOQD = objDon.SOQD;
                    DateTime date_temp = (String.IsNullOrEmpty(objDon.NGAYQD + "")) ? DateTime.MinValue : DateTime.Parse(objDon.NGAYQD + "", cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGAYQD = date_temp;
                    oT.TENQD = objDon.TENQD;
                    oT.HANHVIHC = objDon.HANHVIHC;

                    oT.QDHC_CUA = objDon.QDHC_CUA + "";
                    oT.TOMTATHANHVIHCBIKIEN = objDon.TOMTATHANHVIHCBIKIEN + "";
                    oT.NOIDUNGQUYETDINH = objDon.NOIDUNGQUYETDINH;

                    //----------------------------------
                    oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                    oT.NGAYVIETDON = DateTime.Now;
                    oT.NGAYNHANDON = DateTime.Now;
                    oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                    oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                    oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);
                    oT.CANBONHANDONID = 0;
                    oT.THAMPHANKYNHANDON = 0;
                    oT.LOAIDON = 1;
                    oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                    if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                    {
                        AHC_DON_BL dsBL = new AHC_DON_BL();
                        oT.TOAANID = objDon.TOAANID;
                        oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                        oT.TRANGTHAI = 0;
                        oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_HANHCHINH + "." + oT.TT.ToString();
                        //updaet 060825
                        oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        //ngay phan loai dkk, nguoi phan loai dkk
                        oT.NGAYSUA = DateTime.Now;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        try
                        {
                            //Ngay tao dkk, nguoi tao donkk
                            oT.NGAYTAO = objDon.NGAYTAO;
                            oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                        }
                        catch (Exception ex) { }

                        oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        gsdt.AHC_DON.Add(oT);
                        gsdt.SaveChanges();
                        hddVuAnID.Value = oT.ID.ToString();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("6", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
                    else
                    {
                        oT.NGAYSUA = DateTime.Now;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        gsdt.SaveChanges();
                    }
                    #endregion
                    //-----------------------------
                    VuAnID = oT.ID;
                    hddGSTP_MaVuViec.Value = oT.MAVUVIEC;

                    //Lưu duong su
                    Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_HANHCHINH);

                    string lstIdDuongSu = "";
                    string lstNameDuongSu = "";
                    var lstDuongSu = (from a in gsdt.AHC_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                      join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                      where a.TUCACHTOTUNG_MA == "NGUYENDON"
                                      select new
                                      {
                                          ID = a.ID,
                                          TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                      });
                    foreach (var item in lstDuongSu)
                    {
                        lstIdDuongSu += item.ID + ",";
                    }
                    lstNameDuongSu = string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                    lstIdDuongSu = "," + lstIdDuongSu;

                    Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_HANHCHINH, lstIdDuongSu, lstNameDuongSu);
                    //-----------------------------
                    AHC_DON_DUONGSU_BL oDonBL = new AHC_DON_DUONGSU_BL();
                    oDonBL.AHC_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                    Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_HANHCHINH);
                    return VuAnID;
                }
                else return 0;
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }
        private Decimal Update_AHN(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                AHN_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                    oT = new AHN_DON();
                else
                {
                    decimal ID = Convert.ToDecimal(hddVuAnID.Value);
                    oT = gsdt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                oT.TENVUVIEC = GetTenVuViec(DonKKID);

                oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;// Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                oT.NGAYVIETDON = DateTime.Now;
                oT.NGAYNHANDON = DateTime.Now;
                oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);
                oT.CANBONHANDONID = 0; // Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = 0;// Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.LOAIDON = 1; //Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                if (trLydoLyhon.Visible)
                {
                    oT.SOCONCHUATHANHNIEN = 0;
                    // oT.SOCONDUOI7TUOI = txtSoconduoi7tuoi.Text == "" ? 0 : Convert.ToDecimal(txtSoconduoi7tuoi.Text);
                }
                else
                {
                    oT.SOCONCHUATHANHNIEN = 0;
                    oT.LYDOLYHONID = 0;
                }

                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                {
                    AHN_DON_BL dsBL = new AHN_DON_BL();
                    oT.TOAANID = objDon.TOAANID;
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = 0;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH + "." + oT.TT.ToString();
                    //ngay phan loai dkk, nguoi phan loai dkk
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        oT.NGAYTAO = objDon.NGAYTAO;
                        oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                    }
                    catch (Exception ex) { }
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    gsdt.AHN_DON.Add(oT);
                    gsdt.SaveChanges();
                    hddVuAnID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("3", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    gsdt.SaveChanges();
                }
                #endregion
                VuAnID = oT.ID;
                hddGSTP_MaVuViec.Value = oT.MAVUVIEC;

                //-------Nguyen don , bi don
                //Update_AHN_NguyenDon(oT, VuAnID);
                //if (chkKhongCoNYC2.Checked == false)
                //    Update_AHN_BiDon(oT, VuAnID);
                //Lưu duong su
                Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_HONNHAN_GIADINH);

                string lstIdDuongSu = "";
                string lstNameDuongSu = "";
                var lstDuongSu = (from a in gsdt.AHN_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                  join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  where a.TUCACHTOTUNG_MA == "NGUYENDON"
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                  });
                foreach (var item in lstDuongSu)
                {
                    lstIdDuongSu += item.ID + ",";
                }
                lstNameDuongSu = string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                lstIdDuongSu = "," + lstIdDuongSu;


                Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_HONNHAN_GIADINH, lstIdDuongSu, lstNameDuongSu);
                //-----------------------------
                AHN_DON_DUONGSU_BL oDonBL = new AHN_DON_DUONGSU_BL();
                oDonBL.AHN_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_HONNHAN_GIADINH);
                return VuAnID;
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }
        private Decimal Update_AKT(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                AKT_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                {
                    oT = new AKT_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddVuAnID.Value);
                    oT = gsdt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                oT.TENVUVIEC = GetTenVuViec(DonKKID);

                oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                oT.NGAYVIETDON = DateTime.Now;
                oT.NGAYNHANDON = DateTime.Now;
                oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);
                oT.CANBONHANDONID = 0;
                oT.THAMPHANKYNHANDON = 0;
                oT.LOAIDON = 1;
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                {
                    AKT_DON_BL dsBL = new AKT_DON_BL();
                    oT.TOAANID = objDon.TOAANID;
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = 0;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI + "." + oT.TT.ToString();
                    //ngay phan loai dkk, nguoi phan loai dkk
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        oT.NGAYTAO = objDon.NGAYTAO;
                        oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                    }
                    catch (Exception ex) { }
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    gsdt.AKT_DON.Add(oT);
                    gsdt.SaveChanges();
                    hddVuAnID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("4", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    gsdt.SaveChanges();
                }
                #endregion
                //-----------------------------
                VuAnID = oT.ID;
                hddGSTP_MaVuViec.Value = oT.MAVUVIEC;
                ////Lưu người khởi kiện đại diện
                //Update_NguyenDon(oT, VuAnID);
                //if (chkKhongCoNYC2.Checked == false)
                //    Update_BiDon(oT, VuAnID);
                //Lưu duong su
                Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI);

                string lstIdDuongSu = "";
                string lstNameDuongSu = "";
                var lstDuongSu = (from a in gsdt.AKT_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                  join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                  });
                foreach (var item in lstDuongSu)
                {
                    lstIdDuongSu += item.ID + ",";
                }
                lstNameDuongSu = string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                lstIdDuongSu = "," + lstIdDuongSu;


                Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI, lstIdDuongSu, lstNameDuongSu);
                //-----------------------------
                AKT_DON_DUONGSU_BL oDonBL = new AKT_DON_DUONGSU_BL();
                oDonBL.AKT_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI);
                return VuAnID;
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }
        private Decimal Update_ALD(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                ALD_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                {
                    oT = new ALD_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddVuAnID.Value);
                    oT = gsdt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                oT.TENVUVIEC = GetTenVuViec(DonKKID);

                oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                oT.NGAYVIETDON = DateTime.Now;
                oT.NGAYNHANDON = DateTime.Now;
                oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);
                oT.CANBONHANDONID = 0;
                oT.THAMPHANKYNHANDON = 0;
                oT.LOAIDON = 1;
                oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                {
                    ALD_DON_BL dsBL = new ALD_DON_BL();
                    oT.TOAANID = objDon.TOAANID;
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = 0;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_LAODONG + "." + oT.TT.ToString();
                    //ngay phan loai dkk, nguoi phan loai dkk
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        oT.NGAYTAO = objDon.NGAYTAO;
                        oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                    }
                    catch (Exception ex) { }
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    gsdt.ALD_DON.Add(oT);
                    gsdt.SaveChanges();
                    hddVuAnID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("5", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    gsdt.SaveChanges();
                }
                #endregion
                //-----------------------------
                VuAnID = oT.ID;
                hddGSTP_MaVuViec.Value = oT.MAVUVIEC;
                //Lưu người khởi kiện đại diện
                //Update_NguyenDon(oT, VuAnID);
                //if (chkKhongCoNYC2.Checked == false)
                //    Update_BiDon(oT, VuAnID);
                //Lưu duong su
                Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_LAODONG);

                string lstIdDuongSu = "";
                string lstNameDuongSu = "";
                var lstDuongSu = (from a in gsdt.ALD_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                  join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  where a.TUCACHTOTUNG_MA == "NGUYENDON"
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                  });
                foreach (var item in lstDuongSu)
                {
                    lstIdDuongSu += item.ID + ",";
                }
                lstNameDuongSu = string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                lstIdDuongSu = "," + lstIdDuongSu;

                Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_LAODONG, lstIdDuongSu, lstNameDuongSu);
                //-----------------------------
                ALD_DON_DUONGSU_BL oDonBL = new ALD_DON_DUONGSU_BL();
                oDonBL.ALD_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_LAODONG);
                return VuAnID;
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }
        private Decimal Update_APS(Decimal DonKKID, DONKK_DON objDon)
        {
            Decimal VuAnID = 0;
            try
            {
                if (CheckValid())
                {
                    APS_DON oT;
                    #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                    if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                    {
                        oT = new APS_DON();
                    }
                    else
                    {
                        decimal ID = Convert.ToDecimal(hddVuAnID.Value);
                        oT = gsdt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    oT.TENVUVIEC = GetTenVuViec(DonKKID);
                    oT.HINHTHUCNHANDON = HinhThucNhanDon_TrucTuyen;
                    oT.NGAYVIETDON = DateTime.Now;
                    oT.NGAYNHANDON = DateTime.Now;
                    oT.LOAIQUANHE = Convert.ToDecimal(hddLoaiQuanHe.Value);
                    oT.QUANHEPHAPLUATID = Convert.ToDecimal(dropQHPL.SelectedValue);
                    oT.QHPLTKID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);

                    oT.CANBONHANDONID = 0;
                    oT.THAMPHANKYNHANDON = 0;
                    oT.LOAIDON = 1;
                    oT.NOIDUNGKHOIKIEN = objDon.NOIDUNG;
                    if (hddVuAnID.Value == "" || hddVuAnID.Value == "0")
                    {
                        APS_DON_BL dsBL = new APS_DON_BL();
                        oT.TOAANID = objDon.TOAANID;
                        oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                        oT.TRANGTHAI = 0;
                        oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_PHASAN + "." + oT.TT.ToString();

                        //ngay phan loai dkk, nguoi phan loai dkk
                        oT.NGAYSUA = DateTime.Now;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        try
                        {
                            //Ngay tao dkk, nguoi tao donkk
                            oT.NGAYTAO = objDon.NGAYTAO;
                            oT.NGUOITAO = dt.DONKK_USERS.Where(x => x.ID == objDon.NGUOITAO).Single<DONKK_USERS>().EMAIL;
                        }
                        catch (Exception ex) { }

                        oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        gsdt.APS_DON.Add(oT);
                        gsdt.SaveChanges();
                        hddVuAnID.Value = oT.ID.ToString();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("7", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
                    else
                    {
                        oT.NGAYSUA = DateTime.Now;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        gsdt.SaveChanges();
                    }
                    #endregion
                    //-----------------------------
                    VuAnID = oT.ID;
                    hddGSTP_MaVuViec.Value = oT.MAVUVIEC;

                    //Lưu người khởi kiện đại diện
                    //Update_NguyenDon(oT, VuAnID);
                    //Update_BiDon(oT, VuAnID);
                    //Lưu duong su
                    Update_QLAn_DuongSu(VuAnID, DonKKID, ENUM_LOAIAN.AN_PHASAN);

                    string lstIdDuongSu = "";
                    string lstNameDuongSu = "";
                    var lstDuongSu = (from a in gsdt.APS_DON_DUONGSU.Where(s => s.DONID == VuAnID)
                                      join d in gsdt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                      where a.TUCACHTOTUNG_MA== "NGUYENDON"
                                      select new
                                      {
                                          ID = a.ID,
                                          TENDUONGSU = a.TENDUONGSU + " (" + d.TEN + ")",
                                      });
                    foreach (var item in lstDuongSu)
                    {
                        lstIdDuongSu += item.ID + ",";
                    }
                    lstNameDuongSu = string.Join(",", lstDuongSu.Select(s => s.TENDUONGSU));
                    lstIdDuongSu = "," + lstIdDuongSu;


                    Update_NguoiThamGiaTotung(VuAnID, DonKKID, ENUM_LOAIAN.AN_PHASAN, lstIdDuongSu, lstNameDuongSu);
                    //-----------------------------
                    APS_DON_DUONGSU_BL oDonBL = new APS_DON_DUONGSU_BL();
                    oDonBL.APS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);

                    Update_QLAn_TaiLieuBanGiao(DonKKID, VuAnID, ENUM_LOAIAN.AN_PHASAN);
                    return VuAnID;
                }
                else return 0;
            }
            catch (Exception ex)
            {
                //lttThongBaoTop.Text = lbthongbao.Text = "<div class='msg_thongbao'>Lỗi: " + ex.Message + "</div>";
                return 0;
            }
        }

        string GetTenVuViec(Decimal DonKKID)
        {
            string temp = "";
            List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID && x.ISDAIDIEN == 1).ToList<DONKK_DON_DUONGSU>();
            if (lstDS != null && lstDS.Count > 0)
            {
                string nguyendon = "";
                string bidon = "";
                foreach (DONKK_DON_DUONGSU item in lstDS)
                {
                    if (item.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
                        nguyendon = item.TENDUONGSU;
                    else if (item.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                        bidon = item.TENDUONGSU;
                }
                temp = nguyendon + " - " + bidon + " - " + dropQHPL.SelectedItem.Text;
            }
            return temp;
        }

        void Update_NguoiThamGiaTotung(Decimal VuAnID, Decimal DonKKID, String MaLoaiVuViec,string lstIdDuongSu,string lstNameDuongSu)
        {
            Decimal QLA_DuongSuID = 0;
            List<DONKK_DON_THAMGIATOTUNG> lst = dt.DONKK_DON_THAMGIATOTUNG.Where(x => x.DONKKID == DonKKID).ToList<DONKK_DON_THAMGIATOTUNG>();
            if (lst != null && lst.Count > 0)
            {
                string TuCachToTung_Ma = "", TenDuongSu = "", SoCMND;
                foreach (DONKK_DON_THAMGIATOTUNG item in lst)
                {
                    QLA_DuongSuID = 0;
                    TenDuongSu = item.TENDUONGSU;
                    SoCMND = item.SOCMND;

                    switch (MaLoaiVuViec)
                    {
                        case ENUM_LOAIAN.AN_DANSU:
                            List<ADS_DON_THAMGIATOTUNG> lstDS = gsdt.ADS_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstDS == null || lstDS.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnDanSu(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                        case ENUM_LOAIAN.AN_HANHCHINH:
                            List<AHC_DON_THAMGIATOTUNG> lstHC = gsdt.AHC_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstHC == null || lstHC.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnHanhChinh(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            List<AHN_DON_THAMGIATOTUNG> lstHN = gsdt.AHN_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstHN == null || lstHN.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnHNGD(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            List<AKT_DON_THAMGIATOTUNG> lstKT = gsdt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstKT == null || lstKT.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnKDTM(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            List<ALD_DON_THAMGIATOTUNG> lstLD = gsdt.ALD_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstLD == null || lstLD.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnLaoDong(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                        case ENUM_LOAIAN.AN_PHASAN:
                            List<APS_DON_THAMGIATOTUNG> lstPS = gsdt.APS_DON_THAMGIATOTUNG.Where(x => x.DONID == VuAnID).ToList();
                            if (lstPS == null || lstPS.Count == 0)
                                QLA_DuongSuID = ThemThamGiaTotung_AnPhaSan(item, VuAnID, lstIdDuongSu, lstNameDuongSu);
                            break;
                    }


                }
            }
        }
        Decimal ThemThamGiaTotung_AnDanSu(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu,string lstNameDuongSu)
        {
            ADS_DON_THAMGIATOTUNG oND = new ADS_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
           
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            oND.SOCMND = item.SOCMND;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG=="UYQUYEN"? "TGTTDS_01" : item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;
            
            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.ADS_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }
        Decimal ThemThamGiaTotung_AnHanhChinh(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu, string lstNameDuongSu)
        {
            AHC_DON_THAMGIATOTUNG oND = new AHC_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
            oND.SOCMND = item.SOCMND;
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.AHC_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }

        //----------------------------------------
        Decimal ThemThamGiaTotung_AnKDTM(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu, string lstNameDuongSu)
        {
            AKT_DON_THAMGIATOTUNG oND = new AKT_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
            oND.SOCMND = item.SOCMND;
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.AKT_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }
        Decimal ThemThamGiaTotung_AnHNGD(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu, string lstNameDuongSu)
        {
            AHN_DON_THAMGIATOTUNG oND = new AHN_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
            oND.SOCMND = item.SOCMND;
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.AHN_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }
        //--------------------------------------
        Decimal ThemThamGiaTotung_AnLaoDong(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu, string lstNameDuongSu)
        {
            ALD_DON_THAMGIATOTUNG oND = new ALD_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
            oND.SOCMND = item.SOCMND;
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.ALD_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }
        Decimal ThemThamGiaTotung_AnPhaSan(DONKK_DON_THAMGIATOTUNG item, Decimal VuAnID,string lstIdDuongSu, string lstNameDuongSu)
        {
            APS_DON_THAMGIATOTUNG oND = new APS_DON_THAMGIATOTUNG();
            oND.DONID = VuAnID;
            oND.SOCMND = item.SOCMND;
            oND.HOTEN = item.HOTEN;
            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.THANGSINH = item.THANGSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);
            oND.TUCACHTGTTID = item.TUCACHTOTUNG;
            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            //oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            //oND.NDD_DIACHIID = item.NDD_DIACHIID;
            //oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            //oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            //oND.ISSOTHAM = 1;
            //oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            oND.DUONGSUID = lstIdDuongSu;
            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.APS_DON_THAMGIATOTUNG.Add(oND);
            gsdt.SaveChanges();

            return oND.ID;
        }




        #region Update QuanLyAn GSTP. duong su
        void Update_QLAn_DuongSu(Decimal VuAnID, Decimal DonKKID, String MaLoaiVuViec)
        {
            Decimal QLA_DuongSuID = 0;
            List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID).ToList<DONKK_DON_DUONGSU>();
            if (lst != null && lst.Count > 0)
            {
                string TuCachToTung_Ma = "", TenDuongSu = "", SoCMND;
                foreach (DONKK_DON_DUONGSU item in lst)
                {
                    QLA_DuongSuID = 0;
                    TuCachToTung_Ma = item.TUCACHTOTUNG_MA;
                    TenDuongSu = item.TENDUONGSU;
                    SoCMND = item.SOCMND;

                    switch (MaLoaiVuViec)
                    {
                        case ENUM_LOAIAN.AN_DANSU:
                            List<ADS_DON_DUONGSU> lstDS = gsdt.ADS_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstDS == null || lstDS.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnDanSu(item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_HANHCHINH:
                            List<AHC_DON_DUONGSU> lstHC = gsdt.AHC_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstHC == null || lstHC.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnHanhChinh(item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            List<AHN_DON_DUONGSU> lstHN = gsdt.AHN_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstHN == null || lstHN.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnHNGD(item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            List<AKT_DON_DUONGSU> lstKT = gsdt.AKT_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstKT == null || lstKT.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnKDTM(item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            List<ALD_DON_DUONGSU> lstLD = gsdt.ALD_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstLD == null || lstLD.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnLaoDong(item, VuAnID);
                            break;
                        case ENUM_LOAIAN.AN_PHASAN:
                            List<APS_DON_DUONGSU> lstPS = gsdt.APS_DON_DUONGSU.Where(x => x.DONID == VuAnID
                                                                              && x.TUCACHTOTUNG_MA == TuCachToTung_Ma
                                                                              && x.TENDUONGSU == TenDuongSu
                                                                              && x.SOCMND == SoCMND
                                                                            ).ToList();
                            if (lstPS == null || lstPS.Count == 0)
                                QLA_DuongSuID = ThemDuongSu_AnPhaSan(item, VuAnID);
                            break;
                    }


                }
            }
        }

        Decimal ThemDuongSu_AnDanSu(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            ADS_DON_DUONGSU oND = new ADS_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }

            gsdt.ADS_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnHanhChinh(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AHC_DON_DUONGSU oND = new AHC_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            // oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.AHC_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }

        //----------------------------------------
        Decimal ThemDuongSu_AnKDTM(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AKT_DON_DUONGSU oND = new AKT_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            
            // quyennd
            if (oND.TOA_GIAIQUYET_ID == null)
                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            
            gsdt.AKT_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnHNGD(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            AHN_DON_DUONGSU oND = new AHN_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //  oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.AHN_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();
            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        //--------------------------------------
        Decimal ThemDuongSu_AnLaoDong(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            ALD_DON_DUONGSU oND = new ALD_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            oND.TUOI = (String.IsNullOrEmpty(oND.NAMSINH + "") || oND.NAMSINH == 0) ? 0 : (DateTime.Now.Year - oND.NAMSINH);

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.ALD_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();
            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        Decimal ThemDuongSu_AnPhaSan(DONKK_DON_DUONGSU item, Decimal VuAnID)
        {
            APS_DON_DUONGSU oND = new APS_DON_DUONGSU();
            oND.DONID = VuAnID;
            oND.TENDUONGSU = item.TENDUONGSU;
            oND.ISDAIDIEN = item.ISDAIDIEN;
            oND.TUCACHTOTUNG_MA = item.TUCACHTOTUNG_MA;
            oND.LOAIDUONGSU = item.LOAIDUONGSU;
            oND.SOCMND = item.SOCMND;
            oND.QUOCTICHID = item.QUOCTICHID;

            //-----------------------------------
            oND.TAMTRUID = item.TAMTRUID;
            oND.TAMTRUCHITIET = item.TAMTRUCHITIET;
            oND.TAMTRUTINHID = item.TAMTRUTINHID;
            //-----------------------------------
            oND.HKTTID = item.HKTTID;
            oND.HKTTCHITIET = item.HKTTCHITIET;
            oND.HKTTTINHID = item.HKTTTINHID;
            //-----------------------------------
            oND.NGAYSINH = item.NGAYSINH;
            oND.NAMSINH = item.NAMSINH;
            //oND.TUOI = DateTime.Now.Year - oND.NAMSINH;

            //-----------------------------------
            oND.GIOITINH = item.GIOITINH;
            oND.SINHSONG_NUOCNGOAI = item.SINHSONG_NUOCNGOAI;

            oND.EMAIL = item.EMAIL;
            oND.DIENTHOAI = item.DIENTHOAI;
            oND.FAX = item.FAX;

            //-------Nguoi dai dien cua to chuc------------------
            oND.NDD_DIACHIID = item.NDD_DIACHIID;
            oND.NDD_DIACHICHITIET = item.NDD_DIACHICHITIET;
            oND.CHUCVU = item.CHUCVU;
            oND.NGUOIDAIDIEN = item.NGUOIDAIDIEN;

            //-------------------------
            oND.ISSOTHAM = 1;
            oND.ISDON = 1;

            //-----------------
            //ngay phan loai dkk, nguoi phan loai dkk
            oND.NGAYSUA = DateTime.Now;
            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            try
            {
                //Ngay tao dkk, nguoi tao donkk
                oND.NGAYTAO = item.NGAYTAO;
                oND.NGUOITAO = item.NGUOITAO;
            }
            catch (Exception ex) { }
            gsdt.APS_DON_DUONGSU.Add(oND);
            gsdt.SaveChanges();

            //-----Update DonKK_DuongSu.DuongSuID------------
            Decimal QLA_DuongSuID = (decimal)oND.ID;
            item.DUONGSUID = QLA_DuongSuID;
            dt.SaveChanges();
            return oND.ID;
        }
        //------------------------------------
        #endregion

        #region Update QuanLyAn GSTP. TaiLieuBanGiao
        void Update_QLAn_TaiLieuBanGiao(decimal DonKKID, decimal VuAnID, String MaLoaiVuViec)
        {
            DONKK_DON_DUONGSU obj = dt.DONKK_DON_DUONGSU.Where(x => x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                                                                && x.DONKKID == DonKKID
                                                                && x.ISDAIDIEN == 1).Single<DONKK_DON_DUONGSU>();

            if (obj != null)
            {
                Decimal QLA_DuongSuId = (Decimal)obj.DUONGSUID;
                switch (MaLoaiVuViec)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        ADS_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        AHC_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        AHN_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        AKT_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        ALD_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        APS_File(obj, DonKKID, VuAnID, QLA_DuongSuId);
                        break;
                }
            }
        }

        void ADS_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<ADS_DON_TAILIEU> lstDS = gsdt.ADS_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ADS_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (ADS_DON_TAILIEU itemOld in lstDS)
                            gsdt.ADS_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                ADS_DON_TAILIEU objTL = new ADS_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new ADS_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    objTL.NGAYBANGIAO = DateTime.Now;

                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.ADS_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    ADS_DON_BANGIAO_TAILIEU objBG = null;
                    List<ADS_DON_BANGIAO_TAILIEU> lstBG = gsdt.ADS_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ADS_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (ADS_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new ADS_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        objBG.NGUOINHANID = 0;
                        gsdt.ADS_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AHC_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AHC_DON_TAILIEU> lstDS = gsdt.AHC_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHC_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AHC_DON_TAILIEU itemOld in lstDS)
                            gsdt.AHC_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AHC_DON_TAILIEU objTL = new AHC_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AHC_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AHC_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AHC_DON_BANGIAO_TAILIEU objBG = null;
                    List<AHC_DON_BANGIAO_TAILIEU> lstBG = gsdt.AHC_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHC_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AHC_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new AHC_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        objBG.NGUOINHANID = 0;
                        gsdt.AHC_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AHN_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AHN_DON_TAILIEU> lstDS = gsdt.AHN_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHN_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AHN_DON_TAILIEU itemOld in lstDS)
                            gsdt.AHN_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AHN_DON_TAILIEU objTL = new AHN_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AHN_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AHN_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AHN_DON_BANGIAO_TAILIEU objBG = null;
                    List<AHN_DON_BANGIAO_TAILIEU> lstBG = gsdt.AHN_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AHN_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AHN_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new AHN_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;

                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        objBG.NGUOINHANID = 0;
                        gsdt.AHN_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void ALD_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<ALD_DON_TAILIEU> lstDS = gsdt.ALD_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ALD_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (ALD_DON_TAILIEU itemOld in lstDS)
                            gsdt.ALD_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                ALD_DON_TAILIEU objTL = new ALD_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new ALD_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.ALD_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    ALD_DON_BANGIAO_TAILIEU objBG = null;
                    List<ALD_DON_BANGIAO_TAILIEU> lstBG = gsdt.ALD_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<ALD_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (ALD_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new ALD_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";


                        objBG.NGUOINHANID = 0;
                        gsdt.ALD_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void AKT_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<AKT_DON_TAILIEU> lstDS = gsdt.AKT_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AKT_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (AKT_DON_TAILIEU itemOld in lstDS)
                            gsdt.AKT_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                AKT_DON_TAILIEU objTL = new AKT_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new AKT_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.AKT_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    AKT_DON_BANGIAO_TAILIEU objBG = null;
                    List<AKT_DON_BANGIAO_TAILIEU> lstBG = gsdt.AKT_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<AKT_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (AKT_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new AKT_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        objBG.NGUOINHANID = 0;
                        gsdt.AKT_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }
        void APS_File(DONKK_DON_DUONGSU objDS, decimal DonKKID, decimal VuAnID, Decimal QLA_DuongSuId)
        {
            List<DONKK_DON_TAILIEU> lst = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList<DONKK_DON_TAILIEU>();
            if (lst != null && lst.Count > 0)
            {
                //------Xoa file cu + dinh kem file moi
                try
                {
                    List<APS_DON_TAILIEU> lstDS = gsdt.APS_DON_TAILIEU.Where(x => x.DONID == VuAnID).ToList<APS_DON_TAILIEU>();
                    if (lstDS != null && lstDS.Count > 0)
                    {
                        foreach (APS_DON_TAILIEU itemOld in lstDS)
                            gsdt.APS_DON_TAILIEU.Remove(itemOld);
                        gsdt.SaveChanges();
                    }
                }
                catch (Exception ex) { }

                //-------------------------
                APS_DON_TAILIEU objTL = new APS_DON_TAILIEU();
                foreach (DONKK_DON_TAILIEU item in lst)
                {
                    objTL = new APS_DON_TAILIEU();
                    objTL.DONID = VuAnID;
                    objTL.BANGIAOID = 0;
                    objTL.LOAIFILE = item.LOAIFILE;
                    objTL.TENFILE = item.TENFILE;
                    objTL.NOIDUNG = item.NOIDUNG;
                    objTL.TENTAILIEU = item.TENTAILIEU;
                    //ngay phan loai dkk, nguoi phan loai dkk
                    objTL.NGAYSUA = DateTime.Now;
                    objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    try
                    {
                        //Ngay tao dkk, nguoi tao donkk
                        objTL.NGAYTAO = objDS.NGAYTAO;
                        objTL.NGUOITAO = objDS.NGUOITAO;
                    }
                    catch (Exception ex) { }
                    objTL.NGUOIBANGIAO = QLA_DuongSuId;
                    objTL.LOAIDOITUONG = 0;//=0--> nguyendon
                    objTL.NGUOINHANID = 0;

                    gsdt.APS_DON_TAILIEU.Add(objTL);
                    gsdt.SaveChanges();
                }

                //------------ban giao tai lieu-------------------------
                try
                {
                    APS_DON_BANGIAO_TAILIEU objBG = null;
                    List<APS_DON_BANGIAO_TAILIEU> lstBG = gsdt.APS_DON_BANGIAO_TAILIEU.Where(x => x.DONID == VuAnID).ToList<APS_DON_BANGIAO_TAILIEU>();
                    if (lstBG != null && lstBG.Count > 0)
                    {
                        objBG = (APS_DON_BANGIAO_TAILIEU)lstBG[0];
                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    else
                    {
                        objBG = new APS_DON_BANGIAO_TAILIEU();
                        objBG.DONID = VuAnID;
                        objBG.NGAYBANGIAO = objDS.NGAYTAO;
                        objBG.NGUOIBANGIAO = objDS.NGUOITAO;

                        objBG.NGAYTAO = objDS.NGAYTAO;
                        objBG.NGUOITAO = objDS.NGUOITAO;

                        objBG.NGAYSUA = DateTime.Now;
                        objBG.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        objBG.NGUOINHANID = 0;
                        gsdt.APS_DON_BANGIAO_TAILIEU.Add(objBG);

                    }
                    gsdt.SaveChanges();
                }
                catch (Exception ex) { }
            }
        }

        #endregion
        #endregion


        #endregion

    }
}