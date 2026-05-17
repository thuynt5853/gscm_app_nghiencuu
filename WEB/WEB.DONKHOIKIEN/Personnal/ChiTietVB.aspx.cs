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
    public partial class ChiTietVB : System.Web.UI.Page
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
                Decimal dTemp = 0;
                //--------load thong tin vu an theo loai----------------------
                Decimal VuViecID = Convert.ToDecimal(objVB.VUVIECID);
                String loai_vuviec = objVB.MALOAIVUVIEC;
                if (String.IsNullOrEmpty(objVB.TENVUVIEC + ""))
                {
                    switch (loai_vuviec)
                    {
                        case ENUM_LOAIAN.AN_DANSU:
                            ADS_DON objDS = gsdt.ADS_DON.Where(x => x.ID == VuViecID).Single<ADS_DON>();
                            lttVuViec.Text = objDS.TENVUVIEC;
                            dTemp = (Decimal)objDS.TOAANID;
                            break;
                        case ENUM_LOAIAN.AN_HANHCHINH:
                            AHC_DON objHC = gsdt.AHC_DON.Where(x => x.ID == VuViecID).Single<AHC_DON>();
                            lttVuViec.Text = objHC.TENVUVIEC;
                            dTemp = (Decimal)objHC.TOAANID;
                            break;
                        case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                            AHN_DON objHN = gsdt.AHN_DON.Where(x => x.ID == VuViecID).Single<AHN_DON>();
                            lttVuViec.Text = objHN.TENVUVIEC;
                            dTemp = (Decimal)objHN.TOAANID;
                            break;
                        case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                            AKT_DON objKT = gsdt.AKT_DON.Where(x => x.ID == VuViecID).Single<AKT_DON>();
                            dTemp = Convert.ToDecimal(objKT.TOAANID);
                            lttVuViec.Text = objKT.TENVUVIEC;
                            break;
                        case ENUM_LOAIAN.AN_LAODONG:
                            ALD_DON objLD = gsdt.ALD_DON.Where(x => x.ID == VuViecID).Single<ALD_DON>();
                            dTemp = Convert.ToDecimal(objLD.TOAANID);
                            lttVuViec.Text = objLD.TENVUVIEC;
                            break;
                        case ENUM_LOAIAN.AN_PHASAN:
                            APS_DON objPS = gsdt.APS_DON.Where(x => x.ID == VuViecID).Single<APS_DON>();
                            dTemp = Convert.ToDecimal(objPS.TOAANID);
                            lttVuViec.Text = objPS.TENVUVIEC;
                            break;
                    }
                }
                else
                    lttVuViec.Text = objVB.TENVUVIEC;

                //------Load thong tin toa an gui van ban-------------
                decimal ToaAnID = (string.IsNullOrEmpty(objVB.TOAANID + "")) ? 0 : Convert.ToDecimal(objVB.TOAANID);
                if (ToaAnID > 0)
                    dTemp = ToaAnID;

                DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == dTemp).SingleOrDefault();
                if (objTA != null)
                    lttToaAn.Text = objTA.TEN;

                //-----------Lay ds Van ban tong dat-------------
                List<DONKK_DON_VBTONGDAT> lst = new List<DONKK_DON_VBTONGDAT>();
                lst.Add(objVB);

                rptFile.DataSource = lst;
                rptFile.DataBind();
                pnVBTongDat.Visible = true;
                //---------------------
                if ((String.IsNullOrEmpty(objVB.ISREAD + "")) || (objVB.ISREAD == 0))
                {
                    objVB.ISREAD = 1;
                    objVB.NGAYDOC = DateTime.Now;
                    dt.SaveChanges();
                    GhiLog(objVB);
                    ShowTB_TiepNhanVB();
                }                
            }
            else pnVBTongDat.Visible = false;
        }


        #region DowLoadFile_ VB tong dat    
      

        //void LoadVanBanTongDat( Decimal VuViecID)
        //{
        //    try
        //    {
        //        List<DONKK_DON_VBTONGDAT> lst = dt.DONKK_DON_VBTONGDAT.Where(x => x.VUVIECID == VuViecID ).OrderBy(y=>y.NGAYGUI).ToList<DONKK_DON_VBTONGDAT>();
        //        if (lst != null && lst.Count > 0)
        //        {
        //            rptFile.DataSource = lst;
        //            rptFile.DataBind();
        //            pnVBTongDat.Visible = true;
        //        }
        //        else pnVBTongDat.Visible = false;
        //    }
        //    catch (Exception ex) { }
        //}
        //-----------------------------------------
        protected void rptFile_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // DataRowView rv = (DataRowView)e.Item.DataItem;
                DONKK_DON_VBTONGDAT obj = (DONKK_DON_VBTONGDAT)e.Item.DataItem;
                try
                {
                    ImageButton imgFile = (ImageButton)e.Item.FindControl("imgFile");
                    //string loaifile = string.IsNullOrEmpty(obj.LOAIFILE) ? "" : obj.LOAIFILE.ToString().ToLower().Replace(".", "");
                    //if (loaifile.Length > 0)
                    //{
                    //    switch (loaifile)
                    //    {
                    //        case "pdf":
                    //            imgFile.ImageUrl = "../UI/img/pdf.png";
                    //            break;
                    //        case "doc":
                    //            imgFile.ImageUrl = "../UI/img/document_download.png";
                    //            break;
                    //        case "docx":
                    //            imgFile.ImageUrl = "../UI/img/document_download.png";
                    //            break;
                    //        case "xls":
                    //            imgFile.ImageUrl = "../UI/img/excel.jpeg";
                    //            break;
                    //        case "xlsx":
                    //            imgFile.ImageUrl = "../UI/img/excel.jpeg";
                    //            break;
                    //        case "rar":
                    //            imgFile.ImageUrl = "../UI/img/rar.png";
                    //            break;
                    //        case "zip":
                    //            imgFile.ImageUrl = "../UI/img/zip.jpeg";
                    //            break;
                    //        default:
                    //            imgFile.ImageUrl = "../UI/img/attachfile.png";
                    //            break;
                    //    }
                    //}
                    //else
                    //{
                    //    imgFile.ImageUrl = "../UI/img/word.png";
                    //}
                    //imgFile.Width = 27;
                    //imgFile.Height = 32;
                }catch(Exception exx) {  }
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
        void GhiLog(DONKK_DON_VBTONGDAT oND)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String Detail_Action = CurrUserName + " - Nhận văn bản, thông báo mới từ Tòa án.<br/>";
            String KeyLog = ENUM_HD_NGUOIDUNG_DKK.NHANVB;

            //-----------------------------
            Detail_Action += "- Vụ việc:<br/>";            
            Detail_Action += "+ Lĩnh vực: ";
            switch (oND.MALOAIVUVIEC)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    Detail_Action += "Dân sự";
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Detail_Action += "Hành chính";
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Detail_Action += "Hôn nhân & Gia đình";
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Detail_Action += "Kinh doanh & Thương mại";
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Detail_Action += "Lao động";
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Detail_Action += "Phá sản";
                    break;
            }
            Detail_Action += "<br/>";
            Detail_Action += "+ Số vụ việc:" + oND.VUVIECID + "<br/>";
            Detail_Action += "+ Tên vụ việc:" + oND.TENVANBAN;
            //--------------
            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }

        void ShowTB_TiepNhanVB()
        {
            string temp = "";
            string ma_tiepnhanvb = "tiepnhanvbtongdat";
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(ma_tiepnhanvb);
            if (!String.IsNullOrEmpty(NoiDung))
                temp = NoiDung;
            //temp = String.Format(temp, Session[ENUM_SESSION.SESSION_USERTEN] + "", DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));

            string TenNguoiDung = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            temp = String.Format(temp, TenNguoiDung, DateTime.Now.ToString("dd/MM/yyyy hh:mm tt", cul));

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
        }
        #endregion
    }
}