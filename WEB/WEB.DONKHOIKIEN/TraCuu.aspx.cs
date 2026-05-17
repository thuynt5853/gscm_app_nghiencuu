using System;
using System.Data;
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
namespace WEB.DONKHOIKIEN
{
    public partial class TraCuu : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        int SoLuongKyTu = 6;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getIMG()", true);
        }
        //void CreateRandomCode()
        //{
           // String StrRandom = Cls_Comon.RandomString(SoLuongKyTu);
           // lttRandom.Text = hddTempCode.Value = StrRandom;
        //}
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            if (txtMaCapCha.Text.Trim() != Convert.ToString(Cache[hddcapcha.Value]))
            {
                lttThongBao.Text = "<div class='msg_thongbao'>Chuỗi xác nhận không chính xác</div>";
                txtMaCapCha.Focus();
                return;
            }
            lttThongBao.Text = "";
            decimal trangthai = (Decimal)ENUM_DS_TRANGTHAI.THULY;
            string mavuviec = txtMaVuViec.Text.Trim();
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.MAVUVIEC == mavuviec 
                                                    && x.TRANGTHAI == trangthai
                                                ).SingleOrDefault();
            if (obj != null)
            {
                decimal VuViecID = (Decimal)obj.VUANID;
                string MaLoaiVuViec = obj.MALOAIVUAN;

                if (CheckMaBaoMatHS_TheoLoaiVuViec(MaLoaiVuViec, VuViecID))
                {
                    pnHoSo.Visible = true;
                    lttVuViec.Text = obj.TENVUVIEC;
                    string temp = "";
                    switch (Convert.ToInt32(obj.TRANGTHAI.GetValueOrDefault(0)))
                    {
                        case 0:
                            temp = "Đơn đã gửi & chờ xử lý";
                            break;
                        case 3:
                            temp = "Đơn bị trả lại do chưa đủ điều kiện";
                            break;
                        case 4:
                            temp = "Đơn chờ bổ sung";
                            break;
                        case 5:
                            temp = "Đơn đã thụ lý";
                            break;
                    }
                    lttTrangThai.Text = temp;

                    //-----------------------------
                    try
                    {
                        Decimal ToaAnID = obj.TOAANID;
                        DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == ToaAnID).Single<DM_TOAAN>();
                        if (objTA != null)
                            lttToaAn.Text = objTA.TEN;
                    } catch (Exception ex) { }
                    //-----------------------------
                    try
                    {
                        LoadNguyenDonVuAn(MaLoaiVuViec, VuViecID);
                    }
                    catch (Exception ex) { }
                    //-----------Lay ds Van ban tong dat---------------

                    LoadFile_VBTongDat(obj.ID, (Decimal)obj.VUANID);
                    
                }
                else
                {
                    pnHoSo.Visible = false;
                    lttThongBao.Text = "<div class='msg_thongbao'>Không tìm thấy hồ sơ theo yêu cầu!</div>";
                } 
            }
            else
            {
                pnHoSo.Visible = false;
                lttThongBao.Text = "<div class='msg_thongbao'>Không tìm thấy hồ sơ theo yêu cầu!</div>";
            }
        }
        Boolean CheckMaBaoMatHS_TheoLoaiVuViec(string MaLoaiVuViec, Decimal VuViecID)
        {
            string ma_bao_mat = txtMaBaoMatHS.Text.Trim();
            Boolean retval = false;
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    ADS_DON obj1 = gsdt.ADS_DON.Where(x => x.MABAOMAT == ma_bao_mat 
                                                        && x.ID == VuViecID).Single<ADS_DON>();
                    if (obj1 != null)
                    {
                        lttVuViec.Text = obj1.TENVUVIEC;
                        retval = true;
                    }
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    AHC_DON obj2 = gsdt.AHC_DON.Where(x => x.MABAOMAT == ma_bao_mat 
                                                        && x.ID == VuViecID).Single<AHC_DON>();
                    if (obj2 != null)
                    { lttVuViec.Text = obj2.TENVUVIEC; retval = true; }
                        break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    AHN_DON obj3 = gsdt.AHN_DON.Where(x => x.MABAOMAT == ma_bao_mat 
                                                        && x.ID == VuViecID).Single<AHN_DON>();
                    if (obj3 != null)
                    { lttVuViec.Text = obj3.TENVUVIEC; retval = true; }
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    AKT_DON obj4 = gsdt.AKT_DON.Where(x => x.MABAOMAT == ma_bao_mat 
                                                        && x.ID == VuViecID).Single<AKT_DON>();
                    if (obj4 != null)
                    { lttVuViec.Text = obj4.TENVUVIEC; retval = true; }
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    ALD_DON obj5 = gsdt.ALD_DON.Where(x => x.MABAOMAT == ma_bao_mat 
                                                        && x.ID == VuViecID).Single<ALD_DON>();
                    if (obj5 != null)
                    { lttVuViec.Text = obj5.TENVUVIEC; retval = true; }
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    APS_DON obj6 = gsdt.APS_DON.Where(x => x.MABAOMAT == ma_bao_mat
                                                        && x.ID == VuViecID).Single<APS_DON>();
                    if (obj6 != null)
                    { lttVuViec.Text = obj6.TENVUVIEC; retval = true; }
                    break;
            }
            return retval;
        }
        void LoadNguyenDonVuAn(string MaLoaiVuViec, Decimal VuViecID)
        {
            string MaTuCachToTung = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            DM_DATAITEM_BL objBL = new DM_DATAITEM_BL();
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:                    
                    ADS_DON_DUONGSU objDS = gsdt.ADS_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                                        && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                                        && x.ISDAIDIEN == 1
                                                                                    ).Single<ADS_DON_DUONGSU>();
                    lblTennguyendon.Text = objDS.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objDS.NGAYSINH == DateTime.MinValue) ? objDS.NAMSINH.ToString() : ((DateTime)objDS.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objDS.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objDS.QUOCTICHID);

                    lblDienThoai.Text = objDS.DIENTHOAI + "";
                    lblFax.Text = objDS.FAX;
                    lblEmail.Text = objDS.EMAIL;
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    AHC_DON_DUONGSU objHC = gsdt.AHC_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                   && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                   && x.ISDAIDIEN == 1
                                                               ).Single<AHC_DON_DUONGSU>();
                    lblTennguyendon.Text = objHC.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objHC.NGAYSINH == DateTime.MinValue) ? objHC.NAMSINH.ToString() : ((DateTime)objHC.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objHC.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objHC.QUOCTICHID);

                    lblDienThoai.Text = objHC.DIENTHOAI + "";
                    lblFax.Text = objHC.FAX;
                    lblEmail.Text = objHC.EMAIL;
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    AHN_DON_DUONGSU objHN = gsdt.AHN_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                   && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                   && x.ISDAIDIEN == 1
                                                               ).Single<AHN_DON_DUONGSU>();
                    lblTennguyendon.Text = objHN.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objHN.NGAYSINH == DateTime.MinValue) ? objHN.NAMSINH.ToString() : ((DateTime)objHN.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objHN.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objHN.QUOCTICHID);

                    lblDienThoai.Text = objHN.DIENTHOAI + "";
                    lblFax.Text = objHN.FAX;
                    lblEmail.Text = objHN.EMAIL;
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    AKT_DON_DUONGSU objKT = gsdt.AKT_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                   && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                   && x.ISDAIDIEN == 1
                                                               ).Single<AKT_DON_DUONGSU>();
                    lblTennguyendon.Text = objKT.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objKT.NGAYSINH == DateTime.MinValue) ? objKT.NAMSINH.ToString() : ((DateTime)objKT.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objKT.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objKT.QUOCTICHID);

                    lblDienThoai.Text = objKT.DIENTHOAI + "";
                    lblFax.Text = objKT.FAX;
                    lblEmail.Text = objKT.EMAIL;
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    ALD_DON_DUONGSU objLD = gsdt.ALD_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                   && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                   && x.ISDAIDIEN == 1
                                                               ).Single<ALD_DON_DUONGSU>();
                    lblTennguyendon.Text = objLD.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objLD.NGAYSINH == DateTime.MinValue) ? objLD.NAMSINH.ToString() : ((DateTime)objLD.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objLD.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objLD.QUOCTICHID);

                    lblDienThoai.Text = objLD.DIENTHOAI + "";
                    lblFax.Text = objLD.FAX;
                    lblEmail.Text = objLD.EMAIL;
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    APS_DON_DUONGSU objPS = gsdt.APS_DON_DUONGSU.Where(x => x.DONID == VuViecID
                                                                   && x.TUCACHTOTUNG_MA == MaTuCachToTung
                                                                   && x.ISDAIDIEN == 1
                                                               ).Single<APS_DON_DUONGSU>();
                    lblTennguyendon.Text = objPS.TENDUONGSU;
                    lblNguyendon_ngaysinh.Text = (objPS.NGAYSINH == DateTime.MinValue) ? objPS.NAMSINH.ToString() : ((DateTime)objPS.NGAYSINH).ToString("dd/MM/yyyy", cul);
                    lblCMND.Text = objPS.SOCMND;

                    lblQuocTich.Text = objBL.GetTextByID((Decimal)objPS.QUOCTICHID);

                    lblDienThoai.Text = objPS.DIENTHOAI + "";
                    lblFax.Text = objPS.FAX;
                    lblEmail.Text = objPS.EMAIL;
                    break;
            }
        }
        #region DowLoadFile_ VB tong dat        
        void LoadFile_VBTongDat(Decimal DonKKID, Decimal VuViecID)
        {
            try
            {
                //List<DONKK_DON_VBTONGDAT> lst = dt.DONKK_DON_VBTONGDAT.Where(x => x.DONKKID == DonKKID
                //                                                               && x.VUVIECID == VuViecID).ToList<DONKK_DON_VBTONGDAT>();
                DonKK_VBTongDat_BL obj = new DonKK_VBTongDat_BL();
                DataTable tbl = obj.GetByDonKKAndVuViec(DonKKID, VuViecID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptFile.DataSource = tbl;
                    rptFile.DataBind();
                    pnVBTongDat.Visible = true;
                }
                else
                    pnVBTongDat.Visible = false;
            }catch(Exception ex) { }
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
        void DowloadFile(Decimal VanBanID)
        {
            try
            {
                DONKK_DON_VBTONGDAT oND = dt.DONKK_DON_VBTONGDAT.Where(x => x.ID == VanBanID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    if (oND.NOIDUNGFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);

                    }
                    else
                    {
                        lttThongBao.Text = "<div class='msg_thongbao'>Tệp đính kèm không có nội dung. Không thể tải về được!</div>";
                    }
                }
            }
            catch (Exception ex)
            {
                lttThongBao.Text = ex.Message;
            }
        }
        protected void rptFile_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {                
                DataRowView rv = (DataRowView)e.Item.DataItem;
                ImageButton imgFile = (ImageButton)e.Item.FindControl("imgFile");                
                if (!string.IsNullOrEmpty(rv["LOAIFILE"] + ""))
                {
                    string loaifile =rv["LOAIFILE"].ToString().ToLower().Replace(".", "");
                    switch (loaifile)
                    {
                        case "pdf":
                            imgFile.ImageUrl = "/UI/img/pdf.png";
                            break;
                        case "doc":
                            imgFile.ImageUrl = "/UI/img/word.png";
                            break;
                        case "docx":
                            imgFile.ImageUrl = "/UI/img/word.png";
                            break;
                        case "xls":
                            imgFile.ImageUrl = "/UI/img/excel.jpeg";
                            break;
                        case "xlsx":
                            imgFile.ImageUrl = "/UI/img/excel.jpeg";
                            break;
                        case "rar":
                            imgFile.ImageUrl = "/UI/img/rar.png";
                            break;
                        case "zip":
                            imgFile.ImageUrl = "/UI/img/zip.jpeg";
                            break;
                        default:
                            imgFile.ImageUrl = "/UI/img/attachfile.png";
                            break;
                    }
                    imgFile.Width = 27;
                    imgFile.Height = 32;
                }
            }
        }

        #endregion

        protected void cmdRefreshCode_Click(object sender, ImageClickEventArgs e)
        {
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getIMG()", true);
        }
    }
}