
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

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class pVBTDTheoDonKK : System.Web.UI.Page
    {
        public Decimal DonKKID = 0;
        //String MaLoaiVuViec = "";
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (Request["ID"] != null)
                {
                    DonKKID = Convert.ToDecimal(Request["ID"] + "");
                    if (!IsPostBack)
                        LoadThongTinDonKK(DonKKID);
                }
                else Response.Redirect("/Personnal/Dsdon.aspx");

            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadThongTinDonKK(Decimal DonKKID)
        {
            DONKK_DON obj = dt.DONKK_DON.Where(x => x.ID == DonKKID).Single<DONKK_DON>();
            if (obj != null)
            {
                decimal VuViecID = Convert.ToDecimal(obj.VUANID);
                //try
                //{
                //    if (obj.QUANHEPHAPLUATID > 0)
                //    {
                //        row_QHPL.Visible = true;
                //        DM_DATAITEM objQHPL = gsdt.DM_DATAITEM.Where(x => x.ID == obj.QUANHEPHAPLUATID).FirstOrDefault();
                //        lblQuanHePL.Text = objQHPL.TEN;
                //    }
                //    else row_QHPL.Visible = false;
                //}
                //catch (Exception ex) { row_QHPL.Visible = false; }

                ////----------------------
                //lblNoidungdon.Text = obj.NOIDUNG;
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
                //lttNgay.Text = ngayTao.Day.ToString();
                //lttThang.Text = ngayTao.Month.ToString();
                //lttNam.Text = ngayTao.Year.ToString();

                //-----------------------------
                LoadThongTinThuLy(obj);
                LoadDS_VBTongDat();
                
            }
        }
        void LoadThongTinThuLy(DONKK_DON obj)
        {
            int TrangThai = Convert.ToInt16(obj.TRANGTHAI + "");
            if (TrangThai == 5)
            {
                //Da duoc thu ly
                pnThuLy.Visible = true;
                DONKK_DON_BL objBL = new DONKK_DON_BL();
                DataTable tbl = objBL.GetListThuLyVuViecTheoDonKK(obj.MALOAIVUAN, (Decimal)obj.VUANID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptThuLy.DataSource = tbl;
                    rptThuLy.DataBind();
                    pnThuLy.Visible = true;
                }
                else
                    pnThuLy.Visible = false;
            }
            else
                pnThuLy.Visible = false;
        }
        //---------------------------------
        #region Load ds van ban tong dat cua vu viec
        void LoadDS_VBTongDat()
        {
            DonKKID = Convert.ToDecimal(Request["ID"] + "");

            lbthongbao.Text = "";
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable tbl = null;
            DonKK_VBTongDat_BL objBL = new DonKK_VBTongDat_BL();
            tbl = objBL.GetVBTongDatTheoDonKK(UserID, DonKKID, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi / <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rptVB.DataSource = tbl;
                rptVB.DataBind();
                pnListVBTongDat.Visible = true;
            }
            else
            {
                pnListVBTongDat.Visible = false;
                //lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        protected void rptVB_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command_name = e.CommandName;
            string command_arg = e.CommandArgument.ToString();
            switch (command_name)
            {
                case "dowload":
                    DowloadFileDon(Convert.ToDecimal(command_arg));
                    break;
                case "view":
                    // Response.Redirect("/Personnal/ChiTietVB.aspx?vID=" + command_arg);
                    //DowloadFile(Convert.ToDecimal(command_arg));
                    break;
            }
        }
        protected void rptVB_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton imgFile = (ImageButton)e.Item.FindControl("imgFile");
                DataRowView rv = (DataRowView)e.Item.DataItem;
                if (!string.IsNullOrEmpty(rv["LoaiFile"] + ""))
                {
                    string loaifile = rv["LoaiFile"].ToString().ToLower().Replace(".", "");
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
        void DowloadFileDon(Decimal VanBanID)
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
                        lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                    }
                }
                //---------------------
                if ((String.IsNullOrEmpty(oND.ISREAD + "")) || (oND.ISREAD == 0))
                {
                    oND.ISREAD = 1;
                    oND.NGAYDOC = DateTime.Now;
                    dt.SaveChanges();
                    ShowTB_TiepNhanVB();
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
            //lbthongbao.Text = temp;
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDS_VBTongDat();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDS_VBTongDat();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDS_VBTongDat();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDS_VBTongDat();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDS_VBTongDat();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        #endregion

        //---------------------------------
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Personnal/Dsdon.aspx");
        }
    }
}