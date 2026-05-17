using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using BL.DonKK;
using Module.Common;
using System.Globalization;

using DAL.GSTP;
using BL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.ADS;
using BL.GSTP.AHC;
using BL.GSTP.AHN;
using BL.GSTP.AKT;
using BL.GSTP.ALD;
using BL.GSTP.APS;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class ChiTietVB_DangKy : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();

        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    Decimal VanBanID = Convert.ToDecimal(Request["vID"] + "");
                    LoadInfo(VanBanID);
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }


        void LoadInfo(Decimal VanBanID)
        {
            DONKK_DON_VBTONGDAT objVB = dt.DONKK_DON_VBTONGDAT.Where(x => x.ID == VanBanID).Single<DONKK_DON_VBTONGDAT>();
            if (objVB != null)
            {
                decimal DonKienID = Convert.ToDecimal(objVB.DONKKID);
                DONKK_DON objDonKK = dt.DONKK_DON.Where(x => x.ID == DonKienID).Single<DONKK_DON>();
                string loai_vuviec = objDonKK.MALOAIVUAN;
                Decimal dTemp = Convert.ToDecimal(objDonKK.TOAANID);
                //--------load thong tin vu an theo loai----------------------
                Decimal VuViecID = Convert.ToDecimal(objVB.VUVIECID);
                
                switch (loai_vuviec)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        ADS_DON objDS = gsdt.ADS_DON.Where(x => x.ID == VuViecID).Single<ADS_DON>();
                       // dTemp = Convert.ToDecimal(objDS.TOAANID);
                        lttVuViec.Text = objDS.TENVUVIEC;
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        AHC_DON objHC = gsdt.AHC_DON.Where(x => x.ID == VuViecID).Single<AHC_DON>();
                       // dTemp = Convert.ToDecimal(objHC.TOAANID);
                        lttVuViec.Text = objHC.TENVUVIEC;
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        AHN_DON objHN = gsdt.AHN_DON.Where(x => x.ID == VuViecID).Single<AHN_DON>();
                       // dTemp = Convert.ToDecimal(objHN.TOAANID);
                        lttVuViec.Text = objHN.TENVUVIEC;
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        AKT_DON objKT = gsdt.AKT_DON.Where(x => x.ID == VuViecID).Single<AKT_DON>();
                       // dTemp = Convert.ToDecimal(objKT.TOAANID);
                        lttVuViec.Text = objKT.TENVUVIEC;
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        ALD_DON objLD = gsdt.ALD_DON.Where(x => x.ID == VuViecID).Single<ALD_DON>();
                      //  dTemp = Convert.ToDecimal(objLD.TOAANID);
                        lttVuViec.Text = objLD.TENVUVIEC;
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        APS_DON objPS = gsdt.APS_DON.Where(x => x.ID == VuViecID).Single<APS_DON>();
                      //  dTemp = Convert.ToDecimal(objPS.TOAANID);
                        lttVuViec.Text = objPS.TENVUVIEC;
                        break;
                }

                //------Load thong tin vu viec------------------
                DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == dTemp).SingleOrDefault();
                if (objTA != null)
                    lttToaAn.Text = objTA.TEN;

                //----------Nguyen don dai dien-------------------
                try
                {
                    LoadDsDuongSu(loai_vuviec, VuViecID);
                }
                catch (Exception ex) { }

                //---------------lay ds file cua don kien
                DsFileDonKK.DonKKID = DonKienID;

                //-----------Lay ds Van ban tong dat---------------
                LoadFile_VBTongDat(DonKienID, VuViecID);

            }
        }

        #region Load all duong su theo quan ly an trong GSTP
        int count_all = 0, IsDaiDien = 0;
        DataTable tblNguyenDonKhac = null, tblBiDonKhac = null;
        DataRow[] arr = null;

        void LoadDsDuongSu(string MaLoaiVuViec, Decimal VuViecID)
        {
            DataTable tbl = null;
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    ADS_DON_DUONGSU_BL objDuongSuBL = new ADS_DON_DUONGSU_BL();
                    tbl = objDuongSuBL.GetAllByVuViecID(VuViecID);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    AHC_DON_DUONGSU_BL objHC = new AHC_DON_DUONGSU_BL();
                    tbl = objHC.GetAllByVuViecID(VuViecID);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    AHN_DON_DUONGSU_BL objHN = new AHN_DON_DUONGSU_BL();
                    tbl = objHN.AHN_DON_DUONGSU_GETLIST(VuViecID);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    AKT_DON_DUONGSU_BL objKT = new AKT_DON_DUONGSU_BL();
                    tbl = objKT.AKT_DON_DUONGSU_GETLIST(VuViecID);                    
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    ALD_DON_DUONGSU_BL objLD = new ALD_DON_DUONGSU_BL();
                    tbl = objLD.ALD_DON_DUONGSU_GETLIST(VuViecID);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    APS_DON_DUONGSU_BL objPS = new APS_DON_DUONGSU_BL();
                    tbl = objPS.APS_DON_DUONGSU_GETLIST(VuViecID);
                    break;
            }

            if (tbl != null && tbl.Rows.Count > 0)
            {
                Load_NguyenDon(tbl);
                Load_BiDon(tbl);
                Load_DuongSuKhac(tbl);
            }
        }       
        void Load_NguyenDon(DataTable tbl)
        {
            DM_DATAITEM_BL objBL = new DM_DATAITEM_BL();
            arr = tbl.Select("TUCACHTOTUNG_MA='" + ENUM_DANSU_TUCACHTOTUNG.NGUYENDON + "'", "ISDAIDIEN desc"); ;
            if (arr != null && arr.Length > 0)
            {
                IsDaiDien = 0;
                count_all = arr.Length;
                if (count_all > 1)
                    tblNguyenDonKhac = tbl.Clone();

                foreach (DataRow row in arr)
                {
                    IsDaiDien = Convert.ToInt16(row["ISDAIDIEN"] + "");
                    if (IsDaiDien == 1)
                    {
                        #region Load Nguyen don dai dien
                        lblTennguyendon.Text = row["TENDUONGSU"] + "";
                        lblNguyendon_ngaysinh.Text = row["NAMSINH"].ToString();
                        lblCMND.Text = row["SOCMND"] + "";
                        lblQuocTich.Text = objBL.GetTextByID(Convert.ToDecimal(row["QUOCTICHID"] + ""));
                        lblDienThoai.Text = row["DIENTHOAI"] + "" + "";
                        lblFax.Text = row["FAX"] + "";
                        lblEmail.Text = row["EMAIL"] + "";
                        #endregion
                    }
                    else
                        AddRowToTable(tbl, tblNguyenDonKhac, row);
                }
                if (tblNguyenDonKhac != null && tblNguyenDonKhac.Rows.Count > 0)
                {
                    rptNguyenDon.DataSource = tblNguyenDonKhac;
                    rptNguyenDon.DataBind();
                    pnNguyenDonKhac.Visible = true;
                }
                else pnNguyenDonKhac.Visible = false;
            }          
        }
        void Load_BiDon(DataTable tbl)
        {
            DM_DATAITEM_BL objBL = new DM_DATAITEM_BL();
            arr = tbl.Select("TUCACHTOTUNG_MA='" + ENUM_DANSU_TUCACHTOTUNG.BIDON + "'", "ISDAIDIEN desc"); ;
            if (arr != null && arr.Length > 0)
            {
                IsDaiDien = 0;
                count_all = arr.Length;
                if (count_all > 1)
                    tblBiDonKhac = tbl.Clone();

                foreach (DataRow row in arr)
                {
                    IsDaiDien = Convert.ToInt16(row["ISDAIDIEN"] + "");
                    if (IsDaiDien == 1)
                    {
                        #region Load Nguyen don dai dien
                        lblTenbidon.Text = row["TENDUONGSU"] + "";
                        lblbidon_ngaysinh.Text = row["NAMSINH"].ToString();
                        lblbidonCMND.Text = row["SOCMND"] + "";
                        lblbidonQuocTich.Text = objBL.GetTextByID(Convert.ToDecimal(row["QUOCTICHID"] + ""));
                        lblbidonDienThoai.Text = row["DIENTHOAI"] + "" + "";
                        lblbidonFax.Text = row["FAX"] + "";
                        lblbidonEmail.Text = row["EMAIL"] + "";
                        #endregion
                    }
                    else
                        AddRowToTable(tbl, tblBiDonKhac, row);
                }
                if (tblBiDonKhac != null && tblBiDonKhac.Rows.Count > 0)
                {
                    rptBiDon.DataSource = tblBiDonKhac;
                    rptBiDon.DataBind();
                    pnBiDonKhac.Visible = true;
                }
                else pnBiDonKhac.Visible = false;
            }
        }
        void Load_DuongSuKhac(DataTable tbl)
        {
            arr = tbl.Select("TUCACHTOTUNG_MA <>'" + ENUM_DANSU_TUCACHTOTUNG.BIDON + "' and TUCACHTOTUNG_MA <>'" + ENUM_DANSU_TUCACHTOTUNG.NGUYENDON + "'", "ISDAIDIEN desc"); 
            if (arr != null && arr.Length > 0)
            {
                DataTable tblTemp = tbl.Clone();
                foreach(DataRow row in arr)
                    AddRowToTable(tbl, tblTemp, row);
                rptDuongSuKhac.DataSource = tblTemp;
                rptDuongSuKhac.DataBind();
                pnDSKhac.Visible = true;
            }
            else pnDSKhac.Visible = false;
        }
      
        //---------------------------------------------
        void AddRowToTable(DataTable tblRoot, DataTable tblCopy, DataRow rowdata)
        {
            DataRow newrow = tblCopy.NewRow();
            foreach (DataColumn cl in tblRoot.Columns)
                newrow[cl.ColumnName] = rowdata[cl.ColumnName];
            tblCopy.Rows.Add(newrow);
        }

        #endregion 

        #region DowLoadFile_ VB tong dat        
        void LoadFile_VBTongDat(Decimal DonKKID, Decimal VuViecID)
        {
            try
            {
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
            }
            catch (Exception ex) { }
        }
        //-----------------------------------------
        protected void rptFile_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                ImageButton imgFile = (ImageButton)e.Item.FindControl("imgFile");
                if (!string.IsNullOrEmpty(rv["LOAIFILE"] + ""))
                {
                    string loaifile = rv["LOAIFILE"].ToString().ToLower().Replace(".", "");
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

        protected void rptFile_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "dowload":
                    DowloadFile_VBTongDat(Convert.ToDecimal(e.CommandArgument));
                    break;
            }
        }

        void DowloadFile_VBTongDat(Decimal VanBanID)
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

                        //---------------------
                        if ((String.IsNullOrEmpty(oND.ISREAD + "")) || (oND.ISREAD == 0))
                        {
                            oND.ISREAD = 1;
                            oND.NGAYDOC = DateTime.Now;
                            dt.SaveChanges();
                            ShowTB_TiepNhanVB();
                        }
                    }
                    else
                    {
                        string msg = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", msg);
                    }
                }
            }
            catch (Exception ex)
            {
                // lttThongBaoTop.Text = lbthongbao.Text = ex.Message;
            }
        }
        void ShowTB_TiepNhanVB()
        {
            string temp = "";
            string ma_tiepnhanvb = "tiepnhanvbtongdat";
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(ma_tiepnhanvb);
            if (!String.IsNullOrEmpty(NoiDung))
                temp = NoiDung;
            temp = String.Format(temp, Session[ENUM_SESSION.SESSION_USERTEN] + "", DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));
            string TenNguoiDung = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            temp = String.Format(temp, TenNguoiDung, DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        }
        #endregion
    }
}